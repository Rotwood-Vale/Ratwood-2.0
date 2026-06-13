GLOBAL_LIST(admin_objective_list) //Prefilled admin assignable objective list

/datum/objective
	var/datum/mind/owner				//The primary owner of the objective. !!SOMEWHAT DEPRECATED!! Prefer using 'team' for new code.
	var/datum/team/team					//An alternative to 'owner': a team. Use this when writing new code.
	var/name = "通用目标" 		//Name for admin prompts
	var/explanation_text = "无"	//What that person is supposed to do.
	var/team_explanation_text			//For when there are multiple owners.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.
	var/martyr_compatible = 0			//If the objective is compatible with martyr objective, i.e. if you can still do it while dead.
	var/triumph_count = 1
	var/flavor = "目标"

/datum/objective/New(text, datum/mind/owner)
	if(text)
		explanation_text = text
	if(owner)
		src.owner = owner
	on_creation()

/datum/objective/proc/on_creation()
	if(owner && !(owner in GLOB.personal_objective_minds))
		GLOB.personal_objective_minds |= owner
	return

/datum/objective/proc/get_owners() // Combine owner and team into a single list.
	. = (team && team.members) ? team.members.Copy() : list()
	if(owner)
		. += owner

/datum/objective/proc/escalate_objective(event_track = EVENT_TRACK_PERSONAL, second_event_track = EVENT_TRACK_INTERVENTION)
	if(event_track)
		var/first_points_to_add = SSgamemode.point_thresholds[event_track] * rand(0.5, 0.75)
		SSgamemode.event_track_points[event_track] += first_points_to_add
	if(second_event_track)
		var/second_points_to_add = SSgamemode.point_thresholds[second_event_track] * rand(0.05, 0.1)
		SSgamemode.event_track_points[second_event_track] += second_points_to_add

/datum/objective/proc/admin_edit(mob/admin)
	return

//Shared by few objective types
/datum/objective/proc/admin_simple_target_pick(mob/admin)
	var/list/possible_targets = list("Free objective","Random")
	var/def_value
	for(var/datum/mind/possible_target in SSticker.minds)
		if ((possible_target != src) && ishuman(possible_target.current))
			possible_targets += possible_target.current


	if(target && target.current)
		def_value = target.current

	var/mob/new_target = input(admin,"Select target:", "Objective target", def_value) as null|anything in sortNames(possible_targets)
	if (!new_target)
		return

	if (new_target == "Free objective")
		target = null
	else if (new_target == "Random")
		find_target()
	else
		target = new_target.mind

	update_explanation_text()

/datum/objective/proc/considered_escaped(datum/mind/M)
	if(!considered_alive(M))
		return FALSE
	if(M.force_escaped)
		return TRUE
	var/area/A = get_area(M.current)
	if(istype(A, /area/rogue/indoors/town/cell))
		return FALSE
	return TRUE

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/is_unique_objective(possible_target, dupe_search_range)
	if(!islist(dupe_search_range))
		stack_trace("Non-list passed as duplicate objective search range")
		dupe_search_range = list(dupe_search_range)

	for(var/A in dupe_search_range)
		var/list/objectives_to_compare
		if(istype(A,/datum/mind))
			var/datum/mind/M = A
			objectives_to_compare = M.get_all_objectives()
		else if(istype(A,/datum/antagonist))
			var/datum/antagonist/G = A
			objectives_to_compare = G.objectives
		else if(istype(A,/datum/team))
			var/datum/team/T = A
			objectives_to_compare = T.objectives
		for(var/datum/objective/O in objectives_to_compare)
			if(istype(O, type) && O.get_target() == possible_target)
				return FALSE
	return TRUE

/datum/objective/proc/get_target()
	return target

/datum/objective/proc/get_crewmember_minds()
	. = list()
	for(var/V in GLOB.data_core.locked)
		var/datum/data/record/R = V
		var/datum/mind/M = R.fields["mindref"]
		if(M)
			. += M

