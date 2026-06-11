//Eora content from Stonekeep

/obj/item/clothing/head/peaceflower
	name = "Eora 花苞"
	desc = "一朵花瓣柔和的花，与 Eora 或 Necra 相关。通常被佩作头饰，或置于墓前，象征爱与安宁。"
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "peaceflower"
	item_state = "peaceflower"
	dropshrink = 0.9
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	dynamic_hair_suffix = ""
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	dropshrink = 0.8

/obj/item/clothing/head/peaceflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		var/trait_given = user?.patron?.type == /datum/patron/divine/eora ? TRAIT_EORAN_CONTENTED : TRAIT_PACIFISM
		ADD_TRAIT(user, trait_given, "peaceflower_[REF(src)]")
		user.apply_status_effect(/datum/status_effect/buff/peaceflower)

/obj/item/clothing/head/peaceflower/dropped(mob/living/carbon/human/user)
	var/trait_given = user?.patron?.type == /datum/patron/divine/eora ? TRAIT_EORAN_CONTENTED : TRAIT_PACIFISM
	REMOVE_TRAIT(user, trait_given, "peaceflower_[REF(src)]")
	if(istype(user) && (user?.head == src || user?.wear_mask == src))
		user.remove_status_effect(/datum/status_effect/buff/peaceflower)
	return ..()

/datum/status_effect/buff/peaceflower
	id = "peaceflower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/peaceflower
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 1) // These are the stats that the eoran tree affect

/atom/movable/screen/alert/status_effect/buff/peaceflower
	name = "Eora 花苞"
	desc = "Eora 的美丽令我的心神变得澄澈而敏锐。"
	icon_state = "buff"

/obj/item/clothing/head/peaceflower/proc/peace_check(mob/living/user)
	// return true if we should be unequippable, return false if not
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head || src == C.wear_mask)
			to_chat(user, "<span class='warning'>我感到无比平静。<b style='color:pink'>我为何还会想要别的东西？</b></span>")
			return TRUE
	return FALSE

/obj/item/clothing/head/peaceflower/MouseDrop(atom/over_object)
	if (!peace_check(usr))
		return ..()

/obj/item/clothing/head/peaceflower/attack_hand(mob/user)
	if (!peace_check(user))
		return ..()


/obj/effect/proc_holder/spell/invoked/bud
	name = "Eora 绽放"
	desc = "尝试在目标地块，或目标的头顶长出一枚 Eora 花苞，在它被移除前令其思绪远离暴力。"
	clothes_req = FALSE
	range = 7
	overlay_state = "love"
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/bud/cast(list/targets, mob/living/user)
	var/target = targets[1]
	if(istype(target, /mob/living/carbon/human)) //Putting flower on head check
		var/mob/living/carbon/human/C = target
		if(!C.get_item_by_slot(SLOT_HEAD))
			var/obj/item/clothing/head/peaceflower/F = new(get_turf(C))
			C.equip_to_slot_if_possible(F, SLOT_HEAD, TRUE, TRUE)
			to_chat(C, "<span class='info'>一朵 Eora 之花在我头顶绽放。我感到无比平和。</span>")
			return TRUE
		else
			to_chat(user, "<span class='warning'>目标的头部被遮住了。Eora 之花需要一片开阔处才能绽放。</span>")
			revert_cast()
			return FALSE
	var/turf/T = get_turf(targets[1])
	if(!isclosedturf(T))
		new /obj/item/clothing/head/peaceflower(T)
		return TRUE
	to_chat(user, "<span class='warning'>目标位置被阻挡了。Eora 之花拒绝在此生长。</span>")
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/eoracurse
	name = "Eora 的诅咒"
	desc = "令目标同时陷入恍惚与醉意。"
	overlay_state = "curse2"
	releasedrain = 50
	chargetime = 30
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/whiteflame.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/eoracurse/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/druqks)
		target.apply_status_effect(/datum/status_effect/buff/drunk)
		target.visible_message("<span class='info'>一阵紫色雾气笼罩了 [target]！</span>", "<span class='notice'>我感觉平静多了。</span>")
		//target.blur_eyes(10)
		return TRUE
	revert_cast()
	return FALSE

// =====================
// Eora Bond Component
// =====================
/datum/component/eora_bond
	var/mob/living/carbon/partner
	var/mob/living/carbon/caster
	var/duration = 900 SECONDS
	var/max_distance = 15
	var/damage_share = 0.4
	var/heal_share = 0.4
	var/wound_chance = 15
	var/ispartner = FALSE
	can_transfer = TRUE

/datum/component/eora_bond/partner
	ispartner = TRUE

/datum/component/eora_bond/Initialize(mob/living/partner_mob, mob/living/caster_mob, holy_skill)
	if(!isliving(parent) || !isliving(partner_mob))
		return COMPONENT_INCOMPATIBLE

	// Prevent duplicate bonds
	var/datum/component/eora_bond/existing = parent.GetComponent(/datum/component/eora_bond)
	if(existing)
		return COMPONENT_INCOMPATIBLE

	partner = partner_mob
	caster = caster_mob

	var/bonus_mod = 0
	if(holy_skill >= 4)
		bonus_mod = 0.05
	damage_share = 0.1 + (0.05 * holy_skill) + bonus_mod
	heal_share = 0.1 + (0.05 * holy_skill) + bonus_mod
	wound_chance = 40 - (5 * holy_skill)

	// Correct signal name
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_heal))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))

	START_PROCESSING(SSprocessing, src)
	addtimer(CALLBACK(src, PROC_REF(remove_bond)), duration)

	var/mob/living/L = parent
	L.apply_status_effect(/datum/status_effect/eora_bond)
	return ..()

/datum/component/eora_bond/proc/on_damage(datum/source, damage, damagetype, def_zone)
	if( !isliving(partner) || !ispartner)
		return

	var/mob/living/carbon/L = caster
	var/shared_damage = damage * damage_share

	if(damagetype == BRUTE)
		//Heal our buddy <3
		var/list/wCount = partner.get_wounds()
		if(wCount.len > 0)
			partner.heal_wounds(shared_damage)
			partner.update_damage_overlays()
		partner.adjustBruteLoss(-shared_damage, 0)

		var/obj/item/bodypart/BP = null
		BP = L.get_bodypart(check_zone(def_zone))
		if(!BP)
			BP = L.get_bodypart(BODY_ZONE_CHEST)
		BP.receive_damage(shared_damage, 0)
		L.update_damage_overlays()
		//Potentially bite ourselves :(
		if(prob(wound_chance))
			L.visible_message(span_danger("[L] 的伤口鲜血狂涌！"))
			BP.add_wound(/datum/wound/bite/small)

