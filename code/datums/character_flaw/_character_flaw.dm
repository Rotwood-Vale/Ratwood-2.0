/// Assoc list mapping /datum/charflaw typepaths to detached instances. Mainly for getting stuff like names from the typepath.
/// Initialized at runtime. Should remain stable if nobody's calling procs on New().
GLOBAL_LIST_EMPTY(charflaw_singletons)

/// Associative list mapping the "menu name" of each vice in the list to its typepath. This list is all of the vices you can choose. 
/// Used primarily for adding a vice, but also for randomly picking a vice from the selectable space. Try pick_assoc().
GLOBAL_LIST_INIT(character_flaws, list(
	"酒鬼"=/datum/charflaw/addiction/alcoholic,
	"讨嫌面相"=/datum/charflaw/annoying_face,
	"破碎心智 (+1 TRI)"=/datum/charflaw/mind_broken,
	"视力不佳 (+1 TRI)"=/datum/charflaw/badsight,
	"失明 (+1 TRI)"=/datum/charflaw/noeyeall,
	"粘人"=/datum/charflaw/clingy,
	"色盲 (+1 TRI)"=/datum/charflaw/colorblind,
	"顺从"=/datum/charflaw/compliant,
	"致命脆弱 (+1 TRI)"=/datum/charflaw/critweakness,
	"独眼 (左) (+1 TRI)"=/datum/charflaw/noeyel,
	"独眼 (右) (+1 TRI)"=/datum/charflaw/noeyer,
	"虔诚信徒"=/datum/charflaw/addiction/godfearing,
	"贪婪"=/datum/charflaw/greedy,
	"Marked for Death"=/datum/charflaw/assassintarget,
	"Marked by Gnolls"=/datum/charflaw/hunted,
	"孤僻"=/datum/charflaw/isolationist,
	"瘾君子"=/datum/charflaw/addiction/junkie,
	"无法无天"=/datum/charflaw/lawless,
	"欲望之印" =/datum/charflaw/marked_by_baotha,
	"麻风病人 (+1 TRI)"=/datum/charflaw/leprosy,
	"Loose Straps"=/datum/charflaw/loose_armor,
	"受虐狂"=/datum/charflaw/addiction/masochist,
	"失鼻"=/datum/charflaw/missing_nose,
	"哑巴 (+1 TRI)"=/datum/charflaw/mute,
	"嗜睡症 (+1 TRI)"=/datum/charflaw/narcoleptic,
	"无缺陷 (-3 TRI)"=/datum/charflaw/noflaw,
	"裸睡者"=/datum/charflaw/nude_sleeper,
	"裸体主义者"=/datum/charflaw/nudist,
	"性欲亢进"=/datum/charflaw/addiction/lovefiend,
	"和平主义"=/datum/charflaw/pacifism,
	"偏执"=/datum/charflaw/paranoid,
	"随机或无缺陷"=/datum/charflaw/randflaw,
	"施虐狂"=/datum/charflaw/addiction/sadist,
	"伤疤累累"=/datum/charflaw/scarred,
	"畏银"=/datum/charflaw/silverweakness,
	"失眠 (+1 TRI)"=/datum/charflaw/sleepless,
	"烟鬼"=/datum/charflaw/addiction/smoker,
	"恶臭"=/datum/charflaw/malodorous,
	"丑陋"=/datum/charflaw/ugly,
	"言语不通 (+1 TRI)"=/datum/charflaw/unintelligible,
	"木臂 (左) (+1 TRI)"=/datum/charflaw/limbloss/arm_l,
	"木臂 (右) (+1 TRI)"=/datum/charflaw/limbloss/arm_r,
	"噬血者 (+1 TRI)"=/datum/charflaw/hemophage,
	"体弱"=/datum/charflaw/weak,
	"孱弱"=/datum/charflaw/frail,
	"蹒跚"=/datum/charflaw/slow,
	"愚钝"=/datum/charflaw/dull,
	"倒霉"=/datum/charflaw/unlucky,
	))

/datum/charflaw
	var/name
	var/desc
	var/ephemeral = FALSE // This flaw is currently disabled and will not process

/datum/charflaw/proc/on_mob_creation(mob/user)
	return

/datum/charflaw/proc/apply_post_equipment(mob/user)
	return

