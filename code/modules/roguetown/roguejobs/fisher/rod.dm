/obj/item/fishingrod
	force = 12
	possible_item_intents = list(ROD_AUTO, ROD_CAST, SPEAR_BASH)
	name = "fishing rod"
	desc = "Made from weathered wood and coarse twine. Use in hand to reel catches in, and right-click in your off-hand to manage rod attachments."
	icon_state = "rod"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	wlength = WLENGTH_NORMAL
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	grid_height = 96
	grid_width = 32

	///the bait we have on the hook
	var/obj/item/baited = null

	//attachments for the fishing rod
	var/obj/item/fishing/reel/reel
	var/obj/item/fishing/hook/hook
	var/obj/item/fishing/line/line //this last one isnt needed to fish

	///THIS IS FOR THE NON-AUTOFISHING GAME

	//checks to see if currently fishing
	var/currentlyfishing = FALSE
	var/turf/startingturf
	var/startingdir
	//so that process() can check for actively held
	var/mob/living/fisher
	//these affect the below modifiers, and determine what you catch
	var/fishrarity
	var/fishtype
	var/fishsize
	var/obj/fish
	//how much the velocity can change per tick
	var/acceleration = 0
	//how fast the angle can change
	var/maxvelocity = 0
	//what direction the fish is currently accelerating in
	var/directionstate = 1
	//multiplier for angle change per angle of difference past margin of error, should not go above 10
	var/difficulty = 0
	//the current desired angle, moves based on velocity
	var/fishtarget = 0
	//fish health
	var/fishhealth = 0
	//how many ticks the meter can be in the danger zone for before snapping, regenerates while input is at the target boundaries
	var/linehealth = 0
	//time in ticks to hook a fish
	var/hookwindow = 0
	//current state
	var/currentstate
	//ui elements
	var/atom/movable/fishingoverlay/base/backdrop
	var/atom/movable/fishingoverlay/reelstate
	var/atom/movable/fishingoverlay/fishstate
	var/atom/movable/fishingoverlay/face
	var/atom/movable/fishingoverlay/faceframe

	///our clients average ping
	var/average_ping = 0
	/// Auto-fishing pending pull state, consumed by use-in-hand reeling.
	var/auto_reel_ready = FALSE
	var/auto_reel_deadline = 0
	var/auto_pending_catch = null
	var/list/auto_pending_modlist = null
	var/turf/auto_pending_target = null
	var/auto_reel_successes = 0
	var/auto_retry_used = FALSE
	var/static/list/rod_size_weights = list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1)
	/// Cast-intent pending state: set after bite, cleared by attack_self to start the minigame.
	var/cast_reel_pending = FALSE
	var/cast_reel_pending_deadline = 0
	COOLDOWN_DECLARE(ping_delay)
	/// Cast minigame top-zone reel mechanics.
	var/topzone_hold = 0    // ticks spent continuously with fishstate near top-center
	var/reel_ready = FALSE  // TRUE once fish is tired enough to haul in
	var/reel_expire = 0    // world.time deadline for the reel opportunity window
	var/reel_input = FALSE  // set by attack_self during minigame when reel_ready
	var/reel_successes = 0
	var/early_reel_streak = 0
	var/failed_reel_attempts = 0
	/// Zone-tracking for the fish position in the minigame.
	var/red_zone_visits = 0     // times fish has entered the red zone this hooked phase
	var/fish_was_red = FALSE    // previous-tick red zone state, for entry detection
	var/current_fish_zone = "none"  // "green", "blue", or "red"

/obj/item/fishingrod/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/fishingrod/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/fishingrod/process()
	if(!fisher)
		return
	if(!(auto_reel_ready || cast_reel_pending || currentlyfishing))
		return
	if(is_far_from_cast_anchor(fisher))
		snap_line_from_anchor_drift(fisher)
		currentlyfishing = FALSE

/datum/intent/cast
	name = "cast"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "cast"
	no_attack = TRUE
	reach = 8

/datum/intent/auto
	name = "auto reel"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "auto"
	no_attack = TRUE
	reach = 8

/obj/item/fishingrod/attack_self(mob/user)
	// During the cast minigame, intercept to allow the player to reel the fish in.
	if(currentlyfishing && fisher == user)
		if(is_far_from_cast_anchor(user))
			snap_line_from_anchor_drift(user)
			currentlyfishing = FALSE
			return
		if(reel_ready)
			reel_input = TRUE
		else if(current_fish_zone == "red")
			to_chat(user, "<span class='warning'>I yanked the line sideways and lost the fish!</span>")
			currentlyfishing = FALSE
		else
			topzone_hold = 0
			failed_reel_attempts++
			if(failed_reel_attempts >= 2)
				to_chat(user, "<span class='warning'>I keep yanking too early and lose the fish!</span>")
				currentlyfishing = FALSE
			else
				to_chat(user, "<span class='warning'>Too early! I lose my progress and need to steady the line again.</span>")
		return
	// Cast-intent pending: player uses rod in-hand to start the reel and launch the minigame.
	if(cast_reel_pending && fisher == user)
		if(is_far_from_cast_anchor(user))
			snap_line_from_anchor_drift(user)
			return
		if(world.time > cast_reel_pending_deadline)
			cast_reel_pending = FALSE
			to_chat(user, "<span class='warning'>Too slow. The fish wriggled free.</span>")
		else
			cast_reel_pending = FALSE // Signal the afterattack wait-loop to continue.
		return
	if(user.doing)
		to_chat(user, "<span class='warning'>I'm busy right now.</span>")
		return
	if(auto_reel_ready && is_far_from_cast_anchor(user))
		snap_line_from_anchor_drift(user)
		return
	if(!try_reel_auto_catch(user))
		to_chat(user, "<span class='notice'>I need a fish tug first. Right-click in your off-hand [src] to manage attachments.</span>")

/obj/item/fishingrod/proc/show_attachment_menu(mob/user)
	if(!user.canUseTopic(src, be_close=TRUE))
		return

	if(!baited && !hook && !line && !reel)
		to_chat(user, "<span class='notice'>There's nothing on this fishing rod!</span>")
		return

	var/list/choices = list()
	if(baited)
		choices["Remove Bait"] = image(icon = baited.icon, icon_state = baited.icon_state)
	if(hook)
		choices["Remove Hook"] = image(icon = hook.icon, icon_state = hook.icon_state)
	if(line)
		choices[line.bobber ? "Remove Bobber" : "Remove Sinker"] = image(icon = line.icon, icon_state = line.icon_state)
	// Show reel/line status - can only be removed if nothing else is attached
	if(reel)
		if(!hook && !line && !baited)
			choices["Remove Line"] = image(icon = reel.icon, icon_state = reel.icon_state)
		else
			choices["Fishing Line (Attached)"] = image(icon = reel.icon, icon_state = reel.icon_state)

	var/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return

	switch(choice)
		if("Remove Bait")
			if(baited)
				drop_attachment(baited, user)
				baited = null
				playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
				to_chat(user, "<span class='notice'>I remove the bait from [src].</span>")
		if("Remove Hook")
			if(baited)
				to_chat(user, "<span class='warning'>I should remove the bait first.</span>")
				return
			if(hook)
				drop_attachment(hook, user)
				hook = null
				to_chat(user, "<span class='notice'>I remove the hook from [src].</span>")
		if("Remove Bobber")
			if(baited)
				to_chat(user, "<span class='warning'>I should remove the bait first.</span>")
				return
			if(line)
				drop_attachment(line, user)
				line = null
				to_chat(user, "<span class='notice'>I remove the bobber from [src].</span>")
		if("Remove Sinker")
			if(baited)
				to_chat(user, "<span class='warning'>I should remove the bait first.</span>")
				return
			if(line)
				drop_attachment(line, user)
				line = null
				to_chat(user, "<span class='notice'>I remove the sinker from [src].</span>")
		if("Remove Line")
			if(reel)
				drop_attachment(reel, user)
				reel = null
				to_chat(user, "<span class='notice'>I remove the line from [src].</span>")
		if("Fishing Line (Attached)")
			to_chat(user, "<span class='warning'>I need to remove the bait, hook, and bobber or sinker first.</span>")

	update_icon()
	return

/obj/item/fishingrod/proc/get_auto_catch_weight(catch_path)
	if(!ispath(catch_path))
		return 1
	var/weight = 1
	if(ispath(catch_path, /mob/living))
		weight += 4
	if(ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/octopus))
		weight += 3
	else if(ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/angler))
		weight += 2
	return weight

/obj/item/fishingrod/proc/get_fish_total_challenge()
	// Returns 0-9: base score from rarity + size, then offset by tackle difficultymod.
	// Negative difficultymod (better tackle) lowers the challenge; positive (poor tackle) raises it.
	var/list/rarity_score = list("com" = 0, "rare" = 1, "ultra" = 3, "gold" = 5)
	var/list/size_score = list("tiny" = 0, "small" = 0, "normal" = 1, "large" = 2, "huge" = 4, "prize" = 6)
	var/ri = rarity_score[fishrarity] || 0
	var/si = size_score[fishsize] || 0
	var/tackle_offset = 0
	if(istype(reel, /obj/item/fishing) && reel.difficultymod)
		tackle_offset += reel.difficultymod
	if(istype(hook, /obj/item/fishing) && hook.difficultymod)
		tackle_offset += hook.difficultymod
	return clamp(ri + si + tackle_offset, 0, 9)

/obj/item/fishingrod/proc/try_spawn_deluxe_bonus_fish(mob/user, list/modlist, turf/targeted, primary_path)
	if(!user || !targeted)
		return FALSE
	if(!istype(hook, /obj/item/fishing/hook/deluxe))
		return FALSE
	if(!ispath(primary_path, /obj/item/reagent_containers/food/snacks/fish))
		return FALSE
	if(!prob(50))
		return FALSE
	var/bonus_path = null
	for(var/i in 1 to 6)
		var/rolled_path = getfishingloot(user, modlist, targeted)
		if(is_shellfish_catch_path(rolled_path))
			rolled_path = istype(targeted, /turf/open/water/ocean) || istype(targeted, /turf/open/water/ocean/deep) ? /obj/item/reagent_containers/food/snacks/fish/cod : /obj/item/reagent_containers/food/snacks/fish/carp
		if(!ispath(rolled_path, /obj/item/reagent_containers/food/snacks/fish))
			continue
		if(rolled_path == primary_path)
			continue
		bonus_path = rolled_path
		break
	if(!bonus_path)
		return FALSE
	var/turf/safe_drop_turf = get_safe_catch_drop_turf(user, targeted)
	var/obj/item/reagent_containers/food/snacks/fish/bonusfish = new bonus_path(user)
	if(!user.put_in_hands(bonusfish))
		bonusfish.forceMove(safe_drop_turf)
	apply_fishing_quality_to_fish(bonusfish, modlist, rod_size_weights)
	to_chat(user, "<span class='notice'>The lure fools a second fish into striking at once!</span>")
	playsound(user.loc, 'sound/items/Fish_out.ogg', 80, TRUE)
	if(user.mind)
		user.mind.add_sleep_experience(/datum/skill/labor/fishing, 0.5, FALSE)
		record_featured_stat(FEATURED_STATS_FISHERS, user)
		record_round_statistic(STATS_FISH_CAUGHT)
	return TRUE

