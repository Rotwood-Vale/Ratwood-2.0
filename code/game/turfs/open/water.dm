///////////// OVERLAY EFFECTS /////////////
/obj/effect/overlay/water
	icon = 'icons/turf/newwater.dmi'
	icon_state = "bottom"
	density = 0
	mouse_opacity = 0
	layer = BELOW_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = BELOW_MOB_LAYER


/turf/open/water
	gender = PLURAL
	name = "water"
	desc = "Good enough to drink, wet enough to douse fires."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "together"
	baseturfs = /turf/open/water
	slowdown = 5
	var/obj/effect/overlay/water/water_overlay
	var/obj/effect/overlay/water/top/water_top_overlay
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral,/turf/closed/wall/mineral/rogue, /turf/open/floor/rogue)
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	landsound = 'sound/foley/jumpland/waterland.wav'
	neighborlay_override = "edge"
	var/water_color = "#6a9295"
	var/water_reagent = /datum/reagent/water
	var/water_reagent_purified = /datum/reagent/water // If put through a water filtration device, provides this reagent instead
	var/mapped = TRUE // infinite source of water
	var/water_volume = 100 // 100 is 1 bucket
	var/water_maximum = 100
	water_level = 2
	var/wash_in = TRUE
	var/swim_skill = FALSE
	nomouseover = FALSE
	var/swimdir = FALSE
	temperature = 210
	var/last_fish_release_splash = 0

/turf/open/water/Initialize(mapload)
	.  = ..()
	water_overlay = new(src)
	water_top_overlay = new(src)
	update_icon()

