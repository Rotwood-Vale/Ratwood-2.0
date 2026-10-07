#define EQUALIZED_GLOW "equalizer glow"

// T0: Determine the net mammon value of target

/obj/effect/proc_holder/spell/invoked/appraise
	name = "Appraise"
	desc = "Tells you how many mammons someone has on them and in the nervelock."
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "appraise"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/appraise/secular
	name = "Secular Appraise"
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "appraise"
	range = 2
	associated_skill = /datum/skill/misc/reading // idk reading is like Accounting right
	miracle = FALSE
	devotion_cost = 0 //Merchants are not clerics


/obj/effect/proc_holder/spell/invoked/appraise/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_DECEIVING_MEEKNESS) && target != user)
			to_chat(user, "<font color='yellow'>I cannot tell...</font>")
			if(prob(50 + ((target.STAPER - 10) * 10)))
				to_chat(target, span_warning("A pair of prying eyes were laid on me..."))
			return
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.get_balance(target)
		var/totalvalue = mammonsinbank + mammonsonperson
		to_chat(user, ("<font color='yellow'>[target] has [mammonsonperson] mammons on them, [mammonsinbank] in their nervelock, for a total of [totalvalue] mammons.</font>"))
// T1 - Take value of item in hand, apply that as healing. Destroys item.

/obj/effect/proc_holder/spell/invoked/transact
	name = "Transact"
	desc = "Sacrifice an item in your hand, applying a heal over time to yourself with strength depending on its value."
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "transact"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 20


/obj/effect/proc_holder/spell/invoked/transact/cast(list/targets, mob/living/user)
	. = ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_info("I need something of value to make a transaction..."))
		return
	var/helditemvalue = held_item.get_real_price()
	if(!helditemvalue)
		to_chat(user, span_info("This has no value, It will be of no use In such a transaction."))
		return
	if(helditemvalue<10)
		to_chat(user, span_info("This has little value, It will be of no use In such a transaction."))
		return
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		user.visible_message(span_notice("The transaction Is made, [target] Is bathed In empowerment!"))
		to_chat(user, "<font color='yellow'>[held_item] burns into the air suddenly, my Transaction is accepted.</font>")
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/datum/status_effect/buff/healing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/healing)
			heal_effect.healing_on_tick = helditemvalue/2
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			qdel(held_item)
		else
			target.adjustBruteLoss(helditemvalue/2)
			target.adjustFireLoss(helditemvalue/2)
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			qdel(held_item)
		return TRUE
	revert_cast()
	return FALSE

// T2 We're going to debuff a targets stats = to the difference between us and them in total stats.

/obj/effect/proc_holder/spell/invoked/equalize
	name = "Equalize"
	desc = "Create equality, with a thumb on the scales, with your target. Siphon strength, speed, and constitution from them."
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "equalize"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/swap.ogg'
	chargedrain = 0
	chargetime = 50
	releasedrain = 60
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 2 MINUTES
	range = 4


/obj/effect/proc_holder/spell/invoked/equalize/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/target = targets[1]
		target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff)
		user.apply_status_effect(/datum/status_effect/buff/equalizebuff)
		return TRUE
	revert_cast()
	return FALSE


// buff
/datum/status_effect/buff/equalizebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = 2, STATKEY_CON = 2, STATKEY_SPD = 2)
	duration = 1 MINUTES
	var/outline_colour = "#FFD700"


/atom/movable/screen/alert/status_effect/buff/equalized
	name = "Equalized"
	desc = "Equalized, with a gentle thumb on the scale, tactfully."

/datum/status_effect/buff/equalizebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/buff/equalizebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>My link wears off, their stolen fire returns to them</font>")


// debuff
/datum/status_effect/debuff/equalizedebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_SPD = -2)
	duration = 1 MINUTES
	var/outline_colour = "#FFD700"

/atom/movable/screen/alert/status_effect/debuff/equalized
	name = "Equalized"
	desc = "My fire is stolen from me!"

/datum/status_effect/debuff/equalizedebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/debuff/equalizedebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>My fire returns to me!</font>")



