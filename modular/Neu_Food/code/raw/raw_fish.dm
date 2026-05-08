/mob/living
	var/hand_fishing_mode = null
	var/hand_fishing_mode_until = 0
	var/turf/hand_fishing_reel_turf = null
	var/hand_fishing_reel_until = 0
	var/hand_fishing_reel_loot = null
	var/hand_fishing_reel_size_tag = null
	/// Temp fishingrod used for the cast hand-fishing minigame UI. Null when not in minigame.
	var/obj/item/fishingrod/hand_fishing_cast_rod = null

/obj/item/reagent_containers/food/snacks/fish
	name = "fish"
	desc = "Fresh blood stains its silvery skin. Silver-coloured scales shimmering softly.."
	icon_state = "carp"
	icon = 'modular/Neu_Food/icons/raw/raw_fish.dmi'
	verb_say = "glubs"
	verb_yell = "glubs"
	obj_flags = CAN_BE_HIT
	var/dead = TRUE
	var/no_rarity_sprite = FALSE // Whether this fish has rarity based sprites. If not, don't change icon states
	var/list/rarity_icon_states = null
	var/sinkable = TRUE
	var/fish_size_tag = "normal"
	var/fish_size_scale = 1
	var/fish_normal_size_scale = 1
	var/default_slice_path = null
	var/mob/hand_reel_user = null
	var/turf/hand_reel_turf = null
	var/hand_reel_until = 0
	var/hand_reel_loot = null
	var/static/list/hand_fishing_modlist = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0,
	)
	var/static/list/hand_fishing_size_weights = list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1)
	max_integrity = 50
	sellprice = 10
	dropshrink = 0.6
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	chopping_sound = TRUE
	var/rarity_rank = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 2)
	cooked_smell = /datum/pollutant/food/cooked_fish

/obj/item/reagent_containers/food/snacks/fish/dead
	dead = TRUE

