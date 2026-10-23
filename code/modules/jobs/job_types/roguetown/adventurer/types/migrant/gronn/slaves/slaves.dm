/datum/advclass/gronn/slave
	name = ""
	category_tags = list()
	subclass_languages = list(/datum/language/gronnic)

//Captives are locals, not tribe, so the six gronnic gods off the parent outfit get cleared here. They keep whatever they walked in with.
/datum/outfit/job/roguetown/gronn/slave
	allowed_patrons = null

// Everything the tribe dragged back with it. The migrant role itself is over in gronn_roles.dm, this lot just rolls out of CTAG_GRONN_SLAVE.
// One class to a file, because seven of them stacked in one place was a nightmare to read.
