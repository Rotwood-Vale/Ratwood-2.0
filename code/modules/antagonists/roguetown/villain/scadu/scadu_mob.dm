GLOBAL_LIST_EMPTY(active_scadu_mobs)

/area/rogue/outdoors/bograt/Entered(atom/movable/AM, turf/old_turf)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(!H.client || !H.mind || HAS_TRAIT(H, TRAIT_ANTISCRYING))
		return
	if(old_turf && istype(get_area(old_turf), /area/rogue/outdoors/bograt))
		return
	for(var/mob/dead/observer/rogue/scadu/SM in GLOB.active_scadu_mobs)
		if(SM.client && !QDELETED(SM))
			SM.notify_entered(H)

/atom/movable/screen/ghost/orbit/rogue/Click(location, control, params)
	if(istype(usr, /mob/dead/observer/rogue/scadu))
		return
	return ..()

/datum/hud/scadu/New(mob/owner)
	..()

/mob/dead/observer/rogue/scadu
	name = "The Scadu"
	icon = 'icons/roguetown/mob/misc.dmi'
	icon_state = "hollow"
	draw_icon = FALSE
	alpha = 0
	see_in_dark = 100
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS
	hud_type = /datum/hud/scadu

	var/datum/antagonist/scadu/antag_datum = null
	var/active_ability = "none"
	var/ability_cooldown = 0

/mob/dead/observer/rogue/scadu/Initialize(mapload)
	. = ..()
	active_ability = SCADU_ABILITY_NONE
	set_invisibility(INVISIBILITY_MAXIMUM)
	movement_type = GROUND | FLYING
	GLOB.active_scadu_mobs += src
	INVOKE_ASYNC(src, PROC_REF(presence_loop))

/mob/dead/observer/rogue/scadu/proc/presence_loop()
	while(!QDELETED(src))
		sleep(100)
		if(QDELETED(src) || !client)
			continue
		for(var/mob/living/carbon/human/H in range(5, src))
			if(!H.client || !H.mind || HAS_TRAIT(H, TRAIT_ANTISCRYING))
				continue
			H.apply_status_effect(/datum/status_effect/buff/scadu_presence)

/mob/dead/observer/rogue/scadu/Destroy()
	GLOB.active_scadu_mobs -= src
	return ..()

/mob/dead/observer/rogue/scadu/Login()
	. = ..()
	if(antag_datum?.manifest_revert_time > world.time)
		ability_cooldown = antag_datum.manifest_revert_time
		antag_datum.manifest_revert_time = 0
	client?.verbs -= GLOB.ghost_verbs
	if(client)
		for(var/atom/movable/screen/ghost/orbit/rogue/S in client.screen)
			client.screen -= S
		for(var/atom/movable/screen/backhudl/ghost/S in client.screen)
			client.screen -= S
			to_chat(src, span_notice("You are the <b>Scadu</b>. Select an ability verb, then click a target to use it."))
	to_chat(src, span_notice("You are bound to <b>The Terrorbog</b>. You cannot leave its borders. Place your monuments to gain lux to fuel your abilities. Abilities used near monuments are halved in cost."))

/mob/dead/observer/rogue/scadu/Move(NewLoc, direct)
	if(istype(get_area(src), /area/rogue/outdoors/bograt))
		if(NewLoc && !istype(get_area(NewLoc), /area/rogue/outdoors/bograt))
			to_chat(src, span_warning("The borders of the bog hold you fast."))
			return FALSE
		return ..()
	. = ..()
	scadu_return_to_bog()

/mob/dead/observer/rogue/scadu/proc/near_psycross(turf/T)
	for(var/obj/structure/fluff/psycross/P in range(5, T))
		return TRUE
	return FALSE

