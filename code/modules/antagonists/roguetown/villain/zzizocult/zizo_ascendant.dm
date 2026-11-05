//most of this is taken from TG heretic's star gazer
/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant
	name = "ASCENDANT"
	desc = "THE FIFTH."
	icon = 'icons/mob/zizo_gazer.dmi'
	icon_state = "star_gazer"
	icon_living = "star_gazer"
	pixel_x = -32
	faction = list("zizo_cult")
	mob_biotypes = MOB_ORGANIC|MOB_EPIC
	health = 10000
	maxHealth = 10000
	obj_damage = 400
	melee_damage_lower = 80
	melee_damage_upper = 120
	environment_smash = ENVIRONMENT_SMASH_WALLS|ENVIRONMENT_SMASH_RWALLS
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	food_type = list()
	pooptype = null

/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant/Initialize(mapload)
	. = ..()
	set_light(4, 1, 1, l_color = "#ff4040")
	for(var/spell in list(/datum/action/cooldown/spell/zizo_dominion, /datum/action/cooldown/spell/zizo_beam, /datum/action/cooldown/spell/projectile/zizo_orb))
		var/datum/action/cooldown/spell/S = new spell(src)
		S.Grant(src)

/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.overlay_fullscreen("cult", /atom/movable/screen/fullscreen/druqks)
	H.add_stress(/datum/stressevent/saw_wonder/cult)
	H.emote("scream")
	H.Paralyze(2 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(clear_cult_fullscreen), H), 2 SECONDS)

/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant/Life()
	. = ..()
	adjustBruteLoss(-20)

/mob/living/simple_animal/hostile/retaliate/rogue/zizo_ascendant/death(gibbed)
	visible_message(span_userdanger("THE NEWLY FORMED GOD DIES IN ITS CRADLE!"))
	. = ..()
	qdel(src)

/proc/zizo_convert_turf(turf/T)
	for(var/obj/structure/mineral_door/D in T)
		if(!istype(D, /obj/structure/mineral_door/wood/donjon/stone/cult))
			qdel(D)
			new /obj/structure/mineral_door/wood/donjon/stone/cult(T)
			new /obj/effect/temp_visual/cult/door(T)
	if(isclosedturf(T) && !istype(T, /turf/closed/indestructible) && !istype(T, /turf/closed/wall/mineral/rogue/stone/space))
		T.ChangeTurf(/turf/closed/wall/mineral/rogue/stone/space, flags = CHANGETURF_IGNORE_AIR)
		new /obj/effect/temp_visual/cult/turf(T)
	else if(isopenturf(T) && !istype(T, /turf/open/floor/rogue/underworld/space/quiet/cult))
		T.ChangeTurf(/turf/open/floor/rogue/underworld/space/quiet/cult, flags = CHANGETURF_IGNORE_AIR)
		new /obj/effect/temp_visual/cult/turf/floor(T)

/datum/action/cooldown/spell/zizo_dominion
	name = "Dominion"
	desc = "Expand your domain!"
	button_icon = 'icons/effects/cult_effects.dmi'
	button_icon_state = "wallglow"
	sound = 'sound/magic/cosmic_expansion.ogg'
	click_to_activate = FALSE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	cooldown_time = 15 SECONDS

/datum/action/cooldown/spell/zizo_dominion/cast(atom/cast_on)
	. = ..()
	var/turf/center = get_turf(owner)
	var/obj/effect/temp_visual/zizo_ring/ring = new(center)
	ring.pixel_y = 32
	spread(center)

/datum/action/cooldown/spell/zizo_dominion/proc/spread(turf/center)
	set waitfor = FALSE
	for(var/i in 0 to 7)
		for(var/turf/T in range(i, center))
			if(get_dist(T, center) == i)
				zizo_convert_turf(T)
		sleep(3)

/datum/action/cooldown/spell/projectile/zizo_orb
	name = "Orb"
	desc = "Shoot it at people to kill them."
	button_icon = 'icons/effects/zizo_star_ball.dmi'
	button_icon_state = "star_ball"
	sound = 'sound/magic/cosmic_energy.ogg'
	projectile_type = /obj/projectile/magic/zizo_orb
	cast_range = SPELL_RANGE_PROJECTILE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	cooldown_time = 8 SECONDS

