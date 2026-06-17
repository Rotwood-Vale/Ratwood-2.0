/datum/family_curse
	var/name
	var/description
	var/curse_type
	var/severity = 1 // 1-3 scale
	var/inherited = TRUE // Whether curse passes to children
	var/tmp/datum/weakref/cursed_by // Who placed the curse
	var/when_cursed
	var/blessing = FALSE

	var/list/curse_effects = list()


//Misfortune
/datum/family_curse/misfortune
	name = "家族厄运"
	description = "这条血脉总被厄运缠身"
	curse_effects = list(/datum/status_effect/misfortune)

/datum/status_effect/misfortune
	id = "family_misfortune"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/misfortune
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/family_curse/misfortune
	name = "家族厄运"
	desc = "家族的诅咒让厄运伴随着我的每一步。"
	icon_state = "debuff"

	var/static/list/misfortune_tips = list(
		"无论我走到哪里，仿佛都有阴云相随……",
		"我能感到家族诅咒沉重地压在身上。",
		"就连最简单的事也似乎更容易出错了。",
		"命运仿佛在合谋与我作对。",
		"先祖的罪孽至今仍在纠缠着我。"
	)

/atom/movable/screen/alert/status_effect/family_curse/misfortune/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(desc == initial(desc))
		desc = "[initial(desc)] [pick(misfortune_tips)]"


// Hunger
/datum/family_curse/hunger
	name = "无尽饥渴"
	description = "这条血脉饥肠辘辘，永难满足。"
	curse_effects = list(/datum/status_effect/hunger)

/datum/status_effect/hunger
	id = "family_hunger"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/family_curse/hunger

/atom/movable/screen/alert/status_effect/family_curse/hunger
	name = "无尽饥渴"
	desc = "家族被一种极少能够满足的饥饿所诅咒。"
	icon_state = "debuff"

	var/static/list/hunger_tips = list(
		"我的胃像笼中的沃尔夫一样低吼着……",
		"我能感到家族诅咒沉重地压在身上。",
		"即便是最丰盛的盛宴也从来无法让我满足。"
	)

/atom/movable/screen/alert/status_effect/family_curse/hunger/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	if(desc == initial(desc))
		desc = "[initial(desc)] [pick(hunger_tips)]"


/atom/movable/screen/alert/status_effect/family_curse/handle_click(location, control, params)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.family_datum)
		var/curse_info = ""
		for(var/datum/family_curse/curse in user.family_datum.family_curses)
			curse_info += "<b>[curse.name]</b><br>"
			curse_info += "[curse.description]<br>"
			if(curse.cursed_by)
				var/mob/curser = curse.cursed_by.resolve()
				if(curser)
					curse_info += "[curse.blessing ? "祝福施加者" : "诅咒施加者"]：[curser.real_name]<br>"
			curse_info += "严重程度：[curse.severity]/3<br>"
			curse_info += "受影响时长：[DisplayTimeText(world.time - curse.when_cursed)]<br>"

		if(curse_info)
			var/datum/browser/popup = new(usr, "curse_info", "家族状态详情", 300, 200)
			popup.set_content(curse_info)
			popup.open()

/datum/heritage
	var/housename
	var/datum/species/dominant_species
	var/datum/species/dominant_race
	var/list/members = list() // All family members
	var/list/family_icons = list()
	var/datum/family_member/founder // The person who started this family line

	var/list/family_curses = list()
	var/list/curse_history = list() // Track when/how curses were gained

/datum/heritage/proc/AddFamilyCurse(datum/family_curse/curse_type, severity, mob/curser)
	var/datum/family_curse/new_curse = new curse_type()
	new_curse.curse_type = curse_type
	new_curse.severity = severity
	new_curse.cursed_by = WEAKREF(curser)
	new_curse.when_cursed = world.time

	family_curses += new_curse

	// Record curse history
	curse_history += "[housename] 家族遭到了 [curser] 施加的[new_curse.name]。"

	// Apply curse effects to all members
	ApplyCurseEffects(new_curse)

	return new_curse

