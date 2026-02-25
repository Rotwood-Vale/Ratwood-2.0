#define COLLAR_TRAIT "collar_master"
#define EMOTE_MESSAGE "emote_message"
#define EMOTE_SOURCE "emote_source"
#define ANTAGONIST_PREVIEW_ICON_SIZE 96
#define COMSIG_LIVING_SURRENDER "living_surrender"
#define COLLAR_SURRENDER_TIME 10 SECONDS
#define COMSIG_MOB_CLICK_SHIFT "mob_click_shift"
#define COMPONENT_INTERRUPT_CLICK "interrupt_click"
#define HEARING_MESSAGE_MODE "message_mode"
#define MODE_SAY "say"

GLOBAL_LIST_EMPTY(collar_masters)

/datum/status_effect/surrender/collar
	id = "collar_surrender"
	duration = COLLAR_SURRENDER_TIME
	alert_type = /atom/movable/screen/alert/status_effect/collar_surrender

/atom/movable/screen/alert/status_effect/collar_surrender
	name = "Forced Surrender"
	desc = "Your collar forces you to submit!"
	icon_state = "surrender"

/datum/component/collar_master
	var/datum/mind/mindparent
	var/list/my_pets = list()
	var/list/temp_selected_pets = list()
	var/listening = FALSE
	var/deny_orgasm = FALSE
	var/dominating = FALSE
	var/silenced = FALSE
	var/scrying = FALSE
	var/last_command_time = 0
	var/command_cooldown = 2 SECONDS
	var/static/list/pet_sounds = list(
		"*lets out a soft whimper",
		"*whines quietly",
		"*makes a needy sound",
		"*lets out a submissive mewl",
		"*makes a pathetic noise",
		"*whimpers needily",
		"*mewls submissively",
		"*pants heavily",
		"*lets out a desperate whine",
		"*makes a pleading sound"
	)
	var/list/registered_pets = list()
	var/speech_altered = FALSE
	var/mob/living/carbon/human/original_pet_body
	var/mob/living/carbon/human/original_master_body
	var/mob/living/carbon/human/listening_pet

/datum/component/collar_master/Initialize(...)
	. = ..()
	mindparent = parent
	GLOB.collar_masters += mindparent

/datum/component/collar_master/Destroy(force, silent)
	. = ..()
	for(var/pet in my_pets)
		cleanup_pet(pet)
	GLOB.collar_masters -= mindparent

/datum/component/collar_master/proc/add_pet(mob/living/carbon/human/pet)
	if(!pet || (pet in my_pets))
		return FALSE

	// Add to lists
	my_pets += pet
	registered_pets += pet

	// Register all signals including attack signals
	RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
	RegisterSignal(pet, COMSIG_MOB_DEATH, PROC_REF(on_pet_death))
	RegisterSignal(pet, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_pet_attack))
	RegisterSignal(pet, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_pet_attack))
	RegisterSignal(pet, COMSIG_ITEM_ATTACK, PROC_REF(on_pet_attack))
	RegisterSignal(pet, COMSIG_LIVING_ATTACKED_BY, PROC_REF(on_pet_attack))

	register_pet(pet)

	// Get the collar and ensure it's properly set up
	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
	if(istype(collar))
		// Set master before sending signal
		collar.collar_master = mindparent?.current
		if(!collar.collar_master)
			return FALSE

		// Send signal first
		SEND_SIGNAL(pet, COMSIG_CARBON_GAIN_COLLAR, collar)

		// Wait a tick before giving feedback to allow signal to process
		addtimer(CALLBACK(src, PROC_REF(give_collar_feedback), pet), 0.1 SECONDS)

		// Verify signal was received and processed
		addtimer(CALLBACK(src, PROC_REF(verify_collar_binding), pet, collar), 0.2 SECONDS)

	return TRUE

