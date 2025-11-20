/datum/coven/dendor
	name = "Dendor"
	desc = "The Coven of the Treefather, the mad god who broke when PSYDON fell. Once born to tame nature's fury, Dendor became the very beast he sought to control. Vampires of this coven channel his primal madness, becoming apex predators who embody the savage chaos of the untamed wilds."
	power_type = /datum/coven_power/dendor
	max_level = 4
	icon_state = "dendor"
	is_god_coven = TRUE

/datum/coven/dendor/post_gain()
	. = ..()
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.grant_language(/datum/language/beast, TRUE, TRUE)
		to_chat(H, span_notice("The whispers of the wild fill my mind. I can now speak with beasts."))

/datum/coven_power/dendor

// Level 1 - Beast Claws (Basic Power - grants natural weapons)
/datum/coven_power/dendor/beast_claws
	name = "Beast Claws"
	desc = "Your hands transform into deadly claws, natural weapons that rend flesh with savage efficiency. The first step toward embracing the beast within."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 30 SECONDS
	vitae_cost = 20
	duration_length = 120 SECONDS

/datum/coven_power/dendor/beast_claws/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(active)
		deactivate(user)
		return TRUE

	active = TRUE

	// Grant the player a self-toggle spell for wolf claws instead of equipping items directly
	if(user?.mind && !user.mind.has_spell(/obj/effect/proc_holder/spell/self/wolfclaws))
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/wolfclaws)
		to_chat(user, span_notice("I feel primal power course through me... I can now invoke Lupine Claws at will."))
		user.visible_message(span_warning("[user]'s eyes flash with feral instinct."))
	else
		to_chat(user, span_notice("The beast within answers my call."))

	addtimer(CALLBACK(src, PROC_REF(deactivate), user), duration_length)
	return TRUE

/datum/coven_power/dendor/beast_claws/deactivate(atom/target, direct = FALSE)
	. = ..() // Call parent
	if(!active)
		return
	active = FALSE
	var/mob/living/carbon/human/user = owner
	if(user)
		// Remove the granted wolfclaws spell
		if(user.mind)
			user.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/wolfclaws)
		// Clean up any spawned wolf claw items if the spell was left toggled on
		for(var/obj/item/rogueweapon/wolf_claw/W in user)
			user.dropItemToGround(W, TRUE)
			qdel(W)
		to_chat(user, span_warning("The feral edge fades and your claws retract..."))

// Level 2a - FERAL PATH: Predator's Instinct
/datum/coven_power/dendor/predator_instinct
	name = "Predator's Instinct"
	desc = "Embrace the savage hunter within. Your senses sharpen, movements quicken, and prey cannot hide from you. The path of the beast."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS
	vitae_cost = 35
	duration_length = 90 SECONDS

/datum/coven_power/dendor/predator_instinct/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("The hunt begins! I can smell fear, hear heartbeats, taste blood in the air!"))
	user.visible_message(span_danger("[user]'s eyes gleam with predatory hunger!"))
	
	ADD_TRAIT(user, TRAIT_DARKVISION, "predator_instinct")
	user.AddComponent(/datum/component/after_image)
	
	addtimer(CALLBACK(src, PROC_REF(end_instinct), user), duration_length)
	return TRUE

/datum/coven_power/dendor/predator_instinct/proc/end_instinct(mob/living/carbon/human/user)
	active = FALSE
	if(!user)
		return
	REMOVE_TRAIT(user, TRAIT_DARKVISION, "predator_instinct")
	qdel(user.GetComponent(/datum/component/after_image))
	to_chat(user, span_warning("The predatory clarity fades..."))

// Level 2b - NATURE PATH: Nature's Embrace
/datum/coven_power/dendor/natures_embrace
	name = "Nature's Embrace"
	desc = "Find harmony with the natural world. Plants flourish at your touch, and the earth itself mends your wounds. The path of peaceful coexistence."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 5
	cooldown_length = 120 SECONDS
	vitae_cost = 40
	duration_length = 60 SECONDS

