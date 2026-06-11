/*
Oooooh boy. This is an odd introduction, and an even worse file path. But hear me out.
These are ported from a port I did of Escalation(?), on F13, elsewhere, which was picked up and brought elsewhere.
It was a huge mess. Cleaned up, now. Mostly. Redone for our use. Just know that this is cool. And it kicks ass. - Carl

Design:
 * Deploy bombard.
 * Gather coords, known as 'leyline intersection points'(LIP), for the purpose of IC screwery, with your palantir.
 * Interact with the bombard and put target X-LIP/Y-LIP into it.
 * Fill it with powder. Ram the powder. Both of these actions take time.
 * Load, after which it automatically fires.
 * Dial adjustments as required, if the first shot misses, or you're trying to pre-adjust.
 * Repeat the above, from interaction point onwards. Coords can be reused, but it's expensive to spam this.
 * The only interactions above applicable to a non-Fusilier are filling, ramming and packing/unpacking. Everything else is barred.

Balance:
This is, as of the moment, intended to be limited to Pioneer. To even the playing field for brigands.
Playing field? Eight MAAs, two knights, one KC, eight mercs, etc.
Lets have the funny guys have to come to the bandits, rather than the other way around.
This is incredibly expensive to run. Old Dragonscale levels of expensive.
It's also VERY loud, as in most of the map is going to hear it firing if in range.
This will also KILL people. At least, some of the projectiles.
Requirement of the fusilier trait for aiming and gathering coordinates should limit the intensity, combined with absurd costs.

Also this is later going to the siege mode. But for now, brigands. Woohoo!!!!
*/
/obj/structure/bombard
	name = "便携臼炮"
	desc = "一门轻便、可搬运的臼炮。看起来只有受过训练的人才能瞄准它……"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "smallmortar"
	anchored = 1
	density = 1
	var/xinput = 0
	var/yinput = 0
	var/xdial = 0
	var/ydial = 0
	var/zdial = 0
	var/xoffset = 0
	var/yoffset = 0
	var/offset_per_turfs = 20 //Number of turfs to offset from target by 1
	var/firing = 0
	var/busy = 0
	var/fixed = 0//If 1, bombard cannot be unarchored and moved. Used by the heavy bombard, to prevent repositioning.
	var/travel_time = 45
	var/powder = FALSE
	var/rammed = FALSE
	var/heavy = FALSE//Can this fire anywhere, as opposed to exclusively within 124 tiles?

//TODO change bombard fluff and desc - I never did this. Whoops!!! - Carl
/obj/structure/bombard/fixed
	name = "重型臼炮"
	desc = "一门庞大而固定的重型臼炮。与便携臼炮不同，它几乎能轰击任何地方。只要烟火药够多，再加上一点梦想……"
	icon = 'icons/roguetown/weapons/stationary/bombard48.dmi'
	icon_state = "bigmortar"//We'll get a bigger projectile set, for this one, later. That's what the heavy var was for, before.
	fixed = 1
	heavy = TRUE

/*
/obj/structure/bombard/OnCrafted(dirin)
	dir = turn(dirin, 180)
*/

/obj/structure/bombard/Initialize(mapload)
	. = ..()
	zdial = src.z

/obj/structure/bombard/examine(mob/user)
	. = ..()//Below displays deobfuscated coords. Is that a good idea? No. But it works. Also lets you math things out easier I guess.
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		. += "...<br>\
			<small>'X-LIP' Dial: <span class='warning'>[xinput]</span> <br>\
			'Y-LIP' Dial: <span class='warning'>[yinput]</span> <br>\
			'X-LIP' Adjustment: <span class='warning'>[xdial]</span> <br>\
			'Y-LIP' Adjustment: <span class='warning'>[ydial]</span> <br>\
			<br>\
			Elevation: <span class='danger'>[zdial]0%</span> <br>\
			Expected Deviancy: <span class='danger'>[offset_per_turfs]%</span></small>"//Just for fluff.
	else
		. += "...<br>\
		<small>不出所料，你完全看不懂这些细节。也许受过烟火药训练的人会明白……</small>"
	if(!heavy)
		. += "...<br>\
		<small>这门臼炮可以用 MMB 拆卸打包。</small>"
	else
		. += "...<br>\
		<small>这门臼炮固定在原地，重得根本无法搬动！</small>"

