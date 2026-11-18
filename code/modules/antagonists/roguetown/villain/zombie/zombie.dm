#define ZOMBIE_FIRST_BITE_CHANCE 15
#define ZOMBIE_BITE_CONVERSION_TIME 1.5 MINUTES

/datum/antagonist/zombie
	name = "Deadite"
	antag_hud_type = ANTAG_HUD_ZOMBIE
	antag_hud_name = "huddead"
	show_in_roundend = FALSE
	rogue_enabled = TRUE
	/// SET TO FALSE IF WE DON'T TURN INTO ROTMEN WHEN REMOVED
	var/become_rotman = FALSE
	var/zombie_start
	/// The body this datum deadified. The mind can move away, a severed head puts it in a brainmob,
	/// and the restore must reach the flesh. Never qdel it, weakref/Destroy() qdels its target
	var/datum/weakref/deadite_body_ref
	var/revived = FALSE

	antag_flags = FLAG_FAKE_ANTAG

	// CACHE VARIABLES SO ZOMBIFICATION CAN BE CURED
	var/was_i_undead = FALSE
	var/special_role
	var/ambushable = TRUE
	var/soundpack_m
	var/soundpack_f

	var/cmode_music
	var/base_species_blood_color
	var/obj/effect/proc_holder/spell/self/zombie_seek/seek_spell
	var/list/base_intents
	/// Default language from before we turned, restored on cure.
	var/prior_default_language

	/// Whether or not we have been turned
	var/has_turned = FALSE
	/// Traits applied to the owner mob when we turn into a zombie
	var/static/list/traits_zombie = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_BREADY,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_NOSLEEP,
		TRAIT_BASHDOORS,
		TRAIT_SPELLCOCKBLOCK,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_ZOMBIE_SPEECH,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_SILVER_WEAK,
		TRAIT_STRONGBITE,
		TRAIT_DEADITE,
	)
	/// Traits applied to the owner when we are cured and turn into just "rotmen"
	var/static/list/traits_rotman = list(
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_SILVER_WEAK,
	)

/datum/antagonist/zombie/Destroy()
	if(has_turned)
		var/datum/atom_hud/antag/deadite_hud = GLOB.huds[antag_hud_type]
		if(owner?.antag_hud == deadite_hud)
			if(!QDELETED(owner.current))
				remove_antag_hud(antag_hud_type, owner.current)
			owner.antag_hud = null
		if(owner?.antag_hud_icon_state == antag_hud_name)
			owner.antag_hud_icon_state = null
		var/mob/living/carbon/human/body = deadite_body_ref?.resolve()
		if(body && body != owner?.current)
			deadite_hud.remove_from_hud(body)
			deadite_hud.remove_hud_from(body)
			var/image/marker = body.hud_list[ANTAG_HUD]
			if(marker?.icon_state == antag_hud_name)
				marker.icon_state = null
	if(seek_spell)
		owner?.spell_list -= seek_spell
		QDEL_NULL(seek_spell)
	return ..()

/datum/antagonist/zombie/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		var/datum/antagonist/zombie/fellow_zombie = examined_datum
		return span_boldnotice("Another deadite. [fellow_zombie.has_turned ? "My ally." : span_warning("Hasn't turned yet.")]")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")

//Housekeeping/saving variables from pre-zombie

/*Death transformation process goes:
	death ->
	/mob/living/carbon/human/death(gibbed) ->
	zombie_check_can_convert() ->
	zombie.on_gain() ->
	rotting.dm process ->
	time passes ->
	zombie.wake_zombie() ->
	transform
*/
/*
	Deadite transformation is 2 ways. First is on the initial bite (low chance) and second is on being chewed on.

	Initial bite is: rogueweapons/mmb/bite.dm, /mob/living/carbon/onbite(mob/living/carbon/human/user) ->
	bite_victim.zombie_infect_attempt() ->
	attempt_zombie_infection(src, "bite", ZOMBIE_BITE_CONVERSION_TIME) -> rng check here
	time passes ->
	wake_zombie.

	Wound transformation goes: rogueweapons/mmb/bite.dm, /obj/item/grabbing/bite/proc/bitelimb(mob/living/carbon/human/user) ->
	/datum/wound/proc/zombie_infect_attempt() ->
	human_owner.attempt_zombie_infection(src, "wound", zombie_infection_time) ->
	time passes ->
	wake_zombie

	Infection transformation process goes -> infection -> timered transform in zombie_infect_attempt() [drink red/holy water and kill timer?] -> /datum/antagonist/zombie/proc/wake_zombie -> zombietransform
*/
/datum/antagonist/zombie/on_gain(admin_granted = FALSE)
	var/mob/living/carbon/human/zombie = ishuman(owner?.current) ? owner.current : null
	if(!zombie) // Everything below dereferences the body, and a half-built datum restores nulls when removed
		qdel(src)
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		qdel(src)
		return
	deadite_body_ref = WEAKREF(zombie)
	zombie_start = world.time
	was_i_undead = zombie.mob_biotypes & MOB_UNDEAD
	special_role = zombie.mind?.special_role
	ambushable = zombie.ambushable
	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f
		base_species_blood_color = zombie.dna.species.blood_color
	base_intents = zombie.base_intents

	cmode_music = zombie.cmode_music

	//Special because deadite status is latent as opposed to the others.
	if(admin_granted)
		zombie.infected = TRUE
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(wake_zombie), zombie, FALSE, TRUE), 5 SECONDS, TIMER_STOPPABLE)
	return ..()

