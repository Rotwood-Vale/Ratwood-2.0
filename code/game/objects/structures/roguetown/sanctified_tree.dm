//==============================================================================
// Dendor's Vigil Status Effect (applied by Cat 2 ritual)
//==============================================================================

/atom/movable/screen/alert/status_effect/buff/dendor_vigil
	name = "Dendor 的守望"
	desc = "树父的祝福使我步履更轻，并庇护我免受自然障碍所困。"
	icon_state = "buff"

/datum/status_effect/buff/dendor_vigil
	id = "dendor_vigil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_vigil
	effectedstats = list("perception" = 2, "speed" = 1)
	duration = 30 MINUTES

/datum/status_effect/buff/dendor_vigil/dendorite
	effectedstats = list("perception" = 2, "speed" = 2, "willpower" = 1)

/datum/status_effect/buff/dendor_vigil/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, "DENDOR_VIGIL")
	ADD_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, "DENDOR_VIGIL")
	to_chat(owner, span_green("树父的守望拥抱着我，我的步伐更迅捷，荆棘也不会再刺伤我。"))

/datum/status_effect/buff/dendor_vigil/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, "DENDOR_VIGIL")
	REMOVE_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, "DENDOR_VIGIL")
	to_chat(owner, span_warning("树父的守望自我身上消退了。"))

//==============================================================================
// Blessed Druid Armor (reward from Cat 6 ritual)
//==============================================================================

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed
	name = "受祝福的德鲁伊护甲"
	desc = "经树父仪式祝圣的德鲁伊护甲。树皮泛着微弱的生命之光，仿佛整片森林都在守望着穿戴它的人。"
	armor = list("blunt" = 90, "slash" = 70, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	color = "#73c47a"

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name]排斥了我的触碰，唯有树父的虔诚信徒才有资格承载这份赠礼！"))

