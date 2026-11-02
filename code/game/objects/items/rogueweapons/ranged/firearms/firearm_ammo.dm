/**
 * Parent bullet.
 */
/obj/item/ammo_casing/caseless/bullet
	name = "PARENT SPHERE"
	desc = "YOU SHOULD NOT BE SEEING THIS. YELL AT CARL!!!"
	projectile_type = /obj/projectile/bullet/firearm
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball"
	possible_item_intents = list(/datum/intent/use)
	dropshrink = 0.5
	max_integrity = 0.1
	w_class = WEIGHT_CLASS_TINY

/obj/projectile/bullet/firearm
	name = "PARENT SMOKEPOWDER PROJECTILE"
	damage = 90//Do you see how infrequently these things fire...
	armor_penetration = PEN_BSTEEL //... and yet I need to explain?
	range = 7 //Effective range? 7 tiles. You aren't sniping with this.
	embedchance = 100//Yessir.
	speed = 0.1//Take a guess.
	npc_simple_damage_mult = 4//320, at 80 base.
	accuracy = 90//Their point. Very slow firing. Yet powerful and accurate.
	bonus_accuracy = 10//As opposed to using PER.
	damage_type = BRUTE
	woundclass = BCLASS_PIERCE
	flag = "piercing"//Vestigial, but just in case we use another flag later.
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/bullet
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	var/stumble_strength = 4
	var/secondary_damage
	var/secondary_damage_type
	var/silver = FALSE
	var/blessed = FALSE
	var/critfactor = 1
	var/gunpowder_npc_critfactor = 1
	var/gunpowder

/obj/item/ammo_casing
	var/obj/item/quiver/twilight_bullet/runicbag/linked_bag = null
	var/obj/item/storage/belt/rogue/leather/entropy_sphere_belt/linked_belt = null
	var/breech_loaded = FALSE

/**
 * Generic ammo used by handgonnes and arquebuses
 */

/obj/item/ammo_casing/caseless/bullet/lead
	name = "lead sphere"
	desc = "A small lead sphere. This should go well with smokepowder."
	projectile_type = /obj/projectile/bullet/firearm/lead
	caliber = "lead_sphere"

/obj/projectile/bullet/firearm/lead
	name = "lead sphere"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead

/obj/projectile/bullet/firearm/lead/on_hit(atom/target)
	if(isliving(target))
		var/mob/living/target_living = target
		if(target_living.has_status_effect(/datum/status_effect/debuff/exposed) || target_living.has_status_effect(/datum/status_effect/debuff/vulnerable))
			damage *= 1.5

	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/**
 * Now, actual grapeshot, for the proper blunderbuss.
 */

/obj/item/ammo_casing/caseless/bullet/grapeshot
	name = "grapeshot"
	desc = "A collection of tiny metal beads. This should go well with smokepowder."
	projectile_type = /obj/projectile/bullet/firearm/grapeshot
	caliber = "grapeshot"
	icon_state = "grapeshot"
	pellets = 6//180 point blank, based on 30 damage.
	variance = 30

/obj/projectile/bullet/firearm/grapeshot
	name = "grapeshot"
	damage = 30
	range = 15
	npc_simple_damage_mult = 4//720 potential, if all hit.
	ammo_type = /obj/item/ammo_casing/caseless/bullet/grapeshot
	stumble_strength = 1//6 potential, if all hit.

/obj/projectile/bullet/firearm/grapeshot/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/**
 * General firearm effect, on strike.
 * You roll 1-12, and if it's higher than your CON, you're FUCKED.
 * Otherwise, applies a slowdown for beating the check.
 * Silver and blessed burn is handled here too, so every subtype inherits it.
 */

