/mob/living/simple_animal/hostile/retaliate/blood
	name = "FLESH HOMUNCULUS"
	icon = 'icons/mob/mob.dmi'
	icon_state = "FLESH"
	icon_living = "FLESH"
	vision_range = 6
	aggro_vision_range = 6
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	base_intents = list(/datum/intent/simple/claw)
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	health = 900
	maxHealth = 900
	melee_damage_lower = 40
	melee_damage_upper = 60
	STACON = 15
	STASTR = 16
	STASPD = 2

/mob/living/simple_animal/hostile/retaliate/blood/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/blood/death(gibbed)
	. = ..()
	gib()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/blood/ascended
	name = "???"
	desc = ""
	icon_state = "ascend"
	icon_living = "ascend"
	icon = 'icons/mob/32x64.dmi'
	move_to_delay = 0
	base_intents = list(/datum/intent/simple/claw/ascended)
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	melee_damage_lower = 250
	melee_damage_upper = 550
	health = 666666
	maxHealth = 666666
	STACON = 66
	STASTR = 66
	STASPD = 66
	move_resist = MOVE_FORCE_OVERPOWERING

/mob/living/simple_animal/hostile/retaliate/blood/ascended/Initialize(mapload)
	. = ..()
	set_light(5, 5, 5, l_color = LIGHT_COLOR_RED)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/blood/ascended/examine(mob/user)
	. = ..()
	. += "<span class='danger'>It is impossible to comprehend such a thing.</span>"

/datum/intent/simple/claw/ascended
	name = "smites"
	icon_state = "instrike"
	attack_verb = list("smites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 100
	candodge = TRUE
	canparry = FALSE
	miss_text = "smites the air"
	item_d_type = "slash"
	clickcd = 8
