// T1: (fires a bone splinter at a target for brute and bleeding if you're not holding bones in your other hand, fires a significantly stronger bone lance if you are)

/obj/effect/proc_holder/spell/invoked/projectile/profane
	name = "渎骨"
	desc = "射出一枚不洁骨刺，撕裂血肉并造成流血。若你的另一只手握着骨片，便能诱导出威力强得多的骨矛。"
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "profane"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Oblino!")
	invocation_type = "whisper"
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	hide_charge_effect = TRUE // Left handed magick babe

/obj/effect/proc_holder/spell/invoked/projectile/profane/miracle
	miracle = TRUE
	devotion_cost = 15
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/profane/fire_projectile(mob/living/user, atom/target)
	current_amount--

	var/obj/item/held_item = user.get_active_held_item()
	var/big_cast = FALSE
	if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if (bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/boney_bundle = held_item
		if (boney_bundle.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE

	var/obj/projectile/P = new projectile_type(user.loc)
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

	if (big_cast)
		user.visible_message(span_danger("[user]凝出一支凶恶骨矛，朝[target]猛然掷去！"), span_notice("我朝[target]掷出了一支凶恶的渎化骨矛！"))
	else
		user.visible_message(span_danger("[user]朝[target]射出了一枚骨刺！"), span_notice("我朝[target]掷出了一枚渎化骨片！"))

	projectile_type = initial(projectile_type)

/obj/projectile/magic/profane
	name = "渎化骨刺"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	var/embed_prob = 10

/obj/projectile/magic/profane/major
	name = "渎化骨矛"
	damage = 35
	embed_prob = 30

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if (iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter
	name = "骨刺"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src]碎成了尘埃......"))
	qdel(src)

// T2: just use lesser animate undead for now

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	miracle = TRUE
	devotion_cost = 75
	cabal_affine = TRUE
	to_spawn = 2

// T3: tames bio_type = undead mobs

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	miracle = TRUE
	devotion_cost = 100

// T3: Rituos (usable once per sleep cycle, allows you to choose any 1 arcane spell to use for the duration w/ an associated devotion cost. each time you change it, 1 of your limbs is skeletonized, if all of your limbs are skeletonized, you gain access to arcane magic. continuing to use rituos after being fully skeletonized gives you additional spellpoints). Gives you the MOB_UNDEAD flag (needed for skeletonize to work) on first use.

/obj/effect/proc_holder/spell/invoked/rituos
	name = "仪式术"
	desc = "为齐佐女士举行一道仪式，将你身体的一部分化为骸骨，并在你下次睡眠前赐予你奥术魔法。一旦你的全身都化为骸骨，你便可获得完整的奥术通行权，而每一次额外仪式都会继续增强你的法术知识。"
	clothes_req = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 2 MINUTES
	hide_charge_effect = TRUE
	/// List of limbs that don't get skeletonized. Chest has special handling once you are at that point
	var/static/list/excluded_bodyparts = list(/obj/item/bodypart/head, /obj/item/bodypart/chest)
	/// How many times Rituos has been casted
	var/rituos_counter = 0

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/user)
	. = ..()
	if(!user || !user.mind)
		return FALSE

	if(user.mind.has_rituos)
		to_chat(user, span_warning("我已没有足够的心智再度施行这道小业。必须先休息......"))
		return FALSE

	// Find a bodypart to skeletonize
	var/list/potential_bodypart = list()
	for(var/obj/item/bodypart/limb as anything in user.bodyparts)
		if(limb.type in excluded_bodyparts)
			continue
		if(limb.skeletonized)
			continue
		potential_bodypart += limb

	if(!length(potential_bodypart) && rituos_counter < 4)
		to_chat(user, span_warning("我已经没有可献给仪式的肢体了！"))
		return FALSE

	var/obj/item/bodypart/part_to_bonify
	if(rituos_counter == 4)
		part_to_bonify = locate(/obj/item/bodypart/chest) in user.bodyparts
	else
		part_to_bonify = pick(potential_bodypart)

	if(!part_to_bonify)
		to_chat(user, span_warning("我已经没有可献给仪式的肢体了！"))
		return FALSE

	if(!(user.mob_biotypes & MOB_UNDEAD))
		user.visible_message(span_warning("墓地般的苍白随着一波奥术能量覆上了[user]的肌肤......"), span_boldwarning("当我第一次完成“小业”时，一股死寂的寒意吞没了我的身体！我能感觉到心脏在胸腔中慢了下来......"))
		user.mob_biotypes |= MOB_UNDEAD
		to_chat(user, span_smallred("我已背弃生者。如今的我更接近死灵，而非凡人......但我仍会呼吸，也仍会流血。"))

	part_to_bonify.skeletonize(FALSE)
	user.update_body_parts()
	user.visible_message(span_warning("微弱的符文在[user]皮肤下闪烁，随后[user.p_their()] [part_to_bonify.name]上的血肉骤然从骨头上滑落！"), span_notice("我感到奥术力量在这脆弱的凡躯中奔涌，而Rituos正从我的[part_to_bonify.name]上索取它可怖的代价。"))

	user.mind.has_rituos = TRUE
	rituos_counter++
	switch(rituos_counter)
		if(1)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			ADD_TRAIT(user, TRAIT_ARCYNE_T3, "[type]")
			user.mind?.adjust_spellpoints(3)
		if(2,4)
			user.mind?.adjust_spellpoints(3)
		if(3)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			user.mind?.adjust_spellpoints(3)
		if(5)
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			user.grant_language(/datum/language/undead)
			user.mind?.adjust_spellpoints(6)
			user.visible_message(span_boldwarning("[user]的形体随着可怖力量一同膨胀，几乎将所有残余凡肉尽数抛弃，裸露的骨骼上闪烁着奥术符文......"), span_notice("我做到了！我完成了她的“小业”！我已站在难以言喻的力量边缘，可似乎仍少了些什么......"))
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
			ADD_TRAIT(user, TRAIT_OVERTHERETIC, "[type]")
			if(prob(33))
				to_chat(user, span_small("......我都做了什么？"))
			user.mind?.RemoveSpell(src)

// T3 Lacrima (plunge your hand into someone's ribs to rip out their impure lux for your diabolical uses)

/obj/effect/proc_holder/spell/targeted/touch/lacrima
	name = "泪痕"
	desc = "让你的手缠绕上异端能量。\n \
	以“使用”对仍活着、倒地且灵辉完好的心智生灵施放，将手刺入其胸膛，粉碎其肋骨与意志，强行把灵辉从胸中扯出。\n \
	以“缴械”对纯净灵辉施放，可将其转化为污秽灵辉，以夺走他人所需之物，或为你邪恶的死灵遗物充能。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "lacrima"
	clothes_req = FALSE
	drawmessage = "我向ZIZO祈求一缕她的力量，让异端能量缠上我的手掌！"
	dropmessage = "我让手上的能量缓缓散去。"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 0
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/lacrima

/obj/effect/proc_holder/spell/targeted/touch/lacrima/free
	miracle = FALSE

/obj/item/melee/touch_attack/lacrima
	name = "\improper 灵辉裂割器"
	desc = "齐佐的意志，就是扭曲生者的灵辉。凭借她赐下的一缕微力，你便能做到这一点。"
	catchphrase = null
	possible_item_intents = list(/datum/intent/use, INTENT_DISARM)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#ff0000"
	associated_skill = /datum/skill/magic/holy

/obj/item/melee/touch_attack/lacrima/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/lacrima/afterattack(mob/living/carbon/human/target, mob/living/carbon/human/user, proximity)
	switch(user.used_intent.type)
		if(/datum/intent/use)
			lux_rip(target, user)
		if(INTENT_DISARM)
			if(istype(target, /obj/item/reagent_containers/lux))
				perverse_lux(target, user)
			else
				to_chat(user, span_info("那不是纯净灵辉。"))

/obj/item/melee/touch_attack/lacrima/proc/lux_rip(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 100
	var/tear_time = 50

	if(target == user)
		to_chat(user, span_alert("我不该把自己的灵辉扯出来！那玩意我还得用。"))
		return
	if(!target.mind)
		to_chat(user, span_info("此人的灵辉太过微弱，不足以提取。我需要一个意识更完整的受害者！"))
		return
	if(target.stat == DEAD || !isliving(target))
		to_chat(user, span_info("只有活着的生物才能被扯出灵辉。"))
		return
	if(!target.Adjacent(user))
		to_chat(user, span_info("我得站到[target]身旁，才能扯出其灵辉。"))
		return
	if((target.mobility_flags & MOBILITY_STAND))
		to_chat(user, span_info("目标必须倒在地上，我才能扯出他们的灵辉。"))
		return
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || (target.has_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped) || target.mob_biotypes & MOB_UNDEAD)) //can't farm your skeletons
		to_chat(user, span_notice("此人的灵辉已经被扰乱了！"))
		return
	else
		to_chat(user, span_alert("我开始把手伸向[target]，准备将其灵辉从体内扯出......"))
		user.visible_message(span_alert("[user]将手探向[target]的胸膛，[user.p_their()]的手被异端火焰缠绕着......"))
	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return
		if(chest)
			if(!HAS_TRAIT(target, TRAIT_NOPAIN))
				target.emote("painscream")
			target.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
			user.visible_message(span_alert("[user]将拳头猛地刺入[target]的胸腔，惊人地穿过了肋骨！"))
	if(!do_after(user, tear_time, target = target))
		return
	if(!HAS_TRAIT(target, TRAIT_NOPAIN))
		target.emote("painscream")
		target.add_stress(/datum/stressevent/myfuckingluxman)
	playsound(src, 'sound/items/blackmirror_needle.ogg', 60, FALSE, 3)
	user.visible_message(span_alert("[user]从[target]胸中硬生生扯出了一团灵辉！"))
	new /obj/item/reagent_containers/lux_impure(target.loc)
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised/lux_ripped) // -5 omnistat. prevents harvesting lux again for much longer than regular devitalised
	qdel(src)

