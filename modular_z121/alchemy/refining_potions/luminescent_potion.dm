// ============================================================================
// 荧光药水 (Luminescent Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY / HOW)：
//   配方：5 级"威仪"气味 + 底料【清水 70 + 魔力药水 30】 → 50 单位荧光药水；技能：学徒(炼金 2 级)。
//   效果：饮下后【身体持续散发柔和的荧光】，且【光芒的强弱与体内残留药量正相关】——
//         药量越多光越亮、照得越远；随着药力被消化，光晕逐拍变暗、收束，直至药力散尽、光芒熄灭。
//   消化速度：每 1 单位 30 秒(见 metabolization_rate 注释)；故 50 单位 ≈ 1500 秒 ≈ 25 分钟的持续发光。
//   产量：50 单位。
//
//   ★为什么选"威仪"气味★：
//     "威仪"是原版【抗火药剂(fire_potion)】配方的 smells_like，且【尚未】被任何自定义精炼配方占用
//     (其余精炼药水已分别用掉 火焰/大地/平静/纯净/雨后泥土/清新空气…… 等气味)。题目要求"取一种未被
//     使用、且等级 5 的自定义药水气味"，"威仪"正好满足。
//     现实可达性：ingredients.dm 中【太阳尘(solardust)】与【地狱尘(infernaldust)】的 major_pot 均指向
//     fire_potion(各 3 点)，二者同投即得 6 ≥ 5，稳定凑齐"5 级威仪"气味，玩家可复现。
//     ★主题契合★：太阳尘被描述为"融入 阿斯特拉塔 光辉之力的尘末，直视会刺痛双眼"——本身就是【光】的
//     意象；以它循来的"威仪"之气精炼出一味【发光药水】，气味与效果浑然一体。
//
//   ★机制落点(为什么这样实现)★：
//     让生物"持续发光"的原生手段是 /mob/living/mob_light(color, range, power, duration)：它在该生物身上
//     挂一个 /obj/effect/dummy/lighting_obj/moblight 光源物件(随生物移动而移动)。当 duration 传 0 时该
//     光源【永不自行到期】，只随我们 qdel 它而消失——正好把"发光的起止"完全交给药剂的代谢生命周期。
//     光源物件是 /atom/movable，可用 set_light_range_power_color(range, power, color) 在【每一代谢拍】按
//     体内残留药量(volume)实时改写其半径与强度，从而实现"光强随药量动态变化"。
//
//   ★"光强与残留药量正相关"如何量化★：
//     取 frac = clamp(volume / 参考药量, 0, 1)(参考药量 = 满瓶 50)，再把光【半径】与【强度】在
//     [最小, 最大] 之间按 frac 线性插值：药量满时最亮最远，药量将尽时收束为一圈微光，恰成正相关。
//
//   框架与精炼锅见 refining_framework.dm。本药【非酒基】(底料无任何乙醇)，故成品为普通 /datum/reagent。
//   全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// 中文：★消化速度常量★——题面要求【每 1 单位 30 秒】。生命循环(SSmobs, wait=20)每 2 秒触发一次
//   on_mob_life，每次移除 metabolization_rate 单位；故"每单位耗时(秒) = 2 ÷ metabolization_rate"。
//   要 30 秒/单位 ⇒ metabolization_rate = 2 ÷ 30 = 1/15 ≈ 0.0667。抽为宏，便于日后统一调参。
#define LUMINESCENT_SECONDS_PER_UNIT 30				// Digest one unit every 30 seconds.

// 中文：★光强量化常量★——"参考药量"是计算亮度所用的满值基准；取满瓶产量 50，使【满瓶=最亮】。
//   WHY: 以固定基准而非"当前最大值"归一化，才能让不同残量对应稳定、可预期的亮度档位。
#define LUMINESCENT_REF_VOLUME 50					// Volume that maps to the brightest glow (a full 50u batch).

