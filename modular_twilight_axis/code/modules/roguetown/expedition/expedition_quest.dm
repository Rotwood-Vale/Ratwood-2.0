GLOBAL_VAR_INIT(current_expedition_level_name, "Muster Grounds")
GLOBAL_LIST_EMPTY(current_expedition_objectives)

/datum/expedition_objective
	var/id = ""
	var/text = ""
	var/completed = FALSE
	var/current_count = 0
	var/max_count = 1

/datum/expedition_objective/New(new_id, new_text, new_max = 1)
	id = new_id
	text = new_text
	max_count = new_max

/mob/living/carbon/human/Stat()
	..()
	var/is_crusader = HAS_TRAIT(src, TRAIT_EXPEDITION_MEMBER)
	var/is_ruler = (GLOB.expedition_status != EXPEDITION_INACTIVE && (SSticker.rulermob == src || SSticker.regentmob == src))

	if(is_crusader || is_ruler)
		if(statpanel("Crusade"))
			stat("HOLY CRUSADE", " ")
			stat("Domain:", GLOB.current_expedition_level_name)
			stat("Purpose:", GLOB.expedition_goal ? GLOB.expedition_goal : "Royal Sanction")
			stat("--------------------------------------", "")

			if(!length(GLOB.current_expedition_objectives))
				stat("\[ \]", "Explore the depths")
			else
				for(var/datum/expedition_objective/OBJ in GLOB.current_expedition_objectives)
					var/mark = OBJ.completed ? "\[X\]" : "\[ \]"
					var/progress_str = ""
					if(OBJ.completed)
						progress_str = "COMPLETED"
					else if(OBJ.max_count > 1)
						progress_str = "([OBJ.current_count]/[OBJ.max_count])"
					
					stat("[mark] [OBJ.text]", progress_str)

/proc/set_expedition_level(level_name, list/objectives_data)
	GLOB.current_expedition_level_name = level_name
	
	QDEL_LIST(GLOB.current_expedition_objectives)
	GLOB.current_expedition_objectives = list()

	for(var/obj_id in objectives_data)
		var/data = objectives_data[obj_id]
		var/obj_text = ""
		var/obj_max = 1
		if(islist(data))
			obj_text = data[1]
			obj_max = data[2]
		else
			obj_text = data
		
		var/datum/expedition_objective/OBJ = new(obj_id, obj_text, obj_max)
		GLOB.current_expedition_objectives += OBJ

	for(var/mob/living/carbon/human/H in GLOB.expedition_party)
		if(!QDELETED(H))
			to_chat(H, "<span style='color: #e5a93b;'><b>\[CRUSADE LOG\]</b> Entering <b>[level_name]</b>. Check your <b>Crusade</b> tab!</span>")

/proc/complete_expedition_objective(objective_id)
	for(var/datum/expedition_objective/OBJ in GLOB.current_expedition_objectives)
		if(OBJ.id == objective_id)
			if(!OBJ.completed)
				OBJ.completed = TRUE
				OBJ.current_count = OBJ.max_count
				playsound_party('sound/misc/bell.ogg', 60)
				for(var/mob/living/carbon/human/H in GLOB.expedition_party)
					if(!QDELETED(H))
						to_chat(H, "<span style='color: #55b055;'><b>\[CRUSADE OBJECTIVE COMPLETED\]</b> [OBJ.text]</span>")
			return TRUE
	return FALSE

/proc/progress_expedition_objective(objective_id, amount = 1)
	for(var/datum/expedition_objective/OBJ in GLOB.current_expedition_objectives)
		if(OBJ.id == objective_id)
			if(!OBJ.completed)
				OBJ.current_count = min(OBJ.current_count + amount, OBJ.max_count)
				if(OBJ.current_count >= OBJ.max_count)
					OBJ.completed = TRUE
					playsound_party('sound/misc/bell.ogg', 60)
					for(var/mob/living/carbon/human/H in GLOB.expedition_party)
						if(!QDELETED(H))
							to_chat(H, "<span style='color: #55b055;'><b>\[CRUSADE OBJECTIVE COMPLETED\]</b> [OBJ.text]</span>")
				else
					for(var/mob/living/carbon/human/H in GLOB.expedition_party)
						if(!QDELETED(H))
							to_chat(H, "<span style='color: #aaa;'><b>\[CRUSADE PROGRESS\]</b> [OBJ.text] ([OBJ.current_count]/[OBJ.max_count])</span>")
			return TRUE
	return FALSE

/proc/update_all_expedition_trackers()
	return

/proc/playsound_party(soundfile, volume = 50)
	for(var/mob/living/carbon/human/H in GLOB.expedition_party)
		if(!QDELETED(H) && H.client)
			playsound(H, soundfile, volume, FALSE)
