// ============================================================================
// 愚人药水 (Idiot Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY / HOW)：
//   配方：5 级"水"气味 + 底料【板油(leaf lard) 60】 → 30 单位愚人药水；技能：熟练(炼金 3 级)。
//   效果：饮下后一段时间内——
//         ① 【智力 -8】(短暂变蠢，clamp 到下限 1，不会低于 1)；
//         ② 【神志混沌】：所有说出的话都变成【无法理解的、蠢笨的呓语】(替换全部语言为"失语症/aphasia"，
//            并叠加"简语 TRAIT_SIMPLESPEECH"，让言语既含糊又幼稚)；
//         ③ 【步履不稳、无法自控身体】：叠加"神志混乱 confused"(随机乱走) + 中度"醉意 drunkenness"
//            (踉跄、眩晕、口齿不清)，仿佛醉汉般控制不住自己的身体。
//   消化速度：每 1 单位 30 秒(见 metabolization_rate 注释)；故 30 单位 ≈ 900 秒 ≈ 15 分钟的持续药效。
//   产量：30 单位。
//
//   ★为什么选"水"气味★：
//     "水"是原版【锐思药剂(int_potion，提升智力)】配方的 smells_like，且【尚未】被任何自定义精炼配方占用
//     (题目要求"取一种未被使用、且等级 5 的自定义药水气味")。用【提升智力】那味药的气味去精炼出一味
//     【令人变蠢】的药水，气味与效果形成绝妙的反讽，主题浑然一体。
//     现实可达性：ingredients.dm 中【水之精质(waterdust)】与【原初精质(runedust)】的 major_pot 均指向
//     int_potion(各 3 点)，二者同投即得 3+3=6 ≥ 5，稳定凑齐"5 级水"气味，玩家可复现，且无需新增任何材料。
//
//   ★机制落点(为什么这样实现)★：
//     所有效果统一由一个自定义【减益状态 /datum/status_effect/debuff/idiot_potion】承载，随药剂的代谢
//     生命周期"同生共死"——代谢开始时施加、每代谢拍刷新其计时(令其贯穿整个消化过程)、代谢结束时解除。
//     · 智力 -8：借用状态基类的 effectedstats 机制。★关键★：本汉化分支里 change_stat() 用 STATKEY_INT
//       ("智力")作为键做 switch 分发；原版 mishap_feeblemind 误用英文字面量 "intelligence" 作为键，在本
//       分支里【匹配不到、静默失效】。故这里必须用 STATKEY_INT，才能真正把智力降下来(且基类会自动 clamp
//       到 [1,20]、并在移除时精确还原)。
//     · 蠢笨呓语：复刻 mishap_feeblemind 的做法——保存旧语言、清空全部语言、只授予"失语症(aphasia)"，
//       使其开口即是旁人无法听懂的胡言乱语；移除时精确还原原有语言。再叠加 TRAIT_SIMPLESPEECH(迟钝简语)。
//     · 醉步/失控：复刻 mishap_arcane_drunkenness / mishap_arcane_high——抬高 drunkenness 与 slurring，
//       并置入 confused(令移动随机化)。drunkenness 特意维持在 45(≥41 触发踉跄/眩晕/口齿不清，却 <51，
//       从而【不会】造成中毒伤害/呕吐——见 carbon/life.dm 的 handle_alcohol 阈值)，效果强烈但不致命。
//
//   框架与精炼锅见 refining_framework.dm。本药【非酒基】(底料为板油这类油脂、无任何乙醇)，故成品为普通
//   /datum/reagent，不携带 boozepwr。全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// 中文：★消化速度常量★——题面要求【每 1 单位 30 秒】。生命循环(SSmobs, wait=20)每 2 秒触发一次
//   on_mob_life，每次移除 metabolization_rate 单位；故"每单位耗时(秒) = 2 ÷ metabolization_rate"。
//   要 30 秒/单位 ⇒ metabolization_rate = 2 ÷ 30 = 1/15 ≈ 0.0667。抽为宏，便于日后统一调参。
#define IDIOT_POTION_SECONDS_PER_UNIT 30			// Digest one unit every 30 seconds.

// 中文：★智力惩罚常量★——题面要求"智力 -8"。抽为宏，逻辑与文案共用一个真值来源，避免改动时不一致。
#define IDIOT_POTION_INT_PENALTY 8					// Intelligence reduced by 8 while the potion lasts.