//T3 COUNT WEALTH, HURT TARGET/APPLY EFFECTS BASED ON AMOUNT OF WEALTH. AT 500+, OLD STYLE CHURNS THE TARGET.

/obj/effect/proc_holder/spell/invoked/churnwealthy
	name = "Churn Wealthy"
	desc = "Attacks the target by weight of their greed, dealing increased damage and effects depending on how wealthy they are."
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "churn_wealthy"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 2 MINUTES
	range = 4


/obj/effect/proc_holder/spell/invoked/churnwealthy/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]

		if(user.z != target.z) //Stopping no-interaction snipes
			to_chat(user, "<font color='yellow'>The Free-God compels me to face [target] on level ground before I transact.</font>")
			revert_cast()
			return
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.bank_accounts[target]
		var/totalvalue = mammonsinbank + mammonsonperson
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			totalvalue += 101 // We're ALWAYS going to do a medium level smite minimum to nobles.
		if(totalvalue <=10)
			to_chat(user, "<font color='yellow'>[target] one has no wealth to hold against them.</font>")
			revert_cast()
			return
		if(totalvalue <=30)
			user.say("Wealth becomes woe!")
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
			target.adjustFireLoss(30)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=60)
			user.say("Wealth becomes woe!")
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
			target.adjustFireLoss(60)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=100)
			user.say("Wealth becomes woe!")
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
			target.adjustFireLoss(80)
			target.Stun(20)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=200)
			user.say("The Free-God rebukes!")
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
			target.adjustFireLoss(100)
			target.adjust_fire_stacks(7, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.Stun(20)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <=500)
			user.say("The Free-God rebukes!")
			target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
			target.adjustFireLoss(120)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			target.Stun(40)
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			return
		if(totalvalue <= 1000)
			target.visible_message(span_danger("[target] is smited with holy light!"), span_userdanger("I feel the weight of my wealth rend my soul apart!"))
			user.say("Your final transaction! The Free-God rebukes!!")
			target.Stun(60)
			target.emote("agony")
			target.adjustFireLoss(140)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			return
		if(totalvalue >=1001) //THE POWER OF MY STAND: 'EXPLODE AND DIE INSTANTLY'
			target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
			user.say("Wealth beyond measure- YOUR FINAL TRANSACTION!!")
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)

			target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))
			playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(user, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)

			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/limb_index in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)

			return

// T3: Rally Matthios' followers around the People's Banner

/obj/effect/proc_holder/spell/invoked/twilight_commieflag
	name = "The People's Banner"
	desc = "Summon a Matthian banner and rally your comrades. While the banner is held, you and nearby allies resist slowdown and gain the will to fight."
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "peoplesbanner"
	invocations = list(
		"Comrades, rally around the standard of the Father of Freedom!",
		"We will wrest our freedom from their cold hands!",
	)
	invocation_type = "shout"
	chargedrain = 0
	chargetime = 2 SECONDS
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeascendant
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 90
	miracle = TRUE
	recharge_time = 5 MINUTES
	sound = list('sound/magic/whiteflame.ogg')
	no_early_release = TRUE
	movement_interrupt = TRUE
	antimagic_allowed = TRUE
	charging_slowdown = 3
	glow_color = "#FFD700"
	glow_intensity = GLOW_INTENSITY_LOW
	conjured_item_glow = "#FFD700"

