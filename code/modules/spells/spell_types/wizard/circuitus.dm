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
	var/in_conditional = FALSE
	var/spell_command_used = FALSE
	var/obj/effect/proc_holder/spell/spell_holder = null

/datum/incantation_data/New(mob/living/user, turf/spot, obj/effect/proc_holder/spell/holder)
	caster = user
	target_location = spot
	spell_holder = holder

/datum/incantation_data/proc/parse_and_execute(text)
	text = trim(lowertext(text))

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

	return do_sequence()

/datum/incantation_data/proc/do_sequence()
	var/word_num = 1
	var/first_word = TRUE

	while(word_num <= length(words))
		var/word = words[word_num]

		if(word in GLOB.spell_command_list)
			if(word_num != length(words))
				to_chat(caster, span_warning("Spell commands must be final word!"))
				return FALSE

			caster.Immobilize(1 SECONDS)
			sleep(1 SECONDS)
			caster.say("[uppertext(word)]!", forced = "spell")

			return do_spell_command(word)
		else
			if(!skip_until_else)
				if(!first_word)
					caster.Immobilize(0.6 SECONDS)
					sleep(0.6 SECONDS)

				caster.say(uppertext(word), forced = "spell")

				if(!do_operation(word))
					to_chat(caster, span_warning("Your incantation fizzles!"))
					return FALSE
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

/datum/spell_value
	var/what_am_i = "nothing"

/datum/spell_value/number
	what_am_i = "number"
	var/num = 0

/datum/spell_value/number/New(n)
	num = n

/datum/spell_value/position
	what_am_i = "coords"
	var/x_pos = 0
	var/y_pos = 0
	var/z_pos = 0

/datum/spell_value/position/New(x, y, z)
	x_pos = x
	y_pos = y
	z_pos = z

/datum/spell_value/tile
	what_am_i = "turf"
	var/turf/the_turf = null

/datum/spell_value/tile/New(turf/T)
	the_turf = T

/datum/spell_value/tile_group
	what_am_i = "area"
	var/list/turfs = list()

/datum/spell_value/tile_group/New()
	turfs = list()

/datum/spell_value/tile_group/proc/add(turf/T)
	if(T && !(T in turfs))
		turfs += T

/datum/spell_value/people
	what_am_i = "moblist"
	var/list/mob_list = list()

/datum/spell_value/people/New()
	mob_list = list()

/datum/spell_value/people/proc/add(mob/M)
	if(M && !(M in mob_list))
		mob_list += M

/datum/spell_value/mob
	what_am_i = "mob"
	var/mob/living/the_mob = null

/datum/spell_value/mob/New(mob/living/M)
	the_mob = M

/datum/spell_value/coord_list
	what_am_i = "coordlist"
	var/list/coord_list = list()

/datum/spell_value/coord_list/New()
	coord_list = list()

/datum/spell_value/coord_list/proc/add(datum/spell_value/position/pos)
	if(pos)
		coord_list += pos

/datum/spell_value/item_thing
	what_am_i = "item"
	var/obj/item/the_item = null

/datum/spell_value/item_thing/New(obj/item/I)
	the_item = I

/datum/spell_operation
	var/word = ""

/datum/spell_operation/proc/activate(datum/incantation_data/data)
	return FALSE

/datum/spell_operation/me
	word = "ego"

/datum/spell_operation/me/activate(datum/incantation_data/data)
	if(!data.caster)
		return FALSE
	data.push_iota(new /datum/spell_value/mob(data.caster))
	return TRUE

/datum/spell_operation/clicked
	word = "signum"

/datum/spell_operation/clicked/activate(datum/incantation_data/data)
	if(!data.target_location)
		return FALSE

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/new_x = data.target_location.x - pos.x_pos
		var/new_y = data.target_location.y - pos.y_pos
		var/new_z = data.target_location.z - pos.z_pos
		data.current_iota = new /datum/spell_value/position(new_x, new_y, new_z)
		return TRUE
	else if(data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist = data.current_iota
		var/datum/spell_value/coord_list/result = new()

		for(var/datum/spell_value/position/pos in clist.coord_list)
			var/new_x = data.target_location.x - pos.x_pos
			var/new_y = data.target_location.y - pos.y_pos
			var/new_z = data.target_location.z - pos.z_pos
			result.add(new /datum/spell_value/position(new_x, new_y, new_z))

		data.current_iota = result
		return TRUE
	else
		return FALSE

/datum/spell_operation/to_coords
	word = "coordinatus"

/datum/spell_operation/to_coords/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "turf")
		var/datum/spell_value/tile/t = data.current_iota
		data.current_iota = new /datum/spell_value/position(t.the_turf.x, t.the_turf.y, t.the_turf.z)
		return TRUE
	else if(data.current_iota.what_am_i == "coords")
		return TRUE
	else if(data.current_iota.what_am_i == "mob")
		var/datum/spell_value/mob/mob_iota = data.current_iota
		var/turf/T = get_turf(mob_iota.the_mob)
		if(T)
			data.current_iota = new /datum/spell_value/position(T.x, T.y, T.z)
			return TRUE
		return FALSE
	else if(data.current_iota.what_am_i == "moblist")
		var/datum/spell_value/people/victims = data.current_iota
		if(length(victims.mob_list) == 1)
			var/mob/M = victims.mob_list[1]
			var/turf/T = get_turf(M)
			if(T)
				data.current_iota = new /datum/spell_value/position(T.x, T.y, T.z)
				return TRUE
			return FALSE
		else
			var/datum/spell_value/coord_list/result = new()
			for(var/mob/M in victims.mob_list)
				var/turf/T = get_turf(M)
				if(T)
					result.add(new /datum/spell_value/position(T.x, T.y, T.z))
			data.current_iota = result
			return TRUE
	else
		return FALSE

