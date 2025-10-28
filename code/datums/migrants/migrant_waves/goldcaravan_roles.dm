#define CTAG_EA_MERCHANT "ea_merchant"
#define CTAG_EA_GUARD "ea_guard"
/datum/migrant_role/ea_hasir/merchant
	name = "EA Hasir-ian Gold Merchant"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_EA_MERCHANT = 20)
	greet_text = "The esteemed EA-Hasir owns your gold company, Promising only the finest quality gold in grimoria\
	 You've been sent with your caravan to sell golden riches and wonders- at a high price."

/datum/advclass/merchant
	name = "EA Hasir-ian Merchant"
	tutorial = "You were born into wealth, learning from before you could talk about the basics of mathematics. \
	Counting coins is a simple pleasure for any person, but you've made it an art form. \
	EA-Hasir has entrusted you with some of his highest quality gold products- Make him proud, \
	Rob 'em all blind."
	outfit = /datum/outfit/job/roguetown/merchant/ea_hasir
	traits_applied = list(TRAIT_NOBLE, TRAIT_OUTLANDER)
	category_tags = list(CTAG_EA_MERCHANT)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_STR = -1
	)
/datum/outfit/job/roguetown/merchant/ea_hasir/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/navaja)
	head = /obj/item/clothing/head/roguetown/chaperon/noble
	neck = /obj/item/clothing/neck/roguetown/horus
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	pants = /obj/item/clothing/under/roguetown/trou/leathertights
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/gold
	backr = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_masc_clothes(H))
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
		H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	else if(should_wear_femme_clothes(H))
		shoes = /obj/item/clothing/shoes/roguetown/gladiator
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
	new /obj/structure/handcart/ea_hasir(src)

/datum/migrant_role/ea_hasir/guard
	name = "EA Hasir-ian Guard"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	advclass_cat_rolls = list(CTAG_EA_GUARD = 20)
	greet_text = "The esteemed EA Hasir owns your gold company, Promising only the finest quality gold in grimoria\
	 You've been sent to guard his caravans and earn a tidy profit as you do."

/datum/advclass/guard
	name = "EA Hasir-ian Guard"
	tutorial = "You're a caravan guard, used to dealing with your average thief and the occasional bandit raid.\
	EA-Hasir is a reliable employer, and you're guarding a rather high value merchant\
	Keep them alive, and you may get paid enough to take a much needed break."
	outfit = /datum/outfit/job/roguetown/ea_guard
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_OUTLANDER)
	category_tags = list(CTAG_EA_GUARD)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 2,
	)

/datum/outfit/job/roguetown/ea_guard/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/wood
	belt = /obj/item/storage/belt/rogue/leather
	r_hand = /obj/item/rogueweapon/sword/falchion
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots

/obj/structure/handcart/ea_hasir
	upgrade_level = 2
	maximum_capacity = 120
	// Random loot pool
	var/list/possible_loot = list(
	/obj/item/clothing/neck/roguetown/ornateamulet,
	/obj/item/kitchen/fork/gold,
	/obj/item/kitchen/spoon/gold,
	/obj/item/reagent_containers/glass/bowl/gold,
	/obj/item/cooking/platter/gold,
	/obj/item/reagent_containers/glass/cup/golden,
	/obj/item/reagent_containers/glass/cup/golden/small,
	/obj/item/clothing/mask/rogue/spectacles/golden,
	/obj/item/clothing/mask/rogue/lordmask,
	/obj/item/clothing/mask/rogue/facemask/goldmask,
	/obj/item/roguestatue/gold,
	/obj/item/bodypart/l_arm/prosthetic/gold,
	/obj/item/bodypart/r_arm/prosthetic/gold,
	/obj/item/bodypart/l_leg/prosthetic/gold,
	/obj/item/bodypart/r_leg/prosthetic/gold,
	/obj/item/clothing/ring/gold,
	/obj/item/clothing/ring/signet,
	/obj/item/clothing/ring/diamond,
	/obj/item/clothing/ring/sapphire,
	/obj/item/clothing/ring/quartz,
	/obj/item/clothing/ring/topaz,
	/obj/item/clothing/ring/ruby,
	/obj/item/clothing/ring/emerald,
	/obj/item/clothing/ring/dragon_ring,
	/obj/item/ingot/gold,
	/obj/item/ingot/purifiedaalloy/eahasir)

	// Guaranteed loot pool
	var/list/guaranteed_loot = list(
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/purifiedaalloy/eahasir,
		/obj/item/ingot/gold,
		/obj/item/ingot/gold,
		/obj/item/ingot/gold,
		/obj/item/ingot/gold,
		/obj/item/ingot/gold)

	var/min_loot = 8
	var/max_loot = 12

/obj/structure/handcart/ea_hasir/proc/spawn_random_loot()
	for(var/typepath in guaranteed_loot)
		var/obj/item/I = new typepath(src)
		if(isitem(I))
			if((current_capacity + I.w_class) <= maximum_capacity)
				stuff_shit += I
				current_capacity += I.w_class
			else
				qdel(I)
				break

	var/loot_count = rand(min_loot, max_loot)
	for(var/i in 1 to loot_count)
		if(current_capacity >= maximum_capacity)
			break

		var/type_to_spawn = pick(possible_loot)
		var/obj/item/I = new type_to_spawn(src)

		if(!isitem(I))
			continue

		// weight check (uses same logic as put_in)
		if((current_capacity + I.w_class) > maximum_capacity)
			qdel(I)
			break

		stuff_shit += I
		current_capacity += I.w_class

	update_icon()

/obj/structure/handcart/ea_hasir/proc/spawn_guaranteed_loot()

/obj/structure/handcart/ea_hasir/Initialize(mapload)
	. = ..()
	if(mapload)
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)

	// fill with guaranteed loot
	addtimer(CALLBACK(src, PROC_REF(spawn_guaranteed_loot)), 1)
	// fill with random gold loot
	addtimer(CALLBACK(src, PROC_REF(spawn_random_loot)), 1)

	update_icon()

#undef CTAG_EA_MERCHANT
#undef CTAG_EA_GUARD