// 中文：★光晕半径区间★——药量将尽时收束到 MIN(一圈贴身微光)，药量充盈时扩张到 MAX(照亮周遭)。
//   取值参照原版用法(杜拉汉 mob_light(...,2,2)、破碎之光 mob_light(...,5,5))，落在合理观感区间。
#define LUMINESCENT_MIN_RANGE 1.5					// Smallest glow radius (near-empty).
#define LUMINESCENT_MAX_RANGE 6						// Largest glow radius (full potion).

// 中文：★光照强度区间★——power 越大越亮。药量将尽为 MIN(黯淡)，药量充盈为 MAX(明亮)，与半径同步缩放。
#define LUMINESCENT_MIN_POWER 1						// Dimmest glow power (near-empty).
#define LUMINESCENT_MAX_POWER 4						// Brightest glow power (full potion).

// 中文：★光色★——暖金色的荧光(呼应"太阳尘/阿斯特拉塔光辉"的来历)。以十六进制常量集中定义，便于统一改色。
#define LUMINESCENT_GLOW_COLOR "#ffe6a8"			// Warm golden luminescence (evokes solar radiance).


// ============================================================================
// 成品试剂——荧光药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：发光与药剂"同生共死"——代谢开始点亮(挂永久光源)、每拍按残留药量调节亮度、代谢结束熄灭并清理。
// ============================================================================
/datum/reagent/luminescent_potion
	name = "荧光药水"											// In-game name (Luminescent Potion).
	// 中文：检视/说明文本——点明"以清水与魔力药水循威仪之气精炼、饮后自体发光、光随药量强弱"的功效。
	description = "循威仪之气、以清水与魔力药水精炼而成的、微微流光的琥珀色药液。饮下后周身会漾开一层柔和的荧光，体内药力越足则光芒越盛、照得越远；待药力渐渐消化殆尽，光晕也随之收敛、黯淡，直至彻底熄灭。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid potion.
	color = "#ffe6a8"										// Warm amber-gold (also tints the pot/bottle liquid).
	taste_description = "一缕温暖的、仿佛能照亮喉咙的甜光"			// Taste flavour text.
	// 中文：半透明显示，与其它自定义药水观感统一。
	alpha = 200												// Slight transparency, matching other potions.
	// 中文：★消化速度★= 每单位 30 秒(见上方宏推导)：REAGENTS_METABOLISM(=1) * 2 / 30 = 1/15 单位/拍。
	metabolization_rate = REAGENTS_METABOLISM * 2 / LUMINESCENT_SECONDS_PER_UNIT	// 1/15 u per 2s-tick = 30s per unit.
	// 中文：★每饮者独有的光源句柄★——保存挂在饮者身上的 moblight 光源物件，供每拍调节亮度、结束时清理。
	//   WHY 可用实例变量：试剂在每个持有者(mob)的试剂容器中各是独立实例(同类型药也各自成一份)，
	//   故此变量天然是"每饮者一份"，绝不会串号到别的饮者。
	var/obj/effect/dummy/lighting_obj/moblight/glow_obj = null	// Per-drinker glow light source (null until lit).