/datum/component/eora_bond/proc/on_heal(datum/source, healing_on_tick, healing_datum)
	if( !isliving(parent) || source != parent || istype(healing_datum, /datum/status_effect/buff/healing/eora) || HAS_TRAIT(parent, TRAIT_PSYDONITE))
		return

	healing_on_tick = healing_on_tick * heal_share
	var/mob/living/target_to_heal
	if(parent == caster)
		target_to_heal = partner
	else
		target_to_heal = caster

	target_to_heal.apply_status_effect(/datum/status_effect/buff/healing/eora, healing_on_tick)

/datum/component/eora_bond/proc/on_deletion()
	remove_bond()

/datum/component/eora_bond/process()
	//If this turns out to be too costly, make this based on the movement signal instead.
	var/mob/living/M = parent
	if(!istype(M) || !istype(partner) || M.stat == DEAD || partner.stat == DEAD || get_dist(M, partner) > max_distance)
		remove_bond()

/datum/component/eora_bond/proc/remove_bond()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/eora_bond)
		UnregisterSignal(L, list(
			COMSIG_MOB_APPLY_DAMGE,
			COMSIG_LIVING_MIRACLE_HEAL_APPLY,
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/eora_bond)
		var/datum/component/eora_bond/other = partner.GetComponent(/datum/component/eora_bond)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/datum/status_effect/buff/healing/eora

// =====================
// Heartweave Spell
// =====================
/obj/effect/proc_holder/spell/invoked/heartweave
	name = "心丝共织"
	desc = "在两道灵魂之间结成共生之纽带。"
	overlay_state = "bliss"
	range = 1
	chargetime = 0.5 SECONDS
	invocations = list("借 Eora 之恩，让我们的命运交缠吧！")
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/heartweave/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/eora_bond/existing = user.GetComponent(/datum/component/eora_bond)
	if(existing)
		to_chat(user, span_warning("你已经与他人结下了纽带！"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 2 SECONDS, target = target))
		to_chat(user, span_warning("缔结纽带需要全神贯注！"))
		revert_cast()
		return FALSE

	var/consent = alert(target, "[user] 向你献上生命连结。接受吗？", "心丝共织", "接受", "拒绝")
	if(consent != "接受" || QDELETED(target))
		to_chat(user, span_warning("这道纽带被拒绝了。"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	// Add component to both participants without mutual recursion
	user.AddComponent(/datum/component/eora_bond, target, user, holy_skill)
	target.AddComponent(/datum/component/eora_bond/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("[user] 与 [target] 之间结起了一道金色丝缕！"),
		span_notice("你感到 [target] 的生命力与自己连结在了一起。")
	)
	return TRUE

// =====================
// Status Effect
// =====================

#define HEARTWEAVE_FILTER "heartweave"

/datum/status_effect/eora_bond
	id = "eora_bond"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/eora_bond
	var/outline_colour = "#FF69B4"

/atom/movable/screen/alert/status_effect/eora_bond
	name = "Eora 之绊"
	desc = "你的生命力与另一道灵魂相连。"

/datum/status_effect/eora_bond/on_apply()
	var/filter = owner.get_filter(HEARTWEAVE_FILTER)
	if (!filter)
		owner.add_filter(HEARTWEAVE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/eora_bond/on_remove()
	owner.remove_filter(HEARTWEAVE_FILTER)

#define BLESSED_FOOD_FILTER "blessedfood"

/datum/component/blessed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/caster
	var/quality
	var/skill
	var/bitesize_mod
	var/Eo_buff
	// I hate this but let's be consistent.
	var/datum/patron/patron

/datum/component/blessed_food/Initialize(mob/living/_caster, holy_skill, patron_init)
	if(!isitem(parent) || !istype(parent, /obj/item/reagent_containers/food/snacks))
		return COMPONENT_INCOMPATIBLE

	caster = _caster
	skill = holy_skill
	var/obj/item/reagent_containers/food/snacks/F = parent
	//Better food being blessed heals more
	quality = F.faretype
	bitesize_mod = 1 / F.bitesize
	patron = patron_init
	F.faretype = clamp(skill, 1, 5)
	if(skill < 5 || patron.type != /datum/patron/divine/eora)
		F.add_filter(BLESSED_FOOD_FILTER, 1, list("type" = "outline", "color" = "#ff00ff", "size" = 1))
	else
		F.add_filter(BLESSED_FOOD_FILTER, 1, list("type" = "outline", "color" = "#f0b000", "size" = 1))
	RegisterSignal(F, COMSIG_FOOD_EATEN, PROC_REF(on_food_eaten))

/datum/component/blessed_food/proc/on_food_eaten(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	if(eater == caster)
		eater.visible_message(span_notice("神圣能量在 [caster] 身边无害地噼啪消散。"))
		return

	eater.apply_status_effect(/datum/status_effect/buff/healing, (quality + (skill / 5)) * bitesize_mod)
	if(skill > 4 || patron.type == /datum/patron/divine)
		eater.apply_status_effect(/datum/status_effect/buff/haste, 55 SECONDS)

/obj/effect/proc_holder/spell/invoked/bless_food
	name = "祝福食物"
	invocations = list("Eora，请滋养这份供品！")
	desc = "祝福一件食物。进食耗时越久的食物，治疗速度越慢。熟练的教士能更频繁地祝福食物。越精致的食物治疗效果越强。Eora 的大师甚至能令食物染上金辉。"
	sound = 'sound/magic/magnet.ogg'
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	devotion_cost = 25
	recharge_time = 90 SECONDS
	overlay_state = "bread"
	associated_skill = /datum/skill/magic/holy
	var/base_recharge_time = 90 SECONDS

/obj/effect/proc_holder/spell/invoked/bless_food/cast(list/targets, mob/living/user)
	var/obj/item/target = targets[1]
	if(!istype(target, /obj/item/reagent_containers/food/snacks))
		to_chat(user, span_warning("你只能祝福食物！"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	var/mob/living/carbon/human/H = user
	var/patron = FALSE
	if(ishuman(H))
		patron = user.patron
	target.AddComponent(/datum/component/blessed_food, user, holy_skill, patron)
	to_chat(user, span_notice("你以 Eora 的慈爱祝福了 [target]！"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/bless_food/start_recharge()
	if(ranged_ability_user)
		var/holy_skill = ranged_ability_user.get_skill_level(associated_skill)
		// Reduce recharge by 6 seconds per skill level
		var/skill_reduction = (6 SECONDS) * holy_skill
		recharge_time = base_recharge_time - skill_reduction
		// Ensure recharge doesn't go below 0
		if(recharge_time < 0)
			recharge_time = 0
	else
		recharge_time = base_recharge_time

	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/invoked/pomegranate
	name = "绯榴圣域"
	invocations = list("Eora，请为你的美丽降下庇护！")
	desc = "种出一棵石榴树，只要悉心照料，便会结出具有各种效果的 Auril。除此之外，它还会治疗美丽之人，并对视野范围内的所有人大幅削弱力量与感知。"
	sound = 'sound/magic/magnet.ogg'
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	devotion_cost = 500
	recharge_time = 5 SECONDS
	chargetime = 1 SECONDS
	overlay_state = "tree"
	associated_skill = /datum/skill/magic/holy
	var/obj/structure/eoran_pomegranate_tree/my_little_tree = null

/obj/effect/proc_holder/spell/invoked/pomegranate/cast(list/targets, mob/living/user)
	. = ..()

	if(QDELETED(my_little_tree))
		my_little_tree = null

	if(my_little_tree)
		to_chat(user, span_warning("我无法同时为 Eora 维系超过一棵树。无论多么不忍，我都得先处理掉另一棵。"))
		revert_cast()
		return FALSE

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("目标位置被阻挡了。Eora 的种子无法在这里萌芽。"))
		revert_cast()
		return FALSE
	if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/grassyel) || istype(T, /turf/open/floor/rogue/grassred) || istype(T, /turf/open/floor/rogue/grasscold) || istype(T, /turf/open/floor/rogue/desert_grass)))
		to_chat(user, span_warning("这棵树无法在这里生长。它必须种在泥土或草地上！"))
		revert_cast()
		return FALSE

	to_chat(user, span_notice("我开始在这里培育 Eora 的圣树了。若我并不想把唯一的一棵种在这里，现在就该停手再想想。"))
	if(do_after(user, 30 SECONDS, FALSE))
		var/obj/structure/eoran_pomegranate_tree/tree = new /obj/structure/eoran_pomegranate_tree(T)
		my_little_tree = tree
		return TRUE

#define SPROUT 0
#define GROWING 1
#define MATURING 2
#define FRUITING 3

/obj/structure/eoran_pomegranate_tree
	name = "石榴圣树"
	desc = "一棵受 Eora 祝福的神秘树木。"
	icon = 'modular_azurepeak/icons/obj/items/eora_tree.dmi'
	icon_state = "sprout"
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	pixel_x = -8

	// Growth tracking
	var/growth_stage = SPROUT
	var/growth_progress = 0
	var/growth_threshold = 100
	var/time_to_mature = 10 MINUTES // Total time from sprout 0% to fully grown 100% through GROWING stage
	var/time_to_grow_fruit = 6 MINUTES //Fairly long but these fruits are potentially really good and there can be multiple acolytes
	var/fruit = FALSE
	var/fruit_ready = FALSE

	// Tree care system
	var/happiness = 0
	var/water_happiness = 0
	var/fertilizer_happiness = 0
	var/prune_count = 0
	var/list/tree_offerings = list()
	var/happiness_tier = 1

	/// Range of the aura
	var/aura_range = 7
	/// List of mobs currently affected by our aura
	var/list/mob/living/affected_mobs = list()
	var/ash_offered = FALSE
	var/ash_effect_start_time = 0
	var/creation_time
	var/fruit_doubled = FALSE

/obj/structure/eoran_pomegranate_tree/proc/get_farming_skill(mob/user)
	return user.get_skill_level(/datum/skill/labor/farming)

/obj/structure/eoran_pomegranate_tree/proc/update_happiness_tier()
	if(happiness >= 100)
		happiness_tier = 4
	else if(happiness >= 75)
		happiness_tier = 3
	else if(happiness >= 50)
		happiness_tier = 2
	else
		happiness_tier = 1

/obj/structure/eoran_pomegranate_tree/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/eoran_aril/crimson))
		if(iscarbon(user))
			var/mob/living/carbon/human/sacrifice = user
			user.visible_message(
				span_danger("[user] 开始无私地引导绯红果粒之力来修复这棵树。"),
				span_info("我开始用自己的鲜血，把绯红果粒的力量灌入树中。")
			)
			if(!do_after(sacrifice, 15 SECONDS))
				return
			sacrifice.blood_volume = max(0, sacrifice.blood_volume - ((BLOOD_VOLUME_NORMAL * 0.03) + (sacrifice.blood_volume * 0.06)))
			obj_integrity = min(max_integrity, obj_integrity + max_integrity / 4)
			qdel(I)
			update_icon()
			return TRUE
	if(istype(I, /obj/item/ash))
		if(iscarbon(user))
			var/mob/living/carbon/c = user
			if(c.patron.type != /datum/patron/divine/eora)
				to_chat(user, span_warning("这棵树拒绝了你的供奉。只有 Eora 的追随者才能向它献上灰烬。"))
				return TRUE
		if(ash_offered)
			to_chat(user, span_warning("继续往树上覆灰似乎激怒了它，叶片猛然舒张，灰烬纷纷抖落在地，光环也重新燃起。"))
			qdel(I)
			ash_offered = FALSE
			aura_range = 7
			return TRUE

		qdel(I)
		ash_offered = TRUE
		ash_effect_start_time = world.time
		to_chat(user, span_notice("当你将灰烬覆上叶片时，这棵树微微颤抖。叶子仿佛略微枯萎了一些，而它的光环也开始减弱。"))
		update_icon()
		return TRUE

	if(istype(I, /obj/item/rogueweapon/huntingknife/scissors) || (istype(I, /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr) && user.used_intent.type == /datum/intent/snip))
		if(prune_count >= 1)
			to_chat(user, span_warning("这棵树已经被修剪到极致了！"))
			return TRUE
		var/skill = get_farming_skill(user)
		var/prune_time = 10 SECONDS - (skill * 2.5 SECONDS)

		to_chat(user, span_notice("你开始修剪这棵树……"))

		if(do_after(user, prune_time, target = src))
			prune_count++
			happiness = min(happiness + 5, 100)
			update_happiness_tier()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)
			
			to_chat(user, span_notice("你修去了几根枝条。"))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/reagent_containers) && !istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/container = I
		if(water_happiness >= 25)
			to_chat(user, span_warning("这棵树现在已经无法再吸收更多水分了！"))
			return TRUE

		var/water_type = null
		if(container.reagents.has_reagent(/datum/reagent/water, 20))
			water_type = /datum/reagent/water
		else if(container.reagents.has_reagent(/datum/reagent/water/blessed, 20))
			water_type = /datum/reagent/water/blessed

		if(!water_type)
			to_chat(user, span_warning("这棵树只接受新鲜洁净的清水。"))
			return

		var/remaining_cap = 40 - water_happiness
		var/actual_gain = remaining_cap

		if(do_after(user, 1 SECONDS, target = src))
			container.reagents.remove_reagent(water_type, 20)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)

			water_happiness += actual_gain
			happiness = min(happiness + actual_gain, 100)
			update_happiness_tier()

			to_chat(user, span_notice("你给这棵树浇了水。"))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/compost) || istype(I, /obj/item/fertilizer))
		if(istype(I, /obj/item/fertilizer) && growth_stage != FRUITING)
			to_chat(user, span_warning("The tree won't absorb the fertilizer properly until it is maturing or fully grown."))
			return TRUE

		if(fertilizer_happiness >= 25)
			to_chat(user, span_warning("这棵树现在已经无法再吸收更多养分了！"))
			return TRUE

		var/remaining_cap = 25 - fertilizer_happiness
		var/skill = get_farming_skill(user)
		var/potential_gain = max(5 + (skill * 4), 13)  // A maximum of 13 ensures at most 2 applications of compost
		var/actual_gain = min(potential_gain, remaining_cap)

		if(do_after(user, 1 SECONDS, target = src))
			qdel(I)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 0.5)

			fertilizer_happiness += actual_gain
			happiness = min(happiness + actual_gain, 100)
			update_happiness_tier()

			to_chat(user, span_notice("你为这棵树施了肥。"))
			update_icon()
			return TRUE

	if(istype(I, /obj/item/roguegem/ruby) || istype(I, /obj/item/alch/transisdust) || istype(I, /obj/item/reagent_containers/food/snacks/eoran_aril/opalescent))

		if(I.type in tree_offerings)
			to_chat(user, span_warning("这个物品已经献给过这棵树了！"))
			return TRUE

		if(length(tree_offerings) >= 3)
			to_chat(user, span_warning("这棵树暂时已经收到了足够的供奉！"))
			return TRUE

		qdel(I)
		tree_offerings += I.type
		
		happiness = min(happiness + 10, 100)
		update_happiness_tier()

		to_chat(user, span_notice("树叶轻轻一颤，这棵树优雅地接受了你的供奉。"))
		update_icon()
		return TRUE

	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			if(iscarbon(user))
				var/mob/living/carbon/c = user
				if(c.patron.type == /datum/patron/divine/eora)
					c.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
				else
					to_chat(c, span_warning("你因摧毁圣树而遭到了神圣诅咒！"))
					c.adjustFireLoss(100)
					c.ignite_mob()
					c.add_stress(/datum/stressevent/psycurse)
			SEND_SIGNAL(user, COMSIG_MOB_FELL_TREE)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			record_round_statistic(STATS_TREES_CUT)