/mob/dead/observer/rogue/scadu/ClickOn(atom/A, list/modifiers)
	if(!antag_datum || active_ability == SCADU_ABILITY_NONE)
		return
	if(world.time < ability_cooldown)
		to_chat(src, span_warning("My power still gathers... ([round((ability_cooldown - world.time) / 10, 1)]s)"))
		return
	var/turf/T = isturf(A) ? A : get_turf(A)
	if(!T || !istype(get_area(T), /area/rogue/outdoors/bograt))
		to_chat(src, span_warning("My reach does not extend beyond the bog."))
		return
	if(near_psycross(T))
		to_chat(src, span_warning("A holy ward repels my power. I cannot act here."))
		return
	switch(active_ability)
		if(SCADU_ABILITY_MONUMENT)
			ability_place_monument(T)
		if(SCADU_ABILITY_PLACE_TOTEM)
			ability_place_totem(T)
		if(SCADU_ABILITY_DESTROY_TOTEM)
			ability_destroy_totem(A)
		if(SCADU_ABILITY_SUMMON_LURKER)
			ability_summon_mirelurker(T)
		if(SCADU_ABILITY_SUMMON_CRAWLER)
			ability_summon_mirecrawler(T)
		if(SCADU_ABILITY_GOBLIN)
			ability_summon_goblin(T)
		if(SCADU_ABILITY_WEEPVINE)
			ability_summon_weepvine(T)
		if(SCADU_ABILITY_TERROR)
			ability_terror_pulse(T)
		if(SCADU_ABILITY_SNUFF_LIGHTS)
			ability_snuff_lights(T)
		if(SCADU_ABILITY_MIASMA)
			ability_place_miasma(T)
		if(SCADU_ABILITY_BOGTRAP)
			ability_place_bogtrap(T)
		if(SCADU_ABILITY_GOBLIN_PORTAL)
			ability_goblin_portal(T)
		if(SCADU_ABILITY_MESSAGE)
			if(isliving(A))
				ability_send_message(A)
			else
				to_chat(src, span_warning("I must target a living soul to speak to."))
		if(SCADU_ABILITY_HALLUCINATE)
			if(isliving(A))
				ability_hallucinate(A)
			else
				to_chat(src, span_warning("I must target a living soul to afflict."))
		if(SCADU_ABILITY_WEB)
			ability_summon_web(T)
		if(SCADU_ABILITY_MANIFEST)
			ability_manifest(T)

/mob/dead/observer/rogue/scadu/proc/check_placement(turf/T)
	if(istype(T, /turf/open/transparent/openspace))
		to_chat(src, span_warning("I cannot place anything over open space."))
		return FALSE
	for(var/turf/closed/mineral/CT in range(2, T))
		to_chat(src, span_warning("Too close to rock walls."))
		return FALSE
	for(var/obj/structure/S in T)
		to_chat(src, span_warning("Something already stands there."))
		return FALSE
	return TRUE

/mob/dead/observer/rogue/scadu/proc/check_summon(turf/T)
	if(!T.can_see_sky())
		to_chat(src, span_warning("My power cannot reach into enclosed spaces."))
		return FALSE
	for(var/mob/living/carbon/human/H in range(5, T))
		if(H.mind)
			to_chat(src, span_warning("A soul stands too close. I cannot summon there."))
			return FALSE
	return TRUE

/mob/dead/observer/rogue/scadu/proc/nearest_monument_in_range(turf/T, range = 7)
	if(!antag_datum)
		return null
	for(var/obj/structure/scadu_monument/M in antag_datum.monuments)
		if(!QDELETED(M) && M.standing && get_dist(T, M) <= range)
			return M
	return null

/mob/dead/observer/rogue/scadu/proc/nearest_anchor_in_range(turf/T, range = 7)
	if(!antag_datum)
		return null
	for(var/obj/structure/scadu_monument/M in antag_datum.monuments)
		if(!QDELETED(M) && M.standing && get_dist(T, M) <= range)
			return M
	for(var/obj/structure/scadu_totem/totem in antag_datum.active_totems)
		if(!QDELETED(totem) && get_dist(T, totem) <= SCADU_TOTEM_RANGE)
			return totem
	return null

