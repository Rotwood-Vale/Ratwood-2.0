/datum/objective/listen_whispers
	name = "聆听低语"
	triumph_count = 2
	var/time_required = 5 MINUTES
	var/time_spent = 0
	var/last_check = 0
	var/check_interval = 10 SECONDS
	var/area/church_area = /area/rogue/indoors/town/church
	var/list/heard_messages = list()

/datum/objective/listen_whispers/on_creation()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	update_explanation_text()

/datum/objective/listen_whispers/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/objective/listen_whispers/process()
	if(world.time < last_check + check_interval || completed || !owner?.current)
		return

	last_check = world.time
	check_location()

/datum/objective/listen_whispers/proc/check_location()
	var/mob/living/user = owner.current
	if(!istype(user) || user.stat == DEAD)
		return

	if(!istype(get_area(user), church_area))
		return

	var/amulet_found = FALSE
	for(var/obj/item/clothing/neck/current_item in user.get_equipped_items(TRUE))
		if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/necra))
			amulet_found = TRUE

	if(!amulet_found)
		return

	time_spent += check_interval

	if(prob(20) && length(GLOB.last_words))
		var/message = pick(GLOB.last_words - heard_messages)
		to_chat(user, span_red("[message]"))
		heard_messages += message
		if(prob(33))
			user.playsound_local(user, 'sound/effects/ghost.ogg', 40)

	if(time_spent >= time_required && !completed)
		complete_objective()

/datum/objective/listen_whispers/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已聆听亡者低语足够久，令内克拉感到满意！"))
	owner.current.adjust_triumphs(triumph_count)
	completed = TRUE
	adjust_storyteller_influence("Necra", 15)
	escalate_objective()
	STOP_PROCESSING(SSprocessing, src)

/datum/objective/listen_whispers/update_explanation_text()
	explanation_text = "内克拉希望你更深地理解死亡。佩戴内克拉护符，在教堂中聆听亡者低语至少 [time_required / (1 MINUTES)] 分钟。"
