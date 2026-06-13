/**
 * Modular override handlers for key and lockpick attack procs, scoped to chastity devices.
 *
 * Architecture notes for maintainers:
 * - Lord key uses is_hardmode_active() directly instead of SEND_SIGNAL for the hardmode check.
 *   This is intentional: the lord key's attack proc receives a mob as its target, not the device itself.
 *   Firing COMSIG_CARBON_CHASTITY_LOCK_INTERACT with a mob target causes a type mismatch inside the signal.
 *   Direct proc call avoids the issue cleanly.
 * - Lockpick and hammer & chisel DO use SEND_SIGNAL since their interaction flows through the device context.
 *   The signal fires twice for lockpick: once before do_after (early bail for hardmode) and once after
 *   (in case state changed while the player was waiting). This prevents wasting pick durability and time.
 * - Hard mode routes blocked here: lord key, lockpick, spectral lockpick (lesserknock).
 * - Hard mode routes blocked in chastity_equip.dm: hammer & chisel (attempt_forced_removal).
 * - Allowed removal routes regardless of hardmode: original generated key, werewolf transformation,
 *   catastrophic spiked-device avulsion (cage_twist.dm, cage_pull.dm) AKA ripping the pintle off.
 * - Spectral lockpick (lesserknock) uses identical pick logic to the physical lockpick.
 *   It still benefits from the user's lockpicking skill and can shatter on a failed attempt.
 *   Skill XP is awarded the same way — the arcyne merely shapes the tool, the hand still works it.
 */
/obj/item/roguekey/lord/proc/modular_chastity_attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return null

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]的腹股沟部位被遮住了。我连笼子都看不见，更别说开锁了！"))
		return TRUE
	if(!H.chastity_device)
		to_chat(user, span_warning("[H]没有佩戴贞操装置。违背了阿斯特拉塔的意志，他们的下体正自由敞露着。"))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	// Hard mode is ironclad — even the lord's key cannot unlock it.
	// Only the original generated key, werewolf destruction, or a catastrophic violent rip-out
	// can remove a device whose wearer has hard mode enabled.
	if(device.locked && device.is_hardmode_active())
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	if(device.locked)
		user.visible_message(span_notice("[user]用[src]打开了[H]的贞操装置。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, FALSE, user, src, "key")
	else
		user.visible_message(span_notice("[user]用[src]锁上了[H]的贞操装置。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, TRUE, user, src, "key")

	return TRUE

/obj/item/lockpick/proc/modular_chastity_attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return null
	if(!ishuman(user))
		to_chat(user, span_warning("我没法稳稳控制住这把锁，无法撬开它。"))
		return TRUE

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]的腹股沟部位被遮住了。我够不到锁。"))
		return TRUE
	if(!H.chastity_device)
		to_chat(user, span_warning("[H]没有佩戴贞操装置。"))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		return TRUE
	if(!device.locked)
		to_chat(user, span_notice("[H]的贞操装置已经是解锁状态了。"))
		return TRUE

	// Hardmode blocks lockpicking upfront — no point letting the player burn time and pick durability
	// if the device's owner has permanent binding enabled. Give immediate feedback instead.
	if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, FALSE, "lockpick") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		return TRUE

	var/mob/living/carbon/human/U = user
	var/pickskill = U.get_skill_level(/datum/skill/misc/lockpicking)
	var/perbonus = U.STAPER / 5
	var/picktime = clamp(60 - (pickskill * 8), 15, 60)
	var/pickchance = 25 + (pickskill * 10) + perbonus
	pickchance *= picklvl
	pickchance = clamp(pickchance, 5, 95)

	user.visible_message(span_notice("[user]开始撬开[H]贞操装置上的锁……"), span_notice("我开始撬开[H]贞操装置上的锁……"))
	if(!do_after(user, picktime, target = H))
		return TRUE

	// Re-validate after the timed action in case state changed mid-pick.
	var/obj/item/chastity/current_device = H.chastity_device
	if(!current_device || !current_device.lockable)
		to_chat(user, span_warning("那把锁已经不在那里了。"))
		return TRUE
	if(!current_device.locked)
		to_chat(user, span_notice("[H]的贞操装置已经是解锁状态了。"))
		return TRUE

	if(prob(pickchance))
		if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, FALSE, "lockpick") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
			playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
			to_chat(user, span_warning(current_device.get_lock_denial_string()))
			return TRUE

		playsound(src, pick('sound/items/pickgood1.ogg', 'sound/items/pickgood2.ogg'), 30, TRUE)
		to_chat(user, span_green("锁开了。"))
		current_device.set_chastity_locked_state(H, FALSE, user, src, "lockpick")
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 2)
	else
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		take_damage(1, BRUTE, "blunt")
		to_chat(user, span_warning("咔哒。"))
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 4)

	return TRUE

