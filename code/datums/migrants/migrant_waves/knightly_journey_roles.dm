#define CTAG_KJ_KNIGHT "CTAG_KJ_KNIGHT"
#define CTAG_KJ_SQUIRE "CTAG_KJ_SQUIRE"
#define CTAG_KJ_CHAPLAIN "CTAG_KJ_CHAPLAIN"
#define CTAG_KJ_FOLLOWER "CTAG_KJ_FOLLOWER"

/datum/migrant_role/kj_knight
	name = "Hardened Knight Errant"
	greet_text = "Tourney fields, sieges and roadside ambushes: you have survived them all. Your squire has seen a few of those with you. Finish their training, and see them earn their spurs."
	advclass_cat_rolls = list(CTAG_KJ_KNIGHT = 20)

/datum/migrant_role/kj_knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/migrant_role/kj_squire
	name = "Hardened Squire"
	greet_text = "You have served your knight for a few yils now. You can hold your own in a fight and keep their armor sound, but the accolade is still ahead of you."
	advclass_cat_rolls = list(CTAG_KJ_SQUIRE = 20)

/datum/migrant_role/kj_chaplain
	name = "Sworn Chaplain"
	greet_text = "You travel with a knight errant to look after their soul, and more often than not their wounds as well."
	advclass_cat_rolls = list(CTAG_KJ_CHAPLAIN = 20)

/datum/migrant_role/kj_follower
	name = "Sworn Follower"
	greet_text = "You serve a knight errant on the road. They handle the fighting, and you handle everything else that keeps them going."
	advclass_cat_rolls = list(CTAG_KJ_FOLLOWER = 20)
	allowed_races = ACCEPTED_RACES
	show_wanderer_examine = FALSE
