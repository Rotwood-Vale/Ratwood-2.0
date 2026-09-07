/datum/stressevent/lovezizo
	timer = 99999 MINUTES
	stressadd = -666 // :)
	desc = span_green("ZIZOZIZOZIZO")

/datum/stressevent/hatezizo
	timer = 99999 MINUTES
	stressadd = 10 // :)
	desc = "<span class='red'>ZIZOZIZOZIZO</span>"

/datum/stressevent/leechcult
	timer = 1 MINUTES
	stressadd = 3
	desc = list("<span class='red'>There's a little goblin in my head telling me to do things and I don't like it!</span>","<span class='red'>\"Kill your friends.\"</span>","<span class='red'>\"Make them bleed.\"</span>","<span class='red'>\"Give them no time to squeal.\"</span>","<span class='red'>\"Praise Zizo.\"</span>","<span class='red'>\"Death to the Ten.\"</span>","<span class='red'>\"We will recycle them.\"</span>")

/proc/is_zizocultist(datum/mind/M)
	return istype(M?.has_antag_datum(/datum/antagonist/zizocultist), /datum/antagonist/zizocultist/leader)

/proc/is_zizolackey(datum/mind/M)
	var/datum/antagonist/zizocultist/Z = M?.has_antag_datum(/datum/antagonist/zizocultist)
	return Z && !istype(Z, /datum/antagonist/zizocultist/leader)

GLOBAL_LIST_INIT(ritualslist, build_zizo_rituals())

/proc/build_zizo_rituals()
	. = list()
	for(var/datum/ritual/ritual as anything in subtypesof(/datum/ritual))
		if(initial(ritual.abstract_type) == ritual)
			continue
		.[ritual.name] = new ritual

// RITUAL DATUMS
/proc/ritual_available(mob/living/carbon/human/user, datum/ritual/ritual)
	if(initial(ritual.abstract_type) == ritual)
		return FALSE
	if(!(ritual in user.mind.zizo_researched))
		return FALSE
	if(initial(ritual.is_cultist_ritual) && !is_zizo(user))
		return FALSE
	if(ritual.passive == TRUE)
		return FALSE
	return TRUE

GLOBAL_LIST_EMPTY(zizo_targets)
GLOBAL_VAR_INIT(zizo_target_cd, 0)

/proc/zizo_award(mob/M, amt)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.mind.zizo_points += amt
	to_chat(M, span_boldnotice("SECRETS UNVEILED. (+[amt])"))

/datum/zizo_research/proc/open(mob/living/carbon/human/user)
	var/contents = "SECRETS UNVEILED: [user.mind.zizo_points]<BR>--------------<BR>"
	var/any = FALSE
	for(var/ritualtype in GLOB.zizo_researchable)
		any = TRUE
		var/datum/ritual/R = ritualtype
		if(ritualtype in user.mind.zizo_researched)
			contents += "<B>[initial(R.name)]</B> - LEARNED<BR>'<I>[R.desc]</I>'<BR>"
			continue
		if(R.is_cultist_ritual && !is_zizo(user))
			continue
		contents += "<a href='?src=[REF(src)];buy=[ritualtype]'>[initial(R.name)]</a> - [initial(R.research_cost)] SECRETS<BR>'<I>[R.desc]</I>'<BR>"
	if(!any)
		contents += "There is nothing left to uncover.<BR>"
	var/datum/browser/popup = new(user, "zizoresearch", "ZIZO", 400, 500)
	popup.set_content(contents)
	popup.open(FALSE)

/datum/zizo_research/Topic(href, href_list)
	var/mob/living/carbon/human/user = usr
	if(!ishuman(user))
		return
	var/ritualtype = text2path(href_list["buy"])
	if(!ritualtype || (ritualtype in user.mind.zizo_researched) || !(ritualtype in GLOB.zizo_researchable))
		return
	var/datum/ritual/R = new ritualtype
	if(user.mind.zizo_points < initial(R.research_cost))
		to_chat(user, span_warning("NOT ENOUGH SECRETS."))
		return
	user.mind.zizo_points -= initial(R.research_cost)
	user.mind.zizo_researched |= ritualtype
	if(R.passive)
		R.apply_passive(user)
	to_chat(user, span_boldnotice("EUREKA! I DISCOVER [uppertext(R.name)]!"))
	qdel(R)
	open(user)

/proc/reroll_targets()
	GLOB.zizo_targets = list()
	var/list/weighted = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(!H.mind || !H.client || H.stat == DEAD || is_zizo(H))
			continue
		var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
		if(!J || (J.type in list(KING_QUEEN_ROLES)) || J.type == /datum/job/roguetown/bandit || J.type == /datum/job/roguetown/wretch)
			continue
		if(J.type in (list(PEASANT_ROLES) + list(YEOMEN_ROLES) + list(MANOR_ROLES) + list(WANDERER_ROLES) + list(GARRISON_ROLES) + list(CHURCH_ROLES)))
			weighted[H] = 5
			if(H.purity == TRUE)
				weighted[H] = 10
		else
			weighted[H] = 1
			if(H.purity == TRUE)
				weighted[H] = 5
	for(var/i in 1 to 7)
		if(!weighted.len)
			break
		var/mob/living/carbon/human/chosen = pickweight(weighted)
		GLOB.zizo_targets += chosen
		weighted -= chosen

