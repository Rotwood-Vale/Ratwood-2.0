/*/datum/virtue/combat/tavern_brawler
	name = "Tavern Brawler"
	desc = "I've never met a problem my fists couldn't solve."
	added_traits = list(TRAIT_CIVILIZEDBARBARIAN)*/

/datum/virtue/combat/guarded
	name = "Guarded"
	desc = "I have long kept my true capabilities and vices a secret. Sometimes being deceptively weak can save one's lyfe."
	category = "feats"
	virtue_cost = 10
	custom_text = "Obfuscates information about you from all sorts of effects, including patron abilities & passives, Assess and other virtues."
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/*/datum/virtue/combat/impervious
	name = "Impervious"
	desc = "I've spent years shoring up my weakspots, and have become difficult to wound with critical blows."
	added_traits = list(TRAIT_CRITICAL_RESISTANCE)*/

/datum/virtue/combat/rotcured
	name = "Rotcured"
	desc = "I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe..."
	category = "feats"
	virtue_cost = 2
	custom_text = "Colors your body a distinct, sickly green."
	// below is functionally equivalent to dying and being resurrected via astrata T4 - yep, this is what it gives you.
	added_traits = list(TRAIT_EASYDISMEMBER, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_ZOMBIE_IMMUNE, TRAIT_ROTMAN, TRAIT_SILVER_WEAK)

/datum/virtue/combat/rotcured/apply_to_human(mob/living/carbon/human/recipient)
	recipient.update_body() // applies the rot skin tone stuff

/datum/virtue/combat/dualwielder
	name = "Dual Wielder"
	desc = "Whether it was by the Naledi scholars, Etruscan privateers or even the Kazengan senseis. I've been graced with the knowledge of how to wield two weapons at once."
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_DUALWIELDER)

/datum/virtue/combat/sharp
	name = "Sentinel of Wits"
	desc = "Whether it's by having an annoying sibling that kept prodding me with a stick, or years of study and observation, I've become adept at both parrying and dodging stronger opponents, by learning their moves and studying them."
	category = "feats"
	virtue_cost = 10
	added_traits = list(TRAIT_SENTINELOFWITS)

/datum/virtue/combat/combat_aware
	name = "Combat Aware"
	desc = "The opponent's flick of their wrist. The sound of maille snapping. The desperate breath as the opponent's stamina wanes. All of this is made more clear to you through intuition or experience."
	category = "feats"
	virtue_cost = 10
	custom_text = "Shows a lot more combat information via floating text. Has a toggle."
	added_traits = list(TRAIT_COMBAT_AWARE)

/datum/virtue/combat/combat_aware/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/togglecombatawareness

/datum/virtue/combat/tough_hide
	name = "Natural Armor"
	desc = "Whether by natural means or other means, my skin is strong enough to resist being pierced and cut."
	category = "feats"
	virtue_cost = 5
	custom_text = "This will replace your SHIRT slot with a regenerating, unremoveable armor."

/datum/virtue/combat/tough_hide/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!recipient)
		return

	// Remove whatever shirt they spawned with
	var/obj/item/clothing/shirt = recipient.wear_shirt
	if(shirt)
		qdel(shirt)

	// Equip the skin armor (now nudist-safe, no workarounds needed)
	recipient.equip_to_slot_or_del(
		new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak(recipient),
		SLOT_SHIRT,
		TRUE
	)
	
	if(alert(recipient, "Would you like to change the name or description of your skin?", "TOUGH HIDE", "MAKE IT SO", "I RESCIND") == "MAKE IT SO") // Query user
		addtimer(CALLBACK(src, .proc/customize_skin, recipient), 5 SECONDS)

/datum/virtue/combat/tough_hide/proc/customize_skin(mob/living/carbon/human/recipient)
	var/obj/item/clothing/hide = recipient.wear_shirt
	var/inputty = stripped_input(recipient, "What would you like to name your hide?", "TOUGH HIDE", null, 200)
	if(inputty)
		hide.name = inputty
	inputty = stripped_input(recipient, "How would you describe your hide?", "TOUGH HIDE", null, 200)
	if(inputty)
		hide.desc = inputty
