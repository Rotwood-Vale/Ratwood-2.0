/datum/origin
	var/name = null
	var/desc = ""
	var/origin_title = null
	var/region_title = null
	var/map_x = 0
	var/map_y = 0
	var/origin_language = null

GLOBAL_LIST_INIT(origins, build_origins())

/proc/build_origins()
	. = list()
	for(var/type in subtypesof(/datum/origin))
		.[type] = new type()

/datum/origin/otava
	name = "Otava"
	desc = "An unforgivingly cold alpine clime, said to be the birthplace of the Psydonic faith. The Orthodoxist Inquisition operates from the capital of Otava's old monarchy."
	origin_title = "Otava"
	origin_language = /datum/language/otavan
	map_x = 183
	map_y = 151

/datum/origin/zybantine
	name = "Zybantine"
	desc = "The Zybantine Empire spans across many countries, encompassing many of the deserts of Ferentia. The Empire favours strength and wealth; though rumours are abound \
	that the opulent empire gathers its wealth through unsavoury means."
	origin_title = "Zybantine"
	origin_language = /datum/language/celestial
	map_x = 364
	map_y = 325

/datum/origin/naledi
	name = "Naledi"
	desc = "Once a thriving empire in its own right, the Naledi people have warred against demons (or djinn in the local tongue) for centuries. Their homeland was almost \
	utterly destroyed with the Ascension of Baotha. It is said that the first magics were born here."
	origin_title = "Naledi"
	origin_language = /datum/language/celestial
	map_x = 514
	map_y = 242

/datum/origin/ferentia
	name = "Ferentia"
	desc = "An island kingdom off of the western coast of Grenzelhoft and Etrusca. The Ferentian people are a hardworking sort, eager to drink and revel after a dae's worth \
	of toil. In the past, the kingdom has had to defend against Otava and Grenzelhoft, but now it acts as a mediator between the two nations."
	origin_title = "Ferentia"
	map_x = 151
	map_y = 200

/datum/origin/underdark
	name = "The Underdark"
	desc = "Said to be an immense network of caves and tunnels located all throughout the crust of Grimoria, the Underdark is home to the Dark Elves and the Kobolds, as well \
	as the elusive Fluvian city-state of Mercuriam. The caverns of the Underdark are filled with many threats from rivers of acid to man-eating spiders; and even exaggerated \
	reports of dragons beneath."
	origin_title = "the Underdark"
	map_x = 120
	map_y = 344

/datum/origin/hammerhold
	name = "Hammerhold"
	desc = "The Hammerhold Peninsula and Isles are home to a myriad of peoples, from the Abyssor-loving Witan of the peninsula, the red-heads of Ru-Yermon, or the isles that \
	once made up the see of seasons. Within it lies the Platinum Dwarf Fortress, the ruins of a glorious cathedral that was once the seat of northern tennite faith, and various \
	petty kingdoms, or Jarldoms, all loosely agreeing to the will of the Ringbearer, Lord of the Witan."
	origin_title = "Hammerhold"
	origin_language = /datum/language/dwarvish
	map_x = 90
	map_y = 132

/datum/origin/grenzelhoft
	name = "Grenzelhoft"
	desc = "The Grenzelhoft Empire is the seat of the Holy See of the Dieci, the main Ten-worshipping religion of Grimoria. Due to the unfathomable hordes of deadites plaguing \
	the Empire, many of the grand cities and artisan towns have been abandoned in favour of a lyfe across the seas or within the capital city. Despite all, Grenzelhoft still \
	stands tall."
	origin_title = "Grenzelhoft"
	origin_language = /datum/language/grenzelhoftian
	map_x = 283
	map_y = 188

/datum/origin/avar
	name = "Avar"
	desc = "Avar is a land divided between the great Northern mountain ranges, the rolling grasslands of the Steppe, and the thick forests of the oncoming Taiga. It is home \
	to the second greatest Psydonic kingdom behind Otava, the finest martial force of the Eastern ranges, and the most ethnically and culturally diverse peoples in Grimoria."
	origin_title = "Avar"
	origin_language = /datum/language/aavnic
	map_x = 417
	map_y = 189

/datum/origin/gronn
	name = "Gronn"
	desc = "The steppes of Gronn are a place of bloodshed and war; Graggarite warbands laying waste to the people of Gronn and vying for dominance over Avar to the south. \
	Not all is lost in the steppes, however, with many towns and nomad families eking out an existence fraught with danger despite the ravagers' conquest."
	origin_title = "Gronn"
	origin_language = /datum/language/gronnic
	map_x = 445
	map_y = 116

/datum/origin/etrusca
	name = "Etrusca"
	desc = "A sunny trade nation comprised mostly of beautiful archipelagos. Etrusca prides itself on its martial and culinary traditions, with people all across Grimoria \
	striving to learn the ways of the vaqueros and duellists of the trader state. "
	origin_title = "Etrusca"
	origin_language = /datum/language/etruscan
	map_x = 266
	map_y = 277

