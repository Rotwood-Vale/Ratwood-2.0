/*
	Combat Mode Music Track Datums
	---
	Currently only used for overriding the default combat music that comes with your job or antagonist.
	As of writing they are never directly applied to mobs themselves, only the name and musicpath are.
	Deleting these datums or renaming subtypes will not break preferences; invalid saves get redirected to /default.
	When adding new songs, add a shortname around ~12 characters for the game preferences menu.

	IMPORTANT! Be careful about adding songs to this list that aren't used anywhere else, lest you needlessly inflate the RSC.
*/

// Admins: please don't molest my lists. You can't add new types at runtime anyways. Kisses! - Zoktiik
GLOBAL_LIST_EMPTY(cmode_tracks_by_type)
GLOBAL_LIST_EMPTY(cmode_tracks_by_name)

// People make mistakes. This should help catch when that happens.
/proc/cmode_track_to_namelist(datum/combat_music/track)
	if(!track)
		return
	if(!track.name)
		LAZYREMOVE(GLOB.cmode_tracks_by_type, track.type)
		CRASH("CMODE MUSIC: type [track.type] has no name!")
	if(GLOB.cmode_tracks_by_name[track.name])
		LAZYREMOVE(GLOB.cmode_tracks_by_type, track.type)
		CRASH("CMODE MUSIC: type [track.type] has duplicate name \"[track.name]\"!")
	GLOB.cmode_tracks_by_name[track.name] = track
	return

/datum/combat_music
	var/name
	var/desc
	var/shortname
	var/credits
	var/musicpath = list()

// Shit WILL break if you change /default's typepath. Don't do it.
/datum/combat_music/default
	name = "默认"
	desc = "我让当前状态自己为我歌唱；它的曲目会动态变化。"
	shortname = "默认"
	musicpath = list()

/datum/combat_music/acolyte
	name = "侍僧"
	desc = ""
	shortname = "侍僧"
	credits = "T-87 SULFURHEAD - Hellions (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_acolyte.ogg')

/datum/combat_music/adjudicator
	name = "审判官"
	desc = "如今，没有什么比一位公正的法官更残酷。"
	shortname = "审判官"
	credits = "Chivalry 2 OST: Duty and Honor II (with Ryan Patrick Buckley)"
	musicpath = list('sound/music/templarofpsydonia.ogg')

/datum/combat_music/adventurer_default
	name = "冒险者默认曲（战士）"
	desc = ""
	shortname = "冒险默认"
	credits = "T-87 SULFURHEAD - Men at War (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander2.ogg')

/datum/combat_music/adventurer_2
	name = "冒险者 2（刺客）"
	desc = ""
	shortname = "冒险者 2"
	credits = "T-87 SULFURHEAD - Ninth Circle (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander.ogg')

/datum/combat_music/adventurer_3
	name = "冒险者 3（盗贼/法师）"
	desc = ""
	shortname = "冒险者 3"
	credits = "T-87 SULFURHEAD - MORTEM OBIRE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander3.ogg')

/datum/combat_music/adventurer_4
	name = "冒险者 4"
	desc = ""
	shortname = "冒险者 4"
	credits = "T-87 SULFURHEAD - Snicker Snacker (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/adventurer/combat_outlander4.ogg')

/datum/combat_music/ascended
	name = "升格者"
	desc = "凡人永远无法理解我已抵达何等高处。"
	shortname = "升格者"
	credits = "TO PIERCE THE BLACK SKY /// ENVY INTERLUDE - UNFORTUNATE DEVELOPMENT"
	musicpath = list('sound/music/combat_ascended.ogg')

/datum/combat_music/astrata
	name = "Astrata 之光"
	desc = ""
	shortname = "Astrata"
	credits = "T-87 SULFURHEAD - Heliotrix (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_astrata.ogg')

