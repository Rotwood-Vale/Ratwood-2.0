/datum/antagonist/werewolf/on_life(mob/user)
	try_werewolf_auto_tf(user)

/datum/antagonist/werewolf/proc/can_transform(mob/living/carbon/human/user)
	if(!ishuman(user)) 
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD) 
		return FALSE
	if(H.advsetup) 
		return FALSE
	if(HAS_TRAIT(H, TRAIT_SILVER_BLESSED)) 
		return FALSE
	return TRUE

// automatic fire-and-do-whatever-should-do-thing thing
/datum/antagonist/werewolf/proc/try_werewolf_auto_tf(mob/living/carbon/human/user)
	if(!can_transform(user))
		return

	if(transformed)
		if(time_is_day_under_daylight_day(user))
			if(!is_unmagical_ungirl_untransforming(user))
				start_the_untransformation(user)
				return // the furry -> bigfurry pipeline is started
			tick_unmagical_ungirl_untransformation(user)
		else if(untransforming)
			abort_untransformation(user)
	else
		if(time_is_right_under_moonlit_night(user))
			if(!is_magical_girl_transforming(user))
				start_the_transformation(user)
				return // the bigfurry -> furry pipeline is started
			tick_magical_girl_transformation(user)
		else if(transforming)
			abort_transformation(user)

/datum/antagonist/werewolf/proc/time_is_day_under_daylight_day(mob/living/carbon/human/user)
	if(!transformed)
		return FALSE
	if(GLOB.tod == "night")
		return FALSE // define? very fine~
	if(ready_to_untransform)
		return TRUE // good!
	if(!automatically_untransforms_in_daytime)
		return FALSE
	return TRUE

// Werewolf transforms at night AND under the sky
/datum/antagonist/werewolf/proc/time_is_right_under_moonlit_night(mob/living/carbon/human/user)
	if(transformed)
		return FALSE
	if(GLOB.tod != "night")
		return FALSE
	var/turf/here = user.loc
	if(!isturf(here))
		return FALSE // inside something, or user is a turf and their loc is an area. actually impossible, but something I have to keep reminding myself, about the whole turf.loc = area thing
	if(!here.can_see_sky())
		return FALSE
	return TRUE

/datum/antagonist/werewolf/proc/start_the_transformation(mob/living/carbon/human/user)
	to_chat(user, span_userdanger("The moonlight scorns me... It is too late."))
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	user.fullscreen_redflash("redflash3")
	transforming = world.time // timer
	tf_stage = 0

/datum/antagonist/werewolf/proc/start_the_untransformation(mob/living/carbon/human/user)
	untransforming = world.time // Start untransformation phase
	tf_stage = 0

/datum/antagonist/werewolf/proc/is_magical_girl_transforming(mob/living/carbon/human/user)
	return transforming > 0

/datum/antagonist/werewolf/proc/is_unmagical_ungirl_untransforming(mob/living/carbon/human/user)
	return untransforming > 0

/datum/antagonist/werewolf/proc/tick_magical_girl_transformation(mob/living/carbon/human/user)
	if(transformed)
		return
	var/delta_t = world.time - transforming
	switch(tf_stage)
		if(0)
			to_chat(user, span_warning("I feel sick..."))
			tf_stage = 1
		if(1) // stage 1
			if(delta_t < 10 SECONDS)
				return
			user.emote("") // ??
			to_chat(user, span_warning("I can feel my muscles aching, it feels HORRIBLE..."))
			tf_stage = 2
		if(2) // stage 2
			if(delta_t < 25 SECONDS)
				return
			user.fullscreen_redflash("redflash3")
			user.emote("agony", forced = TRUE)
			to_chat(user, span_userdanger("UNIMAGINABLE PAIN!"))
			user.Stun(30)
			user.Knockdown(30)
			tf_stage = 3
		if(3) // stage 3, sailor star power make up
			if(delta_t < 35 SECONDS)
				return
			user.werewolf_transform()
			ready_to_untransform = FALSE // just in case
			transforming = FALSE // its both a boolean AND a timer!
			transformed = TRUE // Mark as transformed
			tf_stage = 0 // all done!

/datum/antagonist/werewolf/proc/tick_unmagical_ungirl_untransformation(mob/living/carbon/human/user)
	if(!transformed)
		return // already there
	var/delta_t = world.time - untransforming
	switch(tf_stage)
		if(0)
			to_chat(user, span_warning("My fur itches..."))
			tf_stage = 1
		if(1)
			if(delta_t < 10 SECONDS)
				return
			user.fullscreen_redflash("redflash1")
			to_chat(user, span_warning("Daylight shines around me... the curse begins to fade."))
			tf_stage = 2
		if(2)
			if(delta_t < 30 SECONDS)
				return
			user.emote("rage", forced = TRUE)
			user.werewolf_untransform()
			ready_to_untransform = FALSE
			transformed = FALSE
			untransforming = FALSE // Reset untransforming phase
			tf_stage = 0

/datum/antagonist/werewolf/proc/abort_transformation(mob/living/carbon/human/user)
	if(!transforming || transformed)
		return // not wolfing, or already a wolf
	transforming = 0
	tf_stage = 0
	to_chat(user, span_userdanger("I resist the moonlight's influence! My transformation has ceased!"))
	user.Stun(10)
	user.Knockdown(10)

