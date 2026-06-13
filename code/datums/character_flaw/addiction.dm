/mob/proc/sate_addiction()
	return

/mob/living/carbon/human/sate_addiction(addiction_type)
	var/datum/charflaw/addiction/A

	// If a specific addiction type is requested, only sate that one.
	if(addiction_type)
		if(length(vices))
			for(var/datum/charflaw/vice in vices)
				if(istype(vice, addiction_type))
					A = vice
					break
		if(!A && istype(charflaw, addiction_type))
			A = charflaw
	else
		// Otherwise, try to find an addiction vice (prefer an unsated one).
		if(length(vices))
			for(var/datum/charflaw/vice in vices)
				if(!istype(vice, /datum/charflaw/addiction))
					continue
				var/datum/charflaw/addiction/candidate = vice
				if(!A)
					A = candidate
					continue
				if(A.sated && !candidate.sated)
					A = candidate
		if(!A && istype(charflaw, /datum/charflaw/addiction))
			A = charflaw

	if(!A)
		return

	if(!A.sated)
		to_chat(src, span_blue(A.sated_text))
	A.sated = TRUE
	A.time = initial(A.time) //reset roundstart sate offset to standard
	A.next_sate = world.time + A.time
	remove_stress(A.stress_event)  // Remove vice-specific stress event
	if(A.debuff)
		remove_status_effect(A.debuff)

/datum/charflaw/addiction
	var/next_sate = 0
	var/sated = TRUE
	var/time = 5 MINUTES
	var/debuff = /datum/status_effect/debuff/addiction
	var/needsate_text
	var/sated_text = "这下好多了……"
	var/unsate_time
	var/stress_event = /datum/stressevent/vice  // Specific stress event type for this vice


/datum/charflaw/addiction/New()
	..()
	time = rand(6 MINUTES, 60 MINUTES)
	next_sate = world.time + time

