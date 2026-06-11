//Brain traumas that are rare and/or somewhat beneficial;
//they are the easiest to cure, which means that if you want
//to keep them, you can't cure your other traumas
/datum/brain_trauma/special

/datum/brain_trauma/special/godwoken
	name = "神启综合征"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='notice'>我感到脑海中有一股更高的力量……</span>"
	lose_text = "<span class='warning'>那道神圣存在离开了我的脑海，不再对我感兴趣。</span>"

/datum/brain_trauma/special/godwoken/on_life()
	..()
	if(prob(4))
		if(prob(33) && (owner.IsStun() || owner.IsParalyzed() || owner.IsUnconscious()))
			speak("unstun", TRUE)
		else if(prob(60) && owner.health <= owner.crit_threshold)
			speak("heal", TRUE)
		else if(prob(30) && owner.used_intent.type == INTENT_HARM)
			speak("aggressive")
		else
			speak("neutral", prob(25))

/datum/brain_trauma/special/godwoken/on_gain()
	ADD_TRAIT(owner, TRAIT_HOLY, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/godwoken/on_lose()
	REMOVE_TRAIT(owner, TRAIT_HOLY, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/godwoken/proc/speak(type, include_owner = FALSE)
	var/message
	switch(type)
		if("unstun")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_unstun")
		if("heal")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_heal")
		if("neutral")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_neutral")
		if("aggressive")
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_aggressive")
		else
			message = pick_list_replacements(BRAIN_DAMAGE_FILE, "god_neutral")

	playsound(get_turf(owner), 'sound/blank.ogg', 200, TRUE, 5)
	voice_of_god(message, owner, list("colossus","yell"), 2.5, include_owner, FALSE)

/datum/brain_trauma/special/bluespace_prophet
	name = "Bluespace 预兆"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='notice'>我感到 Bluespace 正在我周围脉动……</span>"
	lose_text = "<span class='warning'>Bluespace 那微弱的脉动渐渐归于寂静。</span>"
	var/next_portal = 0

/datum/brain_trauma/special/bluespace_prophet/on_life()
	if(world.time > next_portal)
		next_portal = world.time + 100
		var/list/turf/possible_turfs = list()
		for(var/turf/T in range(owner, 8))
			if(!T.density)
				var/clear = TRUE
				for(var/obj/O in T)
					if(O.density)
						clear = FALSE
						break
				if(clear)
					possible_turfs += T

		if(!LAZYLEN(possible_turfs))
			return

		var/turf/first_turf = pick(possible_turfs)
		if(!first_turf)
			return

		possible_turfs -= (possible_turfs & range(first_turf, 3))

		var/turf/second_turf = pick(possible_turfs)
		if(!second_turf)
			return

		var/obj/effect/hallucination/simple/bluespace_stream/first = new(first_turf, owner)
		var/obj/effect/hallucination/simple/bluespace_stream/second = new(second_turf, owner)

		first.linked_to = second
		second.linked_to = first
		first.seer = owner
		second.seer = owner

/obj/effect/hallucination/simple/bluespace_stream
	name = "Bluespace 流"
	desc = ""
	image_icon = 'icons/effects/effects.dmi'
	image_state = "bluestream"
	image_layer = ABOVE_MOB_LAYER
	var/obj/effect/hallucination/simple/bluespace_stream/linked_to
	var/mob/living/carbon/seer

/obj/effect/hallucination/simple/bluespace_stream/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 300)

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/effect/hallucination/simple/bluespace_stream/attack_hand(mob/user)
	if(user != seer || !linked_to)
		return
	var/slip_in_message = pick("以一种古怪的姿势横滑了一下，随后消失不见", "跳进了一个看不见的维度里",\
		"伸直了一条腿，晃了晃[user.p_their()]的脚，突然就不见了", "停顿了一下，随后从现实中闪灭了", \
		"被卷进了一道无形的漩涡，消失在视野中")
	var/slip_out_message = pick("无声地渐渐显现出来", "凭空一跃而出","忽然出现了", "从一道看不见的门中走了出来",\
		"从时空的褶皱中滑了出来")
	to_chat(user, "<span class='notice'>我试着与这道 Bluespace 流对齐……</span>")
	if(do_after(user, 20, target = src))
		new /obj/effect/temp_visual/bluespace_fissure(get_turf(src))
		new /obj/effect/temp_visual/bluespace_fissure(get_turf(linked_to))
		user.forceMove(get_turf(linked_to))
		user.visible_message("<span class='warning'>[user][slip_in_message]。</span>", null, null, null, user)
		user.visible_message("<span class='warning'>[user][slip_out_message]。</span>", "<span class='notice'>……然后我抵达了另一端。</span>")

/datum/brain_trauma/special/tenacity
	name = "坚韧"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='warning'>我突然感觉不到疼痛了。</span>"
	lose_text = "<span class='warning'>我意识到自己又能感受到疼痛了。</span>"

/datum/brain_trauma/special/tenacity/on_gain()
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAUMA_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/tenacity/on_lose()
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAUMA_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/special/death_whispers
	name = "功能性脑坏死"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='warning'>我感觉自己从内到外都死寂了。</span>"
	lose_text = "<span class='notice'>我感觉自己又活了过来。</span>"
	var/active = FALSE

/datum/brain_trauma/special/death_whispers/on_life()
	..()
	if(!active && prob(2))
		whispering()

/datum/brain_trauma/special/death_whispers/on_lose()
	if(active)
		cease_whispering()
	..()

/datum/brain_trauma/special/death_whispers/proc/whispering()
	ADD_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(cease_whispering)), rand(50, 300))

