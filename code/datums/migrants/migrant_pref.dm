/datum/migrant_pref
	/// Reference to our prefs
	var/datum/preferences/prefs
	/// Whether the user wants to be a migrant
	var/active = FALSE
	/// Role preferences of the user, the things he clicks on to be preferred to be
	var/list/role_preferences = list()
	///are we viewing the page?
	var/viewer = FALSE

/datum/migrant_pref/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/migrant_pref/proc/set_active(new_state, silent = FALSE)
	if(active == new_state)
		return
	active = new_state
	role_preferences.Cut()
	if(!silent && prefs.parent)
		if(new_state)
			to_chat(prefs.parent, span_notice("你已进入移民队列，他们到来时你将与其一同加入游戏"))
		else
			to_chat(prefs.parent, span_boldwarning("你已不在移民队列中"))

/datum/migrant_pref/proc/toggle_role_preference(role_type)
	if(role_type in role_preferences)
		role_preferences -= role_type
	else
		// Currently only allow 1 role preffed up for clarity
		role_preferences.Cut()

		if(SSmigrants.can_be_role(prefs.parent, role_type))
			role_preferences += role_type
			var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
			to_chat(prefs.parent, span_nicegreen("你已将 [role.name] 设为优先选择，但这并不保证你一定会获得该身份。"))
		else
			to_chat(prefs.parent, span_warning("你不能选择这个身份。（种族、性别或年龄不符。）"))

/datum/migrant_pref/proc/post_spawn()
	set_active(FALSE, TRUE)
	hide_ui()

