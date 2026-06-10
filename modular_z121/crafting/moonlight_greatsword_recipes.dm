/datum/crafting_recipe/roguetown/alch/moonlight_greatsword
	name = "月光大剑"
	result = list(/obj/item/rogueweapon/greatsword/moonlight_greatsword)
	reqs = list(
		/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel = 1,
		/obj/item/magic/voidstone = 1,
		/obj/item/riddleofsteel = 1,
	)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = SKILL_LEVEL_MASTER
