/mob/living/carbon/human/proc/handle_curses()
	for(var/curse in curses)
		var/datum/curse/C = curse
		C.on_life(src)

/mob/living/carbon/human/proc/add_curse(datum/curse/C)
	if(is_cursed(C))
		return FALSE

	C = new C()
	curses += C
	var/curse_resist = FALSE
	if(HAS_TRAIT(src, TRAIT_CURSE_RESIST))
		curse_resist = 0.5
	C.on_gain(src, curse_resist)
	return TRUE

/mob/living/carbon/human/proc/remove_curse(datum/curse/C)
	if(!is_cursed(C))
		return FALSE

	var/curse_resist = FALSE
	if(HAS_TRAIT(src, TRAIT_CURSE_RESIST))
		curse_resist = 0.5
	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			curse.on_loss(src, curse_resist)
			curses -= curse
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_cursed(datum/curse/C)
	if(!C)
		return FALSE

	for(var/datum/curse/curse in curses)
		if(curse.name == C.name)
			return TRUE
	return FALSE

/datum/curse
	var/name = "调试诅咒"
	var/description = "这是一个调试用诅咒。"
	var/trait

/datum/curse/proc/on_life(mob/living/carbon/human/owner)
	return

/datum/curse/proc/on_death(mob/living/carbon/human/owner)
	return

/datum/curse/proc/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	ADD_TRAIT(owner, trait, TRAIT_CURSE)
	to_chat(owner, span_userdanger("有哪里不对劲……我感到自己被诅咒了。"))
	to_chat(owner, span_danger(description))
	owner.playsound_local(get_turf(owner), 'sound/misc/excomm.ogg', 80, FALSE, pressure_affected = FALSE)
	return

/datum/curse/proc/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	REMOVE_TRAIT(owner, trait, TRAIT_CURSE)
	to_chat(owner, span_userdanger("有什么变了……我感到如释重负。"))
	owner.playsound_local(get_turf(owner), 'sound/misc/bell.ogg', 80, FALSE, pressure_affected = FALSE)
	qdel(src)
	return

//////////////////////
///   TEN CURSES   ///
//////////////////////

/datum/curse/astrata
	name = "Astrata 的诅咒"
	description = "我已被太阳所弃。在她毫不动摇的注视下，我永远得不到安歇。"
	trait = TRAIT_CURSE_ASTRATA

/datum/curse/noc
	name = "Noc 的诅咒"
	description = "我已被明月所弃。在他的恩泽中，我再寻不到救赎。"
	trait = TRAIT_CURSE_NOC

/datum/curse/dendor
	name = "Dendor 的诅咒"
	description = "我已被树父所弃。理智与常识正离我而去。"
	trait = TRAIT_CURSE_DENDOR //Needs something unique but come up with it later:tm:

/datum/curse/abyssor
	name = "Abyssor 的诅咒"
	description = "我已被梦者所弃。祂的领域终将化为我的葬身之地。"
	trait = TRAIT_CURSE_ABYSSOR

/datum/curse/ravox
	name = "Ravox 的诅咒"
	description = "我已被裁决者所弃。我的敌手绝不会对我心慈手软。"
	trait = TRAIT_CURSE_RAVOX

/datum/curse/necra
	name = "Necra 的诅咒"
	description = "我已被冥下侍女所弃。哪怕最轻微的一击，也可能将我送入她的怀抱。"
	trait = TRAIT_CURSE_NECRA //Should be crit weakness still just flavour:tm:

/datum/curse/xylix
	name = "Xylix 的诅咒"
	description = "我已被诡术者所弃。厄运将步步紧随于我。"
	trait = TRAIT_CURSE_XYLIX

/datum/curse/pestra
	name = "Pestra 的诅咒"
	description = "我已被疫母所弃。病痛席卷我的身体，让最简单的事情也成了折磨。"
	trait = TRAIT_CURSE_PESTRA

/datum/curse/malum
	name = "Malum 的诅咒"
	description = "我已被造物主所弃。我的双手颤抖不止，迷雾笼罩了我的思绪。"
	trait = TRAIT_CURSE_MALUM

