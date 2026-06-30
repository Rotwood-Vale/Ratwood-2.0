// ============================================================================
// 变性药水 (Gender-Swap Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"浆果派"气味 + 情欲液(精液)100；技能：专家。
// 效果：饮用并消化满 5 单位后，触发一次彻底性别转换；并【弹窗让本人选择】新性器官的大小/样式等。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——变性药水。饮下并【代谢满 5 单位】后，触发一次彻底的性别转换：翻转 gender、移除原性别
//       的性器官，随后【弹窗让本人选择】新性器官的【大小/样式】等(详见 build_new_genitals)，再植入并刷新外观。
//       属角色变身机制，仅对人类生效。弹窗为异步进行，不阻塞生命循环；无客户端(NPC)则按默认值生成。
//   涉及原版接口：H.gender、getorganslot(ORGAN_SLOT_*)、器官 Insert()/Remove()、regenerate_icons()、
//       原版尺寸/样式 #define(MAX_PENIS_SIZE/MAX_BREASTS_SIZE/PENIS_TYPE_* 等)、tgui_input_number/list。
/datum/reagent/gender_swap_potion
	name = "变性药水"										// In-game name (Gender-Swap Potion).
	description = "循浆果派的气味、以情欲液为底精炼的乳色药水。饮下足量并待其消化后，会从内到外彻底改写饮用者的性别——容貌乃至性器官都将随之转变。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#f0e6e8"										// Pale milky.
	taste_description = "暧昧的甜腥"							// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// Standard metabolism.
	// 中文：累计已代谢(消化)的量；达到阈值才触发，确保"至少摄入并消化 5 单位"。
	var/digested = 0										// Total amount metabolized so far.
	// 中文：仅转换一次的标记。
	var/swapped = FALSE										// Ensures the transformation happens once.

// 中文：每代谢一拍累加已消化量；累计 >= 5 单位且尚未转换时，执行一次性别转换。
/datum/reagent/gender_swap_potion/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	// 中文：把本拍代谢掉的量累加进"已消化"计数(近似按代谢速率累加)。
	digested += metabolization_rate							// Accumulate digested amount.
	// 中文：消化满 5 单位且未转换过 → 执行转换(只触发一次)。
	if(!swapped && digested >= 5)							// Threshold reached, once only.
		swapped = TRUE										// Latch so it never repeats.
		do_gender_swap(M)									// Perform the transformation.
	return ..()

// 中文：执行性别转换——翻转 gender、移除原性别的性器官，随后由【本人弹窗定制】后植入新性器官并刷新外观。仅对人类有效。
/datum/reagent/gender_swap_potion/proc/do_gender_swap(mob/living/carbon/human/H)
	// 中文：非人类(动物/构造体等)没有这套性器官系统，直接跳过。
	if(!ishuman(H))											// Only humans have these organs.
		return
	// 中文：当前为男性 → 变女；否则 → 变男。
	var/becoming_female = (H.gender == MALE)				// Direction of the swap.
	// 中文：翻转性别(影响声音/称谓/身体外观判定)。
	H.gender = becoming_female ? FEMALE : MALE				// Flip the gender var.
	// 中文：先移除"原性别"的性器官；新器官稍后据玩家选择植入。
	if(becoming_female)
		swap_remove_organ(H, ORGAN_SLOT_PENIS)				// Remove penis.
		swap_remove_organ(H, ORGAN_SLOT_TESTICLES)			// Remove testicles.
	else
		swap_remove_organ(H, ORGAN_SLOT_VAGINA)				// Remove vagina.
		swap_remove_organ(H, ORGAN_SLOT_BREASTS)			// Remove breasts.
	// 中文：先就当前状态刷新一次外观，并给出转变反馈。
	H.regenerate_icons()									// Rebuild the body sprite.
	H.update_body_parts(TRUE)								// Refresh body-part overlays.
	to_chat(H, span_userdanger("一阵深入骨髓的剧变自体内涌起……我的身体被彻底改写了。"))	// Self message.
	H.visible_message(span_warning("[H]的身形在眼前发生了惊人的转变！"))	// Onlookers' message.
	// 中文：植入新性器官——有客户端者【弹窗让本人选择大小/样式等】，并异步进行(避免阻塞生命循环)；
	//       无客户端(NPC)则按默认值同步构建。
	if(H.client)											// A player who can answer prompts.
		INVOKE_ASYNC(src, PROC_REF(build_new_genitals), H, becoming_female)	// Prompt + build, off the Life loop.
	else
		build_new_genitals(H, becoming_female)				// NPC: defaults, synchronous.

