/datum/action/cooldown/spell/phantom_ear
	name = "Summon Phantom Ear"
	desc = "Creates a magical ear to listen in on distant sounds."
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	sound = 'sound/magic/buffrollaccent.ogg'
	button_icon_state = "phantomear"

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Lend me thine ear.")
	invocation_type = "whisper"

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/datum/weakref/current_ear

/datum/action/cooldown/spell/phantom_ear/Destroy(force)
	QDEL_NULL(current_ear)
	return ..()

/datum/action/cooldown/spell/phantom_ear/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/obj/item/phantom_ear/current = current_ear?.resolve()
	if(current && !QDELETED(current))
		to_chat(user, span_notice("You close one ear to open another."))
		qdel(current)
	else
		to_chat(user, span_notice("You've conjured a phantom ear. You can hear through it as if you were there. Speak \"deafen\" to close this ear to the world, and \"listen\" to re-open it."))

	var/obj/item/phantom_ear/summoned_object = new /obj/item/phantom_ear(user.drop_location())
	summoned_object.AddComponent(/datum/component/conjured_item, GLOW_COLOR_METAL, TRUE, user, src)
	summoned_object.setup(user)
	if(!user.put_in_hands(summoned_object))
		qdel(summoned_object)
		to_chat(user, span_warning("I need a free hand to conjure the phantom ear!"))
		return FALSE
	current_ear = WEAKREF(summoned_object)
	return TRUE
