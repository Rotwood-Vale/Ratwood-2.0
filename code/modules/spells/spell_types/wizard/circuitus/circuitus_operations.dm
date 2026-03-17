/datum/spell_value
	var/value_type = "nothing"

/datum/spell_value/proc/copy()
	return src

/datum/spell_value/number
	value_type = "number"
	var/num = 0

/datum/spell_value/number/New(n)
	num = n

/datum/spell_value/number/copy()
	return new /datum/spell_value/number(num)

/datum/spell_value/position
	value_type = "coords"
	var/x_pos = 0
	var/y_pos = 0
	var/z_pos = 0

/datum/spell_value/position/New(x, y, z)
	x_pos = x
	y_pos = y
	z_pos = z

/datum/spell_value/position/copy()
	return new /datum/spell_value/position(x_pos, y_pos, z_pos)

/datum/spell_value/tile
	value_type = "turf"
	var/turf/the_turf = null

/datum/spell_value/tile/New(turf/T)
	the_turf = T

/datum/spell_value/tile_group
	value_type = "area"
	var/list/turfs = list()

/datum/spell_value/tile_group/New()
	turfs = list()

/datum/spell_value/tile_group/proc/add(turf/T)
	if(T && !(T in turfs))
		turfs += T

/datum/spell_value/people
	value_type = "moblist"
	var/list/mob_list = list()

/datum/spell_value/people/New()
	mob_list = list()

/datum/spell_value/people/proc/add(mob/M)
	if(M && !(M in mob_list))
		mob_list += M

/datum/spell_value/mob
	value_type = "mob"
	var/mob/living/the_mob = null

/datum/spell_value/mob/New(mob/living/M)
	the_mob = M

/datum/spell_value/mob/copy()
	return new /datum/spell_value/mob(the_mob)

/datum/spell_value/coord_list
	value_type = "coordlist"
	var/list/coord_list = list()

/datum/spell_value/coord_list/New()
	coord_list = list()

/datum/spell_value/coord_list/proc/add(datum/spell_value/position/pos)
	if(pos)
		coord_list += pos

/datum/spell_value/item_thing
	value_type = "item"
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
	data.push_iota(new /datum/spell_value/position(data.target_location.x, data.target_location.y, data.target_location.z))
	return TRUE

/datum/spell_operation/to_coords
	word = "coordinatus"