/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	var/desc
	var/center_requirement
	var/n_req
	var/e_req
	var/s_req
	var/w_req
	var/is_cultist_ritual = FALSE
	var/research_cost = 5
	var/needs_aspect = FALSE
	var/keep_center = FALSE
	var/center_desc
	var/n_desc
	var/e_desc
	var/s_desc
	var/w_desc
	var/passive = FALSE

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	return

/datum/ritual/proc/apply_passive(mob/living/carbon/human/H)
	return

/datum/ritual/proc/req_label(req, desc)
	if(desc)
		return desc
	if(req == /mob/living/carbon/human)
		return "a humanoid"
	var/atom/A = req
	return initial(A.name)

/datum/ritual/proc/hugbox()
	var/list/parts = list()
	if(center_requirement)
		parts += "Center - [req_label(center_requirement, center_desc)]"
	if(n_req)
		parts += "North - [req_label(n_req, n_desc)]"
	if(e_req)
		parts += "East - [req_label(e_req, e_desc)]"
	if(s_req)
		parts += "South - [req_label(s_req, s_desc)]"
	if(w_req)
		parts += "West - [req_label(w_req, w_desc)]"
	return jointext(parts, ", ")

// SERVANTRY
/datum/ritual/servantry
	abstract_type = /datum/ritual/servantry

/datum/ritual/servantry/convert
	name = "Convert"
	desc = "Place a sacrifice in the middle of the rune to convert them into a lackey. Grants SECRETS. If they refuse, it sacrifices them. Requires an assistant on the rune if you have more than 2 lackeys already. Must use targets obtained by Divine Sacrifices."
	center_requirement = /mob/living/carbon/human
	center_desc = "a sacrifice"
	is_cultist_ritual = TRUE