/obj/projectile/bullet/firearm/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		var/list/screams = list("painscream", "paincrit")
		var/check = rand(1, 12)//12CON or higher to beat this every time.
		if(isliving(target))
			if(check > M.STACON)//Has to beat, not meet.
				M.emote(screams)//MY INSIDES ARE ON THE OUTSIDE!!!
				M.Knockdown(rand(15,30))
				M.Immobilize(rand(30,60))
			else
				M.Slowdown(stumble_strength)
	if(silver && isliving(target))
		var/mob/living/T = target
		if(HAS_TRAIT(T, TRAIT_SILVER_WEAK))
			if(blessed)
				if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder))
					if(T.patron)
						to_chat(T, span_danger("The thrice-cursed Otavan silver! By [T.patron.name], it hurts!!"))
					else
						to_chat(T, span_danger("The thrice-cursed Otavan silver! By all that's holy, it hurts!!"))
				T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
			else
				if(!T.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
					to_chat(T, span_danger("Silver rebukes my presence! These fires are lashing at my very soul!"))
				T.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
			T.ignite_mob()

//The actual pouches.
/obj/item/quiver/bullet
	name = "lead ball pouch"
	desc = "This pouch can hold a handful of musket balls, or, perhaps, grapeshot."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"//Need another sprite.
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 8
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/bullet/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bullet))
				break

/obj/item/quiver/bullet/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/bullet))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/firearm))
		var/obj/item/gun/ballistic/firearm/B = A
		if(arrows.len && !B.chambered)
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/bullet))
					arrows -= AR
					B.attackby(AR, loc, params)
					break
		return
	..()

/obj/item/quiver/bullet/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bullet/update_icon()
	return

/obj/item/quiver/bullet/lead/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/lead/B = new()
		arrows += B
	update_icon()

/obj/item/quiver/bullet/grapeshot/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/grapeshot/B = new()
		arrows += B
	update_icon()

//RUNELOCK
/obj/item/ammo_casing/caseless/bullet/lead/silver
	name = "silver sphere"
	desc = "A small silver sphere. Softer than a lead bullet, but highly effective against the undead."
	projectile_type = /obj/projectile/bullet/firearm/lead/silver
	icon_state = "musketball_silver"

/obj/projectile/bullet/firearm/lead/silver
	name = "silver sphere"
	desc = "A small silver sphere. Softer than a lead bullet, but highly effective against the undead."
	damage = 120
	silver = TRUE
	critfactor = 0.8
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/silver
	damage_type = BRUTE
	armor_penetration = PEN_NONE

/obj/item/ammo_casing/caseless/bullet/lead/runelock
	name = "PARENT RUNELOCK SPHERE"
	desc = "YOU SHOULD NOT BE SEEING THIS. YELL AT DEVS!!!"
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock
	caliber = "runed_sphere"
	max_integrity = 0

/obj/item/ammo_casing/caseless/bullet/lead/runelock/Initialize(mapload)
	. = ..()
	if(!get_filter("rune_filter"))
		add_filter("rune_filter", 2, list("type" = "outline", "color" = rgb(112, 28, 28, 1), "alpha" = 200, "size" = 2))

/obj/item/ammo_casing/caseless/bullet/lead/runelock/Destroy()
	if(linked_bag)
		linked_bag.unlink_casing(src)
	if(linked_belt)
		linked_belt.unlink_casing(src)
	linked_bag = null
	linked_belt = null
	return ..()

/obj/item/ammo_casing/caseless/bullet/lead/runelock/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	. = ..()
	if(linked_bag && length(linked_bag.linked_ammo_types) < linked_bag.max_storage)
		linked_bag.linked_ammo_types += type
	if(linked_belt && length(linked_belt.linked_ammo_types) < linked_belt.max_storage)
		linked_belt.linked_ammo_types += type

/obj/item/ammo_casing/caseless/bullet/lead/runelock/equipped(mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_INQUISITION) && !(H.STAINT >= 15) && !(H.patron?.type == /datum/patron/old_god) && !(H.merctype == 10))
			to_chat(H, "<font color='yellow'>The [name] is extremely hot to touch! It burns your hand!</font>")
			var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_hand"
			H.apply_damage(rand(5,15), BURN, def_zone)
			forceMove(get_turf(H))
	else
		to_chat(user, "<font color='yellow'>The [name] is extremely hot to touch! It burns your hand!</font>")
		user.apply_damage(rand(5,15), BURN)
		forceMove(get_turf(user))
	..()

