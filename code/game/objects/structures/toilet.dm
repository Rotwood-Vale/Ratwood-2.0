/obj/structure/toilet
	name = "马桶"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE
	var/open = FALSE			//if the lid is up
	var/cistern = 1			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie
	var/buildstacktype
	var/buildstackamount = 1

/obj/structure/toilet/Initialize(mapload)
	. = ..()

/obj/structure/toilet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	if(cistern && user.CanReach(src))
		if(!contents.len)
			to_chat(user, "<span class='notice'>马桶里是空的。</span>")
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(drop_location())
			to_chat(user, "<span class='notice'>我在马桶里找到了[I]。</span>")
			w_items -= I.w_class

/obj/structure/toilet/update_icon_state()
	icon_state = "toilet"

/obj/structure/toilet/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/toilet/attackby(obj/item/I, mob/living/user, params)
	add_fingerprint(user)
	if(I.tool_behaviour == TOOL_CROWBAR)
		to_chat(user, "<span class='notice'>我开始[cistern ? "盖上水箱盖" : "掀开水箱盖"]……</span>")
		playsound(loc, 'sound/blank.ogg', 50, TRUE)
		if(I.use_tool(src, user, 30))
			user.visible_message("<span class='notice'>[user][cistern ? "盖上了水箱盖" : "掀开了水箱盖"]！</span>", "<span class='notice'>我[cistern ? "盖上了水箱盖" : "掀开了水箱盖"]！</span>", "<span class='hear'>我听见瓷器摩擦的声音。</span>")
			cistern = !cistern
			update_icon()
	else if(I.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		I.play_tool_sound(src)
		deconstruct()
	else if(cistern)
		if(user.used_intent.type != INTENT_HARM)
			if(I.w_class > WEIGHT_CLASS_NORMAL)
				to_chat(user, "<span class='warning'>[I]放不进去！</span>")
				return
			if(w_items + I.w_class > WEIGHT_CLASS_HUGE)
				to_chat(user, "<span class='warning'>马桶已经满了！</span>")
				return
			if(!user.transferItemToLoc(I, src))
				to_chat(user, "<span class='warning'>[I]黏在你的手上了，没法把它塞进水箱！</span>")
				return
			w_items += I.w_class
			to_chat(user, "<span class='notice'>我小心地把[I]放进了马桶里。</span>")

	else if(istype(I, /obj/item/reagent_containers))
		if (!open)
			return
		var/obj/item/reagent_containers/RG = I
		RG.reagents.add_reagent(/datum/reagent/water/gross, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		to_chat(user, "<span class='notice'>我从[src]里给[RG]装满了液体。</span>")
	else
		return ..()