/datum/combat_music/bandit_default
	name = "强盗默认曲"
	desc = ""
	shortname = "强盗默认"
	credits = "T-87 SULFURHEAD - Deadly Shadows (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_deadlyshadows.ogg')

/datum/combat_music/astratan_zeal
	name = "Astrata 狂热"
	desc = "在她的指引下挥击时，你的双手永不会染血。"
	shortname = "Astrata"
	credits = "Jesper Kyd - Light of the Imperium"
	musicpath = list('sound/music/combat_holy.ogg')

/datum/combat_music/bandit_soldier
	name = "强盗士兵（逃兵/法外者）"
	desc = ""
	shortname = "强盗士兵"
	credits = "T-87 SULFURHEAD - The Wall (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_thewall.ogg')

/datum/combat_music/bandit_rogue
	name = "强盗盗匪（佣兵/扒手）"
	desc = ""
	shortname = "强盗盗匪"
	credits = "T-87 SULFURHEAD - Cutpurse (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_cutpurse.ogg')

/datum/combat_music/barbarian
	name = "野蛮人"
	desc = "咬紧牙关吧，就好像你嘴里还剩牙可以咬似的。"
	shortname = "野蛮人"
	musicpath = list('sound/music/combat_gronn.ogg')

/datum/combat_music/berserker
	name = "狂战士"
	desc = "这一切一点一点将你碾碎，直到你变得强大。"
	shortname = "狂战士"
	credits = "Mikolai Stroinski - Eyes of the Wolf"
	musicpath = list('sound/music/combat_berserker.ogg')

/datum/combat_music/blackoak
	name = "Black Oak 的守卫"
	desc = "树木天生就是用来吊人的。"
	shortname = "Black Oak"
	musicpath = list('sound/music/combat_blackoak.ogg')

/datum/combat_music/beggar
	name = "乞丐"
	desc = "踢、抓、咬。"
	shortname = "乞丐"
	credits = "Pathologic (Classic) - Most Combat Theme"
	musicpath = list('sound/music/combat_bum.ogg')

/datum/combat_music/conddottiero
	name = "Condottiero 公会成员"
	desc = "去悔恨那微笑着逐利之人的时代吧。"
	shortname = "Condottiero"
	musicpath = list('sound/music/combat_condottiero.ogg')

/datum/combat_music/cultic
	name = "邪教巫术"
	desc = "我被使唤到只剩骨头，却永远无法安息。我是什么？"
	shortname = "邪教"
	credits = "Igor Kornelyuk - Воланд (\"Voland\")"
	musicpath = list('sound/music/combat_cult.ogg')

/datum/combat_music/combat
	name = "经典战斗曲（冒险者）"
	desc = "尽量死在一个方便别人摸尸的地方。"
	shortname = "经典战斗"
	musicpath = list('sound/music/combat.ogg')

/* Unused
/datum/combat_music/combat_old_2
	name = "Combat Old 2"
	desc = ""
	shortname = "Combat Old 2"
	musicpath = list('sound/music/combat2.ogg')
*/

/datum/combat_music/darkstar
	name = "Dark Star（Verewolf/野蛮人/狂战士）"
	desc = ""
	shortname = "Dark Star"
	credits = " T-87 SULFURHEAD - Archetype of the Dark Star (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_darkstar.ogg')

/datum/combat_music/deadite
	name = "Deadite"
	desc = "踢！抓！咬！"
	shortname = "Deadite"
	musicpath = list('sound/music/combat_weird.ogg')

/datum/combat_music/dendor
	name = "Dendor 教士（守林者）"
	desc = ""
	shortname = "Dendor"
	credits = "T87-Sulfurhead - Metamorphosis (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/garrison/combat_warden.ogg')

/datum/combat_music/desertrider
	name = "沙漠骑手佣兵"
	desc = "敬出价最高的人一杯。"
	shortname = "沙漠骑手"
	credits = "Two Fingers - You Ain't Down"
	musicpath = list('sound/music/combat_desertrider.ogg')

