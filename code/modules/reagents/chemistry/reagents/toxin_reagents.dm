
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "毒素"
	description = "一种有毒化学物质。"
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "苦味"
	taste_mult = 1.2
	harmful = TRUE
	var/toxpwr = 1.5
	var/silent_toxin = FALSE //won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present.

/datum/reagent/toxin/on_mob_life(mob/living/carbon/M)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM, 0)
	return ..()

/datum/reagent/toxin/amatoxin
	name = "鹅膏毒素"
	description = "一种从特定蘑菇中提取出的强效毒药。"
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "蘑菇味"

/datum/reagent/toxin/mutagen
	name = "不稳定诱变剂"
	description = "可能引发无法预测的突变。请远离儿童。"
	color = "#00FF00"
	toxpwr = 0
	taste_description = "史莱姆味"
	taste_mult = 0.9

/datum/reagent/toxin/mutagen/reaction_mob(mob/living/carbon/M, method=TOUCH, reac_volume)
	if(!..())
		return
	if(!M.has_dna())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	if((method==VAPOR && prob(min(33, reac_volume))) || method==INGEST || method==PATCH || method==INJECT)
		M.randmuti()
		M.updateappearance()
		M.domutcheck()
	..()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/C)
	C.apply_effect(5,EFFECT_IRRADIATE,0)
	return ..()

#define	LIQUID_PLASMA_BP (50+T0C)

/datum/reagent/toxin/plasma
	name = "等离子体"
	description = "液态的等离子体。"
	taste_description = "苦味"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3

/datum/reagent/toxin/plasma/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 5)
		return
	..()

/datum/reagent/toxin/lexorin
	name = "勒克索林"
	description = "一种用于阻断呼吸的强效毒药。"
	color = "#7DC3A0"
	toxpwr = 0
	taste_description = "酸味"

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/carbon/C)
	. = TRUE

	if(HAS_TRAIT(C, TRAIT_NOBREATH))
		. = FALSE

	if(.)
		C.adjustOxyLoss(5, 0)
		C.losebreath += 2
		if(prob(20))
			C.emote("breathgasp")
	..()

/datum/reagent/toxin/slimejelly
	name = "史莱姆胶"
	description = "一种由世上最致命的生命形态之一分泌出的黏稠半流体。真的很真。"
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0
	taste_description = "史莱姆味"
	taste_mult = 1.3

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		to_chat(M, span_danger("我的五脏六腑都在燃烧！"))
		M.adjustToxLoss(rand(20,60)*REM, 0)
		. = 1
	else if(prob(40))
		M.heal_bodypart_damage(5*REM)
		. = 1
	..()

/datum/reagent/toxin/minttoxin
	name = "薄荷毒素"
	description = "非常适合拿来对付不受欢迎的顾客。"
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0
	taste_description = "薄荷味"

/datum/reagent/toxin/minttoxin/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_FAT))
		M.inflate_gib()
	return ..()

/datum/reagent/toxin/carpotoxin
	name = "鲤毒素"
	description = "由可怕的太空鲤鱼分泌出的致命神经毒素。"
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2
	taste_description = "鱼腥味"

/datum/reagent/toxin/zombiepowder
	name = "僵尸粉"
	description = "一种会让目标陷入假死状态的强效神经毒素。"
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "死亡气息"
	var/fakedeath_active = FALSE

/datum/reagent/toxin/zombiepowder/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FAKEDEATH, type)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/L)
	L.cure_fakedeath(type)
	..()

/datum/reagent/toxin/zombiepowder/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	L.adjustOxyLoss(0.5*REM, 0)
	if(method == INGEST)
		fakedeath_active = TRUE
		L.fakedeath(type)

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/M)
	..()
	if(fakedeath_active)
		return TRUE
	switch(current_cycle)
		if(1 to 5)
			M.confused += 1
			M.drowsyness += 1
			M.slurring += 3
		if(5 to 8)
			M.adjustStaminaLoss(40, 0)
		if(9 to INFINITY)
			fakedeath_active = TRUE
			M.fakedeath(type)

