#define PILLORY_HEAD_OFFSET      2 // How much we need to move the player to center their head

/obj/structure/pillory
	name = "颈手枷"
	desc = "用来把罪犯牢牢锁住！"
	icon_state = "pillory_single"
	icon = 'modular/icons/obj/pillory.dmi'
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	anchored = TRUE
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/latched = FALSE
	locked = FALSE
	var/base_icon = "pillory_single"
	lockid = list()

/obj/structure/pillory/double
	icon_state = "pillory_double"
	base_icon = "pillory_double"

/obj/structure/pillory/reinforced
	icon_state = "pillory_reinforced"
	base_icon = "pillory_reinforced"


/obj/structure/pillory/Initialize(mapload)
	LAZYINITLIST(buckled_mobs)
	. = ..()

/obj/structure/pillory/examine(mob/user)
	. = ..()

	var/msg = "它当前为[latched ? "扣合" : "未扣合"]状态，并且[locked ? "已上锁。" : "未上锁。"]<br/>"
	. += msg

/obj/structure/pillory/attack_right(mob/living/user)
	. = ..()
	if(!buckled_mobs.len)
		to_chat(user, span_warning("里面没人，扣上它又有什么意义？"))
		return
	if(user in buckled_mobs)
		to_chat(user, span_warning("我够不到插销！"))
		return
	if(locked)
		to_chat(usr, span_warning("先把它解锁！"))
		return
	togglelatch(user)

/obj/structure/pillory/attackby(obj/item/P, mob/user, params)
	if(user in buckled_mobs)
		to_chat(user, span_warning("我够不到锁！"))
		return
	if(!latched)
		to_chat(user, span_warning("它根本没扣上！"))
		return
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid in lockid)
			togglelock(user)
			return
		else
			to_chat(user, span_warning("钥匙不对。"))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K.keys)
			if(KE.lockid in lockid)
				togglelock(user)
				return

/obj/structure/pillory/proc/togglelatch(mob/living/user, silent)
	user.changeNext_move(CLICK_CD_MELEE)
	if(latched)
		user.visible_message(span_warning("[user]打开了[src]的插销。"), \
			span_notice("我打开了[src]的插销。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		latched = FALSE
	else
		user.visible_message(span_warning("[user]扣上了[src]。"), \
			span_notice("我扣上了[src]。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		latched = TRUE

/obj/structure/pillory/proc/togglelock(mob/living/user, silent)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!latched)
		to_chat(user, span_warning("[src]还没有扣上。"))
	if(locked)
		user.visible_message(span_warning("[user]打开了[src]的锁。"), \
			span_notice("我打开了[src]的锁。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		locked = FALSE
	else
		user.visible_message(span_warning("[user]锁上了[src]。"), \
			span_notice("我锁上了[src]。"))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		locked = TRUE

/obj/structure/pillory/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if (!anchored)
		return FALSE

	if(locked)
		to_chat(usr, span_warning("先把它解锁！"))
		return FALSE

	if (!istype(M, /mob/living/carbon/human))
		to_chat(usr, span_warning("[M]看起来没法被好好固定进这里！"))
		return FALSE // Can't hold non-humanoids

	return ..(M, force, FALSE)

/obj/structure/pillory/post_buckle_mob(mob/living/M)
	if (!istype(M, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/H = M

	if (H.dna)
		if (H.dna.species)
			var/datum/species/S = H.dna.species

			if (istype(S))
				//H.cut_overlays()
				H.update_body_parts_head_only()
				switch(H.dna.species.name)
					if ("Dwarf", "Kobold", "Goblin", "Critterkin")
						H.set_mob_offsets("bed_buckle", _x = 0, _y = PILLORY_HEAD_OFFSET)
				icon_state = "[base_icon]-over"
				update_icon()
			else
				unbuckle_all_mobs()
		else
			unbuckle_all_mobs()
	else
		unbuckle_all_mobs()

	..()

/obj/structure/pillory/post_unbuckle_mob(mob/living/M)
	//M.regenerate_icons()
	M.reset_offsets("bed_buckle")
	icon_state = "[base_icon]"
	update_icon()
	..()

/obj/structure/pillory/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(!latched)
		return ..()
	if(buckled_mob == user)
		if(buckled_mob.STASTR >= 18)
			if(do_after(buckled_mob, 2.5 SECONDS))
				buckled_mob.visible_message(span_warning("[buckled_mob]硬生生把[src]挣开了！"))
				locked = FALSE
				latched = FALSE
				return ..()
			return null
		if(locked)	//can't be locked without also being latched anyway
			to_chat(user, span_warning("它锁住了！我没法自己挣脱！"))
			return
		else if(latched)
			buckled_mob.visible_message(span_warning("[buckled_mob]在[src]里拼命挣扎，试图把插销弄开！"))
			if(do_after(buckled_mob, 12 SECONDS))
				buckled_mob.visible_message(span_warning("[buckled_mob]硬是把[src]的插销撬开了！"))
				latched = FALSE
				return ..()
			else
				return null
	if(locked)	//if user isn't the one in the pillory and it's also locked
		to_chat(user, span_warning("[src]锁住了！我得用钥匙才能打开它。"))
		return null
	latched = FALSE //we pull them free, which implies unlatching
	return ..()

/obj/structure/pillory/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag)
	if(!has_buckled_mobs())
		return ..()

	var/mob/living/victim = pick(buckled_mobs)
	return AM.throw_impact(victim, throwingdatum)

#undef PILLORY_HEAD_OFFSET