/turf/open/water/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user

		// Stage 3 (CAST minigame running): forward reel input regardless of current intent.
		if(L.hand_fishing_cast_rod)
			if(!QDELETED(L.hand_fishing_cast_rod) && L.hand_fishing_cast_rod.currentlyfishing)
				if(L.z == src.z)
					L.hand_fishing_cast_rod.reel_input_zone = L.hand_fishing_cast_rod.current_fish_zone
					L.hand_fishing_cast_rod.reel_input = TRUE
			else
				L.hand_fishing_cast_rod = null
				L.hand_fishing_mode = null
				L.hand_fishing_mode_until = 0
				L.hand_fishing_reel_size_tag = null
			return

		var/using_hand_intent = L.used_intent && (L.used_intent.type == ROD_CAST || L.used_intent.type == ROD_AUTO)
		if(!using_hand_intent)
			L.hand_fishing_mode = null
			L.hand_fishing_mode_until = 0
			L.hand_fishing_reel_turf = null
			L.hand_fishing_reel_until = 0
			L.hand_fishing_reel_loot = null
			L.hand_fishing_reel_size_tag = null
		else
			// Stage 1 (no pending reel): always read current intent so switching between cast/auto works.
			// Stage 2+: use the intent locked when the bite was found.
			var/active_mode
			if(L.hand_fishing_reel_loot)
				active_mode = L.hand_fishing_mode
			else
				active_mode = L.used_intent.type
			if(active_mode == ROD_CAST || active_mode == ROD_AUTO)
				if(!ishuman(user))
					to_chat(user, span_warning("I can't fish by hand like this."))
					return
				if(istype(src, /turf/open/water/bath) || istype(src, /turf/open/water/sewer))
					to_chat(user, span_warning("I can't fish here..."))
					return
				if(user.z != src.z || get_dist(user, src) > 1)
					to_chat(user, span_warning("It's out of reach. I can only fish by hand in water close to me!"))
					return
				var/mob/living/carbon/human/H = user
				var/sl = H.get_skill_level(/datum/skill/labor/fishing)
				var/per_mod = clamp(H.get_stat(STATKEY_PER), 1, 20)
				var/speed_mod = clamp(H.get_stat(STATKEY_SPD), 1, 20)
				var/fpp = 130 - (40 + (sl * 15))
				var/shore_distance = get_fishing_excluded_turf_distance(src, 6)
				var/near_shore_penalty = max(3 - shore_distance, 0)
				var/shallow_excluded_junk_zone = FALSE
				if(istype(src, /turf/open/water/cleanshallow))
					near_shore_penalty = max(near_shore_penalty, 1)
					if(shore_distance <= 3)
						shallow_excluded_junk_zone = TRUE
				if(shore_distance <= 3)
					shallow_excluded_junk_zone = TRUE
					near_shore_penalty = max(near_shore_penalty, 3)

				// Stage 2: reel click after stage 1 found a bite.
				if(H.hand_fishing_reel_loot)
					if(world.time > H.hand_fishing_reel_until || !H.hand_fishing_reel_turf)
						H.hand_fishing_mode = null
						H.hand_fishing_mode_until = 0
						H.hand_fishing_reel_turf = null
						H.hand_fishing_reel_until = 0
						H.hand_fishing_reel_loot = null
						H.hand_fishing_reel_size_tag = null
						to_chat(user, span_warning("I lose the fish's trail."))
						return
					if(src != H.hand_fishing_reel_turf)
						to_chat(user, span_warning("I need to strike the same area of water to reel it in!"))
						return
					playsound(src, 'sound/items/fishing_plouf.ogg', 100, TRUE)
					var/reel_time = round(max(10, 45 - (sl * 3) - (speed_mod * 2)) * 1.5)
					if(!do_after(user, reel_time, target = user))
						return
					if(user.mind)
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, 1, FALSE)
					var/reel_result = H.hand_fishing_reel_loot
					to_chat(user, span_notice("[get_fishing_size_feel_text(H.hand_fishing_reel_size_tag, reel_result)]"))
					var/reel_challenge = get_fishing_path_challenge(reel_result)
					var/reel_chance = clamp(30 + (sl * 8) + (speed_mod * 3) - (reel_challenge * 8), 5, 98)
					if(active_mode == ROD_AUTO)
						reel_chance = clamp(reel_chance - 12 - (near_shore_penalty * 8) - (shallow_excluded_junk_zone ? 10 : 0), 5, 98)
					else
						reel_chance = clamp(reel_chance - 6 - (near_shore_penalty * 4), 5, 98)
					H.hand_fishing_reel_turf = null
					H.hand_fishing_reel_until = 0
					H.hand_fishing_reel_loot = null
					H.hand_fishing_reel_size_tag = null
					if(!prob(reel_chance))
						H.hand_fishing_mode = null
						H.hand_fishing_mode_until = 0
						apply_fishing_bite_injury(H, src)
						to_chat(user, span_warning("Damn, it slips away as I pull!"))
						return
					if(active_mode == ROD_AUTO)
						// Auto: direct catch with no minigame.
						var/auto_hand_stamina = get_hand_fishing_stamina_drain(H, 48.75)
						if(auto_hand_stamina && !H.stamina_add(auto_hand_stamina))
							H.hand_fishing_mode = null
							H.hand_fishing_mode_until = 0
							H.hand_fishing_reel_turf = null
							H.hand_fishing_reel_until = 0
							H.hand_fishing_reel_loot = null
							H.hand_fishing_reel_size_tag = null
							to_chat(user, span_warning("I'm too exhausted to haul it in."))
							return
						if(ispath(reel_result, /mob/living/simple_animal/hostile))
							new reel_result(src)
						else if(ispath(reel_result, /mob))
							new reel_result(user.loc)
						else
							var/obj/item/new_catch_auto = new reel_result(user.drop_location())
							if(istype(new_catch_auto, /obj/item/reagent_containers/food/snacks/fish))
								var/obj/item/reagent_containers/food/snacks/fish/F_auto = new_catch_auto
								apply_fishing_quality_to_fish(F_auto, list(
									"commonFishingMod" = 1,
									"rareFishingMod" = 1,
									"treasureFishingMod" = 1,
									"trashFishingMod" = 1,
									"dangerFishingMod" = 1,
									"ceruleanFishingMod" = 0,
									"cheeseFishingMod" = 0,
								), list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1))
						H.adjust_experience(/datum/skill/labor/fishing, 20)
						playsound(src, 'sound/items/Fish_out.ogg', 100, TRUE)
						to_chat(user, span_notice("Pull 'em in!"))
						H.hand_fishing_mode = null
						H.hand_fishing_mode_until = 0
						return
					// Cast: spawn the fishing UI minigame. Subsequent water clicks set reel_input.
					var/obj/item/fishingrod/temp_rod = new /obj/item/fishingrod(null)
					H.hand_fishing_cast_rod = temp_rod
					H.hand_fishing_mode = null
					H.hand_fishing_mode_until = 0
					playsound(src, 'sound/items/fishing_plouf.ogg', 100, TRUE)
					to_chat(user, span_notice("I've got something! Strike the same area of water to haul it in!"))
					var/turf/water_turf_ref = src
					spawn()
						temp_rod.begin_hand_fishing_cast_minigame(H, reel_result, water_turf_ref)
					return

				// Stage 1: cast/search by hand.
				user.visible_message("<span class='warning'>[user] strikes their hand into the water!</span>", \
								"<span class='notice'>I strike into the water.</span>")
				playsound(src, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				var/ft = 150
				ft -= (sl * 20)
				ft -= (per_mod * 2)
				if(active_mode == ROD_AUTO)
					ft += 20
				ft = round(ft * 1.5)
				ft = max(20, ft)
				if(do_after(user, ft, target = user))
					var/thrust_drain_pct = (active_mode == ROD_AUTO) ? 32.5 : 25
					var/thrust_stamina_drain = get_hand_fishing_stamina_drain(H, thrust_drain_pct)
					if(thrust_stamina_drain && !H.stamina_add(thrust_stamina_drain))
						to_chat(user, span_warning("I'm too exhausted to thrust into the water."))
						return
					var/fishchance = 100
					fishchance += per_mod
					fishchance += 10
					if(shore_distance <= 3)
						fishchance += 20
						fishchance = round(fishchance * 2)
					fishchance -= near_shore_penalty * 20
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					if(active_mode == ROD_AUTO)
						fishchance -= 20
					if(shallow_excluded_junk_zone)
						fishchance -= 15
					fishchance = clamp(fishchance, 2, 98)
					if(prob(fishchance))
						var/list/hand_mods = list(
							"commonFishingMod" = 1,
							"rareFishingMod" = 1,
							"treasureFishingMod" = 1,
							"trashFishingMod" = 1,
							"dangerFishingMod" = 1,
							"ceruleanFishingMod" = 0,
							"cheeseFishingMod" = 0,
						)
						if(shallow_excluded_junk_zone)
							hand_mods["force_common_rarity"] = TRUE
							hand_mods["force_nonprize_size"] = TRUE
							hand_mods["trashFishingMod"] = 2
							hand_mods["rareFishingMod"] = 0
							hand_mods["treasureFishingMod"] = 0
						var/A = get_handfishingloot(H, hand_mods, src)
						if(A)
							H.hand_fishing_reel_turf = src
							H.hand_fishing_reel_until = world.time + max(20, 35 + (sl * 6) + (speed_mod * 2))
							H.hand_fishing_reel_loot = A
							H.hand_fishing_reel_size_tag = get_fishing_size_tag_from_catch_path(A)
							H.hand_fishing_mode = active_mode
							to_chat(user, span_notice("Something tugs at my hand! Strike the same area of water to reel."))
							to_chat(user, span_notice("[get_fishing_size_feel_text(H.hand_fishing_reel_size_tag, A)]"))
							src.balloon_alert_to_viewers("Tug!")
							playsound(src, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							return
					else
						to_chat(user, span_warning("Not a single fish..."))
				else
					to_chat(user, span_warning("I must stand still to fish."))
				return
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(H, TRAIT_MIRROR_MAGIC))
		to_chat(H, span_info("You gaze at your reflection in the water, concentrating on the glamoring magicks..."))
		if(do_after(H, 3 SECONDS, src))
			perform_mirror_transform(H)
		return
	else
		to_chat(H, span_notice("You see your reflection in the water."))
		return

/turf/open/water/update_icon()
	if(water_overlay)
		water_overlay.color = water_color
		water_overlay.icon_state = "bottom[water_level]"
	if(water_top_overlay)
		water_top_overlay.color = water_color
		water_top_overlay.icon_state = "top[water_level]"

/turf/open/water/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(isliving(user) && !user.is_floor_hazard_immune())
			for(var/obj/structure/S in src)
				if(S.obj_flags & BLOCK_Z_OUT_DOWN)
					return
			if(water_overlay)
				if((get_dir(src, newloc) == SOUTH))
					water_overlay.layer = BELOW_MOB_LAYER
					water_overlay.plane = GAME_PLANE
				else
					spawn(6)
						if(!locate(/mob/living) in src)
							water_overlay.layer = BELOW_MOB_LAYER
							water_overlay.plane = GAME_PLANE
			var/drained = get_stamina_drain(user, get_dir(src, newloc))
			if(drained && !user.stamina_add(drained))
				user.Immobilize(30)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, Knockdown), 30), 1 SECONDS)