/obj/effect/proc_holder/spell/invoked/twilight_commieflag/cast(list/targets, mob/living/user = usr)
	if(user.get_num_arms(FALSE) < 1 || (user.get_inactive_held_item() && user.get_active_held_item()))
		to_chat(user, span_notice("I need a free hand to hold the People's Banner!"))
		revert_cast(user)
		return FALSE

	dispel_conjured_item()
	var/obj/item/rogueweapon/spear/matthios_standard/banner = new(user.drop_location())
	user.put_in_hands(banner)
	ADD_TRAIT(banner, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	banner.wdefense += skill
	banner.wdefense_dynamic += skill
	banner.force = min(5 * skill, 20)
	banner.update_force_dynamic()
	set_conjured_item(banner)
	return TRUE

/obj/item/rogueweapon/spear/matthios_standard
	name = "people's banner"
	desc = "The banner of those who stand against tyranny and oppression, bearing the sigil of Matthios, Father of Freedom."
	force = 0
	force_wielded = 0
	wdefense = 1
	possible_item_intents = list(/datum/intent/spear/thrust)
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "matthios_standard"
	resistance_flags = FIRE_PROOF

/obj/item/rogueweapon/spear/matthios_standard/Initialize(mapload)
	. = ..()
	for(var/mob/living/carbon/human/H as anything in SSspatial_grid.orthogonal_range_search(src, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, 7))
		if(get_dist(src, H) > 7)
			continue
		if(istype(H.patron, /datum/patron/inhumen/matthios))
			H.apply_status_effect(/datum/status_effect/buff/twilight_peoplesbanner)
		else
			H.apply_status_effect(/datum/status_effect/debuff/twilight_peoplesbanner)

/obj/item/rogueweapon/spear/matthios_standard/attack_self(mob/living/user)
	to_chat(user, span_notice("You begin dispelling the [src.name]..."))
	if(do_after(user, 3 SECONDS, src))
		qdel(src)

/atom/movable/screen/alert/status_effect/buff/twilight_peoplesbanner
	name = "The People's Banner"
	desc = "The sigil of Matthios inspires me to fight on!"
	icon_state = "peoplesbanner_buff"
	icon = 'icons/mob/actions/matthiosmiracles.dmi'

/datum/status_effect/buff/twilight_peoplesbanner
	id = "twilight_peoplesbanner"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twilight_peoplesbanner
	effectedstats = list(STATKEY_WIL = 3, STATKEY_SPD = 2)
	tick_interval = 5 SECONDS

/datum/status_effect/buff/twilight_peoplesbanner/process()
	. = ..()
	var/preserve = FALSE
	for(var/mob/living/carbon/human/H as anything in SSspatial_grid.orthogonal_range_search(owner, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, 7))
		if(get_dist(owner, H) > 7)
			continue
		if(istype(H.get_inactive_held_item(), /obj/item/rogueweapon/spear/matthios_standard) || istype(H.get_active_held_item(), /obj/item/rogueweapon/spear/matthios_standard))
			preserve = TRUE
			break
	if(!preserve)
		owner.remove_status_effect(/datum/status_effect/buff/twilight_peoplesbanner)

/datum/status_effect/buff/twilight_peoplesbanner/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	owner.add_stress(/datum/stressevent/twilight_peoplesbanner_good)

/datum/status_effect/buff/twilight_peoplesbanner/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	owner.remove_stress(/datum/stressevent/twilight_peoplesbanner_good)

/atom/movable/screen/alert/status_effect/debuff/twilight_peoplesbanner
	name = "The People's Banner"
	desc = "That horrid sigil! How dare they?!"
	icon_state = "peoplesbanner_debuff"
	icon = 'icons/mob/actions/matthiosmiracles.dmi'

/datum/status_effect/debuff/twilight_peoplesbanner
	id = "twilight_peoplesbanner_debuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/twilight_peoplesbanner
	tick_interval = 5 SECONDS

/datum/status_effect/debuff/twilight_peoplesbanner/process()
	. = ..()
	var/preserve = FALSE
	for(var/mob/living/carbon/human/H as anything in SSspatial_grid.orthogonal_range_search(owner, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, 7))
		if(get_dist(owner, H) > 7)
			continue
		if(istype(H.get_inactive_held_item(), /obj/item/rogueweapon/spear/matthios_standard) || istype(H.get_active_held_item(), /obj/item/rogueweapon/spear/matthios_standard))
			preserve = TRUE
			break
	if(!preserve)
		owner.remove_status_effect(/datum/status_effect/debuff/twilight_peoplesbanner)

/datum/status_effect/debuff/twilight_peoplesbanner/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/twilight_peoplesbanner_bad)

