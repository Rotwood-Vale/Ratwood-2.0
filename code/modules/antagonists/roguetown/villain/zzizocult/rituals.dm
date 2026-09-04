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
	if(initial(ritual.is_cultist_ritual) && !is_zizo(user))
		return FALSE
	if(initial(ritual.required_aspect) && initial(ritual.required_aspect) != user.aspect)
		return FALSE
	if(initial(ritual.needs_aspect) && !user.aspect)
		return FALSE
	return TRUE

/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	var/center_requirement
	var/n_req
	var/e_req
	var/s_req
	var/w_req
	var/is_cultist_ritual = FALSE
	var/required_aspect
	var/needs_aspect = FALSE
	var/keep_center = FALSE

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	return

/datum/ritual/proc/hugbox()
	var/list/parts = list()
	var/atom/req
	if(center_requirement)
		req = center_requirement
		parts += "Center - [initial(req.name)]"
	if(n_req)
		req = n_req
		parts += "North - [initial(req.name)]"
	if(e_req)
		req = e_req
		parts += "East - [initial(req.name)]"
	if(s_req)
		req = s_req
		parts += "South - [initial(req.name)]"
	if(w_req)
		req = w_req
		parts += "West - [initial(req.name)]"
	return jointext(parts, ", ")

// SERVANTRY
/datum/ritual/servantry
	abstract_type = /datum/ritual/servantry

/datum/ritual/servantry/convert
	name = "Convert"
	center_requirement = /mob/living/carbon/human
	is_cultist_ritual = TRUE

