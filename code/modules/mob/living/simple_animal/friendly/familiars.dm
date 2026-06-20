#define FAMILIAR_SEE_IN_DARK 6
#define FAMILIAR_MIN_BODYTEMP 200
#define FAMILIAR_MAX_BODYTEMP 400

/*
	Familiar list and buffs below.
	Sprites by Diltyrr (those aren't good gah)

	Quick AI pictures idea for each of them : https://imgbox.com/g/MvanomKazA
*/

/mob/living/simple_animal/pet/familiar
	name = "通用巫师伙伴"
	desc = "构成了伙伴的精魂（你不应该看到这个。）"

	icon = 'icons/roguetown/mob/familiars.dmi'

	butcher_results = list(/obj/item/natural/stone = 1)

	pass_flags = PASSMOB //We don't want them to block players.
	base_intents = list(INTENT_HELP)
	melee_damage_lower = 1
	melee_damage_upper = 2

	dextrous = TRUE
	gender = MALE

	speak_chance = 1
	turns_per_move = 5
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	see_in_dark = FAMILIAR_SEE_IN_DARK
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = FAMILIAR_MIN_BODYTEMP
	maxbodytemp = FAMILIAR_MAX_BODYTEMP
	unsuitable_atmos_damage = 1
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	faction = list("rogueanimal", "neutral")
	speed = 0.8
	breedchildren = 0 //Yeah no, I'm not falling for this one.
	dodgetime = 20
	held_items = list(null, null)
	pooptype = null
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	var/obj/item/mouth = null

	var/buff_given = list()
	var/mob/living/carbon/familiar_summoner = null
	var/inherent_spell = null
	var/summoning_emote = null

	var/flight_capable = FALSE
	var/flight_time = 2 SECONDS

//As far as I am aware, you cannot pat out fire as a familiar at least not in time for it to not kill you, this seems fair.
/mob/living/simple_animal/pet/familiar/fire_act(added, maxstacks)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, extinguish_mob)), 1 SECONDS)

/mob/living/simple_animal/pet/familiar/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CHUNKYFINGERS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	AddComponent(/datum/component/footstep, footstep_type)
	if(flight_capable)
		verbs += list(/mob/living/simple_animal/pet/familiar/proc/fly_up,
		/mob/living/simple_animal/pet/familiar/proc/fly_down)

/mob/living/simple_animal/pet/familiar/proc/fly_up()
	set category = "Flight"
	set name = "Fly Up"

	if(src.pulledby != null)
		to_chat(src, span_notice("我被抓住了，没法飞走！"))
		return
	src.visible_message(span_notice("[src]开始上升！"), span_notice("你起飞了……"))
	if(do_after(src, flight_time))
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("我飞上去了。"))
		else
			to_chat(src, span_notice("我被抓住了，没法飞走！"))

/mob/living/simple_animal/pet/familiar/proc/fly_down()
	set category = "Flight"
	set name = "Fly Down"

	if(src.pulledby != null)
		to_chat(src, span_notice("我被抓住了，没法飞走！"))
		return
	src.visible_message(span_notice("[src]开始下降！"), span_notice("你起飞了……"))
	if(do_after(src, flight_time))
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("我飞下去了。"))
		else
			to_chat(src, span_notice("我被抓住了，没法飞走！"))

/mob/living/simple_animal/pet/familiar/proc/can_bite()
	for(var/obj/item/grabbing/grab in grabbedby) //Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE

	return TRUE

/mob/living/simple_animal/pet/familiar/examine(mob/user)
	. = ..()
	var/datum/familiar_prefs/fpref = src.client?.prefs.familiar_prefs
	if(fpref && (fpref.familiar_flavortext || fpref.familiar_headshot_link || fpref.familiar_ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_fam_headshot;'>仔细查看</a>"

/datum/status_effect/buff/familiar
	duration = -1

/mob/living/simple_animal/pet/familiar/death()
	. = ..()
	emote("deathgasp")
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name]倒下了，你们的羁绊随之暗淡。但在远处的寂静中，它们一丝精华的微光依然留存。"))

/mob/living/simple_animal/pet/familiar/Destroy()
	if(familiar_summoner)
		if(buff_given)
			familiar_summoner.remove_status_effect(buff_given)
		if(familiar_summoner.mind)
			familiar_summoner.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/message_familiar)
	return ..()

