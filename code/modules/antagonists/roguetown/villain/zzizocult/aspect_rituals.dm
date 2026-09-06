GLOBAL_LIST_INIT(zizo_aspects, list(
	"strand" = "Dreams, prophecy, and passage between realms.<BR>Through its signs, She gathered her faithful.<BR><BR><B>PASSIVE:</B> DREAM JAUNT - BRING YOURSELF AND ANY YOU GRAB INTO THE DREAM.<BR><BR><B>ACTIVE:</B> PASSAGE - TRANSFORM A SERVANTRY RUNE INTO A PORTAL.<BR><BR><B>REMNANT:</B> CURSE OF RECALL - USE A SERVANTRY RUNE TO SUMMON YOUR TARGET.",
	"pitch" = "Fire, shadow, and chaos.<BR>The tool to split the land for Her coming.<BR><BR><B>PASSIVE:</B> IMMUNITY TO FLAME.<BR><BR><B>ACTIVE:</B> SCADUFORM - USE A FLESHCRAFTING SIGIL TO TRANSCEND INTO A DARK FORM. PERMANENT.<BR><BR><B>REMNANT:</B> CURSE OF RADIANCE - USE A FLESHCRAFTING SIGIL TO CURSE YOUR TARGET WITH FLESH THAT BURNS IN LIGHT.",
	"toil" = "Lightning, labor, and lyfe.<BR>What prepares and preserves us from Her coming.<BR><BR><B>PASSIVE:</B> PROGRESS - HEAL THE TARGET AND MEND THEIR ITEMS.<BR><BR><B>ACTIVE:</B> MEND - USE A TRANSMUTATION SIGIL TO FIX ITEMS AND PEOPLE. CONSUMES A DARK CRYSTAL ON THE NORTH SIDE TO REVIVE.<BR><BR><B>REMNANT:</B> CURSE OF WHISPERS - USE A TRANSMUTATION SIGIL TO INVITE THE TARGET INTO THE CULT.",
	"bite" = "Winter, bone, and death.<BR>The eternal life She promised us.<BR><BR><B>PASSIVE:</B> ACCESS TO NECROMANCY SPELLS.<BR><BR><B>ACTIVE:</B> RAISE DEADITE - RAISE A CORPSE INTO A PALE DEADITE THAT CAN USE TOOLS, BUT NOT WEAPONS. CAN BE REMOTELY VIEWED AND DETONATED FOR DEVASTATING AREA OF EFFECT DAMAGE.<BR><BR><B>REMNANT:</B> NONE.",
	"rot" = "Infection, hatred, and murder.<BR>With this, She will kill the world.<BR><BR><B>PASSIVE:</B> IMMUNITY TO POISON. TRANSFUSE - GRAB SOMEONE TIGHTLY AND TRANSFUSE ALL REAGENTS FROM YOUR BLOODSTREAM INTO THEM.<BR><BR><B>ACTIVE:</B> BLIGHT - PETRIFY THE NEARBY AREA INTO STONE THAT DAMAGES NON-CULTISTS WHO STEP UPON IT.<BR><BR><B>REMNANT:</B> CURSE OF BLACK ROT - MAKE THE TARGET DEATHLY ILL.",
	"noise" = "Sound, knowledge, and madness.<BR>What will come after Her.<BR><BR><B>PASSIVE:</B> SEE THE LIVING THROUGH WALLS.<BR><BR><B>ACTIVE:</B> SPOOK - BECOME INVISIBLE AND ETHEREAL TO MOVE THROUGH WALLS AND OBSERVE FOR A SHORT TIME. RETURNS YOU TO THE SIGIL AFTER.<BR><BR><B>REMNANT:</B> CURSE OF BABEL - THE TARGET FORGETS THE COMMON TONGUE.",
	"blood" = "Connection, protection, and devotion.<BR>She never liked this one.<BR><BR><B>PASSIVE:</B> NONE.<BR><BR><B>ACTIVE:</B> SNARE - USE A FLESHCRAFTING SIGIL TO CREATE A DEADLY TRAP. WEAPONS STUN YOUR FOE. ORGANS POISON THEM. ANYTHING ELSE MAKES THEM BLEED.<BR><BR><B>REMNANT:</B> USE A FLESHCRAFTING RUNE AND TWO BLOOD-FILLED LEECHES TO CONNECT TWO TARGETS. THEY WILL SLOWLY DIE IF APART.",
	))

