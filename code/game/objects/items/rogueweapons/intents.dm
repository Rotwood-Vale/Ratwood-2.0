////click cooldowns, in tenths of a second, used for various combat actions
//#define CLICK_CD_EXHAUSTED 35
//#define CLICK_CD_MELEE 12
//#define CLICK_CD_RANGE 4
//#define CLICK_CD_RAPID 2

/datum/intent
	var/name = "意图"
	var/desc = ""
	var/icon_state = "instrike"
	var/list/attack_verb = list("击打", "打击")
	var/obj/item/masteritem
	var/mob/living/mastermob
	var/unarmed = FALSE
	var/intent_type
	var/animname = "strike"
	var/blade_class = BCLASS_BLUNT
	var/list/hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	var/canparry = TRUE
	var/candodge = TRUE
	var/chargetime = 0 //if above 0, this attack must be charged to reach full damage
	var/chargedrain = 0 //how mcuh fatigue is removed every second when at max charge
	var/releasedrain = 1 //drain when we go off, regardless
	var/misscost = 1	//extra drain from missing only, ALSO APPLIED IF ENEMY DODGES
	var/tranged = 0
	var/noaa = FALSE //turns off auto aiming, also turns off the 'swooshes'
	var/warnie = ""
	var/pointer = 'icons/effects/mousemice/human_attack.dmi'
	var/charge_pointer = null // Simple unique charge icon
	var/charged_pointer = null // Simple unique charged icon
	var/clickcd = CLICK_CD_MELEE //the cd invoked clicking on stuff with this intent
	var/recovery = 0		//RTD unable to move for this duration after an attack without becoming off balance
	var/list/charge_invocation //list of stuff to say while charging
	var/no_early_release = FALSE //we can't shoot off early
	var/movement_interrupt = FALSE //we cancel charging when changing mob direction, for concentration spells
	var/rmb_ranged = FALSE //we execute a proc with the same name when rmbing at range with no offhand intent selected
	var/tshield = FALSE //probably needed or something
	var/datum/looping_sound/chargedloop = null
	var/keep_looping = TRUE
	var/damfactor = 1 //multiplied by weapon's force for damage
	var/penfactor = 0 //see armor_penetration
	var/intent_intdamage_factor = 1 // Whether the intent itself has integrity damage modifier. Used for rend.
	var/item_d_type = "blunt" // changes the item's attack type ("blunt" - area-pressure attack, "slash" - line-pressure attack, "stab" - point-pressure attack)
	var/charging_slowdown = 0
	var/warnoffset = 0
	var/swingdelay = 0
	var/no_attack = FALSE //causes a return in /attack() but still allows to be used in attackby(
	var/reach = 1 //In tiles, how far this weapon can reach; 1 for adjacent, which is default
	var/miss_text //THESE ARE FOR UNARMED MISSING ATTACKS
	var/miss_sound //THESE ARE FOR UNARMED MISSING ATTACKS
	var/allow_offhand = TRUE	//Do I need my offhand free while using this intent?
	var/peel_divisor = 0		//How many consecutive peel hits this intent requires to peel a piece of coverage? May be overriden by armor thresholds if they're higher.
	var/glow_intensity = null	//How much glow this intent has. Used for spells
	var/glow_color = null // The color of the glow. Used for spells
	var/mob_light = null // tracking mob_light
	var/obj/effect/mob_charge_effect = null // The effect to be added (on top) of the mob while it is charging
	var/custom_swingdelay = null	//Custom icon for its swingdelay.
	/// Effective range for penfactor to apply fully.
	var/effective_range = null
	///	Effective range type. Can be Exact, Below or Above. Be sure to set this if you use effective_range!
	/// Only use this with reach is >1 because otherwise like... why.
	var/effective_range_type = EFF_RANGE_NONE
	/// Extra sharpness drain per successful & parried hit.
	var/sharpness_penalty = 0
	//The below is for chipping on intents. Damage applied through armour, as a mechanic.
	var/blunt_chipping = FALSE//Is this even capable of it?
	var/blunt_chip_strength = null//How strong?

	var/static/list/bonk_animation_types = list(
		BCLASS_BLUNT,
		BCLASS_SMASH,
	)
	var/static/list/swipe_animation_types = list(
		BCLASS_CUT,
		BCLASS_CHOP,
	)
	var/static/list/thrust_animation_types = list(
		BCLASS_STAB,
		BCLASS_PICK,
	)