/obj/item/fishingrod/proc/is_shellfish_catch_path(catch_path)
	if(!ispath(catch_path))
		return FALSE
	return ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/lobster) \
		|| ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/crab) \
		|| ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/clam) \
		|| ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/oyster) \
		|| ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/shrimp) \
		|| ispath(catch_path, /obj/item/reagent_containers/food/snacks/fish/crawfish)

/obj/item/fishingrod/proc/get_cast_junk_reward_path()
	return pickweight(list(
		/obj/item/natural/fibers = 4,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 3,
		/obj/item/clothing/shoes/roguetown/boots/leather = 2,
		/obj/item/clothing/head/roguetown/fisherhat = 1,
		/obj/structure/fermentation_keg = 1,
	))

/obj/item/fishingrod/proc/get_safe_catch_drop_turf(mob/user, turf/targeted)
	var/turf/drop_turf = null
	if(user)
		drop_turf = user.drop_location()
		if(!isturf(drop_turf))
			drop_turf = get_turf(user)
	if(istype(drop_turf, /turf/open/transparent/openspace) && targeted)
		return targeted
	if(drop_turf)
		return drop_turf
	return targeted

/obj/item/fishingrod/proc/get_fishing_stamina_drain(mob/living/user, base_percent = 25)
	if(!user)
		return 0
	var/athletics_skill = max(user.get_skill_level(/datum/skill/misc/athletics), 0)
	var/strength_bonus = max(0, user.STASTR - 10)
	var/effective_percent = max(1, base_percent - athletics_skill - strength_bonus)
	var/drain = round((user.max_stamina * effective_percent) / 100, 1)
	return max(1, drain)

/obj/item/fishingrod/proc/get_bite_chance_bonus(turf/open/water/targeted, shore_distance)
	var/bonus = 0
	if(istype(line, /obj/item/fishing/line/bobber))
		bonus += 15
	else if(istype(line, /obj/item/fishing/line/sinker))
		bonus += 10
		if(shore_distance <= 3)
			bonus += 20
	if(istype(baited, /obj/item/fishing/bait/fly))
		bonus += 35
	return bonus

/obj/item/fishingrod/proc/get_bite_chance_multiplier(shore_distance)
	var/mult = 1
	if(istype(line, /obj/item/fishing/line/bobber))
		mult *= 1.2
	else if(istype(line, /obj/item/fishing/line/sinker) && shore_distance <= 3)
		// Sinker excels near shore by roughly doubling bite odds.
		mult *= 2
	if(istype(baited, /obj/item/fishing/bait/fly))
		mult *= 1.5
	return mult

/obj/item/fishingrod/proc/get_cast_time_multiplier()
	var/mult = 1
	if(istype(line, /obj/item/fishing/line/sinker))
		mult *= 1.5
	return mult

/obj/item/fishingrod/proc/get_reel_time_multiplier()
	var/mult = 1
	if(istype(line, /obj/item/fishing/line/sinker))
		mult *= 1.5
	return mult

/obj/item/fishingrod/proc/has_complete_fishing_rig()
	if(!baited || !hook || !reel)
		return FALSE
	if(istype(baited, /obj/item/fishing/bait/fly))
		return TRUE
	return !!line

/obj/item/fishingrod/proc/apply_tackle_wear(mob/user, line_damage = 0, hook_damage = 0, reel_damage = 0)
	if(line && istype(line, /obj/item/fishing))
		var/obj/item/fishing/line_item = line
		if(line_item.adjust_durability(line_damage))
			to_chat(user, "<span class='warning'>My [line_item.name] gives out!</span>")
			QDEL_NULL(line)
	if(hook && istype(hook, /obj/item/fishing))
		var/obj/item/fishing/hook_item = hook
		if(hook_item.adjust_durability(hook_damage))
			to_chat(user, "<span class='warning'>My [hook_item.name] breaks!</span>")
			QDEL_NULL(hook)
	if(reel && istype(reel, /obj/item/fishing))
		var/obj/item/fishing/reel_item = reel
		if(reel_item.adjust_durability(reel_damage))
			to_chat(user, "<span class='warning'>My [reel_item.name] is ruined!</span>")
			QDEL_NULL(reel)
	update_icon()
	if(!hook || (!line && !istype(baited, /obj/item/fishing/bait/fly)))
		to_chat(user, "<span class='warning'>My rig is incomplete now. I need a fresh hook and line setup.</span>")

/obj/item/fishingrod/proc/apply_line_snap_consequences(mob/user)
	if(reel && istype(reel, /obj/item/fishing/reel))
		var/obj/item/fishing/reel/reel_item = reel
		var/snap_percent = 30
		if(istype(reel_item, /obj/item/fishing/reel/leather))
			snap_percent = 25
		else if(istype(reel_item, /obj/item/fishing/reel/silk))
			snap_percent = 20
		else if(istype(reel_item, /obj/item/fishing/reel/deluxe))
			snap_percent = 15
		var/snap_damage = max(1, round(reel_item.max_integrity * (snap_percent / 100)))
		if(reel_item.obj_integrity > 1)
			snap_damage = min(snap_damage, reel_item.obj_integrity - 1)
		reel_item.adjust_durability(snap_damage)
		to_chat(user, "<span class='warning'>My [reel_item.name] is badly frayed and tears off the rod!</span>")
		drop_attachment(reel_item, user)
		reel = null
	if(line)
		to_chat(user, "<span class='warning'>The [line.name] tears free and drops to the ground!</span>")
		drop_attachment(line, user)
		line = null
	if(hook)
		to_chat(user, "<span class='warning'>The hook tears free with the line snap!</span>")
		QDEL_NULL(hook)
	if(baited)
		QDEL_NULL(baited)
	baited = null
	update_icon()

/obj/item/fishingrod/proc/reset_auto_pending_catch()
	auto_reel_ready = FALSE
	auto_reel_deadline = 0
	auto_pending_catch = null
	auto_pending_modlist = null
	auto_pending_target = null
	auto_reel_successes = 0
	auto_retry_used = FALSE

/obj/item/fishingrod/proc/is_far_from_cast_anchor(mob/living/user, max_dist = 1)
	if(!user || !startingturf)
		return FALSE
	return get_dist(user, startingturf) > max_dist

/obj/item/fishingrod/proc/snap_line_from_anchor_drift(mob/living/user)
	if(!user)
		return
	playsound(user.loc, 'sound/items/pickbreak.ogg', 80, FALSE)
	to_chat(user, "<span class='warning'>I stray too far from my casting spot and the line snaps!</span>")
	apply_line_snap_consequences(user)
	cast_reel_pending = FALSE
	cast_reel_pending_deadline = 0
	reset_auto_pending_catch()

