/// Keep the portrait in the original 96x96 credits frame, regardless of accessory canvas size.
/proc/crop_credit_headshot(icon/source)
	if(!source)
		return null
	var/icon/portrait = icon(source)
	// Explicitly discard the body and oversized lower/side overlays instead of masking them.
	portrait.Crop(1, 17, 32, 32)
	portrait.Crop(1, -15, 32, 16) // Restore transparent space below the head for existing labels/crops.
	portrait.Scale(96, 96)
	return portrait

// One worker owns generation and its completion-relative cooldown, including when idle.
SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	flags = SS_NO_INIT | SS_NO_FIRE
	var/list/portrait_queue = list()
	var/worker_running = FALSE

/datum/mind
	var/credits_manual_updates = 0
	var/credits_revision = 0
	var/datum/credit_portrait_request/credits_manual_pending
	var/datum/credit_portrait_request/credits_auto_pending

/datum/preferences
	var/credits_revision = 0

/mob/living/carbon/human
	var/credits_equipment_ready = FALSE
	var/credits_auto_complete = FALSE
	var/credits_setup_depth = 0

// Invalidate requests from an earlier loadout before equipment routines can sleep.
/mob/living/carbon/human/proc/begin_credits_setup()
	credits_equipment_ready = FALSE
	credits_auto_complete = FALSE
	if(mind)
		mind.credits_revision++

// Call only after all job/subclass/arrival equipment and preference equipment are ready.
/mob/living/carbon/human/proc/add_credit()
	credits_equipment_ready = TRUE
	if(!credits_setup_depth)
		return SScrediticons.queue_portrait(src)

/client/verb/set_credits_mugshot()
	set name = "Set Credits Mugshot"
	set category = "OOC"
	set desc = "Queue a credits portrait with your current equipment. Two successful updates per character per round."
	if(!ishuman(mob))
		to_chat(src, span_warning("You must be controlling a humanoid character to set a credits mugshot."))
		return
	SScrediticons.queue_portrait(mob, TRUE)

/datum/controller/subsystem/crediticons/proc/queue_portrait(mob/living/carbon/human/character, manual = FALSE)
	if(QDELETED(character) || !character.client?.prefs || !character.mind || character.mind.current != character)
		if(manual && character?.client)
			to_chat(character, span_warning("Your character is not available for a credits mugshot. No update was used."))
		return FALSE
	var/datum/mind/owner = character.mind
	if(!character.credits_equipment_ready || character.credits_setup_depth || character.advsetup)
		if(manual)
			to_chat(character, span_warning("Your equipment is still being prepared. Try Set Credits Mugshot after character setup finishes."))
		return FALSE
	if(manual)
		if(owner.credits_manual_updates >= 2)
			to_chat(character, span_warning("You have already used both credits mugshot updates for this character this round."))
			return FALSE
		if(owner.credits_manual_pending)
			to_chat(character, span_warning("Your credits mugshot update is already queued or generating."))
			return FALSE
		// Invalidate older automatic work before it can publish after a sleeping generator.
		owner.credits_revision++
	else if(character.credits_auto_complete || (owner.credits_auto_pending && owner.credits_auto_pending.valid()) || (owner.credits_manual_pending && owner.credits_manual_pending.valid()) || owner.credits_manual_updates)
		return FALSE
	var/datum/credit_portrait_request/request = new(character, manual)
	if(manual)
		owner.credits_manual_pending = request
		to_chat(character, span_notice("Credits mugshot update queued ([owner.credits_manual_updates]/2 successful updates used). Your equipment will be captured when generation starts."))
	else
		owner.credits_auto_pending = request
	portrait_queue += request
	if(!worker_running)
		worker_running = TRUE
		INVOKE_ASYNC(src, PROC_REF(run_queue))
	return TRUE