/obj/structure/eoran_pomegranate_tree/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0)
	if(ash_offered)
		ash_offered = FALSE
		aura_range = 7
		visible_message(span_notice("树身在受创时猛地一颤，原本覆在叶片上的灰烬被尽数震落，光环也再度燃起。"))
	else
		visible_message(span_notice("这棵树在受创时颤抖起来。一股令人不安的恐惧自它体内弥漫而出。"))
	. = ..()

/obj/structure/eoran_pomegranate_tree/examine(mob/user)
	. = ..()
	if(!ash_offered)
		. += span_warning("叶片正散发出明亮而削弱他人的光环，也许覆上灰烬就能阻止这一点。")
	else
		. += span_warning("叶片已覆满灰烬而显得黯淡，不再散发光环。或许再添些灰烬会带来别的变化。")

	if(happiness_tier == 1)
		. += span_warning("这棵树似乎长期遭到忽视，枝条都已枯萎。")
	else if(happiness_tier == 2)
		. += span_info("这棵树看起来安宁而健康。")
	else if(happiness_tier == 3)
		. += span_good("这棵树正散发着旺盛蓬勃的生机。")
	else if(happiness_tier == 4)
		. += span_good("这棵树通体流转着炽亮的辉光。你感到……完美。")

	if(water_happiness < 25)
		. += span_info("它还需要更多水分。")
	else
		. += span_info("它已经喝得很饱了。")

	if(fertilizer_happiness < 25)
		. += span_info("它的根系还需要更多养分。")
	else
		. += span_info("它已经被彻底滋养。")

	if(prune_count < 1)
		. += span_info("枝条看起来有些凌乱。也许一把剪刀能理顺这团纷乱。")
	else
		. += span_info("枝条已经被精心修剪妥当。")

	if(length(tree_offerings) < 3)
		. += span_info("这棵树仍渴望供奉。低语钻入你的脑海：一枚闪烁的红晶……某种能塑造形体之物……一粒闪闪发亮的种子……")

	if(growth_stage == FRUITING && user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_JOURNEYMAN)
		if(fruit_ready)
			. += span_good("The fruit is ripe and ready to harvest.")
		else if(fruit)
			. += span_info("The fruit is almost ripe.")
		else
			var/effective_fruit_time = (fertilizer_happiness > 0) ? time_to_grow_fruit / 2 : time_to_grow_fruit
			var/remaining_seconds = round(((growth_threshold - growth_progress) / (growth_threshold * 0.25)) * effective_fruit_time / 10)
			var/minutes = round(remaining_seconds / 60)
			var/secs = remaining_seconds % 60
			. += span_info("My farming experience tells me the fruit will start to bear in roughly [minutes > 0 ? "[minutes] minute\s" : ""][minutes > 0 && secs > 0 ? " and " : ""][secs > 0 ? "[secs] second\s" : ""].")

