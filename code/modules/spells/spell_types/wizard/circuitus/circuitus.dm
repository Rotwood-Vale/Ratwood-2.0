/obj/effect/proc_holder/spell/invoked/incantation
	name = "Circuitus"
	desc = "Noc's gift to mankind, the ability to shape the arcyne with mortal speech. Requires other spells to use to its full potential."
	range = 14
	selection_type = "range"
	recharge_time = 20 SECONDS
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	invocation_type = "none"
	warnie = "spellwarning"
	overlay_state = "nondetection"
	action_icon_state = "spell0"
	associated_skill = /datum/skill/magic/arcane
	cost = 4
	spell_tier = 2

	var/datum/incantation_data/spell_process = null

/obj/effect/proc_holder/spell/invoked/incantation/cast(list/targets, mob/user)
	if(!targets || !length(targets))
		revert_cast()
		return FALSE

	var/turf/clicked_spot = get_turf(targets[1])
	if(!clicked_spot)
		revert_cast()
		return FALSE
	if(clicked_spot.density)
		to_chat(user, span_warning("I cannot target that!"))
		revert_cast()
		return FALSE
	var/obj/item/circuitus_scroll/sacrifice
	spell_process = new /datum/incantation_data(user, clicked_spot, src)

	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/circuitus_scroll))
			sacrifice = I

	var/incantation

	if(sacrifice)
		incantation = sacrifice.spell_info
		to_chat(user, span_info("I read from the paper in my hand..."))
	else
		incantation = stripped_input(user, "Speak words of power.", "Incantation", "", 512)

	if(!incantation)
		revert_cast()
		spell_process = null
		return FALSE

	var/result = spell_process.parse_and_execute(incantation)
	var/used_spell = spell_process.spell_command_used

	spell_process = null

	if(used_spell)
		return FALSE
	else
		if(!result)
			revert_cast()
		return FALSE

/datum/incantation_data
	var/mob/living/caster
	var/turf/target_location
	var/list/words = list()
	var/datum/spell_value/current_iota = null
	var/list/iota_stack = list()
	var/in_loop = FALSE
	var/skip_until_else = FALSE
	var/list/spoken_so_far = list()
	var/suppress_runechat = FALSE
	var/in_conditional = FALSE
	var/spell_command_used = FALSE
	var/obj/effect/proc_holder/spell/spell_holder = null
	var/start_pause = FALSE
	var/pause_active = FALSE
	var/obj/item/melee/touch_attack/mora_focus/active_focus = null
	var/chant_delay = 0.6

/datum/incantation_data/New(mob/living/user, turf/spot, obj/effect/proc_holder/spell/holder)
	caster = user
	target_location = spot
	spell_holder = holder

/datum/incantation_data/proc/parse_and_execute(text)
	text = trim(LOWER_TEXT(text))

	if(!length(text) || !findtext(text, "!"))
		to_chat(caster, span_warning("Empty or invalid incantation!"))
		return FALSE

	var/exclaim_pos = findtext(text, "!")
	text = copytext(text, 1, exclaim_pos)
	text = trim(text)

	words = splittext(text, " ")

	var/list/cleaned = list()
	for(var/word in words)
		word = trim(word)
		if(length(word))
			cleaned += word

	words = cleaned

	if(!length(words))
		to_chat(caster, span_warning("Empty incantation!"))
		return FALSE

	chant_delay = 0.6 - (caster.get_skill_level(/datum/skill/magic/arcane) * 0.05)

	return do_sequence()

