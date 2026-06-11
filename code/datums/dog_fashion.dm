/datum/dog_fashion
	var/name
	var/desc
	var/emote_see
	var/emote_hear
	var/speak
	var/speak_emote

	// This isn't applied to the dog, but stores the icon_state of the
	// sprite that the associated item uses
	var/icon_file
	var/obj_icon_state
	var/obj_alpha
	var/obj_color

/datum/dog_fashion/New(mob/M)
	name = replacetext(name, "REAL_NAME", M.real_name)
	desc = replacetext(desc, "NAME", name)

/datum/dog_fashion/proc/apply(mob/living/simple_animal/pet/dog/D)
	if(name)
		D.name = name
	if(desc)
		D.desc = desc
	if(emote_see)
		D.emote_see = emote_see
	if(emote_hear)
		D.emote_hear = emote_hear
	if(speak)
		D.speak = speak
	if(speak_emote)
		D.speak_emote = speak_emote

/datum/dog_fashion/proc/get_overlay(dir)
	if(icon_file && obj_icon_state)
		var/image/corgI = image(icon_file, obj_icon_state, dir = dir)
		corgI.alpha = obj_alpha
		corgI.color = obj_color
		return corgI


/datum/dog_fashion/head
	icon_file = 'icons/mob/corgi_head.dmi'

/datum/dog_fashion/back
	icon_file = 'icons/mob/corgi_back.dmi'

/datum/dog_fashion/head/helmet
	name = "警长 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/chef
	name = "副厨 REAL_NAME"
	desc = ""


/datum/dog_fashion/head/captain
	name = "队长 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/kitty
	name = "Runtime"
	emote_see = list("咳出一团毛球", "伸了个懒腰")
	emote_hear = list("发出呼噜声")
	speak = list("Purrr", "Meow!", "MAOOOOOW!", "HISSSSS", "MEEEEEEW")
	desc = ""

/datum/dog_fashion/head/rabbit
	name = "Hoppy"
	emote_see = list("抽动着鼻子", "蹦跳了几下")
	desc = ""

/datum/dog_fashion/head/beret
	name = "Yann"
	desc = ""
	speak = list("le woof!", "le bark!", "JAPPE!!")
	emote_see = list("吓得缩成一团。", "投降了。", "开始装死。","像是看到面前有堵墙一样。")


/datum/dog_fashion/head/detective
	name = "侦探 REAL_NAME"
	desc = ""
	emote_see = list("正在调查周围。","四处嗅闻线索。","寻找着零食。","从帽子里掏出一颗糖果玉米。")


/datum/dog_fashion/head/nurse
	name = "护士 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/pirate
	name = "Pirate-title Pirate-name"
	desc = ""
	emote_see = list("正在寻找宝藏。","冷冷地盯着前方……","咬得自己小小的柯基牙齿咯咯作响！")
	emote_hear = list("凶狠地低吼！", "龇牙咆哮。")
	speak = list("Arrrrgh!!","Grrrrrr!")

/datum/dog_fashion/head/pirate/New(mob/M)
	..()
	name = "[pick("老","坏血病","黑","朗姆","瘸腿","血腥","坏疽","死神","长约翰")] [pick("狗粮","腿","胡子","牙","臭甲板","Threepwood","Le Chuck","海盗","西尔弗","Crusoe")]"

/datum/dog_fashion/head/ushanka
	name = "Communist-title Realname"
	desc = ""
	emote_see = list("沉思着资本主义经济模型的失败。", "琢磨着先锋主义的利弊。")

/datum/dog_fashion/head/ushanka/New(mob/M)
	..()
	name = "[pick("同志","政委","光荣领袖")] [M.real_name]"

/datum/dog_fashion/head/warden
	name = "警官 REAL_NAME"
	emote_see = list("流着口水。","正在找甜甜圈。")
	desc = ""

/datum/dog_fashion/head/blue_wizard
	name = "大法师 REAL_NAME"
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU", "EI NATH!")

/datum/dog_fashion/head/red_wizard
	name = "炎术师 REAL_NAME"
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU", "ONI SOMA!")

/datum/dog_fashion/head/cardborg
	name = "Borgi"
	speak = list("Ping!","Beep!","Woof!")
	emote_see = list("开始失控。", "嗅探着非人类。")
	desc = ""

/datum/dog_fashion/head/ghost
	name = "\improper Ghost"
	speak = list("WoooOOOooo~","AUUUUUUUUUUUUUUUUUU")
	emote_see = list("跌跌撞撞地游荡。", "瑟瑟发抖。")
	emote_hear = list("发出嚎叫！","呻吟着。")
	desc = ""
	obj_icon_state = "sheet"

/datum/dog_fashion/head/santa
	name = "圣诞老人的柯基助手"
	emote_hear = list("汪汪唱着圣诞歌。", "欢快地叫个不停！")
	emote_see = list("寻找着礼物。", "核对着自己的清单。")
	desc = ""

/datum/dog_fashion/head/cargo_tech
	name = "柯基技师 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/reindeer
	name = "红鼻子柯基 REAL_NAME"
	emote_hear = list("照亮前路！", "发出亮光。", "汪汪叫着！")
	desc = ""

/datum/dog_fashion/head/sombrero
	name = "先生 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/sombrero/New(mob/M)
	..()
	desc = ""

/datum/dog_fashion/head/hop
	name = "副官 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/deathsquad
	name = "突击兵 REAL_NAME"
	desc = ""

/datum/dog_fashion/head/clown
	name = "小丑 REAL_NAME"
	desc = ""
	speak = list("HONK!", "Honk!")
	emote_see = list("耍着滑稽把戏。", "啪叽一声滑倒了。")

/datum/dog_fashion/back/deathsquad
	name = "突击兵 REAL_NAME"
	desc = ""