/turf/open/water/proc/get_stamina_drain(mob/living/swimmer, travel_dir)
	var/const/BASE_STAM_DRAIN = 15
	var/const/MIN_STAM_DRAIN = 2
	var/const/STAM_PER_LEVEL = 5
	var/const/UNSKILLED_ARMOR_PENALTY = 40
	var/const/HEAVY_ARMOR_PENALTY = 30
	var/const/MEDIUM_ARMOR_PENALTY = 20
	var/const/BASE_XP_GAIN = 0.5
	var/const/HEAVY_XP_GAIN = 0.01
	var/const/MEDIUM_XP_GAIN = 0.05
	if(!isliving(swimmer))
		return 0
	if(!isnull(swimmer.grabbedby))
		for(var/obj/item/grabbing/active_grab in swimmer.grabbedby)
			if(active_grab.grabbed == active_grab.grabbee)
				continue
			return 0
	if(!swim_skill)
		return 0 // no stam cost
	if(swimmer.is_floor_hazard_immune())
		return 0 // floating!
	if(swimdir && travel_dir && travel_dir == dir)
		return 0 // going with the flow
	if(swimmer.buckled)
		return 0
	if(!ishuman(swimmer))
		return 0
	var/mob/living/carbon/human/H = swimmer
	var/ac = H.highest_ac_worn(check_hands = TRUE)
	var/xpmod = BASE_XP_GAIN
	var/base_drain = BASE_STAM_DRAIN

	switch(ac)
		if(ARMOR_CLASS_HEAVY)
			xpmod = HEAVY_XP_GAIN
			base_drain = HEAVY_ARMOR_PENALTY
		if(ARMOR_CLASS_MEDIUM)
			xpmod = MEDIUM_XP_GAIN
			base_drain = MEDIUM_ARMOR_PENALTY

	var/abyssor_swim_bonus = HAS_TRAIT(swimmer, TRAIT_ABYSSOR_SWIM) ? 5 : 0
	var/swimming_skill_level = swimmer.get_skill_level(/datum/skill/misc/swimming)
	. = max(base_drain - (swimming_skill_level * STAM_PER_LEVEL) - abyssor_swim_bonus, MIN_STAM_DRAIN)
	if(swimmer.mind)
		swimmer.mind.add_sleep_experience(/datum/skill/misc/swimming, swimmer.STAINT * xpmod)
