//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/shoot/bow
	chargetime = 1 //used for edge cases only, /datum/intent/shoot/bow/get_chargetime handles the actual number
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/shoot/bow/can_charge(atom/clicked_object)
	if(mastermob?.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item())
		to_chat(mastermob, span_warning("我需要一只空着的手来拉开[masteritem]！"))
		return FALSE
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE

	return TRUE

/datum/intent/shoot/bow/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob]拉开了[masteritem]！"))
		playsound(mastermob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/shoot/bow/get_chargetime() //this handles how long it takes for us to fully aim our bow. damage is handled below in /obj/item/gun/ballistic/revolver/grenadelauncher/bow/process_fire
	if(mastermob && chargetime)
		var/newtime = 0
		newtime = ((newtime + 10) - (mastermob.get_skill_level(/datum/skill/combat/bows) * (2)))
		if(strength_check == TRUE)
			newtime = ((newtime + 10) - (mastermob.STASTR / 2))
		else
			newtime = newtime
		newtime = ((newtime + 20) - (mastermob.STAPER))
		if(newtime > 1)
			return newtime //this value is how fast we can accurately shoot a bow. most builds will turn up with about 6 - 12 on non heavy bows.
		else
			return 1 //our floor for how quickly you can fire an accurate shot if you somehow break the calcs above. you need about 18 PER and master bows to reach this
	else
		return chargetime //if a bow somehow gets drawn by something that doesn't fulfill the above we can use the intent value

/datum/intent/shoot/bow/heavy
	strength_check = TRUE

/datum/intent/arc/bow
	chargetime = 1
	chargedrain = 2
	charging_slowdown = 3

/datum/intent/arc/bow/can_charge(atom/clicked_object)
	if(mastermob?.get_num_arms(FALSE) < 2 || mastermob.get_inactive_held_item())
		to_chat(mastermob, span_warning("我需要一只空着的手来拉开[masteritem]！"))
		return FALSE
	if(istype(clicked_object, /obj/item/quiver) && istype(mastermob?.get_active_held_item(), /obj/item/gun/ballistic))
		return FALSE
	return TRUE

/datum/intent/arc/bow/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob]弧形拉开了[masteritem]！"))
		playsound(mastermob, pick('sound/combat/Ranged/bow-draw-01.ogg'), 100, FALSE)

/datum/intent/arc/bow/get_chargetime() //same calc as above, but with a higher absolute floor for how fast you can shoot
	if(mastermob && chargetime)
		var/newtime = 0
		newtime = ((newtime + 10) - (mastermob.get_skill_level(/datum/skill/combat/bows) * (2)))
		if(strength_check == TRUE)
			newtime = ((newtime + 10) - (mastermob.STASTR / 2))
		else
			newtime = newtime
		newtime = ((newtime + 20) - (mastermob.STAPER))
		if(newtime > 3)
			return newtime
		else
			return 3
	else
		return chargetime

/datum/intent/arc/bow/heavy
	strength_check = TRUE

//bow objs ฅ^•ﻌ•^ฅ

/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	name = "短弓"
	desc = "这把制作朴素的短弓勉强够用。它虽在弓力与精度上有所欠缺， \
	但尚算迅捷的开弓速度弥补了这一点。"
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "bow"
	item_state = "bow"
	experimental_onhip = TRUE
	experimental_onback = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/shot/bow
	fire_sound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	can_parry = TRUE
	verbage = "nock"
	cartridge_wording = "arrow"
	load_sound = 'sound/foley/nockarrow.ogg'
	obj_flags = UNIQUE_RENAME
	var/heavy_bow = FALSE //used for adding a STR check to the charge time of a bow
	metalizer_result = /obj/item/restraints/legcuffs/beartrap/armed
	possible_item_intents = list(
		/datum/intent/shoot/bow/short,
		/datum/intent/arc/bow/short,
		INTENT_GENERIC,
		)
	randomspread = 1
	spread = 1
	force = 9
	damfactor = 0.9//combat stats at the end - these are tuned for a Shortbow - high spread, low damage

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/Initialize(mapload)
	. = ..()
	if(heavy_bow == TRUE)
		src.possible_item_intents = list(
									/datum/intent/shoot/bow/heavy,
									/datum/intent/arc/bow/heavy,
									INTENT_GENERIC,
									)
		desc += " <b>弓力沉重。</b>"
	else
		return

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.7,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 1,
					"ex" = -2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = -3,
					"nx" = 4,
					"ny" = -5,
					"wx" = -3,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = 0,
					"nx" = 4,
					"ny" = 0,
					"wx" = 0,
					"wy" = 0,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)


