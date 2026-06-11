/obj/structure/flagpole
	name = "旗杆"
	icon = 'icons/roguetown/misc/flagpole.dmi'
	icon_state = "flagpole"
	desc = "一根人工制成的旗杆。它会响应远方信号，显示镇上哪些重要人物目前正在活动……"
	density = FALSE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flagpole/Initialize(mapload)
	. = ..()
	GLOB.rogue_info.all_flags += src

/obj/structure/flagpole/Destroy()
	GLOB.rogue_info.all_flags -= src
	return ..()

/obj/structure/flagpole/proc/update_single_role(role_name, is_visible)
	var/image/I = image(icon, role_name)

	if(is_visible)
		add_overlay(I)
	else
		cut_overlay(I)
	update_desc()

/obj/structure/flagpole/proc/update_desc()
	var/list/active_names = list()
	for(var/role in GLOB.rogue_info.role_visibility)
		if(GLOB.rogue_info.role_visibility[role])
			active_names += role

	desc = active_names.len ? "当前升起的旗帜有：[english_list(active_names)]。" : "[initial(desc)]"

/obj/structure/flagpole/examine(mob/user)
	. = ..()

	var/list/active_roles = list()
	for(var/role in GLOB.rogue_info.role_visibility)
		if(GLOB.rogue_info.role_visibility[role])
			active_roles += role

	if(!active_roles.len)
		return

	var/dropdown_html = "<details><summary><b>查看当前升起旗帜的详情</b></summary>"

	for(var/role in active_roles)
		var/list/data = GLOB.rogue_info.role_data[role]
		var/role_desc = data ? data["desc"] : "暂无描述。"
		var/role_note = data ? data["note"] : "暂无自定义备注。"

		dropdown_html += "<details style='margin-left: 10px;'>"
		dropdown_html += "<summary>[capitalize(role)]</summary>"
		dropdown_html += "<p><em>说明：</em> [role_desc]</p>"
		dropdown_html += "<p><em>备注：</em> [role_note]</p>"
		dropdown_html += "</details>"

	dropdown_html += "</details>"

	. += dropdown_html

/obj/item/mini_flagpole
	name = "自定义迷你旗杆"
	icon = 'icons/roguetown/misc/flagpole_mini.dmi'
	icon_state = "flagpole"
	desc = "用于表示你在镇中的存在。中键可在镇中旗杆上设置自定义告示，使用它可升起或降下你的旗帜。"

	w_class = WEIGHT_CLASS_TINY
	var/controlled_role = "freeform1"
	var/flag_color = "#ffffff"
	var/mutable_appearance/flag_overlay
	var/list/authorized_jobs = list()

/obj/item/mini_flagpole/proc/can_use(mob/user)
	if(!length(authorized_jobs))
		return TRUE

	if(!iscarbon(user))
		return FALSE

	var/user_job = user.job
	if(user_job in authorized_jobs)
		return TRUE

	to_chat(user, span_alert("你没有操控这根旗杆的权限。"))
	return FALSE

/obj/item/mini_flagpole/proc/update_visuals()
	flag_overlay = mutable_appearance(icon, "flag")
	flag_overlay.color = flag_color

	var/active = GLOB.rogue_info.role_visibility[controlled_role]

	if(active)
		add_overlay(flag_overlay)
	else
		cut_overlay(flag_overlay)

/obj/item/mini_flagpole/attack_self(mob/user)
	if(!can_use(user))
		return

	var/new_status = !GLOB.rogue_info.role_visibility[controlled_role]

	if(GLOB.rogue_info.set_role_visibility(controlled_role, new_status))
		update_visuals()
		to_chat(user, "你将[controlled_role]的旗帜[new_status ? "升起" : "降下"]了。")

