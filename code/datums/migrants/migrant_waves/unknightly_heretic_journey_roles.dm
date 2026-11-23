#define CTAG_UKJ_DARK_ITINERANT "CTAG_UKJ_DARK_ITINERANT"
#define CTAG_UKJ_VARLET "CTAG_UKJ_VARLET"
#define CTAG_UKJ_DARK_CHAPLAIN "CTAG_UKJ_DARK_CHAPLAIN"

/datum/migrant_role/ukj_dark_itinerant
	name = "Dark Itinerant"
	role_category = "Adventurer"
	greet_text = "You were denied the lands and titles your blade had earned, so you turned to the Ascendants instead. Yils in their service have taught you to take what you want. Your varlet is still learning."
	antag_datum = /datum/antagonist/ukj_dark_itinerant
	advclass_cat_rolls = list(CTAG_UKJ_DARK_ITINERANT = 20)
	grant_lit_torch = TRUE

/datum/migrant_role/ukj_varlet
	name = "Varlet"
	role_category = "Adventurer"
	greet_text = "You were nobody until a fallen knight took you on, and you didn't ask many questions about where their loyalties lay. Your god's voice is still new to you, but you're learning to listen."
	antag_datum = /datum/antagonist/ukj_dark_itinerant/varlet
	advclass_cat_rolls = list(CTAG_UKJ_VARLET = 20)

/datum/migrant_role/ukj_dark_chaplain
	name = "Wordbearer"
	role_category = "Adventurer"
	greet_text = "You keep your forsworn knight's faith strong, and every town you pass hears about the Ascendants whether it wants to or not."
	antag_datum = /datum/antagonist/ukj_dark_itinerant/dark_chaplain
	advclass_cat_rolls = list(CTAG_UKJ_DARK_CHAPLAIN = 20)
