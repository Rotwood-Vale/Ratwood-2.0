//Call to Slaughter - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution."
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "call_to_slaughter"
	recharge_time = 5 MINUTES
	invocations = list("LAMBS TO THE SLAUGHTER!")
	invocation_type = "shout"
	sound = 'sound/magic/timestop.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 40

/obj/effect/proc_holder/spell/self/call_to_slaughter/cast(list/targets,mob/living/user = usr)
	for(var/mob/living/carbon/target in view(3, get_turf(user)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/buff/call_to_slaughter)	//Buffs inhumens
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a surge of cold wash over you; leaving your body as quick as it hit.."))	//No effect on Psydonians!
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
	return TRUE

//Unholy Grasp - Turns the viscera in your hand into a net made of gore.
/obj/effect/proc_holder/spell/self/blood_net
	name = "Unholy Grasp"
	desc = "Twist the viscera in your hand into a writhing, unholy net. Cast again to unmake it back into gore. Throw it to snare a foe's legs."
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_grasp"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	releasedrain = 30
	chargedrain = 0
	recharge_time = 10 SECONDS
	miracle = TRUE

/obj/effect/proc_holder/spell/self/blood_net/cast(list/targets, mob/living/user = usr)
	var/obj/item/held_item = user.get_active_held_item()

	if(istype(held_item, /obj/item/net/unholy_grasp))
		var/obj/item/net/unholy_grasp/net = held_item
		net.revert_to_viscera(user, TRUE)
		revert_cast(user) // Unmaking the net doesn't invoke the cooldown.
		return FALSE

	if(!istype(held_item, /obj/item/alch/viscera))
		to_chat(user, span_warning("I'm missing viscera to twist into a net."))
		revert_cast(user)
		return FALSE

	qdel(held_item)
	var/obj/item/net/unholy_grasp/net = new(get_turf(user))
	user.put_in_hands(net)
	user.visible_message(span_danger("The viscera in [user]'s hand twists into a writhing net of gore!"), span_danger("The viscera in my hand twists into a writhing net of gore!"))
	return TRUE

/obj/item/net/unholy_grasp
	name = "visceral net"
	desc = "A writhing snare woven from blood and guts. It won't hold its shape for long outside a caster's grip. Throw it, or it'll collapse back into what it was."
	color = "#80182e"
	w_class = WEIGHT_CLASS_BULKY // No storing these things.
	slot_flags = NONE
	var/about_to_be_thrown = FALSE
	var/was_ensnaring = FALSE
	var/being_destroyed = FALSE

/obj/item/net/unholy_grasp/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_THROW, PROC_REF(on_holder_throw))

/obj/item/net/unholy_grasp/proc/on_holder_throw(mob/thrower, atom/target)
	SIGNAL_HANDLER
	about_to_be_thrown = TRUE
	addtimer(VARSET_CALLBACK(src, about_to_be_thrown, FALSE), 1)

/obj/item/net/unholy_grasp/on_drop()
	return

/obj/item/net/unholy_grasp/dropped(mob/user, silent = FALSE)
	if(user)
		UnregisterSignal(user, COMSIG_MOB_THROW)
	if(was_ensnaring)
		remove_effect()
		return
	if(!about_to_be_thrown)
		revert_to_viscera(user)
		return
	about_to_be_thrown = FALSE
	return ..()

/obj/item/net/unholy_grasp/proc/revert_to_viscera(mob/user, to_hand = FALSE)
	if(being_destroyed)
		return
	being_destroyed = TRUE
	var/turf/T = get_turf(src)
	if(!QDELING(src))
		qdel(src)
	if(!T)
		return
	var/obj/item/alch/viscera/gore = new(T)
	if(to_hand && user)
		user.put_in_hands(gore)
	if(user)
		to_chat(user, span_danger("The unholy net collapses back into a mess of viscera!"))

/obj/item/net/unholy_grasp/ensnare(mob/living/carbon/C, mob/user)
	slipouttime = max(2 SECONDS, 10 SECONDS - max(0, C.STASTR - 10) * 0.5 SECONDS)
	. = ..()
	if(C.legcuffed == src)
		was_ensnaring = TRUE

/obj/item/net/unholy_grasp/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(was_ensnaring)
		return
	remove_effect()