/datum/migrant_pref/proc/show_ui()
	var/client/client = prefs.parent
	if(!client)
		return

	var/current_migrants = SSmigrants.get_active_migrant_amount()
	var/player_triumph = SStriumphs.get_triumphs(client.ckey)

	// Build main content (left side)
	var/list/main_dat = list()
	main_dat += "<div style='padding: 10px;'>"
	main_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px;'>波次：\Roman[SSmigrants.wave_number] | 凯旋点：[player_triumph]</div>"
	main_dat += "<div style='text-align: center; margin-bottom: 10px;'><b>成为移民：<a href='byond://?src=[REF(src)];task=toggle_active'>[active ? "是" : "否"]</a></b></div>"
	main_dat += "<div style='text-align: center; margin-bottom: 15px;'>游荡的傻瓜：[current_migrants ? "\Roman[current_migrants]" : "无"]</div>"

	if(!SSmigrants.current_wave)
		main_dat += "<div style='text-align: center; margin-bottom: 15px;' id='migrant_countdown'>迷雾将在 [(SSmigrants.time_until_next_wave / (1 SECONDS))] 秒后散开……</div>"
	else
		var/datum/migrant_wave/wave = MIGRANT_WAVE(SSmigrants.current_wave)
		main_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px;'>[wave.name]</div>"

		// Show if this wave was triumph-influenced
		if(wave.triumph_total > 0)
			var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0
			if(player_contribution > 0)
				main_dat += "<div style='text-align: center; color: cyan; margin-bottom: 10px;'>你影响了这次波次！([player_contribution] 凯旋点)</div>"
			else
				main_dat += "<div style='text-align: center; color: yellow; margin-bottom: 10px;'>这次波次受到了凯旋点影响！</div>"
		for(var/role_type in wave.roles)
			var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
			var/role_amount = wave.roles[role_type]
			var/role_name = role.name
			if(active  && (role_type in role_preferences))
				role_name = "<u><b>[role_name]</b></u>"
			var/stars_amount = SSmigrants.get_stars_on_role(role_type)
			var/stars_string = ""
			if(stars_amount)
				stars_string = "(*\Roman[stars_amount])"

			// Show triumph bonus for selection
			var/triumph_bonus = SSmigrants.get_triumph_selection_bonus(client, SSmigrants.current_wave)
			var/triumph_bonus_string = ""
			if(triumph_bonus > 0)
				triumph_bonus_string = " <span style='color: gold;'>(+[triumph_bonus])</span>"

			main_dat += "<div style='text-align: center; margin: 5px 0;'><a href='byond://?src=[REF(src)];task=toggle_role_preference;role=[role_type]'>[role_name]</a> - \Roman[role_amount] [stars_string][triumph_bonus_string]</div>"
		main_dat += "<div style='text-align: center; margin-top: 15px;' id='migrant_countdown'>他们将在 [(SSmigrants.wave_timer / (1 SECONDS))] 秒后到来……</div>"

	main_dat += "</div>"

	// Build wave influence sidebar (right side)
	var/list/sidebar_dat = list()
	sidebar_dat += "<div style='padding: 10px; background-color: #1a1a1a; height: 100%; overflow-y: auto;' id='wave-sidebar'>"
	sidebar_dat += "<div style='text-align: center; font-weight: bold; margin-bottom: 10px; color: #cccccc;'>波次影响</div>"

	// Calculate total weights for percentage calculation
	var/list/wave_weights = list()
	var/total_weight = 0
	var/list/available_waves = SSmigrants.get_influenceable_waves()

	for(var/wave_type in available_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		var/weight = SSmigrants.calculate_triumph_weight(wave)
		wave_weights[wave_type] = weight
		total_weight += weight

	for(var/wave_type in available_waves)
		var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
		var/triumph_display = "[wave.triumph_total]/[wave.triumph_threshold]"
		var/threshold_reached = wave.triumph_total >= wave.triumph_threshold
		var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0

		// Check if wave has hit max spawns
		var/is_maxed_out = FALSE
		if(!isnull(wave.max_spawns))
			var/used_wave_type = wave.type
			if(wave.shared_wave_type)
				used_wave_type = wave.shared_wave_type
			if(SSmigrants.spawned_waves[used_wave_type] && SSmigrants.spawned_waves[used_wave_type] >= wave.max_spawns)
				is_maxed_out = TRUE

		var/wave_color = "#ffffff"
		var/wave_name = wave.name
		if(is_maxed_out)
			wave_color = "#666666"
			wave_name = "[wave.name]（已满）"
		else if(threshold_reached)
			wave_color = "gold"
			wave_name = "[wave.name]（就绪！）"
		else if(player_contribution > 0)
			wave_color = "cyan"
			wave_name = "[wave.name] ([player_contribution])"

		// Progress bar
		var/progress_percent = min((wave.triumph_total / wave.triumph_threshold) * 100, 100)

		// Calculate roll percentage
		var/roll_percentage = 0
		if(is_maxed_out)
			roll_percentage = "0%（已满）"
		else if(threshold_reached)
			roll_percentage = "100%（必定）"
		else if(total_weight > 0)
			var/wave_weight = wave_weights[wave_type]
			roll_percentage = "[round((wave_weight / total_weight) * 100, 0.1)]%"
		else
			roll_percentage = "0%"

		sidebar_dat += "<div style='margin-bottom: 12px; padding: 8px; border: 1px solid #444; border-radius: 4px;' title='抽取概率：[roll_percentage]（基础：[wave.weight]，凯旋加成：+[wave.triumph_total * 6]）'>"
		sidebar_dat += "<div style='color: [wave_color]; font-weight: bold; margin-bottom: 4px;'>[wave_name]</div>"
		sidebar_dat += "<div style='background-color: #333; height: 12px; border-radius: 6px; margin-bottom: 4px;'>"
		sidebar_dat += "<div style='background-color: [threshold_reached ? "gold" : (is_maxed_out ? "#666666" : "cyan")]; height: 100%; width: [progress_percent]%; border-radius: 6px;'></div>"
		sidebar_dat += "</div>"
		sidebar_dat += "<div style='display: flex; justify-content: space-between; align-items: center; font-size: 12px;'>"
		sidebar_dat += "<span>[triumph_display]</span>"

		// Only show contribution button if wave isn't maxed out
		if(!is_maxed_out)
			sidebar_dat += "<a href='byond://?src=[REF(src)];task=contribute_triumph;wave=[wave_type]' style='background-color: #4a4a4a; color: white; text-decoration: none; padding: 2px 6px; border-radius: 3px; font-size: 11px;'>+T</a>"
		else
			sidebar_dat += "<span style='background-color: #333; color: #666; padding: 2px 6px; border-radius: 3px; font-size: 11px;'>已满</span>"

		sidebar_dat += "</div>"
		sidebar_dat += "</div>"

	sidebar_dat += "</div>"

	// Combine into two-column layout
	var/list/dat = list()
	dat += {"<style>
		body { margin: 0; padding: 0; font-family: monospace; background-color: #2a2a2a; color: #ffffff; }
		.container { display: flex; height: 100vh; }
		.main-content { flex: 1; overflow-y: auto; }
		.sidebar { width: 280px; border-left: 1px solid #444; }
		a { color: #88aaff; }
		a:hover { color: #aaccff; }

		/* Tooltip styling */
		\[title\] {
			position: relative;
			cursor: help;
		}
		\[title\]:hover::after {
			content: attr(title);
			position: absolute;
			bottom: 100%;
			left: 50%;
			transform: translateX(-50%);
			background-color: #1a1a1a;
			color: #ffffff;
			padding: 8px 12px;
			border-radius: 6px;
			white-space: nowrap;
			font-size: 12px;
			border: 1px solid #555;
			z-index: 1000;
			box-shadow: 0 2px 8px rgba(0,0,0,0.3);
		}

		\[title\]:hover::before {
			content: '';
			position: absolute;
			bottom: 100%;
			left: 50%;
			transform: translateX(-50%) translateY(1px);
			border: 5px solid transparent;
			border-top-color: #555;
			z-index: 1000;
		}
	</style>
	<div class='container'>
		<div class='main-content' id='main-content'>
			[main_dat.Join()]
		</div>
		<div class='sidebar'>
			[sidebar_dat.Join()]
		</div>
	</div>
	<script>
		function update_migrant_countdown(text) {
			var el = document.getElementById("migrant_countdown");
			if (el) el.innerHTML = text;
		}

		// Cookie functions
		function setCookie(name, value, days) {
			var expires = "";
			if (days) {
				var date = new Date();
				date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
				expires = "; expires=" + date.toUTCString();
			}
			document.cookie = name + "=" + (value || "") + expires + "; path=/";
		}

		function getCookie(name) {
			var nameEQ = name + "=";
			var ca = document.cookie.split(';');
			for(var i = 0; i < ca.length; i++) {
				var c = ca\[i\];
				while (c.charAt(0) == ' ') c = c.substring(1, c.length);
				if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
			}
			return null;
		}

		// Restore scroll position from cookie
		var mainContent = document.getElementById('main-content');
		var sidebar = document.getElementById('wave-sidebar');

		if(mainContent) {
			var savedScroll = getCookie('migrant_scroll');
			if(savedScroll) {
				mainContent.scrollTop = parseInt(savedScroll);
			}

			// Save scroll position to cookie when scrolling
			mainContent.addEventListener('scroll', function() {
				setCookie('migrant_scroll', this.scrollTop, 1); // Save for 1 day
			});
		}

		if(sidebar) {
			var savedSidebarScroll = getCookie('migrant_sidebar_scroll');
			if(savedSidebarScroll) {
				sidebar.scrollTop = parseInt(savedSidebarScroll);
			}

			// Save sidebar scroll position too
			sidebar.addEventListener('scroll', function() {
				setCookie('migrant_sidebar_scroll', this.scrollTop, 1);
			});
		}
	</script>"}

	var/datum/browser/popup = new(client.mob, "migration", "<center>寻找你的目标</center>", 650, 500, src)
	popup.set_content(dat.Join())
	popup.open()
	client.prefs.migrant.viewer = TRUE

/datum/migrant_pref/Topic(href, href_list)
	var/client/client = prefs.parent
	if(!client)
		return

	if(href_list["close"])
		if(active)
			client.prefs.migrant.set_active(FALSE)
		hide_ui()
		return

	switch(href_list["task"])
		if("toggle_active")
			set_active(!active)
		if("toggle_role_preference")
			var/role_type = text2path(href_list["role"])
			toggle_role_preference(role_type)
		if("contribute_triumph")
			var/wave_type = text2path(href_list["wave"])
			handle_triumph_contribution(wave_type)
	show_ui()
/datum/migrant_pref/proc/handle_triumph_contribution(wave_type)
	var/client/client = prefs.parent
	if(!client)
		return

	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(!wave)
		return

	var/current_triumph = SStriumphs.get_triumphs(client.ckey)
	if(current_triumph <= 0)
		to_chat(client, span_warning("你没有可投入的凯旋点！"))
		return

	var/player_contribution = wave.triumph_contributions[client.ckey] ? wave.triumph_contributions[client.ckey] : 0
	var/max_contribute = min(current_triumph, 25) // Cap individual contributions

	var/amount = input(client, "要向“[wave.name]”投入凯旋点吗？\n\n你的凯旋点：[current_triumph]\n你的贡献：[player_contribution]\n波次总计：[wave.triumph_total]/[wave.triumph_threshold]\n\n投入数量（1-[max_contribute]）：", "凯旋点投入") as null|num

	if(!amount || amount <= 0 || amount > max_contribute)
		return

	SSmigrants.contribute_triumph_to_wave(client, wave_type, amount)

/datum/migrant_pref/proc/hide_ui()
	var/client/client = prefs.parent
	if(!client)
		return
	client.mob << browse(null, "window=migration")
	client.prefs.migrant.viewer = FALSE