/*
	CHECK HERE IF ANY UN-ZOMBIFICATION ISSUES.
*/
///Remove zombification - cure rot, surgical rot remove
/datum/antagonist/zombie/on_removal()
	// Restore the body we deadified, not whatever mob the mind now occupies
	var/mob/living/carbon/human/zombie = deadite_body_ref?.resolve()
	if(!ishuman(zombie))
		zombie = ishuman(owner?.current) ? owner.current : null // Pre-weakref datums, and admin-built ones
	if(zombie)

		zombie.infected = FALSE // Makes sure admins removing deadification removes the infected var if they do it before they turn
		zombie.remove_status_effect(/datum/status_effect/debuff/deadite_grace)
		zombie.mind?.special_role = special_role
		zombie.ambushable = ambushable

		if(zombie.dna?.species)
			zombie.dna.species.soundpack_m = soundpack_m
			zombie.dna.species.soundpack_f = soundpack_f
			zombie.dna.species.blood_color = base_species_blood_color
		zombie.base_intents = base_intents
		zombie.update_a_intents()
		zombie.aggressive = FALSE
		zombie.mode = NPC_AI_OFF
		zombie.npc_jump_chance = initial(zombie.npc_jump_chance)
		zombie.rude = initial(zombie.rude)
		zombie.tree_climber = initial(zombie.tree_climber)
		// Remove all vices that were ephemeral (added during zombification)
		if(zombie.charflaw)
			if(zombie.charflaw.ephemeral)
				// Remove from vices list if present
				if(zombie.charflaw in zombie.vices)
					zombie.vices -= zombie.charflaw
				// Clear the legacy field
				zombie.charflaw = null
			else
				zombie.charflaw.ephemeral = FALSE
		
		// Also clean up ephemeral vices from the vices list
		for(var/datum/charflaw/vice in zombie.vices)
			if(vice.ephemeral)
				zombie.vices -= vice
		
		zombie.update_body()

		// Rising swaps the lists in become_alive, this only covers admins curing someone already alive.
		// A still-dead corpse stays in the dead list or it counts toward pop caps and hides from locate_dead
		if(zombie.stat != DEAD)
			GLOB.dead_mob_list -= zombie
			GLOB.alive_mob_list |= zombie

		zombie.cmode_music = cmode_music

		for(var/trait in traits_zombie)
			REMOVE_TRAIT(zombie, trait, "[type]")
		zombie.remove_client_colour(/datum/client_colour/monochrome)
		zombie.remove_language(/datum/language/undead, source = "[type]")
		if(has_turned)
			var/datum/language_holder/language_holder = zombie.get_language_holder()
			language_holder.selected_default_language = prior_default_language

		if(has_turned && become_rotman)
			for(var/trait in traits_rotman)
				ADD_TRAIT(zombie, trait, "[type]")
			to_chat(zombie, span_green("I no longer crave flesh... <i>But I still feel ill.</i>"))
		else
			if(!was_i_undead)
				zombie.mob_biotypes &= ~MOB_UNDEAD
			zombie.faction -= "undead"
			zombie.faction -= "zombie"
			zombie.faction += "neutral"
			zombie.regenerate_organs()
			if(has_turned)
				to_chat(zombie, span_green("I no longer crave flesh..."))

		for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts) //Cure all limbs
			zombie_part.rotted = FALSE
			zombie_part.update_disabled()
			zombie_part.update_limb()
		zombie.update_body()
	// Bandaid to fix the zombie ghostizing not allowing you to re-enter
	if(zombie)
		var/mob/dead/observer/ghost = zombie.get_ghost(TRUE)
		if(ghost)
			ghost.can_reenter_corpse = TRUE
	return ..()