// 中文：★神志混乱下限★——confused 会令移动方向随机化(living_defines: "Makes the mob move in random
//   directions")，从而表现为"步履不稳、控制不住身体"。confused 会随时间自然衰减，故每拍把它顶回此下限。
//   取 15：明显踉跄乱走，但并非每步都乱，仍留一点可控性，避免 15 分钟完全无法移动过于严苛。
#define IDIOT_POTION_CONFUSED_FLOOR 15				// Keep confusion (random-walk) topped up to this while active.

// 中文：★醉意下限★——drunkenness 的踉跄/眩晕/口齿不清效果。特意取 45：≥41 触发 confused/Dizzy(眩晕)，
//   却 <51(那才开始中毒伤害与呕吐)，故效果强烈但绝不致命(阈值见 carbon/life.dm handle_alcohol)。
#define IDIOT_POTION_DRUNK_FLOOR 45					// Keep drunkenness topped up here: staggering/dizzy but below the 51 toxin threshold.

// 中文：★含糊口齿下限★——slurring 令说话含糊。取 20，配合失语症，把"蠢笨呓语"表现得更足。
#define IDIOT_POTION_SLUR_FLOOR 20					// Keep slurred speech topped up to this while active.


// ============================================================================
// 1) 减益状态：愚人药水的效果本体(智力 -8 + 蠢笨呓语 + 醉步失控)。
// 中文：继承 /datum/status_effect/debuff(其 status_type 已是 STATUS_EFFECT_REFRESH——重复施加只会刷新
//   计时、不会重复跑 on_apply，故可安全地每代谢拍施加一次以维持药效)。
// ============================================================================

// 中文：状态生效期间显示在屏幕上的提示图标(复用原版"神志被控"图标，无需新增美术)。
/atom/movable/screen/alert/status_effect/idiot_potion
	name = "愚钝"											// Alert title.
	desc = "呜哇……呃啊……脑子……好像……转不动了……"		// Flavour: drooling idiocy.
	icon_state = "mind_control"							// Reuse the existing mind-addled alert sprite.

/datum/status_effect/debuff/idiot_potion
	id = "idiot_potion"									// Unique id (drives the by-id refresh path).
	// 中文：★安全网计时★——正常情况下由药剂每 2 秒刷新一次；万一药剂被异常清除而未走 on_mob_end_metabolize，
	//   本状态也会在 1 分钟后自行到期解除，绝不会永久卡住玩家。
	duration = 1 MINUTES								// Safety-net duration; refreshed every 2s while digesting.
	status_type = STATUS_EFFECT_REFRESH					// Re-applying only refreshes the timer (never re-runs on_apply).
	// 中文：★智力 -8★——★必须用 STATKEY_INT("智力")作为键★，否则 change_stat 的 switch 匹配不到而静默失效
	//   (原版 mishap_feeblemind 用英文 "intelligence" 在本汉化分支就是失效的)。基类 on_apply/on_remove 会
	//   自动施加/还原，并把结果 clamp 在 [1,20](即最多降到 1，不会到 0 或负)。
	effectedstats = list(STATKEY_INT = -IDIOT_POTION_INT_PENALTY)	// -8 Intelligence (auto-clamped, auto-restored by base).
	alert_type = /atom/movable/screen/alert/status_effect/idiot_potion	// The on-screen indicator above.
	// 中文：保存施加前的语言持有者与其副本，用于结束时精确还原可听懂的言语。
	var/datum/language_holder/owner_language_holder = null	// The owner's live language holder.
	var/datum/language_holder/old_languages = null			// A saved copy of the pre-debuff languages.
	// 中文：记录"我们实际叠加了多少醉意"，以便解除时精确扣回、不误伤玩家原本已有的醉意。
	var/applied_drunk = 0								// How much drunkenness THIS effect actually added.