/datum/incantation_data/proc/do_sequence()
	var/word_num = 1
	var/first_word = !length(spoken_so_far)

	while(word_num <= length(words))
		var/word = words[word_num]

		if(word in GLOB.spell_command_list)
			if(word_num != length(words))
				to_chat(caster, span_warning("Spell commands must be final word!"))
				return FALSE

			if(!pause_active)
				caster.Immobilize(chant_delay SECONDS)
				sleep(chant_delay SECONDS)

			spoken_so_far += "[uppertext(word)]!"
			if(!suppress_runechat)
				show_runechat(spoken_so_far.Join(" "))
				if(caster.vocal_bark)
					playsound(caster, caster.vocal_bark, 40, TRUE)

			return do_spell_command(word)
		else
			if(!skip_until_else)
				if(pause_active && word == "mora")
					word_num++
					continue

				if(!first_word && !pause_active)
					caster.Immobilize(chant_delay SECONDS)
					sleep(chant_delay SECONDS)

				if(!pause_active)
					spoken_so_far += uppertext(word)
					if(!suppress_runechat)
						show_runechat(spoken_so_far.Join(" "))
						if(caster.vocal_bark)
							playsound(caster, caster.vocal_bark, 40, TRUE)

				if(!do_operation(word))
					to_chat(caster, span_warning("Your incantation fizzles!"))
					return FALSE

				if(start_pause)
					var/next_word = (word_num < length(words)) ? words[word_num + 1] : null
					if(!next_word || (!(next_word in GLOB.spell_command_list) && next_word != "iteratio"))
						start_pause = FALSE
						to_chat(caster, span_warning("Mora must come before a spell command or iteratio!"))
						return FALSE
					start_pause = FALSE
					start_mora_pause()
					return TRUE

				if(!caster.can_speak_vocal())
					to_chat(caster, span_warning("You can't speak the words!"))
					return FALSE

				first_word = FALSE
			else
				if(word == "alioquin")
					skip_until_else = FALSE

		word_num++

	to_chat(caster, span_warning("No spell command!"))
	return FALSE

/datum/incantation_data/proc/show_runechat(text)
	for(var/mob/M in oview(7, caster))
		if(M.client)
			M.create_chat_message(caster, null, text, list("emote", "italics"))
	if(caster.client)
		caster.create_chat_message(caster, null, text, list("emote", "italics"))

/datum/incantation_data/proc/start_mora_pause()
	var/obj/item/melee/touch_attack/mora_focus/focus = new /obj/item/melee/touch_attack/mora_focus(
		get_turf(caster),
		caster,
		words,
		spell_holder,
		spoken_so_far
	)

	caster.put_in_hands(focus)
	active_focus = focus
	START_PROCESSING(SSobj, focus)

	playsound(caster, 'sound/magic/repulse.ogg', 60, TRUE)
	to_chat(caster, span_notice("<b>Click a location</b> to redirect your incantation there, or <b>drop</b> the focus to cancel."))


/datum/incantation_data/proc/do_operation(word)
	var/datum/spell_operation/op = GLOB.spell_word_list[word]
	if(!op)
		to_chat(caster, span_warning("Unknown word: '[word]'"))
		return FALSE
	return op.activate(src)

/datum/incantation_data/proc/do_spell_command(word)
	var/datum/spell_command/spell = GLOB.spell_command_list[word]
	if(!spell)
		return FALSE

	if(spell.needs_spell && caster.mind)
		var/knows_it = FALSE
		for(var/obj/effect/proc_holder/spell/S in caster.mind.spell_list)
			if(istype(S, spell.needs_spell))
				knows_it = TRUE
				break
		if(!knows_it)
			to_chat(caster, span_warning("You don't know how to manifest '[word]'!"))
			return FALSE

	if(!spell_command_used && spell_holder)
		spell_holder.charge_counter = 0
		spell_holder.start_recharge()

	spell_command_used = TRUE
	return spell.activate(src)

/datum/incantation_data/proc/get_staff_power()
	var/obj/item/rogueweapon/woodstaff/staff = caster.is_holding_item_of_type(/obj/item/rogueweapon/woodstaff/)
	if(!staff)
		return 0
	var/power = staff.cast_time_reduction
	if(power >= 0.3)
		return 3
	if(power >= 0.2)
		return 2
	return 1

/datum/incantation_data/proc/push_iota(datum/spell_value/val)
	if(current_iota)
		iota_stack += current_iota
	current_iota = val

/datum/incantation_data/proc/pop_iota()
	if(!length(iota_stack))
		return null
	var/datum/spell_value/val = iota_stack[length(iota_stack)]
	iota_stack.len--
	return val

/datum/incantation_data/proc/peek_stack(index = 0)
	var/actual_index = length(iota_stack) - index
	if(actual_index < 1 || actual_index > length(iota_stack))
		return null
	return iota_stack[actual_index]

