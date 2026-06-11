/* HELMSGUARD LANDMARK */





///////////////////////
/* LATEJOIN SUNDMARK */
///////////////////////

/obj/effect/landmark/start/helms/late/noblelate
	name = "贵族晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
//	"Lord Castellan",
	"Lord Consort",
	"Lord Heir",
	"Hand",
	"Steward"
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/courtierlate
	name = "廷臣晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Court Physician",
	"Jester",
	"Keep Servant",
	"Dungeoneer",
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/garrisonlate
	name = "侍从晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Knight",
	"Master-at-Arms",
	"Man-at-Arms",
	"Gatekeeper"
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/churchlate
	name = "教会晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(	
	"Priest",
	"Inquisitor",
	"Monk",
	"Chapter Master",
	"Knight Templar",
	"Templar Sergeant",
	"Knight Hospitaler",
	"Hospitaler Sergeant"
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/townerlate
	name = "镇民晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Merchant",
	"Innkeeper",
	"Armorer",
	"Weaponsmith",
	"Apothecary",
	"Leatherworker",
	"Tailor",
	"Blacksmith",
	"Cook",
	"Apprentice",
	"Serving Lad"
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/citywatchlate
	name = "城卫晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Bailiff",
	"Watchman",
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/peasantlate
	name = "农民晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Soilson",
	"Serf"
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/rabblelate
	name = "平民晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Bawdyhouse Master",
	"Rake",
	"Gutterfolk",
	)
	delete_after_roundstart = FALSE


/obj/effect/landmark/start/helms/late/adventurerlate
	name = "冒险者晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Adventurer",
	)
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/helms/late/mercenarylate
	name = "佣兵晚加入（赫姆）"
	icon_state = "arrow"
	jobspawn_override = list(
	"Mercenary",
	)
	delete_after_roundstart = FALSE

///////////////////////
/* ROUNDSTART SPAWN */
///////////////////////
//These are roles exclusive to Helmsguard//

/obj/effect/landmark/start/helms/noble/markgraf
	name = "城主"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/noble/consort
	name = "领主配偶"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/noble/heir
	name = "领主继承人"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/noble/hand
	name = "御前之手"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/noble/steward
	name = "总管"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/court/physician
	name = "宫廷医师"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/court/jester
	name = "弄臣"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/court/servant
	name = "城堡仆役"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/garrison/knight
	name = "骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/garrison/manatarms
	name = "披甲兵"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/garrison/masteratarms
	name = "军械长"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/garrison/gatekeeper
	name = "守门人"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/priest
	name = "司祭"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/inquisitor
	name = "审判官"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/monk
	name = "修士"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/chapmaster
	name = "礼拜堂长"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/templar_knight
	name = "圣殿骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/templar_sergeant
	name = "圣殿军士"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/hospitaler_knight
	name = "医院骑士"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/church/hospitaler_sergeant
	name = "医院军士"
	icon_state = "arrow"


/obj/effect/landmark/start/helms/watch/bailiff
	name = "法警"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/watch/watchman
	name = "卫兵"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/watch/dungeoneer
	name = "狱卒"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/merchant
	name = "商人"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/innkeeper
	name = "店主"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/armorer
	name = "甲匠"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/weaponsmith
	name = "武器匠"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/blacksmith
	name = "铁匠"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/builder
	name = "工匠"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/apothecary
	name = "药剂师"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/leatherworker
	name = "皮匠"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/apprentice
	name = "学徒"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/yeomen/tailor
	name = "裁缝"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/peasants/soilson
	name = "农家子"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/peasants/serf
	name = "农奴"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/rabble/master
	name = "风月馆老板"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/rabble/wench
	name = "浪荡子"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/rabble/gutterfolk
	name = "沟巷人"
	icon_state = "arrow"

/obj/effect/landmark/start/helms/rabble/servingwench
	name = "侍应小厮"
	icon_state = "arrow"
