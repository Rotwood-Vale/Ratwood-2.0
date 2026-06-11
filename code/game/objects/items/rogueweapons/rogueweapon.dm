

/obj/item/rogueweapon
	name = ""
	desc = ""
	icon_state = "sabre"
	item_state = "sabre"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	dam_icon = 'icons/effects/item_damage64.dmi'
	force = 15
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	block_chance = 0
	armor_penetration = 0
	sharpness = IS_SHARP
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST)
	can_parry = TRUE
	wlength = WLENGTH_NORMAL
	sellprice = 1
	parrysound = list('sound/combat/parry/parrygen.ogg')
	break_sound = 'sound/foley/breaksound.ogg'
	anvilrepair = /datum/skill/craft/weaponsmithing
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	blade_dulling = null
	max_integrity = 250
	integrity_failure = 0.2
	wdefense = 3
	wdefense_wbonus = 3 //Default is 3.
	experimental_onhip = TRUE
	experimental_onback = TRUE
	resistance_flags = FIRE_PROOF
	embedding = list(
		"embed_chance" = 20,
		"embedded_pain_multiplier" = 1,
		"embedded_fall_chance" = 0,
	)

	/// Icon for sheathing. Only null for weapons that are unsheathable.
	var/sheathe_icon = null

	/// Special datum holder
	var/datum/special_intent/special

/obj/item/rogueweapon/Initialize(mapload)
	. = ..()
	if(!destroy_message)
		destroy_message = span_warning("[src]碎裂了！")

	if(ispath(special))
		special = new special()

/obj/item/rogueweapon/ComponentInitialize()
	if(is_silver) // By default, silver weapons are supposed to be blesseable.
		AddComponent(\
			/datum/component/silverbless,\
			pre_blessed = BLESSING_NONE,\
			silver_type = SILVER_TENNITE,\
			added_force = 0,\
			added_blade_int = 0,\
			added_int = 25,\
			added_def = 2,\
		)

/obj/item/rogueweapon/get_examine_string(mob/user, thats = FALSE)
	return "[thats? "那是":""]<b>[get_examine_name(user)]</b> <font size = 1>[get_blade_dulling_text(src)]</font>"

/obj/item/rogueweapon/obj_break(damage_flag)
	..()
	if(force)
		force /= 5
	if(force_wielded)
		force_wielded /= 5
	update_force_dynamic()
	if(armor_penetration)
		armor_penetration /= 5
	if(wdefense)
		wdefense /= 2
	if(wdefense_wbonus)
		wdefense_wbonus = -3
	wdefense_dynamic = wdefense
	if(sharpness & IS_SHARP)
		sharpness = IS_BLUNT
	if(can_parry)
		can_parry = FALSE

/obj/item/rogueweapon/obj_fix()
	force = initial(force)
	force_wielded = initial(force_wielded)
	update_force_dynamic()
	armor_penetration = initial(armor_penetration)
	wdefense = initial(wdefense)
	wdefense_wbonus = initial(wdefense_wbonus)
	wdefense_dynamic = wdefense
	sharpness = initial(sharpness)
	can_parry = initial(can_parry)
	..()

/obj/item/rogueweapon/rmb_self(mob/user)
	if(length(alt_intents))
		if(altgripped)
			ungrip(user)
			return
		if(wielded)
			ungrip(user)
		altgrip(user)
		user.update_inv_hands()
	..()

/obj/item/shaft
	name = "调试柄杆"
	desc = "你本不该看到这个。"
	icon = 'icons/roguetown/misc/shafts.dmi'
	icon_state = "woodshaft"
	grid_height = 32
	grid_width = 32

/obj/item/shaft/wood
	name = "木柄杆"
	desc = "标准、可靠、易于制作。面对劈砍较脆弱，但很能承受钝击。"

/obj/item/shaft/reinforced
	name = "加固木柄杆"
	desc = "一根钉有铆钉并包着金属片的木杆。相当能扛劈砍，但会更怕刺击。"
	icon_state = "reinforcedshaft"

/obj/item/shaft/metal
	name = "金属柄杆"
	desc = "一根沉重的锻造柄杆。极难被砍断，但更容易被钝力砸弯。"
	icon_state = "metalshaft"

/obj/item/rogueweapon/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/shaft) && (blade_dulling != DULLING_SHAFT_GRAND && blade_dulling != DULLING_SHAFT_CONJURED) && (blade_dulling > DULLING_FLOOR))	//hacky
		user.visible_message(span_info("[user]开始更换[src]的柄杆……"))
		if(do_after(user, 50))
			user.visible_message(span_info("[user]用[W]替换了原本的柄杆。"))
			replace_shaft(W)
			playsound(user, 'sound/foley/Building-01.ogg', 100)
	. = ..()


/obj/item/rogueweapon/proc/replace_shaft(obj/item/shaft/S)
	var/new_shaft
	var/obj/item/shaft/replaced_shaft
	switch(S.type)
		if(/obj/item/shaft/wood)
			new_shaft = DULLING_SHAFT_WOOD
		if(/obj/item/shaft/reinforced)
			new_shaft = DULLING_SHAFT_REINFORCED
		if(/obj/item/shaft/metal)
			new_shaft = DULLING_SHAFT_METAL
	switch(blade_dulling)
		if(DULLING_SHAFT_WOOD)
			replaced_shaft = /obj/item/shaft/wood
		if(DULLING_SHAFT_REINFORCED)
			replaced_shaft = /obj/item/shaft/reinforced
		if(DULLING_SHAFT_METAL)
			replaced_shaft = /obj/item/shaft/metal
	blade_dulling = new_shaft
	qdel(S)
	new replaced_shaft(src.drop_location())
