#define TOWNER_BROADCAST_COST 1
#define NON_TOWNER_BROADCAST_COST 5

/obj/structure/broadcast_horn
	name = "\improper 街巷传声筒"
	desc = "也被称作“人民之口”，前提是人民掏得起喂鼠的饲料钱。"
	icon_state = "broadcaster_crass"
	icon = 'icons/roguetown/misc/machines.dmi'
	blade_dulling = DULLING_BASH
	max_integrity = 0
	density = TRUE
	anchored = TRUE
	flags_1 = HEAR_1
	speech_span = SPAN_ORATOR
	var/listening = FALSE
	var/speech_color = null
	var/loudmouth = FALSE
	var/broadcaster_tag

/obj/structure/broadcast_horn/examine(mob/user)
	. = ..()
	if(listening)
		. += span_info("里面隐约传出窸窸窣窣的爬动声。")
	else
		. += span_info("里面的老鼠很安静。")
	if(broadcaster_tag)
		. += span_info("它[broadcaster_tag ? " 的标识为 [broadcaster_tag]" : ""]。")

/obj/structure/broadcast_horn/redstone_triggered()
	toggle_horn()

/obj/structure/broadcast_horn/proc/toggle_horn()
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(listening)
		visible_message(span_notice("[src]的嗡鸣声停了下来。"))
		listening = FALSE
	else
		listening = TRUE
		visible_message(span_notice("[src]吱吱作响地活了过来。"))

/obj/structure/broadcast_horn/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!ishuman(speaker))
		return
	if(!listening)
		return
	var/turf/step_turf = get_step(get_turf(src), src.dir)
	if(get_turf(speaker) != step_turf)
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	var/list/tspans = list()
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	tspans |= speech_span
	if(speech_color)
		raw_message = "<span style='color: [speech_color]'>[raw_message]</span>"

	//Log the broadcast here
	GLOB.broadcast_list += list(list(
		"message"   = raw_message,
		"tag"       = broadcaster_tag,
		"timestamp" = station_time_timestamp("hh:mm:ss")
	))

	//Forward to all listeners
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(!S.calling && (!loudmouth || S.loudmouth_listening))
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		if(!loudmouth || S.loudmouth_listening)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		if(!loudmouth || S.loudmouth_listening)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	var/obj/item/clothing/head/roguetown/crown/serpcrown/crowne = SSroguemachine.crown
	if(crowne && (!loudmouth || crowne.loudmouth_listening))
		crowne.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	if(istype(src, /obj/structure/broadcast_horn/paid))
		listening = FALSE
		playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

/obj/structure/broadcast_horn/loudmouth
	name = "\improper 金尊之口"
	desc = "金口者专用的闪亮号角，表面镌刻着公爵纹章。"
	icon_state = "broadcaster"
	speech_color = COLOR_ASSEMBLY_GOLD
	broadcaster_tag = "金尊之口"
	loudmouth = TRUE

/obj/structure/broadcast_horn/loudmouth/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	toggle_horn()

/obj/structure/broadcast_horn/loudmouth/guest
	name = "\improper 银舌"
	desc = "宾客用的号角。虽不如金口者本人那般浮华，但依旧是件做工精良的器物。"
	broadcaster_tag = "银舌"
	icon_state = "broadcaster_crass"
	speech_color = COLOR_ASSEMBLY_GURKHA

/obj/structure/broadcast_horn/paid
	name = "\improper 街巷传声筒"
	desc = "也被称作“人民之口”，前提是人民掏得起喂鼠的饲料钱。"
	icon_state = "broadcaster_crass"
	icon = 'icons/roguetown/misc/machines.dmi'
	var/is_locked = FALSE

/obj/structure/broadcast_horn/paid/examine()
	. = ..()
	. += span_info("贵族、自由民、教士、随从成员或廷臣可花 1 枚泽尼使用；其他人必须投入 1 枚兹利夸。")

/obj/structure/broadcast_horn/paid/proc/get_broadcast_cost(mob/user)
	var/datum/job/user_job = SSjob.GetJob(user.job)
	if(!user_job)
		return NON_TOWNER_BROADCAST_COST
	if(user_job.department_flag & (NOBLEMEN|YEOMEN|GARRISON|CHURCHMEN|COURTIERS))
		return TOWNER_BROADCAST_COST
	if(HAS_TRAIT(user, TRAIT_NOBLE))
		// Noble privilege! 
		return TOWNER_BROADCAST_COST
	return NON_TOWNER_BROADCAST_COST

/obj/structure/broadcast_horn/paid/attackby(obj/item/P, mob/user, params)
	// Handle locking/unlocking with crier key
	if(istype(P, /obj/item/roguekey/crier))
		is_locked = !is_locked
		listening = FALSE
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		say(is_locked ? "街巷传声筒已上锁。" : "街巷传声筒已解锁。")
		return

	// Handle coin payment
	if(istype(P, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = P
		if(is_locked)
			say("街巷传声筒已上锁。请去找报信官。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		if(listening)
			say("硬币已经投进去了。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		
		var/cost = get_broadcast_cost(user)

		if(C.get_real_price() != cost)
			to_chat(user, span_warning("支付无效！请投入面值 [cost] 玛门的硬币。"))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		listening = TRUE
		qdel(C)

		// Route payments to rousmaster
		for(var/obj/structure/roguemachine/crier/Crier in world)
			Crier.total_payments += cost
			break // Safety. Prevents a runtime if more than 1 rousmaster exists.

		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return

	..()

/obj/structure/broadcast_horn/Initialize(mapload)
	. = ..()
	become_hearing_sensitive()
	SSroguemachine.broadcaster_machines += src

/obj/structure/broadcast_horn/Destroy()
	lose_hearing_sensitivity()
	return ..()

#undef TOWNER_BROADCAST_COST
#undef NON_TOWNER_BROADCAST_COST