/datum/charflaw/proc/flaw_on_life(mob/user)
	return

// Called when a vice is removed from a character to clean up persistent effects
/datum/charflaw/proc/on_removal(mob/user)
	return

/datum/charflaw/proc/on_bath(mob/user)
	return

/mob/proc/has_flaw(flaw)
	return

/mob/living/carbon/human/has_flaw(flaw)
	if(!flaw)
		return
	// Check new multiple vices system
	if(length(vices))
		for(var/datum/charflaw/vice in vices)
			if(istype(vice, flaw))
				return TRUE
	// Legacy single vice check
	if(istype(charflaw, flaw))
		return TRUE
	return FALSE

/mob/proc/get_flaw(flaw_type)
	return

/mob/living/carbon/human/get_flaw(flaw_type)
	if(!flaw_type)
		return
	// Check new multiple vices system
	if(length(vices))
		for(var/datum/charflaw/vice in vices)
			if(istype(vice, flaw_type))
				return vice
	// Legacy single vice check
	if(istype(charflaw, flaw_type))
		return charflaw
	return

/datum/charflaw/randflaw
	name = "随机或无"
	desc = "有 50% 几率获得一个随机缺陷，也有 50% 几率完全没有缺陷。"

/datum/charflaw/randflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(prob(50))
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		H.charflaw = new charflaw()
		H.charflaw.on_mob_creation(H)
	else
		H.charflaw = new /datum/charflaw/eznoflaw()
		H.charflaw.on_mob_creation(H)


/datum/charflaw/eznoflaw
	name = "无缺陷"
	desc = "我是个正常人，这可真稀罕！"

/datum/charflaw/noflaw
	name = "无缺陷 (-3 TRI)"
	desc = "我是个正常人，这可真稀罕！（消耗 3 点 triumph，否则会获得随机缺陷。）"

/datum/charflaw/noflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(H.get_triumphs() < 3)
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/randflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/randflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		H.charflaw = new charflaw()
		H.charflaw.on_mob_creation(H)
	else
		H.adjust_triumphs(-3)

/datum/charflaw/badsight
	name = "视力不佳"
	desc = "我这些年读书太多，得戴眼镜才能正常看清。"

/datum/charflaw/badsight/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		if(isclothing(H.wear_mask))
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/spectacles))
				var/obj/item/I = H.wear_mask
				if(!I.obj_broken)
					return
	H.blur_eyes(2)
	H.apply_status_effect(/datum/status_effect/debuff/badvision)

/datum/status_effect/debuff/badvision
	id = "badvision"
	alert_type = null
	effectedstats = list(STATKEY_PER = -20, STATKEY_SPD = -5)
	duration = 10 SECONDS

/datum/charflaw/badsight/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/spectacles(H), SLOT_WEAR_MASK)
	else
		new /obj/item/clothing/mask/rogue/spectacles(get_turf(H))

	// we don't seem to have a mind when on_mob_creation fires, so set up a timer to check when we probably will
	addtimer(CALLBACK(src, PROC_REF(apply_reading_skill), H), 5 SECONDS)

/datum/charflaw/badsight/proc/apply_reading_skill(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_triumphs(1)

/datum/charflaw/malodorous
	name = "恶臭"
	desc = "如果不经常洗澡，我身上的体味会臭得难以忍受，别人也闻得出来。"
	var/last_aura_tick = 0
	var/aura_tick_delay = 5 SECONDS
	var/suppressed_until = 0

/datum/charflaw/malodorous/proc/is_reeking()
	return world.time >= suppressed_until

/datum/charflaw/malodorous/on_bath(mob/living/user)
	if(!ishuman(user))
		return
	suppressed_until = world.time + 30 MINUTES
	user.remove_status_effect(/datum/status_effect/debuff/malodorous_stink)
	to_chat(user, span_notice("我把这股臭味洗掉了。接下来一阵子应该能清爽些。"))

/datum/charflaw/malodorous/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/should_reek = is_reeking() && H.can_smell()

	if(should_reek && user.mind?.antag_datums)
		for(var/datum/antagonist/D in user.mind?.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				should_reek = FALSE
				break

	if(should_reek)
		H.apply_status_effect(/datum/status_effect/debuff/malodorous_stink)
	else
		H.remove_status_effect(/datum/status_effect/debuff/malodorous_stink)

	if(!should_reek)
		return
	if(world.time < last_aura_tick + aura_tick_delay)
		return
	last_aura_tick = world.time
	apply_stink_aura(H)

/datum/charflaw/malodorous/proc/apply_stink_aura(mob/living/carbon/human/H)
	for(var/mob/living/nearby in view(2, H))
		if(nearby == H)
			continue
		if(nearby.stat)
			continue
		if(!nearby.can_smell())
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK))
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH))
			continue
		if(!nearby.has_stress_event(/datum/stressevent/stinky_aura))
			to_chat(nearby, span_warning("附近有什么东西臭得厉害。"))
		nearby.add_stress(/datum/stressevent/stinky_aura)

