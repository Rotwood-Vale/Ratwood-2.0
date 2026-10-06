//==============================================================================
// Blessed Druid Armor
//==============================================================================

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed
	name = "blessed druid armor"
	desc = "Druid armor hallowed by the Treefather's rite. The bark pulses with faint living light; it feels as though the forest itself watches over whoever wears it."
	armor = list("blunt" = 90, "slash" = 70, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	color = "#73c47a"

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/pickup(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(user.patron?.type == /datum/patron/divine/dendor)
		return
	user.electrocute_act(30, src)
	user.mob_timers["kneestinger"] = world.time
	to_chat(user, span_warning("[name] rejects my grasp — only the Treefather's faithful may bear such a gift!"))

//==============================================================================
// Sanctified Tree Data Datum
//==============================================================================

/// Tracks per-tree ritual state, aura flags, and the per-player soulbind registry.
/datum/sanctified_tree_data
	/// Back-reference to the owning sanctified tree.
	var/obj/structure/flora/roguetree/wise/sanctified/tree
	/// Once-per-tree ritual completion flags.
	var/list/rituals_completed = list()
	/// Per-player soulbind registry: list of ckey strings.
	var/list/soulbound_players = list()
	/// Ckey of the player who just completed soulbound offerings and must now bleed to confirm.
	var/awaiting_soulbind_ckey

	// ---- Ritual state -------------------------------------------------------
	/// Currently active ritual category string, or null if none.
	var/datum/druid_ritual/active_ritual
	/// Armor held for nature's temper. Stored inside the tree until completion.
	var/obj/item/ritual_armor

	// ---- Aura state ---------------------------------------------------------
	/// TRUE once Treefather's Bulwark is completed.
	var/has_slow_aura = FALSE
	/// TRUE once Living Light is completed.
	var/has_heal_aura = FALSE
	/// Mobs currently slowed by the bulwark aura. Tracked for cleanup.
	var/list/slowed_mobs = list()
	/// dt accumulator for slow-aura 5-second ticks.
	var/slow_aura_elapsed = 0
	/// dt accumulator for heal-aura 60-second ticks.
	var/heal_aura_elapsed = 0
	/// Per-player middle-click heal cooldown: ckey -> world.time threshold (5 seconds after heal wears off).
	var/list/heal_player_cooldowns = list()

	// ---- Wedding ceremony state ------------------------------------------
	/// TRUE while an eoran bud has been offered and the tree awaits a bitten apple.
	var/wedding_active = FALSE
	/// Ckey of the player who offered the eoran bud to start the ceremony.
	var/wedding_officiant_ckey

/datum/sanctified_tree_data/New(obj/structure/flora/roguetree/wise/sanctified/owner)
	..()
	tree = owner

//==============================================================================
// Sanctified Tree
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified
	name = "sanctified tree"
	desc = "A great tree consecrated by the Treefather. Its bark glows with faint light, and the air around it thrums with primal holiness. A nexus of druidic power."
	examine_plays_music = FALSE
	pixel_x = -11
	/// Base max_integrity before nearby-tree bonus.
	max_integrity = 400
	/// Disable wise-tree autonomous retaliation. The sanctified tree
	/// cooperates with its druid warden rather than lashing out autonomously.
	activated = FALSE
	// Blessed log is spawned manually in obj_destruction — suppress the inherited plain log drop.
	static_debris = list()

	/// Datum holding ritual completion flags and the soulbind registry.
	var/datum/sanctified_tree_data/tree_data
	/// If FALSE (for sanctified_wise trees), hides ritual and wedding hints in examine.
	var/show_ritual_hints = TRUE
	/// Current max_integrity bonus from nearby living trees.
	var/integrity_bonus = 0
	/// SSprocessing dt accumulator — recalculates bonus every 60 seconds.
	var/bonus_check_elapsed = 0
	/// SSprocessing dt accumulator — restores integrity periodically.
	var/integrity_regen_elapsed = 0

/obj/structure/flora/roguetree/wise/sanctified/Initialize(mapload)
	. = ..()
	tree_data = new /datum/sanctified_tree_data(src)
	set_light(3, 3, 3, l_color = "#FFD700")
	START_PROCESSING(SSprocessing, src)
	recalculate_integrity_bonus()

/obj/structure/flora/roguetree/wise/sanctified/Destroy()
	remove_filter("sanctified_outline")
	STOP_PROCESSING(SSprocessing, src)
	if(tree_data)
		// Notify and debuff any soulbound players before clearing data.
		if(length(tree_data.soulbound_players))
			curse_soulbound_players()
		// Clean up aura slow on destroy.
		for(var/mob/living/slowed_mob in tree_data.slowed_mobs)
			if(!QDELETED(slowed_mob))
				slowed_mob.remove_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		tree_data.slowed_mobs = list()
		// Return any stored ritual armor to the ground.
		if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
			tree_data.ritual_armor.forceMove(get_turf(src))
			tree_data.ritual_armor = null
		qdel(tree_data)
		tree_data = null
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/obj_destruction(damage_flag)
	set_light(0)
	visible_message(span_warning("The sanctified tree's golden light dies as it falls — the Treefather's blessing is broken!"))
	var/obj/item/grown/log/tree/blessed_log = new(loc)
	blessed_log.bless_log()
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/process(dt)
	bonus_check_elapsed += dt
	if(bonus_check_elapsed >= 60 SECONDS)
		bonus_check_elapsed = 0
		recalculate_integrity_bonus()
	integrity_regen_elapsed += dt
	if(integrity_regen_elapsed >= 30 SECONDS)
		integrity_regen_elapsed = 0
		if(obj_integrity < max_integrity)
			obj_integrity = min(obj_integrity + 10, max_integrity)
	if(!tree_data)
		return
	if(tree_data.has_slow_aura)
		tree_data.slow_aura_elapsed += dt
		if(tree_data.slow_aura_elapsed >= 5 SECONDS)
			tree_data.slow_aura_elapsed = 0
			update_slow_aura()
	if(tree_data.has_heal_aura)
		tree_data.heal_aura_elapsed += dt
		if(tree_data.heal_aura_elapsed >= 60 SECONDS)
			tree_data.heal_aura_elapsed = 0
			pulse_heal_aura()

//==============================================================================
// Examine / Interaction// Wedding ritual procs
//==============================================================================

/// Called when a bitten apple (2 names) is offered to the sanctified tree during a wedding ceremony.
/obj/structure/flora/roguetree/wise/sanctified/proc/perform_wedding(mob/living/user, obj/item/reagent_containers/food/snacks/grown/apple/marriage_apple)
	var/mob/living/carbon/human/thegroom
	var/mob/living/carbon/human/thebride
	for(var/bite_name in marriage_apple.bitten_names)
		var/found = FALSE
		for(var/mob/living/carbon/human/viewer in viewers(src, 7))
			if(!ishuman(viewer))
				continue
			if(viewer.stat == DEAD)
				continue
			if(!viewer.client)
				continue
			if(viewer.marriedto)
				continue
			if(viewer.real_name == bite_name)
				if(!thegroom)
					thegroom = viewer
				else if(!thebride)
					thebride = viewer
				found = TRUE
				break
		if(found && thegroom && thebride)
			break

	if(!(thegroom && thebride))
		marriage_apple.become_rotten()
		to_chat(user, span_danger("The Treefather's blessing falters — the souls who have bitten the fruit are not present or have already been wed. The apple rots."))
		tree_data.wedding_active = FALSE
		tree_data.wedding_officiant_ckey = null
		return

	var/surname = reject_bad_name(tgui_input_text(user, "Enter a shared surname for the couple:", "Nature's Union"))
	if(QDELETED(src) || QDELETED(user))
		return
	if(!surname || !length(trim(surname)))
		surname = thegroom.dna.species.random_surname()

	priority_announce("[thegroom.real_name] and [thebride.real_name] have been wed beneath the Treefather's boughs!", title = "Nature's Union!", sound = 'sound/misc/bell.ogg')

	var/list/titles = list("Sir", "Ser", "Dame", "Lord", "Lady", "Knight-Captain", "Duke", "Duchess", "Father", "Mother", "Brother", "Sister", "Prelate", "Devotee", "Votary")

	var/list/groom_name_parts = splittext(thegroom.real_name, " ")
	var/title_found = (titles.Find(groom_name_parts[1]) != 0)
	if(title_found)
		thegroom.real_name = "[groom_name_parts[1]] [groom_name_parts[2]] [surname]"
	else
		thegroom.real_name = "[groom_name_parts[1]] [surname]"

	var/list/bride_name_parts = splittext(thebride.real_name, " ")
	title_found = (titles.Find(bride_name_parts[1]) != 0)
	if(title_found)
		thebride.real_name = "[bride_name_parts[1]] [bride_name_parts[2]] [surname]"
	else
		thebride.real_name = "[bride_name_parts[1]] [surname]"

	to_chat(thegroom, span_notice("Your new shared surname is [surname]."))
	to_chat(thebride, span_notice("Your new shared surname is [surname]."))

	thegroom.marriedto = thebride.real_name
	thebride.marriedto = thegroom.real_name
	thegroom.adjust_triumphs(1)
	thebride.adjust_triumphs(1)

	visible_message(span_green("The [src.name] blazes with golden light — Dendor and Eora both bless this union!"))
	playsound(get_turf(src), 'sound/misc/bell.ogg', 80, FALSE)
	qdel(marriage_apple)
	tree_data.wedding_active = FALSE
	tree_data.wedding_officiant_ckey = null
//==============================================================================

/obj/structure/flora/roguetree/wise/sanctified/examine(mob/living/carbon/human/user)
	. = ..()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/counted_tree in range(5, src))
		if(!counted_tree.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/counted_tree in range(5, src))
		if(istype(counted_tree, /obj/structure/flora/roguetree/wise) || istype(counted_tree, /obj/structure/flora/roguetree/burnt) || istype(counted_tree, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	. += span_info("[src] draws strength from [tree_count] nearby living tree\s, granting [integrity_bonus] bonus integrity.")
	. += span_info("Integrity: [round(obj_integrity)]/[max_integrity]")
	if(show_ritual_hints)
		. += span_info("Open the ritual menu with the Dendor amulet to begin any druidic ritual, or start the 'Nature's Union' wedding ceremony; the betrothed must each bite the same apple once and offer it to the tree to seal the pact.")
	if(!ishuman(user))
		return
	if(user.patron?.type != /datum/patron/divine/dendor)
		return
	if(show_ritual_hints)
		. += span_notice("Hold the Dendor amulet against this tree to start or cancel a Treefather bounty.")
		. += span_notice("Alternatively, touch-intent with an empty hand while wearing the amulet opens the ritual menu.")
		. += span_notice("To offer while a bounty is active, click the tree with the required item in-hand.")
	if(show_ritual_hints && tree_data?.active_ritual)
		. += span_notice("Active bounty: [tree_data.active_ritual.name]")
		. += span_notice("[tree_data.active_ritual.get_ritual_examine()]")
	if(tree_data?.has_slow_aura)
		. += span_info("A guardian ward repels those who would defile this grove.")
	if(tree_data?.has_heal_aura)
		. += span_info("A healing aura emanates from this tree. Middle-click the tree while adjacent to channel its healing energies.")

/obj/structure/flora/roguetree/wise/sanctified/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return ..()
	if(tree_data?.awaiting_soulbind_ckey && user.ckey == tree_data.awaiting_soulbind_ckey && show_ritual_hints)
		attempt_soulbind(user)
		return
	// Touch intent with empty hand while wearing the Dendor amulet opens the ritual menu.
	if(!user.get_active_held_item())
		var/has_dendor_amulet = FALSE
		for(var/slot in user.get_all_slots())
			if(istype(user.get_item_by_slot(slot), /obj/item/clothing/neck/roguetown/psicross/dendor))
				has_dendor_amulet = TRUE
				break
		if(!has_dendor_amulet)
			return
		if(!show_ritual_hints)
			to_chat(user, span_warning("This blessed tree holds no further rites — its power is already given."))
			return ..()
		if(user.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("Only a follower of Dendor may commune with this sacred tree."))
			return
		open_ritual_menu(user)

/obj/structure/flora/roguetree/wise/sanctified/attackby(obj/item/attacking_item, mob/living/user, params)
	// Bitten apple: completes the Nature's Union wedding ceremony.
	if(tree_data?.wedding_active && istype(attacking_item, /obj/item/reagent_containers/food/snacks/grown/apple))
		var/obj/item/reagent_containers/food/snacks/grown/apple/marriage_apple = attacking_item
		if(length(marriage_apple.bitten_names) < 2)
			to_chat(user, span_warning("Both partners must bite the apple before offering it to the tree."))
			return
		perform_wedding(user, marriage_apple)
		return

	// Dendor amulet: entry point for ritual menu.
	if(istype(attacking_item, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!show_ritual_hints)
			to_chat(user, span_warning("This blessed tree holds no further rites — its power is already given."))
			return
		if(!ishuman(user))
			return
		var/mob/living/carbon/human/human_user = user
		if(human_user.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("Only a follower of Dendor may commune with this sacred tree."))
			return
		open_ritual_menu(user)
		return

	// While a ritual is active, offerings are made by clicking the tree with an item in-hand.
	if(tree_data?.active_ritual && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.patron?.type == /datum/patron/divine/dendor)
			if(offer_item(user))
				return
	return ..()

//==============================================================================
// Integrity Bonus
//==============================================================================

/// Recounts living trees within 10 tiles and updates max_integrity.
/// Qualifying trees: /obj/structure/flora/newtree (not burnt) and
/// /obj/structure/flora/roguetree (not wise, burnt, or stump subtypes).
/// Each tree contributes +10 integrity, capped at +200 (20 trees).
/obj/structure/flora/roguetree/wise/sanctified/proc/recalculate_integrity_bonus()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/counted_tree in range(10, src))
		if(!counted_tree.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/counted_tree in range(10, src))
		if(istype(counted_tree, /obj/structure/flora/roguetree/wise))
			continue  // exclude wise and sanctified subtypes
		if(istype(counted_tree, /obj/structure/flora/roguetree/burnt))
			continue
		if(istype(counted_tree, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	var/new_bonus = min(tree_count * 10, 200)
	if(new_bonus == integrity_bonus)
		return
	integrity_bonus = new_bonus
	max_integrity = 400 + integrity_bonus
	obj_integrity = min(obj_integrity, max_integrity)

//==============================================================================
// Sanctified Wise Tree
// A sacred (wise) tree blessed by a Dendorite acolyte into a sanctified wise tree.
// Has the slow aura and heal aura active from creation, but cannot receive rituals, soulbind, or officiate weddings.
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified/wise
	name = "sanctified wise tree"
	desc = "An ancient sacred tree directly blessed by a Dendorite acolyte. The Treefather's power flows through its roots — it radiates healing and repels those who would defile the grove — but its deeper mysteries are locked away."
	examine_plays_music = TRUE
	show_ritual_hints = FALSE

/obj/structure/flora/roguetree/wise/sanctified/wise/Initialize(mapload)
	. = ..()
	// Both auras are active from creation — no rituals needed.
	tree_data.has_slow_aura = TRUE
	tree_data.has_heal_aura = TRUE
	// Replace the standard golden glow with the living-light green (normally granted by ritual).
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))

//==============================================================================
// Ritual Framework
//==============================================================================

/// Returns a list of rituals that can be started
/obj/structure/flora/roguetree/wise/sanctified/proc/open_ritual_menu(mob/living/user)
	if(!tree_data)
		return

	if(tree_data.wedding_active)
		// Nature's Union ceremony is active — offer cancellation.
		var/choice = tgui_alert(user, "A Nature's Union wedding ceremony is active at this tree. The Treefather's blessing currently joins two souls.\n\nCancel the wedding ceremony?", "Sanctified Tree", list("Keep Ceremony", "Cancel Ceremony"))
		if(choice == "Cancel Ceremony" && !QDELETED(src) && !QDELETED(user))
			tree_data.wedding_active = FALSE
			tree_data.wedding_officiant_ckey = null
			to_chat(user, span_warning("The wedding ceremony is dissolved. The Treefather withdraws his blessing."))
		return

	if(tree_data.active_ritual)
		// Show progress and only allow cancellation from the amulet menu.
		var/text = "[tree_data.active_ritual.name] is active.\n\nOffer items by clicking the tree while holding them."
		for(var/line in tree_data.active_ritual.get_plaintext_examine())
			text += "[line]"
		text += "<br>Cancel this ritual?"
		var/choice = tgui_alert(user, text, "Sanctified Tree", list("Keep Ritual", "Cancel Ritual"))
		if(choice != "Cancel Ritual" || QDELETED(src) || QDELETED(user))
			return
		cancel_ritual(user)
		return

	// No active ritual, so let's start one
	var/list/possible_rituals = list()
	var/list/ritual_names = list()
	for(var/datum/druid_ritual/new_ritual as anything in subtypesof(/datum/druid_ritual))
		new_ritual = new new_ritual
		if(!new_ritual.can_see_ritual(user))
			continue
		if(new_ritual.unique_tree_rite && (locate(new_ritual) in tree_data.rituals_completed))
			new_ritual.name = "[new_ritual.name] (Completed)"
		possible_rituals += new_ritual.name
		ritual_names[new_ritual.name] = new_ritual

	var/choice = tgui_input_list(user, "Choose a ritual to perform:", "Sanctified Tree Rituals", possible_rituals)
	var/datum/druid_ritual/selected_ritual = ritual_names[choice]
	if(isnull(selected_ritual) || QDELETED(src) || QDELETED(user))
		return

	if(!selected_ritual.can_start_ritual(user))
		to_chat(user, span_info("That ritual has already been completed on this tree and cannot be repeated."))
		return

	selected_ritual.prepare_tracker()
	if(!confirm_start_ritual(user, selected_ritual))
		return
	tree_data.active_ritual = selected_ritual
	selected_ritual.ritual_holder = tree_data
	to_chat(user, span_notice("I begin the ritual. Offer items by clicking the tree while holding them. Use the amulet only if I need to cancel."))

/obj/structure/flora/roguetree/wise/sanctified/proc/confirm_start_ritual(mob/living/user, datum/druid_ritual/selected_ritual)
	var/text = "Begin [selected_ritual.name]?\n\nRequired offerings:"
	for(var/line in selected_ritual.get_plaintext_examine())
		text += "\n[line]"
	var/choice = tgui_alert(user, text, "Sanctified Tree Bounty", list("Begin", "Cancel"))
	return (choice == "Begin")

/obj/structure/flora/roguetree/wise/sanctified/proc/offer_item(mob/living/user)
	if(!tree_data?.active_ritual)
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I am not holding anything to offer."))
		return FALSE

	// Support taking items from a held storage container (sack, satchel, bag).
	if(held.GetComponent(/datum/component/storage))
		// Bulk mode: for every unfulfilled key, drain all matching items from the sack at once.
		var/any_taken = FALSE
		// Snapshot contents so deletions during iteration are safe.
		var/list/sack_contents = held.contents.Copy()
		for(var/obj/item/sack_item in sack_contents)
			if(tree_data.active_ritual.accept_offering(sack_item, user, silent = TRUE))
				any_taken = TRUE
		if(!any_taken)
			to_chat(user, span_warning("The tree does not need anything from that container right now."))
			return FALSE
		playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
		tree_data.active_ritual.check_ritual_complete(user)
		return TRUE

	if(tree_data.active_ritual.accept_offering(held, user, silent = FALSE))
		tree_data.active_ritual.check_ritual_complete(user)
		return TRUE
	return FALSE



/*
/obj/structure/flora/roguetree/wise/sanctified/proc/consume_offering(key, obj/item/held, mob/living/user)
	switch(key)
		if("druid_armor")
			// Move armor to tree's turf and store reference for transmutation.
			held.forceMove(get_turf(src))
			tree_data.ritual_armor = held
		if("holy_water_container")
			// Drain blessed water but leave the container.
			held.reagents.remove_reagent(/datum/reagent/water/blessed, 30)
		if("bloomstone")
			// Force the bloomstone to drain all charges so Destroy() actually deletes it.
			held.forceMove(get_turf(src))
			var/obj/item/alch/bloomstone/offered = held
			offered.charges = 1
			qdel(offered)
		else
			qdel(held)
*/

/obj/structure/flora/roguetree/wise/sanctified/proc/cancel_ritual(mob/living/user)
	if(!tree_data?.active_ritual)
		return
	if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
		tree_data.ritual_armor.forceMove(get_turf(user))
		to_chat(user, span_notice("The offered armor returns to my feet."))
		tree_data.ritual_armor = null
	to_chat(user, span_warning("I cancel the [tree_data.active_ritual.name] ritual. All progress is lost."))
	tree_data.active_ritual = null

/datum/druid_ritual
	abstract_type = /datum/druid_ritual
	/// Reference to the tree that this ritual is a part of
	var/datum/sanctified_tree_data/ritual_holder
	/// Name of the ritual, how it shows up in the UI
	var/name = "Abstract Ritual"
	/// Tier of the ritual, you need equal or greater skill to be elligible to start/complete the ritual
	var/druid_ritual_tier = SKILL_LEVEL_NONE
	/// How much XP the ritual gives upon completion
	var/experience_payout = 0
	/// TRUE if the ritual is once-per-tree
	var/unique_tree_rite = FALSE // Repeatable rituals by default
	/// If the rite isn't repeatable, mark as completed
	var/rite_completed = FALSE

	/// Spell this ritual grants on completion
	var/granted_spell

	/// Assoc list of [typepaths we need] to [amount needed].
	/// If one of the items in the list is a list, it's treated as 'any of these items will work'
	var/list/specific_offerings

	//---- If specific_offerings isn't set, we have to handle things on a more specific basis
	/// List of types that this ritual can accept
	var/list/elligible_offerings
	/// Amount of offerings needed
	var/required_amount
	/// What this ritual will ask for when starting the ritual
	var/offering_description

	/// List that keeps track of how many offerings we've already given to the tree
	var/list/offering_tracker

/// Checks what rituals the user is able to see, used to build the list to display to the user
/datum/druid_ritual/proc/can_see_ritual(mob/druid)
	if(!druid.mind)
		return FALSE
	var/druidic_level = druid.get_skill_level(/datum/skill/magic/druidic)
	if(druidic_level >= druid_ritual_tier)
		return TRUE
	return FALSE

/// Checks if the user is elligible to even start the ritual. Returns TRUE if elligible
/datum/druid_ritual/proc/can_start_ritual(mob/druid)
	if(!druid.mind)
		return FALSE
	if(unique_tree_rite && rite_completed)
		return FALSE
	var/druidic_level = druid.get_skill_level(/datum/skill/magic/druidic)
	if(druidic_level < druid_ritual_tier)
		return FALSE
	if(granted_spell)
		if(locate(granted_spell) in druid.mind.spell_list)
			to_chat(druid, span_warning("The Treefather's floral gift is already within me — I cannot receive this blessing twice."))
			return FALSE
	return TRUE

/// Copies our list of requirements once the ritual actually begins
/datum/druid_ritual/proc/prepare_tracker()
	offering_tracker = list()
	if(!isnull(specific_offerings))
		offering_tracker = specific_offerings.Copy()
		return
	if(!isnull(elligible_offerings))
		offering_tracker = 0

/// Checks if the item offered to the tree meets our criteria. Returns TRUE if the item is accepted and consumed
/datum/druid_ritual/proc/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			if(islist(key)) // If it's a list, check if it matches something in the list
				if(!is_type_in_list(offering, key))
					continue
				else if(offering_tracker[key] <= 0) // Found in the list, check if it's needed
					if(!silent)
						to_chat(user, span_warning("The tree does not need [offering.name] right now."))
					return FALSE
			else if(istype(offering, key)) // Key isn't a list, check if the type matches directly
				if(offering_tracker[key] <= 0)
					if(!silent)
						to_chat(user, span_warning("The tree does not need [offering.name] right now."))
					return FALSE
			else
				continue // Not a key list and doesn't match a type
			// Ok, we found the item in our list, now we can track it and delete the item
			offering_tracker[key]--
			qdel(offering)
			if(!silent)
				playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
			return TRUE
	if(!isnull(elligible_offerings)) // Most of these lists will have custom handling, this just covers the generic case
		for(var/key in offering_tracker)
			if(islist(key))
				if(!is_type_in_list(offering, key))
					continue
				else if(offering_tracker[key] <= 0) // Found in the list, check if it's needed
					if(!silent)
						to_chat(user, span_warning("The tree does not need [offering.name] right now."))
					return FALSE

			else if(istype(offering, key))
				if(offering_tracker[key] <= 0)
					if(!silent)
						to_chat(user, span_warning("The tree does not need [offering.name] right now."))
					return FALSE
			else
				continue // No matches
			// Ok, we found the item in our list, now we can track it and delete the item
			offering_tracker[key]++
			qdel(offering)
			if(!silent)
				playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
			return TRUE
	return FALSE

/// Checks if all the criteria are fulfilled, and calls on_complete once elligible
/datum/druid_ritual/proc/check_ritual_complete(mob/living/user)
	for(var/key in offering_tracker)
		if(offering_tracker[key] > 0)
			return FALSE // Unfulfilled requirement
	on_complete(user)

/// Grants rewards when the ritual is completed
/datum/druid_ritual/proc/on_complete(mob/living/user)
	playsound(get_turf(user), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	user.visible_message(span_green("The [name] blazes with golden light as [user.name] completes a sacred ritual!"))
	ritual_holder.rituals_completed |= src
	ritual_holder.active_ritual = null
	if(experience_payout > 0 && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, experience_payout)
	on_complete_rewards(user) // Per ritual custom rewards
	return

/// Pays out ritual-specific rewards
/datum/druid_ritual/proc/on_complete_rewards(mob/living/user)
	return

/// Returns the current ritual progress
/datum/druid_ritual/proc/get_ritual_examine()
	var/list/examine_list = list()
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			var/target = specific_offerings[key] // Maximum amount
			var/current = target - offering_tracker[key] // Copy list means ex: 10 - 10 = 0 contributed
			var/english_text

			if(islist(key))
				var/list/key_list = key
				var/list/key_text_list = list()
				for(var/atom/possible_type as anything in key_list)
					key_text_list += "[initial(possible_type.name)]"
				english_text = english_list(key_text_list, and_text = " or ")

			else
				var/atom/key_atom = key
				english_text = initial(key_atom.name)

			if(current >= target)
				examine_list += span_notice("[english_text]: [current]/[target] (fulfilled)<br>")
			else
				examine_list += span_warning("[english_text]: [current]/[target]<br>")
	return examine_list.Join()

/// Returns the current ritual progress but in plaintext
/datum/druid_ritual/proc/get_plaintext_examine()
	var/list/examine_list = list()
	if(!isnull(specific_offerings))
		for(var/key in offering_tracker)
			var/target = specific_offerings[key] // Maximum amount
			var/current = target - offering_tracker[key] // Copy list means ex: 10 - 10 = 0 contributed
			var/english_text

			if(islist(key))
				var/list/key_list = key
				var/list/key_text_list = list()
				for(var/atom/possible_type as anything in key_list)
					key_text_list += "[initial(possible_type.name)]"
				english_text = english_list(key_text_list, and_text = " or ")

			else
				var/atom/key_atom = key
				english_text = initial(key_atom.name)

			if(current >= target)
				examine_list += "[english_text]: [current]/[target] (fulfilled)"
			else
				examine_list += "[english_text]: [current]/[target]"
	return examine_list

//--- DENDORS HARVEST
/datum/druid_ritual/dendors_harvest
	name = "Dendor's Harvest"
	experience_payout = 5
	druid_ritual_tier = SKILL_LEVEL_NONE // Starting point
	required_amount = 6
	offering_description = "any fresh or rotten produce"
	/// Static list of produce
	var/static/list/produce_subtypes = subtypesof(/obj/item/reagent_containers/food/snacks/grown)
	/// If the ritual was only satisfied with berries, it's an alternate payout
	var/berries_only = TRUE

/datum/druid_ritual/dendors_harvest/New()
	. = ..()
	elligible_offerings = produce_subtypes.Copy()
	elligible_offerings |= /obj/item/natural/shellplant/pumpkin

/datum/druid_ritual/dendors_harvest/prepare_tracker()
	offering_tracker = list("food_item" = required_amount)

/datum/druid_ritual/dendors_harvest/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(offering_tracker["food_item"] <= 0)
		return
	if(!is_type_in_list(offering, elligible_offerings))
		return FALSE
	if(!istype(offering, /obj/item/reagent_containers/food/snacks/grown/berries))
		berries_only = FALSE
	offering_tracker["food_item"]--
	qdel(offering)
	if(!silent)
		playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
	return TRUE

/datum/druid_ritual/dendors_harvest/check_ritual_complete(mob/living/user)
	if(offering_tracker["food_item"] <= 0)
		on_complete(user)

/datum/druid_ritual/dendors_harvest/get_ritual_examine()
	return span_warning("Grown Produce: [(required_amount - offering_tracker["food_item"])]/[required_amount]<br>")

/datum/druid_ritual/dendors_harvest/get_plaintext_examine()
	var/list/examine_list = list()
	examine_list += "Grown Produce: [(required_amount - offering_tracker["food_item"])]/[required_amount]"
	return examine_list

/// Dendor's Harvest: seed bounty (repeatable).
/// Offerings: 6 any fruit/grain/vegetable food items (rotten okay).
/// Reward (normal): 1 random misc seed + 1 tree seed (5% sakura, 10% pine, 85% regular).
/// Reward (berry special case, all 5 berries): 1 wild bush seed + 50% chance flower seed.
/datum/druid_ritual/dendors_harvest/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	if(berries_only)
		// Berry special case: all offerings were berries → wild thorny berry hedge seed + possible flower
		new /obj/item/seeds/bush(user_turf)
		if(prob(50))
			new /obj/item/seeds/flower(user_turf)
		to_chat(user, span_green("The roots twist with thorny energy — a wild hedge sapling seed tumbles forth."))
		return
	// Normal reward: 1 misc seed from Dendor's garden + 1 tree seed
	var/misc = pickweight(list(
		/obj/item/seeds/tea                          = 10,
		/obj/item/seeds/coffee                       = 10,
		/obj/item/herbseed/manabloom                 = 8,
		/obj/item/seeds/swampweed                    = 8,
		/obj/item/seeds/apple                        = 6,
		/obj/item/seeds/pear                         = 6,
		/obj/item/seeds/plum                         = 6,
		/obj/item/seeds/strawberry                   = 5,
		/obj/item/seeds/blackberry                   = 5,
		/obj/item/seeds/raspberry                    = 5,
		/obj/item/seeds/tomato                       = 5,
		/obj/item/seeds/potato                       = 5,
		/obj/item/seeds/onion                        = 5,
		/obj/item/seeds/cabbage                      = 5,
		/obj/item/seeds/wheat                        = 5,
		/obj/item/seeds/garlick                      = 5,
		/obj/item/seeds/turnip                       = 5,
		/obj/item/seeds/rice                         = 5,
		/obj/item/seeds/cucumber                     = 5,
		/obj/item/seeds/eggplant                     = 5,
		/obj/item/seeds/carrot                       = 5,
		/obj/item/seeds/wheat/oat                    = 5,
		/obj/item/seeds/sugarcane                    = 4,
		/obj/item/seeds/poppy                        = 4,
		/obj/item/seeds/nut                          = 4,
		/obj/item/seeds/lemon                        = 4,
		/obj/item/seeds/lime                         = 4,
		/obj/item/seeds/tangerine                    = 4,
		/obj/item/seeds/pumpkin                      = 3,
		/obj/item/seeds/berryrogue                   = 3
	))
	new misc(user_turf)
	// Tree seed: 5% sakura, 10% pine, 85% regular
	var/tree_type = pickweight(list(
		/obj/item/seeds/treesap/sakura = 5,
		/obj/item/seeds/treesap/pine   = 10,
		/obj/item/seeds/treesap        = 85
	))
	new tree_type(user_turf)
	to_chat(user, span_green("Seeds tumble from the roots — Dendor's harvest is generous."))

//--- NATURES UNION (Marriage ritual)
/datum/druid_ritual/natures_union
	name = "Nature's Union"
	experience_payout = 25
	druid_ritual_tier = SKILL_LEVEL_NOVICE
	specific_offerings = list(/obj/item/clothing/head/peaceflower = 1)
	offering_description = "Eoran peace flower"

/// Nature's Union: begins a wedding ceremony (repeatable).
/// Offering: 1 eoran peace flower. The betrothed must each bite the same apple,
/// then offer it to the tree to complete the pact.
/datum/druid_ritual/natures_union/on_complete_rewards(mob/living/user)
	if(ritual_holder.wedding_active)
		to_chat(user, span_warning("A wedding ceremony is already being held at this tree."))
		return
	ritual_holder.wedding_active = TRUE
	ritual_holder.wedding_officiant_ckey = user.ckey
	user.visible_message(span_green("A peace flower drifts to the roots of [ritual_holder.tree.name] — the blessings of Dendor and Eora are invoked. Two souls may now offer their bitten apple to be wed beneath this tree."))
	to_chat(user, span_notice("The ceremony has begun. Both partners should bite the same apple once each, then hand it to the tree to be wed. The one handing the apple over will decide the surname."))

//---- FLORAL CONJURATION
/datum/druid_ritual/floral_conjuration
	name = "Floral Conjuration"
	unique_tree_rite = TRUE // One spell per tree
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_NOVICE
	specific_offerings = list(
		/obj/item/alch/atropa = 1,
		/obj/item/alch/matricaria = 1,
		/obj/item/alch/symphitum = 1,
		/obj/item/alch/taraxacum = 1,
		/obj/item/alch/euphrasia = 1,
		/obj/item/alch/paris = 1,
		/obj/item/alch/calendula = 1,
		/obj/item/alch/mentha = 1,
		/obj/item/alch/urtica = 1,
		/obj/item/alch/salvia = 1,
		/obj/item/alch/hypericum = 1,
		/obj/item/alch/benedictus = 1,
		/obj/item/alch/valeriana = 1,
		/obj/item/alch/artemisia = 1,
		/obj/item/alch/rosa = 1,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
	)
	offering_description = "One of every herb"
	granted_spell = /obj/effect/proc_holder/spell/self/conjure_floral_seed

/// Floral Conjuration: grants the Conjure Floral Seed spell (once per tree, once per person).
/// Offerings: one of every herb (atropa through rosa, 15 total).
/datum/druid_ritual/floral_conjuration/on_complete_rewards(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, span_warning("Only a humanoid may receive the Treefather's floral gift."))
		return
	if(!user.mind)
		return
	// Once-per-person: don't grant the spell if they already have it.
	for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/floral_spell in user.mind.spell_list)
		to_chat(user, span_warning("I already know how to conjure floral seeds — this blessing cannot be received twice."))
		return
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_floral_seed)
	to_chat(user, span_green("The knowledge of Floral Conjuration flows into my mind — I can call seeds forth with the Treefather's power."))

//---- FUNGAL VIGIL
/datum/druid_ritual/fungal_vigil
	name = "Fungal Vigil"
	experience_payout = 25
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/reagent_containers/food/snacks/grown/manabloom, /obj/item/magic/manacrystal) = 10
	)
	offering_description = "Mana bloom OR Crystalized Mana"