//dupe_search_range is a list of antag datums / minds / teams
/datum/objective/proc/find_target(dupe_search_range, blacklist)
	var/list/datum/mind/owners = get_owners()
	if(!dupe_search_range)
		dupe_search_range = get_owners()
	var/list/possible_targets = list()
	var/try_target_late_joiners = FALSE
	for(var/I in owners)
		var/datum/mind/O = I
		if(O.late_joiner)
			try_target_late_joiners = TRUE
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(!(possible_target in owners) && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && is_unique_objective(possible_target,dupe_search_range))
			if (!(possible_target in blacklist))
				possible_targets += possible_target
	if(try_target_late_joiners)
		var/list/all_possible_targets = possible_targets.Copy()
		for(var/I in all_possible_targets)
			var/datum/mind/PT = I
			if(!PT.late_joiner)
				possible_targets -= PT
		if(!possible_targets.len)
			possible_targets = all_possible_targets
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/proc/find_target_by_role(role, role_type=FALSE,invert=FALSE)//Option sets either to check assigned role or special role. Default to assigned., invert inverts the check, eg: "Don't choose a Ling"
	var/list/datum/mind/owners = get_owners()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(!(possible_target in owners) && ishuman(possible_target.current))
			var/is_role = FALSE
			if(role_type)
				if(possible_target.special_role == role)
					is_role = TRUE
			else
				if(possible_target.assigned_role == role)
					is_role = TRUE

			if(invert)
				if(is_role)
					continue
				possible_targets += possible_target
				break
			else if(is_role)
				possible_targets += possible_target
				break
	if(length(possible_targets))
		target = pick(possible_targets)
	update_explanation_text()
	return target

/datum/objective/proc/update_explanation_text()
	if(team_explanation_text && LAZYLEN(get_owners()) > 1)
		explanation_text = team_explanation_text

/datum/objective/proc/give_special_equipment(special_equipment)
	var/datum/mind/receiver = pick(get_owners())
	if(receiver && receiver.current)
		if(ishuman(receiver.current))
			var/mob/living/carbon/human/H = receiver.current
			var/list/slots = list("backpack" = SLOT_IN_BACKPACK)
			for(var/eq_path in special_equipment)
				var/obj/O = new eq_path
				H.equip_in_one_of_slots(O, slots)

/datum/objective/assassinate
	name = "刺杀"
	var/target_role_type=FALSE
	martyr_compatible = 0
	triumph_count = 3

/datum/objective/assassinate/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()

/datum/objective/assassinate/check_completion()
	return completed || (!considered_alive(target))

/datum/objective/assassinate/update_explanation_text()
	..()
	if(target && target.current)
			explanation_text = "确保 [target.name] 这名[!target_role_type ? target.assigned_role : target.special_role]被杀死，并在本轮结束前始终保持死亡。若其在回合结束前被复活，你将失败。"

/datum/objective/assassinate/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/assassinate/internal
	var/stolen = 0 		//Have we already eliminated this target?

/datum/objective/assassinate/internal/update_explanation_text()
	..()
	if(target && !target.current)
		explanation_text = "刺杀 [target.name]，其当前已被彻底毁灭"

/datum/objective/mutiny
	name = "叛乱"
	var/target_role_type=FALSE
	martyr_compatible = 1

/datum/objective/mutiny/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()

/datum/objective/mutiny/check_completion()
	if(!target || !considered_alive(target) || considered_afk(target))
		return TRUE
	var/turf/T = get_turf(target.current)
	return !T || !is_station_level(T.z)

/datum/objective/mutiny/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "刺杀或放逐 [target.name] 这名[!target_role_type ? target.assigned_role : target.special_role]。"
	else
		explanation_text = "自由目标"

/datum/objective/maroon
	name = "流放"
	var/target_role_type=FALSE
	martyr_compatible = 1

/datum/objective/maroon/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()

/datum/objective/maroon/check_completion()
	return !target || !considered_alive(target) || (!target.current.onCentCom())

/datum/objective/maroon/update_explanation_text()
	if(target && target.current)
		explanation_text = "阻止 [target.name] 这名[!target_role_type ? target.assigned_role : target.special_role]活着逃脱。"
	else
		explanation_text = "自由目标"

/datum/objective/maroon/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/debrain
	name = "夺脑"
	var/target_role_type=0

/datum/objective/debrain/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()