/datum/reagent/toxin/ghoulpowder
	name = "食尸鬼粉"
	description = "一种强效神经毒素，会把代谢减缓到近似死亡的程度，却让患者仍然保持活动；使用过久会累积毒性。"
	reagent_state = SOLID
	color = "#664700" // rgb: 102, 71, 0
	toxpwr = 0.8
	taste_description = "死亡气息"

/datum/reagent/toxin/ghoulpowder/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FAKEDEATH, type)

/datum/reagent/toxin/ghoulpowder/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FAKEDEATH, type)
	..()

/datum/reagent/toxin/ghoulpowder/on_mob_life(mob/living/carbon/M)
	M.adjustOxyLoss(1*REM, 0)
	..()
	. = 1

/datum/reagent/toxin/mindbreaker
	name = "碎心毒素"
	description = "一种强效致幻剂，绝不是能随便乱碰的东西；对某些精神病患而言，它反而能抵消症状并把他们拉回现实。"
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "酸味"

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/M)
	M.hallucination += 5
	return ..()

/datum/reagent/toxin/plantbgone
	name = "植物去无踪"
	description = "一种用于杀死植物的有害毒性混合物。请勿入口！"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1

/datum/reagent/toxin/plantbgone/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O, /obj/structure/vine))
		var/obj/structure/vine/SV = O
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				var/damage = min(round(0.4*reac_volume, 0.1),10)
				C.adjustToxLoss(damage)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "除草剂"
	description = "一种用于杀死杂草的有害毒性混合物。请勿入口！"
	color = "#4B004B" // rgb: 75, 0, 75

/datum/reagent/toxin/pestkiller
	name = "杀虫剂"
	description = "一种用于杀死害虫的有害毒性混合物。请勿入口！"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1

/datum/reagent/toxin/pestkiller/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	..()
	if(M.mob_biotypes & MOB_BUG)
		var/damage = min(round(0.4*reac_volume, 0.1),10)
		M.adjustToxLoss(damage)

/datum/reagent/toxin/spore
	name = "孢子毒素"
	description = "由团块孢子自然产生的毒素，入口后会抑制视觉。"
	color = "#9ACD32"
	toxpwr = 1

/datum/reagent/toxin/spore/on_mob_life(mob/living/carbon/C)
	C.damageoverlaytemp = 60
	C.update_damage_hud()
	C.blur_eyes(3)
	return ..()

/datum/reagent/toxin/spore_burning
	name = "燃烧孢子毒素"
	description = "由团块孢子自然产生的毒素，会让受害者自燃。"
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "灼烧感"

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/carbon/M)
	M.adjust_fire_stacks(2)
	M.ignite_mob()
	return ..()

/datum/reagent/toxin/chloralhydrate
	name = "水合氯醛"
	description = "一种强效镇静剂，会先让目标陷入混乱与困倦，随后沉沉睡去。"
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/carbon/M)
	switch(current_cycle)
		if(1 to 10)
			M.confused += 2
			M.drowsyness += 2
		if(10 to 50)
			M.Sleeping(40, 0)
			. = 1
		if(51 to INFINITY)
			M.Sleeping(40, 0)
			M.adjustToxLoss((current_cycle - 50)*REM, 0)
			. = 1
	..()

/datum/reagent/toxin/fakebeer	//disguised as normal beer for use by emagged brobots
	name = "啤酒"
	description = "一种伪装成啤酒的特制镇静剂，会让目标立刻睡着。"
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "尿骚水"
	glass_icon_state = "beerglass"
	glass_name = "一杯啤酒"
	glass_desc = ""

/datum/reagent/toxin/fakebeer/on_mob_life(mob/living/carbon/M)
	switch(current_cycle)
		if(1 to 50)
			M.Sleeping(40, 0)
		if(51 to INFINITY)
			M.Sleeping(40, 0)
			M.adjustToxLoss((current_cycle - 50)*REM, 0)
	return ..()