/mob/living/simple_animal/pet/familiar/pondstone_toad
	name = "池塘石蟾蜍"
	desc = "这只潮湿沉重的蟾蜍搏动着无形的力量。它的皮肤冰凉，布满了矿物脉络。"
	animal_species = "池塘石蟾蜍"
	summoning_emote = "你脚下回荡起一阵低沉的嗡鸣，一只苔藓覆盖的蟾蜍推开泥土，发出低沉的哼鸣。"
	icon_state = "pondstone"
	icon_living = "pondstone"
	icon_dead = "pondstone_dead"
	buff_given = /datum/status_effect/buff/familiar/settled_weight
	inherent_spell = list(/obj/effect/proc_holder/spell/self/stillness_of_stone)
	STASTR = 11
	STAPER = 7
	STAINT = 9
	STACON = 11
	STASPD = 5
	STALUC = 9
	speak = list("Hrrrm.", "Grrup.", "Blorp.")
	speak_emote = list("低沉地呱呱叫", "咕哝")
	emote_hear = list("低沉地呱呱叫。", "发出咕噜咕噜的声音。")
	emote_see = list("如石头般颤抖。", "在原地轻轻扑通。")
	var/icon/original_icon = null
	var/original_icon_state = ""
	var/original_icon_living = ""
	var/original_name = ""
	var/stoneform = FALSE

/datum/status_effect/buff/familiar/settled_weight
	id = "settled_weight"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/settled_weight

/atom/movable/screen/alert/status_effect/buff/familiar/settled_weight
	name = "沉稳之重"
	desc = "你感觉自己更沉稳了一些。推回去变得稍微容易了。"


/mob/living/simple_animal/pet/familiar/mist_lynx
	name = "雾影猞猁"
	desc = "一只幽灵般的猞猁，双眼如双月般闪烁。它似乎从不眨眼，即使你没在看着它。"
	animal_species = "雾影猞猁"
	summoning_emote = "雾气凝聚成猫科形态，化作一只毛色苍白、银眼不眨的猞猁。"
	icon_state = "mist"
	icon_living = "mist"
	icon_dead = "mist_dead"
	alpha = 150
	buff_given = /datum/status_effect/buff/familiar/silver_glance
	inherent_spell = list(/obj/effect/proc_holder/spell/self/lurking_step, /obj/effect/proc_holder/spell/invoked/veilbound_shift)
	pass_flags = PASSGRILLE | PASSMOB
	STASTR = 6
	STAPER = 11
	STAINT = 9
	STACON = 7
	STAWIL = 9
	STASPD = 13
	STALUC = 9
	speak = list("...") // mostly silent
	speak_emote = list("轻声呼噜", "低语")
	emote_hear = list("发出轻柔的嚎叫。", "近乎无声地低语。")
	emote_see = list("转着圈踱步。", "短暂消失，然后重新出现。")
	var/list/saved_trails = list()