/obj/structure/bombard/attack_hand(mob/user as mob)
	if(busy)
		to_chat(user, "<span class='warning'>现在有别人正在操作[src]。</span>")
		return
	if(firing)
		to_chat(user, "<span class='warning'>[src]的炮管还在冒着热气。先等几秒，让它停火冷却。</span>")
		return
	add_fingerprint(user)

	if(!HAS_TRAIT(user, TRAIT_FUSILIER))
		to_chat(user, "<span class='warning'>你根本不知道这玩意该怎么操作！</span>")
		return

	var/area/A = get_area(src)
	if(!A.outdoors)
		to_chat(user, "<span class='warning'>你没有在室内发射[src]。</span>")
		return

	var/choice = alert(user, "要设定臼炮的目标吗？","臼炮校准", "设定目标","手动校准","取消并清空目标")
	if (choice == "取消并清空目标")//Just in case, as a fallback.
		xdial = 0
		ydial = 0
		zdial = 0
		xinput = 0
		yinput = 0
		return

	if (choice == "设定目标")
		var/temp_targ_x = input("设定打击点的横向偏移。") as num
		if(xdial + deobfuscate_x(temp_targ_x) > world.maxx || xdial + deobfuscate_x(temp_targ_x) < 0)
			to_chat(user, "<span class='warning'>你无法瞄准这个目标，它超出了你的射程。</span>")
			return
		var/temp_targ_y = input("设定打击点的纵向偏移。") as num
		if(ydial + deobfuscate_y(temp_targ_y) > world.maxy || ydial + deobfuscate_y(temp_targ_y) < 0)
			to_chat(user, "<span class='warning'>你无法瞄准这个目标，它超出了你的射程。</span>")
			return
		var/temp_targ_z = input("调整打击点高度。") as num
		if(temp_targ_z > 5/*world.maxz*/ || temp_targ_z < 2)//Adjust if we abandon the 5 Z setup.
			to_chat(user, "<span class='warning'>你不能以这种方式调整臼炮仰角。</span>")
			return

		//Does anything prevent us from actually hitting that area?
		var/turf/T = locate(deobfuscate_x(temp_targ_x) + xdial, deobfuscate_y(temp_targ_y) + ydial, temp_targ_z)
		if(get_dist(loc, T) < 10)
			to_chat(user, "<span class='warning'>你无法瞄准这个目标，它离你的臼炮太近了。</span>")
			return
		if(get_dist(loc, T) > 124 && !heavy)//Heavy bombards, exclusively, can aim anywhere. You can still offset away from the max.
			to_chat(user, "<span class='warning'>这个目标对轻型臼炮来说太远了！</span>")
			return

		//Special checks, now. Eventually, we'll do 'is_centcom_level' and 'is_station_level'. When I make those not awful.
		//We intentionally allow offsets to target protected locations, since it can't go as deep, or reliably.
		if(!T.can_see_sky())
			to_chat(user, "<span class='warning'>这个位置上方有天花板！你不能直接瞄准那里！重新调整！</span>")
			return