/datum/controller/subsystem/crediticons/proc/run_queue()
	while(length(portrait_queue))
		var/datum/credit_portrait_request/request = portrait_queue[1]
		portrait_queue.Cut(1, 2)
		if(request.valid())
			try
				request.generate()
			catch(var/exception/error)
				log_runtime("Credits portrait generation failed: [error]")
		request.finish()
		qdel(request)
		// This sleep starts AFTER generation returns, including all mannequin waits.
		// Keep ownership during cooldown so newly queued work cannot start another worker.
		sleep(5 SECONDS)
	worker_running = FALSE

/datum/credit_portrait_request
	var/mob/living/carbon/human/character
	var/datum/mind/owner
	var/client/player
	var/datum/preferences/preferences
	var/preference_slot
	var/preference_revision
	var/owner_revision
	var/character_name
	var/role_title
	var/manual = FALSE
	var/invalidated = FALSE
	var/succeeded = FALSE

/datum/credit_portrait_request/New(mob/living/carbon/human/target, is_manual)
	. = ..()
	character = target
	owner = target.mind
	player = target.client
	preferences = player.prefs
	preference_slot = preferences.default_slot
	preference_revision = preferences.credits_revision
	owner_revision = owner.credits_revision
	character_name = target.real_name
	role_title = target.get_role_title()
	manual = is_manual
	RegisterSignal(character, list(COMSIG_MOB_LOGOUT, COMSIG_MIND_TRANSFER, COMSIG_QDELETING), PROC_REF(invalidate))

/datum/credit_portrait_request/proc/invalidate()
	SIGNAL_HANDLER
	invalidated = TRUE

/datum/credit_portrait_request/proc/valid()
	if(invalidated || QDELETED(character) || QDELETED(owner) || !player || QDELETED(preferences))
		return FALSE
	if(character.client != player || player.mob != character || character.mind != owner || owner.current != character)
		return FALSE
	if(player.prefs != preferences || preferences.default_slot != preference_slot || preferences.credits_revision != preference_revision)
		return FALSE
	return owner.credits_revision == owner_revision && character.real_name == character_name && character.get_role_title() == role_title

/datum/credit_portrait_request/proc/generate()
	var/icon/portrait = get_flat_human_icon(null, null, preferences, DUMMY_HUMAN_SLOT_MANIFEST, list(SOUTH), human_gear_override = character, copy_appearance = TRUE, hide_portrait_headgear = TRUE)
	if(!portrait || !valid())
		return
	portrait = crop_credit_headshot(portrait)
	if(!portrait)
		return
	GLOB.credits_icons[REF(owner)] = list("name" = character_name, "title" = role_title, "icon" = portrait, "vc" = character.voice_color)
	succeeded = TRUE
	if(manual)
		owner.credits_manual_updates++
	else
		character.credits_auto_complete = TRUE

/datum/credit_portrait_request/proc/finish()
	if(owner?.credits_manual_pending == src)
		owner.credits_manual_pending = null
	if(owner?.credits_auto_pending == src)
		owner.credits_auto_pending = null
	// Notify the original player's connection, never a new occupant of the body.
	if(manual && player)
		if(succeeded)
			to_chat(player, span_notice("Credits mugshot updated ([owner.credits_manual_updates]/2 successful updates used)."))
		else
			to_chat(player, span_warning("Credits mugshot update failed or was cancelled. Generation may have failed, or your character or preferences changed. No update was used; you may queue it again."))

/datum/credit_portrait_request/Destroy()
	if(character)
		UnregisterSignal(character, list(COMSIG_MOB_LOGOUT, COMSIG_MIND_TRANSFER, COMSIG_QDELETING))
	character = null
	owner = null
	player = null
	preferences = null
	return ..()

/datum/controller/subsystem/crediticons/proc/get_credit_icon(mob/living/carbon/human/target, crop_to_upper_half = FALSE)
	if(!target || !istype(target) || !target.mind || !target.client)
		return null

	var/credit_name = REF(target.mind)
	if(!GLOB.credits_icons[credit_name]?["icon"])
		return null

	var/icon/credit_icon = GLOB.credits_icons[credit_name]["icon"]

	if(crop_to_upper_half)
		var/icon/cropped_icon = icon(credit_icon)
		cropped_icon.Crop(1, 49, 96, 96)
		return cropped_icon

	return credit_icon
