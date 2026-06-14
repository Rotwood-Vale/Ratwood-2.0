// Any areas that are part of the town
//////
/////
////     TOWN AREAS
////
///
//

/area/rogue/outdoors/town
	name = "室外"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/town
	first_time_text = "腐木谷地城"
	town_area = TRUE
	warden_area = FALSE
	deathsight_message = "腐木谷地城，以及那里熙攘往来的众生"

/area/rogue/outdoors/town/graveyard
	name = "城镇墓园"
	icon_state = "church"
	first_time_text = "亡者花园"
	holy_area = TRUE
	warden_area = TRUE//eh why not it's got grass I guess
	deathsight_message = "一处供亡者永眠的神圣之地"

/area/rogue/outdoors/town/rockhill
	name = "岩丘室外"
	first_time_text = "岩丘镇"
	deathsight_message = "岩丘城，以及那里熙攘往来的众生"

/area/rogue/outdoors/town/church
	name = "教区室外"
	first_time_text = "旧教区"
	deathsight_message = "繁华城池边缘的圣化废墟"
	// holy_area = TRUE //ravox decrees it most honorable to not benefit from you +2 to everything buffs while duelling in the duel pit

/area/rogue/indoors/shelter/town
	icon_state = "town"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	town_area = TRUE

/area/rogue/indoors/town
	name = "室内"
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/exposed/town
	town_area = TRUE
	deathsight_message = "腐木谷地城门窗之后，那些熙攘往来的众生"
	detail_text = DETAIL_TEXT_AZURE_PEAK

/area/rogue/outdoors/exposed/town
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	town_area = TRUE

/area/rogue/outdoors/exposed/town/keep
	name = "城堡"
	icon_state = "manor"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_KEEP

/area/rogue/outdoors/exposed/town/keep/unbuildable
	name = "城堡禁建区"

/area/rogue/outdoors/exposed/town/keep/unbuildable/can_craft_here()
	return FALSE

/area/rogue/indoors/town/manor
	name = "庄园"
	icon_state = "manor"
	droning_sound = list('sound/music/area/manor.ogg', 'sound/music/area/manor2.ogg')
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	first_time_text = "腐木谷地城堡"
	keep_area = TRUE
	detail_text = DETAIL_TEXT_MANOR
	deathsight_message = "皇家门扉之后，细毯铺地，权势暗涌"

/area/rogue/outdoors/exposed/manorgarri
	icon_state = "manorgarri"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE

/area/rogue/indoors/town/manor/rockhill
	first_time_text = "岩丘城堡"

/area/rogue/outdoors/town/roofs
	name = "屋顶"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/town/roofs
	first_time_text = null
	deathsight_message = "繁华城池的屋顶之上"

/area/rogue/outdoors/town/roofs/keep
	name = "城堡屋顶"
	icon_state = "manor"
	keep_area = TRUE

/area/rogue/outdoors/town/roofs/church
	name = "教堂屋顶"
	holy_area = TRUE

/area/rogue/outdoors/town/roofs/warden
	name = "守林人屋顶"
	warden_area = TRUE

/area/rogue/outdoors/town/roofs/tavern
	name = "酒馆屋顶"
	tavern_area = TRUE

/area/rogue/indoors/shelter/town/roofs
	icon_state = "roofs"

/area/rogue/indoors/town/magician
	name = "谷地大学"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "谷地大学"
	converted_type = /area/rogue/outdoors/exposed/magiciantower
	keep_area = TRUE
	// detail_text = DETAIL_TEXT_UNIVERSITY_OF_ROTWOOD
	
/area/rogue/indoors/town/magician/arcynefortress
	name = "奥术堡垒"
	first_time_text = "奥术堡垒"

/area/rogue/indoors/town/magician/rockhill
	name = "巫师塔"
	first_time_text = "魔导高塔"
	// detail_text = DETAIL_TEXT_WIZARD_TOWER

/area/rogue/outdoors/exposed/magiciantower
	icon_state = "magiciantower"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE
	// detail_text = DETAIL_TEXT_UNIVERSITY_OF_ROTWOOD

/area/rogue/indoors/town/shop
	name = "商店"
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/shop
	deathsight_message = "身处昂贵货物与钱币之间"

/area/rogue/outdoors/exposed/shop
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'

/area/rogue/indoors/town/steward
	name = "总管室"
	icon_state = "steward"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/physician
	name = "医师所"
	icon_state = "physician"
	droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "一处回荡痛苦呻吟与熟练医者忙碌声的建筑"

/area/rogue/indoors/town/academy
	name = "学院"
	icon_state = "academy"
	droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "厚重书卷翻动时的沙沙声"

/area/rogue/indoors/town/bath
	name = "浴场"
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/bath
	deathsight_message = "一处充满欲望与秘密的巢穴"

// /area/rogue/indoors/town/bath/vault
// 	name = "Bathmaster vault"
// 	icon_state = "bathvault"

/area/rogue/outdoors/exposed/bath
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'

/area/rogue/outdoors/exposed/bath/vault//Note that this DOESN'T WORK!! The mechanic is actually keyed to the particular type of floor-tile instead of area tile. Weird, I know. Also there's no reason for it to be Exposed, no idea why that's been the case.
	name = "浴场主金库"
	icon_state = "bathvault"
	ceiling_protected = TRUE

