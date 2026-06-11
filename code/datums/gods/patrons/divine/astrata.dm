/datum/patron/divine/astrata
	name = "Astrata"
	domain = "白昼、太阳、秩序"
	desc = "Absolute Order 便是那穿透大地、驱退邪恶的辉煌日光。世界因她的光而获得秩序，高贵者也因她的赐福而得以统治。Ravox 立于她侧，确保她的秩序不会沦为暴政。"
	worshippers = "贵族、义人、狂热者"
	virtues = "服从、诚实、压制"
	sins = "不忠、不死、懒惰"
	mob_traits = list(TRAIT_APRICITY)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/ignition				= CLERIC_T0,
					/obj/effect/proc_holder/spell/self/astrata_gaze				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/astratan_path			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/heal					= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/revive				= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/immolation			= CLERIC_T4,
	)
	confess_lines = list(
		"ASTRATA 即是我的光！",
		"ASTRATA 带来律法！",
		"我侍奉太阳的荣光！",
	)
	storyteller = /datum/storyteller/astrata

// In daylight, church, cross, or ritual chalk.
/datum/patron/divine/astrata/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的十字架打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer during daytime if outside.
	if(istype(get_area(follower), /area/rogue/outdoors) && (GLOB.tod == "day" || GLOB.tod == "dawn"))
		return TRUE
	to_chat(follower, span_danger("若想让 Astrata 听见我的祈祷，我必须沐浴在她赐福的白昼之下、身处教堂之中，或位于 psycross 附近……"))
	return FALSE

/datum/patron/divine/astrata/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一圈柔和的光辉拂过[target]！")
	*message_self = ("我沐浴在神圣的光辉之中！")

	if(GLOB.tod == "day")
		*conditional_buff = TRUE
		*situational_bonus = 2
