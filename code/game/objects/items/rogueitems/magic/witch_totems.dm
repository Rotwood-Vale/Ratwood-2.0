// Witch Totem System - Inspired by Hades II
// Totems store magical energy and can be upgraded through material tiers
// Each witch class has unique charging methods based on their power source

#define TOTEM_TYPE_ARCANE "arcane" // Old Magick - charged with alchemical items
#define TOTEM_TYPE_DIVINE "divine" // Godsblood - charged with patron-specific items
#define TOTEM_TYPE_HYBRID "hybrid" // Mystagogue - charged with both

/obj/item/witch_totem
	name = "wooden totem"
	desc = "A carved wooden totem inscribed with mysterious runes. It pulses with latent energy, waiting to be filled."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scomstone"
	color = "#8B4513" // Wood brown
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | UNACIDABLE
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	
	var/totem_type = TOTEM_TYPE_ARCANE // Type determines charging method
	var/totem_tier = 1 // Material tier: 1=wood, 2=stone, 3=copper, 4=tin, 5=iron, 6=silver, 7=gold
	var/current_energy = 0
	var/max_energy = 100 // Base capacity for wooden totem
	var/quality_bonus = 0 // Bonus capacity from material quality
	var/last_regen_time = 0.1 // For passive regeneration
	
	// Bonding system - only one totem per witch
	var/mob/living/carbon/human/bonded_witch = null
	var/choicename = FALSE
	var/choicedesc = FALSE
	
	// Upgrade paths - which material can upgrade this totem
	var/upgrade_material = null // Base wooden totem requires magical stone (checked differently)
	var/next_tier_path = /obj/item/witch_totem/stone

/obj/item/witch_totem/examine(mob/user)
	. = ..()
	. += span_notice("Energy: [current_energy]/[max_energy]")
	if(quality_bonus > 0)
		. += span_green("Quality Bonus: +[quality_bonus] max energy")
	. += span_info("Totem Tier: [get_tier_name()]")
	if(bonded_witch)
		. += span_purple("This totem is bonded to [bonded_witch.real_name].")
	
	// Show charging method based on totem type
	if(totem_type == TOTEM_TYPE_ARCANE)
		. += span_notice("<b>Path of Old Magick:</b> This totem hungers for arcane power.")
		. += span_info("Accepts: Manablooms (15), Mana Crystals (30), Obsidian (20), Alchemical ingredients (5)")
	else if(totem_type == TOTEM_TYPE_DIVINE)
		. += span_notice("<b>Path of Godsblood:</b> This totem thirsts for divine offerings.")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.patron)
				. += get_patron_lore(H.patron)
		else
			. += span_info("Accepts: Psicross (20) and patron-specific offerings")
	else if(totem_type == TOTEM_TYPE_HYBRID)
		. += span_notice("<b>Path of the Mystagogue:</b> This totem accepts both arcane and divine power.")
		. += span_info("Accepts: Arcane reagents and sacred offerings")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.patron)
				. += get_patron_lore(H.patron)
	
	if(next_tier_path)
		if(totem_tier == 1)
			. += span_warning("Can be upgraded with a magical stone (a stone imbued with magic power).")
		else if(upgrade_material)
			var/obj/item/upgrade_item = upgrade_material
			. += span_warning("Can be upgraded with [initial(upgrade_item.name)].")

/obj/item/witch_totem/attack_right(mob/user)
	if(!bonded_witch || bonded_witch != user)
		to_chat(user, span_warning("Only the bonded witch can customize this totem!"))
		return
	if(choicename && choicedesc)
		return
	var/current_time = world.time
	if(!choicename)
		var/namechoice = input(user, "Input a new name for your totem", "Rename Totem") as text|null
		if(namechoice && world.time <= (current_time + 30 SECONDS))
			name = namechoice
			choicename = TRUE
	if(!choicedesc)
		var/descchoice = input(user, "Input a new description for your totem", "Describe Totem") as text|null
		if(descchoice && world.time <= (current_time + 30 SECONDS))
			desc = descchoice
			choicedesc = TRUE

/obj/item/witch_totem/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!bonded_witch)
		bond_to_witch(H)
	else if(bonded_witch == H)
		to_chat(H, span_notice("This totem is already bonded to you."))
	else
		to_chat(H, span_warning("This totem is bonded to [bonded_witch.real_name]!"))