/datum/heritage/proc/ApplyCurseEffects(datum/family_curse/curse)
	for(var/datum/family_member/F in members)
		if(F.person)
			for(var/effect in curse.curse_effects)
				F.person.apply_status_effect(effect)

/datum/heritage/proc/InheritCurses(datum/family_member/child)
	// Pass inherited curses to new family members
	for(var/datum/family_curse/curse in family_curses)
		if(curse.inherited)
			for(var/effect in curse.curse_effects)
				child.person?.apply_status_effect(effect)


/datum/heritage/proc/TransferToFamily(mob/living/carbon/human/person, relationship_type)
	var/datum/family_member/member = CreateFamilyMember(person)
	if(!member)
		return FALSE

	// Handle different relationship types
	switch(relationship_type)
		if(FAMILY_INLAW)
			member.adoption_status = FALSE
		if(FAMILY_FATHER, FAMILY_MOTHER)
			pass()

	to_chat(person, span_notice("我以[relationship_type]的身份加入了[housename]家族。"))
	return member

/datum/heritage/proc/ConductWedding(datum/family_member/bride, datum/family_member/groom, mob/living/carbon/human/officiant)
	if(!bride || !groom || !officiant)
		return FALSE

	// Perform the marriage
	if(!MarryMembers(bride, groom))
		return FALSE

	// Announce to all family members
	var/announcement = "[bride.person?.real_name]与[groom.person?.real_name]已在[housename]家族中缔结婚姻！"

	for(var/datum/family_member/member in members)
		if(member.person && member.person?.client)
			to_chat(member.person, span_love(announcement))

	// Handle any children that should now be biological
	bride.HandleBiologicalChildren(groom)

	return TRUE

/datum/family_member
	var/tmp/mob/living/carbon/human/person
	var/datum/heritage/family
	var/list/parents = list() // Direct parents (max 2)
	var/list/children = list() // Direct children
	var/list/spouses = list() // Current spouses
	var/list/former_spouses = list() // Divorced spouses
	var/adoption_status = FALSE // TRUE if adopted into family
	var/generation = 0 // 0 = founder, 1 = their children, etc.
	var/tmp/recalculating_generation = FALSE
	var/mutable_appearance/cloned_look

/datum/family_member/New(mob/living/carbon/human/new_person, datum/heritage/new_family)
	person = new_person
	family = new_family
	person?.family_member_datum = src
	var/old_dir = person?.dir
	var/old_inivisiity = person?.invisibility
	person?.invisibility = 0
	person?.dir = SOUTH
	cloned_look = new_person?.appearance
	person?.dir = old_dir
	person?.invisibility = old_inivisiity

/datum/family_member/proc/AddParent(datum/family_member/parent, skip_reciprocal = FALSE)
	if(!parent || (parent in parents))
		return FALSE
	if(parents.len >= 2)
		return FALSE // Can't have more than 2 parents

	// Prevent circular relationships (can't be parent of your own ancestor)
	if(IsAncestorOf(parent))
		return FALSE

	parents += parent

	// Only add reciprocal relationship if not already doing so
	if(!skip_reciprocal && !(src in parent.children))
		parent.AddChild(src, TRUE) // TRUE = skip reciprocal call

	RecalculateGeneration()
	return TRUE

/datum/family_member/proc/RemoveParent(datum/family_member/parent, skip_reciprocal = FALSE)
	if(!parent || !(parent in parents))
		return FALSE

	parents -= parent

	// Only remove reciprocal relationship if not already doing so
	if(!skip_reciprocal && (src in parent.children))
		parent.RemoveChild(src, TRUE) // TRUE = skip reciprocal call

	RecalculateGeneration()
	return TRUE

/datum/family_member/proc/AddChild(datum/family_member/child, skip_reciprocal = FALSE)
	if(!child || (child in children))
		return FALSE

	// Prevent circular relationships (can't be child of your own descendant)
	if(IsDescendantOf(child))
		return FALSE

	children += child

	// Only add reciprocal relationship if not already doing so
	if(!skip_reciprocal && !(src in child.parents))
		child.AddParent(src, TRUE) // TRUE = skip reciprocal call

	child.RecalculateGeneration()
	return TRUE