/obj/structure/eoran_pomegranate_tree/proc/reset_care()
	//The benefit of rare offerings are kept through harvests.
	happiness = 0 + (10 * length(tree_offerings))
	water_happiness = 0
	fertilizer_happiness = 0
	prune_count = 0
	update_happiness_tier()
	update_icon()

/obj/structure/eoran_pomegranate_tree/Initialize(mapload)
	. = ..()
	update_icon()
	START_PROCESSING(SSobj, src)
	creation_time = world.time

/obj/structure/eoran_pomegranate_tree/process(delta_time)
	var/delta_seconds = delta_time / 10 // Convert delta_time (ticks) to seconds Delta time is the amount of time that has passed since the last time process was called.

	var/target_growth_rate_per_second = 0

	if(ash_offered)
		var/time_since_ash = world.time - ash_effect_start_time
		if(time_since_ash >= 30 SECONDS)
			aura_range = 0
		else if(time_since_ash >= 15 SECONDS)
			aura_range = round(aura_range / 2)

	if(!fruit_doubled && (world.time - creation_time) >= 40 MINUTES)
		fruit_doubled = TRUE
		visible_message(span_notice("这棵树已经彻底成熟，如今能结出更多果实了！"))

	if(growth_progress >= 50)
		var/list/current_mobs = list()
		var/atom/A = src

	// Get all mobs in range
		var/list/mobs_in_range
		mobs_in_range = view(aura_range, A)

		for(var/mob/living/L in mobs_in_range)
			//Unconscious people can't harm others. Nor can they observe trees. Dead people are food.
			if(L.stat == UNCONSCIOUS)
				continue
			current_mobs += L

			// Apply effects if new mob
			if(!affected_mobs[L])
				apply_effects(L)
				affected_mobs[L] = TRUE

		// Remove effects from mobs that left range
		for(var/mob/living/L in affected_mobs - current_mobs)
			remove_effects(L)
			affected_mobs -= L

	if (growth_stage == FRUITING && !fruit)
		// We need to grow from 75% to 100% in time_to_grow_fruit
		var/progress_needed_in_fruiting = growth_threshold * 0.25
		var/effective_fruit_time = (fertilizer_happiness > 0) ? time_to_grow_fruit / 2 : time_to_grow_fruit

		if (effective_fruit_time > 0)
			target_growth_rate_per_second = progress_needed_in_fruiting / (effective_fruit_time / 10)
		else
			target_growth_rate_per_second = growth_threshold // Grow instantly if time is 0
	else
		if (time_to_mature > 0)
			target_growth_rate_per_second = growth_threshold / (time_to_mature / 10)
		else
			target_growth_rate_per_second = growth_threshold // Grow instantly if time is 0

	growth_progress = min(growth_progress + (target_growth_rate_per_second * delta_seconds), growth_threshold)

	check_growth_stage()

