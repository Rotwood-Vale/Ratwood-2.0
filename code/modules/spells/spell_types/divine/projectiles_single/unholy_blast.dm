/obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast
	name = "亵渎冲击"
	desc = "引导亵渎之力，摧裂不信者。对可悲的顺从者与 普赛顿 信徒会造成额外伤害！\n\
	对头脑简单的生物伤害提高 100%。\n\
	若使用法师杖、法术书或 普赛圣十字 并切换为弧射意图，还能越过盟友头顶以弧线射出；但那样会少造成 25% 伤害。"
	projectile_type = /obj/projectile/energy/unholyblast
	invocations = list("亵渎，迸发！")

/obj/projectile/energy/unholyblast
	name = "Unholy Blast"
	icon_state = "divine_blast"
	damage = 20 // wont do much to a heretical worshipper
	woundclass = BCLASS_CUT // I REALLY wanted to do cut
	nodamage = FALSE
	npc_simple_damage_mult = 2 // The Simple Skele Gibber
	hitsound = 'sound/magic/churn.ogg'
	speed = 1

/obj/projectile/energy/unholyblast/arc
	name = "弧射亵渎冲击"
	damage = 15 // Slightly lower base damage
	arcshot = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/divineblast/unholyblast/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/energy/unholyblast/arc
	else
		projectile_type = /obj/projectile/energy/unholyblast
	. = ..()

/obj/projectile/energy/unholyblast/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/H = target
		if(H.mob_biotypes & MOB_UNDEAD)
			damage += 20
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.patron, /datum/patron/divine))
			damage += 20
		if(istype(H.patron, /datum/patron/old_god))
			damage += 20
		if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			H.visible_message("<font color='white'>这道亵渎打击暂时削弱了诅咒！</font>")
			to_chat(H, span_userdanger("白银正在斥退我的存在！我的血性在灼烧，力量也在衰退！"))
			H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder)
		var/mob/living/carbon/human/caster
		if (ishuman(firer))
			caster = firer
			switch(caster.patron.type)
				if(/datum/patron/inhumen/baotha)
					H.adjustToxLoss(10)
					H.Dizzy(5)
				if(/datum/patron/inhumen/matthios)
					if(HAS_TRAIT(H, TRAIT_NOBLE))
						damage += 10 
						H.adjust_fire_stacks(4)
					H.adjust_fire_stacks(2)
					H.ignite_mob()
				if(/datum/patron/inhumen/graggar)
					H.visible_message(span_warning("一片血污泼了 [H] 满脸！"), span_warning("一团血沫糊住了我的视野！"))
					H.Dizzy(5)
					H.blur_eyes(5)
				if(/datum/patron/inhumen/zizo)
					if(istype(H.patron, /datum/patron/divine/necra)) //Hilarious
						H.adjust_fire_stacks(6)
						H.ignite_mob()
					H.Slowdown(3) 
					H.visible_message(span_warning("炽沸的野心正灼烧着 [H] 的脑海！"), span_warning("野心的幻景正灼烧着我的脑海！"))
	else
		return



