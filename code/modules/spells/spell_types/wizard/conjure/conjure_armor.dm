/obj/effect/proc_holder/spell/self/conjure_armor
	name = "召甲术"
	desc = "召出一枚命织护环，为全身提供保护，但它也很容易破碎。若身上穿着重于轻甲的护具，便无法召出。\n\
	这枚护环会持续存在，直到它破碎、你召出新的，或你忘却这道法术。"
	overlay_state = "conjure_armor"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 3 MINUTES // Not meant to be spammed any lower and it starts to compete with stoneskin

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 2
	spell_tier = 2 // Spellblade tier.

	invocations = list("命运，披于我身！") //destiny's defeat!
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM


	var/objtoequip = /obj/item/clothing/ring/fate_weaver
	var/slottoequip = SLOT_RING
	var/obj/item/clothing/conjured_armor = null
	var/checkspot = "ring"


/obj/effect/proc_holder/spell/self/conjure_armor/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/H = user
	var/targetac = H.highest_ac_worn()
	if(targetac > 1)
		to_chat(user, span_warning("我必须穿得更轻一些才行！"))
		revert_cast()
		return FALSE
	if(user.get_num_arms() <= 0)
		to_chat(user, span_warning("我没有可用的手！"))
		revert_cast()
		return FALSE
	if(src.conjured_armor)
		qdel(src.conjured_armor)
	switch(checkspot)
		if("ring")
			if(user.get_num_arms() <= 0)
				to_chat(user, span_warning("我没有可用的手！"))
				revert_cast()
				return FALSE
			if(H.wear_ring)
				to_chat(user, span_warning("我的戴戒指那根手指必须空着！"))
				revert_cast()
				return FALSE
		if("armor")
			if(H.wear_armor)
				to_chat(user, span_warning("胸口已经穿着护甲时，我没法再穿这个！"))
				revert_cast()
				return FALSE

	user.visible_message("[user] 的身形短暂地颤动了一下，自注定的厄运中扯出了一层护身之力！")
	var/item = objtoequip
	conjured_armor = new item(user)
	user.equip_to_slot_or_del(conjured_armor, slottoequip)
	if(!QDELETED(conjured_armor))
		conjured_armor.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
	return TRUE

/obj/effect/proc_holder/spell/self/conjure_armor/miracle
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/conjure_armor/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("[conjured_armor] 的边缘开始闪烁消褪，随后彻底消失了！"))
		qdel(conjured_armor)
	return ..()
