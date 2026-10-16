//Thug statues, intended for Thugs. God forgive me for the...Bloat...Please help me if its too bloated...//

/obj/structure/fluff/statue/gang
	name = "unclaimed flat stick"
	desc = "A flat, unmarked stick. Perhaps it could be used to make a statement."
	icon_state = "gangneutral"
	icon = 'icons/roguetown/misc/structure.dmi'
	max_integrity = 89999
	var/being_captured = FALSE
	var/capture_time = 12 SECONDS
	var/intimidation_range = 8
	var/belongs_to = null
	var/list/reward_pool
	var/next_business_cycle = 0

/obj/structure/fluff/statue/gang/attack_hand(mob/user)	//simple structure to switch states between the three modes, relevant to user traits.
	. = ..()
	if(belongs_to == null)
		if(HAS_TRAIT(user, TRAIT_GANG_A))
			who_captures("Rontz", user)
			return
		else if(HAS_TRAIT(user, TRAIT_GANG_B))
			who_captures("Blortz", user)
			return
	else if(belongs_to == "Blortz")
		if(HAS_TRAIT(user, TRAIT_GANG_A))
			who_captures("Rontz", user)
			return
		else if(HAS_TRAIT(user, TRAIT_TROUBLEMAKER_KNOWER))
			who_captures(null, user)
			return
	else if(belongs_to == "Rontz")
		if(HAS_TRAIT(user, TRAIT_GANG_B))
			who_captures("Blortz", user)
			return
		else if(HAS_TRAIT(user, TRAIT_TROUBLEMAKER_KNOWER))
			who_captures(null, user)
			return

/obj/structure/fluff/statue/gang/proc/who_captures(new_owner, mob/user)	//Is the object being captured? And when should the object transform states? Answers those.
	if(being_captured)
		to_chat(user, span_warning("This stone is already bein' claimed!"))
		return

	being_captured = TRUE

	if(new_owner == null)
		user.visible_message(
			span_warning("[user] begins unwrapping a cloth around the pillar!"),
			span_warning("I start ripping the cloth around the stone.")
		)
	else
		user.visible_message(
			span_warning("[user] begins wrapping a cloth around the stick!"),
			span_warning("I begin wrapping my colours around the stick!")
		)

	playsound(src, "rustle", 70, FALSE)
	
	if(do_after(user, capture_time, src))
		change_ownership(new_owner)
		user.visible_message(
			span_warning("[user] is done with the stick."),
			span_warning("It is done.")
		)
	else
		user.visible_message(
			span_warning("[user] gets interrupted whilst fiddling with  the cloth!"),
			span_warning("I get interrupted whilst fiddling with the cloth!")
		)

	being_captured = FALSE

/obj/structure/fluff/statue/gang/proc/change_ownership(new_owner)	//For a more compact code. Thanks to these maptainers will have an easier time mapping the thug-areas.
	belongs_to = new_owner

	switch(belongs_to)
		if("Rontz")
			name = "stick with a cloth"
			desc = "A wooden stick with a red cloth wrapped around the tip."
			icon_state = "rontzthug"
		if("Blortz")
			name = "stick with a cloth"
			desc = "A wooden stick with a blue cloth wrapped around the tip."
			icon_state = "blortzthug"
		if(null)
			name = "unclaimed flat stick"
			desc = "A flat, unmarked stick. Perhaps it could be used to make a statement."
			icon_state = "gangneutral"

/obj/structure/fluff/statue/gang/Initialize(mapload)	//The thug-specific debuffs come in. Do the thug shake now.
	. = ..()
	next_business_cycle = world.time + 10 SECONDS
	START_PROCESSING(SSobj, src)
	
/obj/structure/fluff/statue/gang/process()

	if(world.time >= next_business_cycle)
		reward_spawn()
		next_business_cycle = world.time + 7 SECONDS

	if(belongs_to == null)
		return

	for(var/mob/living/carbon/human/H in viewers(intimidation_range, src))
		if(belongs_to == "Blortz")
			if(HAS_TRAIT(H, TRAIT_GANG_A))
				if(!H.has_status_effect(/datum/status_effect/debuff/blortzterritory))
					H.apply_status_effect(/datum/status_effect/debuff/blortzterritory)
		else if(belongs_to == "Rontz")
			if(HAS_TRAIT(H, TRAIT_GANG_B))
				if(!H.has_status_effect(/datum/status_effect/debuff/rontzterritory))
					H.apply_status_effect(/datum/status_effect/debuff/rontzterritory)

