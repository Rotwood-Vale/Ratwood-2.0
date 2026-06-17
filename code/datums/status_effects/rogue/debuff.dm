/datum/status_effect/debuff
	status_type = STATUS_EFFECT_REFRESH

///////////////////////////

/datum/status_effect/debuff/hungryt1
	id = "hungryt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt1
	effectedstats = list(STATKEY_CON = -1)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/hungryt1
	name = "饥饿"
	desc = "饥饿使这具活着的身体变得虚弱。"
	icon_state = "hunger1"

/datum/status_effect/debuff/hungryt2
	id = "hungryt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt2
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -1)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/hungryt2
	name = "饥饿"
	desc = "这具活着的身体正深受饥饿折磨。"
	icon_state = "hunger2"

/datum/status_effect/debuff/hungryt3
	id = "hungryt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt3
	effectedstats = list(STATKEY_STR = -5, STATKEY_CON = -3, STATKEY_WIL = -2)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/hungryt3
	name = "饥饿"
	desc = "我的身体快撑不住了！"
	icon_state = "hunger3"

/datum/status_effect/debuff/thirstyt1
	id = "thirsty1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt1
	effectedstats = list(STATKEY_WIL = -1)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/thirstyt1
	name = "口渴"
	desc = "我需要水。"
	icon_state = "thirst1"

/datum/status_effect/debuff/thirstyt2
	id = "thirsty2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt2
	effectedstats = list(STATKEY_SPD = -1, STATKEY_WIL = -2)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/thirstyt2
	name = "口渴"
	desc = "我的嘴里越来越干。"
	icon_state = "thirst2"

/datum/status_effect/debuff/thirstyt3
	id = "thirsty3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt3
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -2, STATKEY_WIL = -3)
	duration = 100
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/thirstyt3
	name = "口渴"
	desc = "我急需喝水！"
	icon_state = "thirst3"

/////////

/datum/status_effect/debuff/uncookedfood
	id = "uncookedfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/uncookedfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER) || HAS_TRAIT(owner, TRAIT_ORGAN_EATER) || HAS_TRAIT(owner, TRAIT_WILD_EATER))
		return ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(100)
	return ..()

/datum/status_effect/debuff/badmeal
	id = "badmeal"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/badmeal/on_apply()
	owner.add_stress(/datum/stressevent/badmeal)
	return ..()

/datum/status_effect/debuff/burnedfood
	id = "burnedfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/burnedfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER))
		return ..()
	owner.add_stress(/datum/stressevent/burntmeal)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(100)
	return ..()

/datum/status_effect/debuff/rotfood
	id = "rotfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/rotfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER) || HAS_TRAIT(owner, TRAIT_ROT_EATER))
		return ..()
	owner.add_stress(/datum/stressevent/rotfood)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(200)
	return ..()

/datum/status_effect/debuff/bleeding
	id = "bleedingt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt1
	effectedstats = list(STATKEY_SPD = -1)
	duration = -1
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/bleedingt1
	name = "头晕"
	desc = ""
	icon_state = "bleed1"

/datum/status_effect/debuff/bleedingworse
	id = "bleedingt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt2
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -2)
	duration = -1
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/bleedingt2
	name = "昏眩"
	desc = ""
	icon_state = "bleed2"

/datum/status_effect/debuff/bleedingworst
	id = "bleedingt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt3
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -4)
	duration = -1
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/bleedingt3
	name = "枯竭"
	desc = ""
	icon_state = "bleed3"

/datum/status_effect/debuff/sleepytime
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sleepytime
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/netted
	name = "网住"
	desc = "一张网罩在我身上......我还怎么动？"
	icon_state = "muscles"

/datum/status_effect/debuff/netted
	id = "net"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/netted
	effectedstats = list(STATKEY_SPD = -5, STATKEY_WIL = -2)
	duration = 30 SECONDS

/datum/status_effect/debuff/netted/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, multiplicative_slowdown = 3)

/datum/status_effect/debuff/netted/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.legcuffed = null
		C.update_inv_legcuffed()
		C.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN)

/atom/movable/screen/alert/status_effect/debuff/sleepytime
	name = "疲倦"
	desc = "我该休息一下了。"
	icon_state = "sleepy"

/datum/status_effect/debuff/muscle_sore
	id = "muscle_sore"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/muscle_sore
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/muscle_sore
	name = "肌肉酸痛"
	desc = "我的肌肉需要靠睡眠来恢复。"
	icon_state = "muscles"

/datum/status_effect/debuff/devitalised
	id = "devitalised"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/devitalised
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)	//Slightly punishing.
	duration = 15 MINUTES	//Punishing, same time as revival, but mildly less punishing than revival itself.

/datum/status_effect/debuff/devitalised/lux_ripped
	id = "lux_ripped"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/devitalised/lux_ripped
	effectedstats = list(STATKEY_STR = -5, STATKEY_WIL = -5, STATKEY_CON = -5, STATKEY_SPD = -5, STATKEY_LCK = -5)	//apparently zizite miraclists killing people is BAD so we have to make the debuff so much worse than death to encourage people to just lacrima rather than remove gorget neck chop. this also prevents necromancers from doing a lacrima circle-jerk to farm lux. have fun.
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/debuff/devitalised
	name = "元气受损"
	desc = "我被夺走了某些东西，还需要时间恢复。"

