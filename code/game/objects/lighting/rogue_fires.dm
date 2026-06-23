#define MIN_STEW_TEMPERATURE 374 // For cooking
#define VOLUME_PER_STEW_COOK 29 // Volume to cook per ingredient
#define VOLUME_PER_STEW_COOK_AFTER 1 // Volume to deduct after the sleep is over
#define DEEP_FRY_TIME 5 SECONDS // Default deep fry time
#define OIL_CONSUMED 5 // Amount of oil consumed per deep fry (1 fat = 4 fry)

/obj/machinery/light/rogue/firebowl
	name = "火盆"
	desc = "一个坚固的石制火盆，像山岳一样牢靠。"
	icon = 'icons/roguetown/misc/lighting.dmi'
	icon_state = "stonefire1"
	bulb_colour = "#ffa35c"
	brightness = 12
	density = TRUE
//	pixel_y = 10
	base_state = "stonefire"
	climbable = TRUE
	pass_flags = LETPASSTHROW
	cookonme = TRUE
	dir = SOUTH
	crossfire = TRUE
	fueluse = 0
	no_refuel = TRUE
	heat_level = 4

/obj/machinery/light/rogue/firebowl/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	return !density

/obj/machinery/light/rogue/firebowl/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(!on)

		if(icon_state == "[base_state]over")
			user.visible_message("<span class='notice'>[user]开始搬起[src]...</span>", \
				"<span class='notice'>我开始搬起[src]...</span>")
			if(do_after(user, 30, target = src))
				icon_state = "[base_state]0"
			return

/obj/machinery/light/rogue/firebowl/off
	icon_state = "stonefire0"
	base_state = "stonefire"
	status = LIGHT_BURNED
	desc = "火已经熄灭了！"

/obj/machinery/light/rogue/firebowl/stump
	icon_state = "stumpfire1"
	base_state = "stumpfire"
	desc = "有些简陋，却照亮了这片土地上蜿蜒漫长的小路。"

/obj/machinery/light/rogue/firebowl/church
	desc = "一个宽阔的金属火盆，架在底座上，燃起旺盛的火焰。"
	icon_state = "churchfire1"
	base_state = "churchfire"

/obj/machinery/light/rogue/firebowl/church/off
	icon_state = "churchfire0"
	base_state = "churchfire"
	soundloop = null
	status = LIGHT_BURNED
	desc = "火已经熄灭了！"

/obj/machinery/light/rogue/firebowl/standing
	name = "立式烛火"
	desc = "锻打金属被塑造成一个出奇稳固的支架，用来托住大蜡烛。"
	icon_state = "standing1"
	base_state = "standing"
	bulb_colour = "#ff9648"
	cookonme = FALSE
	crossfire = FALSE
	density = FALSE
	heat_level = 3


/obj/machinery/light/rogue/firebowl/standing/blue
	icon_state = "standingb1"
	base_state = "standingb"
	bulb_colour = "#7b60f3"
	desc = "柔和的蓝色，如同月光。"

/obj/machinery/light/rogue/firebowl/standing/green
	icon_state = "standingg1"
	base_state = "standingg"
	bulb_colour = "#8ee2a7"
	desc = "柔和的绿色……嗯，你一时也想不出像什么。"

/obj/machinery/light/rogue/firebowl/standing/red
	icon_state = "standingr1"
	base_state = "standingr"
	bulb_colour = "#f02929"
	desc = "一种非尘世的赤红色，隐约飘来硫磺气味。"


/obj/machinery/light/rogue/firebowl/standing/proc/knock_over() //use this later for jump impacts and shit
	icon_state = "[base_state]over"

/obj/machinery/light/rogue/firebowl/standing/fire_act(added, maxstacks)
	if(icon_state != "[base_state]over")
		..()

/obj/machinery/light/rogue/firebowl/standing/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(icon_state == "[base_state]over")
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
				user.visible_message("<span class='warning'>[user]用[user.p_their()]尾巴猛抽[src]！</span>", \
					"<span class='warning'>我用尾巴抽打[src]！</span>")
			else
				user.visible_message("<span class='warning'>[user]踢了[src]！</span>", \
					"<span class='warning'>我踢了[src]！</span>")
			return
		if(prob(L.STASTR * 8))
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
				user.visible_message("<span class='warning'>[user]用[user.p_their()]尾巴抽翻了[src]！</span>", \
					"<span class='warning'>我猛抽[src]，把它掀翻了！</span>")
			else
				user.visible_message("<span class='warning'>[user]把[src]踢翻了！</span>", \
					"<span class='warning'>我把[src]踢翻了！</span>")
			burn_out()
			knock_over()
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
				user.visible_message("<span class='warning'>[user]用[user.p_their()]尾巴猛抽[src]！</span>", \
					"<span class='warning'>我用尾巴猛抽[src]！</span>")

