//dont mind ton of self repeatable defines man i have to remove it but it stays as my code is modular shit for another project and i dont want to re write duplicates

#define VERONICA_SLOT_SHIRT "shirt"
#define VERONICA_SLOT_FACE "face"
#define VERONICA_SLOT_CLOAK "cloak"
#define VERONICA_SLOT_ARMOR "armor"
#define VERONICA_NORMAL_BASE_COST 100
#define VERONICA_NORMAL_BONUS_COST 60
#define VERONICA_TAILOR_BASE_COST 30
#define VERONICA_TAILOR_BONUS_COST 20
#define VERONICA_UPGRADE_NORMAL_COST 100
#define VERONICA_UPGRADE_TAILOR_COST 35
#define VERONICA_UPGRADE_SUCCESS_CHANCE 50
#define VERONICA_MAX_UPGRADE 10
#define VERONICA_UPGRADE_PROTECTION 5
#define VERONICA_UPGRADE_INTEGRITY 30
#define VERONICA_DIRECT_STAT_STEP 5
#define VERONICA_DIRECT_STAT_MAX 20
#define VERONICA_DESIGN_PREFIX "VERONICA1:"
#define VERONICA_MAX_DESIGN_LENGTH 999
#define VERONICA_NAME_LENGTH 40
#define VERONICA_DESC_LENGTH 200

GLOBAL_LIST_INIT(veronica_armor_stats, list( //todo make a refer to existing armor defines
	"blunt",
	"slash",
	"stab",
	"piercing",
	"fire",
	"acid"
))

GLOBAL_LIST_INIT(veronica_crit_types, list(  //todo make a refer to existing armor defines
	"CUT" = BCLASS_CUT,
	"BLUNT" = BCLASS_BLUNT,
	"STAB" = BCLASS_STAB,
	"CHOP" = BCLASS_CHOP,
	"SMASH" = BCLASS_SMASH,
	"PICK" = BCLASS_PICK,
	"TWIST" = BCLASS_TWIST
))

GLOBAL_LIST_INIT(veronica_coverage_types, list( //todo make a refer to existing armor defines
	"ARMS" = ARMS,
	"LEGS" = LEGS,
	"GROIN" = GROIN,
	"VITALS" = VITALS
))

/proc/veronica_is_tailor(mob/user) //tailor or no else for now replaced with trait later
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.job == "Tailor"

/proc/veronica_get_base_price(mob/user)
	return veronica_is_tailor(user) ? VERONICA_TAILOR_BASE_COST : VERONICA_NORMAL_BASE_COST

/proc/veronica_get_bonus_price(mob/user)
	return veronica_is_tailor(user) ? VERONICA_TAILOR_BONUS_COST : VERONICA_NORMAL_BONUS_COST

/proc/veronica_get_upgrade_price(mob/user)
	return veronica_is_tailor(user) ? VERONICA_UPGRADE_TAILOR_COST : VERONICA_UPGRADE_NORMAL_COST

// fluff starts here

/datum/veronica_pattern_data
	var/clothing_slot = VERONICA_SLOT_SHIRT
	var/armored = FALSE
	var/dwarf_compatible = FALSE
	var/finalized = FALSE
	var/base_paid = FALSE
	var/paid_total = 0
	var/custom_name = ""
	var/custom_desc = ""
	var/design_code = VERONICA_DESIGN_PREFIX
	var/list/armor_bonuses = list(
		"blunt" = 0,
		"slash" = 0,
		"stab" = 0,
		"piercing" = 0,
		"fire" = 0,
		"acid" = 0
	)
	var/list/crit_protections = list()
	var/list/extra_coverage = list()

/datum/veronica_pattern_data/proc/get_slot_display_name()
	switch(clothing_slot)
		if(VERONICA_SLOT_SHIRT)
			return "Shirt"
		if(VERONICA_SLOT_FACE)
			return "Face"
		if(VERONICA_SLOT_CLOAK)
			return "Cloak"
		if(VERONICA_SLOT_ARMOR)
			return "Armor"
	return "Unknown"

/datum/veronica_pattern_data/proc/get_bonus_count()
	var/count = 0
	if(armored)
		count++
	if(dwarf_compatible)
		count++
	for(var/stat_name in armor_bonuses)
		var/value = armor_bonuses[stat_name]
		if(isnum(value) && value > 0)
			count += value / VERONICA_DIRECT_STAT_STEP
	count += crit_protections.len
	count += extra_coverage.len
	return count

