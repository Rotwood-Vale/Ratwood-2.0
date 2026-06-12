
// Raw Shellfish. Separate folder due to sprites
/obj/item/reagent_containers/food/snacks/fish/crab
	name = "螃蟹"
	desc = "一种外壳硬得让人头疼的贝甲生物，不过拿黄油面片做成蟹饼后味道绝佳。"
	icon_state = "crab"
	sellprice = 10
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, "<span class='notice'>用黄油面皮把螃蟹包起来……</span>")
			if(do_after(user,short_cooktime, target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw(loc)
				qdel(I)
				qdel(src)
		return TRUE
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/clam
	name = "蛤蜊"
	desc = "阿比索尔仿照骑士造出的海中小兽。外壳坚硬，里面却软乎乎的。"
	icon_state = "clam"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/lobster
	name = "龙虾"
	desc = "一种壳硬得要命的笨东西，勉强算是能吃。"
	icon_state = "lobster"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "虾"
	desc = "一种小小的贝甲生物，比你的拇指大不了多少，常被戏称为“海中的蝴蝶”。"
	icon_state = "shrimp"
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster
	name = "牡蛎"
	desc = "这种顽固的贝甲生物体内也许藏着宝贝；用小刀撬开后，就能取出里面的肉。"
	icon_state = "oyster"
	sellprice = 5
	var/closed
	var/obj/item/pearl
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	trash = /obj/item/oystershell
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster/Initialize(mapload)
	. = ..()
	var/pearl_weight
	switch(name) //checks the rarity of the oyster via the name
		if("legendary oyster")
			pearl_weight = pickweight(list("bpearl" = 200, "pearl" =15, "nopearl"=15)) //specific weights should be modified due to balance later
		if("ultra-rare oyster")
			pearl_weight = pickweight(list("bpearl" = 60, "pearl" =120, "nopearl"=35))
		if("rare oyster")
			pearl_weight = pickweight(list("bpearl" = 40, "pearl" =80, "nopearl"=150))
		if("common oyster")
			pearl_weight = pickweight(list("bpearl" = 10, "pearl" =40, "nopearl"=200))
	switch(pearl_weight)
		if("nopearl")
			pearl = null
		if("pearl")
			pearl = new /obj/item/pearl(src)
		if("bpearl")
			pearl = new /obj/item/pearl/blue(src)
	closed = TRUE

/obj/item/reagent_containers/food/snacks/fish/oyster/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/huntingknife))
		if(closed)
			user.visible_message("<span class='notice'>[user]用小刀撬开了牡蛎。</span>")
			closed = FALSE
			icon_state = "[icon_state]_open"
			update_icon()
		else
			if(slice(src, user))
				new /obj/item/oystershell(user.loc)
				new /obj/item/oystershell(user.loc)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	else
		if(pearl)
			user.put_in_hands(pearl)
			pearl = null
			update_icon()
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/update_icon()
	cut_overlays()
	if(!closed && pearl)
		var/mutable_appearance/pearl = mutable_appearance(icon, "pearl")
		add_overlay(pearl)

/obj/item/oystershell
	name = "牡蛎壳"
	icon = 'modular/Neu_food/icons/raw/raw_fish.dmi'
	icon_state = "oyster_shell"
	desc = ""
	dropshrink = 0.5
	w_class = WEIGHT_CLASS_TINY
	sellprice = 3
	grid_height = 32
	grid_width = 32

/obj/item/reagent_containers/food/snacks/rogue/crabcake
	name = "蟹饼"
	desc = "一种手馅饼变体，内里填满黄油香浓的贝甲肉，用抹了黄油的面片制成。"
	icon_state = "crab_cake"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION + MEATSLAB_NUTRITION)
	tastes = list("酥脆黄油面皮与贝甲肉" = 1)
	rotprocess = null
	dropshrink = 0.8
