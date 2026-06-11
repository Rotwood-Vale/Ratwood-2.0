/obj/structure/dock_bell
	name = "码头钟"
	desc = "一口声音能传到附近港口的大钟。它向商人传达我们正在寻求交易。"


	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "dock_bell"


	COOLDOWN_DECLARE(ring_bell)


/obj/structure/dock_bell/attack_hand(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, ring_bell))
		to_chat(user, span_notice("我得再等等……"))
		return
	if(!do_after(user, 5 SECONDS, target = src))
		return
	if(!COOLDOWN_FINISHED(src, ring_bell))
		to_chat(user, span_notice("有人抢先一步敲响了它！"))
		return
	visible_message(span_notice("[user]开始敲响码头钟。"))
	playsound(get_turf(src), 'sound/misc/handbell.ogg', 50, 1)
	if(!SSmerchant.cargo_docked && SSmerchant.cargo_boat.check_living())
		SSmerchant.send_cargo_ship_back()
	else if(SSmerchant.cargo_docked)
		SSmerchant.prepare_cargo_shipment()
	COOLDOWN_START(src, ring_bell, 2 MINUTES)
