/datum/wound/facial
	name = "面部创伤"
	sound_effect = 'sound/combat/crit.ogg'
	severity = WOUND_SEVERITY_SEVERE
	whp = null
	woundpain = 0
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE

/datum/wound/facial/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/facial/ears
	name = "鼓膜切裂"
	check_name = span_danger("耳部")
	crit_message = list(
		"耳膜被刺穿了！",
		"耳膜破裂了！",
	)
	can_sew = FALSE
	can_cauterize = FALSE
	critical = TRUE
	woundpain = 30 // it REALLY HURTS to have ruptured eardrums

/datum/wound/facial/ears/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_EARS)

/datum/wound/facial/ears/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(10)
	var/obj/item/organ/ears/ears = affected.getorganslot(ORGAN_SLOT_EARS)
	if(ears)
		ears.Remove(affected)
		ears.forceMove(affected.drop_location())

/datum/wound/facial/eyes
	name = "眼球毁损"
	check_name = span_warning("眼部")
	crit_message = list(
		"眼睛被刺中了！",
		"眼球被挖伤了！",
		"眼睛被毁了！",
	)
	woundpain = 30
	can_sew = FALSE
	can_cauterize = FALSE
	critical = TRUE
	var/do_blinding = TRUE

/datum/wound/facial/eyes/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_EYES)

/datum/wound/facial/eyes/on_mob_gain(mob/living/affected)
	. = ..()
	if(do_blinding)
		affected.Stun(10)
		affected.blind_eyes(5)

/datum/wound/facial/eyes/right
	name = "右眼毁损"
	check_name = span_danger("右眼")
	crit_message = list(
		"右眼被刺中了！",
		"右眼被挖伤了！",
		"右眼被毁了！",
	)

/datum/wound/facial/eyes/right/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial/eyes/right))
		return FALSE
	return TRUE

/datum/wound/facial/eyes/right/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_CYCLOPS_RIGHT, "[type]")
	affected.update_fov_angles()
	if(affected.has_wound(/datum/wound/facial/eyes/left) && affected.has_wound(/datum/wound/facial/eyes/right))
		var/obj/item/organ/my_eyes = affected.getorganslot(ORGAN_SLOT_EYES)
		if(my_eyes)
			my_eyes.Remove(affected)
			my_eyes.forceMove(affected.drop_location())

/datum/wound/facial/eyes/right/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_CYCLOPS_RIGHT, "[type]")
	affected.update_fov_angles()

/datum/wound/facial/eyes/right/permanent
	whp = null
	woundpain = 0
	sound_effect = null
	do_blinding = FALSE

/datum/wound/facial/eyes/left
	name = "左眼毁损"
	check_name = span_danger("左眼")
	crit_message = list(
		"左眼被刺中了！",
		"左眼被挖伤了！",
		"左眼被毁了！",
	)

/datum/wound/facial/eyes/left/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial/eyes/left))
		return FALSE
	return TRUE

/datum/wound/facial/eyes/left/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_CYCLOPS_LEFT, "[type]")
	affected.update_fov_angles()
	if(affected.has_wound(/datum/wound/facial/eyes/left) && affected.has_wound(/datum/wound/facial/eyes/right))
		var/obj/item/organ/my_eyes = affected.getorganslot(ORGAN_SLOT_EYES)
		if(my_eyes)
			my_eyes.Remove(affected)
			my_eyes.forceMove(affected.drop_location())

/datum/wound/facial/eyes/left/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_CYCLOPS_LEFT, "[type]")
	affected.update_fov_angles()

/datum/wound/facial/eyes/left/permanent
	whp = null
	woundpain = 0
	sound_effect = null
	do_blinding = FALSE

/datum/wound/facial/tongue
	name = "舌切创"
	check_name = span_danger("舌头")
	crit_message = list(
		"舌头被割开了！",
		"舌头被切断了！",
		"舌头打着旋飞了出去！"
	)
	woundpain = 20
	can_sew = FALSE
	can_cauterize = FALSE
	critical = TRUE

/datum/wound/facial/tongue/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_TONGUE)

/datum/wound/facial/tongue/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(10)
	var/obj/item/organ/tongue/tongue_up_my_asshole = affected.getorganslot(ORGAN_SLOT_TONGUE)
	if(tongue_up_my_asshole)
		tongue_up_my_asshole.Remove(affected)
		tongue_up_my_asshole.forceMove(affected.drop_location())