/datum/intent/Destroy()
	if(chargedloop)
		chargedloop.stop()
	if(mob_light)
		QDEL_NULL(mob_light)
	if(mob_charge_effect)
		mastermob.vis_contents -= mob_charge_effect
	if(mastermob?.curplaying == src)
		mastermob.curplaying = null
	mastermob = null
	masteritem = null
	return ..()

/datum/intent/proc/examine(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b>意图</span>"
	if(desc)
		inspec += "\n[desc]"
	if(reach != 1)
		inspec += "\n<b>攻击距离:</b> [reach] 步"
	if(effective_range)
		var/suffix
		switch(effective_range_type)
			if(EFF_RANGE_EXACT)
				suffix = "恰好"
			if(EFF_RANGE_ABOVE)
				suffix = "及更远处"
			if(EFF_RANGE_BELOW)
				suffix = "及更近处"
			else
				CRASH("effective_range found without a valid effective_range_type on [src] intent by [user]")
		inspec += "\n<b>有效距离:</b> [suffix] [effective_range] 步"
	if(damfactor != 1)
		inspec += "\n<b>伤害:</b> [damfactor]"
	if(penfactor)
		inspec += "\n<b>护甲穿透:</b> [penfactor < 0 ? "无" : penfactor]"
	if(get_chargetime())
		inspec += "\n<b>蓄力时间</b>"
	if(movement_interrupt)
		inspec += "\n<b>移动会打断</b>"
	if(no_early_release)
		inspec += "\n<b>不可提前释放</b>"
	if(chargedrain)
		inspec += "\n<b>蓄满时消耗:</b> [chargedrain]"
	if(releasedrain)
		inspec += "\n<b>释放时消耗:</b> [releasedrain]"
	if(misscost)
		inspec += "\n<b>落空时消耗:</b> [misscost]"
	if(clickcd != CLICK_CD_MELEE)
		inspec += "\n<b>恢复时间:</b> "
		if(clickcd < CLICK_CD_MELEE)
			inspec += "快"
		if(clickcd > CLICK_CD_MELEE)
			inspec += "慢"
	if(blade_class == BCLASS_PEEL)
		inspec += "\n该意图会在连续命中 [peel_divisor] 次后，剥离目标护甲在非关键部位的覆盖。\n部分护甲的阈值可能更高。"
	if(!allow_offhand)
		inspec += "\n该意图需要空出的副手。"
	if(blade_class == BCLASS_EFFECT)
		var/datum/intent/effect/int = src
		inspec += "\n该意图会在成功命中时附加状态效果，不要求造成伤害。"
		if(length(int.target_parts))
			inspec += "\n可作用于以下部位: "
			var/str
			for(var/part in int.target_parts)
				str +="|[bodyzone2readablezone(part)]|"
			inspec += str
	if(intent_intdamage_factor != 1)
		var/percstr = abs(intent_intdamage_factor - 1) * 100
		inspec += "\n该意图会对耐久造成[percstr]％[intent_intdamage_factor > 1 ? "更多" : "更少"]伤害。"
	if(sharpness_penalty)
		inspec += "\n该意图每次攻击都会额外消耗一些锋利度。"
	if(blunt_chipping)
		var/chip_strength
		switch(blunt_chip_strength)
			if(BLUNT_CHIP_MINUSCULE)
				chip_strength = "极少"
			if(BLUNT_CHIP_WEAK)
				chip_strength = "中等"
			if(BLUNT_CHIP_STRONG)
				chip_strength = "可观"
			if(BLUNT_CHIP_ABSURD)
				chip_strength = "显著"
		inspec += "\n若目标没有衬垫防护，将有一部分[chip_strength]的伤害绕过护甲。"
	inspec += "<br>----------------------"

	to_chat(user, "[inspec.Join()]")

/datum/intent/proc/get_chargetime()
	if(chargetime)
		return chargetime
	else
		return 0

/datum/intent/proc/get_chargedrain()
	if(chargedrain)
		return chargedrain
	else
		return 0

/datum/intent/proc/get_releasedrain()
	if(releasedrain)
		return releasedrain
	else
		return 0

/datum/intent/proc/parrytime()
	return 0

/datum/intent/proc/prewarning()
	return

/datum/intent/proc/rmb_ranged(atom/target, mob/user)
	return

/datum/intent/proc/can_charge(atom/clicked_object)
	return TRUE

/datum/intent/proc/afterchange()
	if(masteritem)
		masteritem.d_type = item_d_type
		var/list/benis = hitsound
		if(benis)
			masteritem.hitsound = benis
	return

/datum/intent/proc/height2limb(height as num)
	var/list/returned
	switch(height)
		if(2)
			returned += list(BODY_ZONE_HEAD)
		if(1)
			returned += list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_CHEST)
		if(0)
			returned += list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	return returned


