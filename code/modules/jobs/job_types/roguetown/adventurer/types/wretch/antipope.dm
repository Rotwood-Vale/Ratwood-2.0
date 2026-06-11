//The antipope. The evil twin sibling of Bishop.
//Locked to Inhumen. Powerful support class with, however, very limited combat potential.
//Gets the ability to torture, recycled from normal heretic, combined with EVIL sermons and some extra miracles from other Inhumen patrons.
#define EVIL_PRIEST_SERMON_COOLDOWN (30 MINUTES)
/datum/advclass/wretch/antipope
	name = "异端宗主" //formerly Doomsayer
	tutorial = "他们自命不凡。他们软弱无能。他们安于现状。并且毫无希望。可你不同。你将改变这一切。\
	你曾是圣教会中的高阶人物，因你的行迹，四位升天者赐福于你，要你带来改变，成为他们的神之手。\
	但这种改变必会遭到抗拒。粉碎异见吧。让他们明白，为何统治于 Gehenna 之上，也胜过匍匐侍奉于 Firmament 之下。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS //The Inhumen discriminate not.
	outfit = /datum/outfit/job/roguetown/wretch/antipope
	cmode_music = 'sound/music/combat_cult.ogg'
	class_select_category = CLASS_CAT_CLERIC
	category_tags = list(CTAG_WRETCH)
//Seer to see other Inhumen.
	traits_applied = list(TRAIT_HERETIC_SEER, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_RESONANCE, TRAIT_OVERTHERETIC)
//Support class statline, somewhat better than Bishop's. No armour traits, DE or CR, so needs good stats desperately.
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	maximum_possible_slots = 1//THERE CAN BE ONLY ONE GOD HAND.
	subclass_skills = list(//Has Expert in two comparatively bad weapon types, otherwise supposed to be a support rather than a frontliner.
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, //For self-defence, no STR so can't grab well, only resist
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER, //You are Ascendants' chosen.
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "仅限 异民。无 wretch 悬赏，便于渗透与传播末日预言。拥有邪恶布道、拷问能力、所属神祇的满级神迹，以及来自其他 异民 神祇的额外神迹。"

/datum/outfit/job/roguetown/wretch/antipope
	has_loadout = TRUE

//Starts with some basic leather armour.
/datum/outfit/job/roguetown/wretch/antipope/pre_equip(mob/living/carbon/human/H)
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	if(istype(H.patron, /datum/patron/inhumen/zizo))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/g
	if(istype(H.patron, /datum/patron/inhumen/graggar))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	if(istype(H.patron, /datum/patron/inhumen/baotha))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
	if(istype(H.patron, /datum/patron/inhumen/matthios))
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 6, TRUE)

	if(H.mind)
		wretch_select_bounty(H)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence)//Shut that guy up!
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/nondetection)//For the purposes of meeting folks.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)//See above.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/evil_resurrect)//Sacrifice a heart to bring somebody back to life.
		H.verbs |= /mob/living/carbon/human/proc/completesermon_evil
		H.verbs |= /mob/living/carbon/human/proc/revelations

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()

