// ============================================================================
// 丰盈药水 (Enlargement Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY/HOW)：
//   配方：5 级"甜浆果"气味 + 底料【乳汁 30 + 清水 30】 → 30 单位丰盈药水；技能：学徒。
//      气味来源：symphitum/urtica/valeriana 等常见草药，2-3 株即可凑满。
//   效果：药力持续期间（约 5 分钟），饮者的性器官（阴茎、睾丸、乳房）直接增至最大尺寸。
//         药效期间伴有周期性"胀满感"文字提示。药效结束后器官恢复原始尺寸。
//
//   机制落点：
//     · 直接修改器官的 size 变量(breast_size / penis_size / ball_size)，仿 admin curse 的成熟模式。
//     · 代谢开始：记录原始尺寸 → 直接拉满到 MAX → update_body()
//     · 代谢期间：每隔约 16 秒轮换提示"胀大/饱胀感"文案
//     · 代谢结束：恢复原始尺寸 → update_body()
//
//   ★合意前提★：仅对【开启了 ERP(prefs.sexable) 的人类】生效；否则清空体积无效果。
//
//   全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================

// 消化速度——约 5 分钟(300 秒)，30 单位 @10s/u。
#define ENLARGEMENT_POTION_SECONDS_PER_UNIT 10

// 中文：成品试剂——丰盈药水。临时增大性器官尺寸。
/datum/reagent/enlargement_potion
	name = "丰盈药水"
	description = "循甜浆果的芬芳、以乳汁与清水精炼而成的淡粉色稠液。饮下后一股温热蔓延至胸腹与股间，沉睡的器官在这股暖流的滋养下渐渐苏醒、胀大……"
	reagent_state = LIQUID
	color = "#f2c4d8"										// Soft pink — suggestive of blooming.
	taste_description = "甜腻顺滑，带着一缕温热的奶香"
	metabolization_rate = REAGENTS_METABOLISM * 2 / ENLARGEMENT_POTION_SECONDS_PER_UNIT
	alpha = 200
	var/active = FALSE
	var/flavor_tick = 0
	var/flavor_cycle = -1
	// 中文：存储原始尺寸以便药效结束后恢复。
	var/old_penis_size = null
	var/old_ball_size = null
	var/old_breast_size = null
	// 中文：实际生效的增幅（若某器官已达上限则跳过）。
	var/penis_gained = 0
	var/ball_gained = 0
	var/breast_gained = 0

// 中文：代谢开始——记录原始尺寸并增大。
/datum/reagent/enlargement_potion/on_mob_metabolize(mob/living/carbon/M)
	..()
	if(!M || QDELETED(M))
		return
	if(!ishuman(M) || !M.client?.prefs?.sexable)
		volume = 0
		return
	var/mob/living/carbon/human/H = M

	// 中文：获取所有性器官并记录原始尺寸。
	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!penis && !testicles && !breasts)
		to_chat(H, span_warning("一股暖流涌入下腹，却似乎没有找到可以滋养的地方……"))
		volume = 0
		return

	// 中文：储存原始值。
	if(penis)
		old_penis_size = penis.penis_size
	if(testicles)
		old_ball_size = testicles.ball_size
	if(breasts)
		old_breast_size = breasts.breast_size

	// 中文：各器官直接拉满到最大尺寸。
	if(penis)
		penis_gained = MAX_PENIS_SIZE - penis.penis_size
		penis.penis_size = MAX_PENIS_SIZE
	if(testicles)
		ball_gained = MAX_TESTICLES_SIZE - testicles.ball_size
		testicles.ball_size = MAX_TESTICLES_SIZE
	if(breasts)
		breast_gained = MAX_BREASTS_SIZE - breasts.breast_size
		breasts.breast_size = MAX_BREASTS_SIZE
	// 中文：更新乳汁容量以匹配新的乳房尺寸。
	if(breasts && breast_gained > 0)
		breasts.milk_max = max(75, breasts.breast_size * 100)

	H.update_body()
	active = TRUE

	// 中文：起效文案——针对不同器官变化给出描述。
	var/list/effects = list()
	if(penis_gained > 0)
		effects += "胯下的软肉在滚烫的热流中不受控制地膨胀、延展——它正变得比以往更加粗壮"
	if(ball_gained > 0)
		effects += "囊袋沉沉地坠了下去，里面的分量比之前饱胀了许多"
	if(breast_gained > 0)
		effects += "胸前一阵酸胀——它们在暖流的浸润下如同再度发育般缓缓隆起，衣襟被撑得紧绷了起来"
	if(effects.len > 0)
		to_chat(H, "<span class='aphrodisiac'>暖流自小腹炸开，沿着血管奔涌向全身……[english_list(effects, "；")]。</span>")

