/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor
	slot_flags = null
	name = "豺狼人兽皮"
	desc = "格拉加尔 狂怒所化、坚不可摧的兽皮"
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_GNOLL_STANDARD
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 475
	item_flags = DROPDEL
	repair_time = 14 SECONDS
	combat_taggable = TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/Initialize(mapload)
	. = ..()
	// Gnolls don't really get to unequip their skin so they might as well just register it as soon as they get it
	// loc is shitcode here because the skin is created inside the gnoll so we can juse abuse that logic
	RegisterSignal(loc, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by), override = TRUE)

/datum/antagonist/gnoll
	name = "豺狼人"
	roundend_category = "豺狼人"
	antagpanel_category = "豺狼人"
	job_rank = ROLE_GNOLL
	var/datum/weakref/tracked_target_ref = null

/proc/get_gnoll_tracking_combat_roles()
	var/static/list/combat_roles = list(
		"Orthodoxist" = TRUE,
		"Absolver" = TRUE,
		"Templar" = TRUE,
		"Sergeant" = TRUE,
		"Man at Arms" = TRUE,
		"Knight" = TRUE,
		"Squire" = TRUE,
		"Mercenary" = TRUE,
		"Warden" = TRUE,
		"Acolyte" = TRUE,
		"Vanguard" = TRUE,
		"City Guard" = TRUE,
		"Bandit" = TRUE,
		"Watch Captain" = TRUE,
		"Master Warden" = TRUE,
		"Knight Captain" = TRUE,
		"Inquisitor" = TRUE
	)
	return combat_roles

/datum/antagonist/gnoll/on_gain()
	greet()
	owner.special_role = "Gnoll"

	return ..()

/datum/antagonist/gnoll/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
	tracked_target_ref = null

/datum/antagonist/gnoll/proc/set_tracked_target(mob/living/target)
	if(!target || QDELETED(target) || target.stat == DEAD)
		tracked_target_ref = null
		return

	tracked_target_ref = WEAKREF(target)

/datum/antagonist/gnoll/proc/get_sniff_spell()
	var/mob/living/current_mob = owner?.current
	if(!current_mob)
		return null

	for(var/obj/effect/proc_holder/spell/S as anything in current_mob.mob_spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		return S

	if(current_mob.mind)
		var/obj/effect/proc_holder/spell/mind_spell = current_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/gnoll_sniff)
		if(istype(mind_spell, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			return mind_spell

	return null

/datum/antagonist/gnoll/proc/get_tracked_target()
	var/mob/living/cached_target = tracked_target_ref?.resolve()
	if(cached_target && !QDELETED(cached_target) && cached_target.stat != DEAD)
		return cached_target
	tracked_target_ref = null

	var/mob/living/current_mob = owner?.current
	if(!current_mob)
		return null

	var/list/sniff_spells = list()
	for(var/obj/effect/proc_holder/spell/S as anything in current_mob.mob_spell_list)
		if(!istype(S, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		if(!(S in sniff_spells))
			sniff_spells += S

	if(current_mob.mind)
		var/obj/effect/proc_holder/spell/mind_sniff_spell = current_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/gnoll_sniff)
		if(istype(mind_sniff_spell, /obj/effect/proc_holder/spell/invoked/gnoll_sniff) && !(mind_sniff_spell in sniff_spells))
			sniff_spells += mind_sniff_spell

	for(var/obj/effect/proc_holder/spell/sniff_spell_candidate as anything in sniff_spells)
		if(!istype(sniff_spell_candidate, /obj/effect/proc_holder/spell/invoked/gnoll_sniff))
			continue
		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/sniff_spell = sniff_spell_candidate
		var/mob/living/target = sniff_spell.tracked_target_ref?.resolve()
		if(target && sniff_spell.is_valid_hunted(target))
			tracked_target_ref = WEAKREF(target)
			return target

	return null

/datum/antagonist/gnoll/proc/get_tracked_target_source(mob/living/target)
	if(!target)
		return null
	if(target.has_flaw(/datum/charflaw/hunted))
		return "被猎印记"
	if(target.job in get_gnoll_tracking_combat_roles())
		return "战斗职业后备"
	return "直接气味"

/datum/antagonist/gnoll/proc/is_examine_marked_target(mob/living/target)
	if(!target)
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted))
		return TRUE
	if(get_tracked_target() != target)
		return FALSE
	return get_tracked_target_source(target) == "战斗职业后备"

/datum/antagonist/gnoll/antag_listing_status()
	var/base_status = ..()
	var/mob/living/target = get_tracked_target()
	var/target_display = "无"

	if(target)
		var/source = get_tracked_target_source(target)
		target_display = "<a href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(target)]'>[target.real_name]</a>"
		if(source)
			target_display += " ([source])"

	if(base_status)
		return "[base_status] | 已追踪: [target_display]"
	return "已追踪: [target_display]"

/mob/living/carbon/human/proc/gnoll_can_feed_heal()
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("我的力量被削弱了，无法治疗自己！"))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/gnoll_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!target)
		return
	if(!gnoll_can_feed_heal())
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("我不该啃食腐烂的血肉。"))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("我不该啃食被污染的血肉。"))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/gnoll))
			to_chat(src, span_warning("我不该啃食同族的血肉。"))
			return

	to_chat(src, span_warning("我吞食鲜嫩的血肉，感觉自己重新焕发了活力。"))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/mob/living/carbon/human/proc/gnoll_bloodpool_feed(healing_amount = 6)
	if(!gnoll_can_feed_heal())
		return FALSE

	to_chat(src, span_warning("我舔食鲜血。蒙 格拉加尔 之恩，我得以重获新生。"))
	src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)
	return TRUE

/obj/item/rogueweapon/werewolf_claw/gnoll
	name = "豺狼人利爪"
	// We are smarter, we can use our solid, steel-like claws to defend ourselves.
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)

/obj/item/rogueweapon/werewolf_claw/gnoll/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/datum/intent/simple/werewolf/gnoll
	name = "利爪"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("抓挠", "撕咬", "开膛破肚")
	animname = "chop"
	hitsound = "genslash"
	penfactor = 20
	candodge = TRUE
	canparry = TRUE
	miss_text = "扑了个空！"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.2

/datum/intent/mace/smash/werewolf/gnoll
	name = "狂击"
	desc = "以野蛮肌力发动的强力猛击，造成正常伤害，并能依照你的力量击退、减速站立目标。力量低于 10 时无效。减速与击退会随你的力量提高，最高按 15 点计算（1 到 5 格）。同一目标每 5 秒内不能连续使用。倒地目标的击退距离减半。"
	icon_state = "insmash"
	chargetime = 1
	penfactor = 0

/datum/intent/simple/gnoll_cut
	name = "裂割爪"
	hitsound = "genslash"
	penfactor = 60
	candodge = TRUE
	canparry = TRUE
	miss_text = "扑了个空！"
	miss_sound = "bluntwooshlarge"
	icon_state = "incut"
	attack_verb = list("切开", "劈裂")
	animname = "cut"
	blade_class = BCLASS_CUT
	item_d_type = "slash"

/datum/intent/mace/strike/gnoll
	name = "裂甲重击"
	miss_text = "挥空了！"
	miss_sound = "bluntwooshlarge"
	attack_verb = list("猛击", "重创", "撕裂")
