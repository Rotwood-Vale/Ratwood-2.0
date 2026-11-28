/*
* The familytree subsystem is supposed to be a way to
* assist RP by setting people up as related roundstart.
* This relation can be based on role (IE king and prince
* being father and son) or random chance.
*
* Updated to work with the new multi-generational heritage system
* Fixed to properly handle string age constants
*/

SUBSYSTEM_DEF(familytree)
	name = "familytree"
	flags = SS_NO_FIRE
	lazy_load = FALSE

	/*
	* The family that kings, queens, and princes
	* are automatically placed into. Has no other
	* real function.
	*/
	var/datum/heritage/ruling_family
	/*
	* The other major houses of Rockhill.
	* Id say think Shrouded Isle families but
	* smaller.
	*/
	var/list/families = list()
	/*
	* Bachalors and Bachalorettes
	*/
	var/list/viable_spouses = list()
	// shit for da relationship board
	var/board_path = "data/family_board.json"
	var/list/board = list()
	var/list/saved_ads = list()
	var/list/requests = list()
	var/list/links = list()
	var/list/blocks = list()
	var/list/connected = list()
	// random string
	var/salt = ""
	var/list/relation_options = list("Spouse", "Sibling", "Parent", "Offspring", "Lover", "Cousin")
	// easiest way to tell whose older than who
	var/list/age_order = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	var/list/royal_jobs = list("Grand Duke", "Grand Duchess", "Consort", "Prince", "Princess")
	//These jobs are excluded from AddLocal()
	var/list/excluded_jobs = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Suitor",
		"Hand",
		"Prince",
		"Bandit",
		"Absolver",
		"Orthodoxist",
		"Inquisitor",
		)
	var/list/nomarry_jobs = list(
		"Nightswain",
		"Churchling",
		"Acolyte",
		"Templar",
		"Martyr",
		"Priest",
		)
	//This creates 2 families for each race roundstart so that siblings dont fail to be added to a family.
	var/list/preset_family_species = list(
		/datum/species/human/northern,
		/datum/species/elf,
		/datum/species/elf/dark,
		/datum/species/human/halfelf,
		/datum/species/dwarf/mountain,
		/datum/species/tieberian,
		/datum/species/aasimar,
		/datum/species/halforc
		)

/datum/controller/subsystem/familytree/Initialize()
	ruling_family = new /datum/heritage(null, "Royal", /datum/species/human/northern)
	//Blank starter families that we can customize for players.
	for(var/pioneer_household in preset_family_species)
		for(var/I = 1 to 2)
			families += new /datum/heritage(null, null, pioneer_household)

	salt = md5("[world.realtime][rand()]")
	// relationship links save between rounds! kinda 50/50 on this
	if(fexists(board_path))
		var/list/saved = json_decode(file2text(board_path))
		if(saved)
			links = saved["links"] || list()
			blocks = saved["blocks"] || list()
			saved_ads = saved["ads"] || list()
			for(var/client/C in GLOB.clients)
				RestoreAd(C.prefs)

	return ..()

/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H)
	if(!H || istype(H, /mob/living/carbon/human/dummy))
		return
	if(H.stat == DEAD || !H.client)
		return
	var/royal_status
	switch(H.job)
		if("Grand Duke", "Grand Duchess")
			royal_status = FAMILY_FATHER
		if("Consort")
			royal_status = FAMILY_MOTHER
		if("Prince", "Princess")
			royal_status = FAMILY_PROGENY
	if(royal_status)
		if(royal_status != FAMILY_FATHER && !GetCurrentMonarch())
			return
		AddRoyal(H, royal_status)
		return
	LinkSpawn(H)
	if(!H.random_match.len)
		return
	//Exclude princes and princesses from having their parentage calculated.
	if(H.mind?.assigned_role in excluded_jobs)
		return
	AssignRandom(H)