/datum/spell_operation/make_turf
	word = "locus"

/datum/spell_operation/make_turf/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	if(!T)
		return FALSE

	data.current_iota = new /datum/spell_value/tile(T)
	return TRUE

/datum/spell_operation/get_facing
	word = "prospectus"

/datum/spell_operation/get_facing/activate(datum/incantation_data/data)
	var/turf/start = get_turf(data.caster)
	if(!start)
		return FALSE

	var/turf/facing = get_step(start, data.caster.dir)
	if(!facing)
		return FALSE

	data.push_iota(new /datum/spell_value/position(facing.x, facing.y, facing.z))
	return TRUE

/datum/spell_operation/get_stuff_here
	word = "res"

/datum/spell_operation/get_stuff_here/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	if(!T)
		return FALSE

	var/datum/spell_value/people/result = new()
	for(var/mob/living/M in T.contents)
		result.add(M)

	data.current_iota = result
	return TRUE

/datum/spell_operation/get_item
	word = "obiectum"

/datum/spell_operation/get_item/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	if(!T)
		return FALSE

	for(var/obj/item/I in T.contents)
		data.current_iota = new /datum/spell_value/item_thing(I)
		return TRUE

	return FALSE

/datum/spell_operation/get_held_item
	word = "manus"

/datum/spell_operation/get_held_item/activate(datum/incantation_data/data)
	for(var/obj/item/I in data.caster.held_items)
		if(istype(I, /obj/item/circuitus_scroll))
			continue
		data.push_iota(new /datum/spell_value/item_thing(I))
		return TRUE

	return FALSE

/datum/spell_operation/coord_distance
	word = "distantia"

