//All orthodoxists get miracles, as combination classes.
//Only Adjudicators get decent regen, at 0.5, with the rest at 0.1.
//Standard stat spread is 8 across the board. Broken up by classes that don't fit this.
/datum/job/roguetown/orthodoxist
	title = "Orthodoxist"
	flag = ORTHODOXIST
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_races = RACES_ALL_KINDS
	allowed_patrons = list(/datum/patron/old_god) //Requires your character's patron to be Psydon. This role is explicitly designed to be played by Psydonites, only, and almost everything they have - down to the equipment and statblock - is rooted in Psydonism. Do NOT make this accessable to other faiths, unless you go through the efforts of redesigning it from the ground up.
	tutorial = "赞美，赎罪，哀悼。百种人生，百条道路，终点却都相同: 你向 普赛顿 宣誓效忠，被纳入审判官的随从之列。把那些畸变者从他们藏身的每个角落里拔除出来，无论是握紧拳头，还是伸出手掌，都要把他们重新带回光中。"
	selection_color = JCOLOR_INQUISITION
	outfit = null
	outfit_female = null
	display_order = JDO_ORTHODOXIST
	min_pq = 20
	max_pq = null
	round_contrib_points = 2
	advclass_cat_rolls = list(CTAG_INQUISITION = 20)
	wanderer_examine = FALSE
	advjob_examine = TRUE
	give_bank_account = 15
	social_rank = SOCIAL_RANK_PEASANT
	job_traits = list(TRAIT_OUTLANDER, TRAIT_STEELHEARTED, TRAIT_INQUISITION)
	job_subclasses = list(
		/datum/advclass/psydoniantemplar,
		/datum/advclass/disciple,
		/datum/advclass/confessor,
		/datum/advclass/psyaltrist,
		/datum/advclass/arbalist,
		/datum/advclass/sojourner
	)
