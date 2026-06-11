//Sojourner exclusive. Meant to facilitate being super protected from magic. Don't hand this out readily.
//Full anti-magic, with a unique trait to allow the user to cast under the effects of it.
/obj/effect/proc_holder/spell/self/conjure_armor/barrier
	name = "召障术"
	desc = "召出一道奥术屏障，使你长时间免受奥术性质攻击的侵袭。施放此术时，你的护甲位必须空着。\n\
	这道屏障会持续存在，直到它破碎、你召出新的，或你忘却这道法术。"
	overlay_state = "barrier"//temp
	sound = list('sound/misc/murderbeast.ogg')//What they'll do when they get you.

	releasedrain = 50
	chargedrain = 1
	chargetime = 6 SECONDS
	no_early_release = TRUE
	recharge_time = 6 MINUTES

	warnie = "spellwarning"
	movement_interrupt = TRUE
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3

	invocations = list("屏障，现身！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cost = 3
	spell_tier = 4

	objtoequip = /obj/item/clothing/suit/roguetown/arcyne_barrier
	slottoequip = SLOT_ARMOR
	checkspot = "armor"

/obj/effect/proc_holder/spell/self/conjure_armor/barrier/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("[conjured_armor] 的边缘开始噼啪作响，随后在一阵飞散的火花中碎裂了！"))
		qdel(conjured_armor)
	return ..()

/obj/item/clothing/suit/roguetown/arcyne_barrier
	name = "奥术屏障"
	desc = "纳莱迪游修者所掌握的技艺，以偏转取代硬抗。\
	这道屏障以施术者自身的火花为力，对抗命运之风，绝大多数魔法都无法作用于使用者。"
	max_integrity = 25//Intended to be easy to break.
	break_sound = 'modular_azurepeak/sound/spellbooks/crystal.ogg'
	drop_sound = 'modular_azurepeak/sound/spellbooks/glass.ogg'
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "barrier"
	slot_flags = ITEM_SLOT_ARMOR
	mob_overlay_icon = null
	sleeved = null
	boobed = FALSE
	flags_inv = null
	armor_class = ARMOR_CLASS_NONE
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	armor = ARMOR_BARRIER//20 across the board, except fire and acid, get 30.
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET

/obj/item/clothing/suit/roguetown/arcyne_barrier/equipped(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		user.apply_status_effect(/datum/status_effect/buff/arcyne_barrier)

/obj/item/clothing/suit/roguetown/arcyne_barrier/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("[src] 的边缘开始噼啪作响，随后在一阵飞散的火花中碎裂了！"))
		playsound(get_turf(src), break_sound, 100, TRUE)
		qdel(src)

/obj/item/clothing/suit/roguetown/arcyne_barrier/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/arcyne_barrier/attack_hand(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/arcyne_barrier/dropped(mob/living/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/arcyne_barrier)
	if(!QDELETED(src))
		dispel()

#define ARCBARRIER_FILTER "arcyne_barrier"

/datum/status_effect/buff/arcyne_barrier
	id = "arcyne_barrier"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	duration = -1
	examine_text = "<font color='blue'>SUBJECTPRONOUN 被奥术火花环绕着！</font>"
	var/outline_colour = "#12f0f0"

/atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	name = "奥术屏障"
	desc = "奥术火花环绕着我，替我挡下命运之风的侵袭！"

/datum/status_effect/buff/arcyne_barrier/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)

	var/filter = owner.get_filter(ARCBARRIER_FILTER)
	if (!filter)
		owner.add_filter(ARCBARRIER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/arcyne_barrier/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	owner.remove_filter(ARCBARRIER_FILTER)