/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(!ruling_family.housename)
		ruling_family.housename = " Royal"
	var/datum/family_member/member = ruling_family.CreateFamilyMember(H)
	if(!member)
		return

	// If this is the first royal, generate a historical lineage
	if(!ruling_family.founder)
		GenerateRoyalLineage(member, status)
		for(var/mob/living/carbon/human/waiting in GLOB.human_list)
			if(waiting != H && !waiting.family_datum && (waiting.job in royal_jobs))
				AddLocal(waiting)
		return

	// Handle adding new royals to existing family
	switch(status)
		if(FAMILY_FATHER, FAMILY_MOTHER)
			// If there's already a monarch, make them spouses
			var/datum/family_member/existing_monarch = GetCurrentMonarch()
			member.generation = 12
			if(existing_monarch)
				ruling_family.MarryMembers(existing_monarch, member)
				for(var/datum/family_member/kid in existing_monarch.children)
					kid.AddParent(member)
					kid.UpdateAdoption()

		if(FAMILY_PROGENY)  // Prince/Princess
			// Children of the current monarch
			var/datum/family_member/monarch = GetCurrentMonarch()
			if(monarch)
				member.generation = monarch.generation + 1
				member.AddParent(monarch)
				// Add other parent if monarch has spouse
				if(monarch.spouses.len)
					member.AddParent(monarch.spouses[1])
				member.UpdateAdoption()

		if(FAMILY_OMMER)  // Hand - sibling or cousin of monarch
			CreateBranchFamily(member)

/datum/controller/subsystem/familytree/proc/GetCurrentMonarch()
	// Find the monarch at generation 12 (current ruling generation)
	for(var/datum/family_member/member in ruling_family.members)
		if(member.generation == 12 && (member.person?.job == "Grand Duke" || member.person?.job == "Grand Duchess"))
			return member
	return null

/datum/controller/subsystem/familytree/proc/CreateBranchFamily(datum/family_member/hand_member)
	var/datum/family_member/monarch = GetCurrentMonarch()
	if(!monarch)
		return

	hand_member.generation = monarch.generation

	// Make the hand a sibling of the monarch (so uncle/aunt to any princes/princesses)
	if(monarch.parents.len)
		var/datum/family_member/monarch_parent = monarch.parents[1]
		var/datum/family_member/monarch_parent_second = monarch.parents.len >= 2 ? monarch.parents[2] : null
		if(monarch_parent)
			hand_member.AddParent(monarch_parent)
		if(monarch_parent_second)
			hand_member.AddParent(monarch_parent_second)

		// Create a spouse for the hand
		var/mob/living/carbon/human/dummy/spouse = new()
		spouse.age = hand_member.person.age
		spouse.gender = hand_member.person.pronouns == HE_HIM ? FEMALE : MALE
		spouse.real_name = GenerateRoyalName(spouse.gender, hand_member.generation)
		var/datum/family_member/hand_spouse = ruling_family.CreateFamilyMember(spouse)
		hand_spouse.generation = hand_member.generation
		ruling_family.MarryMembers(hand_member, hand_spouse)

