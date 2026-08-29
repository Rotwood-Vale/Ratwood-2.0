/datum/patron/inhumen/graggar
	name = "Graggar"
	domain = "Conquest, Cruelty, Kinslaying, Slaughter, Cannibalism, Domination"
	desc = "The Gorebound Star was a half-orc warlord who sought to strike Ravox down in rage at the cruel fate of His lover. He was decapitated, and His head revived as a mutilated aberration of blue flesh and sickening tendrils. Gazing upon the Star will drive anyone mad."
	worshippers = "Fallen Warriors, Cannibals, Serial Killers, The Cruel"
	virtues = "Martial Prowess, Dominance, Violence"
	sins = "Weakness, Servility, Cowardice"
	mob_traits = list(TRAIT_HORDE, TRAIT_ORGAN_EATER)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/graggar_bloodrage				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/call_to_slaughter 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/blood_net 			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revel_in_slaughter 			= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/graggar				= CLERIC_T4,
	)
	confess_lines = list(
		"GRAGGAR IS THE BEAST I WORSHIP!",
		"THROUGH VIOLENCE, DIVINITY!",
		"THE GOD OF CONQUEST DEMANDS BLOOD!",
	)
	storyteller = /datum/storyteller/graggar

/datum/patron/inhumen/graggar/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("Foul fumes billow outward as [target] is restored!")
	*message_self = span_notice("A noxious scent burns my nostrils, but I feel better!")

	var/bonus = 0

	for(var/obj/effect/decal/cleanable/blood/blood in oview(5, target))
		bonus = min(bonus + 0.1, 2.5)

	if(!bonus)
		return

	*situational_bonus = bonus
	*conditional_buff = TRUE

/datum/patron/inhumen/graggar/on_gain(mob/living/living)
	. = ..()

	RegisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

/datum/patron/inhumen/graggar/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER

	drinker.adjust_hydration(8)

/datum/patron/inhumen/graggar/on_loss(mob/living/living)
	. = ..()

	UnregisterSignal(living, COMSIG_LIVING_DRINKED_LIMB_BLOOD)

// When bleeding, near blood on ground, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/graggar/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if actively bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer near blood.
	for(var/obj/effect/decal/cleanable/blood in view(3, get_turf(follower)))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Graggar to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, near fresh blood or draw blood of my own!"))
	return FALSE

/// - GRAGGAR REVIVAL - ///

/obj/effect/proc_holder/spell/invoked/resurrect/graggar
	name = "Blood for Graggar"
	desc = "You cannot dominate the dead. Place GRAGGAR'S EYES upon a fallen mortal, granting them the\
	chance to fight again... for a price. Their intelligence will be drained for some time, or until\
	they slay an orcish challenger from His realm."
	debuff_type = /datum/status_effect/debuff/graggar_challenge
	alt_required_items = list(/obj/item/organ/heart = 1)
	required_items = list(/obj/item/organ/heart = 1)
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/graggar

/// CHALLENGE PORTAL

/obj/structure/primal_rift
	name = "primal rift"
	desc = "A jagged tear in reality smelling of blood."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	color = "#570f04"
	anchored = TRUE
	density = FALSE
	max_integrity = 600

	/// Who is our cowardice target
	var/mob/living/target
	var/orc_count = 0
	/// Orcs to spawn, let's keep this at one because carbon orcs are wicked.
	var/max_orcs = 1
	/// When has our cowardice target been out of range for too long?
	var/out_of_range_since = 0
	var/lifetime = 15 MINUTES

/obj/structure/primal_rift/Initialize(mapload)
	. = ..()
	spawn_orcs()

	// Auto-delete after 15 minutes
	addtimer(CALLBACK(src, PROC_REF(expire)), lifetime)
	START_PROCESSING(SSobj, src)

/obj/structure/primal_rift/process()
	if(!target || QDELETED(target) || target.stat == DEAD)
		return
	var/dist = get_dist(src, target)
	if(dist > 7)
		// First time crossing the line? Log it and warn once.
		if(!out_of_range_since)
			out_of_range_since = world.time
			to_chat(target, span_userdanger("The rift pulses angrily! Return to the challenge immediately or face the consequences!"))
			return

		// Has it been 5 seconds since that first warning?
		if(world.time >= out_of_range_since + 5 SECONDS)
			trigger_consequences()
	else
		// They are back in range. Reset the tracking.
		out_of_range_since = 0

/obj/structure/primal_rift/proc/spawn_orcs()
	var/turf/T = get_turf(src)
	for(var/i in 1 to max_orcs)
		var/mob/living/carbon/human/species/orc/npc/warlord/O = new(T)
		O.visible_message(span_danger("[O] step out of the rift, axes drawn!"))
		O.AddComponent(/datum/component/rift_bound, src)
		orc_count++