/obj/projectile/magic/zizo_orb
	name = "dark star"
	icon = 'icons/effects/zizo_star_ball.dmi'
	icon_state = "star_ball"
	color = "#ff4040"
	damage = 0
	nodamage = TRUE
	speed = MAGE_PROJ_FAST
	range = 14
	light_color = "#ff4040"
	light_outer_range = 3

/obj/projectile/magic/zizo_orb/on_hit(target)
	. = ..()
	detonate()

/obj/projectile/magic/zizo_orb/on_range()
	detonate()

/obj/projectile/magic/zizo_orb/proc/detonate()
	var/turf/T = get_turf(src)
	if(T)
		new /obj/effect/temp_visual/zizo_ring(T)
		playsound(T, 'sound/magic/cosmic_expansion.ogg', 80, TRUE)
		for(var/mob/living/L in range(2, T))
			if(L == firer || is_zizo(L))
				continue
			L.apply_damage(200, BURN)
			L.Knockdown(40)
		for(var/turf/C in range(2, T))
			zizo_convert_turf(C)
	qdel(src)

/datum/action/cooldown/spell/zizo_beam
	name = "Beam"
	desc = "IT'S ALL FUCKING OVER."
	button_icon = 'icons/effects/beam.dmi'
	button_icon_state = "gazer_beam"
	click_to_activate = FALSE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	cooldown_time = 30 SECONDS
	var/list/turf/targets
	var/damage_timer
	var/open_timer
	var/fire_timer
	var/cycle_tracker = 0
	var/obj/effect/abstract/gazer_orb/orb_visual
	var/obj/effect/abstract/gazer_beam/beam_visual
	var/obj/effect/abstract/gazer_beamend/end_visual
	var/list/beam_fillings
	var/datum/looping_sound/gazer_beam/sound_loop

/datum/action/cooldown/spell/zizo_beam/New(Target)
	. = ..()
	sound_loop = new

/datum/action/cooldown/spell/zizo_beam/Destroy()
	stop_beaming()
	QDEL_NULL(sound_loop)
	return ..()

/datum/action/cooldown/spell/zizo_beam/cast(atom/cast_on)
	. = ..()
	if(damage_timer || open_timer || fire_timer)
		stop_beaming()
	var/turf/check_turf = get_step(owner, owner.dir)
	var/list/turf/targets_left = list()
	var/list/turf/targets_right = list()
	targets = list()
	while(check_turf && length(targets) < 20)
		targets += check_turf
		targets_left += get_step(check_turf, turn(owner.dir, 90))
		targets_right += get_step(check_turf, turn(owner.dir, -90))
		check_turf = get_step(check_turf, owner.dir)
	if(length(targets) < 20)
		targets = null
		return
	targets += targets_left
	targets += targets_right
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE), PROC_REF(stop_beaming))
	beam_fillings = list()
	cycle_tracker = 0
	orb_visual = new(get_step(owner, owner.dir))
	playsound(owner, 'sound/magic/stargazer/beam_open.ogg', 50, FALSE)
	open_timer = addtimer(CALLBACK(src, PROC_REF(open_laser)), 2.2 SECONDS, TIMER_STOPPABLE)
	fire_timer = addtimer(CALLBACK(src, PROC_REF(fire_laser)), 3 SECONDS, TIMER_STOPPABLE)

/datum/action/cooldown/spell/zizo_beam/proc/open_laser()
	var/turf/far = targets[20]
	beam_visual = new(get_step(get_step(owner, owner.dir), owner.dir), far)
	end_visual = new(far, owner)
	for(var/turf/to_fill as anything in getline(targets[4], targets[18]))
		beam_fillings += new /obj/effect/abstract/gazer_beam_filling(to_fill, owner.dir)

/datum/action/cooldown/spell/zizo_beam/proc/fire_laser()
	if(!beam_visual || !end_visual)
		stop_beaming()
		return
	sound_loop.start(owner)
	QDEL_NULL(orb_visual)
	beam_visual.icon_state = "gazer_beam_active"
	end_visual.icon_state = "gazer_beam_end"
	process_beam()