/datum/combat_music/druid
	name = "德鲁伊（Verewolf）"
	desc = "死路、无数岔道、令人窒息的泥沼。它们比任何刀刃都更危险。"
	shortname = "德鲁伊"
	credits = "The Witcher 3: Wild Hunt - Hunt or Be Hunted"
	musicpath = list('sound/music/combat_druid.ogg')

/datum/combat_music/dungeoneer
	name = "地城探险者"
	desc = "哦，要不是我还有活干，我真不知道会对这座镇子做出些什么。"
	shortname = "探险者"
	credits = "T87-Sulfurhead - RATEATER (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_dungeoneer.ogg')

/datum/combat_music/dwarf
	name = "矮人仇怨承载者"
	desc = "看见这个了吗？某种意义上说，它算是一本留言簿。"
	shortname = "矮人"
	musicpath = list('sound/music/combat_dwarf.ogg')

/datum/combat_music/eora
	name = "Eora 教士"
	desc = "刚分手的时候，千万别听这首。" // from the credits.txt lol
	shortname = "Eora"
	credits = "T-87 SULFURHEAD - Family Melts Away (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_eora.ogg')

/datum/combat_music/forlorn
	name = "Forlorn Hope 佣兵"
	desc = "你觉得自己从死亡手里逃出来了吗，先锋？"
	shortname = "Forlorn Hope"
	musicpath = list('sound/music/combat_blackstar.ogg')

/datum/combat_music/fullplate
	name = "全身板甲"
	desc = "一位披着日渐衰败甲胄的骑士。"
	shortname = "板甲"
	credits = "Stoneshard OST - Track 9 (https://youtu.be/duI4N5MTyKY?si=aHEUbkUzEHSDsIRh)"
	musicpath = list('sound/music/combat_fullplate.ogg')

/datum/combat_music/grenzelhoft
	name = "Grenzelhoft 佣兵"
	desc = "你的态度令人无法忍受，你的笑容也让人作呕。你被录用了。"
	shortname = "Grenzelhoft"
	credits = "Helbrede - Sons of Tyr"
	musicpath = list('sound/music/combat_grenzelhoft.ogg')

/datum/combat_music/heretic_zizo
	name = "异端 - Zizo（巫妖）"
	desc = "谁都别信，因为力量始终都在你自己体内。"
	shortname = "Zizo"
	credits = "T87-Sulfurhead - DEMESNE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_heretic.ogg')

/datum/combat_music/heretic_matthios
	name = "异端 - Matthios"
	desc = "一阵精力狂涌而来。你早已忘记上一次有人告诉你何为正确、该做什么，是在什么时候了。"
	shortname = "Matthios"
	credits = "T87-Sulfurhead - Amontillado (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_matthios.ogg')

/datum/combat_music/heretic_graggar
	name = "异端 - Graggar"
	desc = "也许这一次，你终于会感受到真正的强大。"
	shortname = "Graggar"
	credits = "T87-Sulfurhead - Black Powder (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_graggar.ogg')

/datum/combat_music/heretic_graggar_2
	name = "异端 - Graggar（替代）"
	desc = "也许这一次，你终于会感受到真正的强大。它可能很吵，所以小心。"
	shortname = "Graggar 2"
	credits = "Devil's Meat Grinder - OTXO OST"
	musicpath = list('sound/music/combat_graggar_new.ogg')

/datum/combat_music/heretic_baotha
	name = "异端 - Baotha"
	desc = "去他的明天。"
	shortname = "Baotha"
	credits = "T87-Sulfurhead - Love Within You (Rough Mix) (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_baotha.ogg')

/datum/combat_music/highgrain
	name = "高原谷地"
	desc = "在他倒地之前，我就已经要了他的命。"
	shortname = "高原谷地"
	credits = "Half-Lyfe: Alyx - APC Cannon - Extended (https://youtu.be/LsGts7dAqTQ?si=wAMHGtrMKzHxyIon)"
	musicpath = list('sound/music/combat_highgrain.ogg')