/datum/ritual/servantry/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target == user)
		return
	if(is_zizocultist(target.mind) || is_zizolackey(target.mind))
		return
	if(!target.client)
		return
	if(istype(target.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
	var/alert = tgui_alert(target, "YOU WILL BE SHOWN THE TRUTH. DO YOU RESIST?", "???", list("Yield", "Resist"))
	target.Immobilize(3 SECONDS)
	if(alert == "Yield")
		to_chat(target, span_notice("I see the truth now! It all makes so much sense! They aren't HERETICS! They want the BEST FOR US!"))
		PR.add_cultist(target.mind)
		target.praise()
	else
		target.visible_message(span_danger("[target] thrashes around, unyielding!"))
		if(!absorb_lux(target, get_turf(target)))
			to_chat(user, span_warning("[target] has no lux left to give."))
		else
			to_chat(user, span_notice("The lux is torn from [target] and bound into a dark crystal."))

/datum/ritual/servantry/sacrifice
	name = "Sacrifice"
	center_requirement = /mob/living/carbon/human

/datum/ritual/servantry/sacrifice/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target || target == user)
		return
	if(!absorb_lux(target, center))
		to_chat(user, span_warning("[target] has no lux left to give."))
		return
	to_chat(user, span_notice("The lux is torn from [target] and bound into a dark crystal."))

/datum/ritual/servantry/heartache
	name = "Heartaches"
	center_requirement = /obj/item/organ/heart

/datum/ritual/servantry/heartache/invoke(mob/user, turf/center)
	new /obj/item/corruptedheart(center)
	to_chat(user, span_notice("A corrupted heart. When used on a non-enlightened mortal their heart shall ache and they will be immobilized and too stunned to speak. Perfect for getting new soon-to-be enlightened. Now, just don't use it at the combat ready."))

/obj/item/corruptedheart
	name = "corrupted heart"
	desc = "It sparkles with forbidden magic energy. It makes all the heart aches go away."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/corruptedheart/attack(mob/living/target, mob/living/user, list/modifiers)
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(istype(target.patron, /datum/patron/inhumen/zizo) && target.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		target.set_blood_volume(BLOOD_VOLUME_NORMAL)
		to_chat(target, span_notice("My elixir of life is stagnant once again."))
		qdel(src)
		return
	if(!do_after(user, 2 SECONDS, target))
		return
	if(target.cmode)
		user.electrocute_act(30)
	target.Stun(10 SECONDS)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.adjust_silence(30 SECONDS)
	qdel(src)

/datum/ritual/servantry/darksunmark
	name = "Dark Sun's Mark"
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
	is_cultist_ritual = TRUE
	center_requirement = /obj/item/organ/eyes

/datum/ritual/transmutation/allseeingeye/invoke(mob/living/user, turf/center)
	new /obj/item/scrying/eye(center)
	to_chat(user, span_notice("The All-seeing Eye. To see beyond sight."))

/datum/ritual/transmutation/cross
	name = "Summon Amulet of Zizo"
	center_requirement = /obj/item/clothing/neck/roguetown/psicross

/datum/ritual/transmutation/cross/invoke(mob/living/user, turf/center)
	new /obj/item/clothing/neck/roguetown/psicross/inhumen(center)
	to_chat(user, span_notice("The psycross is transmuted into an amulet of Zizo."))

/datum/ritual/transmutation/criminalstool
	name = "Criminal's Tool"
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
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather

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
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/ingot/steel
	s_req = /obj/item/ingot/steel
	is_cultist_ritual = TRUE

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
	target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonweapon
	name = "Summon Weapons"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/ingot/steel
	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonweapon/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/item/rogueweapon/sword/long/zizo(center)
	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING
/datum/ritual/fleshcrafting
	abstract_type = /datum/ritual/fleshcrafting

/datum/ritual/fleshcrafting/gutted
	name = "Gutted Fish"
	center_requirement = /mob/living/carbon/human // One to be gutted.human
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/gutted/invoke(mob/living/user, turf/center)
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

/datum/ritual/fleshcrafting/bunnylegs
	name = "Saliendo Pedes"
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg
	is_cultist_ritual = TRUE
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)
	to_chat(target, span_notice("I feel like my legs have become stronger."))

/datum/ritual/fleshcrafting/fleshmend
	name = "Fleshmend"
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	center_requirement = /mob/living/carbon/human
	var/heal_tick = 30
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/fleshmend/greater
	name = "Greater Fleshmend"
	is_cultist_ritual = TRUE
	heal_tick = 70
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.apply_status_effect(/datum/status_effect/buff/healing, heal_tick, TRUE)
	to_chat(target, span_notice("Zizo empowers me."))

/datum/ritual/fleshcrafting/darkeyes
	name = "Darkened Eyes"
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/organ/eyes
	e_req = /obj/item/organ/eyes
	needs_aspect = TRUE

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
	center_requirement = /mob/living/carbon/human
	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	to_chat(target, span_notice("I no longer feel pain, but it has come at a terrible cost."))
	target.change_stat(STATKEY_STR, -2)
	target.change_stat(STATKEY_CON, -3)

/datum/ritual/fleshcrafting/immortality
	name = "Flawed Immortality"
	center_requirement = /mob/living/carbon/human
	n_req = /mob/living/carbon/human
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	var/mob/living/carbon/human/victim = locate() in get_step(center, NORTH)
	if(!(is_species(victim, /datum/species/aasimar)))
		to_chat(user, span_danger("The sacrifice must be an Aasimar."))
		return
	victim.set_species(/datum/species/human/northern)
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_PACIFISM, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
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
	center_requirement = /mob/living/carbon/human // cult leader
	n_req = /mob/living/carbon/human // the ruler
	is_cultist_ritual = TRUE
	needs_aspect = TRUE

/datum/ritual/fleshcrafting/ascend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/cultist = locate() in center.contents
	if(!cultist || cultist != user)
		return
	if(!is_zizocultist(cultist.mind))
		return
	var/mob/living/carbon/human/RULER = locate() in get_step(center, NORTH)
	if(RULER != SSticker.rulermob && RULER.stat != DEAD)
		to_chat(user, span_danger("The sacrifice must be the ruler of this realm."))
		return
	RULER.gib()
	SSmapping.retainer.cult_ascended = TRUE
	to_chat(cultist, span_userdanger("I HAVE DONE IT! I HAVE REACHED A HIGHER FORM! ZIZO SMILES UPON ME WITH MALICE IN HER EYES TOWARD THE ONES WHO LACK KNOWLEDGE AND UNDERSTANDING!"))
	ADD_TRAIT(cultist, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
	ADD_TRAIT(cultist, TRAIT_NOFIRE, TRAIT_GENERIC)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/cleave)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/ascended_heal)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/true_resurrection)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/self/regenerate)
	cultist.mind.AddSpell(new /obj/effect/proc_holder/spell/bloodcrawl)
	if(cultist.head)
		cultist.dropItemToGround(cultist.head, TRUE)
	var/obj/item/clothing/head/roguetown/crown/zizo/crown = new(cultist)
	cultist.equip_to_slot_or_del(crown, SLOT_HEAD)
	ADD_TRAIT(crown, TRAIT_NODROP, TRAIT_GENERIC)
	priority_announce("The sky blackens, a dark day for Grimoria.", "Ascension")
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