/datum/ritual/servantry/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target || target == user)
		to_chat(user, span_warning("A sacrifice must lie in the center. The sacrifice must be desired by ZIZO, which can be tracked by heartaches. If you have more than 2 lackeys, you require an assistant cultist on the sigil to perform this rite."))
		return
	if(is_zizocultist(target.mind) || is_zizolackey(target.mind))
		return
	if(!target.client)
		return
	if(!(target in GLOB.zizo_targets))
		to_chat(user, span_warning("She does not want this one."))
		return
	if(istype(target.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist, TRUE)
	var/lackeys = 0
	for(var/datum/mind/M in SSmapping.retainer.cultists)
		if(is_zizolackey(M))
			lackeys++
	if(lackeys > 2)
		var/mob/living/carbon/human/assistant
		for(var/mob/living/carbon/human/H in range(1, center))
			if(H == user || H == target || !is_zizo(H))
				continue
			assistant = H
			break
		if(!assistant)
			to_chat(user, span_warning("FOR THE CULT TO GROW LARGER, YOU MUST PERFORM THIS RITE WITH AN ASSISTANT CULTIST ON THE SIGIL."))
			return
	var/alert = tgui_alert(target, "YOU WILL BE SHOWN THE TRUTH. DO YOU RESIST?", "???", list("Yield", "Resist"))
	target.Immobilize(3 SECONDS)
	if(alert == "Yield")
		to_chat(target, span_notice("I see the truth now! It all makes so much sense! They aren't HERETICS! They want the BEST FOR US!"))
		PR.add_cultist(target.mind)
		target.praise()
		for(var/datum/mind/M in SSmapping.retainer.cultists)
			if(M.current)
				zizo_award(M.current, 2)
		zizo_award(user, 3)
		zizo_award(target, 3)
	else
		target.visible_message(span_danger("[target] thrashes around, unyielding!"))
		if(!absorb_lux(target, get_turf(target)))
			to_chat(user, span_warning("[target] has no lux left to give."))
		else
			to_chat(user, span_notice("The lux is torn from [target] and bound into a dark crystal."))
			zizo_award(user, 5)
	GLOB.zizo_targets -= target

/datum/ritual/servantry/sacrifice
	name = "Sacrifice"
	desc = "Place a sacrifice in the middle of the rune to rip out their lux. Grants SECRETS and a dark crystal. Requires an assistant holding a knife to stand on the sigil for the rite to function. Must use targets obtained by Divine Sacrifices."
	center_requirement = /mob/living/carbon/human
	center_desc = "a sacrifice"

/datum/ritual/servantry/sacrifice/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target || target == user)
		to_chat(user, span_warning("A sacrifice must lie in the center. I also need another cultist on the rune with a knife in their hand. The sacrifice must be desired by ZIZO, which can be tracked by heartaches."))
		return
	if(is_zizo(target))
		to_chat(user, span_warning("This is a cultist."))
		return
	if(!target.client)
		return
	if(!(target in GLOB.zizo_targets))
		to_chat(user, span_warning("She does not want this one."))
		return
	if(istype(target.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	var/mob/living/carbon/human/assistant
	for(var/mob/living/carbon/human/H in range(1, center))
		if(H == user || H == target)
			continue
		for(var/obj/item/I in H.held_items)
			if(istype(I, /obj/item/rogueweapon/huntingknife))
				assistant = H
				break
		if(assistant)
			break
	if(!assistant)
		to_chat(user, span_warning("I need another cultist on the rune with a knife in their hand."))
		return
	to_chat(user, span_notice("You and [assistant] begin the sacrifice..."))
	if(!do_after(user, 10 SECONDS, target = target) && !do_after(assistant, 10 SECONDS, target = target))
		return
	if(QDELETED(target) || !(target in center.contents) || QDELETED(assistant))
		return
	if(!absorb_lux(target, center))
		to_chat(user, span_warning("[target] has no lux left to give."))
		return
	var/datum/job/J = SSjob.GetJob(target.mind?.assigned_role)
	if(J && (J.type in (list(NOBLE_ROLES) + list(CHURCH_ROLES) + list(GARRISON_ROLES) + list(INQUISITION_ROLES))))
		new /obj/item/necro_relics/necro_crystal(center)
	GLOB.zizo_targets -= target
	zizo_award(user, 5)
	zizo_award(assistant, 5)
	target.visible_message(span_danger("[assistant] tears open [target]'s chest and rips free their lux!"))
	to_chat(user, span_notice("The sacrifice is accepted!"))

/datum/ritual/servantry/heartache
	name = "Heartaches"
	desc = "Create a heart to track your sacrifice targets."
	center_requirement = /obj/item/organ/heart

/datum/ritual/servantry/heartache/invoke(mob/user, turf/center)
	new /obj/item/corruptedheart(center)
	to_chat(user, span_notice("Use this item to seek your sacrifices."))

/datum/ritual/servantry/marktargets
	name = "Divine Sacrifices"
	desc = "Locate new targets to sacrifice and convert. Can use every 20 minutes."
	center_requirement = /obj/item/organ/eyes
	center_desc = "eyes"
	is_cultist_ritual = TRUE
	keep_center = TRUE

/datum/ritual/servantry/marktargets/invoke(mob/living/user, turf/center)
	if(world.time < GLOB.zizo_target_cd)
		to_chat(user, span_warning("It is too soon, you must wait."))
		return
	var/obj/item/organ/heart/heart = locate() in center
	if(heart)
		qdel(heart)
	GLOB.zizo_target_cd = world.time + 20 MINUTES
	reroll_targets()
	to_chat(user, span_notice("You feel a shiver down your spine. Seek your new sacrifices with heartaches."))

/obj/item/corruptedheart
	name = "corrupted heart"
	desc = "It sparkles with forbidden magic energy. Can be used to locate sacrifices."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class = WEIGHT_CLASS_SMALL
	var/cooldown

/obj/item/corruptedheart/attack_self(mob/user)
	if(!is_zizo(user))
		return
	if(!length(GLOB.zizo_targets))
		to_chat(user, span_warning("There are no targets. Divine new sacrifices."))
		return
	if(world.time < cooldown)
		to_chat(user, span_warning("Too soon!"))
		return
	if(!do_after(user, 2 SECONDS, src))
		return
	var/mob/living/carbon/human/prey = input("Choose a target.") as null|anything in GLOB.zizo_targets
	if(!prey || !prey.z)
		return
	if(istype(prey.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	var/dir_text = dir2text(get_dir(user, prey))
	var/dist = get_dist(user, prey)
	var/proximity_text = "far away"
	if(dist <= 5)
		proximity_text = "very close"
	else if(dist <= 15)
		proximity_text = "nearby"
	var/z_text = ""
	if(prey.z > user.z)
		z_text = ", somewhere above"
	else if(prey.z < user.z)
		z_text = ", somewhere below"
	to_chat(user, span_danger("The heart beats faster toward the [dir_text]. [prey.real_name] feels [proximity_text][z_text]."))
	cooldown = world.time + 10 SECONDS

/datum/ritual/servantry/gutted
	name = "Gutted Fish"
	desc = "Place a mindless humanoid in the center of the sigil to rip out its organs."
	center_requirement = /mob/living/carbon/human // One to be gutted.human

/datum/ritual/servantry/gutted/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD)
		return
	if(target.mind)
		to_chat(user, span_danger("The sacrifice must be mindless."))
		return
	center.visible_message(span_danger("[target] is lifted up into the air and multiple scratches, incisions and deep cuts start etching themselves into their skin as all of their internal organs spill on the floor below!"))
	var/atom/drop_location = target.drop_location()
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		organ.Remove(target)
		organ.forceMove(drop_location)
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		part.drop_limb()

/datum/ritual/servantry/darksunmark
	name = "Dark Sun's Mark"
	desc = "Mark someone for death by Graggar Assassins."
	center_requirement = /obj/item/rogueweapon/huntingknife/idagger

/datum/ritual/servantry/darksunmark/invoke(mob/living/user, turf/center)
	var/target_name = input(user, "Who do you wish to die?", "GRAGGAR")
	if(!user.mind || !user.mind.do_i_know(name = target_name))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	var/mob/living/carbon/human/target
	var/assassin_found = FALSE
	for(var/mob/living/carbon/human/HL as anything in GLOB.human_list)
		if(HL.stat == DEAD)
			continue
		if(HL.real_name == target_name)
			target = HL
			continue
		if(HAS_TRAIT(HL, TRAIT_ASSASSIN))
			assassin_found = TRUE
			var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/dagger = locate() in HL.get_all_gear()
			if(dagger)
				to_chat(HL, "profane dagger whispers, <span class='danger'>\"The terrible Zizo has called for our aid. Hunt and strike down our common foe, [target_name]!\"</span>")
	if(!target || !assassin_found)
		to_chat(user, span_warning("There has been no answer to your call to the Dark Sun. It seems his servants are far from here..."))
		return
	target.charflaw = new /datum/charflaw/assassintarget()
	to_chat(user, span_warning("Your target has been marked, your profane call answered by the Dark Sun. [target.real_name] will surely perish!"))
	to_chat(target, span_warningbig("My hair stands on end. Has someone just said my name? I should watch my back."))
	target.playsound_local(target, 'sound/magic/marked.ogg', 100)

// TRANSMUTATION
/datum/ritual/transmutation
	abstract_type = /datum/ritual/transmutation

/datum/ritual/transmutation/allseeingeye
	name = "All-seeing Eye"
	desc = "Create an eye to scry through. Requires a dark crystal."
	is_cultist_ritual = TRUE
	center_requirement = /obj/item/organ/eyes
	n_req = /obj/item/necro_relics/necro_crystal

/datum/ritual/transmutation/allseeingeye/invoke(mob/living/user, turf/center)
	new /obj/item/scrying/eye(center)
	to_chat(user, span_notice("The All-seeing Eye. To see beyond sight."))

/datum/ritual/transmutation/cross
	name = "Summon Amulet of Zizo"
	desc = "Create a Zizo Amulet."
	center_requirement = /obj/item/clothing/neck/roguetown/psicross

/datum/ritual/transmutation/cross/invoke(mob/living/user, turf/center)
	new /obj/item/clothing/neck/roguetown/psicross/inhumen(center)
	to_chat(user, span_notice("The psycross is transmuted into an amulet of Zizo."))

/datum/ritual/transmutation/criminalstool
	name = "Criminal's Tool"
	desc = "Create soap to clean runes with."
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/criminalstool/invoke(mob/living/user, turf/center)
	new /obj/item/soap/cult(center)
	to_chat(user, span_notice("The Criminal's Tool. Could be useful for hiding tracks or getting rid of sigils."))

/obj/item/soap/cult
	name = "accursed soap"
	desc = "It is pulsating."
	color = LIGHT_COLOR_BLOOD_MAGIC

/datum/ritual/transmutation/propaganda
	name = "Remnant Leech"
	desc = "Create a leech that attaches silently onto targets. Used for curses."
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather
	research_cost = 3

/datum/ritual/transmutation/propaganda/invoke(mob/living/user, turf/center)
	new /obj/item/natural/worms/leech/propaganda(center)
	to_chat(user, span_notice("A leech to steal their souls."))

/obj/item/natural/worms/leech/propaganda
	name = "accursed leech"
	desc = "A leech like none other."
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	suppressed = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/propaganda/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	. = ..()
	if(!user)
		return
	if(iscarbon(user))
		var/mob/living/carbon/V = user
		if(prob(5))
			record_round_statistic(STATS_ZIZO_PRAISED)
			V.say(pick( \
				"PRAISE ZIZO!", \
				"DEATH TO THE TEN...", \
				"Astrata will fail!", \
				"The Ten cannot stop me!", \
				"Zizo shows the way!", \
				"The Dark Lady has shown me the truth!", \
				"My life for Zizo...", \
				"Curse your Beast God!", \
				"Noc's magick is nothing to Zizo!", \
				"Abyssor is but a grain of salt!", \
				"Pestra is the most foul of goddesses!", \
				"Ravox's justice is flawed and dull!", \
				"Rip the Sun Tyrant from the sky!", \
				"Xylix is the tongue that must be severed off!", \
				"Cast Malum into the fires of hell!", \
				"The only truth there is lies with the Dark Elves!", \
				"I will defile Necra's dead, a thousand times!", \
				"I will butcher the Ten like Necra butchered Psydon!", \
				"Snuff out the beating hearts of Eora!"))
		V.add_stress(/datum/stressevent/leechcult)

/datum/ritual/transmutation/invademind
	name = "Invade Mind"
	desc = "Send an anonymous message into someone's head."
	center_requirement = /obj/item/natural/feather

/datum/ritual/transmutation/invademind/invoke(mob/living/user, turf/center)
	var/info = input(user, "What shall the message be?", "ZIZO")
	var/target_name = input(user, "To whom do we send this message?", "ZIZO") as null|text
	if(!target_name)
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == target_name)
			to_chat(HL, "<i>You hear a voice in your head... <b>[info]</i></b>")

/datum/ritual/transmutation/summonoutfit
	name = "Summon Cult Outfit"
	desc = "Conjure an ominous outfit that provides some defense."
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/summonoutfit/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/item/clothing/head/roguetown/helmet/skullcap/cult(center)
	new /obj/item/clothing/cloak/half/shadowcloak/cult(center)
	new /obj/item/rope/chain(center)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/obj/item/clothing/head/roguetown/helmet/skullcap/cult
	name = "ominous hood"
	desc = "It echoes with ominous laughter. Worn over a skullcap"
	icon_state = "warlockhood"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

	body_parts_covered = NECK|HAIR|EARS|HEAD

/obj/item/clothing/cloak/half/shadowcloak/cult
	name = "ominous cloak"
	desc = "Those who wear, thy should beware, for those who do; never come back as who they once were again."
	body_parts_covered = ARMS|CHEST

/datum/ritual/transmutation/summonarmor
	name = "Summon Darksteel Armor"
	desc = "Conjure a set of unremovable darksteel plate. Trains you in heavy armor and grants mending. Requires a dark crystal."
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	w_req = /obj/item/ingot/steel
	e_req = /obj/item/ingot/steel

/datum/ritual/transmutation/summonarmor/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
		return
	ADD_TRAIT(target, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	switch(target.aspect)
		if("bite")
			target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
		else
			target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonweapon
	name = "Summon Weapons"
	desc = "Conjure an avantyne blade. Teaches you expert swordsmanship. Requires a dark crystal."
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	s_req = /obj/item/ingot/steel

/datum/ritual/transmutation/summonweapon/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	switch(target.aspect)
		if("bite")
			new /obj/item/rogueweapon/sword/long/zizo(center)
			target.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT)
		else
			new /obj/item/rogueweapon/sword/long/zizo(center)
			target.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING
/datum/ritual/fleshcrafting
	abstract_type = /datum/ritual/fleshcrafting

/datum/ritual/fleshcrafting/bunnylegs
	name = "Saliendo Pedes"
	desc = "Use a pair of legs to permanently increase your jump height."
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg

/datum/ritual/fleshcrafting/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)
	to_chat(target, span_notice("I feel like my legs have become stronger."))

/datum/ritual/fleshcrafting/fleshmend
	name = "Fleshmend"
	desc = "Use a piece of raw meat to heal yourself."
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	center_requirement = /mob/living/carbon/human
	var/heal_tick = 30
	research_cost = 3

/datum/ritual/fleshcrafting/fleshmend/greater
	name = "Greater Fleshmend"
	desc = "Use a piece of raw meat to heal yourself, but better."
	is_cultist_ritual = TRUE
	heal_tick = 70
	research_cost = 7

/datum/ritual/fleshcrafting/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.apply_status_effect(/datum/status_effect/buff/healing, heal_tick, TRUE)
	to_chat(target, span_notice("Zizo empowers me."))

/datum/ritual/fleshcrafting/darkeyes
	name = "Darkened Eyes"
	desc = "Use a pair of eyes to permanently see in the dark."
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/organ/eyes
	e_req = /obj/item/organ/eyes
	research_cost = 3

/datum/ritual/fleshcrafting/darkeyes/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	var/obj/item/organ/eyes/old_eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(old_eyes)
		old_eyes.Remove(target, 1)
		QDEL_NULL(old_eyes)
	var/obj/item/organ/eyes/night_vision/zombie/new_eyes = new
	new_eyes.Insert(target)
	to_chat(target, span_notice("I no longer fear the dark."))

/datum/ritual/fleshcrafting/nopain
	name = "Painless Battle"
	desc = "Use a heart and a brain to become immune to pain. Requires a dark crystal."
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/necro_relics/necro_crystal
	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain

/datum/ritual/fleshcrafting/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	to_chat(target, span_notice("I no longer feel pain."))

/datum/ritual/fleshcrafting/immortality
	name = "Flawed Immortality"
	desc = "Sacrifice an Aasimar to obtain a flawed version of immortality. Not as useful as you might expect."
	center_requirement = /mob/living/carbon/human
	n_req = /mob/living/carbon/human
	research_cost = 10

/datum/ritual/fleshcrafting/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	var/mob/living/carbon/human/victim = locate() in get_step(center, NORTH)
	if(!(is_species(victim, /datum/species/aasimar)))
		to_chat(user, span_danger("The sacrifice must be an Aasimar."))
		return
	victim.set_species(/datum/species/human/northern)
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_EXTREME_TEMPERATURE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_PACIFISM, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	to_chat(target, span_notice("ZIZO EMPOWERS ME!! SOMETHING HAS GONE WRONG, THE RITUAL FAILED BUT WHAT IT LEFT ME WITH IS STILL POWER!!"))
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/regenerate)
	target.change_stat(STATKEY_STR, -3)
	target.change_stat(STATKEY_SPD, -4)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)

