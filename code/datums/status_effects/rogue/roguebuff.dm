/datum/status_effect/buff
	status_type = STATUS_EFFECT_REFRESH


/datum/status_effect/buff/drunk
	id = "drunk"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunk
	effectedstats = list(STATKEY_INT = -2, STATKEY_WIL = 1)
	duration = 5 MINUTES

/atom/movable/screen/alert/status_effect/buff/drunk
	name = "醉酒"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/drunkmurk
	name = "Murk 之识"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/drunknoc
	name = "Noc 光辉之力"
	desc = ""
	icon_state = "drunk"

/datum/status_effect/buff/murkwine
	id = "murkwine"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunkmurk
	effectedstats = list(STATKEY_INT = 5)
	duration = 2 MINUTES

/datum/status_effect/buff/nocshine
	id = "nocshine"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunknoc
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 1)
	duration = 2 MINUTES

/datum/status_effect/buff/snackbuff
	id = "snack"
	alert_type = /atom/movable/screen/alert/status_effect/buff/snackbuff
	effectedstats = list(STATKEY_WIL = 1)
	duration = 8 MINUTES

/atom/movable/screen/alert/status_effect/buff/snackbuff
	name = "好点心"
	desc = "比白面包强多了，真好吃。"
	icon_state = "foodbuff"

/datum/status_effect/buff/snackbuff/on_apply() //can't stack two snack buffs, it'll keep the highest one
	. = ..()
	owner.add_stress(/datum/stressevent/goodsnack)
	if(owner.has_status_effect(/datum/status_effect/buff/greatsnackbuff))
		owner.remove_status_effect(/datum/status_effect/buff/snackbuff)


/datum/status_effect/buff/greatsnackbuff
	id = "greatsnack"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatsnackbuff
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatsnackbuff
	name = "绝佳点心！"
	desc = "没有什么比一份营养又美味的点心更适合支撑最后一程了。我感觉精神焕发。"
	icon_state = "foodbuff"

/datum/status_effect/buff/greatsnackbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/greatsnack)
	if(owner.has_status_effect(/datum/status_effect/buff/snackbuff)) //most of the time you technically shouldn't need to check this, but otherwise you get runtimes, so keep it
		owner.remove_status_effect(/datum/status_effect/buff/snackbuff)

/datum/status_effect/buff/mealbuff
	id = "meal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mealbuff
	effectedstats = list(STATKEY_CON = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/mealbuff
	name = "好饭食"
	desc = "一天一顿好饭能让剃头匠离我远点，至少日子会稍微好过些。"
	icon_state = "foodbuff"

/datum/status_effect/buff/mealbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/goodmeal)
	if(owner.has_status_effect(/datum/status_effect/buff/greatmealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/mealbuff)

/datum/status_effect/buff/greatmealbuff
	id = "greatmeal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatmealbuff
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatmealbuff
	name = "盛宴一餐！"
	desc = "那顿饭简直像贵族的宴席！它肯定能让我一整天都精力充沛。"
	icon_state = "foodbuff"

/datum/status_effect/buff/greatmealbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/greatmeal)
	if(owner.has_status_effect(/datum/status_effect/buff/mealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/mealbuff) //can't stack two meal buffs, it'll keep the highest one

/datum/status_effect/buff/sweet
	id = "sugar"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sweet
	effectedstats = list(STATKEY_LCK = 1)
	duration = 8 MINUTES

/atom/movable/screen/alert/status_effect/buff/sweet
	name = "甜蜜拥抱"
	desc = "甜食总是好运的象征，吃上几口后万事都顺起来了。"
	icon_state = "foodbuff"

/datum/status_effect/buff/sweet/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/sweet)

/datum/status_effect/buff/druqks
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 5,STATKEY_SPD = 3,STATKEY_LCK = -5)
	duration = 2 MINUTES

/datum/status_effect/buff/druqks/baotha

/datum/status_effect/buff/druqks/baotha/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)

/datum/status_effect/buff/druqks/baotha/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)
	owner.visible_message("[owner]的眼睛似乎恢复正常了。")

/datum/status_effect/buff/druqks/on_apply()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.add_stress(/datum/stressevent/high)

/datum/status_effect/buff/druqks/on_remove()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.remove_stress(/datum/stressevent/high)

	. = ..()

/atom/movable/screen/alert/status_effect/buff/druqks
	name = "上头"
	desc = ""
	icon_state = "acid"

/datum/status_effect/buff/ozium
	id = "ozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = -5, STATKEY_PER = 2)
	duration = 30 SECONDS

/datum/status_effect/buff/ozium/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, id)

/datum/status_effect/buff/ozium/on_remove()
	owner.remove_stress(/datum/stressevent/ozium)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	. = ..()

/datum/status_effect/buff/moondust
	id = "moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 2, STATKEY_WIL = 2, STATKEY_INT = -2)
	duration = 30 SECONDS

/datum/status_effect/buff/moondust/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/moondust/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/moondust)

/datum/status_effect/buff/moondust_purest
	id = "purest moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 3, STATKEY_INT = -2)
	duration = 40 SECONDS

/datum/status_effect/buff/moondust_purest/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/moondust_purest/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/moondust_purest)

/datum/status_effect/buff/herozium
	id = "herozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = -5, STATKEY_WIL = 4, STATKEY_INT = -3, STATKEY_CON = 3)
	duration = 80 SECONDS
	var/originalcmode = ""

/datum/status_effect/buff/herozium/nextmove_modifier()
	return 1.2

/datum/status_effect/buff/herozium/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, id)
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_ozium.ogg'

/datum/status_effect/buff/herozium/on_remove()
	owner.remove_stress(/datum/stressevent/ozium)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	owner.cmode_music = originalcmode
	. = ..()

/datum/status_effect/buff/starsugar
	id = "starsugar"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 4, STATKEY_WIL = 4, STATKEY_INT = -3, STATKEY_CON = -3)
	duration = 80 SECONDS
	var/originalcmode = ""

/datum/status_effect/buff/starsugar/nextmove_modifier()
	return 0.7

/datum/status_effect/buff/starsugar/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/starsugar)
	ADD_TRAIT(owner, TRAIT_DODGEEXPERT, id)
	ADD_TRAIT(owner, TRAIT_DARKVISION, id)
	if(owner.has_status_effect(/datum/status_effect/debuff/sleepytime))
		owner.remove_status_effect(/datum/status_effect/debuff/sleepytime)
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_starsugar.ogg'


/datum/status_effect/buff/starsugar/on_remove()
	REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, id)
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, id)
	owner.remove_stress(/datum/stressevent/starsugar)
	owner.cmode_music = originalcmode
	. = ..()

/datum/status_effect/buff/weed
	id = "weed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/weed
	effectedstats = list(STATKEY_INT = 2,STATKEY_SPD = -2,STATKEY_LCK = 2)
	duration = 10 SECONDS

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/weed)
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/datum/status_effect/buff/weed/on_remove()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

	. = ..()

/atom/movable/screen/alert/status_effect/buff/weed
	name = "恍惚"
	desc = ""
	icon_state = "weed"

/datum/status_effect/buff/vitae
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vitae
	effectedstats = list(STATKEY_LCK = 2)
	duration = 1 MINUTES

/datum/status_effect/buff/vitae/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/high)
	SEND_SIGNAL(owner, COMSIG_LUX_TASTED)

/datum/status_effect/buff/vitae/on_remove()
	owner.remove_stress(/datum/stressevent/high)

	. = ..()

/datum/status_effect/buff/fermented_crab
	id = "fermented_crab"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fermented_crab
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = -2)
	duration = 5 MINUTES
	/// TRUE if the user had TRAIT_LIMPDICK and we have to reapply if after the trait expires
	var/had_limpdick = FALSE
	/// TRUE if the user had disfunctional pintle and we have to make it disfunctional again on trait expiration
	var/had_disfunctional_pintle = FALSE

/datum/status_effect/buff/fermented_crab/on_apply()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_LIMPDICK))
		REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
		had_limpdick = TRUE

	var/obj/item/organ/penis/pintle = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(!pintle.functional)
		pintle.functional = TRUE
		had_disfunctional_pintle = TRUE

	owner?.sexcon?.set_charge(owner?.sexcon?.get_max_charge())

/datum/status_effect/buff/fermented_crab/on_remove()
	. = ..()
	if(had_limpdick)
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	if(had_disfunctional_pintle)
		var/obj/item/organ/penis/pintle = owner.getorganslot(ORGAN_SLOT_PENIS)
		pintle.functional = FALSE

