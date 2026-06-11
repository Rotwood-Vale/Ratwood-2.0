#define CTYPE_GOLD "g"
#define CTYPE_SILV "s"
#define CTYPE_COPP "c"
#define CTYPE_ICOIN "i"
#define CTYPE_ANCIENT "a"
#define MAX_COIN_STACK_SIZE 20

/obj/item/roguecoin
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = ""
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.2
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 0
	static_price = TRUE
	simpleton_price = TRUE
	var/flip_cd
	var/heads_tails = TRUE
	var/last_merged_heads_tails = TRUE
	var/base_type //used for compares
	var/quantity = 1
	var/plural_name
	var/rigged_outcome = 0 //1 for heads, 2 for tails
	resistance_flags = FIRE_PROOF

/obj/item/roguecoin/Initialize(mapload, coin_amount)
	. = ..()
	if(coin_amount >= 1)
		set_quantity(floor(coin_amount))

/obj/item/roguecoin/getonmobprop(tag)
	. = ..()
	if(tag != "gen")
		return
	return list("shrink" = 0.10, "sx" = -6, "sy" = 6, "nx" = 6, "ny" = 7, "wx" = 0, "wy" = 5, "ex" = -1, "ey" = 7, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)

/obj/item/roguecoin/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
	..() 

/obj/item/roguecoin/Crossed(atom/movable/AM)
	. = ..()
	if(istype(AM, /obj/item/roguecoin) && isturf(loc)) // Only on floor
		merge(AM, null)
		return

/obj/item/roguecoin/get_real_price()
	return sellprice * quantity

/obj/item/roguecoin/proc/set_quantity(new_quantity)
	quantity = new_quantity
	update_icon()
	update_transform()

/obj/item/roguecoin/examine(mob/user)
	. = ..()
	if(quantity > 1)
		. += span_info("\Roman [quantity] 枚硬币。")

/obj/item/roguecoin/proc/merge(obj/item/roguecoin/G, mob/user)
	if(!G)
		return
	if(G.base_type != base_type)
		return

	var/amt_to_merge = min(G.quantity, MAX_COIN_STACK_SIZE - quantity)
	if(amt_to_merge <= 0)
		return
	set_quantity(quantity + amt_to_merge)
	last_merged_heads_tails = G.heads_tails

	G.set_quantity(G.quantity - amt_to_merge)
	rigged_outcome = 0
	G.rigged_outcome = 0
	if(user && G.quantity <= 0)
		user.doUnEquip(G)
		user.update_inv_hands()
	if(G.quantity <= 0)
		qdel(G)
	playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)

/obj/item/roguecoin/attack_right(mob/user)
	if(user.get_active_held_item())
		return ..()
	if(quantity == 1)
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			switch(alert(user, "你想把下一次掷硬币操纵成什么结果？","XYLIX","正面","反面","公平游戏"))
				if("正面")
					rigged_outcome = 1
				if("反面")
					rigged_outcome = 2
				if("公平游戏")
					rigged_outcome = 0
		return
	var/obj/item/roguecoin/new_coin = new type()
	new_coin.set_quantity(1)
	set_quantity(quantity - 1)
	new_coin.heads_tails = last_merged_heads_tails
	user.put_in_hands(new_coin)
	playsound(loc, 'sound/foley/coinphy (2).ogg', 100, TRUE, -2)

/obj/item/roguecoin/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src && quantity > 1)
		var/amt_text = "（1 到 [quantity]）"
		if(quantity == 1)
			amt_text = ""
		var/amount = input(user, "要分出多少[plural_name]？[amt_text]", null, round(quantity/2, 1)) as null|num
		if(QDELETED(user) || QDELETED(src) || !user.Adjacent(src)) // if coins were consumed/user was deleted/moved away, don't split
			return
		amount = clamp(amount, 0, quantity)
		amount = round(amount, 1) // no taking non-integer coins
		if(!amount)
			return
		if(amount >= quantity)
			return ..()
		var/obj/item/roguecoin/new_coins = new type()
		new_coins.set_quantity(amount)
		new_coins.heads_tails = last_merged_heads_tails
		set_quantity(quantity - amount)

		user.put_in_hands(new_coins)
		playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
		return
	..()


/obj/item/roguecoin/attack_self(mob/living/user)
	if(quantity > 1 || !base_type)
		return
	if(world.time < flip_cd + 30)
		return
	flip_cd = world.time
	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)
	if(prob(50))
		user.visible_message(span_info("[user]抛起硬币。正面！"))
		heads_tails = TRUE
	else
		user.visible_message(span_info("[user]抛起硬币。反面！"))
		heads_tails = FALSE
	update_icon()


