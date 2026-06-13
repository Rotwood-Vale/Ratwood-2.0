// modular_z121 自定义冒险者子职业：战争萨满
// 仅在 modular_z121 内实现，避免触碰主职业文件。

/datum/advclass/z121_war_shaman
	name = "战争萨满"
	tutorial = "你成长于遥远游牧边境的部落当中，你精湛于家乡的传统武术，在当地为其他战士祈福。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/z121_war_shaman
	category_tags = list(CTAG_ADVENTURER)
	class_select_category = CLASS_CAT_CLERIC
	subclass_social_rank = SOCIAL_RANK_PEASANT
	cmode_music = 'sound/music/combat_holy.ogg'
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOPAINSTUN,
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_EQUESTRIAN,
	)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "拥有铁心、坚忍、拳斗专家与重创抗性，并会在开局选择一只来自草原的坐骑。"

/datum/advclass/z121_war_shaman/post_equip(mob/living/carbon/human/H)
	..()
	z121_war_shaman_grant_miracles(H)
	z121_war_shaman_choose_mount(H)

/datum/outfit/job/roguetown/adventurer/z121_war_shaman/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("你成长于遥远游牧边境的部落当中，你精湛于家乡的传统武术，在当地为其他战士祈福。"))

	// 按需求固定发放开局装备。
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	backl = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	cloak = /obj/item/clothing/cloak/volfmantle
	gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/storage/belt/rogue/pouch
	belt = /obj/item/storage/belt/rogue/leather/black
	// 将指定道具放入挎包，方便开局整理随身装备。
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/mercenary = 1,
	)

	// 草原兽面具优先给兽人脸型，其他种族则回退到通用狼兽面具，避免贴图错位。
	if(istype(H.dna?.species, /datum/species/anthromorph) || istype(H.dna?.species, /datum/species/anthromorphsmall))
		mask = /obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro
	else
		mask = /obj/item/clothing/mask/rogue/wildguard

/proc/z121_war_shaman_grant_miracles(mob/living/carbon/human/H)
	if(!H?.mind || !H.patron)
		return

	// 给出基础神迹成长，符合“神迹：熟练”的职业定位。
	var/datum/devotion/shaman_devotion = new /datum/devotion(H, H.patron)
	shaman_devotion.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)

/proc/z121_war_shaman_choose_mount(mob/living/carbon/human/H)
	if(!H?.mind)
		return
	if(H.saddleborn_mount?.resolve())
		return

	var/turf/T = get_turf(H)
	if(!T)
		return

	// 只提供草原风格坐骑，保持职业主题一致。
	var/list/mount_choices = list(
		"赛加羚羊" = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled,
		"赛加公羚" = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled,
		"公山羊" = /mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame/saddled,
		"母山羊" = /mob/living/simple_animal/hostile/retaliate/rogue/goat/tame/saddled,
		"野公猪" = /mob/living/simple_animal/hostile/retaliate/rogue/swine/hog/tame/saddled,
	)
	var/chosen_label = input(H, "选择你的开局坐骑。", "战争萨满") as null|anything in mount_choices
	if(!chosen_label)
		// 若玩家一时取消，补发通用选马法术，避免这次机会永久丢失。
		H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
		to_chat(H, span_notice("你暂时没有决定坐骑。稍后可使用“Choose Mount”能力重新选择。"))
		return

	var/chosen_mount_type = mount_choices[chosen_label]
	var/mob/living/simple_animal/selected_mount = new chosen_mount_type(T)
	if(istype(selected_mount, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_mount = selected_mount
		hostile_mount.owner = H

	selected_mount.AddComponent(/datum/component/precious_creature, H)
	H.saddleborn_mount = WEAKREF(selected_mount)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/sendaway)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/whistle)
	to_chat(H, span_notice("你的[chosen_label]已来到身边。你还获得了召回与遣返坐骑的能力。"))
