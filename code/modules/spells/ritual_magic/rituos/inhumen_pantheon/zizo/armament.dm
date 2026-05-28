/obj/structure/ritualcircle/zizo/proc/zizoarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_CABAL))
		loc.visible_message(span_cult("THE RITE REJECTS ONE NOT OF THE CABAL"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. As their black, rotten lux is torn from their chest, the very essence of their body surges to form it into armor. "))
		target.Paralyze(120)
	else
		loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. Their lux is torn from their chest, and reforms into armor. "))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
		if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
			ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
		spawn(40)
			to_chat(target, span_purple("They are ignorant, backwards, without hope. You. You will be powerful."))

/datum/outfit/job/roguetown/darksteelrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
	backr = /obj/item/rogueweapon/sword/long/zizo
	neck = /obj/item/clothing/neck/roguetown/bevor
	H.mind.AddSpell(new /datum/action/cooldown/spell/mending/lesser)
	var/helmets = list("BARBUTE - VISORED", "FROGMOUTH - NECK PROTECTION")
	var/helmet_choice = input(H, "Choose your helmet.", "PROTECTION FROM THE LADY") as anything in helmets
	switch(helmet_choice)
		if("BARBUTE - VISORED")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		if("FROGMOUTH - NECK PROTECTION")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth/zizo
