// Noc Spells
// Blindness is a cancerous spells and should not be available to everyone.
// But I am not nuking it from Acolyte yet so it will be unavailable to mage.
// I repathed it to avoid it becoming available to mages again.
/obj/effect/proc_holder/spell/invoked/blindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another."
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "blindness"
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
	recharge_time = 15 SECONDS
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
		var/strength = min(user.get_skill_level(associated_skill) * 4, 4)
		target.blind_eyes(strength)
		return TRUE
	revert_cast()
	return FALSE

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
	hide_charge_effect = TRUE
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
	desc = "Allows you to learn new spells over time through divine insight."
	miracle = TRUE
	devotion_cost = 250
	recharge_time = 30 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/spells_granted = 0
	var/list/all_spells = list( //A limited list of spells no greater than T2. You cannot get more than 15 spells by round end if you are consistent in learning them
		/obj/effect/proc_holder/spell/invoked/diagnose/secular::name = /obj/effect/proc_holder/spell/invoked/diagnose/secular,
		/obj/effect/proc_holder/spell/self/message::name = /obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/leap::name = /obj/effect/proc_holder/spell/invoked/leap,
		/obj/effect/proc_holder/spell/targeted/touch/lesserknock::name = /obj/effect/proc_holder/spell/targeted/touch/lesserknock,
		/obj/effect/proc_holder/spell/self/light::name = /obj/effect/proc_holder/spell/self/light,
		/obj/effect/proc_holder/spell/invoked/mirror_transform::name = /obj/effect/proc_holder/spell/invoked/mirror_transform,
		/obj/effect/proc_holder/spell/invoked/mending::name = /obj/effect/proc_holder/spell/invoked/mending,
		/obj/effect/proc_holder/spell/invoked/projectile/fetch::name = /obj/effect/proc_holder/spell/invoked/projectile/fetch,
		/obj/effect/proc_holder/spell/invoked/projectile/repel::name = /obj/effect/proc_holder/spell/invoked/projectile/repel,
		/obj/effect/proc_holder/spell/invoked/create_campfire::name = /obj/effect/proc_holder/spell/invoked/create_campfire,
		/obj/effect/proc_holder/spell/invoked/blink::name = /obj/effect/proc_holder/spell/invoked/blink,
		/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt::name = /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt, //Relatively weak compared to all other spells like their holy bolt
		/obj/effect/proc_holder/spell/invoked/projectile/frostbolt::name = /obj/effect/proc_holder/spell/invoked/projectile/frostbolt, //Also weak but it also gives an edge against undead NPCs
		/obj/effect/proc_holder/spell/self/conjure_armor/miracle::name = /obj/effect/proc_holder/spell/self/conjure_armor/miracle,
		/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle::name = /obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle,
		/obj/effect/proc_holder/spell/invoked/wither/miracle::name = /obj/effect/proc_holder/spell/invoked/wither/miracle,
		/obj/effect/proc_holder/spell/invoked/hawks_eyes::name = /obj/effect/proc_holder/spell/invoked/hawks_eyes,
		/obj/effect/proc_holder/spell/invoked/giants_strength::name = /obj/effect/proc_holder/spell/invoked/giants_strength,
		/obj/effect/proc_holder/spell/invoked/longstrider::name = /obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/guidance::name = /obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/haste::name = /obj/effect/proc_holder/spell/invoked/haste,
		/obj/effect/proc_holder/spell/invoked/fortitude::name = /obj/effect/proc_holder/spell/invoked/fortitude
	)

/obj/effect/proc_holder/spell/self/noc_spell_bundle/cast(list/targets, mob/user)
	if(!user?.mind)
		revert_cast()
		return FALSE
	if(spells_granted >= 15)
		user.mind.RemoveSpell(src)
		return FALSE
	var/remaining = add_spells(user, all_spells, choice_count = min(3, 15 - spells_granted))
	if(!remaining || spells_granted >= 15)
		user.mind.RemoveSpell(src)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/noc_spell_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1)
	var/list/available_spells = spells.Copy()
	for(var/spell_name in available_spells.Copy())
		if(user.mind.has_spell(available_spells[spell_name]))
			available_spells.Remove(spell_name)
	var/choice_count_visual = choice_count
	for(var/spell_picker in 1 to choice_count)
		if(!length(available_spells))
			break
		var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in available_spells
		if(isnull(choice))
			break
		var/picked_spell = available_spells[choice]
		if(!user.mind.has_spell(picked_spell))
			var/obj/effect/proc_holder/spell/new_spell = new picked_spell
			user.mind.AddSpell(new_spell, user)
			spells_granted++
			if(istype(new_spell, /obj/effect/proc_holder/spell/self/conjure_armor/miracle))
				ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		available_spells.Remove(choice)
		choice_count_visual--
	return length(available_spells)

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