/mob/dead/observer/rogue/scadu/proc/ability_place_monument(turf/T)
	if(antag_datum.monuments_placed >= antag_datum.monument_limit)
		to_chat(src, span_warning("I have raised all [antag_datum.monument_limit] monuments I am capable of."))
		return
	if(!isopenturf(T) || !check_placement(T))
		if(isopenturf(T))
			return
		to_chat(src, span_warning("That ground will not accept a monument."))
		return
	for(var/obj/structure/scadu_monument/existing in range(2, T))
		to_chat(src, span_warning("Another monument stands too close."))
		return
	var/obj/structure/scadu_monument/M = new(T)
	M.owner_datum = antag_datum
	antag_datum.register_monument(M)
	visible_message_at(T, span_warning("The earth groans as dark stone erupts from the bog..."))
	set_cooldown(SCADU_CD_MONUMENT)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_place_totem(turf/T)
	var/totem_limit = floor(antag_datum.count_standing_monuments() / 2)
	if(totem_limit < 1)
		to_chat(src, span_warning("I need at least 2 standing monuments to place a totem."))
		return
	if(antag_datum.count_active_totems() >= totem_limit)
		to_chat(src, span_warning("I cannot place more than [totem_limit] totem\s with [antag_datum.count_standing_monuments()] standing monuments."))
		return
	if(!antag_datum.spend_lux(SCADU_COST_PLACE_TOTEM))
		to_chat(src, span_warning("Insufficient lux. (Need [SCADU_COST_PLACE_TOTEM], have [antag_datum.lux])"))
		return
	if(!isopenturf(T) || !check_placement(T))
		antag_datum.add_lux(SCADU_COST_PLACE_TOTEM)
		if(isopenturf(T))
			return
		to_chat(src, span_warning("That ground will not accept a totem."))
		return
	var/obj/structure/scadu_totem/totem = new(T)
	totem.owner_datum = antag_datum
	antag_datum.active_totems += totem
	visible_message_at(T, span_warning("Dark energy coalesces into a pulsing totem..."))
	playsound(T, 'sound/magic/antimagic.ogg', 60, TRUE)
	to_chat(src, span_notice("Totem placed ([antag_datum.count_active_totems()]/[totem_limit]). Mob summons must be within [SCADU_TOTEM_RANGE] tiles of it (or any standing monument)."))
	set_cooldown(SCADU_CD_PLACE_TOTEM)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_destroy_totem(atom/A)
	var/obj/structure/scadu_totem/totem = null
	if(istype(A, /obj/structure/scadu_totem))
		totem = A
	else
		var/turf/T = isturf(A) ? A : get_turf(A)
		for(var/obj/structure/scadu_totem/candidate in T)
			totem = candidate
			break
	if(!totem || QDELETED(totem))
		to_chat(src, span_warning("I must click directly on one of my totems to destroy it."))
		active_ability = SCADU_ABILITY_NONE
		return
	if(totem.owner_datum != antag_datum)
		to_chat(src, span_warning("That totem is not mine."))
		active_ability = SCADU_ABILITY_NONE
		return
	var/area/area = get_area(totem)
	visible_message_at(get_turf(totem), span_warning("The totem shudders and collapses into dark mist..."))
	playsound(get_turf(totem), 'sound/magic/antimagic.ogg', 60, TRUE)
	antag_datum.active_totems -= totem
	qdel(totem)
	to_chat(src, span_notice("Your totem in [area.name] has been reclaimed."))
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_summon_mirelurker(turf/T)
	var/cost = SCADU_COST_SUMMON_LURKER
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!nearest_anchor_in_range(T))
		to_chat(src, span_warning("Summons must be within range of a monument or totem."))
		antag_datum.add_lux(cost)
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That location is blocked."))
		antag_datum.add_lux(cost)
		return
	new /mob/living/simple_animal/hostile/rogue/mirespider_lurker/scadu(T)
	new /obj/effect/temp_visual/bluespace_fissure(T)
	visible_message_at(T, span_danger("Something massive lurches out of the black water..."))
	set_cooldown(SCADU_CD_SUMMON_LURKER)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_summon_mirecrawler(turf/T)
	var/cost = SCADU_COST_SUMMON_CRAWLER
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!nearest_anchor_in_range(T))
		to_chat(src, span_warning("Summons must be within range of a monument or totem."))
		antag_datum.add_lux(cost)
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That location is blocked."))
		antag_datum.add_lux(cost)
		return
	new /mob/living/simple_animal/hostile/retaliate/rogue/mirespider/scadu(T)
	new /obj/effect/temp_visual/bluespace_fissure(T)
	visible_message_at(T, span_danger("A mire crawler scrabbles out of the dark water..."))
	set_cooldown(SCADU_CD_SUMMON_CRAWLER)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_summon_goblin(turf/T)
	var/cost = SCADU_COST_GOBLIN
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!nearest_anchor_in_range(T))
		to_chat(src, span_warning("Summons must be within range of a monument or totem."))
		antag_datum.add_lux(cost)
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That location is blocked."))
		antag_datum.add_lux(cost)
		return
	new /mob/living/carbon/human/species/goblin/npc/scadu_goblin(T)
	new /obj/effect/temp_visual/bluespace_fissure(T)
	visible_message_at(T, span_danger("A goblin claws its way up from the murk!"))
	set_cooldown(SCADU_CD_GOBLIN)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_summon_weepvine(turf/T)
	var/cost = SCADU_COST_WEEPVINE
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!nearest_anchor_in_range(T))
		to_chat(src, span_warning("Summons must be within range of a monument or totem."))
		antag_datum.add_lux(cost)
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That ground cannot root a vine."))
		antag_datum.add_lux(cost)
		return
	new /datum/vine_controller(T)
	visible_message_at(T, span_danger("Weepvines tear through the bog floor!"))
	set_cooldown(SCADU_CD_WEEPVINE)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_terror_pulse(turf/T)
	var/cost = SCADU_COST_TERROR
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	var/affected = 0
	for(var/mob/living/carbon/human/H in range(5, T))
		if(!H.mind || !H.client)
			continue
		H.add_stress(/datum/stressevent/scadu_terror)
		H.apply_status_effect(/datum/status_effect/buff/scadu_terrored)
		H.emote("scream")
		to_chat(H, span_userdanger("An unseen presence presses in around you. Your breath comes short."))
		affected++
	if(!affected)
		to_chat(src, span_notice("No souls were close enough to terror."))
		antag_datum.add_lux(cost)
		return
	playsound(T, 'sound/magic/antimagic.ogg', 80, TRUE)
	visible_message_at(T, span_danger("The air turns cold and still..."))
	set_cooldown(SCADU_CD_TERROR)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_snuff_lights(turf/T)
	var/cost = SCADU_COST_SNUFF_LIGHTS
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	var/range = 7
	for(var/obj/O in range(range, T))
		O.extinguish()
	for(var/mob/living/carbon/human/H in range(range, T))
		for(var/obj/O in H.contents)
			O.extinguish()
		to_chat(H, span_notice("<i>The lights go out.</i>"))
	playsound(T, 'sound/magic/zizo_snuff.ogg', 70, TRUE)
	visible_message_at(T, span_warning("The lights gutter and die..."))
	set_cooldown(SCADU_CD_SNUFF_LIGHTS)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_place_miasma(turf/T)
	var/cost = SCADU_COST_MIASMA
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	new /obj/effect/scadu_miasma(T)
	playsound(T, 'sound/misc/evilevent.ogg', 60, TRUE)
	visible_message_at(T, span_warning("A creeping mist rises from the bog..."))
	set_cooldown(SCADU_CD_MIASMA)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_place_bogtrap(turf/T)
	var/cost = SCADU_COST_BOGTRAP
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That ground cannot hide a trap."))
		antag_datum.add_lux(cost)
		return
	new /obj/structure/trap/bogtrap/kneestingers(T)
	playsound(T, pick('sound/misc/sting1.ogg','sound/misc/sting2.ogg'), 50, TRUE)
	visible_message_at(T, span_warning("The murk stirs..."))
	set_cooldown(SCADU_CD_BOGTRAP)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_goblin_portal(turf/T)
	if(antag_datum.portal_used)
		to_chat(src, span_warning("Can only use once."))
		return
	if(!antag_datum.spend_lux(SCADU_COST_GOBLIN_PORTAL))
		to_chat(src, span_warning("Insufficient lux. (Need [SCADU_COST_GOBLIN_PORTAL], have [antag_datum.lux])"))
		return
	if(!isopenturf(T) || !check_placement(T))
		if(!isopenturf(T))
			to_chat(src, span_warning("That location is blocked."))
		antag_datum.add_lux(SCADU_COST_GOBLIN_PORTAL)
		return
	antag_datum.portal_used = TRUE
	SSmapping.add_world_trait(/datum/world_trait/goblin_siege, 8 MINUTES)
	for(var/mob/dead/observer/O in GLOB.player_list)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/mob/dead/observer, horde_respawn)), 1)
	var/obj/structure/gob_portal/P = new(T)
	P.maxgobs = 5
	var/obj/effect/landmark/L = new /obj/effect/landmark/start/goblin_portal_spawn(T)
	visible_message_at(T, span_danger("A foul portal tears open in the bog! Goblins pour through!"))
	addtimer(CALLBACK(src, PROC_REF(close_goblin_portal), P, L), 8 MINUTES)
	set_cooldown(SCADU_CD_GOBLIN_PORTAL)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/close_goblin_portal(obj/structure/gob_portal/P, obj/effect/landmark/L)
	if(!QDELETED(P))
		qdel(P)
	if(!QDELETED(L))
		qdel(L)