/obj/item/witch_totem/proc/get_tier_name()
	switch(totem_tier)
		if(1) return "Wood"
		if(2) return "Stone"
		if(3) return "Copper"
		if(4) return "Tin"
		if(5) return "Iron"
		if(6) return "Silver"
		if(7) return "Gold"
	return "Unknown"

/obj/item/witch_totem/proc/get_patron_lore(datum/patron/P)
	if(!P)
		return span_info("Accepts: Psicross (20)")
	
	switch(P.type)
		if(/datum/patron/divine/astrata)
			return span_red("<i>Astrata, the Absolute Order, demands light to pierce the darkness.</i><br>Offer: Torches (25), Gold (30), Candles (15), Psicross (20)")
		if(/datum/patron/divine/dendor)
			return span_green("<i>Dendor, the Treefather, seeks gifts of the natural world.</i><br>Offer: Seeds (25), Plants (20), Fibers (15), Bones (10), Psicross (20)")
		if(/datum/patron/divine/necra)
			return span_purple("<i>Necra, the Undermaiden, desires tokens of the departed.</i><br>Offer: Skulls (30), Bones (20), Ash (15), Candles (10), Psicross (20)")
		if(/datum/patron/divine/noc)
			return span_blue("<i>Noc, Father of Secrets, craves forbidden knowledge.</i><br>Offer: Books (30), Silver (25), Swampweed (20), Paper (15), Psicross (20)")
		if(/datum/patron/divine/pestra)
			return span_red("<i>Pestra, the Panacea, accepts both decay and cure.</i><br>Offer: Rotten Meat (25), Viscera (20), Worms (15), Psicross (20)")
		if(/datum/patron/divine/xylix)
			return span_red("<i>Xylix, the Trickster, delights in games of chance and fate.</i><br>Offer: Tarot Deck (35), Dice (30), Cards (25), Bottles (15), Psicross (20)")
		if(/datum/patron/divine/malum)
			return span_red("<i>Malum, the Opinionless God, honors the forge and flame.</i><br>Offer: Weapons (30), Ingots (25), Coal (20), Torches (15), Psicross (20)")
		if(/datum/patron/divine/ravox)
			return span_red("<i>Ravox, Glorious Justice, demands proof of righteous battle.</i><br>Offer: Swords (30), Armor (25), Severed Arms (20), Psicross (20)")
		if(/datum/patron/divine/eora)
			return span_red("<i>Eora, Lady of the Hearth, cherishes tokens of love and beauty.</i><br>Offer: Rings (30), Berries (25), Flowers (20), Apples (15), Psicross (20)")
		if(/datum/patron/divine/abyssor)
			return span_blue("<i>Abyssor, the Pure Tide, accepts gifts from the depths.</i><br>Offer: Water (30), Fish (25), Cloth (15), Psicross (20)")
		if(/datum/patron/inhumen/zizo)
			return span_red("<i>Zizo, the God-Head, hungers for death and flesh.</i><br>Offer: Bodyparts (35), Skulls (30), Bones (25)")
		if(/datum/patron/inhumen/graggar)
			return span_red("<i>Graggar, the Gorebound Star, revels in carnage.</i><br>Offer: Bodyparts (30), Meat (25), Weapons (20)")
		if(/datum/patron/inhumen/matthios)
			return span_red("<i>Matthios, the Merchant Prince, demands wealth and coin.</i><br>Offer: Gold Ingots (40), Gold Coins (30), Coins (15)")
		if(/datum/patron/inhumen/baotha)
			return span_green("<i>Baotha, the Hermaphrodite, desires pleasure and indulgence.</i><br>Offer: Drug Bottles (30), Pipeweed (25), Fyritius (20)")
	
	return span_info("Accepts: Psicross (20)")

/obj/item/witch_totem/proc/bond_to_witch(mob/living/carbon/human/witch)
	if(bonded_witch)
		to_chat(witch, span_warning("This totem is already bonded to [bonded_witch.real_name]!"))
		return FALSE
	if(!HAS_TRAIT(witch, TRAIT_WITCH))
		to_chat(witch, span_warning("Only witches can bond with totems!"))
		return FALSE
	// Check if witch already has a bonded totem
	for(var/obj/item/witch_totem/T in world)
		if(T.bonded_witch == witch)
			to_chat(witch, span_warning("I already have a bonded totem! A witch can only bond with one totem."))
			return FALSE
	bonded_witch = witch
	to_chat(witch, span_purple("The totem resonates with my essence, forming an unbreakable bond!"))
	return TRUE

