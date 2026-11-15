#define HYPNOTIC_GAZE_CHANNEL_TIME (10 SECONDS)
#define HYPNOTIC_GAZE_PENDING_TIME (10 MINUTES)
#define HYPNOTIC_GAZE_REMINDER_TIME (20 MINUTES)

/proc/hypnosis_content_enabled(mob/participant)
	return !!participant?.client?.prefs?.hypnosis_content

/// Speech arrives HTML-encoded, with optional renderer-inserted formatting tags.
/// Strip only actual markup, decode exactly once, and encode only at display time.
/proc/hypnotic_speech_plaintext(text)
	if(!istext(text))
		return ""
	var/static/regex/markup = regex(@"<[^>]*>", "g")
	return trim(copytext_char(html_decode(markup.Replace(text, "")), 1, MAX_MESSAGE_LEN))

/proc/hypnotic_gaze_styles()
	return list("Hypnotext", "Purple", "Pink", "Velvet", "Gold", "Green", "Cult Red")

/proc/sanitize_hypnotic_gaze_text(text)
	if(!istext(text))
		return "Their eyes are enticing to gaze into."
	text = trim(copytext_char(text, 1, 101))
	return length(text) ? text : "Their eyes are enticing to gaze into."

/proc/sanitize_hypnotic_gaze_style(style)
	return (style in hypnotic_gaze_styles()) ? style : "Hypnotext"

/proc/sanitize_hypnotic_presence_text(text)
	if(!istext(text))
		return "There is something strangely compelling about their presence."
	text = trim(copytext_char(text, 1, 101))
	return length(text) ? text : "There is something strangely compelling about their presence."

/proc/hypnotic_gaze_format(text, style = "Hypnotext")
	text = html_encode(text)
	switch(sanitize_hypnotic_gaze_style(style))
		if("Purple")
			return "<span style='color:#b56cff'>[text]</span>"
		if("Pink")
			return "<span style='color:#ff8fca'>[text]</span>"
		if("Velvet")
			return "<span style='color:#c45b85'>[text]</span>"
		if("Gold")
			return "<span style='color:#e8c65a'>[text]</span>"
		if("Green")
			return "<span style='color:#72c779'>[text]</span>"
		if("Cult Red")
			return "<span class='cult'>[text]</span>"
	return span_hypnophrase(text)

/datum/quirk/hypnotic_gaze
	name = "Hypnotic Gaze"
	desc = "My gaze draws others in, leaving my words lingering deep within their thoughts."
	point_cost = 1
	incompatible_quirks = list(/datum/quirk/hypnotic_presence)
	custom_text = "Grants Hypnotic Gaze. The next words the target hears from me become a lasting suggestion. Recasting releases them. Customize the examine text on the button below."
	var/is_presence = FALSE
	var/hypnotic_spell_type = /obj/effect/proc_holder/spell/invoked/hypnotic_gaze

/datum/quirk/hypnotic_presence
	parent_type = /datum/quirk/hypnotic_gaze
	name = "Hypnotic Presence"
	desc = "Something about my presence draws others in, leaving my words lingering deep within their thoughts."
	custom_text = "Grants Hypnotic Presence, which does not require exposed eyes. The next words the target hears from me become a lasting suggestion. Recasting releases them. Customize the examine text on the button below."
	incompatible_quirks = list(/datum/quirk/hypnotic_gaze)
	is_presence = TRUE
	hypnotic_spell_type = /obj/effect/proc_holder/spell/invoked/hypnotic_gaze/presence

/datum/quirk/hypnotic_gaze/apply_to_human(mob/living/carbon/human/recipient)
	if(locate(/obj/effect/proc_holder/spell/invoked/hypnotic_gaze) in recipient.mob_spell_list)
		return
	if(recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/hypnotic_gaze))
		return
	var/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/spell = new hypnotic_spell_type
	if(is_presence)
		spell.presentation_text = sanitize_hypnotic_presence_text(recipient.client?.prefs?.hypnotic_presence_text)
		spell.presentation_style = sanitize_hypnotic_gaze_style(recipient.client?.prefs?.hypnotic_presence_style)
	else
		spell.presentation_text = sanitize_hypnotic_gaze_text(recipient.client?.prefs?.hypnotic_gaze_text)
		spell.presentation_style = sanitize_hypnotic_gaze_style(recipient.client?.prefs?.hypnotic_gaze_style)
	if(recipient.mind)
		recipient.mind.AddSpell(spell)
	else
		recipient.AddSpell(spell)