/obj/item/fishingrod/proc/try_reel_auto_catch(mob/user)
	if(!auto_reel_ready)
		return FALSE
	if(is_far_from_cast_anchor(user))
		snap_line_from_anchor_drift(user)
		return TRUE
	if(world.time > auto_reel_deadline)
		to_chat(user, "<span class='warning'>Too slow. The fish slips free.</span>")
		reset_auto_pending_catch()
		return TRUE

	if(!auto_pending_catch)
		reset_auto_pending_catch()
		return TRUE

	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/str_score = 10
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		str_score = H.STASTR
	var/catch_weight = get_auto_catch_weight(auto_pending_catch)
	var/fish_challenge = get_fish_total_challenge()
	var/effective_weight = catch_weight + fish_challenge
	var/base_speed = get_skill_delay(sl, 1, slowest = 7)
	var/reel_speed = max(1, (base_speed + (effective_weight * 0.7) - max(0, str_score - 10) * 0.2) * get_reel_time_multiplier())
	var/turf/reel_anchor = auto_pending_target

	playsound(user.loc, 'sound/misc/reeling.ogg', 70, FALSE)
	user.visible_message("<span class='notice'>[user] starts reeling the line in.</span>", "<span class='notice'>I start reeling the line in.</span>")
	if(auto_reel_successes <= 0)
		to_chat(user, "<span class='notice'>[get_fishing_size_feel_text(fishsize, auto_pending_catch)]</span>")
	if(!do_after(user, reel_speed, target = reel_anchor || user))
		to_chat(user, "<span class='warning'>I lose my grip on the reel!</span>")
		apply_tackle_wear(user, 2, 1, 1)
		return TRUE

	if(reel_anchor && get_dist(user, reel_anchor) > 8)
		playsound(user.loc, 'sound/items/pickbreak.ogg', 80, FALSE)
		to_chat(user, "<span class='warning'>I stray too far and the line snaps!</span>")
		apply_line_snap_consequences(user)
		reset_auto_pending_catch()
		return TRUE

	var/auto_pull_stamina_drain = get_fishing_stamina_drain(user, 37.5)
	if(auto_pull_stamina_drain && !user.stamina_add(auto_pull_stamina_drain))
		to_chat(user, "<span class='warning'>I'm too exhausted to keep reeling.</span>")
		reset_auto_pending_catch()
		return TRUE

	auto_reel_successes++
	if(auto_reel_successes < 2)
		to_chat(user, span_userdanger("I GAIN LINE! But the fish surges back. One more strong reel should do it!"))
		if(auto_pending_target)
			auto_pending_target.balloon_alert_to_viewers("Tug!")
		playsound(user.loc, 'sound/items/fishing_plouf.ogg', 90, TRUE)
		auto_reel_deadline = world.time + clamp(25 + (sl * 8) - (effective_weight * 4), 18, 80)
		return TRUE

	var/reel_roll = rand(1, 20) + str_score + (sl * 2)
	var/reel_target = 12 + (effective_weight * 4)
	if(reel_roll < reel_target)
		if(prob(8))
			if(baited && prob(80))
				to_chat(user, "<span class='warning'>Critical slip! The fish rips the bait clean off.</span>")
				QDEL_NULL(baited)
			else
				playsound(user.loc, 'sound/items/pickbreak.ogg', 80, FALSE)
				to_chat(user, "<span class='warning'>Critical slip! The line snaps under the strain.</span>")
				apply_line_snap_consequences(user)
		else
			if(!auto_retry_used && prob(45))
				auto_retry_used = TRUE
				auto_reel_successes = max(1, auto_reel_successes - 1)
				auto_reel_deadline = world.time + clamp(20 + (sl * 7) - (effective_weight * 3), 14, 60)
				to_chat(user, span_userdanger("I LOSE LINE! But I can still reel once more!"))
				if(auto_pending_target)
					auto_pending_target.balloon_alert_to_viewers("Tug!")
				playsound(user.loc, 'sound/items/fishing_plouf.ogg', 90, TRUE)
				apply_tackle_wear(user, 1, 1, 1)
				return TRUE
			to_chat(user, "<span class='warning'>I lose the fish after the final pull.</span>")
			apply_tackle_wear(user, 2, 1, 1)
		reset_auto_pending_catch()
		update_icon()
		return TRUE

	if(auto_pending_catch in subtypesof(/mob/living))
		var/mob/M = auto_pending_catch
		new M(auto_pending_target || get_turf(user))
		if(!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
			user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	else
		var/turf/safe_drop_turf = get_safe_catch_drop_turf(user, auto_pending_target)
		if(ispath(auto_pending_catch, /obj/item/reagent_containers/food/snacks/fish))
			var/obj/item/reagent_containers/food/snacks/fish/caughtfish = new auto_pending_catch(safe_drop_turf)
			apply_fishing_quality_to_fish(caughtfish, auto_pending_modlist, rod_size_weights)
			try_spawn_deluxe_bonus_fish(user, auto_pending_modlist, auto_pending_target, auto_pending_catch)
		else
			new auto_pending_catch(safe_drop_turf)
	apply_tackle_wear(user, 4 + catch_weight, 2 + catch_weight, 2)

	playsound(user.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
	if(user.mind)
		user.mind.add_sleep_experience(/datum/skill/labor/fishing, 1, FALSE)
		record_featured_stat(FEATURED_STATS_FISHERS, user)
		record_round_statistic(STATS_FISH_CAUGHT)
	if(baited && getbaitlife(sl, baited))
		to_chat(user, "<span class='warning'>Damn, it ate my bait.</span>")
		qdel(baited)
		baited = null
		update_icon()
	reset_auto_pending_catch()
	return TRUE
/obj/item/fishingrod/attackby(obj/item/I, mob/user, params)
	if(baited && reel && hook && line)
		return  ..()

	if(istype(I, /obj/item/fishing/bait) || istype(I, /obj/item/natural/worms) || istype(I, /obj/item/natural/bundle/worms) || istype(I, /obj/item/reagent_containers/food/snacks))
		try_attach_bait_item(I, user)

	else if(istype(I, /obj/item/fishing)) //bait has a null attachtype and is accounted for in the previous check so i don't have to worry about it
		var/obj/item/fishing/T = I
		switch(T.attachtype)
			if("line")
				if(T.type == /obj/item/fishing/line)
					to_chat(user, "<span class='warning'>This tackle piece is deprecated. Use a bobber or sinker.</span>")
				else if(istype(baited, /obj/item/fishing/bait/fly))
					to_chat(user, "<span class='warning'>Fly bait only works without a bobber or sinker.</span>")
				else if(!reel)
					to_chat(user, "<span class='warning'>I need to add fishing line first.</span>")
				else if(!hook)
					to_chat(user, "<span class='warning'>I need a hook before adding this.</span>")
				else if(baited)
					to_chat(user, "<span class='warning'>I should remove the bait first.</span>")
				else if(!line)
					attach_tackle(T)
					line = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("hook")
				if(!reel)
					to_chat(user, "<span class='warning'>I need to add fishing line first.</span>")
				else if(baited)
					to_chat(user, "<span class='warning'>I should remove the bait first.</span>")
				else if(!hook)
					attach_tackle(T)
					hook = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("reel")
				if(hook || line || baited)
					to_chat(user, "<span class='warning'>The line should go on. Remove the rest of the rig first.</span>")
				else if(!reel)
					attach_tackle(T)
					reel = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
	update_icon()
	return

/obj/item/fishingrod/proc/try_attach_bait_item(obj/item/I, mob/user)
	if(!I || !user || baited)
		return FALSE
	if(I.anchored)
		return FALSE
	if(!reel)
		to_chat(user, "<span class='warning'>I need to add fishing line first.</span>")
		return FALSE
	if(!hook)
		to_chat(user, "<span class='warning'>I need a hook before I can bait the rod.</span>")
		return FALSE
	if(istype(I, /obj/item/fishing/bait/fly) && line)
		to_chat(user, "<span class='warning'>I need to remove the bobber or sinker first before using fly bait.</span>")
		return FALSE

	if(istype(I, /obj/item/fishing/bait) || istype(I, /obj/item/natural/worms))
		I.forceMove(src)
		baited = I
		user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [I] to my line.</span>")
		playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
		update_icon()
		return TRUE

	if(istype(I, /obj/item/natural/bundle/worms))
		var/obj/item/natural/bundle/worms/W = I
		if(W.amount <= 0)
			to_chat(user, "<span class='warning'>There are no worms left in that bundle.</span>")
			return FALSE
		var/obj/item/new_bait = new W.stacktype(src)
		baited = new_bait
		var/worm_name = "worm"
		W.amount = max(0, W.amount - 1)
		if(W.amount <= 0)
			qdel(W)
		else if(W.amount == 1)
			var/turf/drop_turf = get_turf(W)
			if(user.is_holding(W))
				user.doUnEquip(W, TRUE, drop_turf, silent = TRUE)
			qdel(W)
			var/obj/item/single_worm = new new_bait.type(drop_turf)
			if(drop_turf == get_turf(user))
				user.put_in_hands(single_worm)
		else
			W.update_bundle()
		user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [worm_name] to my line.</span>")
		playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
		update_icon()
		return TRUE

	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/list/snack_fishloot = I.vars["fishloot"]
		if(!snack_fishloot)
			return FALSE
		I.forceMove(src)
		baited = I
		user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [I] to my line.</span>")
		playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
		update_icon()
		return TRUE

	return FALSE

/obj/item/fishingrod/proc/attach_tackle(obj/item/fishing/I)
	I.forceMove(src)
	// Keep tackle hidden while attached so only rod visuals are shown.
	I.alpha = 0

/obj/item/fishingrod/proc/drop_attachment(obj/item/I, mob/user)
	if(!I)
		return
	I.alpha = initial(I.alpha)
	I.forceMove(get_turf(user))

/obj/item/fishingrod/proc/remove_rig(mob/user)
	if(baited)
		drop_attachment(baited, user)
		baited = null
	if(hook)
		drop_attachment(hook, user)
		hook = null
	if(line)
		drop_attachment(line, user)
		line = null

/obj/item/fishingrod/proc/remove_all_attachments(mob/user)
	if(baited)
		drop_attachment(baited, user)
		baited = null
	if(hook)
		drop_attachment(hook, user)
		hook = null
	if(line)
		drop_attachment(line, user)
		line = null
	if(reel)
		drop_attachment(reel, user)
		reel = null
	update_icon()

/obj/item/fishingrod/attack_right(mob/user)
	show_attachment_menu(user)

/obj/item/fishingrod/AltClick(mob/user)
	return ..()

/obj/item/fishingrod/AltRightClick(mob/user)
	if(!user)
		return
	if(user.get_active_held_item() != src && !Adjacent(user))
		return
	if(!baited && !hook && !line && !reel)
		to_chat(user, "<span class='notice'>There's nothing to remove.</span>")
		return
	remove_all_attachments(user)
	to_chat(user, "<span class='notice'>I strip everything off [src].</span>")

/obj/item/fishingrod/examine(mob/user)
	..()
	if(baited)
		to_chat(user, "<span class='info'>There's a [baited.name] stuck on here.</span>")
		if(baited.isbait)
			for(var/line in baited.get_bait_modifier_lines())
				to_chat(user, "<span class='notice'>[line]</span>")
	if(reel)
		to_chat(user, "<span class='info'>There's a [reel.name] strung on this rod.</span>")
		if(istype(reel, /obj/item/fishing))
			var/obj/item/fishing/reel_item = reel
			to_chat(user, "<span class='notice'>[reel_item.name] durability: [reel_item.get_durability_percent()]%</span>")
	else
		to_chat(user, "<span class='warning'>I'm missing the fishing line.</span>")
	if(hook)
		to_chat(user, "<span class='info'>There's a [hook.name] on this rod.</span>")
		if(istype(hook, /obj/item/fishing))
			var/obj/item/fishing/hook_item = hook
			to_chat(user, "<span class='notice'>[hook_item.name] durability: [hook_item.get_durability_percent()]%</span>")
	else
		to_chat(user, "<span class='warning'>I'm missing the hook.</span>")
	if(line)
		to_chat(user, "<span class='info'>There's a [line.name] on this rod.</span>")
		if(istype(line, /obj/item/fishing))
			var/obj/item/fishing/line_item = line
			to_chat(user, "<span class='notice'>[line_item.name] durability: [line_item.get_durability_percent()]%</span>")

	// Rig summary: total stats contributed by all attached tackle.
	var/total_linehealth = 0
	var/total_hookmod = 0
	var/total_difficultymod = 0
	var/total_deepweight = 0
	var/list/combined_raritymod = list()
	var/list/combined_sizemod = list()
	for(var/obj/item/A in list(reel, hook, line))
		if(!A || !istype(A, /obj/item/fishing))
			continue
		var/obj/item/fishing/F = A
		total_linehealth += F.linehealth
		total_hookmod += F.hookmod
		total_difficultymod += F.difficultymod
		total_deepweight += F.deepfishingweight
		if(islist(F.raritymod))
			for(var/key in F.raritymod)
				if(key in combined_raritymod)
					combined_raritymod[key] += F.raritymod[key]
				else
					combined_raritymod[key] = F.raritymod[key]
		if(islist(F.sizemod))
			for(var/key in F.sizemod)
				if(key in combined_sizemod)
					combined_sizemod[key] += F.sizemod[key]
				else
					combined_sizemod[key] = F.sizemod[key]
	if(total_linehealth || total_hookmod || total_difficultymod || total_deepweight || length(combined_raritymod) || length(combined_sizemod))
		to_chat(user, "<span class='info'>--- Rig Stats ---</span>")
		if(total_linehealth)
			to_chat(user, "<span class='notice'>Line Toughness: [format_fishing_signed_value(total_linehealth)]</span>")
		if(total_hookmod)
			to_chat(user, "<span class='notice'>Bite Modifier: [format_fishing_signed_value(total_hookmod)]</span>")
		if(total_difficultymod)
			to_chat(user, "<span class='notice'>Fight Ease: [format_fishing_signed_value(total_difficultymod)]</span>")
		if(total_deepweight)
			to_chat(user, "<span class='notice'>Depth Pull: [format_fishing_signed_value(total_deepweight)]</span>")
		if(length(combined_raritymod))
			to_chat(user, "<span class='notice'>Rarity Chance: [format_fishing_mod_list(combined_raritymod)]</span>")
		if(length(combined_sizemod))
			to_chat(user, "<span class='notice'>Size Bias: [format_fishing_mod_list(combined_sizemod)]</span>")

	to_chat(user, "<span class='notice'>Use in hand to reel in a hooked catch. Right-click in your off-hand to manage attachments. Alt-Right-Click strips all attachments.</span>")

/obj/item/fishingrod/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -13,"sy" = 3,"nx" = 14,"ny" = 3,"wx" = -12,"wy" = 4,"ex" = 6,"ey" = 5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/fishingrod/update_icon()
	cut_overlays()
	if(baited)
		var/bait_overlay_x = 11
		var/bait_overlay_y = -10
		var/mutable_appearance/bait_overlay = mutable_appearance(baited.icon, baited.icon_state)
		bait_overlay.pixel_x = bait_overlay_x
		bait_overlay.pixel_y = bait_overlay_y
		add_overlay(bait_overlay)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

#define FISHRARITYWEIGHTS = list("com" = 140, "rare" = 40, "ultra" = 18, "gold" = 1)
#define FISHSIZEWEIGHTS = list("tiny" = 4, "small" = 5, "normal" = 4, "large" = 3, "huge" = 2, "prize" = 1)

/obj/item/fishingrod/proc/checkreqs(mob/living/user)
	. = FALSE
	if(user.get_active_held_item() != src)//half of this code is basically ripped out of do_after, don't hold it against me
		return
	if(user.inertia_dir)
		return
	if(user.IsStun() || user.IsParalyzed())
		return
	if(user.loc != startingturf)
		return
	if(user.dir != startingdir)
		return
	return TRUE

/obj/item/fishingrod/proc/createui(mob/living/user)
	backdrop = new /atom/movable/fishingoverlay/base
	reelstate = new /atom/movable/fishingoverlay/pointer1
	fishstate = new /atom/movable/fishingoverlay/pointer2
	face = new /atom/movable/fishingoverlay/face
	faceframe = new /atom/movable/fishingoverlay/face/frame
	backdrop.owner = user.client
	user.client.screen += backdrop
	user.client.screen += reelstate
	user.client.screen += fishstate
	user.client.screen += face
	user.client.screen += faceframe

/obj/item/fishingrod/proc/deleteui(mob/living/user)
	user.client.screen -= backdrop
	user.client.screen -= reelstate
	user.client.screen -= fishstate
	user.client.screen -= face
	user.client.screen -= faceframe
	qdel(backdrop)
	qdel(reelstate)
	qdel(fishstate)
	qdel(face)
	qdel(faceframe)
	backdrop = null
	reelstate = null
	fishstate = null
	face = null
	faceframe = null

/obj/item/fishingrod/proc/stopgame(mob/living/user)
	src.deleteui(user)
	fisher = null
	fishrarity = null
	fishtype = null
	fishsize = null
	acceleration = 1
	maxvelocity = 0
	directionstate = null
	difficulty = 0
	fishtarget = 0
	fishhealth = 0
	linehealth = 0
	hookwindow = 0
	currentstate = null
	currentlyfishing = FALSE
	topzone_hold = 0
	reel_ready = FALSE
	reel_expire = 0
	reel_input = FALSE
	reel_successes = 0
	early_reel_streak = 0
	red_zone_visits = 0
	fish_was_red = FALSE
	current_fish_zone = "none"

/**
 * Hand-fishing cast minigame: runs the standard fishing UI/loop without a rod in-hand.
 * Called by water.dm via spawn() after a successful Stage 2 reel (CAST intent only).
 * The player advances the minigame by clicking the water turf (sets reel_input = TRUE).
 * Cleans up user.hand_fishing_cast_rod and qdel's itself when done.
 */
/obj/item/fishingrod/proc/begin_hand_fishing_cast_minigame(mob/living/carbon/human/user, catch_path, turf/open/water/water_turf)
	if(!user || QDELETED(user) || !catch_path)
		qdel(src)
		return

	// Anchor the player to where they are now.
	fisher = user
	startingturf = get_turf(user)
	startingdir = user.dir

	// Derive fish stats from the path challenge + skill (no tackle bonuses for hand-fishing).
	fishtype = catch_path
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/speed_mod = clamp(user.get_stat(STATKEY_SPD), 1, 20)
	var/path_challenge = get_fishing_path_challenge(catch_path)
	var/shore_distance = water_turf ? get_fishing_excluded_turf_distance(water_turf, 6) : 7
	var/near_shore_penalty = max(3 - shore_distance, 0)
	if(istype(water_turf, /turf/open/water/cleanshallow))
		near_shore_penalty = max(near_shore_penalty, 1)
	if(shore_distance <= 3)
		near_shore_penalty = max(near_shore_penalty, 3)

	// Base this cast minigame on auto-style hand formula, then handicap it as "worst gear".
	var/auto_style_reel = clamp(30 + (sl * 8) + (speed_mod * 3) - (path_challenge * 8), 5, 98)
	auto_style_reel = clamp(auto_style_reel - 12 - (near_shore_penalty * 8) - (shore_distance <= 3 ? 10 : 0), 5, 98)
	var/worst_gear_penalty = 20
	var/expected_reel = clamp(auto_style_reel - worst_gear_penalty, 2, 95)
	var/failure_pressure = clamp(round((100 - expected_reel) / 10), 1, 9)

	if(failure_pressure >= 8)
		fishsize = "prize"
		fishrarity = "gold"
	else if(failure_pressure >= 6)
		fishsize = "huge"
		fishrarity = "ultra"
	else if(failure_pressure >= 4)
		fishsize = "large"
		fishrarity = "rare"
	else
		fishsize = "normal"
		fishrarity = "com"

	difficulty = clamp(2 + path_challenge + round(failure_pressure / 2) - max(0, sl - 1), 1, 6)
	linehealth = max(4, sl + 2 - round(failure_pressure / 2))
	hookwindow = clamp(sl * 2 + 4 - round(failure_pressure / 2), (1 SECONDS), 4 SECONDS)
	acceleration = max(2, 1 + round(path_challenge / 2.0) + round(failure_pressure / 3.0))
	maxvelocity = max(2, 2 + round(path_challenge / 2.0) + round(failure_pressure / 3.0))
	fishhealth = 18 + path_challenge * 6 + failure_pressure * 2

	var/initialline = linehealth
	var/initialfish = fishhealth
	var/fish_challenge_mg = get_fish_total_challenge()
	var/skillmod = sl
	var/challenge_load = max(0, fish_challenge_mg - max(0, skillmod - 4))

	// Reset minigame state.
	reel_successes = 0
	failed_reel_attempts = 0
	early_reel_streak = 0
	red_zone_visits = 0
	fish_was_red = FALSE
	current_fish_zone = "none"
	reel_ready = FALSE
	reel_input = FALSE
	topzone_hold = 0
	reel_expire = 0
	currentstate = "hooked"
	currentlyfishing = TRUE
	directionstate = 1
	fishtarget = 90

	// NPC/headless: skip minigame and just give the catch.
	if(!user.client)
		if(user.hand_fishing_cast_rod == src)
			user.hand_fishing_cast_rod = null
		user.hand_fishing_mode = null
		user.hand_fishing_mode_until = 0
		user.hand_fishing_reel_size_tag = null
		var/obj/item/npc_catch = new catch_path(user.drop_location())
		if(istype(npc_catch, /obj/item/reagent_containers/food/snacks/fish))
			var/obj/item/reagent_containers/food/snacks/fish/FC = npc_catch
			apply_fishing_quality_to_fish(FC, list("commonFishingMod" = 1, "rareFishingMod" = 1, "treasureFishingMod" = 1, "trashFishingMod" = 1, "dangerFishingMod" = 1, "ceruleanFishingMod" = 0, "cheeseFishingMod" = 0), list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1))
		qdel(src)
		return

	createui(fisher)
	user.doing = TRUE

	var/caught = FALSE
	var/hooked_ticks = 0
	var/velocity = 0
	var/currentmouse = 0
	var/targetdif = 0
	var/facestate = 1
	var/next_stamina_tick = world.time + (5 SECONDS)
	var/hold_needed = clamp(1 + round(failure_pressure / 3), 1, 3)

	while(currentlyfishing)
		if(QDELETED(user) || !user.client)
			currentlyfishing = FALSE
			break
		if(is_far_from_cast_anchor(fisher))
			to_chat(fisher, span_warning("I stray too far and the fish slips free!"))
			currentlyfishing = FALSE
			break
		if(world.time >= next_stamina_tick)
			var/stamina_drain = get_fishing_stamina_drain(fisher, 18.75)
			if(stamina_drain && !fisher.stamina_add(stamina_drain))
				to_chat(fisher, span_warning("I'm too exhausted to keep fighting the fish."))
				currentlyfishing = FALSE
			next_stamina_tick = world.time + (5 SECONDS)
		if(user.IsStun() || user.IsParalyzed())
			to_chat(fisher, span_warning("I lose my grip!"))
			currentlyfishing = FALSE
		if(user.client)
			average_ping = user.client.avgping * 0.01

		currentmouse = clamp(backdrop.pointdir, 90, 270)
		reelstate.transform = 0
		var/matrix/M = matrix()
		M.Turn(currentmouse)
		reelstate.transform = M

		fishstate.transform = 0
		var/matrix/F = matrix()
		F.Turn(targetdif)
		fishstate.transform = F

		face.icon_state = "stress[facestate]"

		hooked_ticks++
		if(currentmouse > 180)
			fishhealth -= round(abs(currentmouse - 180) / 90, 0.1)
		fishhealth = max(1, fishhealth)
		if(linehealth <= 0)
			currentlyfishing = FALSE

		if(fishtarget > 90 && directionstate == 1)
			if(prob(fishtarget - 90))
				directionstate = -1
		else if(fishtarget < 90 && directionstate == -1)
			if(prob(abs(fishtarget - 90)))
				directionstate = 1

		targetdif = clamp((-currentmouse + fishtarget + 90) * difficulty, -90, 90)
		if(targetdif >= 90 || targetdif <= -90)
			if(COOLDOWN_FINISHED(src, ping_delay))
				linehealth--
				COOLDOWN_START(src, ping_delay, average_ping)

		var/fatigue_step = min(round(hooked_ticks / (8 SECONDS)), 3)
		var/effective_acceleration = max(1, acceleration - fatigue_step)
		var/effective_maxvelocity = max(1, maxvelocity - fatigue_step)
		velocity = clamp(velocity + ((effective_acceleration * directionstate) / 5), -effective_maxvelocity, effective_maxvelocity)
		fishtarget = clamp(fishtarget + velocity, 0, 180)

		switch(linehealth / initialline)
			if(0.81 to 1)
				facestate = 1
			if(0.61 to 0.8)
				facestate = 2
			if(0.41 to 0.6)
				facestate = 3
			if(0.21 to 0.4)
				facestate = 4
			else
				facestate = 5

		switch(fishhealth / initialfish)
			if(0.61 to 0.8)
				facestate -= 1
			if(0.41 to 0.6)
				facestate -= 2
			if(0.21 to 0.4)
				facestate -= 3
			if(0 to 0.2)
				facestate -= 4

		facestate = clamp(facestate, 1, 5)

		var/green_zone_margin = max(4, 18 - challenge_load * 2 - round(failure_pressure / 3))
		var/blue_zone_margin = 80
		var/abs_tdf = abs(targetdif)
		if(abs_tdf <= green_zone_margin)
			current_fish_zone = "green"
			topzone_hold++
			if(topzone_hold >= hold_needed && !reel_ready)
				reel_ready = TRUE
				reel_expire = world.time + (2 SECONDS)
				to_chat(fisher, span_notice("The fish is tiring! Click the water to reel it in!"))
		else if(abs_tdf <= blue_zone_margin)
			current_fish_zone = "blue"
			topzone_hold = 0
			reel_ready = FALSE
			reel_expire = 0
		else
			current_fish_zone = "red"
			topzone_hold = 0
			reel_ready = FALSE
			reel_expire = 0
			linehealth = max(0, linehealth - 2)
			if(!fish_was_red)
				red_zone_visits++
				if(red_zone_visits >= 2)
					early_reel_streak++
					red_zone_visits = 0
					to_chat(fisher, span_warning("The fish fights into the danger zone again!"))
				else
					to_chat(fisher, span_warning("The fish pulls hard — I need to steady my hand!"))
		fish_was_red = (abs_tdf > blue_zone_margin)

		if(reel_ready && world.time > reel_expire)
			reel_ready = FALSE
			topzone_hold = 0
			to_chat(fisher, span_warning("The fish recovers! Keep my hand centered to tire it again!"))

		if(reel_input && reel_ready)
			reel_input = FALSE
			reel_ready = FALSE
			var/reel_stamina_drain = get_fishing_stamina_drain(fisher, 37.5)
			if(reel_stamina_drain && !fisher.stamina_add(reel_stamina_drain))
				to_chat(fisher, span_warning("I'm too exhausted to haul against the fish."))
				currentlyfishing = FALSE
				sleep(1)
				continue
			topzone_hold = 0
			reel_expire = 0
			playsound(water_turf ? water_turf : get_turf(fisher), 'sound/items/fishing_plouf.ogg', 90, TRUE)
			reel_successes++
			if(reel_successes >= 2)
				to_chat(fisher, span_notice("I haul back hard and pull it in!"))
				caught = TRUE
				currentlyfishing = FALSE
			else
				hooked_ticks = 0
				red_zone_visits = 0
				fish_was_red = FALSE
				to_chat(fisher, span_userdanger("I GAIN GROUND! But the fish surges back. One more strong pull!"))

		sleep(1)

	// Cleanup
	if(!QDELETED(user))
		user.doing = FALSE
		if(user.hand_fishing_cast_rod == src)
			user.hand_fishing_cast_rod = null
		user.hand_fishing_mode = null
		user.hand_fishing_mode_until = 0
		user.hand_fishing_reel_size_tag = null
		if(user.client)
			deleteui(fisher)

	if(!caught || QDELETED(user))
		if(!QDELETED(user))
			var/injury_chance = clamp(25 + (failure_pressure * 5), 25, 65)
			if(prob(injury_chance))
				apply_fishing_bite_injury(user, water_turf ? water_turf : src)
			to_chat(user, span_warning("Damn, it slips free!"))
		qdel(src)
		return

	to_chat(user, span_notice("I pull it out of the water!"))
	playsound(water_turf, 'sound/items/Fish_out.ogg', 100, TRUE)
	user.adjust_experience(/datum/skill/labor/fishing, 1)
	var/static/list/hand_quality_mods = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0,
	)
	var/static/list/hand_size_weights = list("tiny" = 40, "small" = 40, "normal" = 40, "large" = 20, "huge" = 5, "prize" = 1)
	var/turf/drop_turf = get_safe_catch_drop_turf(user, water_turf)
	if(ispath(catch_path, /mob/living/simple_animal/hostile))
		new catch_path(water_turf)
	else if(ispath(catch_path, /mob))
		new catch_path(get_turf(user))
	else
		var/obj/item/new_catch = new catch_path(drop_turf)
		if(istype(new_catch, /obj/item/reagent_containers/food/snacks/fish))
			var/obj/item/reagent_containers/food/snacks/fish/FQ = new_catch
			apply_fishing_quality_to_fish(FQ, hand_quality_mods, hand_size_weights)
	qdel(src)