/obj/item/witch_totem/Destroy()
	bonded_witch = null
	return ..()

/obj/item/witch_totem/proc/can_cast(cost = 10)
	return current_energy >= cost

/obj/item/witch_totem/proc/consume_energy(cost = 10)
	if(!can_cast(cost))
		return FALSE
	current_energy = max(0, current_energy - cost)
	update_icon()
	return TRUE

/obj/item/witch_totem/proc/add_energy(amount)
	var/old_energy = current_energy
	current_energy = min(max_energy, current_energy + amount)
	update_icon()
	return current_energy - old_energy // Return actual amount added

/obj/item/witch_totem/update_icon()
	..()
	// Visual feedback based on energy level
	if(current_energy >= max_energy * 0.75)
		add_atom_colour("#00ff00", FIXED_COLOUR_PRIORITY) // Bright green glow
	else if(current_energy >= max_energy * 0.5)
		add_atom_colour("#88ff00", FIXED_COLOUR_PRIORITY) // Yellow-green
	else if(current_energy >= max_energy * 0.25)
		add_atom_colour("#ffaa00", FIXED_COLOUR_PRIORITY) // Orange
	else if(current_energy > 0)
		add_atom_colour("#ff4400", FIXED_COLOUR_PRIORITY) // Red
	else
		remove_atom_colour(FIXED_COLOUR_PRIORITY) // No glow when empty

// Charging system - interact with items to charge the totem
/obj/item/witch_totem/attackby(obj/item/I, mob/user, params)
	// Check for upgrade first
	if(next_tier_path)
		// Wooden totem upgrades with magical stones
		if(totem_tier == 1 && istype(I, /obj/item/natural/stone))
			var/obj/item/natural/stone/S = I
			if(S.magic_power > 0)
				if(try_upgrade(I, user))
					return
				else
					return
			else
				to_chat(user, span_warning("This stone lacks magical power. I need a magical stone to upgrade [src]!"))
				return
		// Other tiers upgrade with bars
		else if(upgrade_material && istype(I, upgrade_material))
			if(try_upgrade(I, user))
				return
	
	// Then check for charging
	if(try_charge_from_item(I, user))
		return
	
	return ..()

/obj/item/witch_totem/proc/try_upgrade(obj/item/I, mob/user)
	if(!next_tier_path)
		to_chat(user, span_warning("[src] cannot be upgraded further!"))
		return FALSE
	
	// Calculate quality bonus before upgrade
	var/quality_bonus_amount = calculate_quality_bonus(I)
	
	user.visible_message(span_notice("[user] begins infusing [src] with [I]..."), \
						span_notice("I begin channeling the essence of [I] into [src]..."))
	
	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(user, span_warning("I interrupt the infusion!"))
		return FALSE
	
	// Create upgraded totem
	var/obj/item/witch_totem/new_totem = new next_tier_path(get_turf(src))
	new_totem.totem_type = totem_type
	new_totem.current_energy = current_energy // Transfer energy
	new_totem.bonded_witch = bonded_witch // Transfer bonding
	new_totem.choicename = choicename // Transfer customization
	new_totem.choicedesc = choicedesc
	
	// Apply quality bonus
	new_totem.quality_bonus = quality_bonus_amount
	new_totem.max_energy += quality_bonus_amount
	
	// Show quality result message
	var/quality_msg = get_quality_message(quality_bonus_amount)
	if(quality_msg)
		to_chat(user, quality_msg)
	
	user.visible_message(span_green("[src] transforms, absorbing the power of [I]!"), \
						span_green("[src] transforms into [new_totem]!"))
	
	playsound(get_turf(src), 'sound/magic/timestop.ogg', 50, TRUE)
	qdel(I)
	user.dropItemToGround(src)
	qdel(src)
	user.put_in_hands(new_totem)
	return TRUE