/datum/component/collar_master/proc/give_collar_feedback(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return
	to_chat(pet, span_notice("The collar tightens as it recognizes its master!"))
	to_chat(parent, span_notice("You feel the collar bind to [pet]'s will."))

/datum/component/collar_master/proc/verify_collar_binding(mob/living/carbon/human/pet, obj/item/clothing/neck/roguetown/cursed_collar/collar)
	if(!pet || !collar || !collar.collar_master)
		return

	// Prevent self-collaring
	if(pet == collar.collar_master)
		to_chat(pet, span_warning("The collar refuses to clasp shut."))
		pet.dropItemToGround(collar, force = TRUE)
		return FALSE

	to_chat(pet, span_notice("Your collar pulses, reinforcing your master's control..."))
	SEND_SIGNAL(pet, COMSIG_CARBON_GAIN_COLLAR, collar)
	addtimer(CALLBACK(src, PROC_REF(final_verify_binding), pet, collar), 0.2 SECONDS)

/datum/component/collar_master/proc/final_verify_binding(mob/living/carbon/human/pet, obj/item/clothing/neck/roguetown/cursed_collar/collar)
	if(!pet || !collar || !collar.collar_master)
		return

	SEND_SIGNAL(pet, COMSIG_CARBON_GAIN_COLLAR, collar)

/datum/component/collar_master/proc/on_pet_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return

	if(speech_altered)
		speech_args[SPEECH_MESSAGE] = ""  // Clear the speech message
		var/emote_text = pick(pet_sounds)
		emote_text = replacetext(emote_text, "*", "") // Remove asterisk
		pet.visible_message(span_emote("<b>[pet]</b> [emote_text]"))
		return COMPONENT_CANCEL_SAY

/datum/component/collar_master/proc/do_pet_emote(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return
	pet.emote("me", EMOTE_VISIBLE, pick(pet_sounds))

/datum/component/collar_master/proc/on_pet_death(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return
	addtimer(CALLBACK(src, PROC_REF(cleanup_pet), pet), 0.1 SECONDS)

/datum/component/collar_master/proc/remove_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in registered_pets))
		return FALSE

	UnregisterSignal(pet, list(
		COMSIG_MOB_SAY,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ITEM_ATTACK,
		COMSIG_LIVING_ATTACKED_BY
	))

	registered_pets -= pet
	cleanup_pet(pet)
	return TRUE

/datum/component/collar_master/proc/on_pet_attack(datum/source, atom/target)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return COMPONENT_CANCEL_ATTACK

	// Block attacks against the master only if on harm intent
	if(target == mindparent?.current && pet.used_intent.type == INTENT_HARM)
		to_chat(pet, span_warning("Your collar shocks you as you try to attack your master!"))
		INVOKE_ASYNC(src, PROC_REF(shock_pet), pet, 10)
		return COMPONENT_CANCEL_ATTACK

	return COMPONENT_CANCEL_ATTACK

/datum/component/collar_master/proc/shock_pet(mob/living/carbon/human/pet, intensity = 10)
	if(!pet || !(pet in my_pets))
		return FALSE

	// Calculate damage based on intensity
	var/damage = intensity * 0.5

	// Apply damage and effects
	pet.adjustFireLoss(damage)
	pet.adjustStaminaLoss(intensity * 2)
	pet.Knockdown(intensity * 0.2 SECONDS)
	pet.do_jitter_animation(intensity)

	// Visual effects
	pet.visible_message(span_danger("[pet]'s collar crackles with electricity!"), \
					   span_userdanger("Your collar sends searing pain through your body!"))

	var/turf/T = get_turf(pet)
	if(T)
		new /obj/effect/temp_visual/cult/sparks(T)
		playsound(T, list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg'), 50, TRUE)
		do_sparks(2, FALSE, pet)

	// Add a temporary overlay effect
	pet.flash_fullscreen("redflash3")
	addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, clear_fullscreen), "pain"), 2 SECONDS)

	return TRUE

/datum/component/collar_master/proc/select_pets(mob/user, action_name = "", allow_multiple = FALSE)
	var/list/valid_pets = list()
	for(var/mob/living/carbon/human/pet in my_pets)
		if(!pet || !pet.mind || !pet.client)
			continue
		valid_pets += pet

	if(!length(valid_pets))
		return list()

	if(allow_multiple)
		var/list/selected = input(user, "Choose pets to [action_name]:", "Pet Selection") as null|anything in valid_pets
		return selected ? selected : list()
	else
		var/mob/living/carbon/human/selected = input(user, "Choose a pet to [action_name]:", "Pet Selection") as null|anything in valid_pets
		return selected ? list(selected) : list()

