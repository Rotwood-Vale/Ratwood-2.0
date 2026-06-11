/obj/effect/proc_holder/spell/invoked/conjure_primordial
	name = "唤生元初灵"
	desc = "消耗一把火、水或风的精质，并召出对应类型的元初灵。\n\
	这道法术无法返还。"
	clothes_req = FALSE
	overlay_state = "rune0"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	refundable = FALSE
	cost = 4
	spell_tier = 3 // Mage tier
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 45 SECONDS
	hide_charge_effect = TRUE
	var/list/conjured_mobs = list()
	var/spellsgranted = FALSE
/obj/effect/proc_holder/spell/invoked/conjure_primordial/cast(list/targets, mob/living/user)
	. = ..()
	if(length(conjured_mobs) >= 2)
		to_chat(user, span_warning("我不可能再分神维持更多元初灵了！"))
		revert_cast()
		return
	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("目标地点被阻挡了。我的召唤无法显现。"))
		revert_cast()
		return

	var/obj/item/sacrifice
	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/alch/waterdust)||istype(I, /obj/item/alch/airdust)|| istype(I, /obj/item/alch/firedust))
			sacrifice = I
			break

	if(!sacrifice)
		to_chat(user, span_warning("我需要在空着的手里握有一些精质。"))
		revert_cast()
		return
	if(!spellsgranted)
		var/obj/effect/proc_holder/spell/primordial_order = new /obj/effect/proc_holder/spell/invoked/minion_order/primordial
		var/obj/effect/proc_holder/spell/primordialmark = new /obj/effect/proc_holder/spell/invoked/primordialmark
		user.mind.AddSpell(primordial_order )
		user.mind.AddSpell(primordialmark)
		spellsgranted = TRUE
	if(!("[user.mind.current.real_name]_faction" in user.mind.current.faction))
		user.mind.current.faction |= "[user.mind.current.real_name]_faction"

	var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/conjured
	switch(sacrifice.type)
		if(/obj/item/alch/waterdust)
			conjured = new /mob/living/simple_animal/hostile/retaliate/rogue/primordial/water(T,user)
		if(/obj/item/alch/firedust)
			conjured = new /mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire(T, user)
		if(/obj/item/alch/airdust)
			conjured = new /mob/living/simple_animal/hostile/retaliate/rogue/primordial/air(T, user)
	conjured_mobs += conjured
	RegisterSignal(conjured, COMSIG_QDELETING, PROC_REF(remove_conjure), conjured)

	qdel(sacrifice)
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_primordial/proc/remove_conjure(mob/living/simple_animal/hostile/retaliate/rogue/primordial/conjured)
	if(conjured in conjured_mobs)
		conjured_mobs -= conjured

/obj/effect/proc_holder/spell/invoked/minion_order/primordial
	name = "号令元初灵"
	refundable = FALSE
/obj/effect/proc_holder/spell/invoked/primordialmark
	name = "元初印记"
	desc = "对地面施放可激活附近元初灵的特殊能力；对其他目标施放可将其标记为元初灵的友方，或移除其已有标记。"
	overlay_state = "primetriangle"
	refundable = FALSE
	range = 7
	warnie = "primetriangle"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/primordialmark/cast(list/targets, mob/living/user)
	. = ..()
	var/faction_tag = "[user.mind.current.real_name]_faction"
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if (target == user)
			to_chat(user, span_warning("把自己的元初灵变成敌人可不是什么明智之举。"))
			return FALSE
		if(target.mind && target.mind.current)
			if (faction_tag in target.mind.current.faction)
				target.mind.current.faction -= faction_tag
				user.say("我已宣你为敌。")
			else
				target.mind.current.faction += faction_tag
				user.say("我已宣你为友。")
				target.notify_faction_change()
		else if(istype(target, /mob/living/simple_animal))
			if (faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("我已宣你为敌。")
			else
				target.faction |= faction_tag
				user.say("我已宣你为友。")
				target.notify_faction_change()
		return TRUE
	else if(isturf(targets[1]))
		var/turf/T = get_turf(targets[1])
		for(var/mob/living/simple_animal/hostile/retaliate/rogue/primordial/primordial in oview(3, T))
			if(faction_tag in primordial.faction)
				to_chat(user,"[primordial.name] 会将能力集中施放在被标记的地块上！")
				primordial.ability(T, user)
	return FALSE
