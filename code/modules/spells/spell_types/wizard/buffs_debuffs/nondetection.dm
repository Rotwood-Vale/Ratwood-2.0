/obj/effect/proc_holder/spell/targeted/touch/nondetection
	name = "蔽视术"
	desc = "消耗一把灰烬，让你触碰到的目标在 1 小时内避开占视法术的窥探。"
	clothes_req = FALSE
	drawmessage = "我准备编织一道魔法帷幕。"
	dropmessage = "我散去了手中的奥术焦点。"
	school = "abjuration"
	overlay_state = "nondetection"
	recharge_time = 10 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/nondetection
	spell_tier = 1
	hide_charge_effect = TRUE
	// Nondetection shouldn't need an invocation
	xp_gain = TRUE
	cost = 1

/obj/item/melee/touch_attack/nondetection
	name = "\improper 奥术焦点"
	desc = "触碰一名生物，为其覆上一层持续 1 小时的反占视帷幕，并会消耗一些灰烬作为媒介。"
	catchphrase = null
	possible_item_intents = list(INTENT_HELP)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#3FBAFD"

/obj/item/melee/touch_attack/nondetection/attack_self()
	attached_spell.remove_hand()

/obj/effect/proc_holder/spell/targeted/touch/nondetection/proc/add_buff_timer(mob/living/user)
	addtimer(CALLBACK(src, PROC_REF(remove_buff), user), wait = 1 HOURS)

/obj/effect/proc_holder/spell/targeted/touch/nondetection/proc/remove_buff(mob/living/user)
	REMOVE_TRAIT(user, TRAIT_ANTISCRYING, MAGIC_TRAIT)
	to_chat(user, span_warning("我感觉遮蔽占视的帷幕正在失效。"))

/obj/item/melee/touch_attack/nondetection/afterattack(atom/target, mob/living/carbon/user, proximity)
	var/obj/effect/proc_holder/spell/targeted/touch/nondetection/base_spell = attached_spell
	var/requirement = FALSE
	var/obj/item/sacrifice

	if(isliving(target))

		var/mob/living/spelltarget = target

		for(var/obj/item/I in user.held_items)
			if(istype(I, /obj/item/ash))
				requirement = TRUE
				sacrifice = I

		if(!requirement)
			to_chat(user, span_warning("我需要在空着的手里拿一些灰烬。"))
			return

		if(!do_after(user, 5 SECONDS, target = spelltarget))
			return

		qdel(sacrifice)
		ADD_TRAIT(spelltarget, TRAIT_ANTISCRYING, MAGIC_TRAIT)
		if(spelltarget != user)
			user.visible_message("[user] 在空中划出符文，将一把灰烬吹向了 [spelltarget]。")
		else
			user.visible_message("[user] 在空中划出符文，将灰烬洒在了自己身上。")

		base_spell.add_buff_timer(spelltarget)
		attached_spell.remove_hand()
	return
