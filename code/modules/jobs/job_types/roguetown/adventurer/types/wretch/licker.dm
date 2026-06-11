/datum/advclass/wretch/licker
	name = "舔血者"
	tutorial = "你最近才刚被吸血鬼初拥。你不知道自己的血亲是谁，体内翻涌着诡异的冲动、非人的力量，以及几乎无法控制的饥渴。你的怪物身份已经暴露，如今只能四处逃亡。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/wretch/licker
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_SILVER_WEAK,
	)
	maximum_possible_slots = 2
	applies_post_equipment = FALSE

/datum/outfit/job/roguetown/wretch/licker/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_blindness(-3)
		wretch_select_bounty(H)
		var/list/possible_classes = list()
		for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_LICKER_WRETCH])
			possible_classes += CHECKS

		var/datum/advclass/C = input(H.client, "我将以什么身份行动？", "冒险") as null|anything in possible_classes
		C.equipme(H)

		H.adjust_skillrank_up_to(/datum/skill/magic/blood, 4, TRUE)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_NEONATE)
		H.mind.add_antag_datum(new_antag)

/datum/reagent/vampsolution
	metabolization_rate = 1

/datum/reagent/vampsolution/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(30)
	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s","giggle"))
		else
			M.emote(pick("twitch_s","chuckle"))
	// Apply vampbite once, do not refresh duration endlessly
	if(!M.has_status_effect(/datum/status_effect/debuff/vampbite))
		M.apply_status_effect(/datum/status_effect/debuff/vampbite)
	..()

/atom/movable/screen/fullscreen/vampsolution
	icon_state = "spa"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE

/datum/reagent/vampsolution/on_mob_metabolize(mob/living/M, mob/living/S)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
	M.set_drugginess(30)
	if(M.client)
		ADD_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.area_entered(get_area(M), M.client)

/datum/reagent/vampsolution/on_mob_end_metabolize(mob/living/M, mob/living/S)
	M.clear_fullscreen("druqk")
	M.remove_status_effect(/datum/status_effect/buff/druqks)
	M.set_drugginess(0)
	if(M.client)
		REMOVE_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.play_area_sound(get_area(M), M.client)