/mob/dead/observer/rogue/scadu/proc/ability_send_message(mob/living/target)
	if(!target?.client)
		to_chat(src, span_warning("No conscious soul to speak to."))
		return
	var/msg = html_decode(input(src, "Speak to [target.real_name]:", "The Bog Speaks") as null|text)
	if(!msg || !length(msg))
		return
	to_chat(target, span_userdanger("<i>A voice rises from the bog...</i> \"[msg]\""))
	target.playsound_local(get_turf(target), 'sound/vo/mobs/ghost/aggro (2).ogg', 50, TRUE)
	to_chat(src, span_notice("Your words reach [target.real_name]."))
	set_cooldown(SCADU_CD_MESSAGE)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_hallucinate(mob/living/carbon/H)
	if(!H || QDELETED(H) || !istype(H, /mob/living/carbon))
		to_chat(src, span_warning("I must target a living soul."))
		return
	var/hal_type = pick(
		/datum/hallucination/chasing_mob,
		/datum/hallucination/battle,
		/datum/hallucination/delusion,
		/datum/hallucination/voices,
		/datum/hallucination/fake_heartattack,
		/datum/hallucination/floor_shift,
		/datum/hallucination/weird_sounds,
	)
	new hal_type(H, TRUE)
	playsound(get_turf(H), pick('sound/misc/carriage1.ogg','sound/misc/carriage3.ogg','sound/misc/zizo.ogg'), 50, TRUE)
	to_chat(src, span_notice("Your will reaches into [H.real_name]'s mind."))
	set_cooldown(SCADU_CD_HALLUCINATE)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_summon_web(turf/T)
	var/cost = SCADU_COST_WEB
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!nearest_anchor_in_range(T))
		to_chat(src, span_warning("Summons must be within range of a monument or totem."))
		antag_datum.add_lux(cost)
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That ground cannot hold a web."))
		antag_datum.add_lux(cost)
		return
	new /obj/structure/spider/stickyweb(T)
	playsound(T, pick('sound/misc/sting1.ogg','sound/misc/sting2.ogg'), 45, TRUE)
	visible_message_at(T, span_warning("Silken threads weave up from the dark..."))
	set_cooldown(SCADU_CD_WEB)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/ability_manifest(turf/T)
	var/cost = SCADU_COST_MANIFEST
	if(!antag_datum.spend_lux(cost))
		to_chat(src, span_warning("Insufficient lux. (Need [cost], have [antag_datum.lux])"))
		return
	if(!isopenturf(T))
		to_chat(src, span_warning("That location is blocked."))
		antag_datum.add_lux(cost)
		return
	if(!nearest_anchor_in_range(T) && !check_summon(T))
		antag_datum.add_lux(cost)
		return
	var/mob/living/carbon/human/species/human/northern/scadu_manifest/G = new(T)
	G.color = "#000000"
	G.real_name = "Shade"
	G.name = "Shade"
	if(G.dna?.species)
		G.dna.species.name = "???"
		G.dna.species.id = "unknown"
	if(G.dna && G.dna.species)
		G.dna.species.species_traits |= NOBLOOD
	ADD_TRAIT(G, TRAIT_MUTE, "scadu_manifest")
	G.adjust_skillrank(/datum/skill/misc/sneaking, 6, TRUE)
	var/obj/item/scadu_drain_touch/D1 = new(G)
	var/obj/item/scadu_drain_touch/D2 = new(G)
	D1.antag_datum = antag_datum
	D2.antag_datum = antag_datum
	G.put_in_hands(D1)
	G.put_in_hands(D2)
	G.ckey = ckey
	visible_message_at(T, span_danger("A shadow tears itself free from the dark..."))
	set_cooldown(SCADU_CD_MANIFEST)
	active_ability = SCADU_ABILITY_NONE