/datum/reagent/toxin/coffeepowder
	name = "咖啡粉"
	description = "磨得极细的咖啡豆粉末，用来冲泡咖啡。"
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

/datum/reagent/toxin/teapowder
	name = "茶末"
	description = "切得很细的茶叶碎，用于泡茶。"
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "绿茶味"

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "缄默毒素"
	description = "一种不会致命、但会抑制受害者说话能力的毒药。"
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "寂静"

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/M)
	M.silent = max(M.silent, 3)
	..()

/datum/reagent/toxin/histamine
	name = "组胺"
	description = "组胺的效果会随着剂量增加而越发危险，从轻微烦人一路升级到极其致命。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0

/datum/reagent/toxin/histamine/on_mob_life(mob/living/carbon/M)
	if(prob(50))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(M, span_danger("我几乎什么都看不清了！"))
				M.blur_eyes(3)
			if(2)
				M.emote("cough")
			if(3)
				M.emote("sneeze")
			if(4)
				if(prob(75))
					to_chat(M, span_danger("我忍不住去抓痒。"))
					M.adjustBruteLoss(2*REM, 0)
					. = 1
	..()

/datum/reagent/toxin/histamine/overdose_process(mob/living/M)
	M.adjustOxyLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, FALSE, FALSE, BODYPART_ORGANIC)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/toxin/formaldehyde
	name = "甲醛"
	description = "甲醛本身算是比较弱的毒素；其中含有微量组胺，因此极少数情况下会分解成组胺。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5,15))
		holder.remove_reagent(/datum/reagent/toxin/formaldehyde, 1.2)
	else
		return ..()

/datum/reagent/toxin/venom
	name = "毒液"
	description = "一种从剧毒生物体内提取出的异域毒药，会随剂量增加造成更多毒伤与瘀伤，并常会分解为组胺。"
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/M)
	toxpwr = 0.2*volume
//	M.adjustBruteLoss((0.3*volume)*REM, 0)
	. = 1
//	if(prob(15))
//		M.reagents.add_reagent(/datum/reagent/toxin/histamine, pick(5,10))
//		M.reagents.remove_reagent(/datum/reagent/toxin/venom, 1.1)
//	else
//		..()
	..()

/datum/reagent/toxin/fentanyl
	name = "芬太尼"
	description = "芬太尼会抑制脑功能并造成毒素伤害，最终让受害者失去意识。"
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3*REM, 150)
	if(M.toxloss <= 60)
		M.adjustToxLoss(1*REM, 0)
	if(current_cycle >= 18)
		M.Sleeping(40, 0)
	..()
	return TRUE

/datum/reagent/toxin/cyanide
	name = "氰化物"
	description = "一种因常被用于暗杀而臭名昭著的毒药，会造成少量毒伤，并有小概率带来缺氧伤害或眩晕。"
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolization_rate = 0.1
	toxpwr = 0

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/carbon/M)
	testing("toxin OML")
	M.add_nausea(20)
	M.adjustToxLoss(3, 0)
	return ..()

/datum/reagent/toxin/bad_food
	name = "劣质食物"
	description = "某种烹饪灾难的产物，难吃到已经带毒了。"
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "糟糕厨艺"

/datum/reagent/toxin/itching_powder
	name = "瘙痒粉"
	description = "一种接触皮肤后会引发瘙痒的粉末，会让受害者不停抓挠，并有极低概率分解成组胺。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/itching_powder/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.reagents?.add_reagent(/datum/reagent/toxin/itching_powder, reac_volume)

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/carbon/M)
	if(prob(15))
		to_chat(M, span_danger("我抓挠起自己的头。"))
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(15))
		to_chat(M, span_danger("我抓挠起自己的腿。"))
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(15))
		to_chat(M, span_danger("我抓挠起自己的手臂。"))
		M.adjustBruteLoss(0.2*REM, 0)
		. = 1
	if(prob(3))
		M.reagents.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		M.reagents.remove_reagent(/datum/reagent/toxin/itching_powder,1.2)
		return
	..()