/// Fungal Vigil: kneestinger ring + 30-min vigil buff to nearby mobs (repeatable).
/// Offerings: 10 mana blooms OR crystalized mana.
/// Buff: longstrider + +2 Perception + +1 Speed + kneestinger immunity, 30 minutes.
/datum/druid_ritual/fungal_vigil/on_complete_rewards(mob/living/user)
	var/turf/spawn_turf = get_turf(ritual_holder.tree)
	// Plant kneestingers in the 4 cardinal directions around the tree.
	for(var/cardinal_direction in GLOB.cardinals)
		var/turf/adj = get_step(spawn_turf, cardinal_direction)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	// Buff nearby non-dead pantheon followers except excluded patrons.
	for(var/mob/living/carbon/human/follower in range(6, ritual_holder.tree))
		if(!is_valid_vigil_follower(follower))
			continue
		if(follower.stat == DEAD)
			continue
		if(follower.patron?.type == /datum/patron/divine/dendor)
			follower.apply_status_effect(/datum/status_effect/buff/dendor_vigil/dendorite)
		else
			follower.apply_status_effect(/datum/status_effect/buff/dendor_vigil)
	to_chat(user, span_green("Kneestingers erupt in a ring — the Treefather's vigil strengthens his faithful."))

/datum/druid_ritual/fungal_vigil/proc/is_valid_vigil_follower(mob/living/carbon/human/follower)
	if(!follower)
		return FALSE
	// Psydon followers have no patron datum — identified by trait.
	if(HAS_TRAIT(follower, TRAIT_PSYDONITE))
		return FALSE
	// Old-god worshippers and all inhumen (Zizo, Baotha, Graggar, Matthios) patrons are excluded.
	if(istype(follower.patron, /datum/patron/old_god))
		return FALSE
	if(istype(follower.patron, /datum/patron/inhumen))
		return FALSE
	return TRUE