// 中文：★核心★ 按当前体内残留药量(volume)点亮/刷新饮者身上的荧光光源，使光强与残留药量正相关。
//   逻辑：frac = clamp(volume/参考量,0,1) → 半径/强度在 [MIN,MAX] 间线性插值；无光源则新建(永久)，有则就地改写。
// WHY 独立成 proc：代谢开始(初次点亮)与代谢每拍(刷新亮度)都要用同一套"按药量算亮度并施加"的逻辑，抽出复用。
/datum/reagent/luminescent_potion/proc/update_glow(mob/living/M)
	// 中文：错误防护——目标缺失/正被删除，或并非 /mob/living(mob_light 仅对 living 有意义)时，直接返回不发光。
	if(!M || QDELETED(M) || !isliving(M))					// No valid living drinker to glow.
		return
	// 中文：把当前残留药量归一化到 [0,1]：药量越多越接近 1(越亮)，越少越接近 0(越暗)。
	var/frac = clamp(volume / LUMINESCENT_REF_VOLUME, 0, 1)	// Remaining-medication fraction (0..1).
	// 中文：按 frac 在 [MIN,MAX] 之间线性插值出本拍应有的光半径与光强(体现"正相关")。
	var/glow_range = LUMINESCENT_MIN_RANGE + frac * (LUMINESCENT_MAX_RANGE - LUMINESCENT_MIN_RANGE)	// Radius ∝ remaining volume.
	var/glow_power = LUMINESCENT_MIN_POWER + frac * (LUMINESCENT_MAX_POWER - LUMINESCENT_MIN_POWER)	// Power ∝ remaining volume.
	// 中文：若尚无光源、光源已被外部清除、或光源竟不在当前饮者身上(极端的试剂转移情形)——重建一个挂在 M 身上的永久光源。
	//   duration 传 0 ⇒ 永不自行到期，只随代谢结束时我们主动 qdel 而消失。
	if(QDELETED(glow_obj) || glow_obj.loc != M)				// Missing / cleaned up / attached to the wrong mob?
		if(!QDELETED(glow_obj))								// A stale light lingering elsewhere?
			qdel(glow_obj)									// Drop it before making a fresh one.
		glow_obj = M.mob_light(LUMINESCENT_GLOW_COLOR, glow_range, glow_power, 0)	// Fresh, permanent glow on M.
		return
	// 中文：光源已在饮者身上——就地把半径/强度/颜色改写为本拍数值(比每拍重建更省、也更平滑)。
	glow_obj.set_light_range_power_color(glow_range, glow_power, LUMINESCENT_GLOW_COLOR)	// Live-update the glow.

// 中文：代谢开始时(每瓶仅触发一次)——校验目标后按当前药量点亮荧光，并给出"初次发光"的纯文字反馈。
/datum/reagent/luminescent_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let the base reagent set up first.
	// 中文：错误防护——目标缺失/正被删除则直接返回，避免对无效对象施加光源而运行时报错。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	// 中文：错误防护——荧光光源仅对 /mob/living 有意义；非 living 无从承载，给出诚实提示后照常代谢、不发光。
	if(!isliving(M))										// Effect only applies to living mobs.
		to_chat(M, span_warning("荧光药水在体内流转，却无处安放它的光。"))	// Honest non-living notice.
		return
	// 中文：按当前(通常为满量)药量点亮荧光。
	update_glow(M)											// Light up according to the starting volume.
	// 中文：错误防护——极少数情况下光源可能未成功创建(如被其它系统阻止)；据此给出诚实反馈而非假装成功。
	if(QDELETED(glow_obj))									// Light somehow failed to spawn?
		to_chat(M, span_warning("一阵微光自体内亮起又骤然熄灭，荧光药水的光华未能凝住。"))	// Honest failure message.
		return
	// 中文：成功反馈——身体亮起柔和荧光(纯文字提示，不影响机制)。
	M.visible_message(span_notice("[M]的身体渐渐透出一层柔和的荧光。"), span_notice("我的身体亮了起来，一层温暖的荧光自皮下漫开。"))	// Onset feedback.

// 中文：每代谢一拍——按【本拍最新的残留药量】刷新荧光亮度(实现"光随药量动态变化")，随后交给父类完成常规代谢。
//   注意：holder 在 on_mob_life 之后才扣减 metabolization_rate，故此处读到的 volume 正是"本拍尚存的药量"。
/datum/reagent/luminescent_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误防护——目标缺失/正被删除 → 跳过发光刷新，仍交给父类收尾以保持代谢推进(否则药剂会卡住不减少)。
	if(!M || QDELETED(M))									// Guard against a missing/deleting mob.
		return ..()
	// 中文：按当前残留药量刷新光晕(药量渐少 → 光渐暗、渐收；被外力移除的光源也在此补回)。
	update_glow(M)											// Re-scale the glow to the current remaining volume.
	return ..()												// Standard metabolism (consumes metabolization_rate, decrements volume).