/atom/movable/screen/alert/status_effect/buff/fermented_crab
	name = "精力焕发"
	desc = "腌蟹味道糟透了，但我现在浑身是劲！"

/datum/status_effect/buff/cum_consumed
	id = "cum_consumed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/cum_consumed
	duration = 10 MINUTES

/datum/status_effect/buff/cum_consumed/on_apply()
	. = ..()
	if(owner.has_flaw(/datum/charflaw/addiction/lovefiend))
		owner.add_stress(/datum/stressevent/cumconsumed)

/datum/status_effect/buff/cum_consumed/on_remove()
	if(owner.has_flaw(/datum/charflaw/addiction/lovefiend))
		owner.remove_stress(/datum/stressevent/cumconsumed)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/cum_consumed
	name = "精液上头"
	desc = "我吞下了某人的精液......"
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/vitae
	name = "振奋"
	desc = "我品尝了最上等的珍馐：生命！"

/atom/movable/screen/alert/status_effect/buff/featherfall
	name = "轻羽缓落"
	desc = "我在一定程度上不易因高处坠落受伤。"
	icon_state = "buff"

/datum/status_effect/buff/featherfall
	id = "featherfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/featherfall
	duration = 1 MINUTES

/datum/status_effect/buff/featherfall/on_apply()
	. = ..()
	to_chat(owner, span_warning("我感觉更轻了。"))
	ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/datum/status_effect/buff/featherfall/on_remove()
	. = ..()
	to_chat(owner, span_warning("轻盈的感觉消散了。"))
	REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/darkvision
	name = "暗视"
	desc = "我在黑暗中也能看清一些。"
	icon_state = "buff"

/datum/status_effect/buff/darkvision
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/darkvision
	duration = 15 MINUTES

/datum/status_effect/buff/darkvision/on_apply(mob/living/new_owner, assocskill)
	if(assocskill)
		duration += 5 MINUTES * assocskill
	. = ..()
	to_chat(owner, span_warning("黑暗稍微退去了。"))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("黑暗又恢复如常。"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/longstrider
	name = "长行者"
	desc = "我能轻松穿过崎岖地形。"
	icon_state = "buff"

/datum/status_effect/buff/longstrider
	id = "longstrider"
	alert_type = /atom/movable/screen/alert/status_effect/buff/longstrider
	duration = 15 MINUTES

/datum/status_effect/buff/longstrider/on_apply()
	. = ..()
	to_chat(owner, span_warning("地形不再拖慢我。"))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/datum/status_effect/buff/longstrider/on_remove()
	. = ..()
	to_chat(owner, span_warning("崎岖地面又再次拖慢了我的脚步。"))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/magearmor
	name = "削弱的屏障"
	desc = "我的魔法屏障被削弱了。"
	icon_state = "stressvg"

/datum/status_effect/buff/magearmor
	id = "magearmor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magearmor

/datum/status_effect/buff/magearmor/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/magearmordown.ogg', 75, FALSE)
	duration = (7-owner.get_skill_level(/datum/skill/magic/arcane)) MINUTES

/datum/status_effect/buff/magearmor/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的魔法屏障重新成形。"))
	playsound(owner, 'sound/magic/magearmorup.ogg', 75, FALSE)
	owner.scalearmor = 0

/atom/movable/screen/alert/status_effect/buff/scalearmor
	name = "鳞甲受击"
	desc = "我的鳞片受了重击，暂时不能再替我的护甲承受下一击！"
	icon_state = "stressvg"

/datum/status_effect/buff/scalearmor
	id = "scalearmor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/scalearmor

/datum/status_effect/buff/scalearmor/on_apply()
	. = ..()
	playsound(owner, 'sound/combat/sharpness_loss1.ogg', 75, FALSE)
	duration = 3 MINUTES//A flat rate of 3 minutes, no matter what. Maybe change this to CON?

/datum/status_effect/buff/scalearmor/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的鳞片大概又能再挡下一击了。"))
	playsound(owner, 'sound/combat/sharpness_loss2.ogg', 75, FALSE)
	owner.scalearmor = 0

/atom/movable/screen/alert/status_effect/buff/guardbuffone
	name = "警觉卫兵"
	desc = "这里是我的地盘。我时刻警惕，并会迅速作出反应。"
	icon_state = "guardsman"

/atom/movable/screen/alert/status_effect/buff/barkeepbuff
	name = "警觉酒馆老板"
	desc = "这里是我的地盘。我时刻警惕，并会迅速作出反应。"
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/knightbuff
	name = "宣誓守卫"
	desc = "我已立誓守卫这座城堡，我的决心绝不会动摇。"
	icon_state = "guardsman"

/atom/movable/screen/alert/status_effect/buff/dungeoneerbuff
	name = "无情狱吏"
	desc = "这里是我的领地。我能压倒任何胆敢闯入的敌人。"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/wardenbuff
	name = "林地行者"
	desc = "我已在这片林地间跋涉许久，在这里行动更轻松。"
	icon_state = "guardsman"

/datum/status_effect/buff/wardenbuff
	id = "wardenbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wardenbuff
	effectedstats = list(STATKEY_SPD = 1, STATKEY_PER = 3)

/atom/movable/screen/alert/status_effect/buff/viewingbuff
	name = "视野良好"
	desc = "这片区域修得更便于观察。"
	icon_state = "guardsman"

/datum/status_effect/buff/viewingbuff
	id = "viewingbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/viewingbuff
	effectedstats = list(STATKEY_PER = 2)

/datum/status_effect/buff/barkeepbuff
	id = "barkeepbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/barkeepbuff
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1, STATKEY_SPD = 1, STATKEY_STR = 3)

/datum/status_effect/buff/barkeepbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.tavern_area))
		owner.remove_status_effect(/datum/status_effect/buff/barkeepbuff)

/datum/status_effect/buff/guardbuffone
	id = "guardbuffone"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guardbuffone
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1, STATKEY_SPD = 1, STATKEY_PER = 2)

/datum/status_effect/buff/dungeoneerbuff
	id = "dungeoneerbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dungeoneerbuff
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1, STATKEY_STR = 2)//This only works in 2 small areas on the entire map

/datum/status_effect/buff/guardbuffone/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.town_area))
		owner.remove_status_effect(/datum/status_effect/buff/guardbuffone)

/datum/status_effect/buff/wardenbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.warden_area))
		owner.remove_status_effect(/datum/status_effect/buff/wardenbuff)

/datum/status_effect/buff/wardenbuff/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)

/datum/status_effect/buff/wardenbuff/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)

/datum/status_effect/buff/dungeoneerbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.cell_area))
		owner.remove_status_effect(/datum/status_effect/buff/dungeoneerbuff)

/datum/status_effect/buff/dungeoneerbuff/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CIVILIZEDBARBARIAN, id)

/datum/status_effect/buff/dungeoneerbuff/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CIVILIZEDBARBARIAN, id)

/atom/movable/screen/alert/status_effect/holy_empowerement
	name = "圣地"
	desc = "在这片土地上，我与自己的主神联系最深，祂的赐福也最为强大！"
	icon_state = "guardsman"

/datum/status_effect/debuff/holy_blessing
	id = "holyblessing"
	alert_type = /atom/movable/screen/alert/status_effect/holy_empowerement
	effectedstats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 2,
	)

/datum/status_effect/debuff/holy_blessing/process()
	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.holy_area))
		owner.remove_status_effect(/datum/status_effect/debuff/holy_blessing)

// Lesser Miracle effect
/atom/movable/screen/alert/status_effect/buff/healing
	name = "治愈奇迹"
	desc = "神圣干预缓解了我的伤痛。"
	icon_state = "lesser_heal"

/datum/status_effect/buff/viewingbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.viewing_area))
		owner.remove_status_effect(/datum/status_effect/buff/viewingbuff)

#define MIRACLE_HEALING_FILTER "miracle_heal_glow"

/datum/status_effect/buff/healing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS
	examine_text = "SUBJECTPRONOUN 沐浴在恢复性的灵光之中！"
	var/healing_on_tick = 1
	var/outline_colour = "#c42424"
	var/tech_healing_modifier = 1

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, new_healing_on_tick, is_inhumen = FALSE)
	healing_on_tick = new_healing_on_tick
	tech_healing_modifier = SSchimeric_tech.get_healing_multiplier()
	if(is_inhumen)
		// The penalty/benefit of healing tech is halved for inhumen followers
		tech_healing_modifier = 1 + ((tech_healing_modifier - 1) * 0.5)
	healing_on_tick *= tech_healing_modifier
	return ..()