/datum/charflaw/paranoid
	name = "偏执"
	desc = "我比大多数人都更焦虑。我尤其害怕异族，也害怕见血。"
	var/last_check = 0

/datum/charflaw/paranoid/flaw_on_life(mob/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == src)
			continue
		if(L.stat)
			continue
		if(L.dna?.species)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(L.dna.species.id != H.dna.species.id)
					cnt++
		if(cnt > 2)
			break
	if(cnt > 2)
		user.add_stress(/datum/stressevent/paracrowd)
	cnt = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break
	if(cnt > 6)
		user.add_stress(/datum/stressevent/parablood)

/datum/charflaw/isolationist
	name = "孤僻"
	desc = "我不喜欢待在人群附近。他们说不定正打算对我做点什么……"
	var/last_check = 0

/datum/charflaw/isolationist/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 3)
			break
	var/mob/living/carbon/P = user
	if(cnt > 3)
		P.add_stress(/datum/stressevent/crowd)

/datum/charflaw/clingy
	name = "粘人"
	desc = "我喜欢待在人群身边，那样才热闹……"
	var/last_check = 0

/datum/charflaw/clingy/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 1)
			break
	var/mob/living/carbon/P = user
	if(cnt < 1)
		P.add_stress(/datum/stressevent/nopeople)

/datum/charflaw/noeyer
	name = "独眼 (右)"
	desc = "很久以前，我就失去了右眼。"

/datum/charflaw/noeyer/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()
	H.adjust_triumphs(1)

/datum/charflaw/noeyel
	name = "独眼 (左)"
	desc = "很久以前，我就失去了左眼。"

/datum/charflaw/noeyel/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch/left(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	H.update_fov_angles()
	H.adjust_triumphs(1)

/datum/charflaw/noeyeall
	name = "失明"
	desc = "很久以前，我就失去了双眼。"

/datum/charflaw/noeyeall/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/woodstaff = new /obj/item/rogueweapon/woodstaff(get_turf(H))
	H.put_in_hands(woodstaff, forced = TRUE)

	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/blindfold(H), SLOT_WEAR_MASK)
	H.overlay_fullscreen("blind_flaw", /atom/movable/screen/fullscreen/impaired, 2)
	H.adjust_triumphs(1)

/datum/charflaw/colorblind
	name = "色盲"
	desc = "我生来便受诅咒，视力有缺，许多别人能分辨的东西我都看不出来。与夜眼美德不兼容。"

/datum/charflaw/colorblind/on_mob_creation(mob/user)
	..()
	user.add_client_colour(/datum/client_colour/monochrome)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/compliant
	name = "顺从"
	desc = "无论我怎么努力，我都没法真正反抗别人。<br>\
	<small>我每次挣脱抓取都会失败，而别人总能从我的抓取中轻易脱身。盗贼也能毫无阻碍地抢我。</small>"

/datum/charflaw/compliant/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_COMPLIANT, TRAIT_GENERIC)
		H.compliance = 1
		H.apply_status_effect(/datum/status_effect/compliance)

/datum/charflaw/compliant/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_COMPLIANT, TRAIT_GENERIC)
		H.compliance = 0
		H.remove_status_effect(/datum/status_effect/compliance)

/datum/charflaw/assassintarget
	name = "Marked for Death"
	desc = "我过去的某些事让我成了目标。我总得不停回头张望。<br>\
	你的刺客可以在不进行升级冲突的情况下永久将你逐出本局！"
	var/logged = FALSE

