/*
LISTEN HERE, BUDDY.
THIS IS A FORWARD PORT, FOR THE MOST PART, OF OLDRW'S FIREARMS!!!
WHY IS THAT IMPORTANT? BECAUSE I'VE NUMBERFUCKED IT!!!
Ahem.
You'll need EXPT or higher to use these without absurd aim times.

The niche is very high pen(crossbows, lol), but lower damage(bows, lol).
This is combined with their accuracy bonus, bypassing PER value.
At least, it should. Fingers crossed.
*/
/obj/item/ramrod
	name = "通条"
	icon = 'modular_helmsguard/icons/obj/items/arquebus_items.dmi'
	desc = "用于给火器装填的通条。可别弄丢了。"
	icon_state = "ramrod"
	item_state = "ramrod"
	slot_flags = SLOT_BELT_L | SLOT_BELT_R | ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 64
	grid_width = 32

/obj/item/powderflask
	name = "火药瓶"
	icon = 'modular_helmsguard/icons/obj/items/arquebus_items.dmi'
	desc = "对门外汉而言，烟火药简直像某种奥术把戏。 \
	它的制法在格里莫里亚大多数地区都已失传，只在齐班提姆之类的地方尚能见到。 \
	可如今？你手里就有一瓶。务必看紧它。"
	icon_state = "powderflask"
	item_state = "powderflask"
	slot_flags = SLOT_BELT_L | SLOT_BELT_R | ITEM_SLOT_NECK | ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_SMALL
	grid_height = 64
	grid_width = 32
	dropshrink = 0.6

/obj/item/gun/ballistic/firearm
	name = "火器原型"
	desc = "如果你看到了这个，请去喊卡尔！！！"
	icon = 'modular_helmsguard/icons/weapons/arquebus.dmi'
	icon_state = "arquebus"
	item_state = "arquebus"
	force = 10
	force_wielded = 15
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, INTENT_GENERIC)
	internal_magazine = TRUE
	mag_type = /obj/item/ammo_box/magazine/internal/firearm
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	randomspread = 1
	spread = 0
	can_parry = TRUE
	minstr = 10
	walking_stick = TRUE
	experimental_onback = TRUE
	cartridge_wording = "musketball"
	load_sound = list('modular_helmsguard/sound/arquebus/musketload.ogg')
	fire_sound = list('modular_helmsguard/sound/arquebus/arquefire.ogg')
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	bolt_type = BOLT_TYPE_NO_BOLT
	casing_ejector = FALSE
	//pickup_sound = 'sound/sheath_sounds/draw_from_holster.ogg'
	//sheathe_sound = 'sound/sheath_sounds/put_back_to_holster.ogg'
	var/spread_num = 10
	var/reloaded = FALSE
	var/load_time = 50
	var/gunpowder = FALSE
	var/obj/item/ramrod/myrod = null

/obj/item/gun/ballistic/firearm/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/firearm/Initialize(mapload)
	. = ..()
	myrod = new /obj/item/ramrod(src)

/obj/item/gun/ballistic/firearm/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	fire_sound = pick("modular_helmsguard/sound/arquebus/arquefire.ogg", "modular_helmsguard/sound/arquebus/arquefire2.ogg",
	"modular_helmsguard/sound/arquebus/arquefire3.ogg", "modular_helmsguard/sound/arquebus/arquefire4.ogg", "modular_helmsguard/sound/arquebus/arquefire5.ogg")
	. = ..()

/obj/item/gun/ballistic/firearm/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	else
		if(myrod)
			playsound(src, "sound/items/sharpen_short1.ogg",  100)
			to_chat(user, "<span class='warning'>我从[src]里抽出了通条！</span>")
			var/obj/item/ramrod/AM
			for(AM in src)
				user.put_in_hands(AM)
				myrod = null
		else
			to_chat(user, "<span class='warning'>[src]里没有收着通条！</span>")


/datum/intent/shoot/firearm
	var/basetime = 120
	chargedrain = 0

/datum/intent/shoot/firearm/can_charge()
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/shoot/firearm/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/firearms) * 20)
		newtime = newtime - ((mastermob.STAPER)) // minus 1 per perception
		if(newtime > 1)
			return newtime
		else
			return 1
	return chargetime

/datum/intent/arc/firearm
	var/basetime = 140
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/firearm/can_charge()
	if(mastermob)
		if(mastermob.get_num_arms(FALSE) < 2)
			return FALSE
		if(mastermob.get_inactive_held_item())
			return FALSE
	return TRUE

/datum/intent/arc/firearm/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + basetime
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/firearms) * 20)
		newtime = newtime - ((mastermob.STAPER)) // minus 1 per perception
		if(newtime > 1)
			return newtime
		else
			return 1
	return chargetime

/obj/item/gun/ballistic/firearm/shoot_with_empty_chamber()
	playsound(src.loc, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 100, FALSE)
//	update_icon()