GLOBAL_LIST_EMPTY(zizo_portals)

// HELPERS !!!

/proc/is_zizo(mob/M)
	return M && (is_zizocultist(M.mind) || is_zizolackey(M.mind))

/proc/absorb_lux(mob/living/carbon/human/target, turf/T)
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped))
		return FALSE
	target.apply_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped)
	target.Unconscious(2 MINUTES)
	target.Jitter(4)
	target.visible_message(span_danger("[target]'s memory is wiped clean! They will completely forget what happened and who did it to them. In 2 minutes, they shall wake."))
	to_chat(target, span_danger("THE LUX IS TORN FROM YOUR SOUL. YOUR MEMORY BECOMES A BLUR. YOU CAN'T REMEMBER WHO DID THIS TO YOU, OR ANY DETAILS ABOUT HOW IT HAPPENED."))
	new /obj/item/necro_relics/necro_crystal(T)
	return TRUE

/proc/find_remnant(mob/user, turf/center)
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			if(istype(L.fed_from.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
				to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
				return FALSE
			return L
	to_chat(user, span_warning("Empty."))

/proc/recolor_accessory(accessory_type, hex)
	var/datum/sprite_accessory/A = SPRITE_ACCESSORY(accessory_type)
	var/list/colors = list()
	for(var/i in 1 to A.color_keys)
		colors += "#[hex]"
	return color_list_to_string(colors)

/proc/pick_deadite(mob/living/carbon/human/H, title)
	var/list/choices = list()
	for(var/mob/living/D in H.deadites_controlled)
		if(!QDELETED(D) && D.stat != DEAD)
			choices += D
	if(!length(choices))
		to_chat(H, span_warning("No deadites left."))
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/deadite_sight)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/deadite_burst)
		return
	return input(H, title, "DEADITE") as null|anything in choices


/datum/ritual/strand
	abstract_type = /datum/ritual/strand
	required_aspect = "strand"

/datum/ritual/pitch
	abstract_type = /datum/ritual/pitch
	required_aspect = "pitch"

/datum/ritual/toil
	abstract_type = /datum/ritual/toil
	required_aspect = "toil"

/datum/ritual/bite
	abstract_type = /datum/ritual/bite
	required_aspect = "bite"

/datum/ritual/rot
	abstract_type = /datum/ritual/rot
	required_aspect = "rot"

/datum/ritual/noise
	abstract_type = /datum/ritual/noise
	required_aspect = "noise"

/datum/ritual/blood
	abstract_type = /datum/ritual/blood
	required_aspect = "blood"

/datum/ritual/servantry/aspect
	name = "Bestow Aspect"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	is_cultist_ritual = TRUE

/datum/ritual/servantry/aspect/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		new /obj/item/necro_relics/necro_crystal(center)
		return
	if(!is_zizo(target))
		to_chat(user, span_warning("THEIR MIND IS CLOSED."))
		new /obj/item/necro_relics/necro_crystal(center)
		return
	if(HAS_TRAIT(target, TRAIT_ASPECTED))
		to_chat(user, span_warning("THEY ARE ALREADY AN INITIATE."))
		new /obj/item/necro_relics/necro_crystal(center)
		return
	var/contents = "THESE ARE THE SIGNS BY WHICH YOU WILL KNOW ME.<BR>--------------<BR>"
	for(var/key in GLOB.zizo_aspects)
		contents += "<b><a href='?src=[REF(src)];pick=[key];target=[REF(target)]'>[uppertext(key)]</a></b><BR>[GLOB.zizo_aspects[key]]<BR><BR>"
	var/datum/browser/popup = new(target, "aspectmenu", "ZIZO", 420, 520)
	popup.set_content(contents)
	popup.open(FALSE)

