

/datum/controller/subsystem/ratworld
	name         = "Ratworld"
	init_order   = INIT_ORDER_DEFAULT // Run after most other things are ready
	flags        = SS_NO_FIRE // This subsystem doesn't need to be ticked.

/datum/controller/subsystem/ratworld/Initialize()
	initialize_rw_rarity_weights()
	return ..()
