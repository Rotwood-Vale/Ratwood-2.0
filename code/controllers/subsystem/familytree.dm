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

	return ..()

/datum/controller/subsystem/familytree/proc/GetAgeValue(age_string)
	// Convert age string to numeric value for comparison
	switch(age_string)
		if(AGE_ADULT)
			return 1
		if(AGE_MIDDLEAGED)
			return 2
		if(AGE_OLD)
			return 3
		if(AGE_IMMORTAL)
			return 4
		else
			return 1 // Default to adult

/datum/controller/subsystem/familytree/proc/WouldCreateAgeConflict(datum/heritage/house, mob/living/carbon/human/person)
	if(!house.members.len)
		return FALSE
	// Check against existing family members for age conflicts
	for(var/datum/family_member/member in house.members)
		if(!member.person)
			continue

		// Check if person is too young to be parent of existing children
		for(var/datum/family_member/child in member.children)
			if(child.person && !CanBeParentOf(person, child.person))
				return TRUE

		// Check if person is too old to be child of existing parents
		for(var/datum/family_member/parent in member.parents)
			if(parent.person && !CanBeParentOf(parent.person, person))
				return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/CanBeParentOf(mob/living/carbon/human/parent, mob/living/carbon/human/child)
	var/parent_age = parent.age
	var/child_age = child.age
	if(!child.setspouse || child.setspouse == parent.real_name)
		if(parent_age == AGE_ADULT)
			return FALSE
		if(parent_age == AGE_MIDDLEAGED && child_age == AGE_ADULT)
			return TRUE
		if(parent_age == AGE_OLD && child_age != AGE_OLD && child_age != AGE_IMMORTAL)
			return TRUE
		if(parent_age == AGE_IMMORTAL && child_age != AGE_IMMORTAL)
			return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/CanBeSiblings(age1, age2)
	// Siblings can be same age category or adjacent categories
	if(age1 == age2)
		return TRUE

	var/age1_value = GetAgeValue(age1)
	var/age2_value = GetAgeValue(age2)

	// Allow siblings to be within 1 age category of each other
	if(abs(age1_value - age2_value) <= 1)
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/DetermineAppropriateRole(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE)
	// Look for potential parents (older members who could be parents)
	var/list/potential_parents = list()
	for(var/datum/family_member/member in house.members)
		if(member.person && CanBeParentOf(member.person, person))
			potential_parents += member

	// If we have potential parents, make this person a child
	if(potential_parents.len)
		return "child"

	// Look for potential siblings (similar age)
	for(var/datum/family_member/member in house.members)
		if(member.person && CanBeSiblings(member.person.age, person.age))
			return "sibling"

	// Default to founder/parent role
	return "parent"

/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	if(!H || !status || istype(H, /mob/living/carbon/human/dummy))
		return
	if(H.stat == DEAD || !H.client)
		return
	//Exclude princes and princesses from having their parentage calculated.
	if(H.mind?.assigned_role in excluded_jobs)
		return
	if(H.mind?.assigned_role in nomarry_jobs)
		if(status != FAMILY_NONE)
			AssignToHouse(H)
			return
	switch(status)
		if(FAMILY_PARTIAL)
			AssignToHouse(H)

		if(FAMILY_NEWLYWED)
			AssignNewlyWed(H)

		if(FAMILY_FULL)
			if(H.virginity)
				return
			AssignToFamily(H)

/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(!ruling_family.housename)
		ruling_family.housename = " Royal"
	var/datum/family_member/member = ruling_family.CreateFamilyMember(H)
	if(!member)
		return

	// If this is the first royal, generate a historical lineage
	if(!ruling_family.founder)
		GenerateRoyalLineage(member, status)
		H.ShowFamilyUI(TRUE)
		return

	// Handle adding new royals to existing family
	switch(status)
		if(FAMILY_FATHER, FAMILY_MOTHER)
			// If there's already a monarch, make them spouses
			var/datum/family_member/existing_monarch = GetCurrentMonarch()
			member.generation = 12
			if(existing_monarch)
				ruling_family.MarryMembers(existing_monarch, member)

		if(FAMILY_PROGENY)  // Prince/Princess
			// Children of the current monarch
			var/datum/family_member/monarch = GetCurrentMonarch()
			if(monarch)
				member.generation = monarch.generation + 1
				member.AddParent(monarch)
				// Add other parent if monarch has spouse
				if(monarch.spouses.len)
					member.AddParent(monarch.spouses[1])

		if(FAMILY_OMMER)  // Hand - sibling or cousin of monarch
			CreateBranchFamily(member)

	H.ShowFamilyUI(TRUE)