/obj/machinery/light/rogue/campfire/fireplace
	name = "壁炉"
	desc = "温暖的火焰在半燃的木柴与发光余烬之间跃动。"
	icon_state = "wallfire1"
	base_state = "wallfire"
	light_outer_range = 4 //slightly weaker than a torch
	bulb_colour = "#ffa35c"
	fueluse = 0
	no_refuel = TRUE
	crossfire = FALSE
	healing_range = 2
	stamina_status_effect = /datum/status_effect/buff/campfire_stamina/fireplace
	heat_level = 6

/obj/machinery/light/rogue/campfire/fireplace/attack_right(mob/user)
	if(isliving(user) && on)
		user.visible_message(span_warning("[user]熄灭了[src]。"))
		burn_out()
		return TRUE
	return ..()
/obj/machinery/light/rogue/campfire/fireplace/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!on)
		return
	var/mob/living/carbon/human/H = user

	if(istype(H))
		H.visible_message("<span class='info'>[H]在火上暖了暖自己的手。</span>")

		if(do_after(H, 15, target = src) && H.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT - 75)
			H.adjust_bodytemperature(75)
	return TRUE //fires that are on always have this interaction with lmb unless its a torch

/obj/machinery/light/rogue/campfire/fireplace/inn
	name = "大壁炉"
	healing_range = 6

/obj/machinery/light/rogue/campfire/fireplace/crafted
	density = FALSE
	pixel_y = 32
	cookonme = TRUE

/obj/machinery/light/rogue/campfire/fireplace/crafted/blue
	desc = "一团奇特的、清冷的火焰在神秘发光的余烬上翩翩起舞。"
	icon = 'icons/roguetown/misc/wallfireblue.dmi'
	bulb_colour = "#6e90ff"

/obj/machinery/light/rogue/campfire/fireplace/blue
	desc = "一团奇特的、清冷的火焰在神秘发光的余烬上翩翩起舞。"
	icon = 'icons/roguetown/misc/wallfireblue.dmi'
	bulb_colour = "#6e90ff"

/obj/machinery/light/rogue/candle
	name = "蜡烛"
	desc = "微弱的火焰随风摇曳，提供足够的光亮让人看清周围。"
	icon_state = "wallcandle1"
	base_state = "wallcandle"
	crossfire = FALSE
	cookonme = FALSE
	pixel_y = 32
	soundloop = null
	fueluse = 0

/obj/machinery/light/rogue/candle/off
	name = "蜡烛"
	desc = "冰冷的蜡泪半融半凝，凄然静止。它们只缺一点火星。"
	icon_state = "wallcandle0"
	base_state = "wallcandle"
	crossfire = FALSE
	cookonme = FALSE
	light_outer_range = 0
	pixel_y = 32
	soundloop = null
	status = LIGHT_BURNED

/obj/machinery/light/rogue/candle/off/r
	pixel_y = 0
	pixel_x = 32
/obj/machinery/light/rogue/candle/off/l
	pixel_y = 0
	pixel_x = -32

/obj/machinery/light/rogue/candle/OnCrafted(dirin)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/machinery/light/rogue/candle/attack_hand(mob/user)
	if(isliving(user) && on)
		user.visible_message(span_warning("[user]熄灭了[src]。"))
		burn_out()
		return TRUE //fires that are on always have this interaction with lmb unless its a torch
	. = ..()

/obj/machinery/light/rogue/candle/r
	pixel_y = 0
	pixel_x = 32
/obj/machinery/light/rogue/candle/l
	pixel_y = 0
	pixel_x = -32

/obj/machinery/light/rogue/candle/blue
	bulb_colour = "#7b60f3"
	icon_state = "wallcandleb1"
	base_state = "wallcandleb"
	desc = "细小的蓝色火焰轻轻闪烁，仿佛群星本身。"

/obj/machinery/light/rogue/candle/blue/r
	pixel_y = 0
	pixel_x = 32
/obj/machinery/light/rogue/candle/blue/l
	pixel_y = 0
	pixel_x = -32