/mob/living/carbon/human
	var/hypnotic_gaze_text
	var/hypnotic_gaze_style = "Hypnotext"
	var/hypnotic_presence = FALSE
	var/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/hypnotic_presentation_source
	var/datum/hypnotic_gaze_channel/hypnotic_gaze_channel

// Use current eye-cover flags, not identity hiding or merely occupying the mask slot.
/mob/living/carbon/human/proc/hypnotic_eyes_visible()
	if(!getorganslot(ORGAN_SLOT_EYES) || is_eyes_covered() || get_eye_protection() > 0)
		return FALSE
	// Cloth eye coverings do not consistently set flags_cover. Armor coverage
	// alone is not visibility: rag masks and transparent spectacles cover EYES too.
	for(var/obj/item/clothing/C in list(head, wear_mask, glasses))
		if(istype(C, /obj/item/clothing/mask))
			var/obj/item/clothing/mask/M = C
			if(M.mask_adjusted)
				continue
		if(C.flags_cover & (MASKCOVERSEYES | HEADCOVERSEYES | GLASSESCOVERSEYES))
			return FALSE
		if(istype(C, /obj/item/clothing/glasses/blindfold) || istype(C, /obj/item/clothing/mask/rogue/blindfold) || istype(C, /obj/item/clothing/mask/rogue/duelmask))
			return FALSE
	return TRUE

/mob/living/carbon/human/proc/hypnotic_gaze_examine(mob/viewer)
	if(viewer == src || !hypnosis_content_enabled(viewer) || !hypnotic_gaze_text)
		return null
	if(!hypnotic_presence)
		if(!hypnotic_eyes_visible())
			return null
		if(isliving(viewer))
			var/mob/living/L = viewer
			if(L.eye_blind)
				return null
	return hypnotic_gaze_format(hypnotic_gaze_text, hypnotic_gaze_style)

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze
	name = "Hypnotic Gaze"
	base_action = /datum/action/spell_action/spell/hypnosis
	var/presentation_text
	var/presentation_style = "Hypnotext"
	// Spiral: tgstation/tgstation, icons/hud/screen_alert.dmi, state "hypnosis".
	// Scaled down and clipped to a transparent 20px circle within the 32px HUD tile.
	action_icon = 'icons/mob/actions/hypnotic_gaze.dmi'
	action_icon_state = "hypnosis"
	overlay_state = "hypnosis"
	hide_charge_effect = TRUE
	desc = "Hold another's gaze for ten seconds. Your next words they hear become a lasting suggestion. Cast again to release an existing suggestion."
	range = 2
	chargetime = 1 SECONDS
	no_early_release = TRUE
	recharge_time = 5 SECONDS
	invocation_type = "none"
	ignore_los = FALSE
	is_cdr_exempt = TRUE
	mute_allowed = TRUE
	releasedrain = 0
	var/datum/hypnotic_gaze_channel/channel
	var/requires_eye_contact = TRUE
	var/connection_error = "I cannot establish eye contact right now."
	var/channel_caster_text = "You fix your gaze upon them, beginning to pierce the surface of their mind."
	var/channel_target_text = "Their gaze draws you in. You feel compelled to meet their eyes."
	var/interrupted_target_text = "The gaze breaks before it can settle into your thoughts."
	var/trance_target_text = "Your thoughts soften beneath their gaze. Your mind feels especially receptive to their next words."
	var/trance_caster_text = "Their mind lies open. The next words they hear from you will become a lasting suggestion, remembered until another gaze releases them."
	var/release_target_text = "Your mind clears. Those words no longer command your thoughts."
	var/release_caster_text = "You release their mind from its lingering suggestion."

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/presence
	name = "Hypnotic Presence"
	desc = "Focus your influence on someone for ten seconds. The next words they hear from you become a lasting suggestion. Cast again to release an existing trance or suggestion."
	requires_eye_contact = FALSE
	connection_error = "I cannot establish a connection right now."
	channel_caster_text = "You focus your influence upon them, gently pressing against the surface of their thoughts."
	channel_target_text = "Something about their presence draws you in. You feel an unusual pull upon your attention."
	interrupted_target_text = "The influence fades before it can settle into your thoughts."
	trance_target_text = "Your thoughts soften, and the world around you seems less important. Your mind feels especially receptive to their next words."
	trance_caster_text = "Their mind lies open. The next words they hear from you will become a lasting suggestion, remembered until another hypnotic influence releases them."
	release_target_text = "Your mind clears. The lingering influence releases its hold upon your thoughts."
	release_caster_text = "You release their mind from its lingering influence."