//==============================================================================
// Dendor's Vigil Status Effect (applied by Fungal Vigil)
//==============================================================================

/atom/movable/screen/alert/status_effect/buff/dendor_vigil
	name = "Dendor's Vigil"
	desc = "The Treefather's blessing quickens my steps and wards me against natural obstacles."
	icon_state = "buff"

/datum/status_effect/buff/dendor_vigil
	id = "dendor_vigil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_vigil
	effectedstats = list("perception" = 2, "speed" = 1)
	duration = 30 MINUTES

/datum/status_effect/buff/dendor_vigil/dendorite
	effectedstats = list("perception" = 2, "speed" = 2, "willpower" = 1)

/datum/status_effect/buff/dendor_vigil/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_green("The Treefather's vigil embraces me — my steps are swift and the thorns will not bite."))

/datum/status_effect/buff/dendor_vigil/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_warning("The Treefather's vigil fades from me."))

//---- LIVING LIGHT
/datum/druid_ritual/living_light
	name = "Living Light"
	unique_tree_rite = TRUE // Provides an AOE heal aura
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/alch/sinew, /obj/item/alch/viscera, /obj/item/alch/bonemeal, /obj/item/skull) = 10,
		/obj/item/ash = 10,
		/obj/item/compost = 10,
	)

/// Living Light: passive healing aura + middle-click manual heal (once per tree).
/// Offerings: 10 mixed sinew/viscera/tailbone/bone/skull + 10 ash + 10 compost.
/// Aura: wide green glow, periodic healing for Dendor followers.
/datum/druid_ritual/living_light/on_complete_rewards(mob/living/user)
	ritual_holder.has_heal_aura = TRUE
	ritual_holder.tree.set_light(5, 5, 5, l_color = "#44AA44")
	ritual_holder.tree.add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	ritual_holder.tree.visible_message(span_green("A warm green aura blooms from [src.name]. The Treefather's life flows to those who revere him."))