/datum/outfit/job/roguetown/wretch/antipope/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/t3_count = 1
	var/t2_count = 1
	var/t1_count = 1
	var/t0_count = 1
	var/list/t3 = list()
	var/list/t2 = list()
	var/list/t1 = list()
	var/list/t0 = list()
	for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/inhumen])
		var/datum/patron/patron = GLOB.patronlist[path]
		if(!patron || !patron.name)
			continue
		for(var/miracle in patron.miracles)
			var/obj/effect/proc_holder/checked_miracle = miracle
			if(patron.miracles[checked_miracle] == CLERIC_T3)
				t3[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T2)
				t2[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T1)
				t1[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T0)
				t0[initial(checked_miracle.name)] = checked_miracle
	for(var/miracle in t3)
		if(H.mind?.has_spell(t3[miracle]))
			t3.Remove(miracle)
	for(var/miracle in t2)
		if(H.mind?.has_spell(t2[miracle]))
			t2.Remove(miracle)
	for(var/miracle in t1)
		if(H.mind?.has_spell(t1[miracle]))
			t1.Remove(miracle)
	for(var/miracle in t0)
		if(H.mind?.has_spell(t0[miracle]))
			t0.Remove(miracle)
	for(var/i in 1 to t3_count)
		var/t3_choice = input(H,"选择你的三级神迹。", "汲取黑暗知识（剩余 [t3_count] 次选择）") as anything in t3
		if(t3_choice)
			var/obj/effect/proc_holder/chosen_miracle = t3[t3_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t3.Remove(t3_choice)
			t3_count--
	for(var/i in 1 to t2_count)
		var/t2_choice = input(H,"选择你的二级神迹。", "汲取黑暗知识（剩余 [t2_count] 次选择）") as anything in t2
		if(t2_choice)
			var/obj/effect/proc_holder/chosen_miracle = t2[t2_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t2.Remove(t2_choice)
			t2_count--
	for(var/i in 1 to t1_count)
		var/t1_choice = input(H,"选择你的一级神迹。", "汲取黑暗知识（剩余 [t1_count] 次选择）") as anything in t1
		if(t1_choice)
			var/obj/effect/proc_holder/chosen_miracle = t1[t1_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t1.Remove(t1_choice)
			t1_count--
	for(var/i in 1 to t0_count)
		var/t0_choice = input(H,"选择你的零级神迹。", "汲取黑暗知识（剩余 [t0_count] 次选择）") as anything in t0
		if(t0_choice)
			var/obj/effect/proc_holder/chosen_miracle = t0[t0_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t0.Remove(t0_choice)
			t0_count--

	if(H.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle))
		H.mind?.current.faction += "[H.name]_faction"
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/command_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)

/mob/living/carbon/human/proc/completesermon_evil()
	set name = "异种布道"
	set category = "异端宗主"

	if (!mind)
		return

	//ANYWHERE, really, EXCEPT the chapel.
	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我不能在这里这么做！他们会察觉的！"))
		return FALSE

	if (!COOLDOWN_FINISHED(src, evil_priest_sermon))
		to_chat(src, span_warning("这么短时间内你还无法再次鼓舞他人。"))
		return

	src.visible_message(span_notice("[src] 开始宣讲布道……"))

	if (!do_after(src, 120, target = src)) // 120 seconds
		src.visible_message(span_warning("[src] 停止了布道。"))
		return

	src.visible_message(span_notice("[src] 完成了布道，激励了附近的人！"))
	playsound(src.loc, 'sound/magic/ahh2.ogg', 80, TRUE)
	COOLDOWN_START(src, evil_priest_sermon, EVIL_PRIEST_SERMON_COOLDOWN)

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue
		//We invert the sermon positives and negatives. Wild how that works.
		if (istype(H.patron, /datum/patron/divine) && !HAS_TRAIT(H, TRAIT_HERESIARCH)) //Tennite Wretches won't be affected for the sake of convenience.
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("你的神祇正因不悦而震怒。"))
		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("你感受到来自神祇的神圣认可。"))
		else
			// Other patrons - fluff only
			to_chat(H, span_notice("你身上似乎什么都没有发生。"))

	return TRUE

/mob/living/carbon/human/proc/revelations()
	set name = "启示逼问"
	set category = "异端宗主"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("我的手里没有受害者！"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("我已经在折磨我自己了。"))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("要这样做，我的受害者必须先被束缚住！"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/inhumen/))
		to_chat(src, span_warning("我要手持一件 异民 护符，才能逼出这道启示！"))
		return
	for(var/obj/structure/fluff/psycross/zizocross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("附近必须有一座大型亵渎圣龛，我才能逼出这道启示！"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"真理必将使你自由！",
			"你的神是谁！？",
			"你是否忠贞于信仰！？",
			"谁才是你的牧者！？",
		)
		src.visible_message(span_warning("[src] 将 [S] 狠狠抵进了 [H] 的灵火之处！"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		H.confess_sins("patron")
		return
	to_chat(src, span_warning("这家伙现在还没到能被拷问的状态……"))
