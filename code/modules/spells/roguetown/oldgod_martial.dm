/*
These are martial spells for Psydonites. 'Greater miracles', which once relied on Psydon, now pulling from the user's own form.
These are all meant to be flagellant in nature.
Given the nature of Psydon, two of these are INTENDED to be refluffed Tennite spells. Although different in power / use.
*/
//Retribution. Spend blood to empower your strikes.
//It's just refluffed divine strike. But worse.
/obj/effect/proc_holder/spell/self/psydonic_retribution
	name = "RETRIBUTION"
	desc = "You siphon a portion of your blood, in exchange for empowering your next strike. \
	Those struck will find their actions tiring and cumbersome. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "RETRIBUTION"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/bloodheal.ogg'
	invocations = list("*warcry")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/psydonic_retribution/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	user.adjust_blood_volume(-50) //Lowered from -100. An empowering hit that does more damage to you than the enemy even if you debuff them is never a good trade.
	user.handle_blood()
	new /obj/effect/decal/cleanable/blood/puddle(user.loc)
	user.apply_status_effect(/datum/status_effect/psydonic_retribution, user.get_active_held_item())
	return TRUE

/datum/status_effect/psydonic_retribution
	id = "psydonic_retribution"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/psydonic_retribution
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/atom/movable/screen/alert/status_effect/buff/psydonic_retribution
	name = "Retribution"
	desc = span_bloody("I stand ready! Fight me, fiends!")
	icon_state = "call_to_arms"

