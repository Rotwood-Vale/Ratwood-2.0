/obj/structure/ritualcircle/graggar/proc/graggararmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_HORDE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITHOUT SLAUGHTER IN THEIR HEART!!"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("[target]'s rotten lux pours from their nose like viscous tar, sizzling and bubbling around the rune. The solution erupts upwards, searing their skin!"))
		target.adjustFireLoss(200) //This gets spread across all limbs, 500+ is needed before it knocks someone out.
		playsound(src,'sound/misc/lava_death.ogg', rand(30,60), TRUE)
		return
	loc.visible_message(span_cult("[target]'s lux pours from their nose, into the rune, motive and metals swirl into armor, snug around their form!"))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/viciousrite)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
		if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
			ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
		spawn(40)
			to_chat(target, span_cult("Break them."))

/datum/outfit/job/roguetown/viciousrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	cloak = /obj/item/clothing/cloak/graggar
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