/// returns the attack animation type this intent uses
/datum/intent/proc/get_attack_animation_type()
	if(blade_class in bonk_animation_types)
		return ATTACK_ANIMATION_BONK
	if(blade_class in swipe_animation_types)
		return ATTACK_ANIMATION_SWIPE
	if(blade_class in thrust_animation_types)
		return ATTACK_ANIMATION_THRUST
	return null

/datum/intent/New(Mastermob, Masteritem)
	..()
	if(Mastermob)
		if(isliving(Mastermob))
			mastermob = Mastermob
			if(chargedloop)
				update_chargeloop()
	if(Masteritem)
		masteritem = Masteritem

/datum/intent/proc/update_chargeloop() //what the fuck is going on here lol
	if(mastermob)
		if(chargedloop)
			if(!istype(chargedloop))
				chargedloop = new chargedloop(mastermob)

/datum/intent/proc/on_charge_start() //what the fuck is going on here lol
	if(mastermob.curplaying)
		mastermob.curplaying.chargedloop.stop()
		mastermob.curplaying = null
	if(chargedloop)
		if(!istype(chargedloop, /datum/looping_sound))
			chargedloop = new chargedloop(mastermob)
		else
			chargedloop.stop()
		chargedloop.start(chargedloop.parent)
		mastermob.curplaying = src
	if(glow_color && glow_intensity)
		mob_light = mastermob.mob_light(glow_color, glow_intensity, FLASH_LIGHT_SPELLGLOW)
	if(mob_charge_effect)
		mastermob.vis_contents += mob_charge_effect

/datum/intent/proc/on_mouse_up()
	if(chargedloop)
		chargedloop.stop()
	if(mastermob?.curplaying == src)
		mastermob?.curplaying = null
	if(mob_light)
		qdel(mob_light)
	if(mob_charge_effect)
		mastermob?.vis_contents -= mob_charge_effect

/datum/intent/proc/on_mmb(atom/target, mob/living/user, params)
	return

// Do something special when this intent is applied to a living target, H being the receiver and user being the attacker
/datum/intent/proc/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	return

/datum/intent/use
	name = "使用"
	icon_state = "inuse"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/datum/intent/give
	name = "给予"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE
	pointer = 'icons/effects/mousemice/human_give.dmi'