/datum/ritual/fleshcrafting/ascend
	name = "ASCEND!"
	desc = "Sacrifice the ruler on the north side, a person with a pure heart on the south side, and have a pair of fellow cultists on the east and west side. Must be performed inside the keep. Keep the ruler on the sigil for 5 minutes to Ascend. Alerts everyone."
	center_requirement = /mob/living/carbon/human
	center_desc = "the cult leader"
	n_req = /mob/living/carbon/human
	n_desc = "the ruler"
	s_req = /mob/living/carbon/human
	s_desc = "one of pure heart"
	e_req = /mob/living/carbon/human
	e_desc = "a cultist"
	w_req = /mob/living/carbon/human
	w_desc = "a cultist"
	is_cultist_ritual = TRUE

/obj/effect/proc_holder/spell/bloodcrawl/ascendant
	recharge_time = 1 MINUTES
	invocations = list("Kri'tha mak!")
	invocation_type = "shout"
	gesture_required = TRUE

/datum/ritual/fleshcrafting/ascend/invoke(mob/living/user, turf/center)
	if(!istype(get_area(center), /area/rogue/indoors/town/manor))
		to_chat(user, span_warning("The ascension must be performed within the keep. The ruler must lie on the north side. A person with a pure heart must lie on the south side. Two fellow cultists must stand on the east and west side."))
		return
	var/mob/living/carbon/human/cultist = locate() in center.contents
	if(!cultist || cultist != user || !is_zizocultist(cultist.mind))
		return
	var/mob/living/carbon/human/RULER = locate() in get_step(center, NORTH)
	if(RULER != SSticker.rulermob)
		to_chat(user, span_warning("The ascension must be performed within the keep. The ruler must lie on the north side. A person with a pure heart must lie on the south side. Two fellow cultists must stand on the east and west side."))
		return
	var/mob/living/carbon/human/cleric = locate() in get_step(center, SOUTH)
	if(!cleric || cleric.purity == FALSE || cleric.stat == DEAD)
		to_chat(user, span_warning("The ascension must be performed within the keep. The ruler must lie on the north side. A person with a pure heart must lie on the south side. Two fellow cultists must stand on the east and west side."))
		return
	var/mob/living/carbon/human/east = locate() in get_step(center, EAST)
	var/mob/living/carbon/human/west = locate() in get_step(center, WEST)
	if(!is_zizo(east) || !is_zizo(west))
		to_chat(user, span_warning("The ascension must be performed within the keep. The ruler must lie on the north side. A person with a pure heart must lie on the south side. Two fellow cultists must stand on the east and west side."))
		return
	cleric.visible_message(span_danger("[cleric] withers and dies!"))
	cleric.death()
	RULER.Unconscious(6 MINUTES)
	priority_announce("Incomprehensible evil arises from within the keep! To arms, the end is near!", title = "ZIZO", sound = 'sound/villain/seen_wonder.ogg')
	var/datum/particle_weather/storm = new /datum/particle_weather/blood_rain_storm
	SSParticleWeather.runningWeather = storm
	storm.start()
	RULER.apply_status_effect(/datum/status_effect/zizo_ascension, cultist)
	to_chat(user, span_boldnotice("The ruler must remain upon the rune for five minutes. Guard them, do not move them from the rune."))