/obj/item/reagent_containers/food/snacks/fish/Initialize(mapload)
	. = ..()
	default_slice_path = initial(slice_path)
	if(!dead)
		START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/fish/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(dead)
		..()
	else
		var/fishing_skill = 0
		var/perception_stat = 1
		var/speed_stat = 1
		var/mob/living/living_user = null
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			fishing_skill = H.get_skill_level(/datum/skill/labor/fishing)
			perception_stat = max(1, H.STAPER)
			speed_stat = max(1, H.STASPD)
			living_user = H
		else if(isliving(user))
			living_user = user

		if(!living_user)
			return

		if(!living_user.used_intent || (living_user.used_intent.type != ROD_CAST && living_user.used_intent.type != ROD_AUTO))
			living_user.hand_fishing_mode = null
			living_user.hand_fishing_mode_until = 0
			living_user.hand_fishing_reel_turf = null
			living_user.hand_fishing_reel_until = 0
			living_user.hand_fishing_reel_loot = null
			living_user.hand_fishing_reel_size_tag = null
			to_chat(user, span_warning("I need cast or auto intent to hand-fish."))
			return

		if(living_user.used_intent)
			if(living_user.used_intent.type == ROD_CAST || living_user.used_intent.type == ROD_AUTO)
				living_user.hand_fishing_mode = living_user.used_intent.type

		if(!living_user.hand_fishing_mode || world.time > living_user.hand_fishing_mode_until)
			living_user.hand_fishing_mode = null
			living_user.hand_fishing_mode_until = 0
			to_chat(user, span_warning("I need to brace my opposite hand first before hand-fishing."))
			return

		if(living_user.hand_fishing_mode != ROD_CAST && living_user.hand_fishing_mode != ROD_AUTO)
			living_user.hand_fishing_mode = null
			living_user.hand_fishing_mode_until = 0
			to_chat(user, span_warning("I need to enter a hand-fishing stance first."))
			return

		var/turf/src_turf = get_turf(src)
		if(!src_turf || user.z != src_turf.z || get_dist(user, src_turf) > 1)
			to_chat(user, span_warning("It's out of reach. I can only fish by hand in water close to me!"))
			return
		if(istype(src_turf, /turf/open/water/bath) || istype(src_turf, /turf/open/water/sewer))
			to_chat(user, span_warning("I can't fish here..."))
			return

		if(hand_reel_user && QDELETED(hand_reel_user))
			hand_reel_user = null
			hand_reel_turf = null
			hand_reel_until = 0
			hand_reel_loot = null
		if(hand_reel_user == user)
			if(world.time > hand_reel_until || !hand_reel_turf)
				hand_reel_user = null
				hand_reel_turf = null
				hand_reel_until = 0
				hand_reel_loot = null
				to_chat(user, span_warning("I lose the fish's trail."))
				return
			if(get_turf(src) != hand_reel_turf)
				hand_reel_user = null
				hand_reel_turf = null
				hand_reel_until = 0
				hand_reel_loot = null
				to_chat(user, span_warning("It slips to another tile before I can haul it in!"))
				return
			if(user.z != hand_reel_turf.z || get_dist(user, hand_reel_turf) > 1)
				to_chat(user, span_warning("I lose leverage. I need to stay within close proximity to reel by hand."))
				hand_reel_user = null
				hand_reel_turf = null
				hand_reel_until = 0
				hand_reel_loot = null
				return
			var/reel_time = max(4, 16 - round(fishing_skill * 0.5) - round(speed_stat * 0.25))
			if(living_user.hand_fishing_mode == ROD_AUTO)
				reel_time = max(3, reel_time - 2)
			if(!do_after(user, reel_time, target = src))
				return
			var/reel_challenge = get_fishing_path_challenge(hand_reel_loot)
			switch(src.fish_size_tag)
				if("normal")
					reel_challenge += 1
				if("large")
					reel_challenge += 2
				if("huge")
					reel_challenge += 4
				if("prize")
					reel_challenge += 6
			var/reel_chance = clamp(10 + (fishing_skill * 4) + round(speed_stat * 1.5) - (reel_challenge * 6), 2, 75)
			if(living_user.hand_fishing_mode == ROD_CAST)
				reel_chance += 8
			if(prob(reel_chance))
				var/catch_path = hand_reel_loot
				if(!catch_path)
					catch_path = src.type
				if(catch_path == src.type)
					if(istype(src, /obj/item/reagent_containers/food/snacks/fish))
						var/obj/item/reagent_containers/food/snacks/fish/F = src
						apply_fishing_quality_to_fish(F, hand_fishing_modlist, hand_fishing_size_weights)
					if(user.put_in_hands(src))
						to_chat(user, span_notice("I reel [src] in by hand!"))
					else
						src.forceMove(user.drop_location())
						to_chat(user, span_notice("I catch [src], but it slips to the ground."))
				else if(catch_path in subtypesof(/mob/living))
					var/mob/living/target_mob = new catch_path(get_turf(src))
					target_mob.visible_message(span_danger("[target_mob] bursts out of the water!"), span_warning("You surge up from the dark waters!"))
					QDEL_NULL(src)
				else
					var/obj/item/new_catch = new catch_path(user.drop_location())
					if(istype(new_catch, /obj/item/reagent_containers/food/snacks/fish))
						var/obj/item/reagent_containers/food/snacks/fish/F = new_catch
						apply_fishing_quality_to_fish(F, hand_fishing_modlist, hand_fishing_size_weights)
					if(user.put_in_hands(new_catch))
						to_chat(user, span_notice("I reel [new_catch] in by hand!"))
					else
						new_catch.forceMove(user.drop_location())
						to_chat(user, span_notice("I catch [new_catch], but it slips to the ground."))
					QDEL_NULL(src)
				if(living_user)
					var/athletics_skill = max(living_user.get_skill_level(/datum/skill/misc/athletics), 0)
					var/strength_bonus = max(0, living_user.STASTR - 10)
					var/effective_percent = max(1, 25 - athletics_skill - strength_bonus)
					var/stamina_drain = max(1, round((living_user.max_stamina * effective_percent) / 100, 1))
					living_user.stamina_add(stamina_drain)
				hand_reel_user = null
				hand_reel_turf = null
				hand_reel_until = 0
				hand_reel_loot = null
				living_user.hand_fishing_mode = null
				living_user.hand_fishing_mode_until = 0
				return
			hand_reel_user = null
			hand_reel_turf = null
			hand_reel_until = 0
			hand_reel_loot = null
			living_user.hand_fishing_mode = null
			living_user.hand_fishing_mode_until = 0
			if(isturf(user.loc))
				src.forceMove(user.loc)
			apply_fishing_bite_injury(living_user, src)
			to_chat(user, span_warning("Too slippery!"))
			return

		playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
		var/grab_time = max(6, 22 - fishing_skill - round(perception_stat * 0.5))
		if(living_user.hand_fishing_mode == ROD_AUTO)
			grab_time = max(5, grab_time - 2)
		if(!do_after(user, grab_time, target = src))
			return
		var/spot_chance = clamp(4 + (fishing_skill * 5) + round(perception_stat * 1.5), 2, 75)
		if(living_user.hand_fishing_mode == ROD_CAST)
			spot_chance += 8
		if(prob(spot_chance))
			var/loot_path = getfishingloot(user, hand_fishing_modlist, src_turf)
			if(!loot_path)
				loot_path = src.type
			hand_reel_user = user
			hand_reel_turf = get_turf(src)
			hand_reel_until = world.time + max(18, 30 + (fishing_skill * 4) + speed_stat)
			hand_reel_loot = loot_path
			to_chat(user, span_notice("I get a grip on [src]! Click the same tile again to reel it in."))
			return
		if(isturf(user.loc))
			src.forceMove(user.loc)
		living_user.hand_fishing_mode = null
		living_user.hand_fishing_mode_until = 0
		to_chat(user, span_warning("Too slippery!"))
		return

