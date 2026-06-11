/*
Firstly, the coordinates device. Eventually, I'll add free aim. But for now...
*/
/obj/item/rogueweapon/palantir
	name = "\improper 真知晶球"
	desc = "一具刻满符文、灌注了能量的 Arcyne 罗盘。\
	换句话说，它能够侦测地脉交汇点。\
	这是件贵得惊人的装置，多半是从女王麾下某位法师手里撬来的。"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "compass"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	possible_item_intents = list(INTENT_GENERIC)
	var/last_x = "UNKNOWN"
	var/last_y = "UNKNOWN"
	var/last_z = "UNKNOWN"

/obj/item/rogueweapon/palantir/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		. += "<small>上次记录的横向交汇点：<span class='warning'>[last_x]</span> <br>\
			上次记录的纵向交汇点：<span class='warning'>[last_y]</span> <br>\
			上次记录的高度交汇点：<span class='warning'>[last_z]</span></small>"
	else
		. += "<small>不出所料，你完全看不懂这些细节。也许受过烟火药训练的人会明白……</small>"

/obj/item/rogueweapon/palantir/afterattack(atom/A, mob/living/user, adjacent, params) //handles coord obtaining
	if(!HAS_TRAIT(user, TRAIT_FUSILIER))
		to_chat(user, "<span class='warning'>这件装置超出了你的理解范围……</span>")
		return
	to_chat(user, "正在计算地脉交汇点。请保持不动。")
	loud_message("能听见真知晶球发出的尖锐嗡鸣", hearing_distance = 24)//"ZEZUZ PYST FROM WHERE?!!"
	if(do_after(user, 12 SECONDS, src))
		A = get_turf(A)
		last_x = obfuscate_x(A.x)
		last_y = obfuscate_y(A.y)
		last_z = A.z
		to_chat(user, "目标交汇点 <br>\
		<small>横向交汇点：<span class='warning'>[last_x]</span> <br>\
		纵向交汇点：<span class='warning'>[last_y]</span> <br>\
		高度交汇点：<span class='warning'>[last_z]</span></small>")
	else
		to_chat(user, "<span class='warning'>你必须保持不动！</span>")

//This is a weapon because it makes me chuckle. Sorry.
/obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge
	name = "装药杆"
	desc = "一根又粗又重的长杆，一头是海绵，另一头站着个傻子。完全不适合拿来战斗。"
	icon = 'icons/roguetown/weapons/stationary/bombard64.dmi'
	icon_state = "ramrod"
	item_state = "ramrod"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	force_wielded = 10
	max_integrity = 25
	wdefense = 2
	wdefense_wbonus = 2
	possible_item_intents = list(INTENT_GENERIC)

//The portable bombard's frame, lacking a barrel.
/obj/item/bombard_frame
	name = "\improper 轻型臼炮架"
	desc = "一门轻型臼炮的炮架。要是你有炮管，就能把轻型臼炮架设起来…… <br>\
	<small>要这么做，你必须同时持有两部分，然后用“制作”组装。</small>"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "kit_frame"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	possible_item_intents = list(INTENT_GENERIC)

//And the barrel it lacks.
/obj/item/bombard_barrel
	name = "\improper 轻型臼炮管"
	desc = "一门轻型臼炮的炮管。要是你有炮架，就能把轻型臼炮架设起来…… <br>\
	<small>要这么做，你必须同时持有两部分，然后用“制作”组装。</small>"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "kit_barrel"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	possible_item_intents = list(INTENT_GENERIC)

//And the recipe in which we hold it hostage. It shouldn't be survival, but, whatever.
/datum/crafting_recipe/roguetown/survival/bombard
	name = "便携臼炮（炮管与炮架）"
	result = /obj/structure/bombard
	category = "Ranged"
	reqs = list(
		/obj/item/bombard_frame = 1,
		/obj/item/bombard_barrel = 1
		)
	skillcraft = /datum/skill/combat/firearms
	craftdiff = 1
	time = 60