/obj/item/fishingrod/proc/get_targeted_water_turf(atom/target)
	var/turf/T = get_turf(target)
	if(!T)
		return null
	if(istype(T, /turf/open/water))
		return T
	if(!istype(T, /turf/open/transparent/openspace))
		return null
	var/turf/downcheck = T
	for(var/i in 1 to 12)
		downcheck = get_step_multiz(downcheck, DOWN)
		if(!downcheck)
			return null
		if(istype(downcheck, /turf/open/water))
			return downcheck
		if(!istype(downcheck, /turf/open/transparent/openspace))
			return null
	return null

/obj/item/fishingrod/proc/get_shore_distance(turf/open/water/W, max_scan = 6)
	return get_fishing_excluded_turf_distance(W, max_scan)

/obj/item/fishingrod/proc/is_shoreline_fishing_turf(turf/T)
	return is_excluded_fishing_border_turf(T)

/obj/item/fishingrod/afterattack(atom/target, mob/user, proximity, params)
	if(!check_allowed_items(target,target_self=1) \
	|| user.doing \
	|| !isliving(user) \
	|| !user.loc
	)

		return

	// Allow attaching bait by clicking bait items regardless of active intent.
	if(get_dist(user, target) <= 1 && istype(target, /obj/item))
		if(try_attach_bait_item(target, user))
			return

	if(user.used_intent.type != ROD_CAST && user.used_intent.type != ROD_AUTO && user.used_intent.type != SPEAR_BASH)
		return
	if((auto_reel_ready || cast_reel_pending) && (user.used_intent.type == ROD_AUTO || user.used_intent.type == ROD_CAST))
		if(cast_reel_pending)
			to_chat(user, "<span class='warning'>There's a bite waiting! Use [src] in hand to start reeling!</span>")
		else
			to_chat(user, "<span class='warning'>I already have a fish on the line! I need to reel it in first.</span>")
		return

	if(user.used_intent.type == SPEAR_BASH)
		if(get_dist(user, target) > 1)
			to_chat(user, "<span class='warning'>It's too far away...</span>")
			return
		if(istype(target, /obj/item))
			if(try_attach_bait_item(target, user))
				return
		var/turf/T = get_turf(target)
		if(!T)
			return
		for(var/obj/item/I in T)
			if(try_attach_bait_item(I, user))
				return
		to_chat(user, "<span class='warning'>I can't find usable bait there.</span>")
		return

	if(user.client)
		average_ping = user.client.avgping * 0.01

	if(get_dist(user, target) > 8)
		to_chat(user, "<span class='warning'>It's too far away...</span>")
		return

	var/turf/open/water/targeted = get_targeted_water_turf(target)
	if(!targeted)
		// If target is openspace, try to find water below for casting from above
		if(istype(target, /turf/open/transparent/openspace))
			var/turf/below = get_step_multiz(target, DOWN)
			if(istype(below, /turf/open/water))
				targeted = below
	if(!targeted)
		to_chat(user, "<span class='warning'>I can't fish here...</span>")
		return

	if(istype(targeted, /turf/open/water/bath) || istype(targeted, /turf/open/water/sewer))
		to_chat(user, "<span class='warning'>I can't fish here...</span>")

		return

	var/shore_distance = get_shore_distance(targeted, 6)
	var/cast_depth_bonus = max(min(shore_distance, 8) - 2, 0)
	var/near_shore_penalty = max(3 - shore_distance, 0)
	var/chummed_spot = is_chummed_fishing_turf(targeted)
	var/shallow_excluded_junk_zone = FALSE
	var/sinker_shore_override = istype(line, /obj/item/fishing/line/sinker)
	if(istype(targeted, /turf/open/water/cleanshallow))
		near_shore_penalty = max(near_shore_penalty, 1)
		if(shore_distance <= 3)
			shallow_excluded_junk_zone = TRUE
	if(shore_distance <= 3 && !sinker_shore_override)
		shallow_excluded_junk_zone = TRUE
		near_shore_penalty = max(near_shore_penalty, 3)

	if(!has_complete_fishing_rig())
		to_chat(user, "<span class='warning'>I'm missing something...</span>")
		return

	if(currentlyfishing)
		return

	//initialize fishing modifiers
	var/deepmod = 0
	var/is_abyssor_fisher = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H_patron_check = user
		is_abyssor_fisher = H_patron_check.patron?.type == /datum/patron/divine/abyssor
	var/list/raritypicker = list("com" = 140, "rare" = 40, "ultra" = 18, "gold" = 1)
	var/list/sizepicker = rod_size_weights.Copy()
	var/obj/item/fishing/bait/B = null
	fisher = user
	var/specialcatchprob = 0
	var/costmod = 1
	var/skillmod = 0
	startingturf = fisher.loc
	startingdir = fisher.dir

	var/list/attacheditems = list()
	attacheditems += reel
	attacheditems += hook
	attacheditems += line
	attacheditems += baited
	skillmod = fisher.get_skill_level(/datum/skill/labor/fishing)
	difficulty = -skillmod
	linehealth = skillmod + 6
	hookwindow = skillmod*3 + 5 + average_ping

	for(var/obj/item/A in attacheditems)
		if(!istype(A, /obj/item/fishing))
			continue
		var/obj/item/fishing/F = A
		deepmod += F.deepfishingweight
		linehealth += F.linehealth
		hookwindow += F.hookmod
		difficulty += F.difficultymod
		if(F.raritymod)
			pickweightmerge(raritypicker, F.raritymod)
		if(F.sizemod)
			pickweightmerge(sizepicker, F.sizemod)


	if(!targeted.can_see_sky())
		deepmod += 1

	var/list/fishpicker = list()
	var/list/deepfishlist = list(/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	if(istype(targeted, /turf/open/water/swamp))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 6,
							/obj/item/reagent_containers/food/snacks/fish/carp = 2)
	else if(istype(targeted, /turf/open/water/swamp/deep))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 5,
							/obj/item/reagent_containers/food/snacks/fish/carp = 3)
		deepmod += 1
	else if(istype(targeted, /turf/open/water/cleanshallow))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 3,
							/obj/item/reagent_containers/food/snacks/fish/carp = 5)
	else if(istype(targeted, /turf/open/water/river))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 2,
							/obj/item/reagent_containers/food/snacks/fish/carp = 6)
		deepmod += 1

	if(istype(baited, /obj/item/fishing/bait))
		B = baited
		fishpicker = pickweightmerge(fishpicker, B.fishinglist)
		if(B.deeplist)
			deepfishlist = B.deeplist
		if(B.specialchance)
			specialcatchprob = B.specialchance
		if(istype(B, /obj/item/fishing/bait/meat) && hook && (istype(hook, /obj/item/fishing/hook/iron) || istype(hook, /obj/item/fishing/hook/steel) || istype(hook, /obj/item/fishing/hook/deluxe)))
			fishpicker = pickweightmerge(fishpicker, list(/obj/item/reagent_containers/food/snacks/fish/octopus = 20))
			deepfishlist = pickweightmerge(deepfishlist, list(/obj/item/reagent_containers/food/snacks/fish/octopus = 12))
	else if(istype(baited, /obj/item/natural/worms))
		var/list/worm_fishloot = null
		if("fishloot" in baited.vars)
			worm_fishloot = baited.vars["fishloot"]
		if(worm_fishloot)
			fishpicker = pickweightmerge(fishpicker, worm_fishloot)
	else if(istype(baited, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = baited
		var/list/snack_fishloot = null
		if("fishloot" in S.vars)
			snack_fishloot = S.vars["fishloot"]
		if(snack_fishloot)
			fishpicker = pickweightmerge(fishpicker, snack_fishloot)
		if(S.sizemod)
			sizepicker = pickweightmerge(sizepicker, S.sizemod)
		if(S.raritymod)
			raritypicker = pickweightmerge(raritypicker, S.raritymod)

	if(is_cheese_bait(baited))
		fishpicker = pickweightmerge(fishpicker, list(
			/obj/item/reagent_containers/food/snacks/smallrat = 20,
			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 3,
		))

	if(cast_depth_bonus)
		deepmod += cast_depth_bonus
		for(var/i in 1 to cast_depth_bonus)
			raritypicker = pickweightmerge(raritypicker, list("com" = -1, "rare" = 1))
			if(i >= 2)
				raritypicker = pickweightmerge(raritypicker, list("ultra" = 1))
			sizepicker = pickweightmerge(sizepicker, list("tiny" = -1, "small" = -1, "large" = 1, "huge" = 1, "prize" = 1))

	if(near_shore_penalty)
		deepmod = max(0, deepmod - near_shore_penalty)
		for(var/i in 1 to near_shore_penalty)
			raritypicker = pickweightmerge(raritypicker, list("com" = 2, "rare" = -1, "ultra" = -1, "gold" = -1))
			sizepicker = pickweightmerge(sizepicker, list("tiny" = 2, "small" = 1, "large" = -1, "huge" = -2, "prize" = -3))

	if(shallow_excluded_junk_zone)
		raritypicker = pickweightmerge(raritypicker, list("com" = 12, "rare" = -999, "ultra" = -999, "gold" = -999))
		sizepicker = pickweightmerge(sizepicker, list("tiny" = 5, "small" = 4, "normal" = 2, "large" = -6, "huge" = -8, "prize" = -999))

	if(chummed_spot)
		deepmod += 1
		raritypicker = pickweightmerge(raritypicker, list("com" = -2, "rare" = 2, "ultra" = 1, "gold" = 1))

	while(deepmod > 0)
		fishpicker = pickweightmerge(fishpicker, deepfishlist)
		deepmod--

	//initialize fish modifiers
	var/specialcatching = FALSE
	var/specialfish = FALSE
	var/specialrarity = FALSE
	var/specialsize = FALSE
	var/turfcatch = FALSE
	var/trashfishing = FALSE
	if(prob(specialcatchprob))
		specialcatching = TRUE
		if(B.specialsize)
			specialsize = TRUE
			difficulty += B.specialsize["diffmod"]
			acceleration += B.specialsize["accmod"]
			fishhealth += B.specialsize["health"]
			hookwindow += B.specialsize["hookmod"]
			fishsize = B.specialsize["type"]
			costmod *= B.specialsize["costmod"]
		if(B.specialrarity)
			specialrarity = TRUE
			difficulty += B.specialrarity["diffmod"]
			acceleration += B.specialrarity["accmod"]
			fishhealth += B.specialrarity["health"]
			hookwindow += B.specialrarity["hookmod"]
			fishrarity = B.specialrarity["type"]
			costmod *= B.specialrarity["costmod"]
		if(B.specialfishtype)
			specialfish = TRUE
			difficulty += B.specialfishtype["diffmod"]
			acceleration += B.specialfishtype["accmod"]
			fishhealth += B.specialfishtype["health"]
			hookwindow += B.specialfishtype["hookmod"]
			fishtype = B.specialfishtype["type"]
			costmod *= B.specialfishtype["costmod"]
		if(B.specialturfcatch)
			turfcatch = TRUE
	else
		if(fisher.STALUC > 10)
			var/luckboost = fisher.STALUC - 10
			// Every point over 10 boosts rare and cuts common.
			// Every 2 points over 10 also boosts ultra and gold.
			for(var/lki in 1 to luckboost)
				raritypicker = pickweightmerge(raritypicker, list("com" = -1, "rare" = 1))
				if(!(lki % 2))
					raritypicker = pickweightmerge(raritypicker, list("ultra" = 1, "gold" = 1))

		if(prob(16 - skillmod - fisher.STALUC)) //you will always have a chance at this, legendary fishers got a 10% chance - their luck stat
			fishtype = pickweight(list(/obj/item/natural/fibers = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/clothing/shoes/roguetown/boots/leather = 1, /obj/structure/fermentation_keg = 1, /obj/item/clothing/head/roguetown/fisherhat = 1))
			difficulty = 1
			acceleration = 1
			hookwindow = 30
			maxvelocity = 1
			fishhealth = 15
			trashfishing = TRUE

		if(!trashfishing)
			raritypicker = removenegativeweights(raritypicker)
			sizepicker = removenegativeweights(sizepicker)
			if(shallow_excluded_junk_zone)
				raritypicker = list("com" = 1)
				sizepicker["large"] = 0
				sizepicker["huge"] = 0
				sizepicker["prize"] = 0

			fishsize = pickweightAllowZero(sizepicker)
			fishrarity = pickweightAllowZero(raritypicker)
			fishtype = pickweightAllowZero(fishpicker)
			if(!is_abyssor_fisher && (fishtype == /obj/item/reagent_containers/food/snacks/fish/creepy_squid || fishtype == /obj/item/reagent_containers/food/snacks/fish/creepy_shark))
				var/list/safe_fishpicker = fishpicker.Copy()
				safe_fishpicker -= /obj/item/reagent_containers/food/snacks/fish/creepy_squid
				safe_fishpicker -= /obj/item/reagent_containers/food/snacks/fish/creepy_shark
				fishtype = pickweightAllowZero(safe_fishpicker)

			difficulty += sizepicker.Find(fishsize) + raritypicker.Find(fishrarity) - 1
			hookwindow -= raritypicker.Find(fishrarity) - 1
			acceleration += clamp(sizepicker.Find(fishsize) - 3, 0, 2) + clamp(raritypicker.Find(fishrarity) - 1, 0, 3)
			maxvelocity = 3 + clamp(raritypicker.Find(fishrarity) - 1, 0, 3) + clamp(sizepicker.Find(fishsize) - 3, -1, 2)
			fishhealth =  9 + sizepicker.Find(fishsize)*6 + raritypicker.Find(fishrarity)*6
			if(fishsize == "tiny")
				costmod *= 0.5
			else if(fishsize == "small")
				costmod *= 0.75
			else if(fishsize == "large")
				costmod *= 1.05
			else if(fishsize == "huge")
				costmod *= 2.1
			else if(fishsize == "prize")
				costmod *= 3.5
			switch(fishrarity)
				if("rare")
					costmod *= 2
				if("ultra")
					costmod *= 4
				if("gold")
					costmod *= 10

	difficulty = clamp(difficulty, 1, 6)
	hookwindow = clamp(hookwindow, (1.5 SECONDS), 5 SECONDS)
	acceleration = max(acceleration, 1)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing) // User's skill level
	var/ft = 120 //Time to get a catch, in ticks
	var/fpp =  100 - (40 + (sl * 10)) // Fishing power penalty based on fishing skill level
	var/caught = FALSE
	var/line_snapped = FALSE
	var/list/modlist
	if(!check_allowed_items(target,target_self=1))
		return ..()

	if(user.used_intent.type != ROD_CAST)
		if(user.used_intent.type == ROD_AUTO && !user.doing)
			if(auto_reel_ready && world.time > auto_reel_deadline)
				to_chat(user, "<span class='warning'>Too slow. The fish slips free.</span>")
				reset_auto_pending_catch()
			user.visible_message("<span class='warning'>[user] casts a line!</span>", \
								"<span class='notice'>I cast a line.</span>")
			playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
			ft = max(18, ((1 SECONDS) - sl) * 8)
			ft = round(ft * get_cast_time_multiplier())
			if(do_after(user,ft, target = user))
				if(baited)
					var/bite_bonus = get_bite_chance_bonus(targeted, shore_distance)
					var/bite_mult = get_bite_chance_multiplier(shore_distance)
					var/bp = baited.baitpenalty // Penalty to fishing chance based on how good bait is. Lower is better.
					var/fishchance = 100 // Total fishing chance, deductions applied below
					fishchance -= (difficulty * 15) ///based on the fishes difficulty means better fishing rods can be given to shit fishers
					fishchance += cast_depth_bonus * 8
					fishchance -= near_shore_penalty * 20
					if(shallow_excluded_junk_zone)
						fishchance -= 55
					fishchance += bite_bonus
					if(chummed_spot)
						fishchance += 20
					if(has_world_trait(/datum/world_trait/fishing_decrease))
						fishchance -= 25
					if(has_world_trait(/datum/world_trait/fishing_increase))
						fishchance += 40
					if(user.mind)
						if(!sl) // If we have zero fishing skill...
							fishchance -= 50 // 50% chance to fish base
						else
							fishchance -= bp // Deduct penalties from bait quality, if any
							fishchance -= fpp // Deduct a penalty the lower our fishing level is (-0 at legendary)
					fishchance = round(fishchance * bite_mult)
					fishchance = clamp(fishchance, 2, 98)
					if(islist(baited.fishingMods))
						modlist = baited.fishingMods.Copy()
					else
						modlist = list(
							"commonFishingMod" = 1,
							"rareFishingMod" = 1,
							"treasureFishingMod" = 1,
							"trashFishingMod" = 1,
							"dangerFishingMod" = 1,
							"ceruleanFishingMod" = 0,
							"cheeseFishingMod" = 0,
						)
					if(is_cheese_bait(baited))
						modlist["cheeseFishingMod"] = 1
					if(shallow_excluded_junk_zone)
						modlist["force_common_rarity"] = TRUE
						modlist["force_nonprize_size"] = TRUE
					if(prob(fishchance)) // Finally, roll the dice to see if we fish.
						var/A = getfishingloot(user, modlist, targeted)
						if(shallow_excluded_junk_zone && prob(96))
							A = get_cast_junk_reward_path()
						if(is_shellfish_catch_path(A))
							A = istype(targeted, /turf/open/water/ocean) || istype(targeted, /turf/open/water/ocean/deep) ? /obj/item/reagent_containers/food/snacks/fish/cod : /obj/item/reagent_containers/food/snacks/fish/carp
						if(A)
							var/ow = 30 + (sl * 10) // Opportunity window, in ticks. Longer means you get more time to cancel your bait
							to_chat(user, "<span class='notice'>Something tugs the line! Use [src] in hand to reel it in!</span>")
							targeted.balloon_alert_to_viewers("Tug!")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							auto_reel_ready = TRUE
							auto_pending_catch = A
							auto_pending_modlist = islist(modlist) ? modlist.Copy() : null
							auto_pending_target = targeted
							auto_reel_deadline = world.time + ow
							apply_tackle_wear(user, 1, 1, 1)
					else
						to_chat(user, "<span class='warning'>Not even a nibble...</span>")
						apply_tackle_wear(user, 1, 0, 1)
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, 1) // Pity XP.
				else
					to_chat(user, "<span class='warning'>This seems pointless without bait.</span>")
			else
				to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()
			return
	else
		user.visible_message("<span class='warning'>[user] casts a line!</span>", \
							"<span class='notice'>I cast a line.</span>")
		playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
		var/ft_cast = max(9, ((1 SECONDS) - sl) * 4)
		ft_cast = round(ft_cast * get_cast_time_multiplier())
		if(!do_after(user, ft_cast, target = user))
			to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			return
		var/cast_bite_chance = 70 + (cast_depth_bonus * 10) - (near_shore_penalty * 20) + (sl * 3) + get_bite_chance_bonus(targeted, shore_distance) + (chummed_spot ? 20 : 0)
		if(shallow_excluded_junk_zone)
			cast_bite_chance -= 55
		cast_bite_chance = round(cast_bite_chance * get_bite_chance_multiplier(shore_distance))
		cast_bite_chance = clamp(cast_bite_chance, 5, 98)
		if(!prob(cast_bite_chance))
			to_chat(user, "<span class='warning'>No bite... I should cast farther from shore.</span>")
			apply_tackle_wear(user, 1, 0, 1)
			update_icon()
			return
		// Got a bite. Wait for the player to use the rod in-hand to start reeling (like auto intent).
		cast_reel_pending = TRUE
		cast_reel_pending_deadline = world.time + 30 + (sl * 10)
		targeted.balloon_alert_to_viewers("Tug!")
		playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
		to_chat(user, "<span class='notice'>There's a bite! Use [src] in hand to start reeling!</span>")
		while(cast_reel_pending && world.time <= cast_reel_pending_deadline)
			if(is_far_from_cast_anchor(fisher))
				snap_line_from_anchor_drift(user)
				update_icon()
				return
			sleep(1)
		if(cast_reel_pending) // Deadline expired before player triggered.
			cast_reel_pending = FALSE
			to_chat(user, "<span class='warning'>Too slow. The fish wriggled free.</span>")
			apply_tackle_wear(user, 1, 1, 1)
			update_icon()
			return
		// Player triggered - refresh starting position and begin the initial reel pull.
		startingturf = fisher.loc
		startingdir = fisher.dir
		var/initial_reel_time = max(1, round(get_skill_delay(sl, 1, slowest = 7) * get_reel_time_multiplier() * 0.5))
		playsound(src.loc, 'sound/misc/reeling.ogg', 70, FALSE)
		to_chat(user, "<span class='notice'>I start reeling against the bite...</span>")
		to_chat(user, "<span class='notice'>[get_fishing_size_feel_text(fishsize, fishtype)]</span>")
		if(!do_after(user, initial_reel_time, target = user))
			to_chat(user, "<span class='warning'>I miss the first pull and lose the bite.</span>")
			apply_tackle_wear(user, 1, 1, 1)
			update_icon()
			return
		// Strength + fishing level check: harder fish can tear free before the hook sets.
		var/fish_challenge_hook = get_fish_total_challenge()
		if(fish_challenge_hook > 0)
			var/str_hook = 10
			if(ishuman(fisher))
				var/mob/living/carbon/human/H_hook = fisher
				str_hook = H_hook.STASTR
			var/hook_roll = rand(1, 10) + str_hook + sl
			var/hook_target = 8 + fish_challenge_hook * 4
			if(hook_roll < hook_target)
				to_chat(user, "<span class='warning'>The fish fights viciously — it tears free before I can secure the line!</span>")
				apply_tackle_wear(user, 1, 1, 1)
				update_icon()
				return
		// The fish is now secured. Reset anchor so tiny orientation/position changes during the reel-in stage don't instantly fail the minigame.
		startingturf = fisher.loc
		startingdir = fisher.dir

		//the actual game
		currentlyfishing = TRUE
		currentstate = "hooked"
		var/waittime = rand(30, 50) - skillmod*2
		var/lastmouse = 0
		var/currentmouse = 0
		var/targetdif = 0
		var/velocity
		var/initialwait = waittime
		var/initialline = linehealth //these last two are for the face
		var/initialfish = fishhealth
		var/facestate = 1
		var/hooked_ticks = 0
		var/next_stamina_tick = world.time + (5 SECONDS)
		reel_successes = 0
		failed_reel_attempts = 0
		early_reel_streak = 0
		// Pre-compute fish challenge for the minigame: skill partially offsets it, but hard fish always pressure the player.
		var/fish_challenge_minigame = get_fish_total_challenge()
		var/challenge_load = max(0, fish_challenge_minigame - max(0, skillmod - 4))
		createui(fisher)
		fisher.doing = TRUE
		directionstate = 1
		fishtarget = 90

		while(currentlyfishing)
			if(is_far_from_cast_anchor(fisher))
				snap_line_from_anchor_drift(fisher)
				line_snapped = TRUE
				currentlyfishing = FALSE
			if(world.time >= next_stamina_tick)
				var/stamina_drain = get_fishing_stamina_drain(fisher, 18.75)
				if(stamina_drain && !fisher.stamina_add(stamina_drain))
					to_chat(fisher, "<span class='warning'>I'm too exhausted to keep fighting the fish.</span>")
					currentlyfishing = FALSE
				next_stamina_tick = world.time + (5 SECONDS)
			if(user.client)
				average_ping = user.client.avgping * 0.01

			if(!checkreqs(fisher))
				currentlyfishing = FALSE

			currentmouse = clamp(backdrop.pointdir, 90, 270)
			reelstate.transform = 0
			var/matrix/M = matrix()
			M.Turn(currentmouse)
			reelstate.transform = M

			fishstate.transform = 0
			var/matrix/F = matrix()
			F.Turn(targetdif)
			fishstate.transform = F

			face.icon_state = "stress[facestate]"

			switch(currentstate)
				if("wait")
					if(waittime <= 0)
						if(line && line.bobber)
							to_chat(fisher, "<span class = 'notice'>The [line.name] dips in the water!</span>")
							playsound(loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
						if(abs(currentmouse - lastmouse) > 6 && waittime / initialwait < 0.4)
							currentlyfishing = FALSE
						currentstate = "biting"
					waittime--
				if("biting")
					if(hookwindow <= 0)
						currentlyfishing = FALSE
					if(targetdif == 0)
						targetdif -= clamp(skillmod*2, 3, 10)
					else
						targetdif = 0
					if(currentmouse > lastmouse)
						currentstate = "hooked"
						targetdif = 0
						fishtarget = (-currentmouse + 270)
						to_chat(fisher, "<span class='notice'>Something tugs the line!</span>")
						playsound(loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
						directionstate = 1
					hookwindow -= 1
				if("hooked")
					hooked_ticks++
					if(currentmouse > 180)
						fishhealth -= round(abs(currentmouse - 180)/90, 0.1)

					// Keep fish pressure and visuals, but prevent passive auto-catch.
					fishhealth = max(1, fishhealth)
					if(linehealth <= 0)
						currentlyfishing = FALSE

					if(fishtarget > 90 && directionstate == 1)
						if(prob(fishtarget - 90))
							directionstate = -1
					else if(fishtarget < 90 && directionstate == -1)
						if(prob(abs(fishtarget - 90)))
							directionstate = 1

					targetdif = clamp((-currentmouse + fishtarget + 90) * difficulty, -90, 90)
					if(targetdif >= 90 || targetdif <= -90)
						if(COOLDOWN_FINISHED(src, ping_delay))
							linehealth--
							COOLDOWN_START(src, ping_delay, average_ping) ///this gives users the average ping free time between damages incase of lag spikes you don't instantly lose
					var/fatigue_step = min(round(hooked_ticks / (8 SECONDS)), 3)
					var/effective_acceleration = max(1, acceleration - fatigue_step)
					var/effective_maxvelocity = max(1, maxvelocity - fatigue_step)
					velocity = clamp(velocity + ((effective_acceleration*directionstate)/5), -effective_maxvelocity, effective_maxvelocity)
					fishtarget = clamp(fishtarget + velocity, 0, 180)

					switch(linehealth / initialline)
						if(0.81 to 1)
							facestate = 1
						if(0.61 to 0.8)
							facestate = 2
						if(0.41 to 0.6)
							facestate = 3
						if(0.21 to 0.4)
							facestate = 4
						else
							facestate = 5

					switch(fishhealth / initialfish)
						if(0.61 to 0.8)
							facestate -= 1
						if(0.41 to 0.6)
							facestate -= 2
						if(0.21 to 0.4)
							facestate -= 3
						if(0 to 0.2)
							facestate -= 4

					facestate = clamp(facestate, 1, 5)

					// Top-zone reel mechanic: keep fishstate centered (targetdif near 0) to tire the fish.
					// Bigger/rarer fish fight harder due to higher velocity and acceleration.
					var/hold_needed = 1
					// Zone margins: green zone narrows for rarer/bigger fish; skill partially offsets it.
					var/green_zone_margin = max(6, 20 - challenge_load * 2)
					var/blue_zone_margin = 80
					var/abs_tdf = abs(targetdif)
					if(abs_tdf <= green_zone_margin)
						current_fish_zone = "green"
						topzone_hold++
						if(topzone_hold >= hold_needed && !reel_ready)
							reel_ready = TRUE
							reel_expire = world.time + (2 SECONDS)
							to_chat(fisher, "<span class='notice'>The fish is tiring! Use the rod to reel it in!</span>")
					else if(abs_tdf <= blue_zone_margin)
						current_fish_zone = "blue"
						topzone_hold = 0
						reel_ready = FALSE
						reel_expire = 0
					else
						current_fish_zone = "red"
						topzone_hold = 0
						reel_ready = FALSE
						reel_expire = 0
						// Red-zone contact should punish quickly.
						linehealth = max(0, linehealth - 2)
						if(!fish_was_red)
							red_zone_visits++
							if(red_zone_visits >= 2)
								early_reel_streak++
								red_zone_visits = 0
								to_chat(fisher, "<span class='warning'>The fish fights into the danger zone again!</span>")
							else
								to_chat(fisher, "<span class='warning'>The fish pulls hard to the side — steady the line!</span>")
					fish_was_red = (abs_tdf > blue_zone_margin)

					if(reel_ready && world.time > reel_expire)
						reel_ready = FALSE
						topzone_hold = 0
						to_chat(fisher, "<span class='warning'>The fish recovers! Keep the rod steady in front of you to tire it again!</span>")

					if(reel_input && reel_ready)
						reel_input = FALSE
						reel_ready = FALSE
						var/reel_stamina_drain = get_fishing_stamina_drain(fisher, 37.5)
						if(reel_stamina_drain && !fisher.stamina_add(reel_stamina_drain))
							to_chat(fisher, "<span class='warning'>I'm too exhausted to haul against the fish.</span>")
							currentlyfishing = FALSE
							continue
						topzone_hold = 0
						reel_expire = 0
						playsound(loc, 'sound/misc/reeling.ogg', 80, FALSE)
						reel_successes++
						if(reel_successes >= 2)
							to_chat(fisher, "<span class='notice'>I haul back hard and pull it in!</span>")
							caught = TRUE
							currentlyfishing = FALSE
						else
							// After each successful reel, the fish surges back to full speed.
							hooked_ticks = 0
							red_zone_visits = 0
							fish_was_red = FALSE
							to_chat(fisher, span_userdanger("I GAIN LINE! But the fish surges back. One more strong reel should do it!"))

			lastmouse = currentmouse
			sleep(1)

	if(!caught)
		to_chat(user, "<span class = 'warning'>Damn, got away...</span>")
	else
		to_chat(user, "<span class = 'notice'>I pull something out of the water!</span>")
		playsound(loc, 'sound/items/Fish_out.ogg', 100, TRUE)
		fisher.adjust_experience(/datum/skill/labor/fishing, 1)
		var/turf/safe_drop_turf = get_safe_catch_drop_turf(fisher, targeted)
		if(shallow_excluded_junk_zone && ispath(fishtype, /obj/item/reagent_containers/food/snacks/fish) && prob(98))
			fishtype = get_cast_junk_reward_path()
			to_chat(user, "<span class='notice'>The shallow waters cough up mostly junk.</span>")
		if(!ispath(fishtype))
			fishtype = get_cast_junk_reward_path()
			to_chat(user, "<span class='notice'>I still dredge up some junk for my trouble.</span>")
		else if(ispath(fishtype, /obj/item/reagent_containers/food/snacks/fish))
			try_spawn_deluxe_bonus_fish(fisher, modlist, targeted, fishtype)
			var/obj/item/reagent_containers/food/snacks/caughtfish = new fishtype(safe_drop_turf)
			var/raritydesc
			var/sizedesc

			if(!specialfish)
				if(!specialrarity)
					switch(fishrarity)
						if("rare")
							raritydesc = "rare"
							caughtfish.raritymod = list("com"= -30)//some incentive to use rarer tiny fish as bait
						if("ultra")
							raritydesc = "ultra-rare"
							caughtfish.raritymod = list("com"= -50)
						if("gold")
							raritydesc = "legendary"
							caughtfish.raritymod = list("com"= -70, "rare" = -20)
						else
							raritydesc = "common"
				// Only apply rarity suffix if the fish type has the property and doesn't set no_rarity_sprite
				if(istype(caughtfish, /obj/item/reagent_containers/food/snacks/fish))
					var/obj/item/reagent_containers/food/snacks/fish/F = caughtfish
					if(!initial(F.no_rarity_sprite) && islist(F.rarity_icon_states) && F.rarity_icon_states[fishrarity])
						caughtfish.icon_state = F.rarity_icon_states[fishrarity]
					if(fishrarity != "com")
						switch(fishtype)
							if(/obj/item/reagent_containers/food/snacks/fish/carp)
								caughtfish.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/rare
								caughtfish.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/rare
							if(/obj/item/reagent_containers/food/snacks/fish/eel)
								caughtfish.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/rare
								caughtfish.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/rare
							if(/obj/item/reagent_containers/food/snacks/fish/angler)
								caughtfish.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/rare
								caughtfish.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/rare
							if(/obj/item/reagent_containers/food/snacks/fish/clownfish)
								caughtfish.fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/rare
								caughtfish.cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/rare
				else
					raritydesc = fishrarity

				if(!specialsize)
					caughtfish.vars["fishloot"] = null
					switch(fishsize)
						if("tiny")
							caughtfish.sizemod = list("tiny" = -999)//fish can't swallow a fish of the same size
						if("small")
							caughtfish.sizemod = list("tiny" = -999, "small" = -999)
						if("large")
							caughtfish.vars["fishloot"] = null//can't use fish larger than normal size as bait
				if(istype(caughtfish, /obj/item/reagent_containers/food/snacks/fish))
					var/obj/item/reagent_containers/food/snacks/fish/F = caughtfish
					F.apply_fishing_size(fishsize)
				sizedesc = fishsize
				if(specialcatching)
					var/obj/item/fishing/bait/specialmaker = baited
					specialmaker.makespecial(caughtfish)
				else
					caughtfish.name = "[sizedesc] [raritydesc] [caughtfish.name]"
					caughtfish.sellprice *= costmod
		else//only occurs on special catch that most likely won't have special modifiers
			if(turfcatch)
				var/atom/caughtthing = new fishtype(targeted)
				if(specialcatching)
					var/obj/item/fishing/bait/specialmaker = baited
					specialmaker.makespecial(caughtthing)
			else
				var/atom/caughtthing2
				if(ispath(fishtype, /obj/item))
					caughtthing2 = new fishtype(safe_drop_turf)
				else
					caughtthing2 = new fishtype(safe_drop_turf || fisher.loc)
				if(specialcatching)
					var/obj/item/fishing/bait/specialmaker = baited
					specialmaker.makespecial(caughtthing2)

	if(!caught)
		if(!line_snapped)
			apply_tackle_wear(user, 2, 1, 1)
	else
		apply_tackle_wear(user, 3, 2, 2)
		if(baited && getbaitlife(sl, baited))
			to_chat(user, "<span class='warning'>Damn, it ate my bait.</span>")
			qdel(baited)
			baited = null
			update_icon()

	fisher.doing = FALSE
	stopgame(fisher)
	update_icon()

/obj/item/fishingrod/fisher

/obj/item/fishingrod/fisher/Initialize()
	. = ..()
	reel = new /obj/item/fishing/reel/silk(src)
	reel.alpha = 0
	hook = new /obj/item/fishing/hook/iron(src)
	hook.alpha = 0
	line = new /obj/item/fishing/line/bobber(src)
	line.alpha = 0

/obj/item/fishingrod/aalloy
	name = "decrepit fishing rod"
	desc = "The Comet Syon's impact drowned the world, long ago. The waves've long since receded, but His greatest works remain shrouded far beneath the sea."
	icon_state = "arod"
	color = "#bb9696"
	sellprice = 15