/datum/coven_power/dendor/natures_embrace/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("I call upon the Treefather's gentle touch..."))
	user.visible_message(span_green("Plant life flourishes around [user]!"))
	
	// Heal user based on nearby natural elements
	var/heal_amount = 0
	var/list/natural_stuff = list(/obj/structure/flora/roguegrass, /obj/structure/flora/roguetree, 
									/obj/structure/flora/rogueshroom, /obj/structure/soil, 
									/obj/structure/flora/newtree, /obj/structure/flora/tree)
	
	for(var/obj/obj in view(range, user))
		if(obj.type in natural_stuff)
			heal_amount += 5
	
	for(var/obj/structure/flora/roguetree/wise/tree in view(range, user))
		heal_amount += 25
	
	heal_amount = min(heal_amount, 100)
	
	if(heal_amount > 0)
		user.adjustBruteLoss(-heal_amount)
		user.adjustFireLoss(-heal_amount * 0.5)
		user.blood_volume = min(user.blood_volume + 50, BLOOD_VOLUME_NORMAL)
		to_chat(user, span_green("Nature's vitality flows through me! ([heal_amount] health restored)"))
		
		// Create visual effect
		new /obj/effect/temp_visual/heal(get_turf(user), "#00ff00")
		playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
	else
		to_chat(user, span_warning("There is no nature here to draw strength from..."))
		return FALSE
	
	return TRUE

/datum/coven_power/dendor/natures_embrace/proc/remove_embrace(mob/living/carbon/human/user)
	if(!user)
		return

// Level 3a - FERAL PATH: Blood Frenzy
/datum/coven_power/dendor/blood_frenzy
	name = "Blood Frenzy"
	desc = "The scent of blood drives you into a savage frenzy. Each wound you inflict feeds your hunger and fuels your rage, making you deadlier with every strike."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 150 SECONDS
	vitae_cost = 50
	duration_length = 90 SECONDS

/datum/coven_power/dendor/blood_frenzy/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("BLOOD! I MUST HAVE MORE BLOOD!"))
	user.visible_message(span_danger("[user] enters a savage blood frenzy!"))
	
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "blood_frenzy")
	ADD_TRAIT(user, TRAIT_NOMOOD, "blood_frenzy")
	ADD_TRAIT(user, TRAIT_NOPAINSTUN, "blood_frenzy")
	
	user.cmode_music = 'sound/music/combat_weird.ogg'
	
	addtimer(CALLBACK(src, PROC_REF(end_frenzy), user), duration_length)
	return TRUE

/datum/coven_power/dendor/blood_frenzy/proc/end_frenzy(mob/living/carbon/human/user)
	active = FALSE
	if(!user)
		return
	
	to_chat(user, span_warning("The blood frenzy subsides..."))
	user.visible_message(span_notice("[user]'s frenzy ends."))
	
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "blood_frenzy")
	REMOVE_TRAIT(user, TRAIT_NOMOOD, "blood_frenzy")
	REMOVE_TRAIT(user, TRAIT_NOPAINSTUN, "blood_frenzy")

// Level 3b - NATURE PATH: Wild Growth
/datum/coven_power/dendor/wild_growth
	name = "Wild Growth"
	desc = "Channel Dendor's life-giving essence. Summon thorned vines to entangle enemies while healing allies. Nature provides, nature protects."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 7
	cooldown_length = 150 SECONDS
	vitae_cost = 55
	duration_length = 45 SECONDS

/datum/coven_power/dendor/wild_growth/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("The wild grows at my command!"))
	user.visible_message(span_green("Vines and thorns erupt from the ground around [user]!"))
	
	var/turf/center = get_turf(user)
	
	// Create vine zone
	for(var/turf/T in view(range, center))
		// Entangle enemies
		for(var/mob/living/carbon/human/victim in T)
			if(victim == user)
				continue
			if(victim.mind?.has_antag_datum(/datum/antagonist/vampire))
				// Heal vampire allies
				victim.adjustBruteLoss(-25)
				victim.adjustFireLoss(-15)
				to_chat(victim, span_green("Healing vines embrace me!"))
			else
				// Entangle and damage enemies
				victim.Immobilize(30)
				victim.adjustBruteLoss(20)
				to_chat(victim, span_userdanger("Thorned vines wrap around me!"))
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(T)
		
		// Visual effects
		if(prob(30))
			new /obj/effect/temp_visual/heal(T, "#00ff00")
	
	playsound(center, 'sound/magic/churn.ogg', 100, TRUE)
	
	// Sustained healing aura for user
	for(var/i in 1 to 5)
		addtimer(CALLBACK(src, PROC_REF(healing_pulse), user), i * 10 SECONDS)
	
	return TRUE