/datum/looping_sound/invokegen
	mid_sounds = list('sound/magic/charging.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokefire
	mid_sounds = list('sound/magic/charging_fire.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokelightning
	mid_sounds = list('sound/magic/charging_lightning.ogg')
	mid_length = 130
	volume = 100
	extra_range = 3

/datum/looping_sound/invokeholy
	mid_sounds = list('sound/magic/holycharging.ogg')
	mid_length = 320
	volume = 100
	extra_range = 3

/datum/looping_sound/invokeascendant
	mid_sounds = list('sound/magic/chargingold.ogg')
	mid_length = 320
	volume = 100
	extra_range = 5

/datum/looping_sound/flailswing
	mid_sounds = list('sound/combat/wooshes/flail_swing.ogg')
	mid_length = 7
	volume = 100


/datum/intent/hit
	name = "打击"
	icon_state = "instrike"
	attack_verb = list("击打", "打击")
	item_d_type = "blunt"
	chargetime = 0
	swingdelay = 0

/datum/intent/stab
	name = "刺击"
	icon_state = "instab"
	attack_verb = list("刺击")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	animname = "stab"
	item_d_type = "stab"
	blade_class = BCLASS_STAB
	chargetime = 0
	swingdelay = 0

/datum/intent/stab/militia
	name = "民兵刺击"
	damfactor = 1.1
	penfactor = 50

/datum/intent/pick //now like icepick intent, we really went in a circle huh
	name = "啄刺"
	icon_state = "inpick"
	attack_verb = list("啄刺", "贯穿")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	penfactor = 80
	animname = "strike"
	item_d_type = "stab"
	blade_class = BCLASS_PICK
	chargetime = 0
	clickcd = 14 // Just like knife pick!
	swingdelay = 12

/datum/intent/pick/bad	//One-handed intents
	name = "迟缓啄刺"
	icon_state = "inpick"
	attack_verb = list("啄刺", "贯穿")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	penfactor = 60
	animname = "strike"
	item_d_type = "stab"
	blade_class = BCLASS_PICK
	chargetime = 0
	clickcd = 16 // Just like knife pick!
	swingdelay = 16

/datum/intent/pick/ranged
	name = "远距啄刺"
	icon_state = "inpick"
	attack_verb = list("刺入", "贯穿")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 60
	damfactor = 1.1
	clickcd = CLICK_CD_CHARGED
	releasedrain = 4
	reach = 2
	no_early_release = TRUE
	blade_class = BCLASS_PICK

/datum/intent/shoot //shooting crossbows or other guns, no parrydrain
	name = "射击"
	icon_state = "inshoot"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "stab"
	chargetime = 0.1
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20
	var/strength_check = FALSE //used when we fire HEAVY bows

/datum/intent/shoot/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob]举起了[masteritem]瞄准！"))

/datum/intent/arc
	name = "弧射"
	icon_state = "inarc"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "blunt"
	chargetime = 0
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20
	var/strength_check = FALSE //used when we fire HEAVY bows

/datum/intent/proc/arc_check()
	return FALSE

/datum/intent/arc/arc_check()
	return TRUE

/datum/intent/arc/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob]举起了[masteritem]瞄准！"))

/datum/intent/swing //swinging a sling, no parrydrain
	name = "甩投"
	icon_state = "inshoot"
	tranged = 1
	warnie = "aimwarn"
	item_d_type = "stab"
	chargetime = 0.1
	no_early_release = FALSE
	noaa = TRUE
	charging_slowdown = 3
	warnoffset = 20

/datum/intent/swing/prewarning()
	if(masteritem && mastermob)
		mastermob.visible_message(span_warning("[mastermob]甩动着[masteritem]！"))

/datum/intent/unarmed
	unarmed = TRUE

/datum/intent/unarmed/punch
	name = "拳击"
	icon_state = "inpunch"
	attack_verb = list("挥拳", "猛击", "重殴", "打击")
	chargetime = 0
	noaa = FALSE
	animname = "bite"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg', 'sound/combat/hits/punch/punch (2).ogg', 'sound/combat/hits/punch/punch (3).ogg')
	misscost = 4
	releasedrain = 1
	swingdelay = 0
	clickcd = 10
	rmb_ranged = TRUE
	candodge = TRUE
	canparry = TRUE
	blade_class = BCLASS_PUNCH
	miss_text = "朝空气挥了一拳"
	miss_sound = "punchwoosh"
	item_d_type = "blunt"
	intent_intdamage_factor = 1

/datum/intent/unarmed/punch/rmb_ranged(atom/target, mob/user)
	if(user.stat >= UNCONSCIOUS)
		return
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_taunt("[user] 嘲弄着 [M]!"), span_taunt("我在嘲弄[M]!"), ignored_mobs = targetl)
		user.emote("taunt")
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_danger("[user]在嘲弄我！"))
		else
			M.taunted(user)
	return

/datum/intent/unarmed/claw
	name = "抓挠"
	//icon_state
	attack_verb = list("撕扯", "抓伤", "抓挠")
	chargetime = 0
	animname = "blank22"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg', 'sound/combat/hits/punch/punch (2).ogg', 'sound/combat/hits/punch/punch (3).ogg')
	misscost = 5
	releasedrain = 4	//More than punch cus pen factor.
	swingdelay = 0
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	blade_class = BCLASS_CUT
	miss_text = "朝空气抓了一把"
	miss_sound = "punchwoosh"
	item_d_type = "slash"


