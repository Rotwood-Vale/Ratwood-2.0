//Drow Screaming Bell (screaming_bell) - Sort of weaker Inquisition crankbox. Everyone but drows and the undead receive a slight stat penalty and a significant mood down when it's rung.
/obj/item/renegade_relics/screaming_bell
	name = "drow screaming bell"
	desc = "A magical bell crafted by a particularly wicked drow matriarch. It's particularly difficult to ring. \
	The Otavan Inquisition once conducted quite extensive research into the bell and its arcyne mechanism of work."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "screamingbell"
	hitsound = 'sound/blank.ogg'
	var/last_use_time = -6001 // So that it's ready for use right after spawn.
	var/use_cooldown = 6000 // 10 minutes or 600 seconds

/obj/item/renegade_relics/screaming_bell/attack_self(mob/living/user)
	. = ..()
	if(!(HAS_TRAIT(usr, TRAIT_PSYDONITE) || isdarkelf(user)))
		to_chat(user, (span_suicide("My hand freezes still as I raise the bell. I can't do it.")))
		return FALSE
	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("The souls are exhausted. I should wait a bit."))
		return FALSE
	else
		var/songhearers = view(7, user)
		for(var/mob/living/carbon/human/target in songhearers)
			to_chat(target,span_cultsmall("[user] slowly raises the sinister-looking bell..."))
		if(do_after(user, 50, src))
			src.last_use_time = world.time
			playsound(src, 'sound/misc/bell_evil.ogg', 100, TRUE)
			for (var/mob/living/carbon/human/H in hearers(7, user))
				to_chat(H, span_cult("[user] rings the bell!"))
				if (!H.client)
					continue
				if (!(H.has_stress_event(/datum/stressevent/drowbell) || isdarkelf(H)))
					H.add_stress(/datum/stressevent/drowbell)
				if(!(H.has_status_effect(/datum/status_effect/buff/drowbell) || isdarkelf(H)))
					H.apply_status_effect(/datum/status_effect/buff/drowbell)

//Cerulean Tear (life_crystal) - Summmons a player-controlled quasi-undead minion for the Renegade Inquisitor. Only one warrior may be active at any given moment.
/obj/item/renegade_relics/life_crystal
	name = "cerulean tear"
	desc = "A magical droplet containing lux, dreams, hopes and suffering of countless people who lived in the era when PSYDON was still reigning over HIS children. \
	Once crushed, it releases enough arcyne energy and gavvah to bring an ancient Psydonic warrior back to life."
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "life_crystal"
	hitsound = 'sound/blank.ogg'
	dropshrink = 0.6
	var/last_use_time = 0
	var/use_cooldown = 300 // 30 seconds
	var/list/active_wights = list() //List of active wights stored here.
	var/max_summons = 1 //Maximum amount of wights that can be summoned at one time.
	var/max_charges = 1 //Maximum amount of charges the tear can hold.
	var/current_charges = 1
	grid_height = 32
	grid_width = 32

/obj/item/renegade_relics/life_crystal/examine(mob/user)
	. = ..()
	if(current_charges > 0)
		. += span_notice("The tear shines with cerulean light, quiet whispers can be heard.")
	else
		. += span_danger("The tear is silent, the dreams it once contained are now one with oblivion. I can use lux to reinvigorate it.")

/obj/item/renegade_relics/life_crystal/Initialize(mapload)
	..()
	set_light(2, 2, 1, l_color = "#0D7BD7")

/obj/item/renegade_relics/life_crystal/proc/recharge(obj/item/reagent_containers/lux/L, mob/user)
	if(current_charges >= max_charges)
		to_chat(user, span_notice("The tear is already brimming with dreams and suffering."))
		return FALSE

	qdel(L) // consume the lux
	current_charges = min(current_charges + 1, max_charges)
	to_chat(user, span_notice("The tear emits a heartbeat-like noise as it absorbs somebody's hopes."))
	playsound(src, 'sound/magic/heartbeat.ogg', 100, TRUE)
	return TRUE

