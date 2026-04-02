/obj/item/fishingrod
	force = 12
	possible_item_intents = list(ROD_AUTO, ROD_CAST,SPEAR_BASH)
	name = "fishing rod"
	desc = "Made from weathered wood and coarse twine. The tool of the battle against the dark waters below."
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
	COOLDOWN_DECLARE(ping_delay)

/datum/intent/cast
	name = "cast"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "cast"
	no_attack = TRUE

/datum/intent/auto
	name = "auto reel"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "auto"
	no_attack = TRUE

/obj/item/fishingrod/attack_self(mob/user)
	if(user.doing)
		user.doing = 0
	else
		..()

/obj/item/fishingrod/attackby(obj/item/I, mob/user, params)
	if(baited && reel && hook && line)
		return  ..()

	if(istype(I, /obj/item/fishing/bait) || istype(I, /obj/item/natural/worms) || istype(I, /obj/item/natural/bundle/worms) || istype(I, /obj/item/reagent_containers/food/snacks))
		if(istype(I, /obj/item/fishing/bait) || istype(I, /obj/item/natural/worms))
			if(!baited)
				I.forceMove(src)
				baited = I
				user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [I] to my line.</span>")
				playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
		else if(istype(I, /obj/item/natural/bundle/worms))
			if(!baited)
				var/obj/item/natural/bundle/worms/W = I
				baited = new W.stacktype(src)
				W.amount--
				if(W.amount == 1)
					new W.stacktype(get_turf(user))
					qdel(W)
				user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [W.stacktype] to my line.</span>")
				playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)
		else
			if(!baited)
				var/list/snack_fishloot = I.vars["fishloot"]
				if(snack_fishloot)
					I.forceMove(src)
					baited = I
					user.visible_message("<span class='notice'>[user] hooks something to the line.</span>", "<span class='notice'>I hook [I] to my line.</span>")
					playsound(src.loc, 'sound/foley/pierce.ogg', 50, FALSE)

	else if(istype(I, /obj/item/fishing)) //bait has a null attachtype and is accounted for in the previous check so i don't have to worry about it
		var/obj/item/fishing/T = I
		switch(T.attachtype)
			if("line")
				if(!line)
					attach_tackle(T)
					line = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("hook")
				if(!hook)
					attach_tackle(T)
					hook = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
			if("reel")
				if(!reel)
					attach_tackle(T)
					reel = T
					to_chat(user, "<span class='notice'>I add [I] to [src]...</span>")
	update_icon()
	return

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
	if(line?.bobber)
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
	if(!user.canUseTopic(src, be_close=TRUE))
		return

	var/has_rig = (baited || hook || (line && line.bobber))
	if(!has_rig && !line && !reel)
		to_chat(user, "<span class='notice'>There's nothing on this fishing rod!</span>")
		return

	var/list/choices = list()
	if(has_rig)
		choices["Remove Rig (bait/hook/bobber)"] = image(icon = 'icons/roguetown/items/fishing.dmi', icon_state = "bobber")
	if(line && !line.bobber)
		choices["Remove Line"] = image(icon = line.icon, icon_state = line.icon_state)
	if(reel)
		choices["Remove Tackle"] = image(icon = reel.icon, icon_state = reel.icon_state)

	var/choice = show_radial_menu(user, src, choices, require_near = TRUE, tooltips = TRUE)
	if(!choice)
		return

	switch(choice)
		if("Remove Rig (bait/hook/bobber)")
			remove_rig(user)
			to_chat(user, "<span class='notice'>I remove the rig from [src].</span>")
		if("Remove Line")
			if(line)
				drop_attachment(line, user)
				line = null
				to_chat(user, "<span class='notice'>I remove the line from [src].</span>")
		if("Remove Tackle")
			if(reel)
				drop_attachment(reel, user)
				reel = null
				to_chat(user, "<span class='notice'>I remove the tackle from [src].</span>")

	update_icon()
	return

/obj/item/fishingrod/AltClick(mob/user)
	if(!user.canUseTopic(src, be_close=TRUE))
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
	if(reel)
		to_chat(user, "<span class='info'>There's a [reel.name] strung on this rod.</span>")
	else
		to_chat(user, "<span class='warning'>I'm missing the fishing line.</span>")

	if(hook)
		to_chat(user, "<span class='info'>There's a [hook.name] on this rod.</span>")
	else
		to_chat(user, "<span class='warning'>I'm missing the hook.</span>")

	if(line)
		to_chat(user, "<span class='info'>There's a [line.name] on this rod.</span>")

/obj/item/fishingrod/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -14,"sy" = 3,"nx" = 14,"ny" = 3,"wx" = -12,"wy" = 4,"ex" = 6,"ey" = 5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/fishingrod/update_icon()
	cut_overlays()
	if(baited)
		var/obj/item/I = baited
		I.pixel_x = 6
		I.pixel_y = -6
		add_overlay(new /mutable_appearance(I))
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

#define FISHRARITYWEIGHTS = list("com" = 70, "rare" = 20, "ultra" = 9, "gold" = 1)
#define FISHSIZEWEIGHTS = list("tiny" = 4, "small" = 4, "normal" = 4, "large" = 2, "prize" = 1)

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