/datum/objective/debrain/check_completion()
	if(!target)//If it's a free objective.
		return TRUE
	if(!target.current || !isbrain(target.current))
		return FALSE
	var/atom/A = target.current
	var/list/datum/mind/owners = get_owners()

	while(A.loc) // Check to see if the brainmob is on our person
		A = A.loc
		for(var/datum/mind/M in owners)
			if(M.current && M.current.stat != DEAD && A == M.current)
				return TRUE
	return FALSE

/datum/objective/debrain/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "夺取 [target.name] 这名[!target_role_type ? target.assigned_role : target.special_role]的大脑。"
	else
		explanation_text = "自由目标"

/datum/objective/debrain/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/protect//The opposite of killing a dude.
	name = "保护"
	martyr_compatible = 1
	var/target_role_type = FALSE
	var/human_check = TRUE

/datum/objective/protect/find_target_by_role(role, role_type=FALSE,invert=FALSE)
	if(!invert)
		target_role_type = role_type
	..()
	return target

/datum/objective/protect/check_completion()
	return !target || considered_alive(target, enforce_human = human_check)

/datum/objective/protect/update_explanation_text()
	..()
	if(target && target.current)
		explanation_text = "保护 [target.name] 这名[!target_role_type ? target.assigned_role : target.special_role]。"
	else
		explanation_text = "自由目标"

/datum/objective/protect/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/protect/nonhuman
	name = "保护非人者"
	human_check = FALSE

/datum/objective/escape/prisoner
	name = "越狱"
	explanation_text = "逃离监牢。"
	team_explanation_text = "逃离监牢。"

/datum/objective/escape
	name = "幸存"
	explanation_text = "在不面对审判的情况下存活下来。"
	team_explanation_text = "在不面对审判的情况下存活下来。"

/datum/objective/escape/check_completion()
	// Require all owners escape safely.
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_escaped(M))
			return FALSE
	return TRUE

/datum/objective/marry
	name = "联姻"
	explanation_text = "与本地公爵或女公爵缔结婚姻, 或者与某位王室继承人结婚, 并确保其在周末前加冕。"
	team_explanation_text = "与本地公爵或女公爵缔结婚姻, 或者与某位王室继承人结婚, 并确保其在周末前加冕。"

/datum/objective/marry/check_completion()
	for(var/datum/mind/M in get_owners())
		var/mob/living/carbon/human/marriagepartner = M.current
		marriagepartner = marriagepartner.marriedto
		var/mob/living/carbon/human/the_duke = SSticker.rulermob
		if(the_duke)
			var/duke_name = the_duke.real_name
			if(duke_name && the_duke.real_name == marriagepartner)
				testing("[duke_name] is duke, marriage partner is [marriagepartner]")
				return TRUE
	testing("duke is not marriagepartner")
	return FALSE

/datum/objective/dungeoneer
	name = "看押"
	explanation_text = "让囚犯活着并待在牢房里。"
	team_explanation_text = "让囚犯活着并待在牢房里。"
	var/mob/prisoner

/datum/objective/dungeoneer/check_completion()
	// Require all owners escape safely.
	if(prisoner)
		return TRUE


/datum/objective/escape/escape_with_identity
	name = "冒名逃脱"
	var/target_real_name // Has to be stored because the target's real_name can change over the course of the round
	var/target_missing_id

/datum/objective/escape/escape_with_identity/find_target(dupe_search_range)
	target = ..()
	update_explanation_text()

/datum/objective/escape/escape_with_identity/update_explanation_text()
	if(target && target.current)
		target_real_name = target.current.real_name
		explanation_text = "以 [target_real_name] 这名[target.assigned_role]的身份搭乘穿梭机或逃生舱逃脱"
		var/mob/living/carbon/human/H
		if(ishuman(target.current))
			H = target.current
		if(H && H.get_id_name() != target_real_name)
			target_missing_id = 1
		else
			explanation_text += "，并佩戴其身份卡"
		explanation_text += "." //Proper punctuation is important!

	else
		explanation_text = "自由目标。"

/datum/objective/escape/escape_with_identity/check_completion()
	if(!target || !target_real_name)
		return TRUE
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!ishuman(M.current) || !considered_escaped(M))
			continue
		var/mob/living/carbon/human/H = M.current
		if(H.dna.real_name == target_real_name && (H.get_id_name() == target_real_name || target_missing_id))
			return TRUE
	return FALSE