/datum/incantation_data/proc/can_see_through(turf/start, turf/target)
	if(!start || !target)
		return FALSE

	if(target.z != start.z)
		return FALSE

	if(target.density)
		return FALSE

	var/list/turf_list = getline(start, target)
	if(length(turf_list) > 0)
		turf_list.len--

	for(var/turf/T in turf_list)
		if(T.density)
			return FALSE

		for(var/obj/structure/mineral_door/door in T.contents)
			return FALSE

		for(var/obj/structure/roguewindow/window in T.contents)
			return FALSE

		for(var/obj/structure/bars/bars in T.contents)
			return FALSE

		for(var/obj/structure/gate/gate in T.contents)
			return FALSE

	return TRUE


/obj/item/melee/touch_attack/mora_focus
	name = "arcyne focus"
	desc = "A crystallised pause in an ongoing incantation. Click a location to redirect and release the spell. Drop it and the spell is lost."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	w_class = WEIGHT_CLASS_TINY

	var/mob/living/saved_caster = null
	var/list/saved_words = list()
	var/list/spoken_so_far_snapshot = list()
	var/obj/effect/proc_holder/spell/saved_spell_holder = null
	var/fatigue_per_tick = 20
	var/fizzled = FALSE

/obj/item/melee/touch_attack/mora_focus/Initialize(mapload, mob/living/C, list/W, obj/effect/proc_holder/spell/H, list/spoken = null)
	. = ..()
	saved_caster = C
	saved_words = W.Copy()
	saved_spell_holder = H
	spoken_so_far_snapshot = spoken ? spoken.Copy() : list()

/obj/item/melee/touch_attack/mora_focus/Destroy()
	if(!fizzled)
		_fizzle()
	return ..()

/obj/item/melee/touch_attack/mora_focus/attack_self(mob/user)
	_fizzle()
	qdel(src)

/obj/item/melee/touch_attack/mora_focus/afterattack(atom/target, mob/living/user, proximity)
	if(fizzled)
		return
	var/turf/T = get_turf(target)
	if(!T || T.density)
		to_chat(user, span_warning("I cannot target that location!"))
		return
	if(saved_spell_holder)
		var/turf/caster_turf = get_turf(user)
		if(get_dist(caster_turf, T) > saved_spell_holder.range)
			to_chat(user, span_warning("That is too far away!"))
			return
	var/mob/living/C = saved_caster
	var/list/W = saved_words.Copy()
	var/obj/effect/proc_holder/spell/H = saved_spell_holder
	fizzled = TRUE
	qdel(src)
	playsound(C, 'sound/magic/blink.ogg', 60, TRUE)
	var/datum/incantation_data/fresh = new /datum/incantation_data(C, T, H)
	fresh.pause_active = TRUE
	fresh.spoken_so_far = spoken_so_far_snapshot.Copy()
	fresh.parse_and_execute(jointext(W, " ") + "!")

/obj/item/melee/touch_attack/mora_focus/proc/_fizzle()
	if(fizzled)
		return
	fizzled = TRUE
	STOP_PROCESSING(SSobj, src)
	if(saved_caster)
		to_chat(saved_caster, span_warning("Your incantation fizzles as your focus dissolves!"))

/obj/item/melee/touch_attack/mora_focus/process()
	if(fizzled || !saved_caster)
		return PROCESS_KILL
	if(!(src in saved_caster.held_items))
		_fizzle()
		qdel(src)
		return PROCESS_KILL
	saved_caster.Immobilize(2 SECONDS)
	saved_caster.stamina_add(fatigue_per_tick)
	if(saved_caster.stamina >= saved_caster.maxHealth)
		to_chat(saved_caster, span_warning("You are too exhausted to maintain your focus!"))
		_fizzle()
		qdel(src)
		return PROCESS_KILL

/obj/item/melee/touch_attack/mora_focus/dropped(mob/user, silent)
	. = ..()
	if(!fizzled)
		_fizzle()

/datum/spell_operation/mora
	word = "mora"