/obj/item/fishingrod/afterattack(obj/target, mob/user, proximity, params)
	if(!check_allowed_items(target,target_self=1) \
	|| (user.used_intent.type != ROD_CAST && user.used_intent.type != ROD_AUTO) \
	|| user.doing \
	|| !isliving(user) \
	|| !user.loc
	)

		return

	if(user.client)
		average_ping = user.client.avgping * 0.01

	if(get_dist(user, target) > 5)
		to_chat(user, "<span class='warning'>It's too far away...</span>")
		return

	var/turf/targeted
	if(istype(target, /turf/open/transparent/openspace))
		var/turf/downcheck = get_step_multiz(target, DOWN)
		if(istype(downcheck, /turf/open/water))
			targeted = downcheck
		else
			to_chat(user, "<span class='warning'>I can't fish here...</span>")
			return
	else if(istype(target, /turf/open/water))
		targeted = target
	else
		to_chat(user, "<span class='warning'>I can't fish here...</span>")
		return

	var/localwater = 0
	for(var/turf/open/W in block(get_step(targeted, SOUTHWEST), get_step(targeted, NORTHEAST)))
		if(istype(W, /turf/open/water))
			localwater++
	if(localwater < 5)
		to_chat(user, "<span class='warning'>I can't fish here...</span>")
		return

	if(istype(targeted, /turf/open/water/bath) || istype(targeted, /turf/open/water/sewer))
		to_chat(user, "<span class='warning'>I can't fish here...</span>")

		return

	if(!baited || !hook || !line)
		to_chat(user, "<span class='warning'>I'm missing something...</span>")
		return

	if(currentlyfishing)
		return

	//initialize fishing modifiers
	var/deepmod = 0
	var/list/raritypicker = list("com" = 70, "rare" = 20, "ultra" = 9, "gold" = 1)
	var/list/sizepicker = list("tiny" = 4, "small" = 4, "normal" = 4, "large" = 2, "prize" = 1)
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
	hookwindow = skillmod*3 + 4 + average_ping

	for(var/obj/item/fishing/A in attacheditems)
		deepmod += A.deepfishingweight
		linehealth += A.linehealth
		hookwindow += A.hookmod
		difficulty += A.difficultymod
		if(A.raritymod)
			pickweightmerge(raritypicker, A.raritymod)
		if(A.sizemod)
			pickweightmerge(sizepicker, A.sizemod)


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
	else if(istype(baited, /obj/item/natural/worms))
		var/list/worm_fishloot = baited.vars["fishloot"]
		if(worm_fishloot)
			fishpicker = pickweightmerge(fishpicker, worm_fishloot)
	else if(istype(baited, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = baited
		var/list/snack_fishloot = S.vars["fishloot"]
		if(snack_fishloot)
			fishpicker = pickweightmerge(fishpicker, snack_fishloot)
		if(S.sizemod)
			sizepicker = pickweightmerge(sizepicker, S.sizemod)
		if(S.raritymod)
			raritypicker = pickweightmerge(raritypicker, S.raritymod)

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
			var/luckrarity = list("com" = -1, "rare" = 1)
			while(luckboost > 0)
				raritypicker = pickweightmerge(raritypicker, luckrarity)
				luckboost--

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

			fishsize = pickweightAllowZero(sizepicker)
			fishrarity = pickweightAllowZero(raritypicker)
			fishtype = pickweightAllowZero(fishpicker)

			difficulty += sizepicker.Find(fishsize) + raritypicker.Find(fishrarity) - 1
			hookwindow -= raritypicker.Find(fishrarity) - 1
			acceleration += clamp(sizepicker.Find(fishsize) - 3, 0, 2) + clamp(raritypicker.Find(fishrarity) - 1, 0, 3)
			maxvelocity = 3 + clamp(raritypicker.Find(fishrarity) - 1, 0, 3) + clamp(sizepicker.Find(fishsize) - 3, -1, 2)
			fishhealth =  9 + sizepicker.Find(fishsize)*6 + raritypicker.Find(fishrarity)*6
			switch(fishsize)
				if("tiny")
					costmod *= 0.5
				if("small")
					costmod *= 0.75
				if("large")
					costmod *= 1.5
				if("prize")
					costmod *= 3
			switch(fishrarity)
				if("rare")
					costmod *= 2
				if("ultra")
					costmod *= 4
				if("gold")
					costmod *= 10

	difficulty = clamp(difficulty, 1, 6)
	hookwindow = clamp(hookwindow, 1 SECONDS, 4 SECONDS)
	acceleration = max(acceleration, 1)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing) // User's skill level
	var/ft = 120 //Time to get a catch, in ticks
	var/fpp =  100 - (40 + (sl * 10)) // Fishing power penalty based on fishing skill level
	var/caught = FALSE
	var/list/modlist
	if(user.used_intent.type == SPEAR_BASH)
		return ..()

	if(!check_allowed_items(target,target_self=1))
		return ..()

	if(user.used_intent.type != ROD_CAST)
		if(user.used_intent.type == ROD_AUTO && !user.doing)
			if(target in range(user,5))
				user.visible_message("<span class='warning'>[user] casts a line!</span>", \
									"<span class='notice'>I cast a line.</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 1 SECONDS) //every skill lvl is -1 seconds
				ft = max(20,ft) //min of 2 seconds
				if(do_after(user,ft, target = target))
					if(baited)
						var/bp = baited.baitpenalty // Penalty to fishing chance based on how good bait is. Lower is better.
						var/fishchance = 100 // Total fishing chance, deductions applied below
						fishchance -= (difficulty * 15) ///based on the fishes difficulty means better fishing rods can be given to shit fishers
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
						var/mob/living/carbon/human/fisherman = user
						modlist = baited.fishingMods.Copy()
						if(prob(fishchance)) // Finally, roll the dice to see if we fish.
							var/A = getfishingloot(user, modlist, target)
							if(A)
								var/ow = 30 + (sl * 10) // Opportunity window, in ticks. Longer means you get more time to cancel your bait
								to_chat(user, "<span class='notice'>Something tugs the line!</span>")
								target.balloon_alert_to_viewers("Tug!")
								playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
								if(!do_after(user,ow, target = target, same_direction = TRUE))
									if(A in subtypesof(/mob/living))
										var/mob/M = A
										new M(target)
										if (!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
											user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
										user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2) // High risk high reward
									else
										new A(user.loc)
										to_chat(user, "<span class='warning'>Reel 'em in!</span>")
										teleport_to_dream(user, 10000, 1)
										user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE) // Level up!
										record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
										record_round_statistic(STATS_FISH_CAUGHT)
										playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
									if(getbaitlife(sl, baited)) // Higher skill levels make you less likely to lose your bait
										to_chat(user, "<span class='warning'>Damn, it ate my bait.</span>")
										qdel(baited)
										baited = null
								else
									to_chat(user, "<span class='warning'>Damn, it got away... I should <b>pull away</b> next time.</span>")
									if(getbaitlife(sl, baited, 100)) // Higher chance for it to flee with your bait.
										to_chat(user, "<span class='warning'>...And took my bait, too.</span>")
										qdel(baited)
										baited = null
						else
							to_chat(user, "<span class='warning'>Not even a nibble...</span>")
							user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2) // Pity XP.
					else
						to_chat(user, "<span class='warning'>This seems pointless without bait.</span>")
				else
					to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()
	else
		//the actual game
		currentlyfishing = TRUE
		currentstate = "wait"
		var/waittime = rand(30, 50) - skillmod*2
		var/lastmouse = 0
		var/currentmouse = 0
		var/targetdif = 0
		var/velocity
		var/initialwait = waittime
		var/initialline = linehealth //these last two are for the face
		var/initialfish = fishhealth
		var/facestate = 1
		createui(fisher)
		fisher.doing = TRUE
		fishtarget = 90

		while(currentlyfishing)
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
						if(line.bobber)
							to_chat(fisher, "<span class = 'notice'>The [line.name] dips in the water!</span>")
							playsound(loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
						if(abs(currentmouse - lastmouse) > 1 && waittime / initialwait < 0.5)
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
					if(currentmouse > 180)
						fishhealth -= round(abs(currentmouse - 180)/90, 0.1)

					if(fishhealth <= 0)
						caught = TRUE
						currentlyfishing = FALSE
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
					velocity = clamp(velocity + ((acceleration*directionstate)/5), -maxvelocity, maxvelocity)
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

			lastmouse = currentmouse
			sleep(1)

	if(!caught)
		to_chat(user, "<span class = 'warning'>Damn, got away...</span>")
	else
		to_chat(user, "<span class = 'notice'>I pull something out of the water!</span>")
		playsound(loc, 'sound/items/Fish_out.ogg', 100, TRUE)
		fisher.adjust_experience(/datum/skill/labor/fishing, clamp(difficulty, 1, 3) * fisher.STAINT)
		if(ispath(fishtype, /obj/item/reagent_containers/food/snacks/fish))
			var/obj/item/reagent_containers/food/snacks/caughtfish = new fishtype(get_turf(fisher))
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
					caughtfish.icon_state = "[caughtfish.icon_state][fishrarity]"
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
					switch(fishsize)
						if("tiny")
							caughtfish.sizemod = list("tiny" = -999)//fish can't swallow a fish of the same size
						if("small")
							caughtfish.sizemod = list("tiny" = -999, "small" = -999)
						if("large")
							caughtfish.slices_num = 2
							caughtfish.vars["fishloot"] = null//can't use fish larger than normal size as bait
						if("prize")
							caughtfish.slices_num = 3
							caughtfish.vars["fishloot"] = null
						else
							caughtfish.vars["fishloot"] = null
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
				var/atom/caughtthing2 = new fishtype(fisher.loc)
				if(specialcatching)
					var/obj/item/fishing/bait/specialmaker = baited
					specialmaker.makespecial(caughtthing2)

	fisher.doing = FALSE
	stopgame(fisher)
	qdel(baited)
	baited = null
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