//	. += (swimmer.checkwornweight()*2)
	if(!swimmer.check_armor_skill())
		. += UNSKILLED_ARMOR_PENALTY
	if(.) // this check is expensive so we only run it if we do expect to use stamina
		for(var/obj/structure/S in src)
			if(S.obj_flags & BLOCK_Z_OUT_DOWN)
				return 0
		for(var/D in GLOB.cardinals) //adjacent to a floor to hold onto
			if(istype(get_step(src, D), /turf/open/floor))
				return 0

// Mobs won't try to path through water if low on stamina,
// and will take advantage of water flow to move faster.
/turf/open/water/get_heuristic_slowdown(mob/traverser, travel_dir)
	/// Mobs will heavily avoid pathing through this turf if their stamina is too low.
	var/const/LOW_STAM_PENALTY = 7 // only go through this if we'd have to go offscreen otherwise
	. = ..()
	if(isliving(traverser) && !HAS_TRAIT(traverser, TRAIT_INFINITE_STAMINA))
		var/mob/living/living_traverser = traverser
		var/remaining_stamina = (living_traverser.max_stamina - living_traverser.stamina)
		if(remaining_stamina < get_stamina_drain(living_traverser, travel_dir)) // not enough stamina reserved to cross
			. += LOW_STAM_PENALTY // really want to avoid this unless we don't have any better options

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	..()
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg','sound/foley/water_land3.ogg'), 100, FALSE)