/atom/movable/screen/alert/status_effect/debuff/devitalised/lux_ripped
	name = "灵辉撕裂"
	desc = "我生命的本质被粗暴地从体内撕走了。"

/datum/status_effect/debuff/vamp_dreams
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vamp_dreams
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/vamp_dreams
	name = "顿悟"
	desc = "只要在棺材里睡上一觉，我感觉自己就能变得更强。"
	icon_state = "sleepy"

/datum/status_effect/debuff/ritualdefiled
	id = "ritualdefiled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritualdefiled
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)
	duration = 1 HOURS // Punishing AS FUCK, but not as punishing as being dead.


/atom/movable/screen/alert/status_effect/debuff/ritualdefiled
	name = "受污的灵辉"
	desc = "我的灵辉在邪恶的异端仪式中被玷污了。"

/// SURRENDERING DEBUFFS

/datum/status_effect/debuff/breedable
	id = "breedable"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/breedable
	duration = 30 SECONDS

/datum/status_effect/debuff/breedable/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)

/datum/status_effect/debuff/breedable/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)

/atom/movable/screen/alert/status_effect/debuff/breedable
	name = "顺从"
	desc = "他们不会把我伤得太重......"

/datum/status_effect/debuff/submissive
	id = "submissive"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/submissive
	duration = 60 SECONDS

/datum/status_effect/debuff/submissive/on_apply()
	. = ..()
	owner.add_movespeed_modifier("SUBMISSIVE", multiplicative_slowdown = 4)

/datum/status_effect/debuff/submissive/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("SUBMISSIVE")

/atom/movable/screen/alert/status_effect/debuff/submissive
	name = "屈从"
	desc = "乖乖顺从是我唯一的选择。"

/datum/status_effect/debuff/yield_prompt
	id = "yieldprompt"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/yield_prompt
	duration = 20 SECONDS

/datum/status_effect/debuff/yield_prompt/on_apply()
	if(isliving(owner) && owner.has_flaw(/datum/charflaw/compliant))
		var/mob/living/living_owner = owner
		living_owner.submit(TRUE)
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/debuff/yield_prompt
	name = "屈服吗？"
	desc = "有人在逼我屈服。我该顺从吗，还是继续战斗！"
	icon_state = "compliance"
	alert_group = ALERT_DEBUFF

/atom/movable/screen/alert/status_effect/debuff/yield_prompt/handle_click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/mob/user = usr
	var/paramslist = params2list(params)
	if(paramslist["shift"] && paramslist["left"]) // screen objects don't do the normal Click() stuff so we'll cheat
		examine_ui(user)
		return FALSE
	var/mob/living/L = usr
	if(!istype(L))
		return
	L.submit()
	L.remove_status_effect(attached_effect)