/datum/spell_operation/coord_distance/activate(datum/incantation_data/data)
	var/datum/spell_value/position/first = data.pop_iota()

	if(!first || first.what_am_i != "coords" || !data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/second = data.current_iota

	var/dx = second.x_pos - first.x_pos
	var/dy = second.y_pos - first.y_pos
	var/dz = second.z_pos - first.z_pos

	var/distance = round(sqrt((dx * dx) + (dy * dy) + (dz * dz)))

	data.current_iota = new /datum/spell_value/number(distance)
	return TRUE

/datum/spell_operation/list_add
	word = "addo"

/datum/spell_operation/list_add/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	var/datum/spell_value/item_to_add = data.current_iota
	var/datum/spell_value/base_list = data.pop_iota()

	if(!base_list)
		return FALSE

	if(base_list.what_am_i == "moblist" && item_to_add.what_am_i == "mob")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/mob/m = item_to_add
		list1.add(m.the_mob)
		data.current_iota = list1
		return TRUE
	else if(base_list.what_am_i == "moblist" && item_to_add.what_am_i == "moblist")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/people/list2 = item_to_add
		for(var/mob/M in list2.mob_list)
			list1.add(M)
		data.current_iota = list1
		return TRUE
	else if(base_list.what_am_i == "coordlist" && item_to_add.what_am_i == "coords")
		var/datum/spell_value/coord_list/clist = base_list
		var/datum/spell_value/position/pos = item_to_add
		clist.add(pos)
		data.current_iota = clist
		return TRUE
	else if(base_list.what_am_i == "coordlist" && item_to_add.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist1 = base_list
		var/datum/spell_value/coord_list/clist2 = item_to_add
		for(var/datum/spell_value/position/pos in clist2.coord_list)
			clist1.add(pos)
		data.current_iota = clist1
		return TRUE
	else
		return FALSE

/datum/spell_operation/list_remove
	word = "removeo"

/datum/spell_operation/list_remove/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	var/datum/spell_value/item_to_remove = data.current_iota
	var/datum/spell_value/base_list = data.pop_iota()

	if(!base_list)
		return FALSE

	if(base_list.what_am_i == "moblist" && item_to_remove.what_am_i == "mob")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/mob/m = item_to_remove
		list1.mob_list -= m.the_mob
		data.current_iota = list1
		return TRUE
	else if(base_list.what_am_i == "moblist" && item_to_remove.what_am_i == "moblist")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/people/list2 = item_to_remove
		for(var/mob/M in list2.mob_list)
			list1.mob_list -= M
		data.current_iota = list1
		return TRUE
	else if(base_list.what_am_i == "coordlist" && item_to_remove.what_am_i == "coords")
		var/datum/spell_value/coord_list/clist = base_list
		var/datum/spell_value/position/pos = item_to_remove
		clist.coord_list -= pos
		data.current_iota = clist
		return TRUE
	else if(base_list.what_am_i == "coordlist" && item_to_remove.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist1 = base_list
		var/datum/spell_value/coord_list/clist2 = item_to_remove
		for(var/datum/spell_value/position/pos in clist2.coord_list)
			clist1.coord_list -= pos
		data.current_iota = clist1
		return TRUE
	else
		return FALSE

/datum/spell_operation/pop_from_list
	word = "extraho"

/datum/spell_operation/pop_from_list/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "moblist")
		var/datum/spell_value/people/mob_list = data.current_iota
		if(!length(mob_list.mob_list))
			return FALSE

		var/mob/last_mob = mob_list.mob_list[length(mob_list.mob_list)]
		mob_list.mob_list.len--

		var/turf/T = get_turf(last_mob)
		if(!T)
			return FALSE

		data.current_iota = new /datum/spell_value/position(T.x, T.y, T.z)
		return TRUE
	else if(data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist = data.current_iota
		if(!length(clist.coord_list))
			return FALSE

		var/datum/spell_value/position/last_coord = clist.coord_list[length(clist.coord_list)]
		clist.coord_list.len--

		data.current_iota = last_coord
		return TRUE
	else
		return FALSE

/datum/spell_operation/coord_add
	word = "additus"

/datum/spell_operation/coord_add/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	var/datum/spell_value/first = data.pop_iota()
	if(!first)
		return FALSE

	if(first.what_am_i == "coords" && data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/p1 = first
		var/datum/spell_value/position/p2 = data.current_iota
		data.current_iota = new /datum/spell_value/position(
			p1.x_pos + p2.x_pos,
			p1.y_pos + p2.y_pos,
			p1.z_pos + p2.z_pos
		)
		return TRUE
	else if(first.what_am_i == "coordlist" && data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/c1 = first
		var/datum/spell_value/coord_list/c2 = data.current_iota
		var/datum/spell_value/coord_list/result = new()

		var/max_len = max(length(c1.coord_list), length(c2.coord_list))
		for(var/i = 1, i <= max_len, i++)
			var/datum/spell_value/position/p1 = (i <= length(c1.coord_list)) ? c1.coord_list[i] : new /datum/spell_value/position(0, 0, 0)
			var/datum/spell_value/position/p2 = (i <= length(c2.coord_list)) ? c2.coord_list[i] : new /datum/spell_value/position(0, 0, 0)

			result.add(new /datum/spell_value/position(p1.x_pos + p2.x_pos, p1.y_pos + p2.y_pos, p1.z_pos + p2.z_pos))

		data.current_iota = result
		return TRUE
	else
		return FALSE

/datum/spell_operation/coord_sub
	word = "subtractus"

/datum/spell_operation/coord_sub/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	var/datum/spell_value/first = data.pop_iota()
	if(!first)
		return FALSE

	if(first.what_am_i == "coords" && data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/p1 = first
		var/datum/spell_value/position/p2 = data.current_iota
		data.current_iota = new /datum/spell_value/position(
			p2.x_pos - p1.x_pos,
			p2.y_pos - p1.y_pos,
			p2.z_pos - p1.z_pos
		)
		return TRUE
	else if(first.what_am_i == "coordlist" && data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/c1 = first
		var/datum/spell_value/coord_list/c2 = data.current_iota
		var/datum/spell_value/coord_list/result = new()

		var/max_len = max(length(c1.coord_list), length(c2.coord_list))
		for(var/i = 1, i <= max_len, i++)
			var/datum/spell_value/position/p1 = (i <= length(c1.coord_list)) ? c1.coord_list[i] : new /datum/spell_value/position(0, 0, 0)
			var/datum/spell_value/position/p2 = (i <= length(c2.coord_list)) ? c2.coord_list[i] : new /datum/spell_value/position(0, 0, 0)

			result.add(new /datum/spell_value/position(p2.x_pos - p1.x_pos, p2.y_pos - p1.y_pos, p2.z_pos - p1.z_pos))

		data.current_iota = result
		return TRUE
	else
		return FALSE

/datum/spell_operation/check_if
	word = "si"

/datum/spell_operation/check_if/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/n = data.current_iota
	data.in_conditional = TRUE

	if(n.num <= 0)
		data.skip_until_else = TRUE

	return TRUE

/datum/spell_operation/or_else
	word = "alioquin"

/datum/spell_operation/or_else/activate(datum/incantation_data/data)
	data.in_conditional = FALSE
	data.skip_until_else = FALSE
	return TRUE

/datum/spell_operation/for_each
	word = "iteratio"

/datum/spell_operation/for_each/activate(datum/incantation_data/data)
	if(data.in_loop)
		to_chat(data.caster, span_warning("Cannot loop within a loop!"))
		return FALSE

	if(!data.current_iota)
		return FALSE

	var/list/items_to_iterate = list()

	if(data.current_iota.what_am_i == "moblist")
		var/datum/spell_value/people/victims = data.current_iota
		for(var/mob/M in victims.mob_list)
			items_to_iterate += new /datum/spell_value/mob(M)
	else if(data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/coords = data.current_iota
		for(var/datum/spell_value/position/pos in coords.coord_list)
			items_to_iterate += pos
	else
		return FALSE

	if(!length(items_to_iterate))
		return TRUE

	data.in_loop = TRUE
	var/loop_start = 0

	for(var/i = 1, i <= length(data.words), i++)
		if(data.words[i] == "iteratio")
			loop_start = i + 1
			break

	if(!loop_start)
		return FALSE

	var/datum/spell_value/backup_iota = data.current_iota

	for(var/datum/spell_value/item in items_to_iterate)
		data.current_iota = item

		for(var/word_idx = loop_start, word_idx <= length(data.words), word_idx++)
			var/word = data.words[word_idx]

			if(word in GLOB.spell_command_list)
				if(!data.do_spell_command(word))
					data.in_loop = FALSE
					return FALSE
				break
			else
				if(!data.do_operation(word))
					data.in_loop = FALSE
					return FALSE

	data.in_loop = FALSE
	data.current_iota = backup_iota
	return TRUE

/datum/spell_operation/zero
	word = "nulla"

/datum/spell_operation/zero/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(0))
	return TRUE

/datum/spell_operation/one
	word = "unus"

/datum/spell_operation/one/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(1))
	return TRUE

/datum/spell_operation/two
	word = "duo"

/datum/spell_operation/two/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(2))
	return TRUE

/datum/spell_operation/three
	word = "tres"

/datum/spell_operation/three/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(3))
	return TRUE

/datum/spell_operation/four
	word = "quattuor"

/datum/spell_operation/four/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(4))
	return TRUE

/datum/spell_operation/five
	word = "quinque"

/datum/spell_operation/five/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(5))
	return TRUE

/datum/spell_operation/six
	word = "sex"

/datum/spell_operation/six/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(6))
	return TRUE

/datum/spell_operation/seven
	word = "septem"

/datum/spell_operation/seven/activate(datum/incantation_data/data)
	data.push_iota(new /datum/spell_value/number(7))
	return TRUE

/datum/spell_operation/make_coordlist
	word = "lista"

/datum/spell_operation/make_coordlist
	word = "lista"

/datum/spell_operation/make_coordlist/activate(datum/incantation_data/data)
	if(!data.current_iota)
		var/datum/spell_value/coord_list/new_list = new()
		data.push_iota(new_list)
		return TRUE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/datum/spell_value/coord_list/new_list = new()
		new_list.add(pos)
		data.current_iota = new_list
		return TRUE
	else if(data.current_iota.what_am_i == "mob")
		var/datum/spell_value/mob/m = data.current_iota
		var/datum/spell_value/people/new_list = new()
		new_list.add(m.the_mob)
		data.current_iota = new_list
		return TRUE
	else if(data.current_iota.what_am_i == "coordlist" || data.current_iota.what_am_i == "moblist")
		return TRUE
	else
		return FALSE

/datum/spell_operation/retrieve_iota
	word = "lego"

/datum/spell_operation/retrieve_iota/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "item")
		return FALSE

	var/datum/spell_value/item_thing/item_iota = data.current_iota
	if(!istype(item_iota.the_item, /obj/item/memory_string))
		return FALSE

	var/obj/item/memory_string/memory = item_iota.the_item
	if(!memory.iota)
		return FALSE

	data.current_iota = memory.iota
	return TRUE