/obj/item/reagent_containers/food/snacks/fish/process()
	if(!isturf(loc)) //no floating out of bags
		return
	if(prob(50) && !dead)
		dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		step(src, dir)

/obj/item/reagent_containers/food/snacks/fish/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/deconstruct()
	if(!dead)
		dead = TRUE
//		icon_state = "[icon_state]"
		STOP_PROCESSING(SSobj, src)
		return 1

/obj/item/reagent_containers/food/snacks/fish/after_throw(datum/callback/callback)
	. = ..()
	sinkable = TRUE
	update_transform()

/obj/item/reagent_containers/food/snacks/fish/attackby(obj/item/W, mob/user, params)
	if(fish_size_tag == "tiny")
		slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/proc/apply_fishing_size(size_tag)
	fish_size_tag = size_tag || "normal"
	fish_size_scale = get_fish_size_scale(fish_size_tag)
	if(fish_size_tag == "normal")
		fish_size_scale *= fish_normal_size_scale
	if(fish_size_tag == "tiny")
		slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	else
		slice_path = default_slice_path || initial(slice_path)
	// Keep fish chop yield aligned with visual tiering.
	if(fish_size_tag == "tiny" || fish_size_tag == "small")
		slices_num = 1
	else if(fish_size_tag == "huge" || fish_size_tag == "prize")
		slices_num = 4
	else
		slices_num = initial(slices_num)
	update_transform()

/obj/item/reagent_containers/food/snacks/fish/update_transform()
	..()
	if(!fish_size_scale || fish_size_scale == 1)
		transform = null
		return
	var/matrix/M = matrix()
	M.Scale(fish_size_scale, fish_size_scale)
	transform = M