/obj/item/mini_flagpole/MiddleClick(mob/user, params)
	. = ..()
	if(!can_use(user))
		return

	var/list/role_entry = GLOB.rogue_info.role_data[controlled_role]
	if(!role_entry)
		to_chat(user, span_alert("错误：未找到[controlled_role]的数据项。"))
		return

	var/default_note = "暂无自定义备注。"
	var/current_note = role_entry["note"]
	if(current_note && current_note != default_note)
		var/choice = alert(user, "这面旗帜当前已有自定义信息：\n\"[current_note]\"\n\n设置新信息会覆盖原内容。要继续吗？", "覆盖旗帜信息", "继续", "取消")
		if(choice != "继续")
			return

	var/default_text = (current_note && current_note != default_note) ? current_note : ""
	var/new_note = tgui_input_text(user, "为[controlled_role]输入新的自定义备注：", "更新旗帜备注", default_text, MAX_MESSAGE_LEN)

	if(!new_note)
		return
	var/trimmed_note = trim(new_note)
	if(!length(trimmed_note))
		to_chat(user, span_alert("自定义备注不能为空。"))
		return

	if(trimmed_note == current_note)
		to_chat(user, span_notice("[controlled_role]的自定义备注未改变。"))
		return

	role_entry["note"] = trimmed_note
	to_chat(user, span_notice("你已更新[controlled_role]的自定义备注。"))

/obj/item/mini_flagpole/freeform2
	name = "自定义迷你旗杆"
	controlled_role = "freeform2"
	flag_color = "#ffffff"

/obj/item/mini_flagpole/blacksmith
	name = "铁匠迷你旗杆"
	controlled_role = "blacksmith"
	flag_color = "#808080" // Gray
	authorized_jobs = list("Guildsman", "Guildmaster")

/obj/item/mini_flagpole/artificer
	name = "工匠迷你旗杆"
	controlled_role = "artificer"
	flag_color = "#B87333" // Copper
	authorized_jobs = list("Guildsman", "Guildmaster")

/obj/item/mini_flagpole/steward
	name = "总管迷你旗杆"
	controlled_role = "steward"
	flag_color = "#FFD700" // Gold
	authorized_jobs = list("Steward", "Clerk")

/obj/item/mini_flagpole/duke
	name = "公爵迷你旗杆"
	controlled_role = "duke"
	flag_color = "#007FFF" // Azure

/obj/item/mini_flagpole/apothecary
	name = "药剂师迷你旗杆"
	controlled_role = "apothecary"
	flag_color = "#A9A9A9" // Dark Gray
	authorized_jobs = list("Head Physician", "Apothecary", "Keeper")

/obj/item/mini_flagpole/church
	name = "教会迷你旗杆"
	controlled_role = "church"
	flag_color = "#00FFFF" // Cyan
	authorized_jobs = list("Bishop", "Keeper", "Templar", "Druid", "Acolyte", "Head Physician", "Apothecary")

/obj/item/mini_flagpole/fisher
	name = "渔夫迷你旗杆"
	controlled_role = "fisher"
	flag_color = "#006400" // Dark Green
	authorized_jobs = list("Towner")

/obj/item/mini_flagpole/university
	name = "学府迷你旗杆"
	controlled_role = "university"
	flag_color = "#000080" // Deep Marine Blue

/obj/item/mini_flagpole/innkeeper
	name = "旅店老板迷你旗杆"
	controlled_role = "innkeeper"
	flag_color = "#800020" // Burgundy
	authorized_jobs = list("Towner", "Innkeeper", "Tapster", "Cook")

/obj/item/mini_flagpole/tailor
	name = "裁缝迷你旗杆"
	controlled_role = "tailor"
	flag_color = "#FFFFFF" // Bright White
	authorized_jobs = list("Tailor")

/obj/item/mini_flagpole/bathhouse
	name = "浴场迷你旗杆"
	controlled_role = "bathhouse"
	flag_color = "#800080" // Purple
	authorized_jobs = list("Bathhouse Attendant", "Bathmaster")

/obj/item/mini_flagpole/merchant
	name = "商人迷你旗杆"
	controlled_role = "merchant"
	flag_color = "#C0C0C0" // Silver
	authorized_jobs = list("Merchant", "Shophand")
