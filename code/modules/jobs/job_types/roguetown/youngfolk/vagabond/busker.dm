/datum/advclass/busker
	name = "Busker"
	examine_name = "Beggar"
	tutorial = "You've lost pretty much everything - everything but your instrument and an adequate ability to play it. Maybe a jaunty tune will send a few zennies your way - whether through pitied gratitute, or by distracting long enough for you to swipe a coinpurse."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/busker
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_EMPATH)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 1,
		STATKEY_CON = -2,
		STATKEY_STR = -1,
	)

/datum/outfit/job/roguetown/vagabond/busker/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/raincloak/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(10))
		r_hand = /obj/item/rogue/instrument/flute

	if (H.mind)
		H.adjust_skillrank(/datum/skill/misc/music, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	var/weapons = list("Accordion","Bagpipe", "Banjo","Drum","Flute","Guitar","Harmonica","Harp","Hurdy-Gurdy","Jaw Harp","Lute","Psyaltery","Shamisen","Trumpet","Viola","Vocal Talisman")
	var/weapon_choice = input("Choose your instrument.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Accordion")
			backr = /obj/item/rogue/instrument/accord
		if("Bagpipe")
			backr = /obj/item/rogue/instrument/bagpipe
		if("Banjo")
			backr = /obj/item/rogue/instrument/banjo
		if("Drum")
			backr = /obj/item/rogue/instrument/drum
		if("Flute")
			backr = /obj/item/rogue/instrument/flute
		if("Guitar")
			backr = /obj/item/rogue/instrument/guitar
		if("Harmonica")
			backr = /obj/item/rogue/instrument/harmonica
		if("Harp")
			backr = /obj/item/rogue/instrument/harp
		if("Hurdy-Gurdy")
			backr = /obj/item/rogue/instrument/hurdygurdy
		if("Jaw Harp")
			backr = /obj/item/rogue/instrument/jawharp
		if("Lute")
			backr = /obj/item/rogue/instrument/lute
		if("Psyaltery")
			backr = /obj/item/rogue/instrument/psyaltery
		if("Shamisen")
			backr = /obj/item/rogue/instrument/shamisen
		if("Trumpet")
			backr = /obj/item/rogue/instrument/trumpet
		if("Viola")
			backr = /obj/item/rogue/instrument/viola
		if("Vocal Talisman")
			backr = /obj/item/rogue/instrument/vocals
