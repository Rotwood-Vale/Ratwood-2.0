GLOBAL_DATUM_INIT(ssd_indicator, /mutable_appearance, mutable_appearance('icons/mob/ssd_indicator.dmi', "default0", FLY_LAYER))
GLOBAL_LIST_INIT(disconnected_admin_alert_role_times, list(
	// "Grand Duke" = 10 MINUTES,
))

#define DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME 15 MINUTES

/mob/living/proc/set_ssd_indicator(state)
	if(state && stat != DEAD)
		add_overlay(GLOB.ssd_indicator)
	else
		cut_overlay(GLOB.ssd_indicator)
	return state

/mob/living/proc/get_ssd_examine_text(m3)
	if(!is_disconnected_player())
		return
	return span_warning("[m3] been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)].")

/// Returns TRUE if this mob's player has disconnected from the game while still in it.
/// Bodies left behind while the player plays elsewhere (wildshape, werewolf and spell shapeshifts, ghosting)
/// lose their key along with the player, so they are not counted.
/mob/living/proc/is_disconnected_player()
	if(client || !ckey || !last_logout_time || stat == DEAD)
		return FALSE
	// An aghosted admin's body holds a placeholder "@key".
	if(copytext(key, 1, 2) == "@")
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		return FALSE
	return TRUE

/// Flags this mob as holding a disconnected player: starts the admin alert timer and shows the SSD indicator.
/// since is when the player disconnected, for a slumbering player moved here from another mob.
/mob/living/proc/mark_disconnected(since = world.time)
	last_logout_time = since
	disconnected_admin_alert_sent = FALSE
	queue_disconnected_admin_alert()
	if(!HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		set_ssd_indicator(TRUE)

/mob/living/proc/clear_disconnected()
	last_logout_time = 0
	cancel_disconnected_admin_alert()
	set_ssd_indicator(FALSE)

/// Returns the shapeshift holder inside this spell shapeshift form, if it carries a human caster.
/mob/living/proc/get_shapeshift_holder()
	var/obj/shapeshift_holder/holder = locate() in src
	if(holder && ishuman(holder.stored))
		return holder

/// Returns the human character this mob's player would leave the round as, or null if there is none.
/// A spell shapeshift form carries the caster's body inside its shapeshift holder.
/mob/living/proc/get_real_body()
	var/obj/shapeshift_holder/holder = get_shapeshift_holder()
	return holder?.stored

/// Wildshape and werewolf forms carry the character's body in stored_mob.
/mob/living/carbon/human/get_real_body()
	. = ..()
	if(!.)
		return ishuman(stored_mob) ? stored_mob : src

/mob/living/proc/queue_disconnected_admin_alert()
	cancel_disconnected_admin_alert()
	var/alert_time = get_disconnected_admin_alert_time()
	if(!alert_time)
		return
	// Count from the disconnect, which may predate this mob holding the player.
	alert_time = max(alert_time - (world.time - last_logout_time), 1)
	disconnected_admin_alert_timer = addtimer(CALLBACK(src, PROC_REF(disconnected_admin_alert)), alert_time, TIMER_STOPPABLE)

/mob/living/proc/cancel_disconnected_admin_alert()
	if(disconnected_admin_alert_timer)
		deltimer(disconnected_admin_alert_timer)
		disconnected_admin_alert_timer = null

/mob/living/proc/disconnected_admin_alert()
	disconnected_admin_alert_timer = null
	if(disconnected_admin_alert_sent || !is_disconnected_player())
		return
	if(!get_real_body())
		return
	disconnected_admin_alert_sent = TRUE
	var/fartravel_link = "(<a href='?_src_=holder;[HrefToken(TRUE)];ssd_sendbacktolobby=[REF(src)];ssd_ckey=[ckey]'>Fartravel</a>)"
	message_admins(span_adminnotice("[ADMIN_LOOKUPFLW(src)] ([get_disconnected_admin_alert_job_name()]) has been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)]. [fartravel_link]"))

/mob/living/proc/get_disconnected_admin_alert_time()
	var/role_name = get_disconnected_admin_alert_role_name()
	if(role_name in GLOB.disconnected_admin_alert_role_times)
		return GLOB.disconnected_admin_alert_role_times[role_name]
	return DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME

/mob/living/proc/get_disconnected_admin_alert_role_name()
	return mind?.assigned_role ? mind.assigned_role : job

/mob/living/proc/get_disconnected_admin_alert_job_name()
	var/role_name = get_disconnected_admin_alert_role_name()
	if(advjob && role_name && advjob != role_name)
		return "[role_name] / [advjob]"
	if(role_name)
		return role_name
	if(advjob)
		return advjob
	return "Unknown job"

#undef DEFAULT_DISCONNECTED_ADMIN_ALERT_TIME