/obj/structure/eoran_pomegranate_tree/proc/apply_effects(mob/living/target)
	if(!HAS_TRAIT(target, TRAIT_EORAN_CALM))
		target.apply_status_effect(/datum/status_effect/debuff/pomegranate_aura, src)

/obj/structure/eoran_pomegranate_tree/proc/remove_effects(mob/living/target)
	target.remove_status_effect(/datum/status_effect/debuff/pomegranate_aura)

/obj/structure/eoran_pomegranate_tree/proc/check_growth_stage()
	switch(growth_stage)
		if(SPROUT)
			if(growth_progress >= 25)
				advance_stage(GROWING)
		if(GROWING)
			if(growth_progress >= 50)
				advance_stage(MATURING)
		if(MATURING)
			if(growth_progress >= 75)
				advance_stage(FRUITING)
		if(FRUITING)
			if(!fruit && growth_progress >= growth_threshold)
				spawn_fruit()

/obj/structure/eoran_pomegranate_tree/proc/advance_stage(new_stage)
	growth_stage = new_stage
	update_icon()
	visible_message(span_notice("[name] 长大了一圈！"))

	if(new_stage == FRUITING)
		spawn_fruit()

/obj/structure/eoran_pomegranate_tree/proc/spawn_fruit()
	if(fruit)  // Already has fruit
		return

	fruit = TRUE
	fruit_ready = FALSE
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(ripen_fruit)), rand(10 SECONDS, 15 SECONDS))

/obj/structure/eoran_pomegranate_tree/proc/ripen_fruit()
	fruit_ready = TRUE
	visible_message(span_notice("[src] 上的果实开始散发出温暖的光辉！"))
	update_icon()

/obj/structure/eoran_pomegranate_tree/update_icon()
	// Base icon states
	switch(growth_stage)
		if(SPROUT)
			icon_state = "sprout"
		if(GROWING)
			icon_state = "growing"
		if(MATURING)
			icon_state = "mature"
		if(FRUITING)
			icon_state = "fruiting"

	cut_overlays()

	if(growth_stage == FRUITING && fruit_ready)
		var/image/fruit_image = image(icon = initial(icon), icon_state = "fruit[happiness_tier]", layer = 1)
		add_overlay(fruit_image)

	. = ..()

/datum/status_effect/pomegranate_fatigue
	id = "pom_fatigue"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/pomegranate_fatigue

/datum/status_effect/pomegranate_fatigue/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_SANITY, update=TRUE, priority=100, override=FALSE, multiplicative_slowdown=0.5)

/datum/status_effect/pomegranate_fatigue/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
	return ..()

/atom/movable/screen/alert/status_effect/pomegranate_fatigue
	name = "神力疲乏"
	desc = "石榴中蕴含的神圣力量令你感到虚弱。"

/obj/structure/eoran_pomegranate_tree/attack_hand(mob/living/user)
	if(!fruit_ready || !fruit)
		return ..()

	if(!can_pick_fruit(user))
		return

	user.visible_message(
		span_notice("[user] 小心翼翼地摘下了果实。"),
		span_notice("你轻轻摘下了那枚发光的石榴。")
	)

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		add_sleep_experience(user, /datum/skill/labor/farming, C.STAINT * 3)
	var/obj/item/fruit_of_eora/new_fruit = new(user.loc, happiness_tier, fruit_doubled)
	user.put_in_hands(new_fruit)

	// Apply picking debuff
	user.apply_status_effect(/datum/status_effect/pomegranate_fatigue)

	// Reset tree
	fruit = FALSE
	fruit_ready = FALSE
	growth_progress = 75 // Return to fruiting stage baseline
	reset_care()
	update_icon()

// Check if user can pick fruit
/obj/structure/eoran_pomegranate_tree/proc/can_pick_fruit(mob/living/user)
	if(!fruit_ready)
		to_chat(user, span_warning("这枚果实还没成熟！"))
		return FALSE

	// Eoran alignment check
	if(!(user.patron.type == /datum/patron/divine/eora))
		to_chat(user, span_warning("当你伸手去摘时，这枚果实直接消失了！"))
		return FALSE

	return TRUE

/obj/item/fruit_of_eora
	name = "石榴"
	desc = "一枚散发内在辉光的神秘石榴。触手生温。"
	icon = 'modular_azurepeak/icons/obj/items/eora_pom.dmi'
	icon_state = "pom"
	var/fruit_tier = 1
	var/list/aril_types = list()
	var/opened = FALSE
	var/fruit_doubled = FALSE

/obj/item/fruit_of_eora/Initialize(mapload, tier = 1, doubled = FALSE)
	. = ..()
	fruit_tier = tier
	fruit_doubled = doubled
	generate_arils()
	update_pom()

/obj/item/fruit_of_eora/proc/update_pom()
	switch(fruit_tier)
		if(1)
			name = "腐坏石榴"
			desc = "一枚已经腐坏的石榴。"
			icon_state = "rotten"
		if(2)
			name = "瑕疵石榴"
			desc = "一枚带着瑕疵的石榴，通体泛着天青般的蓝色。"
			icon_state = "blemished"
		if(3)
			desc = "一枚生机盎然、内蕴光辉搏动的石榴。它正散发着暖意。"
			icon_state = "pom"
		if(4)
			name = "金色石榴"
			desc = "一枚完美无瑕、燃烧着神圣光辉的金色石榴。它仿佛活着一般，像心脏那样跳动不止。"
			icon_state = "golden"

