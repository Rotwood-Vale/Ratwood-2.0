/obj/item/bodypart/proc/prosthetic_attachment(mob/living/carbon/human/H, mob/user)
	if(!ishuman(H))
		return

	if(user.zone_selected != body_zone)
		to_chat(user, span_warning("[src]并不适用于[parse_zone(user.zone_selected)]。"))
		return -1

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(affecting)
		return

	if(user.temporarilyRemoveItemFromInventory(src))
		attach_limb(H)
		user.visible_message(span_notice("[user]将[src]安装到了[H]身上。"))
		return 1

/obj/item/contraption/bronzeprosthetic
	name = "青铜义肢"
	desc = "一件由青铜制成的义肢。在手中使用它，以决定它要作为哪条肢体。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prb_blank"

/obj/item/contraption/ironprosthetic
	name = "铁制义肢"
	desc = "一件由铁制成的义肢。在手中使用它，以决定它要作为哪条肢体。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_blank"
	smeltresult = /obj/item/ingot/iron

/obj/item/contraption/steelprosthetic
	name = "钢制义肢"
	desc = "一件由钢制成的义肢。在手中使用它，以决定它要作为哪条肢体。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_blank"
	smeltresult = /obj/item/ingot/steel

/obj/item/contraption/goldprosthetic
	name = "金制义肢"
	desc = "一件由黄金制成的义肢。在手中使用它，以决定它要作为哪条肢体。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_blank"
	smeltresult = /obj/item/ingot/gold

/obj/item/contraption/bronzeprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "选择部位与肢体") as null|anything in list("左臂", "右臂", "左腿", "右腿", "取消")
	switch(choice)
		if("取消")
			return
		if(null)
			return
		if("左臂")
			new /obj/item/bodypart/l_arm/prosthetic/bronzeleft(get_turf(src.loc))
			qdel(src)
			return
		if("右臂")
			new /obj/item/bodypart/r_arm/prosthetic/bronzeright(get_turf(src.loc))
			qdel(src)
			return
		if("左腿")
			new /obj/item/bodypart/l_leg/prosthetic/bronzeleft(get_turf(src.loc))
			qdel(src)
			return
		if("右腿")
			new /obj/item/bodypart/r_leg/prosthetic/bronzeright(get_turf(src.loc))
			qdel(src)
			return

/obj/item/contraption/ironprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "选择部位与肢体") as null|anything in list("左臂", "右臂", "左腿", "右腿", "取消")
	switch(choice)
		if("取消")
			return
		if(null)
			return
		if("左臂")
			new /obj/item/bodypart/l_arm/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("右臂")
			new /obj/item/bodypart/r_arm/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("左腿")
			new /obj/item/bodypart/l_leg/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("右腿")
			new /obj/item/bodypart/r_leg/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return

/obj/item/contraption/steelprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "选择部位与肢体") as null|anything in list("左臂", "右臂", "左腿", "右腿", "取消")
	switch(choice)
		if("取消")
			return
		if(null)
			return
		if("左臂")
			new /obj/item/bodypart/l_arm/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("右臂")
			new /obj/item/bodypart/r_arm/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("左腿")
			new /obj/item/bodypart/l_leg/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("右腿")
			new /obj/item/bodypart/r_leg/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return

/obj/item/contraption/goldprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "选择部位与肢体") as null|anything in list("左臂", "右臂", "左腿", "右腿", "取消")
	switch(choice)
		if("取消")
			return
		if(null)
			return
		if("左臂")
			new /obj/item/bodypart/l_arm/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("右臂")
			new /obj/item/bodypart/r_arm/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("左腿")
			new /obj/item/bodypart/l_leg/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("右腿")
			new /obj/item/bodypart/r_leg/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return

/////     ARMS     /////

/obj/item/bodypart/l_arm/prosthetic/woodleft
	name = "木制左臂"
	desc = "一条木制左臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_arm"
	item_state = "pr_arm"
	limb_material = "wood"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC	//allows removals
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
	fingers = FALSE //can't swing weapons but can pick stuff up and punch
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_arm/prosthetic/iron
	name = "铁制左臂"
	desc = "一条铁制左臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_arm"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/l_arm/prosthetic/steel
	name = "钢制左臂"
	desc = "一条钢制左臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/l_arm/prosthetic/bronzeleft
	name = "青铜左臂"
	desc = "一条以青铜打造的替代左臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_arm"
	prosthetic_prefix = "prs"
	limb_material = "bronze"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 110
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	sellprice = 30
	fingers = TRUE // it acts like a normal arm
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_arm/prosthetic/gold
	name = "金制左臂"
	desc = "一条由齿轮与黄金构成的左臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	fingers = TRUE
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/l_arm/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/obj/item/bodypart/r_arm/prosthetic/woodright
	name = "木制右臂"
	desc = "一条木制右臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_arm"
	limb_material = "wood"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
	fingers = FALSE //can't swing weapons but can pick stuff up and punch
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_arm/prosthetic/iron
	name = "铁制右臂"
	desc = "一条铁制右臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_arm"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/r_arm/prosthetic/steel
	name = "钢制右臂"
	desc = "一条钢制右臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/r_arm/prosthetic/bronzeright
	name = "青铜右臂"
	desc = "一条以青铜打造的替代右臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_arm"
	prosthetic_prefix = "prs"
	limb_material = "bronze" // still need a different onmob sprite for bronze limbs brah
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	sellprice = 30
	fingers = TRUE // it acts like a normal arm
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_arm/prosthetic/gold
	name = "金制右臂"
	desc = "一条由齿轮与黄金构成的右臂。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	fingers = TRUE
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/r_arm/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/////     LEGS     /////

/obj/item/bodypart/l_leg/prosthetic
	name = "木制左腿"
	desc = "一条木制左腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_leg"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_leg/prosthetic/iron
	name = "铁制左腿"
	desc = "一条铁制左腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_leg"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 1.2
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/l_leg/prosthetic/steel
	name = "钢制左腿"
	desc = "一条钢制左腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 1.1
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/l_leg/prosthetic/bronzeleft
	name = "青铜左腿"
	desc = "一条以青铜打造的替代左腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_leg"
	prosthetic_prefix = "prs"
	limb_material = "bronze"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze

/obj/item/bodypart/l_leg/prosthetic/gold
	name = "金制左腿"
	desc = "一条由齿轮与黄金构成的左腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_leg"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	organ_slowdown = 0
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/l_leg/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/obj/item/bodypart/r_leg/prosthetic
	name = "木制右腿"
	desc = "一条木制右腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_leg"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_leg/prosthetic/iron
	name = "铁制右腿"
	desc = "一条铁制右腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_leg"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 1.2
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/r_leg/prosthetic/steel
	name = "钢制右腿"
	desc = "一条钢制右腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 1.1
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/r_leg/prosthetic/bronzeright
	name = "青铜右腿"
	desc = "一条以青铜打造的替代右腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_leg"
	prosthetic_prefix = "prs"
	limb_material = "bronze"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	sellprice = 30
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze

/obj/item/bodypart/r_leg/prosthetic/gold
	name = "金制右腿"
	desc = "一条由齿轮与黄金构成的右腿。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_leg"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	organ_slowdown = 0
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/r_leg/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)
