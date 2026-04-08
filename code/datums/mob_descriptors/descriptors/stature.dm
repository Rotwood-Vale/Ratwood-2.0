/datum/mob_descriptor/stature
	abstract_type = /datum/mob_descriptor/stature
	slot = MOB_DESCRIPTOR_SLOT_STATURE
	show_obscured = TRUE

/datum/mob_descriptor/stature/man
	name = "Man/Woman"

/datum/mob_descriptor/stature/man/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "woman"
		if(SHE_HER_M)
			return "woman"
		if(HE_HIM)
			return "man"
		if(HE_HIM_F)
			return "man"
		if(THEY_THEM)
			return "person"
		if(THEY_THEM_F)
			return "person"
		else
			return "creacher"

/datum/mob_descriptor/stature/gentleman
	name = "Gentleman/Gentlewoman"

/datum/mob_descriptor/stature/gentleman/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "gentlewoman"
		if(SHE_HER_M)
			return "gentlewoman"
		if(HE_HIM)
			return "gentleman"
		if(HE_HIM_F)
			return "gentleman"
		if(THEY_THEM)
			return "gentleperson"
		if(THEY_THEM_F)
			return "gentleperson"
		else
			return "gentlecreacher"

/datum/mob_descriptor/stature/patriarch
	name = "Patriarch/Matriarch"

/datum/mob_descriptor/stature/patriarch/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "matriarch"
		if(HE_HIM)
			return "patriarch"
		if(THEY_THEM)
			return "hierarch"
		if(THEY_THEM_F)
			return "hierarch"
		else
			return "hierarch"

/datum/mob_descriptor/stature/hag
	name = "Hag/Codger"

/datum/mob_descriptor/stature/hag/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "hag"
		if(HE_HIM)
			return "codger"
		if(THEY_THEM)
			return "senior"
		if(THEY_THEM_F)
			return "senior"
		else
			return "elder"

/datum/mob_descriptor/stature/villain
	name = "Villain/Villainess"

/datum/mob_descriptor/stature/villain/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "villainess"
		if(HE_HIM)
			return "villain"
		if(THEY_THEM)
			return "antagonist"
		if(THEY_THEM_F)
			return "antagonist"
		else
			return "antagonist"

/datum/mob_descriptor/stature/thug
	name = "Thug"

/datum/mob_descriptor/stature/knave
	name = "Knave"

/datum/mob_descriptor/stature/wench
	name = "Wench"

/datum/mob_descriptor/stature/snob
	name = "Snob"

/datum/mob_descriptor/stature/slob
	name = "Slob"

/datum/mob_descriptor/stature/brute
	name = "Brute"

/datum/mob_descriptor/stature/highbrow
	name = "Highbrow"

/datum/mob_descriptor/stature/scholar
	name = "Scholar"

/datum/mob_descriptor/stature/rogue
	name = "Rogue"

/datum/mob_descriptor/stature/hermit
	name = "Hermit"

/datum/mob_descriptor/stature/pushover
	name = "Pushover"

/datum/mob_descriptor/stature/beguiler
	name = "Beguiler"

/datum/mob_descriptor/stature/daredevil
	name = "Daredevil"

/datum/mob_descriptor/stature/valiant
	name = "Valiant"

/datum/mob_descriptor/stature/adventurer
	name = "Adventurer"

/datum/mob_descriptor/stature/fiend
	name = "Fiend"

/datum/mob_descriptor/stature/stoic
	name = "Stoic"

/datum/mob_descriptor/stature/stooge
	name = "Stooge"

/datum/mob_descriptor/stature/fool
	name = "Fool"

/datum/mob_descriptor/stature/bookworm
	name = "Bookworm"

/datum/mob_descriptor/stature/lowlife
	name = "Lowlife"

/datum/mob_descriptor/stature/dignitary
	name = "Dignitary"

/datum/mob_descriptor/stature/degenerate
	name = "Degenerate"

/datum/mob_descriptor/stature/zealot
	name = "Zealot"

/datum/mob_descriptor/stature/churl
	name = "Churl"

/datum/mob_descriptor/stature/archon
	name = "Archon"

/datum/mob_descriptor/stature/vizier
	name = "Vizier"

/datum/mob_descriptor/stature/blaggard
	name = "Blaggard"

/datum/mob_descriptor/stature/creep
	name = "Creep"

/datum/mob_descriptor/stature/freek
	name = "Freek"

/datum/mob_descriptor/stature/weerdoe
	name = "Weerdoe"

/datum/mob_descriptor/stature/plump
	name = "Plump Figure"

/datum/mob_descriptor/stature/savant
	name = "Savant"

/datum/mob_descriptor/stature/pilgrim
	name = "Pilgrim"

/datum/mob_descriptor/stature/penitent
	name = "Penitent"

/datum/mob_descriptor/stature/gallant
	name = "Gallant"

