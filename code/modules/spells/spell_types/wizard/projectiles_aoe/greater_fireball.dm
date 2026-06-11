/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater
	name = "强效火球术"
	desc = "射出一枚巨大的火球，在命中时猛烈爆炸。"
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/great
	overlay_state = "fireball_wide"
	sound = list('sound/magic/fireball.ogg')
	active = FALSE
	releasedrain = 50
	chargedrain = 1
	chargetime = 15
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	spell_tier = 4 // Highest tier AOE
	invocations = list("烈焰巨球，爆裂！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokefire
	cost = 9
	xp_gain = TRUE

/obj/projectile/magic/aoe/fireball/rogue/great
	name = "火球"
	exp_heavy = 0
	exp_light = 1
	exp_flash = 2
	exp_fire = 2
	damage = 90 // This is gonna fucking HURT
	npc_simple_damage_mult = 2 // HAHAHA
	flag = "magic"