/obj/item/gun/ballistic/firearm/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded) //Trying to unwield it
		ungrip(user)
		return
	if(alt_intents)
		altgrip(user)
	if(gripped_intents)
		wield(user)
	update_icon()


/obj/item/gun/ballistic/firearm/attackby(obj/item/A, mob/user, params)
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/load_time_skill = load_time - (firearm_skill*2)

	if(istype(A, /obj/item/ammo_casing))
		if(chambered)
			to_chat(user, "<span class='warning'>[src]里已经装着[chambered]了！</span>")
			return
		if(!gunpowder)
			to_chat(user, "<span class='warning'>我得先往[src]里装入烟火药！</span>")
			return
		if((loc == user) && (user.get_inactive_held_item() != src))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg",  100)
		user.visible_message("<span class='notice'>[user]把[A]硬塞进了[src]的枪管。</span>")
		..()

	if(istype(A, /obj/item/powderflask))
		if(gunpowder)
			user.visible_message("<span class='notice'>[src]里已经装满烟火药了！</span>")
			return
		else
			playsound(src, "modular_helmsguard/sound/arquebus/pour_powder.ogg",  100)
			if(do_after(user, load_time_skill, src))
				user.visible_message("<span class='notice'>[user]往[src]里装填了烟火药。</span>")
				gunpowder = TRUE
			return
	if(istype(A, /obj/item/ramrod))
		var/obj/item/ramrod/R=A
		if(!reloaded)
			if(chambered)
				user.visible_message("<span class='notice'>[user]开始用[R.name]将装药捣入[src]的枪管。</span>")
				playsound(src, "modular_helmsguard/sound/arquebus/ramrod.ogg",  100)
				if(do_after(user, load_time_skill, src))
					user.visible_message("<span class='notice'>[user]完成了[src]的装填。</span>")
					reloaded = TRUE
				return
		if(reloaded && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, "modular_helmsguard/sound/arquebus/musketload.ogg",  100)
			user.visible_message("<span class='notice'>[user]把[R.name]收到了[src]的枪管下方。</span>")
		if(!chambered && !myrod)
			user.transferItemToLoc(R, src)
			myrod = R
			playsound(src, "modular_helmsguard/sound/arquebus/musketload.ogg",  100)
			user.visible_message("<span class='notice'>[user]把[R.name]收到了[src]的枪管下方，但没有完成装填。</span>")
		if(!myrod == null)
			to_chat(user, span_warning("[name]里面已经有一根[R.name]了。"))
			return

/obj/item/gun/ballistic/firearm/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/accident_chance = 0
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/turf/knockback = get_ranged_target_turf(user, turn(user.dir, 180), rand(1,2))
	spread = (spread_num - firearm_skill)
	if(firearm_skill < 1)
		accident_chance =80

	if(firearm_skill < 2)
		accident_chance =50
	if(firearm_skill >= 2 && firearm_skill < 5)
		accident_chance =10
	if(firearm_skill >= 5)
		accident_chance =0
	if(HAS_TRAIT(user, TRAIT_FUSILIER))//Regardless of skill, we force it to 0 if you're trained properly.
		accident_chance =0
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
			adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	gunpowder = FALSE
	reloaded = FALSE
	spark_act()

	..()

	//Why must I do this? If we don't do this... I weep...
	for(var/obj/item/ammo_casing/MB in get_ammo_list(FALSE, TRUE))
		qdel(MB)

	spawn (5)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
	spawn (10)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
	spawn (16)
		new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
	for(var/mob/M in range(5, user))
		if(!M.stat)
			shake_camera(M, 3, 1)

	if(prob(accident_chance))
		user.flash_fullscreen("whiteflash")
		user.apply_damage(rand(5,15), BURN, pick(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
		user.visible_message("<span class='danger'>[user]在发射[src]时不慎把自己烧伤了。</span>")
		user.emote("painscream")
		if(prob(60))
			user.dropItemToGround(src)
			user.Knockdown(rand(15,30))
			user.Immobilize(30)

	if(prob(accident_chance))
		user.visible_message("<span class='danger'>[user]被[src]的后坐力震退了！</span>")
		user.throw_at(knockback, rand(1,2), 7)
		if(prob(accident_chance))
			user.dropItemToGround(src)
			user.Knockdown(rand(15,30))
			user.Immobilize(30)

/obj/item/gun/ballistic/firearm/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
/*	if(!reloaded)
		to_chat(user, span_warning("The [src] is not properly loaded yet!"))
		return*/

/obj/item/gun/ballistic/firearm/can_shoot()
	if (!reloaded)
		return FALSE
	return ..()

/obj/item/ammo_box/magazine/internal/firearm
	name = "火器内置弹仓"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead
	caliber = "lead_sphere"
	max_ammo = 1
	start_empty = TRUE

/obj/effect/particle_effect/smoke/arquebus
	name = "烟雾"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	opacity = FALSE
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = 0
	amount = 4
	lifetime = 4
	opaque = TRUE