/datum/component/rift_bound
	var/obj/structure/primal_rift/linked_portal

/datum/component/rift_bound/Initialize(obj/structure/primal_rift/rift)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	linked_portal = rift
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/rift_bound/proc/on_death()
	SIGNAL_HANDLER
	if(linked_portal)
		linked_portal.orc_died()
	qdel(src)

/obj/structure/primal_rift/proc/orc_died()
	orc_count--
	if(orc_count <= 0)
		visible_message(span_notice("With its champions defeated, the primal rift collapses."))
		target?.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
		qdel(src)

/obj/structure/primal_rift/proc/expire()
	visible_message(span_warning("The primal rift destabilizes and vanishes into nothingness."))
	qdel(src)

/obj/structure/primal_rift/proc/trigger_consequences()
	to_chat(target, span_boldannounce("Graggar punishes your cowardice!"))
	var/datum/status_effect/debuff/graggar_challenge/G = target.has_status_effect(/datum/status_effect/debuff/graggar_challenge)
	if(G)
		G.trigger_failure_consequences(target)
		target.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
	qdel(src)

/obj/structure/primal_rift/Destroy()
	target?.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
	STOP_PROCESSING(SSobj, src)
	return ..()

/// STATUS EFFECT

/atom/movable/screen/alert/status_effect/graggar_challenge
	name = "Blood debt"
	desc = "Graggar demands blood be spilt in exchange for his mercy! Summon the rift! Prove yourself! Cowardice is not an option!"
	icon_state = "pom_regret"

/datum/status_effect/debuff/graggar_challenge
	id = "graggar_challenge"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/graggar_challenge
	var/creation_time
	var/failure_time = 15 MINUTES

	effectedstats = list(
		STATKEY_INT = -10 // Graggar values brawn over brain
	)

/datum/status_effect/debuff/graggar_challenge/on_apply()
	. = ..()
	creation_time = world.time
	to_chat(owner, span_userdanger("Your mind feels clouded by a primal bloodlust. Graggar demands a challenge! Summon the rift before your time runs out!"))

	// Grant the summoning spell
	var/obj/effect/proc_holder/spell/invoked/summon_rift/S = new(owner)
	owner.mind?.AddSpell(S)

/datum/status_effect/debuff/graggar_challenge/on_remove()
	// If the duration ran out naturally (didn't get cleared by the rift)
	if(world.time >= (creation_time + failure_time - 5))
		to_chat(owner, span_userdanger("You failed to prove your worth to Graggar!"))
		trigger_failure_consequences(owner)

	// Cleanup the spell if they still have it
	for(var/obj/effect/proc_holder/spell/invoked/summon_rift/S in owner.mind?.spell_list)
		owner.mind.RemoveSpell(S)
		qdel(S)
	. = ..()

/datum/status_effect/debuff/graggar_challenge/proc/trigger_failure_consequences(mob/living/carbon/human/H)
	if(!istype(H))
		return

	to_chat(H, span_boldannounce("Your bones snap under the weight of your own cowardice!"))
	playsound(H, 'sound/combat/fracture/fracturedry (1).ogg', 100, TRUE)

	// Apply fractures to arms. I'd break legs too but we have to account for player error. (like summoning the rift whilst you're in the rimboe)
	var/list/limbs = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/zone in limbs)
		var/obj/item/bodypart/BP = H.get_bodypart(zone)
		if(BP)
			BP.add_wound(/datum/wound/fracture/no_bleed)

/// Helper spell

/obj/effect/proc_holder/spell/invoked/summon_rift
	name = "Summon Primal Rift"
	desc = "Challenge the rift-born to clear your blood-debt. Must be cast on a nearby floor. Make sure to kill all foes, Graggar will not tolerate further acts of mercy."
	invocation_type = "shout"
	invocations = list("GRAGGAR, WITNESS ME!")
	recharge_time = 5 SECONDS
	chargetime = 0.1 SECONDS
	var/summoned = FALSE
	// Let's make it hard to cheese this with a death trap box or something
	range = 2

/obj/effect/proc_holder/spell/invoked/summon_rift/cast(list/targets, mob/living/user)
	if(summoned)
		to_chat(user, span_warning("The rift was already summoned!"))
		revert_cast()
		return FALSE

	var/turf/T = targets[1]
	if(!isturf(T) || T.density)
		to_chat(user, span_warning("The rift needs solid ground to tear open!"))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user] slams their fist into the ground, tearing a crimson hole in reality!"))
	var/obj/structure/primal_rift/R = new(T)
	R.target = user
	summoned = TRUE
	return TRUE
