/datum/advclass/hammerhold/thrall
	name = ""
	category_tags = list()
	subclass_languages = list(/datum/language/hammerholdian)

//Thralls arent required to be Abyssorite like the rest of the warband, so the Abyssor lock off the parent outfit gets cleared here.
/datum/outfit/job/roguetown/hammerhold/thrall
	allowed_patrons = null

// Everything the warband dragged back with it. The migrant role itself is over in hammerhold_roles.dm, this lot just rolls out of CTAG_HAMMERHOLD_THRALL.
// One class to a file, because seven of them stacked in one place was a nightmare to read.
