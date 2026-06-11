/obj/item/alch
	name = "粉末"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.75//way easier to organise on tables like this
	/*
		So, you're here about potions: TLDR - the cauldron takes up to 4 items, from this, makes 1 recipe. Major gives 3 points, med 2 points,minor 1 point.
		If no recipe gets above 5 points, it makes nothing,otherwise It then makes the recipe with the HIGHEST POINTS.
		all 3 of the below variables should be NULL or the type-path of the recipe to make.
	*/
	var/major_pot = null
	var/med_pot = null
	var/minor_pot = null
	//Dont worry, these 3 are just to cache the 'smell' of their pot on initialization to not have to re-look every examine.
	//No need to set them.
	var/major_smell
	var/med_smell
	var/minor_smell
	///Same as the smells, just caching what the potion name is
	var/major_name
	var/med_name
	var/minor_name

/obj/item/alch/Initialize(mapload)
	. = ..()
	if(!isnull(major_pot))
		var/datum/alch_cauldron_recipe/rec = locate(major_pot) in GLOB.alch_cauldron_recipes
		major_smell = rec.smells_like
		major_name = rec.name
	if(!isnull(med_pot))
		var/datum/alch_cauldron_recipe/rec = locate(med_pot) in GLOB.alch_cauldron_recipes
		med_smell = rec.smells_like
		med_name = rec.name
	if(!isnull(minor_pot))
		var/datum/alch_cauldron_recipe/rec = locate(minor_pot) in GLOB.alch_cauldron_recipes
		minor_smell = rec.smells_like
		minor_name = rec.name

/obj/item/alch/examine(mob/user)
	. = ..()
	if(user.mind)
		var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
		var/perint = 0
		if(isliving(user))
			var/mob/living/lmob = user
			perint = FLOOR((lmob.STAPER + lmob.STAINT)/2,1)
		if(HAS_TRAIT(user,TRAIT_LEGENDARY_ALCHEMIST))
			if(!isnull(major_name))
				. += span_notice(" 与制作[major_name]的亲和度极高。")
			if(!isnull(med_name))
				. += span_notice(" 与制作[med_name]的亲和度适中。")
			if(!isnull(minor_name))
				. += span_notice(" 与制作[minor_name]有微弱的亲和度。")
		else
			if(!isnull(major_smell))
				if(alch_skill >= SKILL_LEVEL_NOVICE || perint >= 6)
					. += span_notice(" 散发着浓烈的[major_smell]气味。")
			if(!isnull(med_smell))
				if(alch_skill >= SKILL_LEVEL_APPRENTICE || perint >= 10)
					. += span_notice(" 散发着淡淡的[med_smell]气味。")
			if(!isnull(minor_smell))
				if(alch_skill >= SKILL_LEVEL_EXPERT || perint >= 16)
					. += span_notice(" 散发着微弱的[minor_smell]气味。")
/obj/item/alch/viscera
	name = "内脏"
	icon_state = "viscera"
	major_pot = /datum/alch_cauldron_recipe/big_health_potion
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/waterdust
	name = "水之精质"
	icon_state = "water_runedust"
	major_pot = /datum/alch_cauldron_recipe/int_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/bonemeal
	name = "骨粉"
	icon_state = "bonemeal"
	major_pot = /datum/alch_cauldron_recipe/mana_potion
	med_pot = /datum/alch_cauldron_recipe/per_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/seeddust
	name = "种子粉"
	icon_state = "seeddust"
	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/strong_antidote

/obj/item/alch/blessedseedpowder
	name = "祝圣种子粉"
	desc = "以圣水制成的发光种子粉末，其中仍留有 登多尔 的气息。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	color = "#BFFFC4"
	major_pot = null
	med_pot = null
	minor_pot = null

/obj/item/alch/blessedseedpowder/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("blessedseed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/alch/blessedseedpowder/Destroy()
	remove_filter("blessedseed_glow")
	return ..()

//==============================================================================
// Harvest Bloomstone — ritual reward from Cat 9 Harvest Bloomstone rite.
// Functions as a 20-use blessed seed powder when held during Bless Crops.
// Each use (qdel call from blesscrop) decrements charges instead of destroying it.
// When all 20 charges are spent, the stone shatters and leaves stone dust.
//==============================================================================
/obj/item/alch/bloomstone
	name = "harvest bloomstone"
	desc = "一块浸润着 Treefather 生机之力的光滑石头。手持它施展 Bless Crops 奇迹时，会像祝圣种子粉一样生效，并消耗 1 层充能而不是被直接消耗，足够使用二十次后才会碎裂。"
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "cutgem_shell"
	color = "#228B22"
	major_pot = null
	med_pot = null
	minor_pot = null
	var/charges = 20

/obj/item/alch/bloomstone/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#73c47a")
	add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))

/obj/item/alch/bloomstone/examine(mob/user)
	. = ..()
	. += span_info("还剩 [charges] 层充能。")