/obj/item/reagent_containers/food/snacks/fish/salmon
	name = "salmon"
	desc = "A lonesome, horrific creacher of the freshwaters, searching for a mate. It makes for good eating."
	icon_state = "salmon"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon

/obj/item/reagent_containers/food/snacks/fish/plaice
	name = "plaice"
	desc = "A popular flatfish for eating. Found on tables of noblefolk and peasantry alike."
	icon_state = "plaice"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice

/obj/item/reagent_containers/food/snacks/fish/mudskipper
	name = "mudskipper"
	desc = "A furtive creacher, it hides in murky waters to keep its grotesque visage secreted away."
	icon_state = "mudskipper"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper

/obj/item/reagent_containers/food/snacks/fish/bass
	name = "seabass"
	desc = "I didn't see a bass."
	icon_state = "seabass"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 10
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass

/obj/item/reagent_containers/food/snacks/fish/sunny
	name = "sunny"
	desc = "A pitiful beast, clinging to Astrata's light as if it would make it stronger. Little does it know that it needs faith for such miracles."
	icon_state = "sunny"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 3
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny

/obj/item/reagent_containers/food/snacks/fish/carp
	name = "carp"
	desc = "A mudraking creacher of the river-depths, barely fit for food."
	faretype = FARE_IMPOVERISHED
	icon_state = "carpcom"
	rarity_icon_states = list("com" = "carpcom", "rare" = "carprare", "ultra" = "carpultra", "gold" = "carpgold")
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp

/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "clownfish"
	desc = "This fish brings vibrant hues to the dark world of the vale."
	icon_state = "clownfishcom"
	rarity_icon_states = list("com" = "clownfishcom", "rare" = "clownfishrare", "ultra" = "clownfishultra", "gold" = "clownfishgold")
	no_rarity_sprite = TRUE
	faretype = FARE_NEUTRAL
	sellprice = 40
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish

/obj/item/reagent_containers/food/snacks/fish/angler
	name = "anglerfish"
	desc = "A menacing abyssal predator."
	faretype = FARE_NEUTRAL
	icon_state = "anglercom"
	rarity_icon_states = list("com" = "anglercom", "rare" = "anglerrare", "ultra" = "anglerultra", "gold" = "anglergold")
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler

/obj/item/reagent_containers/food/snacks/fish/eel
	name = "eel"
	desc = "A sinuous eel that slithers through the dark waters."
	icon_state = "eelcom"
	rarity_icon_states = list("com" = "eelcom", "rare" = "eelrare", "ultra" = "eelultra", "gold" = "eelgold")
	faretype = FARE_NEUTRAL
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel

/obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/rare
	eat_effect = list(/datum/status_effect/buff/mealbuff, /datum/status_effect/buff/blessed)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/rare
	eat_effect = list(/datum/status_effect/buff/mealbuff, /datum/status_effect/buff/blessed)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/rare
	eat_effect = list(/datum/status_effect/buff/mealbuff, /datum/status_effect/buff/blessed)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/rare
	eat_effect = list(/datum/status_effect/buff/mealbuff, /datum/status_effect/buff/blessed)

/obj/item/reagent_containers/food/snacks/fish/sole
	name = "sole"
	desc = "An ugly flatfish, slimy and with both eyes on one side of its head. Nothing to do with feet."
	icon_state = "sole"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole

/obj/item/reagent_containers/food/snacks/fish/cod
	name = "cod"
	desc = "A cod, wow! Cod you hand me another piece of bait?"
	icon_state = "cod"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod

/obj/item/reagent_containers/food/snacks/fish/creepy_eel
	name = "abyssal eel"
	desc = "Pick me up pick me up pick me up pick me up pick me up pick me up!"
	icon_state = "creepy_eel"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	var/was_i_picked_up = FALSE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_eel/pickup(mob/living/user)
	if(!was_i_picked_up && ishuman(user))
		teleport_to_dream(user, 1, 1)
		was_i_picked_up = TRUE
		desc = "A slimy eel, you feel a strange mundanity looking at it... You're assured there's nothing weird about it whatsoever. It might as well be the most average thing in the realm."
	..()

