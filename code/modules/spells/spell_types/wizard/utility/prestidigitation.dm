#define PRESTI_CLEAN   "presti_clean"
#define PRESTI_SPARK   "presti_spark"
#define PRESTI_MOTE    "presti_mote"
#define PRESTI_SPLASH  "presti_splash"

/obj/effect/proc_holder/spell/targeted/touch/prestidigitation
	name = "戏法术"
	desc = "许多学徒用来练习基础奥术操控的几种小把戏。"
	drawmessage = "我准备施展一道微小的奥术咒术。"
	dropmessage = "我散去了自己凝聚的微末奥术。"
	school = "transmutation"
	overlay_state = "prestidigitation"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/prestidigitation
	var/mote_color = null

// Re-apply saved prestidigitation color when the touch hand is summoned again.
/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/ChargeHand(mob/living/carbon/user)
	. = ..()
	if(!.)
		return
	var/obj/item/melee/touch_attack/prestidigitation/hand = attached_hand
	if(!istype(hand))
		return
	if(mote_color)
		hand.apply_mote_color(mote_color)
	else
		hand.apply_mote_color(hand.default_mote_color)

/obj/item/melee/touch_attack/prestidigitation
	name = "\improper 戏法之触"
	desc = "你回想起自己学过的如下咒式：\n \
	<b>触碰</b>：用奥术之力把物件或某样东西擦拭干净，如同肥皂一般。也被称作“学徒之苦”。\n \
	<b>推搡</b>：在你选定的物品上引出一点火星（若对地面使用，则在你面前），可点燃易燃物以及火把、提灯、营火等事物。 \n \
	<b>使用</b>：召出一颗环绕飞行的魔光微尘，为你照路。中键点击此手以设置微尘颜色，Alt+右键可将其重置。\n \
	<b>挥击</b>：朝目标射出一枚无害的水弹，熄灭其身上的火焰。若瞄准头部，或许会令某些猫科天性者与贵胄不适。"
	catchphrase = null
	no_effect = TRUE
	possible_item_intents = list(INTENT_HELP, INTENT_DISARM, /datum/intent/use, INTENT_HARM)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD" // this produces green because the icon base is yellow but someone else can fix that if they want
	var/obj/effect/wisp/prestidigitation/mote
	var/default_mote_color = "#3FBAFD"
	var/cleanspeed = 35 // adjust this down as low as 15 depending on magic skill
	var/motespeed = 20 // mote summoning speed
	var/sparkspeed = 30 // spark summoning speed
	var/spark_cd = 0
	var/gatherspeed = 35

/obj/item/melee/touch_attack/prestidigitation/Initialize(mapload)
	. = ..()
	mote = new(src)
	apply_mote_color(default_mote_color)

/obj/item/melee/touch_attack/prestidigitation/Destroy()
	if(mote)
		QDEL_NULL(mote)
	return ..()

/obj/item/melee/touch_attack/prestidigitation/attack_self()
	qdel(src)