//Housekeeping's done. Transform into zombie.
/datum/antagonist/zombie/proc/transform_zombie()
	if(has_turned)
		return
	var/mob/living/carbon/human/zombie = owner?.current
	if(!ishuman(zombie)) // A severed head puts the mind in a brainmob, everything below dereferences the body
		qdel(src)
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head) //If no head then unable to become zombie
		qdel(src)
		return

	revived = TRUE //so we can die for real later
	add_antag_hud(antag_hud_type, antag_hud_name, zombie)

	for(var/trait_applied in traits_zombie)
		ADD_TRAIT(zombie, trait_applied, "[type]")
	if(zombie.mind)
		special_role = zombie.mind.special_role
		zombie.mind.special_role = name
	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f
		base_species_blood_color = zombie.dna.species.blood_color
		zombie.dna.species.soundpack_m = new /datum/voicepack/zombie/m()
		zombie.dna.species.soundpack_f = new /datum/voicepack/zombie/f()
	base_intents = zombie.base_intents
	if(zombie.dna?.species && !isooze(zombie))
		zombie.dna.species.blood_color = "#161616"
	zombie.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	zombie.update_a_intents()
	zombie.aggressive = TRUE
	zombie.mode = NPC_AI_IDLE
	zombie.handle_ai()
	ambushable = zombie.ambushable
	zombie.ambushable = FALSE

	if(zombie.charflaw)
		zombie.charflaw.ephemeral = TRUE
	zombie.mob_biotypes |= MOB_UNDEAD
	zombie.faction += "undead"
	zombie.faction += "zombie"
	zombie.faction -= "neutral"
	zombie.grant_language(/datum/language/undead, source = "[type]")
	var/datum/language_holder/language_holder = zombie.get_language_holder()
	prior_default_language = language_holder.selected_default_language
	language_holder.selected_default_language = /datum/language/undead
	seek_spell = new
	zombie.mind?.AddSpell(seek_spell)
	for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts)
		if(!zombie_part.rotted && !zombie_part.skeletonized)
			zombie_part.rotted = TRUE
		zombie_part.update_disabled()

	zombie.add_client_colour(/datum/client_colour/monochrome)
	var/obj/item/organ/eyes/eyes = zombie.getorganslot(ORGAN_SLOT_EYES) //Add zombie eyes(nightvision)
	if(eyes)
		eyes.Remove(zombie,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(zombie)

//Drop held items

	zombie.dropItemToGround(zombie.get_active_held_item(), TRUE)
	zombie.dropItemToGround(zombie.get_inactive_held_item(), TRUE)

	zombie.update_body()
	zombie.playsound_local(get_turf(zombie), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	to_chat(zombie, span_cult(pick("SO... HUNGRY... CRAVE FLESH!", "FLESH... MUST HAVE FLESH!", "HUNGER... KILL... FLESH!")))
	zombie.cmode_music = 'sound/music/combat_weird.ogg'
	zombie.apply_status_effect(/datum/status_effect/debuff/deadite_grace)
	has_turned = TRUE
	zombie.dropItemToGround(zombie.get_item_by_slot(SLOT_MOUTH), TRUE)
	record_round_statistic(STATS_DEADITES_WOKEN_UP)
	INVOKE_ASYNC(src, PROC_REF(reanimation_sequence), zombie)

/datum/antagonist/zombie/proc/reanimation_sequence(mob/living/carbon/human/zombie)
	zombie.Knockdown(3.3 SECONDS)
	zombie.Immobilize(3.3 SECONDS)
	zombie.Stun(3.3 SECONDS)
	zombie.Jitter(15)
	zombie.emote("idle")
	zombie.drop_all_held_items()
	zombie.Unconscious(1.5 SECONDS)
	zombie.fullscreen_redflash("redflash3")
	zombie.visible_message(span_warning("[zombie] convulses on the floor as [zombie.p_their()] skin rots unnaturally fast..."))
	sleep(2 SECONDS)
	if(QDELETED(src) || QDELETED(zombie) || zombie.stat == DEAD || !HAS_TRAIT(zombie, TRAIT_DEADITE))
		return
	zombie.visible_message(span_warning("[zombie]'s lyfeless eyes shine anew with an eerie glow."))
	zombie.vomit(1, blood = TRUE, stun = FALSE)
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
	sleep(2 SECONDS)
	if(QDELETED(src) || QDELETED(zombie) || zombie.stat == DEAD || !HAS_TRAIT(zombie, TRAIT_DEADITE))
		return
	if(zombie.resting)
		zombie.set_resting(FALSE, FALSE)
	zombie.visible_message(span_danger("[zombie] [pick("stands back up!", "shambles upright!", "lumbers to [zombie.p_their()] feet!", "snaps to [zombie.p_their()] feet!", "rises again!")]"))
	zombie.emote("rage")
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
	zombie.set_blurriness(0)
	if(!zombie.cmode)
		zombie.toggle_cmode()
	to_chat(zombie, span_boldwarning("I have risen as a feral, mindless deadite. I can no longer use weapons, climb most walls, cast spells or use the advanced fighting techniques I knew in lyfe. I cannot recognize those I once knew. Only endless hunger remains: bite and claw, hunt the lyving, and feast upon their flesh!"))
	to_chat(zombie, span_notice("I can examine the lyving to identify those I can infect. Seek the Lyving helps me track them down."))

// Infected wake param is just a transition from living to zombie, via zombie_infect()
// Prevoously you just died without warning in ~3 min, now you just become an antag instead of having to die first if infected.
/datum/antagonist/zombie/proc/wake_zombie(infected_wake = FALSE)
	var/mob/living/carbon/human/zombie = owner?.current
	if(!ishuman(zombie))
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		qdel(src)
		return
	if(zombie.has_foreign_brain()) // Must precede the healing below, or a refused rise leaves a healed living body
		qdel(src)
		return
	if(zombie.stat != DEAD && !infected_wake)
		qdel(src)
		return
	if(istype(zombie.loc, /obj/structure/closet/dirthole) || istype(zombie.loc, /obj/structure/closet/crate/coffin))
		qdel(src)
		return

	zombie.set_blood_volume(BLOOD_VOLUME_NORMAL)
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	if(!infected_wake)	// if we died, heal all this too
		zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.heal_wounds(INFINITY)
	if(zombie.stat == DEAD)
		if(!zombie.become_alive(UNCONSCIOUS)) // Backstops the pre-heal foreign gate above
			qdel(src)
			return
		if(zombie.stat >= DEAD) // Rose but was too broken to stay up, do not fall through to the transform
			qdel(src)
			return
	else // Infected while still alive, forced under rather than raised, not a death transition
		zombie.stat = UNCONSCIOUS
		zombie.updatehealth()
		zombie.update_mobility()
		zombie.update_sight()
		zombie.reload_fullscreen()
	zombie.clear_blood_loss_effects()
	transform_zombie()
	if(zombie.stat >= DEAD)
		//could not revive
		qdel(src)

/**
 * Cancels a pending rise for a corpse that can never turn.
 *
 * The body keeps rotting normally, it just stops being a candidate, so rotting.dm never calls back
 * here for it again. qdel rather than on_removal as in remove_zombie_antag(). A dormant datum never
 * turned, so on_gain wrote nothing worth restoring, and on_removal would regenerate organs and clear
 * rotted on every limb, erasing the corpse's decay.
 */
/proc/cancel_deadite_rise(mob/living/carbon/zombie)
	zombie.infected = FALSE
	var/datum/antagonist/zombie/dormant_antag = zombie.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(dormant_antag)
		qdel(dormant_antag)

/*
	Proc for our newly infected to wake up as a zombie
*/
/proc/wake_zombie(mob/living/carbon/zombie, infected_wake = FALSE, converted = FALSE)
	if(!zombie.infected) //Ensure they werent cured
		return

	if (!zombie || QDELETED(zombie))
		return

	if (!istype(zombie, /mob/living/carbon/human)) // Ensure the zombie is human
		return

	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if (!head) // Missing head
		cancel_deadite_rise(zombie)
		return

	if (zombie.has_foreign_brain()) // Stitched-on stranger's head, the rot cannot knit it to this flesh. Pre-heal on purpose
		cancel_deadite_rise(zombie)
		return

	if (zombie.stat != DEAD && infected_wake) // Died too hard
		cancel_deadite_rise(zombie)
		return

	if (istype(zombie.loc, /obj/structure/closet/dirthole) || istype(zombie.loc, /obj/structure/closet/crate/coffin)) // Buried
		cancel_deadite_rise(zombie)
		return

	// Heal the zombie
	zombie.set_blood_volume(BLOOD_VOLUME_NORMAL)
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE) // Zombies don't breathe
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE) // Zombies are immune to poison

	if (infected_wake || converted)
		zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.heal_wounds(INFINITY) // Heal all non-permanent wounds
		playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
		to_chat(zombie, span_userdanger("Your bones snap back into place and your flesh knits itself back together as you rise again in undeath."))

	if(zombie.stat == DEAD)
		if(!zombie.become_alive(UNCONSCIOUS)) // Backstops the pre-heal foreign gate above. The corpse stays
			zombie.infected = FALSE
			return
		if(zombie.stat >= DEAD) // Rose but was too broken to stay up, the corpse stays
			zombie.infected = FALSE
			return
	else // Converted or infected while still alive, forced under rather than raised, not a death transition
		zombie.stat = UNCONSCIOUS
		zombie.updatehealth()
		zombie.update_mobility()
		zombie.update_sight()
		zombie.reload_fullscreen()
	zombie.infected = FALSE //The infection has finished and they are now a zombie

	var/datum/antagonist/zombie/zombie_antag = zombie.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(zombie_antag)
		zombie.clear_blood_loss_effects()
		zombie_antag.transform_zombie()
	else
		CRASH("[zombie] tried to wake up as a zombie but did not have the antag set.")

	if (zombie.stat >= DEAD) // Turned and died anyway. The corpse keeps its datum so it can still be cured
		return

