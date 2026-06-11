/obj/effect/proc_holder/spell/invoked/transform_tree
	name = "化树为智"
	desc = "将一棵普通树木转化为 Dendor 的智者古树。"
	invocation_type = "whisper"
	overlay_state = "entangle"
	range = 1
	recharge_time = 20 SECONDS
	var/uses = 3

/obj/effect/proc_holder/spell/invoked/transform_tree/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return

	var/atom/target_atom = targets[1]
	var/obj/structure/flora/target

	if(istype(target_atom, /obj/structure/flora/tree) && !istype(target_atom, /obj/structure/flora/roguetree/wise) && !istype(target_atom, /obj/structure/flora/roguetree/stump))
		target = target_atom
	else if(istype(target_atom, /obj/structure/flora/newtree))
		target = target_atom
	else if(target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
		for(var/obj/structure/flora/tree/T in target_atom.loc)
			if(!istype(T, /obj/structure/flora/roguetree/wise) && !istype(T, /obj/structure/flora/roguetree/stump))
				target = T
				break
		if(!target)
			for(var/obj/structure/flora/newtree/NT in target_atom.loc)
				if(!NT.burnt)
					target = NT
					break

	if(!target)
		to_chat(H, span_warning("你必须选中身旁一棵普通且活着的树木！"))
		return

	if(uses <= 0)
		to_chat(H, span_warning("你的赐福已经耗尽了！"))
		H.mind.RemoveSpell(src)
		return

	H.visible_message(span_notice("[H] 开始低声吟唱，准备转化这棵树。"), \
					span_notice("我开始进行转化仪式……"))

	if(!do_after(H, 10 SECONDS, target = target))
		to_chat(H, span_warning("仪式被打断了！"))
		return

	var/turf/T = get_turf(target)
	var/obj/structure/flora/roguetree/wise/new_wise_tree = new(T)
	new_wise_tree.activated = TRUE
	new_wise_tree.set_light(2, 2, 2, l_color = "#66FF99")

	if(istype(target, /obj/structure/flora/newtree))
		for(var/turf/adjacent in range(1, T))
			for(var/obj/structure/flora/newbranch/B in adjacent)
				qdel(B)
			for(var/obj/structure/flora/newleaf/L in adjacent)
				qdel(L)
		var/turf/above = get_step_multiz(T, UP)
		if(istype(above, /turf/open/transparent/openspace))
			for(var/obj/structure/flora/newtree/upper_tree in above)
				qdel(upper_tree)

	qdel(target)

	uses--
	SEND_SIGNAL(user, COMSIG_TREE_TRANSFORMED)
	if(uses > 0)
		to_chat(H, span_notice("我将这棵树转化成了智者古树。还剩 [uses] 次使用机会。"))
	else
		to_chat(H, span_notice("我将这棵树转化成了智者古树。"))
	playsound(T, 'sound/ambience/noises/mystical (4).ogg', 50, TRUE)

	if(uses <= 0)
		to_chat(H, span_warning("Dendor 的赐福自我身上消退了。"))
		H.mind.RemoveSpell(src)