/datum/status_effect/zizo_ascension
	id = "zizo_ascension"
	duration = -1
	tick_interval = 5 SECONDS
	var/mob/living/carbon/human/cultist
	var/elapsed = 0

/datum/status_effect/zizo_ascension/on_creation(mob/living/new_owner, mob/living/carbon/human/leader)
	cultist = leader
	. = ..()

/datum/status_effect/zizo_ascension/tick()
	if(QDELETED(cultist) || cultist.stat == DEAD)
		ascension_fail()
		return
	if(!istype(get_area(owner), /area/rogue/indoors/town/manor))
		ascension_fail()
		return
	if(!(locate(/obj/effect/decal/cleanable/sigil) in get_turf(owner)))
		ascension_fail()
		return
	elapsed += 5
	if(elapsed >= 300)
		zizo_ascend(cultist)
		owner.gib()
		qdel(src)

/datum/status_effect/zizo_ascension/proc/ascension_fail()
	priority_announce("The sky brightens! The ritual is foiled!", title = "PEACE", sound = 'sound/misc/triumph.ogg')
	qdel(src)

/proc/zizo_ascend(mob/living/carbon/human/cultist)
	if(QDELETED(cultist) || !cultist.mind)
		return
	SSmapping.retainer.cult_ascended = TRUE
	to_chat(cultist, span_userdanger("I HAVE DONE IT! I HAVE REACHED A HIGHER FORM! ZIZO SMILES UPON ME WITH MALICE IN HER EYES TOWARD THE ONES WHO LACK KNOWLEDGE AND UNDERSTANDING!"))
	ADD_TRAIT(cultist, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_EXTREME_TEMPERATURE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_INFINITE_ENERGY, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	cultist.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER)
	cultist.change_stat(STATKEY_STR, 10)
	cultist.change_stat(STATKEY_CON, 10)
	cultist.change_stat(STATKEY_WIL, 10)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/cleave)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/ascended_heal)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/true_resurrection)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/self/regenerate)
	if(cultist.head)
		cultist.dropItemToGround(cultist.head, TRUE)
	var/obj/item/clothing/head/roguetown/crown/zizo/crown = new(cultist)
	cultist.equip_to_slot_or_del(crown, SLOT_HEAD)
	ADD_TRAIT(crown, TRAIT_NODROP, TRAIT_GENERIC)
	priority_announce("The sky blackens, a dark day for Grimoria.", title = "Ascension", sound = 'sound/villain/dreamer_win.ogg')
	SSvote.initiate_vote("endround", "ZIZO", null, forced = TRUE)
	for(var/mob/living/carbon/human/V in GLOB.human_list)
		if(V.mind in SSmapping.retainer.cultists)
			V.add_stress(/datum/stressevent/lovezizo)
		else
			V.add_stress(/datum/stressevent/hatezizo)