/mob/dead/observer/rogue/scadu/proc/scadu_return_to_bog()
	var/turf/dest = null
	if(length(GLOB.jobspawn_overrides["Scadu"]))
		dest = get_turf(pick(GLOB.jobspawn_overrides["Scadu"]))
	if(!dest)
		for(var/turf/T in get_area_turfs(/area/rogue/outdoors/bograt))
			if(isopenturf(T))
				dest = T
				break
	if(dest)
		forceMove(dest)
		to_chat(src, span_warning("The bog reclaims you."))

/mob/dead/observer/rogue/scadu/proc/notify_entered(mob/living/carbon/human/H)
	if(!client)
		return
	var/area/A = get_area(H)
	to_chat(src, span_warning("\[BOG ALERT\] <b>[H.real_name]</b> has entered <b>[A.name]</b>. <a href='byond://?src=[REF(src)];scadu_tp=[REF(H)]'>Observe</a>"))

/mob/dead/observer/rogue/scadu/Topic(href, href_list)
	. = ..()
	if(!href_list["scadu_tp"])
		return
	var/atom/target = locate(href_list["scadu_tp"])
	if(!target || QDELETED(target))
		to_chat(src, span_warning("Target no longer exists."))
		return
	if(istype(target, /obj/structure/scadu_monument))
		forceMove(get_turf(target))
		to_chat(src, span_notice("You drift toward your monument."))
		return
	var/mob/M = target
	if(!istype(get_area(M), /area/rogue/outdoors/bograt))
		to_chat(src, span_warning("[M.real_name] is no longer in the bog."))
		return
	forceMove(get_turf(M))
	to_chat(src, span_notice("You drift toward [M.real_name]."))