/datum/controller/subsystem/familytree/proc/GenerateRoyalLineage(datum/family_member/current_royal, status)
	// Set as current generation
	ruling_family.founder = current_royal
	current_royal.generation = 12  // Start at generation 12 to leave room for ancestors

	// Update ruling family's species based on first member
	ruling_family.dominant_species = current_royal.person.dna.species.type

	// Generate ancestors
	var/datum/family_member/current_ancestor = current_royal
	var/list/age_progression = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_OLD)

	for(var/i = current_royal.generation - 1; i >= 6; i--)  // Generate 6 generations of ancestors
		// Create parent
		var/mob/living/carbon/human/dummy/ancestor = new()
		ancestor.age = age_progression[min(current_royal.generation - i, age_progression.len)]
		ancestor.gender = prob(50) ? MALE : FEMALE
		ancestor.real_name = GenerateRoyalName(ancestor.gender, i)
		set_species_type(ancestor, ruling_family.dominant_species)
		var/datum/family_member/parent = ruling_family.CreateFamilyMember(ancestor)
		parent.generation = i

		// Create spouse for parent
		var/mob/living/carbon/human/dummy/spouse = new()
		spouse.age = ancestor.age
		spouse.gender = ancestor.gender == MALE ? FEMALE : MALE
		spouse.real_name = GenerateRoyalName(spouse.gender, i)
		set_species_type(spouse, ruling_family.dominant_species)
		var/datum/family_member/parent_spouse = ruling_family.CreateFamilyMember(spouse)
		parent_spouse.generation = i

		// Connect family members
		ruling_family.MarryMembers(parent, parent_spouse)
		current_ancestor.AddParent(parent)
		current_ancestor.AddParent(parent_spouse)

		// Add 0-1 siblings with 30% chance (for branch families later)
		if(prob(30))
			var/mob/living/carbon/human/dummy/sibling = new()
			sibling.age = ancestor.age
			sibling.gender = prob(50) ? MALE : FEMALE
			sibling.real_name = GenerateRoyalName(sibling.gender, i + 1)
			set_species_type(sibling, ruling_family.dominant_species)
			var/datum/family_member/sibling_member = ruling_family.CreateFamilyMember(sibling)
			sibling_member.generation = i + 1
			sibling_member.AddParent(parent)
			sibling_member.AddParent(parent_spouse)

		current_ancestor = parent

/datum/controller/subsystem/familytree/proc/set_species_type(mob/living/carbon/human/H, species_type)
	if(!H || !species_type)
		return

	var/datum/species/S = new species_type
	H.set_species(S)
	H.dna.species = S

/datum/controller/subsystem/familytree/proc/GenerateRoyalName(gender, generation)
	var/list/male_names = list(
		"King" = list("Otto", "Arnulf", "Ludwig", "Henri", "Louis", "Francois"),
		"Prince" = list("Karl", "Konrad", "Heinrich", "Raoul", "Hugues")
	)
	var/list/female_names = list(
		"Queen" = list("Hildegard", "Freya", "Helga", "Jeanne", "Adeline"),
		"Princess" = list("Karoline", "Hedwig", "Anneliese", "Elise")
	)

	var/title
	var/list/names
	if(gender == MALE)
		title = generation > 2 ? "King" : "Prince"
		names = male_names[title]
	else
		title = generation > 2 ? "Queen" : "Princess"
		names = female_names[title]

	var/list/roman_numerals = list("I", "II", "III", "IV", "V")
	return "[title] [pick(names)] [pick(roman_numerals)]"

// matchmaking
/datum/controller/subsystem/familytree/proc/AssignRandom(mob/living/carbon/human/H)
	listclearnulls(viable_spouses)
	for(var/mob/living/carbon/human/stale in viable_spouses.Copy())
		if(QDELETED(stale) || !stale.client)
			viable_spouses -= stale
	viable_spouses += H
	var/list/my_info = MobInfo(H)
	var/list/complements = list("Spouse" = "Spouse", "Sibling" = "Sibling", "Parent" = "Offspring", "Offspring" = "Parent", "Lover" = "Lover", "Friend" = "Friend", "Cousin" = "Cousin")
	var/list/unmatched = list()
	var/list/paired = list()

	for(var/relation in H.random_match.Copy())
		if(!(relation in relation_options))
			continue
		var/list/candidates = list()
		for(var/mob/living/carbon/human/other in viable_spouses)
			if(other == H || (other in paired) || other.stat == DEAD || !other.client)
				continue
			if(!(complements[relation] in other.random_match) || !AgeOK(relation, H.age, other.age))
				continue
			LinkSpawn(other)
			// NO polyamory. 
			if(relation == "Spouse" && (H.spouse_mob || other.spouse_mob))
				continue
			if(relation == "Lover" && (H.family_member_datum?.lover?.person || other.family_member_datum?.lover?.person))
				continue
			if(relation == "Spouse" && ((H.mind?.assigned_role in nomarry_jobs) || (other.mind?.assigned_role in nomarry_jobs)))
				continue
			if(Blocked(H.ckey, other.ckey) || !Compatible(my_info, MobInfo(other), (relation == "Spouse" || relation == "Lover")))
				continue
			candidates += other
		if(!candidates.len)
			unmatched += relation
			continue
		var/mob/living/carbon/human/chosen = pick(candidates)
		paired += chosen
		H.random_match -= relation
		chosen.random_match -= complements[relation]
		if(!chosen.random_match.len)
			viable_spouses -= chosen
		switch(relation)
			if("Spouse")
				H.MarryTo(chosen)
			if("Sibling")
				H.MarryTo(chosen, "sibling")
			if("Parent")
				chosen.MarryTo(H, "parent")
			if("Offspring")
				H.MarryTo(chosen, "parent")
			if("Lover")
				H.MarryTo(chosen, "lover")
			if("Friend")
				H.MarryTo(chosen, "friend")
			if("Cousin")
				H.MarryTo(chosen, "cousin")

	if(!H.random_match.len)
		viable_spouses -= H
	if(unmatched.len)
		to_chat(H, span_notice("No random match yet for: [unmatched.Join(", ")]."))