/obj/item/witch_totem/proc/calculate_quality_bonus(obj/item/I)
	// For magical stones (tier 1 upgrade)
	if(istype(I, /obj/item/natural/stone))
		var/obj/item/natural/stone/S = I
		// magic_power ranges from 1-15, give 5-75 bonus (5 per magic_power)
		return S.magic_power * 5
	
	// For ingots (tier 2+ upgrades)
	if(istype(I, /obj/item/ingot))
		var/obj/item/ingot/ingot = I
		var/base_bonus = 0
		
		// Quality-based bonuses
		switch(ingot.quality)
			if(SMELTERY_LEVEL_SPOIL)
				base_bonus = -20 // Penalty for spoiled quality
			if(SMELTERY_LEVEL_POOR)
				base_bonus = 0 // No bonus
			if(SMELTERY_LEVEL_NORMAL)
				base_bonus = 10 // Small bonus
			if(SMELTERY_LEVEL_GOOD)
				base_bonus = 25 // Decent bonus
			if(SMELTERY_LEVEL_GREAT)
				base_bonus = 40 // Great bonus
			if(SMELTERY_LEVEL_EXCELLENT)
				base_bonus = 60 // Excellent bonus from master smiths
		
		return base_bonus
	
	return 0

/obj/item/witch_totem/proc/get_quality_message(bonus_amount)
	if(bonus_amount >= 60)
		return span_green("The material's exceptional quality resonates powerfully with the totem!")
	else if(bonus_amount >= 40)
		return span_green("The material's great quality enhances the totem significantly!")
	else if(bonus_amount >= 25)
		return span_notice("The material's good quality improves the totem.")
	else if(bonus_amount >= 10)
		return span_notice("The material's decent quality provides a modest improvement.")
	else if(bonus_amount > 0)
		return span_notice("The material resonates with the totem.")
	else if(bonus_amount == 0)
		return span_warning("The material's poor quality provides no enhancement.")
	else if(bonus_amount < 0)
		return span_danger("The material's spoiled quality weakens the totem's potential!")
	return null

/obj/item/witch_totem/proc/try_charge_from_item(obj/item/I, mob/user)
	var/charge_amount = get_charge_value(I, user)
	if(charge_amount <= 0)
		return FALSE
	
	if(current_energy >= max_energy)
		to_chat(user, span_warning("[src] is already at full capacity!"))
		return FALSE
	
	user.visible_message(span_notice("[user] channels energy from [I] into [src]..."), \
						span_notice("I channel the essence of [I] into [src]..."))
	
	if(!do_after(user, 3 SECONDS, target = src))
		return FALSE
	
	var/actual_added = add_energy(charge_amount)
	to_chat(user, span_green("[src] absorbs [actual_added] energy from [I]! ([current_energy]/[max_energy])"))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 30, TRUE)
	
	qdel(I)
	return TRUE

/obj/item/witch_totem/proc/get_charge_value(obj/item/I, mob/user)
	if(!isliving(user))
		return 0
	
	var/mob/living/carbon/human/H = user
	
	// Old Magick (Arcane) - charges from alchemical and magical items
	if(totem_type == TOTEM_TYPE_ARCANE || totem_type == TOTEM_TYPE_HYBRID)
		if(istype(I, /obj/item/reagent_containers/food/snacks/grown/manabloom))
			return 15
		if(istype(I, /obj/item/magic/manacrystal))
			return 30
		if(istype(I, /obj/item/magic/obsidian))
			return 20
		// Alchemical ingredients provide smaller amounts
		if(istype(I, /obj/item/alch))
			return 5
	
	// Godsblood (Divine) - charges from patron-specific items
	if((totem_type == TOTEM_TYPE_DIVINE || totem_type == TOTEM_TYPE_HYBRID) && H && H.patron)
		var/patron_charge = get_patron_charge_value(I, H.patron)
		if(patron_charge > 0)
			return patron_charge
	
	return 0

