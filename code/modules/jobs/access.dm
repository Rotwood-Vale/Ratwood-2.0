//returns TRUE if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(src.check_access(null))
		return TRUE
	if(IsAdminGhost(M))
		//Access can't stop the abuse
		return TRUE
	else if(istype(M) && SEND_SIGNAL(M, COMSIG_MOB_ALLOWED, src))
		return TRUE
	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_held_item()) || src.check_access(H.wear_ring))
			return TRUE
	else if(isanimal(M))
		var/mob/living/simple_animal/A = M
		if(check_access(A.get_active_held_item()))
			return TRUE
	return FALSE

/obj/item/proc/GetAccess()
	return list()

/obj/item/proc/GetID()
	return null

/obj/item/proc/RemoveID()
	return null

/obj/item/proc/InsertID()
	return FALSE

/obj/proc/text2access(access_text)
	. = list()
	if(!access_text)
		return
	var/list/split = splittext(access_text,";")
	for(var/x in split)
		var/n = text2num(x)
		if(n)
			. += n

//Call this before using req_access or req_one_access directly
/obj/proc/gen_access()
	//These generations have been moved out of /obj/New() because they were slowing down the creation of objects that never even used the access system.
	if(!req_access)
		req_access = list()
		for(var/a in text2access(req_access_txt))
			req_access += a
	if(!req_one_access)
		req_one_access = list()
		for(var/b in text2access(req_one_access_txt))
			req_one_access += b

// Check if an item has access to this object
/obj/proc/check_access(obj/item/I)
	return check_access_list(I ? I.GetAccess() : null)

/obj/proc/check_access_list(list/access_list)
	gen_access()

	if(!islist(req_access)) //something's very wrong
		return TRUE

	if(!req_access.len && !length(req_one_access))
		return TRUE

	if(!length(access_list) || !islist(access_list))
		return FALSE

	for(var/req in req_access)
		if(!(req in access_list)) //doesn't have this access
			return FALSE

	if(length(req_one_access))
		for(var/req in req_one_access)
			if(req in access_list) //has an access from the single access list
				return TRUE
		return FALSE
	return TRUE

/proc/get_centcom_access(job)
	switch(job)
		if("VIP Guest")
			return list(ACCESS_CENT_GENERAL)
		if("Custodian")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Thunderdome Overseer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER)
		if("CentCom Official")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("CentCom Intern")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("CentCom Head Intern")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING)
		if("Medical Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_MEDICAL)
		if("Death Commando")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("Research Officer")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_TELEPORTER, ACCESS_CENT_STORAGE)
		if("Special Ops Officer")
			return get_all_centcom_access()
		if("Admiral")
			return get_all_centcom_access()
		if("CentCom Commander")
			return get_all_centcom_access()
		if("Emergency Response Team Commander")
			return get_ert_access("commander")
		if("Security Response Officer")
			return get_ert_access("sec")
		if("Engineer Response Officer")
			return get_ert_access("eng")
		if("Medical Response Officer")
			return get_ert_access("med")
		if("CentCom Bartender")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_LIVING, ACCESS_CENT_BAR)

/proc/get_all_accesses()
	return list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_FORENSICS_LOCKERS, ACCESS_COURT,
	            ACCESS_MEDICAL, ACCESS_GENETICS, ACCESS_MORGUE, ACCESS_RD,
	            ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_CHEMISTRY, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MAINT_TUNNELS,
	            ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD,
	            ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_HEADS, ACCESS_CAPTAIN, ACCESS_ALL_PERSONAL_LOCKERS,
	            ACCESS_TECH_STORAGE, ACCESS_CHAPEL_OFFICE, ACCESS_ATMOSPHERICS, ACCESS_KITCHEN,
	            ACCESS_BAR, ACCESS_JANITOR, ACCESS_CREMATORIUM, ACCESS_ROBOTICS, ACCESS_CARGO, ACCESS_CONSTRUCTION,
	            ACCESS_HYDROPONICS, ACCESS_LIBRARY, ACCESS_LAWYER, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_QM, ACCESS_SURGERY,
	            ACCESS_THEATRE, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING, ACCESS_WEAPONS,
				ACCESS_MECH_MINING, ACCESS_MECH_ENGINE, ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY, ACCESS_MECH_MEDICAL,
	            ACCESS_VAULT, ACCESS_MINING_STATION, ACCESS_XENOBIOLOGY, ACCESS_CE, ACCESS_HOP, ACCESS_HOS, ACCESS_APOTHECARY, ACCESS_RC_ANNOUNCE,
	            ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_GATEWAY, ACCESS_MINERAL_STOREROOM, ACCESS_MINISAT, ACCESS_NETWORK, ACCESS_CLONING)