/datum/status_effect/debuff/twilight_peoplesbanner/on_remove()
	. = ..()
	owner.remove_stress(/datum/stressevent/twilight_peoplesbanner_bad)

/datum/stressevent/twilight_peoplesbanner_good
	timer = 999 MINUTES
	stressadd = -3
	desc = span_green("The sigil of Matthios inspires me to fight on!")

/datum/stressevent/twilight_peoplesbanner_bad
	timer = 999 MINUTES
	stressadd = 3
	desc = span_red("That horrid sigil! How dare they?!")

// Granted directly to the Iconoclast; this is not part of Matthios' general miracle list.
/obj/effect/proc_holder/spell/invoked/raze
	name = "Raze"
	desc = "Exhale a cone of stolen fyre before you, scorching enemies and igniting the ground. Damage increases with Holy skill. These flames can turn unworthy corpses to ash."
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "breath"
	sound = 'sound/misc/bamf.ogg'
	chargedloop = /datum/looping_sound/invokefire
	recharge_time = 2 MINUTES
	chargedrain = 0
	chargetime = 1 SECONDS
	releasedrain = 30
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 1
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 90
	miracle = TRUE
	range = 3
	var/delay = 12
	var/strike_delay = 2
	var/damage = 20
	var/cone_range = 3

/obj/effect/proc_holder/spell/invoked/raze/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/turf/target_turf = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(!target_turf || !source_turf || target_turf.z != source_turf.z || target_turf == source_turf)
		return FALSE

	var/direction = get_dir(source_turf, target_turf)
	if(!direction)
		return FALSE
	var/left_dir
	var/right_dir
	switch(direction)
		if(NORTH, SOUTH)
			left_dir = WEST
			right_dir = EAST
		if(EAST, WEST)
			left_dir = NORTH
			right_dir = SOUTH
		if(NORTHEAST, SOUTHWEST)
			left_dir = NORTHWEST
			right_dir = SOUTHEAST
		if(NORTHWEST, SOUTHEAST)
			left_dir = NORTHEAST
			right_dir = SOUTHWEST

	for(var/distance in 1 to cone_range)
		var/turf/center = source_turf
		for(var/i in 1 to distance)
			center = get_step(center, direction)
		if(!center)
			continue

		var/list/current_wave = list(center)
		for(var/offset in 1 to distance - 1)
			var/turf/left_turf = center
			var/turf/right_turf = center
			for(var/j in 1 to offset)
				left_turf = get_step(left_turf, left_dir)
				right_turf = get_step(right_turf, right_dir)
			if(left_turf)
				current_wave |= left_turf
			if(right_turf)
				current_wave |= right_turf

		var/tile_delay = delay + (strike_delay * (distance - 1))
		for(var/turf/affected_turf in current_wave)
			if(!(affected_turf in view(source_turf)))
				continue
			new /obj/effect/temp_visual/trap/firebreath(affected_turf, tile_delay)
			addtimer(CALLBACK(src, PROC_REF(ignite), affected_turf, user), tile_delay)

	user.visible_message(span_yellow("[user] sharply exhales, breathing out a cloud of fyre!"))
	user.Immobilize(15)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raze/proc/ignite(turf/damage_turf, mob/living/caster)
	if(!damage_turf)
		return
	new /obj/effect/temp_visual/firebreath_actual(damage_turf)
	playsound(damage_turf, 'sound/magic/fireball.ogg', 50, TRUE)

	var/total_damage = damage + caster.get_skill_level(associated_skill)
	for(var/mob/living/target in damage_turf)
		if(target == caster)
			continue
		target.adjustFireLoss(total_damage)
		to_chat(target, span_userdanger("You're scorched by flames!"))
		if(target.stat == DEAD && (!target.mind || (!target.key && !target.get_ghost(FALSE, TRUE))))
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, dust)), 2 SECONDS)

	new /obj/effect/hotspot(damage_turf)

/obj/effect/temp_visual/trap/firebreath
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_bullet"
	duration = 10 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/firebreath_actual
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	light_outer_range = 2
	light_color = "#FF6A00"
	duration = 1 SECONDS