/datum/status_effect/debuff/chilled
	id = "chilled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/chilled
	effectedstats = list(STATKEY_SPD = -5, STATKEY_STR = -2, STATKEY_WIL = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/chilled
	name = "寒战"
	desc = "我的四肢几乎失去知觉了！"
	icon_state = "chilled"


/datum/status_effect/debuff/ritesexpended
	id = "ritesexpended"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritesexpended
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/debuff/ritesexpended
	name = "仪式冷却"
	desc = "我还需要过一段时间才能再次施行仪式。"
	icon_state = "ritesexpended"

/datum/status_effect/debuff/ritesexpended_heavy
	id = "ritesexpended_heavy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritesexpended_heavy
	duration = 1 HOURS

/atom/movable/screen/alert/status_effect/debuff/ritesexpended_heavy
	name = "仪式冷却"
	desc = "我要很久以后才能再施行下一次仪式。我已筋疲力尽。"
	icon_state = "ritesexpended"

/datum/status_effect/debuff/ritesexpended_lesser
	id = "ritesexpended_lesser"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritesexpended_lesser
	duration = 5 MINUTES

/atom/movable/screen/alert/status_effect/debuff/ritesexpended_lesser
	name = "仪式冷却"
	desc = "稍等片刻后我就能再次施行仪式。"
	icon_state = "ritesexpended"

/datum/status_effect/debuff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_arms
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 2.5 MINUTES

/atom/movable/screen/alert/status_effect/debuff/call_to_arms
	name = "拉沃克斯的战召"
	desc = "他的声音在你耳边久久回荡，震撼着你的灵魂......"
	icon_state = "call_to_arms"

/datum/status_effect/debuff/ravox_burden
	id = "ravox_burden"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ravox_burden
	effectedstats = list(STATKEY_SPD = -2, STATKEY_WIL = -3)
	duration = 12 SECONDS

/atom/movable/screen/alert/status_effect/debuff/ravox_burden
	name = "拉沃克斯的重担"
	desc = "我的双臂与双腿被神圣锁链束缚！\n"
	icon_state = "restrained"

/datum/status_effect/debuff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 2.5 MINUTES

/atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	name = "屠戮号令"
	desc = "腐臭的气味灌满你的鼻腔，格拉加尔的屠戮号令震得你灵魂发颤......"
	icon_state = "call_to_slaughter"

//For revive - your body DIDN'T rot, but it did suffer damage. Unlike being rotted, this one is only timed. Not forever.
/datum/status_effect/debuff/revived
	id = "revived"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/revived
	effectedstats = list(STATKEY_STR = -1, STATKEY_PER = -1, STATKEY_INT = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)
	duration = 15 MINUTES		//Should be long enough to stop someone from running back into battle. Plus, this stacks with body-rot debuff. RIP.

/atom/movable/screen/alert/status_effect/debuff/revived
	name = "复生虚弱"
	desc = "你感到生命本身流过全身，修复了你的灵辉与精华。你......活过来了，但身体仍在疼痛，还需要时间恢复......"
	icon_state = "revived"

//For de-rot - your body ROTTED. Harsher penalty for longer, can be fully off-set with a cure-rot potion.
/datum/status_effect/debuff/rotted
	id = "rotted_body"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rotted
	effectedstats = list(STATKEY_STR = -2, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_WIL = -2, STATKEY_CON = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = 30 MINUTES	//Back to a temporary 30 min duration. It hurts.

/atom/movable/screen/alert/status_effect/debuff/rotted
	name = "尸腐麻痹"
	desc = "你从死亡中归来，但浑身都在作痛......你能在肌肉里感到这种痛楚，甚至鼻腔里都充满腐败恶臭。你还活着，可代价又是什么......？"
	icon_state = "rotted_body"

//Replaces the flat-stat change, this should ONLY apply to zombies who have been dead for some time. Makes them easier to kill.
/datum/status_effect/debuff/rotted_zombie
	id = "rotted_zombie"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rotted_zombie
	effectedstats = list(STATKEY_CON = -8)
	//No duration = infinate in time - this is removed on de-rot miricle OR de-rot surgery. Won't be applied unless you've been a zombie for ~20 min.

/atom/movable/screen/alert/status_effect/debuff/rotted_zombie
	name = "腐烂尸体"
	desc = "你已经死去一段时间了......你的身体终于开始彻底崩坏。"
	icon_state = "rotted_body"	//Temp holdover, no idea what I'd do for a new icon for this.

/datum/status_effect/debuff/dazed
	id = "dazed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed
	effectedstats = list(STATKEY_PER = -2, STATKEY_INT = -2)
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/debuff/dazed/shield
	effectedstats = list(STATKEY_PER = -3, STATKEY_LCK = -1)
	duration = 8 SECONDS

/datum/status_effect/debuff/dazed/unarmed
	effectedstats = list(STATKEY_INT = -2, STATKEY_LCK = -1)
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/debuff/dazed
	name = "头昏脑涨"
	desc = "你的脑袋挨了重重一下。等等，左边是哪边来着？"
	icon_state = "dazed"

/datum/status_effect/debuff/cold
	id = "Frostveiled"
	alert_type =  /atom/movable/screen/alert/status_effect/debuff/cold
	effectedstats = list(STATKEY_SPD = -2)
	duration = 12 SECONDS

/datum/status_effect/debuff/cold/on_apply()
	. = ..()
	var/mob/living/target = owner
	var/newcolor = rgb(136, 191, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 12 SECONDS)

/atom/movable/screen/alert/status_effect/debuff/cold
	name = "寒冷"
	desc = "有什么东西让我冷到骨子里了！动起来都变得困难。"
	icon_state = "muscles"

/*/atom/movable/screen/alert/status_effect/debuff/dazed/shield
	name = "Dazed by fencer's wrap"
	desc = "That stupid piece of cloth is so distracting! It pisses me off!"
	icon_state = "dazed" */

/datum/status_effect/debuff/staggered
	id = "staggered"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/staggered
	effectedstats = list(STATKEY_PER = -2, STATKEY_SPD = -2, STATKEY_CON = -2)
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/debuff/staggered
	name = "踉跄"
	desc = "你被某个大家伙狠狠干了一下，冲击力让你站立不稳。"
	icon_state = "dazed"

/datum/status_effect/debuff/staggered/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/staggered/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/datum/status_effect/debuff/excomm
	id = "Excommunicated!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/excomm
	effectedstats = list(STATKEY_LCK = -2, STATKEY_INT = -2, STATKEY_SPD = -1, STATKEY_WIL = -1, STATKEY_CON = -1)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/excomm
	name = "被逐出教会！"
	desc = "十神已将我遗弃！"
	icon_state = "muscles"
	color ="#6d1313"

/datum/status_effect/debuff/apostasy
	id = "Apostasy!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/apostasy
	effectedstats = list(STATKEY_LCK = -5, STATKEY_INT = -3, STATKEY_PER = -2, STATKEY_SPD = -2, STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = -1
	var/resistant = FALSE
	var/original_devotion = 0
	var/original_prayer_effectiveness = 0
	var/original_passive_devotion_gain = 0
	var/original_passive_progression_gain = 0

/datum/status_effect/debuff/apostasy/on_creation(mob/living/new_owner, resistant = FALSE)
	src.resistant = resistant
	return ..()

/datum/status_effect/debuff/apostasy/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!H.devotion)
		return FALSE

	var/datum/devotion/D = H.devotion
	original_devotion = D.devotion
	original_prayer_effectiveness = D.prayer_effectiveness
	original_passive_devotion_gain = D.passive_devotion_gain
	original_passive_progression_gain = D.passive_progression_gain

	if(resistant)
		D.devotion = original_devotion * 0.5
		D.prayer_effectiveness = original_prayer_effectiveness * 0.5
		D.passive_devotion_gain = original_passive_devotion_gain * 0.5
		D.passive_progression_gain = original_passive_progression_gain * 0.5
	else
		D.devotion = 0
		D.prayer_effectiveness = 0
		D.passive_devotion_gain = 0
		D.passive_progression_gain = 0

	to_chat(H, span_boldnotice("我已被逐出教会，现在无法再获得虔信。"))
	return ..()

/datum/status_effect/debuff/apostasy/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.devotion)
			var/datum/devotion/D = H.devotion
			D.devotion = original_devotion
			D.prayer_effectiveness = original_prayer_effectiveness
			D.passive_devotion_gain = original_passive_devotion_gain
			D.passive_progression_gain = original_passive_progression_gain

		to_chat(H, span_boldnotice("我已被教会重新接纳，现在又能获得虔信了。"))

/atom/movable/screen/alert/status_effect/debuff/apostasy
	name = "背教！"
	desc = "神职人员蒙羞！"
	icon_state = "debuff"
	color ="#7a0606"

/datum/status_effect/debuff/hereticsermon
	id = "Heretic on sermon!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hereticsermon
	effectedstats = list(STATKEY_INT = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/debuff/hereticsermon
	name = "异端听道！"
	desc = "我参加了布道。我的主神并不以我为荣。"
	icon_state = "debuff"
	color ="#af9f9f"

/datum/status_effect/debuff/necrandeathdoorwilloss
	id = "Necran Deathly calm!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/necranwilloss
	effectedstats = list(STATKEY_WIL = -4)
	tick_interval = 5 SECONDS

/datum/status_effect/debuff/necrandeathdoorwilloss/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/necrandeathdoorwilloss/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/necrandeathdoorwilloss/process()
	.=..()
	owner.energy_add(-1)	//being in death's edge drains energy from people
	var/area/rogue/our_area = get_area(owner)
	if(isnull(our_area) || !(our_area.necra_area))
		owner.remove_status_effect(src)

/atom/movable/screen/alert/status_effect/debuff/necranwilloss
	name = "内克拉的死寂安宁！"
	desc = "我正站在吾主领域的边缘，如此死寂的安宁让我意志消沉。"
	icon_state = "debuff"
	color ="#af9f9f"

/datum/status_effect/debuff/deathdoorwilloss
	id = "Deathly calm!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/deathdoorwilloss
	effectedstats = list(STATKEY_WIL = -8)
	tick_interval = 5 SECONDS

/datum/status_effect/debuff/deathdoorwilloss/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/deathdoorwilloss/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/deathdoorwilloss/process()
	.=..()
	owner.energy_add(-1)	//being in death's edge drains energy from people
	var/area/rogue/our_area = get_area(owner)
	if(isnull(our_area) || !(our_area.necra_area))
		owner.remove_status_effect(src)

/atom/movable/screen/alert/status_effect/debuff/deathdoorwilloss
	name = "死寂安宁！"
	desc = "我正站在死亡领域的边缘，如此死寂的安宁让人难以提起干劲。"
	icon_state = "debuff"
	color ="#af9f9f"

/atom/movable/screen/alert/status_effect/emberwine
	name = "催情"
	desc = "温热正蔓延至我的全身......"
	icon_state = "emberwine"

/datum/status_effect/debuff/emberwine
	id = "emberwine"
	effectedstats = list("strength" = -1, "willpower" = -2, "speed" = -2, "intelligence" = -3)
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/emberwine

/* Kockout */
/datum/status_effect/debuff/knockout
	id = "knockout"
	effectedstats = null
	alert_type = null
	duration = 12 SECONDS
	var/time = 0

/datum/status_effect/debuff/knockout/tick()
	time += 1
	switch(time)
		if(3)
			if(prob(50)) //You don't always know...
				var/msg = pick("我觉得好困......", "我感觉放松了。", "我的眼皮有点沉。")
				to_chat(owner, span_warn(msg))

		if(5)
			if(prob(50))
				owner.Slowdown(20)
			else
				owner.Slowdown(10)
		if(8)
			if(iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/msg = pick("yawn", "cough", "clearthroat")
				C.emote(msg, forced = TRUE)
		if(12)
			// it's possible that stacking effects delay this.
			// If we hit 12 regardless we end
			Destroy()

/datum/status_effect/debuff/knockout/on_remove()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(C.IsSleeping()) //No need to add more it's already pretty long.
			return ..()
		C.SetSleeping(20 SECONDS)
	..()

/atom/movable/screen/alert/status_effect/debuff/knockout
	name = "困倦"

/datum/status_effect/debuff/lost_naledi_mask
	id = "naledimask"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/naledimask
	effectedstats = list(STATKEY_WIL = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/naledimask
	name = "失去面具"
	desc = "没有面具，精灵与恶魔随时都可能找上我。这很危险。"
	icon_state = "muscles"

/datum/status_effect/debuff/lost_shaman_hood
	id = "shaman_hood"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/shamanhood
	effectedstats = list(STATKEY_WIL = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/shamanhood
	name = "失去兜帽"
	desc = "圣兜帽遗失了。失去它后我感到虚弱而空乏。"

/datum/status_effect/debuff/lost_oath_ring
	id = "oath_ring"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/oath_ring
	effectedstats = list(STATKEY_PER = -2, STATKEY_INT = -2)

/atom/movable/screen/alert/status_effect/debuff/oath_ring
	name = "失去誓印"
	desc = "我誓言的证明......不见了！"

///////////////////////
/// CLIMBING STUFF ///
/////////////////////

/// OPEN SPACE TURF BASED CLIMBING, MOB DRAG-DROP TILE
/datum/status_effect/debuff/climbing_lfwb
	id = "climbing_lfwb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/climbing_lfwb
	tick_interval = 10
	var/stamcost = 30
	var/stamcost_final = 30
	var/mob/living/carbon/human/climber

/datum/status_effect/debuff/climbing_lfwb/on_creation(mob/living/new_owner, new_stamcost)
	stamcost = new_stamcost
	return ..()

/datum/status_effect/debuff/climbing_lfwb/on_apply()
	. = ..()
	climber = owner
	climber.climbing = TRUE
	climber.put_in_hands(new /obj/item/clothing/wall_grab, TRUE, FALSE, TRUE) // gotta have new before /obj/... , otherwise its gonna die

/datum/status_effect/debuff/climbing_lfwb/tick() // do we wanna do this shit every single second? I guess we do boss
	. = ..()
	climber = owner
	if((istype(climber.backr, /obj/item/clothing/climbing_gear)) || (istype(climber.backl, /obj/item/clothing/climbing_gear)))
		stamcost_final = stamcost / 2
		climber.stamina_add(stamcost_final) // every tick interval this much stamina is deducted
	else
		stamcost_final = stamcost
		climber.stamina_add(stamcost_final) // every tick interval this much stamina is deducted
//	to_chat(climber, span_warningbig("[stamcost_final] REMOVED!")) // debug msg
	var/turf/tile_under_climber = climber.loc
	var/list/random_shit_under_climber = list()
	for(var/obj/structure/flora/newbranch/branch in climber.loc)
		random_shit_under_climber += branch
	for(var/obj/machinery/light/rogue/chand/chandelier in climber.loc)
		random_shit_under_climber += chandelier
	for(var/obj/structure/kybraxor/fucking_hatch in climber.loc)
		random_shit_under_climber += fucking_hatch
	if(!istype(tile_under_climber, /turf/open/transparent/openspace))// if we aren't on open space turf, remove debuff (aka our feet are on solid shi or water)
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	if(random_shit_under_climber.len) // branches dont remove open space turf, so we have to check for it separately
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	else if(climber.stamina >= climber.max_stamina) // if we run out of green bar stamina, we fall
		to_chat(climber, span_dead("我再也抓不住这处边缘了！"))
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
		tile_under_climber.zFall(climber)


/datum/status_effect/debuff/climbing_lfwb/on_remove()
	. = ..()
	climber = owner
	climber.climbing = FALSE
	climber.reset_offsets("wall_press")
	if(climber.is_holding_item_of_type(/obj/item/clothing/wall_grab)) // the slop slops itself holy shit
		for(var/obj/item/clothing/wall_grab/I in climber.held_items)
			if(istype(I, /obj/item/clothing/wall_grab))
				qdel(I)
				return

/atom/movable/screen/alert/status_effect/debuff/climbing_lfwb
	name = "攀爬中......"
	desc = "如你所见，你正在攀爬，伙计。"
	icon_state = "muscles"

/datum/status_effect/debuff/mesmerised
	id = "mesmerised"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mesmerised
	effectedstats = list(STATKEY_STR = -2, STATKEY_LCK = -2, STATKEY_PER = -2, STATKEY_SPD = -2)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/mesmerised
	name = "痴迷"
	desc = span_warning("那份美丽简直不似凡尘......")
	icon_state = "acid"

/////////////////////////
///HARPY FLIGHT STUFF///
///////////////////////

/datum/status_effect/debuff/harpy_flight
	id = "harpy_flight"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/harpy_flight
	tick_interval = 10
	var/obj/effect/flyer_shadow/shadow
	var/mob/living/carbon/human/harpy
	var/mob/living/carbon/human/passenger
	var/stamcost = 9
	var/obj/item/organ/wings/harpy/harpy_wings
	/// Buckled mob if someone decides to mount the flying harpy
	var/datum/weakref/buckled_mob

/datum/status_effect/debuff/harpy_flight/on_creation(mob/living/new_owner, new_stamcost)
	stamcost = new_stamcost
	harpy_wings = new_owner.getorganslot(ORGAN_SLOT_WINGS)
	return ..()

/datum/status_effect/debuff/harpy_flight/on_apply()
	. = ..()
	harpy = owner
	animate(harpy, pixel_y = harpy.pixel_y + 3, time = 6, loop = -1) // thank you shadowdeath6
	animate(pixel_y = harpy.pixel_y - 3, time = 6) // thank you oog
	harpy.drop_all_held_items()
	for(var/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/talons in harpy_wings.nullspace_items)
		var/talons_final = talons
		harpy.put_in_hands(talons_final, TRUE, FALSE, TRUE)
		break
	harpy.movement_type |= FLYING
	harpy.dna.species.speedmod += 0.3
	harpy.remove_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD) // If they are slowed down (like being in water) remove it
	harpy.add_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE, 100, override=TRUE, multiplicative_slowdown = harpy.dna.species.speedmod)
	harpy.apply_status_effect(/datum/status_effect/debuff/flight_sound_loop)
	ADD_TRAIT(harpy, TRAIT_SPELLCOCKBLOCK, ORGAN_TRAIT)
	harpy.flying = TRUE
	init_signals()
	var/mob/buckled_rider = harpy.buckled_mobs[1]
	if(!isnull(buckled_rider))
		buckled_mob = WEAKREF(buckled_rider)
		buckled_rider.movement_type |= FLYING

/datum/status_effect/debuff/harpy_flight/tick()
	. = ..()
	harpy = owner
	var/stamcost_final = stamcost
	if(harpy.pulling)
		stamcost_final = stamcost * 2
	harpy.stamina_add(stamcost_final)
//	to_chat(harpy, span_warningbig("[stamcost_final] REMOVED!")) // debug msg
	if(harpy.pulledby)
		passenger = harpy.pulling
		if(harpy.pulledby != passenger)
			to_chat(harpy, span_bloody("有人这样抓着我，我没法飞，啊啊！！"))
			harpy.remove_status_effect(/datum/status_effect/debuff/harpy_flight)
	if(harpy.buckled)
		to_chat(harpy, span_bloody("哈，这下该让我的翅膀歇歇了！"))
		harpy.remove_status_effect(/datum/status_effect/debuff/harpy_flight)
	if(harpy.mind)
		harpy.mind.add_sleep_experience(/datum/skill/misc/athletics, (harpy.STAINT*0.03), FALSE)
	if(!(harpy.mobility_flags & MOBILITY_STAND))
		to_chat(harpy, span_bloody("我失去平衡成这样，没法扇动翅膀，啊啊！！"))
		harpy.remove_status_effect(/datum/status_effect/debuff/harpy_flight)
	if(harpy.stamina >= harpy.max_stamina)
		to_chat(harpy, span_bloody("我已经撑不了多久再扇翅了，啊啊！！"))
		harpy.remove_status_effect(/datum/status_effect/debuff/harpy_flight)

/datum/status_effect/debuff/harpy_flight/on_remove()
	. = ..()
	harpy = owner
	if(harpy.pulling)
		harpy.stop_pulling()
	harpy.remove_status_effect(/datum/status_effect/debuff/flight_sound_loop)
	harpy.dna.species.speedmod -= 0.3
	harpy.remove_movespeed_modifier(MOVESPEED_ID_SPECIES, TRUE)
	var/turf/tile_under_harpy = harpy.loc
	harpy.movement_type &= ~FLYING
	tile_under_harpy.zFall(harpy)
	remove_signals()
	animate(harpy)
	REMOVE_TRAIT(harpy, TRAIT_SPELLCOCKBLOCK, ORGAN_TRAIT)
	harpy.flying = FALSE
	if(harpy.is_holding_item_of_type(/obj/item/rogueweapon/huntingknife/idagger/harpy_talons))
		for(var/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/talons in harpy.held_items)
			harpy.dropItemToGround(talons, TRUE)
			return
	var/mob/buckled_rider = buckled_mob.resolve()
	if(!isnull(buckled_rider))
		buckled_rider.movement_type &= ~FLYING
	buckled_mob = null

/atom/movable/screen/alert/status_effect/debuff/harpy_flight
	name = "飞行中......"
	desc = "嘻嘻！！"
	icon_state = "muscles"

/obj/effect/flyer_shadow
	name = "人形影子"
	desc = "某个从上方飞过之物投下的影子。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow"
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	alpha = 130
	pixel_y = -5
	var/datum/weakref/flying_ref

/obj/effect/flyer_shadow/Initialize(mapload, flying_mob)
	. = ..()
	if(flying_mob)
		flying_ref = WEAKREF(flying_mob)
	transform = matrix() * 0.8 // Make the shadow slightly smaller

/obj/effect/flyer_shadow/Destroy()
	flying_ref = null
	return ..()

/datum/status_effect/debuff/harpy_flight/proc/init_signals()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(check_movement))
	RegisterSignal(owner, COMSIG_LIVING_UPDATE_TURF_MOVESPEED, PROC_REF(on_turf_movespeed_update))
	RegisterSignal(owner, COMSIG_MOVABLE_BUCKLE, PROC_REF(harpy_mob_buckled))
	RegisterSignal(owner, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(harpy_mob_unbuckle))

/datum/status_effect/debuff/harpy_flight/proc/check_movement(datum/source) // rewritten by @tmyqlfpir
	SIGNAL_HANDLER

	var/turf/cur_turf = get_turf(owner)
	if(!cur_turf)
		return
	if(!shadow)
		shadow = new /obj/effect/flyer_shadow(cur_turf, owner)
	while(isopenspace(cur_turf))
		var/turf/temp_turf = GET_TURF_BELOW(cur_turf)
		if(!temp_turf || isclosedturf(temp_turf))
			break
		cur_turf = temp_turf
	shadow.forceMove(cur_turf)

/datum/status_effect/debuff/harpy_flight/proc/on_turf_movespeed_update()
	SIGNAL_HANDLER
	return TURF_MOVESPEED_BLOCKED // Flying harpies do not get slowed down from turfs

/// Updates flight when a mob is buckled as a harpy is already in flight
/datum/status_effect/debuff/harpy_flight/proc/harpy_mob_buckled(datum/source, mob/living/M, force = FALSE)
	SIGNAL_HANDLER
	if(isnull(M))
		return
	buckled_mob = WEAKREF(M)
	M.movement_type |= FLYING

/// Updates flight when a mob is unbuckled as a harpy is already in flight
/datum/status_effect/debuff/harpy_flight/proc/harpy_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	SIGNAL_HANDLER
	var/mob/living/unbuckling_mob = buckled_mob.resolve()
	if(!unbuckling_mob && isnull(M))
		buckled_mob = null
		return
	unbuckling_mob.movement_type &= ~FLYING
	var/turf/tile_under_rider = get_turf(unbuckling_mob)
	tile_under_rider.zFall(unbuckling_mob)
	buckled_mob = null

/datum/status_effect/debuff/harpy_flight/proc/remove_signals()
	UnregisterSignal(owner, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_UPDATE_TURF_MOVESPEED,
		COMSIG_MOVABLE_BUCKLE,
		COMSIG_MOVABLE_UNBUCKLE,
	))
	QDEL_NULL(shadow)

/datum/status_effect/debuff/harpy_passenger
	id = "harpy_passenger"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/harpy_passenger
	tick_interval = 5
	var/mob/living/carbon/human/passenger
	var/mob/living/carbon/human/harpy

/datum/status_effect/debuff/harpy_passenger/on_apply()
	. = ..()
	passenger = owner
	animate(passenger, pixel_y = passenger.pixel_y + 3, time = 6, loop = -1) // thank you shadowdeath6
	animate(pixel_y = passenger.pixel_y - 3, time = 6) // thank you oog
	passenger.movement_type |= FLYING
	passenger.drop_all_held_items() // think fast chucklenuts
	passenger.put_in_hands(new /obj/item/harpy_leg, TRUE, FALSE, TRUE) // will have to make it so ppl can't dismount themselves

/datum/status_effect/debuff/harpy_passenger/tick()
	. = ..()
	passenger = owner
	if(!passenger.pulledby)
		passenger.remove_status_effect(/datum/status_effect/debuff/harpy_passenger)

/datum/status_effect/debuff/harpy_passenger/on_remove()
	. = ..()
	passenger = owner
	animate(passenger)
	if(passenger.is_holding_item_of_type(/obj/item/harpy_leg))
		for(var/obj/item/harpy_leg/I in passenger.held_items)
			if(istype(I, /obj/item/harpy_leg))
				qdel(I)
	if(passenger.pulledby)
		harpy = passenger.pulledby
		harpy.stop_pulling()
	var/turf/tile_under_passenger = passenger.loc
	passenger.movement_type &= ~FLYING
	tile_under_passenger.zFall(passenger)

/atom/movable/screen/alert/status_effect/debuff/harpy_passenger
	name = "被带着飞......"
	desc = "啊啊啊啊放我下去！！"
	icon_state = "muscles"

//////////////////////////////////////
///FLIGHT SOUND LOOP STATUS EFFECT///
////////////////////////////////////

///I MEAN it's the easiest fucking way to do so in my mind LOL
/datum/status_effect/debuff/flight_sound_loop
	id = "flight_sound_loop"
	tick_interval = 16
	alert_type = null
	var/list/wing_flap_sound = list(
		'sound/foley/footsteps/flight_sounds/wingflap1.ogg',
		'sound/foley/footsteps/flight_sounds/wingflap2.ogg',
		'sound/foley/footsteps/flight_sounds/wingflap3.ogg',
		'sound/foley/footsteps/flight_sounds/wingflap4.ogg',
		'sound/foley/footsteps/flight_sounds/wingflap5.ogg',
		'sound/foley/footsteps/flight_sounds/wingflap6.ogg',
	)

/datum/status_effect/debuff/flight_sound_loop/tick()
	. = ..()
	var/mob/living/carbon/human/harpy = owner
	playsound(harpy, pick(wing_flap_sound), 100)

/////////////////////////////
///HARPY FLIGHT STUFF END///
///////////////////////////

/datum/status_effect/debuff/specialcd
	id = "specialcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/specialcd
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/specialcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/atom/movable/screen/alert/status_effect/debuff/specialcd
	name = "特殊机动冷却"
	desc = "我刚用过，必须等等。"
	icon_state = "debuff"

/datum/status_effect/debuff/liver_failure
	id = "liver_failure"
	alert_type = null
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/liver_failure/on_apply()
	if(!iscarbon(owner))
		return FALSE

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	return ..()

/datum/status_effect/debuff/liver_failure/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	return ..()

/datum/status_effect/debuff/liver_failure/proc/on_life(mob/living/carbon/carbon, seconds, times_fired)
	SIGNAL_HANDLER

	INVOKE_ASYNC(carbon, TYPE_PROC_REF(/mob/living/carbon, liver_failure))

/datum/status_effect/debuff/vampbite
	id = "Vampire Bite"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vampbite
	duration = 30 SECONDS

/datum/status_effect/debuff/vampbite/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_DRUQK, id)
	owner.add_stress(/datum/stressevent/high)
	to_chat(owner, span_love("起初你只觉一阵尖锐的痛楚，但它很快化作席卷全身的愉悦......"))
	owner.overlay_fullscreen("vampirebite", /atom/movable/screen/fullscreen/weedsm)
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/datum/status_effect/debuff/vampbite/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DRUQK, id)
	owner.remove_stress(/datum/stressevent/high)
	owner.clear_fullscreen("vampirebite")
	owner.visible_message("[owner]的眼睛似乎恢复正常了。")
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/atom/movable/screen/alert/status_effect/debuff/vampbite
	name = "吸血鬼之咬"
	desc = "你感觉到某种......有趣的变化......"
	icon_state = "acid"