/datum/spell_operation/indexed_list_get
	word = "indicis"

/datum/spell_operation/indexed_list_get/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/index = data.current_iota
	var/datum/spell_value/the_list = data.pop_iota()

	if(!the_list)
		return FALSE

	var/idx = max(1, index.num)

	if(the_list.what_am_i == "moblist")
		var/datum/spell_value/people/mlist = the_list
		if(idx > length(mlist.mob_list))
			return FALSE
		data.current_iota = new /datum/spell_value/mob(mlist.mob_list[idx])
		return TRUE
	else if(the_list.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist = the_list
		if(idx > length(clist.coord_list))
			return FALSE
		data.current_iota = clist.coord_list[idx]
		return TRUE
	else
		return FALSE

/datum/spell_operation/deep_stack_get
	word = "profundus"

/datum/spell_operation/deep_stack_get/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/depth = data.current_iota
	var/datum/spell_value/retrieved = data.peek_stack(depth.num)

	if(!retrieved)
		return FALSE

	data.current_iota = retrieved
	return TRUE

/datum/spell_operation/line_coords
	word = "linea"

/datum/spell_operation/line_coords/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/end_pos = data.current_iota
	var/datum/spell_value/position/start_pos = data.pop_iota()

	if(!start_pos || start_pos.what_am_i != "coords")
		return FALSE

	var/turf/start_turf = locate(start_pos.x_pos, start_pos.y_pos, start_pos.z_pos)
	var/turf/end_turf = locate(end_pos.x_pos, end_pos.y_pos, end_pos.z_pos)

	if(!start_turf || !end_turf)
		return FALSE

	var/datum/spell_value/coord_list/line = new()
	var/list/turf_line = getline(start_turf, end_turf)

	for(var/turf/T in turf_line)
		line.add(new /datum/spell_value/position(T.x, T.y, T.z))

	data.current_iota = line
	return TRUE

/datum/spell_operation/inspect_iota
	word = "inspicio"

/datum/spell_operation/inspect_iota/activate(datum/incantation_data/data)
	if(!data.current_iota)
		to_chat(data.caster, span_notice("Current iota: nothing"))
		return TRUE

	var/message = "Current iota: [data.current_iota.what_am_i]"

	if(data.current_iota.what_am_i == "number")
		var/datum/spell_value/number/n = data.current_iota
		message += " ([n.num])"
	else if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		message += " ([pos.x_pos], [pos.y_pos], [pos.z_pos])"
	else if(data.current_iota.what_am_i == "moblist")
		var/datum/spell_value/people/ppl = data.current_iota
		message += " (count: [length(ppl.mob_list)])"
	else if(data.current_iota.what_am_i == "coordlist")
		var/datum/spell_value/coord_list/clist = data.current_iota
		message += " (count: [length(clist.coord_list)])"
	else if(data.current_iota.what_am_i == "mob")
		var/datum/spell_value/mob/m = data.current_iota
		message += " ([m.the_mob])"

	to_chat(data.caster, span_notice(message))
	return TRUE

/datum/spell_operation/copy
	word = "effingo"

/datum/spell_operation/copy/activate(datum/incantation_data/data)
	data.push_iota(data.current_iota)
	return TRUE

/datum/spell_operation/copy_last
	word = "ruptis"

/datum/spell_operation/copy_last/activate(datum/incantation_data/data)
	var/datum/spell_value/number/new_iota = data.peek_stack(0)
	data.push_iota(new_iota)
	return TRUE

/datum/spell_operation/flip_sign
	word = "inversus"

/datum/spell_operation/flip_sign/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE
	var/datum/spell_value/number/n = data.current_iota
	n.num = -n.num
	return TRUE

/datum/spell_operation/add_nums
	word = "summa"

/datum/spell_operation/add_nums/activate(datum/incantation_data/data)
	var/datum/spell_value/number/first = data.pop_iota()

	if(!first || first.what_am_i != "number" || !data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/second = data.current_iota
	data.current_iota = new /datum/spell_value/number(first.num + second.num)
	return TRUE

/datum/spell_operation/times_nums
	word = "multiplicatio"

/datum/spell_operation/times_nums/activate(datum/incantation_data/data)
	var/datum/spell_value/number/first = data.pop_iota()

	if(!first || first.what_am_i != "number" || !data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/second = data.current_iota
	data.current_iota = new /datum/spell_value/number(first.num * second.num)
	return TRUE

/datum/spell_operation/shift_x
	word = "motus-x"

/datum/spell_operation/shift_x/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.what_am_i != "coords")
		return FALSE

	base_pos.x_pos += offset.num
	data.current_iota = base_pos
	return TRUE

/datum/spell_operation/shift_y
	word = "motus-y"

/datum/spell_operation/shift_y/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.what_am_i != "coords")
		return FALSE

	base_pos.y_pos += offset.num
	data.current_iota = base_pos
	return TRUE

/datum/spell_operation/shift_z
	word = "motus-z"

/datum/spell_operation/shift_z/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.what_am_i != "coords")
		return FALSE

	base_pos.z_pos += offset.num
	data.current_iota = base_pos
	return TRUE