/**
 * Chastity picking logic for the spectral lockpick created by the Lesser Knock spell.
 * Behaves identically to /obj/item/lockpick/proc/modular_chastity_attack:
 * - Skill and perception govern pick time and success chance, scaled by picklvl (0.99).
 * - A failed attempt can shatter the spectral pick (take_damage → destroy via max_integrity).
 * - Hard mode is blocked upfront and re-validated post-do_after.
 * - Lockpicking XP is awarded on both success and failure; the arcyne shapes the tool, skill works it.
 * The attack() hook in keys.dm routes here before falling through to the touch_attack dispel logic,
 * so targeting a chastity-device wearer picks the lock; targeting anything else dispels the spell.
 */
/obj/item/melee/touch_attack/lesserknock/proc/modular_chastity_attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return null
	if(!ishuman(user))
		to_chat(user, span_warning("我没法稳稳控制住这把锁，无法撬开它。"))
		return TRUE

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]的腹股沟部位被遮住了。我够不到锁。"))
		return TRUE
	if(!H.chastity_device)
		to_chat(user, span_warning("[H]没有佩戴贞操装置。"))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		return TRUE
	if(!device.locked)
		to_chat(user, span_notice("[H]的贞操装置已经是解锁状态了。"))
		return TRUE

	// Hardmode blocks picking upfront — give immediate feedback before burning spell charges and time.
	if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, FALSE, "lockpick") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		to_chat(user, span_warning(device.get_lock_denial_string()))
		return TRUE

	var/mob/living/carbon/human/U = user
	var/pickskill = U.get_skill_level(/datum/skill/misc/lockpicking)
	var/perbonus = U.STAPER / 5
	var/picktime = clamp(60 - (pickskill * 8), 15, 60)
	var/pickchance = 25 + (pickskill * 10) + perbonus
	pickchance *= picklvl
	pickchance = clamp(pickchance, 5, 95)

	user.visible_message(span_notice("[user]用幽光撬锁器划过[H]贞操装置上的锁……"), span_notice("我将幽光撬锁器引入[H]贞操装置上的锁孔……"))
	if(!do_after(user, picktime, target = H))
		return TRUE

	// Re-validate after the timed action in case state changed mid-pick.
	var/obj/item/chastity/current_device = H.chastity_device
	if(!current_device || !current_device.lockable)
		to_chat(user, span_warning("那把锁已经不在那里了。"))
		return TRUE
	if(!current_device.locked)
		to_chat(user, span_notice("[H]的贞操装置已经是解锁状态了。"))
		return TRUE

	if(prob(pickchance))
		if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, FALSE, "lockpick") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
			playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
			to_chat(user, span_warning(current_device.get_lock_denial_string()))
			return TRUE

		playsound(src, pick('sound/items/pickgood1.ogg', 'sound/items/pickgood2.ogg'), 30, TRUE)
		to_chat(user, span_green("锁开了。"))
		current_device.set_chastity_locked_state(H, FALSE, user, src, "lockpick")
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 2)
	else
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		take_damage(1, BRUTE, "blunt")
		to_chat(user, span_warning("咔哒。奥术焦点动摇了。"))
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 4)

	return TRUE
