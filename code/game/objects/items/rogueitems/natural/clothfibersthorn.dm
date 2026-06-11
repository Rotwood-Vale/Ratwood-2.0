/obj/item/natural/fibers
	name = "纤维"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "植物纤维。农民们将它制成衣物来谋生。"
	force = 0
	throwforce = 0
	obj_flags = null
	color = "#575e4a"
	bundling_time = 1 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	sellprice = 2
	bundletype = /obj/item/natural/bundle/fibers

/obj/item/natural/fibers/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/woodhammer,
		/datum/crafting_recipe/roguetown/survival/torch,
		/datum/crafting_recipe/roguetown/survival/woodhammer,
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/stonesword,
		/datum/crafting_recipe/roguetown/survival/woodsword,
		/datum/crafting_recipe/roguetown/survival/rod,
		/datum/crafting_recipe/roguetown/survival/pearlcross,
		/datum/crafting_recipe/roguetown/survival/bpearlcross,
		/datum/crafting_recipe/roguetown/survival/shellnecklace,
		/datum/crafting_recipe/roguetown/survival/shellbracelet,
		/datum/crafting_recipe/roguetown/survival/abyssoramulet,
		/datum/crafting_recipe/roguetown/survival/broom,
		/datum/crafting_recipe/roguetown/survival/woodcross,
		/datum/crafting_recipe/roguetown/survival/bonespear,
		/datum/crafting_recipe/roguetown/survival/boneaxe,
		/datum/crafting_recipe/roguetown/survival/goodluckcharm,
		/datum/crafting_recipe/roguetown/survival/bouquet_rosa,
		/datum/crafting_recipe/roguetown/survival/bouquet_salvia,
		/datum/crafting_recipe/roguetown/survival/bouquet_matricaria,
		/datum/crafting_recipe/roguetown/survival/bouquet_calendula,
		/datum/crafting_recipe/roguetown/survival/flowercrown_rosa,
		/datum/crafting_recipe/roguetown/survival/flowercrown_salvia,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/fibers/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	var/is_legendary = FALSE
	if(user.get_skill_level(/datum/skill/labor/farming) == SKILL_LEVEL_LEGENDARY) //check if the user has legendary farming skill
		is_legendary = TRUE //they do
	if(is_legendary)
		bundling_time = 2 //if legendary skill, the move_after is fast, 0.2 seconds
	to_chat(user, span_warning("我开始收集[src]..."))
	if(move_after(user, bundling_time, target = src))
		var/fibercount = 0
		for(var/obj/item/natural/fibers/F in get_turf(src))
			fibercount++
		while(fibercount > 0)
			if(fibercount == 1)
				new /obj/item/natural/fibers(get_turf(user))
				fibercount--
			else if(fibercount >= 2)
				var/obj/item/natural/bundle/fibers/B = new(get_turf(user))
				B.amount = clamp(fibercount, 2, 6)
				B.update_bundle()
				fibercount -= clamp(fibercount, 2, 6)
				user.put_in_hands(B)
		for(var/obj/item/natural/fibers/F in get_turf(src))
			qdel(F)

/obj/item/natural/silk
	name = "蛛丝"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "一缕缕蜘蛛丝。除深地之外，用它制成的衣物在任何地方都算得上异域珍品。"
	force = 0
	throwforce = 0
	obj_flags = null
	color = "#e6e3db"
	bundling_time = 1 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	bundletype = /obj/item/natural/bundle/silk

/obj/item/natural/silk/attack_right(mob/user)
	to_chat(user, span_warning("我开始收集[src]..."))
	if(move_after(user, bundling_time, target = src))
		var/silkcount = 0
		for(var/obj/item/natural/silk/F in get_turf(src))
			silkcount++
		while(silkcount > 0)
			if(silkcount == 1)
				new /obj/item/natural/silk(get_turf(user))
				silkcount--
			else if(silkcount >= 2)
				var/obj/item/natural/bundle/silk/B = new(get_turf(user))
				B.amount = clamp(silkcount, 2, 6)
				B.update_bundle()
				silkcount -= clamp(silkcount, 2, 6)
		for(var/obj/item/natural/silk/F in get_turf(src))
			qdel(F)

#ifdef TESTSERVER

/client/verb/bloodnda()
	set category = "DEBUGTEST"
	set name = "血液 DNA"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(I.return_blood_DNA())
			testing("yep")
		else
			testing("nope")

#endif

