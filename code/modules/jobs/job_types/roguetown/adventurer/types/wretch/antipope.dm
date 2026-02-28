//The antipope. The evil twin sibling of Bishop.
//Locked to Inhumen. Powerful support class with, however, very limited combat potential.
//Gets the ability to torture, recycled from normal heretic, combined with EVIL sermons and some extra miracles from other Inhumen patrons.
#define EVIL_PRIEST_SERMON_COOLDOWN (30 MINUTES)
/datum/advclass/wretch/antipope
	name = "Heresiarch" //formerly Doomsayer
	tutorial = "They are pretentious. They are weak. They are complacent. And they are hopeless. But you. You will change this. \
    A high-ranking official of the Holy Ecclesial, for your deeds you have been blessed by the Four Ascendants to bring upon change and be their God Hand. \
    But this change will be resisted. Crush the dissent. Show them why it is better to rule in Gehenna than serve under the Firmament."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS //The Inhumen discriminate not.
	outfit = /datum/outfit/job/roguetown/wretch/antipope
	cmode_music = 'sound/music/combat_cult.ogg'
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
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER, //You are Ascendants' chosen.
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "Inhumen exclusive. No wretch bounty, for the purpose of infiltration and doomsaying. Given EVIL sermon abilities, torture, maxed out miracles of their own patron and some extra miracles from other Inhumen patrons."

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
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 6, TRUE)
	if(istype (H.patron, /datum/patron/inhumen/zizo))
		H.mind?.current.faction += "[H.name]_faction"

	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence)//Shut that guy up!
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/nondetection)//For the purposes of meeting folks.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/message)//See above.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/evil_resurrect)//Sacrifice a heart to bring somebody back to life.
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
		var/t3_choice = input(H,"Choose your Tier Three Miracle.", "TAKE UP DARK KNOWLEDGE ([t3_count] CHOICES REMAIN)") as anything in t3
		if(t3_choice)
			var/obj/effect/proc_holder/chosen_miracle = t3[t3_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t3.Remove(t3_choice)
			t3_count--
	for(var/i in 1 to t2_count)
		var/t2_choice = input(H,"Choose your Tier Two Miracle.", "TAKE UP DARK KNOWLEDGE ([t2_count] CHOICES REMAIN)") as anything in t2
		if(t2_choice)
			var/obj/effect/proc_holder/chosen_miracle = t2[t2_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t2.Remove(t2_choice)
			t2_count--
	for(var/i in 1 to t1_count)
		var/t1_choice = input(H,"Choose your Tier One Miracle.", "TAKE UP DARK KNOWLEDGE ([t1_count] CHOICES REMAIN)") as anything in t1
		if(t1_choice)
			var/obj/effect/proc_holder/chosen_miracle = t1[t1_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t1.Remove(t1_choice)
			t1_count--
	for(var/i in 1 to t0_count)
		var/t0_choice = input(H,"Choose your Tier Zero Miracle.", "TAKE UP DARK KNOWLEDGE ([t0_count] CHOICES REMAIN)") as anything in t0
		if(t0_choice)
			var/obj/effect/proc_holder/chosen_miracle = t0[t0_choice]
			H.mind?.AddSpell(new chosen_miracle)
			t0.Remove(t0_choice)
			t0_count--

/mob/living/carbon/human/proc/completesermon_evil()
	set name = "Inhumen Sermon"
	set category = "Antipope"

	if (!mind)
		return

	//ANYWHERE, really, EXCEPT the chapel.
	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I can't do this here! They'll know!"))
		return FALSE

	if (!COOLDOWN_FINISHED(src, evil_priest_sermon))
		to_chat(src, span_warning("You cannot inspire others so early."))
		return

	src.visible_message(span_notice("[src] begins preaching a sermon..."))

	if (!do_after(src, 120, target = src)) // 120 seconds
		src.visible_message(span_warning("[src] stops preaching."))
		return

	src.visible_message(span_notice("[src] finishes the sermon, inspiring those nearby!"))
	playsound(src.loc, 'sound/magic/ahh2.ogg', 80, TRUE)
	COOLDOWN_START(src, evil_priest_sermon, EVIL_PRIEST_SERMON_COOLDOWN)

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue
		//We invert the sermon positives and negatives. Wild how that works.
		if (istype(H.patron, /datum/patron/divine))
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("Your patron seethes with disapproval."))
		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("You feel a divine affirmation from your patron."))
		else
			// Other patrons - fluff only
			to_chat(H, span_notice("Nothing seems to happen to you."))

	return TRUE

/mob/living/carbon/human/proc/revelations()
	set name = "Revelations"
	set category = "Antipope"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy))
		to_chat(src, span_warning("I need to be holding a zcross to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/zizocross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large profane shrine structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"THE TRUTH SHALL SET YOU FREE!",
			"WHO IS YOUR GOD!?",
			"ARE YOU FAITHFUL!?",
			"WHO IS YOUR SHEPHERD!?",
		)
		src.visible_message(span_warning("[src] shoves the decrepit zcross into [H]'s lux!"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		H.confess_sins("patron")
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))