/datum/reagent/toxin/initropidril
	name = "伊尼托匹德利尔"
	description = "一种效果阴险的强力毒药，能导致眩晕、致命性呼吸衰竭与心搏骤停。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/carbon/C)
	if(prob(25))
		var/picked_option = rand(1,3)
		switch(picked_option)
			if(1)
				C.Paralyze(60, 0)
				. = TRUE
			if(2)
				C.losebreath += 10
				C.adjustOxyLoss(rand(5,25), 0)
				. = TRUE
			if(3)
				if(!C.undergoing_cardiac_arrest() && C.can_heartattack())
					C.set_heartattack(TRUE)
					if(C.stat == CONSCIOUS)
						C.visible_message(span_danger("[C]捂住了[C.p_their()]的胸口，仿佛[C.p_their()]的心脏停跳了一样！"))
				else
					C.losebreath += 10
					C.adjustOxyLoss(rand(5,25), 0)
					. = TRUE
	return ..() || .

/datum/reagent/toxin/pancuronium
	name = "泮库溴铵"
	description = "一种难以察觉的毒素，会迅速使受害者失去行动能力，也可能引发呼吸衰竭。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/carbon/M)
	if(current_cycle >= 10)
		M.Stun(40, 0)
		. = TRUE
	if(prob(20))
		M.losebreath += 4
	..()

/datum/reagent/toxin/sodium_thiopental
	name = "硫喷妥钠"
	description = "硫喷妥钠会让目标极度虚弱并陷入昏迷。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#6496FA"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/carbon/M)
	if(current_cycle >= 10)
		M.Sleeping(40, 0)
	M.adjustStaminaLoss(10*REM, 0)
	..()
	return TRUE

/datum/reagent/toxin/sulfonal
	name = "磺醛"
	description = "一种隐蔽毒药，会造成轻微毒伤，并最终让目标睡着。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/carbon/M)
	if(current_cycle >= 22)
		M.Sleeping(40, 0)
	return ..()

/datum/reagent/toxin/amanitin
	name = "鹅膏蕈素"
	description = "一种极强的延时毒素；彻底代谢时，会根据它在受害者血液中停留的时间造成巨量毒素伤害。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/M)
	var/toxdamage = current_cycle*3*REM
	M.log_message("has taken [toxdamage] toxin damage from amanitin toxin", LOG_ATTACK)
	M.adjustToxLoss(toxdamage)
	..()

/datum/reagent/toxin/lipolicide
	name = "溶脂毒素"
	description = "一种会摧毁脂肪细胞的强力毒素，能在短时间内大幅减轻体重；对体内缺乏营养的人尤其致命。"
	silent_toxin = TRUE
	taste_description = "樟脑丸味"
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/carbon/M)
	if(M.nutrition <= NUTRITION_LEVEL_STARVING)
		M.adjustToxLoss(1*REM, 0)
	M.adjust_nutrition(-3) // making the chef more valuable, one meme trap at a time
	M.overeatduration = 0
	return ..()

/datum/reagent/toxin/coniine
	name = "毒芹碱"
	description = "毒芹碱代谢极慢，却会造成大量毒伤并让呼吸停止。"
	reagent_state = LIQUID
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75

/datum/reagent/toxin/coniine/on_mob_life(mob/living/carbon/M)
	M.losebreath += 5
	return ..()

/datum/reagent/toxin/spewium
	name = "喷吐剂"
	description = "一种强效催吐剂，会引发无法控制的呕吐；高剂量时甚至可能把器官都吐出来。"
	reagent_state = LIQUID
	color = "#2f6617" //A sickly green color
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 29
	toxpwr = 0
	taste_description = "呕吐物味"