/obj/item/fruit_of_eora/proc/generate_arils()
	aril_types = list()
	var/list/possible_arils

	// Define aril tables by tier
	switch(fruit_tier)
		if(1)
			return
		if(2)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 50,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 20
			)
		if(3)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 30,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean = 20,
				/obj/item/reagent_containers/food/snacks/eoran_aril/fractal = 5
			)
		if(4)
			possible_arils = list(
				/obj/item/reagent_containers/food/snacks/eoran_aril/crimson = 15,
				/obj/item/reagent_containers/food/snacks/eoran_aril/roseate = 5,
				/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent = 10,
				/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean = 15,
				/obj/item/reagent_containers/food/snacks/eoran_aril/fractal = 5,
				/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 4,
				/obj/item/reagent_containers/food/snacks/eoran_aril/ashen = 1,
				/obj/item/reagent_containers/food/snacks/eoran_aril/ochre = 5,
				/obj/item/reagent_containers/lux/eoran_aril = 1, //Lux equivalent
				/obj/item/reagent_containers/eoran_seed = 1 // Seed for more trees
			)

	// Generate 4 arils +1 per tier.
	var/num_arils = 4 + (floor(fruit_tier / 2))
	if(fruit_doubled)
		num_arils *= 2

	for(var/i in 1 to num_arils)
		var/aril_type = pickweight(possible_arils)
		aril_types += aril_type

/obj/item/fruit_of_eora/attackby(obj/item/I, mob/user)
	if(!opened && I.get_sharpness())
		if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc) \
			)
			to_chat(user, span_warning("我需要借助一张桌子。"))
			return FALSE
		open_fruit(user)
		return TRUE
	return ..()

/obj/item/fruit_of_eora/proc/open_fruit(mob/user)
	if(opened)
		return

	to_chat(user, span_notice("你小心地剖开石榴，露出了里面发光的种子。"))
	playsound(src, 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1)
	opened = TRUE

	for(var/aril_type in aril_types)
		new aril_type(loc)

		// if you've tended your tree perfectly, are eligible to pick fruit, pray over the pomegranate, and haven't gotten one already, you get a guaranteed seed
	var/mob/living/living_user = user
	if(istype(living_user)\
		&& (fruit_tier == 4)\
		&& ((living_user.patron.type == /datum/patron/divine/eora) || HAS_TRAIT(living_user, TRAIT_CHOSEN))\
		&& user.get_stress_event(/datum/stressevent/psyprayer)\
		&& !HAS_TRAIT(living_user, TRAIT_EORAN_PITY))
		to_chat(user, span_notice("Eora 回应了你的祈祷，赐予你一枚可供培育的种子！"))
		new /obj/item/reagent_containers/eoran_seed(loc)
		ADD_TRAIT(living_user, TRAIT_EORAN_PITY, TRAIT_GENERIC)


	qdel(src)

/obj/item/reagent_containers/food/snacks/eoran_aril
	name = "Eora 果粒"
	desc = "一枚来自 Eora 果实的发光种子。它正随着神圣能量轻轻搏动。"
	icon = 'modular_azurepeak/icons/obj/items/eora_pom.dmi'
	dropshrink = 0.7
	icon_state = "auric"
	bitesize = 1
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_TINY
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/effect_desc = "效果未知。"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/eoran_aril/attack(mob/living/M, mob/living/user, def_zone)
	if(M != user)
		to_chat(user, span_info("当你试图强行把她的馈赠塞给别人时，这枚种子因 Eora 的怒意而灼热发烫。"))
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/eoran_aril/On_Consume(mob/living/eater)
	. = ..()
	if(iscarbon(eater))
		var/mob/living/carbon/c = eater
		apply_effects(c)

/obj/item/reagent_containers/food/snacks/eoran_aril/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/eora)
			. += span_info(effect_desc)

/obj/item/reagent_containers/food/snacks/eoran_aril/proc/apply_effects(mob/living/carbon/eater)
	return

//--TIER 1--
/obj/item/reagent_containers/food/snacks/eoran_aril/crimson
	name = "绯红果粒"
	desc = "一枚血红色的种子，仿佛正随着生命力一同脉动。"
	icon_state = "crimson"
	effect_desc = "此果实会以鲜血为代价治疗伤势。将这枚种子喂给别人时，将消耗你自己的鲜血。"

	var/heal_amount = 35
	var/blood_loss = 225

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/Initialize(mapload)
	. = ..()
	blood_loss = BLOOD_VOLUME_NORMAL * 0.03

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/apply_effects(mob/living/carbon/eater)
	var/list/wCount = eater.get_wounds()
	if(!eater.construct && !(eater.mob_biotypes & MOB_UNDEAD))
		var/current_brute_loss = eater.getBruteLoss()
		blood_loss += (eater.blood_volume * 0.06)
		if(wCount.len > 0)
			eater.heal_wounds(heal_amount + (current_brute_loss * 0.12))
			eater.update_damage_overlays()
		eater.blood_volume = max(0, eater.blood_volume - blood_loss)
		eater.adjustBruteLoss(-(heal_amount + (current_brute_loss * 0.12)), 0)
		eater.adjustFireLoss(-(heal_amount + (eater.getFireLoss() * 0.12)), 0)
		eater.adjustToxLoss(-(heal_amount + (eater.getToxLoss() * 0.12)), 0)
		eater.adjustOxyLoss(-(heal_amount + (eater.getOxyLoss() * 0.12)), 0)
		eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amount)
		eater.adjustCloneLoss(-heal_amount, 0)

/obj/item/reagent_containers/food/snacks/eoran_aril/crimson/attack(mob/living/M, mob/living/user, def_zone)
	if(!ishuman(M))
		return
	if(M == user)
		. = ..()
		return
	user.visible_message(
		span_danger("[user] 开始无私地引导绯红果粒的力量，为 [M] 恢复伤势。"),
			span_info("我开始用自己的鲜血，将绯红果粒的力量灌入 [M] 体内。")
	)
	if(!do_mob(user, M, time = 2 SECONDS, double_progress = TRUE))
		return
	var/mob/living/carbon/human/eater = M
	var/list/wCount = eater.get_wounds()
	if(!eater.construct && !(eater.mob_biotypes & MOB_UNDEAD))
		var/current_brute_loss = eater.getBruteLoss()
		blood_loss += (user.blood_volume * 0.08)
		if(wCount.len > 0)
			eater.heal_wounds(heal_amount + (current_brute_loss * 0.12))
			eater.update_damage_overlays()
		user.blood_volume = max(0, user.blood_volume - blood_loss)
		eater.adjustBruteLoss(-(heal_amount + (current_brute_loss * 0.12)), 0)
		eater.adjustFireLoss(-(heal_amount + (eater.getFireLoss() * 0.12)), 0)
		eater.adjustToxLoss(-(heal_amount + (eater.getToxLoss() * 0.12)), 0)
		eater.adjustOxyLoss(-(heal_amount + (eater.getOxyLoss() * 0.12)), 0)
		eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amount)
		eater.adjustCloneLoss(-heal_amount, 0)
	qdel(src)
	return

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate
	name = "玫彩果粒"
	desc = "一枚散发着美丽与优雅气息的粉色种子。"
	icon_state = "roseate"
	effect_desc = "赐予转瞬即逝的美丽。会排斥丑陋者。"

	var/beauty_duration = 10 MINUTES