/proc/get_all_centcom_access()
	return list(ACCESS_CENT_GENERAL, ACCESS_CENT_THUNDER, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE, ACCESS_CENT_TELEPORTER, ACCESS_CENT_CAPTAIN)

/proc/get_ert_access(class)
	switch(class)
		if("commander")
			return get_all_centcom_access()
		if("sec")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING)
		if("eng")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_LIVING, ACCESS_CENT_STORAGE)
		if("med")
			return list(ACCESS_CENT_GENERAL, ACCESS_CENT_SPECOPS, ACCESS_CENT_MEDICAL, ACCESS_CENT_LIVING)

/proc/get_all_syndicate_access()
	return list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)

/proc/get_region_accesses(code)
	switch(code)
		if(0)
			return get_all_accesses()
		if(1) //station general
			return list(ACCESS_KITCHEN,ACCESS_BAR, ACCESS_HYDROPONICS, ACCESS_JANITOR, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_LIBRARY, ACCESS_THEATRE, ACCESS_LAWYER)
		if(2) //security
			return list(ACCESS_SEC_DOORS, ACCESS_WEAPONS, ACCESS_SECURITY, ACCESS_BRIG, ACCESS_ARMORY, ACCESS_FORENSICS_LOCKERS, ACCESS_COURT, ACCESS_MECH_SECURITY, ACCESS_HOS)
		if(3) //medbay
			return list(ACCESS_MEDICAL, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MORGUE, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_SURGERY, ACCESS_MECH_MEDICAL, ACCESS_CMO, ACCESS_APOTHECARY)
		if(4) //research
			return list(ACCESS_RESEARCH, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_GENETICS, ACCESS_ROBOTICS, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE, ACCESS_MINISAT, ACCESS_RD, ACCESS_NETWORK)
		if(5) //engineering and maintenance
			return list(ACCESS_CONSTRUCTION, ACCESS_MAINT_TUNNELS, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_TECH_STORAGE, ACCESS_ATMOSPHERICS, ACCESS_MECH_ENGINE, ACCESS_TCOMSAT, ACCESS_MINISAT, ACCESS_CE)
		if(6) //supply
			return list(ACCESS_MAILSORTING, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_MECH_MINING, ACCESS_MINERAL_STOREROOM, ACCESS_CARGO, ACCESS_QM, ACCESS_VAULT)
		if(7) //command
			return list(ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_CHANGE_IDS, ACCESS_AI_UPLOAD, ACCESS_TELEPORTER, ACCESS_EVA, ACCESS_GATEWAY, ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_HOP, ACCESS_CAPTAIN, ACCESS_VAULT)

/proc/get_region_accesses_name(code)
	switch(code)
		if(0)
			return "全部"
		if(1) //station general
			return "综合"
		if(2) //security
			return "安保"
		if(3) //medbay
			return "医疗"
		if(4) //research
			return "研究"
		if(5) //engineering and maintenance
			return "工程"
		if(6) //supply
			return "后勤"
		if(7) //command
			return "指挥"

