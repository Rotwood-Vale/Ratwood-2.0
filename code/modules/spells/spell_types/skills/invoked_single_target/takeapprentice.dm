// A skill, currently meant to be for towner towner (excluding towner, the more freeform role atm)
// Allows you to take on an apprentice, giving them one of the skill gating traits
// And giving them Novice in corresponding skills. 
// Meant to be used once per round per character. Cannot have more than one apprentice per character.
// Encourage people to encourage w/ towners to get skills and give them a point of leverage.
/obj/effect/proc_holder/spell/invoked/takeapprentice
	name = "收学徒"
	desc = "你可以收下一名学徒，给予其一项特质以及对应技能的新手水平。你只能拥有一名学徒，而且不能收已有导师的人为徒。 \n\
	若你的学徒彻底消失（例如离开本轮），你便可以再收另一名学徒。"
	overlay_state = "craft_buff"
	releasedrain = 50
	chargedrain = 0
	chargetime = 3 SECONDS // A charge time mostly to render it useless for putting an input on someone's screen mid combat. 
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	range = 1
	// Miserere mei, Deus, secundum magnam misericordiam tuam
	var/list/traits_to_skills = list (
		TRAIT_HOMESTEAD_EXPERT = list( 
			/datum/skill/labor/fishing,
			/datum/skill/labor/butchering,
			/datum/skill/labor/lumberjacking,
			/datum/skill/labor/farming,
			/datum/skill/craft/cooking,
			/datum/skill/craft/ceramics
		),
		TRAIT_SMITHING_EXPERT = list(
			/datum/skill/craft/blacksmithing,
			/datum/skill/craft/armorsmithing,
			/datum/skill/craft/weaponsmithing,
			/datum/skill/craft/ceramics,
			/datum/skill/craft/engineering,
			/datum/skill/labor/mining
		),
		TRAIT_SURVIVAL_EXPERT = list(
			/datum/skill/craft/cooking,
			/datum/skill/craft/tanning,
			/datum/skill/labor/butchering,
			/datum/skill/labor/fishing,
		),
		TRAIT_SEWING_EXPERT = list(
			/datum/skill/craft/sewing,
			/datum/skill/craft/tanning,
			/datum/skill/labor/butchering
		),
		TRAIT_ALCHEMY_EXPERT = list(
			/datum/skill/craft/alchemy
		),
		TRAIT_MEDICINE_EXPERT = list(
			/datum/skill/misc/medicine
		),
		TRAIT_SEEPRICES = list(
			/datum/skill/misc/reading, // I dunno what skills to give them as this is not a true
			/datum/skill/misc/lockpicking, // Yes I hate thieves but this should come with something
			/datum/skill/misc/stealing // Gating trait so I just give them some that make sense
		)
	)

/obj/effect/proc_holder/spell/invoked/takeapprentice/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/choices = list()
	var/mob/living/L = targets[1]
	if(user.get_apprentice())
		to_chat(user, span_warning("你已经有一名学徒了，不能再收第二个。"))
		revert_cast()
		return
	if(L.get_mentor())
		to_chat(user, span_warning("[L.name]已经有导师了，不能再拜第二位。"))
		revert_cast()
		return
	if(user == L)
		to_chat(user, span_warning("你不能把自己收为学徒。"))
		revert_cast()
		return
	for(var/i in traits_to_skills)
		if(HAS_TRAIT(user, i) && !HAS_TRAIT(L, i))
			choices += i
	if(!length(choices))
		to_chat(user, span_warning("不知为何，你没有任何能传授给[L.name]的特质。"))
		revert_cast()
	var/chosen_trait = input(user, "选择要让[L.name]学习的特质。", "传授你的知识") as null|anything in choices
	if(alert(L, "[user.name]愿意收你为学徒，教你成为[chosen_trait]的基础。你愿意接受吗？", "拜师", "侍奉并学习", "我拒绝") == "我拒绝")
		// Daga Kotowaru
		to_chat(user, span_warning("[L.name]拒绝了你收徒的提议。"))
		revert_cast()
		return
	if(!chosen_trait)
		to_chat(user, span_warning("你必须为[L.name]选择一项要学习的特质。"))
		revert_cast()
		return
	// Give the trait and skills.
	ADD_TRAIT(L, chosen_trait, TRAIT_GENERIC)
	for(var/skill in traits_to_skills[chosen_trait])
		// We can just skip the check because it only adjust up to 1 anyway
		to_chat(L, span_greentext("[user]已收你为学徒，开始教你成为[chosen_trait]的基础。"))
		L.adjust_skillrank_up_to(skill, SKILL_LEVEL_NOVICE)
		L.set_mentor(user)
		user.set_apprentice(L)