/obj/structure/flora/roguetree/wise/sanctified/proc/is_valid_vigil_follower(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	// Psydon followers have no patron datum — identified by trait.
	if(HAS_TRAIT(H, TRAIT_PSYDONITE))
		return FALSE
	// Old-god worshippers and all inhumen (Zizo, Baotha, Graggar, Matthios) patrons are excluded.
	if(istype(H.patron, /datum/patron/old_god))
		return FALSE
	if(istype(H.patron, /datum/patron/inhumen))
		return FALSE
	return TRUE

//==============================================================================
// Sanctified Tree Data Datum
//==============================================================================

/// Tracks per-tree ritual state, aura flags, and the per-player soulbind registry.
/datum/sanctified_tree_data
	/// Back-reference to the owning sanctified tree.
	var/obj/structure/flora/roguetree/wise/sanctified/tree
	/// Once-per-tree ritual completion flags. Values: "cat4", "cat5", "cat6".
	var/list/rituals_completed = list()
	/// Per-player soulbind registry: list of ckey strings.
	var/list/soulbound_players = list()
	/// Ckey of the player who just completed cat7 offerings and must now bleed to confirm.
	var/awaiting_soulbind_ckey = null

	// ---- Ritual state -------------------------------------------------------
	/// Currently active ritual category string, or null if none.
	var/active_ritual = null
	/// Progress for the active ritual: associative list of "key" = deposited_count.
	var/list/ritual_progress = list()
	/// Cat1 berry-only tracking: TRUE while current cat1 ritual has only received berry food.
	var/cat1_all_berries = TRUE
	/// Armor held for cat6 transmutation. Stored at the tree's turf until completion.
	var/obj/item/ritual_armor = null

	// ---- Aura state ---------------------------------------------------------
	/// TRUE once cat4 (Treefather's Bulwark) ritual is completed.
	var/has_slow_aura = FALSE
	/// TRUE once cat5 (Living Light) ritual is completed.
	var/has_heal_aura = FALSE
	/// Mobs currently slowed by the bulwark aura. Tracked for cleanup.
	var/list/slowed_mobs = list()
	/// dt accumulator for slow-aura 5-second ticks.
	var/slow_aura_elapsed = 0
	/// dt accumulator for heal-aura 60-second ticks.
	var/heal_aura_elapsed = 0
	/// Per-player middle-click heal cooldown: ckey -> world.time threshold (5 seconds after heal wears off).
	var/list/heal_player_cooldowns = list()

	// ---- Wedding ceremony state ------------------------------------------
	/// TRUE while an eoran bud has been offered and the tree awaits a bitten apple.
	var/wedding_active = FALSE
	/// Ckey of the player who offered the eoran bud to start the ceremony.
	var/wedding_officiant_ckey = null

/datum/sanctified_tree_data/New(obj/structure/flora/roguetree/wise/sanctified/owner)
	..()
	tree = owner

//==============================================================================
// Sanctified Tree
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified
	name = "圣化之树"
	desc = "一棵由树父祝圣的伟大树木。它的树皮泛着微光，周围空气回荡着原始的神圣气息。这里是德鲁伊力量的枢纽。"
	examine_plays_music = FALSE
	pixel_x = -11
	/// Base max_integrity before nearby-tree bonus.
	max_integrity = 400
	/// Disable wise-tree autonomous retaliation. The sanctified tree
	/// cooperates with its druid warden rather than lashing out autonomously.
	activated = FALSE
	// Blessed log is spawned manually in obj_destruction — suppress the inherited plain log drop.
	static_debris = list()

	/// Datum holding ritual completion flags and the soulbind registry.
	var/datum/sanctified_tree_data/tree_data
	/// If FALSE (for sanctified_wise trees), hides ritual and wedding hints in examine.
	var/show_ritual_hints = TRUE
	/// Current max_integrity bonus from nearby living trees.
	var/integrity_bonus = 0
	/// SSprocessing dt accumulator — recalculates bonus every 60 seconds.
	var/bonus_check_elapsed = 0
	/// SSprocessing dt accumulator — restores integrity periodically.
	var/integrity_regen_elapsed = 0

/obj/structure/flora/roguetree/wise/sanctified/Initialize(mapload)
	. = ..()
	tree_data = new /datum/sanctified_tree_data(src)
	set_light(3, 3, 3, l_color = "#FFD700")
	START_PROCESSING(SSprocessing, src)
	recalculate_integrity_bonus()

/obj/structure/flora/roguetree/wise/sanctified/Destroy()
	remove_filter("sanctified_outline")
	STOP_PROCESSING(SSprocessing, src)
	if(tree_data)
		// Notify and debuff any soulbound players before clearing data.
		if(tree_data.soulbound_players.len)
			curse_soulbound_players()
		// Clean up aura slow on destroy.
		for(var/mob/living/M in tree_data.slowed_mobs)
			if(!QDELETED(M))
				var/datum/status_effect/debuff/sanctified_tree_slow/SE = M.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
				if(SE)
					qdel(SE)
		tree_data.slowed_mobs = list()
		// Return any stored ritual armor to the ground.
		if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
			tree_data.ritual_armor.forceMove(get_turf(src))
			tree_data.ritual_armor = null
		qdel(tree_data)
		tree_data = null
	return ..()

/// Applies the permanent soulbind-broken debuff to all online soulbound players.
/// Called from Destroy() before tree_data is cleared.
/obj/structure/flora/roguetree/wise/sanctified/proc/curse_soulbound_players()
	for(var/ckey in tree_data.soulbound_players)
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			if(H.ckey != ckey)
				continue
			H.apply_status_effect(/datum/status_effect/debuff/soulbind_broken)
			H.add_stress(/datum/stressevent/soulbind_tree_loss)
			REMOVE_TRAIT(H, "DENDOR_SOULBOUND", "SOULBIND")
			for(var/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			for(var/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			for(var/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			break

/obj/structure/flora/roguetree/wise/sanctified/process(dt)
	bonus_check_elapsed += dt
	if(bonus_check_elapsed >= 60 SECONDS)
		bonus_check_elapsed = 0
		recalculate_integrity_bonus()
	integrity_regen_elapsed += dt
	if(integrity_regen_elapsed >= 30 SECONDS)
		integrity_regen_elapsed = 0
		if(obj_integrity < max_integrity)
			obj_integrity = min(obj_integrity + 10, max_integrity)
	if(!tree_data)
		return
	if(tree_data.has_slow_aura)
		tree_data.slow_aura_elapsed += dt
		if(tree_data.slow_aura_elapsed >= 5 SECONDS)
			tree_data.slow_aura_elapsed = 0
			update_slow_aura()
	if(tree_data.has_heal_aura)
		tree_data.heal_aura_elapsed += dt
		if(tree_data.heal_aura_elapsed >= 60 SECONDS)
			tree_data.heal_aura_elapsed = 0
			pulse_heal_aura()

//==============================================================================
// Integrity Bonus
//==============================================================================

/// Recounts living trees within 10 tiles and updates max_integrity.
/// Qualifying trees: /obj/structure/flora/newtree (not burnt) and
/// /obj/structure/flora/roguetree (not wise, burnt, or stump subtypes).
/// Each tree contributes +10 integrity, capped at +200 (20 trees).
/obj/structure/flora/roguetree/wise/sanctified/proc/recalculate_integrity_bonus()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/T in range(10, src))
		if(!T.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/T in range(10, src))
		if(istype(T, /obj/structure/flora/roguetree/wise))
			continue  // exclude wise and sanctified subtypes
		if(istype(T, /obj/structure/flora/roguetree/burnt))
			continue
		if(istype(T, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	var/new_bonus = min(tree_count * 10, 200)
	if(new_bonus == integrity_bonus)
		return
	integrity_bonus = new_bonus
	max_integrity = 400 + integrity_bonus
	obj_integrity = min(obj_integrity, max_integrity)

//==============================================================================
// Ritual Framework
//==============================================================================

/obj/structure/flora/roguetree/wise/sanctified/proc/open_ritual_menu(mob/living/user)
	if(!tree_data)
		return

	if(tree_data.wedding_active)
		// Nature's Union ceremony is active — offer cancellation.
		var/choice = alert(user, "这棵树上正在举行一场“自然结合”婚礼。树父的祝福此刻正连结着两道灵魂。\n\n要取消这场婚礼吗？", "圣化之树", "保留仪式", "取消仪式")
		if(choice == "取消仪式" && !QDELETED(src) && !QDELETED(user))
			tree_data.wedding_active = FALSE
			tree_data.wedding_officiant_ckey = null
			to_chat(user, span_warning("婚礼仪式已被解散。树父收回了他的祝福。"))
		return

	if(tree_data.active_ritual)
		// Show progress and only allow cancellation from the amulet menu.
		show_ritual_requirements(user, tree_data.active_ritual)
		var/choice = alert(user, "[get_ritual_display_name(tree_data.active_ritual)]正在进行中。\n\n手持供品点击树木即可献上。\n\n要取消这个仪式吗？", "圣化之树", "保留仪式", "取消仪式")
		if(choice != "取消仪式" || QDELETED(src) || QDELETED(user))
			return
		cancel_ritual(user)
		return

	// No active ritual — show the category picker.
	// Display order and skill gates:
	//   cat1 (Dendor's Harvest)    — None
	//   cat8 (Nature's Union)      — Novice
	//   cat10 (Floral Conjuration) — Novice
	//   cat2 (Fungal Vigil)        — Apprentice
	//   cat5 (Living Light)        — Apprentice
	//   cat12 (Timber's Tithe)     — Apprentice
	//   cat4 (Treefather's Bulwark)— Journeyman
	//   cat7 (Soulbind)            — Journeyman
	//   cat9 (Harvest Bloomstone)  — Expert
	//   cat3 (Fey Weaving)         — Expert
	//   cat6 (Nature's Temper)     — Master
	//   cat11 (Winged Rebirth)   — Legendary
	var/list/cat_opts = list()
	var/list/cat_map = list()
	for(var/cat in list("cat1", "cat8", "cat10", "cat2", "cat5", "cat12", "cat4", "cat7", "cat9", "cat3", "cat6", "cat11"))
		var/cat_name = get_ritual_display_name(cat)
		if(is_once_per_tree(cat) && (cat in tree_data.rituals_completed))
			cat_opts["[cat_name]（已完成）"] = null
			continue
		cat_opts[cat_name] = cat
		cat_map[cat_name] = cat
	var/choice = input(user, "选择要进行的仪式：", "圣化之树仪式") as null|anything in cat_opts
	if(isnull(choice) || QDELETED(src) || QDELETED(user))
		return
	var/selected = cat_map[choice]
	if(!selected)
		to_chat(user, span_info("这个仪式已经在这棵树上完成过了，不能重复举行。"))
		return
	// Druidic Trickery skill gate for each ritual.
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/Hg = user
		var/druidic_level = Hg.get_skill_level(/datum/skill/magic/druidic)
		var/required_level = 0
		var/required_name = ""
		switch(selected)
			if("cat8", "cat10")
				required_level = SKILL_LEVEL_NOVICE
				required_name = "新手"
			if("cat2", "cat5", "cat12")
				required_level = SKILL_LEVEL_APPRENTICE
				required_name = "学徒"
			if("cat4", "cat7")
				required_level = SKILL_LEVEL_JOURNEYMAN
				required_name = "熟练"
			if("cat9", "cat3")
				required_level = SKILL_LEVEL_EXPERT
				required_name = "专家"
			if("cat6")
				required_level = SKILL_LEVEL_MASTER
				required_name = "大师"
			if("cat11")
				required_level = SKILL_LEVEL_LEGENDARY
				required_name = "传奇"
		if(required_level > 0 && druidic_level < required_level)
			to_chat(user, span_warning("树父不会向尚未准备好的人揭示[get_ritual_display_name(selected)]的奥秘，你需要[required_name]级德鲁伊秘术。"))
			return
	// Once-per-person gate for Floral Conjuration: prevent initiating if already have the spell.
	if(selected == "cat10" && istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/Hcat10 = user
		if(Hcat10.mind)
			for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/S in Hcat10.mind.spell_list)
				to_chat(user, span_warning("树父的花卉恩赐已经存在于我体内，我不能再次得到这份祝福。"))
				return
	if(!confirm_start_ritual(user, selected))
		return
	tree_data.active_ritual = selected
	var/req = get_required_offerings(selected)
	tree_data.ritual_progress = list()
	for(var/key in req)
		tree_data.ritual_progress[key] = 0
	if(selected == "cat1")
		tree_data.cat1_all_berries = TRUE
	to_chat(user, span_notice("我开始进行[get_ritual_display_name(selected)]仪式。手持供品点击树木即可献上；若要取消，再使用护符。"))
	show_ritual_requirements(user, selected)

/obj/structure/flora/roguetree/wise/sanctified/proc/confirm_start_ritual(mob/living/user, category)
	var/list/req = get_required_offerings(category)
	var/list/lines = list()
	for(var/key in req)
		lines += "- [req[key]]x [get_offering_desc(key)]"
	var/text = "要开始[get_ritual_display_name(category)]吗？\n\n所需供品：\n[jointext(lines, "\n")]"
	var/choice = alert(user, text, "圣化之树悬赏", "开始", "取消")
	return (choice == "开始")

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_display_name(category)
	switch(category)
		if("cat1") return "Dendor 的丰收"
		if("cat2") return "菌灵守望"
		if("cat3") return "妖精编织"
		if("cat12") return "林木什一"
		if("cat4") return "树父壁垒"
		if("cat5") return "活体灵光"
		if("cat6") return "自然之怒"
		if("cat7") return "魂缚"
		if("cat8") return "自然结合"
		if("cat9") return "丰收绽石"
		if("cat10") return "花卉塑成"
		if("cat11") return "振翼重生"
	return "未知仪式"

/// Returns XP awarded to the player upon completing a ritual.
/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_xp(category)
	switch(category)
		if("cat1")  return 5
		if("cat2")  return 25
		if("cat3")  return 50
		if("cat4")  return 100
		if("cat5")  return 100
		if("cat6")  return 200
		if("cat7")  return 100
		if("cat8")  return 25
		if("cat9")  return 50
		if("cat10") return 100
		if("cat12") return 10
	return 0

/obj/structure/flora/roguetree/wise/sanctified/proc/is_once_per_tree(category)
	return (category in list("cat4", "cat5", "cat6", "cat7", "cat9", "cat10", "cat11")) // cat12 is repeatable

/// Returns associative list of offering key -> required count for the given category.
/obj/structure/flora/roguetree/wise/sanctified/proc/get_required_offerings(category)
	switch(category)
		if("cat1") return list("food_item" = 6)
		if("cat2") return list("manabloom_or_manacrystal" = 10)
		if("cat3") return list("runed_or_leyline" = 1, "blessed_powder_alt" = 4)
		if("cat4") return list("boulder_cat4" = 5, "any_stone_cat4" = 15)
		if("cat5") return list("vital_item" = 10, "ash" = 10, "compost" = 10)
		if("cat6") return list("zizobane" = 5, "runed_artifact" = 2, "druid_armor" = 1, "volf_head" = 1, "spider_head" = 1, "tree_seed" = 1, "blessed_seed_powder" = 1, "holy_water_container" = 1)
		if("cat7") return list("leechtick" = 1, "bones" = 4)
		if("cat8") return list("wedding_flower" = 1)
		if("cat9") return list("boulder_only" = 1, "magic_stone_or_essence" = 1, "blessed_powder" = 5)
		if("cat10") return list(
			"herb_atropa"     = 1,
			"herb_matricaria"  = 1,
			"herb_symphitum"   = 1,
			"herb_taraxacum"   = 1,
			"herb_euphrasia"   = 1,
			"herb_paris"       = 1,
			"herb_calendula"   = 1,
			"herb_mentha"      = 1,
			"herb_urtica"      = 1,
			"herb_salvia"      = 1,
			"herb_hypericum"   = 1,
			"herb_benedictus"  = 1,
			"herb_valeriana"   = 1,
			"herb_artemisia"   = 1,
			"herb_rosa"        = 1,
			"manabloom_single" = 1
		)
		if("cat11") return list("feather" = 10, "bonedust" = 10, "essence_of_wilderness" = 1, "bloomstone" = 1)
		if("cat12") return list("tree_sapling_any" = 5)
	return list()

/obj/structure/flora/roguetree/wise/sanctified/proc/get_offering_desc(key)
	switch(key)
		if("food_item") return "任意新鲜或腐烂的农产品"
		if("manabloom_or_manacrystal") return "法力花或结晶化法力"
		if("runed_or_leyline") return "符文造物或地脉碎片"
		if("blessed_powder_alt") return "受祝圣的种粉"
		if("enchanted_stone_or_boulder") return "附魔石头（魔力 5+）或巨石"
		if("boulder_cat4") return "一块大巨石"
		if("any_stone_cat4") return "任意一种石头"
		if("vital_item") return "筋腱、内脏、骨粉或头骨"
		if("ash") return "灰烬"
		if("compost") return "堆肥"
		if("zizobane") return "Zizo克星蘑菇"
		if("runed_artifact") return "符文造物"
		if("druid_armor") return "德鲁伊护甲"
		if("volf_head") return "狼头"
		if("spider_head") return "蜘蛛头"
		if("tree_seed") return "树种"
		if("tree_sapling_any") return "任意树苗"
		if("blessed_seed_powder") return "受祝圣的种粉"
		if("holy_water_container") return "装有 30+ 打兰祝圣水的石臼或水桶"
		if("lux") return "Lux"
		if("leechtick") return "膨胀的水蛭蜱"
		if("bones") return "骨头"
		if("wedding_flower") return "Eora和平花"
		if("boulder_only") return "一块大巨石"
		if("magic_stone_or_essence") return "附魔石头（魔力 5+）、荒野精华或木材精华"
		if("blessed_powder") return "受祝圣的种粉"
		if("herb_atropa")    return "颠茄草"
		if("herb_matricaria") return "母菊草"
		if("herb_symphitum") return "聚合草"
		if("herb_taraxacum") return "蒲公英草"
		if("herb_euphrasia") return "小米草"
		if("herb_paris")     return "重楼草"
		if("herb_calendula") return "金盏花草"
		if("herb_mentha")    return "薄荷草"
		if("herb_urtica")    return "荨麻草"
		if("herb_salvia")    return "鼠尾草"
		if("herb_hypericum") return "金丝桃草"
		if("herb_benedictus") return "本笃草"
		if("herb_valeriana") return "缬草"
		if("herb_artemisia") return "艾草"
		if("herb_rosa")      return "蔷薇花"
		if("manabloom_single") return "一朵法力花"
		if("feather") return "羽毛"
		if("bonedust") return "骨粉"
		if("essence_of_wilderness") return "荒野精华"
		if("bloomstone") return "丰收绽石"
	return key

/obj/structure/flora/roguetree/wise/sanctified/proc/show_ritual_requirements(mob/living/user, category)
	var/req = get_required_offerings(category)
	to_chat(user, span_info("=== [get_ritual_display_name(category)] 所需供品 ==="))
	if(category == "cat4")
		var/boulder_cur = tree_data.ritual_progress["boulder_cat4"] || 0
		var/boulder_needed = req["boulder_cat4"]
		var/stone_cur = tree_data.ritual_progress["any_stone_cat4"] || 0
		var/stone_needed = req["any_stone_cat4"]
		to_chat(user, span_info("  任选以下其中一种供奉方式："))
		if(boulder_cur >= boulder_needed)
			to_chat(user, span_notice("  [get_offering_desc("boulder_cat4")]: [boulder_cur]/[boulder_needed]（已满足）"))
		else
			to_chat(user, span_warning("  方案一 - [get_offering_desc("boulder_cat4")]: [boulder_cur]/[boulder_needed]"))
		if(stone_cur >= stone_needed)
			to_chat(user, span_notice("  [get_offering_desc("any_stone_cat4")]: [stone_cur]/[stone_needed]（已满足）"))
		else
			to_chat(user, span_warning("  方案二 - [get_offering_desc("any_stone_cat4")]: [stone_cur]/[stone_needed]"))
		return
	for(var/key in req)
		var/current = tree_data.ritual_progress[key] || 0
		var/needed = req[key]
		if(current >= needed)
			to_chat(user, span_notice("  [get_offering_desc(key)]: [current]/[needed]（已满足）"))
		else
			to_chat(user, span_warning("  [get_offering_desc(key)]: [current]/[needed]"))

/obj/structure/flora/roguetree/wise/sanctified/proc/offer_item(mob/living/user)
	if(!tree_data?.active_ritual)
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("我手里没有任何可供奉的东西。"))
		return FALSE
	var/req = get_required_offerings(tree_data.active_ritual)
	// For cat4, skip accepting items for the path that is already completed.
	var/skip_boulder_cat4 = (tree_data.active_ritual == "cat4") && ((tree_data.ritual_progress["any_stone_cat4"] || 0) >= req["any_stone_cat4"])
	var/skip_stone_cat4 = (tree_data.active_ritual == "cat4") && ((tree_data.ritual_progress["boulder_cat4"] || 0) >= req["boulder_cat4"])
	// Support taking items from a held storage container (sack, satchel, bag).
	var/obj/item/storage/held_sack = istype(held, /obj/item/storage) ? held : null
	if(held_sack)
		// Bulk mode: for every unfulfilled key, drain all matching items from the sack at once.
		var/any_taken = FALSE
		for(var/key in req)
			var/current = tree_data.ritual_progress[key] || 0
			if(current >= req[key])
				continue
			if(skip_boulder_cat4 && key == "boulder_cat4")
				continue
			if(skip_stone_cat4 && key == "any_stone_cat4")
				continue
			// Snapshot contents so deletions during iteration are safe.
			var/list/sack_contents = held_sack.contents.Copy()
			for(var/obj/item/sack_item in sack_contents)
				if(current >= req[key])
					break
				if(!check_offering_match(key, sack_item))
					continue
				if(tree_data.active_ritual == "cat1" && key == "food_item")
					if(!istype(sack_item, /obj/item/reagent_containers/food/snacks/grown/berries))
						tree_data.cat1_all_berries = FALSE
				consume_offering(key, sack_item, user)
				current++
				tree_data.ritual_progress[key] = current
				any_taken = TRUE
		if(any_taken)
			playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
			if(check_ritual_complete())
				complete_ritual(user)
			return TRUE
		to_chat(user, span_warning("这棵树现在不需要那个容器里的任何东西。"))
		return FALSE
	// Single-item mode: consume the held item if it matches any unfulfilled requirement.
	for(var/key in req)
		var/current = tree_data.ritual_progress[key] || 0
		if(current >= req[key])
			continue
		if(skip_boulder_cat4 && key == "boulder_cat4")
			continue
		if(skip_stone_cat4 && key == "any_stone_cat4")
			continue
		if(!check_offering_match(key, held))
			continue
		// Track whether cat1 offering is a berry.
		if(tree_data.active_ritual == "cat1" && key == "food_item")
			if(!istype(held, /obj/item/reagent_containers/food/snacks/grown/berries))
				tree_data.cat1_all_berries = FALSE
		consume_offering(key, held, user)
		tree_data.ritual_progress[key] = current + 1
		playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
		if(check_ritual_complete())
			complete_ritual(user)
		return TRUE
	to_chat(user, span_warning("这棵树现在不需要[held.name]。"))
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/is_harvest_offering(obj/item/held)
	if(!istype(held, /obj/item/reagent_containers/food/snacks))
		return FALSE
	if(istype(held, /obj/item/reagent_containers/food/snacks/grown/berries))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/food = held
	if(food.foodtype & (FRUIT | VEGETABLES | GRAIN))
		return TRUE
	var/static/list/extra_harvest_types = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue,
		/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
		/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip,
		/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue,
		/obj/item/reagent_containers/food/snacks/grown/potato/rogue,
		/obj/item/reagent_containers/food/snacks/grown/rice,
		/obj/item/reagent_containers/food/snacks/grown/cucumber,
		/obj/item/reagent_containers/food/snacks/grown/eggplant,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/oat,
		/obj/item/reagent_containers/food/snacks/grown/sugarcane,
		/obj/item/reagent_containers/food/snacks/grown/coffeebeans,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/grown/nut,
		/obj/item/reagent_containers/food/snacks/grown/tea,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine,
		/obj/item/reagent_containers/food/snacks/grown/fruit/plum,
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
		/obj/item/natural/shellplant/pumpkin,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	for(var/path in extra_harvest_types)
		if(istype(held, path))
			return TRUE
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/check_offering_match(key, obj/item/held)
	if(!held)
		return FALSE
	switch(key)
		if("food_item")
			return is_harvest_offering(held)
		if("manabloom_or_manacrystal")
			return istype(held, /obj/item/reagent_containers/food/snacks/grown/manabloom) || istype(held, /obj/item/magic/manacrystal)
		if("runed_or_leyline")
			return istype(held, /obj/item/magic/artifact) || istype(held, /obj/item/magic/leyline)
		if("blessed_powder_alt")
			return held.type == /obj/item/alch/blessedseedpowder
		if("enchanted_stone_or_boulder")
			if(istype(held, /obj/item/natural/stone))
				var/obj/item/natural/stone/stone = held
				return stone.magic_power >= 5
			return istype(held, /obj/item/natural/rock)
		if("boulder_cat4")
			return istype(held, /obj/item/natural/rock)
		if("any_stone_cat4")
			return istype(held, /obj/item/natural/stone)
		if("vital_item")
			return istype(held, /obj/item/alch/sinew) || istype(held, /obj/item/alch/viscera) || istype(held, /obj/item/alch/bonemeal) || istype(held, /obj/item/skull)
		if("ash")
			return istype(held, /obj/item/ash)
		if("compost")
			return istype(held, /obj/item/compost)
		if("zizobane")
			return istype(held, /obj/item/reagent_containers/food/snacks/zizo_bane)
		if("runed_artifact")
			return istype(held, /obj/item/magic/artifact)
		if("druid_armor")
			return held.type == /obj/item/clothing/suit/roguetown/armor/leather/druid
		if("volf_head")
			return istype(held, /obj/item/natural/head/volf)
		if("spider_head")
			return istype(held, /obj/item/natural/head/honeyspider) || istype(held, /obj/item/natural/head/mirespider)
		if("tree_seed")
			return istype(held, /obj/item/seeds/treesap)
		if("tree_sapling_any")
			return istype(held, /obj/item/seeds/treesap) || istype(held, /obj/structure/tree_sapling)
		if("blessed_seed_powder")
			return istype(held, /obj/item/alch/blessedseedpowder)
		if("holy_water_container")
			if(!(istype(held, /obj/item/reagent_containers/glass/mortar) || istype(held, /obj/item/reagent_containers/glass/bucket)))
				return FALSE
			if(!held.reagents)
				return FALSE
			return held.reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 30
		if("lux")
			return istype(held, /obj/item/reagent_containers/lux)
		if("leechtick")
			return istype(held, /obj/item/leechtick_bloated)
		if("bones")
			return istype(held, /obj/item/natural/bone) || istype(held, /obj/item/alch/bone)
		if("wedding_flower")
			return istype(held, /obj/item/clothing/head/peaceflower)
		if("boulder_only")
			return istype(held, /obj/item/natural/rock)
		if("magic_stone_or_essence")
			if(istype(held, /obj/item/natural/cured/essence) || istype(held, /obj/item/grown/log/tree/small/essence))
				return TRUE
			if(!istype(held, /obj/item/natural/stone))
				return FALSE
			var/obj/item/natural/stone/stone = held
			return stone.magic_power >= 5
		if("blessed_powder")
			// Exact type check — bloomstone is excluded intentionally.
			return held.type == /obj/item/alch/blessedseedpowder
		if("herb_atropa")    return held.type == /obj/item/alch/atropa
		if("herb_matricaria") return held.type == /obj/item/alch/matricaria
		if("herb_symphitum") return held.type == /obj/item/alch/symphitum
		if("herb_taraxacum") return held.type == /obj/item/alch/taraxacum
		if("herb_euphrasia") return held.type == /obj/item/alch/euphrasia
		if("herb_paris")     return held.type == /obj/item/alch/paris
		if("herb_calendula") return held.type == /obj/item/alch/calendula
		if("herb_mentha")    return held.type == /obj/item/alch/mentha
		if("herb_urtica")    return held.type == /obj/item/alch/urtica
		if("herb_salvia")    return held.type == /obj/item/alch/salvia
		if("herb_hypericum") return held.type == /obj/item/alch/hypericum
		if("herb_benedictus") return held.type == /obj/item/alch/benedictus
		if("herb_valeriana") return held.type == /obj/item/alch/valeriana
		if("herb_artemisia") return held.type == /obj/item/alch/artemisia
		if("herb_rosa")      return held.type == /obj/item/alch/rosa
		if("manabloom_single") return istype(held, /obj/item/reagent_containers/food/snacks/grown/manabloom)
		if("feather") return istype(held, /obj/item/natural/feather)
		if("bonedust") return istype(held, /obj/item/alch/bonemeal)
		if("essence_of_wilderness") return istype(held, /obj/item/natural/cured/essence)
		if("bloomstone") return istype(held, /obj/item/alch/bloomstone)
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/consume_offering(key, obj/item/held, mob/living/user)
	switch(key)
		if("druid_armor")
			// Move armor to tree's turf and store reference for transmutation.
			held.forceMove(get_turf(src))
			tree_data.ritual_armor = held
		if("holy_water_container")
			// Drain blessed water but leave the container.
			held.reagents.remove_reagent(/datum/reagent/water/blessed, 30)
		if("bloomstone")
			// Force the bloomstone to drain all charges so Destroy() actually deletes it.
			held.forceMove(get_turf(src))
			var/obj/item/alch/bloomstone/offered = held
			offered.charges = 1
			qdel(offered)
		else
			qdel(held)

/obj/structure/flora/roguetree/wise/sanctified/proc/check_ritual_complete()
	if(!tree_data?.active_ritual)
		return FALSE
	var/req = get_required_offerings(tree_data.active_ritual)
	// Cat 4: boulder_cat4 and any_stone_cat4 are alternatives — either fully satisfied completes the ritual.
	if(tree_data.active_ritual == "cat4")
		var/boulder_done = (tree_data.ritual_progress["boulder_cat4"] || 0) >= req["boulder_cat4"]
		var/stone_done = (tree_data.ritual_progress["any_stone_cat4"] || 0) >= req["any_stone_cat4"]
		return boulder_done || stone_done
	for(var/key in req)
		if((tree_data.ritual_progress[key] || 0) < req[key])
			return FALSE
	return TRUE

/obj/structure/flora/roguetree/wise/sanctified/proc/complete_ritual(mob/living/user)
	var/cat = tree_data.active_ritual
	tree_data.active_ritual = null
	tree_data.ritual_progress = list()
	if(is_once_per_tree(cat))
		tree_data.rituals_completed |= cat
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	visible_message(span_green("[user.name]完成神圣仪式时，[src.name]迸发出耀眼的金色光辉！"))
	// Award Druidic Trickery XP for completing a bounty ritual.
	var/ritual_xp = get_ritual_xp(cat)
	if(ritual_xp > 0 && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, ritual_xp)
	switch(cat)
		if("cat1") reward_cat1(user)
		if("cat2") reward_cat2(user)
		if("cat3") reward_cat3(user)
		if("cat4") reward_cat4(user)
		if("cat5") reward_cat5(user)
		if("cat6") reward_cat6(user)
		if("cat7") on_soulbind(user)
		if("cat8") reward_cat8(user)
		if("cat9") reward_cat9(user)
		if("cat10") reward_cat10(user)
		if("cat11") reward_cat11(user)
		if("cat12") reward_cat12(user)

/obj/structure/flora/roguetree/wise/sanctified/proc/cancel_ritual(mob/living/user)
	if(!tree_data?.active_ritual)
		return
	var/cat_name = get_ritual_display_name(tree_data.active_ritual)
	if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
		tree_data.ritual_armor.forceMove(get_turf(src))
		to_chat(user, span_notice("献上的护甲回到了我脚边。"))
		tree_data.ritual_armor = null
	tree_data.active_ritual = null
	tree_data.ritual_progress = list()
	to_chat(user, span_warning("我取消了[cat_name]仪式，所有进度都失去了。"))

//==============================================================================
// Ritual Rewards
//==============================================================================

/// Cat 1 — Dendor's Harvest: seed bounty (repeatable).
/// Offerings: 5 any fruit/grain/vegetable food items (rotten okay).
/// Reward (normal): 1 random misc seed + 1 tree seed (5% sakura, 10% pine, 85% regular).
/// Reward (berry special case, all 5 berries): 1 wild bush seed + 50% chance flower seed.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat1(mob/living/user)
	var/turf/T = get_turf(user)
	if(tree_data.cat1_all_berries)
		// Berry special case: all 5 were berries → wild thorny berry hedge seed + possible flower
		new /obj/item/seeds/bush(T)
		if(prob(50))
			new /obj/item/seeds/flower(T)
		to_chat(user, span_green("树根翻涌着荆棘般的能量，一颗野生树篱幼苗种子滚落而出。"))
		return
	// Normal reward: 1 misc seed from Dendor's garden + 1 tree seed
	var/misc = pickweight(list(
		/obj/item/seeds/tea                          = 10,
		/obj/item/seeds/coffee                       = 10,
		/obj/item/herbseed/manabloom                 = 8,
		/obj/item/seeds/swampweed                    = 8,
		/obj/item/seeds/apple                        = 6,
		/obj/item/seeds/pear                         = 6,
		/obj/item/seeds/plum                         = 6,
		/obj/item/seeds/strawberry                   = 5,
		/obj/item/seeds/blackberry                   = 5,
		/obj/item/seeds/raspberry                    = 5,
		/obj/item/seeds/tomato                       = 5,
		/obj/item/seeds/potato                       = 5,
		/obj/item/seeds/onion                        = 5,
		/obj/item/seeds/cabbage                      = 5,
		/obj/item/seeds/wheat                        = 5,
		/obj/item/seeds/garlick                      = 5,
		/obj/item/seeds/turnip                       = 5,
		/obj/item/seeds/rice                         = 5,
		/obj/item/seeds/cucumber                     = 5,
		/obj/item/seeds/eggplant                     = 5,
		/obj/item/seeds/carrot                       = 5,
		/obj/item/seeds/wheat/oat                    = 5,
		/obj/item/seeds/sugarcane                    = 4,
		/obj/item/seeds/poppy                        = 4,
		/obj/item/seeds/nut                          = 4,
		/obj/item/seeds/lemon                        = 4,
		/obj/item/seeds/lime                         = 4,
		/obj/item/seeds/tangerine                    = 4,
		/obj/item/seeds/pumpkin                      = 3,
		/obj/item/seeds/berryrogue                   = 3
	))
	new misc(T)
	// Tree seed: 5% sakura, 10% pine, 85% regular
	var/tree_type = pickweight(list(
		/obj/item/seeds/treesap/sakura = 5,
		/obj/item/seeds/treesap/pine   = 10,
		/obj/item/seeds/treesap        = 85
	))
	new tree_type(T)
	to_chat(user, span_green("种子自树根间簌簌落下，Dendor 的收成一如既往地慷慨。"))

/// Cat 2 — Fungal Vigil: kneestinger ring + 30-min vigil buff to nearby mobs (repeatable).
/// Offerings: 10 mana blooms OR crystalized mana.
/// Buff: longstrider + +2 Perception + +1 Speed + kneestinger immunity, 30 minutes.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat2(mob/living/user)
	var/turf/T = get_turf(src)
	// Plant kneestingers in the 4 cardinal directions around the tree.
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	// Buff nearby non-dead pantheon followers except excluded patrons.
	for(var/mob/living/carbon/human/H in range(6, src))
		if(!is_valid_vigil_follower(H))
			continue
		if(H.stat == DEAD)
			continue
		if(H.patron?.type == /datum/patron/divine/dendor)
			H.apply_status_effect(/datum/status_effect/buff/dendor_vigil/dendorite)
		else
			H.apply_status_effect(/datum/status_effect/buff/dendor_vigil)
	to_chat(user, span_green("膝刺菇环绕而生，树父的守望强化了祂的信徒。"))

/// Cat 3 — Fey Weaving: mushroom fey circle seeds (repeatable).
/// Offerings: 1 runed artifact or leyline shard + 4 blessed seed powder. Reward: 2 mushroom_fey seeds.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat3(mob/living/user)
	var/turf/T = get_turf(user)
	new /obj/item/seeds/mushroom_fey(T)
	new /obj/item/seeds/mushroom_fey(T)
	to_chat(user, span_green("两捧妖精蘑菇孢子自树根间升起，树父嘉奖了你的耐心。"))

/// Cat 4 — Treefather's Bulwark: slow aura + integrity boost (once per tree).
/// Offerings: 5 enchanted stones (magic_power 5+) OR boulders.
/// Reward: +100 integrity, -4 speed debuff aura to non-Dendor mobs within 5 tiles.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat4(mob/living/user)
	tree_data.has_slow_aura = TRUE
	max_integrity += 100
	obj_integrity = min(obj_integrity + 100, max_integrity)
	visible_message(span_green("[src.name]的树皮硬化得如同铁木。无声的护佑笼罩着它，凡欲亵渎此树者，都会感到双腿沉重。"))

/// Cat 5 — Living Light: passive healing aura + middle-click manual heal (once per tree).
/// Offerings: 10 mixed sinew/viscera/tailbone/bone/skull + 10 ash + 10 compost.
/// Aura: wide green glow, periodic healing for Dendor followers.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat5(mob/living/user)
	tree_data.has_heal_aura = TRUE
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	visible_message(span_green("温暖的翠绿灵光自[src.name]绽放而出。树父的生命之力开始流向敬奉祂的人。"))

/// Cat 6 — Nature's Temper: blessed druid armor + possible elven armor piece (once per tree).
/// Offerings: 5 zizo bane + 2 runed artifacts + druid armor + volf head + spider head +
///             tree seed + blessed seed powder + stone mortar/bucket with 30+ drams holy water.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat6(mob/living/user)
	var/turf/T = get_turf(user)
	if(!tree_data.ritual_armor || QDELETED(tree_data.ritual_armor))
		to_chat(user, span_warning("供奉的德鲁伊护甲遗失了，有什么东西打断了仪式。"))
		return
	// Destroy the offered druid armor.
	qdel(tree_data.ritual_armor)
	tree_data.ritual_armor = null
	// Yield blessed druid armor (upgraded chest).
	var/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/BA = new(T)
	to_chat(user, span_green("[BA.name]自仪式中升起，树父已将活生生的力量祝入这件护甲。"))
	// 50% chance: random wood armor piece from elven black oak mercenaries (excluding chest).
	if(prob(50))
		var/list/bonus_pool = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic, /obj/item/clothing/gloves/roguetown/elven_gloves/druidic, /obj/item/clothing/shoes/roguetown/boots/leather/elven_boots/druidic, /obj/item/clothing/cloak/forrestercloak/blessed)
		var/bonus_type = pick(bonus_pool)
		var/obj/item/bonus = new bonus_type(T)
		to_chat(user, span_green("树根间还生出了[bonus.name]，这是额外的赠礼。"))

/// Cat 8 — Nature's Union: begins a wedding ceremony (repeatable).
/// Offering: 1 eoran peace flower. The betrothed must each bite the same apple,
/// then offer it to the tree to complete the pact.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat8(mob/living/user)
	if(tree_data.wedding_active)
		to_chat(user, span_warning("这棵树上已经在举行婚礼仪式了。"))
		return
	tree_data.wedding_active = TRUE
	tree_data.wedding_officiant_ckey = user.ckey
	visible_message(span_green("一朵和平花飘落至[src.name]树根旁，Dendor 与 Eora 的祝福同时被唤起。如今，两道灵魂已可献上共同咬过的苹果，在此树下缔结婚约。"))
	to_chat(user, span_notice("仪式已经开始。两位伴侣都要各自咬同一个苹果一口，再把它交给树来完成婚誓。交出苹果的人将决定共同姓氏。"))

/// Cat 9 — Harvest Bloomstone: a 20-use blessed seed powder stone (once per tree).
/// Offerings: 1 boulder + 1 enchanted stone (magic_power 10+) + 5 blessed seed powders.
/// Requires Expert Druidic Trickery to initiate (gated in open_ritual_menu).
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat9(mob/living/user)
	var/turf/T = get_turf(user)
	var/obj/item/alch/bloomstone/B = new(T)
	user.put_in_hands(B)
	to_chat(user, span_green("树根托起一块发光的石头，丰收花绽石随之升入我手中，充盈着树父祝福的能量。"))

/// Cat 10 — Floral Conjuration: grants the Conjure Floral Seed spell (once per tree, once per person).
/// Offerings: one of every herb (atropa through rosa, 15 total).
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat10(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("唯有人形生灵才能接受树父赐下的花卉恩典。"))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	// Once-per-person: don't grant the spell if they already have it.
	for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/S in H.mind.spell_list)
		to_chat(H, span_warning("我已经知晓如何召出花卉种子了，不能重复接受这份赐福。"))
		return
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_floral_seed)
	to_chat(H, span_green("花卉塑种的知识流入了我的心中，我现在能借树父之力唤出种子。"))

/// Cat 11 — Winged Rebirth: choose a winged form and add it to Beast Form choices (once per tree).
/// Offerings: 10 feathers, 10 bonedust, 1 essence of wilderness, 1 harvest bloomstone.
/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat11(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("唯有人形生灵才能接受树父赐下的诡术祝福。"))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	var/obj/effect/proc_holder/spell/self/wildshape/ws = H.mind.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
	if(!ws)
		to_chat(H, span_warning("我得先拥有野兽形态神迹，才能束缚新的形态。"))
		return

	var/already_has_bat  = (/mob/living/carbon/human/species/wildshape/bat  in ws.possible_shapes)
	var/already_has_crow = (/mob/living/carbon/human/species/wildshape/crow in ws.possible_shapes)
	if(already_has_bat && already_has_crow)
		to_chat(H, span_notice("这些有翼形态已经栖息在我的灵魂之中了。"))
		return

	if(!already_has_bat)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/bat
	if(!already_has_crow)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/crow
	to_chat(H, span_green("蝙蝠与乌鸦的形态知识在我灵魂中扎下了根。我现在能通过野兽形态化作它们了。"))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat12(mob/living/user)
	// Spawn 2 blessed logs at the player's feet as the Treefather's gift.
	var/turf/T = get_turf(user)
	for(var/i in 1 to 2)
		var/obj/item/grown/log/tree/log = new(T)
		log.bless_log()
	to_chat(user, span_green("在树父的力量下，这棵树的枝干脱落又重生，两段受祝福的原木已落在我脚边。"))

//==============================================================================
// Aura Procs
//==============================================================================

/// Applies or removes the bulwark slow on non-Dendor mobs within 5 tiles.
/// Called every 5 seconds when has_slow_aura is TRUE.
/// Applies a -4 speed stat debuff via status effect (8-second duration),
/// refreshed each tick so it stays active while in range.
/obj/structure/flora/roguetree/wise/sanctified/proc/update_slow_aura()
	var/list/in_range = list()
	for(var/mob/living/carbon/human/H in range(5, src))
		if(H.patron && H.patron.type == /datum/patron/divine/dendor)
			continue
		if(H.stat != CONSCIOUS || H.incapacitated())
			continue
		in_range |= H
	// Remove modifier from mobs that left range or are now Dendor-eligible.
	// Collect removals first — mutating slowed_mobs during iteration skips elements in BYOND.
	var/list/to_remove = list()
	for(var/mob/living/M in tree_data.slowed_mobs)
		if(QDELETED(M) || !(M in in_range))
			if(!QDELETED(M))
				var/datum/status_effect/debuff/sanctified_tree_slow/SE = M.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
				if(SE)
					qdel(SE)
			to_remove += M
	tree_data.slowed_mobs -= to_remove
	// Apply/refresh debuff on mobs in range.
	for(var/mob/living/carbon/human/H in in_range)
		var/datum/status_effect/debuff/sanctified_tree_slow/SE = H.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		if(SE)
			SE.refresh()
		else
			H.apply_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
			tree_data.slowed_mobs |= H

/// Heals Dendor followers within 5 tiles periodically like a healing miracle.
/// Also heals non-undead animals and lesser dryads in range.
/// Called every 60 seconds when has_heal_aura is TRUE.
/obj/structure/flora/roguetree/wise/sanctified/proc/pulse_heal_aura()
	var/healed_any = FALSE
	for(var/mob/living/carbon/human/H in range(5, src))
		if(H.patron?.type != /datum/patron/divine/dendor)
			continue
		if(H.stat == DEAD)
			continue
		if(H.has_status_effect(/datum/status_effect/buff/healing))
			continue
		H.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
		new /obj/effect/temp_visual/heal_rogue(get_turf(H))
		healed_any = TRUE
	// Also heal non-undead animals and lesser dryads within range.
	for(var/mob/living/simple_animal/A in range(5, src))
		if(A.mob_biotypes & MOB_UNDEAD)
			continue
		if(A.stat == DEAD)
			continue
		if(A.has_status_effect(/datum/status_effect/buff/healing))
			continue
		A.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
		new /obj/effect/temp_visual/heal_rogue(get_turf(A))
		healed_any = TRUE
	if(healed_any)
		playsound(get_turf(src), 'sound/magic/churn.ogg', 30, FALSE)

//==============================================================================
// Middle-Click Manual Heal (Cat 5)
//==============================================================================

/// Middle-click handler for cat5 healing aura.
/// Applies a healing miracle to the Dendor follower. Per-player cooldown: 5 seconds after effect ends.
/obj/structure/flora/roguetree/wise/sanctified/MiddleClick(mob/user, params)
	if(!tree_data?.has_heal_aura)
		return
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type != /datum/patron/divine/dendor)
		return
	if(H.stat != CONSCIOUS || H.incapacitated())
		return
	if(H.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(H, span_warning("树父的温暖已经在我体内流动了。"))
		return
	var/cooldown_until = tree_data.heal_player_cooldowns[H.ckey]
	if(cooldown_until && world.time < cooldown_until)
		to_chat(H, span_warning("这棵树赐予我的疗愈尚未恢复，再等一会儿。"))
		return
	if(get_dist(H, src) > 1)
		to_chat(H, span_warning("我必须贴近这棵树，才能汲取它的力量。"))
		return
	to_chat(H, span_notice("我将双掌贴在神圣的树皮上，引导树父的暖流。"))
	if(!do_after(H, 3 SECONDS, target = src))
		return
	if(QDELETED(src))
		return
	if(H.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(H, span_warning("树父的温暖已经在我体内流动了。"))
		return
	H.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
	new /obj/effect/temp_visual/heal_rogue(get_turf(H))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 50, FALSE)
	to_chat(H, span_green("树父的温暖流入了我的伤口。"))
	// Per-player cooldown: 5 seconds after the 10-second effect expires
	tree_data.heal_player_cooldowns[H.ckey] = world.time + 15 SECONDS

/// Temporary -4 speed debuff applied by the Treefather's Bulwark aura.
/// Duration is 8 seconds — slightly longer than the 5-second aura tick —
/// so it stays on continuously while the player remains in range.
/datum/status_effect/debuff/sanctified_tree_slow
	id = "sanctified_tree_slow"
	duration = 8 SECONDS
	effectedstats = list("speed" = -4, "strength" = -2)

/datum/status_effect/debuff/sanctified_tree_slow/on_apply()
	. = ..()
	to_chat(owner, span_warning("靠近这棵树时，沉重的压迫与盘结树根缠住了我的脚步，让我的行动慢了下来。"))

//==============================================================================
// Soulbind Broken Status Effect (permanent, applied on tree destruction)
//==============================================================================

/atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	name = "魂缚破碎"
	desc = "我的灵魂被撕下了一角，肉体与心智都因此衰弱。"
	icon_state = "debuff"

/datum/status_effect/debuff/soulbind_broken
	id = "soulbind_broken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	effectedstats = list("strength" = -4, "speed" = -4, "perception" = -4, "intelligence" = -4, "constitution" = -4)
	duration = -1

/datum/status_effect/debuff/soulbind_broken/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/soulsteal.ogg', 80, FALSE)
	to_chat(owner, span_userdanger("我的灵魂被撕下了一角，神圣联结已然破碎。我虚弱到了极点。"))

/datum/status_effect/debuff/soulbind_broken/on_remove()
	. = ..()
	// Permanent — blocked by living code, but implement for completeness.

/datum/stressevent/soulbind_tree_loss
	timer = 60 MINUTES
	stressadd = 5
	desc = span_boldred("与我魂缚相连的圣树已经倒下，我感到自己有一部分被永久撕走了。")

//==============================================================================
// Soulbind (Cat 7)
//==============================================================================

/// Called when cat7 offerings are complete. Sets the tree into soulbind-ready state.
/// The player must then attack the tree with harm intent + empty hand + bleeding arm to confirm.
/obj/structure/flora/roguetree/wise/sanctified/proc/on_soulbind(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("唯有活着的人才能与这棵树进行魂缚。"))
		return
	var/mob/living/carbon/human/H = user
	if(H.ckey in tree_data.soulbound_players)
		to_chat(H, span_warning("我已经与这棵树完成魂缚了。"))
		return
	// Check once-per-player: has this player soulbound to any sanctified tree?
	if(HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		to_chat(H, span_userdanger("我的灵魂已经绑定在另一棵圣树上，无法再次魂缚。"))
		return
	tree_data.awaiting_soulbind_ckey = H.ckey
	to_chat(H, span_warning("仪式已经就绪。要完成魂缚，我必须以伤害意图、空着手、且手臂流血时攻击这棵树。"))

/// Triggered when a player attacks the tree with harm intent + empty hand + bleeding arm.
/obj/structure/flora/roguetree/wise/sanctified/proc/attempt_soulbind(mob/living/carbon/human/H)
	if(!tree_data)
		return
	if(tree_data.awaiting_soulbind_ckey != H.ckey)
		return
	if(HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		to_chat(H, span_userdanger("我的灵魂已经有所归属，无法再次魂缚。"))
		return
	if(H.ckey in tree_data.soulbound_players)
		to_chat(H, span_warning("我已经与这棵树完成魂缚了。"))
		return

	// Check intent
	if(H.used_intent?.type != INTENT_HARM)
		to_chat(H, span_warning("我要用染血的手掌捶击这棵树，才能完成魂缚。"))
		return
	// Check empty active hand
	if(H.get_active_held_item())
		to_chat(H, span_warning("要完成魂缚，我的手必须空着。"))
		return
	// Check arm bleeding
	var/obj/item/bodypart/r_arm = H.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/l_arm = H.get_bodypart(BODY_ZONE_L_ARM)
	if(!(r_arm?.get_bleed_rate() > 0) && !(l_arm?.get_bleed_rate() > 0))
		to_chat(H, span_warning("要以鲜血封缚魂誓，我的手臂必须正在流血。"))
		return

	to_chat(H, span_notice("我将流血的手掌按在神圣树皮上，把自己的灵魂系在这棵圣树之上。"))
	if(!do_after(H, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(H))
		return
	if(H.ckey in tree_data.soulbound_players || HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		return

	// Finalize bind
	var/confirm = alert(H, "你将把自己的灵魂绑定在这棵圣树上。若此树被毁，你的全部属性都将遭受永久且不可逆的削弱。要继续吗？", "魂缚", "是", "否")
	if(confirm != "是" || QDELETED(src) || QDELETED(H))
		to_chat(H, span_warning("我退出了这份神圣誓约。"))
		return

	// 50 brute to active arm
	var/active_zone = H.active_hand_index == 1 ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM
	var/obj/item/bodypart/active_arm = H.get_bodypart(active_zone)
	if(active_arm)
		active_arm.receive_damage(50, 0)
	else
		H.adjustBruteLoss(50, 0)

	// Mark as soulbound
	ADD_TRAIT(H, "DENDOR_SOULBOUND", "SOULBIND")
	tree_data.soulbound_players |= H.ckey
	tree_data.awaiting_soulbind_ckey = null

	// Grant soulbind spells
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad)

	// Register tree destruction signal is no longer needed — cleanup is handled in Destroy().

	visible_message(span_boldwarning("[H.name]的手按在树皮上，一道金光闪过，契约就此完成！"))
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	to_chat(H, span_green("我的灵魂已与这棵圣树相连。若它倒下，我也会随之失去自己的一部分。"))

/// Called when the tree is destroyed while a player is soulbound to it.
/// Actual debuffing happens via curse_soulbound_players() in Destroy().

//==============================================================================
// Examine / Interaction// Wedding ritual procs
//==============================================================================

/// Called when a bitten apple (2 names) is offered to the sanctified tree during a wedding ceremony.
/obj/structure/flora/roguetree/wise/sanctified/proc/perform_wedding(mob/living/user, obj/item/reagent_containers/food/snacks/grown/apple/A)
	var/mob/living/carbon/human/thegroom = null
	var/mob/living/carbon/human/thebride = null
	for(var/bite_name in A.bitten_names)
		var/found = FALSE
		for(var/mob/M in viewers(src, 7))
			if(!ishuman(M)) continue
			var/mob/living/carbon/human/C = M
			if(C.stat == DEAD) continue
			if(!C.client) continue
			if(C.marriedto) continue
			if(C.real_name == bite_name)
				if(!thegroom)
					thegroom = C
				else if(!thebride)
					thebride = C
				found = TRUE
				break
		if(found && thegroom && thebride)
			break

	if(!(thegroom && thebride))
		A.become_rotten()
		to_chat(user, span_danger("树父的祝福动摇了，咬过果实的灵魂并不在场，或已各自成婚。苹果随即腐烂。"))
		tree_data.wedding_active = FALSE
		tree_data.wedding_officiant_ckey = null
		return

	var/surname = input(user, "为这对伴侣输入共同姓氏：", "自然结合") as text|null
	if(QDELETED(src) || QDELETED(user))
		return
	if(!surname || !length(trim(surname)))
		surname = thegroom.dna.species.random_surname()

	priority_announce("[thegroom.real_name]与[thebride.real_name]已在树父枝荫之下缔结婚约！", title = "自然结合！", sound = 'sound/misc/bell.ogg')

	var/list/titles = list("Sir", "Ser", "Dame", "Lord", "Lady", "Knight-Captain", "Duke", "Duchess", "Father", "Mother", "Brother", "Sister", "Prelate", "Devotee", "Votary")

	var/list/groom_name_parts = splittext(thegroom.real_name, " ")
	var/title_found = (titles.Find(groom_name_parts[1]) != 0)
	if(title_found)
		thegroom.real_name = "[groom_name_parts[1]] [groom_name_parts[2]] [surname]"
	else
		thegroom.real_name = "[groom_name_parts[1]] [surname]"

	var/list/bride_name_parts = splittext(thebride.real_name, " ")
	title_found = (titles.Find(bride_name_parts[1]) != 0)
	if(title_found)
		thebride.real_name = "[bride_name_parts[1]] [bride_name_parts[2]] [surname]"
	else
		thebride.real_name = "[bride_name_parts[1]] [surname]"

	to_chat(thegroom, span_notice("你们新的共同姓氏是[surname]。"))
	to_chat(thebride, span_notice("你们新的共同姓氏是[surname]。"))

	thegroom.marriedto = thebride.real_name
	thebride.marriedto = thegroom.real_name
	thegroom.adjust_triumphs(1)
	thebride.adjust_triumphs(1)

	visible_message(span_green("[src.name]迸发出灿金光辉，Dendor 与 Eora 一同为这场结合赐福！"))
	playsound(get_turf(src), 'sound/misc/bell.ogg', 80, FALSE)
	qdel(A)
	tree_data.wedding_active = FALSE
	tree_data.wedding_officiant_ckey = null
//==============================================================================

/obj/structure/flora/roguetree/wise/sanctified/examine(mob/user)
	. = ..()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/T in range(5, src))
		if(!T.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/T in range(5, src))
		if(istype(T, /obj/structure/flora/roguetree/wise) || istype(T, /obj/structure/flora/roguetree/burnt) || istype(T, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	. += span_info("[src]从附近 [tree_count] 棵活树中汲取力量，获得了 [integrity_bonus] 点额外耐久。")
	. += span_info("耐久度：[round(obj_integrity)]/[max_integrity]")
	if(show_ritual_hints)
		. += span_info("将 Dendor 护符贴在这棵树上，可开启任意德鲁伊仪式，或发起“自然结合”婚礼；订婚者各自咬同一个苹果一口后，将其献给树木即可缔结誓约。")
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type != /datum/patron/divine/dendor)
		return
	if(show_ritual_hints)
		. += span_notice("把 Dendor 护符贴在这棵树上，可开始或取消一次树父悬赏。")
		. += span_notice("或者，在佩戴护符时空手用接触意图触碰树木，也能打开仪式菜单。")
		. += span_notice("若悬赏已激活，则手持所需供品点击树木即可献上。")
	if(show_ritual_hints && tree_data?.active_ritual)
		. += span_notice("当前悬赏：[get_ritual_display_name(tree_data.active_ritual)]")
		var/list/req = get_required_offerings(tree_data.active_ritual)
		for(var/key in req)
			var/current = tree_data.ritual_progress[key] || 0
			var/needed = req[key]
			if(current >= needed)
				. += span_notice("  [get_offering_desc(key)]：[current]/[needed]（已满足）")
			else
				. += span_warning("  [get_offering_desc(key)]: [current]/[needed]")
	if(tree_data?.has_slow_aura)
		. += span_info("一道守护结界正在驱退所有妄图亵渎这片林地的人。")
	if(tree_data?.has_heal_aura)
		. += span_info("一股治疗灵光正从这棵树上向外扩散。贴近后中键点击树木即可引导其中的疗愈之力。")

/obj/structure/flora/roguetree/wise/sanctified/attack_hand(mob/user)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(tree_data?.awaiting_soulbind_ckey && H.ckey == tree_data.awaiting_soulbind_ckey)
			attempt_soulbind(H)
			return
		// Touch intent with empty hand while wearing the Dendor amulet opens the ritual menu.
		// Check all slots the amulet can occupy: neck, wrists, ring, or gloves.
		if(!H.get_active_held_item())
			var/has_dendor_amulet = istype(H.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_WRISTS), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_RING), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/neck/roguetown/psicross/dendor)
			if(has_dendor_amulet)
				if(H.patron?.type != /datum/patron/divine/dendor)
					to_chat(H, span_warning("唯有 Dendor 的信徒才能与这棵圣树沟通。"))
					return
				open_ritual_menu(H)
				return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/attackby(obj/item/I, mob/living/user, params)
	// Bitten apple: completes the Nature's Union wedding ceremony.
	if(tree_data?.wedding_active && istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		var/obj/item/reagent_containers/food/snacks/grown/apple/A = I
		if(A.bitten_names.len < 2)
			to_chat(user, span_warning("两位伴侣都必须先咬过苹果，才能把它献给这棵树。"))
			return
		perform_wedding(user, A)
		return

	// Dendor amulet: entry point for ritual menu.
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!istype(user, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = user
		if(H.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("唯有 Dendor 的信徒才能与这棵圣树沟通。"))
			return
		open_ritual_menu(user)
		return

	// While a ritual is active, offerings are made by clicking the tree with an item in-hand.
	if(tree_data?.active_ritual && istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.patron?.type == /datum/patron/divine/dendor)
			if(offer_item(user))
				return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/obj_destruction(damage_flag)
	set_light(0)
	visible_message(span_warning("圣树倒下时，那层金色辉光也随之熄灭了，树父的赐福就此断绝！"))
	var/obj/item/grown/log/tree/blessed_log = new(loc)
	blessed_log.bless_log()
	return ..()

//==============================================================================
// Sanctified Wise Tree
// A sacred (wise) tree blessed by a Dendorite acolyte into a sanctified wise tree.
// Has the slow aura (cat4) and heal aura (cat5) active from creation, but cannot
// receive rituals, soulbind, or officiate weddings.
//==============================================================================
/obj/structure/flora/roguetree/wise/sanctified/wise
	name = "圣化睿木"
	desc = "一棵由 Dendor 侍徒直接祝圣的古老神木。树父的力量沿着根系奔流，既向外散发治愈之光，也排斥所有想要亵渎林苑之人，但它更深层的奥秘仍被封锁着。"
	examine_plays_music = TRUE
	show_ritual_hints = FALSE

/obj/structure/flora/roguetree/wise/sanctified/wise/Initialize(mapload)
	. = ..()
	// Both auras are active from creation — no rituals needed.
	tree_data.has_slow_aura = TRUE
	tree_data.has_heal_aura = TRUE
	// Replace the standard golden glow with the living-light green (normally granted by cat5).
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))

/obj/structure/flora/roguetree/wise/sanctified/wise/attackby(obj/item/I, mob/living/user, params)
	// Block ritual menu — this tree holds no further rites.
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		to_chat(user, span_warning("这棵受祝福的树已不再承载更多仪式，它的力量早已赐出。"))
		return
	// Block wedding initiation — sanctified wise trees cannot officiate ceremonies.
	if(istype(I, /obj/item/clothing/head/peaceflower))
		to_chat(user, span_warning("唯有完全圣化的神树才能主持婚礼仪式。"))
		return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/wise/attack_hand(mob/user)
	// Block touch-intent ritual menu — this tree holds no further rites.
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(!H.get_active_held_item())
			var/has_dendor_amulet = istype(H.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_WRISTS), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_RING), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/neck/roguetown/psicross/dendor)
			if(has_dendor_amulet)
				to_chat(H, span_warning("这棵受祝福的树已不再承载更多仪式，它的力量早已赐出。"))
				return
	return ..()
