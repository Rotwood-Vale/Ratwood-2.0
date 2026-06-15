/datum/wound/magical/pain_spell
	name = "奥术痛灼"
	check_name = "奥术痛灼"
	severity = WOUND_SEVERITY_LIGHT
	mob_overlay = ""
	sewn_overlay = ""
	whp = 1
	sewn_whp = 1
	woundpain = 30
	sewn_woundpain = 0
	sleep_healing = 0
	passive_healing = 0
	qdel_on_droplimb = TRUE
	var/pain_expire_timer_id

/datum/wound/magical/pain_spell/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/magical/pain_spell))
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/pain
	name = "钻心剜骨"
	desc = "三大不可饶恕中的钻心咒，会让目标感受到可怕的疼痛。"
	cost = 3
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 0
	recharge_time = 10 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	school = "evocation"
	spell_tier = 2
	invocations = list("钻心剜骨！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	miracle = FALSE
	gesture_required = TRUE
	var/projectile_type = /obj/projectile/energy/pain_spell_bolt

/obj/projectile/energy/pain_spell_bolt
	name = "钻心咒矢"
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	icon_state = "sphere0"
	color = "#c81818"
	damage = 0
	damage_type = STAMINA
	nodamage = TRUE
	speed = 0.8
	muzzle_type = null
	impact_type = null
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	var/pain_amount = 5
	var/target_zone
	var/obj/effect/proc_holder/spell/invoked/pain/casting_spell

/obj/projectile/energy/pain_spell_bolt/on_hit(atom/target, blocked = FALSE)
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target
	if(blocked == 100)
		return ..()
	if(living_target.anti_magic_check())
		visible_message(span_warning("[src] 在接触 [living_target] 时炸成一缕猩红火星，随即被反魔法驱散了！"))
		playsound(get_turf(living_target), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return .

	if(!istype(firer, /mob/living))
		return BULLET_ACT_HIT

	var/mob/living/caster = firer
	if(!casting_spell)
		return BULLET_ACT_HIT
	if(!casting_spell.apply_pain_effect(living_target, caster, pain_amount, target_zone))
		to_chat(caster, span_warning("[living_target] 似乎无法承受这道钻心剜骨。"))
		return BULLET_ACT_HIT

	living_target.emote("painscream")
	living_target.visible_message(span_warning("[living_target] 被一枚猩红奥术飞矢击中后猛然抽搐，忍不住发出凄厉痛呼！"))
	to_chat(living_target, span_userdanger("那道猩红咒矢钻入体内后，剧痛像利钩一样撕扯着我的神经！"))
	to_chat(caster, span_notice("我射出的钻心咒矢命中了 [living_target]，并将剧烈痛楚灌进了 [living_target.p_their()] 身体。"))
	playsound(get_turf(living_target), 'sound/combat/hits/blunt/shovel_hit2.ogg', 100)
	return BULLET_ACT_HIT

/obj/effect/proc_holder/spell/invoked/pain/cast(list/targets, mob/living/user = usr)
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	if(!fire_pain_projectile(user, target))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user] 指尖一抬，一枚血红色的奥术飞矢便尖啸着射向 [target]！"))
	to_chat(user, span_notice("我将钻心剜骨化作一枚猩红咒矢，直射向 [target]。"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/pain/proc/fire_pain_projectile(mob/living/user, atom/target)
	var/obj/projectile/energy/pain_spell_bolt/projectile = new projectile_type(user.loc)
	// 投射物统一按胸口结算，避免弹道随机偏斜后出现“显示命中 A 处、疼痛却落在 B 处”的错位。
	projectile.def_zone = BODY_ZONE_CHEST
	projectile.target_zone = BODY_ZONE_CHEST
	projectile.pain_amount = get_pain_amount(user)
	projectile.casting_spell = src
	// 沿用现有投射法术的命中修正，让奥术等级也能略微提高命中率。
	projectile.accuracy += (user.STAINT - 9) * 4
	projectile.bonus_accuracy += (user.STAINT - 8) * 3
	if(user.mind)
		projectile.bonus_accuracy += (user.get_skill_level(associated_skill) * 5)
	projectile.firer = user
	projectile.preparePixelProjectile(target, user)
	projectile.fire()
	return TRUE

/obj/effect/proc_holder/spell/invoked/pain/proc/apply_pain_effect(mob/living/target, mob/living/user, pain_amount = null, preferred_zone = null)
	if(isnull(pain_amount))
		pain_amount = get_pain_amount(user)

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/datum/wound/magical/pain_spell/existing_agony = carbon_target.has_wound(/datum/wound/magical/pain_spell)

		var/obj/item/bodypart/affected = carbon_target.get_bodypart(check_zone(preferred_zone || user?.zone_selected))
		if(!affected && existing_agony?.bodypart_owner)
			affected = existing_agony.bodypart_owner
		if(!affected && carbon_target.bodyparts?.len)
			affected = carbon_target.bodyparts[1]
		if(!affected)
			return FALSE

		if(existing_agony)
			existing_agony.woundpain = pain_amount
			queue_bodypart_pain_expire(existing_agony.bodypart_owner || affected, existing_agony)
			return TRUE

		var/datum/wound/magical/pain_spell/agony = affected.add_wound(/datum/wound/magical/pain_spell, TRUE)
		if(!agony)
			return FALSE
		// 让法术伤口的痛感与施法者奥术等级同步。
		agony.woundpain = pain_amount

		queue_bodypart_pain_expire(affected, agony)
		return TRUE

	if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		var/datum/wound/magical/pain_spell/existing_agony = target.has_wound(/datum/wound/magical/pain_spell)
		if(existing_agony)
			existing_agony.woundpain = pain_amount
			queue_simple_pain_expire(target, existing_agony)
			return TRUE

		var/datum/wound/magical/pain_spell/agony = target.simple_add_wound(/datum/wound/magical/pain_spell, TRUE)
		if(!agony)
			return FALSE
		agony.woundpain = pain_amount

		queue_simple_pain_expire(target, agony)
		return TRUE

	target.apply_damage(pain_amount, STAMINA)
	return TRUE

/obj/effect/proc_holder/spell/invoked/pain/proc/get_pain_amount(mob/living/user)
	var/arcane_level = max(user?.get_skill_level(/datum/skill/magic/arcane), 0)
	if(arcane_level <= 1)
		return 5
	switch(arcane_level)
		if(2)
			return 15
		if(3)
			return 40
		if(4)
			return 60
		if(5)
			return 80
	return 100

/obj/effect/proc_holder/spell/invoked/pain/proc/clear_existing_pain_wounds(mob/living/carbon/target)
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
		bodypart.remove_wound(/datum/wound/magical/pain_spell)

/obj/effect/proc_holder/spell/invoked/pain/proc/queue_bodypart_pain_expire(obj/item/bodypart/affected, datum/wound/magical/pain_spell/agony)
	if(QDELETED(affected) || QDELETED(agony))
		return
	reset_pain_expire_timer(agony)
	agony.pain_expire_timer_id = addtimer(CALLBACK(src, PROC_REF(expire_bodypart_pain_wound), affected, agony), 10 SECONDS)

/obj/effect/proc_holder/spell/invoked/pain/proc/queue_simple_pain_expire(mob/living/target, datum/wound/magical/pain_spell/agony)
	if(QDELETED(target) || QDELETED(agony))
		return
	reset_pain_expire_timer(agony)
	agony.pain_expire_timer_id = addtimer(CALLBACK(src, PROC_REF(expire_simple_pain_wound), target, agony), 10 SECONDS)

/obj/effect/proc_holder/spell/invoked/pain/proc/reset_pain_expire_timer(datum/wound/magical/pain_spell/agony)
	var/existing_timer = agony.pain_expire_timer_id
	if(existing_timer)
		deltimer(existing_timer)
	agony.pain_expire_timer_id = null

/obj/effect/proc_holder/spell/invoked/pain/proc/expire_bodypart_pain_wound(obj/item/bodypart/affected, datum/wound/magical/pain_spell/agony)
	agony.pain_expire_timer_id = null
	if(QDELETED(affected) || QDELETED(agony))
		return
	affected.remove_wound(agony)

/obj/effect/proc_holder/spell/invoked/pain/proc/expire_simple_pain_wound(mob/living/target, datum/wound/magical/pain_spell/agony)
	agony.pain_expire_timer_id = null
	if(QDELETED(target) || QDELETED(agony))
		return
	target.simple_remove_wound(agony)