/obj/item/reagent_containers/food/snacks/fish/creepy_squid
	name = "brain squid"
	desc = "It makes me feel strange..."
	icon_state = "creepy_squid"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/octopus
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/octopus

/obj/item/reagent_containers/food/snacks/fish/octopus
	name = "octopus"
	desc = "A many-armed deepwater hunter. Its flesh is chewy but rich once cooked."
	icon_state = "octopuscom"
	faretype = FARE_NEUTRAL
	rarity_icon_states = list("com" = "octopuscom", "rare" = "octopusrare", "ultra" = "octopusultra", "gold" = "octopusgold")
	sellprice = 25
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/octopus
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/octopus

/obj/item/reagent_containers/food/snacks/fish/creepy_squid/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && !HAS_TRAIT(H, TRAIT_NOMOOD) && H.patron.type != /datum/patron/divine/abyssor)
		. += span_danger("As I behold the squid closely, I can see its body extend into the spectral shape of a vicious, horrific creature. Countless tentacles lead into innumerable spiny limbs with vicious looking spikes. A singular, gigantic eye stares back at me. The image fades...")
		H.add_stress(/datum/stressevent/creepy_squid)
		H.emote("scream")
		H.Knockdown(1)
	else if(H.patron.type == /datum/patron/divine/abyssor)
		. += span_notice("It's the most beautiful creature I have ever laid my eyes upon.")
		user.add_stress(/datum/stressevent/creepy_squid_happy)

/datum/stressevent/creepy_squid
	timer = 5 MINUTES
	stressadd = 2
	desc = span_danger("I don't know what I saw, but I can still see parts of that horrific form in the corners of my vision.")

/datum/stressevent/creepy_squid_happy
	timer = 25 MINUTES
	stressadd = -1
	desc = span_notice("Seeing that beautiful squid made me really happy!")

/obj/item/reagent_containers/food/snacks/fish/creepy_shark
	name = "iridescent reaver"
	desc = "It's scales refract light in a strange, unsettling manner."
	icon_state = "creepy_shark"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0
	var/loot_spawn_cooldown