/datum/status_effect/debuff/hobbled
	id = "hobbled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hobbled
	effectedstats = list(STATKEY_SPD = -2)
	duration = 8 SECONDS

/atom/movable/screen/alert/status_effect/debuff/hobbled
	name = "步履蹒跚"
	desc = "你的腿被击中了！冲击让你踉跄不稳！"
	icon_state = "dazed"

/datum/status_effect/debuff/hobbled/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/hobbled/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/datum/status_effect/debuff/freezing
	id = "freezing"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/freezing
	effectedstats = list(STATKEY_CON = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/freezing
	name = "冻僵"
	desc = "太冷了！"
	icon_state = "chilled"

/datum/status_effect/debuff/brittle
	id = "brittle cold"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/brittle
	duration = 10 SECONDS

/datum/status_effect/debuff/brittle/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	to_chat(C, span_warning("寒冷让我的身躯变硬，关节也随之僵住。"))
	ADD_TRAIT(C, TRAIT_CRITICAL_WEAKNESS, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/brittle/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	to_chat(C, span_notice("暖意回归后，我的身躯重新松弛下来。"))
	REMOVE_TRAIT(C, TRAIT_CRITICAL_WEAKNESS, STATUS_EFFECT_TRAIT)

/atom/movable/screen/alert/status_effect/debuff/brittle
	name = "寒脆"
	desc = "我的身躯冷得发脆！"
	icon_state = "chilled"

/datum/status_effect/debuff/overheat
	id = "overheating"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/overheat
	duration = 10 SECONDS
	effectedstats = list(STATKEY_SPD = 2, STATKEY_WIL = -4)

/datum/status_effect/debuff/overheat/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	to_chat(C, span_userdanger("我的核心温度正在上升，身躯过热了。"))

/datum/status_effect/debuff/overheat/on_remove()
	. = ..()
	var/mob/living/carbon/C = owner
	to_chat(C, span_userdanger("我的核心温度恢复正常了。"))

/atom/movable/screen/alert/status_effect/debuff/overheat
	name = "过热"
	desc = "我的身躯过热了！"
	icon_state = "fire"

/datum/status_effect/debuff/kiss_ecstasy
	id = "kiss_ecstasy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/kiss_ecstasy
	effectedstats = list(STATKEY_CON = -2, STATKEY_WIL = -2)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/kiss_ecstasy
	name = "一吻"
	desc = "可怕的甘甜淹没了我的感官。"
	icon_state = "vampirebite"

/datum/status_effect/debuff/malodorous_stink
	id = "malodorous_stink"
	duration = 999 MINUTES
	alert_type = null

	mob_effect_icon = 'icons/effects/effects.dmi'
	mob_effect_icon_state = "mob_smell"
	mob_effect_layer = ABOVE_MOB_LAYER

/datum/status_effect/debuff/stinky_contact
	id = "stinky_contact"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/stinky_contact

/datum/status_effect/debuff/stinky_contact/on_apply()
	. = ..()
	to_chat(owner, span_warning("I reek of someone else's stench now."))
	if(!owner.has_flaw(/datum/charflaw/malodorous) && !HAS_TRAIT(owner, TRAIT_NOSTINK) && owner.can_smell())
		owner.add_stress(/datum/stressevent/stinky_contact)

/datum/status_effect/debuff/stinky_contact/on_remove()
	to_chat(owner, span_notice("The stink finally fades off me."))
	owner.remove_stress(/datum/stressevent/stinky_contact)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/stinky_contact
	name = "Musked"
	desc = "Someone's stench rubbed off on me. I should be able to wash it off, or wait it out."
	icon_state = "debuff"
