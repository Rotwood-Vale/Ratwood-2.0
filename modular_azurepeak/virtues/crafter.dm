// Virtues that let you unlock crafter role
/datum/virtue/utility/blacksmith
	name = "铁匠学徒"
	desc = "年少时，我曾在一位技艺高超的铁匠手下做工，在铁砧前磨练自己的本事。"
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/weaponsmithing, 2, 2),
						list(/datum/skill/craft/armorsmithing, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2)
	)

/datum/virtue/utility/tailor
	name = "裁缝学徒"
	desc = "年少时，我曾在一位手艺娴熟的裁缝门下做活，学习布料与剪裁设计。"
	added_traits = list(TRAIT_SEWING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
	)
	added_stashed_items = list(
		"缝针" = /obj/item/needle,
		"剪刀" = /obj/item/rogueweapon/huntingknife/scissors
	)

/datum/virtue/utility/physician
	name = "医师学徒"
	desc = "年少时，我曾在一位医术高明的医师手下学习，钻研医学与炼金术。"
	added_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	added_stashed_items = list("医药袋" = /obj/item/storage/belt/rogue/pouch/medicine)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/misc/medicine, 2, 2)
	)

/datum/virtue/utility/physician/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


/datum/virtue/utility/hunter
	name = "猎人学徒"
	desc = "年少时，我曾跟随一位老练猎人受训，学会了如何剖解猎物并处理皮革与兽皮。"
	added_traits = list(TRAIT_SURVIVAL_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
						list(/datum/skill/misc/tracking, 2, 2)
	)

/datum/virtue/utility/artificer
	name = "工匠学徒"
	desc = "年少时，我曾在一位巧匠门下做工，学习营造与机关技艺。"
	added_traits = list(TRAIT_SMITHING_EXPERT)
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/craft/masonry, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/craft/ceramics, 2, 2)
	)
	added_stashed_items = list(
		"锤子" = /obj/item/rogueweapon/hammer/wood,
		"凿子" = /obj/item/rogueweapon/chisel,
		"手锯" = /obj/item/rogueweapon/handsaw,
		"吹管" = /obj/item/rogueweapon/blowrod
	)

/datum/virtue/utility/mining
	name = "矿工学徒"
	added_traits = list(TRAIT_SMITHING_EXPERT) // Not sure whether smithing or homestead but given mining goods goes into smithing this fits better?
	desc = "漆黑矿井、潮湿的腥气与漫长劳作时光对我来说都不陌生。我总把镐子和提灯带在身边，也学会了如何更高效地采矿。"
	added_stashed_items = list(
		"钢镐" = /obj/item/rogueweapon/pick/steel,
		"提灯" = /obj/item/flashlight/flare/torch/lantern,
		"矿石袋" = /obj/item/storage/hip/orestore/bronze,
	)
	added_skills = list(list(/datum/skill/labor/mining, 3, 6))
