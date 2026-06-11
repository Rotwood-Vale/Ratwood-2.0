/datum/patron/divine/dendor
	name = "Dendor"
	domain = "植物、野兽、自然、农耕"
	desc = "树父曾是第一位德鲁伊，因其领域屡遭蹂躏而陷入疯狂。即便如此，祂依旧守望着林地与平原，为我们的收成与生计降下祝福。祂的野兽从不对我们留情，但我们仍能学会避开它们的利爪獠牙。"
	worshippers = "德鲁伊、野兽、疯子、农夫、精灵、Wildkin"
	virtues = "和谐、原始主义、狩猎"
	sins = "文明、过度猎杀、不敬自然"
	mob_traits = list(TRAIT_KNEESTINGER_IMMUNITY, TRAIT_LEECHIMMUNE)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/spiderspeak 			= CLERIC_T0,
					/obj/effect/proc_holder/spell/targeted/blesscrop			= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 			= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/wildshape				= CLERIC_T2,
					/obj/effect/proc_holder/spell/targeted/beasttame			= CLERIC_T2,
					/obj/effect/proc_holder/spell/targeted/conjure_glowshroom	= CLERIC_T3,
					/obj/effect/proc_holder/spell/targeted/conjure_vines 		= CLERIC_T3,
					/obj/effect/proc_holder/spell/self/howl/call_of_the_moon	= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/resurrect/dendor		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/sanctify_tree			= CLERIC_T4,
					)
	confess_lines = list(
		"DENDOR 赐予万物！",
		"树父带来丰饶！",
		"我回应荒野的呼唤！",
	)
	storyteller = /datum/storyteller/dendor

// In grove, bog, cross, or ritual chalk
// Yes, he is NOT calling the master cus he's unique. Whole bog is his prayer zone. Druids exist for a reason instead of in the church.
/datum/patron/divine/dendor/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的十字架打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the druid tower + houses in the forest
	if(istype(get_area(follower), /area/rogue/indoors/shelter/woods))
		return TRUE
	// Allows prayer in outdoors wilderness, such as bog
	if(istype(get_area(follower), /area/rogue/outdoors/rtfield))
		return TRUE
	for(var/obj/structure/flora/roguetree/wise in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让 Dendor 听见我的祈祷，我必须身处祂的荒野、Grove、智者古树附近，或 Panetheon Cross 旁，好让“树父”听见我的祈祷……"))
	return FALSE

/datum/patron/divine/dendor/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一股原始能量缠绕着[target]盘旋升腾！")
	*message_self = span_notice("原始的力量灌注进了我的体内！")

	var/list/natural_stuff = list(/obj/structure/flora/roguegrass, /obj/structure/flora/roguetree, /obj/structure/flora/rogueshroom, /obj/structure/soil, /obj/structure/flora/newtree, /obj/structure/flora/tree, /obj/structure/glowshroom)
	var/bonus = 0

	// the more natural stuff around US, the more we heal
	for (var/obj/obj in oview(5, user))
		if(!(obj.type in natural_stuff))
			continue

		bonus = min(bonus + 0.1, 2)

	for(var/obj/structure/flora/roguetree/wise/tree in oview(5, user))
		bonus += 1.5

	if(!bonus)
		return

	*conditional_buff = TRUE
	*situational_bonus = bonus