//---- TIMBERS TITHE
/datum/druid_ritual/timbers_tithe
	name = "Timber's Tithe"
	experience_payout = 10
	druid_ritual_tier = SKILL_LEVEL_APPRENTICE
	specific_offerings = list(
		list(/obj/item/seeds/treesap, /obj/structure/tree_sapling) = 5
	)
	offering_description = "Any tree sapling"

// Spawn 2 blessed logs at the player's feet as the Treefather's gift.
/datum/druid_ritual/timbers_tithe/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	for(var/i in 1 to 2)
		var/obj/item/grown/log/tree/log = new(user_turf)
		log.bless_log()
	to_chat(user, span_green("Through the Treefather's power, the tree's limbs shed and regrow, with blessed logs now at my feet."))

//---- TREEFATHERS BULWARK
#define BOULDER_AMOUNT 5
#define STONE_AMOUNT 15

/datum/druid_ritual/treefathers_bulwark
	name = "Treefather's Bulwark"
	unique_tree_rite = TRUE // Increases integrity
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_JOURNEYMAN
	elligible_offerings = list(
		/obj/item/natural/rock,
		/obj/item/natural/stone,
	) // Special handling
	offering_description = "Boulders or small stones" // 5 Boulders or 15 Stones

/datum/druid_ritual/treefathers_bulwark/prepare_tracker()
	offering_tracker = list(
		/obj/item/natural/rock = BOULDER_AMOUNT,
		/obj/item/natural/stone = STONE_AMOUNT
	)

