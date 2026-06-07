#define PRESTI_CLEAN   "presti_clean"
#define PRESTI_SPARK   "presti_spark"
#define PRESTI_MOTE    "presti_mote"
#define PRESTI_SPLASH  "presti_splash"

/obj/effect/proc_holder/spell/targeted/touch/prestidigitation
	name = "Prestidigitation"
	desc = "A few basic tricks many apprentices use to practice basic manipulation of the arcyne."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a minor arcyne incantation."
	dropmessage = "I release my minor arcyne focus."
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
	name = "\improper prestidigitating touch"
	desc = "You recall the following incantations you've learned:\n \
	<b>Touch</b>: Use your arcyne powers to scrub an object or something clean, like using soap. Also known as the Apprentice's Woe.\n \
	<b>Shove</b>: Will forth a spark on an item of your choosing (or in front of you, if used on the ground) to ignite flammable items and things like torches, lanterns or campfires. \n \
	<b>Use</b>: Conjure forth an orbiting mote of magelight to light your way. Middle-click this hand to set the mote's color. Alt-right-click to reset it.\n \
	<b>Punch</b>: Conjure a harmless bolt of water at your target, extinguishing any flames upon them. When aimed at the head, it may distress those of feline nature or noble bearing."
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
	var/picked_color = input(user, "Choose your magelight mote color:", "Dyes", current_color) as color|null
	if(isnull(picked_color))
		return
	var/picked_color_hex = sanitize_hexcolor(picked_color)
	if(!picked_color_hex)
		return
	var/list/hsl = rgb2hsl(hex2num(copytext(picked_color_hex,1,3)),hex2num(copytext(picked_color_hex,3,5)),hex2num(copytext(picked_color_hex,5,7)))
	var/lightness_percent = round(hsl[3] * 100, 0.1)
	var/new_color = sanitize_hexcolor(picked_color, 6, TRUE)
	if(lightness_percent < 30)
		to_chat(user, span_warning("The picked color is too dark (minimum lightness is 30%)! Reverting to default color."))
		new_color = default_mote_color

	base_spell.mote_color = new_color
	apply_mote_color(new_color)
	to_chat(user, span_notice("I attune my magelight mote to a new hue."))

/obj/item/melee/touch_attack/prestidigitation/AltRightClick(mob/user)
	if(!ishuman(user))
		return
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return

	var/obj/effect/proc_holder/spell/targeted/touch/prestidigitation/base_spell = attached_spell
	if(base_spell)
		base_spell.mote_color = null
	apply_mote_color(default_mote_color)
	to_chat(user, span_notice("I reset my magelight mote color."))

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
		user.visible_message(span_notice("[user] holds open the palm of [user.p_their()] hand and concentrates..."), span_notice("I hold open the palm of my hand and concentrate on my arcyne power..."))
		if (do_after(user, src.motespeed, target = user))
			mote.orbit(user, 1, TRUE, 0, 48, TRUE)
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] wills \the [mote.name] back into [user.p_their()] hand and closes it, extinguishing its light."), span_notice("I will \the [mote.name] back into my palm and close it."))
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
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, producing a spark!"), span_notice("I will forth a tiny spark with a snap of my fingers."))
	else
		thing.spark_act()
		user.visible_message(span_notice("[user] snaps [user.p_their()] fingers, and a spark leaps forth towards [thing]!"), span_notice("I will forth a tiny spark and direct it towards [thing]."))

	return TRUE

/obj/item/melee/touch_attack/prestidigitation/proc/clean_thing(atom/target, mob/living/carbon/human/user)
	// adjusted from /obj/item/soap in clown_items.dm, some duplication unfortunately (needed for flavor)

	// let's adjust the clean speed based on our skill level
	var/skill_level = user.get_skill_level(attached_spell.associated_skill)
	cleanspeed = initial(cleanspeed) - (skill_level * 3) // 3 cleanspeed per skill level, from 35 down to a maximum of 17 (pretty quick)
	cleanspeed = max(1, round(cleanspeed * 0.75)) // 25% less time (e.g. 2s -> 1.5s)

	if (istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Tiny motes of arcyne power dance across its surface..."), span_notice("I begin to clean \the [target.name] with my arcyne power..."))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I render \the [target.name] clean."))
			return TRUE
		return FALSE
	else if (istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Arcyne power slowly scours it away..."), span_notice("I begin to scour \the [target.name] away with my arcyne power..."))
		if (do_after(user, src.cleanspeed, target = target))
			wash_atom(get_turf(target),CLEAN_MEDIUM)
			to_chat(user, span_notice("I expunge \the [target.name] with my mana."))
			return TRUE
		return FALSE
	else
		user.visible_message(span_notice("[user] gestures at \the [target.name]. Tiny motes of arcyne power surge over [target.p_them()]..."), span_notice("I begin to clean \the [target.name] with my arcyne power..."))
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
			to_chat(user, span_notice("I mold the liquid mana in \the [target.name] with my arcane power, crystalizing it!"))
			new /obj/item/magic/manacrystal(Turf)
	if (istype(target, /turf/open/lava))
		user.visible_message(span_notice("[user] begins molding the oozing lava..."))
		while(do_after(user, speed, target = target))
			to_chat(user, span_notice("I mold a handful of oozing lava  with my arcane power, rapidly hardening it!"))
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
	name = "minor magelight mote"
	desc = "A tiny display of arcyne power used to illuminate."
	pixel_x = 20
	color = "#3FBAFD"
	light_color = "#3FBAFD"
//baseline wisp is in rogue_fires

// Harmless water bolt fired by prestidigitation's punch intent
/obj/projectile/energy/waterbolt
	name = "water bolt"
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