/datum/family_member/proc/RemoveChild(datum/family_member/child, skip_reciprocal = FALSE)
	if(!child || !(child in children))
		return FALSE

	children -= child

	// Only remove reciprocal relationship if not already doing so
	if(!skip_reciprocal && (src in child.parents))
		child.RemoveParent(src, TRUE) // TRUE = skip reciprocal call

	child.RecalculateGeneration()
	return TRUE

/datum/family_member/proc/AddSpouse(datum/family_member/spouse, skip_reciprocal = FALSE)
	if(!spouse || (spouse in spouses))
		return FALSE

	spouses += spouse
	person.spouse_mob = spouse.person

	// Only add reciprocal relationship if not already doing so
	if(!skip_reciprocal && !(src in spouse.spouses))
		spouse.AddSpouse(src, TRUE) // TRUE = skip reciprocal call

	// Handle biological children when both parents are present
	HandleBiologicalChildren(spouse)
	return TRUE

/datum/family_member/proc/RemoveSpouse(datum/family_member/spouse, divorce = FALSE, skip_reciprocal = FALSE)
	if(!spouse || !(spouse in spouses))
		return FALSE

	spouses -= spouse

	// Only remove reciprocal relationship if not already doing so
	if(!skip_reciprocal && (src in spouse.spouses))
		spouse.RemoveSpouse(src, divorce, TRUE) // TRUE = skip reciprocal call

	if(divorce)
		if(!(spouse in former_spouses))
			former_spouses += spouse
		if(!skip_reciprocal && !(src in spouse.former_spouses))
			spouse.former_spouses += src

	return TRUE

/datum/family_member/proc/IsAncestorOf(datum/family_member/other)
	if(!other || other == src)
		return FALSE

	// Check if other is in our descendant chain
	var/list/checked = list(src)
	var/list/to_check = children.Copy()

	while(to_check.len)
		var/datum/family_member/current = to_check[1]
		to_check -= current

		if(current == other)
			return TRUE

		if(!(current in checked))
			checked += current
			to_check += current.children

	return FALSE

/datum/family_member/proc/IsDescendantOf(datum/family_member/other)
	if(!other || other == src)
		return FALSE

	// Check if other is in our ancestor chain
	var/list/checked = list(src)
	var/list/to_check = parents.Copy()

	while(to_check.len)
		var/datum/family_member/current = to_check[1]
		to_check -= current

		if(current == other)
			return TRUE

		if(!(current in checked))
			checked += current
			to_check += current.parents

	return FALSE

/datum/family_member/proc/HandleBiologicalChildren(datum/family_member/spouse)
	// Check if any children should be biological offspring of both parents
	for(var/datum/family_member/child in children)
		if(child in spouse.children)
			// Both are parents of this child
			if(family.SpeciesCalculation(child.person, person, spouse.person))
				child.adoption_status = FALSE
				child.person?.MixDNA(person, spouse.person, override = TRUE)

/datum/family_member/proc/RecalculateGeneration()
	if(recalculating_generation)
		return
	recalculating_generation = TRUE

	if(!parents.len)
		generation = 0 // Founder/root generation
	else
		var/max_parent_gen = -1
		for(var/datum/family_member/parent in parents)
			if(parent.generation > max_parent_gen)
				max_parent_gen = parent.generation
		generation = max_parent_gen + 1

	recalculating_generation = FALSE

	for(var/datum/family_member/child in children)
		if(!child.recalculating_generation)
			child.RecalculateGeneration()