/datum/druid_ritual/treefathers_bulwark/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(offering_tracker[offering.type] <= 0)
		return
	if(!is_type_in_list(offering, elligible_offerings))
		return FALSE
	offering_tracker[offering.type]--
	if(!silent)
		playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
	qdel(offering)
	return TRUE

/datum/druid_ritual/treefathers_bulwark/check_ritual_complete(mob/living/user)
	for(var/key in offering_tracker)
		if(offering_tracker[key] <= 0) // First one to hit 0 marks as complete
			on_complete(user)
			break

/datum/druid_ritual/treefathers_bulwark/get_ritual_examine()
	var/list/examine_list = list()
	examine_list += span_warning("Boulders: [(BOULDER_AMOUNT - offering_tracker[/obj/item/natural/rock])]/[BOULDER_AMOUNT]<br>")
	examine_list += span_warning("OR")
	examine_list += span_warning("Stones: [(STONE_AMOUNT - offering_tracker[/obj/item/natural/stone])]/[STONE_AMOUNT]<br>")

	return examine_list.Join()

/datum/druid_ritual/treefathers_bulwark/get_plaintext_examine()
	var/list/examine_list = list()
	examine_list += "Boulders: [(BOULDER_AMOUNT - offering_tracker[/obj/item/natural/rock])]/[BOULDER_AMOUNT]"
	examine_list += "OR"
	examine_list += "Stones: [(STONE_AMOUNT - offering_tracker[/obj/item/natural/stone])]/[STONE_AMOUNT]"
	return examine_list