/datum/intent/unarmed/shove
	name = "推搡"
	icon_state = "inshove"
	attack_verb = list("推搡", "推开")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	misscost = 5
	item_d_type = "blunt"

/datum/intent/unarmed/shove/rmb_ranged(atom/target, mob/user)
	if(user.stat >= UNCONSCIOUS)
		return
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_blue("[user] 挥手驱赶 [M] 。"), span_blue("我挥手驱赶[M]。"), ignored_mobs = targetl)
		if(M.mind)
			var/mob/living/L = user
			L.play_overhead_private_rclickemote(targetl, "dismiss")
			user.changeNext_move(CLICK_CD_FAST)	// Mostly to prevent spamming the animation too heavily.
			to_chat(M, span_blue("[user]挥手要我走开。"))
		else
			M.shood(user)
	return

/datum/intent/unarmed/grab
	name = "抓取"
	icon_state = "ingrab"
	attack_verb = list("抓住")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	releasedrain = 10
	misscost = 8
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

/datum/intent/unarmed/grab/rmb_ranged(atom/target, mob/user)
	if(user.stat >= UNCONSCIOUS)
		return
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_yellow("[user]示意[M]靠近。"), span_yellow("我示意[M]靠近。"), ignored_mobs = targetl)
		if(M.mind)
			var/mob/living/L = user
			L.play_overhead_private_rclickemote(targetl, "beckon")
			user.changeNext_move(CLICK_CD_FAST)	// Mostly to prevent spamming the animation too heavily.
			to_chat(M, span_yellow("[user]示意我靠近。"))
		else
			M.beckoned(user)
	return

/datum/intent/unarmed/help
	name = "触碰"
	icon_state = "intouch"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	releasedrain = 0
	rmb_ranged = TRUE

/datum/intent/unarmed/help/rmb_ranged(atom/target, mob/user)
	if(user.stat >= UNCONSCIOUS)
		return
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_green("[user]友善地朝[M]挥了挥手。"), span_green("我友善地朝[M]挥了挥手。"), ignored_mobs = targetl)
		if(M.mind)	// Waving at an NPC doesn't need to show this.
			var/mob/living/L = user
			L.play_overhead_private_rclickemote(targetl, "wavefriendly")
			user.changeNext_move(CLICK_CD_FAST)	// Mostly to prevent spamming the animation too heavily.
			to_chat(M, span_green("[user]友善地向我挥手。"))
	return

/datum/intent/simple/headbutt
	name = "头槌"
	icon_state = "instrike"
	attack_verb = list("头槌猛撞", "撞击")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_d_type = "blunt"

/datum/intent/simple/claw
	name = "抓挠"
	icon_state = "instrike"
	attack_verb = list("抓挠", "啄击")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	miss_text = "朝空气挥了一下"
	item_d_type = "slash"

/datum/intent/simple/bite
	name = "啃咬"
	icon_state = "instrike"
	attack_verb = list("啃咬")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"


/datum/intent/simple/axe
	name = "劈砍"
	icon_state = "instrike"
	attack_verb = list("劈砍", "斩砍", "猛砸")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = list("genchop", "genslash")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"

/datum/intent/simple/spear
	name = "枪刺"
	icon_state = "instrike"
	attack_verb = list("刺击", "穿透")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = list("genthrust", "genstab")
	chargetime = 0
	penfactor = 0
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/datum/intent/bless
	name = "祝福"
	icon_state = "inbless"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/datum/intent/weep
	name = "悲泣"
	icon_state = "inweep"
	no_attack = TRUE
	candodge = FALSE
	canparry = FALSE

/datum/intent/effect
	blade_class = BCLASS_EFFECT
	var/datum/status_effect/intent_effect	//Status effect this intent will apply on a successful hit (damage not needed)
	var/list/target_parts					//Targeted bodyparts which will apply the effect. Leave blank for anywhere on the body.

/datum/intent/effect/daze
	name = "眩晕打击"
	icon_state = "indaze"
	attack_verb = list("击晕")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/daze_hit.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 6
	damfactor = 1
	item_d_type = "blunt"
	intent_effect = /datum/status_effect/debuff/dazed
	target_parts = list(BODY_ZONE_HEAD)
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/*/datum/intent/effect/daze/shield
	intent_effect = /datum/status_effect/debuff/dazed/shield
	swingdelay = 3 */