/obj/item/natural/cloth
	name = "布"
	icon_state = "cloth"
	possible_item_intents = list(/datum/intent/use)
	desc = "一匹织成的纤维。可用作绷带，以及数十种工艺的原料。"
	force = 0
	throwforce = 0
	obj_flags = null
	bundling_time = 2 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = FALSE //rip
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	nudist_approved = TRUE
	bundletype = /obj/item/natural/bundle/cloth
	sellprice = 4
	detail_tag = "_soaked"
	dropshrink = 0.9
	var/wet = 0
	/// Effectiveness when used as a bandage, how much it'll lower the bloodloss, bloodloss will get multiplied by this.
	var/bandage_effectiveness = 0.5
	var/bandage_speed = 7 SECONDS
	///How much you can bleed into the bandage until it needs to be changed
	var/bandage_health = 150 //75 total blood stopped
	//bandage_health * (1 - bandage_effectiveness) = total amount of blood saved from one bandage
	/// If the bandage is soaked in some kind of medicine.
	var/medicine_quality
	var/medicine_amount = 0

/obj/item/natural/cloth/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("我开始收集[src]..."))
	if(move_after(user, bundling_time, target = src))
		var/clothcount = 0
		for(var/obj/item/natural/cloth/F in get_turf(src))
			clothcount++
		while(clothcount > 0)
			if(clothcount == 1)
				new /obj/item/natural/cloth(get_turf(user))
				clothcount--
			else if(clothcount >= 2)
				var/obj/item/natural/bundle/cloth/B = new(get_turf(user))
				B.amount = clamp(clothcount, 2, 10)
				B.update_bundle()
				clothcount -= clamp(clothcount, 2, 10)
				user.put_in_hands(B)
		for(var/obj/item/natural/cloth/F in get_turf(src))
			playsound(user, "rustle", 70, FALSE, -4)
			qdel(F)

/obj/item/natural/cloth/examine(mob/user)
	. = ..()
	if(wet)
		. += span_notice("它是湿的！")

// CLEANING

/obj/item/natural/cloth/attack_obj(obj/O, mob/living/user)
	testing("attackobj")
	if(user.client && ((O in user.client.screen) && !user.is_holding(O)))
		to_chat(user, span_warning("我需要先把[O.name]取下来才能清理！"))
		return
	if(istype(O, /obj/effect/decal/cleanable))
		var/cleanme = TRUE
		if(istype(O, /obj/effect/decal/cleanable/blood))
			if(!wet)
				cleanme = FALSE
			add_blood_DNA(O.return_blood_DNA())
		if(prob(33 + (wet*10)) && cleanme)
			wet = max(wet-1, 0)
			user.visible_message(span_info("[user]用[src]擦拭[O.name]。"))
			qdel(O)
		playsound(user, "clothwipe", 100, TRUE)
	else
		if(prob(30 + (wet*10)))
			user.visible_message(span_info("[user]用[src]擦拭[O.name]。"), span_info("我用[src]擦拭[O.name]。"))

			if(O.return_blood_DNA())
				add_blood_DNA(O.return_blood_DNA())
			for(var/obj/effect/decal/cleanable/C in O)
				qdel(C)
			if(!wet)
				SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			else
				SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRONG)
			wet = max(wet-1, 0)
		playsound(user, "clothwipe", 100, TRUE)

/obj/item/natural/cloth/attack_turf(turf/T, mob/living/user)
	if(istype(T, /turf/open/water))
		return ..()
	if(prob(30 + (wet*10)))
		user.visible_message(span_info("[user]用[src]擦拭[T.name]。"), span_info("我用[src]擦拭[T.name]。"))
		if(wet)
			for(var/obj/effect/decal/cleanable/C in T)
				qdel(C)
			wet = max(wet-1, 0)
	playsound(user, "clothwipe", 100, TRUE)


// BANDAGING
/obj/item/natural/cloth/attack(mob/living/M, mob/user)
	testing("attack")
	bandage(M, user)

/obj/item/natural/cloth/wash_act()
	. = ..()
	wet = 10
	bandage_health = initial(bandage_health)
	medicine_amount = 0
	medicine_quality = 0
	update_icon()