/datum/wound/facial/disfigurement
	name = "毁容"
	check_name = span_warning("面部")
	severity = 0
	crit_message = "脸被毁得完全认不出来了！"
	whp = null
	woundpain = 20
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = TRUE

/datum/wound/facial/disfigurement/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/facial/disfigurement/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/facial/disfigurement/nose
	name = "鼻毁伤"
	check_name = span_warning("鼻部")
	crit_message = list(
		"鼻子被毁得完全认不出来了！",
		"鼻子被毁了！",
	)
	mortal = TRUE
	woundpain = 10

/datum/wound/facial/disfigurement/nose/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")

/datum/wound/facial/disfigurement/nose/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")


/datum/wound/cbt
	name = "睾丸扭转"
	check_name = span_userdanger("<B>碎蛋</B>")
	crit_message = list(
		"睾丸扭曲了！",
		"睾丸发生扭转了！",
	)
	whp = 50
	woundpain = 100
	mob_overlay = ""
	sewn_overlay = ""
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	mortal = TRUE

/datum/wound/cbt/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/cbt))
		return FALSE
	return TRUE

/datum/wound/cbt/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("groin", forced = TRUE)
	affected.Stun(20)
	to_chat(affected, span_userdanger("我的胯下有什么东西扭起来了！"))
	if(affected.gender != MALE)
		name = "卵巢扭转"
		check_name = span_userdanger("<B>碎卵</B>")
		crit_message = list(
			"卵巢扭曲了！",
			"卵巢发生扭转了！",
		)
	else
		name = "睾丸扭转"
		check_name = span_userdanger("<B>碎蛋</B>")
		crit_message = list(
			"睾丸扭曲了！",
			"睾丸发生扭转了！",
		)

/datum/wound/cbt/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(5))
		carbon_owner.vomit(1, stun = TRUE)

/datum/wound/cbt/permanent
	name = "睾丸毁损"
	crit_message = list(
		"睾丸被毁了！",
		"睾丸被彻底挖烂了！",
	)
	whp = null

/datum/wound/cbt/permanent/on_mob_gain(mob/living/affected)
	. = ..()
	if(affected.gender != MALE)
		name = "卵巢毁损"
		check_name = span_userdanger("<B>碎卵</B>")
		crit_message = list(
			"卵巢被毁了！",
			"卵巢被彻底挖烂了！",
		)
	else
		name = "睾丸毁损"
		check_name = span_userdanger("<B>碎蛋</B>")
		crit_message = list(
			"睾丸被毁了！",
			"睾丸被彻底挖烂了！",
		)

/datum/wound/scarring
	name = "永久疤痕"
	check_name = "<span class='userdanger'><B>留疤</B></span>"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"鞭痕深深裂开血肉！",
		"组织已被不可逆地撕裂！",
		"%BODYPART已被彻底毁坏！",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 80
	woundpain = 30
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0
	var/gain_emote = "paincrit"

/datum/wound/scarring/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("scream", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/scarring/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/scarring))
		return FALSE
	return TRUE