/datum/status_effect/psydonic_retribution/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1, l_color =  "#9e1919")
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/psydonic_retribution/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/psydonic_retribution/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/psydonic_retribution)
	living_target.visible_message(span_warning("The strike from [user]'s weapon coats [living_target] with shards of crimson!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/psydonic_retribution/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/psydonic_retribution)
	H.visible_message(span_warning("The strike from [M]'s fist sprays [H] with droplets of blood!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/debuff/psydonic_retribution
	id = "psydonic_retribution_debuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/psydonic_retribution
	effectedstats = list(STATKEY_WIL = -3, STATKEY_CON = -1)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/psydonic_retribution
	name = "Retribution"
	desc = "Some matter of force attempts to stay my hand...\n"
	icon_state = "restrained"

//Inspire. Meant to rally, at the cost of yourself.
//Ravoxian CtA, with blood cost and weaker. Kind of. As above.
/obj/effect/proc_holder/spell/self/psydonic_inspire
	name = "INSPIRE"
	desc = "At the cost of your own lyfe giving blood, you can inspire your fellow Psydonites. \
	Such grants them constitution and willpower. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "INSPIRE"
	recharge_time = 4 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("For the One!!")
	invocation_type = "shout"
	sound = 'sound/magic/holyshield.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 60

/obj/effect/proc_holder/spell/self/psydonic_inspire/cast(list/targets,mob/living/user = usr)
	user.adjust_blood_volume(-130)//Lowered from -200 due to how useless this miracle was, leaving you almost dead if you had any kind of bleeding.
	user.handle_blood()
	new /obj/effect/decal/cleanable/blood/puddle(user.loc)
	for(var/mob/living/carbon/target in view(6, get_turf(user)))
		if(!istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("A presence witnesses you. For a time, it weeps."))
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/psydonic_inspire)
	return TRUE

/datum/status_effect/buff/psydonic_inspire
	id = "psydonic_inspire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psydonic_inspire
	duration = 2 MINUTES
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = 2)

/atom/movable/screen/alert/status_effect/buff/psydonic_inspire
	name = "Inspired"
	desc = span_bloody("The One witnesses us! To arms!")
	icon_state = "call_to_arms"

//Sacrosanctity. Odd name, but you take damage in exchange to regain blood.
//Avoid bleedouts by breaking your limbs or something. I 'unno. Follows the flagellant theme.
/obj/effect/proc_holder/spell/self/psydonic_sacrosanctity
	name = "SACROSANCTITY"
	desc = "In exchange for your flesh, you may replenish your lyfe giving blood. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "SACROSANCTITY"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/woundheal_crunch.ogg'
	invocations = list("*whimper")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/self/psydonic_sacrosanctity/cast(mob/living/carbon/human/user)
	if(!isliving(user))
		return FALSE
	user.set_blood_volume(max(user.get_blood_volume()+200, 0))
	user.handle_blood()
	user.apply_damage(100, BRUTE, spread_damage = TRUE)//The idea was good, but changing value of damage taken from -200 to -100 due to how inefficient and practically useless this is.
	return TRUE

//Inviolability. A shield around the user, harming any undead who strike them.
/obj/effect/proc_holder/spell/self/psydonic_inviolability
	name = "INVIOLABILITY"
	desc = "In exchange for your flesh and lyfe giving blood, you are protected from Her puppets. \
	Any undead striking you are harmed in turn. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "INVIOLABILITY"
	recharge_time = 6 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/woundheal_crunch.ogg'
	invocations = list("*rage")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 100
	conjured_dispel_desc = "buckle and warp, before it disperses entirely"

/obj/effect/proc_holder/spell/self/psydonic_inviolability/cast(mob/living/carbon/human/user)
	if(!isliving(user))
		return FALSE
	user.adjust_blood_volume(-300)//RAAAA!!!!
	user.handle_blood()
	new /obj/effect/decal/cleanable/blood/puddle(user.loc)
	user.apply_damage(200, BRUTE, spread_damage = TRUE) //300 damage is a lot and enough to cripple one limb instantly, lowering to 200.
	user.apply_status_effect(/datum/status_effect/buff/inviolability)
	return TRUE

#define INVIOLABILITY_FILTER "inviolability_glow"

/atom/movable/screen/alert/status_effect/buff/inviolability
	name = "Inviolability"
	desc = "<span class='bloody'>Her puppets have no hold over my form!</span>"
	icon_state = "necravow"

/datum/status_effect/buff/inviolability
	var/outline_colour ="#9e1919"
	id = "inviolability"
	alert_type = /atom/movable/screen/alert/status_effect/buff/inviolability
	effectedstats = list(STATKEY_CON = 2)
	duration = 3 MINUTES

/datum/status_effect/buff/inviolability/on_apply()
	. = ..()
	var/filter = owner.get_filter(INVIOLABILITY_FILTER)
	if (!filter)
		owner.add_filter(INVIOLABILITY_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/buff/inviolability/on_remove()
	. = ..()
	owner.remove_filter(INVIOLABILITY_FILTER)
	to_chat(owner, span_warning("I feel so cold..."))

#undef INVIOLABILITY_FILTER

//Syonacrum. An ability for arbalists to conjure a special bolt, at the cost of near slaying themselves.
//Of course, this is limited to arbalist. Why would anyone else need or want this?
/obj/effect/proc_holder/spell/self/psydonic_lux_bolt
	name = "SYONACRUM"
	desc = "A miracle of an ancient order, allowing one to form portions of their lux into suitable implements. \
	In your case, projectiles, for your beloved sauterelle. The effects of such are only felt shortly after use, so be swift. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "SYONACRUM"
	recharge_time = 6 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/woundheal_crunch.ogg'
	invocations = list("*scream")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/self/psydonic_lux_bolt/cast(mob/living/carbon/human/user)
	if(!isliving(user))
		return FALSE

	var/obj/item/rogueweapon/huntingknife/idagger/silver/stake/psy/stake = user.get_active_held_item()
	if(istype(stake) && !stake.luxinfused && stake.obj_broken == FALSE)
		user.visible_message(span_notice("[user] places a palm around the [stake], leaving it awash with silvery strings.")) 
		to_chat(user, span_userdanger("The stake is suffused with my own spark. In a moment of desperation it shall serve me well..."))
		addtimer(CALLBACK(src, PROC_REF(lux_punish), user), wait = 12 SECONDS)
		stake.luxinfused = TRUE
		return TRUE


	dispel_conjured_item()
	var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/R = new /obj/item/ammo_casing/caseless/rogue/heavy_bolt/lux(user.drop_location())
	R.AddComponent(/datum/component/conjured_item)
	user.put_in_hands(R)
	set_conjured_item(R)
	addtimer(CALLBACK(src, PROC_REF(lux_punish), user), wait = 12 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/self/psydonic_lux_bolt/proc/lux_punish(mob/living/carbon/target)
	target.visible_message(span_notice("[target] shimmers, as if they're to fade away entirely, before snapping back to reality."), \
		span_userdanger("My own spark, my <b>lyfe</b>, flashes afore me. What have I done?"))
	target.adjust_blood_volume(-200)//Take a guess.
	target.handle_blood()
	new /obj/effect/decal/cleanable/blood/puddle(target.loc)
	target.apply_damage(250, BRUTE, spread_damage = TRUE) //Lowered from 300. At 300, it's enough to literally cripple limbs, which renders the miracle only useful if you have the absolver ready to take damage or in bed. It's limited to one bolt at a time anyways, so at most you'll only use it once in battle.
	playsound(target.loc, 'sound/magic/woundheal_crunch.ogg', 100, FALSE)

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/lux
	name = "lux bolt"
	desc = "A bolt, formed of pure, unfettered <b>lux</b>. Your own, likely, if you're holding this. \
	Surely you can understand what's meant to be done?"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/lux
	icon_state = "lux_bolt"//Temp sprite. Psydon save me!!!
	max_integrity = 0.1
	force = 20
	is_silver = TRUE//ARE YOU INSANE?

//Don't miss, buddy.
/obj/projectile/bullet/reusable/heavy_bolt/lux
	name = "lux projectile"
	damage = 10//We handle this by way of the on hit below.
	damage_type = BURN//Maybe
	armor_penetration = 100//+20 over standard. Doesn't really matter, though.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/lux
	hitsound = 'sound/combat/hits/hi_bolt (1).ogg'
	speed = 0.3
	npc_simple_damage_mult = 7
	

/obj/projectile/bullet/reusable/heavy_bolt/lux/on_hit(target)
	. = ..()
	var/const/structure_damage = 1000
	var/const/radius = 1
	//Handle the mob impact, firstly.
	var/turf/fallzone = get_turf(target)
	if(!fallzone) // falback in case we hit somone without a turf (Harpy flying?)
		if(ismob(target))
			var/mob/living/carbon/human/M = target
			if(M.mob_biotypes & MOB_UNDEAD)
				M.reagents.add_reagent(/datum/reagent/water/blessed, 15)
			if(HAS_TRAIT(M, TRAIT_SILVER_WEAK))
				M.adjust_fire_stacks(12, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
				M.ignite_mob()
				visible_message(span_warning("[target] erupts in divine flames upon being struck by [src]!"))
				M.apply_damage(50, BRUTE, spread_damage = TRUE)
				M.apply_damage(50, BURN, spread_damage = TRUE)
			else
				M.adjust_fire_stacks(12)
				M.ignite_mob()
				visible_message(span_warning("[target] is engulfed in flames upon being struck by [src]!"))
				M.apply_damage(75, BRUTE, spread_damage = TRUE)
				M.apply_damage(25, BURN, spread_damage = TRUE)
		return

	for(var/mob/living/carbon/human/M in range(radius, fallzone))
		if(M.mob_biotypes & MOB_UNDEAD)
			M.reagents.add_reagent(/datum/reagent/water/blessed, 15)
		if(HAS_TRAIT(M, TRAIT_SILVER_WEAK)) // I plaed psydonate miraclist VL. The silveweakness has to override all else
			M.adjust_fire_stacks(12, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
			M.ignite_mob()
			visible_message(span_warning("[M] erupts in divine flames originating from [src]!"))
			M.apply_damage(50, BRUTE, spread_damage = TRUE)
			M.apply_damage(50, BURN, spread_damage = TRUE)
		else
			if(HAS_TRAIT(M, TRAIT_PSYDONITE)) // only for practicing psydonites, all of inqusition qualifies. I dont want arbalist linched
				M.adjust_fire_stacks(3)
				M.ignite_mob()
				visible_message(span_warning("[M] is singed by the flames originating from [src], yet the flames seem to avoid them!"))
				M.apply_damage(20, BRUTE, spread_damage = TRUE)
				M.apply_damage(5, BURN, spread_damage = TRUE)
			else
				M.adjust_fire_stacks(12)
				M.ignite_mob()
				visible_message(span_warning("[M] is engulfed in flames originating from [src]!"))
				M.apply_damage(75, BRUTE, spread_damage = TRUE)
				M.apply_damage(25, BURN, spread_damage = TRUE)
		
	for(var/turf/open/visual in range(radius, fallzone))
		var/obj/effect/temp_visual/luxturf/luxspread = new /obj/effect/temp_visual/luxturf(visual)
		var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast // SMOKE EFFECT
		animate(luxspread, alpha = 255, time = 8)
		S.set_up(radius, fallzone)
		S.start()
	// Everything from this point has to do with what is damaged, additional structures can be added to the list to have different damage/effects!
	for(var/obj/structure/damaged in range(radius, fallzone))
		damaged.take_damage(structure_damage, BRUTE, "blunt", 1)
	for(var/turf/closed/wall/damagedwalls in range(radius, fallzone))
		damagedwalls.take_damage(structure_damage, BRUTE, "blunt", 1)
	for(var/turf/closed/mineral/aoemining in range(radius, fallzone))
		aoemining.take_damage(structure_damage, BRUTE,"blunt",1)
	qdel(src)

/obj/effect/temp_visual/luxturf
	icon_state = "emppulse"//Need a proper sprite for a lux burst.
	duration = 8//Adjust with the above, when/if we get one. Otherwise just default to emp/pulse and just delete this.


#define BLOODRUNE_FIRE "<span style=color:#FF8C00;>Fire Rune</span>"
#define BLOODRUNE_WIND "<span style=color:#87CEFA;>Wind Rune</span>"
#define BLOODRUNE_EARTH "<span style=color:#8B4513;>Earth Rune</span>"
#define BLOODRUNE_WATER "<span style=color:#0000CD;>Water Rune</span>"
#define BLOODRUNE_NATURE "<span style=color:#32CD32;>Nature Rune</span>"
#define BLOODRUNE_FORCE "<span style=color:#FFFF00;>Force Rune</span>"


/obj/effect/proc_holder/spell/self/arbalist_blood_runes 
	name = "FUTHARK"
	desc = "There have been a group of tribal shamans writing weird magical runes into their flesh and blood. \
	While their magics were declared heretical, your sect have realised that their magic can be used together with thier lux techniques. \
	So the blood runes were born, never grafted onto flesh as that has been forbitten, but instead drawn on the objects of your trade with your own blood. \
	Use it with empty hand for more information. \
	<small><span class='bloody'>A greater miracle.</span></small>"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "DEFY"
	recharge_time = 5 SECONDS
	movement_interrupt = FALSE
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/woundheal_crunch.ogg'
	invocations = list("Uzu, Fezo, Kaun.")
	invocation_type = "whisper"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/self/arbalist_blood_runes/cast(mob/living/carbon/human/user)
	if(!ishuman(user))
		return FALSE

	var/item = user.get_active_held_item()
	if(!item) // Nothing in hand, give tutorial
		to_chat(user, span_notice("A blood rune can be applied to: Any bolt with can be fired from saletre or blooded stake."))
		to_chat(user, span_notice("To created blooded stake use this miracle with a wooded stake in hand. They are meant to be expendable and cant be fixed."))
		to_chat(user, span_notice("Each rune activates only once and removes itself after use. Blooded stake takes 10 damage every time it happens."))
		to_chat(user, span_notice("What rune is made depends on your stance. Runes with hard CC give victim 15 second immunity to other hard CC runes."))
		to_chat(user, span_notice("Defend intent creates [BLOODRUNE_FIRE], with causes the victim to burst into flames (holy flames against undead)."))
		to_chat(user, span_notice("Swift intend creates [BLOODRUNE_WIND], with causes the victim to be slowed, and yourself to be hasten for 15 seconds. It also makes bolts fly incredibly fast."))
		to_chat(user, span_notice("Weak intend creates [BLOODRUNE_EARTH], with causes the victim to not be able to use their weapons for 6 second. One of hard CC runes. It also makes bolt extremely effective against structures."))
		to_chat(user, span_notice("Aimed intend creates [BLOODRUNE_WATER], with blinds and mutes the victim for 6 seconds. One of hard CC runes."))
		to_chat(user, span_notice("Feint intend creates [BLOODRUNE_NATURE], with immobilizes the victim for 6 seconds. One of hard CC runes. It also makes the bolt create vines if it fails to hit a person."))
		to_chat(user, span_notice("Strong intend creates [BLOODRUNE_FORCE], with knockbacks victim by 5 tiles. Subject to normal knockback cooldown. It also makes bolt extremely effective against structures."))
		revert_cast()
		return FALSE

	if(!(istype(item, /obj/item/grown/log/tree/stake) || istype(item, /obj/item/rogueweapon/huntingknife/idagger/silver/stake/blood) || istype(item, /obj/item/ammo_casing/caseless/rogue/heavy_bolt)))
		to_chat(user, span_danger("You must be holding a stake, a bloodblessed stake or a sauterelle bolt to use your runes."))
		revert_cast()
		return FALSE

	if(istype(item, /obj/item/grown/log/tree/stake))
		user.visible_message(span_danger("[user] stabs [item] into their flesh, covering it in their blood."), span_notice("I bind my blood to the wooden stake, it will now serve as conduit for the runes."))
		qdel(item)
		user.put_in_active_hand(new /obj/item/rogueweapon/huntingknife/idagger/silver/stake/blood)
		user.adjust_blood_volume(-100)
		return TRUE
	
	var/intent = user.rmb_intent
	var/rune = null
	var/list/posible_intents = list(/datum/rmb_intent/riposte, /datum/rmb_intent/feint, /datum/rmb_intent/swift, /datum/rmb_intent/weak, /datum/rmb_intent/strong, /datum/rmb_intent/aimed)

	if(!intent || !is_type_in_list(intent, posible_intents))
		to_chat(span_green("This intent isnt accepted for the spell. Make a bug report")) // if you make new intends or change the old ones, add them to the list. Double up on a rune from 2 difrent intends if you need to
		revert_cast()
		return FALSE

	if(istype(intent, /datum/rmb_intent/riposte))
		rune = BLOODRUNE_FIRE
	if(istype(intent, /datum/rmb_intent/swift))
		rune = BLOODRUNE_WIND
	if(istype(intent, /datum/rmb_intent/weak))
		rune = BLOODRUNE_EARTH
	if(istype(intent, /datum/rmb_intent/aimed))
		rune = BLOODRUNE_WATER
	if(istype(intent, /datum/rmb_intent/feint))
		rune = BLOODRUNE_NATURE
	if(istype(intent, /datum/rmb_intent/strong))
		rune = BLOODRUNE_FORCE

	var/obj/item/rogueweapon/huntingknife/idagger/silver/stake/blood/stake = item
	var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/bolt = item
	
	if(istype(stake))
		stake.rune = rune
		user.adjust_blood_volume(-50)
		user.visible_message(span_danger("[user] draws something on [item] with their blood."), span_notice("I shape a [rune] on the surface of [item]."))
		return TRUE
	if(istype(bolt))
		bolt.rune = rune
		var/obj/projectile/bullet/reusable/heavy_bolt/loaded_bolt = bolt.BB
		loaded_bolt.rune = rune
		bolt.is_silver = TRUE // silverblessed blood
		if(rune == BLOODRUNE_WIND)
			loaded_bolt.speed = 0.01 // almost hitscan
		else
			loaded_bolt.speed = loaded_bolt.orginal_speed
		user.adjust_blood_volume(-50)
		user.visible_message(span_danger("[user] draws something on [item] with their blood."), span_notice("I shape a [rune] on the surface of [item]."))
		return TRUE

	revert_cast() // fallback
	return FALSE



#define HASTE_FILTER "haste_glow"

/atom/movable/screen/alert/status_effect/buff/lesser_haste
	name = "Lesser Haste"
	desc = "I am speed up by magical means."
	icon_state = "buff"

/datum/status_effect/buff/lesser_haste
	var/outline_colour ="#01b0bd" 
	id = "haste_lesser"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lesser_haste
	effectedstats = list(STATKEY_SPD = 3)
	duration = 15 SECONDS

/datum/status_effect/buff/lesser_haste/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/lesser_haste/on_apply()
	. = ..()
	var/filter = owner.get_filter(HASTE_FILTER)
	if (!filter)
		owner.add_filter(HASTE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("My limbs move with uncanny swiftness."))

/datum/status_effect/buff/lesser_haste/on_remove()
	. = ..()
	owner.remove_filter(HASTE_FILTER)
	to_chat(owner, span_warning("My body move slowly again..."))


/datum/status_effect/buff/lesser_haste/nextmove_modifier()
	return 0.85


/atom/movable/screen/alert/status_effect/debuff/slow
	name = "Slow"
	desc = "Magic is impering my movments."
	icon_state = "debuff"

/datum/status_effect/debuff/slow
	var/outline_colour ="#0f0058" 
	id = "slow"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/slow
	effectedstats = list(STATKEY_SPD = -5)
	duration = 15 SECONDS

/datum/status_effect/debuff/slow/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/debuff/slow/on_apply()
	. = ..()
	var/filter = owner.get_filter(HASTE_FILTER)
	if (!filter)
		owner.add_filter(HASTE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("My limbs move slowly like the air is resisting you."))

/datum/status_effect/debuff/slow/on_remove()
	. = ..()
	owner.remove_filter(HASTE_FILTER)
	to_chat(owner, span_warning("Your movments are free once again."))

/datum/status_effect/debuff/slow/nextmove_modifier()
	return 1.3

#undef HASTE_FILTER


/atom/movable/screen/alert/status_effect/buff/bloodrune_resistance
	name = "Rune resistance"
	desc = "I'm safe from the most disabling runes."
	icon_state = "buff"

/datum/status_effect/buff/bloodrune_resistance
	id = "bloodrune_resistance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bloodrune_resistance
	duration = 15 SECONDS

/datum/status_effect/buff/bloodrune_resistance/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()
