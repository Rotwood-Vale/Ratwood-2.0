/obj/item/roguegear
	icon = 'icons/roguetown/items/misc.dmi'
	name = "示例齿轮"
	desc = "你本不该看到这个。"
	icon_state = "gear"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = null
	var/obj/structure/linking
	grid_width = 64
	grid_height = 32

/* linking now done by wrenches
/obj/item/roguegear/Destroy()
	if(linking)
		linking = null
	. = ..()

/obj/item/roguegear/attack_self(mob/user)
	if(linking)
		linking = null
		to_chat(user, span_warning("链接已中止。"))
		return

/obj/item/roguegear/attack_obj(obj/O, mob/living/user)
	if(!istype(O, /obj/structure))
		return ..()
	var/obj/structure/S = O
	if(linking)
		if(linking == O)
			to_chat(user, span_warning("你不能把我和我自己连接起来。"))
			return
		if(linking in S.redstone_attached)
			to_chat(user, span_warning("已经连接过了。"))
			linking = null
			return
		S.redstone_attached |= linking
		linking.redstone_attached |= S
		linking = null
		to_chat(user, span_notice("连接完成。"))
		return
	linking = S
	to_chat(user, span_info("开始连接……"))
*/


/obj/item/roguegear/bronze
	name = "齿轮"
	desc = "一枚齿牙打磨精细、用于严密咬合的齿轮。"
	smeltresult = /obj/item/ingot/bronze

/obj/item/roguegear/wood
	var/cart_capacity = 0
	var/misfire_modification
	var/name_prefix
	var/ulevel = 0

/obj/item/roguegear/wood/basic
	name = "木制齿轮"
	desc = "一种非常简单的齿轮，能提升木车的载货能力。"
	icon_state = "wcog"
	metalizer_result = /obj/item/roguegear/bronze
	cart_capacity = 90

/obj/item/roguegear/wood/reliable
	name = "可靠木制齿轮"
	desc = "灌注了特殊精华的齿轮，因而格外可靠。可用于车具和机械。"
	icon_state = "wcog2"
	cart_capacity = 120
	misfire_modification = 7
	name_prefix = "stable"
	ulevel = 1

/obj/item/roguegear/wood/reliable/Initialize(mapload)
	.=..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(32, 196, 218, 200))

/obj/item/roguegear/wood/unstable
	name = "不稳定木制齿轮"
	desc = "灌注了特殊精华的齿轮，因此随时都可能损坏。可用于车具和机械。"
	icon_state = "wcog2"
	cart_capacity = 140
	misfire_modification = 100
	ulevel = 2
/obj/item/roguegear/wood/unstable/Initialize(mapload)
	.=..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(167, 17, 17, 200))