/obj/item/roguecoin/inqcoin/attack_self(mob/living/user)
	if(quantity > 1 || !base_type)
		return
	if(world.time < flip_cd + 30)
		return
	flip_cd = world.time
	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)	
	if(prob(50))
		user.visible_message(span_info("[user]抛起硬币。ENDVRE！"))
		heads_tails = TRUE
	else
		user.visible_message(span_info("[user]抛起硬币。LYVE！"))
		heads_tails = FALSE
	update_icon()

/obj/item/roguecoin/update_icon()
	..()
	if(quantity > 1)
		drop_sound = 'sound/foley/coins1.ogg'
	else
		drop_sound = 'sound/foley/coinphy (1).ogg'

	if(quantity == 1)
		name = initial(name)
		desc = initial(desc)
		icon_state = "[base_type][heads_tails]"
		dropshrink = 0.2
		slot_flags = ITEM_SLOT_MOUTH
		return

	name = plural_name
	desc = ""
	dropshrink = 1
	slot_flags = null
	switch(quantity)
		if(2)
			dropshrink = 0.2 // this is just like the single coin, gotta shrink it
			icon_state = "[base_type]m"
			if(heads_tails == last_merged_heads_tails)
				icon_state = "[base_type][heads_tails]1"
		if(3)
			icon_state = "[base_type]2"
		if(4 to 5)
			icon_state = "[base_type]3"
		if(6 to 10)
			icon_state = "[base_type]5"
		if(11 to 15)
			icon_state = "[base_type]10"
		if(16 to INFINITY)
			icon_state = "[base_type]15"


/obj/item/roguecoin/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/G = I
		if(item_flags & IN_STORAGE)
			merge(G, user)
		else
			G.merge(src, user)
		return
	return ..()

//OTAVAN MARQUE - WORTHLESS TO ANYONE BUT INQ.
/obj/item/roguecoin/inqcoin
	name = "奥塔凡马克"
	desc = "一枚受祝福的银币，表面覆有独特的黑色染层，铸着后王国时代的灵十字。金斯菲尔德在被问及时否认此币存在，因此传闻这类钱币仅供奥塔凡宗教裁判所内部使用。"
	icon_state = "i1"
	sellprice = 0
	base_type = CTYPE_ICOIN
	plural_name = "奥塔凡马克"	

//GOLD
/obj/item/roguecoin/gold
	name = "泽纳"
	desc = "一枚金币，上有金牛座与前王国万神殿十字架的符号。这些是省立金铸局中品相最好的，其余的都被熔掉了。"
	icon_state = "g1"
	sellprice = 10
	base_type = CTYPE_GOLD
	plural_name = "泽纳里"


// SILVER
/obj/item/roguecoin/silver
	name = "兹利夸"
	desc = "一种仍在使用的古银币，因其历经岁月而不朽的卓越品质得以流传。"
	icon_state = "s1"
	sellprice = 5
	base_type = CTYPE_SILV
	plural_name = "兹利夸伊"

// COPPER
/obj/item/roguecoin/copper
	name = "泽尼"
	desc = "一枚崭新的铜币，由首都铸造，意在摆脱对银的财政依赖。"
	icon_state = "c1"
	sellprice = 1
	base_type = CTYPE_COPP
	plural_name = "泽尼斯"

// ANCIENT
/obj/item/roguecoin/gilbranze
	name = "普西伦"
	desc = "一枚以抛光吉布兰泽铸成的硬币，属于一个未能熬过时光流转而覆灭的王国。"
	icon_state = "a1"
	sellprice = 3 //Dungeon-specific coinage - valued by historians, collectors, and smelters. 
	base_type = CTYPE_ANCIENT
	plural_name = "普西拉"

/obj/item/roguecoin/inqcoin/pile/Initialize(mapload)
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/gilbranze/pile/Initialize(mapload)
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/copper/pile/Initialize(mapload)
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/silver/pile/Initialize(mapload)
	. = ..()
	set_quantity(rand(4,19))


/obj/item/roguecoin/silver/pile/readyuppile/Initialize(mapload)
	. = ..()
	set_quantity(4) // 20 mammons combine with starting pouch to buy something

/obj/item/roguecoin/gold/pile/Initialize(mapload)
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/gold/virtuepile/Initialize(mapload)
	. = ..()
	set_quantity(rand(8,12))

#undef CTYPE_GOLD
#undef CTYPE_SILV
#undef CTYPE_COPP
#undef CTYPE_ANCIENT
#undef CTYPE_ICOIN
#undef MAX_COIN_STACK_SIZE
