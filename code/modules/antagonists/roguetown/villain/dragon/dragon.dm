/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor
	slot_flags = null
	name = "dragon scales"
	desc = "an impenetrable coat of greed."
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_DRAGON_STRONG
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 900
	item_flags = DROPDEL
	repair_time = 30 SECONDS
	combat_taggable = TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor/Initialize(mapload)
	. = ..()
	// Dragons don't really get to unequip their scales so they might as well just register it as soon as they get it
	// loc is shitcode here because the scales are created inside the gnoll so we can juse abuse that logic
	RegisterSignal(loc, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by), override = TRUE)
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "HIDE", "#DRAGONED")/// no one should ever see this unless they spawn in dragon hide via the game panel

/datum/antagonist/dragon
	name = "Dragon"
	roundend_category = "Dragons"
	antagpanel_category = "Dragons"
	job_rank = ROLE_DRAGON

/datum/antagonist/dragon/on_gain()
	greet()
	owner.special_role = "Dragon"
	return ..()

/datum/antagonist/dragon/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null

/mob/living/carbon/human/proc/dragon_can_feed_heal()
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/dragon_feed(mob/living/carbon/human/target, healing_amount = 30)
	if(!target)
		return
	if(!dragon_can_feed_heal())
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/gnoll))
			to_chat(src, span_warning("I should not feed on graggarite flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/dragon))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/rogueweapon/werewolf_claw/dragon
	name = "Dragon Claw"
	wdefense = 5
	force = 40
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)

/obj/item/rogueweapon/werewolf_claw/dragon/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/dragon/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