// 中文：状态施加(每次"新建"实例时仅触发一次)——在基类施加智力惩罚后，附加"蠢笨呓语 + 醉步失控"。
/datum/status_effect/debuff/idiot_potion/on_apply()
	. = ..()											// Base applies effectedstats (INT -8) & builds the alert; returns TRUE/FALSE.
	// 中文：错误处理——基类拒绝(返回 FALSE)或宿主非 /mob/living(无法承载言语/醉意)时，不再叠加后续效果。
	if(!. || !isliving(owner))							// Base rejected, or owner can't carry speech/drunk effects.
		return .
	// ---- ② 蠢笨呓语：保存并清空全部语言，只留"失语症"，使其开口即是无人能懂的胡言乱语 ----
	owner_language_holder = owner.get_language_holder()	// Grab the live language holder.
	if(owner_language_holder)							// Guard: only if a holder exists.
		old_languages = owner_language_holder.copy()	// Snapshot the current languages for later restore.
		owner_language_holder.remove_all_languages()	// Strip every language...
		owner_language_holder.grant_language(/datum/language/aphasia)	// ...leaving only garbled aphasia.
	// 中文：叠加"简语"特质——即便被听懂的零星词也变得迟钝幼稚，进一步坐实"蠢话"。
	ADD_TRAIT(owner, TRAIT_SIMPLESPEECH, id)			// Dumbed-down, simplified speech on top of the garble.
	// ---- ③ 步履不稳、无法自控：混乱(随机乱走) + 含糊口齿 ----
	owner.confused = max(owner.confused, IDIOT_POTION_CONFUSED_FLOOR)	// Random-direction stumbling.
	owner.slurring = max(owner.slurring, IDIOT_POTION_SLUR_FLOOR)		// Slurred, mush-mouthed speech.
	// 中文：醉意仅对 /mob/living/carbon 有意义(drunkenness 定义在 carbon)。用"顶到下限"而非无脑 +=，
	//   避免把本就醉着的人推过 51 而误触中毒；记录实际叠加量以便结束时精确扣回。
	if(iscarbon(owner))									// Drunkenness only exists on carbon mobs.
		var/mob/living/carbon/C = owner					// Typed access.
		applied_drunk = max(IDIOT_POTION_DRUNK_FLOOR - C.drunkenness, 0)	// Only top-up the gap (never overshoot into toxic range).
		C.drunkenness += applied_drunk					// Raise drunkenness to the (non-lethal) floor.
	// 中文：施加成功的文字反馈(纯提示，不影响机制)。
	owner.visible_message(span_warning("[owner]的眼神骤然涣散，嘴角开始不受控制地流下口水。"), \
						span_userdanger("我的脑袋里像塞满了浆糊，思绪全乱了，身体也不听使唤了……"))	// Onset feedback.
	return .

// 中文：每一状态拍——把会自然衰减的 confused / slurring / drunkenness 顶回下限，保证整个药效期间持续"变蠢"；
//   并偶尔来点发呆/流口水/傻笑的小动作强化观感。
/datum/status_effect/debuff/idiot_potion/tick()
	..()												// Let the base do its per-tick bookkeeping.
	// 中文：错误处理——宿主已失效则直接返回，避免对无效对象操作而运行时报错。
	if(QDELETED(owner) || !isliving(owner))				// Guard against a missing/invalid owner.
		return
	owner.confused = max(owner.confused, IDIOT_POTION_CONFUSED_FLOOR)	// Re-assert random-walk (it decays on its own).
	owner.slurring = max(owner.slurring, IDIOT_POTION_SLUR_FLOOR)		// Re-assert slurred speech.
	if(iscarbon(owner))									// Re-assert drunkenness floor (drunkenness decays each life tick).
		var/mob/living/carbon/C = owner
		C.drunkenness = max(C.drunkenness, IDIOT_POTION_DRUNK_FLOOR)		// Keep staggering, stay below the toxic 51 line.
	// 中文：低概率的傻气小动作，纯表演性质。
	if(prob(8))											// Occasional idiot flavour.
		owner.emote(pick("drools", "stares blankly", "giggle"))