/obj/item/renegade_relics/life_crystal/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		return recharge(I, user)
	return ..()

/obj/item/renegade_relics/life_crystal/attack_self(mob/living/user)
	..()
	if(!user)
		return FALSE

	if(length(active_wights) >= max_summons)
		to_chat(user, span_warning("The tear lets out a quiet whimper. The power within is currently too strained to bring back another immortal."))
		return FALSE

	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("The tear hums under your touch, but remains inert. I should wait a bit."))
		return FALSE

	if(current_charges <= 0)
		to_chat(user, span_warning("The tear is silent. It hungers for lux."))
		return FALSE

	// Ask the Renegade for a task for the wight BEFORE the timer
	var/tasks = list("TOIL","FIGHT","GUARD","SEEK")
	var/tasks_choice = input(user, "WHAT IS THY BIDDING?", "IN HIS NAME") as anything in tasks
	if(!tasks_choice)
		to_chat(user, span_warning("You must assign a task for your immortal!"))
		return FALSE

	src.last_use_time = world.time

	if(!do_after(user, 60, src))
		to_chat(user, span_warning("You lose your concentration."))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_PSYDONITE))
		to_chat(user, span_warning("The tear doesn't respond to your touch. You lack faith."))
		user.flash_fullscreen("redflash1")
		return FALSE

	var/turf/T = get_step(user, user.dir)
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	var/necro_name = user.real_name ? user.real_name : user.name
	var/list/candidates = pollGhostCandidates("Many words once left unspoken fill the air, bleeding through the fabric of reality into PARADYSE. Return to the mortal realm and serve [necro_name] in new life as a Psydonic Wight? YOU WILL [tasks_choice]", ROLE_NECRO_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_NECROMANCER_SKELETON)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("No one is strong enough. I should try again later."))
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		return FALSE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/wight/summoned/target = new /mob/living/carbon/human/species/wight/summoned(T)
	target.crystal = WEAKREF(src)
	target.key = C.key
	current_charges--
	target.visible_message(span_warning("[target]'s eyes light up with a faint glow."))
	var/datum/weakref/W = WEAKREF(target)
	active_wights += W

	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "PSYDONIC WIGHT"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)


	if(current_charges <= 0)
		to_chat(user, span_notice("The tear dims, its power spent."))
	else
		to_chat(user, span_notice("The tear's glow lessens. [current_charges] use\s remain."))

	user.flash_fullscreen("redflash1")
	playsound(src, "shatter", 50, TRUE)

	return TRUE

//Infinite Brace of Pistols (magical_pistols) - UNLIMITED GUN WORKS. Lets the wearer conjure weak pistols. Only one pistol may exist at any given moment. The only relic that the Renegade gets for free.
/obj/item/storage/belt/rogue/leather/magical_pistols
	name = "infinite brace of pistols"
	desc = "A magical brace that conjures arcyne pistols on demand, albeit only one may exist at a time. The pistol fire concentrated magical energy, which is weaker than real lead."
	icon_state = "magical_pistols"
	item_state = "magical_pistols"
	strip_delay = 30
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt // 1x3 space
	var/last_use_time = 0
	var/use_cooldown = 300 // 15 seconds, since it's a bit stronger but much slower arcyne bolt (4s CD).
	var/obj/item/rogueweapon/conjured_gun = null

/obj/item/storage/belt/rogue/leather/magical_pistols/attack_right(mob/user)
	if(world.time - src.last_use_time < src.use_cooldown)
		to_chat(user, span_warning("The belt isn't ready to conjure another pistol!"))
		return FALSE
	else
		src.last_use_time = world.time
		if(src.conjured_gun)
			qdel(src.conjured_gun)
		var/obj/item/rogueweapon/R = new /obj/item/gun/ballistic/firearm/arquebus_pistol/arcyne(user.drop_location())
		if(!QDELETED(R))
			R.AddComponent(/datum/component/conjured_item)
		user.put_in_hands(R)
		src.conjured_gun = R
		return TRUE