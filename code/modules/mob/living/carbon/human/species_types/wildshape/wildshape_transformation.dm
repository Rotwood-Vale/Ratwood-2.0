/mob/living/carbon/human/species/wildshape/death(gibbed, nocutscene = FALSE)
	if(untransform_on_death)
		wildshape_untransform(TRUE, gibbed)
	else
		. = ..()

/mob/living/carbon/human/proc/wildshape_transformation(shapepath)
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)

	//before we shed our items, save our neck and ring, if we have any, so we can quickly rewear them
	var/obj/item/stored_neck = wear_neck
	var/obj/item/stored_ring = wear_ring

	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)

	var/mob/living/carbon/human/species/wildshape/W = new shapepath(loc) //We crate a new mob for the wildshaping player to inhabit

	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	W.job = job
	W.advjob = advjob
	W.migrant_type = migrant_type
	W.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
	if (W.dna.species?.gibs_on_shapeshift)
		playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		W.spawn_gibs(FALSE)

	playsound(W.loc, 'sound/body/shapeshift-start.ogg', 100, FALSE, 3)
	src.forceMove(W)

	// re-equip our stored neck and ring items, if we have them
	if (stored_ring)
		W.equip_to_slot_if_possible(stored_ring, SLOT_RING) // have to do this because we can wear psycrosses as rings even though we shouldn't be able to

	if (stored_neck)
		W.equip_to_slot_if_possible(stored_neck, SLOT_NECK)

	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.stored_spells = mind.spell_list.Copy()
	W.voice_color = voice_color
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name

	for(var/datum/wound/old_wound in W.get_wounds())
		var/obj/item/bodypart/bp = W.get_bodypart(old_wound.bodypart_owner.body_zone)
		bp?.remove_wound(old_wound.type)

	var/list/datum/wound/woundlist = get_wounds()
	if(woundlist.len)
		for(var/datum/wound/wound in woundlist)
			var/obj/item/bodypart/c_BP = get_bodypart(wound.bodypart_owner.body_zone)
			var/obj/item/bodypart/w_BP = W.get_bodypart(wound.bodypart_owner.body_zone)
			w_BP.add_wound(wound.type)
			c_BP.remove_wound(wound.type)

	W.adjustBruteLoss(getBruteLoss())
	W.adjustFireLoss(getFireLoss())
	W.adjustOxyLoss(getOxyLoss())
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	src.adjustBruteLoss(-src.getBruteLoss())
	src.adjustFireLoss(-src.getFireLoss())
	src.adjustOxyLoss(-src.getOxyLoss())

	W.set_blood_volume(blood_volume)
	W.bleed_rate = bleed_rate
	W.bleedsuppress = bleedsuppress

	bleed_rate = 0
	bleedsuppress = TRUE

	mind.transfer_to(W)
	var/datum/skill_holder/beast_skills = W.ensure_skills()
	beast_skills.known_skills = list()
	beast_skills.skill_experience = list()
	W.grant_language(/datum/language/beast)
	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	// Port sex organs from transformer to transformee. 
	var/obj/item/organ/penis/old_penis = getorganslot(ORGAN_SLOT_PENIS)
	if(old_penis)
		var/obj/item/organ/penis/new_penis = new old_penis.type()
		new_penis.penis_type = old_penis.penis_type
		new_penis.sheath_type = old_penis.sheath_type
		new_penis.penis_size = old_penis.penis_size
		new_penis.functional = old_penis.functional
		new_penis.branded_writing = old_penis.branded_writing
		new_penis.Insert(W, TRUE, FALSE)

	var/obj/item/organ/testicles/old_testicles = getorganslot(ORGAN_SLOT_TESTICLES)
	if(old_testicles)
		var/obj/item/organ/testicles/new_testicles = new old_testicles.type()
		new_testicles.ball_size = old_testicles.ball_size
		new_testicles.virility = old_testicles.virility
		new_testicles.branded_writing = old_testicles.branded_writing
		new_testicles.Insert(W, TRUE, FALSE)

	var/obj/item/organ/vagina/old_vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(old_vagina)
		var/obj/item/organ/vagina/new_vagina = new old_vagina.type()
		new_vagina.pregnant = old_vagina.pregnant
		new_vagina.fertility = old_vagina.fertility
		new_vagina.impregnation_probability = old_vagina.impregnation_probability
		new_vagina.branded_writing = old_vagina.branded_writing
		new_vagina.Insert(W, TRUE, FALSE)

	var/obj/item/organ/breasts/old_breasts = getorganslot(ORGAN_SLOT_BREASTS)
	if(old_breasts)
		var/obj/item/organ/breasts/new_breasts = new old_breasts.type()
		new_breasts.breast_size = old_breasts.breast_size
		new_breasts.lactating = old_breasts.lactating
		new_breasts.milk_stored = old_breasts.milk_stored
		new_breasts.milk_max = old_breasts.milk_max
		new_breasts.branded_writing = old_breasts.branded_writing
		new_breasts.Insert(W, TRUE, FALSE)

	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_GENERIC) //If we don't do this, the original body will fall asleep and snore on us

	invisibility = oldinv

	W.gain_inherent_skills()

	// Share devotion bar: beast form inherits the human's current devotion amount.
	if(devotion && W.devotion)
		W.devotion.max_devotion = devotion.max_devotion
		W.devotion.devotion = devotion.devotion
		W.devotion.update_devotion(0)