/obj/structure/fluff/statue/gang/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/fluff/statue/gang/examine(mob/user)
	. = ..()
	if (HAS_TRAIT(user, TRAIT_GANG_A) || HAS_TRAIT(user, TRAIT_GANG_B) || HAS_TRAIT(user, TRAIT_TROUBLEMAKER_KNOWER))
		if(!belongs_to == null)
			to_chat(user, span_notice("This area is claimed by [belongs_to]"))

/obj/structure/fluff/statue/gang/proc/reward_spawn()
	if(belongs_to == null)
		return
	var/list/valid_turf = list()
	for(var/turf/T in range(1,src))
		if(T.density)
			continue
		valid_turf += T
	
	var/turf/item_spawn_turf = pick(valid_turf)
	src.visible_message(span_warning("Freshly found goods are gathered around the stick!"))
	playsound(src.loc, 'sound/foley/cartdump.ogg', 100, FALSE, -1)

	for (var/i in 1 to 3)
		var/possible_item = pick(reward_pool)
		var/quantity = reward_pool[possible_item]

		for(var/j in 1 to quantity)
			new possible_item(item_spawn_turf)

// 20 items per pool for 5% chance of something spawning. RNGod can favor one item and it can spawn 3 times, still. Not a problem though.

/obj/structure/fluff/statue/gang/watchtower	//meant for alleyways.
	reward_pool = list(
		/obj/item/impact_grenade/smoke = 2,
		/obj/item/roguecoin/gold = 1,
		/obj/item/roguecoin/silver = 2,
		/obj/item/roguecoin/copper/pile = 4,
		/obj/item/lockpick = 1,
		/obj/item/lockpickring = 1,
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/quiver/sling/iron = 1,
		/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 1,
		/obj/item/rogueweapon/flail/militia = 1,
		/obj/item/rogueweapon/woodstaff/militia = 1,
		/obj/item/rogueweapon/greataxe/militia = 1,
		/obj/item/rogueweapon/spear/militia = 1,
		/obj/item/rogueweapon/pick/militia = 1,
		/obj/item/rogueweapon/sword/falchion/militia = 1,
		/obj/item/rogueweapon/mace/woodclub = 1,
		/obj/item/rope = 2,
		/obj/item/rope/chain = 1,
		/obj/item/storage/roguebag = 2,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife = 2
	)

/obj/structure/fluff/statue/gang/bathhouse	//meant for whitevein-esque areas.
	reward_pool = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/powder/ozium = 2,
		/obj/item/reagent_containers/powder/moondust = 1,
		/obj/item/reagent_containers/powder/spice = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/redwine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/whitewine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/zagul = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter = 1,
		/obj/item/rogueweapon/whip = 1,
		/obj/item/clothing/neck/roguetown/gorget/cursed_collar = 1,
		/obj/item/clothing/neck/roguetown/collar/leather = 1,
		/obj/item/reagent_containers/glass/bottle = 2,
		/obj/item/clothing/ring/silver = 1,
		/obj/item/clothing/neck/roguetown/psicross/shell = 1,
	)

/obj/structure/fluff/statue/gang/docks	//meant for dock-esque areas. General supplies, tools, anything a thug can intercept and steal form trade ships.
	reward_pool = list(
		/obj/item/roguecoin/gold = 1,
		/obj/item/roguecoin/silver = 3,
		/obj/item/roguecoin/copper/pile = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/sword/cutlass = 1,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 5,
		/obj/item/reagent_containers/food/snacks/fish/plaice = 2,
		/obj/item/reagent_containers/food/snacks/fish/bass = 2,
		/obj/item/reagent_containers/food/snacks/fish/eel = 1,
		/obj/item/natural/cloth/bandage = 1,
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 5,
		/obj/item/natural/stone = 2,
		/obj/item/grown/log/tree/small = 3,
		/obj/item/natural/wood/plank = 2,
		/obj/item/ingot/iron = 1,
		/obj/item/rogueore/iron = 3,
		/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
)