// Clean up addiction effects when vice is removed
/datum/charflaw/addiction/on_removal(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	// Remove stress event
	if(stress_event)
		H.remove_stress(stress_event)
	// Remove debuff
	if(debuff)
		H.remove_status_effect(debuff)

/datum/charflaw/addiction/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	if(user.mind?.antag_datums)
		for(var/datum/antagonist/D in user.mind?.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				return
	var/mob/living/carbon/human/H = user
	var/oldsated = sated
	if(oldsated)
		if(next_sate)
			if(world.time > next_sate)
				sated = FALSE
	if(sated != oldsated)
		unsate_time = world.time
		if(needsate_text)
			to_chat(user, span_boldwarning("[needsate_text]"))
	if(!sated)
		H.add_stress(stress_event)  // Use vice-specific stress event
		if(debuff)
			H.apply_status_effect(debuff)

/datum/status_effect/debuff/addiction //generic
	id = "addiction"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction
	effectedstats = list(STATKEY_WIL = -1,STATKEY_LCK = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/addiction //generic
	name = "成瘾"
	desc = ""
	icon_state = "debuff"

/// ALCOHOLIC

/datum/charflaw/addiction/alcoholic
	name = "酒鬼"
	desc = "喝酒是我最喜欢的事。"
	time = 90 MINUTES
	needsate_text = "该来一杯了。"
	stress_event = /datum/stressevent/vice/alcoholic
	debuff = /datum/status_effect/debuff/addiction/alcoholic

/datum/status_effect/debuff/addiction/alcoholic
	id = "addiction_alcoholic"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/alcoholic
	effectedstats = list(STATKEY_INT = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/alcoholic
	name = "酒精戒断"
	desc = "我开始觉得宿醉上头了。要赶走宿醉，最好的办法就是再来一杯。"
	icon_state = "alcoholic"

/// KLEPTOMANIAC

/datum/charflaw/addiction/kleptomaniac
	name = "盗贼习性"
	desc = "小时候我得靠偷窃活下去。不管后来变没变，我就是改不了这毛病。"
	time = 60 MINUTES
	needsate_text = "我得去偷点什么！不然我会死的！"
	stress_event = /datum/stressevent/vice/kleptomaniac
	debuff = /datum/status_effect/debuff/addiction/kleptomaniac

/datum/status_effect/debuff/addiction/kleptomaniac
	id = "addiction_kleptomaniac"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/kleptomaniac
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/debuff/addiction/kleptomaniac
	name = "盗窃癖"
	desc = "我已经有段时间没摸过别人的口袋了，手指痒得想偷东西。"
	icon_state = "kleptomaniac"

/// JUNKIE

/datum/charflaw/addiction/junkie
	name = "瘾君子"
	desc = "我需要来一场真正的飘飘欲仙，才能忘掉这腐烂世界的痛苦。"
	time = 90 MINUTES
	needsate_text = "该狠狠干一口了。"
	stress_event = /datum/stressevent/vice/junkie
	debuff = /datum/status_effect/debuff/addiction/junkie

/datum/status_effect/debuff/addiction/junkie
	id = "addiction_junkie"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/junkie
	effectedstats = list(STATKEY_STR = -1, STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/junkie
	name = "药瘾发作"
	desc = "距离我上次来一口已经太久了。我得整点够劲的东西。"
	icon_state = "junkie"

/// Smoker

/datum/charflaw/addiction/smoker
	name = "烟鬼"
	desc = "我得抽点什么，才能缓缓神。"
	time = 90 MINUTES
	needsate_text = "该来一口够味的烟了。"
	stress_event = /datum/stressevent/vice/smoker
	debuff = /datum/status_effect/debuff/addiction/smoker

/datum/status_effect/debuff/addiction/smoker
	id = "addiction_smoker"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/smoker
	effectedstats = list(STATKEY_STR = -1, STATKEY_CON = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/smoker
	name = "黑肺"
	desc = "我得抽上一口，得缓缓这股劲。"
	icon_state = "smoker"

/// GOD-FEARING

/datum/charflaw/addiction/godfearing
	name = "虔诚信徒"
	desc = "我得在主的领域里向祂祈祷，这会让我和我的祈祷都更有力量。"
	time = 60 MINUTES
	needsate_text = "该向我的主祈祷了。"
	stress_event = /datum/stressevent/vice/godfearing
	debuff = /datum/status_effect/debuff/addiction/godfearing

/datum/status_effect/debuff/addiction/godfearing
	id = "addiction_godfearing"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/godfearing
	effectedstats = list(STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/debuff/addiction/godfearing
	name = "惧神"
	desc = "距离我上次祈祷已经太久了。我的主就要把目光从我身上移开。"
	icon_state = "godfearing"

/// SADIST

/datum/charflaw/addiction/sadist
	name = "施虐狂"
	desc = "没有什么比他人的痛苦更令人愉悦。"
	time = 60 MINUTES
	needsate_text = "我得听见谁在呜咽。"
	stress_event = /datum/stressevent/vice/sadist
	debuff = /datum/status_effect/debuff/addiction/sadist

/datum/status_effect/debuff/addiction/sadist
	id = "addiction_sadist"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/sadist
	effectedstats = list(STATKEY_WIL = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/sadist
	name = "施虐渴求"
	desc = "我得听见谁在呜咽。唯有他人的哭喊才能让我好受。"
	icon_state = "sadist"

/// MASOCHIST

/datum/charflaw/addiction/masochist
	name = "受虐狂"
	desc = "我喜欢疼痛的感觉，喜欢到怎么都不够。"
	time = 60 MINUTES
	needsate_text = "我需要有人来伤害我。"
	stress_event = /datum/stressevent/vice/masochist
	debuff = /datum/status_effect/debuff/addiction/masochist

/datum/status_effect/debuff/addiction/masochist
	id = "addiction_masochist"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/masochist
	effectedstats = list(STATKEY_CON = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/masochist
	name = "受虐渴求"
	desc = "我就该受苦。不，我必须受苦。"
	icon_state = "masochist"

/// NYMPHOMANIAC

/datum/charflaw/addiction/lovefiend
	name = "性欲亢进"
	desc = "我必须做爱！"
	time = 90 MINUTES
	needsate_text = "我情欲翻涌。"
	stress_event = /datum/stressevent/vice/nympho
	debuff = /datum/status_effect/debuff/addiction/nympho

/datum/status_effect/debuff/addiction/nympho
	id = "addiction_nympho"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/nympho
	effectedstats = list(STATKEY_WIL = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/nympho
	name = "性欲亢进"
	desc = "我必须做爱。欲火灼烧着我的下腹，迟迟不得满足。"
	icon_state = "nymphomaniac"

/datum/charflaw/addiction/baothamarked
	name = "巴奥莎之印"
	desc = "我被巴奥莎的印记烙上了标记。"
	time = 45 MINUTES
	needsate_text = "我的印记正痛苦地灼烧着。"
	sated_text = "印记的光芒渐渐黯淡，宽慰感涌上心头……"
	stress_event = /datum/stressevent/vice/baothamarked
	debuff = /datum/status_effect/debuff/addiction/baothamarked

/datum/status_effect/debuff/addiction/baothamarked
	id = "addiction_baothamark"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/baothamarked
	effectedstats = list(STATKEY_CON = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/baothamarked
	name = "巴奥莎狂热"
	desc = "那道遭诅咒的符印。它在我的血肉上灼灼发亮，把我下腹烧得满是痛苦而难耐的释放欲望。"
	icon_state = "nymphomaniac"
