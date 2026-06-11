/obj/machinery/tanningrack
	name = "晾干架"
	desc = "一个用于晾干肉类或将兽皮刮制成皮革的架子。可以借助木桩来移动它。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "dryrack"
	var/obj/item/natural/hide/hide
	max_integrity = 200
	density = TRUE
	climbable = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/machinery/tanningrack/examine(mob/user)
	. = ..()
	if(hide)
		. += span_warning("上面有一块待处理的兽皮。可能需要一把刀来刮制。")
	if(!anchored)
		. += span_warning("它没有被固定住，可以移动。")

/obj/machinery/tanningrack/attack_hand(mob/user, params)
	if(hide)
		var/obj/item/I = hide
		hide = null
		I.loc = user.loc
		user.put_in_active_hand(I)
		update_icon()

/obj/machinery/tanningrack/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/hide) && !istype(I, /obj/item/natural/hide/cured))
		if(!hide)
			I.forceMove(src)
			hide = I
			update_icon()
			return
		else
			to_chat(user, span_warning("架子上已经有东西了！"))
			return
	if((user.used_intent.type == /datum/intent/dagger/cut || user.used_intent.type == /datum/intent/sword/cut || user.used_intent.type == /datum/intent/axe/cut) && hide)
		if(anchored)
			var/skill_level = max(user.get_skill_level(/datum/skill/craft/tanning))
			var/work_time = (120 - (skill_level * 15))
			var/pieces_to_spawn = rand(1, min(skill_level + 1, 6)) //Random number from 1 to skill level
			var/sound_played = FALSE
			to_chat(user, span_warning("我开始刮削兽皮..."))
			if(!do_after(user, work_time, target = user))
				return
			playsound(src,pick('sound/items/book_open.ogg','sound/items/book_page.ogg'), 100, FALSE)
			QDEL_NULL(hide)
			user.mind.add_sleep_experience(/datum/skill/craft/tanning, user.STAINT * 2) //these numbers may need some revision
			update_icon()
			var/essence_factor = 1 // Chance of getting an essence
			// Not flat scaling, tilted toward the higher levels
			switch(skill_level)
				if(SKILL_LEVEL_NOVICE)
					essence_factor = 1
				if(SKILL_LEVEL_APPRENTICE)
					essence_factor = 2
				if(SKILL_LEVEL_JOURNEYMAN)
					essence_factor = 3
				if(SKILL_LEVEL_EXPERT)
					essence_factor = 6 // Big Jump here - Hunter can level to this quickly. Tailor start w/ it
				if(SKILL_LEVEL_MASTER)
					essence_factor = 8
				if(SKILL_LEVEL_LEGENDARY)
					essence_factor = 10
			for(var/i = 0; i < pieces_to_spawn; i++)
				if(prob(essence_factor + user.goodluck(2)))
					new /obj/item/natural/cured/essence(get_turf(user))
					if(!sound_played)
						sound_played = TRUE
						to_chat(user, span_warning("登多尔 降下恩惠……"))
						playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
				new /obj/item/natural/hide/cured(get_turf(user))
			return
		else
			to_chat(user, span_warning("我得先用木桩把它固定住，才能处理这张兽皮。"))
			return
	if(istype(I, /obj/item/grown/log/tree/stake))
		if(anchored)
			anchored = FALSE
			to_chat(user, span_warning("[src]现在可以移动了。"))
		else
			anchored = TRUE
			to_chat(user, span_warning("你固定好了[src]。"))
		playsound(src,pick('sound/foley/woodclimb.ogg'), 100, TRUE)
		return
	..()

/obj/machinery/tanningrack/update_icon()
	cut_overlays()
	if(hide)
		var/obj/item/I = hide
		I.pixel_x = 0
		I.pixel_y = 0
		var/mutable_appearance/M = new /mutable_appearance(I)
		M.pixel_y = 0
		M.pixel_x = 0
		add_overlay(M)
