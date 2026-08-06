// ============================================================================
// 记忆之吻 (Memory Kiss Token)
// ----------------------------------------------------------------------------
// 中文总览：
//   一枚温润的小巧饰物。手持它点击某人可"铭刻"与他们的亲密记忆；
//   在手中使用(attack_self)可重温那段感受——收到一段描绘文字，并获得小幅 arousal。
//   若铭刻之人已死亡，使用时会出现特殊的哀伤/追忆变体文案，且不再提供 arousal。
//   含 ERP 合意门——未开启 ERP 者仅可见文字、不产生生理效果。
//
//   用法：
//     · 铭刻：手持饰物，点击目标人物 → "铭刻记忆"
//     · 回忆：手持饰物，按 Z 键（或点击自己/饰物） → "重温记忆"
//     · 覆盖：已铭刻时再次点击他人 → 覆盖（旧记忆被新记忆替代）
//     · 清除：对空地使用(attack_self)时若已有铭刻，可选清除（确认弹窗）
//
//   全部代码位于 modular_z121 根目录之下。
// ============================================================================

/obj/item/memory_kiss_token
	name = "记忆之吻"
	desc = "一枚温润的小巧饰物，握在手心能感受到若有若无的余温。它静静等待着被赋予某个人的记忆——手持它、触碰那个人，便可将他们的气息铭刻其中。独处时再取出，闭上眼，仿佛那人就在身旁。"
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "cutgem_shell"
	color = "#e8a8b8"										// Soft rose-pink, romantic hue.
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	// 中文：铭刻数据。
	var/engraved_name = null								// Real name at time of engraving.
	var/engraved_race = null								// Species name for flavour.
	var/engraved_gender = null								// Gender for flavour pronouns.
	var/datum/weakref/engraved_ref = null					// Weak ref to the real person (for death check).
	var/engraved_time = 0									// world.time of engraving.
	var/last_recall = 0									// Cooldown for the recall action.

// 中文：手持点击某人 → 铭刻记忆。
/obj/item/memory_kiss_token/attack(mob/living/target, mob/living/user)
	if(!isliving(target) || !isliving(user))
		return ..()
	if(target == user)
		to_chat(user, span_warning("无法铭刻自己——记忆之吻需要另一个人的气息。"))
		return
	if(!ishuman(target))
		to_chat(user, span_warning("[target]没有留下足够深刻的印记……"))
		return
	var/mob/living/carbon/human/H = target
	var/old_name = engraved_name
	engraved_name = H.real_name
	engraved_race = H.dna?.species?.name
	engraved_gender = H.gender
	engraved_ref = WEAKREF(H)
	engraved_time = world.time
	if(old_name)
		to_chat(user, span_love("[old_name]的余温从指尖消散——[engraved_name]的气息重新填满了这枚小小的饰物。"))
		user.visible_message(span_notice("[user]手中的饰物闪过一丝微光，仿佛有什么被替换了……"), null, ignored_mobs = list(user))
	else
		to_chat(user, span_love("指尖触碰到[engraved_name]的瞬间，一股温热的暖流涌入了饰物——[engraved_name]的气息被铭刻其中。"))
		user.visible_message(span_notice("[user]将一枚小饰物轻轻贴在[target]身上，饰物闪过一丝微光。"), null, ignored_mobs = list(user))
	return

// 中文：手中使用 → 闭眼重温记忆。
/obj/item/memory_kiss_token/attack_self(mob/user)
	if(!engraved_name)
		to_chat(user, span_warning("饰物里还没有铭刻过任何人。试着用它触碰某个特别的人吧。"))
		return
	// 中文：冷却——每 30 秒最多回忆一次，防止 spam。
	if(world.time < last_recall + 30 SECONDS)
		to_chat(user, span_warning("刚才已经回忆过了……再等等才能再次沉浸其中。"))
		return
	last_recall = world.time

	// 中文：检查铭刻之人是否存活。
	var/mob/living/carbon/human/ghost = engraved_ref?.resolve()
	var/dead = FALSE
	if(!ghost || QDELETED(ghost) || ghost.stat == DEAD)
		dead = TRUE

	// 中文：根据存亡与铭刻时长选取文案。
	var/recall_text
	if(dead)
		recall_text = pick(
			"指尖抚过饰物，一阵彻骨的冰凉代替了往日的温热。[engraved_name]已经不在了——唯余这枚小小的饰物，还固执地记着他们活着时的温度。",
			"闭上眼，[engraved_name]的模样依然清晰——那[engraved_race]独有的气息、那曾经鲜活的笑容……记忆越是清晰，失去就越是沉重。",
			"饰物微微发凉，如同[engraved_name]离去那天你触碰到的冰冷肌肤。但它还记得——它比什么都记得更久。",
			"一丝若有若无的触感划过指尖，仿若[engraved_name]的最后一吻。泪水毫无征兆地涌了上来。",
		)
	else
		var/days = round((world.time - engraved_time) / (10 * 60 * 60 * 24))	// Approximate days since engraving.
		if(days <= 0)
			recall_text = pick(
				"闭上眼，[engraved_name]的气息仿佛还缠绕在指尖——那[engraved_race]特有的体温、那双眼睛里的笑意，一切都清晰得像是刚刚发生。",
				"指尖一阵酥麻，一股暖流从饰物流向四肢百骸。[engraved_name]的触碰仿佛近在咫尺，心跳不由自主地加快了。",
				"饰物在掌心微微发热，如同[engraved_name]温暖的手掌正覆在自己的手背上。一个名字在唇边徘徊，却终究没有说出口。",
			)
		else if(days <= 3)
			recall_text = pick(
				"闭上眼，[engraved_name]留下的温度仍未散去。虽然已经过了[days]天，那[engraved_race]特有的气息却依然鲜明如昨。",
				"饰物泛起一阵暖意，仿佛[engraved_name]远在别处也感受到了这份思念。记忆隔着[days]天的距离，依然滚烫。",
			)
		else
			recall_text = pick(
				"时光已经流逝了[days]个日夜。指尖探入饰物的余温，[engraved_name][engraved_race]的轮廓在记忆深处慢慢浮现——遥远，却依然温柔。",
				"闭上眼，[engraved_name]的记忆像陈年的酒，褪去了最初的滚烫，沉淀下一种悠长而醇厚的暖意。[days]天了，但从未真正忘记。",
			)

	to_chat(user, span_love("[recall_text]"))

	// 中文：若 ERP 开启且铭刻之人尚在人世，施加小幅 arousal。
	if(!dead && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.client?.prefs?.sexable && H.sexcon)
			H.sexcon.adjust_arousal(rand(8, 15))
			if(prob(50))
				to_chat(H, span_love("小腹深处传来一阵若有若无的悸动，仿佛[engraved_name]真的触碰了自己……"))

// 中文：检视时显示铭刻信息。
/obj/item/memory_kiss_token/examine(mob/user)
	. = ..()
	if(engraved_name)
		var/days = max(0, round((world.time - engraved_time) / (10 * 60 * 60 * 24)))
		if(days <= 0)
			. += span_notice("铭刻着 <b>[engraved_name]</b> 的气息——仿佛刚刚才发生。")
		else
			. += span_notice("铭刻着 <b>[engraved_name]</b> 的气息——已经 [days] 天了。")
		var/mob/living/carbon/human/ghost = engraved_ref?.resolve()
		if(!ghost || QDELETED(ghost) || ghost.stat == DEAD)
			. += span_warning("饰物……冰凉彻骨。")
	else
		. += span_notice("一片空白，等待着某个人的记忆来填满。")