/// Treefather's Bulwark: slow aura + integrity boost (once per tree).
/// Offerings: 5 enchanted stones (magic_power 5+) OR boulders.
/// Reward: +100 integrity, -4 speed debuff aura to non-Dendor mobs within 5 tiles.
/datum/druid_ritual/treefathers_bulwark/on_complete_rewards(mob/living/user)
	ritual_holder.has_slow_aura = TRUE
	ritual_holder.tree.max_integrity += 100
	ritual_holder.tree.obj_integrity = min(ritual_holder.tree.obj_integrity + 100, ritual_holder.tree.max_integrity)
	ritual_holder.tree.visible_message(span_green("The bark of [ritual_holder.tree.name] hardens like ironwood. A silent ward settles around the tree — those who would defile it will find their feet heavy."))

#undef BOULDER_AMOUNT
#undef STONE_AMOUNT

//---- Soulbind
/datum/druid_ritual/soulbind
	name = "Soulbind"
	unique_tree_rite = TRUE // You can only soulbind to 1 tree. Ever
	experience_payout = 100
	druid_ritual_tier = SKILL_LEVEL_JOURNEYMAN
	specific_offerings = list(
		/obj/item/leechtick_bloated = 1,
		list(/obj/item/natural/bone, /obj/item/alch/bone) = 4,
	)

/datum/druid_ritual/soulbind/on_complete_rewards(mob/living/user)
	. = ..()
	on_soulbind(user)