//GREEN!
/obj/machinery/light/rogue/candle/green
	bulb_colour = "#60f382"
	icon_state = "wallcandleg1"
	base_state = "wallcandleg"
	desc = "细小的绿色火焰闪烁着非尘世的暖意。"

/obj/machinery/light/rogue/candle/green/r
	pixel_y = 0
	pixel_x = 32
/obj/machinery/light/rogue/candle/green/l
	pixel_y = 0
	pixel_x = -32

//RED!
/obj/machinery/light/rogue/candle/red
	bulb_colour = "#f02929"
	icon_state = "wallcandler1"
	base_state = "wallcandler"
	desc = "细小的红色火焰在黑暗中带着恶意闪烁。"

/obj/machinery/light/rogue/candle/red/r
	pixel_y = 0
	pixel_x = 32
/obj/machinery/light/rogue/candle/red/l
	pixel_y = 0
	pixel_x = -32


/obj/machinery/light/rogue/candle/weak
	light_power = 0.9
	light_outer_range =  4
/obj/machinery/light/rogue/candle/weak/l
	pixel_x = -32
	pixel_y = 0
/obj/machinery/light/rogue/candle/weak/r
	pixel_x = 32
	pixel_y = 0

/obj/machinery/light/rogue/candle/floorcandle
	name = "蜡烛"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "floorcandle1"
	base_state = "floorcandle"
	pixel_y = 0
	layer = TABLE_LAYER
	cookonme = FALSE

/obj/machinery/light/rogue/candle/floorcandle/OnCrafted(dirin)
	..() // Base candles offset via pixel x/y, which doesn't handle nicely with floor candles - this resets the offset, so they are placed next the the crafter.
	pixel_x = 0
	pixel_y = 0

/obj/machinery/light/rogue/candle/floorcandle/alt
	icon_state = "floorcandlee1"
	base_state = "floorcandlee"

/obj/machinery/light/rogue/candle/floorcandle/pink
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

/obj/machinery/light/rogue/candle/floorcandle/alt/pink
	color = "#f858b5ff"
	bulb_colour = "#ff13d8ff"

/obj/machinery/light/rogue/torchholder
	name = "壁式火把架"
	desc = "一个安装在墙上的装置，可将火把置于其上照亮周围，同时腾出双手从事其他工作。"
	icon_state = "torchwall1"
	var/torch_off_state = "torchwall0"
	base_state = "torchwall"
	density = FALSE
	light_outer_range = 5 //same as the held torch, if you put a torch into a sconce, it shouldn't magically become twice as bright, it's inconsistent.
	var/obj/item/flashlight/flare/torch/torchy
	fueluse = FALSE //we use the torch's fuel
	no_refuel = TRUE
	soundloop = null
	crossfire = FALSE
	plane = GAME_PLANE_UPPER
	cookonme = FALSE

/obj/machinery/light/rogue/torchholder/c
	pixel_y = 32

/obj/machinery/light/rogue/torchholder/r
	dir = WEST

/obj/machinery/light/rogue/torchholder/l
	dir = EAST

/obj/machinery/light/rogue/torchholder/fire_act(added, maxstacks)
	if(torchy)
		if(!on)
			if(torchy.fuel > 0)
				torchy.spark_act()
				playsound(src.loc, 'sound/items/firelight.ogg', 100)
				on = TRUE
				update()
				update_icon()
				if(soundloop)
					soundloop.start()
				addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))
				return TRUE

/obj/machinery/light/rogue/torchholder/Initialize(mapload)
	torchy = new /obj/item/flashlight/flare/torch(src)
	torchy.spark_act()
	torchy.weather_resistant = TRUE
	. = ..()

/obj/machinery/light/rogue/torchholder/OnCrafted(dirin, user)
	dirin = turn(dirin, 180)
	QDEL_NULL(torchy)
	on = FALSE
	set_light(0)
	pixel_x = 0
	pixel_y = 0
	if(dirin == SOUTH)
		pixel_y = 32
	update_icon()

	..(dirin, user)

/obj/machinery/light/rogue/torchholder/process()
	if(on)
		if(torchy)
			if(torchy.fuel <= 0)
				burn_out()
			if(!torchy.on)
				burn_out()
		else
			return PROCESS_KILL