// 中文：每代谢一拍——轮换"胀满感"提示文案。
/datum/reagent/enlargement_potion/on_mob_life(mob/living/carbon/M)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/H = M
	if(!H.client?.prefs?.sexable)
		volume = 0
		return ..()

	flavor_tick++
	if(flavor_tick >= 8)
		flavor_tick = 0
		flavor_cycle = (flavor_cycle + 1) % 7
		switch(flavor_cycle)
			if(0)
				to_chat(H, "<span class='love'>低头瞥了一眼自己——那股被药水撑满的感觉依然鲜明，每一寸都比以往更加饱满。</span>")
			if(1)
				to_chat(H, "<span class='love'>布料下的紧绷感提醒着身体的变化：它们还在——比记忆中更大、更沉。</span>")
			if(2)
				if(breast_gained > 0)
					to_chat(H, "<span class='love'>走动的每一步都带着胸前微微的晃动，那重量陌生而令人脸红。</span>")
				else
					to_chat(H, "<span class='love'>股间沉甸甸的分量让每一步都带着异样的存在感。</span>")
			if(3)
				to_chat(H, "<span class='love'>指尖无意间碰到自己，触感比往常更加丰腴——一种奇异的满足感涌上心头。</span>")
			if(4)
				to_chat(H, "<span class='love'>皮肤下仿佛还流淌着那股温热的药力，催促着身体再长大一点、再饱满一点……</span>")
			if(5)
				to_chat(H, "<span class='love'>忍不住低头看了自己一眼——这副被药水充盈过的身体，确实比平时更加诱人了。</span>")
			if(6)
				to_chat(H, "<span class='love'>一丝隐约的胀痛夹杂着满足——这就是丰盈的代价，甜美的负担。</span>")
	return ..()

// 中文：代谢结束——恢复原始尺寸。
/datum/reagent/enlargement_potion/on_mob_end_metabolize(mob/living/carbon/M)
	if(!active || !ishuman(M) || QDELETED(M))
		active = FALSE
		return ..()
	var/mob/living/carbon/human/H = M

	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)

	if(penis && !isnull(old_penis_size))
		penis.penis_size = old_penis_size
	if(testicles && !isnull(old_ball_size))
		testicles.ball_size = old_ball_size
	if(breasts && !isnull(old_breast_size))
		breasts.breast_size = old_breast_size
		breasts.milk_max = max(75, breasts.breast_size * 100)

	H.update_body()

	to_chat(H, span_notice("那股暖流终于散去了。身体正缓缓缩回原本的模样——刚才的丰盈如同一场短暂而甜美的梦。"))
	active = FALSE
	..()

// ============================================================================
// 配方：★按气味等级①★ 5 级"甜浆果" + 底料(乳汁 30 + 清水 30) → 丰盈药水 30。技能：学徒。
// ----------------------------------------------------------------------------
//   · "甜浆果" 是原版【生命灵药】(health_potion)的 smells_like。
//     气味来源（纯草药，简单易得）：
//       symphitum (major=3pt) + taraxacum (med=2pt) = 5pt 刚好达标。
//       也可以 urtica(major=3) + 任意带 health_potion minor(1pt) 的草药。
//   · 底料：乳汁 30 + 清水 30 = 60（恰好达到精炼锅起沸下限）。
//   · 与【温酒】(warm_wine，同气味但底料为葡萄酒+水)以液体底料区分。
// ============================================================================
/datum/alch_refining_formula/enlargement
	name = "丰盈药水"
	required_scent = "甜浆果"
	required_scent_points = 5								// 1 symphitum(3) + 1 taraxacum(2) = 5.
	required_base = list(/datum/reagent/consumable/milk = 30,
						/datum/reagent/water = 30)			// 60 total = waterneed minimum.
	output_reagents = list(/datum/reagent/enlargement_potion = 30)
	skill_required = SKILL_LEVEL_APPRENTICE					// 学徒即可——这才是"简单"的精髓。
	smells_like = "饱胀的花蜜香"

#undef ENLARGEMENT_POTION_SECONDS_PER_UNIT