/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/C = I
	if(!istype(C))
		return ..()
	if(C.reagents.has_reagent(/datum/reagent/medicine/healthpot, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在治疗药水中..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 10)
			medicine_quality = 1
			medicine_amount += 10
			desc += " 它已被治疗药水浸泡。"
			detail_color = "#ff0000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/medicine/stronghealth, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在强效治疗药水中..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 10)
			medicine_quality = 2
			medicine_amount += 10
			desc += " 它已被强效治疗药水浸泡。."
			detail_color = "#820000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在生命之水中..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10)
			medicine_quality = 0.5 //slower than health potions, more healing overall. Good for fractures or other big wounds.
			medicine_amount += 60
			desc += " 它已被生命之水浸泡。"
			detail_color = "#6e6e6e"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/water/blessed, 10) && !medicine_amount)
		to_chat(user, span_notice("将[src]浸泡在圣水中..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/water/blessed, 10)
			medicine_quality = 0.2 //cheap, easy to get, doesn't even heal wounds if it's not on a bandage
			medicine_amount += 20
			desc += " 它已被祝福之水浸泡。"
			detail_color = "#6a9295"
			update_icon()

/obj/item/natural/cloth/update_icon()
	cut_overlays()
	if(medicine_amount > 0)
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/natural/cloth/proc/bandage(mob/living/M, mob/user)
	if(!M.can_inject(user, TRUE))
		return
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return
	if(affecting.bandage)
		to_chat(user, span_warning("那里已经有一块绷带了。"))
		return
	var/used_time = bandage_speed
	used_time -= ((user.get_skill_level(/datum/skill/misc/medicine) * 0.15) * bandage_speed) //15% time reduction per level
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!move_after(user, used_time, target = M))
		return
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)

	user.dropItemToGround(src)
	affecting.try_bandage(src)
	H.update_damage_overlays()

	if(M == user)
		user.visible_message(span_notice("[user]用绷带包扎好了自己的[affecting]。"), span_notice("我用绷带包扎好了自己的[affecting.name]。"))
	else
		user.visible_message(span_notice("[user]用绷带包扎好了[M]的[affecting]。"), span_notice("我用绷带包扎好了[M]的[affecting.name]。"))

/obj/item/natural/thorn
	name = "荆棘"
	icon_state = "thorn"
	desc = "许多灌木上长出的尖锐突起，形状有点像针。"
	force = 10
	throwforce = 0
	possible_item_intents = list(/datum/intent/stab)
	firefuel = 5 MINUTES
	embedding = list("embedded_unsafe_removal_time" = 20, "embedded_pain_chance" = 10, "embedded_pain_multiplier" = 1, "embed_chance" = 35, "embedded_fall_chance" = 0)
	resistance_flags = FLAMMABLE
	max_integrity = 20

/obj/item/natural/thorn/attack_self(mob/living/user)
	user.visible_message(span_warning("[user]折断了[src]。"))
	playsound(user,'sound/items/seedextract.ogg', 100, FALSE)
	qdel(src)

/obj/item/natural/thorn/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			if(!(HAS_TRAIT(L, TRAIT_AZURENATIVE) || (HAS_TRAIT(L, TRAIT_WOODWALKER)) && L.m_intent != MOVE_INTENT_RUN))
				playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
			if (L.alpha == 0 && L.rogue_sneaking) // not anymore you're not
				L.update_sneak_invis(TRUE)
			if(!HAS_TRAIT(L, TRAIT_WOODWALKER))
				L.consider_ambush()

/obj/item/natural/bundle/fibers
	name = "一捆纤维"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "许多的植物纤维被紧紧地捆成了一个线圈。"
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = "#575e4a"
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/fibers
	icon1step = 3
	icon2step = 6
	grid_width = 32
	grid_height = 32

/obj/item/natural/bundle/fibers/full
	icon_state = "fibersroll2"
	amount = 6
	firefuel = 30 MINUTES
	grid_width = 64

/obj/item/natural/bundle/silk
	name = "蛛丝卷"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "多缕蜘蛛丝被整齐束起，卷成紧实的一团。"
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = "#e6e3db"
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/silk
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/cloth
	name = "一捆布"
	icon_state = "clothroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "多匹布料被卷在一起，以便运输。"
	force = 0
	throwforce = 0
	maxamount = 10
	obj_flags = null
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/cloth
	stackname = "匹布"
	icon1 = "clothroll1"
	icon1step = 5
	icon2 = "clothroll2"
	icon2step = 10
	grid_width = 32
	grid_height = 32
	dropshrink = 0.9

/obj/item/natural/bundle/stick
	name = "一捆木棍"
	icon_state = "stickbundle1"
	possible_item_intents = list(/datum/intent/use)
	desc = "一棍易折，十棍难断。"
	maxamount = 10
	force = 0
	throwforce = 0
	obj_flags = null
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/grown/log/tree/stick
	stackname = "根木棍"
	icon1 = "stickbundle1"
	icon1step = 4
	icon2 = "stickbundle2"
	icon2step = 7
	icon3 = "stickbundle3"

