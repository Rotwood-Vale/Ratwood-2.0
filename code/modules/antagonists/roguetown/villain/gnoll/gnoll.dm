/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor
	slot_flags = null
	name = "gnoll skin"
	desc = "an impenetrable hide of graggar's fury"
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_GNOLL_STANDARD
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 475
	item_flags = DROPDEL
	repair_time = 14 SECONDS
	combat_taggable = TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/Initialize(mapload)
	. = ..()
	// Gnolls don't really get to unequip their skin so they might as well just register it as soon as they get it
	// loc is shitcode here because the skin is created inside the gnoll so we can juse abuse that logic
	RegisterSignal(loc, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by), override = TRUE)

/datum/antagonist/gnoll
	name = "Gnoll"
	roundend_category = "Gnolls"
	antagpanel_category = "Gnolls"
	job_rank = ROLE_GNOLL
	var/datum/weakref/tracked_target_ref = null

/proc/get_gnoll_tracking_combat_roles()
	var/static/list/combat_roles = list(
		"Orthodoxist" = TRUE,
		"Absolver" = TRUE,
		"Templar" = TRUE,
		"Sergeant" = TRUE,
		"Man at Arms" = TRUE,
		"Knight" = TRUE,
		"Squire" = TRUE,
		"Mercenary" = TRUE,
		"Warden" = TRUE,
		"Acolyte" = TRUE,
		"Vanguard" = TRUE,
		"City Guard" = TRUE,
		"Bandit" = TRUE,
		"Watch Captain" = TRUE,
		"Master Warden" = TRUE,
		"Knight Captain" = TRUE,
		"Inquisitor" = TRUE
	)
	return combat_roles

/datum/antagonist/gnoll/on_gain()
	greet()
	owner.special_role = "Gnoll"

	return ..()

/datum/antagonist/gnoll/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
	tracked_target_ref = null

/datum/antagonist/gnoll/proc/set_tracked_target(mob/living/target)
	if(!target || QDELETED(target) || target.stat == DEAD)
		tracked_target_ref = null
		return

	tracked_target_ref = WEAKREF(target)

/datum/antagonist/gnoll/proc/get_sniff_spell()
	var/mob/living/current_mob = owner?.current
	if(!current_mob)
		return null

	for(var/obj/effect/proc_holder/spell/S as anything in current_mob.mob_spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		return S

	if(current_mob.mind)
		var/obj/effect/proc_holder/spell/mind_spell = current_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/gnoll_sniff)
		if(istype(mind_spell, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			return mind_spell

	return null

/datum/antagonist/gnoll/proc/get_tracked_target()
	var/mob/living/cached_target = tracked_target_ref?.resolve()
	if(cached_target && !QDELETED(cached_target) && cached_target.stat != DEAD)
		return cached_target
	tracked_target_ref = null

	var/mob/living/current_mob = owner?.current
	if(!current_mob)
		return null

	var/list/sniff_spells = list()
	for(var/obj/effect/proc_holder/spell/S as anything in current_mob.mob_spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		if(!(S in sniff_spells))
			sniff_spells += S

	if(current_mob.mind)
		var/obj/effect/proc_holder/spell/mind_sniff_spell = current_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/gnoll_sniff)
		if(istype(mind_sniff_spell, /obj/effect/proc_holder/spell/invoked/gnoll_sniff) && !(mind_sniff_spell in sniff_spells))
			sniff_spells += mind_sniff_spell

	for(var/obj/effect/proc_holder/spell/sniff_spell_candidate as anything in sniff_spells)
		if(!istype(sniff_spell_candidate, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/sniff_spell = sniff_spell_candidate
		var/mob/living/target = sniff_spell.tracked_target_ref?.resolve()
		if(target && sniff_spell.is_valid_hunted(target))
			tracked_target_ref = WEAKREF(target)
			return target

	return null

/datum/antagonist/gnoll/proc/get_tracked_target_source(mob/living/target)
	if(!target)
		return null
	if(target.has_flaw(/datum/charflaw/hunted))
		return "Hunted flaw"
	if(target.job in get_gnoll_tracking_combat_roles())
		return "Combat fallback"
	return "Direct scent"

/datum/antagonist/gnoll/proc/is_examine_marked_target(mob/living/target)
	if(!target)
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted))
		return TRUE
	if(get_tracked_target() != target)
		return FALSE
	return get_tracked_target_source(target) == "Combat fallback"

/datum/antagonist/gnoll/antag_listing_status()
	var/base_status = ..()
	var/mob/living/target = get_tracked_target()
	var/target_display = "None"

	if(target)
		var/source = get_tracked_target_source(target)
		target_display = "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(target)]'>[target.real_name]</a>"
		if(source)
			target_display += " ([source])"

	if(base_status)
		return "[base_status] | Tracked: [target_display]"
	return "Tracked: [target_display]"

/mob/living/carbon/human/proc/gnoll_can_feed_heal()
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/gnoll_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!target)
		return
	if(!gnoll_can_feed_heal())
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/gnoll))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/mob/living/carbon/human/proc/gnoll_bloodpool_feed(healing_amount = 6)
	if(!gnoll_can_feed_heal())
		return FALSE

	to_chat(src, span_warning("I lap from the blood. Through Graggar's grace I am renewed."))
	src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)
	return TRUE

/obj/item/rogueweapon/werewolf_claw/gnoll
	name = "Gnoll Claw"
	// We are smarter, we can use our solid, steel-like claws to defend ourselves.
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)

/obj/item/rogueweapon/werewolf_claw/gnoll/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/datum/intent/simple/werewolf/gnoll
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = "genslash"
	penfactor = 20
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.2

/datum/intent/mace/smash/werewolf/gnoll
	name = "thrash"
	desc = "A powerful smash of savage muscle that deals normal damage, but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	chargetime = 1
	penfactor = 0

/datum/intent/simple/gnoll_cut
	name = "cutting claw"
	hitsound = "genslash"
	penfactor = 60
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	item_d_type = "slash"

/datum/intent/mace/strike/gnoll
	name = "armor rending strike"
	miss_text = "strikes the air!"
	miss_sound = "bluntwooshlarge"
	attack_verb = list("punches", "strikes", "tears")
