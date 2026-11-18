
/obj/effect/proc_holder/spell/self/claws/dragon
	name = "Dragon claws"
	claw_type = /obj/item/rogueweapon/werewolf_claw/dragon

/obj/effect/proc_holder/spell/self/dragon_gate_control
	name = "Lair gate"
	desc = "Remotely opens or closes the gate to your lair."
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/dragon_gate_control/cast(mob/living/user)
	log_game("[key_name(user)] magically pulled the dragon gate lever.")
	var/obj/structure/lever/wall/dragon_gate_control/linked_lever = locate("pdragonexit")
	if(linked_lever && istype(linked_lever))
		linked_lever.magic_flip()

/obj/structure/lever/wall/dragon_gate_control
	redstone_id = "pdragonexit"
	max_integrity = 999999

/obj/structure/lever/wall/dragon_gate_control/proc/magic_flip()
	for(var/obj/structure/O in redstone_attached)
		addtimer(CALLBACK(O, TYPE_PROC_REF(/obj/structure, redstone_triggered)), 0)
	toggled = !toggled
	icon_state = "leverwall[toggled]"
	playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)