/mob/dead/observer/rogue/scadu/proc/set_cooldown(cd)
	ability_cooldown = world.time + cd

/mob/dead/observer/rogue/scadu/proc/visible_message_at(turf/T, message)
	for(var/mob/living/carbon/human/H in viewers(5, T))
		to_chat(H, message)

/mob/dead/observer/rogue/scadu/verb/scadu_goto_monument()
	set name = "Go to Monument"
	set category = "Scadu"
	set hidden = FALSE

	var/list/choices = list()
	for(var/obj/structure/scadu_monument/M in antag_datum?.monuments)
		if(QDELETED(M) || !M.standing)
			continue
		var/area/A = get_area(M)
		choices["Monument: [A.name] ([M.x],[M.y])"] = M
	for(var/obj/structure/scadu_totem/T in antag_datum?.active_totems)
		if(QDELETED(T))
			continue
		var/area/A = get_area(T)
		choices["Totem: [A.name] ([T.x],[T.y])"] = T

	if(!choices.len)
		to_chat(src, span_notice("No monuments or totems are standing."))
		return

	var/choice = input(src, "Select a destination:", "Go to Monument or Totem") as null|anything in choices
	if(!choice)
		return
	var/atom/dest = choices[choice]
	if(QDELETED(dest))
		to_chat(src, span_warning("That structure no longer stands."))
		return
	forceMove(get_turf(dest))

/mob/dead/observer/rogue/scadu/verb/scadu_guide()
	set name = "Scadu Guide"
	set category = "Scadu"
	set hidden = FALSE

	to_chat(src, span_notice("<b>THE SCADU</b>"))
	to_chat(src, span_notice("You are a malevolent spirit bound to the Terrorbog. You cannot leave its borders. Your goal is to defend the bog and destroy those who would topple your monuments."))
	to_chat(src, span_notice("<b>LUX</b>"))
	to_chat(src, span_notice("Lux is your resource. Monuments generate lux over time passively. Your lux cap and monument limit both increase when you absorb corpses via the Hollow Grasp while manifested."))
	to_chat(src, span_notice("<b>MONUMENTS</b>"))
	to_chat(src, span_notice("Monuments are your foundation. Place them with the Place Monument ability. You start with a limit of 3 and gain more by absorbing corpses. If all your placed monuments are destroyed and you have no placements remaining, you are banished."))
	to_chat(src, span_notice("<b>TOTEMS</b>"))
	to_chat(src, span_notice("Totems allow you to summon mobs in areas not covered by a monument. You may place one totem for every two standing monuments, rounded down. Totems cost [SCADU_COST_PLACE_TOTEM] lux each. All mob summons must be placed within [SCADU_TOTEM_RANGE] tiles of either a monument or a totem."))
	to_chat(src, span_notice("<b>MANIFEST</b>"))
	to_chat(src, span_notice("Manifest lets you take physical form as a Shade. While manifested you can use the Hollow Grasp to drain living souls for 0.5 corpse progress each, or fully consume a dead body for 1 full corpse. Each person can only be drained or consumed once. Taking any damage or leaving the bog immediately reverts you. Getting within 5 tiles of a psycross while manifested also forces a revert."))


