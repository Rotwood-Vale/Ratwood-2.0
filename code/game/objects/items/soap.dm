/obj/item/soap
	name = "肥皂"
	desc = "佩斯特拉谦卑朴素的恩赐之一。小心别滑倒！"
	gender = PLURAL
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 1
	throw_range = 7
	grind_results = list(/datum/reagent/lye = 10)
	dropshrink = 0.7
	var/cleanspeed = 20 //as fast as 5 arcyne Prestidigitation
	var/uses = 100

/obj/item/soap/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 1 SECONDS, NO_SLIP_WHEN_WALKING)

/obj/item/soap/examine(mob/user)
	. = ..()
	var/max_uses = initial(uses)
	var/msg = "它看起来刚做好。"
	if(uses != max_uses)
		var/percentage_left = uses / max_uses
		switch(percentage_left)
			if(0 to 0.15)
				msg = "它只剩下一丁点儿了，你不确定它还能撑多久。"
			if(0.15 to 0.30)
				msg = "它已经融化了不少，不过还能再用一阵子。"
			if(0.30 to 0.50)
				msg = "它已经过了最佳状态，但绝对还能用。"
			if(0.50 to 0.75)
				msg = "它开始比原来小了一圈，但肯定还能用很长时间。"
			else
				msg = "它有些许使用痕迹，但还相当新。"
	. += span_notice("[msg]")

/obj/item/soap/proc/decreaseUses(mob/user)
	uses--
	if(uses <= 0)
		to_chat(user, span_warning("[src]碎裂成了小碎片！"))
		qdel(src)

/obj/item/soap/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/turf/bathspot = get_turf(target)
	if(ishuman(target) && (istype(bathspot, /turf/open/water/bath) || locate(/obj/structure/hotspring) in bathspot))
		return
	if(!proximity || !check_allowed_items(target, target_self=1))
		return
	if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user]开始用[src]擦掉[target.name]。"), span_warning("我开始用[src]擦掉[target.name]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("我擦掉了[target.name]。"))
			qdel(target)
			decreaseUses(user)

	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/mob/living/carbon/human/H = user
		user.visible_message(span_warning("[user]用[src.name]洗了[target]的嘴巴！"), span_notice("我用[src.name]洗了[target]的嘴巴！"))
		H.lip_style = null //removes lipstick
		H.update_body()
		decreaseUses(user)
		return
	else if(istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user]开始用[src]清洁[target.name]..."), span_notice("我开始用[src]清洁[target.name]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("我擦干净了[target.name]。"))
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
			decreaseUses(user)
	else
		user.visible_message(span_notice("[user]开始用[src]清洁[target.name]..."), span_notice("我开始用[src]清洁[target.name]..."))
		if(do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("我擦干净了[target.name]。"))
			for(var/obj/effect/decal/cleanable/C in target)
				qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
			decreaseUses(user)
	return


/obj/item/soap/attack(mob/target, mob/user)
	var/turf/bathspot = get_turf(target)
	if(!istype(bathspot, /turf/open/water/bath) && !locate(/obj/structure/hotspring) in bathspot)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	visible_message(span_info("[user]开始用[src]给[H]洗澡。"))
	if(do_after(user, 50))
		wash_atom(target,CLEAN_MEDIUM)
		if(HAS_TRAIT(user, TRAIT_GOODLOVER))
			visible_message(span_info("[user]熟练地用[src]把[H]清洗得干干净净，令其浑身舒泰。"))
			to_chat(H, span_love("我感觉好放松，好干净！"))
			H.add_stress(/datum/stressevent/bathcleaned)
		else
			visible_message(span_info("[user]尽力用[src]给[H]擦洗了一番。"))
			to_chat(H, span_warning("还行吧，确实舒服一点了。"))
			H.add_stress(/datum/stressevent/bath)
		var/datum/charflaw/malodorous/malodorous_flaw = H.get_flaw(/datum/charflaw/malodorous)
		malodorous_flaw?.on_bath(H)
		H.remove_status_effect(/datum/status_effect/debuff/stinky_contact)
		uses -= 1
		if(uses == 0)
			qdel(src)
