/obj/effect/proc_holder/spell/self/message
	name = "传讯术"
	desc = "连接一位你熟识之人的心灵，将话语低声送入其脑海，或投去一道直觉性的幻景。"
	cost = 1
	xp_gain = TRUE
	releasedrain = 30
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "message"
	/// The stat threshold needed to pass the identify check.
	var/identify_difficulty = 15

/obj/effect/proc_holder/spell/self/message/cast(list/targets, mob/user)
	. = ..()

	var/list/eligible_players = list()

	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			eligible_players += people
	else
		to_chat(user, span_warning("我不认识任何人。"))
		revert_cast()
		return

	eligible_players = sortList(eligible_players)
	user.emote("me", 1, "低声念诵咒文，嘴边短暂闪过一道白光。", TRUE, custom_me = TRUE)
	var/input = input(user, "你想联系谁？", src) as null|anything in eligible_players
	if(isnull(input))
		to_chat(user, span_warning("未选择目标。"))
		revert_cast()
		return

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			user.emote("me", 1, "低声念诵咒文，嘴边短暂闪过一道白光！", TRUE, custom_me = TRUE)

			// Standard message color, for anonymous communications.
			var/message_color = "7246ff"

			// Is this a message or a projection? Messages are whispered words, a projection is a projected image or feeling, like a sudden vision.
			// Projections do have the benefit of not being whispered, but your saviours will have to make do with primarily imagery.
			// Imagery which could contain short messages, like a vision! But the point is for them to be more abstract.
			var/is_projection = FALSE

			// Are we sending a message or a projection?
			if(alert(user, "要无言地投射一段幻景，还是低声传出一条讯息？", "", "幻景投射", "低语传讯") == "幻景投射")
				is_projection = TRUE

			var/message = input(user, "你成功建立了连接！[is_projection == TRUE ? "你想向对方脑海送入怎样的感官幻景？" : "你想向对方脑海低语什么？"]")
			if(!message)
				revert_cast()
				return

			if(alert(user, "要匿名发送吗？", "", "是", "否") == "否") //yes or no popup, if you say No run this code
				identify_difficulty = 0 //anyone can clear this

			HL.playsound_local(HL, 'sound/magic/message.ogg', 100)
			user.playsound_local(user, 'sound/magic/message.ogg', 100)

			var/identified = FALSE
			if(HL.STAPER >= identify_difficulty) //quick stat check
				if(HL.mind)
					if(HL.mind.do_i_know(name=user.real_name)) //do we know who this person is?
						identified = TRUE // we do
						// Typecasting so we can access the user's voice color!
						if(ishuman(user))
							var/mob/living/carbon/human/H = user
							// If we aren't anonymous, we speak in our own voice colour.
							message_color = H.voice_color

						// If this a projection or not?
						if(!is_projection)
							to_chat(HL, span_big("奥术低语滑入我的脑海，最终化作[user]的声音：<font color=#[message_color]><i>\"[message]\"</i></font>"))
							to_chat(user, span_big("你向[HL]的脑海低语，并在过程中暴露了自己的身份：<font color=#[message_color]><i>\"[message]\"</i></font>"))
						else
							to_chat(HL, span_big("一段短暂幻景忽然掠过我的脑海，熟悉得仿佛正来自[user]的心境：<font color=#[message_color]>\[<b>[message]</b>\]</font>"))
							to_chat(user, span_big("你向[HL]脑海送入一段短暂幻景，并在过程中暴露了自己的身份：<font color=#[message_color]>\[<b>[message]</b>\]</font>"))

			// We failed the check OR we just dont know who that is
			if(!identified)
				if(!is_projection)
					to_chat(HL, span_big("奥术低语滑入我的脑海，最终化作一名陌生[user.gender == FEMALE ? "女人" : "男人"]的声音：<font color=#[message_color]><i>\"[message]\"</i></font>"))
					to_chat(user, span_big("你匿名向[HL]的脑海低语：<font color=#[message_color]><i>\"[message]\"</i></font>"))
				else
					to_chat(HL, span_big("一段短暂幻景忽然掠过我的脑海，源头却无从辨明：<font color=#[message_color]>\[<b>[message]</b>\]</font>"))
					to_chat(user, span_big("你匿名向[HL]脑海送入一段短暂幻景：<font color=#[message_color]>\[<b>[message]</b>\]</font>"))
			// Messages are whispered out loud, projections are just a silent murmur.
			if(!is_projection)
				user.whisper(message)
			else
				user.emote("me", 1, "将全部心神都凝聚在某个念头上......", TRUE, custom_me = TRUE)
			log_game("[key_name(user)] sent a message to [key_name(HL)] with contents [message]")
			to_chat(user, span_notice("我闭上双眼，将心神聚向[HL.real_name]......我说出的词句已进入对方脑海。"))
			// maybe an option to return a message, here?
			return TRUE
			
	to_chat(user, span_warning("我试图寻求心灵连接，却找不到[input]。"))
	revert_cast()
	return