/mob/dead/observer/rogue/scadu/verb/scadu_move_up()
	set name = "Move Up"
	set category = "Scadu"
	set hidden = FALSE
	ghost_up()

/mob/dead/observer/rogue/scadu/verb/scadu_move_down()
	set name = "Move Down"
	set category = "Scadu"
	set hidden = FALSE
	ghost_down()

/mob/dead/observer/rogue/scadu/verb/scadu_return_underworld()
	set name = "Go Dormant"
	set category = "Scadu"
	set hidden = FALSE

	if(alert("Leave the bog and return to the Underworld? Another may take your place and inherit the monuments.", "Return to Underworld", "Yes", "No") != "Yes")
		return
	if(antag_datum)
		for(var/obj/structure/scadu_monument/M in antag_datum.monuments)
			if(!QDELETED(M))
				M.go_dormant()
		antag_datum.scadu_mob = null
		if(mind)
			mind.remove_antag_datum(antag_datum)
	var/datum/job/roguetown/scadu/J = SSjob.GetJob("Scadu")
	if(J)
		J.current_positions = max(0, J.current_positions - 1)
	returntolobby()

/mob/dead/observer/rogue/scadu/verb/scadu_select_ability()
	set name = "Select Ability"
	set category = "Scadu"
	set hidden = FALSE

	if(!antag_datum)
		return

	var/list/abilities = list(
		"Place Monument (free, limit [antag_datum.monument_limit])"   = SCADU_ABILITY_MONUMENT,
		"Place Totem ([SCADU_COST_PLACE_TOTEM] lux)"                         = SCADU_ABILITY_PLACE_TOTEM,
		"Destroy Totem (free)"                                                = SCADU_ABILITY_DESTROY_TOTEM,
		"Summon Mire Lurker ([SCADU_COST_SUMMON_LURKER] lux)"            = SCADU_ABILITY_SUMMON_LURKER,
		"Summon Mire Crawler ([SCADU_COST_SUMMON_CRAWLER] lux)"          = SCADU_ABILITY_SUMMON_CRAWLER,
		"Summon Goblin ([SCADU_COST_GOBLIN] lux)"                     = SCADU_ABILITY_GOBLIN,
		"Summon Weepvine ([SCADU_COST_WEEPVINE] lux)"                 = SCADU_ABILITY_WEEPVINE,
		"Summon Web ([SCADU_COST_WEB] lux)"                           = SCADU_ABILITY_WEB,
		"Terror Pulse ([SCADU_COST_TERROR] lux)"                      = SCADU_ABILITY_TERROR,
		"Snuff Lights ([SCADU_COST_SNUFF_LIGHTS] lux)"                = SCADU_ABILITY_SNUFF_LIGHTS,
		"Miasma ([SCADU_COST_MIASMA] lux)"                            = SCADU_ABILITY_MIASMA,
		"Bog Trap ([SCADU_COST_BOGTRAP] lux)"                         = SCADU_ABILITY_BOGTRAP,
		"Hallucinate (free)"                                          = SCADU_ABILITY_HALLUCINATE,
		"Send Message (free)"                                         = SCADU_ABILITY_MESSAGE,
		"Manifest ([SCADU_COST_MANIFEST] lux)"                        = SCADU_ABILITY_MANIFEST,
	)

	if(!antag_datum.portal_used)
		abilities["Goblin Portal ([SCADU_COST_GOBLIN_PORTAL] lux)"] = SCADU_ABILITY_GOBLIN_PORTAL

	var/choice = input(src, "Select an ability to ready:", "Scadu Abilities") as null|anything in abilities
	if(!choice)
		active_ability = SCADU_ABILITY_NONE
		to_chat(src, span_notice("Ability deselected."))
		return
	active_ability = abilities[choice]
	to_chat(src, span_notice("Ready: <b>[active_ability]</b>. Click a target in the bog to use it."))

