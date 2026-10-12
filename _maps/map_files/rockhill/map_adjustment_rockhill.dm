/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Rockhill"
	blacklist = list(//I had wanted the map variable in the roles themselves to bar them from non-desert maps but it still shows up in the Latejoin menu so I'm doing this just to keep it clear)
		/datum/job/roguetown/cataphract,
		// /datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		// /datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/dtchaplain,
		
		/datum/job/roguetown/tribalchieftain,
		/datum/job/roguetown/tribalshaman,
		/datum/job/roguetown/tribalguard,
		/datum/job/roguetown/tribalrabble,
		/datum/job/roguetown/tribalvillager,
		)
	slot_adjust = list(
		/datum/job/roguetown/manorguard = 4,//split with watchmen
		/datum/job/roguetown/warden = 4,//split with vanguard
		/datum/job/roguetown/adventurer/courtslave = 2,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Duke", f_title = "Duchess"),
		/datum/job/roguetown/physician = list(display_title = "Court Physician"),
		/datum/job/roguetown/niteman = list(display_title = "Nightmaster", f_title = "Nightmistress"),
		/datum/job/roguetown/nightmaiden = list(display_title = "Nightswain", f_title = "Nightmaiden"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/lord = "Elevated upon your throne through a web of intrigue and political upheaval, you are the absolute authority of these lands and at the center of every plot within it. \
				Every man, woman and child is envious of your position and would replace you in less than a heartbeat: Show them the error of their ways. \
				The Crown took a heavy toll upon your lyfe-force, and you will not be able to be revived if you perish. \
				South of the walls the Baron of Lowtown holds his barony by his own oath to you. Your Hand, Marshal and Knight Captain have no command there: the Baron answers to you alone.",
		/datum/job/roguetown/hand = "Whether by outstanding merit or petty favoritism, you are the Archduke's most trusted representative and advisor. Your authority is second only to the Archduke themselves. \
				The weight of your words can shape policy, stir conflict, or silence dissent. Let none forget whose will you carry, and do not fail your benefactor. \
				Your authority ends at the walls: the Baron of Lowtown holds his barony by his own oath to the Duke, and neither you, the Marshal nor the Knight Captain may command him, his garrison or his lands.",
		/datum/job/roguetown/baron = "Through birthright, favors or intrigue you have landed yourself in the position of being the baron of the outer reaches of the duchy. \
				You swore fealty to the duke alone: the Hand, the Marshal and the Knight Captain hold no command over you, your garrison or your lands. \
				You run lowtown as you see fit and hold sway in its dealings, and the lowtown garrison answers to you. Upon the Duke's request the crown can call upon your men to join its greater army.",
		/datum/job/roguetown/vanguard = "Either a fresh lowborn recruit with something to prove or paying off your crimes with a mandated tour of duty, you have been assigned under the lowtown baron. \
				You have a roof over your head, meagre coin in your pocket, and a thankless job protecting the outskirts of town against what lurks beyond. \
				You are subordinate to the baron, but often are led by the master warden or the retainer, and may be called upon by the Crown, through the baron, to serve in the greater army. \
				Protect lowtown's interests and be the first line of defence from threats beyond the borders of civilisation, hold the vanguard bastion, and try to survive another day. Maybe you'll make it into the Wardens some day.",
		/datum/job/roguetown/captain = "Your lineage is noble, and generations of strong, loyal knights and men-at-arms have come before you. You served your time \
				gracefully as knight of his royal majesty, and now you've grown into a role which many men can only dream of becoming. \
				Veteran among knights, you lead the crown's knights and loyal men at arms into battle and organize the training squires. Obey only the Marshal and Crown. \
				Lead your men to victory--and keep them in line--and you will see this realm prosper under a thousand suns. \
				The Lowtown barony is beyond your command: its baron, his garrison and his lands answer to the Duke alone.",
		/datum/job/roguetown/physician = "You are a master physician, trusted by the Duke themself to administer expert care to the Royal family, the court, \
			its protectors and its subjects. While primarily a resident of the keep in the manors medical wing, you also have access \
			to the local hightown clinic, where lesser licensed apothecaries ply their trade under your occasional passing tutelage.",
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
		/datum/job/roguetown/warden = "Having proven yourself through years of scouting, skirmishing and survival in the vanguard, you have been initiated into the Wardens - an elite fraternity of ranger types who keep a vigil over the untamed wilderness. Trusted to venture deep into the uncivilised darkness south of lowtown, you act as a scout, soldier, sentinel and guide, performing long-range reconnaissance, culling dangerous wildlife, and protecting lowtown alongside the vanguard. You are subordinate to the Master Warden, whom in turn serves the baron and may be called upon by the Crown, through the baron, to serve in the greater army. Serve the baron's will as the first line of defence from threats beyond the borders of civilisation, keep the roads safe, and hold the vanguard fortress. The Crown is counting on you.",
		/datum/job/roguetown/manorguard = "Having proven yourself loyal and capable, you are entrusted to defend the keep and enforce its will throughout the city and duchy. \
				Trained regularly in combat and siege warfare, you deal with threats - both within and without. \
				Obey your Marshal, Knight-captain and the Crown. Show the nobles and knights your respect, so that you may earn it in turn. Not as a commoner, but as a soldier..",
		/datum/job/roguetown/marshal = "You are an agent of the crown in matters of law and military, making sure that laws are pushed, verified and carried out by the retinue upon the citizenry of the realm. \
				As the ultimate authority on all things military, much of your work happens behind a desk, deferring duties between the Knight Captain and Watch Captain and acting as the primary \
				go-between to ensure the will of the duke, through you, is carried out in the field. \
				Lowtown is beyond your reach: the baron, his garrison and his lands answer to the Duke alone, and only the Duke may call on them.",
		/datum/job/roguetown/rookie = "Odd-jobs, running messages, fixing dents and talking to locals; the City Watch can always use a spare pair of hands, eyes and ears. Assist your fellow city watchmen in dealing with threats - both within and without. \
				Given a brief introduction in weapons and guardwork, the rest of your training is to be picked up on the job. \
				Obey your superiors (everyone who isn't you) and show the nobles your respect. Keep an eye out, try to learn a thing or two, then one day you might live to make an adequate soldier."
	
	)
	// species_adjust = list()
	// sexes_adjust = list()
	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_ROCKHILL_BASIN,
		THREAT_REGION_ROCKHILL_BOG_NORTH,
		THREAT_REGION_ROCKHILL_BOG_WEST,
		THREAT_REGION_ROCKHILL_BOG_SOUTH,
		THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		THREAT_REGION_ROCKHILL_WOODS_NORTH,
		THREAT_REGION_ROCKHILL_WOODS_SOUTH
	)
	// The realm is Rockhill here, so the Rockhill trade county becomes Vespermill, its
	// noble seat. Same region_id and goods; only the identity changes.
	trade_region_swaps = list(
		TRADE_REGION_ROCKHILL = /datum/economic_region/vespermill,
	)
	// Towner postings: the caravan runs the wooded roads (highwaymen in the faction
	// tables), the miner's lead strikes the deep bogs. Both target regions carry hard
	// spawners and allow the towner types.
	towner_quest_regions = list(
		QUEST_TOWNER_SMITH_CARAVAN = list(THREAT_REGION_ROCKHILL_WOODS_NORTH, THREAT_REGION_ROCKHILL_WOODS_SOUTH),
		QUEST_TOWNER_MINER_OREVEIN = list(THREAT_REGION_ROCKHILL_BOG_SUNKMIRE, THREAT_REGION_ROCKHILL_BOG_WEST),
	)
	// Blockade routes. Tiers mirror dun_world's: grove-tier roads (no travel fee)
	// through the woods, coast-tier (75) through the outer bogs, mountain-tier (150)
	// through Sunkmire. Every target region carries hard quest spawners - a road
	// mapped to a region without one can never host its defense.
	blockade_route_map = list(
		TRADE_REGION_KINGSFIELD = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_ROSAWOOD = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_BLACKHOLT = THREAT_REGION_ROCKHILL_WOODS_SOUTH,
		TRADE_REGION_HEARTFELT = THREAT_REGION_ROCKHILL_WOODS_NORTH,
		TRADE_REGION_ROCKHILL = THREAT_REGION_ROCKHILL_BOG_NORTH,
		TRADE_REGION_SALTWICK = THREAT_REGION_ROCKHILL_BOG_WEST,
		TRADE_REGION_BLEAKCOAST = THREAT_REGION_ROCKHILL_BOG_SOUTH,
		TRADE_REGION_NORTHFORT = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_HAGENWALD = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		TRADE_REGION_DAFTSMARCH = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
	)
d