/obj/item/alch/bloomstone/Destroy()
	remove_filter("bloomstone_glow")
	charges--
	if(charges > 0)
		// Stone survives this use; re-apply glow and stay alive.
		add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))
		return QDEL_HINT_LETMELIVE
	// All charges spent — shatter into stone dust.
	new /obj/item/alch/stonedust(get_turf(src))
	if(loc && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, span_warning("Harvest Bloomstone 的光芒黯淡下去，石头在我手中碎成了粉末！"))
	return ..()

/obj/item/alch/runedust
	name = "原初精质"
	icon_state = "runedust"
	major_pot = /datum/alch_cauldron_recipe/int_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/coaldust
	name = "煤尘"
	icon_state = "coaldust"
	major_pot = /datum/alch_cauldron_recipe/antidote
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/stonedust
	name = "石粉"
	desc = "用于玻璃黏土精炼的细磨矿粉。"
	icon_state = "coaldust"
	major_pot = null
	med_pot = null
	minor_pot = null

/obj/item/alch/silverdust
	name = "银粉"
	icon_state = "silverdust"
	major_pot = /datum/alch_cauldron_recipe/strong_antidote
	med_pot = /datum/alch_cauldron_recipe/antidote
	minor_pot = /datum/alch_cauldron_recipe/big_health_potion
	is_silver = TRUE

/obj/item/alch/magicdust
	name = "纯净精质"
	icon_state = "magic_runedust"
	major_pot = /datum/alch_cauldron_recipe/big_mana_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/con_potion

/obj/item/alch/firedust
	name = "火之精质"
	icon_state = "fire_runedust"
	major_pot = /datum/alch_cauldron_recipe/str_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/fire_potion

/obj/item/alch/sinew
	name = "肌腱"
	icon_state = "sinew"
	dropshrink = 0.9
	major_pot = /datum/alch_cauldron_recipe/aphrodisiac
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/health_potion

/obj/item/alch/irondust
	name = "铁粉"
	icon_state = "irondust"
	major_pot = /datum/alch_cauldron_recipe/end_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/airdust
	name = "风之精质"
	icon_state = "air_runedust"
	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/swampdust
	name = "Swampweed 粉"
	icon_state = "swampdust"
	major_pot = /datum/alch_cauldron_recipe/temp_potion
	med_pot = /datum/alch_cauldron_recipe/aphrodisiac
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/tobaccodust
	name = "Westleach 粉"
	icon_state = "tobaccodust"
	major_pot = /datum/alch_cauldron_recipe/per_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/spd_potion

/obj/item/alch/earthdust
	name = "土之精质"
	icon_state = "earth_runedust"
	major_pot = /datum/alch_cauldron_recipe/con_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/bone
	name = "尾骨"
	icon_state = "bone"
	desc = "唯一具有炼金特性的生物骨头。"
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64

	major_pot = /datum/alch_cauldron_recipe/strong_antidote
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/con_potion

/obj/item/alch/horn
	name = "巨魔角"
	icon_state = "horn"
	desc = "沼泽巨魔的角。"
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 64
	grid_height = 64

	major_pot = /datum/alch_cauldron_recipe/str_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/golddust
	name = "金粉"
	icon_state = "golddust"

	major_pot = /datum/alch_cauldron_recipe/big_mana_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/feaudust
	name = "feau dust"
	icon_state = "feaudust"

	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/strong_antidote

/obj/item/alch/ozium
	name = "炼金 ozium"
	desc = "炼金处理已使其不适合食用。"
	icon_state = "darkredpowder"

	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/lck_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/transisdust
	name = "sui dust"
	desc = "多种草药长时间混合后形成的特殊粉末。手持使用即可。"
	icon_state = "transisdust"

/obj/item/alch/transisdust/attack_self(mob/living/user)
	..()

	if(alert("你想改变自己吗？", "自我之尘", "是", "否") != "是")
		return
	user.visible_message(
		span_warn("[user]开始使用[src]。"),
		span_warn("我开始把[src]用在自己身上。")
	)
	if(!do_after(user, 5 SECONDS))
		return

	var/p_input = input(user, "选择角色的代词", "代词") as null|anything in GLOB.pronouns_list
	if(p_input)
		user.pronouns = p_input
	if(alert("你想改变体型吗？", "体型", "是", "否") == "是")
		user.gender = "male" ? "female" : "male"

	if(!do_after(user, 5 SECONDS))
		return

	user.regenerate_icons()
	to_chat(user, span_notice("完成了。"))
	qdel(src)

/obj/item/alch/puresalt
	name = "精制盐"
	desc = "经过细筛的盐，能增强其疗愈特性，并强化它与 arcyne 的联系。"
	icon_state = "puresalt"

	major_pot = /datum/alch_cauldron_recipe/antidote
	med_pot = /datum/alch_cauldron_recipe/strong_antidote
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