/datum/status_effect/buff/healing/on_apply()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_on_tick, src)
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		if(HAS_TRAIT(owner, TRAIT_SIMPLE_WOUNDS))
			if(wCount.len > 0)
				owner.heal_wounds(healing_on_tick * 2)
			owner.bleed_rate = owner.get_bleed_rate()
			if(!length(owner.get_wounds()) && !length(owner.get_embedded_objects()))
				owner.simple_bleeding = 0
				owner.bleed_rate = 0
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)
		owner.updatehealth()
// Lesser miracle effect end

/atom/movable/screen/alert/status_effect/buff/healing/campfire
	name = "温暖歇息"
	desc = "火焰的温暖抚慰了我的伤痛。"
	icon_state = "campfire"

/datum/status_effect/buff/healing/campfire
	id = "healing_campfire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/campfire
	examine_text = null
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/buff/campfire_stamina
	name = "营火休憩"
	desc = "在火边歇一会儿让我恢复了些体力。"
	icon_state = "campfire"

/atom/movable/screen/alert/status_effect/buff/fireplace_stamina
	name = "温暖歇息"
	desc = "火焰的温暖让我恢复了些体力。"
	icon_state = "fireplace"

#define CAMPFIRE_BASE_FILTER "campfire_stamina"

/datum/status_effect/buff/campfire_stamina
	id = "stamina_campfire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/campfire_stamina
	duration = 5 SECONDS
	examine_text = "SUBJECTPRONOUN 正享受片刻歇息。"
	var/healing_on_tick = 5
	var/outline_colour = "#7e6a3e"
	var/tech_healing_modifier = 1

/datum/status_effect/buff/campfire_stamina/on_apply()
	var/filter = owner.get_filter(CAMPFIRE_BASE_FILTER)
	if (!filter)
		owner.add_filter(CAMPFIRE_BASE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/campfire_stamina/tick()
	if(owner.construct)
		return
	var/stamheal = healing_on_tick
	if(!owner.cmode)
		stamheal *= 2
	owner.energy_add(stamheal)
	if(owner.bodytemperature < 300)	//Apply heat to player if below certain normal
		owner.adjust_bodytemperature(5)

/datum/status_effect/buff/campfire_stamina/on_remove()
	owner.remove_filter(CAMPFIRE_BASE_FILTER)

/datum/status_effect/buff/campfire_stamina/fireplace
	alert_type = /atom/movable/screen/alert/status_effect/buff/fireplace_stamina

/datum/status_effect/buff/campfire
	id = "healing_campfire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/campfire
	examine_text = null
	var/healing_on_tick = 2
	duration = 6 SECONDS

/datum/status_effect/buff/campfire/tick()
	if(owner.cmode)
		return
	if(owner.construct)
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(owner))
	H.color = "#c7aa5c"
	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_OKAY)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic, /datum/wound/dislocation))
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

#undef CAMPFIRE_BASE_FILTER

//Self healing for Martyr.
/datum/status_effect/buff/healing/prayer
	id = "healing_prayers"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/prayer
	examine_text = "SUBJECTPRONOUN 正燃烧着神圣辉光！"
	outline_colour = "#b280df"
	duration = 12 SECONDS

/atom/movable/screen/alert/status_effect/buff/healing/prayer
	name = "信念"
	desc = "唯凭信仰，我亦能痊愈。"
	icon_state = "buff"

//BY FAITH ALONE. When Martyr heals via another Tennite praying.
/datum/status_effect/buff/healing/prayer_power
	id = "healing_prayers"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/prayer_power
	examine_text = "SUBJECTPRONOUN 被神圣辉光照亮！"
	outline_colour = "#b280df"
	duration = 2 SECONDS

/atom/movable/screen/alert/status_effect/buff/healing/prayer_power
	name = "受福的歇息"
	desc = "借由信仰，我得以活着。"
	icon_state = "buff"

// Lay hands orison effect - gentle, slow healing
#define LAY_HANDS_FILTER "lay_hands_glow"

/atom/movable/screen/alert/status_effect/buff/lay_hands
	name = "按手疗愈"
	desc = "神圣力量流过我体内，缝合我的伤口。"
	icon_state = "buff"

/datum/status_effect/buff/lay_hands
	id = "lay_hands"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lay_hands
	duration = 10 SECONDS // Short duration - continuously refreshed while channeling
	examine_text = "SUBJECTPRONOUN 全身都充盈着神圣能量。"
	var/healing_on_tick = 0.3 // Very weak healing compared to normal miracles
	var/outline_colour = "#FFD700" // Golden color instead of red

/datum/status_effect/buff/lay_hands/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/lay_hands/on_apply()
	var/filter = owner.get_filter(LAY_HANDS_FILTER)
	if (!filter)
		owner.add_filter(LAY_HANDS_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	playsound(owner, 'sound/magic/churn.ogg', 50, FALSE)
	to_chat(owner, span_notice("神圣能量充盈着我的身体......"))
	return TRUE

/datum/status_effect/buff/lay_hands/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FFD700" // Golden healing particles
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+(healing_on_tick * 0.5), BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		if(HAS_TRAIT(owner, TRAIT_SIMPLE_WOUNDS) && !length(owner.get_wounds()) && !length(owner.get_embedded_objects()))
			owner.simple_bleeding = 0
			owner.bleed_rate = 0
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick * 0.5, 0)
		owner.adjustToxLoss(-healing_on_tick * 0.5, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick * 0.5)

/datum/status_effect/buff/lay_hands/on_remove()
	owner.remove_filter(LAY_HANDS_FILTER)
	to_chat(owner, span_notice("神圣能量正从我的身体中消退。"))

#undef LAY_HANDS_FILTER

#define BLOODHEAL_DUR_SCALE_PER_LEVEL 3 SECONDS
#define BLOODHEAL_RESTORE_DEFAULT 5
#define BLOODHEAL_RESTORE_SCALE_PER_LEVEL 2
#define BLOODHEAL_DUR_DEFAULT 10 SECONDS
// Bloodheal miracle effect
/atom/movable/screen/alert/status_effect/buff/bloodheal
	name = "血之奇迹"
	desc = "神圣干预正将生命之血注入我体内。"
	icon_state = "bloodheal"

#define MIRACLE_BLOODHEAL_FILTER "miracle_bloodheal_glow"

/datum/status_effect/buff/bloodheal
	id = "bloodheal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bloodheal
	duration = BLOODHEAL_DUR_DEFAULT
	examine_text = "SUBJECTPRONOUN 沐浴在浓厚刺鼻的铁腥气息中！"
	var/healing_on_tick = BLOODHEAL_RESTORE_DEFAULT
	var/skill_level
	var/outline_colour = "#c42424"

/datum/status_effect/buff/bloodheal/on_creation(mob/living/new_owner, associated_skill)
	healing_on_tick = BLOODHEAL_RESTORE_DEFAULT + ((associated_skill > SKILL_LEVEL_NOVICE) ? (BLOODHEAL_RESTORE_SCALE_PER_LEVEL * associated_skill) : 0)
	skill_level = associated_skill
	duration = BLOODHEAL_DUR_DEFAULT + ((associated_skill > SKILL_LEVEL_NOVICE) ? (BLOODHEAL_DUR_SCALE_PER_LEVEL * associated_skill) : 0)
	return ..()

/datum/status_effect/buff/bloodheal/on_apply()
	var/filter = owner.get_filter(MIRACLE_BLOODHEAL_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_BLOODHEAL_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/bloodheal/on_remove()
	. = ..()
	owner.remove_filter(MIRACLE_BLOODHEAL_FILTER)

/datum/status_effect/buff/bloodheal/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_blood(get_turf(owner))
	H.color = "#FF0000"
	if(!owner.construct)
		if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
			if(owner.blood_volume < BLOOD_VOLUME_SURVIVE)
				owner.blood_volume = BLOOD_VOLUME_SURVIVE
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_NORMAL)

#undef BLOODHEAL_DUR_SCALE_PER_LEVEL
#undef BLOODHEAL_RESTORE_DEFAULT
#undef BLOODHEAL_RESTORE_SCALE_PER_LEVEL
#undef BLOODHEAL_DUR_DEFAULT
// Bloodheal miracle effect end