// Keep the preparatory mouse charge at exactly one second.
/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/get_chargetime()
	return chargetime

// The spell follows the mind; body-local examine fields must follow its action owner too.
/datum/action/spell_action/spell/hypnosis/Grant(mob/M)
	. = ..()
	if(owner != M || !ishuman(M) || QDELETED(target))
		return
	var/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/spell = target
	if(!istype(spell) || isnull(spell.presentation_text))
		return
	var/mob/living/carbon/human/H = M
	H.hypnotic_presentation_source = spell
	H.hypnotic_presence = !spell.requires_eye_contact
	H.hypnotic_gaze_text = H.hypnotic_presence ? sanitize_hypnotic_presence_text(spell.presentation_text) : sanitize_hypnotic_gaze_text(spell.presentation_text)
	H.hypnotic_gaze_style = sanitize_hypnotic_gaze_style(spell.presentation_style)

/datum/action/spell_action/spell/hypnosis/Remove(mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		// Do not erase another hypnosis spell's presentation during replacement/cleanup.
		if(H.hypnotic_presentation_source == target)
			H.hypnotic_presentation_source = null
			H.hypnotic_gaze_text = null
			H.hypnotic_gaze_style = "Hypnotext"
			H.hypnotic_presence = FALSE
	return ..()

// A channel is not a cooldown, and neither stats nor Leyline Haste alter these times.
/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/process()
	if(channel)
		return
	return ..()

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/start_recharge()
	recharge_time = initial(recharge_time)
	last_process_time = world.time
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/Destroy()
	if(channel)
		channel.cancelled = TRUE
	return ..()

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/on_deactivation(mob/living/user)
	if(channel)
		channel.cancelled = TRUE

/obj/effect/proc_holder/spell/invoked/hypnotic_gaze/cast(list/targets, mob/living/user)
	var/mob/living/carbon/human/caster = user
	var/mob/living/carbon/human/target = length(targets) ? targets[1] : null
	if(channel || !hypnotic_gaze_can_channel(caster, target, requires_eye_contact) || caster.hypnotic_gaze_channel || target.hypnotic_gaze_channel)
		var/failure_message = connection_error
		if(!hypnosis_content_enabled(caster))
			failure_message = "I do not have hypnosis content enabled in my toggles!"
		else if(istype(target) && !hypnosis_content_enabled(target))
			failure_message = "They do not consent to hypnosis content."
		else if(requires_eye_contact && istype(caster) && !caster.hypnotic_eyes_visible())
			failure_message = "My eyes are covered!"
		else if(requires_eye_contact && istype(target) && !target.hypnotic_eyes_visible())
			failure_message = "Their eyes are covered!"
		to_chat(user, span_warning(failure_message))
		charge_counter = 0
		start_recharge()
		return FALSE
	var/releasing = !!target.mind.hypnotic_suggestion
	var/datum/weakref/original_suggestion_ref = releasing ? WEAKREF(target.mind.hypnotic_suggestion) : null
	channel = new(caster, target, requires_eye_contact)
	var/datum/hypnotic_gaze_channel/attempt = channel
	to_chat(caster, span_hypnophrase(channel_caster_text))
	to_chat(target, span_hypnophrase(channel_target_text))
	var/success = FALSE
	try
		success = attempt.await_channel()
	catch(var/exception/error)
		stack_trace("[name] channel failed: [error]")
	qdel(attempt)
	if(QDELETED(src))
		return FALSE
	channel = null
	charge_counter = 0
	start_recharge()
	if(!success)
		if(!QDELETED(caster) && hypnosis_content_enabled(caster))
			to_chat(caster, span_hypnophrase("Your concentration breaks, and their thoughts slip beyond your reach."))
		if(!QDELETED(target) && hypnosis_content_enabled(target))
			to_chat(target, span_hypnophrase(interrupted_target_text))
		return FALSE
	var/datum/hypnotic_suggestion/existing = target.mind.hypnotic_suggestion
	if(releasing)
		if(existing && existing != original_suggestion_ref?.resolve())
			return FALSE
		if(existing)
			qdel(existing)
		to_chat(target, span_hypnophrase(release_target_text))
		to_chat(caster, span_hypnophrase(release_caster_text))
	else
		if(existing)
			return FALSE
		new /datum/hypnotic_suggestion(target.mind, caster.mind)
		to_chat(target, span_hypnophrase(trance_target_text))
		to_chat(caster, span_hypnophrase(trance_caster_text))
	return ..()

/proc/hypnotic_gaze_can_channel(mob/living/carbon/human/caster, mob/living/carbon/human/target, requires_eye_contact = TRUE)
	if(!istype(caster) || !istype(target) || QDELETED(caster) || QDELETED(target) || caster == target)
		return FALSE
	if(!caster.client || !target.client || !caster.mind || !target.mind || caster.stat != CONSCIOUS || target.stat != CONSCIOUS)
		return FALSE
	if(!hypnosis_content_enabled(caster) || !hypnosis_content_enabled(target))
		return FALSE
	if(requires_eye_contact && (!caster.hypnotic_eyes_visible() || !target.hypnotic_eyes_visible() || caster.eye_blind || target.eye_blind))
		return FALSE
	var/turf/A = get_turf(caster)
	var/turf/B = get_turf(target)
	// A turf-based view retains obstruction checks without inheriting a blind caster's sight.
	return A && B && A.z == B.z && get_dist(A, B) <= 2 && (target in view(2, requires_eye_contact ? caster : A))

/// Short-lived reservation and movement listeners, only while actually channeling.
/datum/hypnotic_gaze_channel
	var/mob/living/carbon/human/caster
	var/mob/living/carbon/human/target
	var/cancelled = FALSE
	var/requires_eye_contact = TRUE
	var/list/movement_sources = list()
	var/datum/progressbar/caster_bar
	var/datum/progressbar/target_bar

/datum/hypnotic_gaze_channel/New(mob/living/carbon/human/new_caster, mob/living/carbon/human/new_target, needs_eyes = TRUE)
	caster = new_caster
	target = new_target
	requires_eye_contact = needs_eyes
	caster.hypnotic_gaze_channel = src
	target.hypnotic_gaze_channel = src
	RegisterSignal(caster, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MIND_TRANSFER, COMSIG_QDELETING), PROC_REF(interrupt))
	RegisterSignal(target, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MIND_TRANSFER, COMSIG_QDELETING), PROC_REF(interrupt))
	for(var/mob/participant in list(caster, target))
		var/atom/movable/mover = participant
		while(istype(mover))
			movement_sources |= mover
			mover = mover.loc
	for(var/atom/movable/mover as anything in movement_sources)
		RegisterSignal(mover, COMSIG_MOVABLE_MOVED, PROC_REF(interrupt))
	return ..()

