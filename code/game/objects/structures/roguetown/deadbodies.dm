/obj/structure/deadbody
	name = "尸体"
	desc = "某人的最终安息之处。"
	icon = 'icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"
	density = FALSE
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
		to_chat(user, span_warning("已经没什么值得拿走的了。"))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	user.visible_message(span_notice("[user]开始搜查这具尸体。"), span_notice("我开始搜查这具尸体。"))
	if(!do_after(user, 5 SECONDS, needhand = TRUE, target = src))
		return
	playsound(src, pick('sound/foley/equip/rummaging-01.ogg', 'sound/foley/equip/rummaging-02.ogg', 'sound/foley/equip/rummaging-03.ogg'), 50, FALSE)
	if(user.STALUC < 10 && prob(40))
		to_chat(user, span_warning("你一无所获，只有尘土和坏运气。"))
		looted = TRUE
		user.visible_message(span_notice("[user]搜完了[src]。"), span_notice("我搜完了[src]。"))
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
			to_chat(user, span_notice("运气不错！你翻出了[found]。"))
		else
			to_chat(user, span_notice("你翻出了[found]。"))
	looted = TRUE
	user.visible_message(span_notice("[user]搜完了[src]。"), span_notice("我搜完了[src]。"))

// ---- SUBTYPES ----

/obj/structure/deadbody/generic
	name = "流浪者的尸体"
	desc = "一个走到了路尽头的可怜灵魂。"
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
	name = "冒险者的尸体"
	desc = "为追逐荣耀而来。看样子他们确实找到了，还顺带见到了死神Necra。"
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
	name = "死去的冒险者"
	desc = "装备比大多数人都好。显然还是不够。"
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
	name = "军士的尸体"
	desc = "殉职而亡。"
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
	name = "守望者的尸体"
	desc = "死在了他们曾发誓守住的岗位上，死在了Rockhill与恐惧沼泽之间的防线上。"
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
	name = "法师的尸体"
	desc = "那一切知识，都随之而去了。"
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
	name = "死灵法师的尸体"
	desc = "曾骗过死亡一次，第二次就没那么走运了。"
	pose_states = list(
		"necromancer", "nec10", "nec20", "nec30", "nec40",
		"necromancer_old", "necro10", "necro20", "necro30", "necro40",
	)
	loot_table = list(
		/obj/item/book/granter/spell/blackstone/skeleton/lesser           = 15,
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
		/obj/item/book/granter/spell/blackstone/skeleton/lesser           = 15,
		/obj/item/book/granter/spell/blackstone/sicknessray               = 15,
		/obj/item/book/granter/spell/blackstone/invisibility              = 15,
		/obj/item/book/granter/spell/blackstone/bonechill                 = 10,
		/obj/item/book/granter/spell/blackstone/familiar                  = 8,
		/obj/item/storage/belt/rogue/pouch/coins/rich                     = 15,
	)

/obj/structure/deadbody/skeleton
	name = "枯骨"
	desc = "某人仅剩的一点残骸。"
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
	name = "军团士兵的尸体"
	desc = "Zizo 众多战士中的一个。它多半死于她统治之前、期间，或者之后。"
	pose_states = list(
		"gsk10", "gsk20", "gsk30", "gsk40", "gsk50",
		"gske10", "gske20", "gske30", "gske40", "gske50",
	)
	loot_table = list(
		/obj/item/natural/bone                                            = 25,
		/obj/item/skull                                                   = 15,
		/obj/item/rogueweapon/sword/short/ancient                   = 15,
		/obj/item/rogueweapon/sword/short/gladius/ancient               = 10,
		/obj/item/rogueweapon/spear/ancient                               = 10,
		/obj/item/rogueweapon/halberd/bardiche/ancient                    = 6,
		/obj/item/rogueweapon/greatsword/ancient                          = 4,
		/obj/item/rogueweapon/flail/sflail/ancient                        = 6,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient/decrepit = 10,
		/obj/item/clothing/under/roguetown/platelegs/ancient/decrepit             = 8,
		/obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit             = 8,
		/obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit                = 8,
	)
	loot_table_lucky = list(
		/obj/item/rogueweapon/greatsword/ancient                          = 20,
		/obj/item/rogueweapon/halberd/bardiche/ancient                    = 18,
		/obj/item/rogueweapon/spear/ancient                               = 15,
		/obj/item/rogueweapon/flail/sflail/ancient                        = 12,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient  = 20,
		/obj/item/clothing/under/roguetown/platelegs/ancient              = 15,
		/obj/item/clothing/wrists/roguetown/bracers/ancient                = 15,
		/obj/item/clothing/neck/roguetown/chaincoif/ancient                = 15,
	)