/datum/combat_music/iconoclast
	name = "破像者"
	desc = ""
	shortname = "破像者"
	credits = "Valley of Judgement- Lateralis"
	musicpath = list('sound/music/Iconoclast.ogg')

/datum/combat_music/inquisitor
	name = "审判官（猎魔人/破法者）"
	desc = ""
	shortname = "审判官"
	credits = "Hellsing OST RAID Track 15: Survival on the Street of Insincerity"
	musicpath = list('sound/music/inquisitorcombat.ogg')

/datum/combat_music/inquis_ordinator
	name = "审判官 - Ordinator"
	desc = ""
	shortname = "Ordinator"
	musicpath = list('sound/music/combat_inqordinator.ogg')

/datum/combat_music/jester
	name = "小丑"
	desc = ""
	shortname = "小丑"
	credits = "Alias Conrad Coldwood - Pepper Steak (OFF OST)"
	musicpath = list('sound/music/combat_jester.ogg')

/datum/combat_music/kazengite
	name = "Kazengite"
	desc = ""
	shortname = "Kazengite"
	musicpath = list('sound/music/combat_kazengite.ogg')

/datum/combat_music/firestorm
	name = "烈焰风暴（Kazengun）"
	desc = ""
	shortname = "烈焰风暴"
	musicpath = list('sound/music/combat_Kazengun_Firestorm.ogg')

/datum/combat_music/overlord
	name = "霸主（Kazengun）"
	desc = ""
	shortname = "霸主"
	musicpath = list('sound/music/combat_Kazengun_Overlord.ogg')

/datum/combat_music/runaway_chariot
	name = "失控战车（Kazengun）"
	desc = ""
	shortname = "失控战车"
	musicpath = list('sound/music/combat_Kazengun_Runaway_Chariot.ogg')

/datum/combat_music/knight
	name = "骑士（贵族）"
	desc = ""
	shortname = "骑士"
	credits = "T87-Sulfurhead - Durandal (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_knight.ogg')

/datum/combat_music/man_at_arms
	name = "披甲军士（中士）"
	desc = ""
	shortname = ""
	credits = "T87-Sulfurhead - Ready or Not (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_ManAtArms.ogg')


/datum/combat_music/malpractice
	name = "误诊"
	desc = "杀不死你的东西，只会让你更虚弱。"
	shortname = "误诊"
	credits = "Pathologic - Utroba Aggression"
	musicpath = list('sound/music/combat_malpractice.ogg')

// Maniac code has this track uncommented so this is free. And tbh it should remain here. Banger.
/datum/combat_music/maniac
	name = "疯子"
	desc = "TNC 是我所知最讲道理的公司。"
	shortname = "疯子"
	credits = "Thomas Bangalter - Stress"
	musicpath = list('sound/music/combat_maniac2.ogg')

/* Unused
/datum/combat_music/maniac_old
	name = "Maniac (Old)"
	desc = ""
	shortname = "Maniac Old"
	musicpath = list('sound/music/combat_maniac.ogg')
*/

/datum/combat_music/martyr
	name = "殉道者"
	desc = ""
	shortname = "殉道者"
	musicpath = list('sound/music/combat_martyrsafe.ogg')

// The two Martyr Vengeance combat tracks are intentionally left out of this. Look how they're used.

/datum/combat_music/magician
	name = "宫廷法师"
	desc = ""
	shortname = "法师"
	credits = "T-87 SULFURHEAD - MANASURGE (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/nobility/combat_courtmage.ogg')

/datum/combat_music/monastic
	name = "修会狂热"
	desc = ""
	shortname = "修会"
	credits = "Jesper Kyd - Light of the Imperium"
	musicpath = list('sound/music/combat_holy.ogg')

