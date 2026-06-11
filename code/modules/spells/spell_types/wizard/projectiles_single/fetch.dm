/obj/effect/proc_holder/spell/invoked/projectile/fetch
	name = "牵引术"
	desc = "射出一道魔力飞矢，将命中的目标拉向施法者。"
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/fetch
	sound = list('sound/magic/magnet.ogg')
	active = FALSE
	human_req = TRUE
	releasedrain = 5
	chargedrain = 0
	chargetime = 0
	warnie = "spellwarning"
	overlay_state = "fetch"
	no_early_release = TRUE
	charging_slowdown = 1
	spell_tier = 2
	invocations = list("牵引归来。")
	invocation_type = "whisper"
	hide_charge_effect = TRUE // essential for rogue mage
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 2 // Combat spell, but of slighlty less obvious use
	xp_gain = TRUE

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[target] 弹开了这道牵引术！"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