/datum/component/collar_master/proc/toggle_listening(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	listening = !listening
	listening_pet = listening ? pet : null

	if(listening)
		// Add master to pet's message viewers
		RegisterSignal(pet, COMSIG_MOVABLE_HEAR, PROC_REF(relay_heard))
		RegisterSignal(pet, COMSIG_MOB_EMOTE, PROC_REF(relay_emote))
		to_chat(mindparent.current, span_notice("You start listening through [pet]'s collar."))
		to_chat(pet, span_warning("Your collar tingles as your master listens through your ears!"))
	else
		// Remove master from pet's message viewers
		UnregisterSignal(pet, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_EMOTE))
		listening_pet = null
		to_chat(mindparent.current, span_notice("You stop listening through [pet]'s collar."))
		to_chat(pet, span_notice("Your collar relaxes as your master stops listening."))

	return TRUE

/datum/component/collar_master/proc/relay_heard(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets) || !listening || pet != listening_pet)
		return

	var/message = hearing_args[HEARING_MESSAGE]
	if(message)
		to_chat(mindparent.current, span_notice("<i>Through [pet]'s collar: [message]</i>"))

/datum/component/collar_master/proc/relay_emote(datum/source, emote_key, emote_message)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets) || !listening || pet != listening_pet)
		return

	if(emote_message)
		to_chat(mindparent.current, span_notice("<i>Through [pet]'s collar: [pet] [emote_message]</i>"))

/datum/component/collar_master/proc/force_strip(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	pet.drop_all_held_items()
	// Additional stripping logic can be added here
	return TRUE

/datum/component/collar_master/proc/toggle_hallucinations(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(pet.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
		pet.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
		to_chat(pet, span_notice("Your collar pulses and the world becomes clearer."))
	else
		pet.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
		to_chat(pet, span_warning("Your collar pulses and the world begins to shift and warp!"))
		pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/create_illusion(mob/living/carbon/human/pet, message)
	if(!pet || !(pet in my_pets))
		return FALSE

	to_chat(pet, span_warning("<b>Collar Illusion:</b> [message]"))
	pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/force_emote(mob/living/carbon/human/pet, emote_text)
	if(!pet || !(pet in my_pets))
		return FALSE

	pet.emote("me", EMOTE_VISIBLE, emote_text)
	return TRUE

/datum/component/collar_master/proc/share_damage(mob/living/carbon/human/pet, mob/living/carbon/human/master)
	if(!pet || !(pet in my_pets) || !master)
		return FALSE

	var/total_damage = master.getBruteLoss() + master.getFireLoss() + master.getOxyLoss()
	if(total_damage <= 0)
		return FALSE

	var/damage_share = total_damage * 0.5
	pet.adjustBruteLoss(damage_share)
	master.adjustBruteLoss(-damage_share)

	// Share blood if applicable
	if(master.blood_volume && pet.blood_volume)
		var/blood_diff = BLOOD_VOLUME_NORMAL - master.blood_volume
		if(blood_diff > 0)
			var/blood_share = min(blood_diff * 0.5, pet.blood_volume - BLOOD_VOLUME_SAFE)
			if(blood_share > 0)
				pet.blood_volume -= blood_share
				master.blood_volume += blood_share

	return TRUE

/datum/component/collar_master/proc/force_surrender(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(pet.stat >= UNCONSCIOUS)
		return FALSE

	if(pet.surrendering)
		return FALSE

	pet.surrendering = TRUE
	pet.toggle_cmode()
	pet.changeNext_move(CLICK_CD_EXHAUSTED)

	// Create and attach the surrender flag visual
	var/obj/effect/temp_visual/surrender/flaggy = new(pet)
	pet.vis_contents += flaggy

	// Apply stun and status effects
	pet.Stun(300)
	pet.Knockdown(300)
	pet.apply_status_effect(/datum/status_effect/debuff/breedable)
	pet.apply_status_effect(/datum/status_effect/debuff/submissive)

	// Visual and sound effects
	pet.visible_message(span_warning("[pet] is forced to surrender by their collar!"), \
					   span_userdanger("Your collar forces you to submit!"))
	playsound(pet, 'sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls=TRUE)

	pet.update_vision_cone()
	addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, end_submit)), 600)

	return TRUE

/datum/component/collar_master/proc/toggle_arousal(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/loop_id = "force_arousal_[REF(pet)]"

	// Check if arousal is already being forced
	if(pet.active_timers?.Find(loop_id))
		deltimer(pet.active_timers[loop_id])
		pet.clear_fullscreen("love")
		to_chat(pet, span_notice("The waves of arousal from your collar subside..."))
		return TRUE

	// Start arousal loop
	var/amount_per_tick = 5
	arousal_tick(pet, amount_per_tick, loop_id)
	pet.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

	// Visual feedback
	to_chat(pet, span_userdanger("Your collar sends waves of arousal through your body!"))
	pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)

	return TRUE

/datum/component/collar_master/proc/arousal_tick(mob/living/carbon/human/pet, amount_per_tick, loop_id)
	if(!pet?.sexcon)
		pet.sexcon = new /datum/sex_controller(pet)

	pet.sexcon.adjust_arousal(amount_per_tick)
	pet.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

	// Visual feedback each tick
	var/list/arousal_messages = list(
		"Your collar tingles as pleasure courses through you...",
		"Waves of heat spread from your collar...",
		"Your body quivers with building arousal...",
		"The collar's influence makes you shudder with need..."
	)

	to_chat(pet, span_love(pick(arousal_messages)))
	pet.do_jitter_animation(10)

	// Sound effects based on arousal level
	if(prob(10))  // 10% chance each tick to make a sound
		var/current_arousal = pet.sexcon.arousal
		if(current_arousal > 60)
			playsound(pet, pick('sound/vo/female/gen/se/sex (1).ogg',
							  'sound/vo/female/gen/se/sex (2).ogg',
							  'sound/vo/female/gen/se/sex (3).ogg',
							  'sound/vo/female/gen/se/sex (4).ogg',
							  'sound/vo/female/gen/se/sex (5).ogg',
							  'sound/vo/female/gen/se/sex (6).ogg',
							  'sound/vo/female/gen/se/sex (7).ogg'), 50, TRUE)
			pet.emote("moan")
		else if(current_arousal > 10)
			playsound(pet, pick('sound/vo/female/gen/se/sexlight (1).ogg',
							  'sound/vo/female/gen/se/sexlight (2).ogg',
							  'sound/vo/female/gen/se/sexlight (3).ogg',
							  'sound/vo/female/gen/se/sexlight (4).ogg',
							  'sound/vo/female/gen/se/sexlight (5).ogg',
							  'sound/vo/female/gen/se/sexlight (6).ogg',
							  'sound/vo/female/gen/se/sexlight (7).ogg'), 50, TRUE)
			pet.emote("whimper")

	// Continue loop
	pet.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(arousal_tick), pet, amount_per_tick, loop_id), 1 SECONDS, TIMER_STOPPABLE)

