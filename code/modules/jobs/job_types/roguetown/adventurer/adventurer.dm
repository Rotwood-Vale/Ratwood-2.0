GLOBAL_LIST_EMPTY(billagerspawns)

GLOBAL_VAR_INIT(adventurer_hugbox_duration, 40 SECONDS)
GLOBAL_VAR_INIT(adventurer_hugbox_duration_still, 3 MINUTES)

/datum/job/roguetown/adventurer
	title = "Adventurer"
	display_title = "冒险者"
	flag = ADVENTURER
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 20
	spawn_positions = 20
	allowed_races = RACES_ALL_KINDS
	tutorial = "无名的英雄，漂泊异乡、追逐名望与财富的流浪者。究竟是什么把你推到了这般境地，就任凭风去裁定吧，而你向来也只把自己当成追逐刺激之人。总有一天，你的傲气会反噬你，你也会明白，为何大多数人最终都没能被写进史册。"
	class_categories = TRUE

	outfit = null
	outfit_female = null

	display_order = JDO_ADVENTURER
	show_in_credits = FALSE
	min_pq = 0
	max_pq = null

	advclass_cat_rolls = list(CTAG_ADVENTURER = 20)
	PQ_boost_divider = 10

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 1 MINUTES

	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	job_traits = list(TRAIT_OUTLANDER)

	job_subclasses = list(
		/datum/advclass/cleric,
		/datum/advclass/cleric/paladin,
		/datum/advclass/cleric/cantor,
		/datum/advclass/cleric/missionary,
		/datum/advclass/cleric/stigmata,
		/datum/advclass/sfighter,
		/datum/advclass/sfighter/duelist,
		/datum/advclass/sfighter/mhunter,
		/datum/advclass/sfighter/barbarian,
		/datum/advclass/sfighter/ironclad,
		/datum/advclass/rogue,
		/datum/advclass/rogue/thief,
		/datum/advclass/rogue/bard,
		/datum/advclass/rogue/swashbuckler,
		/datum/advclass/mage,
		/datum/advclass/mage/spellblade,
		/datum/advclass/mage/spellsinger,
		/datum/advclass/ranger,
		/datum/advclass/ranger/wayfarer,
		/datum/advclass/ranger/bombadier,
		/datum/advclass/ranger/bwanderer,
		/datum/advclass/noble,
		/datum/advclass/noble/knighte,
		/datum/advclass/noble/squire,
		/datum/advclass/foreigner,
		/datum/advclass/foreigner/yoruku,
		/datum/advclass/foreigner/repentant,
		/datum/advclass/foreigner/refugee,
		/datum/advclass/foreigner/slaver,
		/datum/advclass/foreigner/dunewell,
		/datum/advclass/foreigner/gronn,
		/datum/advclass/foreigner/nostromo,
		/datum/advclass/foreigner/aavnik,
		/datum/advclass/foreigner/bluthund,
	)

/mob/living/carbon/human/proc/adv_hugboxing_start()
	to_chat(src, span_warning("我一开始移动，就会陷入危险。"))
	status_flags |= GODMODE
	ADD_TRAIT(src, TRAIT_PACIFISM, HUGBOX_TRAIT)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(adv_hugboxing_moved))
	//Lies, it goes away even if you don't move after enough time
	if(GLOB.adventurer_hugbox_duration_still)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration_still)

/mob/living/carbon/human/proc/adv_hugboxing_moved()
	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	to_chat(src, span_danger("我必须在 [DisplayTimeText(GLOB.adventurer_hugbox_duration)] 内离开这里！"))
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, adv_hugboxing_end)), GLOB.adventurer_hugbox_duration)

/mob/living/carbon/human/proc/adv_hugboxing_end()
	if(QDELETED(src))
		return
	//hugbox already ended
	if(!(status_flags & GODMODE))
		return
	status_flags &= ~GODMODE
	REMOVE_TRAIT(src, TRAIT_PACIFISM, HUGBOX_TRAIT)
	to_chat(src, span_danger("我的安逸结束了！危险已将我包围。"))