// T4: The Free-God's draconic wrath

/obj/effect/proc_holder/spell/self/wingsoffreedom
	name = "Wings of Freedom"
	desc = "Transform into the strongest form of Matthios' own - a dragon. A mere mortal can't sustain this form for long, yet with the power Matthios grants you, you shall burn this world of tyranny to the ground."
	overlay_state = "wingsoffreedom"
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	glow_color = "#FFD700"
	glow_intensity = GLOW_INTENSITY_LOW
	clothes_req = FALSE
	human_req = FALSE
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 MINUTES
	cooldown_min = 30 MINUTES
	invocations = list("I WILL BURN THE WORLD OF TYRANNY TO THE GROUND!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 200
	miracle = TRUE


/obj/effect/proc_holder/spell/self/wingsoffreedom/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("Your will is too broken to change form."))
		revert_cast(user)
		return FALSE

	if(istype(user, /mob/living/carbon/human/species/wildshape))
		revert_cast(user)
		return FALSE

	if(!do_after(user, 10 SECONDS, target = user))
		to_chat(user, span_userdanger("You are unable to concentrate enough to shapeshift!"))
		revert_cast(user)
		return FALSE

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for my draconic form, but something rebukes me! Ravox is too strong in this dimension!"))
		revert_cast(user)
		return FALSE

	user.Stun(30)
	user.Knockdown(30)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation_twilight_dragon), /mob/living/carbon/human/species/wildshape/dragon_matthios)

	return TRUE

// Mob itself
/mob/living/carbon/human/species/wildshape/dragon_matthios
	name = "Gilded Dragon"
	desc = "It has been a very long time since the dragons ruled the skies, yet their power still remains formidable. Despite their monstrous form, ancient intelligence in their eyes betrays their sentience."
	race = /datum/species/dragon_matthios
	footstep_type = FOOTSTEP_MOB_HEAVY
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/twilight_dragon_skin
	wildshape_icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	wildshape_icon_state = "dragon_cool"
	pixel_x = -32
	pixel_y = -16

/mob/living/carbon/human/species/wildshape/dragon_matthios/gain_inherent_skills()
	if(mind)
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_LEGENDARY, TRUE)
		adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)

		STASTR = 20
		STACON = 20
		STAWIL = 15
		STAPER = 12
		STASPD = 6
		STAINT = 15

		AddSpell(new /obj/effect/proc_holder/spell/self/twilight_dragonclaws)

		AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/matthios_dragon)
		AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire/matthios_dragon)

		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		src.apply_status_effect(/datum/status_effect/buff/twilight_dragon_form)

		real_name = "Gilded Dragon"

/datum/species/dragon_matthios
	name = "Gilded Dragon"
	id = "dragon_matthios"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_TOXIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_NOFIRE,
		TRAIT_NIGHT_VISION,
		TRAIT_BASHDOORS,
		TRAIT_STRONGBITE,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LONGSTRIDER,
		TRAIT_NOFALLDAMAGE1,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE, SLOT_RING, SLOT_NECK)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)

	languages = list(
		/datum/language/draconic,
		/datum/language/common,
	)

