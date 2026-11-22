#define SEAL_MODE_LAY 1
#define SEAL_MODE_HOLD 2
#define SEAL_MODE_AURA 3
#define SEAL_DURATION (15 SECONDS)

// based off verglas
/datum/action/cooldown/spell/silence_field
	name = "Seal of Syon"
	desc = "Lay a 7x7 field of silence; anyone who steps onto it will become mute. \
	Use the Alt Mode keybind to switch between Lay (cast and forget), Hold (maintained by concentration for as long as you like, but shattered the instant you are struck or cast another spell), or Aura (as Hold, but a smaller area around you, which follows you so long as you do not lose concentration.)."
	button_icon_state = "silence"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CRYOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Gelu Silentium!")
	invocation_type = INVOCATION_WHISPER
	ignore_can_speak = TRUE

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/seal_mode = SEAL_MODE_LAY
	var/labels = list("LAY", "HOLD", "AURA")

/datum/action/cooldown/spell/silence_field/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/silence_field/toggle_alt_mode(mob/user)
	seal_mode = (seal_mode % SEAL_MODE_AURA) + 1
	update_mode_maptext()
	return TRUE

/datum/action/cooldown/spell/silence_field/proc/update_mode_maptext()
	var/label_color = GLOW_COLOR_ICE
	if(seal_mode != SEAL_MODE_LAY)
		label_color = "#ff6a3d"
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(labels[seal_mode])
		holder.maptext_x = 5
		holder.color = label_color

/datum/action/cooldown/spell/silence_field/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(seal_mode != SEAL_MODE_LAY && H.has_status_effect(/datum/status_effect/seal_concentration))
		H.remove_status_effect(/datum/status_effect/seal_concentration)
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	var/radius = 3
	var/mob/follow
	if(seal_mode == SEAL_MODE_AURA)
		centerpoint = get_turf(H)
		radius = 2
		follow = H
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	var/lifespan = 0
	if(seal_mode == SEAL_MODE_LAY)
		lifespan = SEAL_DURATION
	var/obj/effect/seal_field/field = new(centerpoint, radius, lifespan, follow)
	if(seal_mode != SEAL_MODE_LAY)
		H.apply_status_effect(/datum/status_effect/seal_concentration, field)
	return TRUE

/obj/effect/seal_field
	name = "silence"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/radius = 3
	var/mob/follow
	var/list/muted = list()
	var/list/tiles = list()

/obj/effect/seal_field/Initialize(mapload, _radius, lifespan = 0, mob/_follow)
	. = ..()
	radius = _radius
	follow = _follow
	build_tiles()
	START_PROCESSING(SSobj, src)
	if(lifespan)
		QDEL_IN(src, lifespan)

/obj/effect/seal_field/proc/build_tiles()
	QDEL_LIST(tiles)
	for(var/turf/T in range(radius, src))
		if(!T.density)
			tiles += new /obj/effect/seal_tile(T)

/obj/effect/seal_field/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/L in muted)
		REMOVE_TRAIT(L, TRAIT_MUTE, "seal")
	QDEL_LIST(tiles)
	muted = null
	follow = null
	return ..()

/obj/effect/seal_tile
	icon = 'icons/effects/effects.dmi'
	icon_state = "sleep"
	color = "#6fb7ff"
	alpha = 150
	layer = FLY_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/seal_field/process()
	if(follow && get_turf(follow) != loc)
		forceMove(get_turf(follow))
		build_tiles()
	for(var/mob/living/L in muted)
		if(get_dist(L, src) > radius || L.z != z)
			REMOVE_TRAIT(L, TRAIT_MUTE, "seal")
			muted -= L
	for(var/mob/living/L in range(radius, src))
		if(L in muted)
			continue
		muted += L
		ADD_TRAIT(L, TRAIT_MUTE, "seal")
		to_chat(L, span_warning("The wind in my voice goes still. I can't speak!"))

/datum/status_effect/seal_concentration
	id = "seal_concentration"
	duration = -1
	alert_type = null
	var/obj/effect/seal_field/field

/datum/status_effect/seal_concentration/on_creation(mob/living/new_owner, obj/effect/seal_field/new_field)
	field = new_field
	. = ..()

/datum/status_effect/seal_concentration/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_struck))
	RegisterSignal(owner, COMSIG_MOB_CAST_SPELL, PROC_REF(on_cast))
	owner.balloon_alert_to_viewers("<font color='#ff6a3d'>concentrating - fragile!</font>")

/datum/status_effect/seal_concentration/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_MOB_CAST_SPELL)
	QDEL_NULL(field)
	to_chat(owner, span_warning("My concentration breaks and the field shatters!"))

/datum/status_effect/seal_concentration/proc/on_struck(mob/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!damage)
		return
	owner.remove_status_effect(/datum/status_effect/seal_concentration)

/datum/status_effect/seal_concentration/proc/on_cast(mob/source, datum/action/cooldown/spell/spell, atom/cast_on)
	SIGNAL_HANDLER
	if(istype(spell, /datum/action/cooldown/spell/silence_field))
		return
	owner.remove_status_effect(/datum/status_effect/seal_concentration)

#undef SEAL_MODE_LAY
#undef SEAL_MODE_HOLD
#undef SEAL_MODE_AURA
#undef SEAL_DURATION