/obj/item/alch/mineraldust
	name = "矿物粉"
	desc = "由宝石研磨并筛去杂质所得，有助于提炼其中有用的炼金矿质。"
	icon_state = "mineraldust"

	major_pot = /datum/alch_cauldron_recipe/doompoison
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/big_stam_poison

/obj/item/alch/infernaldust
	name = "地狱尘"
	desc = "深渊与此界连接残留下来的遗骸，无论是被放逐还是被杀死后都会留下。最好戴着手套处理。"
	icon_state = "infernaldust"

	major_pot = /datum/alch_cauldron_recipe/fire_potion
	med_pot = /datum/alch_cauldron_recipe/big_stam_poison
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/solardust
	name = "太阳尘"
	desc = "一撮融入 阿斯特拉塔 光辉之力的尘末，直视它会刺痛双眼。"
	icon_state = "solardust"

	major_pot = /datum/alch_cauldron_recipe/fire_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/berrypowder
	name = "浆果粉"
	desc = "浆果研磨并晒干后形成的柔软芳香粉末。"
	icon_state = "berrypowder"

	major_pot = /datum/alch_cauldron_recipe/berrypoison
	med_pot = /datum/alch_cauldron_recipe/mana_potion
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

//BEGIN THE HERBS

/obj/item/alch/atropa
	name = "颠茄"
	icon_state = "atropa"

	major_pot = /datum/alch_cauldron_recipe/doompoison
	med_pot = /datum/alch_cauldron_recipe/berrypoison
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/matricaria
	name = "母菊"
	icon_state = "matricaria"

	major_pot = /datum/alch_cauldron_recipe/berrypoison
	med_pot = /datum/alch_cauldron_recipe/per_potion
	minor_pot = /datum/alch_cauldron_recipe/doompoison

/obj/item/alch/symphitum
	name = "聚合草"
	icon_state = "symphitum"

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/stam_poison
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/taraxacum
	name = "蒲公英"
	icon_state = "taraxacum"

	major_pot = /datum/alch_cauldron_recipe/stam_poison
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/euphrasia
	name = "小米草"
	icon_state = "euphrasia"

	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/aphrodisiac
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/paris
	name = "巴黎"
	icon_state = "paris"

	major_pot = /datum/alch_cauldron_recipe/big_stam_poison
	med_pot = /datum/alch_cauldron_recipe/berrypoison
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/calendula
	name = "金盏花"
	icon_state = "calendula"

	major_pot = /datum/alch_cauldron_recipe/big_health_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/health_potion

/obj/item/alch/mentha
	name = "薄荷"
	icon_state = "mentha"

	major_pot = /datum/alch_cauldron_recipe/per_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/stamina_potion

/obj/item/alch/urtica
	name = "荨麻"
	icon_state = "urtica"

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/aphrodisiac

/obj/item/alch/salvia
	name = "欧鼠尾草"
	icon_state = "salvia"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet

	major_pot = /datum/alch_cauldron_recipe/con_potion
	med_pot = /datum/alch_cauldron_recipe/str_potion
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/hypericum
	name = "金丝桃"
	icon_state = "hypericum"

	major_pot = /datum/alch_cauldron_recipe/stamina_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/benedictus
	name = "藏掖花"
	icon_state = "benedictus"

	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/valeriana
	name = "缬草"
	icon_state = "valeriana"

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/artemisia
	name = "艾蒿"
	icon_state = "artemisia"

	major_pot = /datum/alch_cauldron_recipe/lck_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/aphrodisiac

/obj/item/alch/manabloompowder
	name = "Manabloom 粉"
	icon_state = "bluepowder"

	major_pot = /datum/alch_cauldron_recipe/mana_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

/obj/item/alch/rosa
	name = "玫瑰"
	icon_state = "rosa"
	item_state = "rosa"
	desc = "据说它们原本是白色的，直到 格拉加尔 的鲜血染遍了它生长的原野。"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	muteinmouth = FALSE
	alternate_worn_layer  = 8.9 //On top of helmet
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	major_pot = /datum/alch_cauldron_recipe/temp_potion
	med_pot = /datum/alch_cauldron_recipe/aphrodisiac
	minor_pot = /datum/alch_cauldron_recipe/stamina_potion

/obj/item/alch/rosa/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_MOUTH)
		icon_state = "rosa_mouth"
		user.update_inv_mouth()
	else
		icon_state = "rosa"
		user.update_icon()

//dust mix crafting
/datum/crafting_recipe/roguetown/alch/feaudust
	name = "feau dust"
	result = list(/obj/item/alch/feaudust,
				/obj/item/alch/feaudust)
	reqs = list(/obj/item/alch/irondust = 2,
				/obj/item/alch/golddust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "调配"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0

/datum/crafting_recipe/roguetown/alch/magicdust
	name = "纯净精质"
	result = list(/obj/item/alch/magicdust)
	reqs = list(/obj/item/alch/waterdust = 1, /obj/item/alch/firedust = 1,
				/obj/item/alch/airdust = 1, /obj/item/alch/earthdust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "调配"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