/// Side-effect-free eligibility shared by conversion and recovery guidance.
/mob/living/carbon/human/proc/zombie_can_convert()
	if(!mind)
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return FALSE
	return TRUE

/// Add the deadite antagonist only after its eligibility checks pass.
/mob/living/carbon/human/proc/zombie_check_can_convert()
	if(!zombie_can_convert())
		return FALSE
	return mind.add_antag_datum(/datum/antagonist/zombie)

/atom/movable/screen/alert/status_effect/debuff/deadite_grace
	name = "Necrotic Overdrive"
	desc = "My corrupted Lux courses through my decaying corpse. I cannot be stopped while it lasts."
	icon_state = "rotted_body"

/datum/status_effect/debuff/deadite_grace
	id = "deadite_grace_period"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/deadite_grace
	duration = 2 MINUTES
	examine_text = "<font color='#ff0000'>SUBJECTPRONOUN is driven by the stiff, unstoppable fury of undeath!</font>"
	var/had_godmode = FALSE

/datum/status_effect/debuff/deadite_grace/on_apply()
	if(!ishuman(owner))
		return FALSE
	. = ..()
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_projectile))
	RegisterSignal(owner, COMSIG_LIVING_IMPACT_ZONE, PROC_REF(on_thrown_item))
	had_godmode = owner.status_flags & GODMODE
	owner.status_flags |= GODMODE
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	ADD_TRAIT(owner, TRAIT_STRONG_GRABBER, id)