/*		if(T.arcyne_shroud_check())//Has the magos warded the area? Some locations are protected by default, such as his tower...
			to_chat(user, "<span class='warning'>This target is protected by an arcyne shroud! You cannot aim directly at it! Adjust!</span>")
			return
		if(R.ceiling_protected)//As above. Separate, for good reason. | Commented out. For now.
			to_chat(user, "<span class='warning'>This target is hardened against intrusion! You cannot dial directly to it! Adjust!</span>")
			return*/

		if(busy)
			to_chat(user, "<span class='warning'>现在有别人正在操作这门臼炮。</span>")
			return
		//All's well? Continue!

		user.visible_message("<span class='notice'>([user]开始调整[src]的射角与距离。</span>",
		"<span class='notice'>你开始调整[src]的射角与距离，让它对准新的目标位置。</span>")
		busy = 1
		if(do_after(user, 30, src))
			user.visible_message("<span class='notice'>([user]完成了[src]的射角与距离调整。</span>",
			"<span class='notice'>你完成了[src]的射角与距离调整，使其对准新的目标位置。</span>")
			playsound(loc, 'sound/combat/shieldraise.ogg', 25, TRUE)
			busy = 0
			xinput = deobfuscate_x(temp_targ_x)
			yinput = deobfuscate_y(temp_targ_y)
			var/offset_x_max = round(abs((xinput + xdial) - x)/offset_per_turfs) //Offset of bombard shot, grows by 1 every 20 tiles travelled
			var/offset_y_max = round(abs((yinput + ydial) - y)/offset_per_turfs)
			xoffset = rand(-offset_x_max, offset_x_max)
			yoffset = rand(-offset_y_max, offset_y_max)
			if(zdial == null)//No offset? Somehow? That's fine! We do the bombard's Z!
				zdial = src.z
			else
				zdial = temp_targ_z
		else
			busy = 0

	if (choice == "手动校准")
		if(zdial == null)//Have you even set the elevation? No? GO SET IT!!! HOW DID YOU MANAGE THIS, EVEN? I HATE YOU!!!!!
			to_chat(user, "<span class='warning'>你还没设定臼炮的目标高程！你打算怎么修正落点？</span>")
			return
		var/temp_dial_x = input("将横向偏移修正设为 -10 到 10。") as num
		if(temp_dial_x + xinput > world.maxx || temp_dial_x + xinput < 0)
			to_chat(user, "<span class='warning'>你无法把横向偏移调到这里，它超出了臼炮射程。</span>")
			return
		if(temp_dial_x < -10 || temp_dial_x > 10)
			to_chat(user, "<span class='warning'>你无法将目标修正到这里，它太远了。你得重新布设[src]。</span>")
			return
		var/temp_dial_y = input("将纵向偏移修正设为 -10 到 10。") as num
		if(temp_dial_y + yinput > world.maxy || temp_dial_y + yinput < 0)
			to_chat(user, "<span class='warning'>你无法把纵向偏移调到这里，它超出了臼炮射程。</span>")
			return

		//As above, we do the checks now to see if this is even possible.
		var/turf/T = locate(xinput + temp_dial_x, yinput + temp_dial_y, zdial)
		if(get_dist(loc, T) < 10)
			to_chat(user, "<span class='warning'>你无法把落点调到这里，它离臼炮太近了。</span>")
			return
		if(temp_dial_y < -10 || temp_dial_y > 10)
			to_chat(user, "<span class='warning'>你无法将目标修正到这里，它太远了。你得重新布设[src]。</span>")
			return
		if(busy)
			to_chat(user, "<span class='warning'>现在有别人正在操作这门臼炮。</span>")
			return
		//Good to go? Awesome.

		user.visible_message("<span class='notice'>[user]开始拨调[src]的射角与距离。</span>",
		"<span class='notice'>你开始拨调[src]的射角与距离，使其对准新的目标位置。</span>")
		busy = 1
		if(do_after(user, 15, src))
			user.visible_message("<span class='notice'>[user]完成了[src]的射角与距离拨调。</span>",
			"<span class='notice'>你完成了[src]的射角与距离拨调，使其对准新的目标位置。</span>")
			busy = 0
			xdial = temp_dial_x
			ydial = temp_dial_y
		else
			busy = 0

/obj/structure/bombard/attackby(obj/item/O as obj, mob/user as mob)
	var/area/A = get_area(src)
	if(!A.outdoors)
		to_chat(user, "<span class='warning'>你没有在室内准备发射[src]。</span>")
		return

	if(istype(O, /obj/item/powderflask))
		if(powder)
			user.visible_message("<span class='notice'>[src]里已经装满烟火药了！</span>")
			return
		else
			user.visible_message("<span class='notice'>[user]开始往[src]里填装烟火药。</span>")
			playsound(src, "modular_helmsguard/sound/arquebus/pour_powder.ogg", 80, TRUE)
			if(do_after(user, 4 SECONDS, src))
				user.visible_message("<span class='notice'>[user]将[src]填满了烟火药。</span>")
				powder = TRUE
			return

	if(!powder)
		to_chat(user, "<span class='danger'>[src]里还没装烟火药！</span>")
		return

	if(istype(O, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge))
		if(rammed)
			user.visible_message("<span class='notice'>[src]里的烟火药已经捣实妥当了！</span>")
			return
		else
			user.visible_message("<span class='notice'>[user]开始把[src]里的烟火药捣实。</span>")
			playsound(src, "modular_azurepeak/sound/spellbooks/bladescrape.ogg", 80, TRUE)
			if(do_after(user, 8 SECONDS, src))
				user.visible_message("<span class='notice'>[user]把[src]里的烟火药捣实完毕了。</span>")
				rammed = TRUE
			return

	if(!rammed)
		to_chat(user, "<span class='danger'>[src]里的装药还没用捣杆压实！</span>")
		return

	if(istype(O, /obj/item/cannonball))
		var/obj/item/cannonball/cannonball = O

		if(busy)
			to_chat(user, "<span class='warning'>现在有别人正在操作[src]。</span>")
			return
