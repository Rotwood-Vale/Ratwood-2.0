//The guild. /The/ guild. Underdark explorers. Not as packed as other merc groups, but get explosives, the skills to make more off the bat and a funny hat.
/datum/advclass/mercenary/underdweller
	name = "Underdweller"
	tutorial = "A member of the Underdwellers, you've taken many of the deadliest contracts known to man in literal underground circles. \
	Drow or Dwarf, you've put your differences aside for coin and adventure."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dwarf/mountain,
		/datum/species/dwarf/gnome,
		/datum/species/elf/dark,
		/datum/species/kobold,
		/datum/species/goblinp,				//Might be a little weird but goblins do reside in caves, and they could use a unique merc class type.
		/datum/species/anthromorphsmall,	//Basically all under-ground races. Perfect for cave-clearing.
	)
	outfit = /datum/outfit/job/roguetown/mercenary/underdweller
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_WEBWALK)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,	//Gets this for bomb making.
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,	//Accompanies mining; they know how to smelt, not make armor though.
	)
	extra_context = "This subclass is race-limited to: Dwarves, Dark Elves, Kobolds, Goblins & Verminvolk."

/datum/outfit/job/roguetown/mercenary/underdweller/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	mask = /obj/item/clothing/mask/rogue/ragmask
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/black
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/pick
	beltr = /obj/item/storage/detpack
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/shield/wood
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/flint,
		/obj/item/rogueweapon/huntingknife,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 12


//Clothing here to avoid overcrowding the hats.dm with snowflake gear. It's just a kettle with a light.
/obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	name = "reinforced miners helmet"
	desc = "A rimmed miners helmet reinforced with leather atop its flimsy thin inner steel, its glowing lamp fueled by magiks from the depths."
	icon_state = "minerslamp"
	var/on = FALSE
	light_outer_range = 5 	//Same as a lamptern; can't be extinguished either.
	light_power = 1
	max_integrity = 250		//Slightly better integrity. Just because unique kettle. Plus class doesn't have much going for it traits-wise.
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT

/obj/item/clothing/head/roguetown/helmet/kettle/minershelm/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/toggle_lamp.ogg', 100)
	toggle_helmet_light(user)
	to_chat(user, span_info("I toggle [src] [on ? "on" : "off"]."))

/obj/item/clothing/head/roguetown/helmet/kettle/minershelm/proc/toggle_helmet_light(mob/living/user)
	on = !on
	set_light_on(on)
	update_icon()

/obj/item/clothing/head/roguetown/helmet/kettle/minershelm/update_icon()
	icon_state = "minerslamp[on]"
	item_state = "minerslamp[on]"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon(force = TRUE)
	..()

//Detpack. I'm sure you can imagine use cases, outside of carrying it.
/obj/item/storage/detpack
	name = "detpack"
	desc = "A pouch to carry sticks of blasting powder. What sort of lunatic would do that?"
	icon_state = "strapbag"
	item_state = "strapbag"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/detpack
	populate_contents = list(
		/obj/item/tntstick,
		/obj/item/tntstick
	)

/datum/component/storage/concrete/grid/detpack
	max_w_class = WEIGHT_CLASS_BULKY//Can carry a satchel. As a treat.
	screen_max_rows = 4//4 sticks of TNT...
	screen_max_columns = 4//... or a satchel.

/datum/component/storage/concrete/grid/detpack/New(datum/P, ...)
	. = ..()
	set_holdable(list(
		/obj/item/tntstick,
		/obj/item/satchel_bomb
		))

/obj/item/storage/detpack/update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "strapbag"
		w_class = WEIGHT_CLASS_NORMAL
	else
		icon_state = "strapbag"
		w_class = WEIGHT_CLASS_NORMAL