/obj/item/gun/ballistic/revolver/grenadelauncher/bow/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/dropped()
	. = ..()
	if(chambered)
		chambered = null
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			CB.forceMove(drop_location())
//			CB.bounce_away(FALSE, NONE)
			num_unloaded++
		if (num_unloaded)
			update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.get_inactive_held_item() || user.get_num_arms(FALSE) < 2)
		to_chat(user, span_warning("我需要一只空着的手来发射[src]！"))
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		BB.accuracy += accfactor * (user.STAPER - 9) * 4 // 9+ PER gives +4 per level. Exponential.
		BB.bonus_accuracy += (user.STAPER - 8) * 3 // 8+ PER gives +3 per level. Does not decrease over range.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/combat/bows) * 5) // +5 per Bow level.

		if(user.client.chargedprog < 100)
			BB.damage -= (BB.damage * (user.client.chargedprog / 100))
			BB.embedchance /= 2
			BB.accuracy -= 15
		var/perception_modifier = user.STAPER
		if(perception_modifier > 15) // Bow damage hardcapped at 15 PER
			perception_modifier = 15
		if(perception_modifier < 10)
			perception_modifier = 10
		BB.damage *= damfactor * (perception_modifier / 10)
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/update_icon()
	..()

	var/matrix/mat = matrix()
	mat.Translate(20,20)

	cut_overlays()
	if(chambered)
		var/mutable_appearance/ammo = mutable_appearance('icons/roguetown/weapons/ammo.dmi', chambered.icon_state)
		ammo.transform = mat
		add_overlay(ammo)

	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/ammo_box/magazine/internal/shot/bow
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	caliber = "arrow"
	max_ammo = 1
	start_empty = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	name = "反曲弓"
	desc = "一把中等长度的复合弓，由角、木材与筋腱胶合而成，在威力、速度与精度之间取得了良好平衡。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "recurve_bow"
	force = 9
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	dropshrink = 0.8
	possible_item_intents = list(
		/datum/intent/shoot/bow,
		/datum/intent/arc/bow,
		INTENT_GENERIC,
		)
	randomspread = 0
	spread = 0
	force = 10
	damfactor = 1

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 1,
					"ex" = -2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = -3,
					"nx" = 3,
					"ny" = -5,
					"wx" = -7,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 0,
					"nx" = 0,
					"ny" = 1,
					"wx" = -2,
					"wy" = 0,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	name = "紫杉长弓"
	desc = "一把由整形紫杉弓臂制成的坚固战弓。它不易驾驭，但那份 \
	威力值得付出这番力气。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "longbow"
	slot_flags = ITEM_SLOT_BACK
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	dropshrink = 0.8
	heavy_bow = TRUE
	possible_item_intents = list(
		/datum/intent/shoot/bow,
		/datum/intent/arc/bow,
		INTENT_GENERIC,
		)
	randomspread = 0
	spread = 0
	force = 12
	damfactor = 1.2
	accfactor = 0.9

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 0,
					"ex" = -2,
					"ey" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = 1,
					"nx" = 0,
					"ny" = 0,
					"wx" = -1,
					"wy" = 1,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)

//Unique Bows

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
	name = "黑角弓"
	desc = "北方的黑角赛加兽一旦年岁足够，便会脱落那对长达两米的巨角。随着时日推移，它们会愈发坚硬，\
		却仍保有一种甚至胜过紫杉的柔韧。守望者偶尔寻得这种角材时，常会将其收集起来，交由制弓大师削整、上弦、处理。这样的传统至今仍有价值，\
		于是人们仍能看到谷地的守望者自豪地携着他们那种本地特有的黑角弓。"
	icon_state = "recurve_warden"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
	name = "黑角长弓"
	desc = "北方的黑角赛加兽一旦年岁足够，便会脱落那对长达两米的巨角。随着时日推移，它们会愈发坚硬，\
		却仍保有一种甚至胜过紫杉的柔韧。守望者偶尔寻得这种角材时，常会将其收集起来，交由制弓大师削整、上弦、处理。最终成品，\
		便是眼前这样的战弓。"
	icon_state = "longbow_warden"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/steppesman
	name = "阿夫尼骑弓"
	desc = "一把专为骑乘赛加兽射击而打造的短型反曲战弓，这项技艺在阿夫纳的每位弓手眼中都远比北方同侪重要得多。每位老练的杜鲁日纳本身往往也是好弓匠，通常会亲手制作自己的弓；这一把便是以沃勒茨列维树带紫红色的深红木打造。"
	icon_state = "recurve_riding"

/datum/intent/shoot/bow/short
	chargetime = 0.75
	chargedrain = 1.5
	charging_slowdown = 2.5

/datum/intent/arc/bow/short
	chargetime = 0.75
	chargedrain = 1.5
	charging_slowdown = 2.5



/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/eora
	name = "艾欧拉竖琴弓"
	desc = "琴弦，亦可为弓弦。"
	icon = 'icons/roguetown/weapons/special/boweoran64.dmi'
	icon_state = "harpbow"
	dropshrink = 0
	// randomspread = 1
	// spread = 1
	force = 15
	damfactor = 1.25

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/eora//subtype of recurve bow for the sprite sizes, but stats of a shortbow
	name = "艾欧拉竖琴弓"
	desc = "琴弦，亦可为弓弦。"
	icon = 'icons/roguetown/weapons/special/boweoran64.dmi'
	icon_state = "harpbowb"
	dropshrink = 0
	randomspread = 1
	spread = 1
	force = 9
	damfactor = 0.95
	possible_item_intents = list(
		/datum/intent/shoot/bow/short,
		/datum/intent/arc/bow/short,
		INTENT_GENERIC,
		)