/datum/controller/subsystem/familytree/proc/GetCurrentMonarch()
	// Find the monarch at generation 12 (current ruling generation)
	for(var/datum/family_member/member in ruling_family.members)
		if(member.generation == 12 && (member.person.job == "Grand Duke" || member.person.job == "Grand Duchess"))
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

/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H)
	if(!H)
		return

	var/our_race = H.dna.species.name
	var/adopted = FALSE
	var/datum/heritage/chosen_house
	var/list/low_priority_houses = list()
	var/list/high_priority_houses = list()

	if(H.setspouse)
		for(var/datum/heritage/house in families)
			for(var/datum/family_member/M in house.members)
				if(M.person && M.person.real_name == H.setspouse)
					if(M.person.stat == DEAD || !M.person.client)
						break
					if(M.person.xenophobe == 1 && M.person.dna.species.name != our_race)
						break
					if(M.person.xenophobe == 2 && M.person.restricted_species && our_race != M.person.restricted_species)
						break
					if(H.xenophobe == 2 && H.restricted_species && M.person.dna.species.name != H.restricted_species)
						break
					chosen_house = house

	// Prioritize houses with existing members but not too many
	for(var/datum/heritage/house in families)
		if(house.housename && house.members.len >= 1 && house.members.len < 6)
			high_priority_houses += house
		else
			low_priority_houses += house

	// Try high priority houses first
	if(!chosen_house)
		for(var/datum/heritage/house in high_priority_houses)
			if(house.dominant_race == our_race && house.members.len < 4)
				if(!WouldCreateAgeConflict(house, H))
					chosen_house = house
					break
		// Small chance for adoption into different species family
			if(prob(20) && house.members.len <= 8)
				if(!WouldCreateAgeConflict(house, H))
					chosen_house = house
					adopted = TRUE
					break

	// Try low priority houses if no high priority match
	if(!chosen_house)
		for(var/datum/heritage/house in low_priority_houses)
			if(house.dominant_race == our_race)
				if(!WouldCreateAgeConflict(house, H))
					chosen_house = house
					break

	if(chosen_house)
		AddPersonToHouse(chosen_house, H, adopted)

/datum/controller/subsystem/familytree/proc/AddPersonToHouse(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE)
	var/role = DetermineAppropriateRole(house, person, adopted)

	switch(role)
		if("child")
			// Find suitable parents
			var/list/potential_parents = list()
			for(var/datum/family_member/member in house.members)
				if(member.person && CanBeParentOf(member.person, person))
					potential_parents += member

			// Add as child with up to 2 parents
			var/datum/family_member/parent1 = potential_parents.len > 0 ? potential_parents[1] : null
			var/datum/family_member/parent2 = potential_parents.len > 1 ? potential_parents[2] : null

			house.AddToFamily(person, parent1, parent2, adopted)

		if("sibling")
			// Find a sibling and share their parents
			for(var/datum/family_member/member in house.members)
				if(member.person && CanBeSiblings(member.person.age, person.age))
					var/datum/family_member/parent1 = member.parents.len > 0 ? member.parents[1] : null
					var/datum/family_member/parent2 = member.parents.len > 1 ? member.parents[2] : null
					house.AddToFamily(person, parent1, parent2, adopted)
					break

		if("parent")
			// Add as founder/parent
			var/datum/family_member/new_member = house.CreateFamilyMember(person)
			if(!house.founder)
				house.founder = new_member
				new_member.generation = 0
			if(!house.housename)
				house.housename = house.SurnameFormatting(person)