/datum/veronica_pattern_data/proc/get_bonus_cost(mob/user)
	return get_bonus_count() * veronica_get_bonus_price(user)

/datum/veronica_pattern_data/proc/get_unpaid_price(mob/user)
	var/price = get_bonus_cost(user)
	if(!base_paid)
		price += veronica_get_base_price(user)
	return price

/datum/veronica_pattern_data/proc/get_stat_bonus(stat_name)
	if(!(stat_name in armor_bonuses))
		return 0
	return armor_bonuses[stat_name]

/datum/veronica_pattern_data/proc/increase_stat(stat_name)
	if(finalized || !armored)
		return FALSE
	if(!(stat_name in armor_bonuses))
		return FALSE
	if(armor_bonuses[stat_name] >= VERONICA_DIRECT_STAT_MAX)
		return FALSE
	armor_bonuses[stat_name] += VERONICA_DIRECT_STAT_STEP
	return TRUE

/datum/veronica_pattern_data/proc/decrease_stat(stat_name)
	if(finalized || !armored)
		return FALSE
	if(!(stat_name in armor_bonuses))
		return FALSE
	if(armor_bonuses[stat_name] <= 0)
		return FALSE
	armor_bonuses[stat_name] -= VERONICA_DIRECT_STAT_STEP
	return TRUE

/datum/veronica_pattern_data/proc/toggle_crit(crit_name)
	if(finalized || !armored)
		return FALSE
	if(!(crit_name in GLOB.veronica_crit_types))
		return FALSE
	if(crit_name in crit_protections)
		crit_protections -= crit_name
	else
		crit_protections += crit_name
	return TRUE

/datum/veronica_pattern_data/proc/toggle_coverage(zone_name)
	if(finalized || !armored)
		return FALSE
	if(!(zone_name in GLOB.veronica_coverage_types))
		return FALSE
	if(zone_name in extra_coverage)
		extra_coverage -= zone_name
	else
		extra_coverage += zone_name
	return TRUE

/datum/veronica_pattern_data/proc/clear_armor_options()
	for(var/stat_name in armor_bonuses)
		armor_bonuses[stat_name] = 0
	crit_protections.Cut()
	extra_coverage.Cut()

/datum/veronica_pattern_data/proc/get_information()
	var/text = ""
	text += "Slot: [get_slot_display_name()]\n"
	text += "Armored: [armored ? "YES" : "NO"]\n"
	text += "Dwarf compatible: [dwarf_compatible ? "YES" : "NO"]\n"
	text += "Bonuses: [get_bonus_count()]\n"
	text += "Finalized: [finalized ? "YES" : "NO"]\n"
	text += "Paid: [paid_total] mammons\n"
	if(length(custom_name))
		text += "Name: [custom_name]\n"
	if(armored)
		text += "\nArmor bonuses:\n"
		for(var/stat_name in armor_bonuses)
			text += "[stat_name]: +[armor_bonuses[stat_name]]\n"
		text += "Crit protection: [crit_protections.len ? jointext(crit_protections, ", ") : "none"]\n"
		text += "Extra coverage: [extra_coverage.len ? jointext(extra_coverage, ", ") : "none"]\n"
	return text

// WHAT DO WE APPLY ON BLANK

/obj/item/veronica_pattern
	name = "Blank Veil"
	desc = "A prepared piece of cloth awaiting the impression of the Veil of Veronica."
	var/datum/veronica_pattern_data/pattern_data

/obj/item/veronica_pattern/Initialize(mapload)
	. = ..()
	pattern_data = new /datum/veronica_pattern_data
	update_pattern_name()

/obj/item/veronica_pattern/Destroy()
	if(pattern_data)
		qdel(pattern_data)
		pattern_data = null
	return ..()

/obj/item/veronica_pattern/proc/update_pattern_name()
	if(!pattern_data)
		name = "Veronica Pattern"
		return
	if(pattern_data.finalized)
		if(length(pattern_data.custom_name))
			name = "[pattern_data.custom_name] pattern"
		else
			name = "Consecrated [pattern_data.get_slot_display_name()] Pattern"
	else
		name = "Blank Veil"

