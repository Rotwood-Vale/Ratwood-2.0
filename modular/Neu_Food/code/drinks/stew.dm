/*	........   Reagents   ................ */// These are for the pot, if more vegetables are added and need to be integrated into the pot brewing you need to add them here
/datum/reagent/consumable/soup // so you get hydrated without the flavor system messing it up. Works like water with less hydration
	var/hydration = 6
/datum/reagent/consumable/soup/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()

/datum/reagent/consumable/soup/porridge
	name = "粥"
	description = "谷物加水煮软而成，很适合平民果腹。"
	reagent_state = LIQUID
	color = "#F8F0E3"
	nutriment_factor = 15
	metabolization_rate = 0.5 // half as fast as normal, last twice as long
	taste_description = "粥香"
	taste_mult = 3
	hydration = 2

/datum/reagent/consumable/soup/porridge/oatmeal
	name = "燕麦粥"
	description = "很适合平民的一餐。"
	color = "#c38553"

/datum/reagent/consumable/soup/porridge/congee
	name = "米粥"
	description = "把米加水煮到软烂而成。在东方，穷人和病人都会吃它；在这里，它常被视为养身食物。"
	color = "#F8F0E3"

/datum/reagent/consumable/soup/veggie
	name = "蔬菜汤"
	description = ""
	reagent_state = LIQUID
	nutriment_factor = 10
	taste_mult = 4
	hydration = 8

/datum/reagent/consumable/soup/veggie/potato
	name = "土豆汤"
	color = "#869256"
	taste_description = "土豆汤底"

/datum/reagent/consumable/soup/veggie/onion
	name = "洋葱汤"
	color = "#a6b457"
	taste_description = "煮洋葱味"

/datum/reagent/consumable/soup/veggie/cabbage
	name = "卷心菜汤"
	color = "#859e56"
	taste_description = "寡淡卷心菜味"

/datum/reagent/consumable/soup/veggie/turnip
	name = "芜菁汤"
	color = "#becf9d"
	taste_description = "煮芜菁味"

/datum/reagent/consumable/soup/stew
	name = "浓炖"
	description = "凡是能入口的料头，几乎都被炖进这里面了。"
	reagent_state = LIQUID
	nutriment_factor = 20
	taste_mult = 4

/datum/reagent/consumable/soup/stew/egg
	name = "蛋花汤"
	color = "#dedbaf"
	taste_description = "蛋汤味"

/datum/reagent/consumable/soup/stew/cheese
	name = "奶酪浓汤"
	description = "浓稠的奶酪汤，口感绵密，喝下去很是熨帖。"
	color = "#c4be70"
	taste_description = "绵密奶酪味"

/datum/reagent/consumable/soup/stew/chicken
	name = "鸡肉炖汤"
	color = "#baa21c"
	taste_description = "鸡肉味"

/datum/reagent/consumable/soup/stew/meat
	name = "肉炖汤"
	color = "#80432a"
	taste_description = "肉香"

/datum/reagent/consumable/soup/stew/fish
	name = "鱼炖汤"
	color = "#c7816e"
	taste_description = "鱼鲜味"

/datum/reagent/consumable/soup/stew/rabbit
	name = "卡比特炖汤"
	color = "#c59182"
	taste_description = "卡比特肉味"

/datum/reagent/consumable/soup/stew/bisque
	name = "浓海鲜汤"
	color = "#ffb74f" // Bisque like color I know bisque's more complicated than that 
	taste_description = "贝甲鲜味"

/datum/reagent/consumable/soup/stew/yucky
	name = "难喝杂炖"
	color = "#9e559c"
	taste_description = "某种腐败怪味"

/datum/reagent/consumable/soup/stew/berry
	name = "浆果炖汤"
	color = "#863333"
	taste_description = "甜浆果味"

/datum/reagent/consumable/soup/stew/berry_poisoned
	name = "浆果炖汤"
	color = "#863333"
	taste_description = "苦得可疑的浆果味"

/datum/reagent/consumable/soup/stew/garlick_soup
	name = "蒜汤"
	color = "#FAF9F6"
	taste_description = "浓烈蒜香"

/datum/reagent/consumable/soup/stew/cucumber_soup
	name = "黄瓜汤"
	color = "#98fb98"
	taste_description = "饱满黄瓜味"

/datum/reagent/consumable/soup/stew/eggplant_soup
	name = "茄子汤"
	color = "#fff8e3"
	taste_description = "淡淡茄香"

/datum/reagent/consumable/soup/stew/carrot_stew
	name = "胡萝卜炖汤"
	color = "#f26818"
	taste_description = "鲜香胡萝卜味"

/datum/reagent/consumable/soup/stew/nutty_stew
	name = "坚果炖汤"
	color = "#807b78"
	taste_description = "坚果香"

/datum/reagent/consumable/soup/stew/tomato_soup
	name = "番茄汤"
	color = "#db5230"
	taste_description = "浓郁番茄味"
	metabolization_rate = 0.5 // half as fast as normal, last twice as long - it is one of the best soups after all

/datum/reagent/consumable/soup/stew/plum_soup
	name = "李子酱"
	color = "#9c305b"
	taste_description = "甜李子味"

/datum/reagent/consumable/soup/stew/tangerine_marmalade
	name = "橘子果酱"
	color = "#f0935d"
	taste_description = "极甜橘香"

/datum/reagent/consumable/soup/stew/pumpkin_soup
	name = "南瓜汤"
	color = "#702e08"
	taste_description = "烤南瓜味"
	metabolization_rate = 0.5 // half as fast as normal, last twice as long - it is one of the best soups after all

// Copy pasted from berry poison, but stew metabolizes much faster so it is less deadly. You CAN use it as a source of hydration / nutrition if you are desperate enough???
/datum/reagent/consumable/soup/stew/berry_poisoned/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // so one berry or one dose (one clunk of extracted poison, 5u) will make you really sick and a hair away from crit.
			M.adjustToxLoss(2)
	return ..()