/datum/ritual/servantry/aspect/Topic(href, href_list)
	var/mob/living/carbon/human/target = locate(href_list["target"])
	if(!target || usr != target || HAS_TRAIT(target, TRAIT_ASPECTED))
		return
	var/choice = href_list["pick"]
	if(!choice || !GLOB.zizo_aspects[choice])
		return
	target.aspect = choice
	ADD_TRAIT(target, TRAIT_ASPECTED, TRAIT_GENERIC)
	switch(choice)
		if("strand")
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dream_jaunt)
		if("rot")
			ADD_TRAIT(target, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rot_transfuse)
		if("bite")
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer)
		if("pitch")
			ADD_TRAIT(target, TRAIT_NOFIRE, TRAIT_GENERIC)
		if("noise")
			ADD_TRAIT(target, TRAIT_THERMAL_VISION, TRAIT_GENERIC)
		if("toil")
			target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/toil_mend)
	to_chat(target, span_boldnotice("Zizo grants me the mysteries of [choice]!"))
	target.Jitter(4)
	playsound(target, 'sound/villain/male_talk1.ogg', 60, TRUE)
	target << browse(null, "window=aspectmenu")

// STRAND

/obj/effect/proc_holder/spell/invoked/dream_jaunt
	name = "Dream Jaunt"
	desc = "Bring yourself and whoever you hold into the dream."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "jaunt"
	range = 0
	movement_interrupt = FALSE
	chargedloop = null
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/dream_jaunt/cast(list/targets, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return FALSE
	send_to_dream(user)
	if(ishuman(user.pulling))
		send_to_dream(user.pulling)
	return TRUE

/proc/send_to_dream(mob/living/carbon/human/target, status_type = /datum/status_effect/dream_teleport/strand)
	var/area/dream_area = GLOB.areas_by_type[/area/rogue/underworld/dream]
	var/turf/origin = get_turf(target)
	if(!dream_area || !origin)
		return
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(dream_area))
		if(!T.density)
			safe_turfs += T
	if(!safe_turfs.len || !do_teleport(target, pick(safe_turfs)))
		return
	GLOB.players_in_dream |= target
	origin.visible_message(span_danger("[target] vanishes!"))
	playsound(origin, 'sound/misc/area.ogg')
	target.apply_status_effect(status_type, origin)

/datum/status_effect/dream_teleport/strand
	duration = 30 SECONDS

/datum/status_effect/dream_teleport/recall
	duration = 3 MINUTES

/datum/ritual/strand/strandsend
	name = "Passage"
	center_requirement = /mob/living/carbon/human
	required_aspect = "strand"

/datum/ritual/strand/strandsend/invoke(mob/living/user, turf/center)
	var/obj/effect/decal/cleanable/sigil/S = locate() in center
	if(!S)
		return
	if(do_after(user, 3 SECONDS))
		S.set_sigil_type("Portal")
	else
		return
	to_chat(user, span_notice("AN EYE IS A PASSAGE."))

/datum/ritual/strand/strandrecall
	name = "Curse of Recall"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "strand"
	keep_center = TRUE

/datum/ritual/strand/strandrecall/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	if(remnant.fed_from == SSticker.rulermob)
		to_chat(user, span_danger("The Sun Queen protects this soul!"))
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	qdel(remnant)
	to_chat(user, span_notice("ALL MEN OBEY THE DREAMCALL. I HAVE 1 MINUTE TO PREPARE. ANYONE I AM GRABBING WILL BE BROUGHT WITH ME."))
	to_chat(victim, span_userdanger("I FEEL SOMETHING HORRIBLE COMING. I HAVE 1 MINUTE TO PREPARE. ANYONE I AM GRABBING WILL BE BROUGHT WITH ME."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(dreamcall), user, victim), 1 MINUTES)

/proc/dreamcall(mob/living/user, mob/living/victim)
	for(var/mob/living/M in list(user, victim))
		if(QDELETED(M) || !ishuman(M))
			continue
		send_to_dream(M, /datum/status_effect/dream_teleport/recall)
		if(ishuman(M.pulling))
			send_to_dream(M.pulling, /datum/status_effect/dream_teleport/recall)

// TOIL