// Necra's Vow healing effect
/datum/status_effect/buff/healing/necras_vow
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = -1
	healing_on_tick = 3
	outline_colour = "#bbbbbb"

/datum/status_effect/buff/healing/necras_vow/on_apply()
	healing_on_tick = max(owner.get_skill_level(/datum/skill/magic/holy), 3)
	return TRUE

/datum/status_effect/buff/healing/necras_vow/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#a5a5a5"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + (healing_on_tick + 10), BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise))
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/atom/movable/screen/alert/status_effect/buff/psyhealing
	name = "坚忍"
	desc = "我心中满溢着情感。"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/psyvived
	name = "宽赦"
	desc = "我感到一种奇异的平静。"
	icon_state = "buff"

#define PSYDON_HEALING_FILTER "psydon_heal_glow"
#define PSYDON_REVIVED_FILTER "psydon_revival_glow"

/datum/status_effect/buff/psyhealing
	id = "psyhealing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyhealing
	duration = 15 SECONDS
	examine_text = "SUBJECTPRONOUN 因坚忍之感而苏醒！"
	var/healing_on_tick = 1
	var/outline_colour = "#d3d3d3"

/datum/status_effect/buff/psyhealing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/psyhealing/on_apply()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_on_tick, src)
	var/filter = owner.get_filter(PSYDON_HEALING_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyhealing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#d3d3d3"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick * 1.75)
			owner.update_damage_overlays()
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		if(HAS_TRAIT(owner, TRAIT_SIMPLE_WOUNDS))
			if(wCount.len > 0)
				owner.heal_wounds(healing_on_tick * 2)
			owner.bleed_rate = owner.get_bleed_rate()
			if(!length(owner.get_wounds()) && !length(owner.get_embedded_objects()))
				owner.simple_bleeding = 0
				owner.bleed_rate = 0
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/psyvived
	id = "psyvived"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyvived
	duration = 30 SECONDS
	examine_text = "SUBJECTPRONOUN 周身萦绕着宽赦之意！"
	var/outline_colour = "#aa1717"

/datum/status_effect/buff/psyvived/on_creation(mob/living/new_owner)
	return ..()

/datum/status_effect/buff/psyvived/on_apply()
	var/filter = owner.get_filter(PSYDON_REVIVED_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_REVIVED_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyvived/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#aa1717"

/datum/status_effect/buff/rockmuncher
	id = "rockmuncher"
	duration = 10 SECONDS
	var/healing_on_tick = 4

/datum/status_effect/buff/rockmuncher/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/rockmuncher/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(owner.construct)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(0.15*-healing_on_tick, 0)
		owner.adjustFireLoss(0.15*-healing_on_tick, 0)
		owner.adjustOxyLoss(0.15*-healing_on_tick, 0)
		owner.adjustToxLoss(0.15*-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.15*-healing_on_tick)
		owner.adjustCloneLoss(0.15*-healing_on_tick, 0)

//A very brief burst heal, from eating gems. Not stones.
//The better the gem, the better the heal.
/datum/status_effect/buff/gemmuncher
	id = "gemmuncher"
	alert_type = /atom/movable/screen/alert/status_effect/buff/gemmuncher
	duration = 4 SECONDS
	var/healing_on_tick = 3

/datum/status_effect/buff/gemmuncher/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/gemmuncher/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(iskobold(owner))
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(0.15*-healing_on_tick, 0)
		owner.adjustFireLoss(0.15*-healing_on_tick, 0)
		owner.adjustOxyLoss(0.15*-healing_on_tick, 0)
		owner.adjustToxLoss(0.15*-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.15*-healing_on_tick)
		owner.adjustCloneLoss(0.15*-healing_on_tick, 0)

/atom/movable/screen/alert/status_effect/buff/gemmuncher
	name = "饱食"
	desc = "我吞下了一颗宝石。"
	icon_state = "buff"

//Lesser stone eating. Far, far less ideal.
//Heals wounds based on stone level. Restores blood at a static rate.
/datum/status_effect/buff/rockmuncher_lesser
	id = "rockmuncher_lesser"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rockmuncher_lesser
	duration = 10 SECONDS
	var/healing_on_tick = 1

/datum/status_effect/buff/rockmuncher_lesser/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/rockmuncher_lesser/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(iskobold(owner))
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume+4, BLOOD_VOLUME_NORMAL)

/atom/movable/screen/alert/status_effect/buff/rockmuncher_lesser
	name = "饱腹"
	desc = "我吞下了一块石头。"
	icon_state = "buff"

/datum/status_effect/buff/mount_apple_healing
	id = "mount_apple_healing"
	duration = 8 SECONDS
	var/healing_on_tick = 1

/datum/status_effect/buff/mount_apple_healing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/mount_apple_healing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF6666"
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/healing/on_remove()
	owner.remove_filter(MIRACLE_HEALING_FILTER)
	owner.update_damage_hud()

/datum/status_effect/buff/psyhealing/on_remove()
	owner.remove_filter(PSYDON_HEALING_FILTER)
	owner.update_damage_hud()

/datum/status_effect/buff/psyvived/on_remove()
	owner.remove_filter(PSYDON_REVIVED_FILTER)
	owner.update_damage_hud()

/atom/movable/screen/alert/status_effect/buff/convergence
	name = "汇流奇迹"
	desc = "我的身体正回归获得力量与健康时的状态。"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/stasis
	name = "停滞奇迹"
	desc = "我身体的一部分被置于停滞之中。"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/censerbuff
	name = "受 SYON 启迪"
	desc = "那枚大彗星碎片激励我去坚忍。"
	icon_state = "censerbuff"

#define FORTIFY_FILTER "fortify_glow"
/datum/status_effect/buff/fortify //Increases all healing while it lasts.
	id = "fortify"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortify
	duration = 1 MINUTES
	examine_text = "SUBJECTPRONOUN 周身闪耀着神圣能量！"
	var/outline_colour = "#fbe59d"

/atom/movable/screen/alert/status_effect/buff/fortify
	name = "强化奇迹"
	desc = "神圣干预强化了我，也加快了我的恢复。"
	icon_state = "buff"

/datum/status_effect/buff/fortify/on_apply()
	. = ..()
	var/filter = owner.get_filter(FORTIFY_FILTER)
	if (!filter)
		owner.add_filter(FORTIFY_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/buff/fortify/on_remove()
	. = ..()
	owner.remove_filter(FORTIFY_FILTER)
#undef FORTIFY_FILTER

/datum/status_effect/buff/censerbuff
	id = "censer"
	alert_type = /atom/movable/screen/alert/status_effect/buff/censerbuff
	duration = 15 MINUTES
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1)

/datum/status_effect/buff/convergence //Increases all healing while it lasts.
	id = "convergence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/convergence
	duration = 1 MINUTES

/datum/status_effect/buff/stasis //Increases all healing while it lasts.
	id = "stasis"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stasis
	duration = 10 SECONDS

#define CRANKBOX_FILTER "crankboxbuff_glow"
/atom/movable/screen/alert/status_effect/buff/churnerprotection
	name = "魔力紊乱"
	desc = "哀嚎之箱正在扰乱我周围的魔力！"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/churnernegative
	name = "魔力紊乱"
	desc = "那台可憎的装置正在抽干我的 Arcyne 本源！"
	icon_state = "buff"

/datum/status_effect/buff/churnerprotection
	var/outline_colour = "#fad55a"
	id = "soulchurnerprotection"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnerprotection
	duration = 20 SECONDS

/datum/status_effect/buff/churnerprotection/on_apply()
	. = ..()
	var/filter = owner.get_filter(CRANKBOX_FILTER)
	if (!filter)
		owner.add_filter(CRANKBOX_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	to_chat(owner, span_warning("我能感觉到哀嚎之箱正在扭曲我周围的魔力！"))
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)

/datum/status_effect/buff/churnerprotection/on_remove()
	. = ..()
	to_chat(owner, span_warning("哀嚎之箱的保护消散了......"))
	owner.remove_filter(CRANKBOX_FILTER)
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)

#undef CRANKBOX_FILTER
#undef MIRACLE_HEALING_FILTER

/datum/status_effect/buff/churnernegative
	id ="soulchurnernegative"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnernegative
	duration = 23 SECONDS