/obj/projectile/bullet/firearm/lead/runelock
	name = "PARENT RUNELOCK PROJECTILE"
	speed = 0.6
	max_range = 7
	range = 12
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock
	damage_type = BRUTE

/obj/item/ammo_casing/caseless/bullet/lead/runelock/runed
	name = "runed sphere"
	desc = "A small, perfectly round metal sphere covered in Psydonite runes. Lethal at high velocity."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/runed
	icon_state = "musketball_runed"

/obj/projectile/bullet/firearm/lead/runelock/runed
	name = "runed sphere"
	desc = "A small, perfectly round metal sphere covered in Psydonite runes. Lethal at high velocity."
	damage = 45
	icon_state = "musketball_runed"
	armor_penetration = PEN_BSTEEL
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/runed

/obj/projectile/bullet/firearm/lead/runelock/runed/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/debuff/psypowder)

/obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed
	name = "blessed runed sphere"
	desc = "A small, perfectly round sphere crafted from pure silver. These munitions are forged by the finest Otavan smiths and blessed personally by the Grandmaster. Lethal against the undead, but also highly effective against other heretics."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/blessed
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/blessed
	name = "blessed sphere"
	desc = "A small, perfectly round sphere crafted from pure silver. These munitions are forged by the finest Otavan smiths and blessed personally by the Grandmaster. Lethal against the undead, but also highly effective against other heretics."
	damage = 120
	icon_state = "musketball_blessed"
	silver = TRUE
	blessed = TRUE
	armor_penetration = PEN_NONE
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed

/atom/movable/screen/alert/status_effect/debuff/psypowder
	name = "Runed Poison"
	desc = "This powder is killing my eyes and body. I barely can see and move..."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "runed_poison"

/datum/status_effect/debuff/psypowder
	id = "runed_poison"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/psypowder
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -3, STATKEY_CON = -2, STATKEY_PER = -2)
	duration = 15 SECONDS

/datum/status_effect/debuff/psypowder/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))

/datum/status_effect/debuff/psypowder/heavy
	duration = 30 SECONDS

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy
	name = "heavy runed sphere"
	desc = "You shoudnt be seeing this."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy
	caliber = "runed_sphere"
	icon_state = "musketball_runed"
	max_integrity = 0

/obj/projectile/bullet/firearm/lead/runelock/heavy // only shot by the rifle
	name = "heavy runed sphere"
	desc = "You shoudnt be seeing this."
	damage = 100
	speed = 0.4 // a bit faster
	icon_state = "musketball_runed"
	max_range = 25 // be a sniper you alwys wished to be
	range = 25
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy
	damage_type = BRUTE
	armor_penetration = PEN_BSTEEL

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed
	name = "heavy blessed runed sphere"
	desc = "A large, perfectly round sphere crafted from pure silver. These munitions are forged by the finest Otavan smiths and blessed personally by the Grandmaster. The expanded runework nessesites firing it from a rifle."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/blessed
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/blessed
	name = "heavy blessed runed sphere"
	desc = "A large, perfectly round sphere crafted from pure silver. These munitions are forged by the finest Otavan smiths and blessed personally by the Grandmaster. The expanded runework nessesites firing it from a rifle."
	damage = 240
	icon_state = "musketball_blessed"
	silver = TRUE
	blessed = TRUE
	armor_penetration = PEN_NONE
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed
	name = "heavy runed sphere"
	desc = "A large, perfectly round metal sphere covered in Psydonite runes. Lethal at high velocity."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/runed
	caliber = "runed_sphere"
	icon_state = "musketball_runed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/runed
	name = "heavy runed sphere"
	desc = "A large, perfectly round metal sphere covered in Psydonite runes. Lethal at high velocity."
	damage = 90
	icon_state = "musketball_runed"
	armor_penetration = PEN_BSTEEL
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed

