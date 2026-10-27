/datum/mob_descriptor/trait
	abstract_type = /datum/mob_descriptor/trait
	slot = MOB_DESCRIPTOR_SLOT_TRAIT
	verbage = "%ARE%"

/datum/mob_descriptor/trait/moderate
	name = "Moderate"
	prefix = "very"

/datum/mob_descriptor/trait/mundane
	name = "Mundane"
	prefix = "very"

/datum/mob_descriptor/trait/middling
	name = "Middling"
	prefix = "very"

/datum/mob_descriptor/trait/tall
	name = "Tall"
	prefix = "very"

/datum/mob_descriptor/trait/short
	name = "Short"
	prefix = "very"

/datum/mob_descriptor/trait/dainty
	name = "Dainty"
	prefix = "very"

/datum/mob_descriptor/trait/towering
	name = "Towering"
	prefix = "very"

/datum/mob_descriptor/trait/giant
	name = "Giant"
	prefix = "a"

/datum/mob_descriptor/trait/tiny
	name = "Tiny"
	prefix = "very"

/datum/mob_descriptor/trait/stout
	name = "Stout"
	prefix = "very"

/datum/mob_descriptor/trait/cadaverous
	name = "Cadaverous"
	prefix = "very"

/datum/mob_descriptor/trait/lanky
	name = "Lanky"
	prefix = "very"

/datum/mob_descriptor/trait/wide
	name = "Wide"
	prefix = "very"

/datum/mob_descriptor/trait/thin
	name = "Thin"
	prefix = "very"

/datum/mob_descriptor/trait/zardish
	name = "Zardish"
	prefix = "very"


/datum/mob_descriptor/trait/lupian
	name = "Lupian"
	prefix = "very"

/datum/mob_descriptor/trait/venardic
	name = "Venardic"
	prefix = "very"


/datum/mob_descriptor/trait/feline
	name = "Feline"
	prefix = "very"

/datum/mob_descriptor/trait/elven
	name = "Elven"
	prefix = "very"

/datum/mob_descriptor/trait/rousley
	name = "Rousley"
	prefix = "very"

/datum/mob_descriptor/trait/pale
	name = "Pale"
	prefix = "very"

/datum/mob_descriptor/trait/tanned
	name = "Tanned"
	prefix = "very"

/datum/mob_descriptor/trait/dusky
	name = "Dusky"
	prefix = "very"

/datum/mob_descriptor/trait/blessed
	name = "Blessed"
	prefix = "very"

/datum/mob_descriptor/trait/accursed
	name = "Accursed"
	prefix = "a"

/datum/mob_descriptor/trait/aquatic
	name = "Aquatic"
	prefix = "very"

/datum/mob_descriptor/trait/volfish
	name = "Volfish"
	prefix = "very"

/datum/mob_descriptor/trait/graceful
	name = "Graceful"
	prefix = "very"

/datum/mob_descriptor/trait/lapine
	name = "Lapine"
	prefix = "very"

/datum/mob_descriptor/trait/scrappy
	name = "Scrappy"
	prefix = "very"

/datum/mob_descriptor/trait/curious
	name = "Curious"
	prefix = "very"

/datum/mob_descriptor/trait/craven
	name = "Craven"
	prefix = "very"

/datum/mob_descriptor/trait/grinning
	name = "Grinning"
	prefix = "very"

/datum/mob_descriptor/trait/crestfallen
	name = "Crestfallen"
	prefix = "very"

/datum/mob_descriptor/trait/dour
	name = "Dour"
	prefix = "very"

/datum/mob_descriptor/trait/cheery
	name = "Cheery"
	prefix = "very"

/datum/mob_descriptor/trait/simian
	name = "Simian"
	prefix = "very"

/datum/mob_descriptor/trait/bovine
	name = "Bovine"
	prefix = "very"

/datum/mob_descriptor/trait/cervine
	name = "Cervine"
	prefix = "very"

/datum/mob_descriptor/trait/ursine
	name = "Ursine"
	prefix = "very"

/datum/mob_descriptor/trait/stern
	name = "Stern"
	prefix = "very"

/datum/mob_descriptor/trait/jaunty
	name = "Jaunty"
	prefix = "very"

/datum/mob_descriptor/trait/meek
	name = "Meek"
	prefix = "very"

/datum/mob_descriptor/trait/sly
	name = "Sly"
	prefix = "very"

/datum/mob_descriptor/trait/fervent
	name = "Fervent"
	prefix = "very"

/datum/mob_descriptor/trait/coy
	name = "Coy"
	prefix = "very"

/datum/mob_descriptor/trait/harrowed
	name = "Harrowed"
	prefix = "very"

/datum/mob_descriptor/trait/horned
	name = "Horned"
	prefix = "very"

/datum/mob_descriptor/trait/snoutly
	name = "Snoutly"
	prefix = "very"

/datum/mob_descriptor/trait/tailed
	name = "Tailed"
	prefix = "very"

/datum/mob_descriptor/trait/fanged
	name = "Fanged"
	prefix = "very"

/datum/mob_descriptor/trait/tusked
	name = "Tusked"
	prefix = "very"

/datum/mob_descriptor/trait/clawed
	name = "Clawed"
	prefix = "very"

/datum/mob_descriptor/trait/furred
	name = "Furred"
	prefix = "very"

/datum/mob_descriptor/trait/feathered
	name = "Feathered"
	prefix = "very"

/datum/mob_descriptor/trait/scaly
	name = "Scaly"
	prefix = "very"

/datum/mob_descriptor/trait/crimson
	name = "Crimson"
	prefix = "very"

/datum/mob_descriptor/trait/cerulean
	name = "Cerulean"
	prefix = "very"

/datum/mob_descriptor/trait/emerald
	name = "Emerald"
	prefix = "very"

/datum/mob_descriptor/trait/amber
	name = "Amber"
	prefix = "very"

/datum/mob_descriptor/trait/custom
	name = "Custom Trait"
	custom_index = 5

/datum/mob_descriptor/trait/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/trait/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text