/mob/dead/observer/rogue/scadu/verb/scadu_status()
	set name = "Scadu Status"
	set category = "Scadu"
	set hidden = FALSE

	if(!antag_datum)
		return
	to_chat(src, span_notice("Lux: <b>[antag_datum.lux]/[antag_datum.lux_max]</b>"))
	to_chat(src, span_notice("Monuments: <b>[antag_datum.count_standing_monuments()] standing</b>, [antag_datum.monuments_placed]/[antag_datum.monument_limit] placed"))
	to_chat(src, span_notice("Corpses absorbed: <b>[antag_datum.corpses_absorbed]</b>"))
	var/totem_limit = floor(antag_datum.count_standing_monuments() / 2)
	to_chat(src, span_notice("Totems: <b>[antag_datum.count_active_totems()]/[totem_limit]</b> placed"))
	to_chat(src, span_notice("Active ability: <b>[active_ability]</b>"))
	if(world.time < ability_cooldown)
		to_chat(src, span_warning("Cooldown: [round((ability_cooldown - world.time) / 10, 1)]s remaining"))

/mob/dead/observer/rogue/scadu/verb/scadu_scan_bog()
	set name = "Scry Bog"
	set category = "Scadu"
	set hidden = FALSE

	var/list/found = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.client || !H.mind || HAS_TRAIT(H, TRAIT_ANTISCRYING))
			continue
		if(istype(get_area(H), /area/rogue/outdoors/bograt))
			found += H

	if(!found.len)
		to_chat(src, span_notice("No souls wander the bog."))
		return

	to_chat(src, span_notice("SOULS IN THE BOG"))
	for(var/mob/living/carbon/human/H in found)
		var/area/A = get_area(H)
		to_chat(src, span_notice("<b>[H.real_name]</b> [A.name] <a href='byond://?src=[REF(src)];scadu_tp=[REF(H)]'>Go</a>"))

/mob/living/carbon/human/species/human/northern/scadu_manifest
	var/reverting = FALSE

/mob/living/carbon/human/species/human/northern/scadu_manifest/proc/revert()
	if(reverting)
		return
	reverting = TRUE
	var/datum/antagonist/scadu/antag = GLOB.scadu_persistent_datum
	if(antag && !QDELETED(antag))
		antag.manifest_revert_time = world.time + 30 SECONDS
	var/datum/job/roguetown/scadu/J = SSjob.GetJob("Scadu")
	if(J && mind)
		J.do_scadu_transform(src, mind)

/mob/living/carbon/human/species/human/northern/scadu_manifest/Life(seconds_per_tick, delta_time)
	if(reverting)
		return
	if(getBruteLoss() > 0 || getFireLoss() > 0)
		revert()
		return
	if(!istype(get_area(src), /area/rogue/outdoors/bograt))
		revert()
		return
	for(var/obj/structure/fluff/psycross/P in range(5, src))
		revert()
		return
	for(var/mob/living/carbon/human/H in range(5, src))
		if(!H.client || !H.mind || HAS_TRAIT(H, TRAIT_ANTISCRYING))
			continue
		H.apply_status_effect(/datum/status_effect/buff/scadu_presence)
	. = ..()

/mob/living/carbon/human/species/human/northern/scadu_manifest/death(gibbed, nocutscene = FALSE)
	revert()

/mob/living/carbon/human/species/human/northern/scadu_manifest/verb/return_to_shadow()
	set name = "Return to Shadow"
	set category = "Scadu"
	set hidden = FALSE
	revert()

/mob/living/carbon/human/species/human/northern/scadu_manifest/verb/whisper_mind()
	set name = "Whisper"
	set category = "Scadu"
	set hidden = FALSE
	var/mob/living/target = null
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in oview(7, src))
		if(H.client && H.mind)
			candidates += H
	if(!candidates.len)
		to_chat(src, span_warning("No souls are close enough to hear me."))
		return
	target = input(src, "Speak into whose mind?", "Whisper") as null|anything in candidates
	if(!target || QDELETED(target) || !target.client)
		return
	var/msg = html_decode(input(src, "Speak to [target.real_name]:", "Speak") as null|text)
	if(!msg || !length(msg))
		return
	to_chat(target, span_userdanger("<i>A voice whispers into your mind...</i> \"[msg]\""))
	target.playsound_local(get_turf(target), 'sound/vo/mobs/ghost/aggro (2).ogg', 50, TRUE)
	to_chat(src, span_notice("Your thought reaches [target.real_name]."))

/mob/living/carbon/human/species/goblin/npc/scadu_goblin/after_creation()
	..()
	faction = list("scadu_servants")

/mob/living/simple_animal/hostile/rogue/mirespider_lurker/scadu/Initialize(mapload)
	. = ..()
	faction = list("scadu_servants")

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/scadu/Initialize(mapload)
	. = ..()
	faction = list("scadu_servants")