/obj/item/net/unholy_grasp/remove_effect()
	if(being_destroyed)
		return
	being_destroyed = TRUE
	if(iscarbon(loc))
		var/mob/living/carbon/mob_target = loc
		if(mob_target.legcuffed == src)
			mob_target.set_legcuffed(null)
		if(mob_target.has_status_effect(/datum/status_effect/debuff/netted))
			mob_target.remove_status_effect(/datum/status_effect/debuff/netted)
	var/turf/T = get_turf(src)
	if(T)
		new /obj/effect/decal/cleanable/blood(T)
		playsound(T, pick('sound/combat/gib (1).ogg', 'sound/combat/gib (2).ogg'), 50, TRUE)
	if(!QDELING(src))
		qdel(src)

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "The blood of your enemy shall boil, their skin feeling as if it's being ripped apart! Graggar demands their blood must FLOW!!!"
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "revel_in_slaughter"
	recharge_time = 1 MINUTES
	invocations = list("YOUR BLOOD WILL BOIL TILL IT'S SPILLED!")
	invocation_type = "shout"
	sound = 'sound/magic/antimagic.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 70

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/human = targets[1]

	if(!istype(human) || human == user)
		revert_cast()
		return FALSE

	var/success = 0

	for(var/obj/effect/decal/cleanable/blood/blood in view(3, user))
		success++
		qdel(blood)

	if(!success)
		to_chat(user, span_warning("Graggar demands BLOOD to call upon his powers!"))
		revert_cast()
		return FALSE

	var/datum/physiology/phy = human.physiology

	phy.bleed_mod *= 1.5
	phy.pain_mod *= 1.5

	addtimer(VARSET_CALLBACK(phy, bleed_mod, phy.bleed_mod /= 1.5), 25 SECONDS)
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 1.5), 15 SECONDS)

	human.visible_message(span_danger("[human]'s wounds become inflammed as their vitality is sapped away!"))
	to_chat(human, span_warning("My skins feels like pins and needles, as if something were ripping and tearing at me!"))

	return TRUE

//Bloodrage T0 -- Uncapped STR buff.
/obj/effect/proc_holder/spell/self/graggar_bloodrage
	name = "Bloodrage"
	desc = "Grants you unbound strength for a short while."
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("GRAGGAR!! GRAGGAR!! GRAGGAR!!",
		"GRAGGAR! BREAK MY CHAINS!",
		"GRAGGAR! SHATTER MY BINDS!"
	)
	invocation_type = "shout"
	sound = 'sound/magic/bloodrage.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 80
	antimagic_allowed = FALSE
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/graggar_bloodrage/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/human = user
	if(human.resting)
		human.set_resting(FALSE, FALSE)
	human.emote("warcry")
	for(var/effect in purged_effects)
		human.remove_status_effect(effect)
	human.apply_status_effect(/datum/status_effect/buff/bloodrage)
	human.visible_message(span_danger("[human] rises upward, boiling with immense rage!"))
	return TRUE

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
	var/max_orcs = 3
	/// When has our cowardice target been out of range for too long?
	COOLDOWN_DECLARE(out_of_range_since)

/obj/structure/primal_rift/Initialize(mapload)
	. = ..()
	spawn_orcs()

	// Auto-delete after 15 minutes
	addtimer(CALLBACK(src, PROC_REF(expire)), 15 MINUTES)
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
	var/turf/spawn_turf = get_turf(src)
	for(var/orc_index in 3 to max_orcs)
		var/mob/living/carbon/human/species/orc/npc/warlord/orc_warlord = new(spawn_turf)
		orc_warlord.visible_message(span_danger("[orc_warlord] step out of the rift, axes drawn!"))
		orc_warlord.AddComponent(/datum/component/rift_bound, src)
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
	var/datum/status_effect/debuff/graggar_challenge/challenge_effect = target.has_status_effect(/datum/status_effect/debuff/graggar_challenge)
	if(challenge_effect)
		challenge_effect.trigger_failure_consequences(target)
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
	var/obj/effect/proc_holder/spell/invoked/summon_rift/summoning_spell = new(owner)
	owner.mind?.AddSpell(summoning_spell)

/datum/status_effect/debuff/graggar_challenge/on_remove()
	// If the duration ran out naturally (didn't get cleared by the rift)
	if(world.time >= (creation_time + failure_time - 5))
		to_chat(owner, span_userdanger("You failed to prove your worth to Graggar!"))
		trigger_failure_consequences(owner)

	// Cleanup the spell if they still have it
	for(var/obj/effect/proc_holder/spell/invoked/summon_rift/summoning_spell in owner.mind?.spell_list)
		owner.mind.RemoveSpell(summoning_spell)
		qdel(summoning_spell)
	. = ..()

/datum/status_effect/debuff/graggar_challenge/proc/trigger_failure_consequences(mob/living/carbon/human/coward)
	if(!istype(coward))
		return

	to_chat(coward, span_boldannounce("Your bones snap under the weight of your own cowardice!"))
	playsound(coward, 'sound/combat/fracture/fracturedry (1).ogg', 100, TRUE)

	// Apply fractures to arms. I'd break legs too but we have to account for player error. (like summoning the rift whilst you're in the rimboe)
	var/list/limbs = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/zone in limbs)
		var/obj/item/bodypart/bodypart = coward.get_bodypart(zone)
		if(bodypart)
			bodypart.add_wound(/datum/wound/fracture/no_bleed)

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

	var/turf/spawn_turf = targets[1]
	if(!isturf(spawn_turf) || spawn_turf.density)
		to_chat(user, span_warning("The rift needs solid ground to tear open!"))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user] slams their fist into the ground, tearing a crimson hole in reality!"))
	var/obj/structure/primal_rift/rift = new(spawn_turf)
	rift.target = user
	summoned = TRUE
	return TRUE