/datum/family_member/proc/GetRelationshipTo(datum/family_member/other)
	if(!other || other == src)
		return null

	// Direct relationships
	if(other in parents)
		return other.person?.pronouns == HE_HIM ? "父亲" : "母亲"
	if(other in children)
		return other.person?.pronouns == HE_HIM ? "儿子" : "女儿"
	if(other in spouses)
		return other.person?.pronouns == HE_HIM ? "丈夫" : "妻子"

	// Sibling check
	if(AreSiblings(other))
		return other.person?.pronouns == HE_HIM ? "兄弟" : "姐妹"

	// Grandparent/Grandchild
	var/grandparent_rel = GetGrandparentRelation(other)
	if(grandparent_rel)
		return grandparent_rel

	var/grandchild_rel = GetGrandchildRelation(other)
	if(grandchild_rel)
		return grandchild_rel

	// Aunt/Uncle/Niece/Nephew
	var/aunt_uncle_rel = GetAuntUncleRelation(other)
	if(aunt_uncle_rel)
		return aunt_uncle_rel

	var/niece_nephew_rel = GetNieceNephewRelation(other)
	if(niece_nephew_rel)
		return niece_nephew_rel

	// Cousin relationships
	var/cousin_rel = GetCousinRelation(other)
	if(cousin_rel)
		return cousin_rel

	// Great-relationships (great-grandparent, etc.)
	var/great_rel = GetGreatRelation(other)
	if(great_rel)
		return great_rel

	// In-law relationships (moved to end to avoid recursion)
	var/inlaw_rel = GetInLawRelation(other)
	if(inlaw_rel)
		return inlaw_rel

	return "远亲"

/datum/family_member/proc/GetInLawRelation(datum/family_member/other)
	for(var/datum/family_member/spouse in spouses)
		// Check direct relationships to spouse's family
		if(other in spouse.parents)
			return other.person?.pronouns == HE_HIM ? "岳父" : "岳母"
		if(other in spouse.children)
			return other.person?.pronouns == HE_HIM ? "女婿" : "儿媳"
		if(spouse.AreSiblings(other))
			return other.person?.pronouns == HE_HIM ? "姻亲兄弟" : "姻亲姐妹"

		// Check spouse's grandparents
		for(var/datum/family_member/spouse_parent in spouse.parents)
			if(other in spouse_parent.parents)
				return other.person?.pronouns == HE_HIM ? "姻亲祖父" : "姻亲祖母"

	// Check if other is married to our sibling
	for(var/datum/family_member/member in family.members)
		if(AreSiblings(member) && (other in member.spouses))
			return other.person?.pronouns == HE_HIM ? "姻亲兄弟" : "姻亲姐妹"

	// Check if other is married to our child (son/daughter-in-law)
	for(var/datum/family_member/child in children)
		if(other in child.spouses)
			return other.person?.pronouns == HE_HIM ? "女婿" : "儿媳"

	return null

/datum/family_member/proc/AreSiblings(datum/family_member/other)
	if(!other || other == src)
		return FALSE
	if(!parents.len || !other.parents.len)
		return FALSE

	// Check if they share at least one parent
	for(var/datum/family_member/my_parent in parents)
		if(my_parent in other.parents)
			return TRUE
	return FALSE

/datum/family_member/proc/GetAuntUncleRelation(datum/family_member/other)
	// Check if other is aunt/uncle of src (sibling of parent)
	for(var/datum/family_member/parent in parents)
		if(other.AreSiblings(parent) && other != parent)
			return other.person?.pronouns == HE_HIM ? "叔伯" : "姑姨"
	return null

/datum/family_member/proc/GetNieceNephewRelation(datum/family_member/other)
	// Check if other is niece/nephew of src (child of sibling)
	for(var/datum/family_member/sibling in family.members)
		if(AreSiblings(sibling) && (sibling != src) && (other in sibling.children))
			return other.person?.pronouns == HE_HIM ? "侄辈" : "侄女"
	return null


/datum/family_member/proc/GetGrandparentRelation(datum/family_member/other)
	// Check if other is grandparent of src
	for(var/datum/family_member/parent in parents)
		if(other in parent.parents)
			if(other.person?.pronouns == HE_HIM)
				return "祖父"
			else
				return "祖母"
	return null

/datum/family_member/proc/GetGrandchildRelation(datum/family_member/other)
	// Check if other is grandchild of src
	for(var/datum/family_member/child in children)
		if(other in child.children)
			if(other.person?.pronouns == HE_HIM)
				return "孙子"
			else
				return "孙女"
	return null


