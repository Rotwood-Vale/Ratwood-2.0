// The Lowtown barony: the Baron's own domain, as opposed to the Crown's city.
//
// Each type below takes over the tiles of an ordinary area on the Rockhill map (see the "replaces" note on
// each one). It re-parents onto the type it replaces via parent_type, so everything keyed to the old
// type keeps working unchanged: istype() checks, sounds, ambush and threat regions, quest lookups.
// Barony membership is the barony_area var, not the type path, for the same reason.
//
// The Lowtown church is deliberately left out; it stays under the Crown's/church's areas.

/// Replaces the generic /area/rogue/indoors tiles of the Baron's manor.
/area/rogue/indoors/town/barony/manor
	parent_type = /area/rogue/indoors
	name = "Lowtown Manor"
	first_time_text = "THE LOWTOWN MANOR"
	barony_area = TRUE
	deathsight_message = "a modest manor of the outer duchy, seat of the lowtown baron"

/// Replaces /area/rogue/under/town/basement under the Baron's manor.
/area/rogue/under/town/barony/manor
	parent_type = /area/rogue/under/town/basement
	name = "Lowtown Manor cellar"
	barony_area = TRUE
	deathsight_message = "the cellars beneath the lowtown baron's manor"

/// Replaces /area/rogue/indoors/town/warden.
/area/rogue/indoors/town/barony/warden
	parent_type = /area/rogue/indoors/town/warden
	barony_area = TRUE

/// Replaces /area/rogue/indoors/town/cell/warden.
/area/rogue/indoors/town/barony/cell/warden
	parent_type = /area/rogue/indoors/town/cell/warden
	converted_type = /area/rogue/indoors/town/barony/warden
	barony_area = TRUE

/// Replaces /area/rogue/indoors/town/physician (the lowtown clinic).
/area/rogue/indoors/town/barony/physician
	parent_type = /area/rogue/indoors/town/physician
	barony_area = TRUE

/// Replaces /area/rogue/outdoors/rtfield/rockhill (the basin outside the walls).
/area/rogue/outdoors/rtfield/barony/rockhill
	parent_type = /area/rogue/outdoors/rtfield/rockhill
	barony_area = TRUE

/// Replaces /area/rogue/outdoors/rtfield/rockhill/above (the open air and rooftops over the basin).
/area/rogue/outdoors/rtfield/barony/rockhill/above
	parent_type = /area/rogue/outdoors/rtfield/rockhill/above
	barony_area = TRUE
