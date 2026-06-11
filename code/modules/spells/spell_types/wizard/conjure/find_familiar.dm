/mob/var/tmp/busy_summoning_familiar = FALSE

/obj/effect/proc_holder/spell/self/findfamiliar
	name = "寻觅使魔"
	desc = "召唤一位忠诚的魔法伙伴协助你的冒险。若在已有使魔时再次施放，或可唤醒其自我意识。\n\
	与其循规蹈矩地学习此术，制作卷轴或许更便宜。"
	overlay_state = "null"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	recharge_time = 5 SECONDS
	chargetime = 2 SECONDS

	warnie = "spellwarning"

	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

	xp_gain = TRUE
	spell_tier = 1
	cost = 2//Given they all have abilities and provide a buff. One spellpoint left over for virtue lads.

	invocations = list("忠灵，现身。")
	invocation_type = "whisper"

	var/mob/living/simple_animal/pet/familiar/fam
	var/familiars = list()

/obj/effect/proc_holder/spell/self/findfamiliar/Initialize(mapload)
	. = ..()
	familiars = GLOB.familiar_types.Copy()


/obj/effect/proc_holder/spell/self/findfamiliar/cast(list/targets, mob/living/carbon/user)
	if (!user)
		return FALSE

	// Prevent multiple simultaneous summon attempts
	if (user.busy_summoning_familiar)
		to_chat(user, span_warning("你已经在尝试召唤使魔了！请等待当前召唤结束。"))
		return FALSE

	user.busy_summoning_familiar = TRUE

	. = ..()

	// Check if user already has a familiar
	for (var/mob/living/simple_animal/pet/familiar/fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
		if (fam.familiar_summoner == user)
			if(fam.health <= 0)
				var/choice = input(user, "你的使魔已经死了。你想怎么做？") as null|anything in list("用魔法石复活", "释放它")
				if(choice == "用魔法石复活")
					to_chat(user, span_notice("若想尝试复活，你的当前持手中必须握有一块魔法石。"))
					var/obj/item/natural/stone/magic_stone = user.get_active_held_item()
					if(!istype(magic_stone, /obj/item/natural/stone) || magic_stone.magic_power < 1)
						to_chat(user, span_warning("你的当前持手中必须握着一块魔法石！"))
						user.busy_summoning_familiar = FALSE
						revert_cast()
						return FALSE
					else
						revive_familiar(magic_stone, fam, user)
						user.busy_summoning_familiar = FALSE
						return TRUE
				else if(choice == "释放它")
					free_familiar(fam, user)
					if(!fam?.mind)
						log_game("[key_name(user)] has released their familiar: [fam.name] ([fam.type])")
					else
						log_game("[key_name(user)] released sentient familiar [key_name(fam)] ([fam.type])")
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				else // Cancel
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
			else
				var/choice = input(user, "你已经有一只使魔了。你想释放它吗？") as null|anything in list("是", "否")
				if (choice != "是")
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				free_familiar(fam, user)
				if(!fam?.mind)
					log_game("[key_name(user)] has released their familiar: [fam.name] ([fam.type])")
				else
					log_game("[key_name(user)] released sentient familiar [key_name(fam)] ([fam.type])")
				user.busy_summoning_familiar = FALSE
				revert_cast()
				return FALSE

	// Check for valid spawn turf before spawning familiar
	var/turf/spawn_turf = get_step(user, user.dir)
	if (!isturf(spawn_turf) || !isopenturf(spawn_turf))
		to_chat(user, span_warning("这里没有足够的空间召唤你的使魔。"))
		revert_cast()
		user.busy_summoning_familiar = FALSE
		return FALSE

	// Ask how the user wants to summon
	var/path_choice = input(user, "你想如何召唤你的使魔？") as null|anything in list(
		"从已登记使魔中召唤"/*,
		"Summon a non-sentient familiar"*/
	)

	if (path_choice == "从已登记使魔中召唤")
		var/list/candidates = list()

		// Build list of valid candidate clients
		for (var/client/c_client in GLOB.familiar_queue)
			var/datum/familiar_prefs/pref = c_client.prefs?.familiar_prefs
			if (pref && familiars)
				for (var/fam_type in familiars)
					if (ispath(pref.familiar_specie, familiars[fam_type]))
						candidates += c_client
						break

		if (!candidates.len)
			to_chat(user, span_notice("没有你可以召唤的使魔候选者。"))
			user.busy_summoning_familiar = FALSE
			revert_cast()
			return FALSE

		while (TRUE)
			var/list/name_map = list()
			for (var/client/c_candidate in candidates)
				var/datum/familiar_prefs/pref = c_candidate.prefs?.familiar_prefs
				if (pref?.familiar_name)
					name_map[pref.familiar_name] = list("client" = c_candidate, "pref" = pref)

			var/choice = input(user, "选择一个要查看的已登记使魔：") as null|anything in name_map
			if (!choice)
				user.busy_summoning_familiar = FALSE
				revert_cast()
				return FALSE

			var/entry = name_map[choice]
			var/client/target = entry["client"]
			var/datum/familiar_prefs/pref = entry["pref"]

			if (!pref)
				to_chat(user, span_warning("那只使魔已不可用。"))
				GLOB.familiar_queue -= target
				continue

			show_familiar_preview(user, pref)

			var/confirm = input(user, "要召唤这只使魔吗？") as null|anything in list("是", "否")
			if (confirm != "接受")
				winset(user.client, "Familiar Inspect", "is-visible=false")
				continue

			// Check that target is valid
			if (!target || (!isobserver(target.mob) && !isnewplayer(target.mob)))
				to_chat(user, span_warning("那只使魔已不可用。"))
				user.busy_summoning_familiar = FALSE
				GLOB.familiar_queue -= target
				revert_cast()
				return FALSE

			switch(askuser(target.mob, "[user.real_name]正尝试将你召唤为使魔。你愿意接受吗？", "请在 [DisplayTimeText(200)] 内作答！", "是", "拒绝", StealFocus=0, Timeout=200))
				if(1)
					to_chat(target.mob, span_notice("你是[user.real_name]的魔法使魔。你受契约约束，必须协助[user.p_them()]，但你依然保有求生本能。"))
					GLOB.familiar_queue -= target
					spawn_familiar_for_player(target.mob, user)
					log_game("[user.ckey] summoned [pref.familiar_name] ([pref.familiar_specie]) controlled by [target.ckey]")
					if(target && target.mob)
						winset(target.mob, "Be a Familiar", "is-visible=false")
					user.busy_summoning_familiar = FALSE
					return TRUE
				if(2)
					to_chat(target.mob, span_notice("已记录选择：拒绝。"))
					to_chat(user, span_notice("这只使魔拒绝了你的召唤。"))
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
				else
					to_chat(user, span_notice("这只使魔回应得太慢，法术已白白耗散。"))
					user.busy_summoning_familiar = FALSE
					revert_cast()
					return FALSE
/*//Commented out, as they can sit as idle buff totems, effectively. No, thanks.
	if(path_choice == "Summon a non-sentient familiar")
		// Non-sentient familiar summoning
		var/familiarchoice = input("Choose your familiar", "Available familiars") as anything in familiars
		var/mob/living/simple_animal/pet/familiar/familiar_type = familiars[familiarchoice]
		var/mob/living/simple_animal/pet/familiar/fam = new familiar_type(spawn_turf)
		fam.familiar_summoner = user
		user.visible_message(span_notice("[fam.summoning_emote]"))
		fam.fully_replace_character_name(null, "[user.real_name]'s familiar")
		var/faction_to_add = "[user.mind.current.real_name]_faction" //Should stop necromancer's skellies from murdering the necromancer's pet.
		fam.faction |= faction_to_add
		log_game("[key_name(user)] summoned non-sentient familiar of type [familiar_type]")
		user.busy_summoning_familiar = FALSE
		return TRUE
*/
	else
		user.busy_summoning_familiar = FALSE
		revert_cast()
		return FALSE

///Used to show a preview of the prospective familiar's inspect window to the summoner.
/proc/show_familiar_preview(mob/user, datum/familiar_prefs/pref)
	if (!pref)
		return

	var/list/dat = list()
	var/title = pref.familiar_name ? pref.familiar_name : "无名使魔"

	dat += "<div align='center'><font size=5 color='#dddddd'><b>[title]</b></font></div>"

	// Add species name below the title, centered
	var/specie_type = GLOB.familiar_display_names[pref.familiar_specie]
	dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

	// Add pronouns below species name
	var/list/pronoun_display = list(
		HE_HIM = "他",
		SHE_HER = "她",
		THEY_THEM = "TA",
		IT_ITS = "它"
	)
	var/selected_pronoun = pronoun_display[pref.familiar_pronouns] ? pronoun_display[pref.familiar_pronouns] : "they/them"
	dat += "<div align='center'><font size=3 color='#bbbbbb'>[selected_pronoun]</font></div>"

	if (valid_headshot_link(null, pref.familiar_headshot_link, TRUE))
		dat += "<div align='center'><img src='[pref.familiar_headshot_link]' width='325px' height='325px'></div>"

	if (pref.familiar_flavortext_display)
		dat += "<div align='left'>[pref.familiar_flavortext_display]</div>"

	if (pref.familiar_ooc_notes_display)
		dat += "<br><div align='center'><b>OOC 备注</b></div>"
		dat += "<div align='left'>[pref.familiar_ooc_notes_display]</div>"

	if (pref.familiar_ooc_extra)
		dat += pref.familiar_ooc_extra

	var/datum/browser/popup = new(user, "Familiar Inspect", nwidth = 600, nheight = 800)
	popup.set_content(dat.Join("\n"))
	popup.open(FALSE)

///Used to free a familiar from its summoner.
/proc/free_familiar(mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
	if (QDELETED(fam))
		to_chat(user, span_warning("这只使魔已经不在了。"))
		return
	to_chat(user, span_warning("你感到自己与[fam.name]之间的联系断开了。"))
	to_chat(fam, span_warning("你感到自己与[user.name]之间的联系断开了，你自由了。"))

	fam.familiar_summoner = null
	if (fam.buff_given)
		user.remove_status_effect(fam.buff_given)

	user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/message_familiar)
	fam.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/message_summoner)

	if (!fam.mind)
		var/exit_msg
		if (isdead(fam))
			exit_msg = "[fam.name]的尸体在一团烟雾中消失了。"
		else
			exit_msg = "[fam.name]最后望了[user.name]一眼，随后开启一道传送门，没入其中消失不见。"

		fam.visible_message(span_warning(exit_msg))
		qdel(fam)