/datum/reagent/toxin/spewium/on_mob_life(mob/living/carbon/C)
	.=..()
	if(current_cycle >=11 && prob(min(50,current_cycle)))
		C.vomit(10, prob(10), prob(50), rand(0,4), TRUE, prob(30))
		for(var/datum/reagent/toxin/R in C.reagents.reagent_list)
			if(R != src)
				C.reagents.remove_reagent(R.type,1)

/datum/reagent/toxin/spewium/overdose_process(mob/living/carbon/C)
	. = ..()
	if(current_cycle >=33 && prob(15))
		C.spew_organ()
		C.vomit(0, TRUE, TRUE, 4)
		to_chat(C, span_danger("我感觉有团块状的东西涌上来了……"))

/datum/reagent/toxin/curare
	name = "箭毒木碱"
	description = "先造成轻微毒伤，随后带来持续眩晕和缺氧伤害。"
	reagent_state = LIQUID
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1

/datum/reagent/toxin/curare/on_mob_life(mob/living/carbon/M)
	if(current_cycle >= 11)
		M.Paralyze(60, 0)
	M.adjustOxyLoss(1*REM, 0)
	. = 1
	..()

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "肝素"
	description = "一种强效抗凝剂，受害者会失控出血并不断加重瘀伤。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/heparin/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.bleed_rate = min(H.bleed_rate + 2, 8)
		H.adjustBruteLoss(1, 0) //Brute damage increases with the amount they're bleeding
		. = 1
	return ..() || .


/datum/reagent/toxin/rotatium //Rotatium. Fucks up my rotation and is hilarious
	name = "旋转剂"
	description = "一种不断旋涡流动、颜色古怪的液体，会让饮用者的方向感与手眼协调变得一团糟。"
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "天旋地转"

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/carbon/M)
	if(M.hud_used)
		if(current_cycle >= 20 && current_cycle%20 == 0)
			var/list/screens = list(M.hud_used.plane_masters["[FLOOR_PLANE]"], M.hud_used.plane_masters["[GAME_PLANE]"], M.hud_used.plane_masters["[LIGHTING_PLANE]"])
			var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
			for(var/whole_screen in screens)
				animate(whole_screen, transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
				animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)
	return ..()

/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/M)
	if(M && M.hud_used)
		var/list/screens = list(M.hud_used.plane_masters["[FLOOR_PLANE]"], M.hud_used.plane_masters["[GAME_PLANE]"], M.hud_used.plane_masters["[LIGHTING_PLANE]"])
		for(var/whole_screen in screens)
			animate(whole_screen, transform = matrix(), time = 5, easing = QUAD_EASING)
	..()

/datum/reagent/toxin/anacea
	name = "安纳希亚"
	description = "一种会迅速清除药物、且代谢极慢的毒素。"
	reagent_state = LIQUID
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	toxpwr = 0.15

/datum/reagent/toxin/anacea/on_mob_life(mob/living/carbon/M)
	var/remove_amt = 5
	for(var/datum/reagent/medicine/R in M.reagents.reagent_list)
		M.reagents.remove_reagent(R.type,remove_amt)
	return ..()

/datum/reagent/toxin/drow
	name = "卓尔毒素"
	description = "你到底是怎么看清这玩意儿的？"
	reagent_state = LIQUID
	color = "#410233"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

//ACID
/datum/reagent/toxin/acid
	name = "硫酸"
	description = "一种化学式为 H2SO4 的强无机酸。"
	color = "#00FF32"
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour
	taste_description = "酸味"
	self_consuming = TRUE

