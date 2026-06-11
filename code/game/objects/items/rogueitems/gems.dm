
/obj/item/roguegem
	name = "万宝之母"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "一个供后续调试使用的工具。"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 1
	static_price = FALSE
	resistance_flags = FIRE_PROOF

//Kobolds eating GEMS. Dwarves, behold, your BANE.
/obj/item/roguegem/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(iskobold(M))
			if(M == user)
				user.visible_message(span_warning("[user]正试图吃下[src]！"), span_warning("我开始吃[src]了！"))
			else
				user.visible_message(span_warning("[user]开始强迫[M]吃下[src]！"), span_warning("我试图强迫[M]吃下[src]！"))
			if(do_after(user, 40))
				var/healydoodle_gems = sellprice*0.6
				M.apply_status_effect(/datum/status_effect/buff/gemmuncher, healydoodle_gems)
				playsound(get_turf(src), 'modular_azurepeak/sound/spellbooks/glass.ogg', 100)
				qdel(src)
				if(M == user)
					user.visible_message(span_danger("[user]吃下了[src]！天哪！"), span_danger("我把[src]吞了下去！"))
				else
					user.visible_message(span_danger("[user]强迫[M]吃下了[src]！天哪！"), span_danger("我强迫[M]吃下了[src]！"))

		else
			return ..()
	else
		return ..()

/obj/item/roguegem/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/roguegem/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(loc, pick('sound/items/gems (1).ogg','sound/items/gems (2).ogg'), 100, TRUE, -2)
	..()

/obj/item/roguegem/green
	name = "祖母绿"
	icon_state = "emerald_cut"
	sellprice = 42
	desc = "闪烁着翠绿的光辉。"

/obj/item/roguegem/green/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/emerald_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/blue
	name = "石英"
	icon_state = "quartz_cut"
	sellprice = 88
	desc = "淡蓝如冻结的泪滴。"

/obj/item/roguegem/blue/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/yellow
	name = "黄玉"
	icon_state = "topaz_cut"
	sellprice = 34
	desc = "它的琥珀色调让你想起落日。"

/obj/item/roguegem/yellow/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/toper_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/violet
	name = "蓝宝石"
	icon_state = "sapphire_cut"
	sellprice = 56
	desc = "这颗宝石深受许多法师喜爱。"

/obj/item/roguegem/violet/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/sapphire_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/ruby
	name = "红宝石"
	icon_state = "ruby_cut"
	sellprice = 100
	desc = "它的切面闪耀得异常明亮……"

/obj/item/roguegem/ruby/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/ruby_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/diamond
	name = "钻石"
	icon_state = "diamond_cut"
	sellprice = 121
	desc = "它清澈得近乎完美，令人肃然起敬。"

/obj/item/roguegem/onyxa
	name = "奥尼克萨"
	desc = "一块邪异而闪烁的石头。它对卓尔而言价值不菲，也时常用于死灵仪式。传说以它打造的镜子永远不会映出你自己的脸。"
	icon = 'icons/roguetown/gems/gem_onyxa.dmi'
	icon_state = "raw_onyxa"
	sellprice = 30

/obj/item/roguegem/jade
	name = "玉"
	desc = "一块黯淡的绿色宝石，在凌月与风间都备受珍视。凌月传统认为，玉是普希冬本质的凝结，能保护灵魂与血肉免于朽坏和腐化。"
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "raw_jade"
	sellprice = 50

/obj/item/roguegem/oyster
	name = "化石蛤壳"
	desc = "一枚石化的蛤壳。用凿子把它撬开或许是个不错的主意。"
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "oyster_closed"
	sellprice = 5

/obj/item/roguegem/coral
	name = "心石"
	desc = "它的锯齿像猎犬的牙。传说心石是陨落水手鲜血结晶而成的产物。它被阿比索尔信徒奉为圣物，也用于许多阿比索尔仪式。"
	icon = 'icons/roguetown/gems/gem_coral.dmi'
	icon_state = "raw_coral"
	sellprice = 60

/obj/item/roguegem/turq
	name = "蔚青石"
	desc = "一块美丽的蓝绿色宝石，很容易雕琢。它深受法师喜爱，而其惊人的澄澈度也让它成为纳雷迪占星法师偏爱的占卜工具。"
	icon = 'icons/roguetown/gems/gem_turq.dmi'
	icon_state = "raw_turq"
	sellprice = 75

/obj/item/roguegem/amber
	name = "琥珀"
	desc = "一块石化的阳光。人们相信它是第一轮太阳碎裂时洒落的残片，因此在阿斯特拉信徒中价值连城。拉阿内希人有时甚至会拿它的碎片代替玛蒙作为货币。"
	icon = 'icons/roguetown/gems/gem_amber.dmi'
	icon_state = "raw_amber"
	sellprice = 50

/obj/item/roguegem/opal
	name = "欧泊"
	desc = "一颗耀眼夺目的贵重宝石。人们普遍猜测，欧泊是彩虹消散后遗留下来的结晶精华。"
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "raw_opal"
	sellprice = 80

/obj/item/roguegem/chitin
	name = "甲虫几丁质甲片"
	desc = "一块厚实而泛着虹彩的几丁质甲片，从巨型绒甲金龟身上剥取而来。它因坚韧耐用和天然光泽而深受幽深地底工匠珍爱。"
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "raw_shell"
	color = "#7B8C5E"
	sellprice = 15