/datum/controller/subsystem/familytree/proc/AgeOK(relation, poster_age, other_age)
	if(relation == "Parent")
		// I think the list order method is rlly cool
		return age_order.Find(other_age) > age_order.Find(poster_age)
	if(relation == "Offspring")
		return age_order.Find(poster_age) > age_order.Find(other_age)
	return TRUE

// so this avoids putting ckeys in the links which is Important
/datum/controller/subsystem/familytree/proc/Token(id)
	return md5("[id][salt]")

// ppl were complaining abt putting ads up each time *sigh!!!
/datum/controller/subsystem/familytree/proc/RestoreAd(datum/preferences/P)
	var/my_id = "[P.parent.ckey]/[P.default_slot]"
	for(var/ad_id in board.Copy())
		if(board[ad_id]["ckey"] != P.parent.ckey || ad_id == my_id)
			continue
		board -= ad_id
		for(var/list/req in requests.Copy())
			if(req["to"] == ad_id)
				requests -= list(req)
	if(saved_ads[my_id])
		board[my_id] = saved_ads[my_id]

/datum/controller/subsystem/familytree/proc/SaveBoard()
	var/data = json_encode(list("links" = links, "blocks" = blocks, "ads" = saved_ads))
	fdel(board_path)
	WRITE_FILE(file(board_path), data)

/datum/controller/subsystem/familytree/proc/PrefInfo(datum/preferences/P)
	return list("id" = "[P.parent.ckey]/[P.default_slot]", "ckey" = P.parent.ckey, "name" = P.real_name, "species" = P.pref_species.name, "pronouns" = splittext(P.pronouns, " ")[1], "gender" = P.gender_choice, "species_filter" = P.species_filter.Copy(), "blacklist" = P.species_blacklist, "headshot" = P.headshot_link, "age" = P.age, "flavortext" = P.flavortext, "nsfwflavortext" = P.nsfwflavortext, "ooc_notes" = P.ooc_notes, "erpprefs" = P.erpprefs, "ooc_extra" = P.ooc_extra, "ooc_extra_img" = P.ooc_extra_img, "nsfw_ooc_extra_img" = P.nsfw_ooc_extra_img, "song_artist" = P.song_artist, "song_title" = P.song_title, "img_gallery" = P.img_gallery.Copy(), "nsfw_img_gallery" = P.nsfw_img_gallery.Copy(), "headshot_zoom" = P.headshot_zoom, "headshot_x" = P.headshot_x, "headshot_y" = P.headshot_y, "headshot_framed" = P.headshot_framed, "image_backdrop" = P.image_backdrop, "card_backgrounds" = P.card_backgrounds.Copy(), "art_view_settings" = P.art_view_settings.Copy()) // fuuuck