/datum/action/cooldown/spell/zizo_beam/proc/process_beam()
	if(cycle_tracker > 33)
		stop_beaming()
		return
	for(var/obj/effect/abstract/gazer_beam_filling/filling as anything in beam_fillings)
		if(prob(2))
			filling.pull_victims(owner)
	for(var/turf/target as anything in targets)
		if(istype(target, /turf/closed/wall))
			var/turf/closed/wall/wall_target = target
			wall_target.dismantle_wall(devastated = TRUE)
			continue
		for(var/atom/movable/victim in target)
			if(isobj(victim))
				var/obj/to_obliterate = victim
				if(!(to_obliterate.resistance_flags & INDESTRUCTIBLE) && !istype(to_obliterate, /obj/structure/fuge) && !istype(to_obliterate, /obj/structure/pylon))
					qdel(to_obliterate)
			else if(isliving(victim))
				var/mob/living/living_victim = victim
				if(living_victim == owner || is_zizo(living_victim))
					continue
				if(living_victim.stat > CONSCIOUS)
					playsound(living_victim, 'sound/magic/cosmic_expansion.ogg', 80, TRUE)
					living_victim.visible_message(span_danger("THE BEAM EVISCERATES [uppertext(living_victim.name)] TO A PILE OF ASH!"), span_userdanger("THE BEAM STRIPS YOUR FLESH TO DUST! YOU ARE GONE!"))
					living_victim.dust()
					continue
				living_victim.emote("scream")
				living_victim.apply_damage(40, BURN)
	cycle_tracker++
	damage_timer = addtimer(CALLBACK(src, PROC_REF(process_beam)), 0.3 SECONDS, TIMER_STOPPABLE)

/datum/action/cooldown/spell/zizo_beam/proc/stop_beaming()
	SIGNAL_HANDLER
	if(targets && cycle_tracker <= 33)
		to_chat(owner, span_warning("DON'T MOVE!"))
	sound_loop.stop()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE))
	deltimer(open_timer)
	deltimer(fire_timer)
	deltimer(damage_timer)
	open_timer = null
	fire_timer = null
	damage_timer = null
	QDEL_NULL(orb_visual)
	QDEL_NULL(beam_visual)
	QDEL_NULL(end_visual)
	QDEL_LIST(beam_fillings)
	targets = null

/obj/effect/abstract/gazer_orb
	icon = 'icons/effects/zizo_gazer_orb.dmi'
	icon_state = "gazer_beam_charge"
	pixel_x = -64
	pixel_y = -64

/obj/effect/abstract/gazer_beam
	icon = 'icons/effects/beam96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/abstract/gazer_beam/Initialize(mapload, turf/target)
	. = ..()
	if(!target)
		return INITIALIZE_HINT_QDEL
	var/Angle = round(get_angle_raw(x, y, pixel_x, pixel_y, target.x, target.y, target.pixel_x, target.pixel_y), 45)
	var/matrix/transform_matrix = matrix()
	transform_matrix.Turn(Angle - 90)
	transform_matrix.Scale(2, 2)
	transform = transform_matrix
	flick("gazer_beam_start", src)

/obj/effect/abstract/gazer_beam_filling
	icon = 'icons/effects/beam.dmi'
	icon_state = "gazer_beam"

/obj/effect/abstract/gazer_beam_filling/Initialize(mapload, direction)
	. = ..()
	if(!direction)
		return INITIALIZE_HINT_QDEL
	var/matrix/transform_matrix = matrix()
	transform_matrix.Turn(dir2angle(direction))
	transform_matrix.Scale(2, 2)
	transform = transform_matrix
	flick("gazer_beam_end_opening", src)

/obj/effect/abstract/gazer_beam_filling/proc/pull_victims(mob/caster)
	for(var/atom/movable/movable_atom in orange(5, src))
		if(movable_atom != caster && !movable_atom.anchored && movable_atom.move_resist < MOVE_FORCE_EXTREMELY_STRONG)
			step_towards(movable_atom, src)

/obj/effect/abstract/gazer_beamend
	icon = 'icons/effects/beam.dmi'

/obj/effect/abstract/gazer_beamend/Initialize(mapload, atom/origin)
	. = ..()
	if(!origin)
		return INITIALIZE_HINT_QDEL
	var/Angle = round(get_angle_raw(origin.x, origin.y, origin.pixel_x, origin.pixel_y, x, y, pixel_x, pixel_y), 45)
	var/matrix/transform_matrix = matrix()
	transform_matrix.Turn(Angle)
	transform_matrix.Scale(2, 2)
	transform = transform_matrix
	flick("gazer_beam_end_opening", src)

/datum/looping_sound/gazer_beam
	mid_sounds = list('sound/magic/stargazer/beam_loop_one.ogg')
	mid_length = 109
	volume = 80