/obj/structure/deadbody/rogue
	name = "盗贼的尸体"
	desc = "带着秘密和狡黠一起死去。更像是秘密多些，狡黠少些。"
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
	name = "农民的尸体"
	desc = "一个本就没多少东西，却连那一点也失去了的人。"
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
	name = "沼泽人的尸体"
	desc = "看起来，他们是为了某个更宏大的事业而死。"
	pose_states = list("bogman", "bog10", "bog20", "bog30", "bog40")
	loot_table = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor                     = 30,
		/obj/item/rogueweapon/huntingknife/idagger/steel                  = 20,
		/obj/item/rogueweapon/mace                                        = 10,
		/obj/item/impact_grenade/explosion                                = 10,
		/obj/item/impact_grenade/smoke                                    = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy             = 8,
		/obj/item/clothing/suit/roguetown/armor/leather/hide              = 8,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot         = 15,
		/obj/item/flashlight/flare/torch                                  = 10,
		/obj/item/flashlight/flare/torch/lantern                          = 20,
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
	name = "骑士的尸体"
	desc = "纵然没能赢得胜利，至少死时尚存荣誉。"
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

/obj/structure/deadbodyrandom
	name = "随机尸体（假对象）"
	desc = "这个假对象没有任何作用。"
	icon = 'icons/roguetown/rw_deadbodies.dmi'
	icon_state = "base"

//A random-body spawner that picks a random body
/obj/structure/deadbodyrandom/all
	name = "随机尸体"
	desc = "这个假对象可以生成任意尸体。"

/obj/structure/deadbodyrandom/all/Initialize(mapload)
	var/type = pick(list(/obj/structure/deadbody/generic,
	/obj/structure/deadbody/adventurer_leather,
	/obj/structure/deadbody/adventurer_steel,
	/obj/structure/deadbody/maa,
	/obj/structure/deadbody/warden,
	/obj/structure/deadbody/wizard,
	/obj/structure/deadbody/necromancer,
	/obj/structure/deadbody/skeleton,
	/obj/structure/deadbody/greater_skeleton,
	/obj/structure/deadbody/rogue,
	/obj/structure/deadbody/peasant,
	/obj/structure/deadbody/bogman,
	/obj/structure/deadbody/old_knight))

	var/obj/structure/deadbodyrandom/all/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL


//A random-body spawner that picks a random body, but more likely to spawn a low-tier body and unable to spawn high-tier bodies
/obj/structure/deadbodyrandom/high
	name = "随机尸体（高级）"
	desc = "这个生成器会生成最好的尸体。"

/obj/structure/deadbodyrandom/high/Initialize(mapload)
	var/type = pick(list(
	/obj/structure/deadbody/adventurer_steel,
	/obj/structure/deadbody/maa,
	/obj/structure/deadbody/warden,
	/obj/structure/deadbody/wizard,
	/obj/structure/deadbody/necromancer,
	/obj/structure/deadbody/greater_skeleton,
	/obj/structure/deadbody/rogue,
	/obj/structure/deadbody/old_knight))

	var/obj/structure/deadbodyrandom/high/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL

//A random-body spawner that picks a random body, but more likely to spawn a low-tier body and unable to spawn high-tier bodies
/obj/structure/deadbodyrandom/med
	name = "随机尸体（中级）"
	desc = "这个生成器会按价值权重生成尸体。"

/obj/structure/deadbodyrandom/med/Initialize(mapload)
	var/type = pick(list(/obj/structure/deadbody/generic,
	/obj/structure/deadbody/generic,
	/obj/structure/deadbody/adventurer_leather,
	/obj/structure/deadbody/adventurer_steel,
	/obj/structure/deadbody/maa,
	/obj/structure/deadbody/warden,
	/obj/structure/deadbody/skeleton,
	/obj/structure/deadbody/skeleton,
	/obj/structure/deadbody/rogue,
	/obj/structure/deadbody/peasant,
	/obj/structure/deadbody/peasant,
	/obj/structure/deadbody/bogman,))

	var/obj/structure/deadbodyrandom/med/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL

//A random-body spawner that picks a random body, but more likely to spawn a low-tier body and unable to spawn high-tier bodies
/obj/structure/deadbodyrandom/low
	name = "随机尸体（低级）"
	desc = "这个生成器只会生成基础尸体。"

/obj/structure/deadbodyrandom/low/Initialize(mapload)
	var/type = pick(list(/obj/structure/deadbody/generic,
	/obj/structure/deadbody/generic,
	/obj/structure/deadbody/adventurer_leather,
	/obj/structure/deadbody/skeleton,
	/obj/structure/deadbody/skeleton,
	/obj/structure/deadbody/rogue,
	/obj/structure/deadbody/peasant,
	/obj/structure/deadbody/peasant,
	/obj/structure/deadbody/bogman,))

	var/obj/structure/deadbodyrandom/low/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL
