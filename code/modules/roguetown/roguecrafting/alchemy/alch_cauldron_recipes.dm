//vial = 30, bottle = 50
/datum/alch_cauldron_recipe/antidote
	name = "解毒剂"
	smells_like = "潮湿的苔藓"
	output_reagents = list(/datum/reagent/medicine/antidote = 100)

/datum/alch_cauldron_recipe/strong_antidote
	name = "强效解毒剂"
	smells_like = "纯净"
	output_reagents = list(/datum/reagent/medicine/strong_antidote = 100)

/datum/alch_cauldron_recipe/berrypoison
	name = "毒药（浆果）"
	smells_like = "死亡"
	skill_required = SKILL_LEVEL_JOURNEYMAN // Basic poison should be harder to handle
	output_reagents = list(/datum/reagent/berrypoison = 100)

/datum/alch_cauldron_recipe/doompoison
	name = "毒药（毁灭）"
	smells_like = "毁灭"
	skill_required = SKILL_LEVEL_EXPERT // Strong poison should be more difficult to make
	output_reagents = list(/datum/reagent/strongpoison = 100)

/datum/alch_cauldron_recipe/stam_poison
	name = "耐力毒药"
	smells_like = "缓慢的微风"
	skill_required = SKILL_LEVEL_JOURNEYMAN // Basic poison should be harder to handle
	output_reagents = list(/datum/reagent/stampoison = 100)

/datum/alch_cauldron_recipe/big_stam_poison
	name = "强效耐力毒药"
	smells_like = "停滞的空气"
	skill_required = SKILL_LEVEL_EXPERT // Strong poison should be more difficult to make
	output_reagents = list(/datum/reagent/strongstampoison = 100)

//Healing potions
/datum/alch_cauldron_recipe/health_potion
	name = "生命灵药"
	smells_like = "甜浆果"
	output_reagents = list(/datum/reagent/medicine/healthpot = 100)

/datum/alch_cauldron_recipe/big_health_potion
	name = "强效生命灵药"
	smells_like = "浆果派"
	skill_required = SKILL_LEVEL_EXPERT // If it has "Strong", lock it roundstart for Apothecary or above
	output_reagents = list(/datum/reagent/medicine/stronghealth = 50)//it has an extremely easy recipe compared to regular red

/datum/alch_cauldron_recipe/mana_potion
	name = "魔力灵药"
	smells_like = "力量"
	output_reagents = list(/datum/reagent/medicine/manapot = 100)//recipe is harder to make than regular blue

/datum/alch_cauldron_recipe/big_mana_potion
	name = "强效魔力灵药"
	smells_like = "恐惧"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/medicine/strongmana = 100)

/datum/alch_cauldron_recipe/stamina_potion
	name = "耐力灵药"
	smells_like = "清新空气"
	output_reagents = list(/datum/reagent/medicine/stampot = 100)

/datum/alch_cauldron_recipe/big_stamina_potion
	name = "强效耐力灵药"
	smells_like = "洁净的风"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/medicine/strongstam = 100)

//S.P.E.C.I.A.L. potions - Expert or above (roundstart Witch etc.)
/datum/alch_cauldron_recipe/temp_potion
	name = "平衡药剂"
	smells_like = "春日"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/temperature_normalize = 30)

/datum/alch_cauldron_recipe/str_potion
	name = "山岳肌力药剂"
	smells_like = "雨后泥土"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/strength = 30)

/datum/alch_cauldron_recipe/per_potion
	name = "锐眼药水"
	smells_like = "火焰"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/perception = 30)

/datum/alch_cauldron_recipe/end_potion
	name = "坚韧药水"
	smells_like = "山间空气"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/endurance = 30)

/datum/alch_cauldron_recipe/con_potion
	name = "石肤药剂"
	smells_like = "大地"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/constitution = 30)

/datum/alch_cauldron_recipe/int_potion
	name = "锐思药剂"
	smells_like = "水"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/intelligence = 30)

/datum/alch_cauldron_recipe/spd_potion
	name = "疾行药水"
	smells_like = "清新的空气"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/speed = 30)

/datum/alch_cauldron_recipe/lck_potion
	name = "七叶草药剂"
	smells_like = "平静"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/fortune = 30)

/datum/alch_cauldron_recipe/aphrodisiac
	name = "催情酒"
	smells_like = "炽热的甜香"
	output_reagents = list(/datum/reagent/consumable/ethanol/beer/emberwine = 60)

/datum/alch_cauldron_recipe/fire_potion
	name = "抗火药剂"
	smells_like = "威仪"
	skill_required = SKILL_LEVEL_MASTER
	output_reagents =list(/datum/reagent/fire_resist = 30)
