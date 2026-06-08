// Any areas that are part of the town
//////
/////
////     TOWN AREAS
////
///
//

/area/rogue/outdoors/town
	name = "outdoors"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/town
	first_time_text = "THE CITY OF ROTWOOD VALE"
	town_area = TRUE
	warden_area = FALSE
	deathsight_message = "the city of Rotwood Vale and all its bustling souls"

/area/rogue/outdoors/town/graveyard
	name = "town graveyard"
	icon_state = "church"
	first_time_text = "The Garden of the Dead"
	holy_area = TRUE
	warden_area = TRUE//eh why not it's got grass I guess
	deathsight_message = "a hallowed place of eternal rest"

/area/rogue/outdoors/town/rockhill
	name = "outdoors rockhill"
	first_time_text = "The Town of Rockhill"
	deathsight_message = "the city of Rockhill and all its bustling souls"

/area/rogue/outdoors/town/church
	name = "outdoors church district"
	first_time_text = "Old Church District"
	deathsight_message = "sanctified ruins near the bustling city"
	// holy_area = TRUE //ravox decrees it most honorable to not benefit from you +2 to everything buffs while duelling in the duel pit

/area/rogue/indoors/shelter/town
	icon_state = "town"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	town_area = TRUE

/area/rogue/indoors/town
	name = "indoors"
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/exposed/town
	town_area = TRUE
	deathsight_message = "the city of Rotwood vale and all its bustling souls, behind closed doors"
	detail_text = DETAIL_TEXT_AZURE_PEAK

/area/rogue/outdoors/exposed/town
	icon_state = "town"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	town_area = TRUE

/area/rogue/outdoors/exposed/town/keep
	name = "Keep"
	icon_state = "manor"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	keep_area = TRUE
	town_area = TRUE
	detail_text = DETAIL_TEXT_KEEP

/area/rogue/outdoors/exposed/town/keep/unbuildable
	name = "Keep unbuildable"

/area/rogue/outdoors/exposed/town/keep/unbuildable/can_craft_here()
	return FALSE

/area/rogue/indoors/town/manor
	name = "Manor"
	icon_state = "manor"
	droning_sound = list('sound/music/area/manor.ogg', 'sound/music/area/manor2.ogg')
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	first_time_text = "THE KEEP OF ROTWOOD VALE"
	keep_area = TRUE
	detail_text = DETAIL_TEXT_MANOR
	deathsight_message = "sequestered behind royal doors, amidst fine carpets and power"

/area/rogue/outdoors/exposed/manorgarri
	icon_state = "manorgarri"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE

/area/rogue/indoors/town/manor/rockhill
	first_time_text = "Rockhill Keep"

/area/rogue/outdoors/town/roofs
	name = "roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/town/roofs
	first_time_text = null
	deathsight_message = "the roofs of the bustling city"

/area/rogue/outdoors/town/roofs/keep
	name = "keep rooftops"
	icon_state = "manor"
	keep_area = TRUE

/area/rogue/outdoors/town/roofs/church
	name = "church rooftops"
	holy_area = TRUE

/area/rogue/outdoors/town/roofs/warden
	name = "warden rooftops"
	warden_area = TRUE

/area/rogue/outdoors/town/roofs/tavern
	name = "tavern rooftops"
	tavern_area = TRUE

/area/rogue/indoors/shelter/town/roofs
	icon_state = "roofs"

/area/rogue/indoors/town/magician
	name = "University of The Vale"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "THE UNIVERSITY OF THE VALE"
	converted_type = /area/rogue/outdoors/exposed/magiciantower
	keep_area = TRUE
	// detail_text = DETAIL_TEXT_UNIVERSITY_OF_ROTWOOD
	
/area/rogue/indoors/town/magician/arcynefortress
	name = "arcyne fortress"
	first_time_text = "Arcyne Fortress"

/area/rogue/indoors/town/magician/rockhill
	name = "Wizard's Tower"
	first_time_text = "Tower of the Magos"
	// detail_text = DETAIL_TEXT_WIZARD_TOWER

/area/rogue/outdoors/exposed/magiciantower
	icon_state = "magiciantower"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE
	// detail_text = DETAIL_TEXT_UNIVERSITY_OF_ROTWOOD

/area/rogue/indoors/town/shop
	name = "Shop"
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/shop
	deathsight_message = "amgonst expensive wares and zenarii"

/area/rogue/outdoors/exposed/shop
	icon_state = "shop"
	droning_sound = 'sound/music/area/shop.ogg'

/area/rogue/indoors/town/steward
	name = "Steward"
	icon_state = "steward"
	droning_sound = 'sound/music/area/shop.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/physician
	name = "Physician"
	icon_state = "physician"
	droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a structure of pained wails and practiced surgeons"