/datum/status_effect/buff/churnernegative/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(owner, span_warning("我感觉自己与 Arcyne 的联系彻底消失了。空气都像静止了一样......"))
	owner.visible_message("[owner]身上的 Arcyne 灵光似乎正在消退。")

/datum/status_effect/buff/churnernegative/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(owner, span_warning("我感觉 Arcyne 再次环绕着我。"))
	owner.visible_message("[owner]身上的 Arcyne 灵光似乎又回来了。")

#define BLESSINGOFSUN_FILTER "sun_glow"
/atom/movable/screen/alert/status_effect/buff/guidinglight
	name = "引路明光"
	desc = "Astrata 的目光追随着我，为我照亮前路！"
	icon_state = "stressvg"

/datum/status_effect/buff/guidinglight // Hey did u follow us from ritualcircles? Cool, okay this stuff is pretty simple yeah? Most ritual circles use some sort of status effects to get their effects ez.
	id = "guidinglight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guidinglight
	duration = 30 MINUTES // Lasts for 30 minutes, roughly an ingame day. This should be the gold standard for rituals, unless its some particularly powerul effect or one-time effect(Flylord's triage)
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list(STATKEY_PER = 2) // This is for basic stat effects, I would consider these a 'little topping' and not what you should rlly aim for for rituals. Ideally we have cool flavor boons, rather than combat stims.
	examine_text = "SUBJECTPRONOUN 沐浴在祂的光辉下前行！"
	var/list/mobs_affected
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj
	var/outline_colour = "#ffffff"

/datum/status_effect/buff/guidinglight/on_apply()
	. = ..()
	if (!.)
		return
	to_chat(owner, span_notice("光芒在我身边绽放！"))
	var/filter = owner.get_filter(BLESSINGOFSUN_FILTER)
	if (!filter)
		owner.add_filter(BLESSINGOFSUN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	mob_light_obj = owner.mob_light("#fdfbd3", 10, 10)
	return TRUE


/datum/status_effect/buff/guidinglight/on_remove()
	. = ..()
	playsound(owner, 'sound/items/firesnuff.ogg', 75, FALSE)
	to_chat(owner, span_notice("环绕我的奇迹之光离去了......"))
	owner.remove_filter(BLESSINGOFSUN_FILTER)
	QDEL_NULL(mob_light_obj)

#undef BLESSINGOFSUN_FILTER
/datum/status_effect/buff/moonlightdance
	id = "Moonsight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/moonlightdance
	effectedstats = list(STATKEY_INT = 2)
	duration = 25 MINUTES

/atom/movable/screen/alert/status_effect/buff/moonlightdance
	name = "月光之舞"
	desc = "Noc 如石般冰凉的触碰落在我的心智之上，为我带来智慧。"
	icon_state = "moonlightdance"


/datum/status_effect/buff/moonlightdance/on_apply()
	. = ..()
	to_chat(owner, span_warning("我透过月光而视，银色丝线在我眼前舞动。"))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)


/datum/status_effect/buff/moonlightdance/on_remove()
	. = ..()
	to_chat(owner, span_warning("Noc 的银辉离开了我的视野。"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)




/atom/movable/screen/alert/status_effect/buff/flylordstriage
	name = "蝇王急救"
	desc = "Pestra 的仆从正从我的毛孔与伤口中爬行！"
	icon_state = "buff"

/datum/status_effect/buff/flylordstriage
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 20 SECONDS
	var/healing_on_tick = 40

/datum/status_effect/buff/flylordstriage/tick()
	playsound(owner, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
	owner.flash_fullscreen("redflash3")
	owner.emote("agony")
	new /obj/effect/temp_visual/flies(get_turf(owner))
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+100, BLOOD_VOLUME_NORMAL)
	if(wCount.len > 0)
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/obj/effect/temp_visual/flies
	name = "蝇王急救"
	icon_state = "flies"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	icon = 'icons/roguetown/mob/rotten.dmi'
	icon_state = "rotten"


/datum/status_effect/buff/flylordstriage/on_remove()
	to_chat(owner,span_userdanger("终于结束了......"))



/atom/movable/screen/alert/status_effect/buff/undermaidenbargain
	name = "Undermaiden 的交易"
	desc = "有一桩可怕的交易以我的名义缔结了......"
	icon_state = "buff"

/datum/status_effect/buff/undermaidenbargain
	id = "undermaidenbargain"
	alert_type = /atom/movable/screen/alert/status_effect/buff/undermaidenbargain
	duration = 30 MINUTES

/datum/status_effect/buff/undermaidenbargain/on_apply()
	. = ..()
	to_chat(owner, span_danger("你感觉似乎有一桩可怕的交易正以你的名义备妥。愿你永远不要看见它被兑现......"))
	playsound(owner, 'sound/misc/bell.ogg', 100, FALSE, -1)
	ADD_TRAIT(owner, TRAIT_DEATHBARGAIN, id)

/datum/status_effect/buff/undermaidenbargain/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DEATHBARGAIN, id)


/datum/status_effect/buff/undermaidenbargainheal/on_apply()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/undermaidenbargain)
	to_chat(owner, span_warning("你感到那桩以你之名缔结的交易正在被兑现......"))
	playsound(owner, 'sound/misc/deadbell.ogg', 100, FALSE, -1)
	ADD_TRAIT(owner, TRAIT_NODEATH, id)
	var/dirgeline = rand(1,6)
	spawn(15)
		switch(dirgeline)
			if(1)
				to_chat(owner, span_cultsmall("她望着城市天际线，看着自己的鲜血流入下水道。"))
			if(2)
				to_chat(owner, span_cultsmall("他只想为家人争取更多。守望者的刀锋已经命中，他倒在石路上，反而感到一丝安慰。"))
			if(3)
				to_chat(owner, span_cultsmall("一名水手的腿被缆绳缠住了。他临终前最后想到的是家。"))
			if(4)
				to_chat(owner, span_cultsmall("她伏在维纳丁人的尸体上哭泣，而强盗的钉锤止住了她的泪水。"))
			if(5)
				to_chat(owner, span_cultsmall("一个农家儿子咽下了最后一口气。床边的姐姐与母亲正在哭泣。"))
			if(6)
				to_chat(owner, span_cultsmall("一名女子跪在墓碑前哀求。这是你的错。"))

/datum/status_effect/buff/undermaidenbargainheal/on_remove()
	. = ..()
	to_chat(owner, span_warning("以我之名缔结的交易已经兑现......我被 Necra 的怀抱抛出，而另一个人替我承受......"))
	playsound(owner, 'sound/misc/deadbell.ogg', 100, FALSE, -1)
	REMOVE_TRAIT(owner, TRAIT_NODEATH, id)

/datum/status_effect/buff/undermaidenbargainheal
	id = "undermaidenbargainheal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/undermaidenbargainheal
	duration = 10 SECONDS
	var/healing_on_tick = 20

/datum/status_effect/buff/undermaidenbargainheal/tick()
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+60, BLOOD_VOLUME_NORMAL)
	if(wCount.len > 0)
		owner.heal_wounds(100) // we're gonna try really hard to heal someone's arterials and also stabilize their blood, so they don't instantly bleed out again. Ideally they should be 'just' alive.
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/atom/movable/screen/alert/status_effect/buff/undermaidenbargainheal
	name = "契约兑现"
	desc = "我的交易正在被兑现......"
	icon_state = "buff"



/atom/movable/screen/alert/status_effect/buff/lesserwolf
	name = "次级狼之祝福"
	desc = "我因掠食者的灌注而膨胀......"
	icon_state = "buff"

/datum/status_effect/buff/lesserwolf
	id = "lesserwolf"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lesserwolf
	duration = 30 MINUTES

/datum/status_effect/buff/lesserwolf/on_apply()
	. = ..()
	to_chat(owner, span_warning("我感觉腿部肌肉绷紧，牙齿变得锋利，我被掠食者的力量灌注。枝叶与灌木仿佛正伸手攫取我的灵魂......"))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	ADD_TRAIT(owner, TRAIT_STRONGBITE, id)

/datum/status_effect/buff/lesserwolf/on_remove()
	. = ..()
	to_chat(owner, span_warning("我感觉 Dendor 的祝福正在离开我的身体......"))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	REMOVE_TRAIT(owner, TRAIT_STRONGBITE, id)

/atom/movable/screen/alert/status_effect/buff/xylix_pratfall
	name = "摔跌祝福"
	desc = "我的身体成了危险的障碍物。"
	icon_state = "buff"

