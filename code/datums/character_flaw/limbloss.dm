
/datum/charflaw/limbloss
	var/lost_zone

/datum/charflaw/limbloss/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/O = H.get_bodypart(lost_zone)
	if(O)
		O.drop_limb()
		qdel(O)
	return

/datum/charflaw/limbloss/arm_r
	name = "木臂 (右)"
	desc = "很久以前，我就失去了右臂，不过木制手臂不会流那么多血……但它会着火。<br><i>（与 Bronze Arm (R) 美德不兼容）</i>"
	lost_zone = BODY_ZONE_R_ARM

/datum/charflaw/limbloss/arm_r/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/r_arm/prosthetic/woodright/L = new()
	L.attach_limb(H)
	H.adjust_triumphs(1)

/datum/charflaw/limbloss/arm_l
	name = "木臂 (左)"
	desc = "很久以前，我就失去了左臂，不过木制手臂不会流那么多血……但它会着火。<br><i>（与 Bronze Arm (L) 美德不兼容）</i>"
	lost_zone = BODY_ZONE_L_ARM

/datum/charflaw/limbloss/arm_l/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_arm/prosthetic/woodleft/L = new()
	L.attach_limb(H)
	H.adjust_triumphs(1)