/datum/objective/escape/escape_with_identity/admin_edit(mob/admin)
	admin_simple_target_pick(admin)

/datum/objective/survive
	name = "幸存"
	explanation_text = "活到最后。"

/datum/objective/survive/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_alive(M))
			return FALSE
	return TRUE

/datum/objective/survive/exist //Like survive, but works for silicons and zombies and such.
	name = "非人幸存"

/datum/objective/survive/exist/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(!considered_alive(M, FALSE))
			return FALSE
	return TRUE

/datum/objective/martyr
	name = "殉道"
	explanation_text = "壮烈赴死。"

/datum/objective/martyr/check_completion()
	var/list/datum/mind/owners = get_owners()
	for(var/datum/mind/M in owners)
		if(considered_alive(M))
			return FALSE
		if(M.current?.suiciding) //killing myself ISN'T glorious.
			return FALSE
	return TRUE

GLOBAL_LIST_EMPTY(possible_items)
/datum/objective/steal
	name = "窃取"
	var/datum/objective_item/targetinfo = null //Save the chosen item datum so we can access it later.
	var/obj/item/steal_target = null //Needed for custom objectives (they're just items, not datums).
	martyr_compatible = 0

/datum/objective/steal/get_target()
	return steal_target

/datum/objective/steal/New()
	..()
	if(!GLOB.possible_items.len)//Only need to fill the list when it's needed.
		for(var/I in subtypesof(/datum/objective_item/steal/rogue))
			new I

/datum/objective/steal/find_target(dupe_search_range)
	var/list/datum/mind/owners = get_owners()
	if(!dupe_search_range)
		dupe_search_range = get_owners()
	var/approved_targets = list()
	check_items:
		for(var/datum/objective_item/possible_item in GLOB.possible_items)
			if(!is_unique_objective(possible_item.targetitem,dupe_search_range))
				continue
			for(var/datum/mind/M in owners)
				if(M.current.mind.assigned_role in possible_item.excludefromjob)
					continue check_items
			approved_targets += possible_item
	return set_target(safepick(approved_targets))

/datum/objective/steal/proc/set_target(datum/objective_item/item)
	if(item)
		targetinfo = item
		steal_target = targetinfo.targetitem
		explanation_text = "窃取[targetinfo.name]"
		give_special_equipment(targetinfo.special_equipment)
		return steal_target
	else
		explanation_text = "自由目标"
		return

/datum/objective/steal/admin_edit(mob/admin)
	var/list/possible_items_all = GLOB.possible_items
	var/new_target = input(admin,"Select target:", "Objective target", steal_target) as null|anything in sortNames(possible_items_all)+"custom"
	if (!new_target)
		return

	if (new_target == "custom") //Can set custom items.
		var/custom_path = input(admin,"Search for target item type:","Type") as null|text
		if (!custom_path)
			return
		var/obj/item/custom_target = pick_closest_path(custom_path, make_types_fancy(subtypesof(/obj/item)))
		var/custom_name = initial(custom_target.name)
		custom_name = stripped_input(admin,"Enter target name:", "Objective target", custom_name)
		if (!custom_name)
			return
		steal_target = custom_target
		explanation_text = "窃取 [custom_name]。"

	else
		set_target(new_target)

/datum/objective/steal/check_completion()
	var/list/datum/mind/owners = get_owners()
	if(!steal_target)
		return TRUE
	for(var/datum/mind/M in owners)
		if(!isliving(M.current))
			continue

		var/list/all_items = M.current.GetAllContents()	//this should get things in cheesewheels, books, etc.

		for(var/obj/I in all_items) //Check for items
			if(istype(I, steal_target))
				if(!targetinfo) //If there's no targetinfo, then that means it was a custom objective. At this point, we know you have the item, so return 1.
					return TRUE
				else if(targetinfo.check_special_completion(I))//Returns 1 by default. Items with special checks will return 1 if the conditions are fulfilled.
					return TRUE

			if(targetinfo && (I.type in targetinfo.altitems)) //Ok, so you don't have the item. Do you have an alternative, at least?
				if(targetinfo.check_special_completion(I))//Yeah, we do! Don't return 0 if we don't though - then you could fail if you had 1 item that didn't pass and got checked first!
					return TRUE
	return FALSE