/proc/spawn_familiar_for_player(mob/chosen_one, mob/living/carbon/user)
	if (!chosen_one || !user)
		return

	// Handle if the chosen one is a new player lobby mob
	if (isnewplayer(chosen_one))
		var/mob/dead/new_player/new_chosen = chosen_one
		new_chosen.close_spawn_windows()

	// Ensure the chosen one has a valid client and preferences
	var/client/client_ref = chosen_one.client
	if (!client_ref || !client_ref.prefs)
		to_chat(user, span_warning("使魔召唤失败：目标没有偏好设置或已无效。"))
		return

	var/datum/familiar_prefs/prefs = client_ref.prefs.familiar_prefs
	if (!prefs || !prefs.familiar_specie)
		to_chat(user, span_warning("使魔召唤失败：目标没有有效的使魔形态。"))
		return

	// Spawn the familiar mob near the summoner
	var/turf/spawn_turf = get_step(user, user.dir)
	var/mob/living/simple_animal/pet/familiar/awakener = new prefs.familiar_specie(spawn_turf)
	if (!awakener)
		to_chat(user, span_warning("使魔召唤失败：无法创建使魔。"))
		return

	// Set summoner and name
	awakener.familiar_summoner = user
	awakener.fully_replace_character_name(null, prefs.familiar_name)
	awakener.pronouns = prefs.familiar_pronouns

	// Display summoning emote
	user.visible_message(span_notice("[awakener.summoning_emote]"))

	// Apply summoner's familiar buff
	if (awakener.buff_given)
		user.apply_status_effect(awakener.buff_given)

	// Transfer player's mind to the familiar
	if (!chosen_one.mind)
		to_chat(user, span_warning("使魔召唤失败：目标没有可转移的心智。"))
		qdel(awakener)
		return

	chosen_one.mind.transfer_to(awakener, 1)
	var/datum/mind/mind_datum = awakener.mind
	if (!mind_datum)
		to_chat(user, span_warning("使魔召唤失败：心智转移失败。"))
		qdel(awakener)
		return

	// Clear existing spells, then grant familiar communication
	mind_datum.RemoveAllSpells()
	mind_datum.AddSpell(new /obj/effect/proc_holder/spell/self/message_summoner)
	user.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/message_familiar)

	// Add familiar's inherent spells
	if (awakener.inherent_spell)
		for (var/spell_path in awakener.inherent_spell)
			if (ispath(spell_path))
				var/obj/effect/proc_holder/spell/spell_instance = new spell_path
				if (spell_instance)
					mind_datum.AddSpell(spell_instance)

	// Disable automated/AI features
	awakener.can_have_ai = FALSE
	awakener.AIStatus = AI_OFF
	awakener.stop_automated_movement = TRUE
	awakener.stop_automated_movement_when_pulled = TRUE
	awakener.wander = FALSE

	var/faction_to_add = "[user.mind.current.real_name]_faction" //Should stop necromancer's skellies from murdering the necromancer's pet.
	awakener.faction |= faction_to_add

	// Admin/game logging
	log_game("[key_name(user)] has summoned [key_name(chosen_one)] as familiar '[awakener.name]' ([awakener.type]).")