/mob/living/carbon/human/proc/wildshape_untransform(dead,gibbed)
	if(!stored_mob)
		return
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)

	// as before, save our worn stuff and prepare to move it back to the mob
	var/obj/item/stored_neck = wear_neck
	var/obj/item/stored_ring = wear_ring
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null

	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_GENERIC)

	// re-equip our stored neck and ring items, if we have them
	if (stored_ring)
		W.equip_to_slot_if_possible(stored_ring, SLOT_RING) // have to do this because we can wear psycrosses as rings even though we shouldn't be able to

	if (stored_neck)
		W.equip_to_slot_if_possible(stored_neck, SLOT_NECK)

	if(dead)
		W.death()

	for(var/datum/wound/old_wound in W.get_wounds())
		var/obj/item/bodypart/bp = W.get_bodypart(old_wound.bodypart_owner.body_zone)
		bp?.remove_wound(old_wound.type)

	var/list/datum/wound/woundlist = get_wounds()
	if(woundlist.len)
		for(var/datum/wound/wound in woundlist)
			var/obj/item/bodypart/c_BP = get_bodypart(wound.bodypart_owner.body_zone)
			var/obj/item/bodypart/w_BP = W.get_bodypart(wound.bodypart_owner.body_zone)
			w_BP.add_wound(wound.type)
			c_BP.remove_wound(wound.type)

	W.adjustBruteLoss(getBruteLoss())
	W.adjustFireLoss(getFireLoss())
	if(!HAS_TRAIT(W, TRAIT_NOBREATH))
		W.adjustOxyLoss(getOxyLoss())
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	src.adjustBruteLoss(-src.getBruteLoss())
	src.adjustFireLoss(-src.getFireLoss())
	src.adjustOxyLoss(-src.getOxyLoss())

	if(!HAS_TRAIT(W, TRAIT_BLOODLOSS_IMMUNE))
		W.set_blood_volume(blood_volume)
		W.bleed_rate = bleed_rate
	W.bleedsuppress = bleedsuppress

	W.forceMove(get_turf(src))
	mind.transfer_to(W)

	var/mob/living/carbon/human/species/wildshape/WA = src
	W.copy_known_languages_from(WA.stored_language)
	var/datum/skill_holder/restored_skills = W.ensure_skills()
	if(WA.stored_skills)
		restored_skills.known_skills = WA.stored_skills.Copy()
	if(WA.stored_experience)
		restored_skills.skill_experience = WA.stored_experience.Copy()
	playsound(W.loc, 'sound/body/shapeshift-end.ogg', 100, FALSE, 3)

	//Compares the list of spells we had before transformation with those we do now. If there are any that don't match, we remove them
	for(var/obj/effect/proc_holder/spell/self/originspell in WA.stored_spells)
		for(var/obj/effect/proc_holder/spell/self/wildspell in W.mind.spell_list)
			if(wildspell != originspell)
				W.RemoveSpell(wildspell)

	W.regenerate_icons()
	to_chat(W, span_userdanger("I return to my old form."))

	// Share devotion bar: return beast form's current devotion amount to human form.
	if(devotion && W.devotion)
		W.devotion.devotion = clamp(devotion.devotion, 0, W.devotion.max_devotion)
		W.devotion.update_devotion(0)

	qdel(src)
