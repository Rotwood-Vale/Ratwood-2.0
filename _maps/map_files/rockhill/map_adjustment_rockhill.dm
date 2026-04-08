/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Rockhill"
	blacklist = list(
		/datum/job/roguetown/sergeant,
		)
	slot_adjust = list(
		/datum/job/roguetown/manorguard = 4,//split with watchmen
		/datum/job/roguetown/warden = 4,//split with vanguard
	)
	title_adjust = list(
		/datum/job/roguetown/physician = list(display_title = "Court Physician"),
		/datum/job/roguetown/niteman = list(display_title = "Nightmaster", f_title = "Nightmistress"),
		/datum/job/roguetown/nightmaiden = list(display_title = "Nightswain", f_title = "Nightmaiden"),
		// /datum/job/roguetown/marshal = list(display_title = "Mayor"),
	)
	tutorial_adjust = list(
		/datum/job/roguetown/captain = "Your lineage is noble, and generations of strong, loyal knights and men-at-arms have come before you. You served your time \
				gracefully as knight of his royal majesty, and now you've grown into a role which many men can only dream of becoming. \
				Veteran among knights, you lead the crown's knights and loyal men at arms into battle and organize the training squires. Obey only the Marshal and Crown. \
				Lead your men to victory--and keep them in line--and you will see this realm prosper under a thousand suns.",
		/datum/job/roguetown/physician = "You are a master physician, trusted by the Duke themself to administer expert care to the Royal family, the court, \
			its protectors and its subjects. While primarily a resident of the keep in the manors medical wing, you also have access \
			to the local hightown clinic, where lesser licensed apothecaries ply their trade under your occasional passing tutelage.",
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
		/datum/job/roguetown/warden = "Having proven yourself through years of scouting, skirmishing and survival in the vanguard, you have been initiated into the Wardens - an elite fraternity of ranger types who keep a vigil over the untamed wilderness. \
				Trusted to venture deep into the uncivilised darkness south of lowtown, you act as a scout, soldier, sentinel and guide, performing long-range reconnaissance, culling dangerous wildlife, and protecting lowtown alongside the vanguard. \
				You are subordinate to the Master Warden, and may be called upon as members of the garrison by the Marshal and Crown.\
				Serve their will as the first line of defence from threats beyond the borders of civilisation, keep the roads safe, and hold the vanguard fortress. The Crown is counting on you.",
		/datum/job/roguetown/manorguard = "Having proven yourself loyal and capable, you are entrusted to defend the keep and enforce its will throughout the city and duchy. \
				Trained regularly in combat and siege warfare, you deal with threats - both within and without. \
				Obey your Marshal, Knight-captain and the Crown. Show the nobles and knights your respect, so that you may earn it in turn. Not as a commoner, but as a soldier..",
		/datum/job/roguetown/marshal = "You are an agent of the crown in matters of law and military, making sure that laws are pushed, verified and carried out by the retinue upon the citizenry of the realm. \
				As the ultimate authority on all things military, much of your work happens behind a desk, deferring duties between the Knight Captain, Watch Captain and Master Warden and acting as the primary \
				go-between to ensure the will of the duke, through you, is carried out in the field.",
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
d