/obj/item/witch_totem/proc/get_patron_charge_value(obj/item/I, datum/patron/P)
	if(!P)
		return 0
	
	// All divine patrons accept psicross as a universal offering
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross))
		return 20
	
	switch(P.type)
		// Astrata - sun, day, light, order
		if(/datum/patron/divine/astrata)
			if(istype(I, /obj/item/flashlight/flare/torch))
				return 25
			if(istype(I, /obj/item/candle))
				return 15
			if(istype(I, /obj/item/ingot/gold))
				return 30
		
		// Dendor - nature, plants, animals
		if(/datum/patron/divine/dendor)
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown))
				return 20
			if(istype(I, /obj/item/seeds))
				return 25
			if(istype(I, /obj/item/natural/fibers))
				return 15
			if(istype(I, /obj/item/natural/bone))
				return 10
		
		// Necra - death, rebirth, the underworld
		if(/datum/patron/divine/necra)
			if(istype(I, /obj/item/skull))
				return 30
			if(istype(I, /obj/item/natural/bone))
				return 20
			if(istype(I, /obj/item/ash))
				return 15
			if(istype(I, /obj/item/candle))
				return 10
		
		// Noc - night, moon, knowledge, secrets
		if(/datum/patron/divine/noc)
			if(istype(I, /obj/item/book))
				return 30
			if(istype(I, /obj/item/paper))
				return 15
			if(istype(I, /obj/item/ingot/silver))
				return 25
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed))
				return 20
		
		// Pestra - medicine, disease, decay
		if(/datum/patron/divine/pestra)
			if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat_rotten))
				return 25
			if(istype(I, /obj/item/alch/viscera))
				return 20
			if(istype(I, /obj/item/natural/worms))
				return 15
		
		// Xylix - trickery, freedom, fate
		if(/datum/patron/divine/xylix)
			if(istype(I, /obj/item/dice))
				return 30
			if(istype(I, /obj/item/toy/cards/deck/tarot))
				return 35
			if(istype(I, /obj/item/toy/cards))
				return 25
			if(istype(I, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/B = I
				if(B.reagents && B.reagents.total_volume > 0)
					return 15
		
		// Malum - fire, destruction, smithing, ingenuity
		if(/datum/patron/divine/malum)
			if(istype(I, /obj/item/ingot))
				return 25
			if(istype(I, /obj/item/rogueweapon))
				return 30
			if(istype(I, /obj/item/natural/stone))
				return 20
			if(istype(I, /obj/item/flashlight/flare/torch))
				return 15
		
		// Ravox - justice, battle, glory
		if(/datum/patron/divine/ravox)
			if(istype(I, /obj/item/rogueweapon/sword))
				return 30
			if(istype(I, /obj/item/clothing/suit/roguetown/armor))
				return 25
			if(istype(I, /obj/item/bodypart/l_arm) || istype(I, /obj/item/bodypart/r_arm))
				return 20
		
		// Eora - love, family, beauty
		if(/datum/patron/divine/eora)
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
				return 25
			if(istype(I, /obj/item/clothing/ring))
				return 30
			if(istype(I, /obj/item/natural/silk))
				return 20
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
				return 15
		
		// Abyssor - seas, purity, dreams
		if(/datum/patron/divine/abyssor)
			if(istype(I, /obj/item/reagent_containers/food/snacks/fish))
				return 25
			if(istype(I, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/B = I
				if(B.reagents && B.reagents.has_reagent(/datum/reagent/water))
					return 30
			if(istype(I, /obj/item/natural/cloth))
				return 15
		
		// Inhumen deities
		if(/datum/patron/inhumen/zizo)
			if(istype(I, /obj/item/natural/bone))
				return 25
			if(istype(I, /obj/item/skull))
				return 30
			if(istype(I, /obj/item/bodypart))
				return 35
		
		if(/datum/patron/inhumen/graggar)
			if(istype(I, /obj/item/bodypart))
				return 30
			if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat))
				return 25
			if(istype(I, /obj/item/rogueweapon))
				return 20
		
		if(/datum/patron/inhumen/matthios)
			if(istype(I, /obj/item/roguecoin/gold))
				return 30
			if(istype(I, /obj/item/ingot/gold))
				return 40
			if(istype(I, /obj/item/roguecoin))
				return 15
		
		if(/datum/patron/inhumen/baotha)
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed))
				return 25
			if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius))
				return 20
			if(istype(I, /obj/item/reagent_containers/glass/bottle))
				var/obj/item/reagent_containers/glass/bottle/B = I
				if(B.reagents && B.reagents.has_reagent(/datum/reagent/drug))
					return 30
	
	return 0

// ============== TOTEM VARIANTS BY MATERIAL ==============

