//A spell to choose new spells, upon spawning or gaining levels
// TODO: Implement per patron spell lists
/obj/effect/proc_holder/spell/self/learnspell
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0
	skipcharge = TRUE
	var/static/list/spell_icon_cache = list()

/obj/effect/proc_holder/spell/self/learnspell/ui_state(mob/user)
	return GLOB.always_state

/obj/effect/proc_holder/spell/self/learnspell/ui_host(mob/user)
	return user

/obj/effect/proc_holder/spell/self/learnspell/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/obj/effect/proc_holder/spell/self/learnspell/cast(list/targets, mob/living/user = usr)
	. = ..()
	if(!GLOB.learnable_spells || !user || !user.mind)
		return FALSE
	ui_interact(user)
	return TRUE

/obj/effect/proc_holder/spell/self/learnspell/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpellLibrary", name)
		ui.open()

/obj/effect/proc_holder/spell/self/learnspell/ui_data(mob/user)
	var/list/data = list()

	var/points_avail = 0
	if(user && user.mind)
		points_avail = max(0, user.mind.spell_points - user.mind.used_spell_points)

	data["user_points"] = points_avail

	var/user_spell_tier = get_user_spell_tier(user)
	var/user_evil = get_user_evilness(user)
	var/list/known_spells = list()
	if(user && user.mind)
		for(var/obj/effect/proc_holder/spell/known in user.mind.spell_list)
			known_spells[known.type] = TRUE

	var/list/spells_data = list()

	for(var/spell_path in GLOB.learnable_spells)
		var/obj/effect/proc_holder/spell/S = spell_path
		if(!S)
			continue

		var/spell_tier = initial(S.spell_tier)
		var/zizo_req = initial(S.zizo_spell)
		var/cost = initial(S.cost)
		var/is_known = !isnull(known_spells[spell_path])
		var/tier_locked = (spell_tier > user_spell_tier)
		var/evil_locked = (zizo_req > user_evil)
		var/can_afford = (!is_known && !tier_locked && !evil_locked && (points_avail >= cost))
		var/img64 = spell_icon_cache[spell_path]
		if(!img64)
			var/icon_file = initial(S.action_icon) || 'icons/mob/actions/roguespells.dmi'
			var/icon_state_str = initial(S.overlay_state) || initial(S.action_icon_state)
			var/list/valid_states = icon_states(icon_file)

			var/icon/final_icon = null
			if(icon_state_str && (icon_state_str in valid_states))
				final_icon = icon(icon_file, icon_state_str, SOUTH, 1)
			else
				final_icon = icon('icons/mob/actions/roguespells.dmi', "spell", SOUTH, 1)

			if(final_icon)
				try
					var/generated = icon2base64(final_icon)
					img64 = generated ? generated : "blank"
				catch
					img64 = "blank"
			else
				img64 = "blank"

			spell_icon_cache[spell_path] = img64

		spells_data += list(list(
			"name" = initial(S.name) || "Unknown Spell",
			"desc" = initial(S.desc) || "",
			"cost" = cost,
			"tier" = spell_tier,
			"path" = "[spell_path]",
			"school" = initial(S.school) || "generic",
			"range" = initial(S.range),
			"charge_time" = initial(S.chargetime) / 10,
			"cooldown" = initial(S.recharge_time) / 10,
			"fatigue" = initial(S.releasedrain),
			"img64" = img64,
			"is_known" = is_known,
			"can_afford" = can_afford,
			"tier_locked" = tier_locked,
			"evil_locked" = evil_locked
		))

	data["spells"] = spells_data
	return data

/obj/effect/proc_holder/spell/self/learnspell/ui_act(action, params)
	. = ..()
	if(.)
		return TRUE

	var/mob/living/user = usr
	if(!istype(user) || !user.mind)
		return TRUE

	if(action == "learn")
		var/path_text = params["path"]
		if(!path_text)
			return TRUE

		var/spell_path = text2path(path_text)
		if(!ispath(spell_path) || !(spell_path in GLOB.learnable_spells))
			return TRUE

		for(var/obj/effect/proc_holder/spell/known in user.mind.spell_list)
			if(known.type == spell_path)
				to_chat(user, span_warning("You already know this spell!"))
				return TRUE

		var/obj/effect/proc_holder/spell/S = spell_path
		var/cost = initial(S.cost)
		var/spell_tier = initial(S.spell_tier)
		var/zizo_req = initial(S.zizo_spell)

		if(spell_tier > get_user_spell_tier(user))
			to_chat(user, span_warning("This spell requires a higher tier of arcane power!"))
			return TRUE

		if(zizo_req > get_user_evilness(user))
			to_chat(user, span_warning("You lack the forbidden knowledge for this spell."))
			return TRUE

		var/points_avail = user.mind.spell_points - user.mind.used_spell_points
		if(cost > points_avail)
			to_chat(user, span_warning("You do not have enough weave points!"))
			return TRUE

		user.mind.used_spell_points += cost
		var/obj/effect/proc_holder/spell/new_spell = new spell_path()
		new_spell.refundable = TRUE
		user.mind.AddSpell(new_spell)

		to_chat(user, span_notice("You have woven <b>[initial(S.name)]</b> into your mind!"))
		addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS) //self remove if no points
		return TRUE

	return TRUE