/datum/curse/eora
	name = "Eora 的诅咒"
	description = "我已被爱者所弃。这个世界于我而言，再无半点美丽可言。"
	trait = TRAIT_CURSE_EORA

////////////////////////////
///   ASCENDANT CURSES   ///
////////////////////////////
/datum/curse/zizo
	name = "Zizo 的诅咒"
	description = "我已被构筑者所弃。她的手掌正向我的心脏逼近。"
	trait = TRAIT_CURSE_ZIZO

/datum/curse/graggar
	name = "Graggar 的诅咒"
	description = "我已被战主所弃。如今我所真正知晓的，只有嗜血。"
	trait = TRAIT_CURSE_GRAGGAR

/datum/curse/matthios
	name = "Matthios 的诅咒"
	description = "我已被巨龙所弃。贪婪将成为我唯一的救赎。"
	trait = TRAIT_CURSE_MATTHIOS

/datum/curse/baotha
	name = "Baotha 的诅咒"
	description = "我已被碎心者所弃。我正溺死在她的许诺之中。"
	trait = TRAIT_CURSE_BAOTHA

//////////////////////
///	ON LIFE	 ///
//////////////////////

/datum/curse/astrata/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return

	if(world.time % 5)
		if(GLOB.tod != "night")
			if(isturf(H.loc))
				var/turf/T = H.loc
				if(T.can_see_sky())
					if(T.get_lumcount() > 0.15)
						H.fire_act(1,5)

/datum/curse/noc/on_life(mob/user)
	if(!user)
		return
	var/mob/living/carbon/human/H = user
	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return

	if(world.time % 5)
		if(GLOB.tod != "day")
			if(isturf(H.loc))
				var/turf/T = H.loc
				if(T.can_see_sky())
					if(T.get_lumcount() > 0.15)
						H.fire_act(1,5)


//////////////////////
/// ON GAIN / LOSS ///
//////////////////////

//TENNITES//

//ASTRATA//
/datum/curse/astrata/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_GENERIC)

/datum/curse/astrata/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_GENERIC)

//NECRA//
/datum/curse/necra/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STACON -= (10 * (1 - curse_resist))
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/curse/necra/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STACON += (10 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

//XYLIX//
/datum/curse/xylix/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC -= (20 * (1 - curse_resist))

/datum/curse/xylix/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC += (20 * (1 - curse_resist))

//PESTRA//
/datum/curse/pestra/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAWIL -= (10 * (1 - curse_resist))
	if(curse_resist && prob(50))
		return
	ADD_TRAIT(owner, TRAIT_NORUN, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/curse/pestra/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAWIL += (10 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_NORUN, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

//EORA//
/datum/curse/eora/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	var/curse_chance = (100 * (1 - curse_resist))
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_GENERIC)

/datum/curse/eora/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_UNSEEMLY, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_GENERIC)

//ASCENDANTS//

//ZIZO//
/datum/curse/zizo/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAINT -= (20 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)

/datum/curse/zizo/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STAINT += (20 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)

//GRAGGAR//
/datum/curse/graggar/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STASTR -= (14 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_DISFIGURED, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/curse/graggar/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STASTR += (14 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_DISFIGURED, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

//MATTHIOS//
/datum/curse/matthios/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC -= (14 * (1 - curse_resist))
	ADD_TRAIT(owner, TRAIT_CLUMSY, TRAIT_GENERIC)

/datum/curse/matthios/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	owner.STALUC += (14 * (1 - curse_resist))
	REMOVE_TRAIT(owner, TRAIT_CLUMSY, TRAIT_GENERIC)

//BAOTHA//
/datum/curse/baotha/on_gain(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	var/curse_chance = (100 * (1 - curse_resist))
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_NUDIST, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)
	if(prob(curse_chance))
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)

/datum/curse/baotha/on_loss(mob/living/carbon/human/owner, curse_resist = FALSE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NUDIST, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