/obj/item/reagent_containers/food/snacks/eoran_aril/roseate/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!HAS_TRAIT(H, TRAIT_UNSEEMLY) && !HAS_TRAIT(H, TRAIT_BEAUTIFUL))
			H.apply_status_effect(/datum/status_effect/buff/eora_grace)

/datum/status_effect/buff/eora_grace
	id = "eora_grace"
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/eora_grace

/atom/movable/screen/alert/status_effect/eora_grace
	name = "Eora 的恩宠"
	desc = "你感到自己美得动人。"

/datum/status_effect/buff/eora_grace/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
	return TRUE

/datum/status_effect/buff/eora_grace/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)

/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent
	name = "乳辉果粒"
	desc = "一枚在光线下会不断变换色彩的虹彩种子。"
	icon_state = "opalescent"
	effect_desc = "会将手中持有的宝石转化为红宝石。"
	
/obj/item/reagent_containers/food/snacks/eoran_aril/opalescent/apply_effects(mob/living/eater)
	for(var/obj/item/roguegem/G in eater.held_items)
		var/obj/item/roguegem/ruby/new_gem = new(eater.loc)
		qdel(G)
		eater.put_in_hands(new_gem)
		to_chat(eater, span_notice("[G] 在你手中变成了一颗 rontz！"))
		//Probably best not to allow 2 at once...
		break

// TIER 2
/obj/item/reagent_containers/food/snacks/eoran_aril/cerulean
	name = "蔚蓝果粒"
	desc = "一枚深蓝色的种子，带着海洋的气息。"
	icon_state = "cerulean"
	effect_desc = "极佳的钓饵，能吸引宝藏上钩。"
	baitpenalty = 5
	isbait = TRUE
	fishingMods=list(
		"commonFishingMod" = 0.2,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0,
		"ceruleanFishingMod" = 1, // 1 on cerulean aril, 0 on everything else
	)

/obj/item/reagent_containers/food/snacks/eoran_aril/fractal
	name = "分形果粒"
	desc = "一枚几何结构完美到令人目眩刺痛的种子。"
	icon_state = "fractal"
	effect_desc = "以体质为代价，Eora 的慈悲会将丑陋悄然融去……"

/obj/item/reagent_containers/food/snacks/eoran_aril/fractal/apply_effects(mob/living/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
			REMOVE_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_VIRTUE)
			H.change_stat(STATKEY_CON, -1)
			to_chat(eater, span_good("你感到自己的缺陷正在融化消散，但身体也变得更加脆弱。"))

// TIER 3
/obj/item/reagent_containers/food/snacks/eoran_aril/auric
	name = "鎏金果粒"
	desc = "一枚散发着温暖与生命气息的金色种子。"
	icon_state = "auric"
	effect_desc = "复生药剂的关键材料。"

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen
	name = "灰烬果粒"
	desc = "一枚触手冰寒的灰色种子。仅仅注视着它，就会感到一股巨大的恐惧。"
	icon_state = "ashen"
	effect_desc = "禁忌的果粒。它并非为你而生。"

/obj/item/reagent_containers/food/snacks/eoran_aril/ashen/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater

		if(H.patron.type == /datum/patron/divine/eora)
			// Eora does not appreciate her followers ignoring her most sacred wishes.
			H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
		else
			var/datum/status_effect/buff/ashen_aril/existing_effect = H.has_status_effect(/datum/status_effect/buff/ashen_aril)

			if(existing_effect)
				// Already burnt by an aril, simply stave off the ashing for 30 minutes.
				existing_effect.prevent_reapply = TRUE
				H.remove_status_effect(/datum/status_effect/buff/ashen_aril)
				H.remove_filter("ashen_filter")
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 0, 30 MINUTES)
			else
				H.apply_status_effect(/datum/status_effect/buff/ashen_aril, 5, 6 MINUTES)

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre
	name = "赭红果粒"
	desc = "一枚血红色的种子，正以威胁般的节奏搏动着。"
	icon_state = "ochre"
	effect_desc = "以你自己的生命为代价，将视野内附近两具尸体从 Necra 的怀抱中唤回。"

/obj/item/reagent_containers/food/snacks/eoran_aril/ochre/apply_effects(mob/living/carbon/eater)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(H.patron.type == /datum/patron/divine/eora)
			var/list/mob/living/carbon/human/target_mobs = list()

			for(var/mob/living/carbon/human/target in view(7, H))
				if(target_mobs.len >= 2)
					break
				if(target.stat != DEAD)
					continue
				if(!target.mind || !target.mind.active)
					continue
				if(HAS_TRAIT(target, TRAIT_NECRAS_VOW))
					continue
				if(HAS_TRAIT(target, TRAIT_DNR))
					continue
				if(target.mob_biotypes & MOB_UNDEAD)
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/metabolic_acceleration))
					continue
				if(target.has_status_effect(/datum/status_effect/debuff/eoran_wilting))
					continue

				target_mobs += target

			if(target_mobs.len > 0)
				H.apply_status_effect(/datum/status_effect/debuff/eoran_wilting)
				addtimer(CALLBACK(GLOBAL_PROC_REF(process_ochre_revivals), target_mobs), 0)

	return ..()

/proc/process_ochre_revivals(list/mob/living/carbon/human/targets_to_revive)
	for(var/mob/living/carbon/human/target in targets_to_revive)
		continue
		if(target.stat != DEAD)
			continue

		INVOKE_ASYNC(GLOBAL_PROC_REF(revive_ochre_target), target)