/datum/reagent/toxin/acid/reaction_mob(mob/living/carbon/C, method=TOUCH, reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method == INGEST)
		C.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(method == INJECT)
		C.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
		return
	C.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_obj(obj/O, reac_volume)
	if(ismob(O.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(reac_volume,0.1)
	T.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "氟硫酸"
	description = "氟硫酸是一种腐蚀性极强的化学物质。"
	color = "#5050FF"
	toxpwr = 2
	acidpwr = 42.0

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(current_cycle/10, 0)
	. = 1
	..()

/datum/reagent/toxin/acid/nitracid
	name = "硝酸"
	description = "硝酸是一种腐蚀性极强的化学物质，会与活体有机组织发生剧烈反应。"
	color = "#5050FF"
	toxpwr = 6
	acidpwr = 5.0

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(current_cycle/15, FALSE) //here you go nervar
	. = TRUE
	..()

/datum/reagent/toxin/delayed
	name = "毒素微胶囊"
	description = "短暂潜伏后会造成严重毒素伤害。"
	reagent_state = LIQUID
	metabolization_rate = 0 //stays in the system until active.
	var/actual_metaboliztion_rate = REAGENTS_METABOLISM
	toxpwr = 0
	var/actual_toxpwr = 5
	var/delay = 30

/datum/reagent/toxin/delayed/on_mob_life(mob/living/carbon/M)
	if(current_cycle > delay)
		holder.remove_reagent(type, actual_metaboliztion_rate * M.metabolism_efficiency)
		M.adjustToxLoss(actual_toxpwr*REM, 0)
		if(prob(10))
			M.Paralyze(20, 0)
		. = 1
	..()

/datum/reagent/toxin/mimesbane
	name = "哑剧之祸"
	description = "一种不会致命的神经毒素，会干扰受害者做手势的能力。"
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "静止"

/datum/reagent/toxin/mimesbane/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/mimesbane/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_EMOTEMUTE, type)

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "伤骨汁"
	description = "一种看起来很像水的奇怪液体，喝下去有种诡异的诱惑力。哎哟。"
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	toxpwr = 0
	taste_description = "骨头发痛"
	overdose_threshold = 50

/datum/reagent/toxin/bonehurtingjuice/on_mob_add(mob/living/carbon/M)
	M.say("哎哟，我的骨头", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bonehurtingjuice/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(7.5, 0)
	if(prob(20))
		switch(rand(1, 3))
			if(1)
				M.say(pick("哎哟。", "好痛。", "我的骨头。", "哎哟好痛。", "哎哟，我的骨头。"), forced = /datum/reagent/toxin/bonehurtingjuice)
			if(2)
				M.emote("me", 1, pick("默默哀嚎了一声。", "看起来像是骨头在作痛。", "痛苦地皱起脸，仿佛骨头都在发疼。"))
			if(3)
				to_chat(M, span_warning("我的骨头好痛！"))
	return ..()

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/M)
	if(prob(4) && iscarbon(M)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/bp = M.get_bodypart(selected_part)
		if(bp)
			playsound(M, get_sfx("desceration"), 50, TRUE, -1)
			M.visible_message(span_warning("[M]的骨头疼得受不了了！！"), span_danger("我的骨头疼得受不了了！！"))
			M.say("哎哟！！", forced = /datum/reagent/toxin/bonehurtingjuice)
			bp.receive_damage(0, 0, 200)
		else //SUCH A LUST FOR REVENGE!!!
			to_chat(M, span_warning("一条幻肢在疼！"))
			M.say("我们为什么还在这里，只为了受苦吗？", forced = /datum/reagent/toxin/bonehurtingjuice)
	return ..()

/datum/reagent/toxin/bungotoxin
	name = "班戈毒素"
	description = "一种可怕的心脏毒素，用来守护那不起眼的班戈坑。"
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "单宁味"

/datum/reagent/toxin/bungotoxin/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 3)
	M.confused = M.dizziness //add a tertiary effect here if this is isn't an effective poison.
	if(current_cycle >= 12 && prob(8))
		var/tox_message = pick("你感到心脏在胸腔里痉挛。", "你感到一阵发虚。","你觉得自己得赶紧喘口气。","你感到胸口传来一阵刺痛。")
		to_chat(M, span_notice("[tox_message]"))
	. = 1
	..()