/obj/effect/xylix_pratfall_proxy
	name = ""
	icon = 'icons/mob/mob.dmi'
	icon_state = null
	mouse_opacity = 0
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	invisibility = INVISIBILITY_ABSTRACT

	var/datum/weakref/owner_ref

/obj/effect/xylix_pratfall_proxy/Initialize(mapload, mob/living/_owner)
	. = ..()
	if(istype(_owner))
		owner_ref = WEAKREF(_owner)

/datum/status_effect/buff/xylix_pratfall
	id = "xylix_pratfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_pratfall
	duration = 20 MINUTES

	var/obj/effect/xylix_pratfall_proxy/proxy

/datum/status_effect/buff/xylix_pratfall/on_apply()
	. = ..()

	if(!isliving(owner))
		return

	proxy = new(owner.loc, owner)

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(on_owner_deleted))
	RegisterSignal(proxy, COMSIG_QDELETING, PROC_REF(on_proxy_deleted))

/datum/status_effect/buff/xylix_pratfall/on_remove()
	. = ..()
	cleanup()

/datum/status_effect/buff/xylix_pratfall/proc/on_owner_moved()
	if(proxy && owner)
		proxy.loc = owner.loc

/datum/status_effect/buff/xylix_pratfall/proc/on_owner_deleted()
	cleanup()

/datum/status_effect/buff/xylix_pratfall/proc/on_proxy_deleted()
	proxy = null

/datum/status_effect/buff/xylix_pratfall/proc/cleanup()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(owner, COMSIG_QDELETING)

	QDEL_NULL(proxy)

/obj/effect/xylix_pratfall_proxy/Crossed(atom/movable/AM)
	. = ..()

	if(!isliving(AM))
		return

	var/mob/living/M = owner_ref?.resolve()
	if(!M)
		return

	var/mob/living/L = AM

	if(L.buckled)
		return
	if(L.patron?.type == /datum/patron/divine/xylix)
		return

	var/list/messages = list(
		"[L]本想优雅通过，可[M]显然另有打算！",
		"[L]发现踩在同伴身上可不是什么好主意！",
		"[L]手忙脚乱地挣扎着，因为[M]变成了一个滑溜溜的障碍！",
		"拜[M]的阴险所赐，[L]连路都不会走了！",
		"多亏了[M]，[L]以极不体面的姿势亲吻了地板！"
	)

	L.visible_message(span_warning(pick(messages)))

	var/list/sounds = list(
		'sound/misc/clownedsitcomlaugh1.ogg',
		'sound/misc/clownedsitcomlaugh2.ogg',
		'sound/misc/clownedsitcomlaugh3.ogg'
	)

	playsound(L, pick(sounds), 50, TRUE)

	L.AdjustKnockdown(2)

/datum/status_effect/buff/stagehands_silence
	id = "Stagehand"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stagehands_silence
	duration = 20 MINUTES
	var/speed_bonus_applied = FALSE

/atom/movable/screen/alert/status_effect/buff/stagehands_silence
	name = "舞台之手的寂静"
	desc = "缓者亦疾。我的脚步安静无声，潜行时也能移动得更快。"

/datum/status_effect/buff/stagehands_silence/on_apply()
	. = ..()
	if(owner?.STASPD < 12)
		owner.change_stat(STATKEY_SPD, 1)
		speed_bonus_applied = TRUE
	to_chat(owner, span_warning("我的脚步变得更轻也更安静了。可脑海里的嗡鸣声又是什么......？"))
	// inspired by matthiosmuffle
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "xylixboon")
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, "xylixboon")

/datum/status_effect/buff/stagehands_silence/on_remove()
	. = ..()
	if(speed_bonus_applied)
		owner?.change_stat(STATKEY_SPD, -1)
		speed_bonus_applied = FALSE
	to_chat(owner, span_warning("嗡鸣声平息了。我的脚步又变得吵闹起来。"))
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, "xylixboon")
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, "xylixboon")

/atom/movable/screen/alert/status_effect/buff/pacify
	name = "Eora 的祝福"
	desc = "我感到心轻如羽，所有忧虑都被冲刷而去。"
	icon_state = "buff"

/datum/status_effect/buff/pacify
	id = "pacify"
	alert_type = /atom/movable/screen/alert/status_effect/buff/pacify
	duration = 30 MINUTES

/datum/status_effect/buff/pacify/on_apply()
	. = ..()
	to_chat(owner, span_green("一切感觉都好极了！"))
	owner.add_stress(/datum/stressevent/pacified)
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)
	playsound(owner, 'sound/misc/peacefulwake.ogg', 100, FALSE, -1)

/datum/status_effect/buff/pacify/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的心智又回到自己手中，不再被朦胧的平和所淹没！"))
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)

//A lesser variant of Eoran blessing meant for peacecake consumption.
/atom/movable/screen/alert/status_effect/buff/peacecake
	name = "次级 Eora 祝福"
	desc = "我感到内心轻松了许多，所有忧虑都缓缓散去。"
	icon_state = "buff"

/datum/status_effect/buff/peacecake
	id = "peacecake"
	alert_type = /atom/movable/screen/alert/status_effect/buff/peacecake
	duration = 5 MINUTES

/datum/status_effect/buff/peacecake/on_apply()
	. = ..()
	to_chat(owner, span_green("一切都感觉好多了。"))
	owner.add_stress(/datum/stressevent/pacified)
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)
	playsound(owner, 'sound/misc/peacefulwake.ogg', 100, FALSE, -1)

/datum/status_effect/buff/peacecake/on_remove()
	. = ..()
	to_chat(owner, span_warning("我的心智再次清明，不再被朦胧的平和所笼罩！"))
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)

/datum/status_effect/buff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_arms
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/call_to_arms
	name = "战争号召"
	desc = span_bloody("为荣耀与荣誉而战！")
	icon_state = "call_to_arms"

/datum/status_effect/buff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	name = "屠戮号令"
	desc = span_bloody("羔羊们，走向屠场！")
	icon_state = "call_to_slaughter"

/atom/movable/screen/alert/status_effect/buff/xylix_joy
	name = "戏谑者之乐"
	desc = "欢乐的声音让我充满好运。"
	icon_state = "joy"

/datum/status_effect/buff/xylix_joy
	id = "xylix_joy"
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_joy
	effectedstats = list(STATKEY_LCK = 1)
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/xylix_joy/on_apply()
	. = ..()
	to_chat(owner, span_info("欢乐之声让我充满好运！"))

/datum/status_effect/buff/xylix_joy/on_remove()
	. = ..()
	to_chat(owner, span_info("我的运势恢复正常了。"))

/datum/status_effect/buff/vigorized
	id = "vigorized"
	alert_type = /atom/movable/screen/alert/status_effect/vigorized
	duration = 10 MINUTES
	effectedstats = list(STATKEY_SPD = 1, STATKEY_INT = 1)

/atom/movable/screen/alert/status_effect/vigorized
	name = "活力充盈"
	desc = "我感到体内涌起一股能量，加快了我的速度，也让我的注意力更加集中。"
	icon_state = "drunk"

/datum/status_effect/buff/vigorized/on_apply()
	. = ..()
	to_chat(owner, span_warning("我感到体内涌起一股能量！"))

/datum/status_effect/buff/vigorized/on_remove()
	. = ..()
	to_chat(owner, span_warning("体内涌起的那股能量正在消退......"))

/datum/status_effect/buff/seelie_drugs
	id = "seelie drugs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 2, STATKEY_WIL = 4, STATKEY_SPD = -3)
	duration = 20 SECONDS


/datum/status_effect/buff/clash
	id = "clash"
	duration = 4 SECONDS
	var/dur
	var/sfx_on_apply = 'sound/combat/clash_initiate.ogg'
	var/swingdelay_mod = 5
	alert_type = /atom/movable/screen/alert/status_effect/buff/clash

	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_riposte"
	mob_effect_layer = MOB_EFFECT_LAYER_GUARD