/datum/spell_operation/to_coords/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE

	if(data.current_iota.value_type == "turf")
		var/datum/spell_value/tile/t = data.current_iota
		data.current_iota = new /datum/spell_value/position(t.the_turf.x, t.the_turf.y, t.the_turf.z)
		return TRUE
	else if(data.current_iota.value_type == "coords")
		return TRUE
	else if(data.current_iota.value_type == "mob")
		var/datum/spell_value/mob/mob_iota = data.current_iota
		var/turf/T = get_turf(mob_iota.the_mob)
		if(T)
			data.current_iota = new /datum/spell_value/position(T.x, T.y, T.z)
			return TRUE
		return FALSE
	else if(data.current_iota.value_type == "moblist")
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
	if(!data.current_iota || data.current_iota.value_type != "coords")
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
	if(!data.current_iota || data.current_iota.value_type != "coords")
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
	if(!data.current_iota || data.current_iota.value_type != "coords")
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

	if(!first || first.value_type != "coords" || !data.current_iota || data.current_iota.value_type != "coords")
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

	if(base_list.value_type == "moblist" && item_to_add.value_type == "mob")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/mob/m = item_to_add
		list1.add(m.the_mob)
		data.current_iota = list1
		return TRUE
	else if(base_list.value_type == "moblist" && item_to_add.value_type == "moblist")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/people/list2 = item_to_add
		for(var/mob/M in list2.mob_list)
			list1.add(M)
		data.current_iota = list1
		return TRUE
	else if(base_list.value_type == "coordlist" && item_to_add.value_type == "coords")
		var/datum/spell_value/coord_list/clist = base_list
		var/datum/spell_value/position/pos = item_to_add
		clist.add(pos)
		data.current_iota = clist
		return TRUE
	else if(base_list.value_type == "coordlist" && item_to_add.value_type == "coordlist")
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

	if(base_list.value_type == "moblist" && item_to_remove.value_type == "mob")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/mob/m = item_to_remove
		list1.mob_list -= m.the_mob
		data.current_iota = list1
		return TRUE
	else if(base_list.value_type == "moblist" && item_to_remove.value_type == "moblist")
		var/datum/spell_value/people/list1 = base_list
		var/datum/spell_value/people/list2 = item_to_remove
		for(var/mob/M in list2.mob_list)
			list1.mob_list -= M
		data.current_iota = list1
		return TRUE
	else if(base_list.value_type == "coordlist" && item_to_remove.value_type == "coords")
		var/datum/spell_value/coord_list/clist = base_list
		var/datum/spell_value/position/pos = item_to_remove
		clist.coord_list -= pos
		data.current_iota = clist
		return TRUE
	else if(base_list.value_type == "coordlist" && item_to_remove.value_type == "coordlist")
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

	if(data.current_iota.value_type == "moblist")
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
	else if(data.current_iota.value_type == "coordlist")
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

	if(first.value_type == "coords" && data.current_iota.value_type == "coords")
		var/datum/spell_value/position/p1 = first
		var/datum/spell_value/position/p2 = data.current_iota
		data.current_iota = new /datum/spell_value/position(
			p1.x_pos + p2.x_pos,
			p1.y_pos + p2.y_pos,
			p1.z_pos + p2.z_pos
		)
		return TRUE
	else if(first.value_type == "coordlist" && data.current_iota.value_type == "coordlist")
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

	if(first.value_type == "coords" && data.current_iota.value_type == "coords")
		var/datum/spell_value/position/p1 = first
		var/datum/spell_value/position/p2 = data.current_iota
		data.current_iota = new /datum/spell_value/position(
			p2.x_pos - p1.x_pos,
			p2.y_pos - p1.y_pos,
			p2.z_pos - p1.z_pos
		)
		return TRUE
	else if(first.value_type == "coordlist" && data.current_iota.value_type == "coordlist")
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
	if(!data.current_iota || data.current_iota.value_type != "number")
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

	if(data.current_iota.value_type == "moblist")
		var/datum/spell_value/people/victims = data.current_iota
		for(var/mob/M in victims.mob_list)
			items_to_iterate += new /datum/spell_value/mob(M)
	else if(data.current_iota.value_type == "coordlist")
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

	var/list/loop_words = list()
	for(var/wi = loop_start, wi <= length(data.words), wi++)
		var/lw = data.words[wi]
		if(lw in GLOB.spell_command_list)
			loop_words += "[uppertext(lw)]!"
			break
		else
			loop_words += uppertext(lw)
	var/list/full_display = data.spoken_so_far.Copy()
	full_display += loop_words
	data.show_runechat(full_display.Join(" "))
	data.suppress_runechat = TRUE

	var/any_succeeded = FALSE
	for(var/datum/spell_value/item in items_to_iterate)
		data.current_iota = item
		var/iter_ok = TRUE

		for(var/word_idx = loop_start, word_idx <= length(data.words), word_idx++)
			var/word = data.words[word_idx]

			if(word in GLOB.spell_command_list)
				if(!data.do_spell_command(word))
					iter_ok = FALSE
				break
			else
				if(!data.do_operation(word))
					iter_ok = FALSE
					break

		if(iter_ok)
			any_succeeded = TRUE

	data.in_loop = FALSE
	data.suppress_runechat = FALSE
	data.current_iota = backup_iota
	return any_succeeded

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

/datum/spell_operation/make_coordlist/activate(datum/incantation_data/data)
	if(!data.current_iota)
		var/datum/spell_value/coord_list/new_list = new()
		data.push_iota(new_list)
		return TRUE

	if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		var/datum/spell_value/coord_list/new_list = new()
		new_list.add(pos)
		data.current_iota = new_list
		return TRUE
	else if(data.current_iota.value_type == "mob")
		var/datum/spell_value/mob/m = data.current_iota
		var/datum/spell_value/people/new_list = new()
		new_list.add(m.the_mob)
		data.current_iota = new_list
		return TRUE
	else if(data.current_iota.value_type == "coordlist" || data.current_iota.value_type == "moblist")
		return TRUE
	else
		return FALSE

/datum/spell_operation/retrieve_iota
	word = "lego"

/datum/spell_operation/retrieve_iota/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "item")
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
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/index = data.current_iota
	var/datum/spell_value/the_list = data.pop_iota()

	if(!the_list)
		return FALSE

	var/idx = max(1, index.num)

	if(the_list.value_type == "moblist")
		var/datum/spell_value/people/mlist = the_list
		if(idx > length(mlist.mob_list))
			return FALSE
		data.current_iota = new /datum/spell_value/mob(mlist.mob_list[idx])
		return TRUE
	else if(the_list.value_type == "coordlist")
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
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/depth = data.current_iota
	var/datum/spell_value/retrieved = data.peek_stack(depth.num)

	if(!retrieved)
		return FALSE

	data.current_iota = retrieved.copy()
	return TRUE

