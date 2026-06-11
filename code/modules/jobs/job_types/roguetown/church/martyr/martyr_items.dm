/obj/item/rogueweapon/sword/long/martyr
	force = 30
	force_wielded = 36
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike,  /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust,  /datum/intent/sword/peel, /datum/intent/sword/chop)
	icon_state = "martyrsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	item_state = "martyrsword"
	lefthand_file = 'icons/mob/inhands/weapons/roguemartyr_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguemartyr_righthand.dmi'
	name = "殉道之剑"
	desc = "一件出自圣座金库的圣遗物。其上翻涌着神性能量，只会向立下誓约之人屈服。"
	max_blade_int = 200
	max_integrity = 300
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	bigboy = 1
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	associated_skill = /datum/skill/combat/swords
	throwforce = 15
	thrown_bclass = BCLASS_CUT
	dropshrink = 1
	smeltresult = /obj/item/ingot/gold
	is_silver = TRUE
	toggle_state = null
	is_important = TRUE

/obj/item/rogueweapon/sword/long/martyr/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/datum/intent/sword/cut/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CUT
/datum/intent/sword/thrust/martyr
		item_d_type = "fire"
		blade_class = BCLASS_PICK // so our armor-piercing attacks in ult mode can do crits(against most armors, not having crit)
/datum/intent/sword/strike/martyr
		item_d_type = "fire"
		blade_class = BCLASS_SMASH
/datum/intent/sword/chop/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CHOP

/obj/item/rogueweapon/sword/long/martyr/Initialize(mapload)
	AddComponent(/datum/component/martyrweapon)
	..()

/obj/item/rogueweapon/sword/long/martyr/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/job/J = SSjob.GetJob(H.mind?.assigned_role)
		if(J.title == "Bishop" || J.title == "Martyr")
			return ..()
		else if (H.job in GLOB.church_positions)
			to_chat(user, span_warning("你只感到一瞬圣能电流掠过全身，随后剑便从掌中滑脱！你的虔诚还不够。"))
			return FALSE
		else if(istype(H.patron, /datum/patron/inhumen))
			var/datum/component/martyrweapon/marty = GetComponent(/datum/component/martyrweapon)
			to_chat(user, span_warning("蠢货！此物于你而言乃是绝罚！快离开！"))
			H.Stun(40)
			H.Knockdown(40)
			if(marty.is_active) //Inhumens are touching this while it's active, very fucking stupid of them
				visible_message(span_warning("[H] 被长剑反噬，发出痛苦的尖叫！"))
				H.emote("agony")
				H.adjust_fire_stacks(5)
				H.ignite_mob()
			return FALSE
		else	//Everyone else
			to_chat(user, span_warning("一阵痛苦的冲击贯穿全身，将你掀倒在地。你碰不得这东西。"))
			H.emote("groan", forced = TRUE)
			H.Stun(10)
			return FALSE
	else
		return FALSE

/obj/item/rogueweapon/sword/long/martyr/Destroy()
	var/datum/component/martyr = GetComponent(/datum/component/martyrweapon)
	if(martyr)
		martyr.ClearFromParent()
	return ..()

/obj/item/rogueweapon/sword/long/martyr/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback") return list("shrink" = 0.6,"sx" = -2,"sy" = 3,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 90,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded") return list("shrink" = 0.7,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt") return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 0,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = -3,"ey" = -5,"nturn" = 180,"sturn" = 180,"wturn" = 0,"eturn" = 90,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/cloak/martyr
	name = "殉道披风"
	desc = "一件采用 阿斯特拉塔 配色的优雅披风，看起来只适合人类体型的人穿着。"
	color = null
	icon_state = "martyrcloak"
	item_state = "martyrcloak"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	body_parts_covered = CHEST|GROIN
	boobed = FALSE
	sellprice = 100
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/armor/plate/full/holysee
	name = "圣银板甲"
	desc = "为守卫与战士打造的镀银板甲，乃十神枪盾之军所披戴。"
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	icon_state = "silverarmor"
	item_state = "silverarmor"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "silverarmor"
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	armor = ARMOR_PLATE
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 4

/obj/item/clothing/under/roguetown/platelegs/holysee
	name = "圣银护腿"
	desc = "为圣座军势锻造的银制板甲护腿，如银潮般压向邪恶。"
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "silverlegs"
	icon_state = "silverlegs"
	item_state = "silverlegs"
	armor = ARMOR_PLATE
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/holysee
	name = "圣银尖盔"
	desc = "这些头盔烙有圣座印记，由其钦选战士佩戴，是黑夜中希望的堡垒。"
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyrbascinet.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	adjustable = CAN_CADJUST
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	worn_x_dimension = 64
	worn_y_dimension = 64
	icon_state = "silverbascinet"
	item_state = "silverbascinet"
	sellprice = 1000
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/holysee/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/cloak/holysee
	name = "圣银法衣"
	desc = "一套由圣座军势穿着的法衣，银线刺绣与光辉封印使其成为抵御邪恶的堡垒。"
	icon = 'icons/roguetown/clothing/special/martyr.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/martyr.dmi'
	icon_state = "silvertabard"
	item_state = "silvertabard"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "silvertabard"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB
	var/overarmor = TRUE
	sellprice = 300

/obj/item/clothing/cloak/holysee/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/holysee/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/cloak/holysee/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("[overarmor ? "我将罩袍披在护甲外" : "我将罩袍穿在护甲内"]。"))
	if(overarmor)
		alternate_worn_layer = TABARD_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_cloak()
	user.update_inv_armor()
