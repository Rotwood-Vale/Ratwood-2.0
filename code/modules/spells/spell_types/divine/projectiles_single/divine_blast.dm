/obj/effect/proc_holder/spell/invoked/projectile/divineblast
	name = "神圣冲击"
	desc = "射出一道神圣之力的冲击！对异端（普赛顿信徒/异民）与亡灵造成更高伤害！ \n\
	对心智简单的生物伤害提高 100%。\n\
	若持法师长杖、法术书或 普赛圣十字 并使用弧射意图，可越过盟友头顶抛射，但那样会少造成 25% 伤害。"
	clothes_req = FALSE
	range = 12
	projectile_type = /obj/projectile/energy/divineblast
	overlay_state = "divine_blast"
	sound = list('sound/magic/vlightning.ogg')
	active = FALSE
	releasedrain = 20
	chargedrain = 1
	chargetime = 0
	recharge_time = 5 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	invocations = list("神威，降下！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/projectile/divineblast/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/energy/divineblast/arc
	else
		projectile_type = /obj/projectile/energy/divineblast
	. = ..()


/obj/projectile/energy/divineblast
	name = "神圣冲击"
	icon_state = "divine_blast"
	damage = 20 // wont do much to a divine worshipper
	woundclass = BCLASS_STAB // divine blade!
	nodamage = FALSE
	npc_simple_damage_mult = 2 // The Simple Skele Gibber
	hitsound = 'sound/magic/churn.ogg'
	speed = 1

/obj/projectile/energy/divineblast/arc
	name = "弧射神圣冲击"
	damage = 15 // Slightly lower base damage and barely matter due to low to hit but not a problem on acolyte / cleric.
	arcshot = TRUE

/obj/projectile/energy/divineblast/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/H = target
		if((H.job in list("Templar", "Acolyte", "Bishop", "Martyr")))
			visible_message(span_warning("[src]的神力掠过[H]，却未造成任何伤害！"))
			playsound(get_turf(H), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(H.mob_biotypes & MOB_UNDEAD)
			damage += 20
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.patron, /datum/patron/divine))
			if(H in GLOB.excommunicated_players)
				damage += 20
		if(istype(H.patron, /datum/patron/inhumen))
			damage += 20
		if(istype(H.patron, /datum/patron/old_god))
			damage += 20
		if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			H.visible_message("<font color='white'>这记亵渎之击暂时削弱了诅咒！</font>")
			to_chat(H, span_userdanger("银之力在排斥我的存在！我的血髓灼烧不止，力量也在衰退！"))
			H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder)
		var/mob/living/carbon/human/caster
		if (ishuman(firer))
			caster = firer
			switch(caster.patron.type)
				if(/datum/patron/divine/astrata)
					H.adjust_fire_stacks(2)
					H.ignite_mob()
				if(/datum/patron/divine/abyssor)
					H.visible_message(span_warning("水从[H]的唇间渗出！"), span_warning("肺里灌满了呛人的水！"))
					H.Dizzy(5)
					H.emote("drown")
				if(/datum/patron/divine/dendor)
					H.Slowdown(2) // Shared with Ravox cuz immobilize + offbal is 2 strong
					H.visible_message(span_warning("根须缠上了[H]的双腿！"), span_warning("根须缠住了我的双腿！"))
				if(/datum/patron/divine/necra)
					if(H.mob_biotypes & MOB_UNDEAD)
						H.adjust_fire_stacks(4)
						H.ignite_mob()
				if(/datum/patron/divine/pestra)
					H.vomit(stun = 0)
					H.adjustToxLoss(10)
					H.visible_message(span_warning("[H]从体内呕出了几条水蛭！"), span_warning("有什么东西正在我体内翻腾！"))
					new /obj/item/natural/worms/leech(get_turf(H))
				if(/datum/patron/divine/eora)
					H.blur_eyes(10)
				if(/datum/patron/divine/noc)
					H.visible_message(span_warning("月光吞没了[H]！"), span_warning("月光吞没了我！"))
					for(var/obj/O in range(0, H))
						O.extinguish()
					for(var/mob/M in range(0, H)) // extinguish lights of target(zizo snuff pretty much but range 0 always)
						for(var/obj/O in M.contents)
							O.extinguish()
				if(/datum/patron/divine/ravox)
					H.Slowdown(2)
				if(/datum/patron/divine/malum)
					H.adjustFireLoss(10)
					H.visible_message(span_warning("灼鸣的火舌舔舐着[H]！"), span_warning("玛勒姆的熔炉正在炙烤我！"))
	else
		return