/// Human Helper proc to check gender choice based on pronouns

/mob/living/carbon/human/proc/pronouns_match(mob/living/carbon/human/H, mob/living/carbon/human/other)
	if(!H.gender_choice_pref)
		H.gender_choice_pref = ANY_GENDER
	if(!other.gender_choice_pref)
		other.gender_choice_pref = ANY_GENDER
	var/our_gender = H.pronouns
	var/other_gender = other.pronouns
	if(H.gender_choice_pref == ANY_GENDER && other.gender_choice_pref == ANY_GENDER)
		return TRUE
	if(H.gender_choice_pref == ANY_GENDER)
		if(other.gender_choice_pref == SAME_GENDER)
			return our_gender == other_gender
		if(other.gender_choice_pref == DIFFERENT_GENDER)
			return our_gender != other_gender
		return TRUE
	if(other.gender_choice_pref == ANY_GENDER)
		if(H.gender_choice_pref == SAME_GENDER)
			return our_gender == other_gender
		if(H.gender_choice_pref == DIFFERENT_GENDER)
			return our_gender != other_gender
		return TRUE
	if(H.gender_choice_pref == SAME_GENDER)
		return our_gender == other_gender
	if(H.gender_choice_pref == DIFFERENT_GENDER)
		return our_gender != other_gender

	return FALSE
/datum/controller/subsystem/familytree/proc/AssignToFamily(mob/living/carbon/human/H)
	if(!H)
		return
	var/our_race = H.dna.species.name
	var/list/eligible_houses = list()

	// Find houses that need a spouse
	for(var/datum/heritage/house in families)
		if(house.dominant_race != our_race)
			continue

		// Check if there's a potential spouse
		var/has_single_adult = FALSE
		for(var/datum/family_member/member in house.members)
			if(member.person && !member.spouses.len)
				if(member.person.stat == DEAD || !member.person.client)
					continue
				// Check setspouse compatibility
				if(H.setspouse && member.person.real_name == H.setspouse)
					eligible_houses.Insert(1, house) // High priority
					has_single_adult = TRUE
					break
				else if(!H.setspouse)

					if(!member.person.setspouse || member.person.setspouse == H.real_name)
						var/ok_gender_H = H.pronouns_match(H, member.person)
						var/ok_gender_M = member.person.pronouns_match(member.person, H)
						if((member.person.xenophobe == 1 || H.xenophobe == 1) && member.person.dna.species.name != our_race)
							continue
						if(member.person.xenophobe == 2 && member.person.restricted_species && our_race != member.person.restricted_species)
							continue
						if(H.xenophobe == 2 && H.restricted_species && member.person.dna.species.name != H.restricted_species)
							continue
						if(member.person.familytree_pref == FAMILY_PARTIAL)
							continue
						if(member.person.mind?.assigned_role in nomarry_jobs)
							continue
						if(ok_gender_H && ok_gender_M && abs(H.social_rank - member.person.social_rank) <= 1)
							eligible_houses += house
							has_single_adult = TRUE
							break


		if(!has_single_adult && !house.housename)
			eligible_houses += house // Empty house for founding

	// Try to assign to a house
	for(var/datum/heritage/house in eligible_houses)
		// Find a spouse
		for(var/datum/family_member/member in house.members)
			if(member.person && !member.spouses.len)
				if(member.person.stat == DEAD || !member.person.client)
					continue
				// Check compatibility
				var/compatible = FALSE
				if(H.setspouse && member.person.real_name == H.setspouse)
					compatible = TRUE
				else if(!H.setspouse)
					if(!member.person.setspouse || member.person.setspouse == H.real_name)
						// Pronouns matching according to Gender Preference
						var/ok_gender_H = H.pronouns_match(H, member.person)
						var/ok_gender_M = member.person.pronouns_match(member.person, H)

						if(ok_gender_H && ok_gender_M)
							compatible = TRUE

				if(compatible)
					var/datum/family_member/new_member = house.CreateFamilyMember(H)
					if(new_member)
						house.MarryMembers(new_member, member)
						return

		// Or found a new house
		if(!house.housename)
			var/datum/family_member/new_member = house.CreateFamilyMember(H)
			if(new_member)
				house.founder = new_member
				new_member.generation = 0
				house.housename = house.SurnameFormatting(H)
				return

	// Create entirely new house if no match found
	if(our_race != "Aasimar" && our_race != "Doll" && our_race != "Golem")
		var/datum/heritage/new_house = new /datum/heritage(H, null, H.dna.species.type)
		families += new_house