/datum/charflaw/hunted
	name = "豺狼人的猎物"
	desc = "出于某种原因，我被视为了配得上格拉加尔（Graggar）冠军勇士出手的猎物。无论走到哪里，我都能听到他们的怪笑声。<br>\
	<small>此特质会吸引豺狼人对你展开追杀。在此过程中，你可能会被直接杀死。</small>"
	var/logged = FALSE

/datum/charflaw/ugly
	name = "丑陋"
	desc = "我生得面目可憎，谁看了都要心生不快。与“美貌”美德不兼容。"

/datum/charflaw/ugly/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_GENERIC)

/datum/charflaw/ugly/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_UNSEEMLY, TRAIT_GENERIC)

/datum/charflaw/nudist
	name = "裸体主义者"
	desc = "我拒绝穿衣服。那些玩意只会妨碍我的自由。某些配饰我倒还能容忍。"

/datum/charflaw/nudist/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)

/datum/charflaw/nudist/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)

/datum/charflaw/inhumen_anatomy
	name = "异种体貌"
	desc = "我的身体构造异于常人，因此无法穿戴帽子和鞋子。"

/datum/charflaw/inhumen_anatomy/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/charflaw/inhumen_anatomy/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_INHUMEN_ANATOMY, TRAIT_GENERIC)

/datum/charflaw/missing_nose
	name = "失鼻"
	desc = "我连呼吸都更费力。我的体力回复速度减半。"

/datum/charflaw/missing_nose/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/charflaw/missing_nose/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_MISSING_NOSE, TRAIT_GENERIC)

/datum/charflaw/disfigured
	name = "毁容"
	desc = "没人认得出我来。我的脸已经被永久改变了。"

/datum/charflaw/disfigured/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_DISFIGURED, TRAIT_GENERIC)

/datum/charflaw/disfigured/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_DISFIGURED, TRAIT_GENERIC)

/datum/charflaw/pacifism
	name = "和平主义"
	desc = "我无法伤害另一个活着的生灵。"

/datum/charflaw/pacifism/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_PACIFISM, TRAIT_GENERIC)

/datum/charflaw/pacifism/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_PACIFISM, TRAIT_GENERIC)

/datum/charflaw/annoying_face
	name = "讨嫌面相"
	desc = "我像是被诅咒了一样，声音和长相都叫人心烦。"

/datum/charflaw/annoying_face/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_COMICSANS, TRAIT_GENERIC)

/datum/charflaw/annoying_face/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_COMICSANS, TRAIT_GENERIC)

/datum/charflaw/nude_sleeper
	name = "裸睡者"
	desc = "除非赤身躺在床上，否则我根本睡不着。只要身上还穿着装备，我就无法入眠。（不可脱卸的衣物和部分配饰除外。）"

/datum/charflaw/nude_sleeper/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)

/datum/charflaw/nude_sleeper/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_NUDE_SLEEPER, TRAIT_GENERIC)

/datum/charflaw/loose_armor
	name = "Loose Straps"
	desc = "My armor never seems to fit quite right. It has a nasty habit of exploding off my body when under inordinate stress."

/datum/charflaw/loose_armor/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	ADD_TRAIT(H, TRAIT_LOOSE_STRAPS, TRAIT_GENERIC)