/turf/open/water/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/water/roguesmooth(adjacencies)
	var/list/Yeah = ..()
	if(water_overlay)
		water_overlay.cut_overlays(TRUE)
		if(Yeah)
			water_overlay.add_overlay(Yeah)
	if(water_top_overlay)
		water_top_overlay.cut_overlays(TRUE)
		if(Yeah)
			water_top_overlay.add_overlay(Yeah)

/turf/open/water/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(istype(AM, /obj/item/reagent_containers/food/snacks/fish))
		var/obj/item/reagent_containers/food/snacks/fish/F = AM
		if (F.sinkable)
			if(world.time > last_fish_release_splash + 2)
				last_fish_release_splash = world.time
				playsound(src, 'sound/items/fishing_plouf.ogg', 55, FALSE)
			SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_FISH_RELEASED, F.type, F.rarity_rank)
			F.visible_message("<span class='warning'>[F] dives into \the [src] and disappears!</span>")
			qdel(F)
	if(isliving(AM) && !AM.throwing)
		var/mob/living/L = AM
		var/in_dinghy = istype(L.buckled, /obj/vehicle/ridden/dinghy)
		if(HAS_TRAIT(L, TRAIT_CURSE_ABYSSOR))
			L.freak_out()
			L.visible_message(span_warning("[L] spasms violently upon touching the water!"), span_danger("The water... it burns me!"))
			L.adjustFireLoss(25)
			return
		if (istype(src,/turf/open/water/bloody))
			L.add_mob_blood(L)

		if(!(L.movement_type & FLYING) && !in_dinghy)
			if(!(L.mobility_flags & MOBILITY_STAND) || water_level == 3)
				L.SoakMob(FULL_BODY)
			else
				if(water_level == 2)
					L.SoakMob(BELOW_CHEST)
			if(water_overlay)
				if(water_level > 1 && !istype(oldLoc, type))
					playsound(AM, 'sound/foley/waterenter.ogg', 100, FALSE)
				else
					playsound(AM, pick('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg'), 100, FALSE)
				if(istype(oldLoc, type) && (get_dir(src, oldLoc) != SOUTH))
					water_overlay.layer = ABOVE_MOB_LAYER
					water_overlay.plane = water_overlay.plane = GAME_PLANE_HIGHEST
				else
					spawn(6)
						if(AM.loc == src)
							water_overlay.layer = ABOVE_MOB_LAYER
							water_overlay.plane = GAME_PLANE_HIGHEST

			if(temperature <= 250 && L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 10)	//swimming in cold water will cool you down and chill you.
				L.adjust_bodytemperature(-5)
				L.update_health_hud()
		if(!istype(L, /mob/living/carbon/human/species/skeleton))
			return
		if(!istype(src, /turf/open/water/sewer))
			return
		if(!istype(src, /turf/open/water/swamp))
			return
		L.apply_damage(30, BRUTE, BODY_ZONE_CHEST, forced = TRUE)
		to_chat(L, span_warningbig("The water seeps into my pores. I am crumbling!"))

/turf/open/water/attackby(obj/item/C, mob/user, params)
	if(user.used_intent.type == /datum/intent/fill)
		if(C.reagents)
			if(C.reagents.holder_full())
				to_chat(user, span_warning("[C] is full."))
				return
			playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
			if(do_after(user, 8, target = src))
				user.changeNext_move(CLICK_CD_MELEE)
				C.reagents.add_reagent(water_reagent, 300)
				to_chat(user, span_notice("I fill [C] from [src]."))
				// If the user is filling a water purifier and the water isn't already clean...
				if (istype(C, /obj/item/reagent_containers/glass/bottle/waterskin/purifier) && water_reagent != water_reagent_purified)
					var/obj/item/reagent_containers/glass/bottle/waterskin/purifier/P = C
					P.cleanwater(user)
			return

	if(ishuman(user) && istype(C, /obj/item/handmirror))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_MIRROR_MAGIC))
			to_chat(H, span_notice("To change yourself via water reflection, use your bare hands on the water."))
			return
	. = ..()

