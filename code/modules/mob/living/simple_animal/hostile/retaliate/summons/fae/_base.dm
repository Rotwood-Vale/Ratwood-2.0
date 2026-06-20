/mob/living/simple_animal/hostile/retaliate/rogue/fae
	obj_damage = 75

/mob/living/simple_animal/hostile/retaliate/rogue/fae/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	faction += "plants"

/mob/living/simple_animal/hostile/retaliate/rogue/fae/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		if(istype(magicmaterial, /obj/item/magic/fae))
			if(health == maxHealth)
				to_chat(user, "[src]已经很健康了！")
				return
			to_chat(user, "我开始用[magicmaterial]治疗[src]。")
			if(do_mob(user, src, 20))
				var/tier_diff = magicmaterial.tier / summon_tier //find the percentage of the guy we're healing based on the tier of our magic material
				visible_message("[src]吸收了[magicmaterial]并得到了治疗。")
				adjustBruteLoss(-maxHealth * tier_diff)
				qdel(magicmaterial)
				return
	..()