/datum/species/dragon_matthios/send_voice(mob/living/carbon/human/human)
	playsound(get_turf(human), pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg'), 80, TRUE, -1)

/datum/species/dragon_matthios/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "dragon_cool"
	human.update_damage_overlays()
	return TRUE

/datum/species/dragon_matthios/on_species_gain(mob/living/carbon/carbon, datum/species/old_species)
	. = ..()
	RegisterSignal(carbon, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/dragon_matthios/update_damage_overlays(mob/living/carbon/human/human)
	human.remove_overlay(DAMAGE_LAYER)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/skin_armor/twilight_dragon_skin
	slot_flags = null
	name = "draconic scales"
	desc = "All but impenetrable."
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_PLATE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 600
	item_flags = DROPDEL

/datum/intent/simple/twilight_dragon_cut
	name = "claw"
	clickcd = 10
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 30
	reach = 2
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/datum/intent/simple/twilight_dragon_chop
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = "genslash"
	penfactor = 50
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.2

/datum/intent/mace/smash/twilight_dragon_smash
	name = "thrash"
	desc = "A powerful smash of dragon muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown and knockback scales to your strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	reach = 5
	chargetime = 1
	penfactor = 30

/datum/intent/mace/strike/twilight_dragon_strike
	name = "armor rending strike"
	miss_text = "strikes the air!"
	miss_sound = "bluntwooshlarge"
	attack_verb = list("punches", "strikes", "tears")

/obj/item/rogueweapon/twilight_dragon_claw
	name = "dragon claw"
	desc = "It is said that true dragons used to infuse their claws with metal alloys to make them more dangerous in combat. Regardless of whether that's true, those talons, blessed by Matthios, are no less powerful."
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 28
	block_chance = 0
	wdefense = 6
	armor_penetration = 15
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	possible_item_intents = list(/datum/intent/simple/twilight_dragon_cut, /datum/intent/simple/twilight_dragon_chop, /datum/intent/mace/smash/twilight_dragon_smash, /datum/intent/mace/strike/twilight_dragon_strike)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/twilight_dragon_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/twilight_dragon_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/twilight_dragon_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/twilight_dragonclaws
	name = "Dragon Claws"
	desc = "Extend or retract your razor-sharp claws."
	overlay_state = "claws"
	glow_color = "#FFD700"
	glow_intensity = GLOW_INTENSITY_LOW
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/twilight_dragonclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/twilight_dragon_claw/left/left = user.get_active_held_item()
	var/obj/item/rogueweapon/twilight_dragon_claw/right/right = user.get_inactive_held_item()

	if(extended)
		if(istype(left, /obj/item/rogueweapon/twilight_dragon_claw))
			user.dropItemToGround(left, TRUE)
			qdel(left)

		if(istype(right, /obj/item/rogueweapon/twilight_dragon_claw))
			user.dropItemToGround(right, TRUE)
			qdel(right)

		extended = FALSE
		return

	left = new(user, 1)
	right = new(user, 2)
	user.put_in_hands(left, TRUE, FALSE, TRUE)
	user.put_in_hands(right, TRUE, FALSE, TRUE)
	extended = TRUE


/datum/status_effect/buff/twilight_dragon_form
	id = "twilight_dragon_form"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	duration = 5 MINUTES

/datum/status_effect/buff/twilight_dragon_form/short
	id = "twilight_dragon_form_short"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/twilight_dragon_form
	name = "Dragon Form"
	desc = "Burn them! Burn them all!"
	icon_state = "wingsoffreedom_buff"
	icon = 'icons/mob/actions/matthiosmiracles.dmi'

/datum/status_effect/buff/twilight_dragon_form/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.stat != DEAD)
			H.wildshape_untransform_twilight_dragon(FALSE)

#define TRAIT_SOURCE_WILDSHAPE "wildshape_transform"

/mob/living/carbon/human/species/wildshape/dragon_matthios/death(gibbed, nocutscene = FALSE)
	wildshape_untransform_twilight_dragon(TRUE, gibbed)

/mob/living/carbon/human/proc/wildshape_transformation_twilight_dragon(shapepath)
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)

	var/mob/living/carbon/human/species/wildshape/dragon_matthios/W = new shapepath(loc)

	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	playsound(W.loc, 'sound/body/shapeshift-start.ogg', 100, FALSE, 3)
	src.forceMove(W)
	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.stored_spells = list()
	W.voice_color = voice_color
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name

	W.bleedsuppress = bleedsuppress
	bleed_rate = 0
	bleedsuppress = TRUE
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	mind.transfer_to(W)
	for(var/obj/effect/proc_holder/S in W.mind.spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/self/wingsoffreedom))
			W.stored_spells += list(S.type)
			W.mind.RemoveSpell(S)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/draconic)
	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	if(getorganslot(ORGAN_SLOT_PENIS))
		W.internal_organs_slot[ORGAN_SLOT_PENIS] = /obj/item/organ/penis/knotted/big
	if(getorganslot(ORGAN_SLOT_TESTICLES))
		W.internal_organs_slot[ORGAN_SLOT_TESTICLES] = /obj/item/organ/testicles
	if(getorganslot(ORGAN_SLOT_BREASTS))
		W.internal_organs_slot[ORGAN_SLOT_BREASTS] = /obj/item/organ/breasts
	if(getorganslot(ORGAN_SLOT_VAGINA))
		W.internal_organs_slot[ORGAN_SLOT_VAGINA] = /obj/item/organ/vagina

	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE)
	src.status_flags |= GODMODE
	invisibility = oldinv

	playsound(W.loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 100, FALSE, 3)
	W.gain_inherent_skills()
	addtimer(CALLBACK(W, PROC_REF(energy_add), 1000), 3 SECONDS)

