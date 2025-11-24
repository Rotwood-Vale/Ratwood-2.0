/obj/item/rogueweapon/sword/long/martyr
	force = 30
	force_wielded = 36
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike,  /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust,  /datum/intent/sword/peel, /datum/intent/sword/chop)
	icon_state = "martyrsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	item_state = "martyrsword"
	lefthand_file = 'icons/mob/inhands/weapons/roguemartyr_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguemartyr_righthand.dmi'
	name = "martyr sword"
	desc = "A relic from the Holy See's own vaults. It simmers with godly energies, and will only yield to the hands of those who have taken the Oath."
	max_blade_int = 200
	max_integrity = 300
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	bigboy = 1
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	associated_skill = /datum/skill/combat/swords
	throwforce = 15
	thrown_bclass = BCLASS_CUT
	dropshrink = 1
	smeltresult = /obj/item/ingot/gold
	is_silver = TRUE
	toggle_state = null
	is_important = TRUE

/obj/item/rogueweapon/sword/long/martyr/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/datum/intent/sword/cut/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CUT
/datum/intent/sword/thrust/martyr
		item_d_type = "fire"
		blade_class = BCLASS_PICK // so our armor-piercing attacks in ult mode can do crits(against most armors, not having crit)
/datum/intent/sword/strike/martyr
		item_d_type = "fire"
		blade_class = BCLASS_SMASH
/datum/intent/sword/chop/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CHOP

/obj/item/rogueweapon/sword/long/martyr/Initialize()
	AddComponent(/datum/component/martyrweapon)
	..()

/obj/item/rogueweapon/sword/long/martyr/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/job/J = SSjob.GetJob(H.mind?.assigned_role)
		if(J.title == "Bishop" || J.title == "Martyr")
			return ..()
		else if (H.job in GLOB.church_positions)
			to_chat(user, span_warning("You feel a jolt of holy energies just for a split second, and then the sword slips from your grasp! You are not devout enough."))
			return FALSE
		else if(istype(H.patron, /datum/patron/inhumen))
			var/datum/component/martyrweapon/marty = GetComponent(/datum/component/martyrweapon)
			to_chat(user, span_warning("YOU FOOL! IT IS ANATHEMA TO YOU! GET AWAY!"))
			H.Stun(40)
			H.Knockdown(40)
			if(marty.is_active) //Inhumens are touching this while it's active, very fucking stupid of them
				visible_message(span_warning("[H] lets out a painful shriek as the sword lashes out at them!"))
				H.emote("agony")
				H.adjust_fire_stacks(5)
				H.ignite_mob()
			return FALSE
		else	//Everyone else
			to_chat(user, span_warning("A painful jolt across your entire body sends you to the ground. You cannot touch this thing."))
			H.emote("groan")
			H.Stun(10)
			return FALSE
	else
		return FALSE

/obj/item/rogueweapon/sword/long/martyr/Destroy()
	var/datum/component/martyr = GetComponent(/datum/component/martyrweapon)
	if(martyr)
		martyr.ClearFromParent()
	return ..()

/obj/item/rogueweapon/sword/long/martyr/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback") return list("shrink" = 0.6,"sx" = -2,"sy" = 3,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 90,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded") return list("shrink" = 0.7,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt") return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 0,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = -3,"ey" = -5,"nturn" = 180,"sturn" = 180,"wturn" = 0,"eturn" = 90,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/cloak/martyr
	name = "martyr cloak"
	desc = "An elegant cloak in the colors of Astrata. Looks like it can only fit Humen-sized people."
	color = null
	icon_state = "martyrcloak"
	item_state = "martyrcloak"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN
	boobed = FALSE
	sellprice = 100
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/armor/plate/full/holysee
	name = "holy silver plate"
	desc = "Silver-clad plate for the guardians and the warriors, for the spears and shields of the Ten."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	icon_state = "silverarmor"
	item_state = "silverarmor"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "silverarmor"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	armor = ARMOR_PLATE
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 4

/obj/item/clothing/under/roguetown/platelegs/holysee
	name = "holy silver chausses"
	desc = "Plate leggings of silver forged for the Holy See's forces. A sea of silver to descend upon evil."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "silverlegs"
	icon_state = "silverlegs"
	item_state = "silverlegs"
	armor = ARMOR_PLATE
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/holysee
	name = "holy silver bascinet"
	desc = "Branded by the Holy See, these helms are worn by it's chosen warriors. A bastion of hope in the dark nite."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyrbascinet.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	worn_x_dimension = 64
	worn_y_dimension = 64
	icon_state = "silverbascinet"
	item_state = "silverbascinet"
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/holysee/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/cloak/holysee
	name = "holy silver vestments"
	desc = "A set of vestments worn by the Holy See's forces, silver embroidery and seals of light ordain it as a bastion against evil."
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	icon_state = "silvertabard"
	item_state = "silvertabard"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "silvertabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/overarmor = TRUE
	sellprice = 300

/obj/item/clothing/cloak/holysee/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/holysee/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/holysee/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear the tabard over my armor" : "wear the tabard under my armor"]."))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()