/area/rogue/indoors/town/garrison
	name = "驻军营房"
	icon_state = "garrison"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	keep_area = TRUE
	deathsight_message = "锁链作响，警棍噼啪作声"

/area/rogue/indoors/town/cell
	name = "地牢牢房"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	keep_area = TRUE
	cell_area = TRUE
	soundproof = TRUE
	deathsight_message = "充满痛苦与折磨的牢房"

/area/rogue/dietroyt //dungeon labor camp
	name = "地牢苦役营"
	icon_state = "cell"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	cell_area = TRUE
	town_area = TRUE
	no_special_item_retrieval = TRUE
	deathsight_message = "鹤嘴镐挥动的嗡响与赎罪者的劳作声"
	first_time_text = "苦役营"
	detail_text = DETAIL_TEXT_DIETROYT

/area/rogue/dietroyt/nomagic
	noteleport = TRUE

/area/rogue/indoors/town/tavern
	name = "酒馆"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/tavern
	tavern_area = TRUE
	deathsight_message = "刺鼻酒气与疲惫旅人"

/area/rogue/outdoors/exposed/tavern
	icon_state = "tavern"
	// droning_sound = 'sound/silence.ogg'//it should only be silent because of the jukeboxes, no jukeboxes outside
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/under/town/basement/tavern
	name = "酒馆地下室"
	icon_state = "basement"
	tavern_area = TRUE
	town_area = TRUE
	ceiling_protected = TRUE
	deathsight_message = "流言与欢宴之下，一间陈年麦酒散着霉味的地窖"

/area/rogue/indoors/town/church
	name = "教堂"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	holy_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "一处向十神立誓的神圣之地"

/area/rogue/outdoors/exposed/church
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	deathsight_message = "一处向十神立誓的神圣之地"

/area/rogue/indoors/town/church/chapel
	icon_state = "chapel"
	first_time_text = "十神之殿"
	detail_text = DETAIL_TEXT_CHAPEL

/area/rogue/indoors/town/church/basement
	icon_state = "church"
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/church/basement/crypt
	first_time_text = "十神墓穴"

/area/rogue/indoors/town/warehouse
	name = "进口仓库"
	icon_state = "warehouse"
	deathsight_message = "发霉木箱与廉价进口货"

/area/rogue/indoors/town/warehouse/harbor
	droning_sound = 'sound/music/area/harbor.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT
	deathsight_message = "发霉木箱与廉价进口货，空气中还带着咸涩海味"

/area/rogue/indoors/town/warehouse/can_craft_here()
	return FALSE

/area/rogue/indoors/town/warden
	name = "守林人堡垒"
	warden_area = TRUE
	deathsight_message = "一座覆满青苔的石砌堡垒，守望着荒野"

/area/rogue/indoors/town/cell/warden
	converted_type = /area/rogue/indoors/town/warden
	town_area = FALSE
	warden_area = TRUE
	deathsight_message = "荒野边缘用以施加痛苦与折磨的临时牢房"

/area/rogue/indoors/inq
	name = "宗教裁判所"
	icon_state = "chapel"
	first_time_text = "奥塔瓦宗教裁判所"
	// detail_text = DETAIL_TEXT_INQUISITION_HQ

/area/rogue/indoors/inq/office
	name = "审判官办公室"
	icon_state = "chapel"

/area/rogue/indoors/inq/basement
	name = "宗教裁判所地下室"
	icon_state = "chapel"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/inq/import
	name = "外来货仓"
	icon_state = "warehouse"

/area/rogue/indoors/inq/import/can_craft_here()
	return FALSE

/area/rogue/indoors/town/vault
	name = "金库"
	icon_state = "vault"
	keep_area = TRUE
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/entrance
	first_time_text = "罗格镇"
	icon_state = "entrance"

/area/rogue/indoors/town/dwarfin
	name = "工匠公会"
	icon_state = "dwarfin"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "谷地工匠公会"
	converted_type = /area/rogue/outdoors/exposed/dwarf
	detail_text = DETAIL_TEXT_AZUREAN_GUILD_OF_CRAFT

/area/rogue/indoors/town/dwarfin/rockhill
	first_time_text = "岩丘工匠公会"

/area/rogue/outdoors/exposed/dwarf
	icon_state = "dwarf"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

// /area/rogue/outdoors/town/dwarf
// 	name = "dwarven quarter"
// 	icon_state = "dwarf"
// 	droning_sound = 'sound/music/area/dwarf.ogg'
// 	droning_sound_dusk = null
// 	droning_sound_night = null
// 	first_time_text = "The Dwarven Quarter"
// 	soundenv = 16
// 	converted_type = /area/rogue/indoors/shelter/town/dwarf

// /area/rogue/indoors/shelter/town/dwarf
// 	icon_state = "dwarf"
// 	droning_sound = 'sound/music/area/dwarf.ogg'
// 	droning_sound_dusk = null
// 	droning_sound_night = null

/area/rogue/outdoors/town/outskirts
	name = "城郊"
	warden_area = TRUE
	deathsight_message = "文明蜷附在墙垣一侧，如同苔藓一般"
