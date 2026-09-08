GLOBAL_DATUM_INIT(ssd_indicator, /mutable_appearance, mutable_appearance('icons/mob/ssd_indicator.dmi', "default0", FLY_LAYER))

#define DISCONNECTED_ADMIN_ALERT_TIME 15 MINUTES

/mob/living/proc/set_ssd_indicator(state)
	if(state && stat != DEAD)
		add_overlay(GLOB.ssd_indicator)
	else
		cut_overlay(GLOB.ssd_indicator)
	return state

/mob/living/proc/get_ssd_examine_text(m3)
	if(client || !last_logout_time || stat == DEAD || HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		return
	return span_warning("[m3] been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)].")

/mob/living/proc/queue_disconnected_admin_alert()
	cancel_disconnected_admin_alert()
	disconnected_admin_alert_timer = addtimer(CALLBACK(src, PROC_REF(disconnected_admin_alert)), DISCONNECTED_ADMIN_ALERT_TIME, TIMER_STOPPABLE)

/mob/living/proc/cancel_disconnected_admin_alert()
	if(disconnected_admin_alert_timer)
		deltimer(disconnected_admin_alert_timer)
		disconnected_admin_alert_timer = null

/mob/living/proc/disconnected_admin_alert()
	disconnected_admin_alert_timer = null
	if(client || !last_logout_time || stat == DEAD || disconnected_admin_alert_sent || HAS_TRAIT(src, TRAIT_NOSSDINDICATOR))
		return
	if(!ishuman(src))
		return
	disconnected_admin_alert_sent = TRUE
	var/fartravel_link = "(<a href='?_src_=holder;[HrefToken(TRUE)];ssd_sendbacktolobby=[REF(src)]'>Fartravel</a>)"
	message_admins(span_adminnotice("[ADMIN_LOOKUPFLW(src)] has been in a deep slumber for [DisplayTimeText(world.time - last_logout_time, 1)]. [fartravel_link]"))

#undef DISCONNECTED_ADMIN_ALERT_TIME