//We have a lot of signals as the ability is meant to be interrupted by or interact with a lot of mechanics.
/datum/status_effect/buff/clash/on_creation(mob/living/new_owner, ...)
	//!Danger! Zone!
	//These signals use OVERRIDES and can OVERLAP with anything else using them.
	//At the moment we have no way of prioritising one signal over the other, it's first-come first-serve. Keep this in mind.
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_attack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_attack))


	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_touch))
	RegisterSignal(new_owner, COMSIG_MOB_ON_KICK, PROC_REF(guard_disrupted))
	RegisterSignal(new_owner, COMSIG_MOB_KICKED, PROC_REF(guard_disrupted))
	RegisterSignal(new_owner, COMSIG_LIVING_ONJUMP, PROC_REF(guard_disrupted))
	RegisterSignal(new_owner, COMSIG_CARBON_SWAPHANDS, PROC_REF(guard_disrupted))
	RegisterSignal(new_owner, COMSIG_ITEM_GUN_PROCESS_FIRE, PROC_REF(guard_disrupted_cheesy))
	RegisterSignal(new_owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(guard_struck_by_projectile))
	RegisterSignal(new_owner, COMSIG_LIVING_IMPACT_ZONE, PROC_REF(guard_struck_by_projectile))
	RegisterSignal(new_owner, COMSIG_LIVING_SWINGDELAY_MOD, PROC_REF(guard_swingdelay_mod))	//I dunno if a signal is better here rather than theoretically cycling through _all_ status effects to apply a var'd swingdelay mod.
	. = ..()

/datum/status_effect/buff/clash/proc/guard_swingdelay_mod()
	return swingdelay_mod

/datum/status_effect/buff/clash/proc/process_touch(mob/living/carbon/human/parent, mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	var/obj/item/I = defender.get_active_held_item()
	defender.process_clash(attacker, I, null)

/datum/status_effect/buff/clash/proc/process_attack(mob/living/parent, mob/living/target, mob/user, obj/item/I)
	var/bad_guard = FALSE
	var/mob/living/U = user
	//We have Guard / Clash active, and are hitting someone who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(U.has_status_effect(/datum/status_effect/buff/clash) && !target.has_status_effect(/datum/status_effect/buff/clash))
		if(user == parent)
			bad_guard = TRUE
	if(ishuman(target) && target.get_active_held_item() && !bad_guard)
		var/mob/living/carbon/human/HM = target
		var/obj/item/IM = target.get_active_held_item()
		var/obj/item/IU
		if(user.used_intent.masteritem)
			IU = user.used_intent.masteritem
		HM.process_clash(user, IM, IU)
		return COMPONENT_NO_ATTACK
	if(bad_guard)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.bad_guard(span_suicide("我明明全神防守，却还试图出手攻击！这让我精力大损！"), cheesy = TRUE)

//Mostly here so the child (limbguard) can have special behaviour.
/datum/status_effect/buff/clash/proc/guard_struck_by_projectile()
	guard_disrupted()

//Our guard was disrupted by normal means.
/datum/status_effect/buff/clash/proc/guard_disrupted()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.bad_guard("My focus was disrupted!")

//We tried to cheese it. Generally reserved for egregious things, like attacking / casting while its active.
/datum/status_effect/buff/clash/proc/guard_disrupted_cheesy()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.bad_guard("My focus was <b>heavily</b> disrupted!")

/datum/status_effect/buff/clash/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	dur = world.time
	var/mob/living/carbon/human/H = owner
	if(sfx_on_apply)
		playsound(H, sfx_on_apply, 100, TRUE)

/datum/status_effect/buff/clash/tick()
	if(!owner.get_active_held_item() || !(owner.mobility_flags & MOBILITY_STAND))
		var/mob/living/carbon/human/H = owner
		H.bad_guard()

/datum/status_effect/buff/clash/on_remove()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/debuff/clashcd)
	var/newdur = world.time - dur
	var/mob/living/carbon/human/H = owner
	if(newdur > (initial(duration) - 0.2 SECONDS))	//Not checking exact duration to account for lag and any other tick / timing inconsistencies.
		H.bad_guard(span_warning("我维持专注太久了，结果把自己耗空了。"))
	UnregisterSignal(owner, COMSIG_ATOM_BULLET_ACT)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ON_KICK)
	UnregisterSignal(owner, COMSIG_MOB_KICKED)
	UnregisterSignal(owner, COMSIG_ITEM_GUN_PROCESS_FIRE)
	UnregisterSignal(owner, COMSIG_CARBON_SWAPHANDS)
	UnregisterSignal(owner, COMSIG_LIVING_IMPACT_ZONE)
	UnregisterSignal(owner, COMSIG_LIVING_ONJUMP)
	UnregisterSignal(owner, COMSIG_LIVING_SWINGDELAY_MOD)

/atom/movable/screen/alert/status_effect/buff/clash
	name = "准备招架"
	desc = span_notice("我已架好防势，准备招架。若我被击中，我将成功防住；但若我主动攻击，就会失去专注。")
	icon_state = "clash"

#define BLOODRAGE_FILTER "bloodrage"

/atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	name = "血怒"
	desc = "GRAGGAR！GRAGGAR！GRAGGAR！"
	icon_state = "bloodrage"

/datum/status_effect/buff/bloodrage
	id = "bloodrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	var/outline_color = "#ad0202"
	duration = 15 SECONDS

/datum/status_effect/buff/bloodrage/on_apply()
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	var/holyskill = owner.get_skill_level(/datum/skill/magic/holy)
	duration = ((15 SECONDS) * holyskill)
	var/filter = owner.get_filter(BLOODRAGE_FILTER)
	if(!filter)
		owner.add_filter(BLOODRAGE_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 60, "size" = 2))
	if(!HAS_TRAIT(owner, TRAIT_DODGEEXPERT))
		if(owner.STASTR < STRENGTH_SOFTCAP)
			effectedstats = list(STATKEY_STR = (STRENGTH_SOFTCAP - owner.STASTR))
			. = ..()
			return TRUE
	if(holyskill >= SKILL_LEVEL_APPRENTICE)
		effectedstats = list(STATKEY_STR = 2)
	else
		effectedstats = list(STATKEY_STR = 1)
	. = ..()
	return TRUE

/datum/status_effect/buff/bloodrage/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	owner.visible_message(span_warning("[owner]身形摇晃，沸腾的怒火渐渐平息。"))
	owner.OffBalance(3 SECONDS)
	owner.remove_filter(BLOODRAGE_FILTER)
	owner.emote("breathgasp", forced = TRUE)
	owner.Slowdown(3)

/datum/status_effect/buff/psydonic_endurance
	id = "psydonic_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)

/atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	name = "Psydonic 坚忍"
	desc = "我受到受祝 Psydonian 板甲的保护。"
	icon_state = "buff"

#undef BLOODRAGE_FILTER

#define EORANAURA_FILTER "eoranaura"

/datum/status_effect/eoranaura
	id = "eoranaura"
	var/outline_colour = "#EEBBBB"
	duration = -1
	tick_interval = -1
	examine_text = span_good("SUBJECTPRONOUN 沐浴在 Eora 的圣光之中！")
	alert_type = null

/datum/status_effect/eoranaura/on_apply()
	. = ..()

	owner.visible_message(span_userdanger("Eora 的光潮自[owner]身上奔涌而出，使你心中充满平和与希望！"))

	var/mutable_appearance/effect = mutable_appearance('icons/effects/effects.dmi', "curse", -JOYBRINGER_LAYER, alpha = 128)
	effect.appearance_flags = RESET_COLOR
	effect.blend_mode = BLEND_ADD
	effect.color = "#EEBBBB"

	owner.overlays_standing[EORANAURA_FILTER] = effect
	owner.apply_overlay(EORANAURA_FILTER)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/status_effect/eoranaura/on_remove()
	. = ..()

	owner.remove_overlay(EORANAURA_FILTER)

	UnregisterSignal(owner, COMSIG_LIVING_LIFE)

/datum/status_effect/eoranaura/proc/on_life()
	SIGNAL_HANDLER

	for(var/mob/living/mob in get_hearers_in_view(2, owner))
		if(HAS_TRAIT(mob, TRAIT_PSYDONITE))
			continue

		mob.apply_status_effect(/datum/status_effect/eora_blessing)
		mob.apply_status_effect(/datum/status_effect/buff/recuperation/eoran)

#undef EORANAURA_FILTER

/atom/movable/screen/alert/status_effect/buff/recuperation
	name = "休养"
	desc = "我的伤痛得到了片刻喘息。"
	icon_state = "recuperation"

#define RECUPERATION_BASE_FILTER "recuperation"

/datum/status_effect/buff/recuperation
	id = "recuperation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/recuperation
	duration = 5 SECONDS
	var/healing_on_tick = 5
	var/outline_colour = "#2e8d8d"