/datum/controller/subsystem/familytree/proc/MobInfo(mob/living/carbon/human/H)
	return list("id" = H.family_id, "ckey" = H.ckey, "name" = H.real_name, "species" = H.dna.species.name, "pronouns" = splittext(H.pronouns, " ")[1], "gender" = H.gender_choice_pref, "species_filter" = H.species_filter, "blacklist" = H.species_blacklist, "age" = H.age)

/datum/controller/subsystem/familytree/proc/Compatible(list/a, list/b, check_gender = FALSE)
	for(var/list/pair in list(list(a, b), list(b, a)))
		var/list/x = pair[1]
		var/list/y = pair[2]
		var/same = (x["pronouns"] == y["pronouns"])
		if(check_gender && x["gender"] == SAME_GENDER && !same)
			return FALSE
		if(check_gender && x["gender"] == DIFFERENT_GENDER && same)
			return FALSE
		if(length(x["species_filter"]) && x["blacklist"] && (y["species"] in x["species_filter"]))
			return FALSE
		if(length(x["species_filter"]) && !x["blacklist"] && !(y["species"] in x["species_filter"]))
			return FALSE
	return TRUE

// u see I am wise & know ppl will be shitty
/datum/controller/subsystem/familytree/proc/Blocked(ckey_a, ckey_b)
	return (ckey_b in blocks[ckey_a]) || (ckey_a in blocks[ckey_b])

/datum/controller/subsystem/familytree/proc/LinkSpawn(mob/living/carbon/human/H)
	if(!H.family_id || (H.job in royal_jobs))
		return
	for(var/list/link in links)
		if(link in connected)
			continue
		if(length(link) >= 6 && length(link[6]))
			continue
		var/other_id = link[1]
		if(link[1] == H.family_id)
			other_id = link[2]
		else if(link[2] != H.family_id)
			continue
		for(var/mob/living/carbon/human/other in GLOB.human_list)
			if(other == H || other.family_id != other_id || other.stat == DEAD || !other.client || (other.job in royal_jobs))
				continue
			if(link[3] == "spouse" && (H.spouse_mob || other.spouse_mob))
				continue
			if(link[3] == "lover" && (H.family_member_datum?.lover?.person || other.family_member_datum?.lover?.person))
				continue
			if(link[3] == "parent")
				var/mob/living/carbon/human/older = H
				var/mob/living/carbon/human/younger = other
				if(link[2] == H.family_id)
					older = other
					younger = H
				if(age_order.Find(older.age) <= age_order.Find(younger.age))
					continue
			connected += list(link)
			if(link[2] == H.family_id && link[3] == "parent")
				other.MarryTo(H, "parent")
			else
				H.MarryTo(other, link[3])
			break

/datum/controller/subsystem/familytree/proc/ReturnAllFamilies()
	. = ""
	if(ruling_family && ruling_family.members.len)
		. += ruling_family.FormatFamilyList()
	for(var/datum/heritage/house in families)
		if(!house.housename && !house.members.len)
			continue
		. += house.FormatFamilyList()

/datum/controller/subsystem/familytree/proc/ValidateAllFamilies()
	if(ruling_family && ruling_family.members.len)
		ValidateFamily(ruling_family)
	for(var/datum/heritage/family in families)
		if(family.members.len)
			ValidateFamily(family)

/datum/controller/subsystem/familytree/proc/ValidateFamily(datum/heritage/family)
	// Clean up any broken references
	for(var/datum/family_member/member in family.members)
		if(!member.person)
			family.members -= member
			continue

		// Validate parent relationships
		for(var/datum/family_member/parent in member.parents)
			if(!parent.person || !(member in parent.children))
				member.parents -= parent
				if(parent.person)
					parent.children -= member

		// Validate child relationships
		for(var/datum/family_member/child in member.children)
			if(!child.person || !(member in child.parents))
				member.children -= child
				if(child.person)
					child.parents -= member