/datum/hypnotic_gaze_channel/proc/interrupt()
	SIGNAL_HANDLER
	cancelled = TRUE

/datum/hypnotic_gaze_channel/proc/await_channel()
	var/start = world.time
	var/deadline = start + HYPNOTIC_GAZE_CHANNEL_TIME
	caster_bar = new(caster, HYPNOTIC_GAZE_CHANNEL_TIME, caster)
	target_bar = new(target, HYPNOTIC_GAZE_CHANNEL_TIME, target)
	while(world.time < deadline)
		if(cancelled || !hypnotic_gaze_can_channel(caster, target, requires_eye_contact))
			return FALSE
		stoplag(1)
		caster_bar.update(world.time - start)
		target_bar.update(world.time - start)
	return !cancelled && hypnotic_gaze_can_channel(caster, target, requires_eye_contact)

/datum/hypnotic_gaze_channel/Destroy()
	QDEL_NULL(caster_bar)
	QDEL_NULL(target_bar)
	if(!QDELETED(caster))
		UnregisterSignal(caster, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MIND_TRANSFER, COMSIG_QDELETING))
		if(caster.hypnotic_gaze_channel == src)
			caster.hypnotic_gaze_channel = null
	if(!QDELETED(target))
		UnregisterSignal(target, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MIND_TRANSFER, COMSIG_QDELETING))
		if(target.hypnotic_gaze_channel == src)
			target.hypnotic_gaze_channel = null
	for(var/atom/movable/mover as anything in movement_sources)
		if(!QDELETED(mover))
			UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
	movement_sources.Cut()
	caster = null
	target = null
	return ..()

/datum/mind
	var/datum/hypnotic_suggestion/hypnotic_suggestion

/mob/living
	/// Non-null only while waiting for the caster's next intelligible local sentence.
	var/datum/hypnotic_suggestion/hypnotic_pending

