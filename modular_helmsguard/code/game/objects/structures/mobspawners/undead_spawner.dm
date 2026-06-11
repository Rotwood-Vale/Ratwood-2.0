
///SPAWNER///


/obj/effect/mobspawner/undead_all
	name = "骷髅刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	min_mobs = 2
	max_mobs = 3
	restart_time = 10 MINUTES
	mob_types = list(
	/mob/living/carbon/human/species/skeleton/npc = 1,
	/mob/living/simple_animal/hostile/rogue/skeleton/bow = 3,
	/mob/living/carbon/human/species/skeleton/dwarf/npc = 1,
	/mob/living/carbon/human/species/skeleton/npc/dungeon = 1,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/xbow = 2,
	/mob/living/carbon/human/species/skeleton/dwarf/npc/dungeon = 1,
	/mob/living/simple_animal/hostile/rogue/skeleton/axe = 5,
	/mob/living/simple_animal/hostile/rogue/skeleton/bow = 4,
	/mob/living/simple_animal/hostile/rogue/skeleton/spear = 6,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard = 5,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/spear = 5,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/shield = 4,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/crypt_guard = 2,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/crypt_guard_spear = 2,
	/mob/living/simple_animal/hostile/rogue/gravelord = 1,
	/mob/living/simple_animal/hostile/rogue/ghost/wraith = 3,
	/mob/living/simple_animal/hostile/rogue/ghost/cursed = 3)

	text_faction = "骷髅"
	objfaction = list("undead")

/obj/effect/mobspawner/skeleton_spawner_hard
	name = "骷髅刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	min_mobs = 2
	max_mobs = 3
	restart_time = 10 MINUTES
	mob_types = list(
	/mob/living/carbon/human/species/skeleton/npc = 6,
	/mob/living/simple_animal/hostile/rogue/skeleton/bow = 4,
	/mob/living/carbon/human/species/skeleton/dwarf/npc = 4,
	/mob/living/carbon/human/species/skeleton/npc/dungeon = 3,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/xbow = 3,
	/mob/living/carbon/human/species/skeleton/dwarf/npc/dungeon = 2)
	text_faction = "骷髅"
	objfaction = list("undead")

/obj/effect/mobspawner/skeleton_spawner_simple
	name = "骷髅刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	restart_time = 10 MINUTES
	min_mobs = 5
	max_mobs = 8
	mob_types = list(
	/mob/living/simple_animal/hostile/rogue/skeleton/axe = 6,
	/mob/living/simple_animal/hostile/rogue/skeleton/spear = 6,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard = 5,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/spear = 5,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/shield = 4,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/xbow = 3,
	/mob/living/simple_animal/hostile/rogue/skeleton/bow = 4,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/crypt_guard = 2,
	/mob/living/simple_animal/hostile/rogue/skeleton/guard/crypt_guard_spear = 2,
	/mob/living/simple_animal/hostile/rogue/gravelord = 1
	)
	text_faction = "骷髅"
	objfaction = list("undead")


/obj/effect/mobspawner/ghosts_all
	name = "怨灵刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	restart_time = 10 MINUTES
	min_mobs = 2
	max_mobs = 3
	mob_types = list(
	/mob/living/simple_animal/hostile/rogue/ghost/wraith = 1,
	/mob/living/simple_animal/hostile/rogue/ghost/cursed = 1
		)
	text_faction = "怨灵"
	objfaction = list("undead")


/obj/effect/mobspawner/ghosts_wraiths
	name = "怨灵刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	restart_time = 10 MINUTES
	min_mobs = 1
	max_mobs = 2
	mob_types = list(
	/mob/living/simple_animal/hostile/rogue/ghost/wraith = 1
		)
	text_faction = "怨灵"
	objfaction = list("undead")

/obj/effect/mobspawner/ghosts_cursedsouls
	name = "诅咒灵魂刷怪点"
	desc = ""
	anchored = TRUE
	density = FALSE
	restart_time = 10 MINUTES
	min_mobs = 2
	max_mobs = 3
	mob_types = list(
	/mob/living/simple_animal/hostile/rogue/ghost/cursed = 1
		)
	text_faction = "诅咒灵魂"	
	objfaction = list("undead")