/obj/item/clothing/head/roguetown/crown/zizo
	name = "Zizo Crown"
	desc = "FOR THE ASCENDANT."
	icon_state = "zcrown"

/obj/effect/proc_holder/spell/targeted/touch/cleave
	name = "Cleave"
	desc = "Kill."
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 15 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/cleave
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/cleave
	name = "reaping hand"
	desc = "Touch a foe to sever their head."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/cleave/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/cleave/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/spelltarget = target
	if(istype(spelltarget.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	to_chat(spelltarget, span_danger("YOU HAVE A TERRIBLE FEELING ABOUT THIS. GET AWAY!"))
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	var/obj/item/bodypart/head/head = spelltarget.get_bodypart("head")
	if(head)
		head.dismember()
	spelltarget.visible_message(span_danger("[user] makes a horizontal cut with their hand and [spelltarget]'s head pops off!"))
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/ascended_heal
	name = "Blessing"
	desc = "Heal."
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 10 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/ascended_heal
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/ascended_heal
	name = "mending hand"
	desc = "Touch someone to heal them."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/ascended_heal/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/ascended_heal/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target))
		return
	var/mob/living/spelltarget = target
	if(spelltarget.stat == DEAD)
		to_chat(user, span_warning("They're dead. Resurrect them."))
		return
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	spelltarget.revive(full_heal = TRUE, admin_revive = TRUE)
	spelltarget.visible_message(span_notice("[user] mends [spelltarget] in a flash of light!"))
	explosion(get_turf(spelltarget), flash_range = 7)
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/true_resurrection
	name = "True Resurrection"
	desc = "Bring them back."
	clothes_req = FALSE
	overlay_state = "gravemark"
	recharge_time = 30 SECONDS
	chargedloop = null
	hand_path = /obj/item/melee/touch_attack/true_resurrection
	cost = 0
	hide_charge_effect = TRUE
	gesture_required = TRUE