/obj/machinery/light/rogue/torchholder/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(torchy)
		if(!istype(user) || !Adjacent(user) || !user.put_in_active_hand(torchy))
			torchy.weather_resistant = FALSE
			torchy.forceMove(loc)
		torchy = null
		on = FALSE
		set_light(0)
		update_icon()
		playsound(src.loc, 'sound/foley/torchfixturetake.ogg', 70)

/obj/machinery/light/rogue/torchholder/update_icon()
	if(torchy)
		if(on)
			icon_state = "[base_state]1"
		else
			icon_state = "[torch_off_state]"
	else
		icon_state = "[base_state]"

/obj/machinery/light/rogue/torchholder/burn_out()
	if(torchy && torchy.on)
		torchy.turn_off()
	..()

/obj/machinery/light/rogue/torchholder/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = W
		if(torchy)
			if(LR.on && !on)
				if(torchy.fuel <= 0)
					to_chat(user, "<span class='warning'>固定在上面的火把已经烧尽了。</span>")
					return
				else
					torchy.spark_act()
					user.visible_message("<span class='info'>[user]点燃了[src]。</span>")
					playsound(src.loc, 'sound/items/firelight.ogg', 100)
					on = TRUE
					update()
					update_icon()
					addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))
					return
			if(!LR.on && on)
				if(LR.fuel > 0)
					LR.spark_act()
					user.visible_message("<span class='info'>[user]点燃了[src]中的[LR]。</span>")
					user.update_inv_hands()
		else
			if(LR.on)
				if(!user.transferItemToLoc(LR, src))
					return
				torchy = LR
				torchy.weather_resistant = TRUE
				on = TRUE
				update()
				update_icon()
				addtimer(CALLBACK(src, PROC_REF(trigger_weather)), rand(5,20))
			else
				if(!user.transferItemToLoc(LR, src))
					return
				torchy = LR
				torchy.weather_resistant = TRUE
				update_icon()
			playsound(src.loc, 'sound/foley/torchfixtureput.ogg', 70)
		return
	. = ..()

/obj/machinery/light/rogue/chand
	name = "枝形吊灯"
	desc = "十余根纤细金属臂托举着一簇耀眼华美的蜡烛，并将其悬挂于天花板下。"
	icon_state = "chand1"
	base_state = "chand"
	icon = 'icons/roguetown/misc/tallwide.dmi'
	density = FALSE
	brightness = 10
	pixel_x = -10
	pixel_y = -10
	layer = 2.0
	fueluse = 0
	no_refuel = TRUE
	soundloop = null
	crossfire = FALSE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/machinery/light/rogue/chand/attack_hand(mob/user)
	if(isliving(user) && on)
		user.visible_message("<span class='warning'>[user]熄灭了[src]。</span>")
		burn_out()
		return TRUE //fires that are on always have this interaction with lmb unless its a torch
	. = ..()


/obj/machinery/light/rogue/hearth
	name = "炉灶"
	desc = "用石头精心砌成的炉灶，可将煎锅或炖锅稳稳地架在余烬之上。"
	icon_state = "hearth1"
	base_state = "hearth"
	density = TRUE
	anchored = TRUE
	climbable = TRUE
	climb_time = 3 SECONDS
	layer = TABLE_LAYER
	climb_offset = 14
	on = FALSE
	cookonme = TRUE
	soundloop = /datum/looping_sound/fireloop
	heat_level = 3
	var/obj/item/attachment = null
	var/obj/item/food = null
	var/mob/living/carbon/human/lastuser
	var/datum/looping_sound/boilloop/boilloop

/obj/machinery/light/rogue/hearth/Initialize(mapload)
	boilloop = new(src, FALSE)
	. = ..()

/obj/machinery/light/rogue/hearth/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	else
		return !density

/obj/machinery/light/rogue/hearth/examine(mob/user)
	. = ..()
	if(attachment)
		if(istype(attachment, /obj/item/cooking/pan))
			if(food)
				. += "上面有一个[attachment.name]，里面放着[food.name]。"
			else
				. += "上面有一个[attachment.name]。"
		else if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
			var/isboiling = attachment.reagents.chem_temp > MIN_STEW_TEMPERATURE
			if(isboiling)
				. += "上面有一个[attachment.name]，正在沸腾。" // This is common shorthand for the contents don't nitpick
			else
				. += "上面有一个[attachment.name]，没有沸腾。"
		. += span_notice("右键点击煽火，加快烹饪速度。")