/proc/revive_ochre_target(mob/living/carbon/human/target)
	to_chat(world, span_userdanger("正在尝试复活 [target]"))
	if(QDELETED(target) || target.stat != DEAD)
		return FALSE

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()

	// Perform revival
	target.adjustOxyLoss(-target.getOxyLoss())
	if(target.revive(full_heal = FALSE))
		// Transfer ghost back to body (if they were ghosted)
		if(underworld_spirit && underworld_spirit.mind) // Ensure spirit exists and has a mind
			underworld_spirit.mind.transfer_to(target, TRUE) // Transfer mind back to the revived body
			qdel(underworld_spirit) // Delete the spirit mob
		else
			target.grab_ghost(force = TRUE) // This attempts to grab a ghost even if they committed suicide.

		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] 被神圣魔法复活了！"), span_green("我自虚无之中醒来。"))

		ADD_TRAIT(target, TRAIT_IWASREVIVED, "ochre_aril")
		target.apply_status_effect(/datum/status_effect/debuff/metabolic_acceleration)
		return TRUE
	else
		target.visible_message(span_warning("魔法摇晃着溃散了，什么也没有发生。"))
		return FALSE

//This is meant to be given guaranteed with T4 pommes for priests but given we don't have eoran priests yet I will implement this when we do.
/obj/item/reagent_containers/lux/eoran_aril
	name = "炽耀果粒"
	desc = "一枚亮得刺眼的种子，散发着纯粹的生命能量。它模仿着作为生命本源的 lux。"
	icon = 'modular_azurepeak/icons/obj/items/eora_pom.dmi'
	icon_state = "incandescent"
	dropshrink = 0.7

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent
	name = "珠辉果粒"
	desc = "一枚乳白色的种子，随着净化之力脉动不休。"
	icon_state = "pearlescent"
	effect_desc = "会将你体内的毒素转化为生命之血，但代价是稀释过于浓烈的生命之血。"

/obj/item/reagent_containers/food/snacks/eoran_aril/pearlescent/attack(mob/living/M, mob/living/user, def_zone)
	if(ishuman(M))
		M.apply_status_effect(/datum/status_effect/pearlescent_aril)
	qdel(src)
	return

/obj/item/reagent_containers/eoran_seed
	name = "缎柔果粒"
	desc = "一枚来自 Eora 圣树、触感如丝般柔滑的种子。可在肥沃土壤中播下，延续她的恩赐。"
	icon = 'modular_azurepeak/icons/obj/items/eora_pom.dmi'
	icon_state = "roseate"

/obj/item/reagent_containers/eoran_seed/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!isturf(target) || !proximity_flag)
		return ..()

	var/turf/T = target

	// Location checks
	if(!isopenturf(T))
		to_chat(user, span_warning("这枚种子需要开阔的空间才能生长！"))
		return
	if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/grassyel) || istype(T, /turf/open/floor/rogue/grassred) || istype(T, /turf/open/floor/rogue/grasscold) || istype(T, /turf/open/floor/rogue/desert_grass)))
		to_chat(user, span_warning("这枚种子必须种在泥土或草地上！"))
		return

	// Planting process
	to_chat(user, span_notice("你开始将种子种入 [T]。它正轻轻搏动着……"))
	if(!do_after(user, 30 SECONDS, target))
		to_chat(user, span_warning("栽种被打断了！"))
		return

	// Re-check conditions after delay
	if(!isopenturf(T) || !(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/dirt) || istype(T, /turf/open/floor/rogue/grassyel) || istype(T, /turf/open/floor/rogue/grassred) || istype(T, /turf/open/floor/rogue/grasscold) || istype(T, /turf/open/floor/rogue/desert_grass)))
		to_chat(user, span_warning("这片土地已经不再适合栽种了！"))
		return

	// Create tree and consume seed
	new /obj/structure/eoran_pomegranate_tree(T)
	qdel(src)

#undef SPROUT
#undef GROWING
#undef MATURING
#undef FRUITING

//Remove their ability to feel bad, restore a small amount of hunger / thirst if they're already starving.
/obj/effect/proc_holder/spell/invoked/eora_blessing
	name = "Eora 的祝福"
	desc = "将 Eora 的安宁赐予一人，哪怕只持续短短片刻。"
	sound = 'sound/magic/eora_bless.ogg'
	devotion_cost = 80
	recharge_time = 5 MINUTES
	miracle = TRUE
	invocation_type = "shout"
	invocations = list("让生命之美将你彻底充盈。")
	overlay_state = "eora_bless"
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/eora_blessing/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/L = targets[1]
		var/assocskill = L.get_skill_level(associated_skill)
		L.apply_status_effect(/datum/status_effect/eora_blessing, assocskill)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/eora_blessing
	id = "eora_bless"
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/eora_blessing

/datum/status_effect/eora_blessing/on_apply(assocskill)
	if(assocskill)
		duration *= assocskill	//+1 minute per skill level.
	var/mob/living/carbon/human/H = owner
	ADD_TRAIT(owner, TRAIT_EORAN_SERENE, TRAIT_GENERIC)	//Generic origin so other Eorans do not have their innate traits overridden (they use TRAIT_MIRACLE)
	var/hungercheck = H.nutrition
	var/hydrohomiecheck = H.hydration
	switch(hungercheck)
		if(0 to NUTRITION_LEVEL_FED)
			switch(assocskill)
				if(SKILL_LEVEL_NONE)
					H.nutrition = NUTRITION_LEVEL_STARVING + 50
				if(SKILL_LEVEL_NOVICE to SKILL_LEVEL_JOURNEYMAN)
					H.nutrition = NUTRITION_LEVEL_HUNGRY + 50
				else	
					H.nutrition = NUTRITION_LEVEL_WELL_FED
	switch(hydrohomiecheck)
		if(0 to HYDRATION_LEVEL_SMALLTHIRST)
			switch(assocskill)
				if(SKILL_LEVEL_NONE)
					H.hydration = HYDRATION_LEVEL_DEHYDRATED + 50
				if(SKILL_LEVEL_NOVICE to SKILL_LEVEL_JOURNEYMAN)
					H.hydration = HYDRATION_LEVEL_THIRSTY + 50
				else	
					H.hydration = HYDRATION_LEVEL_HYDRATED
	if(assocskill > SKILL_LEVEL_APPRENTICE)
		H.add_stress(/datum/stressevent/eoran_blessing_greater)
	else
		H.add_stress(/datum/stressevent/eoran_blessing)
	H.update_stress()
	. = ..()

/datum/status_effect/eora_blessing/on_remove()
	REMOVE_TRAIT(owner, TRAIT_EORAN_SERENE, TRAIT_GENERIC)
	owner.update_stress()
	return ..()

/atom/movable/screen/alert/status_effect/buff/eora_blessing
	name = "Eora 的宁静"
	desc = "一阵令人神清气爽的安宁。你的烦恼仿佛都被冲刷殆尽。为什么不能永远如此呢？"
	icon_state = "eora_bless"