/obj/item/veronica_pattern/examine(mob/user)
	. = ..()
	if(!pattern_data)
		return
	. += span_info("Slot: [pattern_data.get_slot_display_name()].")
	. += span_info("Armored: [pattern_data.armored ? "yes" : "no"].")
	. += span_info("Dwarf compatible: [pattern_data.dwarf_compatible ? "yes" : "no"].")
	. += span_info("Properties: [pattern_data.get_bonus_count()].")
	if(pattern_data.finalized)
		. += span_info("The likeness has been permanently sealed into the pattern.")
	else
		. += span_info("The pattern may still be altered by the Veil of Veronica.")

/obj/item/veronica_pattern/attack_self(mob/user)
	if(!pattern_data)
		return
	alert(user, pattern_data.get_information(), "Veronica Pattern", "Close")

// FINISH OF THE PROCESS HERE HERE

/obj/item/clothing/proc/apply_veronica_pattern(datum/veronica_pattern_data/D)
	if(!D || !D.finalized)
		return FALSE
	if(length(D.custom_name))
		name = D.custom_name
	if(length(D.custom_desc))
		desc = D.custom_desc
	switch(D.clothing_slot)
		if(VERONICA_SLOT_SHIRT)
			slot_flags = ITEM_SLOT_SHIRT
		if(VERONICA_SLOT_FACE)
			slot_flags = ITEM_SLOT_MASK
		if(VERONICA_SLOT_CLOAK)
			slot_flags = ITEM_SLOT_CLOAK
		if(VERONICA_SLOT_ARMOR)
			slot_flags = ITEM_SLOT_ARMOR
	if(D.dwarf_compatible)
		allowed_race = CLOTHED_RACES_TYPES
	else
		allowed_race = NON_DWARVEN_RACE_TYPES
	if(D.armored)
		armor = ARMOR_CLOTHING
		body_parts_covered = CHEST
		prevent_crits = list()
		for(var/stat_name in D.armor_bonuses)
			if((stat_name in armor) && isnum(armor[stat_name]))
				armor[stat_name] += D.armor_bonuses[stat_name]
		for(var/crit_name in D.crit_protections)
			if(crit_name in GLOB.veronica_crit_types)
				prevent_crits += GLOB.veronica_crit_types[crit_name]
		for(var/zone_name in D.extra_coverage)
			if(zone_name in GLOB.veronica_coverage_types)
				body_parts_covered |= GLOB.veronica_coverage_types[zone_name]
	else
		armor = null
		prevent_crits = list()
	veronica_upgrade_level = 0
	veronica_upgrade_initialized = FALSE
	veronica_base_max_integrity = 0
	veronica_base_armor = null
	veronica_original_name = null
	return TRUE

// gayplay

/obj/item/clothing
	var/veronica_upgrade_level = 0
	var/veronica_upgrade_initialized = FALSE
	var/veronica_base_max_integrity = 0
	var/veronica_original_name
	var/list/veronica_base_armor

/obj/item/clothing/proc/veronica_capture_baseline()
	if(veronica_upgrade_initialized)
		return
	veronica_upgrade_initialized = TRUE
	veronica_base_max_integrity = max_integrity
	veronica_original_name = name
	if(islist(armor))
		var/list/armor_list = armor
		veronica_base_armor = armor_list.Copy()
	else
		veronica_base_armor = list()

/obj/item/clothing/proc/apply_veronica_upgrade()
	veronica_capture_baseline()
	veronica_upgrade_level = clamp(veronica_upgrade_level, 0, VERONICA_MAX_UPGRADE)
	var/roll_bonus = veronica_upgrade_level * VERONICA_UPGRADE_PROTECTION
	if(islist(veronica_base_armor))
		armor = veronica_base_armor.Copy()
		for(var/stat_name in armor)
			if(isnum(armor[stat_name]))
				armor[stat_name] += roll_bonus
	if(veronica_base_max_integrity > 0)
		max_integrity = veronica_base_max_integrity + (veronica_upgrade_level * VERONICA_UPGRADE_INTEGRITY)
	update_veronica_upgrade_name()

/obj/item/clothing/proc/update_veronica_upgrade_name()
	if(!veronica_original_name)
		veronica_original_name = name
	if(veronica_upgrade_level > 0)
		name = "[veronica_original_name] +[veronica_upgrade_level]"
	else
		name = veronica_original_name

