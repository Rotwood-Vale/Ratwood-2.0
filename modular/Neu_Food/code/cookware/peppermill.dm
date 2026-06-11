/obj/item/reagent_containers/peppermill // new with some animated art
	name = "胡椒研磨器"
	desc = "让领主享用他的点心吧；转动研磨器顶部，直到它噼啪作响。"
	icon = 'modular/Neu_Food/icons/cookware/peppermill.dmi'
	icon_state = "peppermill"
	layer = CLOSED_BLASTDOOR_LAYER // obj layer + a little, small obj layering above convenient
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	list_reagents = list(/datum/reagent/consumable/blackpepper = 5)
	reagent_flags = TRANSPARENT
