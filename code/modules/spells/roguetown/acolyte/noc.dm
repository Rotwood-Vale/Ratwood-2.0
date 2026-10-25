// Noc Spells
// Blindness is a cancerous spells and should not be available to everyone.
// But I am not nuking it from Acolyte yet so it will be unavailable to mage.
// I repathed it to avoid it becoming available to mages again.
/obj/effect/proc_holder/spell/invoked/blindness
	name = "Shroud of Noc"
	desc = "Direct a mote of living darkness to temporarily blind another, restricting their combative skills relative to your faith."
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "nocshroud"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2 // Combat spell
	invocations = list("Noc blinds thee of thy sins!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 15
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/blindness/warscholar // Be very careful who this is given out to, Blindness can be surprisingly strong.
	name = "Arcyne Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another. This imperfect replica of divine magick requires a Naledian Psycross to function."
	invocations = list("Visus discede!")
	devotion_cost = 0
	recharge_time = 25 SECONDS // +10 because improper Naledi imitation
	miracle = FALSE
	req_items = list (/obj/item/clothing/neck/roguetown/psicross/naledi)
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/blindness/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[user] points at [target]'s eyes!"),span_warning("My eyes are covered in darkness!"))
		target.apply_status_effect(/datum/status_effect/debuff/magical_blindness, user.get_skill_level(associated_skill))
		return TRUE
	revert_cast()
	return FALSE

/atom/movable/screen/fullscreen/magical_blindness
	icon_state = "oxydamageoverlay9"
	layer = BLIND_LAYER
	
/datum/status_effect/debuff/magical_blindness
	id = "magic_blind"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/magical_blindness
	duration = 100
	var/effect_strength = 0

/datum/status_effect/debuff/magical_blindness/on_creation(mob/living/new_owner, strength)
	if (isnum(strength))
		effect_strength = strength
		effectedstats = list(STATKEY_PER = -(round(strength / 2)))
		duration = (strength * 3) SECONDS
		new_owner.overlay_fullscreen("magical_blindness", /atom/movable/screen/fullscreen/magical_blindness)
	return ..()

/datum/status_effect/debuff/magical_blindness/on_remove()
	owner.clear_fullscreen("magical_blindness")
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/magical_blindness
	name = "Magically Blinded"
	desc = "A mote of darkness clouds my eyes! It's harder to see, and my weapon strikes are less accurate."

/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "invisibility"
	desc = "Make another (or yourself) invisible for some time. Duration scales with the arcyne skill. Casting, attacking or being attacked will cancel the duration."
	releasedrain = 30
	chargedrain = 5
	chargetime = 5
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	spell_tier = 1
	invocation_type = "none"
	sound = 'sound/misc/fade.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = FALSE
	cost = 3 // Very useful

/obj/effect/proc_holder/spell/invoked/invisibility/miracle
	miracle = TRUE
	desc = "Make another (or yourself) invisible for some time. Duration scales with the holy skill. Casting, attacking or being attacked will cancel the duration."
	devotion_cost = 25
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur = max((5 * (user.get_skill_level(associated_skill))), 5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/self/noc_spell_bundle
	name = "Arcyne Affinity"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "arcyne_affinity"
	desc = "Allows you to learn a spell or two of a certain type once every cycle."
	miracle = TRUE
	devotion_cost = 250
	recharge_time = 40 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/list/chosen_bundles = list() // Tracks which categories have already been granted
	var/list/utility_bundle = list(	//Utility means exactly that. Nothing offensive and nothing that can affect another person negatively, 11 spellpoints total. (Barring Fetch, and technically Create Campfire)
	)
	var/list/offensive_bundle = list(	//This is not meant to make them combat-capable. A weak offensive, and mostly defensive option. 9 spellpoints total.
	)
	var/list/buff_bundle = list(	//Buffs! An Acolyte being a supportive caster is 100% what they already are, so this fits neatly. No debuffs -- every patron already has a plethora of those.
	)

/obj/effect/proc_holder/spell/self/noc_spell_bundle/cast(list/targets, mob/user)
	if(!..())
		return FALSE
	if(!user || !user.mind)
		revert_cast()
		return FALSE
	var/list/available_choices = list("Utility", "Offense", "Buffs")
	for(var/already in chosen_bundles)
		available_choices.Remove(already)
	if(!available_choices.len)
		user.mind.RemoveSpell(src)
		to_chat(user, span_notice("The arcyne knowledge granted by Noc has been fully bestowed."))
		return TRUE
	var/choice = input(user, "What type of spells has Noc blessed you with?", "CHOOSE PATH") as null|anything in available_choices
	if(!choice)
		revert_cast()
		return FALSE
	chosen_bundles += choice
	switch(choice)
		if("Utility")
			if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
				var/secular_diagnose = new /obj/effect/proc_holder/spell/invoked/diagnose/secular
				user.mind?.AddSpell(secular_diagnose)
			add_spells(user, utility_bundle, grant_all = TRUE)
		if("Offense")
			add_spells(user, offensive_bundle, grant_all = TRUE)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		if("Buffs")
			add_spells(user, buff_bundle, choice_count = 4)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
	if(chosen_bundles.len >= 3)
		user.mind.RemoveSpell(src)
		to_chat(user, span_notice("The arcyne knowledge granted by Noc has been fully bestowed."))
	return TRUE

/obj/effect/proc_holder/spell/self/noc_spell_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	if(!user || !user.mind || !islist(spells))
		return
	var/list/available = spells.Copy()
	for(var/spell_type in available)
		var/spell_path = available[spell_type]
		if(!spell_path)
			spell_path = spell_type
		if(!ispath(spell_path, /obj/effect/proc_holder/spell))
			available.Remove(spell_type)
			continue
		if(user.mind.has_spell(spell_path))
			available.Remove(spell_type)
	if(!available.len)
		return
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			if(!available.len)
				break
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in available
			if(isnull(choice))
				break
			var/picked_spell = available[choice]
			if(ispath(picked_spell, /obj/effect/proc_holder/spell) && !user.mind.has_spell(picked_spell))
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user.mind.AddSpell(new_spell)
			choice_count_visual--
			available.Remove(choice)
	else
		for(var/spell_type in available)
			var/spell_path = available[spell_type]
			if(!spell_path)
				spell_path = spell_type
			if(ispath(spell_path, /obj/effect/proc_holder/spell) && !user.mind.has_spell(spell_path))
				var/obj/effect/proc_holder/spell/new_spell = new spell_path
				user.mind.AddSpell(new_spell)

//15 PER peer-ahead.
/obj/effect/proc_holder/spell/invoked/noc_sight
	name = "Noc's Gaze"
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "noc_sight"
	desc = "Peer ahead."
	chargetime = 0
	chargedrain = 0
	clothes_req = FALSE
	recharge_time = 5 SECONDS
	devotion_cost = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Noc guide my gaze.")
	invocation_type = "whisper"
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	miracle = TRUE


//Identical to peering ahead as if you had 15 PER. (the max)
/obj/effect/proc_holder/spell/invoked/noc_sight/cast(list/targets, mob/user)
	if(isturf(targets[1]) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/turf/T = targets[1]
		var/_x = T.x-H.loc.x
		var/_y = T.y-H.loc.y
		var/ttime = 6
		var/dist = get_dist(H, T)
		if(dist > 7 || dist  <= 2)
			return
		H.hide_cone()
		var/offset = 5
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
		animate(H.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
		H.update_cone_show()
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/silence/miracle
	name = "Silence"
	desc = "Shutter voices and empty the air of sound - naught mage-nor-man shall utter a word, be it invocation or insult."
	overlay_state = "silencenoc"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 5 SECONDS
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/zizo_snuff.ogg'
	spell_tier = 0
	invocations = list("Lunaria Silentium!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100 //Doubled devotion cost, because it's essentitally their Ultimate Move
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/silence/miracle/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>The spell fizzles, it won't work on them!</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("The wind in my voice goes still. I can't speak!"))
		var/dur = max((5 * (user.get_skill_level(associated_skill, 5))))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE


/obj/effect/proc_holder/spell/invoked/magicshield
	name = "Moonlit Ward"
	desc = "Wrap a target in a ward of anti-magic."
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "antimagenoc"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 3 SECONDS
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/antimagic.ogg'
	spell_tier = 0
	invocations = list("No spell shall touch thee!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100
	recharge_time = 60 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/magicshield/cast(list/targets, mob/user = usr)
	if(!targets || !length(targets) || !isliving(targets[1]))
		revert_cast()
		return FALSE
	var/mob/living/carbon/target = targets[1]
	if(HAS_TRAIT(target, TRAIT_ANTIMAGIC))
		to_chat(user, span_warning("They are already protected from magic!"))
		revert_cast()
		return FALSE
	ADD_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	target.visible_message(
		span_warning("[user] calls down a ward around [target]!"),
		span_warning("A nullifying force settles over me!")
	)
	var/dur = max((5 * (user.get_skill_level(associated_skill, 5))))
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
	return TRUE
/obj/effect/proc_holder/spell/invoked/magicshield/proc/remove_buff(mob/living/carbon/target)
	if(!target)
		return
	REMOVE_TRAIT(target, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(target, span_warning("The anti-magic ward fades."))

/datum/status_effect/debuff/blindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blindness
	duration = 15 SECONDS
	effectedstats = list(STATKEY_PER = -2)

/datum/status_effect/debuff/blindness/on_apply()
	. = ..()

/datum/status_effect/debuff/blindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/atom/movable/screen/alert/status_effect/debuff/blindness
	name = "Blindness"
	desc = "I see naught but darkness! (-2 PER, vision cone reduced)"

/datum/action/cooldown/spell/noc
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	spell_color = GLOW_COLOR_NOC

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/spellpack
	name = "Arcyne Affinity"
	desc = "Allows you to learn a set of spells. \n \
	<b>MAGISTER</b>: Greater Arcyne Bolt, Arc Bolt, Phase, Message, Campfire \n \
	<b>ENCHANTER</b>: Stygian Efflorescence, Geas, Rune Ward, Forcewall, Blood Rush \n \
	<b>SEER</b>: Attune Giant, Guidance, Attune Haste, Fortitude, Mindlink"
	button_icon_state = "spellpack"
//Magister = Generic magos, low utility mostly damage; Enchanter = Area denial beast, some utility; Seer = Full support with practically 0 offensive capacity.
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/phase,
		/datum/action/cooldown/spell/message,
		/datum/action/cooldown/spell/create_campfire
	)
	var/list/enchanter_bundle = list(
		/datum/action/cooldown/spell/projectile/stygian_efflorescence,
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/touch/rune_ward,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/augment_buff/attune_giant,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/mindlink
	)

/datum/action/cooldown/spell/noc/spellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Magister", "Enchanter", "Seer")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("Magister")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Enchanter")
			add_spells(owner, enchanter_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Seer")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/spellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)