/datum/charflaw/loose_armor/on_removal(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	REMOVE_TRAIT(H, TRAIT_LOOSE_STRAPS, TRAIT_GENERIC)
/datum/charflaw/scarred
	name = "伤疤累累"
	desc = "我脸上布满可怖的伤疤，让人很难辨认出我，但也并非完全认不出来。"

/datum/charflaw/scarred/on_mob_creation(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		ADD_TRAIT(H, TRAIT_SCARRED, TRAIT_GENERIC)

/datum/charflaw/scarred/on_removal(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		REMOVE_TRAIT(H, TRAIT_SCARRED, TRAIT_GENERIC)

/datum/charflaw/hunted/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(logged == FALSE)
		if(H.name) // If you don't check this, the log entry wont have a name as flaw_on_life is checked at least once before the name is set.
			log_hunted("[H.ckey] playing as [H.name] had the hunted flaw by vice.")
			logged = TRUE

/datum/charflaw/unintelligible
	name = "言语不通"
	desc = "我不会说通用语！"

/datum/charflaw/unintelligible/on_mob_creation(mob/user)
	var/mob/living/carbon/human/recipient = user
	addtimer(CALLBACK(src, PROC_REF(unintelligible_apply), recipient), 5 SECONDS)

/datum/charflaw/unintelligible/proc/unintelligible_apply(mob/living/carbon/human/user)
	if(user.advsetup)
		addtimer(CALLBACK(src, PROC_REF(unintelligible_apply), user), 5 SECONDS)
		return
	user.remove_language(/datum/language/common, source = LANGUAGE_SOURCE_ALL)
	user.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)
	user.adjust_triumphs(1)

/datum/charflaw/greedy
	name = "贪婪"
	desc = "我对 mammons 永远不会满足，只会想要越来越多！不过我也因此更擅长判断东西值多少钱。"
	var/last_checked_mammons = 0
	var/required_mammons = 0
	var/next_mammon_increase = 0
	var/last_passed_check = 0
	var/first_tick = FALSE
	var/extra_increment_value = 0

/datum/charflaw/greedy/on_mob_creation(mob/user)
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time
	ADD_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "[type]")

/datum/charflaw/greedy/flaw_on_life(mob/user)
	if(!first_tick)
		determine_starting_mammons(user)
		first_tick = TRUE
		return
	if(world.time >= next_mammon_increase)
		mammon_increase(user)
	mammon_check(user)

/datum/charflaw/greedy/proc/determine_starting_mammons(mob/living/carbon/human/user)
	var/starting_mammons = get_mammons_in_atom(user)
	required_mammons = round(starting_mammons * 0.7)
	extra_increment_value = round(starting_mammons * 0.15)

/datum/charflaw/greedy/proc/mammon_increase(mob/living/carbon/human/user)
	if(last_passed_check + (50 MINUTES) < world.time) //If we spend a REALLY long time without being able to satisfy, then pity downgrade
		required_mammons -= rand(10, 20)
		to_chat(user, span_blue("也许少些 mammons 也够了……"))
	else
		required_mammons += rand(25, 35) + extra_increment_value
	required_mammons = min(required_mammons, 250) //Cap at 250 coins maximum
	next_mammon_increase = world.time + rand(35 MINUTES, 40 MINUTES)
	var/current_mammons = get_mammons_in_atom(user)
	if(current_mammons >= required_mammons)
		to_chat(user, span_blue("我手头这些 mammons，已经挺让我满意了……"))
	else
		to_chat(user, span_boldwarning("我需要更多 mammons，我手里的还不够……"))

	last_checked_mammons = current_mammons

/datum/charflaw/greedy/proc/mammon_check(mob/living/carbon/human/user)
	var/new_mammon_amount = get_mammons_in_atom(user)
	var/ascending = (new_mammon_amount > last_checked_mammons)

	var/do_update_msg = TRUE
	if(new_mammon_amount >= required_mammons)
		// Feel better
		if(user.has_stress_event(/datum/stressevent/vice/greedy))
			to_chat(user, span_blue("[new_mammon_amount] 枚 mammons……这才像样……"))
		user.remove_stress(/datum/stressevent/vice/greedy)
		user.remove_status_effect(/datum/status_effect/debuff/addiction/greedy)
		last_passed_check = world.time
		do_update_msg = FALSE
	else
		// Feel bad
		user.add_stress(/datum/stressevent/vice/greedy)
		user.apply_status_effect(/datum/status_effect/debuff/addiction/greedy)

	if(new_mammon_amount == last_checked_mammons)
		do_update_msg = FALSE

	if(do_update_msg)
		if(ascending)
			to_chat(user, span_warning("才 [new_mammon_amount] 枚 mammons……我还需要更多……"))
		else
			to_chat(user, span_boldwarning("不！我珍爱的 mammons……"))

	last_checked_mammons = new_mammon_amount

/datum/status_effect/debuff/addiction/greedy
	id = "addiction_greedy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction/greedy
	effectedstats = list(STATKEY_WIL = -1, STATKEY_LCK = -1)

/atom/movable/screen/alert/status_effect/debuff/addiction/greedy
	name = "贪欲"
	desc = "我的钱袋一点叮当声都没有。那还活个什么劲？"
	icon_state = "greedy"

/datum/charflaw/narcoleptic
	name = "嗜睡症"
	desc = "我白天经常犯困，还会突然睡着，不过若我主动想睡，反倒更容易入眠；月尘也能帮我保持清醒。"
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/charflaw/narcoleptic/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_FASTSLEEP, "[type]")
	reset_timer()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/narcoleptic/proc/reset_timer()
	do_sleep = FALSE
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2,4)

