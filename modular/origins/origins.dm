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
	name = "奥塔瓦"
	desc = "一片严寒无情的高山地带，据说是普赛顿信仰的发源地。正统派审判庭便从奥塔瓦旧王朝的首都运作。"
	origin_title = "奥塔瓦"
	origin_language = /datum/language/otavan
	map_x = 183
	map_y = 151

/datum/origin/zybantine
	name = "兹班图"
	desc = "兹班图帝国横跨诸国，囊括了费伦提亚的大片沙漠。这个帝国崇尚力量与财富；不过也流传着许多传言，说这个奢华帝国正是靠不那么光彩的手段聚敛财富。"
	origin_title = "兹班图"
	origin_language = /datum/language/celestial
	map_x = 364
	map_y = 325

/datum/origin/naledi
	name = "纳莱迪"
	desc = "纳莱迪人曾建立过属于自己的繁荣帝国，并与恶魔，也就是当地人口中的灯灵，鏖战了数个世纪。随着巴奥莎的升格，他们的故土几乎被彻底毁灭。据说最初的魔法便诞生于此。"
	origin_title = "纳莱迪"
	origin_language = /datum/language/celestial
	map_x = 514
	map_y = 242

/datum/origin/ferentia
	name = "费伦提亚"
	desc = "位于格伦泽尔霍夫特与伊特鲁斯卡西岸外海的岛屿王国。费伦提亚人勤勉务实，劳作一天之后总爱畅饮作乐。过去，这个王国不得不同时提防奥塔瓦与格伦泽尔霍夫特，如今却成了两国之间的调停者。"
	origin_title = "费伦提亚"
	map_x = 151
	map_y = 200

/datum/origin/underdark
	name = "幽暗地域"
	desc = "据说幽暗地域是遍布格里莫里亚地壳深处的庞大洞窟与隧道网络，那里既是黑暗精灵与狗头人的家园，也藏着神秘的弗卢维安城邦墨丘利安。幽暗地域的洞穴里危机四伏，从酸液河流到食人蜘蛛无所不有，甚至还流传着地底巨龙的夸张传闻。"
	origin_title = "幽暗地域"
	map_x = 120
	map_y = 344

/datum/origin/hammerhold
	name = "铁锤堡"
	desc = "铁锤堡半岛与群岛栖息着形形色色的族群，从半岛上崇信阿比索尔的维坦人，到鲁-耶尔蒙的红发民众，再到曾构成四季海域的诸岛。 \
	这里既有白金矮人堡垒，也有一座辉煌大教堂的废墟，那里曾是北方十神信仰的中心； \
	除此之外，还有各个零散的小王国，也就是所谓的雅尔领邦，它们都松散地服从于维坦领主持环者的意志。"
	origin_title = "铁锤堡"
	origin_language = /datum/language/hammerholdian
	map_x = 90
	map_y = 132

/datum/origin/grenzelhoft
	name = "格伦泽尔霍夫特"
	desc = "格伦泽尔霍夫特帝国是十神教廷的所在之地，也是格里莫里亚最主要的十神信仰中心。由于难以计数的亡者怪物肆虐帝国，许多宏伟都市与工匠城镇已被弃置，人们转而逃往海外或首都城内谋生。纵然如此，格伦泽尔霍夫特仍屹立不倒。"
	origin_title = "格伦泽尔霍夫特"
	origin_language = /datum/language/grenzelhoftian
	map_x = 283
	map_y = 188

/datum/origin/avar
	name = "阿瓦尔"
	desc = "阿瓦尔是一片被北方群山、起伏草原与渐次逼近的针叶林分割开的土地。这里坐落着仅次于奥塔瓦的第二大普赛顿王国、东境最精锐的武装力量，以及格里莫里亚境内族群与文化最为多元的人民。"
	origin_title = "阿瓦尔"
	origin_language = /datum/language/aavnic
	map_x = 417
	map_y = 189

/datum/origin/gronn
	name = "格隆恩"
	desc = "格隆恩草原是一片充斥流血与战争之地；格拉加尔的战帮肆虐格隆恩人民，同时觊觎南方阿瓦尔的霸权。不过草原并未彻底沉沦，仍有许多城镇与游牧家族在掠夺者的征服阴影下艰难求生。"
	origin_title = "格隆恩"
	origin_language = /datum/language/gronnic
	map_x = 445
	map_y = 116

/datum/origin/etrusca
	name = "伊特鲁斯卡"
	desc = "一个阳光明媚的贸易国，主要由风景秀美的群岛组成。伊特鲁斯卡以自身的武艺与烹饪传统为荣，格里莫里亚各地都有人努力学习这个商贸国度里牧侠与决斗者的技艺。"
	origin_title = "伊特鲁斯卡"
	origin_language = /datum/language/etruscan
	map_x = 266
	map_y = 277

/datum/origin/kazengun
	name = "风郡"
	desc = "风郡并非单一国家，而是三个僵持了数世纪的王朝共同构成的土地。岛屿西侧是风郡幕府，东侧是普伊-梅恩王朝，北方则由信义氏族掌控。西方人常会远行至风郡，但到访者带回的故事，大多都是关于那里的武士与妖魔的夸张传闻。考虑到这些王朝与西方世界之间横亘的汪洋，风郡进口品自然格外昂贵。"
	origin_title = "风郡"
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
	html += "<html><head><meta charset='utf-8'><style>"
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
	var/current_label = origin ? origin.name : "未选择"
	html += "<b>当前选择：[current_label]</b>"
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