/datum/antagonist/werewolf/proc/abort_untransformation(mob/living/carbon/human/user)
	if(!untransforming || !transformed)
		return // not unwolfine, or already not a wolf
	ready_to_untransform = FALSE
	untransforming = 0
	tf_stage = 0
	to_chat(user, span_userdanger("I reject the daylight's power!"))
	user.Stun(10)
	user.Knockdown(10)

/mob/living/carbon/human/species/werewolf/death(gibbed, nocutscene = FALSE)
	werewolf_untransform(TRUE, gibbed)

/mob/living/carbon/human/proc/werewolf_transform()
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)
//	stop_cmusic() // cboy cmusic

	fully_heal(FALSE)

	var/ww_path
	if(gender == MALE)
		ww_path = /mob/living/carbon/human/species/werewolf/male
	else
		ww_path = /mob/living/carbon/human/species/werewolf/female

	var/mob/living/carbon/human/species/werewolf/W = new ww_path(loc)


	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	W.vices += new /datum/charflaw/addiction/lovefiend/werewolf()

	//Set the werewolf's name from the antagonist datum
	var/datum/antagonist/werewolf/Were = mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(Were)
		W.real_name = Were.wolfname
		W.name = Were.wolfname
		Were.transformed = TRUE
		Were.transforming = FALSE
	W.limb_destroyer = TRUE
	W.ambushable = FALSE
	W.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'
	W.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/werewolf_skin(W)
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 80, FALSE, 3)
	W.spawn_gibs(FALSE)
	src.forceMove(W)

	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name
	mind.transfer_to(W)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.remove_all_languages()
	W.grant_language(/datum/language/beast)
	W.grant_language(/datum/language/common)

	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	to_chat(W, span_userdanger("I transform into a horrible beast!"))
	W.emote("rage")

	if(getorganslot(ORGAN_SLOT_PENIS))
		var/obj/item/organ/penis/new_penis = new /obj/item/organ/penis/knotted/big()
		new_penis.Insert(W, special = TRUE, drop_if_replaced = FALSE)
	var/obj/item/organ/testicles/original_testicles = getorganslot(ORGAN_SLOT_TESTICLES)
	if(original_testicles)
		var/obj/item/organ/testicles/new_testicles = new /obj/item/organ/testicles()
		new_testicles.virility = original_testicles.virility
		new_testicles.Insert(W, special = TRUE, drop_if_replaced = FALSE)
	if(getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/breasts/new_breasts = new /obj/item/organ/breasts()
		new_breasts.Insert(W, special = TRUE, drop_if_replaced = FALSE)
	var/obj/item/organ/vagina/original_vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(original_vagina)
		var/obj/item/organ/vagina/new_vagina = new /obj/item/organ/vagina()
		new_vagina.fertility = original_vagina.fertility
		new_vagina.Insert(W, special = TRUE, drop_if_replaced = FALSE)

	W.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	W.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	W.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	W.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)

	W.STASTR = 20
	W.STACON = 20
	W.STAWIL = 20
	if(isseelie(W.stored_mob))
		W.change_stat(STATKEY_SPD, -3)

	W.AddSpell(new /obj/effect/proc_holder/spell/self/howl)
	W.AddSpell(new /obj/effect/proc_holder/spell/self/claws)
	W.AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick/werewolf)
	W.AddSpell(new /obj/effect/proc_holder/spell/invoked/voluntary_bite)
	W.AddSpell(new /obj/effect/proc_holder/spell/invoked/shiftback)

	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_GRABIMMUNE, TRAIT_GENERIC) // THIS IS THE CORRECT PLACE FOR WEREWOLF TRAITS. GOD.
	ADD_TRAIT(W, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_ZJUMP, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_NASTY_EATER, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_IGNORESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_PIERCEIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_GRABIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_DEATHBYSNUSNU, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_UNLYCKERABLE, TRAIT_GENERIC)
	ADD_TRAIT(W, TRAIT_EXTREME_TEMPERATURE_IMMUNE, TRAIT_GENERIC)

	invisibility = oldinv

/mob/living/carbon/human/species/werewolf/could_speak_in_language(datum/language/dt)
	if(dt == /datum/language/common)
		return FALSE
	return ..()

/mob/living/carbon/human/proc/werewolf_untransform(dead,gibbed)
	if(!stored_mob)
		return
	for(var/datum/charflaw/addiction/lovefiend/werewolf/vice in vices.Copy())
		vice.on_removal(src)
		vices -= vice
		qdel(vice)
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null
	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_GENERIC)
	if(dead)
		W.death(gibbed)

	W.forceMove(get_turf(src))

	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_GENERIC)
	REMOVE_TRAIT(W, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

	mind.transfer_to(W)

	var/mob/living/carbon/human/species/werewolf/WA = src
	W.remove_all_languages()
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()

	W.RemoveSpell(new /obj/effect/proc_holder/spell/self/howl)
	W.RemoveSpell(new /obj/effect/proc_holder/spell/self/claws)
	W.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/woundlick/werewolf)
	W.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/shiftback)
	W.regenerate_icons()

	to_chat(W, span_userdanger("I return to my facade."))
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	W.spawn_gibs(FALSE)
	W.Knockdown(30)
	W.Stun(30)

	qdel(src)