/datum/hypnotic_suggestion
	var/datum/weakref/target_mind_ref
	var/datum/weakref/caster_mind_ref
	var/datum/weakref/body_ref
	var/phrase
	var/reminder_timer
	var/pending_timer
	var/datum/status_effect/debuff/hypnotized/status

/datum/hypnotic_suggestion/New(datum/mind/target_mind, datum/mind/caster_mind)
	target_mind_ref = WEAKREF(target_mind)
	caster_mind_ref = WEAKREF(caster_mind)
	target_mind.hypnotic_suggestion = src
	RegisterSignal(target_mind, list(COMSIG_QDELETING, COMSIG_MIND_PERMANENT_DEPARTURE), PROC_REF(clear_suggestion))
	RegisterSignal(caster_mind, COMSIG_QDELETING, PROC_REF(caster_deleted))
	bind_body(target_mind.current)
	pending_timer = addtimer(CALLBACK(src, PROC_REF(expire_pending)), HYPNOTIC_GAZE_PENDING_TIME, TIMER_STOPPABLE)
	return ..()

/datum/hypnotic_suggestion/proc/bind_body(mob/body)
	unbind_body()
	if(!istype(body) || QDELETED(body))
		return
	body_ref = WEAKREF(body)
	if(!phrase && isliving(body))
		var/mob/living/L = body
		L.hypnotic_pending = src
	if(isliving(body))
		var/mob/living/L = body
		// Possessing a previously occupied body must not retain its former mind's HUD state.
		var/datum/status_effect/debuff/hypnotized/old_status = L.has_status_effect(/datum/status_effect/debuff/hypnotized)
		if(istype(old_status))
			var/datum/hypnotic_suggestion/old_suggestion = old_status.suggestion_ref?.resolve()
			if(old_suggestion && old_suggestion != src)
				old_suggestion.unbind_body()
			else
				qdel(old_status)
		var/datum/status_effect/debuff/hypnotized/new_status = L.apply_status_effect(/datum/status_effect/debuff/hypnotized, src)
		if(istype(new_status) && !QDELETED(new_status))
			status = new_status
	RegisterSignal(body, COMSIG_MIND_TRANSFER, PROC_REF(body_transferred))
	RegisterSignal(body, COMSIG_QDELETING, PROC_REF(body_deleted))

/datum/hypnotic_suggestion/proc/unbind_body()
	if(!QDELETED(status))
		status.suggestion_ref = null
		qdel(status)
	status = null
	var/mob/body = body_ref?.resolve()
	if(!QDELETED(body))
		if(isliving(body))
			var/mob/living/L = body
			if(L.hypnotic_pending == src)
				L.hypnotic_pending = null
		UnregisterSignal(body, list(COMSIG_MIND_TRANSFER, COMSIG_QDELETING))
	body_ref = null

/datum/hypnotic_suggestion/proc/body_transferred(datum/source, mob/new_body)
	SIGNAL_HANDLER
	bind_body(new_body)

/datum/hypnotic_suggestion/proc/body_deleted()
	SIGNAL_HANDLER
	unbind_body()

/datum/hypnotic_suggestion/proc/clear_suggestion()
	SIGNAL_HANDLER
	qdel(src)

/datum/hypnotic_suggestion/proc/caster_deleted()
	SIGNAL_HANDLER
	if(!phrase)
		qdel(src)

/// Called only for fully delivered local speech, never eavesdropped fragments/emotes.
/datum/hypnotic_suggestion/proc/capture(mob/living/listener, atom/movable/speaker, datum/language/language, raw_message, radio_freq, message_mode, allow_sleeping)
	if(phrase || QDELETED(listener) || !hypnosis_content_enabled(listener) || !listener.can_hear() || listener.stat == DEAD)
		return FALSE
	if(listener.stat != CONSCIOUS && !(allow_sleeping && listener.IsSleeping()))
		return FALSE
	var/datum/mind/target_mind = target_mind_ref?.resolve()
	var/datum/mind/caster_mind = caster_mind_ref?.resolve()
	if(!target_mind || !caster_mind || listener.mind != target_mind || !isliving(speaker))
		return FALSE
	var/mob/living/caster = speaker
	if(caster.mind != caster_mind || !hypnosis_content_enabled(caster) || radio_freq || !language || !(listener.has_language(language) || listener.check_language_hear(language)))
		return FALSE
	if(message_mode && message_mode != MODE_WHISPER && message_mode != MODE_WHISPER_CRIT)
		return FALSE
	phrase = hypnotic_speech_plaintext(raw_message)
	if(!length(phrase))
		phrase = null
		return FALSE
	if(listener.hypnotic_pending == src)
		listener.hypnotic_pending = null
	if(pending_timer)
		deltimer(pending_timer)
		pending_timer = null
	if(!QDELETED(status))
		status.update_description()
	reminder_timer = addtimer(CALLBACK(src, PROC_REF(remind)), HYPNOTIC_GAZE_REMINDER_TIME, TIMER_STOPPABLE)
	log_game("HYPNOSIS: [key_name(caster)] suggested '[phrase]' to [key_name(listener)].")
	return TRUE

