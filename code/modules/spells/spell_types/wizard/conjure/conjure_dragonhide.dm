/obj/effect/proc_holder/spell/self/conjure_armor/dragonhide
	name = "召出龙鳞障衣"
	desc = "召出一层龙鳞障衣，为你长时间抵御攻击，并赋予对火焰的特殊抗性。施放此术时，你的护甲位必须空着。\n\
	这层障衣会持续存在，直到它破碎、你召出新的，或你忘却这道法术。"
	overlay_state = "conjure_dragonhide"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 3 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 4 // upgrade on ring, + firestack immunity pretty dang good.
	spell_tier = 2 // Spellblade tier.

	invocations = list("披上龙鳞！") // google translate latin 'ride the dragon' - If someone literate wants to change this, feel free to.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM


	objtoequip = /obj/item/clothing/suit/roguetown/dragonhide
	slottoequip = SLOT_ARMOR
	checkspot = "armor"

/obj/effect/proc_holder/spell/self/conjure_armor/conjure_dragonhide/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("[conjured_armor] 的边缘开始闪烁消褪，随后彻底消失了！"))
		qdel(conjured_armor)
	return ..()



/obj/item/clothing/suit/roguetown/dragonhide
	name = "龙鳞障衣"
	desc = "最早由利尔瓦斯的“龙息法师”掌握的奥术技艺。这层障衣对高热的防护尤为出色。"
	max_integrity = 200
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "conjure_dragonhide"
	slot_flags = ITEM_SLOT_ARMOR
	mob_overlay_icon = null
	sleeved = null
	boobed = FALSE
	flags_inv = null
	armor_class = ARMOR_CLASS_NONE
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	armor = ARMOR_DRAGONHIDE
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET

/obj/item/clothing/suit/roguetown/dragonhide/equipped(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		user.apply_status_effect(/datum/status_effect/buff/dragonhide)


/obj/item/clothing/suit/roguetown/dragonhide/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("[src] 的边缘开始闪烁消褪，随后彻底消失了！"))
		qdel(src)

/obj/item/clothing/suit/roguetown/dragonhide/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/dragonhide/attack_hand(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/dragonhide/dropped(mob/living/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/dragonhide)
	if(!QDELETED(src))
		dispel()



#define DRAGONHIDE_FILTER "dragonhide_glow"

/datum/status_effect/buff/dragonhide
	id = "dragonscaled"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dragonhide
	duration = -1
	examine_text = "<font color='red'>SUBJECTPRONOUN 浑身覆着灰烬般的鳞片！</font>"
	var/outline_colour = "#c23d09"

/atom/movable/screen/alert/status_effect/buff/dragonhide
	name = "龙鳞护体"
	desc = "火焰在我脚边起舞，却再也灼伤不了我！"

/datum/status_effect/buff/dragonhide/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	var/filter = owner.get_filter(DRAGONHIDE_FILTER)
	if (!filter)
		owner.add_filter(DRAGONHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/dragonhide/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, TRAIT_GENERIC)
	owner.remove_filter(DRAGONHIDE_FILTER)


