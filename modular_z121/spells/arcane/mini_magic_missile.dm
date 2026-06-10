/obj/effect/proc_holder/spell/invoked/projectile/mini_magic_missile
	name = "小魔弹术"
	desc = "发射一颗小型魔弹，击中目标后造成轻度钝击伤害。"
	overlay_state = "force_dart"
	range = 5
	projectile_type = /obj/projectile/energy/mini_magic_missile
	sound = list('sound/magic/vlightning.ogg')
	releasedrain = 5
	chargedrain = 0
	chargetime = 0
	recharge_time = 0.4 SECONDS
	human_req = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("微芒，成弹！")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 0
	chargedloop = null
	associated_skill = /datum/skill/magic/arcane
	cost = 3
	miracle = FALSE

/obj/projectile/energy/mini_magic_missile
	name = "小魔弹"
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	icon_state = "sphere0"
	damage = 15
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	nodamage = FALSE
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	speed = 0.8
	muzzle_type = null
	impact_type = null

/obj/projectile/energy/mini_magic_missile/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] 在接触[target]时无声地熄散了！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), 'sound/combat/hits/blunt/shovel_hit2.ogg', 100)
	return
