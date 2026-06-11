/obj/item/reagent_containers/glass/bucket/pot
	force = 10
	name = "锅"
	desc = "一口铁制的锅，能装很多液体。"
	icon = 'modular/Neu_Food/icons/cookware/pot.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	icon_state = "pote"
	sharpness = IS_BLUNT
	slot_flags = null
	item_state = "pot"
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	w_class = WEIGHT_CLASS_BULKY
	reagent_flags = OPENCONTAINER
	throwforce = 10
	dropshrink = 1 // Override for bucket
	volume = 240

/obj/item/reagent_containers/glass/bucket/pot/update_icon()
	cut_overlays()
	if(reagents.total_volume > 0)
		if(reagents.total_volume <= 50)
			var/mutable_appearance/filling = mutable_appearance(icon, "pote_half")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)

		if(reagents.total_volume > 50)
			var/mutable_appearance/filling = mutable_appearance(icon, "pote_full")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)


/obj/item/reagent_containers/glass/bucket/pot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bowl))
		to_chat(user, "<span class='notice'>正在把碗装满......</span>")
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 70, FALSE)
		if(do_after(user,2 SECONDS, target = src))
			reagents.trans_to(I, reagents.total_volume)
	return TRUE

/obj/item/reagent_containers/glass/bucket/pot/decrepit
	name = "破旧锅"
	desc = "一口锻造青铜锅。真让人想象不出数千年前的炖汤会是什么滋味；你觉得那时候的人也懂得香料与调味吗？"
	icon_state = "apote"
	volume = 120
	color = "#bb9696"
	sellprice = 25

/obj/item/reagent_containers/glass/bucket/pot/stone
	name = "石锅"
	desc = "一口石制的锅。它能装的东西比金属锅少。"
	volume = 120 // 99 is the max volume for a stone pot

/obj/item/reagent_containers/glass/bucket/pot/kettle
	name = "水壶"
	desc = "一只铁制水壶，便于携带。"
	icon_state = "kettle"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 64
	volume = 120

/obj/item/reagent_containers/glass/bucket/pot/copper
	name = "铜锅"
	desc = "一口铜制的锅，能装很多液体。"
	icon_state = "pote_copper"

/obj/item/reagent_containers/glass/bucket/pot/teapot
	name = "茶壶"
	desc = "一只陶制茶壶，用来奉茶，容量很大，不过依然可能洒出来。"
	dropshrink = 0.7
	icon_state = "teapot"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	volume = 120
	sellprice = 20

/obj/item/reagent_containers/glass/bucket/pot/carved
	name = "雕饰茶壶"
	desc = "你本不该看到这个。"
	icon_state = "teapot"
	fill_icon_thresholds = null
	dropshrink = 1.0
	volume = 99
	sellprice = 0

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotjade
	name = "玉茶壶"
	desc = "一只由玉石雕成的精致茶壶。"
	icon_state = "teapot_jade"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotamber
	name = "琥珀茶壶"
	desc = "一只由琥珀雕成的精致茶壶。"
	icon_state = "teapot_amber"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotshell
	name = "贝壳茶壶"
	desc = "一只由贝壳雕成的精致茶壶。"
	icon_state = "teapot_shell"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 20

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotrose
	name = "玫瑰石茶壶"
	desc = "一只由玫瑰石雕成的精致茶壶。"
	icon_state = "teapot_rose"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 25

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotopal
	name = "欧泊茶壶"
	desc = "一只由欧泊雕成的精致茶壶。"
	icon_state = "teapot_opal"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 90

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotonyxa
	name = "缟玛瑙茶壶"
	desc = "一只由缟玛瑙雕成的精致茶壶。"
	icon_state = "teapot_onyxa"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 40

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotcoral
	name = "心石茶壶"
	desc = "一只由心石雕成的精致茶壶。"
	icon_state = "teapot_coral"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 70

/obj/item/reagent_containers/glass/bucket/pot/carved/teapotturq
	name = "蔚蓝石茶壶"
	desc = "一只由蔚蓝石雕成的精致茶壶。"
	icon_state = "teapot_turq"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 85

/obj/item/reagent_containers/glass/bucket/pot/teapot/examine()
	. = ..()
	. += span_info("可以用染色刷为它上釉。")

/obj/item/reagent_containers/glass/bucket/pot/teapot/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("茶壶里还有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 3 SECONDS, target = src))
			to_chat(user, span_notice("我用染色刷给茶壶上了釉。"))
			new /obj/item/reagent_containers/glass/bucket/pot/teapot/fancy(get_turf(src))
			qdel(src)
		return
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/teapot/fancy
	icon_state = "teapot_fancy"
	sellprice = 24

/obj/item/reagent_containers/glass/bucket/pot/teapot/update_icon(dont_fill=FALSE)
	return FALSE // There's no filling for teapot