/datum/status_effect/buff/recuperation/eoran
	duration = 1 MINUTES
	healing_on_tick = 3
	outline_colour = "#EEBBBB"

/datum/status_effect/buff/recuperation/on_apply()
	var/filter = owner.get_filter(RECUPERATION_BASE_FILTER)
	if (!filter)
		owner.add_filter(RECUPERATION_BASE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 90, "size" = 1))
	return TRUE

/datum/status_effect/buff/recuperation/tick()
	if(owner.construct)
		return
	var/stamheal = healing_on_tick
	if(!owner.cmode)
		stamheal *= 2
	owner.energy_add(stamheal)

/datum/status_effect/buff/recuperation/on_remove()
	owner.remove_filter(RECUPERATION_BASE_FILTER)

#undef RECUPERATION_BASE_FILTER

/datum/status_effect/buff/sermon
	id = "sermon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sermon
	effectedstats = list(STATKEY_LCK = 1, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_INT = 2)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/sermon
	name = "布道"
	desc = "我因这场布道而深受鼓舞！"
	icon_state = "buff"

/datum/status_effect/buff/griefflower
	id = "griefflower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/griefflower
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)

/datum/status_effect/buff/griefflower/on_apply()
	. = ..()
	to_chat(owner, span_notice("Rosa 之环会见血，但真正伤人的却是那些回忆。一次又一次的失败像向内盛开的荆棘般穿透着你。"))
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_STATUS_EFFECT)

/datum/status_effect/buff/griefflower/on_remove()
	. = ..()
	to_chat(owner, span_notice("你脱离了 Rosa 的触碰，疼痛也随之退去......"))
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_STATUS_EFFECT)

/atom/movable/screen/alert/status_effect/buff/griefflower
	name = "Rosa 之环"
	desc = "Rosa 之环会见血，但真正伤人的却是那些回忆。一次又一次的失败像向内盛开的荆棘般穿透着你。"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	name = "肾上腺冲击"
	desc = "这一搏成功了！我无所不能！心跳如擂，伤口的抽痛都变得模糊。"
	icon_state = "adrrush"

/datum/status_effect/buff/adrenaline_rush
	id = "adrrush"
	alert_type = /atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	duration = 18 SECONDS
	examine_text = "SUBJECTPRONOUN 情绪高涨！"
	effectedstats = list(STATKEY_WIL = 1)
	var/blood_restore = 30

/datum/status_effect/buff/adrenaline_rush/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.dna?.species?.type == /datum/species/gnoll)
			return FALSE
	. = ..()
	ADD_TRAIT(owner, TRAIT_ADRENALINE_RUSH, INNATE_TRAIT)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.playsound_local(get_turf(H), 'sound/misc/adrenaline_rush.ogg', 100, TRUE)
		H.blood_volume = min((H.blood_volume + blood_restore), BLOOD_VOLUME_NORMAL)
		H.stamina -= max((H.stamina - (H.max_stamina / 2)), 0)

/datum/status_effect/buff/adrenaline_rush/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ADRENALINE_RUSH, INNATE_TRAIT)

/datum/status_effect/buff/magicknowledge
	id = "intelligence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/knowledge
	effectedstats = list("intelligence" = 2)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/knowledge
	name = "符文机敏"
	desc = "我因魔法而思维敏锐。"
	icon_state = "buff"

/datum/status_effect/buff/magicstrength
	id = "strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength
	effectedstats = list("strength" = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/strength
	name = "奥术强化之力"
	desc = "我的力量被魔法强化了。"
	icon_state = "buff"

/datum/status_effect/buff/magicstrength/lesser
	id = "lesser strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength/lesser
	effectedstats = list("strength" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/strength/lesser
	name = "次级奥术之力"
	desc = "我的力量被魔法强化了。"
	icon_state = "buff"


/datum/status_effect/buff/magicspeed
	id = "speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed
	effectedstats = list("speed" = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/speed
	name = "奥术迅捷"
	desc = "我的速度被魔法强化了。"
	icon_state = "buff"

/datum/status_effect/buff/magicspeed/lesser
	id = "lesser speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed/lesser
	effectedstats = list("speed" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/speed/lesser
	name = "奥术迅捷"
	desc = "我的速度被魔法强化了。"
	icon_state = "buff"

/datum/status_effect/buff/magicwillpower
	id = "willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/willpower
	effectedstats = list("willpower" = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/willpower
	name = "奥术意志"
	desc = "我因魔法而更坚韧。"
	icon_state = "buff"

/datum/status_effect/buff/magicwillpower/lesser
	id = "lesser willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/willpower/lesser
	effectedstats = list("willpower" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/willpower/lesser
	name = "次级奥术意志"
	desc = "我因魔法而更坚韧。"
	icon_state = "buff"


/datum/status_effect/buff/magicconstitution
	id = "constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/constitution
	effectedstats = list("constitution" = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/constitution
	name = "奥术体魄"
	desc = "我感觉自己被魔力强化了。"
	icon_state = "buff"

/datum/status_effect/buff/magicconstitution/lesser
	id = "lesser constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/constitution/lesser
	effectedstats = list("constitution" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/constitution/lesser
	name = "次级奥术体魄"
	desc = "我感觉自己被魔力强化了。"
	icon_state = "buff"

/datum/status_effect/buff/magicperception
	id = "perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception
	effectedstats = list("perception" = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/perception
	name = "奥术感知"
	desc = "我仿佛能看见一切。"
	icon_state = "buff"

/datum/status_effect/buff/magicperception/lesser
	id = "lesser perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception/lesser
	effectedstats = list("perception" = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/perception/lesser
	name = "次级奥术感知"
	desc = "我能看见更多东西。"
	icon_state = "buff"

/datum/status_effect/buff/nocblessing
	id = "nocblessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocblessing
	effectedstats = list("intelligence" = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/nocblessing
	name = "Noc 的祝福"
	desc = "仰望 Noc 让我思绪更清晰。"
	icon_state = "buff"
/datum/status_effect/buff/goodloving
	id = "Good Loving"
	alert_type = /atom/movable/screen/alert/status_effect/buff/goodloving
	effectedstats = list("fortune" = 2)
	duration = 60 MINUTES //Note, you can only benefit from this buff ONCE

/atom/movable/screen/alert/status_effect/buff/goodloving
	name = "美妙欢爱"
	desc = "一场美妙的欢爱让我感觉自己好运非常。"
	icon_state = "stressg"

/datum/status_effect/buff/massage
	id = "massage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/massage
	effectedstats = list(STATKEY_CON = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/massage
	name = "按摩"
	desc = "我的肌肉放松了"
	icon_state = "buff"

/datum/status_effect/buff/goodmassage
	id = "goodmassage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/goodmassage
	effectedstats = list(STATKEY_CON = 1, STATKEY_SPD = 1, STATKEY_STR = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/goodmassage
	name = "优质按摩"
	desc = "我的肌肉放松了，感觉比之前更好"
	icon_state = "buff"

/datum/status_effect/buff/greatmassage
	id = "greatmassage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatmassage
	effectedstats = list(STATKEY_CON = 2, STATKEY_SPD = 1, STATKEY_STR = 1, STATKEY_LCK =1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatmassage
	name = "极佳按摩"
	desc = "我的身体前所未有地舒畅！"
	icon_state = "buff"


/datum/status_effect/buff/refocus
	id = "refocus"
	alert_type = /atom/movable/screen/alert/status_effect/buff/refocus
	effectedstats = list(STATKEY_INT = 2, STATKEY_WIL = -1)
	duration = 15 MINUTES

/atom/movable/screen/alert/status_effect/buff/refocus
	name = "重新聚焦"
	desc = "我牺牲了一部分所学，好让自己能学会新的东西"
	icon_state = "buff"


/datum/status_effect/buff/celerity
	id = "celerity"
	alert_type = /atom/movable/screen/alert/status_effect/buff
	effectedstats = list(STATKEY_SPD = 1)
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/celerity/New(list/arguments)
	effectedstats[STATKEY_SPD] = arguments[2]
	. = ..()

/datum/status_effect/buff/fotv
	id = "fotv"
	alert_type = /atom/movable/screen/alert/status_effect/buff
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 1, STATKEY_CON = 1)
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/oath_ring
	id = "oath_ring_buff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/oath_ring
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 1)

/atom/movable/screen/alert/status_effect/buff/oath_ring
	name = "誓印加身"
	desc = "只要这份提醒仍在身边，誓言就会推动我前进。"