/obj/projectile/bullet/firearm/lead/runelock/heavy/runed/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/debuff/psypowder/heavy) // 2 times duration

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/entropy
	name = "sphere of entropy"
	desc = "Looking at the complex runework on this sphere makes you feel somehow lesser."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/entropy
	caliber = "runed_sphere"
	icon_state = "musketball_blessed"

/obj/projectile/bullet/firearm/lead/runelock/heavy/entropy
	name = "entrophy sphere"
	desc = "You feel lesser for even gazing at this."
	damage = 120
	icon_state = "musketball_blessed"
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/entropy
	armor_penetration = PEN_BSTEEL
	silver = TRUE
	blessed = TRUE

/obj/projectile/bullet/firearm/lead/runelock/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.stamina_add(50)
		L.energy_add(-450) // around 3 bulets to remove a blue bar
		if(L.devotion)
			L.devotion.update_devotion(-500) // half of T4 clerics
		if(L.get_bloodpool())
			L.adjust_bloodpool(-500) // half a normal vampire vita
		to_chat(L, span_danger("You feel as if you somehow became lesser!"))
		

/obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	name = "mark"
	desc = "A highly specialised and expensive tracking sphere. Victim will leave a trail of silver dust as they escape, and will bleed more as they move around."
	projectile_type = /obj/projectile/bullet/firearm/lead/runelock/heavy/tracker
	caliber = "runed_sphere"
	icon_state = "musketball_silver"

/obj/projectile/bullet/firearm/lead/runelock/heavy/tracker
	name = "mark"
	desc = "You can't escape the hunters mark."
	damage = 80
	icon_state = "musketball_silver"
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	armor_penetration = PEN_BSTEEL // we want this to go though no mater what
	silver = TRUE
	blessed = TRUE

/obj/projectile/bullet/firearm/lead/runelock/heavy/tracker/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/L = target
		L.apply_status_effect(/datum/status_effect/debuff/arbalest_hunt)

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail
	name = "silver dust"
	desc = "A trail of silvery dust created by a marking sphere buried in some poor heretic."
	blood_state = BLOOD_STATE_XENO
	alpha = 240

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(self_cleaning)), 5 MINUTES) // och look its self cleaning

/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/proc/self_cleaning()
	qdel(src)
	

/atom/movable/screen/alert/status_effect/debuff/arbalest_hunt
	name = "Hunters Mark"
	desc = "There is something burrowing inside me! The more I move the worse it becomes! I need to stand still and extract it (click the popup)."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "embed"

/atom/movable/screen/alert/status_effect/debuff/arbalest_hunt/handle_click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE
	var/mob/living/carbon/human/L = usr
	if(!istype(L))
		return
	if(do_after(L, 10 SECONDS))	
		L.remove_status_effect(/datum/status_effect/debuff/arbalest_hunt)


/datum/status_effect/debuff/arbalest_hunt
	id = "arbalest_hunt"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/arbalest_hunt
	effectedstats = list(STATKEY_SPD = -3, STATKEY_WIL = -3)
	duration = 5 MINUTES

/datum/status_effect/debuff/arbalest_hunt/on_apply()
	. = ..()
	owner.add_filter("arbalest_hunt_glow", 2, list("type" = "outline", "color" = GLOW_COLOR_METAL, "alpha" = 150, "size" = 2))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move_init))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(clear_hunt))

/datum/status_effect/debuff/arbalest_hunt/on_remove()
	. = ..()
	owner.remove_filter("arbalest_hunt_glow")
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/status_effect/debuff/arbalest_hunt/proc/clear_hunt(mob/living/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/debuff/arbalest_hunt/proc/handle_move()
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(istype(T))
		var/obj/effect/decal/cleanable/blood/footprints/arbalest_trail/trail = locate() in T
		if(!trail)
			trail = new(T)
		trail.entered_dirs |= H.dir
		trail.update_icon()

/datum/status_effect/debuff/arbalest_hunt/proc/handle_move_init(datum/source)
	SIGNAL_HANDLER
	if(source != owner)
		return FALSE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/status_effect/debuff/arbalest_hunt, handle_move))