/datum/spell_operation/make_area
	word = "regio"

/datum/spell_operation/make_area/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	var/turf/center_spot

	if(data.current_iota.what_am_i == "turf")
		var/datum/spell_value/tile/t = data.current_iota
		center_spot = t.the_turf
	else if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		center_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	else
		return FALSE

	var/how_far = 1
	var/datum/spell_value/number/range_iota = data.peek_stack(0)
	if(range_iota && range_iota.what_am_i == "number")
		how_far = range_iota.num
		data.pop_iota()

	var/datum/spell_value/coord_list/coords = new()
	for(var/turf/T in range(how_far, center_spot))
		coords.add(new /datum/spell_value/position(T.x, T.y, T.z))

	data.current_iota = coords
	return TRUE

/datum/spell_operation/find_people
	word = "homines"

/datum/spell_operation/find_people/activate(datum/incantation_data/data)
	var/turf/search_spot

	if(data.current_iota && data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		search_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	else
		search_spot = get_turf(data.caster)

	if(!search_spot)
		return FALSE

	var/how_far = 7
	var/datum/spell_value/number/range_iota = data.peek_stack(0)
	if(range_iota && range_iota.what_am_i == "number")
		how_far = min(max(range_iota.num, 0), 7)
		data.pop_iota()

	var/datum/spell_value/people/victims = new()
	for(var/mob/living/carbon/human/L in hearers(how_far, search_spot))
		if(L == data.caster)
			continue
		if(L.stat == DEAD)
			continue
		victims.add(L)

	data.current_iota = victims
	return TRUE

/datum/spell_command
	var/word = ""
	var/fatiguecost = 20
	var/obj/effect/proc_holder/spell/needs_spell = null

/datum/spell_command/proc/activate(datum/incantation_data/data)
	var/tired_left = data.caster.max_stamina - data.caster.stamina
	if(tired_left < fatiguecost)
		to_chat(data.caster, span_warning("Too tired!"))
		return FALSE
	return do_spell(data)

/datum/spell_command/proc/do_spell(datum/incantation_data/data)
	return FALSE

/datum/spell_command/flames
	word = "ignis"
	fatiguecost = 25
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball

/datum/spell_command/flames/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = 0
	var/datum/spell_value/number/power_iota = data.peek_stack(0)
	if(power_iota && power_iota.what_am_i == "number")
		strength = min(max(power_iota.num, 0), 2)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/fire_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_fire_damage), spots, strength), 1.5 SECONDS)
	return TRUE

