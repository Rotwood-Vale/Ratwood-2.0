/obj/effect/proc_holder/spell/self/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	associated_stat = null
	charge_required = TRUE
	charge_time = 50
	click_to_activate = FALSE
	primary_resource_cost = 90
	primary_resource_type = SPELL_COST_STAMINA
	cooldown_time = 5 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/self/rituos/miracle
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 120
	associated_skill = /datum/skill/magic/holy
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 90

	
/obj/effect/proc_holder/spell/self/rituos/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))
	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		return FALSE

	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))

	var/list/chant_lines
	switch(path_choice)
		if("Progress")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				"STRIP ME OF STAGNATION AND IGNORANCE!",
				"I OFFER THIS MIND TO COMPLETE THY WORK!",
			)
		if("Unlife")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				"STRIP ME OF MORTALITY'S SHACKLE!",
				"I OFFER THIS VESSEL TO THY LESSER WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		if(path_choice == "Progress")
			user.emote(pick("whimper", "gasp"))
			user.emote("painscream")
		else
			user.emote("painscream")
		if(i > 1)
			shake_camera(user, i * 2, i)
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	user.grant_language(/datum/language/undead)
	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	switch(path_choice)
		if("Progress")
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"), span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!"))

		if("Unlife")
			user.mob_biotypes |= MOB_UNDEAD
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
			for(var/obj/item/bodypart/part as anything in user.bodyparts)
				if(istype(part, /obj/item/bodypart/head))
					continue
				part.skeletonize(FALSE)
			var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
			torso?.skeletonize(FALSE)
			user.update_body_parts()
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bonechill)
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("[user]'s flesh sloughs away in sheets, revealing bare bone beneath as [user.p_they()] [user.p_are()] consumed by the Lesser Work!"), span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - but death itself answers my call!"))
			to_chat(user, span_small("...what have I done?"))

	user.mind?.RemoveSpell(src)
	qdel(src)
	return TRUE

/obj/effect/proc_holder/spell/self/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)