/datum/spell_operation/mora/activate(datum/incantation_data/data)
	if(!data.caster)
		return FALSE
	for(var/obj/item/melee/touch_attack/mora_focus/existing in data.caster.held_items)
		to_chat(data.caster, span_warning("You are already maintaining an arcyne focus!"))
		return FALSE
	data.start_pause = TRUE
	return TRUE


GLOBAL_LIST_INIT(spell_word_list, list(
	"ego" = new /datum/spell_operation/me(),
	"signum" = new /datum/spell_operation/clicked(),
	"coordinatus" = new /datum/spell_operation/to_coords(),
	"locus" = new /datum/spell_operation/make_turf(),
	"prospectus" = new /datum/spell_operation/get_facing(),
	"res" = new /datum/spell_operation/get_stuff_here(),
	"obiectum" = new /datum/spell_operation/get_item(),
	"manus" = new /datum/spell_operation/get_held_item(),
	"distantia" = new /datum/spell_operation/coord_distance(),
	"addo" = new /datum/spell_operation/list_add(),
	"removeo" = new /datum/spell_operation/list_remove(),
	"extraho" = new /datum/spell_operation/pop_from_list(),
	"additus" = new /datum/spell_operation/coord_add(),
	"subtractus" = new /datum/spell_operation/coord_sub(),
	"effingo" = new /datum/spell_operation/copy,
	"ruptis" = new /datum/spell_operation/copy_last(),
	"si" = new /datum/spell_operation/check_if(),
	"alioquin" = new /datum/spell_operation/or_else(),
	"iteratio" = new /datum/spell_operation/for_each(),
	"nulla" = new /datum/spell_operation/zero(),
	"unus" = new /datum/spell_operation/one(),
	"duo" = new /datum/spell_operation/two(),
	"tres" = new /datum/spell_operation/three(),
	"quattuor" = new /datum/spell_operation/four(),
	"quinque" = new /datum/spell_operation/five(),
	"sex" = new /datum/spell_operation/six(),
	"septem" = new /datum/spell_operation/seven(),
	"lista" = new /datum/spell_operation/make_coordlist(),
	"lego" = new /datum/spell_operation/retrieve_iota(),
	"indicis" = new /datum/spell_operation/indexed_list_get(),
	"profundus" = new /datum/spell_operation/deep_stack_get(),
	"linea" = new /datum/spell_operation/line_coords(),
	"inspicio" = new /datum/spell_operation/inspect_iota(),
	"inversus" = new /datum/spell_operation/flip_sign(),
	"summa" = new /datum/spell_operation/add_nums(),
	"multiplicatio" = new /datum/spell_operation/times_nums(),
	"motus-x" = new /datum/spell_operation/shift_x(),
	"motus-y" = new /datum/spell_operation/shift_y(),
	"motus-z" = new /datum/spell_operation/shift_z(),
	"regio" = new /datum/spell_operation/make_area(),
	"homines" = new /datum/spell_operation/find_people(),
	"mora" = new /datum/spell_operation/mora()
))

GLOBAL_LIST_INIT(spell_command_list, list(
	"ignis" = new /datum/spell_command/flames(),
	"fulmen" = new /datum/spell_command/lightning(),
	"teleporto" = new /datum/spell_command/teleport(),
	"pondus" = new /datum/spell_command/crush(),
	"reficio" = new /datum/spell_command/fix_item(),
	"scribo" = new /datum/spell_command/store_iota(),
	"obmolior" = new /datum/spell_command/push_away(),
	"recolligere" = new /datum/spell_command/pull_close(),
	"murus" = new /datum/spell_command/make_wall(),
	"vis" = new /datum/spell_command/buff_strength(),
	"saxum" = new /datum/spell_command/buff_constitution(),
	"festinatio" = new /datum/spell_command/buff_speed(),
	"oculi" = new /datum/spell_command/buff_perception(),
	"tenax" = new /datum/spell_command/buff_endurance(),
	"sagitta" = new /datum/spell_command/projectile/arcyne(),
	"flammas" = new /datum/spell_command/projectile/fire(),
	"tabificus" = new /datum/spell_command/projectile/acid(),
	"glacies" = new /datum/spell_command/snap_freeze(),
	"glaciei" = new /datum/spell_command/projectile/frost()
))
