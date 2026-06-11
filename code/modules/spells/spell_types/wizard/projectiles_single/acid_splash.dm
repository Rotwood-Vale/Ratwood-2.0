/obj/effect/proc_holder/spell/invoked/projectile/acidsplash
	name = "酸液飞溅"
	desc = "射出一团缓慢飞行的酸液，命中时会向周围喷溅开来。"
	range = 8
	projectile_type = /obj/projectile/magic/acidsplash
	overlay_state = "acid_splash"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	releasedrain = 30
	chargedrain = 1
	chargetime = 3
	recharge_time = 15 SECONDS //cooldown
	human_req = TRUE

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE //can you use it if you are antimagicked?
	spell_tier = 2
	invocations = list("酸液，飞溅！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

/obj/effect/proc_holder/spell/self/acidsplash/cast(mob/user = usr)
	var/mob/living/target = user
	target.visible_message(span_warning("[target] 掷出了一团腐蚀酸泡！"), span_notice("我掷出了一团腐蚀酸泡！"))
	. = ..()

/obj/projectile/magic/acidsplash //port. todo: the sounds these came with aren't good and drink_blood sounds like ur slurpin pintle
	name = "酸泡"
	icon_state = "green_laser"
	damage = 15
	damage_type = BURN
	flag = "magic"
	range = 15
	speed = 1
	var/aoe_range = 1

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(src, 'sound/misc/drink_blood.ogg', 100)

	for(var/mob/living/L in range(aoe_range, get_turf(src))) //apply damage over time to mobs
		if(!L.anti_magic_check())
			var/mob/living/carbon/M = L
			M.apply_status_effect(/datum/status_effect/buff/acidsplash)
			new /obj/effect/temp_visual/acidsplash(get_turf(M))
	for(var/turf/turfs_in_range in range(aoe_range+1, T)) //make a splash
		new /obj/effect/temp_visual/acidsplash(T)

/datum/status_effect/buff/acidsplash
	id = "acid splash"
	alert_type = /atom/movable/screen/alert/status_effect/buff/acidsplash
	duration = 20 SECONDS

/datum/status_effect/buff/acidsplash/on_apply()
	. = ..()
	owner.playsound_local(get_turf(owner), 'sound/misc/lava_death.ogg', 35, FALSE, pressure_affected = FALSE)
	owner.visible_message(span_warning("[owner] 被酸液覆盖了！"), span_danger("我被酸液覆盖了！"))
	owner.emote("scream")

/datum/status_effect/buff/acidsplash/tick()
	var/mob/living/target = owner
	target.adjustFireLoss(5)

/atom/movable/screen/alert/status_effect/buff/acidsplash
	name = "酸蚀灼伤"
	desc = "我的皮肤正在被酸液灼烧！"
	icon_state = "debuff"

/obj/effect/temp_visual/acidsplash
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter2"
	name = "刺鼻酸液"
	desc = "最好别碰这东西。"
	randomdir = TRUE
	duration = 1 SECONDS
	layer = ABOVE_ALL_MOB_LAYER
