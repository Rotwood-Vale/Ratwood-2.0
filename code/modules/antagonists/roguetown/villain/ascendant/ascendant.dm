/datum/antagonist/ascendant
	name = "飞升者"
	roundend_category = "疯子"
	antagpanel_category = "倾听者"
	antag_memory = "<b>普赛顿 已死。旧万神殿软弱无力，而新神愚不可及。这个世界正在死去，而唯有我能拯救它 - 在此事完成之前，让 彗星西昂 的刀刃以鲜血浸透我。</b>"
	job_rank = ROLE_ASCENDANT
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "villain"
	confess_lines = list(
		"哈 - 哈哈 - 哈哈哈！你们活在一具尸体上！！",
		"神要来了。神已在此。",
		"我就是神。",
		"牌局已经排定，而河流正在转向。",
	)
	rogue_enabled = TRUE
	/// Traits we apply to the owner
	var/static/list/applied_traits = list(
		TRAIT_INFINITE_STAMINA,
		TRAIT_PSYCHOSIS,
		TRAIT_SHOCKIMMUNE,
	)

	/// Cached old stats in case we get removed
	var/STASTR
	var/STACON
	var/STAWIL

	var/static/list/possible_weapons = list(
		/obj/item/rogueweapon/sword/cutlass,
		/obj/item/rogueweapon/sword/decorated,
		/obj/item/rogueweapon/sword/sabre/dec,
	)

/datum/antagonist/ascendant/on_gain()
	. = ..()

	owner.special_role = ROLE_ASCENDANT
	owner.special_items["飞升者武器"] = pick(possible_weapons)
	if(owner.current)
		if(ishuman(owner.current))

			for(var/trait in applied_traits)
				ADD_TRAIT(owner.current, trait, "[type]")

			var/mob/living/carbon/human/dreamer = owner.current
			var/sword_skill = dreamer.get_skill_level(/datum/skill/combat/swords)
			var/unarmed_skill = dreamer.get_skill_level(/datum/skill/combat/unarmed)
			var/wrestling_skill = dreamer.get_skill_level(/datum/skill/combat/wrestling)
			if(sword_skill < 6)
				dreamer.adjust_skillrank(/datum/skill/combat/swords, 6 - sword_skill, TRUE)
			if(unarmed_skill < 6)
				dreamer.adjust_skillrank(/datum/skill/combat/unarmed, 6 - unarmed_skill, TRUE)
			if(wrestling_skill)
				dreamer.adjust_skillrank(/datum/skill/combat/wrestling, 6 - wrestling_skill, TRUE)
			STASTR = dreamer.STASTR
			STACON = dreamer.STACON
			STAWIL = dreamer.STAWIL
			dreamer.STASTR += 2
			dreamer.STACON += 2
			dreamer.STAWIL += 2

		if(length(objectives))
			SEND_SOUND(owner.current, 'sound/villain/ascendant_intro.ogg')
			to_chat(owner.current, span_danger("[antag_memory]"))
			owner.announce_objectives()
