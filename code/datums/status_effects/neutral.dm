//entirely neutral or internal status effects go here


//Roguetown

/datum/status_effect/incapacitating/off_balanced
	id = "off_balanced"
	alert_type = /atom/movable/screen/alert/status_effect/off_balanced
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_offbalanced"
	mob_effect_offset_y = -4	//We want this shown UNDER the feet of the mob.
	mob_effect_layer = MOB_EFFECT_LAYER_OFFBALANCED

/atom/movable/screen/alert/status_effect/off_balanced
	name = "失去平衡"
	desc = ""
	icon_state = "off_balanced"

//ENDROGUE

/datum/status_effect/sigil_mark //allows the affected target to always trigger sigils while mindless
	id = "sigil_mark"
	duration = -1
	alert_type = null
	var/stat_allowed = DEAD //if owner's stat is below this, will remove itself

/datum/status_effect/sigil_mark/tick()
	if(owner.stat < stat_allowed)
		qdel(src)

/datum/status_effect/crusher_damage //tracks the damage dealt to this mob by kinetic crushers
	id = "crusher_damage"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/total_damage = 0

/atom/movable/screen/alert/status_effect/in_love
	name = "坠入爱河"
	desc = ""
	icon_state = "in_love"

/datum/status_effect/in_love
	id = "in_love"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/in_love
	var/mob/living/date

/datum/status_effect/in_love/on_creation(mob/living/new_owner, mob/living/love_interest)
	. = ..()
	if(.)
		date = love_interest
	linked_alert.desc = ""

/datum/status_effect/in_love/tick()
	if(date)
		new /obj/effect/temp_visual/love_heart/invisible(get_turf(date.loc), owner)


/datum/status_effect/throat_soothed
	id = "throat_soothed"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/throat_soothed/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/throat_soothed/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SOOTHED_THROAT, "[STATUS_EFFECT_TRAIT]_[id]")

/datum/status_effect/bounty
	id = "bounty"
	status_type = STATUS_EFFECT_UNIQUE
	var/mob/living/rewarded

/datum/status_effect/bounty/on_creation(mob/living/new_owner, mob/living/caster)
	. = ..()
	if(.)
		rewarded = caster

/datum/status_effect/bounty/on_apply()
	to_chat(owner, span_boldnotice("我听见身后有什么东西在低语……</span> <span class='notice'>我已被 [rewarded] 标记为必死之人。若我死去，对方将得到奖赏。"))
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()

/datum/status_effect/bounty/tick()
	if(owner.stat == DEAD)
		rewards()
		qdel(src)

/datum/status_effect/bounty/proc/rewards()
	if(rewarded && rewarded.mind && rewarded.stat != DEAD)
		to_chat(owner, span_boldnotice("我听见身后有什么东西在低语……</span> <span class='notice'>悬赏已领取。"))
		playsound(owner, 'sound/blank.ogg', 75, FALSE)
		to_chat(rewarded, span_greentext("我感到一股法力涌入体内！"))
		for(var/obj/effect/proc_holder/spell/spell in rewarded.mind.spell_list)
			spell.charge_counter = spell.recharge_time
			spell.update_icon()
		rewarded.adjustBruteLoss(-25)
		rewarded.adjustFireLoss(-25)
		rewarded.adjustToxLoss(-25)
		rewarded.adjustOxyLoss(-25)
		rewarded.adjustCloneLoss(-25)

/datum/status_effect/bugged //Lets another mob hear everything you can
	id = "bugged"
	duration = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/bugged
	var/obj/item/listeningdevice/device

/datum/status_effect/bugged/on_apply(mob/living/new_owner, obj/item/listeningdevice/tracker)
	. = ..()

/datum/status_effect/bugged/on_remove()
	..()
	if(device)
		owner.contents.Remove(device)
		device.forceMove(owner.loc)
		owner.put_in_hands(device)

/atom/movable/screen/alert/bugged
	name = "被窃听"
	desc = "我身上有个音频寄生虫。"
	icon_state = "blackeye"	

/atom/movable/screen/alert/bugged/handle_click()
	var/mob/living/L = usr

	if(!L.has_status_effect(/datum/status_effect/bugged))
		return FALSE

	to_chat(L, span_notice("我用力把寄生虫扯了出来。"))
	playsound(L, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)

	L.remove_status_effect(/datum/status_effect/bugged)

	return TRUE

/datum/status_effect/ugotmail
	id = "mail"
	alert_type = /atom/movable/screen/alert/status_effect/ugotmail

/atom/movable/screen/alert/status_effect/ugotmail
	name = "邮件"
	desc = "HERMES 那里有一封信在等我。"
	icon_state = "mail"

//Xylix Gambling
/datum/status_effect/wheel
	id = "lucky(?)"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000 //Lasts five minutes
	var/wheeleffect
	
/datum/status_effect/wheel/on_apply()
	. = ..()
	wheeleffect = rand(-5,5)
	owner.change_stat(STATKEY_LCK, wheeleffect)
	switch(wheeleffect)
		if(-5 to -1)
			to_chat(owner, span_boldnotice("我心头一沉，感觉自己仿佛失去了什么！"))
		if(0)
			to_chat(owner, span_boldnotice("我的心跳了一下，感觉似乎什么都没有改变……"))
		if(1 to 5)
			to_chat(owner, span_boldnotice("我的心怦然一跳，感觉自己像中了头彩！"))

/datum/status_effect/wheel/on_remove()
	. = ..()
	owner.change_stat(STATKEY_LCK, -wheeleffect)

/atom/movable/screen/alert/status_effect/wheel
	name = "幸运(?)"
	desc = "自从命运改变后，我感觉自己不一样了……"
	icon_state = "asleep"

/atom/movable/screen/alert/status_effect/compliance
	name = "顺从"
	desc = "我目前不会反抗任何抓取我的尝试，也不会挣脱我抓住的对象。别人也能轻易地束缚、制服并洗劫我。\n"\
	+ span_info("左键点击图标可关闭。可在选项卡中屏蔽提示信息。")
	icon_state = "compliance"

// Sadly we can't rely on /atom/movable/screen/Click() to return TRUE at all.
// We MUST use the shitcode method of copypasting if both examine and toggle are to work properly.
/atom/movable/screen/alert/status_effect/compliance/handle_click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE
	var/mob/living/L = usr
	if(!istype(L))
		return
	L.playsound_local(L, 'sound/misc/click.ogg', 100)
	L.toggle_compliance()

/datum/status_effect/compliance
	id = "compliance"
	alert_type = /atom/movable/screen/alert/status_effect/compliance
	needs_processing = FALSE

/datum/status_effect/carebox
	id = "carebox"
	alert_type = /atom/movable/screen/alert/status_effect/carebox

/atom/movable/screen/alert/status_effect/carebox
	name = "包裹"
	desc = "HERMES 那里有一个包裹在等我。"
	icon_state = "mail"