/obj/item/melee/touch_attack/true_resurrection
	name = "reviving hand"
	desc = "Touch the dead to bring them back."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/true_resurrection/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/true_resurrection/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target))
		return
	var/mob/living/spelltarget = target
	if(spelltarget.stat != DEAD)
		to_chat(user, span_warning("They still live."))
		return
	if(!do_after(user, 3 SECONDS, target = spelltarget))
		return
	spelltarget.revive(full_heal = TRUE, admin_revive = TRUE)
	ADD_TRAIT(spelltarget, TRAIT_ROTMAN, TRAIT_GENERIC)
	spelltarget.visible_message(span_notice("[user] drags [spelltarget] back from death!"))
	explosion(get_turf(spelltarget), flash_range = 7)
	attached_spell.remove_hand()

/obj/effect/decal/cleanable/sigil
	name = "sigils"
	desc = "Strange runics. They hurt your eyes."
	icon_state = "center"
	icon = 'icons/obj/sigils.dmi'
	var/sigil_type
	var/static/list/sigil_states = list("Portal" = "strand2", "Strand" = "strand", "Toil" = "toil", "Bite" = "bite", "Pitch" = "pitch", "Noise" = "noise", "Blood" = "blood", "Rot" = "rot")

/obj/effect/decal/cleanable/sigil/examine(mob/user)
	. = ..()
	if(!sigil_type)
		return
	if(isliving(user))
		var/mob/living/living_user = user
		if(istype(living_user.patron, /datum/patron/inhumen/zizo))
			to_chat(user, "It is of the [sigil_type] circle.")

/obj/effect/decal/cleanable/sigil/proc/set_sigil_type(newtype)
	sigil_type = newtype
	if(icon_state == "center")
		icon_state = sigil_states[newtype] || "center"
	if(newtype == "Portal")
		GLOB.zizo_portals |= src
		icon_state = "strand2"
		update_icon()

/obj/effect/decal/cleanable/sigil/Destroy()
	GLOB.zizo_portals -= src
	return ..()