/// grievous wounds exist to provide a solution for "two-stage death" - aka where you want someone to DIE IMMEDIATELY upon dismemberment of a crucial bodypart, but not actually lose it.
/// the spiritual intent here is to provide a little bit of protection from accidental decaps
/datum/wound/grievous
	name = "重创"
	check_name = span_danger("<B>重创</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 150
	woundpain = 100
	sewn_whp = 25
	bleed_rate = 25 // equivalent to carotid artery tear
	sewn_bleed_rate = 0.5
	can_sew = TRUE
	can_cauterize = FALSE
	var/immunity_time = 12 SECONDS // how long the wound actively prevents further dismemberment attempts for

/datum/wound/grievous/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	// ostensibly, the entire point of grievous wounds is that you DIE when you get one, critical weakness or not.
	// this skips the mortal check and just kills you outright. we also give a short window of dismemberment immunity to increase the chances that the zerg pulls back
	if (affected && affected.two_stage_death && !affected.grievously_wounded)
		affected.grievously_wounded = TRUE
		affected.owner?.death()
		bodypart_owner?.dismemberable = FALSE
		addtimer(CALLBACK(src, PROC_REF(reset_dismemberment_immunity)), immunity_time)
		playsound(affected?.owner, 'sound/combat/dismemberment/grievous-behead.ogg', 250, FALSE, -1)

/datum/wound/grievous/proc/reset_dismemberment_immunity()
	if (!bodypart_owner || QDELETED(src))
		return
	bodypart_owner?.dismemberable = initial(bodypart_owner?.dismemberable)
	if (bodypart_owner?.skeletonized)
		owner?.visible_message(span_smallred("细密裂纹沿着<b>[owner]</b>破碎的头骨缓缓蔓延……"))
	else
		owner?.visible_message(span_smallred("<b>[owner]</b>的[bodypart_owner.name]周围痉挛的肌肉终于缓缓松弛……"))

/datum/wound/grievous/remove_from_bodypart(force = FALSE)
	bodypart_owner?.grievously_wounded = FALSE
	. = ..()

/datum/wound/grievous/pre_decapitation
	name = "碎裂脊柱"

/datum/wound/grievous/pre_skullshatter
	name = "粉碎颅骨"

//Unique wounds for ooze-people.
/datum/wound/slime
	var/paralysis
	var/knockout
	sleep_healing = 1
	critical = TRUE

/datum/wound/slime/knockout
	name = "神经核心破裂"
	check_name = span_bone("破裂！")
	crit_message = list(
		"软泥从神经核心中漏出！",
		"神经核心被刺穿了！",
		"神经核心被撕裂了！",
	)
	woundpain = 60
	whp = 20
	knockout = 4 SECONDS

/datum/wound/slime/paralyze
	name = "碎裂的神经核心"
	check_name = span_bone("<B>碎裂！</B>")
	crit_message = list(
		"神经核心碎裂了！",
		"神经核心裂成了两半！",
		"神经核心塌陷了！",
	)
	woundpain = 100
	whp = 40
	paralysis = TRUE

/datum/wound/slime/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(knockout)
		affected.Unconscious(knockout)
	if(paralysis)
		ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/slime/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(paralysis)
		REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/slime/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(20 SECONDS)
	affected.owner.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.3)

/datum/wound/slime/on_bodypart_loss(obj/item/bodypart/affected)
	. = ..()
	if(!affected.owner)
		return
	affected.owner.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/datum/wound/slime/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/slime) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/dynamic/ooze
	name = "体膜擦伤"
	whp = 5
	bleed_rate = null
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 5
	passive_healing = 1
	sew_threshold = 50
	can_sew = FALSE
	can_cauterize = FALSE
	passive_healing = 0.5
	severity_names = list(
		"轻微" = 20,
		"中等" = 60,
		"严重" = 120,
		"大规模" = 180
	)

#define OOZE_UPG_WHPRATE 1
#define OOZE_UPG_PAINRATE 1
#define OOZE_UPG_SELFHEAL 1

/datum/wound/dynamic/ooze/upgrade(dam, armor)
	whp += (dam * OOZE_UPG_WHPRATE)
	woundpain += (dam * OOZE_UPG_PAINRATE)
	passive_healing += OOZE_UPG_SELFHEAL
	update_name()
	..()

#undef OOZE_UPG_WHPRATE
#undef OOZE_UPG_PAINRATE
#undef OOZE_UPG_SELFHEAL

