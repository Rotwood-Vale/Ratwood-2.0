/datum/advclass/noble
	name = "Aristocrat"
	tutorial = "You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grizzly end."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/refugee/noble
	traits_applied = list(TRAIT_NOBLE, TRAIT_SEEPRICES, TRAIT_CICERONE)//wine-tasting experience
	category_tags = list(CTAG_PILGRIM, CTAG_COURTAGENT)

	cmode_music = 'sound/music/combat_knight.ogg'
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = -1,
		STATKEY_SPD = 1,
	)

/datum/outfit/job/roguetown/refugee/noble/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a traveling noble visiting foreign lands. With wealth, come the poor, ready to pilfer you of your hard earned (inherited) coin, so tread lightly unless you want to meet a grizzly end."))
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/silver
	beltl = /obj/item/rogueweapon/sword/sabre/dec
	l_hand = /obj/item/rogueweapon/scabbard/sword
	if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/half/red
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
		armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
		pants = /obj/item/clothing/under/roguetown/tights/black
		head = /obj/item/clothing/head/roguetown/fancyhat
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
		cloak = /obj/item/clothing/cloak/raincloak/purple
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
	var/turf/TU = get_turf(H)
	if(TU)
		new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
	H.set_blindness(0)
