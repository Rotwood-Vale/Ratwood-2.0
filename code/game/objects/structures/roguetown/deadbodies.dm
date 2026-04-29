/obj/structure/deadbody
	name = "dead body"
	desc = "Someone's final resting place."
	icon = 'icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	var/looted = FALSE
	var/list/loot_table
	var/list/loot_table_lucky
	var/list/pose_states
	///If set, always uses this icon_state instead of picking from pose_states.
	var/forced_pose

/obj/structure/deadbody/Initialize(mapload)
	. = ..()
	if(forced_pose)
		icon_state = forced_pose
	else if(pose_states)
		icon_state = pick(pose_states)

/obj/structure/deadbody/attack_hand(mob/living/user)
	if(looted)
		to_chat(user, span_warning("There's nothing left worth taking."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	user.visible_message(span_notice("[user] begins searching the body."), span_notice("You begin searching the body."))
	if(!do_after(user, 5 SECONDS, needhand = TRUE, target = src))
		return
	playsound(src, pick('sound/foley/equip/rummaging-01.ogg', 'sound/foley/equip/rummaging-02.ogg', 'sound/foley/equip/rummaging-03.ogg'), 50, FALSE)
	if(user.STALUC < 10 && prob(40))
		to_chat(user, span_warning("You come up empty. Nothing but dust and bad luck."))
		looted = TRUE
		user.visible_message(span_notice("[user] finishes searching [src]."), span_notice("You finish searching [src]."))
		return
	var/items_found = 1
	if(user.STALUC >= 16)
		items_found = 3
	else if(user.STALUC >= 13)
		items_found = 2
	var/lucky = (user.STALUC >= 14 && loot_table_lucky)
	var/list/active_table = lucky ? loot_table_lucky : loot_table
	for(var/i in 1 to items_found)
		var/item_type = pickweight(active_table)
		var/obj/item/found = new item_type(user.loc)
		user.put_in_hands(found)
		if(lucky)
			to_chat(user, span_notice("A lucky find! You pull out [found]."))
		else
			to_chat(user, span_notice("You pull out [found]."))
	looted = TRUE
	user.visible_message(span_notice("[user] finishes searching [src]."), span_notice("You finish searching [src]."))

// ---- SUBTYPES ----

/obj/structure/deadbody/generic
	name = "dead wanderer"
	desc = "A poor soul who ran out of road."
	pose_states = list(
		"generic_male", "gm10", "gm20", "gm30", "gm40",
		"generic_female", "gf10", "gf20", "gf30", "gf40",
	)
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor         = 60,
		/obj/item/storage/belt/rogue/pouch/coins/mid          = 10,
		/obj/item/reagent_containers/food/snacks/rogue/bread  = 30,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread = 15,
		/obj/item/flashlight/flare/torch                      = 25,
		/obj/item/flint                                       = 20,
		/obj/item/natural/bone                                = 5,
	)

/obj/structure/deadbody/adventurer_leather
	name = "dead adventurer"
	desc = "Came looking for glory. You suppose they found it - with Necra."
	pose_states = list("adventurer_leather", "adl10", "adl20", "adl30", "adl40")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 30,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 25,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 5,
		/obj/item/rogueweapon/huntingknife/idagger                        = 20,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 15,
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass           = 10,
		/obj/item/clothing/suit/roguetown/armor/leather/studded           = 8,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 20,
		/obj/item/flashlight/flare/torch                                  = 15,
		/obj/item/flint                                                   = 10,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 30,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 15,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 25,
		/obj/item/rogueweapon/huntingknife/idagger/navaja                 = 10,
		/obj/item/clothing/suit/roguetown/armor/leather/studded           = 15,
		/obj/item/clothing/suit/roguetown/armor/chainmail                 = 10,
		/obj/item/clothing/head/roguetown/helmet/kettle                   = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 20,
	)

/obj/structure/deadbody/adventurer_steel
	name = "dead adventurer"
	desc = "Better equipped than most. Clearly wasn't enough."
	pose_states = list(
		"adventurer_steel", "ad10", "ad20", "ad30", "ad40",
		"adv_steel_skele", "advsk10", "advsk20", "advsk30", "advsk40",
	)
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 30,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 15,
		/obj/item/rogueweapon/sword                                       = 10,
		/obj/item/rogueweapon/sword/long                                  = 5,
		/obj/item/rogueweapon/mace                                        = 10,
		/obj/item/rogueweapon/mace/steel                                  = 4,
		/obj/item/clothing/suit/roguetown/armor/chainmail                 = 8,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk         = 5,
		/obj/item/clothing/suit/roguetown/armor/plate/half                = 3,
		/obj/item/clothing/head/roguetown/helmet/kettle                   = 10,
		/obj/item/clothing/head/roguetown/helmet/bascinet                 = 5,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 20,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 30,
		/obj/item/rogueweapon/sword/long                                  = 20,
		/obj/item/rogueweapon/mace/steel                                  = 15,
		/obj/item/rogueweapon/estoc                                       = 8,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk         = 15,
		/obj/item/clothing/suit/roguetown/armor/plate/half                = 10,
		/obj/item/clothing/head/roguetown/helmet/bascinet                 = 15,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
	)