/obj/effect/proc_holder/spell/invoked/toil_mend
	name = "Progress"
	desc = "Heals the target and mends their equipment."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "toil"
	sound = 'sound/magic/lightning.ogg'
	range = 7
	recharge_time = 10 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/invoked/toil_mend/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		return FALSE
	target.electrocute_act(1, src, 1, SHOCK_NOSTUN)
	playsound(target, 'sound/magic/lightning.ogg', 60, TRUE)
	target.apply_status_effect(/datum/status_effect/buff/healing, 10, TRUE)
	for(var/obj/item/I in target.get_equipped_items())
		I.obj_integrity = min(I.obj_integrity + (I.max_integrity * 0.2), I.max_integrity)
	to_chat(target, span_notice("I AM MENDED!"))
	return TRUE

/datum/ritual/toil/mend
	name = "Mend"
	required_aspect = "toil"

/datum/ritual/toil/mend/invoke(mob/living/user, turf/center)
	for(var/obj/item/I in center)
		I.obj_integrity = I.max_integrity
		I.shoddy_repair = FALSE
		I.repair_coverage()
	new /obj/effect/temp_visual/thunderstrike_actual(center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target == user)
		to_chat(user, span_notice("ALL THINGS MAY BE REPAIRED, BUT NOT YOUR OWN BODY. FOOL."))
		return
	if(target.stat == DEAD)
		var/obj/item/necro_relics/necro_crystal/crystal = locate() in center
		if(!crystal)
			to_chat(user, span_warning("THE DEAD REQUIRE A DARK CRYSTAL."))
			return
		qdel(crystal)
		ADD_TRAIT(target, TRAIT_ROTMAN, TRAIT_GENERIC)
		to_chat(user, span_notice("[target] convulses!"))
	else
		to_chat(user, span_notice("[target] is made whole!"))
	target.revive(full_heal = TRUE, admin_revive = TRUE)
	target.emote("scream")

/datum/ritual/toil/cultoffer
	name = "Curse of Whispers"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "toil"
	keep_center = TRUE

/datum/ritual/toil/cultoffer/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	var/mob/living/carbon/human/victim = remnant.fed_from
	if(!victim.client || is_zizo(victim))
		to_chat(user, span_warning("THEY CANNOT BE SWAYED."))
		return
	qdel(remnant)
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
	var/answer = tgui_alert(victim, "SHE WHISPERS IN YOUR EAR. A RARE PRIVELAGE. SHE WANTS YOU. DO YOU ACCEPT?", "ZIZO", list("Accept", "Refuse"))
	if(answer == "Accept" && PR)
		PR.add_cultist(victim.mind)
		to_chat(victim, span_notice("I SEE THE TRUTH NOW. SHE NEEDS ME."))
		to_chat(user, span_warning("THEY ACCEPT."))
	else
		to_chat(user, span_warning("THEY REFUSED."))

// BITE

/datum/ritual/bite/raisedeadite
	name = "Raise Deadite"
	center_requirement = /mob/living/carbon/human
	required_aspect = "bite"

/datum/ritual/bite/raisedeadite/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/corpse = locate() in center.contents
	if(!corpse || corpse.stat != DEAD || !corpse.mind)
		to_chat(user, span_warning("YOU NEED A CORPSE."))
		return
	if(HAS_TRAIT(corpse, TRAIT_ZOMBIE_IMMUNE))
		to_chat(user, span_warning("THEY SHALL NOT RISE."))
		return
	playsound(get_turf(corpse), 'sound/magic/magnet.ogg', 80, TRUE)
	corpse.set_blood_volume(BLOOD_VOLUME_NORMAL)
	corpse.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	corpse.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	corpse.heal_wounds(INFINITY)
	corpse.zombie_check_can_convert()
	var/datum/antagonist/zombie/Z = corpse.mind.has_antag_datum(/datum/antagonist/zombie)
	if(Z)
		Z.wake_zombie(TRUE)
	ADD_TRAIT(corpse, TRAIT_ROTMAN, TRAIT_GENERIC)
	ADD_TRAIT(corpse, TRAIT_PACIFISM, TRAIT_GENERIC)
	REMOVE_TRAIT(corpse, TRAIT_CHUNKYFINGERS, "/datum/antagonist/zombie")
	if(!corpse.dna)
		return
	corpse.dna.species.species_traits |= MUTCOLORS
	corpse.dna.species.fixed_mut_color = "e0eaf5"
	corpse.dna.features["mcolor"] = "e0eaf5"
	corpse.update_body()
	corpse.update_hair()
	for(var/obj/item/bodypart/BP in corpse.bodyparts)
		for(var/datum/bodypart_feature/F in BP.bodypart_features)
			if(F.accessory_type)
				F.accessory_colors = recolor_accessory(F.accessory_type, "e0eaf5")
		BP.invalidate_limb_cache()
	for(var/obj/item/organ/O in corpse.internal_organs)
		if(O.accessory_type)
			O.accessory_colors = recolor_accessory(O.accessory_type, "e0eaf5")
	corpse.icon_render_key = null
	corpse.update_body_parts()
	if(ishuman(user))
		var/mob/living/carbon/human/master = user
		if(!LAZYLEN(master.deadites_controlled))
			master.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/deadite_sight)
			master.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/deadite_burst)
		LAZYADD(master.deadites_controlled, corpse)
	corpse.emote("scream")
	to_chat(corpse, span_userdanger("IT IS TOO COLD TO REST. I RISE AGAIN TO SERVE.<br>[user.real_name] is my master, and I must obey their commands."))

