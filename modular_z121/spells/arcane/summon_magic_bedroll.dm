/obj/effect/proc_holder/spell/targeted/conjure_item/summon_magic_bedroll
	name = "召唤魔法睡袋"
	desc = "在手中召唤一只捆好的魔法睡袋。它与普通睡袋作用相同，但只能维持短短数分钟。"
	action_icon = 'icons/roguetown/items/misc.dmi'
	action_icon_state = "bedroll_r"
	overlay_state = "bedroll_r"
	sound = list('sound/magic/whiteflame.ogg')
	invocation_type = "whisper"
	invocations = list("宿具，显形。")
	item_type = /obj/item/bedroll/magic
	delete_old = FALSE
	chargedrain = 0
	releasedrain = 1
	chargetime = 0
	recharge_time = 30 SECONDS
	cooldown_min = 0.5 SECONDS
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	human_req = TRUE
	no_early_release = TRUE
	movement_interrupt = FALSE
	cost = 1
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	warnie = "spellwarning"
	miracle = FALSE

/obj/effect/proc_holder/spell/targeted/conjure_item/summon_magic_bedroll/cast(list/targets, mob/user = usr)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	for(var/mob/living/carbon/caster as anything in targets)
		var/obj/item/held_item = caster.get_active_held_item()
		if(held_item && !caster.dropItemToGround(held_item))
			continue

		var/obj/item/bedroll/magic/summoned_bedroll = make_item()
		// 显式确认物品确实进手，避免沿用父类无返回值 cast 导致成功施法被判成失败。
		if(!caster.put_in_hands(summoned_bedroll, TRUE))
			qdel(summoned_bedroll)
			if(item == summoned_bedroll)
				item = null
			continue
		return TRUE

	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/targeted/conjure_item/summon_magic_bedroll/make_item()
	var/obj/item/bedroll/magic/summoned_bedroll = new item_type
	// 每次施法都生成一只独立计时的魔法睡袋，卷起/展开时会继承剩余寿命。
	summoned_bedroll.set_magic_expiration(world.time + (3 MINUTES))
	item = summoned_bedroll
	return item
