/obj/item/melee
	item_flags = NEEDS_PERMIT

/obj/item/melee/proc/check_martial_counter(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(target.check_block())
		target.visible_message("<span class='danger'>[target.name]挡下了[src]，并把[user]的手臂反扭到了[user.p_their()]身后！</span>",
					"<span class='danger'>我挡下了这次攻击！</span>")
		user.Stun(40)
		return TRUE
