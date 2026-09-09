#define CTAG_SLAVER_MASTER "slaver_master"
#define CTAG_SLAVER_MERC "slaver_mercenary"
#define CTAG_SLAVER_SLAVE "slaver_slave"

/datum/migrant_role/slaver/master
	name = "Zybantynian Master"
	greet_text = "The leader of the Zybantynian slave troop. You have came to the mainlands from the western deserts of Zybantine in the hopes of gathering wealth \
	through the training of and trade of unfortunate laborers. The practice can be called despicable by some, but it is without a doubt efficient in filling your pockets before you return to the deserts of the Zybantines"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	advclass_cat_rolls = list(CTAG_SLAVER_MASTER = 20)

/datum/migrant_role/slaver/slavemerc
	name = "Zybantynian Mercenary"
	greet_text = "A hired arm for the Zybantine Slave troop. You have come from the deserts of Zybantine and are hired under contract by the Zybantynian Master."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = TRUE
	advclass_cat_rolls = list(CTAG_SLAVER_MERC = 20)

/datum/migrant_role/slaver/slavez
	name = "Slave"
	greet_text = "An unlucky slave, captured from their home, moved to the Zybantines and trained for slave labor and obediency, for long enough to where you can only faintly remember who you were before... You are now being transported from the deserts to harsher lands to be sold."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	advclass_cat_rolls = list(CTAG_SLAVER_SLAVE = 20)