/turf/open/water/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		var/obj/item2wash = user.get_active_held_item()
		if(!item2wash)
			if(istype(src, /turf/open/water/bath) && ishuman(user))
				var/mob/living/carbon/human/bather = user
				bather.relaxing_bath(1)
				return
			user.visible_message(span_info("[user] starts to wash in [src]."))
			if(do_after(L, 3 SECONDS, target = src))
				if(wash_in)
					wash_atom(user, CLEAN_STRONG)
					user.remove_stress(/datum/stressevent/sewertouched)
				playsound(user, pick(wash), 100, FALSE)
				L.adjust_fire_stacks(-100)
				if(temperature < 250 && L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 75)	//washing yourself helps to cool you off.
					L.adjust_bodytemperature(-75)
					L.update_health_hud()
				if(temperature >= 300)	//bathhouses, predominantly
					if(L.bodytemperature < BODYTEMP_NORMAL_MIN)	//washing yourself helps to warm you up.
						L.adjust_bodytemperature(75)
						L.update_health_hud()
					if(L.bodytemperature > BODYTEMP_NORMAL_MAX)	//washing yourself helps to cool you off.
						L.adjust_bodytemperature(-75)
						L.update_health_hud()
				if(istype(src,/turf/open/water/sewer) || istype(src,/turf/open/water/swamp) || istype(src, /turf/open/water/sewer))
					if (istype(src, /turf/open/water/sewer))
						user.add_stress(/datum/stressevent/sewertouched)
					if (!HAS_TRAIT(L,TRAIT_LEECHIMMUNE)) // cleaning yourself in nasty water is a wonderful way to get leeches.
						if (prob(20)) // 1 in 5 chance of getting leeched if you wash up in gross water.
							var/list/zones = list(BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_HEAD)
							var/zone = pick(zones)
							var/obj/item/bodypart/BP = L.get_bodypart(zone)
							if (BP && !(BP.skeletonized))
								var/obj/item/natural/worms/leech/I = new(L)
								BP.add_embedded_object(I, silent = TRUE)
/*				if(water_reagent == /datum/reagent/water) //become shittified, checks so bath water can be naturally gross but not discolored
					water_reagent = /datum/reagent/water/gross
					water_color = "#a4955b"
					update_icon()*/
				if (istype(src,/turf/open/water/bloody))
					L.add_mob_blood(L) //Yes its their own DNA

		else
			user.visible_message(span_info("[user] starts to wash [item2wash] in [src]."))
			if(do_after(L, 30, target = src))
				if(wash_in)
					wash_atom(item2wash, CLEAN_STRONG)
					L.update_inv_hands()
				if(istype(src,/turf/open/water/bloody))
					item2wash.add_blood_DNA(list("Blood" = random_blood_type()))
				if(iscarbon(L))
					var/mob/living/carbon/C = user
					C.update_inv_hands()
				playsound(user, pick(wash), 100, FALSE)
		return
	..()

/turf/open/water/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		user.visible_message(span_info("[user] starts to drink from [src]."))
		drink_act(user, L)
		return
	..()

/turf/open/water/proc/drink_act(mob/user, mob/living/L)
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	if(L.stat != CONSCIOUS)
		return

	if(do_after(L, 25, target = src))
		if (istype(src,/turf/open/water/sewer))
			to_chat(user, span_userdanger("Have I gone mad!? Why am I drinking sewage!?"))
		var/list/waterl = list(src.water_reagent = 5)
		var/datum/reagents/reagents = new()
		reagents.add_reagent_list(waterl)
		reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
		playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		drink_act(user, L)
	return

/turf/open/water/Destroy()
	. = ..()
	if(water_overlay)
		QDEL_NULL(water_overlay)
	if(water_top_overlay)
		QDEL_NULL(water_top_overlay)

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	if(!isobj(AM))
		return
	var/obj/O = AM
	if(!O.extinguishable)
		return
	O.extinguish()

/turf/open/water/get_slowdown(mob/user)
	var/returned = slowdown
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/ac = H.highest_ac_worn()
		switch(ac)
			if(ARMOR_CLASS_HEAVY)
				returned += 1.5
			if(ARMOR_CLASS_MEDIUM)
				returned += 1
		if(HAS_TRAIT(user, TRAIT_ABYSSOR_SWIM))
			returned -= 1
	return max(returned, 0.5)

//turf/open/water/Initialize()
//	dir = pick(NORTH,SOUTH,WEST,EAST)
//	. = ..()


