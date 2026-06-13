#define MAGIC_BEDROLL_FILTER "magic_bedroll_outline"
#define MAGIC_BEDROLL_GLOW "#8edcff"
#define MAGIC_BEDROLL_LIFETIME (3 MINUTES)

/obj/structure/bed/rogue/bedroll/magic
	name = "魔法睡袋"
	desc = "一只由奥术临时凝成的睡袋。它看起来与普通睡袋几乎一样，只在边缘流转着淡蓝色微光。"
	var/expire_at = 0

/obj/structure/bed/rogue/bedroll/magic/Initialize(mapload)
	. = ..()
	// 复用原版睡袋外观，只额外加一圈淡蓝色描边。
	add_filter(MAGIC_BEDROLL_FILTER, 2, list("type" = "outline", "color" = MAGIC_BEDROLL_GLOW, "alpha" = 150, "size" = 1))
	if(!expire_at)
		set_magic_expiration(world.time + MAGIC_BEDROLL_LIFETIME)
	else
		apply_magic_expiration()

/obj/structure/bed/rogue/bedroll/magic/Destroy()
	remove_filter(MAGIC_BEDROLL_FILTER)
	return ..()

/obj/structure/bed/rogue/bedroll/magic/proc/set_magic_expiration(new_expire_at)
	expire_at = new_expire_at
	apply_magic_expiration()

/obj/structure/bed/rogue/bedroll/magic/proc/apply_magic_expiration()
	var/remaining_duration = expire_at - world.time
	if(remaining_duration <= 0)
		qdel(src)
		return
	QDEL_IN(src, remaining_duration)

/obj/structure/bed/rogue/bedroll/magic/attack_hand(mob/user, params)
	user.visible_message(span_notice("[user] begins rolling up \the [src]."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		var/obj/item/bedroll/magic/new_bedroll = new /obj/item/bedroll/magic(get_turf(src))
		new_bedroll.color = src.color
		new_bedroll.set_magic_expiration(expire_at)
		qdel(src)

/obj/item/bedroll/magic
	name = "捆好的魔法睡袋"
	desc = "一只被卷起并以奥术维持成形的睡袋。淡蓝色的魔力在布料边缘若隐若现。"
	var/expire_at = 0

/obj/item/bedroll/magic/Initialize(mapload)
	. = ..()
	// 打包态同样复用原版贴图，只通过描边区分魔法版本。
	add_filter(MAGIC_BEDROLL_FILTER, 2, list("type" = "outline", "color" = MAGIC_BEDROLL_GLOW, "alpha" = 150, "size" = 1))
	if(!expire_at)
		set_magic_expiration(world.time + MAGIC_BEDROLL_LIFETIME)
	else
		apply_magic_expiration()

/obj/item/bedroll/magic/Destroy()
	remove_filter(MAGIC_BEDROLL_FILTER)
	return ..()

/obj/item/bedroll/magic/proc/set_magic_expiration(new_expire_at)
	expire_at = new_expire_at
	apply_magic_expiration()

/obj/item/bedroll/magic/proc/apply_magic_expiration()
	var/remaining_duration = expire_at - world.time
	if(remaining_duration <= 0)
		qdel(src)
		return
	QDEL_IN(src, remaining_duration)

/obj/item/bedroll/magic/attack_self(mob/user, params)
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("I need ground to plant this on!"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure))
			to_chat(user, span_warning("I need some free space to deploy a [src] here!"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("There is already something here!</span>"))
			return
	user.visible_message(span_notice("[user] begins placing \the [src] down on the ground."))
	if(do_after(user, 2 SECONDS, TRUE, src))
		var/obj/structure/bed/rogue/bedroll/magic/new_bedroll = new /obj/structure/bed/rogue/bedroll/magic(get_turf(src))
		new_bedroll.color = src.color
		new_bedroll.set_magic_expiration(expire_at)
		qdel(src)

#undef MAGIC_BEDROLL_FILTER
#undef MAGIC_BEDROLL_GLOW
#undef MAGIC_BEDROLL_LIFETIME
