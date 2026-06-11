//The League, but in space. Or something.
//Whip-javelin saiga-archer maniacs!
/datum/advclass/foreigner/aavnik
	name = "阿夫尼克 流逐者"
	tutorial = "Niktov，是对那种做下太多坏事、既害了公义也害了同胞之人的俚语称呼。\
	你算是某种意义上的匪徒，也许并不出名，也不似别的恶棍那般嗜血凶残。\
	可无论如何，你终究还是被那些你曾视作自己人的族群所放逐。\
	你究竟做了什么，才会让他们把你弃若敝履？你又是在哪一步走岔了路？"
	allowed_races = RACES_ALL_KINDS
	traits_applied = list(TRAIT_STEELHEARTED)
	outfit = /datum/outfit/job/roguetown/adventurer/aavnik
	cmode_music = 'sound/music/combat_league.ogg'
	subclass_languages = list(/datum/language/aavnic)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
	//Universal skills
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)

	extra_context = "该子职业为玩家提供四种配置。\
	选择 Saiga 骑射手之路会获得骑术特质。\
	其余路线则都会提供中甲训练。"

/datum/outfit/job/roguetown/adventurer/aavnik/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	head = /obj/item/clothing/head/roguetown/papakha
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/quiver/javelin/iron
	neck = /obj/item/clothing/neck/roguetown/leather
	backpack_contents = list(
		/obj/item/tent_kit/ger,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath/aavnik,
		/obj/item/rogueweapon/whip/nagaika
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	if(H.mind)
		var/aavnik_purpose = list("赛加骑射手","步战兵","斧兵","长枪兵")
		var/purpose_choice = input(H, "选择你的求生之道。", "你为何离开") as anything in aavnik_purpose
		switch(purpose_choice)
			if("赛加骑射手")
				H.change_stat(STATKEY_SPD, 1)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
				beltl = /obj/item/quiver/arrows
				var/turf/TU = get_turf(H)
				if(TU)
					new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled(TU)
			if("步战兵")
				H.change_stat(STATKEY_STR, 1)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("斧兵")
				H.change_stat(STATKEY_STR, 1)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 3, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/steppesman
				backl = /obj/item/rogueweapon/shield/buckler
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("长枪兵")
				H.change_stat(STATKEY_STR, 1)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				r_hand = /obj/item/rogueweapon/spear/boar/aav
				l_hand = /obj/item/rogueweapon/katar/punchdagger/aav
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/obj/item/rogueweapon/scabbard/sheath/aavnik
	name = "匕首鞘"

/obj/item/rogueweapon/scabbard/sheath/aavnik/Initialize(mapload)
	. = ..()
	if(!sheathed)
		var/obj/item/rogueweapon/huntingknife/D = new(src)
		sheathed = D
		update_icon()
