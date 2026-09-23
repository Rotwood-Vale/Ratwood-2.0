/obj/effect/proc_holder/spell/self/darkvision
	name = "Darkvision"
	desc = "Grants night vision in a limited radius."
	overlay_state = "darkvision"
	clothes_req = FALSE
	school = "transmutation"
	releasedrain = 0
	chargedrain = 0
	chargetime = 1 SECONDS
	no_early_release = TRUE
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	invocations = list("Nox Oculus")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 1
	xp_gain = TRUE
	cost = 2
	var/on = FALSE

/obj/effect/proc_holder/spell/self/darkvision/miracle
	cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/darkvision/cast(mob/living/carbon/human/user)
	var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
	if(!E)
		return FALSE
	on = !on
	if(on)
		E.lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		user.add_client_colour(/datum/client_colour/monochrome)
		user.overlay_fullscreen("darkvision_spell", /atom/movable/screen/fullscreen/curse)
	else
		E.lighting_alpha = initial(E.lighting_alpha)
		user.remove_client_colour(/datum/client_colour/monochrome)
		user.clear_fullscreen("darkvision_spell")
	user.update_sight()
	return TRUE

/obj/effect/proc_holder/spell/self/darkvision/invocation(mob/user = usr)
	if(on)
		..()

/obj/effect/proc_holder/spell/self/darkvision/Destroy()
	var/mob/living/carbon/human/user = action?.owner
	if(on && user)
		var/obj/item/organ/eyes/E = user.getorganslot(ORGAN_SLOT_EYES)
		if(E)
			E.lighting_alpha = initial(E.lighting_alpha)
		user.remove_client_colour(/datum/client_colour/monochrome)
		user.clear_fullscreen("darkvision_spell")
		user.update_sight()
	return ..()
