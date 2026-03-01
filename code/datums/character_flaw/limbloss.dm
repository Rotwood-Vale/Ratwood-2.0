
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
	name = "Wood Arm (R)"
	desc = "I lost my right arm and replaced it with a wooden prosthetic. The wooden arm doesn't bleed and is immune to pain, but it's highly flammable and weaker than flesh. Incompatible with Bronze/Prosthetic Arm (R) virtue. +1 TRI"
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
	name = "Wood Arm (L)"
	desc = "I lost my left arm and replaced it with a wooden prosthetic. The wooden arm doesn't bleed and is immune to pain, but it's highly flammable and weaker than flesh. Incompatible with Bronze/Prosthetic Arm (L) virtue. +1 TRI"
	lost_zone = BODY_ZONE_L_ARM

/datum/charflaw/limbloss/arm_l/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_arm/prosthetic/woodleft/L = new()
	L.attach_limb(H)
	H.adjust_triumphs(1)
