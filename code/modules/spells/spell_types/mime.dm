/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall
	name = "隐形墙"
	desc = ""
	school = "mime"
	panel = "哑剧"
	summon_type = list(/obj/effect/forcefield/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>我在自己面前筑起了一道墙。</span>"
	summon_lifespan = 300
	recharge_time = 300
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = 0
	cast_sound = null
	human_req = TRUE

	overlay_state = "invisible_wall"
	overlay_alpha = 175

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/Click()
	if(usr && usr.mind)
		if(!HAS_TRAIT(usr, TRAIT_PERMAMUTE)) // If somehow someone gets ahold of this spell...
			to_chat(usr, span_warning("我不是哑剧演员！"))
			return
		invocations = list("像是有一道墙挡在了[usr.p_them()]面前。")
	else
		invocation_type ="none"
	invocation(usr) // force invocation because invocation() only gets called on a specific spell (not aoe_turf)
	..()

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair
	name = "隐形椅"
	desc = ""
	school = "mime"
	panel = "哑剧"
	summon_type = list(/obj/structure/chair/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>我变出一把隐形椅子并坐了下来。</span>"
	summon_lifespan = 250
	recharge_time = 300
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = 0
	cast_sound = null
	human_req = TRUE

	overlay_state = "invisible_chair"
	overlay_alpha = 175

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair/Click()
	if(usr && usr.mind)
		if(!HAS_TRAIT(usr, TRAIT_PERMAMUTE))
			to_chat(usr, span_warning("我不是哑剧演员！"))
			return
		invocations = list("摸出一把隐形椅子，随后坐了下去。")
	else
		invocation_type ="none"
	invocation(usr)
	..()

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair/cast(list/targets,mob/user = usr)
	..()
	var/turf/T = user.loc
	for (var/obj/structure/chair/A in T)
		if (is_type_in_list(A, summon_type))
			A.setDir(user.dir)
			A.buckle_mob(user)


/obj/effect/proc_holder/spell/targeted/mime/speak
	name = "言语"
	desc = ""
	school = "mime"
	panel = "哑剧"
	clothes_req = FALSE
	human_req = TRUE
	antimagic_allowed = TRUE
	recharge_time = 3000
	range = -1
	include_user = TRUE

	action_icon_state = "mime_speech"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/mime/speak/Click()
	if(!usr)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.mind.miming)
		still_recharging_msg = "<span class='warning'>我没法这么快再次打破沉默誓言！</span>"
	else
		still_recharging_msg = "<span class='warning'>想再次立下沉默誓言，你还得再等等！</span>"
	..()

/obj/effect/proc_holder/spell/targeted/mime/speak/cast(list/targets,mob/user = usr)
	for(var/mob/living/carbon/human/H in targets)
		H.mind.miming=!H.mind.miming
		if(H.mind.miming)
			to_chat(H, "<span class='notice'>我立下了沉默誓言。</span>")
		else
			to_chat(H, "<span class='notice'>我打破了自己的沉默誓言。</span>")

// These spells can only be gotten from the "Guide for Advanced Mimery series" for Mime Traitors.

/obj/effect/proc_holder/spell/targeted/forcewall/mime
	name = "隐形路障"
	desc = ""
	school = "mime"
	panel = "哑剧"
	wall_type = /obj/effect/forcefield/mime/advanced
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>我在自己面前筑起了一道路障。</span>"
	recharge_time = 600
	sound =  null
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = -1
	include_user = TRUE

	action_icon_state = "invisible_blockade"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/forcewall/mime/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='warning'>我必须先将自己奉献给沉默！</span>")
			return
		invocations = list("像是有一道路障横在了[usr.p_them()]面前。")
	else
		invocation_type ="none"
	..()

/obj/item/book/granter/spell/mimery_blockade
	spell = /obj/effect/proc_holder/spell/targeted/forcewall/mime
	spellname = "隐形路障"
	name = "高级哑剧指南 卷一"
	desc = ""
	icon_state ="bookmime"
	remarks = list("...")

/obj/item/book/granter/spell/mimery_blockade/attack_self(mob/user)
	. = ..()
	if(!.)
		return
	if(!locate(/obj/effect/proc_holder/spell/targeted/mime/speak) in user.mind.spell_list)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak)
