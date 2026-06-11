/obj/effect/decal/remains
	name = "残骸"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'

/obj/effect/decal/remains/acid_act()
	visible_message(span_warning("[src]溶成了一滩滋滋作响的黏液！"))
	playsound(src, 'sound/blank.ogg', 150, TRUE)
	new /obj/effect/decal/cleanable/greenglow(drop_location())
	qdel(src)

/obj/effect/decal/remains/human
	desc = ""
	icon_state = "remains"
	var/harvestable_bones = list(/obj/item/natural/bone = 3, /obj/item/skull = 1)
/obj/effect/decal/remains/human/attack_hand(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user]开始翻找[src]。"), span_warning("我开始翻找[src]。"))
	if(do_after(user, 5 SECONDS, needhand = TRUE, target = src))
		playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
		var/atom/L = drop_location()
		for(var/item in harvestable_bones)
			for(var/num in 1 to harvestable_bones[item])
				new item(L)
		user.visible_message(span_warning("[user]翻找了[src]。"), span_warning("我翻找了[src]。"))
		qdel(src)
/obj/effect/decal/remains/plasma
	icon_state = "remainsplasma"

/obj/effect/decal/remains/xeno
	desc = ""
	icon_state = "remainsxeno"

/obj/effect/decal/remains/xeno/larva
	icon_state = "remainslarva"

/obj/effect/decal/cleanable/robot_debris/old
	name = "落满灰尘的机器人残骸"
	desc = ""