// I'll probably give this a cooler effect later, but scope creep ahhh.
/obj/item/reagent_containers/food/snacks/fish/creepy_shark/attack_self(mob/user)
	if(world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		to_chat(user, span_warning("The [src] feels inert. It will take about [minutes_left] more minutes before it can produce again."))
		return TRUE

	var/obj/effect/spawner/lootdrop/roguetown/abyssor/table = new /obj/effect/spawner/lootdrop/roguetown/abyssor
	var/list/loot_table = table.loot
	if(!loot_table || !loot_table.len)
		to_chat(user, span_warning("The [src] shimmers faintly, but nothing happens."))
		return TRUE

	var/lootspawn = pickweight(loot_table)

	if(!lootspawn)
		to_chat(user, span_warning("The [src] shimmers faintly, but nothing happens."))
		return TRUE

	var/obj/item/I = new lootspawn()

	if(user.put_in_hands(I))
		to_chat(user, span_notice("The [src] shimmers, and you feel the weight of [I] materialize in your hand!"))
	else
		I.forceMove(user.drop_location())
		to_chat(user, span_notice("The [src] shimmers, and [I] appears at your feet!"))

	loot_spawn_cooldown = world.time + 30 MINUTES
	return TRUE

/obj/item/reagent_containers/food/snacks/fish/creepy_shark/examine(mob/user)
	. = ..()
	if(loot_spawn_cooldown && world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		. += span_notice("It feels inert and cannot be squeezed yet. About [minutes_left] more minutes required.")
	else
		. += span_notice("You swear you can hear it demand you squeeze it in your hand.")

/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed
	name = "black-headed salmon"
	desc = "Black-Headed Salmon is an ocean fish found in open salt waters, recognizable by its dark head and lighter body. It is fully edible and prized for its firm, tasty meat, and the dark coloration likely helps it blend in when hunting near the surface."
	icon_state = "salmon_black"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	sellprice = 17

/obj/item/reagent_containers/food/snacks/fish/flounder
	name = "flounder"
	desc = "Flounder is a flat ocean fish living in open salt waters, well adapted to life along the seabed. It is fully edible and known for its mild, tender meat, and an interesting fact is that both of its eyes are located on one side of the body, helping it stay hidden while lying flat on the ocean floor."
	icon_state = "flounder"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/swamp_shrimp
	name = "swamp shrimp"
	icon_state = "swamp_shrimp"
	desc = "Swamp \"Shrimp\" is a small crustacean found in murky swamp waters, adapted to survive in dirty, low-oxygen water."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/swamp_mother
	name = "swamp mother"
	icon_state = "swamp_mother"
	desc = "Swamp Mother is a large swamp-dwelling creature found in murky waters."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	sellprice = 15

/obj/item/reagent_containers/food/snacks/fish/black_bass
	name = "black bass"
	icon_state = "black_bass"
	desc = "Black Bass is a freshwater fish found in clean rivers and lakes, known for its strength and aggressive behavior. It is fully edible and popular for its firm meat, and a fun fact is that black bass are notorious for fighting hard even when caught on light tackle."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	sellprice = 7

/obj/item/reagent_containers/food/snacks/fish/zizo_abberation
	name = "zizo abberation"
	icon_state = "zizo_abberation"
	desc = "Zizo Aberration is a cave-dwelling creature found in murky underground waters. It is edible, but widely nicknamed the “Zizo creature” due to its disgusting behavior, it viciously bites any hand that comes into contact with it, whether in water or out."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	sellprice = 20

/obj/item/reagent_containers/food/snacks/fish/zizo_abberation/attack_hand(mob/living/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(H.gloves)
		return ..()
	if(H.get_active_held_item() == src)
		return ..()
	var/hand_zone = (H.active_hand_index == 1) ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND
	var/arm_zone = (hand_zone == BODY_ZONE_PRECISE_L_HAND) ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM
	var/obj/item/bodypart/BP = H.get_bodypart(hand_zone)
	if(!BP)
		BP = H.get_bodypart(arm_zone)
	if(!BP)
		BP = H.get_bodypart(BODY_ZONE_CHEST)
	playsound(get_turf(H), pick('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg'), 60, TRUE)
	H.visible_message(span_danger("[H] recoils as [src] bites into [H.p_their()] hand!"), span_danger("[src] snaps at my hand and bites down!"))
	H.apply_damage(rand(4, 8), BRUTE, BP)
	if(prob(60))
		BP.add_wound(/datum/wound/bite/small)
	return TRUE

/obj/item/reagent_containers/food/snacks/fish/sturgeon
	name = "sturgeon"
	icon_state = "sturgeon"
	desc = "Sturgeon is a large freshwater fish found in clean rivers and waterfalls, known for its ancient appearance and heavy armor-like scales. It is fully edible and highly valued, and an interesting fact is that sturgeons have existed for over 200 million years, making them true living fossils."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/mackerel
	name = "mackerel"
	icon_state = "mackerel"
	desc = "Mackerel is a fast-moving ocean fish found in open salt waters. It is fully edible, rich in oils and flavor, and known for its speed, mackerel can swim so fast it must keep moving to breathe properly."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	sellprice = 5

/obj/item/reagent_containers/food/snacks/fish/beaksnapper
	name = "beaksnapper"
	icon_state = "beaksnapper"
	desc = "Beaksnapper is a colorful ocean fish found in salt waters, named for its strong, beak-like mouth. It is edible and prized for its firm meat, and fun fact: its snapping bite is strong enough to crush small shells, making it a clever little predator."
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	sellprice = 15
