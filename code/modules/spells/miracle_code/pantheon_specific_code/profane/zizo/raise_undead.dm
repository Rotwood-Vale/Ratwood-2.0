//T2

/obj/effect/proc_holder/spell/invoked/raise_undead/miracle
	name = "Raise Undead"
	desc = "Invoke forbidden magicka to summon a mindless, shambling skeleton.\nMindless skeletons can be given orders to guard, patrol, and attack by their summoner.\nThese skeletons are weaker than their more complex-jointed counterparts, but are harder to incapacitate."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton"
	cast_range = 7
	sound = 'sound/magic/magnet.ogg'
	primary_resource_cost = 75
	primary_resource_type = SPELL_COST_DEVOTION
	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/holy
	cooldown_time = 30 SECONDS
	zizo_spell = TRUE
	invocations = list("Convoca spectres custodes!")
	invocation_type = INVOCATION_SHOUT
	var/spawn_lifespan

/obj/effect/proc_holder/spell/invoked/raise_undead/miracle/cast(atom/cast_on)
	. = ..()

	if(istype(get_area(owner), /area/rogue/indoors/ravoxarena))
		to_chat(owner, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		reset_spell_cooldown()
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T))
		to_chat(owner, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	new /obj/effect/temp_visual/gib_animation(T, "gibbed-h")
	var/mob/living/skeleton_new = new /mob/living/carbon/human/species/skeleton/npc/bogguard(T, owner)
	apply_mob_lifespan(skeleton_new, owner, spawn_lifespan)
	var/caster_name = owner.mind?.current?.real_name
	if(caster_name)
		addtimer(CALLBACK(src, PROC_REF(add_skeleton_faction), skeleton_new, caster_name), 1.1 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead/miracle/proc/add_skeleton_faction(mob/living/skeleton, caster_name)
	if(!QDELETED(skeleton))
		skeleton.faction |= list("cabal", "[caster_name]_faction")
