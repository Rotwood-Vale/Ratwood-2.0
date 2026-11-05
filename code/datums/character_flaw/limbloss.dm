
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

// Harpy talons and taur bodies don't take a peg leg.
/datum/charflaw/limbloss/fits_preferences(datum/preferences/prefs)
	if(!(lost_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)))
		return TRUE
	if(istype(prefs.pref_species, /datum/species/harpy) || prefs.taur_type)
		return FALSE
	return TRUE

/datum/charflaw/limbloss/arm_r
	name = "Wood Arm (R)"
	desc = "I lost my right arm long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile and can't grip weapons.<br><i>(Incompatible with the Bronze Arm (R) quirk and Bronze Golem virtue)</i>"
	lost_zone = BODY_ZONE_R_ARM
	point_value = 2

/datum/charflaw/limbloss/arm_r/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/r_arm/prosthetic/woodright/fitted/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/arm_l
	name = "Wood Arm (L)"
	desc = "I lost my left arm long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile and can't grip weapons.<br><i>(Incompatible with the Bronze Arm (L) quirk and Bronze Golem virtue)</i>"
	lost_zone = BODY_ZONE_L_ARM
	point_value = 2

/datum/charflaw/limbloss/arm_l/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_arm/prosthetic/woodleft/fitted/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/leg_r
	name = "Wood Leg (R)"
	desc = "I lost my right leg long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile.<br><i>(Incompatible with the Bronze Leg (R) quirk and Bronze Golem virtue. Not available to harpies or taurs)</i>"
	lost_zone = BODY_ZONE_R_LEG
	point_value = 2

/datum/charflaw/limbloss/leg_r/on_mob_creation(mob/user)
	if(isharpy(user)) // Harpy talons don't take a peg leg.
		return
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/r_leg/prosthetic/fitted/L = new()
	L.attach_limb(H)

/datum/charflaw/limbloss/leg_l
	name = "Wood Leg (L)"
	desc = "I lost my left leg long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile.<br><i>(Incompatible with the Bronze Leg (L) quirk and Bronze Golem virtue. Not available to harpies or taurs)</i>"
	lost_zone = BODY_ZONE_L_LEG
	point_value = 2

/datum/charflaw/limbloss/leg_l/on_mob_creation(mob/user)
	if(isharpy(user)) // Harpy talons don't take a peg leg.
		return
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/l_leg/prosthetic/fitted/L = new()
	L.attach_limb(H)