/datum/status_effect/debuff/deadite_grace/proc/on_projectile(mob/living/source, obj/projectile/projectile)
	SIGNAL_HANDLER
	if(!projectile.nodamage && projectile.damage > 0)
		end_on_player_attack(projectile.firer)

/datum/status_effect/debuff/deadite_grace/proc/on_thrown_item(mob/living/source, obj/item/item)
	SIGNAL_HANDLER
	if(item.throwforce > 0)
		end_on_player_attack(item.thrownby)

/datum/status_effect/debuff/deadite_grace/proc/end_on_player_attack(mob/attacker)
	if(ismob(attacker) && attacker != owner && attacker.client)
		owner.remove_status_effect(/datum/status_effect/debuff/deadite_grace)

/datum/status_effect/debuff/deadite_grace/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	UnregisterSignal(owner, list(COMSIG_ATOM_BULLET_ACT, COMSIG_LIVING_IMPACT_ZONE))
	if(!had_godmode)
		owner.status_flags &= ~GODMODE
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	REMOVE_TRAIT(owner, TRAIT_STRONG_GRABBER, id)
	to_chat(owner, span_userdanger("My body relaxes for a moment before an unnatural rage wells up inside me. My Lux wanes... I am fading."))
	if(!HAS_TRAIT(owner, TRAIT_NORUN))
		to_chat(owner, span_notice("I CAN SPRINT! HUNT THE LYVING! FEAST ON THEIR FLESH!"))