/datum/combat_music/necra
	name = "Necra 教士"
	desc = ""
	shortname = "Necra"
	credits = "T-87 SULFURHEAD - Formerly Known as Toulouse Lautrec (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_necra.ogg')

/datum/combat_music/nitecreecher
	name = "夜行潜猎者"
	desc = "现在，他们将知道自己为何畏惧黑暗。现在，他们将明白自己为何恐惧夜晚。"
	shortname = "夜行者"
	credits = "Half-Lyfe - Diabolical Adrenaline Horror (https://youtu.be/xZad5J1I-OQ?si=dwlYDOJ8t8A2bdpB)"
	musicpath = list('sound/music/combat_nitecreecher.ogg')

/datum/combat_music/noble
	name = "贵族（商人/Freifechter）"
	desc = ""
	shortname = "贵族"
	musicpath = list('sound/music/combat_noble.ogg')

/datum/combat_music/ozium
	name = "Ozium 滥用（很吵！）"
	desc = "唉，我必须赶紧来上一口。"
	shortname = "Ozium"
	credits = "Light Club - FAHKEET"
	musicpath = list('sound/music/combat_ozium.ogg')

/datum/combat_music/physician
	name = "医师（外科郎中）"
	desc = ""
	shortname = "医师"
	credits = "Pathologic (Classic) - Utroba Aggression"
	musicpath = list('sound/music/combat_physician.ogg')

/datum/combat_music/poacher
	name = "偷猎者败类"
	desc = ""
	shortname = "偷猎者"
	musicpath = list('sound/music/combat_poacher.ogg')

/datum/combat_music/reckoning
	name = "清算（教士，进攻）"
	desc = ""
	shortname = "清算"
	credits = "T-87 SULFURHEAD - The Reckoning (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/church/combat_reckoning.ogg')

/datum/combat_music/routier
	name = "Otavan 路佣兵"
	desc = ""
	shortname = "佣兵"
	musicpath = list('sound/music/combat_routier.ogg')

/datum/combat_music/shaman
	name = "Atgervi 萨满"
	desc = ""
	shortname = "萨满"
	credits = "Heilung - Elddansurin"
	musicpath = list('sound/music/combat_shaman2.ogg')

/datum/combat_music/spymaster
	name = "间谍总管"
	desc = ""
	shortname = "总管"
	credits = "T-87 SULFURHEAD - ABedofMoss (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/nobility/combat_spymaster.ogg')

/datum/combat_music/sorcerer
	name = "邪恶术士"
	desc = "把那群侍从的经费全砍了。"
	shortname = "术士"
	credits = "burialgoods - APAB (All Paladins Are Bastards) (https://www.youtube.com/watch?v=CMyvIDLAub8)"
	musicpath = list('sound/music/cmode/antag/combat_sorcerer.ogg')

/datum/combat_music/squire
	name = "侍从"
	desc = ""
	shortname = "侍从"
	credits = "Dragon's Dogma OST: Tense Combat"
	musicpath = list('sound/music/combat_squire.ogg')

/datum/combat_music/starsugar
	name = "Starsugar 滥用（很吵！）"
	desc = ""
	shortname = "Starsugar"
	credits = "FEMTANYL - DOGMATICA"
	musicpath = list('sound/music/combat_starsugar.ogg')

/datum/combat_music/steppe
	name = "草原人"
	desc = ""
	shortname = "草原"
	credits = "Tatar Theme (Hellish Quart OST)"
	musicpath = list('sound/music/combat_steppe.ogg')

/datum/combat_music/league
	name = "Liga Aavnik"
	desc = "Oni zaplatyat tysyachi za odin dyuym。为了一寸之地，千人赴死。"
	shortname = "Liga"
	credits = "The Heathen - Jan J. Močnik"
	musicpath = list('sound/music/combat_league.ogg')

/datum/combat_music/town_dirt
	name = "城镇杂兵（默认）"
	desc = ""
	shortname = "城镇默认"
	credits = "T-87 SULFURHEAD - Catharsis (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner.ogg')