/obj/effect/decal/cleanable/sigil/proc/consume_ingredients(datum/ritual/R)
	for(var/atom/A in get_step(src, NORTH))
		if(istype(A, R.n_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)
	for(var/atom/A in get_step(src, SOUTH))
		if(istype(A, R.s_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)
	for(var/atom/A in get_step(src, EAST))
		if(istype(A, R.e_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)
	for(var/atom/A in get_step(src, WEST))
		if(istype(A, R.w_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)
	for(var/atom/A in loc.contents)
		if(istype(A, R.center_requirement) && !ishuman(A))
			if(R.keep_center)
				continue
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

/obj/effect/decal/cleanable/sigil/attack_hand(mob/living/user)
	. = ..()
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(sigil_type == "Portal")
		var/obj/effect/decal/cleanable/sigil/dest
		for(var/obj/effect/decal/cleanable/sigil/S in GLOB.zizo_portals)
			if(S == src)
				continue
			dest = S
			break
		if(!dest)
			to_chat(user, span_warning("Nothing connected."))
			return
		var/turf/T = get_turf(dest)
		for(var/mob/living/L in range(1, src))
			do_teleport(L, T)
		return
	var/list/rituals_pre = list()
	switch(sigil_type)
		if("Transmutation")
			rituals_pre = subtypesof(/datum/ritual/transmutation)
		if("Fleshcrafting")
			rituals_pre = subtypesof(/datum/ritual/fleshcrafting)
		if("Servantry")
			rituals_pre = subtypesof(/datum/ritual/servantry)
		if("Strand")
			rituals_pre = subtypesof(/datum/ritual/strand)
		if("Pitch")
			rituals_pre = subtypesof(/datum/ritual/pitch)
		if("Toil")
			rituals_pre = subtypesof(/datum/ritual/toil)
		if("Bite")
			rituals_pre = subtypesof(/datum/ritual/bite)
		if("Rot")
			rituals_pre = subtypesof(/datum/ritual/rot)
		if("Noise")
			rituals_pre = subtypesof(/datum/ritual/noise)
		if("Blood")
			rituals_pre = subtypesof(/datum/ritual/blood)
	if(!length(rituals_pre))
		return
	var/list/rituals = list()
	for(var/datum/ritual/ritual as anything in rituals_pre)
		if(ritual_available(user, ritual))
			rituals += initial(ritual.name)
	if(!length(rituals))
		to_chat(user, span_warning("I've no clue how to use this."))
		return

	var/ritualnameinput = input(user, "Rituals", "ZIZO") as null|anything in rituals
	if(!ritualnameinput)
		return
	var/datum/ritual/pickritual = LAZYACCESS(GLOB.ritualslist, ritualnameinput)
	if(!pickritual)
		return

	var/cardinal_success = FALSE
	var/center_success = FALSE
	var/dews = 0

	if(pickritual.e_req)
		for(var/atom/A in get_step(src, EAST))
			if(istype(A, pickritual.e_req))
				dews++
				break
	else
		dews++
	if(pickritual.s_req)
		for(var/atom/A in get_step(src, SOUTH))
			if(istype(A, pickritual.s_req))
				dews++
				break
	else
		dews++
	if(pickritual.w_req)
		for(var/atom/A in get_step(src, WEST))
			if(istype(A, pickritual.w_req))
				dews++
				break
	else
		dews++
	if(pickritual.n_req)
		for(var/atom/A in get_step(src, NORTH))
			if(istype(A, pickritual.n_req))
				dews++
				break
	else
		dews++

	if(dews >= 4)
		cardinal_success = TRUE

	for(var/atom/A in loc.contents)
		if(istype(A, pickritual.center_requirement))
			center_success = TRUE
			break

	if(!cardinal_success)
		to_chat(user, span_danger("Ritual requires: [pickritual.hugbox()]"))
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(1, src, 1, SHOCK_NOSTUN)
		return
	if(!center_success)
		to_chat(user, span_danger("Ritual requires: [pickritual.hugbox()]"))
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(1, src, 1, SHOCK_NOSTUN)
		return

	consume_ingredients(pickritual)
	user.playsound_local(user, 'sound/vo/cult/tesa.ogg', 25)
	user.whisper("O'vena tesa...")
	pickritual.invoke(user, loc)

/obj/effect/decal/cleanable/sigil/N
	icon_state = "N"
/obj/effect/decal/cleanable/sigil/NE
	icon_state = "NE"
/obj/effect/decal/cleanable/sigil/E
	icon_state = "E"
/obj/effect/decal/cleanable/sigil/SE
	icon_state = "SE"
/obj/effect/decal/cleanable/sigil/S
	icon_state = "S"
/obj/effect/decal/cleanable/sigil/SW
	icon_state = "SW"
/obj/effect/decal/cleanable/sigil/W
	icon_state = "W"
/obj/effect/decal/cleanable/sigil/NW
	icon_state = "NW"

/turf/open/floor/proc/generateSigils(mob/M, sigiltype)
	var/turf/T = get_turf(M.loc)
	for(var/obj/A in T)
		if(istype(A, /obj/effect/decal/cleanable/sigil))
			to_chat(M, span_warning("There is already a sigil here."))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(M, span_warning("There is already something here."))
			return
	var/isblood = FALSE
	var/draw_time = 5 SECONDS
	if(HAS_TRAIT(M, TRAIT_BLOODBOUND))
		draw_time = 1 SECONDS
	if(do_after(M, draw_time))
		if(!isblood)
			M.bloody_hands--
			M.update_inv_gloves()
		var/obj/effect/decal/cleanable/sigil/C = new(src)
		C.set_sigil_type(sigiltype)
		playsound(M, 'sound/items/write.ogg', 100)
		var/list/sigilsPath = list(
			/obj/effect/decal/cleanable/sigil/N,
			/obj/effect/decal/cleanable/sigil/S,
			/obj/effect/decal/cleanable/sigil/E,
			/obj/effect/decal/cleanable/sigil/W,
			/obj/effect/decal/cleanable/sigil/NE,
			/obj/effect/decal/cleanable/sigil/NW,
			/obj/effect/decal/cleanable/sigil/SE,
			/obj/effect/decal/cleanable/sigil/SW
		)
		for(var/i = 1; i <= GLOB.alldirs.len; i++)
			var/turf/floor = get_step(src, GLOB.alldirs[i])
			var/sigil = sigilsPath[i]
			new sigil(floor)

/mob/living/carbon/human/proc/draw_sigil()
	set name = "Draw Sigil"
	set category = "ZIZO"
	if(incapacitated() || stat >= UNCONSCIOUS)
		return
	if(!HAS_TRAIT(src, TRAIT_BLOODBOUND) && !bloody_hands && !get_bleed_rate())
		to_chat(src, span_danger("My hands aren't bloody enough."))
		return
	var/static/list/cats = list("Servantry" = /datum/ritual/servantry, "Transmutation" = /datum/ritual/transmutation, "Fleshcrafting" = /datum/ritual/fleshcrafting, "Strand" = /datum/ritual/strand, "Pitch" = /datum/ritual/pitch, "Toil" = /datum/ritual/toil, "Bite" = /datum/ritual/bite, "Rot" = /datum/ritual/rot, "Blood" = /datum/ritual/blood, "Noise" = /datum/ritual/noise)
	var/list/runes = list()
	for(var/cat in cats)
		for(var/datum/ritual/ritual as anything in subtypesof(cats[cat]))
			if(ritual_available(src, ritual))
				runes += cat
				break
	if(!runes.len)
		to_chat(src, span_warning("I know no rites."))
		return
	var/choice = input("Sigil Type", "ZIZO") as null|anything in runes
	if(!choice)
		return
	var/turf/open/floor/T = get_turf(src)
	if(istype(T))
		T.generateSigils(src, choice)

/obj/effect/proc_holder/spell/self/regenerate // This is an aheal spell designed for the zizoid immortal abomination
	name = "Regenerate"
	desc = "Your wounds painfully mend back together."
	overlay_state = "bloodrage"
	sound = 'sound/misc/vampirespell.ogg'

	antimagic_allowed = TRUE
	ignore_cockblock = TRUE

	recharge_time = 3 MINUTES

/obj/effect/proc_holder/spell/self/regenerate/cast(mob/living/user = usr)
	. = ..()
	user.emote("agony", forced = TRUE)
	user.revive(full_heal = TRUE, admin_revive = TRUE)
	user.visible_message(span_notice("[user]'s body painfully contorts itself back together"))