/obj/item/natural/bundle/stick/attackby(obj/item/W, mob/living/user)
	. = ..()
	user.changeNext_move(CLICK_CD_MELEE)
	if(user.used_intent?.blade_class == BCLASS_CUT)
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_info("[user]开始削尖[src]里的木棍..."), span_info("我开始削尖[src]里的木棍..."))
		for(var/i in 1 to (amount - 1))
			if(!do_after(user, 20))
				break
			var/turf/T = get_turf(user.loc)
			var/obj/item/grown/log/tree/stake/S = new /obj/item/grown/log/tree/stake(T)
			amount--
			// If there's only one stick left in the bundle...
			if (amount == 1)
				// Replace the bundle with a single stick
				var/obj/item/ST = new stacktype(T)
				if(user.is_holding(src))
					user.doUnEquip(src, TRUE, T, silent = TRUE)
				qdel(src)
				var/holding = user.put_in_hands(ST)
				// And automatically have us try and carve the last new stick, assuming we're still holding it!
				if(!do_after(user, 20))
					break
				S = new /obj/item/grown/log/tree/stake(T)
				if(holding)
					user.doUnEquip(ST, TRUE, T, silent = TRUE)
				qdel(ST)
			else
				update_bundle()
			user.put_in_hands(S)
			S.pixel_x = rand(-3, 3)
			S.pixel_y = rand(-3, 3)
		return

/obj/item/natural/bundle/bone
	name = "一堆骨头"
	icon_state = "bonestack1"
	possible_item_intents = list(/datum/intent/use)
	desc = "这些死者的遗骸被捆在了一起。"
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = null
	firefuel = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/bone
	stackname = "根骨头"
	icon1 = "bonestack1"
	icon2 = "bonestack2"

/obj/item/natural/bundle/bone/full
	amount = 6

/obj/item/natural/bundle/bone/rdm

/obj/item/natural/bundle/bone/rdm/Initialize(mapload)
	..()
	amount = rand(2,6)
/*/obj/item/natural/bone/attackby(obj/item/I, mob/living/user, params)
	var/mob/living/carbon/human/H = user
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(I, /obj/item/natural/bone))
		var/obj/item/natural/bundle/bone/F = new(src.loc)
		H.put_in_hands(F)
		H.visible_message("[user]把骨头扎成了一捆。")
		qdel(I)
		qdel(src)
	if(istype(I, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/B = I
		if(B.amount < B.maxamount)
			H.visible_message("[user]把[src]加进了骨捆里。")
			B.amount += 1
			B.update_bundle()
			qdel(src)
	..()*/

/obj/item/natural/bowstring
	name = "纤维弓弦"
	desc = "浸蜡后的纤维丝线被绞成一体，制成了闭合的弓弦。"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	obj_flags = null
	color = COLOR_BEIGE
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE

/obj/item/natural/bowstring/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bow,
		/datum/crafting_recipe/roguetown/survival/recurvebow,
		/datum/crafting_recipe/roguetown/survival/longbow,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/bundle/worms
	name = "一堆蠕虫"
	desc = "一小堆泥土中的微小生物正在其中蠕动翻卷。"
	color = "#964B00"
	maxamount = 12
	icon_state = "worm2"
	icon1 = "worm2"
	icon1step = 6
	icon2 = "worm4"
	icon2step = 12
	icon3 = "worm6"
	stacktype = /obj/item/natural/worms
	stackname = "蠕虫"
	bundling_time = 1 SECONDS

/obj/item/natural/worms/attack_right(mob/user)
	to_chat(user, span_warning("我开始收集[src]……"))
	if(move_after(user, bundling_time, target = src))
		var/wormcount = 0
		for(var/obj/item/natural/worms/F in get_turf(src))
			wormcount++
		while(wormcount > 0)
			if(wormcount == 1)
				new /obj/item/natural/worms(user.drop_location())
				wormcount--
			else if(wormcount >= 2)
				var/obj/item/natural/bundle/worms/B = new(user.drop_location())
				B.amount = clamp(wormcount, 2, 12)
				B.update_bundle()
				wormcount -= clamp(wormcount, 2, 12)
				user.put_in_hands(B)
		for(var/obj/item/natural/worms/F in get_turf(src))
			qdel(F)