/datum/spell_command/flames/proc/do_fire_damage(list/turfs, strength)
	var/flame_strength = min(strength, 2)
	for(var/turf/T in turfs)
		explosion(T, -1, 0, strength, strength + 1, 0, flame_range = flame_strength)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			L.adjust_fire_stacks(1 + strength)
			if(L.fire_stacks > 0)
				L.fire_act(1, 5)
			L.adjustFireLoss(15 + (strength * 10))

/datum/spell_command/lightning
	word = "fulmen"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/thunderstrike

/datum/spell_command/lightning/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = 0
	var/datum/spell_value/number/power_iota = data.peek_stack(0)
	if(power_iota && power_iota.what_am_i == "number")
		strength = min(max(power_iota.num, 0), 2)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/lightning_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_zap_damage), spots, strength), 1 SECONDS)
	return TRUE

/datum/spell_command/lightning/proc/do_zap_damage(list/turfs, strength)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/spell_visual/lightning_strike(T)
		playsound(T, 'sound/magic/lightning.ogg', 100)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			L.electrocute_act(30 + (strength * 20), L, 1, SHOCK_NOSTUN)

/datum/spell_command/teleport
	word = "teleporto"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/blink

/datum/spell_command/teleport/do_spell(datum/incantation_data/data)
	var/datum/spell_value/position/end_pos = data.current_iota
	var/datum/spell_value/position/start_pos = data.pop_iota()

	if(!start_pos || start_pos.what_am_i != "coords" || !end_pos || end_pos.what_am_i != "coords")
		to_chat(data.caster, span_warning("Need two coordinates!"))
		return FALSE

	var/turf/start_spot = locate(start_pos.x_pos, start_pos.y_pos, start_pos.z_pos)
	var/turf/end_spot = locate(end_pos.x_pos, end_pos.y_pos, end_pos.z_pos)

	if(!start_spot || !end_spot)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	if(get_dist(caster_spot, start_spot) > 14 || get_dist(caster_spot, end_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(get_dist(start_spot, end_spot) > 14)
		to_chat(data.caster, span_warning("Teleport distance too far!"))
		return FALSE

	if(!data.can_see_through(caster_spot, start_spot) || !data.can_see_through(caster_spot, end_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	new /obj/effect/temp_visual/spell_visual/blink_warning(start_spot)
	new /obj/effect/temp_visual/spell_visual/blink_warning(end_spot)

	addtimer(CALLBACK(src, PROC_REF(perform_teleport), start_spot, end_spot, data.caster.dir), 1 SECONDS)
	return TRUE

/datum/spell_command/teleport/proc/perform_teleport(turf/start_spot, turf/end_spot, caster_dir)
	var/obj/spot_one = new /obj/effect/temp_visual/blink_phase(start_spot, caster_dir)
	var/obj/spot_two = new /obj/effect/temp_visual/blink_phase(end_spot, caster_dir)

	spot_one.Beam(spot_two, "purple_lightning", time = 1.5 SECONDS)
	playsound(start_spot, 'sound/magic/blink.ogg', 100)
	playsound(end_spot, 'sound/magic/blink.ogg', 100)

	for(var/mob/M in start_spot.contents)
		if(M.buckled)
			M.buckled.unbuckle_mob(M, TRUE)
		do_teleport(M, end_spot, channel = TELEPORT_CHANNEL_MAGIC)

	for(var/obj/item/I in start_spot.contents)
		I.forceMove(end_spot)

/datum/spell_command/crush
	word = "pondus"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/gravity

/datum/spell_command/crush/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/strength = 0
	var/datum/spell_value/number/power_iota = data.peek_stack(0)
	if(power_iota && power_iota.what_am_i == "number")
		strength = min(max(power_iota.num, 0), 2)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/gravity_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_gravity_damage), spots, strength), 1 SECONDS)
	return TRUE

/datum/spell_command/crush/proc/do_gravity_damage(list/turfs, strength)
	for(var/turf/T in turfs)
		new /obj/effect/temp_visual/spell_visual/gravity_crush(T)
		playsound(T, 'sound/magic/gravity.ogg', 100)

		for(var/mob/living/L in T.contents)
			if(L.anti_magic_check())
				continue
			if(L.STASTR <= 15)
				L.adjustBruteLoss(30 + (strength * 15))
				L.Knockdown(2 + strength)
			else
				L.adjustBruteLoss(10 + (strength * 5))
				L.OffBalance(5 + (strength * 2))

/datum/spell_command/fix_item
	word = "reficio"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/mending

/datum/spell_command/fix_item/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "item")
		return FALSE

	var/datum/spell_value/item_thing/item_val = data.current_iota
	var/obj/item/target_item = item_val.the_item

	if(!target_item)
		return FALSE

	var/turf/item_spot = get_turf(target_item)
	var/turf/caster_spot = get_turf(data.caster)

	if(get_dist(caster_spot, item_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, item_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	if(!target_item.anvilrepair && !target_item.sewrepair)
		return FALSE

	if(target_item.obj_integrity >= target_item.max_integrity)
		return FALSE

	var/strength = 1
	var/datum/spell_value/number/power_iota = data.peek_stack(0)
	if(power_iota && power_iota.what_am_i == "number")
		strength = min(max(power_iota.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	var/heal_amount = target_item.max_integrity * (0.2 * strength)
	target_item.obj_integrity = min(target_item.obj_integrity + heal_amount, target_item.max_integrity)

	if(target_item.obj_integrity >= target_item.max_integrity && target_item.obj_broken)
		target_item.obj_fix()

	playsound(target_item, 'sound/foley/sewflesh.ogg', 50)
	return TRUE

/datum/spell_command/store_iota
	word = "scribo"
	fatiguecost = 5
	needs_spell = null

/datum/spell_command/store_iota/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "item")
		return FALSE

	var/datum/spell_value/item_thing/item_iota = data.current_iota
	if(!istype(item_iota.the_item, /obj/item/memory_string))
		return FALSE

	var/obj/item/memory_string/memory = item_iota.the_item
	var/datum/spell_value/value_to_store = data.pop_iota()
	if(!value_to_store)
		return FALSE

	var/turf/item_spot = get_turf(memory)
	var/turf/caster_spot = get_turf(data.caster)

	if(get_dist(caster_spot, item_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, item_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	memory.iota = value_to_store
	data.current_iota = item_iota
	return TRUE

/datum/spell_command/push_away
	word = "obmolior"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/repulse

/datum/spell_command/push_away/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)

	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/how_far = 1
	var/datum/spell_value/number/distance_iota = data.peek_stack(0)
	if(distance_iota && distance_iota.what_am_i == "number")
		how_far = min(max(distance_iota.num, 1), 5)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/push_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_push), spots, how_far, data.caster), 1 SECONDS)
	return TRUE

/datum/spell_command/push_away/proc/do_push(list/spots, how_far, mob/living/caster)
	playsound(caster, 'sound/magic/repulse.ogg', 80)
	for(var/turf/T in spots)
		var/atom/throw_spot = get_edge_target_turf(caster, get_dir(caster, get_step_away(T, caster)))
		for(var/mob/living/M in T.contents)
			M.set_resting(TRUE, TRUE)
			M.safe_throw_at(throw_spot, how_far, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)
		for(var/obj/item/I in T.contents)
			I.safe_throw_at(throw_spot, how_far, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/spell_command/pull_close
	word = "recolligere"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/projectile/fetch

/datum/spell_command/pull_close/do_spell(datum/incantation_data/data)
	var/list/spots = list()

	if(!data.current_iota)
		return FALSE

	if(data.current_iota.what_am_i == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/turf/T = locate(pos.x_pos, pos.y_pos, pos.z_pos)
		if(T) spots = list(T)
	else
		return FALSE

	if(!length(spots))
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)

	for(var/turf/T in spots)
		if(get_dist(caster_spot, T) > 14)
			to_chat(data.caster, span_warning("Too far away!"))
			return FALSE
		if(!data.can_see_through(caster_spot, T))
			to_chat(data.caster, span_warning("Cannot see through walls!"))
			return FALSE

	var/how_far = 1
	var/datum/spell_value/number/distance_iota = data.peek_stack(0)
	if(distance_iota && distance_iota.what_am_i == "number")
		how_far = min(max(distance_iota.num, 1), 5)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	for(var/turf/T in spots)
		new /obj/effect/temp_visual/spell_visual/pull_warning(T)

	addtimer(CALLBACK(src, PROC_REF(do_pull), spots, how_far, data.caster), 1 SECONDS)
	return TRUE

/datum/spell_command/pull_close/proc/do_pull(list/spots, how_far, mob/living/caster)
	playsound(caster, 'sound/magic/repulse.ogg', 80)
	for(var/turf/T in spots)
		var/atom/throw_spot = get_step_towards(caster, T)
		for(var/mob/living/M in T.contents)
			M.set_resting(TRUE, TRUE)
			M.safe_throw_at(throw_spot, how_far, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)
		for(var/obj/item/I in T.contents)
			I.safe_throw_at(throw_spot, how_far, 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/spell_command/make_wall
	word = "murus"
	fatiguecost = 10
	needs_spell = /obj/effect/proc_holder/spell/invoked/forcewall

/datum/spell_command/make_wall/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "coords")
		return FALSE

	var/datum/spell_value/position/pos = data.current_iota
	var/turf/wall_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)

	if(!wall_spot)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	if(get_dist(caster_spot, wall_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	if(!data.can_see_through(caster_spot, wall_spot))
		to_chat(data.caster, span_warning("Cannot see through walls!"))
		return FALSE

	data.caster.stamina_add(fatiguecost)

	var/list/wall_turfs = list(wall_spot)
/*
	if(data.caster.dir == SOUTH || data.caster.dir == NORTH)
		wall_turfs += get_step(wall_spot, WEST)
		wall_turfs += get_step(wall_spot, EAST)
	else
		wall_turfs += get_step(wall_spot, NORTH)
		wall_turfs += get_step(wall_spot, SOUTH)
*/

	for(var/turf/T in wall_turfs)
		new /obj/effect/temp_visual/spell_visual/wall_warning(T)
		addtimer(CALLBACK(src, PROC_REF(make_wall_piece), T, data.caster), 1 SECONDS)

	return TRUE

/datum/spell_command/make_wall/proc/make_wall_piece(turf/T, mob/caster)
	new /obj/structure/forcefield_weak(T, caster)

/datum/spell_command/buff_strength
	word = "vis"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/giants_strength

/datum/spell_command/buff_strength/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = 1
	var/datum/spell_value/number/power = data.peek_stack(0)
	if(power && power.what_am_i == "number")
		bonus = min(max(power.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_strength, bonus)
	return TRUE

/datum/spell_command/buff_constitution
	word = "saxum"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/stoneskin

/datum/spell_command/buff_constitution/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = 1
	var/datum/spell_value/number/power = data.peek_stack(0)
	if(power && power.what_am_i == "number")
		bonus = min(max(power.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_constitution, bonus)
	return TRUE

/datum/spell_command/buff_speed
	word = "festinatio"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/haste

/datum/spell_command/buff_speed/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = 1
	var/datum/spell_value/number/power = data.peek_stack(0)
	if(power && power.what_am_i == "number")
		bonus = min(max(power.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_speed, bonus)
	return TRUE

/datum/spell_command/buff_perception
	word = "oculi"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/hawks_eyes

/datum/spell_command/buff_perception/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = 1
	var/datum/spell_value/number/power = data.peek_stack(0)
	if(power && power.what_am_i == "number")
		bonus = min(max(power.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_perception, bonus)
	return TRUE

/datum/spell_command/buff_endurance
	word = "tenax"
	fatiguecost = 20
	needs_spell = /obj/effect/proc_holder/spell/invoked/fortitude

/datum/spell_command/buff_endurance/do_spell(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.what_am_i != "mob")
		return FALSE

	var/datum/spell_value/mob/mob_iota = data.current_iota
	var/mob/living/target = mob_iota.the_mob

	if(!target)
		return FALSE

	var/turf/caster_spot = get_turf(data.caster)
	var/turf/target_spot = get_turf(target)
	if(get_dist(caster_spot, target_spot) > 14)
		to_chat(data.caster, span_warning("Too far away!"))
		return FALSE

	var/bonus = 1
	var/datum/spell_value/number/power = data.peek_stack(0)
	if(power && power.what_am_i == "number")
		bonus = min(max(power.num, 1), 3)
		data.pop_iota()

	data.caster.stamina_add(fatiguecost)

	playsound(target_spot, 'sound/magic/haste.ogg', 80, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/circuitus_endurance, bonus)
	return TRUE

/obj/effect/temp_visual/spell_visual
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/spell_visual/fire_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	light_color = "#f8af07"
	duration = 1.5 SECONDS

/obj/effect/temp_visual/spell_visual/lightning_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	light_color = "#a8d3ff"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/lightning_strike
	icon = 'icons/effects/32x96.dmi'
	icon_state = "lightning"
	light_outer_range = 3
	duration = 0.5 SECONDS

/obj/effect/temp_visual/spell_visual/gravity_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = "#a090c0"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/gravity_crush
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/wall_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-flash"
	light_outer_range = 2
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/push_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2"
	light_outer_range = 2
	light_color = "#ff6666"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/pull_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2"
	light_outer_range = 2
	light_color = "#6666ff"
	duration = 1 SECONDS

/obj/effect/temp_visual/spell_visual/blink_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY
	duration = 1 SECONDS

/obj/effect/temp_visual/blink_phase
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_blast"
	light_outer_range = 2
	light_color = COLOR_PALE_PURPLE_GRAY
	duration = 1.5 SECONDS
	layer = MASSIVE_OBJ_LAYER

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
	"homines" = new /datum/spell_operation/find_people()
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
	"tenax" = new /datum/spell_command/buff_endurance()
))

/datum/status_effect/buff/circuitus_strength
	id = "circuitus_strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_strength
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_strength/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_STR = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_strength
	name = "Giant's Strength"
	desc = "My muscles are strengthened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_constitution
	id = "circuitus_constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_constitution
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_constitution/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_CON = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_constitution
	name = "Stoneskin"
	desc = "My skin is hardened like stone."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_speed
	id = "circuitus_speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_speed
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_speed/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_SPD = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_speed
	name = "Haste"
	desc = "I am magically hastened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_perception
	id = "circuitus_perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_perception
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_perception/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_PER = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_perception
	name = "Hawk's Eyes"
	desc = "My vision is sharpened."
	icon_state = "buff"

/datum/status_effect/buff/circuitus_endurance
	id = "circuitus_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/circuitus_endurance
	duration = 20 SECONDS

/datum/status_effect/buff/circuitus_endurance/on_creation(mob/living/new_owner, bonus = 1)
	effectedstats = list(STATKEY_END = bonus)
	return ..()

/atom/movable/screen/alert/status_effect/buff/circuitus_endurance
	name = "Fortitude"
	desc = "My humors has been hardened to the fatigues of the body."
	icon_state = "buff"