/obj/machinery/light/rogue/hearth/attack_right(mob/user)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	while(do_after(user, 2 SECONDS / cooktime_divisor, target = src))
		to_chat(user, span_info("我煽了煽 [src]的火焰。")) // Until line combine is on by default gotta do this to avoid spam
		try_cook(cooktime_divisor)

/obj/machinery/light/rogue/hearth/attackby(obj/item/W, mob/living/user, params)
	lastuser = user // For processing food
	var/datum/skill/craft/cooking/cs = lastuser?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)

	if(!attachment)
		if(istype(W, /obj/item/cooking/pan) || istype(W, /obj/item/reagent_containers/glass/bucket/pot ) || istype(W, /obj/item/reagent_containers/glass/crucible))
			playsound(get_turf(user), 'sound/foley/dropsound/shovel_drop.ogg', 40, TRUE, -1)
			attachment = W
			user.doUnEquip(W)
			W.forceMove(src)
			update_icon()
			return
	else
		if(istype(attachment, /obj/item/reagent_containers/glass/crucible))
			var/obj/item/reagent_containers/glass/crucible/crucible = attachment
			if(crucible.hot)
				to_chat(user, span_warning("坩埚太烫了，无法放入锭！等它冷却下来。"))
				return

			if(istype(W, /obj/item/ingot/iron) || istype(W, /obj/item/ingot/steel))
				if(crucible.get_total_ingots() >= crucible.max_ingots)
					to_chat(user, span_warning("坩埚已满。"))
					return

				user.visible_message(span_info("[user]将一块锭放入坩埚中。"))
				if(do_after(user, 10, target = src))
					var/ingot_type = W.type
					if(crucible.add_ingot(ingot_type, user) > 0)
						qdel(W)
				return
		if(istype(W, /obj/item/reagent_containers/glass/bowl))
			to_chat(user, "<span class='notice'>先把锅从炉灶上拿开。</span>")
			return
		if(istype(attachment, /obj/item/cooking/pan))
			if(W.type in subtypesof(/obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/S = W
				if(istype(W, /obj/item/reagent_containers/food/snacks/egg)) // added
					if(W.icon_state != "rawegg")
						playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
						sleep(25) // to get egg crack before frying hiss
						W.icon_state = "rawegg" // added
				if(!food)
					S.forceMove(src)
					food = S
					update_icon()
					playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
					return
			if(W.type in subtypesof(/obj/item/seeds))
				var/obj/item/seeds/S = W
				if(!food)
					S.forceMove(src)
					food = S
					update_icon()
					playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
					return
// Stew + Deep Frying code - refactored!!
		else if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
			var/obj/item/reagent_containers/glass/bucket/pot = attachment
			if(istype(W, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/S = W
				if(S.fat_yield)
					if(pot.reagents.has_reagent(/datum/reagent/water))
						to_chat(user, span_warning("你不能在有水的锅里炼油！"))
						return
					if(do_after(user, 2 SECONDS / cooktime_divisor, target = src))
						user.visible_message(span_info("[user]在锅里融化[S]。"))
						qdel(S)
						pot.reagents.add_reagent(/datum/reagent/consumable/oil/tallow, S.fat_yield)
						return
				if(pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow) && S.deep_fried_type)
					if(!pot.reagents.has_reagent(/datum/reagent/consumable/oil/tallow, OIL_CONSUMED))
						to_chat(user, span_notice("油不够。"))
						return
					if(pot.reagents.has_reagent(/datum/reagent/water))
						to_chat(user, span_warning("你不能在有水的锅里油炸！"))
						return
					if(do_after(user, DEEP_FRY_TIME / cooktime_divisor, target = src))
						user.visible_message(span_info("[user]在锅里油炸了[S]。"))
						add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
						new S.deep_fried_type(src.loc)
						qdel(S)
						pot.reagents.remove_reagent(/datum/reagent/consumable/oil/tallow, OIL_CONSUMED)
						return
			for(var/datum/stew_recipe/R in GLOB.stew_recipes)
				for(var/I in R.inputs)
					if(istype(W, I))
						if(!pot.reagents.has_reagent(/datum/reagent/water, VOLUME_PER_STEW_COOK + VOLUME_PER_STEW_COOK_AFTER))
							to_chat(user, span_notice("水不够。"))
							return
						if(pot.reagents.chem_temp < MIN_STEW_TEMPERATURE)
							to_chat(user, span_notice("[pot]还没沸腾！"))
							return
						if(do_after(user, 2 SECONDS / cooktime_divisor, target = src))
							user.visible_message(span_info("[user]把[W]放入锅中。"))
							add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
							qdel(W)
							playsound(src.loc, 'sound/items/Fish_out.ogg', 20, TRUE)
							pot.reagents.remove_reagent(/datum/reagent/water, VOLUME_PER_STEW_COOK)
							sleep(R.cooktime / cooktime_divisor)
							playsound(src, "bubbles", 30, TRUE)
							pot.reagents.remove_reagent(/datum/reagent/water, VOLUME_PER_STEW_COOK_AFTER) // Remove water first prevent overfill
							pot.reagents.add_reagent(R.output, VOLUME_PER_STEW_COOK + VOLUME_PER_STEW_COOK_AFTER)
							return
	. = ..()

//////////////////////////////////

/obj/machinery/light/rogue/hearth/update_icon()
	cut_overlays()
	icon_state = "[base_state][on]"
	if(attachment)
		if(istype(attachment, /obj/item/cooking/pan) || istype(attachment, /obj/item/reagent_containers/glass/bucket/pot)  || istype(attachment, /obj/item/reagent_containers/glass/crucible))
			var/obj/item/I = attachment
			I.pixel_x = 0
			I.pixel_y = 0
			add_overlay(new /mutable_appearance(I))
			if(food)
				I = food
				I.pixel_x = 0
				I.pixel_y = 0
				add_overlay(new /mutable_appearance(I))

/obj/machinery/light/rogue/hearth/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(attachment)
		if(istype(attachment, /obj/item/cooking/pan))
			if(food)
				if(!user.put_in_active_hand(food))
					food.forceMove(user.loc)
				food = null
				update_icon()
			else
				if(!user.put_in_active_hand(attachment))
					attachment.forceMove(user.loc)
				attachment = null
				update_icon()
		if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot) || istype(attachment, /obj/item/reagent_containers/glass/crucible))
			if(!user.put_in_active_hand(attachment))
				attachment.forceMove(user.loc)
			attachment = null
			update_icon()
			boilloop.stop()
	else
		if(on)
			var/mob/living/carbon/human/H = user
			if(istype(H))
				H.visible_message("<span class='info'>[H]在火边暖手。</span>")

				if(do_after(H, 15, target = src) && H.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT - 75)
					H.adjust_bodytemperature(75)
			return TRUE //fires that are on always have this interaction with lmb unless its a torch

/obj/machinery/light/rogue/hearth/process()
	// Edge case is that this depends on the last person to put the pan on the hearth and not the last person to put the food on the pan
	var/datum/skill/craft/cooking/cs = lastuser?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)

	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()
	if(on)
		try_cook(cooktime_divisor)