/datum/family_member/proc/GetCousinRelation(datum/family_member/other)
	// First cousins: their parents are siblings
	for(var/datum/family_member/my_parent in parents)
		for(var/datum/family_member/their_parent in other.parents)
			if(my_parent.AreSiblings(their_parent))
				return "堂表亲"

	// Second cousins, etc. could be added here
	return null


/datum/family_member/proc/GetGreatRelation(datum/family_member/other)
	// Great-grandparent: parent of grandparent
	for(var/datum/family_member/parent in parents)
		for(var/datum/family_member/grandparent in parent.parents)
			if(other in grandparent.parents)
				if(other.person?.pronouns == HE_HIM)
					return "曾祖父"
				else
					return "曾祖母"

	// Great-grandchild: child of grandchild
	for(var/datum/family_member/child in children)
		for(var/datum/family_member/grandchild in child.children)
			if(other in grandchild.children)
				if(other.person?.pronouns == HE_HIM)
					return "曾孙"
				else
					return "曾孙女"

	return null

/datum/heritage/New(mob/living/carbon/human/founder_person, new_name, majority_species)
	if(majority_species)
		dominant_species = majority_species
		var/datum/species/S = new majority_species()
		dominant_race = S.name

	if(founder_person)
		founder = CreateFamilyMember(founder_person)
		founder.generation = 0

		if(!new_name)
			housename = SurnameFormatting(founder_person)
		else
			housename = new_name

		dominant_race = founder_person?.dna?.species?.name
		if(!dominant_species)
			dominant_species = founder_person?.dna?.species?.type