/datum/mob_descriptor/stature/firebrand
	name = "Firebrand"

/datum/mob_descriptor/stature/mourner
	name = "Mourner"

/datum/mob_descriptor/stature/caretaker
	name = "Caretaker"

/datum/mob_descriptor/stature/meddler
	name = "Meddler"

/datum/mob_descriptor/stature/dreamer
	name = "Dreamer"

/datum/mob_descriptor/stature/ascetic
	name = "Ascetic"

/datum/mob_descriptor/stature/sort
	name = "Sort"

/datum/mob_descriptor/stature/sprite
	name = "Sprite"

/datum/mob_descriptor/stature/debutante
	name = "Debutante"

/datum/mob_descriptor/stature/coquette
	name = "Coquette"

/datum/mob_descriptor/stature/songbird
	name = "Songbird"

/datum/mob_descriptor/stature/lad
	name = "Lad/Lass"

/datum/mob_descriptor/stature/lad/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "lass"
		if(SHE_HER_M)
			return "lass"
		if(HE_HIM)
			return "lad"
		if(HE_HIM_F)
			return "lad"
		if(THEY_THEM)
			return "lad"
		if(THEY_THEM_F)
			return "lad"
		else
			return "lad"

/datum/mob_descriptor/stature/beau
	name = "Beau/Belle"

/datum/mob_descriptor/stature/beau/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "belle"
		if(SHE_HER_M)
			return "belle"
		if(HE_HIM)
			return "beau"
		if(HE_HIM_F)
			return "beau"
		if(THEY_THEM)
			return "beauty"
		if(THEY_THEM_F)
			return "beauty"
		else
			return "beauty"

/datum/mob_descriptor/stature/dandy
	name = "Dandy/Damsel"

/datum/mob_descriptor/stature/dandy/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "damsel"
		if(SHE_HER_M)
			return "damsel"
		if(HE_HIM)
			return "dandy"
		if(HE_HIM_F)
			return "dandy"
		if(THEY_THEM)
			return "dandy"
		if(THEY_THEM_F)
			return "dandy"
		else
			return "dandy"

/datum/mob_descriptor/stature/hero
	name = "Hero/Heroine"

/datum/mob_descriptor/stature/hero/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "heroine"
		if(SHE_HER_M)
			return "heroine"
		if(HE_HIM)
			return "hero"
		if(HE_HIM_F)
			return "hero"
		if(THEY_THEM)
			return "hero"
		if(THEY_THEM_F)
			return "hero"
		else
			return "hero"

/datum/mob_descriptor/stature/host
	name = "Host/Hostess"

/datum/mob_descriptor/stature/host/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "hostess"
		if(SHE_HER_M)
			return "hostess"
		if(HE_HIM)
			return "host"
		if(HE_HIM_F)
			return "host"
		if(THEY_THEM)
			return "host"
		if(THEY_THEM_F)
			return "host"
		else
			return "host"

/datum/mob_descriptor/stature/widower
	name = "Widower/Widow"

/datum/mob_descriptor/stature/widower/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "widow"
		if(SHE_HER_M)
			return "widow"
		if(HE_HIM)
			return "widower"
		if(HE_HIM_F)
			return "widower"
		if(THEY_THEM)
			return "widow"
		if(THEY_THEM_F)
			return "widow"
		else
			return "widow"

/datum/mob_descriptor/stature/hunter
	name = "Hunter/Huntress"

/datum/mob_descriptor/stature/hunter/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "huntress"
		if(SHE_HER_M)
			return "huntress"
		if(HE_HIM)
			return "huntsman"
		if(HE_HIM_F)
			return "huntsman"
		if(THEY_THEM)
			return "hunter"
		if(THEY_THEM_F)
			return "hunter"
		else
			return "hunter"

/datum/mob_descriptor/stature/bear
	name = "Bear"

/datum/mob_descriptor/stature/ruffian
	name = "Ruffian/Broad"

/datum/mob_descriptor/stature/ruffian/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "broad"
		if(SHE_HER_M)
			return "broad"
		if(HE_HIM)
			return "ruffian"
		if(HE_HIM_F)
			return "ruffian"
		if(THEY_THEM)
			return "ruffian"
		if(THEY_THEM_F)
			return "ruffian"
		else
			return "ruffian"

/datum/mob_descriptor/stature/wanderer
	name = "Wanderer"

/datum/mob_descriptor/stature/hustler
	name = "Hustler"

/datum/mob_descriptor/stature/samaritan
	name = "Samaritan"

/datum/mob_descriptor/stature/pupil
	name = "Pupil"

/datum/mob_descriptor/stature/soldier
	name = "Soldier"

/datum/mob_descriptor/stature/recluse
	name = "Recluse"

/datum/mob_descriptor/stature/socialite
	name = "Socialite"