/obj/machinery/light/rogue/hearth/proc/try_cook(cooktime_divisor)
	if(initial(fueluse) > 0)
		if(fueluse > 0)
			fueluse = max(fueluse - 10, 0)
		if(fueluse == 0)
			burn_out()
	if(attachment)
		if(istype(attachment, /obj/item/reagent_containers/glass/crucible))
			var/obj/item/reagent_containers/glass/crucible/crucible = attachment
			if(crucible.get_total_ingots() > 0 && on)
				crucible.heat_up(crucible.heat_rate)
			else if(!on)
				crucible.cool_down(crucible.cool_rate)
		if(istype(attachment, /obj/item/cooking/pan))
			if(food)
				var/obj/item/C = food.cooking(20 * cooktime_divisor, 20, src)
				if(C)
					qdel(food)
					food = C
		if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
			if(attachment.reagents)
				attachment.reagents.expose_temperature(400, 0.033)
				if(attachment.reagents.chem_temp > MIN_STEW_TEMPERATURE && !boilloop.loop_started)
					boilloop.start()
				else
					boilloop.stop()
	update_icon()

/obj/machinery/light/rogue/hearth/onkick(mob/user)
	if(isliving(user) && on)
		user.visible_message(span_info("[user]踢灭了[src]。"))
		burn_out()

/obj/machinery/light/rogue/hearth/Destroy()
	QDEL_NULL(boilloop)
	. = ..()