/obj/structure/deadbody/maa
	name = "dead man at arms"
	desc = "Died in the line of duty."
	pose_states = list("guard_tabbard", "g10", "g20", "g30", "g40")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 35,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 10,
		/obj/item/rogueweapon/sword                                       = 12,
		/obj/item/rogueweapon/sword/long                                  = 5,
		/obj/item/rogueweapon/mace                                        = 12,
		/obj/item/rogueweapon/mace/steel                                  = 5,
		/obj/item/clothing/cloak/stabard/guard                            = 10,
		/obj/item/clothing/cloak/stabard/surcoat/guard                    = 6,
		/obj/item/clothing/cloak/stabard/guardhood                        = 6,
		/obj/item/clothing/suit/roguetown/armor/chainmail                 = 10,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk         = 6,
		/obj/item/clothing/head/roguetown/helmet/kettle                   = 10,
		/obj/item/clothing/head/roguetown/helmet/sallet                   = 5,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
		/obj/item/flashlight/flare/torch                                  = 10,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 30,
		/obj/item/rogueweapon/sword/long                                  = 20,
		/obj/item/rogueweapon/mace/steel                                  = 15,
		/obj/item/clothing/cloak/stabard/surcoat/guard                    = 20,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk         = 20,
		/obj/item/clothing/head/roguetown/helmet/sallet                   = 20,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
	)

/obj/structure/deadbody/warden
	name = "dead warden"
	desc = "Died doing what they swore to do - holding the line between Rockhill and the terrorbog."
	pose_states = list(
		"warden", "wa10", "wa20", "wa30", "wa40",
		"warden_skele", "wsk10", "wsk20", "wsk30", "wsk40",
	)
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 25,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 8,
		/obj/item/rogueweapon/spear                                       = 12,
		/obj/item/rogueweapon/halberd                                     = 5,
		/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick                 = 10,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 10,
		/obj/item/quiver/arrows                                           = 12,
		/obj/item/clothing/cloak/wardencloak                              = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden    = 6,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy             = 10,
		/obj/item/clothing/suit/roguetown/armor/chainmail                 = 6,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden           = 5,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf      = 3,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat      = 3,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear      = 3,
		/obj/item/clothing/head/roguetown/roguehood/warden               = 5,
		/obj/item/clothing/head/roguetown/roguehood/warden/antler        = 3,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
		/obj/item/flashlight/flare/torch                                  = 15,
		/obj/item/flint                                                   = 10,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 20,
		/obj/item/rogueweapon/halberd                                     = 20,
		/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick                 = 15,
		/obj/item/clothing/cloak/wardencloak                              = 15,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/warden    = 15,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf      = 10,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat      = 10,
		/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear      = 10,
		/obj/item/clothing/head/roguetown/roguehood/warden/antler        = 8,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
	)

/obj/structure/deadbody/wizard
	name = "dead mage"
	desc = "All that knowledge, gone."
	pose_states = list(
		"wizard", "wiz10", "wiz20", "wiz30", "wiz40",
		"wizard_old", "wiza10", "wiza20", "wiza30", "wiza40",
	)
	loot_table = list(
		/obj/item/book/granter/spell/blackstone/fetch                     = 15,
		/obj/item/book/granter/spell/blackstone/fireball                  = 10,
		/obj/item/book/granter/spell/blackstone/lightning                 = 8,
		/obj/item/book/granter/spell/blackstone/bonechill                 = 8,
		/obj/item/book/granter/spell/blackstone/frostbolt                 = 8,
		/obj/item/book/granter/spell/blackstone/featherfall               = 6,
		/obj/item/book/granter/spell/blackstone/forcewall_weak            = 6,
		/obj/item/book/granter/spell/blackstone/invisibility              = 5,
		/obj/item/book/granter/spell/blackstone/greaterfireball           = 3,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 20,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
	)
	loot_table_lucky = list(
		/obj/item/book/granter/spell/blackstone/greaterfireball           = 20,
		/obj/item/book/granter/spell/blackstone/invisibility              = 15,
		/obj/item/book/granter/spell/blackstone/lightning                 = 15,
		/obj/item/book/granter/spell/blackstone/enlarge                   = 10,
		/obj/item/book/granter/spell/blackstone/familiar                  = 8,
		/obj/item/book/granter/spell/blackstone/fortitude                 = 10,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 15,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 10,
	)