/datum/charflaw/narcoleptic/flaw_on_life(mob/living/carbon/human/user)
	if(user.stat != CONSCIOUS)
		reset_timer()
		return
	if(do_sleep)
		if(next_sleep <= world.time)
			var/pain = user.get_complex_pain()
			if(pain >= 40 && pain_pity_charges > 0)
				pain_pity_charges--
				concious_timer = rand(1 MINUTES, 2 MINUTES)
				to_chat(user, span_warning("痛楚让我没法睡过去……"))
			else
				if(prob(40) || drugged_up)
					drugged_up = FALSE
					concious_timer = rand(4 MINUTES, 6 MINUTES)
					to_chat(user, span_info("那股感觉过去了。"))
				else
					concious_timer = rand(7 MINUTES, 15 MINUTES)
					to_chat(user, span_boldwarning("我的眼皮已经撑不住了……"))
					user.Sleeping(rand(30 SECONDS, 50 SECONDS))
					user.visible_message(span_warning("[user]突然瘫倒在地！"))
			do_sleep = FALSE
			last_unconsciousness = world.time
	else
		// Been conscious for ~10 minutes (whatever is the conscious timer)
		if(last_unconsciousness + concious_timer < world.time)
			drugged_up = FALSE
			to_chat(user, span_blue("我开始犯困了……"))
			user.emote("yawn", forced = TRUE)
			next_sleep = world.time + rand(7 SECONDS, 11 SECONDS)
			do_sleep = TRUE

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/charflaw/narcoleptic/narco = living.get_flaw(/datum/charflaw/narcoleptic)
	if(!narco)
		return
	narco.drugged_up = TRUE

/proc/get_mammons_in_atom(atom/movable/movable)
	var/static/list/coins_types = typecacheof(/obj/item/roguecoin)
	var/mammons = 0
	if(coins_types[movable.type])
		var/obj/item/roguecoin/coin = movable
		mammons += coin.quantity * coin.sellprice
	for(var/atom/movable/content in movable.contents)
		mammons += get_mammons_in_atom(content)
	return mammons

/datum/charflaw/sleepless
	name = "失眠"
	desc = "我不睡觉。我睡不着。什么法子我都试过了。"

/datum/charflaw/sleepless/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_NOSLEEP, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/sleepless/on_removal(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_NOSLEEP, TRAIT_GENERIC)

/datum/charflaw/mute
	name = "哑巴"
	desc = "我生来就无法开口说话。"

/datum/charflaw/mute/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_PERMAMUTE, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/mute/on_removal(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PERMAMUTE, TRAIT_GENERIC)

/datum/charflaw/critweakness
	name = "致命脆弱"
	desc = "我的身体脆得像蛋壳一样。一次致命打击多半就足以当场要了我的命。"

/datum/charflaw/critweakness/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjust_triumphs(1)

/datum/charflaw/critweakness/on_removal(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/charflaw/silverweakness
	name = "畏银"
	desc = "我对银异常敏感，它灼烧并伤害我的程度远超常理。"

/datum/charflaw/silverweakness/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/datum/charflaw/silverweakness/on_removal(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/datum/charflaw/leprosy
	name = "麻风病人"
	desc = "我被麻风诅咒了！穷得无力医治，如今皮肤满是溃烂病灶，四肢麻木，就连最坚毅的人见了我也会心生不安。"

/datum/charflaw/leprosy/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "我染上恶疾。我被世人厌弃，虚弱不堪。我是这个世界上的一块毒疮。")
	ADD_TRAIT(user, TRAIT_LEPROSY, TRAIT_GENERIC)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_PER, -1)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_WIL, -1)
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_LCK, -1)
	H.adjust_triumphs(1)

/datum/charflaw/mind_broken
	name = "破碎心智"
	desc = "我的心智已然支离破碎，不知是自作自受，还是飞来横祸所致。在我眼里，一切都显得不真实……"