/obj/item/quiver/twilight_bullet/runicbag
	name = "pharetra"
	desc = "A leather pouch designed to store runic bullets. The rune inscribed on the lock binds to the ammunition stored inside, and upon activation, returns spent runic bullets to the pouch for reuse."
	icon_state = "runebag"
	item_state = "runebag"
	max_storage = 12
	var/has_types = TRUE
	var/ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/runed 
	var/ammo_type2 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/blessed 
	var/ammo_type_name1 = "runed"
	var/ammo_type_name2 = "blessed"
	var/selected_type // what the pouch is currently attuned to
	var/list/linked_ammo_types = list() // types the casings report on firing
	var/list/linked_casings = list()    // every live casing linked to this bag, in or out of it
	var/recall_energy_cost = 25 // energy drained per sphere recalled

/obj/item/quiver/twilight_bullet/runicbag/Destroy()
	for(var/obj/item/ammo_casing/C as anything in linked_casings)
		C.linked_bag = null
	linked_casings.Cut()
	linked_ammo_types.Cut()
	QDEL_LIST(arrows)
	return ..()

/obj/item/quiver/twilight_bullet/runicbag/proc/link_casing(obj/item/ammo_casing/C)
	C.linked_bag = src
	linked_casings |= C

/obj/item/quiver/twilight_bullet/runicbag/proc/unlink_casing(obj/item/ammo_casing/C)
	linked_casings -= C
	arrows -= C
	if(C.linked_bag == src)
		C.linked_bag = null

/obj/item/quiver/twilight_bullet/runicbag/update_icon()
	icon_state = "runebag"

/obj/item/quiver/twilight_bullet/runicbag/attack_self(mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_notice("The [src.name] is full and can accept no more ammunition!"))
		return
	if(user.energy < recall_energy_cost)
		to_chat(user, span_warning("The runes on the lock flicker and die. I don't have the energy to recall them."))
		return
	var/type_name = (selected_type == ammo_type2) ? "ammo_type_name2" : "ammo_type_name1"
	to_chat(user, span_notice("The runes on the lock flare as I call the [type_name] spheres home..."))
	if(!do_after(user, 15 SECONDS, src))
		to_chat(user, span_warning("My concentration breaks, and the runes go dark."))
		return
	var/affordable = round(user.energy / recall_energy_cost)
	if(affordable < 1)
		to_chat(user, span_warning("My energy gutters out before the spheres can answer."))
		return
	var/summoned = 0
	for(var/obj/item/ammo_casing/C as anything in linked_casings - arrows)
		if(summoned >= affordable || arrows.len >= max_storage)
			break
		if(recursive_loc_check(C, /obj/item/gun))
			continue
		qdel(C)
		if(summon_round(selected_type))
			summoned++
	while(summoned < affordable && summon_round(selected_type))
		summoned++
	if(!summoned)
		return
	playsound(src, 'sound/magic/blink.ogg', 80)
	user.energy_add(-(recall_energy_cost * summoned))
	if(arrows.len < max_storage)
		to_chat(user, span_warning("My energy runs dry. Only [summoned] sphere\s answered the call."))
	else
		to_chat(user, span_notice("The spheres snap back into the pharetra."))
	linked_ammo_types.Cut()
	update_icon()

/obj/item/quiver/twilight_bullet/runicbag/MiddleClick(mob/user, params)
	if(!has_types)
		to_chat(user, span_warning("The spheres in this pouch cannot be converted."))
		return TRUE
	if(selected_type == ammo_type1)
		selected_type = ammo_type2
		to_chat(user, span_notice("The spheres in the pouch shimmer and turn <b>[ammo_type_name2]</b>."))
	else
		selected_type = ammo_type1
		to_chat(user, span_notice("The spheres in the pouch darken and turn <b>[ammo_type_name1]</b>."))
	convert_spheres(selected_type)
	playsound(src, 'sound/magic/charged.ogg', 40, FALSE)
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/proc/convert_spheres(new_type)
	var/converted = 0
	for(var/obj/item/ammo_casing/C as anything in arrows.Copy())
		if(C.type == new_type)
			continue
		unlink_casing(C) 
		qdel(C)
		converted++
	for(var/i in 1 to converted)
		summon_round(new_type)
	update_icon()