// 中文：代谢结束(药剂耗尽/被清除)时——熄灭并清理荧光光源，让"发光随药力一同终止"，并给出消退提示。
/datum/reagent/luminescent_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：若光源仍在，则 qdel 之(光源随之从饮者身上消失)，并置空句柄，避免悬垂引用。
	if(!QDELETED(glow_obj))									// A live glow to extinguish?
		qdel(glow_obj)										// Remove the light source (glow goes out).
	glow_obj = null											// Clear the handle to avoid a dangling reference.
	// 中文：仅对有效目标给出文字反馈，避免对无效对象操作。
	if(M && !QDELETED(M))									// Valid target for feedback?
		to_chat(M, span_warning("体内的荧光渐渐黯淡下去，最后一丝光华也悄然熄灭了。"))	// Fade feedback.
	return ..()												// Let the base finish up (final volume cleanup, etc.).


// ============================================================================
// 配方：★按气味等级①★ 5 级"威仪"气味 + 底料(清水 70 + 魔力药水 30) → 荧光药水 50。技能：学徒(炼金 2 级)。
// ----------------------------------------------------------------------------
// 中文：
//   · "威仪"是【抗火药剂(fire_potion)】配方的气味，且未被其它精炼配方占用(题目要求"未使用的 5 级气味")。
//     带此气味、指向 fire_potion 的现成材料有：太阳尘(solardust, major=3)、地狱尘(infernaldust, major=3)、
//     火之精质(firedust, minor=1)。取【太阳尘 + 地狱尘】即 3+3=6 ≥ 5，稳定满足"5 级威仪"。
//   · 底料用【现成试剂】：清水 /datum/reagent/water 70 + 魔力药水 /datum/reagent/medicine/manapot 30。
//     总量 100 ≥ 精炼锅 waterneed(90)，足以煮沸开炼；且二者均为【具体类型】，与 find_refining_formula
//     的 has_reagent 精确(非子类)匹配相符(魔力药水正是原版"魔力灵药"配方的产物 manapot)。
//   · 无任何乙醇 → 成品非酒基，故 output 直接注入普通试剂，不携带 boozepwr。
// ============================================================================
/datum/alch_refining_formula/luminescent
	name = "荧光药水"											// Formula name.
	// 中文：★气味档①★ 要求"威仪"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "威仪"									// Require the "majesty/radiance" scent (fire_potion, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points; solardust 3 + infernaldust 3).
	// 中文：★复合底料★ 清水 70 + 魔力药水 30(均为现成试剂；不含酒 → 成品非酒基)。
	required_base = list(/datum/reagent/water = 70,			// 70 water...
						/datum/reagent/medicine/manapot = 30)	// ...+ 30 Mana Potion.
	// 中文：产物——50 单位荧光药水。
	output_reagents = list(/datum/reagent/luminescent_potion = 50)	// Refined output: 50u Luminescent Potion.
	// 中文：所需技能——学徒(炼金 2 级，SKILL_LEVEL_APPRENTICE == 2)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_APPRENTICE					// Alchemy Level 2 (Apprentice) gate.
	// 中文：成功时的气味词。
	smells_like = "温暖流转的光华气"							// Success scent.


// 中文：清理本文件作用域内的局部宏，避免它们泄漏到全局编译环境、与他处同名定义冲突。
#undef LUMINESCENT_SECONDS_PER_UNIT
#undef LUMINESCENT_REF_VOLUME
#undef LUMINESCENT_MIN_RANGE
#undef LUMINESCENT_MAX_RANGE
#undef LUMINESCENT_MIN_POWER
#undef LUMINESCENT_MAX_POWER
#undef LUMINESCENT_GLOW_COLOR