/datum/controller/subsystem/familytree/proc/AssignNewlyWed(mob/living/carbon/human/H)
	viable_spouses += H
	var/list/potential_matches = list()

	for(var/mob/living/carbon/human/potential_spouse in viable_spouses)
		if(!potential_spouse || potential_spouse == H || potential_spouse.spouse_mob)
			continue
		if(potential_spouse.stat == DEAD || !potential_spouse.client)
			continue
		// Check if they are mutually setspouse
		var/mutual_setspouse = (H.setspouse == potential_spouse.real_name) && (potential_spouse.setspouse == H.real_name)
		if(!mutual_setspouse)
			if(!H.pronouns_match(H, potential_spouse) || !potential_spouse.pronouns_match(potential_spouse, H))
				continue // skip if gender preferences incompatible
		if(abs(H.social_rank - potential_spouse.social_rank) > 1)
			continue
		if((potential_spouse.xenophobe == 1 || H.xenophobe == 1) && potential_spouse.dna.species.name != H.dna.species.name)
			continue
		if(potential_spouse.xenophobe == 2 && potential_spouse.restricted_species && H.dna.species.name != potential_spouse.restricted_species)
			continue
		if(H.xenophobe == 2 && H.restricted_species && potential_spouse.dna.species.name != H.restricted_species)
			continue
		// Check setspouse compatibility
		var/priority = 0
		if(mutual_setspouse)
			priority = 3 // Perfect match
		else if(potential_spouse.setspouse == H.real_name)
			priority = 1 // Decent match
		else if(!H.setspouse && !potential_spouse.setspouse)
			priority = 0 // Random match
		else
			continue // Incompatible

		potential_matches += list(list(potential_spouse, priority))

	// Sort by priority and pick best match
	if(potential_matches.len)
		var/best_priority = -1
		var/list/best_matches = list()

		for(var/list/match_data in potential_matches)
			var/match_priority = match_data[2]
			if(match_priority > best_priority)
				best_priority = match_priority
				best_matches = list(match_data[1])
			else if(match_priority == best_priority)
				best_matches += match_data[1]

		if(best_matches.len)
			var/mob/living/carbon/human/chosen_spouse = pick(best_matches)
			viable_spouses -= chosen_spouse
			viable_spouses -= H
			H.MarryTo(chosen_spouse)

/datum/controller/subsystem/familytree/proc/AssignAuntUncle(mob/living/carbon/human/H)
	var/base_species = H.dna.species.name
	var/datum/heritage/chosen_house

	// Find houses with established families that could use an aunt/uncle
	for(var/datum/heritage/house in families)
		if(house.dominant_race != base_species)
			continue
		if(!house.housename || house.members.len < 2)
			continue

		// Check if there are children who could use an aunt/uncle
		var/has_children = FALSE
		for(var/datum/family_member/member in house.members)
			if(member.children.len > 0)
				has_children = TRUE
				break

		if(has_children && !WouldCreateAgeConflict(house, H))
			chosen_house = house
			break

	if(chosen_house)
		// Add as sibling to one of the parents
		var/datum/family_member/new_member = chosen_house.CreateFamilyMember(H)
		if(new_member)
			// Find a parent to be sibling to
			for(var/datum/family_member/member in chosen_house.members)
				if(member.children.len > 0 && CanBeSiblings(H.age, member.person.age))
					// Share the same parents as this member
					for(var/datum/family_member/grandparent in member.parents)
						new_member.AddParent(grandparent)
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