/obj/effect/proc_holder/spell/self/deadite_sight
	name = "Deadite Scry"
	desc = "See through your deadite's eyes."
	overlay_state = "gravemark"
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/deadite_sight/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/mob/living/target = pick_deadite(H, "WHOM?")
	if(!target)
		revert_cast()
		return FALSE
	var/mob/dead/observer/screye/S = H.scry_ghost()
	if(!S)
		revert_cast()
		return FALSE
	S.ManualFollow(target)
	H.visible_message(span_danger("[H]'s eyes roll back into [H.p_their()] head."))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 15 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/deadite_burst
	name = "Deadite Burst"
	desc = "Remotely detonate a deadite to cause significant damage to everyone around it. Kills the deadite."
	overlay_state = "gravemark"
	recharge_time = 30 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/deadite_burst/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/mob/living/target = pick_deadite(H, "WHOM?")
	if(!target)
		revert_cast()
		return FALSE
	explosion(get_turf(target), 0, 2, 3, 4, flame_range = 3)
	if(target.stat != DEAD)
		target.death()
	H.deadites_controlled -= target
	return TRUE

// ROT

/obj/effect/proc_holder/spell/self/rot_transfuse
	name = "Transfuse"
	desc = "Transfuse all reagents in your bloodstream to the target you're holding."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "transfuse"
	recharge_time = 5 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/self/rot_transfuse/cast(list/targets, mob/user = usr)
	. = ..()
	var/obj/item/grabbing/G = user.get_active_held_item()
	if(!istype(G) || !isliving(G.grabbed))
		return FALSE
	if(!G)
		to_chat(user, span_warning("I need to be grabbing someone."))
		revert_cast()
		return FALSE
	var/mob/living/victim = G.grabbed
	if(user.reagents && victim.reagents && user.reagents.total_volume)
		user.reagents.trans_to(victim, user.reagents.total_volume, method = INJECT)
	to_chat(user, span_notice("I transfuse into [victim]."))
	return TRUE

/turf/open/floor/rogue/naturalstone/rot
	color = "#30c307"

/turf/open/floor/rogue/naturalstone/rot/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!ishuman(AM) || is_zizo(AM))
		return
	var/mob/living/carbon/human/H = AM
	H.adjustToxLoss(5)
	H.adjustFireLoss(3)

/obj/structure/blight_pillar
	name = "rotting pillar"
	desc = "A pillar of fused bone and diseased flesh. Destroy it!"
	icon = 'icons/roguetown/maniac/creations.dmi'
	icon_state = "creation1"
	anchored = TRUE
	density = TRUE
	max_integrity = 300
	var/radius = 3
	var/list/turf_data = list()

/obj/structure/blight_pillar/Initialize(mapload)
	. = ..()
	var/turf/center = get_turf(src)
	for(var/turf/T in range(radius, center))
		if(isclosedturf(T) && !istype(T, /turf/closed/indestructible))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/closed/mineral/rogue, flags = CHANGETURF_IGNORE_AIR)
		else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/naturalstone/rot))
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/naturalstone/rot, flags = CHANGETURF_IGNORE_AIR)