/// Sets the tree into soulbind-ready state.
/// The player must then attack the tree with harm intent + empty hand + bleeding arm to confirm.
/datum/druid_ritual/soulbind/proc/on_soulbind(mob/living/user)
	if(!istype(user))
		to_chat(user, span_warning("Only a living person may soulbind with this tree."))
		return
	if(user.ckey in ritual_holder.soulbound_players)
		to_chat(user, span_warning("I am already soulbound to this tree."))
		return
	// Check once-per-player: has this player soulbound to any sanctified tree?
	if(HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		to_chat(user, span_userdanger("My soul is already bound to a sanctified tree. I cannot bind twice."))
		return
	ritual_holder.awaiting_soulbind_ckey = user.ckey
	to_chat(user, span_warning("The ritual is set. To complete the soulbind, I must attack this tree with harm intent, my hand empty and my arm bleeding."))

/// Triggered when a player attacks the tree with harm intent + empty hand + bleeding arm.
/obj/structure/flora/roguetree/wise/sanctified/proc/attempt_soulbind(mob/living/carbon/human/user)
	if(!tree_data)
		return
	if(tree_data.awaiting_soulbind_ckey != user.ckey)
		return
	if(HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		to_chat(user, span_userdanger("My soul is already bound — I cannot bind again."))
		return
	if(user.ckey in tree_data.soulbound_players)
		to_chat(user, span_warning("I am already soulbound to this tree."))
		return

	// Check intent
	if(user.used_intent?.type != INTENT_HARM)
		to_chat(user, span_warning("I must punch the tree with my bloodied palm to complete the soulbind."))
		return
	// Check empty active hand
	if(user.get_active_held_item())
		to_chat(user, span_warning("My hand must be empty to complete the soulbind."))
		return
	// Check arm bleeding
	var/obj/item/bodypart/r_arm = user.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
	if(!(r_arm?.get_bleed_rate() > 0) && !(l_arm?.get_bleed_rate() > 0))
		to_chat(user, span_warning("My arm must be bleeding to seal the soulbind in blood."))
		return

	to_chat(user, span_notice("I press my bleeding palm against the sacred bark, binding my soul to the sanctified tree."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(user))
		return
	if(user.ckey in tree_data.soulbound_players || HAS_TRAIT(user, TRAIT_DENDOR_SOULBOUND))
		return

	// Finalize bind
	var/confirm = tgui_alert(user, "You will bind your soul to this sanctified tree. If the tree is destroyed, you will suffer a permanent, irreversible penalty to all your attributes. Proceed?", "Soulbind", list("Yes", "No"))
	if(confirm != "Yes" || QDELETED(src) || QDELETED(user))
		to_chat(user, span_warning("I withdraw from the sacred pact."))
		return

	// 50 brute to active arm
	var/active_zone = user.active_hand_index == 1 ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM
	var/obj/item/bodypart/active_arm = user.get_bodypart(active_zone)
	if(active_arm)
		active_arm.receive_damage(50, 0)
	else
		user.adjustBruteLoss(50, 0)

	// Mark as soulbound
	ADD_TRAIT(user, TRAIT_DENDOR_SOULBOUND, "SOULBIND")
	tree_data.soulbound_players |= user.ckey
	tree_data.awaiting_soulbind_ckey = null

	// Grant soulbind spells
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
	user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad)

	visible_message(span_boldwarning("[user.name]'s hand is pressed against the bark — a flash of gold seals the pact!"))
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	to_chat(user, span_green("My soul is bound to this sanctified tree. Should it fall, a part of me falls with it."))

/// Applies the permanent soulbind-broken debuff to all online soulbound players.
/// Called from Destroy() before tree_data is cleared.
/obj/structure/flora/roguetree/wise/sanctified/proc/curse_soulbound_players()
	for(var/ckey in tree_data.soulbound_players)
		for(var/mob/living/carbon/human/victim in GLOB.alive_mob_list)
			if(victim.ckey != ckey)
				continue
			victim.apply_status_effect(/datum/status_effect/debuff/soulbind_broken)
			victim.add_stress(/datum/stressevent/soulbind_tree_loss)
			REMOVE_TRAIT(victim, TRAIT_DENDOR_SOULBOUND, "SOULBIND")
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
			victim.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad)
			break

// Soulbind Broken Status Effect (permanent, applied on tree destruction)
/datum/status_effect/debuff/soulbind_broken
	id = "soulbind_broken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	effectedstats = list("strength" = -4, "speed" = -4, "perception" = -4, "intelligence" = -4, "constitution" = -4)
	duration = -1

/datum/status_effect/debuff/soulbind_broken/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/soulsteal.ogg', 80, FALSE)
	to_chat(owner, span_userdanger("A piece of my soul has been torn away — my sacred bond is shattered. I am incredibly weakened."))

/atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	name = "Soulbind Broken"
	desc = "A piece of my soul has been torn away — my body and mind are diminished."
	icon_state = "debuff"

/datum/stressevent/soulbind_tree_loss
	timer = 60 MINUTES
	stressadd = 5
	desc = span_boldred("My soulbound tree has fallen. I feel a permanent part of myself torn away.")

//---- Harvest Bloomstone
/datum/druid_ritual/harvest_bloomstone
	name = "Harvest Bloomstone"
	unique_tree_rite = TRUE // One stone per tree
	experience_payout = 50
	druid_ritual_tier = SKILL_LEVEL_EXPERT
	specific_offerings = list(
		/obj/item/natural/rock = 1,
		list(/obj/item/natural/cured/essence, /obj/item/grown/log/tree/small/essence, /obj/item/natural/stone) = 1, //XANTODO Custom handling on the stone
		/obj/item/alch/blessedseedpowder = 1,
	)

/datum/druid_ritual/harvest_bloomstone/accept_offering(obj/item/offering, mob/living/user, silent = FALSE)
	if(istype(offering, /obj/item/natural/stone))
		var/obj/item/natural/stone/offered_stone = offering
		if(offered_stone.magic_power < 5)
			to_chat(user, span_warning("The stone must be at least +5 or more to be accepted by the rite."))
			return FALSE
	return ..()

/// Harvest Bloomstone: a 20-use blessed seed powder stone (once per tree).
/// Offerings: 1 boulder + 1 enchanted stone (magic_power 10+) + 5 blessed seed powders.
/// Requires Expert Druidic Trickery to initiate (gated in open_ritual_menu).
/datum/druid_ritual/harvest_bloomstone/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	var/obj/item/alch/bloomstone/new_stone = new(user_turf)
	user.put_in_hands(new_stone)
	to_chat(user, span_green("The tree's roots cradle a glowing stone — and the Harvest Bloomstone rises to my hand, brimming in energy with the Treefather's blessing."))

//---- Fey Weaving
/datum/druid_ritual/fey_weaving
	name = "Fey Weaving"
	experience_payout = 50
	druid_ritual_tier = SKILL_LEVEL_EXPERT
	specific_offerings = list(
		list(/obj/item/magic/artifact, /obj/item/magic/leyline) = 1,
		/obj/item/alch/blessedseedpowder = 1,
	)

/// mushroom fey circle seeds (repeatable).
/// Offerings: 1 runed artifact or leyline shard + 4 blessed seed powder. Reward: 2 mushroom_fey seeds.
/datum/druid_ritual/fey_weaving/on_complete_rewards(mob/living/user)
	. = ..()
	var/turf/user_turf = get_turf(user)
	new /obj/item/seeds/mushroom_fey(user_turf)
	new /obj/item/seeds/mushroom_fey(user_turf)
	to_chat(user, span_green("Two handfuls of mushroom fey spores rise from the roots — the Treefather rewards your patience."))

/datum/druid_ritual/natures_temper
	name = "Nature's Temper"
	unique_tree_rite = TRUE // Gives an armor set, can't mass print these
	experience_payout = 200
	druid_ritual_tier = SKILL_LEVEL_MASTER
	specific_offerings = list(
		/obj/item/reagent_containers/food/snacks/zizo_bane = 5,
		/obj/item/magic/artifact = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/druid = 1,
		/obj/item/natural/head/volf = 1,
		list(/obj/item/natural/head/honeyspider, /obj/item/natural/head/mirespider) = 1,
		/obj/item/seeds/treesap = 1,
		/obj/item/alch/blessedseedpowder = 1,
		/datum/reagent/water/blessed = 30,
	)

/datum/druid_ritual/natures_temper/accept_offering(obj/item/offering, mob/living/user, silent)
	// Special handling for the armor
	if(istype(offering, /obj/item/clothing/suit/roguetown/armor/leather/druid))
		if(offering_tracker[offering.type] <= 0)
			to_chat(user, span_warning("The tree can only work on one armor at a time."))
			return FALSE
		offering_tracker[offering.type]--
		ritual_holder.ritual_armor = offering
		offering.forceMove(ritual_holder.tree)
		if(!silent)
			playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
		return TRUE
	// Special handling for the blessed water
	if(offering?.reagents?.has_reagent(/datum/reagent/water/blessed))
		if(offering_tracker[/datum/reagent/water/blessed] <= 0)
			to_chat(user, span_warning("The tree has received enough blessed water."))
			return FALSE
		var/amount_removed = offering.reagents.remove_reagent(/datum/reagent/water/blessed, offering_tracker[/datum/reagent/water/blessed])
		offering_tracker[/datum/reagent/water/blessed] -= amount_removed
		if(!silent)
			playsound(get_turf(user), 'sound/magic/churn.ogg', 40, FALSE)
		return TRUE
	return ..() // Everything else should work like normal

/// Nature's Temper: blessed druid armor + possible elven armor piece (once per tree).
/// Offerings: 5 zizo bane + 2 runed artifacts + druid armor + volf head + spider head +
///             tree seed + blessed seed powder + 30+ drams holy water.
/datum/druid_ritual/natures_temper/on_complete_rewards(mob/living/user)
	var/turf/user_turf = get_turf(user)
	if(!ritual_holder.ritual_armor || QDELETED(ritual_holder.ritual_armor))
		to_chat(user, span_warning("The druid armor offering was lost — something disrupted the ritual."))
		return
	// Destroy the offered druid armor.
	qdel(ritual_holder.ritual_armor)
	ritual_holder.ritual_armor = null
	// Yield blessed druid armor (upgraded chest).
	var/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/blessed_armor = new(user_turf)
	to_chat(user, span_green("[blessed_armor.name] rises from the ritual — the Treefather has blessed this armor with living power."))
	// 50% chance: random wood armor piece from elven black oak mercenaries (excluding chest).
	if(prob(50))
		var/list/bonus_pool = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic, /obj/item/clothing/gloves/roguetown/elven_gloves/druidic, /obj/item/clothing/shoes/roguetown/boots/elven_boots/druidic, /obj/item/clothing/cloak/forrestercloak/blessed)
		var/bonus_type = pick(bonus_pool)
		var/obj/item/bonus = new bonus_type(user_turf)
		to_chat(user, span_green("The roots also yield [bonus.name] — an additional gift."))