/obj/machinery/light/rogue/hearth/mobilestove // thanks to Reen and Ppooch for their help on this. If any of this is slopcode, its my slopcode, not theirs. They only made improvements.
	name = "便携炉灶"
	desc = "一台便携式青铜炉面。底部布满玄奥的小管纹路，加热炉面的东西隐藏在装置内部。"
	icon_state = "hobostove1"
	base_state = "hobostove"
	brightness = 4
	bulb_colour ="#4ac77e"
	density = FALSE
	anchored = TRUE
	climbable = FALSE
	climb_offset = FALSE
	layer = TABLE_LAYER
	on = FALSE
	no_refuel = TRUE
	status = LIGHT_BURNED
	crossfire = FALSE
	soundloop = /datum/looping_sound/blank  //datum path is a blank.ogg

/obj/machinery/light/rogue/hearth/mobilestove/MiddleClick(mob/user, params)
	. = ..()
	if(.)
		return

	if(attachment)
		if(istype(attachment, /obj/item/cooking/pan))
			if(!food)
				if(!user.put_in_active_hand(attachment))
					attachment.forceMove(user.loc)
				attachment = null
				update_icon()
				return
			if(!user.put_in_active_hand(food))
				food.forceMove(user.loc)
			food = null
			update_icon()
			return
		if(istype(attachment, /obj/item/reagent_containers/glass/bucket/pot))
			if(!user.put_in_active_hand(attachment))
				attachment.forceMove(user.loc)
			attachment = null
			update_icon()
			boilloop.stop()
	else
		if(!on)
			user.visible_message(span_notice("[user]开始收起[src]。"))
			if(!do_after(user, 2 SECONDS, TRUE, src))
				return
			var/obj/item/mobilestove/new_mobilestove = new /obj/item/mobilestove(get_turf(src))
			new_mobilestove.color = src.color
			qdel(src)
			return

		var/mob/living/carbon/human/H = user
		if(!istype(user))
			return
		H.visible_message(span_notice("[user]开始收起[src]。它还很烫！"))
		if(!do_after(H, 40, target = src))
			return
		var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		to_chat(H, span_warning("好烫！我把自己烫伤了！"))
		if(affecting && affecting.receive_damage( 0, 5 ))        // 5 burn damage
			H.update_damage_overlays()
		var/obj/item/mobilestove/new_mobilestove = new /obj/item/mobilestove(get_turf(src))
		new_mobilestove.color = src.color
		burn_out()
		qdel(src)
		return

/obj/item/mobilestove
	name = "收起的炉灶"
	desc = "一台便携式青铜炉面。底部布满玄奥的小管纹路，加热炉面的东西隐藏在装置内部。"
	icon = 'icons/roguetown/misc/lighting.dmi'
	icon_state = "hobostovep"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	grid_width = 32
	grid_height = 64