/datum/stressevent/myfuckingluxman
	desc = span_boldred("我生命的本质被玷污了！！")
	stressadd = 30
	timer = 15 MINUTES

/obj/item/melee/touch_attack/lacrima/proc/perverse_lux(atom/target, mob/living/carbon/human/user)
	var/perverse_time = 20

	if(!target.Adjacent(user))
		to_chat(user, span_info("我得再靠近些。"))
		return
	to_chat(user, span_alert("我开始在手中揉塑[target]，用异端能量将其扭曲......"))
	if(!do_after(user, perverse_time, target = target))
		return
	else
		qdel(target)
		qdel(src)
		user.put_in_hands(new /obj/item/reagent_containers/lux_impure, forced = TRUE)

/obj/effect/proc_holder/spell/self/zizo_snuff
	name = "熄灯"
	desc = "熄灭范围内的所有光源；你的神迹技能越高，范围越大。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "snuff_lights"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("拥抱黑暗吧！")
	invocation_type = "shout"
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 30
	range = 2

/obj/effect/proc_holder/spell/self/zizo_snuff/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/checkrange = (range + user.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/obj/O in range(checkrange, user))
		O.extinguish()
	for(var/mob/M in range(checkrange, user))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE

// Ancient Champion-exclusive: A non-miracle variant of Snuff Lights with a fixed range of 7 and much longer CD.
/obj/effect/proc_holder/spell/self/zizo_snuff/champion
	invocations = list("Mat shal ukhadowuk!")
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 60 SECONDS
	miracle = FALSE
	devotion cost = 0
	range = 7