/datum/brain_trauma/special/death_whispers/proc/cease_whispering()
	REMOVE_TRAIT(owner, TRAIT_SIXTHSENSE, TRAUMA_TRAIT)
	active = FALSE

/datum/brain_trauma/special/existential_crisis
	name = "存在危机"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='notice'>我感觉自己没那么真实了。</span>"
	lose_text = "<span class='warning'>我感觉自己又重新变得真实了。</span>"
	var/obj/effect/abstract/sync_holder/veil/veil
	var/next_crisis = 0

/datum/brain_trauma/special/existential_crisis/on_life()
	..()
	if(!veil && world.time > next_crisis && prob(3))
		if(isturf(owner.loc))
			fade_out()

/datum/brain_trauma/special/existential_crisis/on_lose()
	if(veil)
		fade_in()
	..()

/datum/brain_trauma/special/existential_crisis/proc/fade_out()
	if(veil)
		return
	var/duration = rand(50, 450)
	veil = new(owner.drop_location())
	to_chat(owner, "<span class='warning'>[pick("我有那么一瞬间停止了思考，于是我便不复存在。",\
												"存在，还是不存在……",\
												"为何而存在？",\
												"我不再维系自身的真实。",\
												"我对存在的把握正在滑落。",\
												"我真的存在吗？",\
												"我只是缓缓淡去了。")]</span>")
	owner.forceMove(veil)
	SEND_SIGNAL(owner, COMSIG_MOVABLE_SECLUDED_LOCATION)
	for(var/thing in owner)
		var/atom/movable/AM = thing
		SEND_SIGNAL(AM, COMSIG_MOVABLE_SECLUDED_LOCATION)
	next_crisis = world.time + 600
	addtimer(CALLBACK(src, PROC_REF(fade_in)), duration)

/datum/brain_trauma/special/existential_crisis/proc/fade_in()
	QDEL_NULL(veil)
	to_chat(owner, "<span class='notice'>我重新淡回了现实之中。</span>")
	next_crisis = world.time + 600

//base sync holder is in desynchronizer.dm
/obj/effect/abstract/sync_holder/veil
	name = "非存在"
	desc = ""

/datum/brain_trauma/special/beepsky
	name = "罪犯"
	desc = ""
	scan_desc = ""
	gain_text = "<span class='warning'>正义正向我逼近。</span>"
	lose_text = "<span class='notice'>我的罪行得到了赦免。</span>"
	clonable = FALSE
	random_gain = FALSE
	var/obj/effect/hallucination/simple/securitron/beepsky

/datum/brain_trauma/special/beepsky/on_gain()
	create_securitron()
	..()

/datum/brain_trauma/special/beepsky/proc/create_securitron()
	var/turf/where = locate(owner.x + pick(-12, 12), owner.y + pick(-12, 12), owner.z)
	beepsky = new(where, owner)
	beepsky.victim = owner

/datum/brain_trauma/special/beepsky/on_lose()
	QDEL_NULL(beepsky)
	..()

/datum/brain_trauma/special/beepsky/on_life()
	if(QDELETED(beepsky) || !beepsky.loc || beepsky.z != owner.z)
		QDEL_NULL(beepsky)
		if(prob(30))
			create_securitron()
		else
			return
	if(get_dist(owner, beepsky) >= 10 && prob(20))
		QDEL_NULL(beepsky)
		create_securitron()
	if(owner.stat != CONSCIOUS)
		if(prob(20))
			owner.playsound_local(beepsky, 'sound/blank.ogg', 50)
		return
	if(get_dist(owner, beepsky) <= 1)
		owner.playsound_local(owner, 'sound/blank.ogg', 50)
		owner.visible_message("<span class='warning'>[owner]的身体猛地一抽，像是被电击了一般。</span>", "<span class='danger'>我感受到了 LAW 的铁拳。</span>")
		owner.take_bodypart_damage(0,0,rand(40, 70))
		QDEL_NULL(beepsky)
	if(prob(20) && get_dist(owner, beepsky) <= 8)
		owner.playsound_local(beepsky, 'sound/blank.ogg', 40)
	..()

/obj/effect/hallucination/simple/securitron
	name = "Securitron"
	desc = ""
	image_icon = 'icons/mob/aibots.dmi'
	image_state = "secbot-c"
	var/victim

/obj/effect/hallucination/simple/securitron/New()
	name = pick ( "officer Beepsky", "officer Johnson", "officer Pingsky")
	START_PROCESSING(SSfastprocess,src)
	..()

/obj/effect/hallucination/simple/securitron/process()
	if(prob(60))
		forceMove(get_step_towards(src, victim))
		if(prob(5))
			to_chat(victim, "<span class='name'>[name]</span>高声说道：\"<span class='robotic'>十级违规警报！</span>\"")

/obj/effect/hallucination/simple/securitron/Destroy()
	STOP_PROCESSING(SSfastprocess,src)
	return ..()