/obj/item/melee/touch_attack/cleave
	name = "reaping hand"
	desc = "Touch a foe to sever their head."
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#8a13bd"

/obj/item/melee/touch_attack/cleave/attack_self()
	attached_spell.remove_hand()

/obj/item/melee/touch_attack/cleave/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!isliving(target))
		return
	var/mob/living/spelltarget = target
	if(!do_after(user, 2 SECONDS, target = spelltarget))
		return
	if(ishuman(spelltarget))
		var/mob/living/carbon/human/H = spelltarget
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
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
	if(!do_after(user, 2 SECONDS, target = spelltarget))
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
	if(!do_after(user, 2 SECONDS, target = spelltarget))
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
	var/static/list/sigil_states = list("Strand" = "strand")

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
		update_icon()

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
	if(sigil_type == "Strand")
		var/obj/effect/decal/cleanable/sigil/dest
		for(var/obj/effect/decal/cleanable/sigil/S in world)
			if(S == src || S.sigil_type != "Strand")
				continue
			dest = S
			break
		if(!dest)
			to_chat(user, span_warning("Nothing connected."))
			return
		do_teleport(user, get_turf(dest))
		return
	if(icon_state != "center")
		return
	var/list/rituals_pre = list()
	switch(sigil_type)
		if("Transmutation")
			rituals_pre = subtypesof(/datum/ritual/transmutation)
		if("Fleshcrafting")
			rituals_pre = subtypesof(/datum/ritual/fleshcrafting)
		if("Servantry")
			rituals_pre = subtypesof(/datum/ritual/servantry)
	if(!length(rituals_pre))
		return
	var/list/rituals = list()
	for(var/datum/ritual/ritual as anything in rituals_pre)
		if(ritual_available(user, ritual))
			rituals += initial(ritual.name)

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
		user.electrocute_act(10, src)
		return
	if(!center_success)
		to_chat(user, span_danger("Ritual requires: [pickritual.hugbox()]"))
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(10, src)
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
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		isblood = (H.aspect == "blood")
	var/draw_time = 5 SECONDS
	if(isblood)
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
	if(aspect != "blood" && !bloody_hands && !get_bleed_rate())
		to_chat(src, span_danger("My hands aren't bloody enough."))
		return
	var/static/list/cats = list("Servantry" = /datum/ritual/servantry, "Transmutation" = /datum/ritual/transmutation, "Fleshcrafting" = /datum/ritual/fleshcrafting)
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

	recharge_time = 1 MINUTES

/obj/effect/proc_holder/spell/self/regenerate/cast(mob/living/user = usr)
	. = ..()
	user.emote("agony", forced = TRUE)
	user.revive(full_heal = TRUE, admin_revive = TRUE)
	user.visible_message(span_notice("[user]'s body painfully contorts itself back together"))