/datum/druid_ritual/winged_rebirth
	name = "Winged Rebirth"
	unique_tree_rite = TRUE // One unlocked form per tree
	experience_payout = 0 // Need legendary so we don't even bother
	druid_ritual_tier = SKILL_LEVEL_LEGENDARY
	specific_offerings = list(
		/obj/item/natural/feather = 10,
		/obj/item/alch/bonemeal = 10,
		/obj/item/natural/cured/essence = 1,
		/obj/item/alch/bloomstone = 1,
	)

/datum/druid_ritual/winged_rebirth/accept_offering(obj/item/offering, mob/living/user, silent)
	// Special handling, make sure to delete the bloomstone
	if(istype(offering, /obj/item/alch/bloomstone) && (offering_tracker[/obj/item/alch/bloomstone] > 0))
		var/obj/item/alch/bloomstone/bloom_offering = offering
		bloom_offering.charges = 0
	return ..()

/// Winged Rebirth: choose a winged form and add it to Beast Form choices (once per tree).
/// Offerings: 10 feathers, 10 bonedust, 1 essence of wilderness, 1 harvest bloomstone.
/datum/druid_ritual/winged_rebirth/on_complete_rewards(mob/living/carbon/human/user)
	if(!ishuman(user))
		to_chat(user, span_warning("Only a humanoid may receive the Treefather's trickster blessing."))
		return
	if(!user.mind)
		return
	var/obj/effect/proc_holder/spell/self/wildshape/ws = user.mind.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
	if(!ws)
		to_chat(user, span_warning("I need the Beast Form miracle before I can bind a new shape."))
		return

	var/already_has_bat  = (/mob/living/carbon/human/species/wildshape/bat  in ws.possible_shapes)
	var/already_has_crow = (/mob/living/carbon/human/species/wildshape/crow in ws.possible_shapes)
	if(already_has_bat && already_has_crow)
		to_chat(user, span_notice("These winged guises already reside within my soul."))
		return

	if(!already_has_bat)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/bat
	if(!already_has_crow)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/crow
	to_chat(user, span_green("The knowledge of bat and crow forms take root in my soul. I can now call shift into them through Beast Form."))

//==============================================================================
// Aura Procs
//==============================================================================

/// Applies or removes the bulwark slow on non-Dendor mobs within 5 tiles.
/// Called every 5 seconds when has_slow_aura is TRUE.
/// Applies a -4 speed stat debuff via status effect (8-second duration),
/// refreshed each tick so it stays active while in range.
/obj/structure/flora/roguetree/wise/sanctified/proc/update_slow_aura()
	var/list/in_range = list()
	for(var/mob/living/carbon/human/human_in_range in range(5, src))
		if(human_in_range?.patron?.type == /datum/patron/divine/dendor)
			continue
		if(human_in_range.stat != CONSCIOUS || human_in_range.incapacitated())
			continue
		in_range |= human_in_range
	// Remove modifier from mobs that left range or are now Dendor-eligible.
	// Collect removals first — mutating slowed_mobs during iteration skips elements in BYOND.
	var/list/to_remove = list()
	for(var/mob/living/slowed_mob in tree_data.slowed_mobs)
		if(QDELETED(slowed_mob) || !(slowed_mob in in_range))
			continue
		slowed_mob?.remove_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		to_remove += slowed_mob
	tree_data.slowed_mobs -= to_remove
	// Apply/refresh debuff on mobs in range.
	for(var/mob/living/carbon/human/human_in_range in in_range)
		human_in_range.apply_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		tree_data.slowed_mobs |= human_in_range

/// Heals Dendor followers within 5 tiles periodically like a healing miracle.
/// Also heals non-undead animals and lesser dryads in range.
/// Called every 60 seconds when has_heal_aura is TRUE.
/obj/structure/flora/roguetree/wise/sanctified/proc/pulse_heal_aura()
	var/healed_any = FALSE
	for(var/mob/living/carbon/human/human_in_range in range(5, src))
		if(human_in_range.patron?.type != /datum/patron/divine/dendor)
			continue
		if(human_in_range.stat == DEAD)
			continue
		if(human_in_range.has_status_effect(/datum/status_effect/buff/healing))
			continue
		human_in_range.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
		new /obj/effect/temp_visual/heal_rogue(get_turf(human_in_range))
		healed_any = TRUE
	// Also heal non-undead animals and lesser dryads within range.
	for(var/mob/living/simple_animal/animal_in_range in range(5, src))
		if(animal_in_range.mob_biotypes & MOB_UNDEAD)
			continue
		if(animal_in_range.stat == DEAD)
			continue
		if(animal_in_range.has_status_effect(/datum/status_effect/buff/healing))
			continue
		animal_in_range.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
		new /obj/effect/temp_visual/heal_rogue(get_turf(animal_in_range))
		healed_any = TRUE
	if(healed_any)
		playsound(get_turf(src), 'sound/magic/churn.ogg', 30, FALSE)

//==============================================================================
// Middle-Click Manual Heal
//==============================================================================

/// Middle-click handler for cat5 healing aura.
/// Applies a healing miracle to the Dendor follower. Per-player cooldown: 5 seconds after effect ends.
/obj/structure/flora/roguetree/wise/sanctified/MiddleClick(mob/living/carbon/human/user, params)
	if(!tree_data?.has_heal_aura)
		return
	if(!ishuman(user))
		return
	if(user.patron?.type != /datum/patron/divine/dendor)
		return
	if(user.stat != CONSCIOUS || user.incapacitated())
		return
	if(user.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("The Treefather's warmth already flows through me."))
		return
	var/cooldown_until = tree_data.heal_player_cooldowns[user.ckey]
	if(cooldown_until && world.time < cooldown_until)
		to_chat(user, span_warning("The tree's healing has not yet recovered for me — wait a moment."))
		return
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("I must be adjacent to the tree to draw from its power."))
		return
	to_chat(user, span_notice("I press my palms to the sacred bark and channel the Treefather's warmth."))
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(src))
		return
	if(user.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(user, span_warning("The Treefather's warmth already flows through me."))
		return
	user.apply_status_effect(/datum/status_effect/buff/healing, 2.5, FALSE, /datum/patron/divine/dendor)
	new /obj/effect/temp_visual/heal_rogue(get_turf(user))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 50, FALSE)
	to_chat(user, span_green("The Treefather's warmth flows into my wounds."))
	// Per-player cooldown: 5 seconds after the 10-second effect expires
	tree_data.heal_player_cooldowns[user.ckey] = world.time + 15 SECONDS

/// Temporary -4 speed debuff applied by the Treefather's Bulwark aura.
/// Duration is 8 seconds — slightly longer than the 5-second aura tick —
/// so it stays on continuously while the player remains in range.
/datum/status_effect/debuff/sanctified_tree_slow
	id = "sanctified_tree_slow"
	duration = 8 SECONDS
	effectedstats = list("speed" = -4, "strength" = -2)

/datum/status_effect/debuff/sanctified_tree_slow/on_apply()
	. = ..()
	to_chat(owner, span_warning("An oppressive weight and gnarled roots press against my feet near this tree, causing my movement to slow down."))
