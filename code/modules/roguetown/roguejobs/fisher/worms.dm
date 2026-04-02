/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/baitresilience = 0 // How resilient bait is. Decreases by 2 for every catch, decreases by 1 when used by a master or better. Bait cannot be consumed whilst it has resilience left.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/list/fishingMods = null

/obj/item/natural/worms
	name = "worm"
	desc = "The favorite bait of the courageous fishermen who venture these dark waters."
	icon_state = "worm1"
	throwforce = 0
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	baitresilience = 1
	
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/amt = 1

/obj/item/natural/worms/grubs
	name = "grub"
	desc = "Bait for the desperate, or the daring."
	baitpenalty = 5
	isbait = TRUE
	color = null
	baitresilience = 2

/obj/item/natural/worms/grub_silk
	name = "silk grub"
	desc = "A pale bog grub swollen with silk. I could squeeze it for a strand."
	icon_state = "worm1"

/obj/item/natural/worms/grub_silk/attack_self(mob/user)
	if(!user)
		return
	var/obj/item/natural/silk/S = new(get_turf(user))
	user.put_in_hands(S)
	to_chat(user, span_notice("I squeeze [src], drawing out a strand of silk."))
	qdel(src)
	return TRUE

/obj/item/natural/worms/grub_silk/attack_right(mob/user)
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/grubcount = 0
		for(var/obj/item/natural/worms/grub_silk/F in get_turf(src))
			grubcount++
		while(grubcount > 0)
			if(grubcount == 1)
				new /obj/item/natural/worms/grub_silk(user.drop_location())
				grubcount--
			else
				var/obj/item/natural/bundle/worms/silkgrubs/B = new(user.drop_location())
				B.amount = clamp(grubcount, 2, B.maxamount)
				B.update_bundle()
				grubcount -= clamp(grubcount, 2, B.maxamount)
				user.put_in_hands(B)
		for(var/obj/item/natural/worms/grub_silk/F in get_turf(src))
			qdel(F)

/obj/item/natural/bundle/worms/silkgrubs
	name = "silk grubs"
	desc = "Multiple wriggly silk grubs."
	stacktype = /obj/item/natural/worms/grub_silk
	stackname = "silk grubs"

/obj/item/natural/worms/grubs/attack_right(mob/user)
	return

/obj/item/natural/worms/Initialize(mapload)
	. = ..()
	fishingMods = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0
	)
	dir = rand(0,8)

/obj/item/natural/worms/grubs/Initialize(mapload)
	. = ..()
	fishingMods = list(
		"commonFishingMod" = 0.85,
		"rareFishingMod" = 1.15,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0
	)
