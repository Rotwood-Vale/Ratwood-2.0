/obj/item/gun/ballistic/firearm/handgonne
	name = "手炮"
	desc = "一根由钢铁与希望铸成的铁筒。\
	它出自格伦泽霍夫攻城铁匠之手，虽独立于 Naledi 的匠人密会之外，却同样依赖烟火药。\
	枪托上刻着工坊印记，只是编号已经被人磨去了……"
	icon = 'modular_helmsguard/icons/weapons/handgonne.dmi'
	icon_state = "handgonne"
	item_state = "handgonne"

/obj/item/gun/ballistic/firearm/handgonne/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/accident_chance = 0
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/turf/knockback = get_ranged_target_turf(user, turn(user.dir, 180), rand(1,2))
	spread = (spread_num - firearm_skill)
	if(firearm_skill < 1)
		accident_chance =80

	if(firearm_skill < 2)
		accident_chance =50
	if(firearm_skill >= 2 && firearm_skill < 5)
		accident_chance =10
	if(firearm_skill >= 5)
		accident_chance =0
	if(HAS_TRAIT(user, TRAIT_FUSILIER))//Regardless of skill, we force it to 0 if you're trained properly.
		accident_chance =0
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
			adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	gunpowder = FALSE
	reloaded = FALSE
	spark_act()

	playsound(src, "modular_helmsguard/sound/arquebus/fuse.ogg", 100)

	spawn(rand(10,20))
		..()
		spawn (1)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
		spawn (5)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
		spawn (12)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))

		for(var/mob/M in range(5, user))
			if(!M.stat)
				shake_camera(M, 3, 1)

		if(prob(accident_chance))
			user.flash_fullscreen("whiteflash")
			user.apply_damage(rand(5,15), BURN, pick(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
			user.visible_message(span_danger("[user]在发射[src]时不慎把自己烧伤了。"))
			user.emote("painscream")
			if(prob(60))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

		if(prob(accident_chance))
			user.visible_message(span_danger("[user]被后坐力猛地震退了！"))
			user.throw_at(knockback, rand(1,2), 7)
			if(prob(accident_chance))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

/obj/item/gun/ballistic/firearm/flintgonne
	name = "燧发枪"
	desc = "一把阿夫尼制式的烟火药长枪。\
	这一型正为新组建的皇家 Strelki 大量打造，专门用于镇压近来在当地爆发的异族叛乱。\
	它在更南方虽然罕见，却也并非闻所未闻，实在是成本与效能兼顾的典范。"
	icon = 'modular_helmsguard/icons/weapons/flintgonne.dmi'//Not Helmsguard. OldRW original, I think? But it's no better a place to put it.
	icon_state = "flintgonne"
	item_state = "flintgonne"
	var/fire_delay = 4//Reliable, unlike the handgonne, but not instant.

//Handgonne, but quicker. Much quicker. But still not point and fire.
/obj/item/gun/ballistic/firearm/flintgonne/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/accident_chance = 0
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/turf/knockback = get_ranged_target_turf(user, turn(user.dir, 180), rand(1,2))
	spread = (spread_num - firearm_skill)
	if(firearm_skill < 1)
		accident_chance =80

	if(firearm_skill < 2)
		accident_chance =50
	if(firearm_skill >= 2 && firearm_skill < 5)
		accident_chance =10
	if(firearm_skill >= 5)
		accident_chance =0
	if(HAS_TRAIT(user, TRAIT_FUSILIER))//Regardless of skill, we force it to 0 if you're trained properly.
		accident_chance =0
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
			adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	gunpowder = FALSE
	reloaded = FALSE
	spark_act()

	playsound(src, "sound/items/flint.ogg", 100)

	spawn(fire_delay)
		..()
		spawn (1)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
		spawn (5)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
		spawn (12)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))

		for(var/mob/M in range(5, user))
			if(!M.stat)
				shake_camera(M, 3, 1)

		if(prob(accident_chance))
			user.flash_fullscreen("whiteflash")
			user.apply_damage(rand(5,15), BURN, pick(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
			user.visible_message(span_danger("[user]在发射[src]时不慎把自己烧伤了。"))
			user.emote("painscream")
			if(prob(60))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

		if(prob(accident_chance))
			user.visible_message(span_danger("[user]被后坐力猛地震退了！"))
			user.throw_at(knockback, rand(1,2), 7)
			if(prob(accident_chance))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

/obj/item/gun/ballistic/firearm/flintgonne/fusil
	name = "燧枪"
	desc = "一把经奥塔维改制的烟火药长枪，只少量配发给数量更加稀少的燧枪兵。\
	它结合了出自 Naledi 的火绳枪本体，以及与阿夫尼燧发枪相近的击发机构。"
	icon = 'modular_helmsguard/icons/weapons/fusil.dmi'//Not Helmsguard. Again. But no better a place to put it.
	icon_state = "fusil"//Flintgonne and Arquebus kitbash.
	item_state = "fusil"
	fire_delay = 8//Double the delay on firing speed when pulling the trigger.
