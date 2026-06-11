/datum/reagent/consumable/ethanol/beer/emberwine
	name = "余烬酒"
	boozepwr = 20
	taste_description = "灼热的甜味"
	taste_mult = 0.5
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.02 * REAGENTS_METABOLISM
	overdose_threshold = 18
	addiction_threshold = 12 //Three sips, or a full goblet if properly mixed with two other reagents to hide the taste.
	addiction_permanent = TRUE
	color = "#721a46"

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_metabolize(mob/living/carbon/human/C)
	if(C?.patron && istype(C.patron, /datum/patron/inhumen/baotha))
		overdose_threshold = 0
	else
		overdose_threshold = initial(overdose_threshold)
	..()
	if(!C?.client?.prefs?.sexable)
		volume = 0
		return
	C.sexcon.aphrodisiac += 1

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_end_metabolize(mob/living/carbon/human/C)
	C.sexcon.aphrodisiac -= 1
	..()

/datum/reagent/consumable/ethanol/beer/emberwine/on_mob_life(mob/living/carbon/human/C)
	var/datum/sex_controller/S = C.sexcon
	var/high_message = pick("我的胃里一阵灼热。", "我的皮肤触碰起来有些发麻。", "我的下体不由自主地抽动着。", "我的心跳变得紊乱。", "我感觉冷汗顺着脖颈滑落。")
	switch(current_cycle)
		if(0 to 19)
			current_cycle++
			return //Dormant
		if(20)
			to_chat(C, "<span class='aphrodisiac'>我感觉一股温热的暖流正在胃里蔓延。</span>")
		if(21 to 25)
			S.adjust_arousal(5)
		if(26 to INFINITY)
			C.apply_status_effect(/datum/status_effect/debuff/emberwine)
			if(S.arousal_frozen)
				S.arousal_frozen = FALSE
			if(S.arousal < 51)
				S.set_arousal(55) //Just enough to be above the frustration threshold.
			if(prob(8))
				C.emote("sexmoanlight", forced = TRUE)
				to_chat(C, "<span class='love_high'>[high_message]</span>")
				if(istype(C.wear_armor, /obj/item/clothing))
					var/obj/item/clothing/CL = C.wear_armor
					switch(CL.armor_class)
						if(3)
							C.Immobilize(30)
							C.set_blurriness(5)
							to_chat(C, "<span class='warning'>护甲不适地磨蹭着我的皮肤，让我呼吸都变得困难。</span>")
						if(2)
							C.Immobilize(15)
							C.set_blurriness(2)
							to_chat(C, "<span class='warning'>护甲不适地磨蹭着我的皮肤。</span>")
			S.adjust_charge(8)
	return ..()

/datum/reagent/consumable/ethanol/beer/emberwine/overdose_start(mob/living/carbon/human/C)
	if(current_cycle < 20)
		current_cycle = 20
		to_chat(C, "<span class='aphrodisiac'>我感觉一股温热的暖流正在胃里蔓延。</span>")
		sleep(10)
	to_chat(C, "<span class='aphrodisiac'>胃里的热流迅速扩散，直冲上脑，让我的脸都热了起来。</span>")
	metabolization_rate = 0.2 //Purges faster while overdosing because this is really debilitating
	C.emote("sexmoanhvy", forced = TRUE)
	C.sexcon.aphrodisiac += 1
	C.Jitter(20)
	C.Stun(15)

/datum/reagent/consumable/ethanol/beer/emberwine/overdose_process(mob/living/carbon/human/C)
	if(prob(5))
		C.emote("sexmoanhvy", forced = TRUE)
		C.Stun(15)
		C.set_blurriness(5)

/datum/reagent/consumable/ethanol/beer/emberwine/addiction_act_stage3(mob/living/carbon/human/C)
	if(prob(20))
		to_chat(C, span_danger("我对[name]生出了强烈的渴求。"))
		C.sexcon.adjust_arousal(5)
	if(istype(C, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = C
		if(!istype(H.charflaw, /datum/charflaw/addiction/lovefiend))
			H.charflaw = new /datum/charflaw/addiction/lovefiend(H)
	return

/datum/reagent/consumable/ethanol/beer/emberwine/addiction_act_stage4(mob/living/carbon/human/C)
	var/datum/sex_controller/S = C.sexcon
	if(!S.arousal_frozen)
		S.arousal_frozen = TRUE
	C.sexcon.arousal = 40
	if(S.aphrodisiac < 1.5)
		S.aphrodisiac = 1.5
	if(prob(10))
		to_chat(C, span_boldannounce("下体的感觉已经化作隐隐的酸胀。唯有更多[name]才能止住这股瘙痒……"))
	return

/datum/reagent/erpjuice
	name = "情欲液"
	reagent_state = LIQUID
	color = "#ebebeb"
	metabolization_rate = 0.1

/datum/reagent/erpjuice/on_mob_life(mob/living/carbon/M) //Rejoice, cum whores can now very inefficiently drink cum to substain themselves.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(1)
		H.adjust_nutrition(0.5) //Semen is not very nutritious. The player can go about 3 rounds of cumming before needing to wait a long time code-wise to cum more.
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()

/datum/reagent/erpjuice/cum
	description = "一种在高潮时分泌出的浓稠、黏滑、近似乳脂的液体。"
	taste_description = "咸涩微酸"

/datum/reagent/erpjuice/femcum
	description = "一种略带乳白的液体，质地稀薄而水润。"
	taste_description = "微甜且带着矿物味"