// 中文：状态解除(到期或被主动移除时仅触发一次)——精确还原智力、语言、特质与我们叠加的那部分醉意。
/datum/status_effect/debuff/idiot_potion/on_remove()
	..()												// Base reverses effectedstats (restores INT) & clears the alert first.
	// ---- 还原语言：去掉失语症、拷回旧语言，让言语重新可被听懂 ----
	if(owner_language_holder)							// Only if we swapped languages on apply.
		owner_language_holder.remove_language(/datum/language/aphasia)	// Drop the garble.
		if(old_languages)								// Restore the snapshot taken at apply time.
			owner_language_holder.copy_known_languages_from(old_languages)
	// ---- 去掉"简语"特质(用 id 作为来源，精确移除本效果加的那一份) ----
	REMOVE_TRAIT(owner, TRAIT_SIMPLESPEECH, id)			// Remove our simplified-speech source.
	// ---- 醒酒：只扣回"我们叠加的那部分"醉意，避免误伤玩家原有醉意；若清零则一并撤下醉酒 buff ----
	if(applied_drunk && iscarbon(owner))				// Did we add any drunkenness?
		var/mob/living/carbon/C = owner
		C.drunkenness = max(C.drunkenness - applied_drunk, 0)	// Subtract exactly what we added.
		if(C.drunkenness <= 0)							// Fully sober now?
			C.remove_status_effect(/datum/status_effect/buff/drunk)	// Clear the lingering drunk buff too.


// ============================================================================
// 2) 成品试剂——愚人药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：效果与药剂"同生共死"——代谢开始施加减益、每拍刷新其计时、代谢结束解除。
// ============================================================================
/datum/reagent/idiot_potion
	name = "愚人药水"										// In-game name (Idiot Potion).
	// 中文：检视/说明文本——点明"以板油循'水'之气(锐思药剂的气味)反其道精炼、饮后短时变蠢、胡言乱语、步履蹒跚"。
	description = "一瓶循'水'之气(本是锐思药剂的气息)、却以板油反其道精炼而成的浑浊灰绿药液，气味呆滞而油腻。饮下后思绪会像被泥浆糊住一般迟钝下来，智力大减、口中尽是无人能懂的蠢笨呓语，四肢也踉踉跄跄、仿佛再难听从自己的意志。"	// Flavour + hint.
	reagent_state = LIQUID								// Drinkable liquid potion.
	color = "#8a9a5b"									// Murky bog-green (echoes int_potion's "bog water" motif).
	taste_description = "一口下去满是沼泽泥水般的滞涩腥浊"	// Taste flavour text (bog-water dullness).
	// 中文：半透明显示，与其它自定义药水观感统一。
	alpha = 200											// Slight transparency, matching other potions.
	// 中文：★消化速度★= 每单位 30 秒(见上方宏推导)：REAGENTS_METABOLISM(=1) * 2 / 30 = 1/15 单位/拍。
	metabolization_rate = REAGENTS_METABOLISM * 2 / IDIOT_POTION_SECONDS_PER_UNIT	// 1/15 u per 2s-tick = 30s per unit.

// 中文：代谢开始时(每瓶仅触发一次)——校验目标后施加"愚人"减益，并给出"开始变蠢"的文字反馈。
/datum/reagent/idiot_potion/on_mob_metabolize(mob/living/M)
	. = ..()											// Let the base reagent set up first.
	// 中文：错误处理——目标缺失/正被删除则直接返回，避免对无效对象施加状态而运行时报错。
	if(!M || QDELETED(M))								// No valid drinker.
		return
	// 中文：错误处理——减益仅对 /mob/living 有意义；非 living 无从承载，给出诚实提示后照常代谢、不施加效果。
	if(!isliving(M))									// Effect only applies to living mobs.
		to_chat(M, span_warning("愚人药水在体内空流转，却找不到可供搅乱的神志。"))	// Honest non-living notice.
		return
	// 中文：施加"愚人"减益(智力 -8 + 蠢笨呓语 + 醉步失控)。文字反馈由状态的 on_apply 负责。
	M.apply_status_effect(/datum/status_effect/debuff/idiot_potion)	// Apply the debuff (fresh instance).
	// 中文：错误处理——极少数情况下状态可能未成功建立；据此给出诚实反馈而非假装成功。
	if(!M.has_status_effect(/datum/status_effect/debuff/idiot_potion))	// Debuff somehow failed to attach?
		to_chat(M, span_warning("一阵恍惚掠过脑海，却又很快散去，愚人药水未能真正搅乱你的神志。"))	// Honest failure message.