/datum/combat_music/town_heavyweights
	name = "城镇重装者"
	desc = ""
	shortname = "城镇重装"
	credits = "T-87 SULFURHEAD - Burning Hovel (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner2.ogg')

/datum/combat_music/town_skilled
	name = "城镇熟手"
	desc = ""
	shortname = "城镇熟手"
	credits = "combat_towner3.ogg: T-87 SULFURHEAD - Knowledge & Pain (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_towner3.ogg')

/datum/combat_music/town_leaders
	name = "城镇领袖"
	desc = "旅店老板、公会领袖、村长、普通老兵。"
	shortname = "城镇领袖"
	credits = "T-87 SULFURHEAD - How Sausage is Made (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/towner/combat_retired.ogg')

/datum/combat_music/varangian
	name = "Varangian"
	desc = ""
	shortname = "Varangian"
	credits = "Heilung - Svanrand"
	musicpath = list('sound/music/combat_vagarian.ogg')

/datum/combat_music/vampire
	name = "吸血鬼"
	desc = ""
	shortname = "吸血鬼"
	credits = "T-87 SULFURHEAD - STOLEN SKY (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/cmode/antag/combat_thrall.ogg')

/* Unused
/datum/combat_music/vampire_old
	name = "Vampire (Old)"
	desc = ""
	shortname = "Vampire Old"
	musicpath = list('sound/music/combat_vamp.ogg')
*/

/datum/combat_music/vaquero
	name = "Vaquero"
	desc = ""
	shortname = "Vaquero"
	musicpath = list('sound/music/combat_vaquero.ogg')

/datum/combat_music/veteran
	name = "老兵"
	desc = ""
	shortname = "老兵"
	credits = "T87-Sulfurhead - Good Men Die Young (https://www.youtube.com/@T87-Sulfurhead)"
	musicpath = list('sound/music/combat_veteran.ogg')

/datum/combat_music/vigilante
	name = "义警"
	desc = "多听一耳路上的动静，就能少往坟墓走两步。"
	shortname = "义警"
	credits = "Stoneshard - Track 5 (https://youtu.be/duI4N5MTyKY?si=aHEUbkUzEHSDsIRh)"
	musicpath = list('sound/music/combat_vigilante.ogg')

/datum/combat_music/warscholar
	name = "Naledi 战争学者"
	desc = ""
	shortname = "战争学者"
	credits = "Butcher's Boulevard - Kristjan Thomas Haaristo"
	musicpath = list('sound/music/warscholar.ogg')

/* Unused. I love Filmmaker but this one ain't worth it.
/datum/combat_music/werewolf_old
	name = "Werewolf (Old)"
	desc = ""
	shortname = "Werewolf Old"
	credits = "Filmmaker - Federal Bestiary"
	musicpath = list('sound/music/combat_werewolf.ogg')
*/

/datum/combat_music/zybantine
	name = "Zybantine 奴隶贩子"
	desc = "拥有奴隶的权利，是一个人所能要求的最大自由。"
	shortname = "Zybantine"
	credits = "Hakan Glante - Crusader Kings 3 Fate of Iberia OST - War \"Short\""
	musicpath = list('sound/music/combat_zybantine.ogg')

/datum/combat_music/czwarteki
	name = "Czwarteki 翼骑兵"
	desc = "为了上帝、荣誉与家园。"
	shortname = "Czwarteki"
	credits = " Andrius Klimka & Andrey Kulik - World of Tanks Original Soundtrack: Studzianki "
	musicpath = list('sound/music/combat_czwarteki.ogg')

/datum/combat_music/ancient
	name = "远古勇士"
	desc = "死者将再度行军。以她之名。"
	shortname = "远古"
	credits = "Carlos Viola - Cante de los Muertos"
	musicpath = list('sound/music/combat_ancient.ogg')