// 中文：构建并植入新性器官。有客户端则弹窗让本人选择(大小/样式/生育力等)，否则用默认值；完成后刷新外观。
//   ——弹窗使用 tgui_input_list/tgui_input_number/alert；尺寸/样式取值范围来自原版 DNA.dm 的相关 #define。
/datum/reagent/gender_swap_potion/proc/build_new_genitals(mob/living/carbon/human/H, becoming_female)
	if(!ishuman(H))											// Safety: still human?
		return
	if(becoming_female)
		// 中文：女性 → 乳房 + 阴道。可选：胸部大小(1-12)、是否具备生育能力。
		var/breast_size = DEFAULT_BREASTS_SIZE				// Default breast size.
		var/fertile = TRUE									// Default: fertile.
		if(H.client)										// Ask the transformed person.
			var/chosen_bsize = tgui_input_number(H, "选择胸部大小（1 - [MAX_BREASTS_SIZE]）", "变性 · 身体定制", DEFAULT_BREASTS_SIZE, MAX_BREASTS_SIZE, 1)
			if(!isnull(chosen_bsize))						// Apply if they answered.
				breast_size = clamp(round(chosen_bsize), 1, MAX_BREASTS_SIZE)
			fertile = (alert(H, "新的身体是否具备生育能力？", "变性 · 身体定制", "是", "否") != "否")	// Fertility option.
		var/obj/item/organ/breasts/new_breasts = new()		// New breasts.
		new_breasts.breast_size = breast_size				// Apply chosen size.
		new_breasts.Insert(H)								// Implant.
		var/obj/item/organ/vagina/new_vagina = new()		// New vagina.
		new_vagina.fertility = fertile						// Apply chosen fertility.
		new_vagina.Insert(H)								// Implant.
	else
		// 中文：男性 → 阴茎 + 睾丸。可选：阴茎样式(对应原版各阴茎子类型)、阴茎大小(1-3)、睾丸大小(1-3)。
		var/penis_path = /obj/item/organ/penis				// Default: plain penis.
		var/penis_size = DEFAULT_PENIS_SIZE					// Default penis size.
		var/ball_size = DEFAULT_TESTICLES_SIZE				// Default testicle size.
		if(H.client)										// Ask the transformed person.
			// 中文：阴茎样式 → 各原版子类型(其已内置对应的 penis_type / sheath_type)。
			var/list/penis_styles = list(
				"普通" = /obj/item/organ/penis,				// Plain.
				"犬结" = /obj/item/organ/penis/knotted,		// Knotted.
				"马势" = /obj/item/organ/penis/equine,		// Equine.
				"锥形" = /obj/item/organ/penis/tapered,		// Tapered.
				"倒刺" = /obj/item/organ/penis/barbed,		// Barbed.
				"触手" = /obj/item/organ/penis/tentacle,		// Tentacle.
			)
			var/style_choice = tgui_input_list(H, "选择阴茎样式", "变性 · 身体定制", penis_styles)
			if(style_choice && penis_styles[style_choice])	// Apply chosen style.
				penis_path = penis_styles[style_choice]
			var/chosen_psize = tgui_input_number(H, "选择阴茎大小（[MIN_PENIS_SIZE] - [MAX_PENIS_SIZE]）", "变性 · 身体定制", DEFAULT_PENIS_SIZE, MAX_PENIS_SIZE, MIN_PENIS_SIZE)
			if(!isnull(chosen_psize))
				penis_size = clamp(round(chosen_psize), MIN_PENIS_SIZE, MAX_PENIS_SIZE)
			var/chosen_tsize = tgui_input_number(H, "选择睾丸大小（1 - [MAX_TESTICLES_SIZE]）", "变性 · 身体定制", DEFAULT_TESTICLES_SIZE, MAX_TESTICLES_SIZE, 1)
			if(!isnull(chosen_tsize))
				ball_size = clamp(round(chosen_tsize), 1, MAX_TESTICLES_SIZE)
		var/obj/item/organ/penis/new_penis = new penis_path()	// New penis of the chosen style.
		new_penis.penis_size = penis_size					// Apply chosen size.
		new_penis.Insert(H)									// Implant.
		var/obj/item/organ/testicles/new_testes = new()		// New testicles.
		new_testes.ball_size = ball_size					// Apply chosen size.
		new_testes.Insert(H)								// Implant.
	// 中文：植入完成后刷新外观，让新器官与体型生效。
	H.regenerate_icons()									// Rebuild the body sprite.
	H.update_body_parts(TRUE)								// Refresh body-part overlays.
	to_chat(H, span_notice("我的新身体已经定型。"))			// Done.

// 中文：移除指定槽位的器官(若有)并销毁。
/datum/reagent/gender_swap_potion/proc/swap_remove_organ(mob/living/carbon/human/H, slot)
	var/obj/item/organ/old_organ = H.getorganslot(slot)		// The organ currently in that slot.
	if(old_organ)											// Present?
		old_organ.Remove(H)									// Detach from the body.
		qdel(old_organ)										// Destroy it.

// 中文：示例配方——★按气味等级★：要求【5 级"浆果派"气味】+ 单一底料(情欲液 100) → 变性药水。
//       "浆果派"是【强效生命灵药】配方的气味；带它的现成材料(指向强效生命灵药)有：内脏[major,3]、金盏花[major,3] 等；
//       如 内脏(3)+金盏花(3)=6 即满足。
//       底料：情欲液(精液)100——即"性活动产生的体液"(现成试剂 /datum/reagent/erpjuice/cum，无酒 → 成品非酒基)。
/datum/alch_refining_formula/gender_swap
	name = "变性药水"										// Formula name.
	// 中文：★气味档①★ 要求"浆果派"气味累计达到 5 点(即"5 份浆果派")。
	required_scent = "浆果派"								// Require the "berry pie" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★单一底料★ 情欲液 100(性活动体液；精液 /datum/reagent/erpjuice/cum 为其大宗产物)。
	required_base = list(/datum/reagent/erpjuice/cum = 100)	// Single base: 100 lust-fluid (semen).
	// 中文：产物——30 单位变性药水。
	output_reagents = list(/datum/reagent/gender_swap_potion = 30)	// Refined output.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	// 中文：成功气味词。
	smells_like = "暧昧的甜香"								// Success scent.