/obj/item/roguegem/diamond/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/diamond_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

// Do NOT add these to the stockpile treasures list, they have other uses.
/obj/item/roguegem/blood_diamond
	name = "血钻"
	icon_state = "blood"
	sellprice = 188
	desc = "这颗宝石让你本能地觉得不对劲。握住它时，你会感觉指尖的血色都被抽离了。"

/obj/item/roguegem/blood_diamond/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	if(human_user.patron.type == /datum/patron/inhumen/graggar)
		. += span_danger("你对这种宝石十分熟悉。唯有最强大战士卷入的极端暴力，才会孕育出它。")

/obj/item/roguegem/amethyst
	name = "阿米索兹"
	icon_state = "amethyst"
	desc = "一块深薰衣草色的晶体，其中奔涌着魔法能量，但它的人造本质也意味着它并不值钱。"

/obj/item/roguegem/amethyst/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/amethyst_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/amethyst/naledi
	name = "纳勒迪阿米索兹"
	desc = "一块深薰衣草色的晶体，噼啪作响地涌动着魔法能量。对门徒而言，它也许只是一次异乡朝圣带回的纪念物；但对旅者来说，它却是将武技与奥术相融的地脉媒介。</br>拥有奥术潜质者可将这颗宝石嵌入尚未完成的法术书中，以此回忆起更多法术。"

/obj/item/roguegem/random
	name = "随机宝石"
	desc = "你不该看到这个。"
	icon = 'icons/roguetown/helpers/spawnerhelpers.dmi'
	icon_state = "roguegem"

/obj/item/roguegem/random/Initialize(mapload)
	..()
	var/newgem = list(/obj/item/roguegem/ruby = 5, /obj/item/roguegem/green = 15, /obj/item/roguegem/blue = 10, /obj/item/roguegem/yellow = 20, /obj/item/roguegem/violet = 10, /obj/item/roguegem/diamond = 5, /obj/item/riddleofsteel = 1, /obj/item/rogueore/silver = 3, /obj/item/roguegem/blood_diamond = 1, /obj/item/roguegem/onyxa = 5, /obj/item/roguegem/jade = 3, /obj/item/roguegem/coral = 3, /obj/item/roguegem/turq = 3, /obj/item/roguegem/amber = 3, /obj/item/roguegem/opal = 3)
	var/pickgem = pickweight(newgem)
	new pickgem(get_turf(src))
	qdel(src)


/// riddle


/obj/item/riddleofsteel
	name = "钢铁之谜"
	icon_state = "ros"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "血肉，心智。"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 400
	var/det_chance = 50//Chance that it'll explode violently when eaten.

/obj/item/riddleofsteel/Initialize(mapload)
	. = ..()
	set_light(2, 2, 1, l_color = "#ff0d0d")

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

//Kobolds eating RIDDLES. PSYDON WEPT.
/obj/item/riddleofsteel/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(iskobold(M))
			if(M == user)
				user.visible_message(span_warning("[user]正试图吃下[src]！"), span_warning("我开始吃[src]了！"))
			else
				user.visible_message(span_warning("[user]开始强迫[M]吃下[src]！"), span_warning("我试图强迫[M]吃下[src]！"))

			if(do_after(user, 40))
				playsound(get_turf(src), 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100)
				qdel(src)
				if(prob(det_chance))//Woe... - TODO: Expand this. Properly. An explosion and dusting.
					M.adjust_fire_stacks(100)//You will burn. Horribly.
					M.adjustFireLoss(250)//If you somehow put it out immediately, you still contend with this.
					M.Paralyze(12 SECONDS, ignore_canstun = TRUE)//You lost the coin toss. Suffer the loss.
					M.ignite_mob()
					M.visible_message(span_deadsay("[src]在一阵奥术火焰与能量中轰然爆开，将[M]猛地吞没！"))
					M.add_stress(/datum/stressevent/riddle_munch)//You still get the stress, even if you don't get the heal.
				else//You won the toss, but you still lose. Because this is a waste of a riddle.
					var/healydoodle_riddle = sellprice*0.5//Not as effective, on a per-value basis. But it's still MUCH better.
					M.apply_status_effect(/datum/status_effect/buff/gemmuncher, healydoodle_riddle)
					M.add_stress(/datum/stressevent/riddle_munch)//Why would you do this?
					if(M == user)
						user.visible_message(span_danger("[user]吃下了[src]！可憎的生物！"), span_danger("我把[src]吞了下去！这真是个好主意吗？"))
					else
						user.visible_message(span_danger("[user]强迫[M]吃下了[src]！这也太没人性了……"), span_danger("我强迫[M]吃下了[src]！我为什么要这么做？"))

		else
			return ..()
	else
		return ..()

/obj/item/pearl
	name = "珍珠"
	icon_state = "pearl"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "一颗美丽的珍珠。可以串起来做成护符。"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 20

/obj/item/pearl/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/pearlcross,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/pearl/blue
	name = "蓝珍珠"
	icon_state = "bpearl"
	desc = "一颗美丽的蓝珍珠，乃阿比索尔的馈赠。可以串起来做成护符。"
	sellprice = 60

/obj/item/pearl/blue/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bpearlcross,
		/datum/crafting_recipe/roguetown/survival/abyssoramulet
		)