/datum/origin/kazengun
	name = "Kazengun"
	desc = "Kazengun is not but one nation, but three dynasties that have been in stand-still for centuries. The Kazengun Shogunate to the west of the island, the \
	Pui-Maen Dynasty to the east, and the Clan Xinyi to the north. Kazengun is oft travelled by the people of the west, but those who visit recount (mostly tall) \
	tales of the warriors and monsters within. Kazengunese imports are particularly expensive considering the vast ocean between the dynasties and the western world."
	origin_title = "Kazengun"
	origin_language = /datum/language/kazengunese
	map_x = 120
	map_y = 374

/datum/preferences/proc/open_origin_map(mob/user)
	var/html = build_origin_map_html()
	user << browse_rsc(file("html/rwmap1.png"), "rwmap1.png")
	user << browse(html, "window=origin_map;size=685x540")
	onclose(user, "origin_map", src)

/datum/preferences/proc/build_origin_map_html()
	var/html = ""
	html += "<html><head><style>"
	html += {"body{margin:0;padding:0;background:#1a1209;color:#e8dcc8;font-family:Georgia,serif;overflow:hidden;user-select:none;}"}
	html += {".map-wrap{position:relative;width:550px;height:400px;display:block;margin:0 auto;}"}
	html += {".map-wrap img{width:550px;height:400px;display:block;pointer-events:none;}"}
	html += {".pin{position:absolute;width:18px;height:18px;border-radius:50%;background:#8b1a1a;border:2px solid #e8c87a;cursor:pointer;transform:translate(-50%,-50%);transition:all 0.15s ease;z-index:10;}"}
	html += {".pin:hover,.pin.selected{background:#e8c87a;border-color:#fff;box-shadow:0 0 10px rgba(232,200,122,0.9);transform:translate(-50%,-50%) scale(1.3);z-index:20;}"}
	html += {".pin.selected{background:#c8a020;}"}
	html += {".tooltip{position:fixed;background:rgba(18,12,5,0.97);border:1px solid #8b6914;border-radius:4px;padding:10px 14px;max-width:240px;z-index:100;pointer-events:none;display:none;color:#e8dcc8;}"}
	html += {".tooltip b{color:#e8c87a;font-size:14px;}"}
	html += {".tooltip p{margin:4px 0 0 0;font-size:12px;line-height:1.4;}"}
	html += {".panel{width:512px;margin:0 auto;padding:6px 0;text-align:center;background:#1a1209;border-top:1px solid #4a3010;}"}
	html += {".panel b{color:#e8c87a;font-size:13px;}"}
	html += {"#selected-label{color:#c8a020;font-size:13px;margin-top:3px;}"}
	html += {".confirm-btn{display:inline-block;margin-top:6px;padding:5px 18px;background:#5a2800;border:1px solid #8b6914;color:#e8dcc8;font-family:Georgia,serif;font-size:13px;cursor:pointer;border-radius:2px;}"}
	html += {".confirm-btn:hover{background:#8b4010;border-color:#e8c87a;}"}
	html += "</style></head><body>"
	html += "<div class='map-wrap'>"
	html += "<img src='rwmap1.png' alt='Ratwood Map'>"
	for(var/otype as anything in GLOB.origins)
		var/datum/origin/O = GLOB.origins[otype]
		var/sel_cls = (origin == O) ? " selected" : ""
		var/safe_name = replacetext(O.name, "'", "\\'")
		var/safe_desc = replacetext(O.desc, "'", "\\'")
		var/node_href = "byond://?src=\ref[src];preference=origin_select;type=[url_encode("[otype]")]"
		html += "<div class='pin[sel_cls]' style='left:[O.map_x]px;top:[O.map_y]px;' "
		html += "onclick=\"window.location.href='[node_href]'; return false;\" "
		html += "onmouseenter=\"showTip(event,'[safe_name]','[safe_desc]')\" "
		html += "onmouseleave=\"hideTip()\"></div>"
	html += "</div>"
	html += "<div class='panel'>"
	var/current_label = origin ? origin.name : "None selected"
	html += "<b>Selected: [current_label]</b>"
	html += "</div>"
	html += "<div class='tooltip' id='tip'></div>"
	html += "<script>"
	html += {"function showTip(e, name, desc) {"}
	html += "  var t = document.getElementById('tip');"
	html += "  t.innerHTML = '<b>' + name + '</b>' + (desc ? '<p>' + desc + '</p>' : '');"
	html += "  t.style.left = '-9999px';"
	html += "  t.style.display = 'block';"
	html += "  var x = e.clientX + 14;"
	html += "  var y = e.clientY + 14;"
	html += "  var tw = t.offsetWidth;"
	html += "  var th = t.offsetHeight;"
	html += "  if (x + tw > window.innerWidth) x = e.clientX - tw - 14;"
	html += "  if (y + th > window.innerHeight) y = e.clientY - th - 14;"
	html += "  t.style.left = x + 'px';"
	html += "  t.style.top = y + 'px';"
	html += "}"
	html += {"function hideTip() { document.getElementById('tip').style.display='none'; }"}
	html += "</script></body></html>"
	return html