// slop machine itself

/obj/structure/roguemachine/veil_of_veronica
	name = "Veil of Veronica"
	desc = "smh smh later"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "veronica"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/budget = 0
	var/obj/item/veronica_pattern/inserted_pattern
	var/obj/item/clothing/inserted_clothing

// shit you put into attackby

/obj/structure/roguemachine/veil_of_veronica/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	if(istype(P, /obj/item/veronica_pattern))
		if(inserted_pattern || inserted_clothing)
			to_chat(user, span_warning("The Veil already holds an offering."))
			return
		var/obj/item/veronica_pattern/VP = P
		VP.forceMove(src)
		inserted_pattern = VP
		playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
		return attack_hand(user)
	if(istype(P, /obj/item/clothing))
		if(inserted_pattern || inserted_clothing)
			to_chat(user, span_warning("The Veil already holds an offering."))
			return
		var/obj/item/clothing/C = P
		C.forceMove(src)
		inserted_clothing = C
		C.veronica_capture_baseline()
		playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
		return attack_hand(user)
	return ..()

// THE MACHINE STARTS HERE

/obj/structure/roguemachine/veil_of_veronica/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	var/mob/living/carbon/human/H = usr

	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, H)
			budget = 0

	if(href_list["buyblank"])
		if(inserted_pattern || inserted_clothing)
			say("My hands are full.")
		else
			var/price = veronica_get_base_price(H)
			if(budget < price)
				say("Not enough!")
			else
				budget -= price
				var/obj/item/veronica_pattern/P = new(get_turf(src))
				P.pattern_data.base_paid = TRUE
				P.pattern_data.paid_total = price
				P.update_pattern_name()
				H.put_in_hands(P)
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

	if(href_list["ejectpattern"])
		if(inserted_pattern)
			var/obj/item/veronica_pattern/P = inserted_pattern
			inserted_pattern = null
			P.forceMove(get_turf(src))
			H.put_in_hands(P)
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)

	if(href_list["ejectclothing"])
		if(inserted_clothing)
			var/obj/item/clothing/C = inserted_clothing
			inserted_clothing = null
			C.forceMove(get_turf(src))
			H.put_in_hands(C)
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)

	if(href_list["slot"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			switch(href_list["slot"])
				if(VERONICA_SLOT_SHIRT)
					inserted_pattern.pattern_data.clothing_slot = VERONICA_SLOT_SHIRT
				if(VERONICA_SLOT_FACE)
					inserted_pattern.pattern_data.clothing_slot = VERONICA_SLOT_FACE
				if(VERONICA_SLOT_CLOAK)
					inserted_pattern.pattern_data.clothing_slot = VERONICA_SLOT_CLOAK
				if(VERONICA_SLOT_ARMOR)
					inserted_pattern.pattern_data.clothing_slot = VERONICA_SLOT_ARMOR

	if(href_list["togglearmor"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
			if(D.armored)
				D.armored = FALSE
				D.clear_armor_options()
			else
				D.armored = TRUE

	if(href_list["toggledwarf"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			inserted_pattern.pattern_data.dwarf_compatible = !inserted_pattern.pattern_data.dwarf_compatible

	if(href_list["statup"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/stat_name = lowertext(href_list["statup"])
			if(stat_name in GLOB.veronica_armor_stats)
				inserted_pattern.pattern_data.increase_stat(stat_name)

	if(href_list["statdown"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/stat_name = lowertext(href_list["statdown"])
			if(stat_name in GLOB.veronica_armor_stats)
				inserted_pattern.pattern_data.decrease_stat(stat_name)

	if(href_list["togglecrit"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/crit_name = uppertext(href_list["togglecrit"])
			if(crit_name in GLOB.veronica_crit_types)
				inserted_pattern.pattern_data.toggle_crit(crit_name)

	if(href_list["togglecoverage"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/zone_name = uppertext(href_list["togglecoverage"])
			if(zone_name in GLOB.veronica_coverage_types)
				inserted_pattern.pattern_data.toggle_coverage(zone_name)

	if(href_list["setname"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
			var/new_name = input(H, "Maximum [VERONICA_NAME_LENGTH] characters.", "Garment Name", D.custom_name) as text|null
			if(!H.canUseTopic(src, BE_CLOSE))
				return
			if(!isnull(new_name) && inserted_pattern && inserted_pattern.pattern_data == D)
				new_name = copytext(new_name, 1, VERONICA_NAME_LENGTH + 1)
				new_name = replacetext(new_name, "<", "")
				new_name = replacetext(new_name, ">", "")
				D.custom_name = new_name
				inserted_pattern.update_pattern_name()

	if(href_list["setdesc"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
			var/new_desc = input(H, "Maximum [VERONICA_DESC_LENGTH] characters.", "Garment Description", D.custom_desc) as message|null
			if(!H.canUseTopic(src, BE_CLOSE))
				return
			if(!isnull(new_desc) && inserted_pattern && inserted_pattern.pattern_data == D)
				new_desc = copytext(new_desc, 1, VERONICA_DESC_LENGTH + 1)
				new_desc = replacetext(new_desc, "<", "")
				new_desc = replacetext(new_desc, ">", "")
				D.custom_desc = new_desc

	if(href_list["import"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
			var/code = input(H, "Paste appearance code with Ctrl+V.\nMust begin with [VERONICA_DESIGN_PREFIX]", "Imprint Appearance") as message|null
			if(!H.canUseTopic(src, BE_CLOSE))
				return
			if(!isnull(code) && inserted_pattern && inserted_pattern.pattern_data == D)
				if(length(code) > VERONICA_MAX_DESIGN_LENGTH)
					to_chat(H, span_warning("The impression is too large."))
				else
					var/prefix_length = length(VERONICA_DESIGN_PREFIX)
					if(copytext(code, 1, prefix_length + 1) != VERONICA_DESIGN_PREFIX)
						to_chat(H, span_warning("The Veil does not recognize this impression."))
					else
						D.design_code = code
						to_chat(H, span_info("The likeness settles into the cloth."))

	if(href_list["export"])
		if(inserted_pattern)
			input(H, "Ctrl+A, then Ctrl+C.", "Take Impression", inserted_pattern.pattern_data.design_code) as message|null

	if(href_list["finalize"])
		if(inserted_pattern && !inserted_pattern.pattern_data.finalized)
			var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
			var/price = D.get_unpaid_price(H)
			if(budget < price)
				say("Not enough!")
			else
				var/answer = alert(H, "Seal this pattern for [price] mammons?\n\nSlot: [D.get_slot_display_name()]\nProperties: [D.get_bonus_count()]", "Veil of Veronica", "Seal", "Cancel")
				if(!H.canUseTopic(src, BE_CLOSE))
					return
				if(answer == "Seal" && inserted_pattern && inserted_pattern.pattern_data == D && !D.finalized)
					if(budget < price)
						say("Not enough!")
					else
						budget -= price
						D.paid_total += price
						D.base_paid = TRUE
						D.finalized = TRUE
						inserted_pattern.update_pattern_name()
						playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
						to_chat(H, span_info("The Veil seals the likeness with a final stitch."))

	if(href_list["upgrade"])
		if(inserted_clothing)
			var/obj/item/clothing/C = inserted_clothing
			if(C.veronica_upgrade_level >= VERONICA_MAX_UPGRADE)
				to_chat(H, span_warning("The garment can bear no greater blessing."))
			else
				var/price = veronica_get_upgrade_price(H)
				if(budget < price)
					say("Not enough!")
				else
					budget -= price
					if(prob(VERONICA_UPGRADE_SUCCESS_CHANCE))
						C.veronica_upgrade_level++
						C.apply_veronica_upgrade()
						playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
						to_chat(H, span_info("The Veil tightens the garment beneath unseen hands. [C] is now +[C.veronica_upgrade_level]."))
					else
						playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
						to_chat(H, span_warning("The gears shriek, then fall silent. The offering is gone."))

	return attack_hand(H)

// ui test

/obj/structure/roguemachine/veil_of_veronica/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/base_price = veronica_get_base_price(user)
	var/bonus_price = veronica_get_bonus_price(user)
	var/upgrade_price = veronica_get_upgrade_price(user)
	var/contents = "<center><b>VEIL OF VERONICA</b><BR>"
	contents += "<i>The image remains when flesh is gone.</i><BR><BR>"
	contents += "<a href='?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"
	if(veronica_is_tailor(user))
		contents += "<b>TAILOR'S PRIVILEGE</b><BR>"
	contents += "</center><BR>"

	if(inserted_pattern)
		var/datum/veronica_pattern_data/D = inserted_pattern.pattern_data
		contents += "<center><b>PATTERN HELD</b><BR>"
		contents += "Slot: [D.get_slot_display_name()]<BR>"
		contents += "Armored: [D.armored ? "YES" : "NO"]<BR>"
		contents += "Dwarf: [D.dwarf_compatible ? "YES" : "NO"]<BR>"
		contents += "Properties: [D.get_bonus_count()]<BR>"
		contents += "Seal cost: [D.get_unpaid_price(user)]<BR></center><BR>"
		if(!D.finalized)
			contents += "<center><b>FORM</b><BR>"
			contents += "<a href='?src=[REF(src)];slot=[VERONICA_SLOT_SHIRT]'>SHIRT</a> | "
			contents += "<a href='?src=[REF(src)];slot=[VERONICA_SLOT_FACE]'>FACE</a> | "
			contents += "<a href='?src=[REF(src)];slot=[VERONICA_SLOT_CLOAK]'>CLOAK</a> | "
			contents += "<a href='?src=[REF(src)];slot=[VERONICA_SLOT_ARMOR]'>ARMOR</a><BR><BR>"
			contents += "<a href='?src=[REF(src)];togglearmor=1'><b>ARMORED: [D.armored ? "YES" : "NO"]</b></a> (+[bonus_price])<BR>"
			contents += "<a href='?src=[REF(src)];toggledwarf=1'><b>DWARF: [D.dwarf_compatible ? "YES" : "NO"]</b></a> (+[bonus_price])<BR>"
			if(D.armored)
				contents += "<BR><b>PROTECTION</b><BR>"
				contents += "Guaranteed bonus cap: +[VERONICA_DIRECT_STAT_MAX]<BR>"
				for(var/stat_name in GLOB.veronica_armor_stats)
					var/value = D.armor_bonuses[stat_name]
					contents += "[uppertext(stat_name)]: +[value] "
					if(value > 0)
						contents += "<a href='?src=[REF(src)];statdown=[stat_name]'>[-5]</a> "
					if(value < VERONICA_DIRECT_STAT_MAX)
						contents += "<a href='?src=[REF(src)];statup=[stat_name]'>\[+5\]</a>"
					else
						contents += "MAX"
					contents += "<BR>"
				contents += "<BR><b>CRITICAL PROTECTION</b><BR>"
				for(var/crit_name in GLOB.veronica_crit_types)
					var/has_crit = (crit_name in D.crit_protections)
					contents += "<a href='?src=[REF(src)];togglecrit=[crit_name]'>[has_crit ? "REMOVE" : "ADD"] [crit_name]</a>"
					if(has_crit)
						contents += " ACTIVE"
					contents += "<BR>"
				contents += "<BR><b>COVERAGE</b><BR>"
				contents += "CHEST: INCLUDED<BR>"
				for(var/zone_name in GLOB.veronica_coverage_types)
					var/has_zone = (zone_name in D.extra_coverage)
					contents += "<a href='?src=[REF(src)];togglecoverage=[zone_name]'>[has_zone ? "REMOVE" : "ADD"] [zone_name]</a>"
					if(has_zone)
						contents += " ACTIVE"
					contents += "<BR>"
			contents += "<BR><b>APPEARANCE</b><BR>"
			contents += "<a href='?src=[REF(src)];setname=1'>NAME GARMENT</a><BR>"
			contents += "<a href='?src=[REF(src)];setdesc=1'>DESCRIPTION</a><BR>"
			contents += "<a href='?src=[REF(src)];import=1'>IMPRINT</a><BR>"
			contents += "<a href='?src=[REF(src)];export=1'>TAKE IMPRESSION</a><BR><BR>"
			contents += "<a href='?src=[REF(src)];finalize=1'><b>SEAL PATTERN ([D.get_unpaid_price(user)])</b></a><BR>"
			contents += "</center>"
		else
			contents += "<center><b>CONSECRATED</b><BR>"
			contents += "The pattern can no longer be altered.<BR>"
			contents += "<a href='?src=[REF(src)];export=1'>TAKE IMPRESSION</a><BR></center>"
		contents += "<BR><center><a href='?src=[REF(src)];ejectpattern=1'>EJECT PATTERN</a></center>"

	else if(inserted_clothing)
		var/obj/item/clothing/C = inserted_clothing
		var/protection_bonus = C.veronica_upgrade_level * VERONICA_UPGRADE_PROTECTION
		var/integrity_bonus = C.veronica_upgrade_level * VERONICA_UPGRADE_INTEGRITY
		contents += "<center><b>GARMENT HELD</b><BR>"
		contents += "Enhancement: +[C.veronica_upgrade_level]<BR>"
		contents += "Maximum: +[VERONICA_MAX_UPGRADE]<BR>"
		contents += "Roll protection: +[protection_bonus]<BR>"
		contents += "Integrity: +[integrity_bonus]<BR><BR>"
		if(C.veronica_upgrade_level < VERONICA_MAX_UPGRADE)
			contents += "Attempt cost: [upgrade_price]<BR>"
			contents += "Success: [VERONICA_UPGRADE_SUCCESS_CHANCE]%<BR>"
			contents += "Success grants +[VERONICA_UPGRADE_PROTECTION] to every armor stat and +[VERONICA_UPGRADE_INTEGRITY] integrity.<BR><BR>"
			contents += "<a href='?src=[REF(src)];upgrade=1'><b>ATTEMPT ENHANCEMENT</b></a><BR>"
		else
			contents += "<b>THE GARMENT CAN BE BLESSED NO FURTHER.</b><BR>"
		contents += "<BR><a href='?src=[REF(src)];ejectclothing=1'>EJECT GARMENT</a></center>"

	else
		contents += "<center>"
		contents += "Blank Veil: [base_price] mammons<BR>"
		contents += "Each property: +[bonus_price] mammons<BR>"
		contents += "Each direct +5 stat: one property<BR>"
		contents += "Each critical protection: one property<BR>"
		contents += "Each extra coverage zone: one property<BR>"
		contents += "Direct stat cap: +[VERONICA_DIRECT_STAT_MAX]<BR><BR>"
		contents += "Enhancement attempt: [upgrade_price] mammons<BR>"
		contents += "Success: [VERONICA_UPGRADE_SUCCESS_CHANCE]%<BR>"
		contents += "Maximum: +[VERONICA_MAX_UPGRADE]<BR><BR>"
		contents += "<a href='?src=[REF(src)];buyblank=1'><b>PURCHASE BLANK VEIL</b></a>"
		contents += "</center>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VERONICATHING", "", 550, 800)
	popup.set_content(contents)
	popup.open()



/obj/structure/roguemachine/veil_of_veronica/obj_break(damage_flag)
	..()
	if(budget > 0)
		budget2change(budget)
		budget = 0
	if(inserted_pattern)
		inserted_pattern.forceMove(get_turf(src))
		inserted_pattern = null
	if(inserted_clothing)
		inserted_clothing.forceMove(get_turf(src))
		inserted_clothing = null

/obj/structure/roguemachine/veil_of_veronica/Destroy()
	if(inserted_pattern)
		inserted_pattern.forceMove(get_turf(src))
		inserted_pattern = null
	if(inserted_clothing)
		inserted_clothing.forceMove(get_turf(src))
		inserted_clothing = null
	return ..()


//ignore it [2]

#undef VERONICA_SLOT_SHIRT
#undef VERONICA_SLOT_FACE
#undef VERONICA_SLOT_CLOAK
#undef VERONICA_SLOT_ARMOR
#undef VERONICA_NORMAL_BASE_COST
#undef VERONICA_NORMAL_BONUS_COST
#undef VERONICA_TAILOR_BASE_COST
#undef VERONICA_TAILOR_BONUS_COST
#undef VERONICA_UPGRADE_NORMAL_COST
#undef VERONICA_UPGRADE_TAILOR_COST
#undef VERONICA_UPGRADE_SUCCESS_CHANCE
#undef VERONICA_MAX_UPGRADE
#undef VERONICA_UPGRADE_PROTECTION
#undef VERONICA_UPGRADE_INTEGRITY
#undef VERONICA_DIRECT_STAT_STEP
#undef VERONICA_DIRECT_STAT_MAX
#undef VERONICA_DESIGN_PREFIX
#undef VERONICA_MAX_DESIGN_LENGTH
#undef VERONICA_NAME_LENGTH
#undef VERONICA_DESC_LENGTH