/obj/item/melee/touch_attack/prestidigitation/MiddleClick(mob/user, params)
	. = ..()
	if(!ishuman(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return

	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	if(!base_spell)
		return

	var/current_color = base_spell.mote_color || mote?.color || default_mote_color
	var/picked_color = input(user, "选择你的魔光微尘颜色：", "染色", current_color) as color|null
	if(isnull(picked_color))
		return
	var/picked_color_hex = sanitize_hexcolor(picked_color)
	if(!picked_color_hex)
		return
	var/list/hsl = rgb2hsl(hex2num(copytext(picked_color_hex,1,3)),hex2num(copytext(picked_color_hex,3,5)),hex2num(copytext(picked_color_hex,5,7)))
	var/lightness_percent = round(hsl[3] * 100, 0.1)
	var/new_color = sanitize_hexcolor(picked_color, 6, TRUE)
	if(lightness_percent < 30)
		to_chat(user, span_warning("所选颜色太暗了（最低亮度需为 30%）！将恢复为默认颜色。"))
		new_color = default_mote_color

	base_spell.mote_color = new_color
	apply_mote_color(new_color)
	to_chat(user, span_notice("我将自己的魔光微尘调谐成了新的色泽。"))

/obj/item/melee/touch_attack/prestidigitation/AltRightClick(mob/user)
	if(!ishuman(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return

	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	if(base_spell)
		base_spell.mote_color = null
	apply_mote_color(default_mote_color)
	to_chat(user, span_notice("我将魔光微尘的颜色重置了。"))

/obj/item/melee/touch_attack/prestidigitation/proc/apply_mote_color(new_color)
	if(!new_color)
		new_color = default_mote_color
	if(color != new_color)
		color = new_color
	if(!mote)
		return
	if(mote.color != new_color)
		mote.color = new_color
	var/light_changed = FALSE
	if(mote.light_color != new_color)
		mote.set_light_color(new_color)
		light_changed = TRUE
	if(light_changed && mote.light_system == STATIC_LIGHT)
		mote.update_light()

/obj/item/melee/touch_attack/prestidigitation/afterattack(atom/target, mob/living/carbon/user, proximity)
	switch (user.used_intent.type)
		if (INTENT_HELP) // Clean something like a bar of soap
			if(istype(target, /obj/structure/well/fountain/mana) || istype(target, /turf/open/lava))
				gather_thing(target, user)
				handle_cost(user, PRESTI_CLEAN)
				return
			if(clean_thing(target, user))
				handle_cost(user, PRESTI_CLEAN)
		if (INTENT_DISARM) // Snap your fingers and produce a spark
			if(create_spark(user, target))
				handle_cost(user, PRESTI_SPARK)
		if (/datum/intent/use) // Summon an orbiting arcane mote for light
			if(handle_mote(user))
				handle_cost(user, PRESTI_MOTE)
		if (INTENT_HARM) // Fire a harmless water bolt — douses fire, distresses felines and nobles when targering the head
			if(shoot_water_bolt(user, target))
				handle_cost(user, PRESTI_SPLASH)

/obj/item/melee/touch_attack/prestidigitation/proc/handle_cost(mob/living/carbon/human/user, action)
	// handles fatigue/stamina deduction, this stuff isn't free - also returns the cost we took to use for xp calculations
	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	var/fatigue_used = base_spell.get_fatigue_drain() //note that as our skills/stats increases, our fatigue drain DECREASES, so this means less xp, too. which is what we want since this is a basic spell, not a spam-for-xp-forever kinda beat
	var/extra_fatigue = 0 // extra fatigue isn't considered in xp calculation
	switch (action)
		if (PRESTI_CLEAN)
			extra_fatigue = 2.5 // baseline stamina cost per clean
		if (PRESTI_SPARK)
			extra_fatigue = 5 // just a bit of extra fatigue on this one
		if (PRESTI_MOTE)
			extra_fatigue = 15 // same deal here
		if (PRESTI_SPLASH)
			extra_fatigue = 15 // one of the most useful effects, stamina cost helps prevent too much spam

	user.stamina_add(fatigue_used + extra_fatigue)

	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	if (skill_level >= SKILL_LEVEL_EXPERT)
		fatigue_used = 0 // we do this after we've actually changed fatigue because we're hard-capping the raises this gives to Expert

	return fatigue_used

/obj/item/melee/touch_attack/prestidigitation/proc/handle_mote(mob/living/carbon/human/user)
	// adjusted from /obj/item/wisp_lantern & /obj/item/wisp
	if (!mote)
		return // should really never happen
	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	if(base_spell?.mote_color)
		apply_mote_color(base_spell.mote_color)
	else
		apply_mote_color(default_mote_color)

	//let's adjust the light power based on our skill, too
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	var/mote_power = clamp(4 + (skill_level - 3), 4, 7) // every step above journeyman should get us 1 more tile of brightness
	mote.set_light_range(mote_power)
	if(mote.light_system == STATIC_LIGHT)
		mote.update_light()

	if (mote.loc == src)
		user.visible_message(span_notice("[user]摊开掌心，凝神专注......"), span_notice("我摊开掌心，将精神集中于自己的奥术之力......"))
		if (do_after(user, src.motespeed, target = user))
			mote.orbit(user, 1, TRUE, 0, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user]将[mote.name]召回[user.p_their()]掌中，并合拢手掌熄灭其光辉。"), span_notice("我将[mote.name]召回掌心，再将手掌合拢。"))
		mote.forceMove(src)
		return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/create_spark(mob/living/carbon/human/user, atom/thing)
	// adjusted from /obj/item/flint
	if (world.time < spark_cd + sparkspeed)
		return FALSE
	spark_cd = world.time

	playsound(user, 'sound/foley/finger-snap.ogg', 100, FALSE)
	user.flash_fullscreen("whiteflash")
	flick("flintstrike", src)

	if (isturf(thing) || !user.Adjacent(thing))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(user, user.dir)
		S.set_up(1, 1, front)
		S.start()
		user.visible_message(span_notice("[user]打了个响指，迸出一点火星！"), span_notice("我以一声响指唤出一点细小火星。"))
	else
		thing.spark_act()
		user.visible_message(span_notice("[user]打了个响指，一点火星直跃向[thing]！"), span_notice("我唤出一点细小火星，并将它引向[thing]。"))

	return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	cleanspeed = initial(cleanspeed) - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)
	cleanspeed = max(1, round(cleanspeed * 0.75)) // 25% less time (e.g. 2s -> 1.5s)

	if (istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user]朝[target.name]施了个手势。细小的奥术微尘在其表面起舞......"), span_notice("我开始用奥术之力清洁[target.name]......"))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("我将[target.name]清理干净了。"))
			return TRUE
		return FALSE
	else if (istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user]朝[target.name]施了个手势。奥术之力正缓缓将其抹去......"), span_notice("我开始用奥术之力将[target.name]一点点抹除......"))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(get_turf(target),CLEAN_MEDIUM)
			to_chat(user, span_notice("我用法力将[target.name]清除了。"))
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user]朝[target.name]施了个手势。细小的奥术微尘涌过[target.p_them()]周身......"), span_notice("我开始用奥术之力清洁[target.name]......"))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I render \the [target.name] clean."))
			return TRUE
		return FALSE