/datum/charflaw/mind_broken/apply_post_equipment(mob/living/carbon/human/insane_fool)
	insane_fool.hallucination = INFINITY
	ADD_TRAIT(insane_fool, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
	insane_fool.adjust_triumphs(1)

/datum/charflaw/marked_by_baotha
	name = "欲望之印"
	desc = "不论是我主动寻上异端仪式术士，还是在违背意愿的情况下，我都已被 Baotha 打上印记。我的腹股沟处留下了清晰可见的烙印，也因此无论身体原本处于何种通常无法受孕的状态，都仍可能受孕。为了避免压力，我得时常满足这股新生的欲望……"

/datum/charflaw/marked_by_baotha/on_mob_creation(mob/user)

	var/mutable_appearance/marking_overlay = mutable_appearance('icons/roguetown/misc/baotha_marking.dmi', "marking_[user.gender == "male" ? "m" : "f"]", -BODY_LAYER)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isdwarf(H) || isgoblinp(H) || iskobold(H) || iscritter(H))
			if(H.gender == MALE)
				marking_overlay.pixel_y -= 5
			else
				marking_overlay.pixel_y -= 3
	user.add_overlay(marking_overlay)

	spawn(40)

	ADD_TRAIT(user, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)

	var/obj/item/organ/vagina/vagina = user.getorganslot(ORGAN_SLOT_VAGINA)
	if(vagina && !vagina.fertility)
		vagina.fertility = TRUE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		// Add the adjusted Nymphomaniac addiction flaw
		if(!HAS_TRAIT(H, TRAIT_DEPRAVED))
			var/datum/charflaw/addiction/baothamarked/L = new
			H.vices += L
			L.on_mob_creation(H)

/datum/charflaw/hemophage
	name = "噬血者"
	desc = "不论是诅咒还是血脉使然，唯有鲜血才能维系我的生命。正常的食物与饮水只会让我生病。 <br>\
	<small>任何会修改进食效果的美德，其相关部分都会被“噬血者”抵消。</small>"

/datum/charflaw/hemophage/on_mob_creation(mob/living/carbon/human/vamp_wannabe)
	ADD_TRAIT(vamp_wannabe, TRAIT_HEMOPHAGE, TRAIT_GENERIC)
	ADD_TRAIT(vamp_wannabe, TRAIT_VAMPBITE, TRAIT_GENERIC)
	vamp_wannabe.adjust_triumphs(1)

/datum/charflaw/silverweakness/on_removal(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_HEMOPHAGE, TRAIT_GENERIC)
	REMOVE_TRAIT(user, TRAIT_VAMPBITE, TRAIT_GENERIC)


/datum/charflaw/weak
	name = "体弱"
	desc = "我手无缚鸡之力，做什么都不太顶用，肉体力量远不如大多数人。 <br>\
	<small>力量 -4。</small>"

/datum/charflaw/weak/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "你比大多数人都要虚弱。")
	H.change_stat(STATKEY_STR, -4)

/datum/charflaw/frail
	name = "孱弱"
	desc = "我很容易淤青，也老是咳嗽打喷嚏，比起大多数人更容易受伤。 <br>\
	<small>体质 -4。</small>"

/datum/charflaw/frail/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "你比大多数人都更脆弱。")
	H.change_stat(STATKEY_CON, -4)

/datum/charflaw/slow
	name = "蹒跚"
	desc = "你会对自己说，慢一点也稳一些。也许是脚踝旧伤，也许只是天性如此。你比大多数人都更迟缓。 <br>\
	<small>速度 -4。</small>"

/datum/charflaw/slow/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "你比大多数人都更慢。")
	H.change_stat(STATKEY_SPD, -4)

/datum/charflaw/dull
	name = "愚钝"
	desc = "大家总爱在你面前说些花里胡哨的大词，可你从来没弄明白他们为什么要这么说……你比大多数人都更缺乏聪慧。 <br>\
	<small>智力 -4。</small>"

/datum/charflaw/dull/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "你比大多数人都更迟钝。")
	H.change_stat(STATKEY_INT, -4)

/datum/charflaw/unlucky
	name = "倒霉"
	desc = "也许是你打碎的那面玻璃镜子，也许是那只总跟着你的黑猫，又或者是神祇降下的诅咒。你只是觉得……哪哪都不对劲。 <br>\
	<small>幸运 -4。</small>"

/datum/charflaw/unlucky/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "你比大多数人都更倒霉。")
	H.change_stat(STATKEY_LCK, -4)