/datum/heritage/proc/CreateFamilyMember(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null

	// Check if already in family
	for(var/datum/family_member/existing in members)
		if(existing.person == person)
			return existing

	var/datum/family_member/new_member = new(person, src)
	members += new_member
	person?.family_datum = src

	AddFamilyIcon(person)
	LateJoinAddToUI(person)

	return new_member

/datum/heritage/proc/AddToFamily(mob/living/carbon/human/person, datum/family_member/parent1, datum/family_member/parent2, adopt = FALSE)
	var/datum/family_member/new_member = CreateFamilyMember(person)
	if(!new_member)
		return FALSE

	new_member.adoption_status = adopt

	if(parent1)
		new_member.AddParent(parent1)
	if(parent2)
		new_member.AddParent(parent2)

	// Handle biological inheritance
	if(!adopt && parent1 && parent2)
		if(SpeciesCalculation(person, parent1.person, parent2.person))
			person?.MixDNA(parent1.person, parent2.person, override = TRUE)
		else
			new_member.adoption_status = TRUE

	to_chat(person, span_notice("我已被纳入[housename]家族。"))
	InheritCurses(new_member)
	return new_member

/datum/heritage/proc/MarryMembers(datum/family_member/person1, datum/family_member/person2)
	if(!person1 || !person2)
		return FALSE

	// Check if already married to each other
	if(person2 in person1.spouses)
		return FALSE

	person1.AddSpouse(person2)

	// Only call MarryTo if it exists and won't cause loops
	if(person1.person && person2.person)
		// Instead of calling MarryTo which might have loops, handle name change here
		// or make sure MarryTo doesn't call back to family system
		// person1.person?.MarryTo(person2.person)
		pass()

	to_chat(person1.person, span_love("我现在已经与[person2.person?.real_name]结为夫妻了！"))
	to_chat(person2.person, span_love("我现在已经与[person1.person?.real_name]结为夫妻了！"))

	return TRUE

/datum/heritage/proc/GetFamilyMember(mob/living/carbon/human/person)
	for(var/datum/family_member/member in members)
		if(member.person == person)
			return member
	return null

/datum/heritage/proc/ReturnRelation(mob/living/carbon/human/lookee, mob/living/carbon/human/looker)
	if(lookee == looker)
		return null

	var/datum/family_member/looker_member = GetFamilyMember(looker)
	var/datum/family_member/lookee_member = GetFamilyMember(lookee)

	if(!looker_member || !lookee_member)
		return null

	var/relationship = looker_member.GetRelationshipTo(lookee_member)
	if(!relationship)
		return null

	var/p_He = lookee.p_they(TRUE)
	var/relationship_text = "[p_He]是我的[relationship]"

	if(lookee_member.adoption_status && (relationship in list("son", "daughter", "child")))
		relationship_text += "（收养）"

	return span_love(span_bold("[relationship_text]."))

/datum/heritage/proc/FormatFamilyList(checker)
	var/household = uppertext(housename)
	var/house_title = "[household] 家族"
	. = "<center>[household ? house_title : "无名家族"]：</center><BR>"
	. += "-----<br>"

	// Sort by generation
	var/list/by_generation = list()
	for(var/datum/family_member/member in members)
		var/gen = member.generation
		if(!by_generation["[gen]"])
			by_generation["[gen]"] = list()
		by_generation["[gen]"] += member

	// Display by generation
	for(var/gen_text in by_generation)
		var/gen_num = text2num(gen_text)
		var/gen_name = GetGenerationName(gen_num)
		. += "<B>[gen_name]:</B><BR>"

		for(var/datum/family_member/member in by_generation[gen_text])
			var/status_text = ""
			var/datum/family_member/checker_member = GetMemberForPerson(checker)
			var/relation_text = ""
			var/name_color = "9370DB"
			if(checker_member)
				relation_text = checker_member.GetRelationshipTo(member)
				switch(relation_text)
					if("父亲", "母亲")
						name_color = "4169E1"
					if("儿子", "女儿")
						name_color = "32CD32"
					if("兄弟", "姐妹")
						name_color = "FFD700"
					if("丈夫", "妻子")
						name_color = "FF69B4"
			if(member.adoption_status)
				status_text = "（收养）"
			if(member.spouses.len)
				var/spouse_names = ""
				for(var/datum/family_member/spouse in member.spouses)
					if(spouse_names)
						spouse_names += ", "
					spouse_names += spouse.person?.real_name
				status_text += "（配偶：[spouse_names]）"
			relation_text = uppertext(relation_text)

			. += "<B><font color=#[name_color];text-shadow:0 0 10px #8d5958, 0 0 20px #8d5958, 0 0 30px #8d5958, 0 0 40px #8d5958, 0 0 50px #e60073, 0 0 60px #8d5958, 0 0 70px #8d5958;>\
				[member.person?.real_name]</font></B> <B>[relation_text]</B> [status_text]<BR>"
		. += "<BR>"

	. += "----------<br>"

/datum/heritage/proc/GetMemberForPerson(mob/living/carbon/human/P)
	for(var/datum/family_member/member in members)
		if(member.person == P)
			return member
	return null

/datum/heritage/proc/GetGenerationName(generation)
	switch(generation)
		if(0)
			return "开创者"
		if(1)
			return "第一代"
		if(2)
			return "第二代"
		if(3)
			return "第三代"
		if(4)
			return "第四代"
		else
			return "第[generation]代"

/datum/heritage/proc/ListFamily(mob/living/carbon/human/checker)
	if(!checker)
		return
	if(!members.len)
		return
	var/contents = FormatFamilyList(checker)
	var/datum/browser/popup = new(checker, "FAMILYDISPLAY", "", 300, 500)
	popup.set_content(contents)
	popup.open()

/datum/heritage/proc/SpeciesCalculation(mob/living/carbon/human/child, mob/living/carbon/human/parent1, mob/living/carbon/human/parent2)
	var/datum/species/child_species = child.dna?.species
	var/datum/species/dad_species = parent1.dna?.species
	var/datum/species/mom_species = parent2.dna?.species

	if(!child_species || !dad_species || !mom_species)
		return FALSE

	var/list/mixes = list(
		"human+elf+" = /datum/species/human/halfelf,
		"human+horc+" = /datum/species/halforc,
	)

	var/mix_text = ""

	// Straightforward basic parentage
	if(istype(dad_species, mom_species))
		if(istype(child_species, dad_species))
			return TRUE

	// Build mix string
	if(istype(dad_species, /datum/species/human/northern) || istype(mom_species, /datum/species/human/northern))
		mix_text += "human+"
	if(istype(dad_species, /datum/species/elf/dark) || istype(mom_species, /datum/species/elf/dark))
		mix_text += "darkelf+"
	if(istype(dad_species, /datum/species/dwarf/mountain) || istype(mom_species, /datum/species/dwarf/mountain))
		mix_text += "dwarf+"
	if(istype(dad_species, /datum/species/tieberian) || istype(mom_species, /datum/species/tieberian))
		mix_text += "tiefling+"

	if(istype(child_species, mixes[mix_text]))
		return TRUE

	return FALSE

/datum/heritage/proc/SurnameFormatting(mob/living/carbon/human/person)
	var/surname2use
	var/index = findtext(person?.real_name, " ")
	person?.original_name = person?.real_name
	if(!index)
		surname2use = person?.dna?.species?.random_surname()
	else
		if(findtext(person?.real_name, " of ") || findtext(person?.real_name, " the "))
			surname2use = person?.dna?.species?.random_surname()
		else
			surname2use = copytext(person?.real_name, index)
	return surname2use

/datum/heritage/proc/ApplyUI(mob/living/carbon/human/iconer, toggle_true = FALSE)
	if(!iconer.client)
		return FALSE
	for(var/mob/living/carbon/human/H in family_icons)
		if(toggle_true)
			iconer.client.images.Remove(family_icons[H])
			continue
		if(!H || H == iconer)
			continue
		iconer.client.images.Add(family_icons[H])

/datum/heritage/proc/LateJoinAddToUI(mob/living/carbon/human/new_fam)
	for(var/datum/family_member/member in members)
		var/mob/living/carbon/human/H = member.person
		if(H && H.family_UI && H.client && H != new_fam)
			if(new_fam in family_icons)
				H.client.images.Add(family_icons[new_fam])

/datum/heritage/proc/AddFamilyIcon(mob/living/carbon/human/famicon)
	var/datum/family_member/member = GetFamilyMember(famicon)
	if(!member)
		return FALSE

	var/icon_state = member.adoption_status ? "adopted" : "related"
	var/image/I = new('icons/relations.dmi', loc = famicon, icon_state = icon_state)

	if(famicon in family_icons)
		family_icons.Remove(famicon)
	family_icons[famicon] = I

	return TRUE

/mob/living/carbon/human/verb/ReturnFamilyList()
	set name = "查看家族"
	set category = "IC"
	if(spouse_mob)
		var/role = spouse_mob.mind?.assigned_role
		var/title = role
		if(istype(role, /datum/job))
			var/datum/job/J = role
			title = J.get_informed_title(spouse_mob)
		to_chat(src, span_info("[spouse_mob.real_name]，那位[spouse_mob.dna.species.name]的[title]，是我的爱人。"))
	if(family_datum)
		family_datum.ListFamily(src)
	else
		to_chat(src, "我并不属于任何显赫家族。")

/mob/living/carbon/human/verb/ToggleFamilyUI()
	set name = "家族界面"
	set category = "IC"
	ShowFamilyUI(FALSE)

/mob/living/carbon/human/proc/ShowFamilyUI(silent)
	if(spouse_mob)
		ApplySpouseUI(family_UI)
	if(family_datum)
		family_datum.ApplyUI(src, family_UI)
	else if(!silent)
		to_chat(src, "我并不属于任何显赫家族。")

	family_UI = !family_UI

	if(!silent)
		to_chat(src, "家族界面已切换为[family_UI ? "开启" : "关闭"]。")

/mob/living/carbon/human/proc/ApplySpouseUI(toggle_true = FALSE)
	if(!spouse_mob || !client)
		return
	if(!spouse_indicator)
		spouse_indicator = new('icons/relations.dmi', loc = spouse_mob, icon_state = "related")
	if(toggle_true)
		client.images.Remove(spouse_indicator)
		return
	client.images.Add(spouse_indicator)