// 中文：每代谢一拍——刷新(REFRESH)减益的计时，使其贯穿整个消化过程(30 单位≈15 分钟)，随后交给父类完成常规代谢。
//   apply_status_effect 对已存在的 REFRESH 型状态只会重置计时、不会重复施加效果，故可安全地每拍调用。
/datum/reagent/idiot_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正被删除 → 跳过刷新，仍交给父类收尾以保持代谢推进(否则药剂会卡住不减少)。
	if(!M || QDELETED(M))								// Guard against a missing/deleting mob.
		return ..()
	// 中文：仅对有效 living 刷新；既能在初次未挂上时补挂，也能维持已挂上的计时。
	if(isliving(M))										// Living target?
		M.apply_status_effect(/datum/status_effect/debuff/idiot_potion)	// Create-or-refresh (REFRESH just resets the timer).
	return ..()											// Standard metabolism (consumes metabolization_rate, decrements volume).

// 中文：代谢结束(药剂耗尽/被清除)时——解除"愚人"减益，让神志随药力散尽而恢复，并给出"清醒过来"的提示。
/datum/reagent/idiot_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：仅对有效目标解除并反馈(减益的 on_remove 会精确还原智力/语言/特质/醉意)。
	if(M && !QDELETED(M))								// Valid target?
		M.remove_status_effect(/datum/status_effect/debuff/idiot_potion)	// Lift the debuff (restores everything).
		to_chat(M, span_notice("脑中的浆糊渐渐化开，思绪与身体重新回到了自己的掌控之中。"))	// Recovery feedback.
	return ..()											// Let the base finish up (final volume cleanup, etc.).


// ============================================================================
// 3) 精炼配方：★按气味等级(气味档①)★ —— 5 级"水"气味 + 底料(板油 60) → 愚人药水 30。技能：熟练(炼金 3 级)。
// ----------------------------------------------------------------------------
// 中文：
//   · "水"是【锐思药剂(int_potion，提升智力)】配方的气味，且未被其它精炼配方占用(题目要求"未使用的 5 级气味")。
//     带此气味、指向 int_potion 的现成材料有：水之精质(waterdust, major=3)、原初精质(runedust, major=3)、
//     太阳尘(solardust, med=2)、艾草粉之类(minor=1)…… 取【水之精质 + 原初精质】即 3+3=6 ≥ 5，稳定满足"5 级水"。
//   · 底料用【现成试剂】：板油(leaf lard) /datum/reagent/consumable/oil/tallow 60。板油是油脂、非乙醇，
//     故成品【非酒基】，output 直接注入普通试剂、不携带 boozepwr。
//   · ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型 /datum/reagent/consumable/oil/tallow。
//   · ★煮沸阈值★：精炼锅默认 waterneed=90，而本配方底料仅 60 单位；为此已在 refining_framework.dm 把
//     /obj/machinery/light/rogue/cauldron/refining 的 waterneed 下调为 60(详见该文件注释)——此改动只降低
//     "起沸所需液量"下限，对既有≥90 底料的配方无害(下限而非上限)，从而让 60 单位底料的本药也能正常熬制。
// ============================================================================
/datum/alch_refining_formula/idiot_potion
	name = "愚人药水"										// Formula name.
	// 中文：★气味档①★ 要求"水"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "水"									// Require the "water" scent (int_potion's smell, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points; waterdust 3 + runedust 3 = 6).
	// 中文：★单一底料★ 板油(leaf lard) 60(现成试剂；油脂非酒 → 成品非酒基)。
	required_base = list(/datum/reagent/consumable/oil/tallow = 60)	// Base: 60 leaf lard (tallow).
	// 中文：产物——30 单位愚人药水(单批产出 30)。
	output_reagents = list(/datum/reagent/idiot_potion = 30)	// Refined output: 30u Idiot Potion.
	// 中文：所需技能——熟练(炼金 3 级，SKILL_LEVEL_JOURNEYMAN == 3)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_JOURNEYMAN					// Alchemy Level 3 (Journeyman) gate.
	// 中文：成功时的气味词。
	smells_like = "呆滞浑浊的浊气"							// Success scent.


// 中文：清理本文件作用域内的局部宏，避免它们泄漏到全局编译环境、与他处同名定义冲突。
#undef IDIOT_POTION_SECONDS_PER_UNIT
#undef IDIOT_POTION_INT_PENALTY
#undef IDIOT_POTION_CONFUSED_FLOOR
#undef IDIOT_POTION_DRUNK_FLOOR
#undef IDIOT_POTION_SLUR_FLOOR