/obj/structure/deadbody/necromancer
	name = "dead necromancer"
	desc = "Cheated death once. Couldn't manage twice."
	pose_states = list(
		"necromancer", "nec10", "nec20", "nec30", "nec40",
		"necromancer_old", "necro10", "necro20", "necro30", "necro40",
	)
	loot_table = list(
		/obj/item/book/granter/spell/blackstone/skeleton                  = 15,
		/obj/item/book/granter/spell/blackstone/sicknessray               = 12,
		/obj/item/book/granter/spell/blackstone/bonechill                 = 10,
		/obj/item/book/granter/spell/blackstone/fetch                     = 8,
		/obj/item/book/granter/spell/blackstone/invisibility              = 6,
		/obj/item/natural/bone                                            = 20,
		/obj/item/skull                                                   = 10,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 15,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 10,
	)
	loot_table_lucky = list(
		/obj/item/book/granter/spell/blackstone/skeleton                  = 20,
		/obj/item/book/granter/spell/blackstone/sicknessray               = 15,
		/obj/item/book/granter/spell/blackstone/invisibility              = 15,
		/obj/item/book/granter/spell/blackstone/bonechill                 = 10,
		/obj/item/book/granter/spell/blackstone/familiar                  = 8,
		/obj/item/skull                                                   = 20,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 15,
	)

/obj/structure/deadbody/skeleton
	name = "old bones"
	desc = "What little remains of someone."
	pose_states = list("skeletons", "ske10", "ske20", "ske30", "ske40")
	loot_table = list(
		/obj/item/natural/bone                                            = 40,
		/obj/item/skull                                                   = 15,
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 25,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 8,
		/obj/item/rogueweapon/huntingknife/idagger                        = 10,
		/obj/item/flint                                                   = 10,
		/obj/item/clothing/head/roguetown/helmet/kettle                   = 5,
	)

/obj/structure/deadbody/greater_skeleton
	name = "dead legionnaire"
	desc = "One of Zizo's many warriors. They probably died before, during or after Her reign."
	pose_states = list(
		"gsk10", "gsk20", "gsk30", "gsk40", "gsk50",
		"gske10", "gske20", "gske30", "gske40", "gske50",
	)
	loot_table = list(
		/obj/item/natural/bone                                            = 25,
		/obj/item/skull                                                   = 15,
		/obj/item/rogueweapon/sword/short/pashortsword                   = 15,
		/obj/item/rogueweapon/sword/short/gladius/pagladius               = 10,
		/obj/item/rogueweapon/spear/paalloy                               = 10,
		/obj/item/rogueweapon/halberd/bardiche/paalloy                    = 6,
		/obj/item/rogueweapon/greatsword/paalloy                          = 4,
		/obj/item/rogueweapon/flail/sflail/paflail                        = 6,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy = 10,
		/obj/item/clothing/under/roguetown/platelegs/paalloy              = 8,
		/obj/item/clothing/wrists/roguetown/bracers/paalloy               = 8,
		/obj/item/clothing/neck/roguetown/chaincoif/paalloy               = 8,
	)
	loot_table_lucky = list(
		/obj/item/rogueweapon/greatsword/paalloy                          = 20,
		/obj/item/rogueweapon/halberd/bardiche/paalloy                    = 18,
		/obj/item/rogueweapon/spear/paalloy                               = 15,
		/obj/item/rogueweapon/flail/sflail/paflail                        = 12,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy = 20,
		/obj/item/clothing/under/roguetown/platelegs/paalloy              = 15,
		/obj/item/clothing/wrists/roguetown/bracers/paalloy               = 15,
		/obj/item/clothing/neck/roguetown/chaincoif/paalloy               = 15,
	)