/obj/structure/blight_pillar/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	visible_message(span_danger("Lux fills the barren stone and returns lyfe to the land!"))
	playsound(src, 'sound/foley/breaksound.ogg', 50, TRUE)
	return ..()

/datum/ritual/rot/blight
	name = "Blight"
	center_requirement = /mob/living/carbon/human
	required_aspect = "rot"

/datum/ritual/rot/blight/invoke(mob/living/user, turf/center)
	new /obj/structure/blight_pillar(center)
	to_chat(user, span_notice("THE LAND ROTS."))

/datum/ritual/rot/plague
	name = "Curse of Black Rot"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "rot"
	keep_center = TRUE

/datum/ritual/rot/plague/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	remnant.fed_from.apply_status_effect(/datum/status_effect/black_rot)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("THEY HAVE THE ROT WITHIN THEM, NOW."))

// NOISE

/obj/effect/dummy/phased_mob/slaughter/noise
	var/nextmove = 0

/obj/effect/dummy/phased_mob/slaughter/noise/relaymove(mob/user, direction)
	if(world.time < nextmove)
		return
	nextmove = world.time + 4
	forceMove(get_step(src, direction))

/mob/living/proc/end_jaunt(obj/effect/dummy/phased_mob/slaughter/holder, turf/return_turf)
	if(QDELETED(holder))
		return
	forceMove(return_turf || get_turf(holder))
	qdel(holder)

/datum/ritual/noise/ghost_form
	name = "Spook"
	center_requirement = /mob/living/carbon/human
	required_aspect = "noise"

/datum/ritual/noise/ghost_form/invoke(mob/living/user, turf/center)
	. = ..()
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target || target.aspect != "noise")
		to_chat(user, span_warning("NOT FOR THEM."))
		return
	var/turf/origin = get_turf(target)
	var/obj/effect/dummy/phased_mob/slaughter/noise/holder = new(origin)
	target.visible_message(span_warning("[target] fades into nothing."))
	target.forceMove(holder)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, end_jaunt), holder, origin), 15 SECONDS)
	return TRUE

/datum/ritual/noise/forgettongue
	name = "Curse of Babel"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "noise"
	keep_center = TRUE

/datum/ritual/noise/forgettongue/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	remnant.fed_from.remove_language(/datum/language/common, source = LANGUAGE_SOURCE_ALL)
	remnant.fed_from.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("IT EATS AWAY MEANING AND LEAVES NOTHING BUT NOISE."))

// PITCH

/datum/component/light_vulnerability
	var/burn_damage = 5

/datum/component/light_vulnerability/Initialize(damage = 5, duration = 0)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	burn_damage = damage
	if(duration)
		QDEL_IN(src, duration)
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(check_light))

/datum/component/light_vulnerability/proc/check_light(mob/living/carbon/human/H)
	if(!ishuman(H) || H.stat == DEAD)
		return
	var/turf/T = get_turf(H)
	if(T && T.get_lumcount() >= 0.75)
		H.adjustFireLoss(burn_damage)
		if(prob(30))
			to_chat(H, span_danger("THE LIGHT BURNS!"))

/datum/status_effect/shadowform
	id = "shadowform"
	duration = -1
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/shadowform

/datum/status_effect/shadowform/tick()
	var/turf/T = get_turf(owner)
	if(T && T.get_lumcount() < 0.75)
		owner.adjustBruteLoss(-5)
		owner.adjustFireLoss(-5)
	for(var/obj/item/I in owner.get_equipped_items() + owner.held_items)
		I.fire_act()
	for(var/obj/item/grabbing/G in owner.held_items)
		if(isliving(G.grabbed))
			var/mob/living/victim = G.grabbed
			victim.fire_act(2, 20)
			victim.adjustFireLoss(10)

/atom/movable/screen/alert/status_effect/shadowform
	name = "SCADUFORM"
	desc = ""
	icon_state = "buff"

/obj/effect/proc_holder/spell/invoked/shadow_snuff
	name = "Snuff"
	desc = "Snuff out a fire or light."
	range = 7
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocandle"
	recharge_time = 2 SECONDS
	chargedloop = null