/obj/item/witch_totem/stone
	name = "stone totem"
	desc = "A totem carved from sturdy stone, its runes etched deeper and more permanent."
	icon_state = "scomstone"
	color = "#808080" // Grey stone
	totem_tier = 2
	max_energy = 150
	upgrade_material = /obj/item/ingot/copper
	next_tier_path = /obj/item/witch_totem/copper

/obj/item/witch_totem/copper
	name = "copper totem"
	desc = "A totem bound with copper, conducting mystical energies with greater efficiency."
	icon_state = "scomstone"
	color = "#B87333" // Copper
	totem_tier = 3
	max_energy = 200
	upgrade_material = /obj/item/ingot/tin
	next_tier_path = /obj/item/witch_totem/tin

/obj/item/witch_totem/tin
	name = "tin totem"
	desc = "A totem reinforced with tin, resonating with a soft, pure hum."
	icon_state = "scomstone"
	color = "#A8A8A8" // Light grey tin
	totem_tier = 4
	max_energy = 250
	upgrade_material = /obj/item/ingot/iron
	next_tier_path = /obj/item/witch_totem/iron

/obj/item/witch_totem/iron
	name = "iron totem"
	desc = "An iron-bound totem, strong and unyielding, channeling considerable power."
	icon_state = "scomstone"
	color = "#4A4A4A" // Dark grey iron
	totem_tier = 5
	max_energy = 300
	upgrade_material = /obj/item/ingot/silver
	next_tier_path = /obj/item/witch_totem/silver

/obj/item/witch_totem/silver
	name = "silver totem"
	desc = "A totem adorned with silver, gleaming with moonlit power. The runes shine with ethereal light."
	icon_state = "scomstone"
	color = "#C0C0C0" // Silver
	totem_tier = 6
	max_energy = 400
	upgrade_material = /obj/item/ingot/gold
	next_tier_path = /obj/item/witch_totem/gold

/obj/item/witch_totem/gold
	name = "golden totem"
	desc = "The pinnacle of totems, wrought in gold. It hums with immense power, barely contained."
	icon_state = "scomstone"
	color = "#FFD700" // Gold
	totem_tier = 7
	max_energy = 500
	upgrade_material = null
	next_tier_path = null

// ============== TOTEM RECALL SPELL ==============

/obj/effect/proc_holder/spell/self/recall_totem
	name = "Recall Totem"
	desc = "Summon your bonded totem to your hand from anywhere in the world."
	overlay_state = "raiseskele"
	range = -1
	chargedrain = 0
	chargetime = 3 SECONDS
	releasedrain = 10
	recharge_time = 30 SECONDS
	selection_type = "view"
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/self/recall_totem/cast(list/targets, mob/living/user = usr)
	if(!ishuman(user))
		return FALSE
	
	var/mob/living/carbon/human/H = user
	
	if(!HAS_TRAIT(H, TRAIT_WITCH))
		to_chat(user, span_warning("Only witches can recall their totems!"))
		return FALSE
	
	// Find the witch's bonded totem
	var/obj/item/witch_totem/bonded_totem = null
	for(var/obj/item/witch_totem/T in world)
		if(T.bonded_witch == H)
			bonded_totem = T
			break
	
	if(!bonded_totem)
		to_chat(user, span_warning("I don't have a bonded totem to recall!"))
		return FALSE
	
	// Check if already holding it
	if(bonded_totem in H.held_items)
		to_chat(user, span_warning("I'm already holding my totem!"))
		return FALSE
	
	// Recall the totem
	var/turf/T = get_turf(bonded_totem)
	var/turf/U = get_turf(H)
	
	// Visual effects at totem location
	if(T)
		new /obj/effect/temp_visual/cult/sparks(T)
		playsound(T, 'sound/magic/churn.ogg', 50, TRUE)
	
	// Move totem to user
	bonded_totem.forceMove(U)
	
	// Visual effects at user location
	new /obj/effect/temp_visual/cult/sparks(U)
	playsound(U, 'sound/magic/timestop.ogg', 50, TRUE)
	
	// Put in hands
	H.put_in_hands(bonded_totem, forced = FALSE)
	
	user.visible_message(span_purple("[user]'s totem materializes in their hand!"), \
						span_purple("My totem answers my call, materializing in my hand!"))
	
	return TRUE

#undef TOTEM_TYPE_ARCANE
#undef TOTEM_TYPE_DIVINE
#undef TOTEM_TYPE_HYBRID