/turf/open/water/bath
	name = "water"
	desc = "Soothing water, with soapy bubbles on the surface."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "bathtileW"
	water_level = 2
	water_color = "#FFFFFF"
	slowdown = 3
	water_reagent = /datum/reagent/water/bathwater
	temperature = 300

/turf/open/water/bath/Initialize(mapload)
	.  = ..()
	icon_state = "bathtile"

/turf/open/water/sewer
	name = "sewage"
	desc = "This dark water smells like dead rats and sulphur!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "pavingW"
	water_level = 1
	water_color = "#705a43"
	slowdown = 3
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewage
	temperature = 300

/turf/open/water/sewer/Initialize(mapload)
	icon_state = "paving"
	water_color = pick("#705a43","#697043", "#6C6543")
	.  = ..()

/turf/open/water/swamp
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "dirtW2"
	water_level = 2
	water_color = "#705a43"
	slowdown = 3
	wash_in = TRUE
	water_reagent = /datum/reagent/water/gross
	temperature = 275

/turf/open/water/bloody
	name = "blood"
	desc = "Is that... a river of blood? EVIL!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "dirtW2"
	water_level = 2
	water_color = "#941010"
	slowdown = 3
	wash_in = FALSE
	water_reagent = /datum/reagent/blood/shitty
	temperature = 300

/turf/open/water/swamp/Initialize(mapload)
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#705a43")
	.  = ..()

/turf/open/water/bloody/Initialize(mapload)
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#880808")
	.  = ..()





/turf/open/water/swamp/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(HAS_TRAIT(AM, TRAIT_LEECHIMMUNE))
		return
	if(isliving(AM) && !AM.throwing)
		if(ishuman(AM))
			var/mob/living/carbon/human/C = AM
			// check if we're riding a boat or a mount (we can presume a living mob is a mount), no leeches if so
			if(istype(C.buckled, /obj/vehicle/ridden) || isliving(C.buckled))
				return
			var/chance = 3
			if(C.m_intent == MOVE_INTENT_RUN)
				chance = 6
			if(C.m_intent == MOVE_INTENT_SNEAK)
				chance = 1
			if(!prob(chance))
				return
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_CHEST)
			for(var/i = 0, i <= zonee.len, i++)
				var/zone = pick(zonee)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/swamp/deep
	name = "murk"
	desc = "Deep water with several weeds and algae on the surface."
	icon_state = "dirtW"
	water_level = 3
	water_color = "#705a43"
	slowdown = 5
	swim_skill = TRUE

/turf/open/water/swamp/deep/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(HAS_TRAIT(AM, TRAIT_LEECHIMMUNE))
		return
	if(isliving(AM) && !AM.throwing)
		if(ishuman(AM))
			var/mob/living/carbon/human/C = AM
			// check if we're riding a boat or a mount (we can presume a living mob is a mount), no leeches if so
			if(istype(C.buckled, /obj/vehicle/ridden) || isliving(C.buckled))
				return
			var/chance = 6
			if(C.m_intent == MOVE_INTENT_RUN)
				chance = 12		//yikes
			if(C.m_intent == MOVE_INTENT_SNEAK)
				chance = 2
			if(!prob(chance))
				return
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_CHEST,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_R_ARM,BODY_ZONE_L_ARM)
			for(var/i = 0, i <= zonee.len, i++)
				var/zone = pick(zonee)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/cleanshallow
	name = "water"
	desc = "Clear and shallow water, what a blessing!"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "rockw2"
	water_level = 2
	slowdown = 3
	wash_in = TRUE
	water_reagent = /datum/reagent/water

/turf/open/water/cleanshallow/Initialize(mapload)
	icon_state = "rock"
	dir = pick(GLOB.cardinals)
	.  = ..()

/turf/open/water/river
	name = "river"
	desc = "A river of crystal clear water flows swiftly along the contours of the land."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "rivermove"
	water_level = 3
	slowdown = 5
	wash_in = TRUE
	swim_skill = TRUE
	var/river_processing
	swimdir = TRUE

/turf/open/water/river/muddy
	water_color = "#705a43"
	water_reagent = /datum/reagent/water/gross
	icon_state = "rockwd"
	name = "muddy river"
	desc = "A river of thick, silt-laden sludge lurches languidly through the land."

