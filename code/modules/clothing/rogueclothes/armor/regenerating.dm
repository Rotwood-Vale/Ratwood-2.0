// REGENERATING ARMOUR

#define COMBAT_TAG_DURATION 30 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating
	name = "再生护甲"
	desc = "抽象父类。若你能看到这个，请联系开发者。"
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

	/// Feedback messages
	var/repairmsg_begin = "我的护甲开始缓缓修复受损……"
	var/repairmsg_continue = "我的护甲修复了部分损伤……"
	var/repairmsg_stop = "在猛攻之下，我的护甲停止修复了！"
	var/repairmsg_end = "我的护甲已重新绷紧，焕发新生！"

	/// Combat timer that prevents you from healing while taking damage
	var/combat_timer
	/// Recursive timer that slowly regenerates the armor
	var/reptimer
	/// Time taken for regeneration
	var/repair_time = 10 SECONDS
	/// If the armor regen is stopped by a combat tag
	var/combat_taggable = FALSE

/obj/item/clothing/suit/roguetown/armor/regenerating/equipped(mob/user, slot)
	. = ..()
	UnregisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE))
	if(slot == SLOT_SHIRT || slot == SLOT_ARMOR)
		RegisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by))

/// Combat tag system, makes your skin stop regenning if you are attacked by anything
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/on_attacked_by(datum/source)
	SIGNAL_HANDLER
	if(!combat_taggable) // This means constant in-combat regen
		if(!reptimer && obj_integrity < max_integrity)
			reptimer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
		return

	combat_timer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), COMBAT_TAG_DURATION, TIMER_UNIQUE|TIMER_OVERRIDE)
	if(timeleft(reptimer))
		to_chat(loc, span_notice(repairmsg_stop))
	deltimer(reptimer)
	reptimer = null
	return

/// Start repairing the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/begin_repair()
	to_chat(loc, span_notice(repairmsg_begin))
	armour_regen(skip_message = TRUE)

/// Recursive loop that fixes the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/armour_regen(repair_percent = 0.2 * max_integrity, skip_message = FALSE)
	obj_integrity = min(obj_integrity + repair_percent, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)

	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		deltimer(reptimer)
		reptimer = null
		return

	if(!skip_message)
		to_chat(loc, span_notice(repairmsg_continue))

	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

// SKIN ARMOUR

/obj/item/clothing/suit/roguetown/armor/regenerating/skin
	name = "再生皮肤"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	flags_inv = null //Exposes the chest and-or breasts.
	surgery_cover = FALSE //Should permit surgery and other invasive processes.
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	armor = ARMOR_PADDED
	nudist_approved = TRUE

	repairmsg_begin = "我的皮肤开始缓缓修复受损……"
	repairmsg_continue = "我的皮肤修复了部分损伤……"
	repairmsg_stop = "在猛攻之下，我的皮肤停止修复了！"
	repairmsg_end = "我的皮肤重新绷紧，焕发新生！"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/Initialize(mapload)
	..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	name = "门徒之肤"
	desc = "它远不只是一句誓言。 </br>'AEON、PSYDON、ADONAI - 熵、众生、人神性。三位一体， \
	既为一，又为三; 为众所知，却被时光遗忘。' </br>'一具尸体。 \
	我他妈正活在一具尸体上。祂便是世界，而世界正在腐烂。 \
	天堂早已对我们关闭了大门。' </br>'然而，祂的孩子们仍在坚持; 只要他们还在，我也必须坚持。 \
	幸福必须靠战斗去争取。'"
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) //Custom value; padded gambeson's slash- and stab- armor.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	repair_time = 20 SECONDS
	max_integrity = 300

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak
	name = "坚韧皮肤"
	desc = "我的皮肤向来够硬，足以挡下大多数划伤与瘀伤，只要给它时间就会愈合。"
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	max_integrity = 300
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	combat_taggable = TRUE

#undef COMBAT_TAG_DURATION