/mob/living/carbon/human/proc/wildshape_untransform_twilight_dragon(dead, gibbed)
	if(!stored_mob)
		return
	if(!mind)
		if(has_status_effect(/datum/status_effect/buff/twilight_dragon_form))
			remove_status_effect(/datum/status_effect/buff/twilight_dragon_form)
		apply_status_effect(/datum/status_effect/buff/twilight_dragon_form/short)
		return
	if(istype(get_area(src), /area/rogue/indoors/ravoxarena))
		to_chat(src, span_userdanger("I reach for my normal form, but something rebukes me! Ravox is too strong in this dimension!"))
		if(has_status_effect(/datum/status_effect/buff/twilight_dragon_form))
			remove_status_effect(/datum/status_effect/buff/twilight_dragon_form)
		apply_status_effect(/datum/status_effect/buff/twilight_dragon_form/short)
		return

	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM
	var/mob/living/carbon/human/species/wildshape/dragon_matthios/WA = src
	var/mob/living/carbon/human/W = WA.stored_mob
	WA.stored_mob = null
	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE)
	if(dead)
		W.death(gibbed)

	W.forceMove(get_turf(src))
	mind.transfer_to(W)
	for(var/S in WA.stored_spells)
		if(S)
			W.mind.AddSpell(new S, W)
	if(dead)
		W.Unconscious(30 SECONDS, TRUE, TRUE)
		W.visible_message(span_boldwarning("[W] twists and shifts back into human guise in a sickening lurch of flesh and bone, and promptly passes out!"), span_userdanger("I quickly flee the waning vitality of my former shape, but the strain is too much--"))
		to_chat(W, span_crit("...DARKNESS..."))
	W.copy_known_languages_from(WA.stored_language)
	W.skills?.known_skills = WA.stored_skills.Copy()
	W.skills?.skill_experience = WA.stored_experience.Copy()

	playsound(W.loc, 'sound/body/shapeshift-end.ogg', 100, FALSE, 3)
	for(var/origin_spell_type in WA.stored_spells)
		for(var/obj/effect/proc_holder/spell/wildspell in W.mind.spell_list)
			if((wildspell.type != origin_spell_type) && !istype(wildspell, /obj/effect/proc_holder/spell/self/wingsoffreedom))
				W.RemoveSpell(wildspell)

	W.regenerate_icons()
	if(!dead)
		to_chat(W, span_userdanger("I return to my old form."))

	qdel(src)

#undef TRAIT_SOURCE_WILDSHAPE

/obj/effect/proc_holder/spell/invoked/projectile/fireball/matthios_dragon
	glow_color = "#FFD700"
	glow_intensity = GLOW_INTENSITY_LOW
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/projectile/spitfire/matthios_dragon
	glow_color = "#FFD700"
	glow_intensity = GLOW_INTENSITY_LOW
	invocation_type = "none"

/// - MATTHIOS REVIVAL - ///


/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Rekindled Exchange"
	desc = "Revives the target by invoking a deal with Matthios. In exchange for their lyfe returned, they will be placed\
	in a lasting debt to Him. Any coins within their hands will be spent paying off said debt. Blood for gold."
	debuff_type = /datum/status_effect/debuff/debt_indicator
	alt_required_items = list()
	required_items = list()
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	recharge_time = 2 MINUTES //Anastasis Equivalent
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/matthios