/obj/effect/proc_holder/spell/self/message_familiar
	name = "向使魔传讯"
	desc = "向你的使魔脑海中低语一段话。"

/obj/effect/proc_holder/spell/self/message_familiar/cast(list/targets, mob/user)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/familiar
	for(var/mob/living/simple_animal/pet/familiar/familiar_check in GLOB.player_list)
		if(familiar_check.familiar_summoner == user)
			familiar = familiar_check
	if(!familiar || !familiar.mind)
		revert_cast()
		to_chat(user, span_warning("你无法感知到使魔的心智。"))
		return
	var/message = input(user, "你建立起了联系。你想说什么？")
	if(!message)
		revert_cast()
		return
	to_chat_immediate(familiar, "奥术低语滑入我的脑海，最终化作[user]的声音：<font color=#7246ff>[message]</font>")
	user.visible_message("[user]低声念出咒语，嘴边短暂闪过一道白光。")
	user.whisper(message)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/proc/revive_familiar(obj/item/natural/stone/magic_stone, mob/living/simple_animal/pet/familiar/fam, mob/living/carbon/user)
	// Consume the stone
	to_chat(user, span_notice("你将石中的魔力导入[fam.name]体内，使其复生！"))
	qdel(magic_stone)

	// Revive and fully heal the familiar
	fam.revive(full_heal = TRUE, admin_revive = TRUE)
	fam.familiar_summoner = user
	fam.visible_message(span_notice("[fam.name]在[user]的魔力下重获新生！"))
	return TRUE