/obj/effect/proc_holder/spell/invoked/shadow_snuff/cast(list/targets, mob/living/user)
	. = ..()
	var/atom/target = targets[1]
	if(!target)
		return FALSE
	if(isobj(target))
		var/obj/O = target
		O.extinguish()
	for(var/obj/O in target.contents)
		O.extinguish()
	return TRUE

/obj/effect/dummy/phased_mob/slaughter/shadow/relaymove(mob/user, direction)
	var/turf/dest = get_step(src, direction)
	if(!dest || dest.get_lumcount() >= 0.75)
		to_chat(user, span_warning("THERE IS LIGHT THERE."))
		return
	forceMove(dest)

/obj/effect/proc_holder/spell/self/shadow_jaunt
	name = "Scadu Jaunt"
	desc = "Turn invisible and move through walls. Only functions in darkness."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "zizocloud"
	recharge_time = 3 MINUTES
	chargedloop = null

/obj/effect/proc_holder/spell/self/shadow_jaunt/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/turf/T = get_turf(user)
	if(T.get_lumcount() >= 0.75)
		to_chat(user, span_warning("IT'S TOO BRIGHT!"))
		revert_cast()
		return FALSE
	var/obj/effect/dummy/phased_mob/slaughter/shadow/holder = new(T)
	user.visible_message(span_warning("[user] melts into the shadows."))
	user.forceMove(holder)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, end_jaunt), holder), 5 SECONDS)
	return TRUE

/datum/ritual/pitch/shadowform
	name = "Scaduform"
	center_requirement = /mob/living/carbon/human
	required_aspect = "pitch"