#define NOBLE_MULTIPLIER 2.5

/datum/component/debt_collector
	var/debt_remaining = 0
	/// There's a couple instances where on_equip() is called twice incorrectly. I'm applying a small cooldown to prevent abuse of this...
	COOLDOWN_DECLARE(next_payment_time)
/datum/component/debt_collector/Initialize(start_debt = 200)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/human = parent
	if(HAS_TRAIT(human, TRAIT_NOBLE))
		debt_remaining = start_debt * NOBLE_MULTIPLIER
	else
		debt_remaining = start_debt
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/debt_collector/proc/on_equip(mob/living/carbon/human/human, obj/item/equipped_item, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_HANDS)
		return

	if(world.time < next_payment_time)
		return

	// Set the cooldown immediately to "lock" this tick
	next_payment_time = world.time + 1

	// Only interact with standard currency, so no marques or psila
	if(istype(equipped_item, /obj/item/roguecoin/gold) || istype(equipped_item, /obj/item/roguecoin/silver) || istype(equipped_item, /obj/item/roguecoin/copper) || istype(equipped_item, /obj/item/roguecoin/gilbranze))
		addtimer(CALLBACK(src, PROC_REF(process_payment), human, equipped_item), 1)

/datum/component/debt_collector/proc/process_payment(mob/living/carbon/human/human, obj/item/roguecoin/coin)
	var/total_real_value = coin.get_real_price()
	if(debt_remaining <= 0)
		clear_debt(human)
		return

	if(total_real_value > debt_remaining)
		var/refund_budget = total_real_value - debt_remaining
		refund_budget = max(0, floor(refund_budget))
		to_chat(human, span_warning("A golden hand claims [coin] and manifest the remainder."))

		qdel(coin)
		// We need a delay to stop the old coin pile from merging with the refund prematurely. Delay one tick :D
		// I love coin code!!
		spawn(1)
			var/obj/structure/roguemachine/temp_ref = new /obj/structure/roguemachine()
			temp_ref.budget2change(refund_budget, human)
			qdel(temp_ref)

		debt_remaining = 0
		clear_debt(human)

	else
		debt_remaining -= total_real_value
		to_chat(human, span_warning("As you grasp [coin], [total_real_value] worth of debt vanishes. Remaining: [debt_remaining]."))
		playsound(human, 'sound/foley/coins1.ogg', 50, TRUE)
		qdel(coin)
		if(debt_remaining <= 0)
			clear_debt(human)

/datum/component/debt_collector/proc/clear_debt(mob/living/carbon/human/human)
	to_chat(human, span_nicegreen("The weight of your debt has lifted!"))
	human.remove_status_effect(/datum/status_effect/debuff/debt_indicator)
	qdel(src)

#undef NOBLE_MULTIPLIER

/atom/movable/screen/alert/status_effect/debuff/debt_indicator
	name = "Indentured Spirit"
	desc = "A spiritual debt weighs heavy on your soul, sapping your vitality. Standard coins you touch are consumed to appease Matthios."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/debt_indicator/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	// Find the component to show the live debt count
	var/datum/component/debt_collector/DC = user.GetComponent(/datum/component/debt_collector)
	if(DC)
		inspec += "<br><span class='boldwarning'>Current Debt: [DC.debt_remaining] mammon.</span>"

	// Stat penalties logic from the base proc
	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		else if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/debt_indicator
	id = "debt_indicator"
	// You should pay off the debt!
	duration = 45 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/debt_indicator
	effectedstats = list(
		STATKEY_STR = -2,
		STATKEY_PER = -4,
		STATKEY_CON = -2
	)

/datum/status_effect/debuff/debt_indicator/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/debt_collector, 200)
	to_chat(owner, span_userdanger("A cold, crushing weight settles over your limbs... you are indentured."))

/datum/status_effect/debuff/debt_indicator/on_remove()
	. = ..()
	to_chat(owner, span_nicegreen("The crushing weight lifts from your soul. You are free!"))
