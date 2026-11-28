/datum/charflaw/limbloss
	var/lost_zone
	/// The fitted prosthetic that replaces the lost limb.
	var/obj/item/bodypart/prosthetic_type

/datum/charflaw/limbloss/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	// Checked on the mob too, as a randomly rolled vice never went through the picker.
	if(!H.can_fit_prosthetics(lost_leg()))
		return
	var/obj/item/bodypart/O = H.get_bodypart(lost_zone)
	if(O)
		O.drop_limb()
		qdel(O)
	var/obj/item/bodypart/prosthetic = new prosthetic_type()
	prosthetic.attach_limb(H)

/datum/charflaw/limbloss/fits_preferences(datum/preferences/prefs)
	return prefs.can_fit_prosthetics(lost_leg())

/datum/charflaw/limbloss/proc/lost_leg()
	return lost_zone == BODY_ZONE_L_LEG || lost_zone == BODY_ZONE_R_LEG

/datum/charflaw/limbloss/arm_r
	name = "Wood Arm (R)"
	desc = "I lost my right arm long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile and can't grip weapons.<br><i>(Incompatible with the Bronze Arm (R) quirk and Bronze Golem virtue. Not available to constructs, dolls or oozes)</i>"
	lost_zone = BODY_ZONE_R_ARM
	prosthetic_type = /obj/item/bodypart/r_arm/prosthetic/woodright/fitted
	point_value = 2

/datum/charflaw/limbloss/arm_l
	name = "Wood Arm (L)"
	desc = "I lost my left arm long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile and can't grip weapons.<br><i>(Incompatible with the Bronze Arm (L) quirk and Bronze Golem virtue. Not available to constructs, dolls or oozes)</i>"
	lost_zone = BODY_ZONE_L_ARM
	prosthetic_type = /obj/item/bodypart/l_arm/prosthetic/woodleft/fitted
	point_value = 2

/datum/charflaw/limbloss/leg_r
	name = "Wood Leg (R)"
	desc = "I lost my right leg long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile.<br><i>(Incompatible with the Bronze Leg (R) quirk and Bronze Golem virtue. Not available to constructs, dolls, oozes, harpies or taurs)</i>"
	lost_zone = BODY_ZONE_R_LEG
	prosthetic_type = /obj/item/bodypart/r_leg/prosthetic/fitted // The root leg prosthetic is the wooden one.
	point_value = 2

/datum/charflaw/limbloss/leg_l
	name = "Wood Leg (L)"
	desc = "I lost my left leg long ago. The wooden one that replaced it doesn't bleed or feel pain, but it's fragile.<br><i>(Incompatible with the Bronze Leg (L) quirk and Bronze Golem virtue. Not available to constructs, dolls, oozes, harpies or taurs)</i>"
	lost_zone = BODY_ZONE_L_LEG
	prosthetic_type = /obj/item/bodypart/l_leg/prosthetic/fitted // The root leg prosthetic is the wooden one.
	point_value = 2