/datum/spell_operation/line_coords
	word = "linea"

/datum/spell_operation/line_coords/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "coords")
		return FALSE

	var/datum/spell_value/position/end_pos = data.current_iota
	var/datum/spell_value/position/start_pos = data.pop_iota()

	if(!start_pos || start_pos.value_type != "coords")
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

	var/message = "Current iota: [data.current_iota.value_type]"

	if(data.current_iota.value_type == "number")
		var/datum/spell_value/number/n = data.current_iota
		message += " ([n.num])"
	else if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		message += " ([pos.x_pos], [pos.y_pos], [pos.z_pos])"
	else if(data.current_iota.value_type == "moblist")
		var/datum/spell_value/people/ppl = data.current_iota
		message += " (count: [length(ppl.mob_list)])"
	else if(data.current_iota.value_type == "coordlist")
		var/datum/spell_value/coord_list/clist = data.current_iota
		message += " (count: [length(clist.coord_list)])"
	else if(data.current_iota.value_type == "mob")
		var/datum/spell_value/mob/m = data.current_iota
		message += " ([m.the_mob])"

	to_chat(data.caster, span_notice(message))
	return TRUE

/datum/spell_operation/copy
	word = "effingo"

/datum/spell_operation/copy/activate(datum/incantation_data/data)
	if(!data.current_iota)
		return FALSE
	data.push_iota(data.current_iota.copy())
	return TRUE

/datum/spell_operation/copy_last
	word = "ruptis"

/datum/spell_operation/copy_last/activate(datum/incantation_data/data)
	var/datum/spell_value/top = data.peek_stack(0)
	if(!top)
		return FALSE
	data.push_iota(top.copy())
	return TRUE

/datum/spell_operation/flip_sign
	word = "inversus"

/datum/spell_operation/flip_sign/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE
	var/datum/spell_value/number/n = data.current_iota
	n.num = -n.num
	return TRUE

/datum/spell_operation/add_nums
	word = "summa"

/datum/spell_operation/add_nums/activate(datum/incantation_data/data)
	var/datum/spell_value/number/first = data.pop_iota()

	if(!first || first.value_type != "number" || !data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/second = data.current_iota
	data.current_iota = new /datum/spell_value/number(first.num + second.num)
	return TRUE

/datum/spell_operation/times_nums
	word = "multiplicatio"

/datum/spell_operation/times_nums/activate(datum/incantation_data/data)
	var/datum/spell_value/number/first = data.pop_iota()

	if(!first || first.value_type != "number" || !data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/second = data.current_iota
	data.current_iota = new /datum/spell_value/number(first.num * second.num)
	return TRUE

/datum/spell_operation/shift_x
	word = "motus-x"

/datum/spell_operation/shift_x/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.value_type != "coords")
		return FALSE

	base_pos.x_pos += offset.num
	data.current_iota = base_pos
	return TRUE

/datum/spell_operation/shift_y
	word = "motus-y"

/datum/spell_operation/shift_y/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.value_type != "coords")
		return FALSE

	base_pos.y_pos += offset.num
	data.current_iota = base_pos
	return TRUE

/datum/spell_operation/shift_z
	word = "motus-z"

/datum/spell_operation/shift_z/activate(datum/incantation_data/data)
	if(!data.current_iota || data.current_iota.value_type != "number")
		return FALSE

	var/datum/spell_value/number/offset = data.current_iota
	var/datum/spell_value/position/base_pos = data.pop_iota()

	if(!base_pos || base_pos.value_type != "coords")
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

	if(data.current_iota.value_type == "turf")
		var/datum/spell_value/tile/t = data.current_iota
		center_spot = t.the_turf
	else if(data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		center_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	else
		return FALSE

	var/how_far = 1
	var/datum/spell_value/number/range_iota = data.peek_stack(0)
	if(range_iota && range_iota.value_type == "number")
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

	if(data.current_iota && data.current_iota.value_type == "coords")
		var/datum/spell_value/position/pos = data.current_iota
		search_spot = locate(pos.x_pos, pos.y_pos, pos.z_pos)
	else
		search_spot = get_turf(data.caster)

	if(!search_spot)
		return FALSE

	var/how_far = 7
	var/datum/spell_value/number/range_iota = data.peek_stack(0)
	if(range_iota && range_iota.value_type == "number")
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