/obj/item/quiver/twilight_bullet/runicbag/attack_right(mob/user)
	if(!arrows.len)
		to_chat(user, span_warning("The pouch is empty."))
		return TRUE
	var/obj/item/ammo_casing/O = arrows[arrows.len]
	arrows -= O 
	O.forceMove(user.loc)
	user.put_in_hands(O)
	update_icon()
	return TRUE

// Examine requested by Xander
/obj/item/quiver/twilight_bullet/runicbag/examine(mob/user)
	. = ..()
	var/type_name = ""
	if(has_types)
		type_name = (selected_type == ammo_type2) ? ammo_type_name2 : ammo_type_name1
	else
		type_name = ammo_type_name1
	. += span_info("It holds [arrows.len]/[max_storage] [type_name] spheres.")
	if(has_types)
		. += span_info("Use it in hand to recall spheres of the attuned type. Middle-click to convert the spheres inside. Right-click to draw a sphere.")
	else
		. += span_info("Use it in hand to recall spheres. Right-click to draw a sphere.")
	

/obj/item/quiver/twilight_bullet/runicbag/attackby(obj/item/A, mob/user, params)
	if((has_types && istype(A, ammo_type2)) || istype(A, ammo_type1))
		if(eatarrow(A, user))
			to_chat(user, span_notice("You insert \the [A] into \the [src]."))
		else
			to_chat(user, span_warning("\The [src] is full!"))
		return TRUE
	return ..()

/obj/item/quiver/twilight_bullet/runicbag/eatarrow(obj/A, loc)
	if((!has_types || !istype(A, ammo_type2)) && !istype(A, ammo_type1))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = A
	if(ismob(loc))
		var/mob/M = loc
		M.doUnEquip(R, TRUE, src, TRUE, silent = TRUE)
	else
		R.forceMove(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/proc/summon_round(sphere_type)
	if(!ispath(sphere_type, ammo_type1) && (!has_types || !ispath(sphere_type, ammo_type2)))
		return FALSE
	if(arrows.len >= max_storage)
		return FALSE
	var/obj/item/ammo_casing/R = new sphere_type(src)
	arrows += R
	link_casing(R)
	update_icon()
	return TRUE

/obj/item/quiver/twilight_bullet/runicbag/Initialize(mapload)
	. = ..()
	selected_type = ammo_type1
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/R = new selected_type(src)
		arrows += R
		link_casing(R)
	update_icon()

//Smaller, 8-sphere pharetras for the Arbalist's Fusilier option.
/obj/item/quiver/twilight_bullet/runicbag/arbalist
	name = "Fusilier's pharetra"
	desc = "A leather pouch designed to store runic bullets. The rune inscribed on the lock binds to the ammunition stored inside, and upon activation, returns spent runic bullets to the pouch for reuse. This version is meant for the heavier rifle ammo of the Fusilier"
	max_storage = 8
	ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/runed 
	ammo_type2 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/blessed 
	ammo_type_name1 = "heavy runed"
	ammo_type_name2 = "heavy blessed"

/obj/item/quiver/twilight_bullet/runicbag/arbalist/mark
	name = "Markers pouch"
	desc = "A small rune-inscribed pouch for storing and recaling a single marking sphere."
	max_storage = 1
	has_types = FALSE
	ammo_type1 = /obj/item/ammo_casing/caseless/bullet/lead/runelock/heavy/tracker
	ammo_type_name1 = "hunters mark"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_RING
	recall_energy_cost = 100 // special ammo