/datum/objective/capture
	name = "捕获"

/datum/objective/capture/proc/gen_amount_goal()
	target_amount = rand(5,10)
	update_explanation_text()
	return target_amount

/datum/objective/capture/update_explanation_text()
	. = ..()
	explanation_text = "用能量网捕获 [target_amount] 个生命体。活体与稀有样本价值更高。"

/datum/objective/capture/admin_edit(mob/admin)
	var/count = input(admin,"How many mobs to capture ?","capture",target_amount) as num|null
	if(count)
		target_amount = count
	update_explanation_text()

/datum/objective/protect_object
	name = "保护物件"
	var/obj/protect_target

/datum/objective/protect_object/proc/set_target(obj/O)
	protect_target = O
	update_explanation_text()

/datum/objective/protect_object/update_explanation_text()
	. = ..()
	if(protect_target)
			explanation_text = "不惜一切代价保护 [protect_target]。"
	else
		explanation_text = "自由目标。"

/datum/objective/protect_object/check_completion()
	return !QDELETED(protect_target)


/datum/objective/destroy/internal
	var/stolen = FALSE 		//Have we already eliminated this target?

/datum/objective/steal_five_of_type
	name = "窃取五件"
	explanation_text = "至少窃取五件物品！"
	var/list/wanted_items = list()

/datum/objective/steal_five_of_type/New()
	..()
	wanted_items = typecacheof(wanted_items)

/datum/objective/steal_five_of_type/check_completion()
	var/list/datum/mind/owners = get_owners()
	var/stolen_count = 0
	for(var/datum/mind/M in owners)
		if(!isliving(M.current))
			continue
		var/list/all_items = M.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
		for(var/obj/I in all_items) //Check for wanted items
			if(is_type_in_typecache(I, wanted_items))
				stolen_count++
	return stolen_count >= 5

//Created by admin tools
/datum/objective/custom
	name = "自定义"

/datum/objective/custom/admin_edit(mob/admin)
	var/expl = stripped_input(admin, "Custom objective:", "Objective", explanation_text)
	if(expl)
		explanation_text = expl

////////////////////////////////
// Changeling team objectives //
////////////////////////////////

/datum/objective/changeling_team_objective //Abstract type
	martyr_compatible = 0	//Suicide is not teamwork!
	explanation_text = "蜕形怪友谊万岁！"
	var/min_lings = 3 //Minimum amount of lings for this team objective to be possible
	var/escape_objective_compatible = FALSE

/datum/objective/changeling_team_objective/proc/prepare()
	return FALSE

//Ideally this would be all of them but laziness and unusual subtypes
/proc/generate_admin_objective_list()
	GLOB.admin_objective_list = list()

	var/list/allowed_types = sortList(list(
		/datum/objective/assassinate,
		/datum/objective/maroon,
		/datum/objective/debrain,
		/datum/objective/protect,
		/datum/objective/escape,
		/datum/objective/survive,
		/datum/objective/martyr,
		/datum/objective/steal,
		/datum/objective/capture,
		/datum/objective/custom
	),/proc/cmp_typepaths_asc)

	for(var/T in allowed_types)
		var/datum/objective/X = T
		GLOB.admin_objective_list[initial(X.name)] = T

/datum/objective/contract
	var/payout = 0
	var/payout_bonus = 0
	var/area/dropoff = null

// Generate a random valid area on the station that the dropoff will happen.
/datum/objective/contract/proc/generate_dropoff()
	var/found = FALSE
	while (!found)
		var/area/dropoff_area = pick(GLOB.sortedAreas)
		if(dropoff_area && is_station_level(dropoff_area.z) && !dropoff_area.outdoors)
			dropoff = dropoff_area
			found = TRUE

// Check if both the contractor and contract target are at the dropoff point.
/datum/objective/contract/proc/dropoff_check(mob/user, mob/target)
	var/area/user_area = get_area(user)
	var/area/target_area = get_area(target)

	return (istype(user_area, dropoff) && istype(target_area, dropoff))