/proc/get_access_desc(A)
	switch(A)
		if(ACCESS_CARGO)
			return "货运区"
		if(ACCESS_SECURITY)
			return "安保"
		if(ACCESS_BRIG)
			return "拘留室"
		if(ACCESS_COURT)
			return "法庭"
		if(ACCESS_FORENSICS_LOCKERS)
			return "法证室"
		if(ACCESS_MEDICAL)
			return "医疗部"
		if(ACCESS_GENETICS)
			return "遗传实验室"
		if(ACCESS_MORGUE)
			return "停尸房"
		if(ACCESS_TOX)
			return "研发实验室"
		if(ACCESS_TOX_STORAGE)
			return "毒素实验室"
		if(ACCESS_CHEMISTRY)
			return "化学实验室"
		if(ACCESS_RD)
			return "研究主管办公室"
		if(ACCESS_BAR)
			return "Bar"
		if(ACCESS_JANITOR)
			return "清洁储物间"
		if(ACCESS_ENGINE)
			return "工程部"
		if(ACCESS_ENGINE_EQUIP)
			return "电力与工程设备"
		if(ACCESS_MAINT_TUNNELS)
			return "维护区"
		if(ACCESS_EXTERNAL_AIRLOCKS)
			return "外部气闸"
		if(ACCESS_CHANGE_IDS)
			return "ID 控制台"
		if(ACCESS_AI_UPLOAD)
			return "AI 控制室"
		if(ACCESS_TELEPORTER)
			return "传送室"
		if(ACCESS_EVA)
			return "EVA"
		if(ACCESS_HEADS)
			return "舰桥"
		if(ACCESS_CAPTAIN)
			return "舰长室"
		if(ACCESS_ALL_PERSONAL_LOCKERS)
			return "个人储物柜"
		if(ACCESS_CHAPEL_OFFICE)
			return "教堂办公室"
		if(ACCESS_TECH_STORAGE)
			return "技术储藏室"
		if(ACCESS_ATMOSPHERICS)
			return "大气系统"
		if(ACCESS_CREMATORIUM)
			return "火葬间"
		if(ACCESS_ARMORY)
			return "军械库"
		if(ACCESS_CONSTRUCTION)
			return "建造区"
		if(ACCESS_KITCHEN)
			return "??"
		if(ACCESS_HYDROPONICS)
			return "水培区"
		if(ACCESS_LIBRARY)
			return "图书馆"
		if(ACCESS_LAWYER)
			return "律师事务所"
		if(ACCESS_ROBOTICS)
			return "机器人学"
		if(ACCESS_VIROLOGY)
			return "病毒学"
		if(ACCESS_CMO)
			return "首席医官办公室"
		if(ACCESS_QM)
			return "军需官室"
		if(ACCESS_SURGERY)
			return "手术室"
		if(ACCESS_THEATRE)
			return "??"
		if(ACCESS_RESEARCH)
			return "科学部"
		if(ACCESS_MINING)
			return "采矿区"
		if(ACCESS_MAILSORTING)
			return "货运办公室"
		if(ACCESS_VAULT)
			return "主金库"
		if(ACCESS_MINING_STATION)
			return "采矿 EVA"
		if(ACCESS_XENOBIOLOGY)
			return "异种生物实验室"
		if(ACCESS_HOP)
			return "人事主管办公室"
		if(ACCESS_HOS)
			return "安保主管办公室"
		if(ACCESS_CE)
			return "首席工程师办公室"
		if(ACCESS_APOTHECARY)
			return "档案官"
		if(ACCESS_RC_ANNOUNCE)
			return "无线公告"
		if(ACCESS_KEYCARD_AUTH)
			return "钥码认证"
		if(ACCESS_TCOMSAT)
			return "通信系统"
		if(ACCESS_GATEWAY)
			return "传送门"
		if(ACCESS_SEC_DOORS)
			return "禁闭室"
		if(ACCESS_MINERAL_STOREROOM)
			return "矿物仓库"
		if(ACCESS_MINISAT)
			return "AI 卫星站"
		if(ACCESS_WEAPONS)
			return "武器许可"
		if(ACCESS_NETWORK)
			return "网络权限"
		if(ACCESS_CLONING)
			return "克隆室"
		if(ACCESS_MECH_MINING)
			return "采矿机甲权限"
		if(ACCESS_MECH_MEDICAL)
			return "医疗机甲权限"
		if(ACCESS_MECH_SECURITY)
			return "安保机甲权限"
		if(ACCESS_MECH_SCIENCE)
			return "科研机甲权限"
		if(ACCESS_MECH_ENGINE)
			return "工程机甲权限"

/proc/get_centcom_access_desc(A)
	switch(A)
		if(ACCESS_CENT_GENERAL)
			return "Code Grey"
		if(ACCESS_CENT_THUNDER)
			return "Code Yellow"
		if(ACCESS_CENT_STORAGE)
			return "Code Orange"
		if(ACCESS_CENT_LIVING)
			return "Code Green"
		if(ACCESS_CENT_MEDICAL)
			return "Code White"
		if(ACCESS_CENT_TELEPORTER)
			return "Code Blue"
		if(ACCESS_CENT_SPECOPS)
			return "Code Black"
		if(ACCESS_CENT_CAPTAIN)
			return "Code Gold"
		if(ACCESS_CENT_BAR)
			return "Code Scotch"

/proc/get_all_jobs()
	return list("Assistant", "Captain", "Head of Personnel", "Bartender", "Cook", "Botanist", "Quartermaster", "Cargo Technician",
				"Shaft Miner", "Clown", "Mime", "Janitor", "Curator", "Lawyer", "Chaplain", "Chief Engineer", "Station Engineer",
				"Atmospheric Technician", "Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Virologist",
				"Research Director", "Scientist", "Roboticist", "Head of Security", "Warden", "Detective", "Security Officer")

/proc/get_all_job_icons() //For all existing HUD icons
	return get_all_jobs() + list("Prisoner")

/proc/get_all_centcom_jobs()
	return list("VIP Guest","Custodian","Thunderdome Overseer","CentCom Official","Medical Officer","Death Commando","Research Officer","Special Ops Officer","Admiral","CentCom Commander","Emergency Response Team Commander","Security Response Officer","Engineer Response Officer", "Medical Response Officer","CentCom Bartender")
