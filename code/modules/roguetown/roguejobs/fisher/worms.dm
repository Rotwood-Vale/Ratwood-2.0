/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/baitresilience = 0 // Current bait durability.
	var/bait_max_durability = 0 // Maximum bait durability.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/list/fishingMods = null

/obj/item/proc/sync_bait_durability()
	if(!isbait)
		return FALSE
	if(!bait_max_durability)
		bait_max_durability = max(1, baitresilience)
	baitresilience = clamp(baitresilience, 0, bait_max_durability)
	max_integrity = bait_max_durability
	obj_integrity = baitresilience
	if(istype(src, /obj/item/fishing))
		var/obj/item/fishing/fishing_item = src
		fishing_item.max_durability = bait_max_durability
		fishing_item.durability = baitresilience
	return TRUE

/obj/item/proc/get_bait_durability_percent()
	if(!isbait)
		return 0
	sync_bait_durability()
	if(bait_max_durability <= 0)
		return 0
	return round((baitresilience / bait_max_durability) * 100)

/obj/item/natural/worms
	name = "worm"
	desc = "The favorite bait of the courageous fishermen who venture these dark waters."
	possible_item_intents = list(/datum/intent/use, /datum/intent/food)
	icon_state = "worm1"
	throwforce = 0
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	baitresilience = 50
	bait_max_durability = 50
	
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'

/obj/item/natural/worms/proc/eat_gross_bait(mob/living/carbon/human/user)
	if(!user)
		return FALSE
	user.visible_message(span_warning("[user] reluctantly swallows [src]."), span_warning("I force [src] down."))
	playsound(user.loc, 'sound/misc/eat.ogg', rand(30,60), TRUE)
	user.adjust_nutrition(1)
	user.adjust_disgust(25)
	if(!HAS_TRAIT(user, TRAIT_NOMOOD))
		user.add_stress(/datum/stressevent/rotfood)
	if(!HAS_TRAIT(user, TRAIT_NASTY_EATER) && !HAS_TRAIT(user, TRAIT_WILD_EATER))
		user.add_nausea(12)
	qdel(src)
	return TRUE

/obj/item/natural/worms/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	return eat_gross_bait(H)

/obj/item/natural/worms/attack(mob/living/M, mob/living/user)
	if(user?.used_intent?.type == /datum/intent/food && M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		return eat_gross_bait(H)
	return ..()

/obj/item/natural/worms/grubs
	name = "grub"
	desc = "Bait for the desperate, or the daring."
	baitpenalty = 5
	isbait = TRUE
	color = null
	baitresilience = 50
	bait_max_durability = 50

/obj/item/natural/bundle/worms/grubs
	name = "grubs"
	desc = "Multiple wriggly grubs."
	stacktype = /obj/item/natural/worms/grubs
	stackname = "grubs"
	color = "#E8E2D1"

/obj/item/natural/worms/grub_silk
	name = "silk grub"
	desc = "A pale bog grub swollen with silk. I could squeeze it for a strand."
	icon_state = "worm1"
	color = "#FFFFFF"  // White color like grub worm type

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
	color = "#F5F2EA"

// Cooked silk grub - result of cooking raw silk grubs
/obj/item/reagent_containers/food/snacks/cooked_silkworm
	name = "cooked silk grub"
	desc = "A cooked silk grub. I could squeeze this for silk, or eat it."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "silkgrubcooked"
	verb_say = "chirps"
	verb_yell = "chirps"
	w_class = WEIGHT_CLASS_TINY
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	faretype = FARE_IMPOVERISHED
	sellprice = 5
	slice_path = null

/obj/item/reagent_containers/food/snacks/cooked_silkworm/attack_self(mob/user)
	if(!user)
		return
	user.visible_message(span_notice("[user] starts extracting silk from [src]..."), span_notice("I start extracting silk from [src]..."))
	if(!do_after(user, 3 SECONDS, target = src))
		to_chat(user, span_warning("I stopped extracting silk."))
		return
	var/obj/item/natural/silk/S = new(get_turf(user))
	user.put_in_hands(S)
	to_chat(user, span_notice("I squeeze [src], drawing out a strand of silk."))
	qdel(src)
	return TRUE

/obj/item/natural/worms/grubs/attack_right(mob/user)
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/grubcount = 0
		for(var/obj/item/natural/worms/grubs/F in get_turf(src))
			grubcount++
		while(grubcount > 0)
			if(grubcount == 1)
				new /obj/item/natural/worms/grubs(user.drop_location())
				grubcount--
			else
				var/obj/item/natural/bundle/worms/grubs/B = new(user.drop_location())
				B.amount = clamp(grubcount, 2, B.maxamount)
				B.update_bundle()
				grubcount -= clamp(grubcount, 2, B.maxamount)
				user.put_in_hands(B)
		for(var/obj/item/natural/worms/grubs/F in get_turf(src))
			qdel(F)

/obj/item/natural/worms/Initialize(mapload)
	. = ..()
	fishingMods = list(
		"commonFishingMod" = 1.15,
		"rareFishingMod" = 0.70,
		"treasureFishingMod" = 0.70,
		"trashFishingMod" = 0.9,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0
	)
	dir = rand(0,8)

/obj/item/natural/worms/grubs/Initialize(mapload)
	. = ..()
	fishingMods = list(
		"commonFishingMod" = 1.25,
		"rareFishingMod" = 0.60,
		"treasureFishingMod" = 0.60,
		"trashFishingMod" = 1.1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0
	)