// Ancient Champion-exclusive: An evil variant of Repulse. Longer charge time and CD, but greater maxthrow, push range and the affected people lose 50 stamina. The undead are immune.
/obj/effect/proc_holder/spell/invoked/churnliving //Repulse variant.
	name = "翻搅生者"
	desc = "唤出一股死灵能量波，将你周围的非不死者击退，并重创其体力。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "churn_living"
	xp_gain = FALSE
	zizo_spell = TRUE
	releasedrain = 50
	chargedrain = 1
	chargetime = 20 //Four times longer charge.
	recharge_time = 40 SECONDS //15 seconds longer CD.
	human_req = TRUE
	ignore_los = TRUE
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokeascendant
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Irzkrat, nullak!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	var/maxthrow = 4 //1 tile more.
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 2 //1 tile more.

/obj/effect/proc_holder/spell/invoked/churnliving/cast(list/targets, mob/user, stun_amt = 5)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
	for(var/turf/T in view(push_range, user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		if(isliving(AM))
			var/mob/living/M = AM
			if(M.mob_biotypes & MOB_UNDEAD)
				continue

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				M.adjustBruteLoss(20)
				M.stamina_add(50) //50 stamina drain, x2 of Frostbolt's. The spell is very telegraphed.
				to_chat(M, "<span class='danger'>你被[user]狠狠砸在地上！你感到一阵虚弱！</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.set_resting(TRUE, TRUE)
				to_chat(M, "<span class='danger'>你被[user]猛地击飞了出去！</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	return TRUE


// Heresiarch-exclusive: Perfect Reanimation. Anastasis but evil. Requires a heart and a zizocross structure to revive somebody.

/obj/effect/proc_holder/spell/invoked/evil_resurrect
	name = "完全复生术" //Wretch Heresiarch-exclusive variant of Anastasis
	desc = "以一颗类人生物的心脏为代价，将目标的灵魂从内克拉手中夺回并使其复生。目标的属性会暂时下降。"
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "revival"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 250
	var/revive_pq = PQ_GAIN_REVIVE
	var/required_structure = /obj/structure/fluff/psycross/zizocross
	var/required_items = list(/obj/item/organ/heart = 1)
	var/alt_required_items = list(/obj/item/organ/heart = 1)
	var/item_radius = 1
	var/debuff_type = /datum/status_effect/debuff/revived
	var/structure_range = 1

/obj/effect/proc_holder/spell/invoked/evil_resurrect/start_recharge()
	recharge_time = initial(recharge_time) * SSchimeric_tech.get_resurrection_multiplier()
	. = ..()

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/get_current_required_items()
	if(SSchimeric_tech.has_revival_cost_reduction() && length(alt_required_items))
		return alt_required_items
	return required_items

/obj/effect/proc_holder/spell/invoked/evil_resurrect/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]

		var/validation_result = validate_items(target)
		if(validation_result != "")
			to_chat(user, span_warning("我需要把[validation_result]放在[target]旁边的地上，或直接放在[target]身上。"))
			revert_cast()
			return FALSE

		var/found_structure = FALSE
		var/list/search_area = oview(structure_range, target)

		for(var/atom/A in search_area)
			// Check if the atom itself is the required structure type
			if(istype(A, required_structure))
				found_structure = TRUE
				break

			if(istype(A, /turf))
				var/turf/T = A
				for(var/obj/O in T.contents)
					if(istype(O, required_structure))
						found_structure = TRUE
						break // Found it in the turf, no need to check further
			if(found_structure)
				break

		if(!found_structure)
			var/atom/temp_structure = required_structure
			to_chat(user, span_warning("我需要在[target]附近准备一座不净的[initial(temp_structure.name)]。"))
			revert_cast()
			return FALSE
		var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost.mind.transfer_to(target, TRUE)
		target.grab_ghost(force = TRUE)
		if(!target.check_revive(user))
			revert_cast()
			return FALSE
		if(target.mob_biotypes & MOB_UNDEAD) //no effect on undead
			to_chat(user, span_warning("[target]是不死者。什么也没有发生。"))
			revert_cast()
			return FALSE
		target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
		if(!target.revive(full_heal = FALSE))
			to_chat(user, span_warning("什么也没有发生。"))
			revert_cast()
			return FALSE
		target.emote("agony")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target]被渎圣魔法重新唤醒了！"), span_warning("我的灵魂被从内克拉手中硬生生拽了回来。诅咒仍在继续。"))
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		target.apply_status_effect(debuff_type)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		//Due to an increased cost and cooldown, these revival types heal quite a bit.
		target.apply_status_effect(/datum/status_effect/buff/healing, 14)
		consume_items(target)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/evil_resurrect/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		to_chat(user, span_warning("神迹熄灭了。"))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/validate_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	var/list/available_items = list()
	var/list/missing_items = list()

	// Scan for items in radius
	for(var/obj/item/I in range(item_radius, center))
		if(I.type in current_required_items)
			available_items[I.type] += 1

	// Check quantities and compile missing list
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]
		var/have = available_items[item_type] || 0

		if(have < needed) {
			var/obj/item/I = item_type
			var/amount_needed = needed - have
			missing_items += "[amount_needed] [initial(I.name)][amount_needed > 1 ? "s" : ""] "
		}

	if(length(missing_items))
		var/string = ""
		for(var/item in missing_items)
			string += item
		return "Missing components: [string]."
	return ""

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/consume_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]

		for(var/obj/item/I in range(item_radius, center))
			if(needed <= 0)
				break
			if(I.type == item_type)
				needed--
				qdel(I)