/obj/item/melee/touch_attack/prestidigitation/proc/gather_thing(atom/target, mob/living/carbon/human/user)

	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	var/speed = initial(gatherspeed) - (skill_level * 3) // 3 speed per skill level, from 35 down to a maximum of 17 (pretty quick)
	var/turf/Turf = get_turf(target)
	if (istype(target, /obj/structure/well/fountain/mana))
		user.visible_message(span_notice("[user] begins crystalizing liquid mana..."))
		while(do_after(user, speed, target = target))
			to_chat(user, span_notice("我用奥术之力塑形[target.name]中的液态法力，将其结晶化了！"))
			new /obj/item/magic/manacrystal(Turf)
	if (istype(target, /turf/open/lava))
		user.visible_message(span_notice("[user] begins molding the oozing lava..."))
		while(do_after(user, speed, target = target))
			to_chat(user, span_notice("我用奥术之力塑起一捧流淌的熔岩，使其迅速硬化了！"))
			new /obj/item/magic/obsidian(user.loc)

// Intents for prestidigitation

/obj/item/melee/touch_attack/prestidigitation/proc/shoot_water_bolt(mob/living/carbon/human/user, atom/target)
	var/obj/projectile/energy/waterbolt/P = new(get_turf(user))
	P.zone_aimed = user.zone_selected
	P.firer = user
	P.original = target
	if(target == user)
		P.on_hit(user)
		qdel(P)
	else
		P.preparePixelProjectile(target, user)
		P.fire()
	return TRUE

/obj/effect/wisp/prestidigitation
	name = "微型魔光微尘"
	desc = "一团用于照明的细小奥术显现。"
	pixel_x = 20
	color = "#3FBAFD"
	light_color = "#3FBAFD"
	light_system = MOVABLE_LIGHT
//baseline wisp is in rogue_fires

// Harmless water bolt fired by prestidigitation's punch intent
/obj/projectile/energy/waterbolt
	name = "水弹"
	icon_state = "arcane_barrage"
	damage = 0
	nodamage = TRUE
	alpha = 127
	color = "#5599FF"
	speed = 1
	hitsound = null
	var/zone_aimed = null

/obj/projectile/energy/waterbolt/on_hit(atom/target, blocked = FALSE)
	playsound(get_turf(target), pick('sound/foley/water_land1.ogg', 'sound/foley/water_land2.ogg', 'sound/foley/water_land3.ogg'), 80, TRUE)
	// Fill refillable containers that the bolt lands in
	if(istype(target, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = target
		if((RC.reagent_flags & REFILLABLE) && RC.reagents)
			RC.reagents.add_reagent(/datum/reagent/water, 5)
		return BULLET_ACT_HIT
	// Extinguish lit light sources (braziers, hearths, fireplaces, wall candles, etc.)
	if(istype(target, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/L = target
		if(L.on)
			L.extinguish()
		return BULLET_ACT_HIT
	// Extinguish burning items and structures; any obj that reaches this point is not a carbon, so always return
	if(isobj(target))
		var/obj/O = target
		if((O.resistance_flags & ON_FIRE) && O.extinguishable)
			O.extinguish()
		return BULLET_ACT_HIT
	if(!iscarbon(target))
		return BULLET_ACT_HIT
	var/mob/living/carbon/C = target
	// Douse fire stacks — 10 per hit, so max stacks (20) requires two bolts
	if(C.fire_stacks > 0)
		C.adjust_fire_stacks(-10)
		if(C.fire_stacks <= 0)
			C.extinguish_mob() // also extinguishes any burning clothing/items
	// Chill the target — less than half as much as washing in cold river water
	if(C.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 30)
		C.adjust_bodytemperature(-30)
	// Head-aim and mood debuff logic is human-only
	if(!ishuman(C))
		return BULLET_ACT_HIT
	var/mob/living/carbon/human/H = C
	// Head-aim check for mood debuff
	if(!(zone_aimed in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)))
		return BULLET_ACT_HIT
	// Abyssor patrons are unaffected
	if(istype(H.patron, /datum/patron/divine/abyssor))
		return BULLET_ACT_HIT
	var/is_cat = istabaxi(H) \
		|| (iswildkin(H) && (H.dna.species.name in list("Cat-Kin", "Panther-Kin", "Lynx-Kin", "Leopard-Kin"))) \
		|| (ishalfkin(H) && H.dna.species.name == "Half-Cat") \
		|| (iscritter(H) && H.dna.species.name == "Catvolk")
	var/is_noble = H.is_noble()
	if(is_cat && is_noble)
		H.add_stress(/datum/stressevent/water_splashed_noble_cat)
	else if(is_cat)
		H.add_stress(/datum/stressevent/water_splashed_cat)
	else if(is_noble)
		H.add_stress(/datum/stressevent/water_splashed_noble)
	return BULLET_ACT_HIT

#undef PRESTI_CLEAN
#undef PRESTI_SPARK
#undef PRESTI_MOTE
#undef PRESTI_SPLASH