/datum/component/collar_master/proc/force_love(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	// Apply love effects
	pet.emote("blush")
	to_chat(pet, span_love("Your collar fills you with overwhelming affection!"))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/permit_clothing(mob/living/carbon/human/pet, permitted = TRUE)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(permitted)
		REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		to_chat(pet, span_notice("Your collar allows you to wear clothing again."))
	else
		ADD_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		to_chat(pet, span_warning("Your collar prevents you from wearing clothing!"))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/check_pet_status(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/status_text = "<span class='notice'><b>[pet.real_name] Status:</b>\n"
	status_text += "Health: [pet.health]/[pet.maxHealth]\n"
	status_text += "Location: [get_area(pet)]\n"
	status_text += "Mental State: [pet.stat >= UNCONSCIOUS ? "Unconscious" : "Conscious"]\n"
	status_text += "Active Traits: "

	var/list/active_traits = list()
	if(speech_altered)
		active_traits += "Speech Altered"

	status_text += active_traits.len ? english_list(active_traits) : "None"
	status_text += "</span>"

	return status_text

/datum/component/collar_master/proc/mass_command(command_type, list/targets, ...)
	if(!length(targets))
		return FALSE

	var/success_count = 0
	for(var/mob/living/carbon/human/pet in targets)
		if(!pet || !(pet in my_pets))
			continue

		switch(command_type)
			if("shock")
				var/intensity = args[1]
				if(shock_pet(pet, intensity))
					success_count++
			if("surrender")
				if(force_surrender(pet))
					success_count++
			if("strip")
				if(force_strip(pet))
					success_count++
			if("arousal")
				if(toggle_arousal(pet))
					success_count++
			if("love")
				if(force_love(pet))
					success_count++
			if("hallucinate")
				if(toggle_hallucinations(pet))
					success_count++

	return success_count

/datum/component/collar_master/proc/on_pet_examine(mob/living/carbon/human/pet, mob/user)
	if(!pet || !(pet in my_pets))
		return

	if(user == mindparent?.current)
		to_chat(user, span_notice("\n[check_pet_status(pet)]"))
	else if(user != pet)
		to_chat(user, span_warning("\nThey wear a strange collar around their neck."))

/datum/component/collar_master/proc/cleanup_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	// Remove all collar-related traits
	REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)

	// Remove from lists
	my_pets -= pet
	registered_pets -= pet

	// Handle collar removal and trigger uncollared signal
	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
	if(istype(collar))
		SEND_SIGNAL(pet, COMSIG_CARBON_LOSE_COLLAR)
		pet.dropItemToGround(collar, force = TRUE)
		REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	// Feedback
	to_chat(pet, span_notice("Your mind clears as the collar's control fades!"))
	if(mindparent.current)
		to_chat(mindparent.current, span_warning("[pet] is no longer under your control!"))

	return TRUE

/datum/component/collar_master/_JoinParent()
	. = ..()
	if(mindparent?.current)
		mindparent.current.verbs += list(
			/mob/proc/collar_master_control_menu,
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
		)

/datum/component/collar_master/_RemoveFromParent()
	if(mindparent?.current)
		mindparent.current.verbs -= list(
			/mob/proc/collar_master_control_menu,
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
		)
	. = ..()

/datum/component/collar_master/proc/pass_wounds(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/mob/living/carbon/human/master = mindparent?.current
	if(!master)
		return FALSE

	// Pass all damage types
	pet.adjustBruteLoss(master.getBruteLoss() * 0.5)
	pet.adjustFireLoss(master.getFireLoss() * 0.5)
	pet.adjustOxyLoss(master.getOxyLoss() * 0.5)

	// Pass blood level if it exists
	if(pet.blood_volume && master.blood_volume)
		pet.blood_volume = max(BLOOD_VOLUME_SAFE, pet.blood_volume - (BLOOD_VOLUME_NORMAL - master.blood_volume) * 0.5)

	// Pass organ damage
	for(var/obj/item/organ/organ in master.internal_organs)
		var/obj/item/organ/matching_organ = pet.getorganslot(organ.slot)
		if(matching_organ && organ.damage > 0)
			matching_organ.applyOrganDamage(organ.damage * 0.5)

	pet.updatehealth()
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	to_chat(pet, span_userdanger("Your collar burns as your master's suffering flows into you!"))
	pet.visible_message(span_warning("[pet] shudders as [master]'s wounds manifest on their body!"))
	pet.do_jitter_animation(20)

	// Heal the master slightly
	master.adjustBruteLoss(-10)
	master.adjustFireLoss(-10)
	master.adjustOxyLoss(-10)

	return TRUE

/datum/component/collar_master/proc/toggle_speech(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	speech_altered = !speech_altered

	if(speech_altered)
		RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
		to_chat(mindparent.current, span_notice("You alter [pet]'s speech to animal sounds."))
		to_chat(pet, span_warning("Your collar tingles - you find yourself only able to make animal noises!"))
	else
		UnregisterSignal(pet, COMSIG_MOB_SAY)
		to_chat(mindparent.current, span_notice("You return [pet]'s speech to normal."))
		to_chat(pet, span_notice("Your collar relaxes - you can speak normally again."))

	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/register_pet(mob/living/carbon/human/pet)
	if(!pet || (pet in my_pets))
		return FALSE

	// Use existing signals from the dominated component
	RegisterSignal(pet, list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_ITEM_ATTACK,
		COMSIG_LIVING_ATTACKED_BY
	), PROC_REF(on_pet_attack))

	return TRUE

/datum/component/collar_master/proc/toggle_denial(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(deny_orgasm)
		// Start a loop to monitor and cap arousal
		var/loop_id = "deny_orgasm_[REF(pet)]"
		pet.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(cap_arousal), pet, loop_id), 1 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
		to_chat(pet, span_warning("Your collar tightens - you feel like you won't be able to finish!"))
	else
		// Stop the denial loop
		var/loop_id = "deny_orgasm_[REF(pet)]"
		if(pet.active_timers?.Find(loop_id))
			deltimer(pet.active_timers[loop_id])
		to_chat(pet, span_notice("Your collar loosens - you feel like you can finish again!"))
	return TRUE

/datum/component/collar_master/proc/cap_arousal(mob/living/carbon/human/pet, loop_id)
	if(!pet?.sexcon || !deny_orgasm)
		return

	if(pet.sexcon.arousal > 90)
		pet.sexcon.arousal = 90
		to_chat(pet, span_warning("Your collar prevents you from reaching climax!"))