/*
		if(z != 1)
			to_chat(user, "<span class='warning'>You cannot fire [src] here.</span>")
			return
*/
		if(xinput == 0 && yinput == 0) //Bombard wasn't set
			to_chat(user, "<span class='warning'>[src]得先完成瞄准。</span>")
			return

		var/turf/T = locate(xinput + xdial + xoffset, yinput + ydial + yoffset, zdial)
		if(!isturf(T))
			to_chat(user, "<span class='warning'>你不能朝这个位置发射[src]。</span>")
			return

		user.visible_message("<span class='notice'>[user]开始将一枚[cannonball.name]装入[src]。</span>",
		"<span class='notice'>你开始将一枚[cannonball.name]装入[src]。</span>")
		playsound(loc, 'sound/combat/bombard/mortar_reload.ogg', 50, TRUE)
		busy = 1

		if(do_after(user, 3 SECONDS, src))
			user.visible_message("<span class='notice'>[user]将一枚[cannonball.name]装进了[src]。</span>",
			"<span class='notice'>你将一枚[cannonball.name]装进了[src]。</span>")
			visible_message("\icon[src] <span class='danger'>[name]开火了！</span>")
			user.dropItemToGround(cannonball, src)
			playsound(loc, 'sound/combat/bombard/mortar_fire.ogg', 50, TRUE)//We want this heard from anywhere in reach. Except in the case of heavy bombards.
			loud_message("能听见火炮开火的巨响", hearing_distance = 124)//So account for minimum distance, by +10.
			busy = 0
			firing = 1
			flick(icon_state + "_fire", src)
			cannonball.forceMove(src)

			for(var/mob/M in range(7))
				shake_camera(M, 3, 1)
			spawn(travel_time) //What goes up
				playsound(T, 'sound/combat/bombard/mortar_long_whistle.ogg', 80, TRUE)
				T.loud_message("头顶传来臼炮炮弹掠空的尖啸", hearing_distance = 12)//An acceptable range, m'lord.
				spawn(45) //Must go down
					cannonball.detonate(T)
					qdel(cannonball)
					firing = 0

			var/msg = "[key_name(user)] fired a bombard, aiming at: X[xinput], Y[yinput], Z[zdial] | (Offset: X[xdial], Y[ydial])"
			message_admins(msg)
			log_admin(msg)
			xdial = 0//Reset after each shot. Post logging.
			ydial = 0
			zdial = 0
			xinput = 0
			yinput = 0
			powder = FALSE
			rammed = FALSE

		else
			busy = 0

/*
/obj/structure/bombard/AltClick(mob/user)
	..()
*/

/obj/structure/bombard/MiddleClick(mob/user)
	if(busy)
		to_chat(user, "<span class='warning'>现在有别人正在操作[src]。</span>")
		return
	if(firing)
		to_chat(user, "<span class='warning'>臼炮正在发射中，先等几秒让炮管冷却。</span>")
		return
	if(fixed)
		to_chat(user, "<span class='warning'>这门臼炮固定在原地，你没法移动它。</span>")
		return

	xdial = 0//Reset after attempted deconstruction.
	ydial = 0
	zdial = 0
	xinput = 0
	yinput = 0
	powder = FALSE//We dump the powder and ram state, in case you're some matter of freak trying to quick position.
	rammed = FALSE

	playsound(loc, 'sound/combat/shieldraise.ogg', 25, TRUE)
	user.visible_message("<span class='notice'>[user]开始拆卸[src]。",
	"<span class='notice'>你开始拆卸[src]。")
	if(do_after(user, 40, src))
		user.visible_message("<span class='notice'>[user]拆下了[src]。",
		"<span class='notice'>你拆下了[src]。")
		playsound(loc, 'sound/combat/shieldraise.ogg', 25, TRUE)
		new /obj/item/bombard_frame(loc)
		new /obj/item/bombard_barrel(loc)
		qdel(src)

/obj/structure/bombard/ex_act(severity)
	return
