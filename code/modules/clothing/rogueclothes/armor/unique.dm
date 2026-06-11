/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	slot_flags = ITEM_SLOT_ARMOR
	name = "咒歌者长袍"
	desc = "法剑士所穿的加固长袍，内有皮革衬垫。"
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_SPELLSINGER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	armor_class = ARMOR_CLASS_LIGHT
	icon_state = "spellcasterrobe"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/basiceast
	name = "简式道袍"
	desc = "带白色翻领的脏旧道袍。可由裁缝升级，以提高耐久与防护。"
	icon_state = "eastsuit3"
	item_state = "eastsuit3"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_SPELLSINGER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = TRUE
	nodismemsleeves = TRUE
	sellprice = 20
	armor_class = ARMOR_CLASS_LIGHT
	allowed_race = NON_DWARVEN_RACE_TYPES
	flags_inv = HIDEBOOB|HIDECROTCH

//less integrity than a leather cuirass, incredibly weak to blunt damage - great against slash - standard leather value against stab
//the intent for these armors is to create specific weaknesses/strengths for people to play with

/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast
	name = "饰纹道袍"
	desc = "缀有红穗的道袍，并缝入了皮革嵌片。看起来比简式长袍更结实。"
	icon_state = "eastsuit2"
	item_state = "eastsuit2"
	armor = ARMOR_LEATHER_STUDDED // Makes it the equivalence of studded with less integrity and better armor 
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

//craftable variation of eastsuit, essentially requiring the presence of a tailor with relevant materials
//still weak against blunt

/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
	name = "旧道袍"
	desc = "你身上的伤疤，曾经都是力量与勇武的故事。"
	icon_state = "eastsuit1"
	item_state = "eastsuit1"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER_STUDDED 
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM


/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe
	name = "异域长袍"
	desc = "花纹风格的长袍，据说被灌注了魔法防护。商会说这来自南方的卡曾贡地区。"
	icon_state = "eastsuit4"
	item_state = "eastsuit4"
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25 // Head Honcho gets a buff
	sellprice = 25

// this robe spawns on a role that offers no leg protection nor further upgrades to the loadout, in exchange for better roundstart gear

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	name = "染纹精灵板甲"
	desc = "由最古老的精灵德鲁伊以歌与工具共同编织。它仍在吱呀作响，仿佛为逝去时代而悲泣。看起来只有精灵才能穿得上。"
	allowed_race = list(/datum/species/elf/wood, /datum/species/human/halfelf, /datum/species/elf/dark, /datum/species/elf)
	armor = list("blunt" = 100, "slash" = 20, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PICK, BCLASS_SMASH)
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfchest"
	item_state = "welfchest"
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	smelt_bar_num = 4
	blocksound = SOFTHIT
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_WOOD_ARMOR)


/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini/horsey
	name = "束带胸衣"
	desc = "贴身的皮质胸衣，并经过强化以提供防护。"
	icon_state = "hcorset"
	item_state = "hcorset"
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	boobed = TRUE
	flags_inv = 0

//Gronn
/obj/item/clothing/suit/roguetown/armor/kurche
	slot_flags = ITEM_SLOT_ARMOR
	name = "库尔切"
	desc = "由铁片与皮革拼接而成，用来保护要害。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "kurche"
	armor = ARMOR_CUIRASS	//Essentially really good stab/slash prot, some prot against projectiles too
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_STAB)
	blocksound = CHAINHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	max_integrity = 325	//Oh Lord 25 More Integrity Egads !
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	armor_class = ARMOR_CLASS_MEDIUM	//a bit heavier therefore!

/obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
	name = "胡斯库亚克"
	desc = "由皮片制成的护甲。"
	icon_state = "huus"
	item_state = "huus"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT,BCLASS_BLUNT)
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	armor_class = ARMOR_CLASS_LIGHT
