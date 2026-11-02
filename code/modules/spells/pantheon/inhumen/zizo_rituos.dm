/datum/action/cooldown/spell/zizo
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	spell_color = GLOW_COLOR_ZIZO
	ignore_armor_penalty = TRUE
	attunement_school = null
	primary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_type = SPELL_COST_STAMINA
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	zizo_spell = TRUE
	spell_tier = 0
	point_cost = 0
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

///////////////////
// T3 - Rituos	//
///////////////////
// - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:

// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization (minus head) + MOB_UNDEAD, grants bonechill and raise_deadite. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

//SOEP -- Undeath gets: miracle-raise undead, bone catacalysm + raise deadite + classic undeath traits. Offensive varient w/ silver weakness and stamina-control for functional immortality.
//SOEP -- Progress gets: rapid skill leveling, ability to consume lux into health and stamina, more utility points for casting. Defensive varient w/ focus on talent and assistance.

/datum/action/cooldown/spell/zizo/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	fluff_desc = "The holiest of Zizo's Lesser Works among the Cabal. A rite of surrendering weakness and mortality to embrace your purpose in Her design. Through agony, the faithful offer either mind or flesh, allowing Zizo to strip away mortal frailty and shape them into reflections of her ascension. Some surrender thought for forbidden understanding. Others surrender flesh for the stillness of unlife. Few endure enough to become what She envisioned. When the gifts fade, the faithful are taught only one truth: they have not sacrificed enough."
	button_icon_state = "rituos"
	charge_sound = 'sound/magic/chargingold.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_message = "<font color=red>ZIZO! ZIZO! ZIZO!"
	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 3 MINUTES
	primary_resource_cost = 100
	secondary_resource_cost = 100
	sound = 'sound/magic/swap.ogg'
	var/anti_spam

/datum/action/cooldown/spell/zizo/rituos/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner

	if(anti_spam)
		return TRUE

	anti_spam = TRUE

	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))

	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		anti_spam = FALSE
		return TRUE

	if(user.stat != CONSCIOUS)
		return FALSE

	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))
	user.grant_language(/datum/language/undead)

	if(!src.run_ritual_chant(user, path_choice))
		anti_spam = FALSE
		return TRUE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
		user.visible_message(span_boldwarning("[user]'s prayers are unanswered!"))
		user.mind?.RemoveSpell(src)
		qdel(src)
		anti_spam = FALSE
		return TRUE

	switch(path_choice)
		if("Progress")
			src.apply_progress_path(user)
		if("Unlife")
			src.apply_unlife_path(user)

	user.mind?.RemoveSpell(src)
	qdel(src)
	anti_spam = FALSE
	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/run_ritual_chant(mob/living/carbon/human/user, path_choice)
	var/list/chant_lines

	switch(path_choice)
		if("Progress")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				",w STRIP ME OF STAGNATION AND IGNORANCE!",
				",w BREAK THE CHAINS OF FALSE UNDERSTANDING!",
				",w LET REVELATION FLOOD THIS FRAIL MIND!",
				",w I OFFER THIS MIND TO COMPLETE THY WORK!",
			)

		if("Unlife")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				",w STRIP ME OF MORTALITY'S SHACKLE!",
				",w LET THIS FRAIL MORTALITY FALL AWAY FROM PURPOSE!",
				",w REMAKE ME IN DEATH'S ENDURING IMAGE!",
				",w I OFFER THIS VESSEL TO COMPLETE THY WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		if(path_choice == "Progress")
			user.emote(pick("whimper", "painmoan", "gag", "choke"))
		else
			user.emote(pick("painscream", "superagony", "paincrit", "choke"))
		if(i > 1)
			shake_camera(user, min(i * 2, 3), i)

		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	return TRUE

/datum/action/cooldown/spell/zizo/rituos/proc/apply_progress_path(mob/living/carbon/human/user)
	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]")
		ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]")
		ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]")
		ADD_TRAIT(user, TRAIT_WARLOCK, "[type]")
		ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
		ADD_TRAIT(user, TRAIT_NOWW, "[type]")
		grant_poke_spell_zizo(user)

	user.visible_message(
		span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"),
		span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!")
	)

	to_chat(user, span_purple("You have performed the Rituos to perfection. By all rights, you should now be a full-fledged Magos... and yet..."))
	sleep(30)
	to_chat(user, "<i>...Why do I still struggle to comprehend anything beyond a mere grasp of the arcane? What am I missing?</i>")

/datum/action/cooldown/spell/zizo/rituos/proc/apply_unlife_path(mob/living/carbon/human/user)

	user.mob_biotypes |= MOB_UNDEAD

	ADD_TRAIT(user, TRAIT_NOMOOD, "[type]")
	ADD_TRAIT(user, TRAIT_NOPAIN, "[type]")
	ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]")
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]")
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
	ADD_TRAIT(user, TRAIT_UNLYCKERABLE, "[type]")
	ADD_TRAIT(user, TRAIT_WARLOCK, "[type]")
	ADD_TRAIT(user, TRAIT_NOWW, "[type]")

	for(var/obj/item/bodypart/part in user.bodyparts)
		if(istype(part, /obj/item/bodypart/head))
			continue

		part.skeletonize(FALSE)
		user.update_body_parts()
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
		new /obj/effect/temp_visual/zizorite(get_turf(user))
		sleep(15)

	var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
	playsound(user.loc, 'sound/misc/lava_death.ogg', 100, FALSE)
	torso?.skeletonize(FALSE)

	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(user,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(user)
	user.update_body_parts()

	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

	if(user.mind)
		user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		grant_poke_spell_zizo(user)

	user.visible_message(
		span_boldwarning("[user]'s flesh burns away in necrotic flames, revealing bone beneath as they are consumed by the Lesser Work!"),
		span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!")
	)

	to_chat(user, span_purple("You have performed the Rituos to perfection. You should be a full-fledged Lich by now... and yet..."))
	sleep(30)
	to_chat(user, "<i>...Vestiges of mortality still cling to me...? Why?</i>")
