/obj/effect/proc_holder/spell/self/lessershift
	name = "Lesser Shapeshift"
	desc = "Shift into a lesser beast form."
	overlay_state = "tamebeast"
	releasedrain = 50
	chargedrain = 1
	chargetime = 5
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = TRUE
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3
	miracle = FALSE

	invocations = list("Mutare Formam.") // Change Form 
	invocation_type = "whisper" //can be none, whisper, emote and shout

	var/list/possible_shapes = list(
		/mob/living/carbon/human/species/lessershift/volf,
		/mob/living/carbon/human/species/lessershift/fox,
		/mob/living/carbon/human/species/lessershift/cat,
		/mob/living/carbon/human/species/lessershift/cabbit,
		/mob/living/carbon/human/species/lessershift/saiga,
		/mob/living/carbon/human/species/lessershift/spider
	)

/obj/effect/proc_holder/spell/self/lessershift/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()
	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("Your will is too broken to change form."))
		return FALSE

	if(istype(user, /mob/living/carbon/human/species/lessershift))
		user.lessershift_untransform()
		return FALSE

	var/list/choices = list()

	for(var/mob/living/carbon/human/species/lessershift/shape as anything in possible_shapes)
		var/icon/icon = icon(shape.lessershift_icon, shape.lessershift_icon_state)

		var/size_x = icon.Width()
		var/size_y = icon.Height()

		var/image/icon_img = image(icon)

		icon_img.pixel_x = -(size_x / 2) + 16
		icon_img.pixel_y = -(size_y / 2) + 16
		
		choices[shape.name] = icon_img

	var/new_lessershift_type = show_radial_menu(user, user, choices)

	if(!new_lessershift_type || !arcane_speech_allowed(user, TRUE))
		if(!QDELETED(user))
			revert_cast(user)
		return FALSE

	user.Stun(30)
	user.Knockdown(30)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon/human, lessershift_transformation), GLOB.wildshapes[new_lessershift_type])

	return TRUE
// Mob itself
/mob/living/carbon/human/species/lessershift
	var/datum/language_holder/stored_language
	var/list/stored_skills
	var/list/stored_experience
	var/list/stored_spells
	var/lessershift_icon
	var/lessershift_icon_state

/mob/living/carbon/human/species/lessershift/proc/gain_inherent_skills()
	if(mind)
		adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		var/datum/devotion/D = devotion
		if(!D)
			D = new /datum/devotion(src, patron)

		D.suppress_grants = TRUE

		if(!(/mob/living/carbon/human/proc/devotionreport in verbs))
			verbs += /mob/living/carbon/human/proc/devotionreport
		if(!(/mob/living/carbon/human/proc/clericpray in verbs))
			verbs += /mob/living/carbon/human/proc/clericpray	

/mob/living/carbon/human/species/lessershift/update_inv_gloves() //Prevents weird blood overlays
	remove_overlay(GLOVES_LAYER)
	remove_overlay(GLOVESLEEVE_LAYER)

/mob/living/carbon/human/species/lessershift/update_inv_shoes() //Prevents weird blood overlays
	remove_overlay(SHOES_LAYER)
	remove_overlay(SHOESLEEVE_LAYER)

/mob/living/carbon/human/species/lessershift/update_inv_neck() //Prevents neck slot sprite overlays in wildshape
	remove_overlay(NECK_LAYER)