/datum/status_effect/buff/familiar/silver_glance
	id = "silver_glance"
	effectedstats = list(STATKEY_PER = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/silver_glance

/atom/movable/screen/alert/status_effect/buff/familiar/silver_glance
	name = "银眸一瞥"
	desc = "你视野的边缘有微光闪烁。你注意到了他人忽略的东西。"

/mob/living/simple_animal/pet/familiar/rune_rat
	name = "符文鼠"
	desc = "这只老鼠抽动时会在空中留下消逝的符文。它的毛皮上粘着旧纸的气味。"
	animal_species = "符文鼠"
	summoning_emote = "一丝微弱的火星在空气中舞动。一只尾巴微微发光的老鼠奔跳着出现了。"
	icon_state = "runerat"
	icon_living = "runerat"
	icon_dead = "runerat_dead"
	buff_given = /datum/status_effect/buff/familiar/threaded_thoughts
	inherent_spell = list(/obj/effect/proc_holder/spell/self/inscription_cache, /obj/effect/proc_holder/spell/self/recall_cache)
	STASTR = 5
	STAPER = 9
	STAINT = 11
	STACON = 7
	STAWIL = 8
	STASPD = 11
	speak = list("Skrii!", "Tik-tik.", "Chrr.")
	speak_emote = list("吱吱叫", "叽喳")
	emote_hear = list("若有所思地吱吱叫。", "嗅了嗅空气。")
	emote_see = list("尾巴划出有规律的抽动。", "绕圈疾跑。")
	var/stored_books = list()
	var/storage_limit = 5

/datum/status_effect/buff/familiar/threaded_thoughts
	id = "threaded_thoughts"
	effectedstats = list(STATKEY_INT = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts

/atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts
	name = "思绪交织"
	desc = "你的思绪更容易凝聚在一起，像被拉成整齐编织的线。"

/mob/living/simple_animal/pet/familiar/vaporroot_wisp
	name = "蒸气根精魄"
	desc = "这只蒸气根精魄闪烁流转如烟，但靠上去却感觉足够坚实。"
	animal_species = "蒸气根"
	summoning_emote = "一团银色的雾旋转凝聚，化作一束蒸气根的小小精魄。"
	icon_state = "vaporroot"
	icon_living = "vaporroot"
	icon_dead = "vaporroot_dead"
	alpha = 150
	buff_given = /datum/status_effect/buff/familiar/quiet_resilience
	inherent_spell = list(/obj/effect/proc_holder/spell/self/soothing_bloom)
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	movement_type = FLYING
	flight_capable = TRUE
	STASTR = 4
	STACON = 11
	STAWIL = 9
	STASPD = 8
	speak = list("Fffff...", "Whuuuh.")
	speak_emote = list("低语", "呢喃")
	emote_hear = list("轻柔地嗡鸣。", "散发出舒缓的雾气。")
	emote_see = list("原地旋转。", "短暂地消散。")

/datum/status_effect/buff/familiar/quiet_resilience
	id = "quiet_resilience"
	effectedstats = list(STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience

/atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience
	name = "静谧韧性"
	desc = "一股平静的力量在你皮下嗡鸣。你的呼吸深了一些。"

/mob/living/simple_animal/pet/familiar/ashcoiler
	name = "灰烬盘绕者"
	desc = "这条长身蛇缓慢地盘绕，像一根加热的绳索。它的呼吸带着淡淡的烧焦草药味。"
	summoning_emote = "尘土扬起盘旋，随后盘绕成一只有着灰色鳞片、散发着干燥余温的生物。"
	animal_species = "灰烬盘绕者"
	icon_state = "ashcoiler"
	icon_living = "ashcoiler"
	icon_dead = "ashcoiler_dead"
	butcher_results = list(/obj/item/ash = 1)
	buff_given = /datum/status_effect/buff/familiar/desert_bred_tenacity
	inherent_spell = list(/obj/effect/proc_holder/spell/self/smolder_shroud)
	STASTR = 7
	STAPER = 8
	STAINT = 9
	STACON = 9
	STAWIL = 11
	STASPD = 8
	STALUC = 8
	speak = list("Ssshh...", "Hhsss.", "Ffff.")
	speak_emote = list("嘶嘶作响", "粗声粗气")
	emote_hear = list("微弱地嘶嘶作响。", "吐出一股灰烬。")
	emote_see = list("缓慢地盘绕又松开。", "有节奏地移动重心。")

/datum/status_effect/buff/familiar/desert_bred_tenacity
	id = "desert_bred_tenacity"
	effectedstats = list(STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity

/atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity
	name = "沙漠淬炼之韧"
	desc = "你感到沉稳而有耐心，就像某个在无雨之年存活下来的存在。"

/mob/living/simple_animal/pet/familiar/glimmer_hare
	name = "微光兔"
	desc = "一只敏捷、神经质的生物。光线在它半透明的身体上奇怪地弯曲。"
	summoning_emote = "空气闪烁，一只半透明的野兔颤抖着出现了。"
	animal_species = "微光兔"
	icon_state = "glimmer"
	icon_living = "glimmer"
	icon_dead = "glimmer_dead"
	buff_given = /datum/status_effect/buff/familiar/lightstep
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/blink/glimmer_hare)
	STASTR = 4
	STAPER = 9
	STACON = 6
	STAWIL = 9
	STASPD = 9
	STALUC = 11
	alpha = 150
	speak = list("Tik!", "Tch!", "Hah!")
	speak_emote = list("快速叽喳", "啁啾")
	emote_hear = list("用脚敲着地面。", "洒落了些灰尘。")
	emote_see = list("突然冲一下然后停下。", "微微震动。")

/datum/status_effect/buff/familiar/lightstep
	id = "lightstep"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/lightstep

/atom/movable/screen/alert/status_effect/buff/familiar/lightstep
	name = "轻盈步伐"
	desc = "你行动起来稍微更轻松了一些。"

/mob/living/simple_animal/pet/familiar/hollow_antlerling
	name = "空心角鹿"
	desc = "一只狗大小的鹿，长着闪烁的空心鹿角，发出笛子般的声音。"
	summoning_emote = "一阵悦耳的钟声响起。一只角如骨笛的小鹿轻柔地走到视野中。"
	animal_species = "空心角鹿"
	icon_state = "antlerling"
	icon_living = "antlerling"
	icon_dead = "antlerling_dead"
	buff_given = /datum/status_effect/buff/familiar/soft_favor
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_veil)
	STASTR = 6
	STACON = 8
	STAWIL = 9
	STASPD = 9
	STALUC = 11
	speak = list("Hrrn.", "Mnnn.", "Chuff.")
	speak_emote = list("轻柔地鸣响", "呼唤")
	emote_hear = list("发出悦耳的钟声。")
	emote_see = list("如海市蜃楼般闪烁。", "刚好站在落尘触及不到的地方。")

/datum/status_effect/buff/familiar/soft_favor
	id = "soft_favor"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/soft_favor

/atom/movable/screen/alert/status_effect/buff/familiar/soft_favor
	name = "温柔眷顾"
	desc = "命运似乎向你倾斜。"

/mob/living/simple_animal/pet/familiar/gravemoss_serpent
	name = "墓苔巨蛇"
	desc = "它的鳞片上斑驳着地衣和墓尘。它所经之处，泥土中的根须微颤。"
	summoning_emote = "地面微微起伏，一条覆满苔藓的长蛇从中盘绕而出。"
	animal_species = "墓苔巨蛇"
	icon_state = "gravemoss"
	icon_living = "gravemoss"
	icon_dead = "gravemoss_dead"
	butcher_results = list(/obj/item/natural/dirtclod = 1)
	buff_given = /datum/status_effect/buff/familiar/burdened_coil
	inherent_spell = list(/obj/effect/proc_holder/spell/self/scent_of_the_grave)
	STASTR = 11
	STAPER = 8
	STAINT = 9
	STAWIL = 11
	STASPD = 6
	STALUC = 8
	speak = list("Grhh...", "Sssrrrh.", "Urrh.")
	speak_emote = list("低沉嘶嘶", "咕哝")
	emote_hear = list("从深处发出隆隆声。", "如穿根之风般嘶嘶作响。")
	emote_see = list("半身沉入大地。", "沉稳注视。")

/datum/status_effect/buff/familiar/burdened_coil
	id = "burdened_coil"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil

/atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil
	name = "重负盘绕"
	desc = "你感到脚踏实地而沉稳，仿佛力量在皮下盘绕。"

/mob/living/simple_animal/pet/familiar/starfield_crow
	name = "星域扎德"
	desc = "它光泽的羽毛闪烁着流转的星座，即使在最暗的阴影中眼睛也闪烁着离奇的知觉。"
	summoning_emote = "空气裂开一道缝隙，显现出星空虚空的一角，一只羽毛如夜空般的利落扎德从中起飞。"
	animal_species = "星域乌鸦"
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow_dead"
	butcher_results = list(/obj/item/roguegem/amethyst = 1)//Worth effectively nothing. Calm down.
	buff_given = /datum/status_effect/buff/familiar/starseam
	inherent_spell = list(/obj/effect/proc_holder/spell/self/starseers_cry)
	pass_flags = PASSTABLE | PASSMOB
	movement_type = FLYING
	flight_capable = TRUE
	STASTR = 4
	STAPER = 11
	STACON = 6
	STAWIL = 8
	STALUC = 11
	speak = list("Kraa.", "Caw.", "Krrrk.")
	speak_emote = list("轻声啼叫", "呱呱叫")
	emote_hear = list("发出通晓的啼叫。", "像星辰滴答般啁啾。")
	emote_see = list("在星座间闪烁。", "歪了下头然后消失了一秒。")

/datum/status_effect/buff/familiar/starseam
	id = "starseam"
	effectedstats = list(STATKEY_PER = 1, STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/starseam

/atom/movable/screen/alert/status_effect/buff/familiar/starseam
	name = "星纹"
	desc = "你感到被遥远的星图轻轻推动。世界的流动变得更容易解读。"

/mob/living/simple_animal/pet/familiar/emberdrake
	name = "余烬幼龙"
	desc = "触感温热的微小龙兽，翅膀拍打时搅动着旧日的记忆。符文在它身后如残像般闪烁。"
	summoning_emote = "沉寂降临，发光的灰烬凝聚成一只扑翼的余烬幼龙。"
	animal_species = "余烬幼龙"
	icon_state = "emberdrake"
	icon_living = "emberdrake"
	icon_dead = "emberdrake_dead"
	butcher_results = list(/obj/item/ash = 1)
	buff_given = /datum/status_effect/buff/familiar/steady_spark
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/pyroclastic_puff)
	STASTR = 9
	STAPER = 8
	STAINT = 11
	STACON = 11
	STAWIL = 9
	STASPD = 8
	STALUC = 8
	speak = list("Ffff.", "Rrrhh.", "Chhhh.")
	speak_emote = list("噼啪作响", "温声细语")
	emote_hear = list("如壁炉般隆隆作响。", "火焰般闪烁。")
	emote_see = list("亮度短暂一涨。", "留下一片短暂的热浪。")

/datum/status_effect/buff/familiar/steady_spark
	id = "steady_spark"
	effectedstats = list(STATKEY_INT = 1, STATKEY_CON = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/steady_spark

/atom/movable/screen/alert/status_effect/buff/familiar/steady_spark
	name = "稳定火花"
	desc = "你的思绪没有燃烧，而是阴燃着。清晰、缓慢、持久。"

/mob/living/simple_animal/pet/familiar/ripplefox
	name = "涟漪狐"
	desc = "不直视它的时候它会闪烁。不留痕迹。你并不总是确定它是否还在附近。"
	summoning_emote = "空气泛起涟漪，化作一只身形流畅的狐狸，毛皮在色彩间跳动，踱步走来。"
	animal_species = "涟漪狐"
	icon_state = "ripple"
	icon_living = "ripple"
	icon_dead = "ripple_dead"
	buff_given = /datum/status_effect/buff/familiar/subtle_slip
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantom_flicker)
	STASTR = 5
	STACON = 8
	STAWIL = 9
	STASPD = 11
	STALUC = 11
	speak = list("Yip!", "Hrrnk.", "Tchk-tchk.")
	speak_emote = list("快速低语", "语速很快")
	emote_hear = list("发出欢快的叫声。", "笑声如流水般。")
	emote_see = list("如水波般模糊。", "已经不在刚才的位置了。")

/datum/status_effect/buff/familiar/subtle_slip
	id = "subtle_slip"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip

/atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip
	name = "微妙滑步"
	desc = "周围的一切似乎都松动了一些，留出了空隙、机会、更快的节拍。"

/mob/living/simple_animal/pet/familiar/whisper_stoat
	name = "低语鼬"
	desc = "它的目光太过通透。它歪着头，仿佛在聆听你头颅内的某种东西。"
	summoning_emote = "一个念头扭曲成形，一只小小的鼬悄然溜进视野。"
	animal_species = "低语鼬"
	icon_state = "whisper"
	icon_living = "whisper"
	icon_dead = "whisper_dead"
	buff_given = /datum/status_effect/buff/familiar/noticed_thought
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantasm_fade)
	STASTR = 5
	STAPER = 11
	STAINT = 11
	STACON = 7
	STAWIL = 8
	STASPD = 11
	STALUC = 9
	speak = list("Tchhh.", "Hmm.", "Skkk.")
	speak_emote = list("低语", "轻声说话")
	emote_hear = list("朝你方向低语。", "发出一种你立刻忘记的声音。")
	emote_see = list("缠绕着一道影子。", "溜进了一个念头背后。")

/datum/status_effect/buff/familiar/noticed_thought
	id = "noticed_thought"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought

/atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought
	name = "被留意的思绪"
	desc = "一切都变得更加有意义。你更快地捕捉到规律。"

/mob/living/simple_animal/pet/familiar/thornback_turtle
	name = "棘背龟"
	desc = "它几乎不动，但似乎不可动摇。藤蔓轻柔地缠绕着它的四肢。"
	summoning_emote = "大地发出缓慢的隆隆声。一只壳如树皮的龟从土壤中钻出。"
	animal_species = "棘背龟"
	icon_state = "thornback"
	icon_living = "thornback"
	icon_dead = "thornback_dead"
	buff_given = /datum/status_effect/buff/familiar/worn_stone
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_sprout)
	STASPD = 5
	STAPER = 7
	STAINT = 9
	STACON = 11
	STAWIL = 12
	STALUC = 8
	speak = list("Hrmm.", "Grunk.", "Mmm.")
	speak_emote = list("隆隆作响", "缓缓而语")
	emote_hear = list("如巨石挪动般哼鸣。", "如古旧木头般叹息。")
	emote_see = list("微微缩进壳里。", "缓慢眨眼。")

/datum/status_effect/buff/familiar/worn_stone
	id = "worn_stone"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/worn_stone

/atom/movable/screen/alert/status_effect/buff/familiar/worn_stone
	name = "磨蚀之石"
	desc = "没什么觉得是紧迫的。你可以慢慢来……并且挨得住一击。"