/obj/structure/deadbody/rogue
	name = "dead rogue"
	desc = "Died with their secrets and cunning. More so secrets, less cunning."
	pose_states = list("rog10", "rog20", "rog30", "rog40", "rog50")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 25,
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 15,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 10,
		/obj/item/rogueweapon/huntingknife/idagger                        = 20,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 15,
		/obj/item/rogueweapon/huntingknife/idagger/navaja                 = 8,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel            = 10,
		/obj/item/lockpick                                                = 12,
		/obj/item/clothing/suit/roguetown/armor/leather/cuirass           = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/studded           = 6,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
		/obj/item/roguestatue/glass                                       = 8,
		/obj/item/roguestatue/gold                                        = 4,
		/obj/item/roguestatue/silver                                      = 6,
		/obj/item/candle/candlestick/gold                                 = 6,
		/obj/item/candle/candlestick/silver                               = 8,
		/obj/item/candle/candlestick/gold/single                          = 5,
		/obj/item/candle/candlestick/silver/single                        = 6,
		/obj/item/clothing/ring/gold                                      = 8,
		/obj/item/clothing/ring/silver                                    = 8,
		/obj/item/clothing/ring/opal                                      = 3,
		/obj/item/clothing/ring/turq                                      = 3,
		/obj/item/clothing/ring/jade                                      = 4,
		/obj/item/clothing/ring/coral                                     = 4,
		/obj/item/roguegem/green                                          = 8,
		/obj/item/roguegem/diamond                                        = 3,
		/obj/item/roguegem/opal                                           = 4,
		/obj/item/roguegem/turq                                           = 5,
		/obj/item/roguegem/jade                                           = 5,
		/obj/item/roguegem/amber                                          = 5,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 20,
		/obj/item/rogueweapon/huntingknife/idagger/navaja                 = 15,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel            = 12,
		/obj/item/roguestatue/gold                                        = 15,
		/obj/item/candle/candlestick/gold                                 = 12,
		/obj/item/clothing/ring/opal                                      = 10,
		/obj/item/clothing/ring/turq                                      = 10,
		/obj/item/roguegem/diamond                                        = 12,
		/obj/item/roguegem/opal                                           = 12,
		/obj/item/roguegem/turq                                           = 10,
	)

/obj/structure/deadbody/peasant
	name = "dead peasant"
	desc = "Someone who had very little, and lost it."
	pose_states = list(
		"mpes10", "mpes20", "mpes30", "mpes40", "mpes50",
		"fpes10", "fpes20", "fpes30", "fpes40", "fpes50",
	)
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 60,
		/obj/item/reagent_containers/food/snacks/rogue/bread              = 25,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread        = 10,
		/obj/item/flashlight/flare/torch                                  = 20,
		/obj/item/flint                                                   = 20,
		/obj/item/natural/bone                                            = 15,
		/obj/item/needle                                                  = 10,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 5,
	)

/obj/structure/deadbody/bogman
	name = "dead bogman"
	desc = "They died for a greater cause, it seems like."
	pose_states = list("bogman", "bog10", "bog20", "bog30", "bog40")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 30,
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 20,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 20,
		/obj/item/rogueweapon/mace                                        = 10,
		/obj/item/impact_grenade/explosion                                = 10,
		/obj/item/impact_grenade/smoke                                    = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy             = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/hide              = 8,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
		/obj/item/flashlight/flare/torch                                  = 10,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 20,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 20,
		/obj/item/rogueweapon/mace/steel                                  = 15,
		/obj/item/impact_grenade/explosion                                = 25,
		/obj/item/impact_grenade/smoke                                    = 15,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy             = 20,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
	)

/obj/structure/deadbody/old_knight
	name = "dead knight"
	desc = "Honor in death if not in victory."
	pose_states = list("old_knight", "kn10", "kn20", "kn30", "kn40")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 25,
		/obj/item/storage/belt/rogue/pouch/coins/mid                      = 20,
		/obj/item/rogueweapon/sword/long                                  = 15,
		/obj/item/rogueweapon/estoc                                       = 6,
		/obj/item/rogueweapon/greatsword/zwei                             = 3,
		/obj/item/clothing/suit/roguetown/armor/plate/half                = 10,
		/obj/item/clothing/suit/roguetown/armor/plate/full                = 4,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight             = 8,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface         = 5,
		/obj/item/clothing/gloves/roguetown/plate                         = 10,
		/obj/item/clothing/under/roguetown/platelegs                      = 10,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 10,
	)
	loot_table_lucky = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 25,
		/obj/item/rogueweapon/sword/long                                  = 20,
		/obj/item/rogueweapon/estoc                                       = 15,
		/obj/item/rogueweapon/greatsword/zwei                             = 8,
		/obj/item/clothing/suit/roguetown/armor/plate/full                = 15,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight             = 15,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface         = 12,
		/obj/item/clothing/gloves/roguetown/plate                         = 15,
		/obj/item/clothing/under/roguetown/platelegs                      = 15,
	)