/area/rogue/indoors/town/academy
	name = "Academy"
	icon_state = "academy"
	droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "the rustle of heavy books"

/area/rogue/indoors/town/bath
	name = "Baths"
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/bath
	deathsight_message = "a den of lust and secrets"

// /area/rogue/indoors/town/bath/vault
// 	name = "Bathmaster vault"
// 	icon_state = "bathvault"

/area/rogue/outdoors/exposed/bath
	icon_state = "bath"
	droning_sound = 'sound/music/area/bath.ogg'

/area/rogue/outdoors/exposed/bath/vault//Note that this DOESN'T WORK!! The mechanic is actually keyed to the particular type of floor-tile instead of area tile. Weird, I know. Also there's no reason for it to be Exposed, no idea why that's been the case.
	name = "Bathmaster vault"
	icon_state = "bathvault"
	ceiling_protected = TRUE

/area/rogue/indoors/town/garrison
	name = "Garrison"
	icon_state = "garrison"
	droning_sound = 'sound/music/area/manorgarri.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/manorgarri
	keep_area = TRUE
	deathsight_message = "a rattle of chains and crackles of stunmaces"

/area/rogue/indoors/town/cell
	name = "dungeon cell"
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
	deathsight_message = "cells of pain and suffering"

/area/rogue/dietroyt //dungeon labor camp
	name = "dungeoneer's labor camp"
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
	deathsight_message = "the drone of pickaxes and penance"
	first_time_text = "LABOR CAMP"
	detail_text = DETAIL_TEXT_DIETROYT

/area/rogue/dietroyt/nomagic
	noteleport = TRUE

/area/rogue/indoors/town/tavern
	name = "tavern"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/tavern
	tavern_area = TRUE
	deathsight_message = "pungent alcohol and weary travelers"

/area/rogue/outdoors/exposed/tavern
	icon_state = "tavern"
	// droning_sound = 'sound/silence.ogg'//it should only be silent because of the jukeboxes, no jukeboxes outside
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/under/town/basement/tavern
	name = "tavern basement"
	icon_state = "basement"
	tavern_area = TRUE
	town_area = TRUE
	ceiling_protected = TRUE
	deathsight_message = "a musty cellar of aging ales, beneath rumours and revelry"

/area/rogue/indoors/town/church
	name = "church"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	holy_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/outdoors/exposed/church
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	deathsight_message = "a hallowed place, sworn to the Ten"

/area/rogue/indoors/town/church/chapel
	icon_state = "chapel"
	first_time_text = "THE HOUSE OF THE TEN"
	detail_text = DETAIL_TEXT_CHAPEL

/area/rogue/indoors/town/church/basement
	icon_state = "church"
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/church/basement/crypt
	first_time_text = "THE CRYPT OF THE TEN"

/area/rogue/indoors/town/warehouse
	name = "warehouse import"
	icon_state = "warehouse"
	deathsight_message = "musty crates and cheap imports"

/area/rogue/indoors/town/warehouse/harbor
	droning_sound = 'sound/music/area/harbor.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT
	deathsight_message = "musty crates and cheap imports, a salty sea-tang on the air"

/area/rogue/indoors/town/warehouse/can_craft_here()
	return FALSE

/area/rogue/indoors/town/warden
	name = "warden fort"
	warden_area = TRUE
	deathsight_message = "a moss covered stone redoubt, guarding against the wilds"

/area/rogue/indoors/town/cell/warden
	converted_type = /area/rogue/indoors/town/warden
	town_area = FALSE
	warden_area = TRUE
	deathsight_message = "makeshift cells of pain and suffering at the border of the wilds"

/area/rogue/indoors/inq
	name = "The Inquisition"
	icon_state = "chapel"
	first_time_text = "THE OTAVAN INQUISITION"
	// detail_text = DETAIL_TEXT_INQUISITION_HQ

/area/rogue/indoors/inq/office
	name = "The Inquisitor's Office"
	icon_state = "chapel"

/area/rogue/indoors/inq/basement
	name = "The Inquisition's Basement"
	icon_state = "chapel"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/inq/import
	name = "foreign imports"
	icon_state = "warehouse"

/area/rogue/indoors/inq/import/can_craft_here()
	return FALSE

/area/rogue/indoors/town/vault
	name = "vault"
	icon_state = "vault"
	keep_area = TRUE
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/entrance
	first_time_text = "Roguetown"
	icon_state = "entrance"

/area/rogue/indoors/town/dwarfin
	name = "The Guild of Craft"
	icon_state = "dwarfin"
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "VALE GUILD OF CRAFTS"
	converted_type = /area/rogue/outdoors/exposed/dwarf
	detail_text = DETAIL_TEXT_AZUREAN_GUILD_OF_CRAFT

/area/rogue/indoors/town/dwarfin/rockhill
	first_time_text = "Rockhill Guild of Crafts"

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