/obj/item/mobilestove/attack_self(mob/user, params)
	..()
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("我得把它放在地面上！"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure))
			to_chat(user, span_warning("这里需要留出一些空位才能展开[src]！"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("这里已经有东西了！</span>"))
			return
	user.visible_message(span_notice("[user]开始把[src]放到地上。"))
	if(do_after(user, 2 SECONDS, TRUE, src))
		var/obj/machinery/light/rogue/hearth/mobilestove/new_mobilestove = new /obj/machinery/light/rogue/hearth/mobilestove(get_turf(src))
		new_mobilestove.color = src.color
		qdel(src)

/obj/machinery/light/rogue/campfire
	name = "篝火"
	desc = "油腻的烟雾从微弱噼啪作响的火焰中卷起。"
	icon_state = "badfire1"
	base_state = "badfire"
	density = FALSE
	layer = 2.8
	brightness = 5
	on = FALSE
	fueluse = 15 MINUTES
	bulb_colour = "#da5e21"
	cookonme = TRUE
	max_integrity = 30
	soundloop = /datum/looping_sound/fireloop
	heat_level = 5
	var/healing_range = 1
	var/static/list/acceptable_beds = list(/obj/structure/bed, /obj/structure/flora/roguetree/stump, /obj/item/bedsheet)
	var/datum/status_effect/buff/stamina_status_effect = /datum/status_effect/buff/campfire_stamina

/obj/machinery/light/rogue/campfire/process()
	..()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()

	if(on)
		var/list/hearers_in_range = get_hearers_in_LOS(healing_range, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
		for(var/mob/living/carbon/human/human in hearers_in_range)
			var/distance = get_dist(src, human)
			if(distance > healing_range || human.construct)
				continue
			if(!human.has_status_effect(stamina_status_effect))
				to_chat(human, span_info("火焰的温暖安抚着我，让我得以短暂休息。若想休息得更好，我得躺到床上去。"))
			human.apply_status_effect(stamina_status_effect)
			human.add_stress(/datum/stressevent/campfire)
			if(human.resting && !human.cmode)
				var/valid_bed = FALSE
				var/turf/T = get_turf(human)
				for(var/obj/O in T.contents)
					for(var/path in acceptable_beds)
						if(ispath(O.type, path))
							valid_bed = TRUE
							break
					if(valid_bed)
						break
				if(valid_bed)
					if(!human.has_status_effect(/datum/status_effect/buff/campfire))
						to_chat(human, span_info("在火边安顿下来，仿佛卸下了一周的重担。"))
					human.apply_status_effect(/datum/status_effect/buff/campfire)

/obj/machinery/light/rogue/campfire/onkick(mob/user)
	if(isliving(user) && on)
		var/mob/living/L = user
		L.visible_message("<span class='info'>[L]熄灭了[src]。</span>")
		burn_out()

/obj/machinery/light/rogue/campfire/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(on)
		var/mob/living/carbon/human/H = user
		if(ishuman(H))
			H.visible_message("<span class='info'>[H]在火边暖了暖[user.p_their()]手。</span>")
			if(H.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT - 75)
				H.adjust_bodytemperature(75)
			var/first_go = TRUE
			while(do_after(H, 105, target = src) && on)
				// Astrata followers get enhanced fire healing
				var/buff_strength = 1
				if(H.patron?.type == /datum/patron/divine/astrata || H.patron?.type == /datum/patron/inhumen/matthios) //Fire and the fire-stealer
					buff_strength = 2
				H.apply_status_effect(/datum/status_effect/buff/healing/campfire, buff_strength)
				H.add_stress(/datum/stressevent/campfire)
				if(first_go)
					to_chat(H, span_good("火焰的温暖安抚着我，让我得以稍作休息。"))
					first_go = FALSE
		return TRUE //fires that are on always have this interaction with lmb unless its a torch

/obj/machinery/light/rogue/campfire/densefire
	icon_state = "densefire1"
	base_state = "densefire"
	desc = "一圈石头为火焰挡住了足够的风，让黑暗无法逼近，也让身体保持温暖。"
	density = TRUE
	layer = 2.8
	brightness = 5
	climbable = TRUE
	on = FALSE
	fueluse = 30 MINUTES
	pass_flags = LETPASSTHROW
	bulb_colour = "#eea96a"
	max_integrity = 60
	heat_level = 5

/obj/machinery/light/rogue/campfire/densefire/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	if(locate(/obj/machinery/light/rogue/firebowl) in get_turf(mover))
		return 1
	return !density


/obj/machinery/light/rogue/campfire/pyre
	name = "火刑柴堆"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "pyre1"
	base_state = "pyre"
	brightness = 10
	fueluse = 30 MINUTES
	layer = BELOW_MOB_LAYER
	buckleverb = "绑上火刑柱"
	can_buckle = 1
	buckle_lying = 0
	dir = NORTH
	buckle_requires_restraints = 1
	buckle_prevents_pull = 1
	heat_level = 5


/obj/machinery/light/rogue/campfire/pyre/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 10)
	M.setDir(SOUTH)

/obj/machinery/light/rogue/campfire/pyre/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/machinery/light/rogue/campfire/longlived
	fueluse = 180 MINUTES

#undef MIN_STEW_TEMPERATURE
#undef VOLUME_PER_STEW_COOK
#undef VOLUME_PER_STEW_COOK_AFTER

//Prestidigitation wisps are fun to decorate with!

/obj/effect/wisp
	name = "鬼火"
	desc = "一团由神秘能量构成的微小火焰光球。"
	light_outer_range =  4
	light_color = "#3FBAFD"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "wisp"

/obj/effect/wisp/infernal
	name = "地狱鬼火"
	desc = "潜伏于环境中的魔力所显现出的不祥化身。"
	light_color = "#ff0008"
	color = "#ff0008"

/obj/effect/wisp/geothermal
	name = "奇异鬼火"
	desc = "一种奇特的自然现象，似乎与下方翻涌的熔岩有关。"
	light_color = "#ff5630"
	color = "#ff5630"

/obj/effect/wisp/green
	light_color = "#ffff00"
	color = "#33ff00"

/obj/effect/wisp/bluegreen
	light_color = "#33ff00"
	color = "#59ff93"

/obj/effect/wisp/purple
	light_color = "#ae00ff"
	color = "#ff767d"