/datum/coven_power/dendor/wild_growth/proc/healing_pulse(mob/living/carbon/human/user)
	if(!user || user.stat == DEAD)
		return
	user.adjustBruteLoss(-10)
	new /obj/effect/temp_visual/heal(get_turf(user), "#00ff00")

// Level 4 - Beast Form (Ultimate Transformation)
/datum/coven_power/dendor/beast_form
	name = "Beast Form"
	desc = "Surrender fully to the beast. Transform into a monstrous hybrid creature - part vampire, part predator, all savage fury. You become the apex predator."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	vitae_cost = 100
	duration_length = 120 SECONDS
	var/original_name = ""

/datum/coven_power/dendor/beast_form/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	original_name = user.real_name
	
	to_chat(user, span_userdanger("THE BEAST AWAKENS! FLESH TEARS! BONES CRACK! I AM REBORN!"))
	user.visible_message(span_danger("[user]'s body contorts and transforms into a savage beast!"))
	
	// Visual transformation
	user.flash_fullscreen("redflash3")
	playsound(user, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 100, TRUE)
	user.emote("rage", forced = TRUE)
	
	// Apply beast traits (no redundant dendor patron traits)
	ADD_TRAIT(user, TRAIT_STRONGBITE, "beast_form")
	ADD_TRAIT(user, TRAIT_STRONGKICK, "beast_form")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "beast_form")
	ADD_TRAIT(user, TRAIT_NOMOOD, "beast_form")
	ADD_TRAIT(user, TRAIT_NOPAINSTUN, "beast_form")
	ADD_TRAIT(user, TRAIT_DARKVISION, "beast_form")
	ADD_TRAIT(user, TRAIT_NOPAIN, "beast_form")
	
	user.AddComponent(/datum/component/after_image)
	user.set_light(5, 3, "#00ff00")
	
	// Equip beast claws
	user.drop_all_held_items()
	user.put_in_r_hand(new /obj/item/rogueweapon/dendor_claws/greater(user))
	user.put_in_l_hand(new /obj/item/rogueweapon/dendor_claws/greater(user))
	
	// Change name to show beast form
	user.real_name = "Beast [original_name]"
	user.name = user.real_name
	
	user.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	
	// Summon pack companions
	for(var/i in 1 to 3)
		var/turf/T = get_step(user, pick(GLOB.cardinals))
		if(T)
			var/mob/living/simple_animal/hostile/retaliate/rogue/wolf/W = new(T)
			W.faction = user.faction
	
	addtimer(CALLBACK(src, PROC_REF(end_beast_form), user), duration_length)
	return TRUE

/datum/coven_power/dendor/beast_form/proc/end_beast_form(mob/living/carbon/human/user)
	active = FALSE
	if(!user)
		return
	
	to_chat(user, span_warning("The beast retreats... I am myself again."))
	user.visible_message(span_notice("[user] transforms back to their normal form."))
	
	REMOVE_TRAIT(user, TRAIT_STRONGBITE, "beast_form")
	REMOVE_TRAIT(user, TRAIT_STRONGKICK, "beast_form")
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "beast_form")
	REMOVE_TRAIT(user, TRAIT_NOMOOD, "beast_form")
	REMOVE_TRAIT(user, TRAIT_NOPAINSTUN, "beast_form")
	REMOVE_TRAIT(user, TRAIT_DARKVISION, "beast_form")
	REMOVE_TRAIT(user, TRAIT_NOPAIN, "beast_form")
	
	qdel(user.GetComponent(/datum/component/after_image))
	user.set_light(0)
	
	// Remove claws
	for(var/obj/item/rogueweapon/dendor_claws/claws in user)
		qdel(claws)
	
	user.real_name = original_name
	user.name = original_name

// Dendor claw weapons
/obj/item/rogueweapon/dendor_claws
	name = "beast claws"
	desc = "Razor-sharp claws born from embracing the beast within."
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/special/claws.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/claws_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/claws_righthand.dmi'
	icon_state = "claws"
	max_blade_int = 900
	max_integrity = 900
	force = 15
	wdefense = 7
	armor_penetration = 50
	block_chance = 15
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/werewolf)
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL

/obj/item/rogueweapon/dendor_claws/greater
	name = "savage beast claws"
	desc = "Massive, razor-sharp claws from a fully transformed beast. Apex predator incarnate."
	force = 25
	wdefense = 9
	armor_penetration = 80
	block_chance = 20

