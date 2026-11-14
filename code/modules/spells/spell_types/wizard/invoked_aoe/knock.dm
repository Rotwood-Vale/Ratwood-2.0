// Spell is perma disabled, consider a Hearthstone / Vanderlin / Whatever port at some point
/obj/effect/proc_holder/spell/invoked/knock
	name = "Knock"
	desc = "Force open adjacent doors, windows and most containers."
	cost = 3
	xp_gain = TRUE
	school = "transmutation"
	releasedrain = SPELLCOST_ULTIMATE
	chargedrain = 0
	chargetime = 5 SECONDS
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	spell_tier = 4 // CM / Antag / Lich exclusive
	spell_impact_intensity = SPELL_IMPACT_NONE
	invocations = list("Pulso!")
	invocation_type = "shout"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	human_req = TRUE

/obj/effect/proc_holder/spell/invoked/knock/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/misc/chestopen.ogg', 100, TRUE, -1)
	for(var/turf/T in range(1, usr))
		for(var/obj/structure/mineral_door/door in T.contents)
			INVOKE_ASYNC(src, PROC_REF(open_door), door, user)
		for(var/obj/structure/closet/C in T.contents)
			INVOKE_ASYNC(src, PROC_REF(open_closet), C, user)
		for(var/obj/structure/roguewindow/openclose/W in T.contents)
			INVOKE_ASYNC(src, PROC_REF(open_window), W, user)

/obj/effect/proc_holder/spell/invoked/knock/proc/open_door(obj/structure/mineral_door/door, mob/user)
	if(istype(door))
		if(door.locked)
			door.add_forensic_action(user, "cast knock, unlocking it")
		door.force_open()
		door.locked = FALSE

/obj/effect/proc_holder/spell/invoked/knock/proc/open_closet(obj/structure/closet/C, mob/user)
	if(C.locked)
		C.add_forensic_action(user, "cast knock, unlocking it")
	C.locked = FALSE
	C.open()

/obj/effect/proc_holder/spell/invoked/knock/proc/open_window(obj/structure/roguewindow/openclose/W, mob/user)
	if(istype(W))
		if(!W.climbable && !W.brokenstate)
			W.add_forensic_action(user, "cast knock, opening it")
		W.force_open()