/datum/wound/sunder
	name = "圣焰灼裂"
	check_name = "<span class='userdanger'><B>灼裂</B></span>"
	crit_message = list(
		"%BODYPART被神圣火焰吞没了！",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 80
	woundpain = 30
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	bypass_bloody_wound_check = FALSE

/datum/wound/sunder/chest
	name = "圣焰裂胸"
	check_name = span_artery("<B>裂胸圣焰</B>")
	crit_message = list(
		"神圣火焰自%VICTIM的胸膛喷涌而出！",
		"熔融圣辉从%VICTIM碎裂的肋骨间飞溅而出！",
	)
	severity = WOUND_SEVERITY_FATAL
	bypass_bloody_wound_check = TRUE
	whp = 100
	sewn_whp = 35
	bleed_rate = 50
	sewn_bleed_rate = 0.8
	woundpain = 100
	sewn_woundpain = 50

/datum/wound/sunder/chest/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
	var/goodbye = list(\
		"PSYDON夺走了我衰竭的……圣辉？！",\
		"我的圣辉正从这颗被洞穿的心脏中熔散！",\
		"操，我的天！"\
	)
	to_chat(affected, span_userdanger(pick(goodbye)))
	affected.apply_status_effect(/datum/status_effect/debuff/devitalised)
	if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		affected.death()

/datum/wound/sunder/head
	name = "圣焰裂首"
	check_name = span_artery("<B>灼裂头颅</B>")
	crit_message = list(
		"神圣火焰自%VICTIM的头颅喷涌而出！",
		"%VICTIM的头颅被圣焰点燃了！",
	)
	severity = WOUND_SEVERITY_FATAL
	bypass_bloody_wound_check = TRUE
	whp = 100
	sewn_whp = 35
	bleed_rate = 50
	sewn_bleed_rate = 0.8
	woundpain = 100
	sewn_woundpain = 50

/datum/wound/sunder/head/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
	var/goodbye = list(\
		"我的头，我的头！在燃烧！！！",\
		"我的脑袋被火焰吞没了！！！",\
		"操，我的天！"\
	)
	to_chat(affected, span_userdanger(pick(goodbye)))
	if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		affected.death()

//Burn wounds. A sideclass of lashing, basically.
//Does not disable limbs.
//High pain. No bleed. All the time. Can sleep it off.
/datum/wound/burn
	name = "烧伤"
	check_name = "<span class='userdanger'><B>焦灼</B></span>"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"组织被可怖的烧伤毁坏了！",
		"%BODYPART周围弥漫着焦肉味！",
		"%BODYPART被彻底烧焦了！",
	)
	sound_effect = 'sound/combat/sizzle1.ogg'
	whp = 100
	woundpain = 35
	can_sew = FALSE
	can_cauterize = FALSE
	sleep_healing = 0.5//You can TRY sleeping this off. A PITA without miracles.

/datum/wound/burn/strong
	whp = 150
	woundpain = 40
	sound_effect = 'sound/combat/sizzle2.ogg'

/datum/wound/burn/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("agony", TRUE)
	affected.Slowdown(40)
	shake_camera(affected, 2, 2)

/datum/wound/burn/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/burn))
		return FALSE
	return TRUE

/datum/wound/heatexhaustion
	name = "热衰竭"
	check_name = span_warning("热衰竭")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE

	var/start_time
	var/duration = 2 MINUTES

/datum/wound/heatexhaustion/on_mob_gain(mob/living/affected)
	. = ..()
	start_time = world.time
	if(!owner.stat)
		to_chat(owner, span_warning("热浪席卷了我……我快要晕过去了。"))
	owner.overlay_fullscreen("heatexhaust", /atom/movable/screen/fullscreen/heatexhaust)

/datum/wound/heatexhaustion/on_life()
	. = ..()

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner

	// If cooled off, remove heat exhaustion
	if(C.bodytemperature <= BODYTEMP_NORMAL_MAX)
		to_chat(C, span_notice("凉意让我缓过神来，最难熬的热浪过去了。"))
		C.clear_fullscreen("heatexhaust")
		qdel(src)
		return

	// Occasional discomfort message
	if(!C.stat && prob(5))
		to_chat(C, span_warning("热得我眼前发花……"))

	// After 2 minute, convert to heatstroke
	if(world.time >= start_time + duration)
		var/obj/item/bodypart/BP = bodypart_owner
		if(BP)
			to_chat(C, span_userdanger("热浪彻底压垮了我！"))
			BP.add_wound(/datum/wound/heatstroke)
		C.clear_fullscreen("heatexhaust")
		qdel(src)

/datum/wound/heatstroke
	name = "中暑"
	check_name = span_warning("中暑")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE
	var/cure_timer

/datum/wound/heatstroke/on_mob_gain(mob/living/affected)
	. = ..()
	cure_timer = null
	owner.overlay_fullscreen("heatstroke", /atom/movable/screen/fullscreen/heatstroke)

/datum/wound/heatstroke/on_life()
	. = ..()

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner

	if(!C.stat && prob(5))
		if(prob(5))
			C.vomit(1, blood = FALSE, stun = TRUE)
		to_chat(owner, span_warning("天旋地转！"))
		C.Dizzy(10)

	// If temperature is normal, start cure timer
	if(C.bodytemperature <= BODYTEMP_NORMAL_MAX)
		if(!cure_timer)
			to_chat(C, span_notice("体内的热意开始慢慢退去……"))
			cure_timer = addtimer(CALLBACK(src, PROC_REF(cure_heatstroke)), 2 MINUTES)

	// If overheating again, cancel cure timer
	else
		if(cure_timer)
			deltimer(cure_timer)
			cure_timer = null