/turf/open/water/river/flow
	icon_state = "rockwd"

/turf/open/water/river/flow/west
	dir = 8

/turf/open/water/river/flow/east
	dir = 4

/turf/open/water/river/flow/north
	dir = 1

/turf/open/water/river/update_icon()
	if(water_overlay)
		water_overlay.color = water_color
		water_overlay.icon_state = "riverbot"
		water_overlay.dir = dir
	if(water_top_overlay)
		water_top_overlay.color = water_color
		water_top_overlay.icon_state = "rivertop"
		water_top_overlay.dir = dir

/turf/open/water/river/Initialize(mapload)
	icon_state = "rock"
	.  = ..()

/turf/open/water/river/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isliving(AM))
		if(!river_processing)
			river_processing = addtimer(CALLBACK(src, PROC_REF(process_river)), 5, TIMER_STOPPABLE)

/turf/open/water/river/get_heuristic_slowdown(mob/traverser, travel_dir)
	var/const/UPSTREAM_PENALTY = 2
	var/const/DOWNSTREAM_BONUS = -2
	. = ..()
	if(traverser.is_floor_hazard_immune())
		return
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(travel_dir == dir) // downriver
		. += DOWNSTREAM_BONUS // faster!
	else if(travel_dir == GLOB.reverse_dir[dir]) // upriver
		. += UPSTREAM_PENALTY // slower

/turf/open/water/river/proc/process_river()
	river_processing = null
	for(var/atom/movable/A in contents)
		for(var/obj/structure/S in src)
			if(S.obj_flags & BLOCK_Z_OUT_DOWN)
				return
		if((A.loc == src))
			A.ConveyorMove(dir)

/turf/open/water/ocean
	name = "salt water"
	desc = "The waves lap at the coast, hungry to swallow the land. Doesn't look too deep."
	icon_state = "ash"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 2
	water_color = "#3e7459"
	slowdown = 4
	swim_skill = TRUE
	wash_in = TRUE
	water_reagent = /datum/reagent/water/salty

/turf/open/water/ocean/deep
	name = "salt water"
	desc = "Deceptively deep, be careful not to find yourself this far out."
	icon_state = "water"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 3
	water_color = "#3e7459"
	slowdown = 8
	swim_skill = TRUE
	wash_in = TRUE

/turf/open/water/pond
	name = "pond"
	desc = "Still and alarmingly idyllic water. Covered in concerning overgrowth of duckweed."
	icon_state = "pond"
	icon = 'icons/turf/roguefloor.dmi'
	water_level = 3
	water_color = "#367e94"
	slowdown = 3
	swim_skill = TRUE
	wash_in = TRUE
	water_reagent = /datum/reagent/water

/turf/open/water/bath/fakepond
	name = "fake pond"
	desc = "Soothing water, with soapy bubbles on the surface. Dyed green to mimic gently floating duckwater."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "pond"
	water_level = 2
	water_color = "#367e94"
	slowdown = 3
	swim_skill = TRUE
	wash_in = TRUE
	water_reagent = /datum/reagent/water/bathwater
	temperature = 300

//Healing springs.
//Intended for deep dungeon / hidden areas.
/turf/open/water/ocean/deep/thermalwater
	name = "healing hot spring"
	desc = "A warm spring with gentle ripples. Standing here soothes your body."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "together"
	water_color = "#23b9df"
	water_reagent = /datum/reagent/water
	var/heal_interval = 5 SECONDS
	var/heal_amount = 20
	var/last_heal = 0
	temperature = 300

/turf/open/water/ocean/deep/thermalwater/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/turf/open/water/ocean/deep/thermalwater/process()
	if(world.time < last_heal + heal_interval)
		return

	for(var/mob/living/carbon/M in src)
		if(M.stat == DEAD) continue

		if(M.getBruteLoss())
			M.adjustBruteLoss(-heal_amount)
		if(M.getFireLoss())
			M.adjustFireLoss(-heal_amount)
		if(M.getToxLoss())
			M.adjustToxLoss(-heal_amount)
		if(M.getOxyLoss())
			M.adjustOxyLoss(-heal_amount*2)

//Someone else can put this on a timer. I can't be bothered.
//		M.visible_message(span_notice("[M] looks a bit better after soaking in the spring."))

	last_heal = world.time
