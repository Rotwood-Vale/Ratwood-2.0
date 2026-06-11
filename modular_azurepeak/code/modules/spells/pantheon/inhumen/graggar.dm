//Call to Slaughter - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_slaughter
	name = "屠戮号令"
	desc = "强化你与附近所有盟友的力量、意志与体质。"
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "call_to_slaughter"
	recharge_time = 5 MINUTES
	invocations = list("羔羊们，奔赴屠场吧！")
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
			to_chat(target, span_danger("你感到一阵寒意冲刷全身，却又如来时一般迅速退去......"))	//No effect on Psydonians!
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
	return TRUE

//Unholy Grasp - Throws disappearing net made of viscera at enemy. Creates blood on impact.
/obj/effect/proc_holder/spell/invoked/projectile/blood_net
	name = "渎圣攫握"
	desc = "将由献给格拉加尔的残余祭品所化成的血肉陷网掷向短距离外。如同罗网一般，将你的目标牢牢困住！"
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_grasp"
	clothes_req = FALSE
	range = 3													//It's a net, so low range.
	req_inhand = /obj/item/alch/viscera							//Need to have viscera inhand to cast this.
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/invoked/projectile/blood_net/cast(list/targets, mob/user = usr)
	var/obj/item/I = user.get_active_held_item()
	if(!istype(I, req_inhand))
		to_chat(user, span_warning("我手中没有施展此术所需的内脏。"))
		return FALSE
	. = ..()
	if(. && I)
		qdel(I)

/obj/projectile/magic/unholy_grasp
	name = "脏器罗网"
	icon_state = "tentacle_end"
	nodamage = TRUE
	knockdown = 3 SECONDS

/obj/projectile/magic/unholy_grasp/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. == BULLET_ACT_MISS || . == BULLET_ACT_BLOCK || !iscarbon(hit_atom))
		return

	ensnare(hit_atom)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	if(carbon.legcuffed || carbon.get_num_legs(FALSE) < 2)
		return

	var/obj/item/net/unholy_grasp/net = new(get_turf(carbon))
	net.slipouttime = max(2 SECONDS, 13 SECONDS - max(0, carbon.STASTR - 10) * 0.5 SECONDS)
	visible_message(span_danger("\The [src]用内脏缠住了[carbon]！"))
	to_chat(carbon, span_danger("\The [src]缠住了你！"))
	carbon.legcuffed = net
	net.forceMove(carbon)
	carbon.update_inv_legcuffed()
	carbon.Knockdown(knockdown)
	carbon.apply_status_effect(/datum/status_effect/debuff/netted)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

/obj/item/net/unholy_grasp
	name = "内脏之网"
	desc = "一团令人作呕的脏器团块，将受害者的双腿死死缠住。"
	color = "#80182e"

/obj/item/net/unholy_grasp/remove_effect()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.legcuffed = null
			M.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, TRUE)
			M.update_inv_legcuffed()
			if(M.has_status_effect(/datum/status_effect/debuff/netted))
				M.remove_status_effect(/datum/status_effect/debuff/netted)
		var/turf/T = get_turf(M)
		if(T)
			forceMove(T)

/obj/item/net/unholy_grasp/Destroy() //we avoud forceMove() my manna caused by destroy as its not good to put it together
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.legcuffed = null
			M.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, TRUE)
			M.update_inv_legcuffed()
		if(M.has_status_effect(/datum/status_effect/debuff/netted))
			M.remove_status_effect(/datum/status_effect/debuff/netted)
	return ..()

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "沉湎屠戮"
	desc = "你敌人的血液将会沸腾，他们的皮肤会像被生生撕裂一般！格拉加尔要他们的鲜血尽情流淌！！！"
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "revel_in_slaughter"
	recharge_time = 1 MINUTES
	invocations = list("你的鲜血将沸腾，直到洒尽为止！")
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
		to_chat(user, span_warning("格拉加尔要求以鲜血来唤起祂的力量！"))
		revert_cast()
		return FALSE

	var/datum/physiology/phy = human.physiology

	phy.bleed_mod *= 1.5
	phy.pain_mod *= 1.5

	addtimer(VARSET_CALLBACK(phy, bleed_mod, phy.bleed_mod /= 1.5), 25 SECONDS)
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 1.5), 15 SECONDS)

	human.visible_message(span_danger("[human]的伤口开始发炎，生命力正被迅速抽离！"))
	to_chat(human, span_warning("我的皮肤像被无数针刺穿，又仿佛有什么东西正在撕扯着我！"))

	return TRUE

//Bloodrage T0 -- Uncapped STR buff.
/obj/effect/proc_holder/spell/self/graggar_bloodrage
	name = "血怒"
	desc = "在短时间内赐予你毫无束缚的力量。"
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("格拉加尔！！格拉加尔！！格拉加尔！！",
		"格拉加尔！打碎我的枷锁！",
		"格拉加尔！粉碎我的束缚！"
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
	var/mob/living/carbon/human/H = user
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	H.apply_status_effect(/datum/status_effect/buff/bloodrage)
	H.visible_message(span_danger("[H]猛然挺身而起，浑身翻涌着滔天怒火！"))
	return TRUE
