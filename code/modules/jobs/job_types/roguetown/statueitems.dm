/proc/give_special_items(mob/living/carbon/human/H)
	if(!H.mind)
		return
	switch(H.ckey)
		if("monokrom")
			H.mind.special_items["飞翼帽"] = /obj/item/clothing/head/roguetown/helmet/winged
		if("hilldric")
			H.mind.special_items["头带"] = /obj/item/clothing/head/roguetown/headband
		if("Muaru")
			H.mind.special_items["头带"] = /obj/item/clothing/head/roguetown/headband
		if("Stimusz")
			H.mind.special_items["头带"] = /obj/item/clothing/head/roguetown/headband
		if("Bonapart")
			H.mind.special_items["头带"] = /obj/item/clothing/head/roguetown/headband