/datum/ritual/pitch/shadowform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target || target.aspect != "pitch")
		to_chat(user, span_warning("NOT FOR THEM."))
		return
	if(target.has_status_effect(/datum/status_effect/shadowform))
		return
	if(!target.dna)
		return
	target.dna.species.species_traits |= MUTCOLORS
	target.dna.species.fixed_mut_color = "000000"
	target.dna.features["mcolor"] = "000000"
	target.update_body()
	target.update_hair()
	for(var/obj/item/bodypart/BP in target.bodyparts)
		for(var/datum/bodypart_feature/F in BP.bodypart_features)
			if(F.accessory_type)
				F.accessory_colors = recolor_accessory(F.accessory_type, "000000")
		BP.invalidate_limb_cache()
	for(var/obj/item/organ/O in target.internal_organs)
		if(O.accessory_type)
			O.accessory_colors = recolor_accessory(O.accessory_type, "000000")
	target.icon_render_key = null
	target.update_body_parts()
	target.apply_status_effect(/datum/status_effect/shadowform)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadow_snuff)
	target.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/shadow_jaunt)
	target.AddComponent(/datum/component/light_vulnerability)
	for(var/obj/item/I in target.get_equipped_items() + target.held_items)
		I.fire_act()
	var/obj/item/organ/eyes/eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(target, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision
	eyes.Insert(target)
	ADD_TRAIT(target, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_NOMETABOLISM, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_MONSTROUS, TRAIT_GENERIC)
	target.dna.species.name = "???"
	target.emote("scream")
	target.Knockdown(5 SECONDS)
	to_chat(target, span_danger("IT BURNS! IT BURNS! IT STICKS TO MY FLESH AND BURNS!"))

/datum/ritual/pitch/lightcurse
	name = "Curse of Radiance"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "pitch"
	keep_center = TRUE

/datum/ritual/pitch/lightcurse/invoke(mob/living/user, turf/center)
	var/obj/item/natural/worms/leech/remnant = find_remnant(user, center)
	if(!remnant)
		return
	remnant.fed_from.AddComponent(/datum/component/light_vulnerability, 10, 5 MINUTES)
	to_chat(remnant.fed_from, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	remnant.fed_from.emote("scream")
	qdel(remnant)
	to_chat(user, span_notice("THEY SHALL KNOW MY HATRED OF HIS LIGHT."))

// BLOOD

/obj/structure/trap/zizo
	name = "bloody sigil"
	desc = "Strange runics smeared in blood."
	icon = 'icons/obj/sigils.dmi'
	icon_state = "center"
	alpha = 45
	charges = 3
	var/effect = "bleed"

/obj/structure/trap/zizo/Crossed(atom/movable/AM)
	if(is_zizo(AM))
		return
	. = ..()

/obj/structure/trap/zizo/trap_effect(mob/living/L)
	switch(effect)
		if("poison")
			if(L.reagents)
				L.reagents.add_reagent(/obj/item/reagent_containers/glass/bottle/rogue/berrypoison, 15)
			L.emote("scream")
			L.Jitter(4)
			L.visible_message(span_danger("THE SIGIL SPRAYS [L] WITH FOUL BLOOD!"))
		if("stun")
			L.electrocute_act(20, src)
			L.Paralyze(60)
			L.emote("scream")
		else
			L.adjustBruteLoss(125)
			L.emote("scream")
			L.Jitter(4)
			L.visible_message(span_danger("BLOODY BLADES RISE FROM THE GROUND AND REND [L]!"))

/datum/ritual/blood/bloodsnare
	name = "Blood Snare"
	center_requirement = /obj/item
	required_aspect = "blood"
	keep_center = TRUE

/datum/ritual/blood/bloodsnare/invoke(mob/living/user, turf/center)
	var/effect = "bleed"
	if(locate(/obj/structure/trap/zizo) in center)
		return FALSE
	if(locate(/obj/item/organ) in center)
		effect = "poison"
	else if(locate(/obj/item/rogueweapon) in center)
		effect = "stun"
	for(var/obj/item/I in center)
		qdel(I)
	for(var/obj/effect/decal/cleanable/sigil/sig in range(1, center))
		qdel(sig)
	var/obj/structure/trap/zizo/T = new(center)
	T.effect = effect
	to_chat(user, span_notice("THE SIGIL FADES. IT IS READY."))

/datum/status_effect/bloodlink
	id = "bloodlink"
	duration = -1
	tick_interval = 5 SECONDS
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/bloodlink
	var/mob/living/carbon/human/partner

/datum/status_effect/bloodlink/on_creation(mob/living/new_owner, mob/living/carbon/human/linked)
	partner = linked
	. = ..()

/datum/status_effect/bloodlink/on_apply()
	. = ..()
	to_chat(owner, span_danger("WHAT A HORRIBLE NITE TO HAVE A CURSE."))
	owner.emote("scream")

/datum/status_effect/bloodlink/tick()
	if(QDELETED(partner) || partner.stat == DEAD)
		qdel(src)
		return
	if(get_dist(owner, partner) > 7)
		owner.adjustOxyLoss(4)
		owner.Jitter(4)
		if(prob(30))
			to_chat(owner, span_danger("My chest aches! Where is [partner.real_name]?!"))

/atom/movable/screen/alert/status_effect/bloodlink
	name = "Blood Bond"
	desc = "OUR HEARTS BEAT AS ONE. I MUST BE NEAR THEM."
	icon_state = "debuff"

/datum/ritual/blood/bloodbond
	name = "Curse of Blood"
	center_requirement = /obj/item/natural/worms/leech
	required_aspect = "blood"
	keep_center = TRUE

/datum/ritual/blood/bloodbond/invoke(mob/living/user, turf/center)
	var/list/found = list()
	for(var/obj/item/natural/worms/leech/L in center)
		if(L.fed_from && L.blood_storage > 0 && !QDELETED(L.fed_from) && L.fed_from.stat != DEAD)
			found += L
	if(found.len < 2)
		to_chat(user, span_warning("This rite needs two leeches."))
		return
	var/obj/item/natural/worms/leech/L1 = found[1]
	var/obj/item/natural/worms/leech/L2 = found[2]
	var/mob/living/carbon/human/A = L1.fed_from
	var/mob/living/carbon/human/B = L2.fed_from
	if(A == B)
		to_chat(user, span_warning("You can not bind someone to theirself. Fool!"))
		return
	A.apply_status_effect(/datum/status_effect/bloodlink, B)
	B.apply_status_effect(/datum/status_effect/bloodlink, A)
	qdel(L1)
	qdel(L2)
	to_chat(user, span_notice("I BIND [A] AND [B], THEIR HEARTS BEAT AS ONE."))