/datum/hypnotic_suggestion/proc/suggestion_text()
	return phrase ? "You feel compelled to obey: [phrase]" : "Your mind is in a trance, awaiting a suggestion."

/datum/hypnotic_suggestion/proc/expire_pending()
	pending_timer = null
	if(phrase)
		return
	var/datum/mind/M = target_mind_ref?.resolve()
	if(M?.hypnotic_suggestion == src && hypnosis_content_enabled(M.current))
		to_chat(M.current, span_hypnophrase("The trance fades. Your thoughts are your own again."))
	qdel(src)

/datum/hypnotic_suggestion/proc/remind()
	reminder_timer = null
	var/datum/mind/target_mind = target_mind_ref?.resolve()
	if(!target_mind || target_mind.hypnotic_suggestion != src || !phrase)
		qdel(src)
		return
	var/mob/living/body = target_mind.current
	if(istype(body) && body.client && !hypnosis_content_enabled(body))
		qdel(src)
		return
	if(istype(body) && !QDELETED(body) && hypnosis_content_enabled(body) && body.stat != DEAD)
		to_chat(body, hypnotic_gaze_format(suggestion_text()))
	reminder_timer = addtimer(CALLBACK(src, PROC_REF(remind)), HYPNOTIC_GAZE_REMINDER_TIME, TIMER_STOPPABLE)

/datum/hypnotic_suggestion/Destroy()
	if(pending_timer)
		deltimer(pending_timer)
		pending_timer = null
	if(reminder_timer)
		deltimer(reminder_timer)
		reminder_timer = null
	unbind_body()
	var/datum/mind/target_mind = target_mind_ref?.resolve()
	var/datum/mind/caster_mind = caster_mind_ref?.resolve()
	if(target_mind)
		UnregisterSignal(target_mind, list(COMSIG_QDELETING, COMSIG_MIND_PERMANENT_DEPARTURE))
		if(target_mind.hypnotic_suggestion == src)
			target_mind.hypnotic_suggestion = null
	if(caster_mind)
		UnregisterSignal(caster_mind, COMSIG_QDELETING)
	return ..()

/// A visible HUD debuff, managed by the mind-owned suggestion rather than ticking.
/datum/status_effect/debuff/hypnotized
	id = "hypnotic_gaze"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = -1
	needs_processing = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hypnotized
	var/datum/weakref/suggestion_ref

/datum/status_effect/debuff/hypnotized/on_creation(mob/living/new_owner, datum/hypnotic_suggestion/suggestion)
	suggestion_ref = WEAKREF(suggestion)
	. = ..()
	if(.)
		update_description()

/datum/status_effect/debuff/hypnotized/proc/update_description()
	var/datum/hypnotic_suggestion/S = suggestion_ref?.resolve()
	if(S && linked_alert)
		linked_alert.desc = hypnotic_gaze_format(S.suggestion_text())

/datum/status_effect/debuff/hypnotized/on_remove()
	var/datum/hypnotic_suggestion/S = suggestion_ref?.resolve()
	suggestion_ref = null
	if(S && S.body_ref?.resolve() == owner)
		qdel(S)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/hypnotized
	name = "Hypnotized"
	icon = 'icons/mob/actions/hypnotic_gaze.dmi'
	desc = "Your mind is in a trance, awaiting a suggestion."
	icon_state = "hypnosis_debuff"

/mob/living/carbon/human/proc/hypnotized_examine(mob/viewer)
	var/datum/hypnotic_suggestion/S = mind?.hypnotic_suggestion
	if(!S || viewer == src || !hypnosis_content_enabled(viewer) || !hypnotic_eyes_visible())
		return null
	if(isliving(viewer))
		var/mob/living/L = viewer
		if(L.eye_blind)
			return null
	if(viewer.mind && viewer.mind == S.caster_mind_ref?.resolve())
		return span_hypnophrase("I have subdued their will.")
	return span_warning("Their eyes look a little strange.")
