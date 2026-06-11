/datum/reagent/water/rosewater
	name = "玫瑰茶"
	description = "以玫瑰花瓣浸泡而成，带有轻微的恢复效果。"
	reagent_state = LIQUID
	color = "#f398b6"
	taste_description = "花香甜味"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/rosewater/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5*REM)
	else
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

// Reagents system don't have the idea of solute and solvent so we need a type for each
/datum/reagent/consumable/caffeine/
	name = "咖啡因"
	description = "你为什么会看到这个？"
	hydration_factor = 5
	overdose_threshold = 60

/datum/reagent/consumable/caffeine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5) // 1/6th of mana pot
	M.apply_status_effect(/datum/status_effect/buff/vigorized)

/datum/reagent/consumable/caffeine/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(prob(5))
		M.heart_attack()
	
/datum/reagent/consumable/caffeine/coffee
	name = "咖啡"
	description = "咖啡豆煮成的热饮，带着一丝苦味，能提振精神。"
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "焦糖般的苦味" // coffee has so many flavors I am going for one
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/caffeine/tea
	name = "茶"
	description = "茶叶煮成的热饮，略带一丝苦味，口感顺滑。"
	reagent_state = LIQUID
	color = "#508141" // Deeper green to make it look better
	taste_description = "顺滑的草木气息" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/poppy_milk
	name = "罂粟奶"
	description = "浸入罂粟后的饮液，喝下后会让你的口舌与神智一同麻木。喝上一杯以上可能不太利于健康......"
	reagent_state = LIQUID
	color = "#dbd7d5"
	taste_description = "瞬间的麻木感"
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 25 // one cup is safe, anything more and it's an OD
	alpha = 173

/datum/reagent/consumable/poppy_milk/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	..()

/datum/reagent/consumable/poppy_milk/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

// Tea ported from Vanderlin from Misc Fixes PR #862
/datum/reagent/consumable/golden_calendula_tea
	name = "金盏花茶"
	description = "一种清爽的茶饮，很适合舒缓伤势并缓解疲劳。"
	color = "#b38e17"
	taste_description = "草本风味"

/datum/reagent/consumable/golden_calendula_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1) //at a metabolism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75*REM, 0)
		M.adjustFireLoss(-0.75*REM, 0)
		M.adjustOxyLoss(-0.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1*REM)
		M.adjustCloneLoss(-0.75*REM, 0)
	..()

/datum/reagent/consumable/soothing_valerian_tea
	name = "舒缓缬草茶"
	description = "一种清爽的茶饮，很适合缓解疲劳并减轻压力。"
	color = "#3b9146"
	quality = DRINK_FANTASTIC
	taste_description = "草本风味"

/datum/reagent/consumable/soothing_valerian_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(3)
	..()