/datum/wound/heatstroke/on_mob_loss()
	. = ..()
	if(cure_timer)
		deltimer(cure_timer)
		cure_timer = null

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	to_chat(owner, span_warning("世界终于不再旋转了。"))
	C.set_dizziness(0)

/datum/wound/heatstroke/proc/cure_heatstroke()
	if(!owner)
		return

	var/mob/living/carbon/human/H = owner

	to_chat(H, span_notice("随着热意离体，世界终于彻底停止了旋转。"))
	H.clear_fullscreen("heatstroke")
	qdel(src)

/datum/wound/frostbite
	name = "冻伤"
	check_name = span_blue("冻伤")
	severity = 0
	crit_message = ""
	whp = null
	woundpain = 0
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE
	var/stage = 1
	var/last_stage_tick
	var/stage_interval = 2 MINUTES

/datum/wound/frostbite/on_mob_gain(mob/living/affected)
	. = ..()
	last_stage_tick = world.time
	update_stage_name()
	owner.overlay_fullscreen("frostbite", /atom/movable/screen/fullscreen/frostbite)

/datum/wound/frostbite/on_life()
	. = ..()

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner
	var/obj/item/bodypart/BP = bodypart_owner

	// Warmth degrades frostbite
	if(C.bodytemperature >= BODYTEMP_NORMAL_MIN)
		if(world.time >= last_stage_tick + (1 MINUTES))
			stage--
			last_stage_tick = world.time

			if(stage >= 1)
				to_chat(C, span_notice("[BP]的知觉正慢慢恢复……"))
				disabling = FALSE
				update_stage_name()
			else
				stage = 1

	// Stage progression
	if(stage < 3 && world.time >= last_stage_tick + stage_interval && C.bodytemperature < BODYTEMP_NORMAL_MIN)
		stage++
		last_stage_tick = world.time
		update_stage_name()

		switch(stage)
			if(2)
				to_chat(C, span_userdanger("我的[BP]已经完全麻木了……"))
			if(3)
				to_chat(C, span_userdanger("我的[BP]像死掉了一样，又脆又硬！"))
				disabling = TRUE

	// Damage scaling per stage
	if(!C.stat && prob(30))
		var/damage = 0
		switch(stage)
			if(1)
				damage = 2
			if(2)
				damage = 5
			if(3)
				damage = 10
		if(BP.bandage)
			damage = damage *0.25

		C.apply_damage(damage, BURN)

/datum/wound/frostbite/proc/update_stage_name()
	var/stage_text

	switch(stage)
		if(1)
			stage_text = "I"
		if(2)
			stage_text = "II"
		if(3)
			stage_text = "III"

	check_name = span_blue("冻伤（[stage_text]期）")


/datum/wound/hypothermia
	name = "失温"
	check_name = span_blue("失温")
	severity = 0
	crit_message = ""
	whp = 40
	woundpain = 0
	mob_overlay = null
	can_sew = FALSE
	can_cauterize = FALSE
	critical = FALSE
	sleep_healing = 0
	bleed_rate = 0
	clotting_threshold = 0
	clotting_rate = 0
	bypass_bloody_wound_check = TRUE

	var/start_time
	var/duration = 2 MINUTES

/datum/wound/hypothermia/on_mob_gain(mob/living/affected)
	. = ..()
	start_time = world.time
	owner.overlay_fullscreen("hypothermia", /atom/movable/screen/fullscreen/hypothermia)

/datum/wound/hypothermia/on_life()
	. = ..()

	if(!iscarbon(owner))
		return

	var/mob/living/carbon/C = owner

	// If warmed up, remove hypothermia
	if(C.bodytemperature >= BODYTEMP_NORMAL_MIN)
		to_chat(C, span_notice("随着身体回暖，知觉重新回到了四肢。"))
		C.clear_fullscreen("hypothermia")
		qdel(src)
		return

	// Occasional discomfort message
	if(!C.stat && prob(5))
		to_chat(C, span_warning("我止不住地发抖……"))

	// After 2 minutes, convert to frostbite
	if(world.time >= start_time + duration)
		var/obj/item/bodypart/BP = bodypart_owner
		if(BP)
			to_chat(C, span_userdanger("[BP]传来一阵针刺般的麻痛！"))
			BP.add_wound(/datum/wound/frostbite)
			C.clear_fullscreen("hypothermia")
		qdel(src)
