/turf
	///Default probatility of leaving a track when entering this turf
	var/track_prob = 0

//Base probabilities to leave a track.
/turf/open/floor/rogue/dirt
	track_prob = 10

/turf/open/floor/rogue/grass
	track_prob = 10

/turf/open/floor/rogue/grassyel
	track_prob = 10

/turf/open/floor/rogue/grassred
	track_prob = 10

/turf/open/floor/rogue/grasscold
	track_prob = 10

/turf/open/floor/rogue/snow
	track_prob = 20

/turf/open/floor/rogue/AzureSand
	track_prob = 20

/turf/open/floor/rogue/snowrough
	track_prob = 10

/turf/open/floor/carpet
	track_prob = 10

/turf/open/floor/rogue/wood
	track_prob = 5

/turf/open/floor/rogue/dirt/road
	track_prob = 10

/turf/open/floor/rogue/concrete
	track_prob = 5

/turf/open/floor/rogue/rooftop
	track_prob = 10

/turf/open/floor/rogue/cobble
	track_prob = 3

/turf/open/floor/rogue/blocks
	track_prob = 10

/turf/open/floor/rogue/tile/bath
	track_prob = 20

/turf/open/floor/rogue/tile
	track_prob = 10

/turf/open/floor/rogue/hexstone
	track_prob = 10

/turf/open/floor/rogue/churchmarble
	track_prob = 5

/turf/open/floor/rogue/churchbrick
	track_prob = 5

/turf/open/floor/rogue/cobblerock
	track_prob = 10

//Probabilities end (albeit mud is handled seperately).

//For highlighting tracks
/mob/living/carbon/human
	var/mob/living/current_mark

//Analysis levels depending on skillcheck during reveal.
#define ANALYSIS_TERRIBLE 1
#define ANALYSIS_BAD 2
#define ANALYSIS_DECENT 3
#define ANALYSIS_GOOD 4
#define ANALYSIS_PERFECT 5

/obj/effect/track
	name = "\improper 痕迹"
	desc = null
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_MAXIMUM
	icon = 'modular_hearthstone/icons/obj/effects/track.dmi' //This sucks, but too bad!
	///The visible state for those that know this.
	var/real_icon_state = "tracks"
	///The image knowers see.
	var/real_image
	///List of mobs aware of this track.
	var/list/mob/living/known_by = list()
	///When this was created. Adjusts difficulty of locating / analyzing.
	var/creation_time = 0
	///What kind of foot, or footwear, created this.
	var/track_type = "不明足迹"
	///Like above, except what you get if you are not good.
	var/ambiguous_track_type = "鞋类痕迹"
	///The way the mob was facing when this was created. Obviously can be messed with if you e.g. walk backwards.
	var/facing = "无从判断"
	///If the depth of the tracks is abnormal, e.g. because of heavy armor.
	var/depth
	///If the creator was moving in a special way, e.g. running / sneaking. Difficult to discern.
	var/special_movement
	///The exact mob that created this. Only used to see if the spotter can notice their own tracks (fairly easy)
	var/mob/living/creator
	///Some things may be easier or harder to track. This adjusts the base difficulty accordingly.
	var/tracking_modifier = 0
	///Tracks how many tracks have been chain-overwritten before this track. Could indicate a commonly passed area.
	var/overwrites = 0
	///The world.time when this track should expire (used by subsystem)
	var/expiry_time
	///For determining if it's been highlighted for marked person purposes
	var/list/highlighted = list()
	///A preserved dir for the highlights
	var/original_dir
	///Whether this track allows its owner to be Marked
	var/markable = TRUE
	///Base difficulty for noticing these tracks
	var/base_diff = 11

/obj/effect/track/Initialize(mapload)
	. = ..()
	real_image = image(icon, src, real_icon_state, ABOVE_OPEN_TURF_LAYER) //Default image in case manually created.

/obj/effect/track/Destroy(force)
	real_image = null
	for(var/knowing_one as anything in known_by)
		remove_knower(knowing_one)
	if(creator)
		clear_creator_reference(creator)
	known_by = null
	SStracks.remove_track(src)
	return ..()

/// Resets track state for reuse from pool - called before recycling
/obj/effect/track/proc/soft_reset()
	// Clear all knowers
	for(var/knowing_one as anything in known_by)
		remove_knower(knowing_one)
	known_by = list()

	// Clear creator reference
	if(creator)
		clear_creator_reference(creator)
	creator = null

	// Reset variables to defaults
	creation_time = 0
	expiry_time = 0
	track_type = "不明足迹"
	ambiguous_track_type = "鞋类痕迹"
	facing = "无从判断"
	depth = null
	special_movement = null
	tracking_modifier = 0
	overwrites = 0
	LAZYCLEARLIST(highlighted)
	original_dir = null
	markable = TRUE

	// Reset image
	real_image = null
	real_icon_state = initial(real_icon_state)

/obj/effect/track/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_info("你开始掩盖这些痕迹……"))
	if(!do_after(user, 4 SECONDS, target = src))
		return
	to_chat(user, span_warning("现在应该没人能再循着这些痕迹追踪了……"))
	qdel(src)
	return TRUE

///Handles checks for if a mob can reveal this. Also returns FALSE if already known to mob.
/obj/effect/track/proc/check_reveal(mob/living/user)
	if(user in known_by)
		return FALSE
	var/success = FALSE
	if(!HAS_TRAIT(user, TRAIT_PERFECT_TRACKER))
		var/diff = base_diff //Base Tracking Difficulty
		diff += tracking_modifier
		diff += round((world.time - creation_time) / (60 SECONDS), 1) //Gets more difficult to spot the older.
		diff += rand(0, 5) //Entropy.

		var/competence = user.STAPER
		if(user.mind)
			competence += 2 * user.get_skill_level(/datum/skill/misc/tracking)

		if(competence >= diff)
			success = TRUE
		else if(diff - competence < 5)
			success = prob((100 - ((diff - competence) * 20)))
	else
		success = TRUE
	if(success && user.mind && creator != user)
		user.mind.add_sleep_experience(/datum/skill/misc/tracking, (user.STAINT*2))
	return success

///Handles revealing the track, including checking how well the tracker can analyze it.
/obj/effect/track/proc/handle_revealing(mob/living/user)
	//Second layer of skill check: How much knowledge you get.
	var/analysis_result = 0
	if(!HAS_TRAIT(user, TRAIT_PERFECT_TRACKER))
		var/diff = 0
		diff += tracking_modifier
		diff += round((world.time - creation_time) / (60 SECONDS), 1)
		var/competence = abs(user.STAPER - 5)
		if(user.mind)
			competence += 5 * user.get_skill_level(/datum/skill/misc/tracking) //Skill is much more relevant for analysis.
		switch(competence - diff)
			if(30 to INFINITY)
				analysis_result = ANALYSIS_PERFECT
			if(20 to 29)
				analysis_result = ANALYSIS_GOOD
			if(10 to 19)
				analysis_result = ANALYSIS_DECENT
			if(0 to 9)
				analysis_result = ANALYSIS_BAD
			if(-INFINITY to 0)
				analysis_result = ANALYSIS_TERRIBLE
	else
		analysis_result = ANALYSIS_PERFECT
	add_knower(user, analysis_result)

//Handles value settings done for a track that need to be done.
/obj/effect/track/proc/handle_creation(mob/living/track_source)
	creator = track_source
	RegisterSignal(track_source, COMSIG_PARENT_QDELETING, PROC_REF(clear_creator_reference), TRUE)
	creation_time = world.time
	track_source.get_track_info(src)
	if(track_source.m_intent == MOVE_INTENT_SNEAK)
		special_movement = "留下这些痕迹的人似乎一直在潜行……"
	else if(track_source.m_intent == MOVE_INTENT_RUN)
		special_movement = "留下这些痕迹的人似乎当时在奔跑！"
	switch(track_source.dir)
		if(NORTH)
			facing = "北方"
		if(SOUTH)
			facing = "南方"
		if(EAST)
			facing = "东方"
		if(WEST)
			facing = "西方"
		if(NORTHWEST)
			facing = "西北方"
		if(NORTHEAST)
			facing = "东北方"
		if(SOUTHWEST)
			facing = "西南方"
		if(SOUTHEAST)
			facing = "东南方"
	real_image = image(icon, src, real_icon_state, ABOVE_OPEN_TURF_LAYER, track_source.dir) //Recreate image with correct dir.
	original_dir = track_source.dir
	expiry_time = world.time + 15 MINUTES //Tracks naturally expire after 15 minutes
	SStracks.add_track(src)

///Adds a new person to the list of people who can see this track.
/obj/effect/track/proc/add_knower(mob/living/tracker, competence = 1)
	known_by[tracker] = competence
	if(ishuman(tracker))
		var/mob/living/carbon/human/H = tracker
		if(HAS_TRAIT(tracker, TRAIT_SLEUTH) && H.current_mark == creator)
			if(!(tracker in highlighted))
				real_icon_state = "tracks_marked"
				real_image = image(icon, src, real_icon_state, ABOVE_OPEN_TURF_LAYER, original_dir)
				LAZYADD(highlighted, tracker)
		if(tracker.client)
			tracker.client.images += real_image
	RegisterSignal(tracker, COMSIG_PARENT_QDELETING, PROC_REF(remove_knower), override = TRUE)

///Removes a knower from the known ones. Usually only done when qdeleted.
/obj/effect/track/proc/remove_knower(mob/living/tracker)
	SIGNAL_HANDLER
	UnregisterSignal(tracker, COMSIG_PARENT_QDELETING)
	if(tracker.client)
		tracker.client.images -= real_image
	LAZYREMOVE(highlighted, tracker)
	known_by -= tracker
	if(creator == tracker)
		creator = null

///Clears the reference to the creator. Is replaced by the above proc if the creator analyzes it.
/obj/effect/track/proc/clear_creator_reference(mob/living/creator_arg)
	SIGNAL_HANDLER
	UnregisterSignal(creator, COMSIG_PARENT_QDELETING)
	creator = null

///Called when the track's time expires, at which point it becomes indistinguishable (aka, deleted)
/obj/effect/track/proc/track_expire()
	qdel(src)

/obj/effect/track/examine(mob/user)
	. = ..()
	var/knowledge = known_by[user]
	if(!knowledge)
		return //Huh?
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!isnull(H.current_mark))
			if(H.current_mark == creator && !(H in highlighted))
				real_icon_state = "tracks_marked"
				real_image = image(icon, src, real_icon_state, ABOVE_OPEN_TURF_LAYER, original_dir)
				LAZYADD(highlighted, H)
				if(H.client)
					H.client.images += real_image
	. += knowledge_readout(user, knowledge)

/obj/effect/track/proc/knowledge_readout(mob/user, knowledge)
	if(knowledge >= ANALYSIS_DECENT)
		. += "看起来像是一些[track_type]。<br>"
	else
		. += "看起来像是一些[ambiguous_track_type]。<br>"
	. += "这些痕迹通向[facing]。<br>"
	if(knowledge > ANALYSIS_DECENT)
		var/timepassed = ((world.time - creation_time) * SSticker.station_time_rate_multiplier)
		var/timetext = ""
		var/realtime = round((world.time - creation_time) / 600, 1)
		if(timepassed >= 36000)
			timetext = "[round(timepassed / 36000)]小时"
		else
			timetext = "[round(timepassed / 600)]分钟"
		. += "这些痕迹大约留下了[timetext]。 <i>（现实时间[realtime]分钟）</i><br>"
		if(depth)
			. += "这些痕迹[depth]！<br>"
	if(knowledge > ANALYSIS_GOOD && special_movement)
		. += "[span_danger("[special_movement]")]<br>"
	if(knowledge > ANALYSIS_TERRIBLE && creator == user)
		. += "[span_nicegreen("这是你自己留下的痕迹！")]<br>"
	if(knowledge >= ANALYSIS_GOOD)
		if(overwrites > 10)
			. += "[span_warning("这里也残留着许多更早的痕迹……")]<br>"
		else if(overwrites >= 2)
			. += "[span_warning("这里也残留着大约[overwrites]道更早的痕迹……")]<br>"
		var/mob/living/carbon/human/H = user
		if(!isnull(H.current_mark) && H.current_mark == creator)
			. += span_nicegreen("这些痕迹属于你的标记目标。")
		if(H.get_skill_level(/datum/skill/misc/tracking) >= SKILL_LEVEL_EXPERT)
			. += span_nicegreen("<i><font size = 2>右键这些痕迹可标记它们的主人。</font></i>")
	return .

///Gets special info for a track relative to a mob, such as type and depth. Override if desiring tracking modifier adjustment.
/mob/living/proc/get_track_info(obj/effect/track/this_track)
	var/mob/living/prototype = type
	this_track.track_type = "[initial(prototype.name)]的足迹" //Lets not mess with someone naming their mob.
	this_track.ambiguous_track_type = "野兽足迹" //Override proc if your mob has weird tracks.

/mob/living/carbon/human/get_track_info(obj/effect/track/this_track)
	if(istype(this_track,/obj/effect/track/structure))
		var/holding = get_active_held_item()
		var/obj/effect/track/structure/this = this_track
		var/weapon
		if(holding)
			if(istype(holding,/obj/item/rogueweapon))
				var/static/list/weapon_types = list(/obj/item/rogueweapon/sword, /obj/item/rogueweapon/mace, /obj/item/rogueweapon/spear, /obj/item/rogueweapon/greatsword, /obj/item/rogueweapon/pick, /obj/item/rogueweapon/huntingknife/idagger, /obj/item/rogueweapon/whip, /obj/item/lockpick)
				for(var/type in weapon_types)
					if(istype(holding, type))
						var/obj/item/rogueweapon/found = type
						weapon = initial(found.name)

			if(weapon)
				this.tool_used_ambiguous = weapon
			var/obj/item/I = holding
			var/skill = I.associated_skill
			this.tool_used = I.name
			if(skill)
				this.skill_level = get_skill_level(skill)
	else
		if(!(mobility_flags & MOBILITY_STAND)) //Either pulled or crawling.
			this_track.track_type = "拖拽痕"
			this_track.track_type = "拖拽痕"
		else
			if(shoes && (shoes.body_parts_covered & FEET))
				this_track.track_type = "[shoes.name]留下的痕迹"
				this_track.ambiguous_track_type = "鞋类痕迹"
			else
				this_track.track_type = "[dna.species.name]脚印" //Look, I am not going to track the species of every single leg you do surgical malpractice with, so this will do.
				this_track.ambiguous_track_type = "类人脚印"

		var/bonus_weight = 0
		if(wear_armor)
			switch(wear_armor.armor_class)
				if(ARMOR_CLASS_HEAVY)
					bonus_weight += 1
				if(ARMOR_CLASS_MEDIUM)
					bonus_weight = 0.5
				else
		if(wear_shirt)
			switch(wear_shirt.armor_class)
				if(ARMOR_CLASS_HEAVY)
					bonus_weight += 1
				if(ARMOR_CLASS_MEDIUM)
					bonus_weight = 0.5
				else
		switch(bonus_weight)
			if(2 to INFINITY)
				this_track.depth = "非常深"
			if(1 to 2)
				this_track.depth = "很深"
			else
	return //This is needed at the moment.

//Checks if the mob should create a track, and creates one if the case (potentially replacing older tracks on the turf)
/mob/living/proc/check_track_creation(turf/new_turf)
	if(!new_turf)
		return //Guh?
	if(isnull(mind))
		return
	if(!(movement_type & GROUND) || (movement_type & (FLOATING|FLYING))) //For some reason some mobs have both ground and flying at once.
		return
	var/probability = round(track_creation_prob(new_turf), 0.1)
	if(!probability)
		return
	if(!prob(probability))
		return
	var/obj/effect/track/old_track = locate() in new_turf
	var/obj/effect/track/new_track = SStracks.get_track(/obj/effect/track, new_turf)
	if(old_track)
		new_track.overwrites = 1 + old_track.overwrites
		SStracks.recycle_track(old_track) // Recycle instead of qdel
	new_track.handle_creation(src)

//Gets the probability of this mob to create a track on the passed turf.
/mob/living/proc/track_creation_prob(turf/new_turf)
	. = new_turf.track_prob
	if(!.)
		return 0
	if(m_intent == MOVE_INTENT_SNEAK)
		var/remaining_mod = 0.7
		if(mind)
			remaining_mod -= 0.1 * get_skill_level(/datum/skill/misc/sneaking)
		. *= remaining_mod
	else if(m_intent == MOVE_INTENT_RUN)
		. *= 3

/mob/living/carbon/human/track_creation_prob(turf/new_turf)
	. = ..()
	if(!.)
		return
	var/bonus_weight = 0
	if(wear_armor)
		switch(wear_armor.armor_class)
			if(ARMOR_CLASS_HEAVY)
				bonus_weight += 0.5
			if(ARMOR_CLASS_MEDIUM)
				bonus_weight = 0.25
			else
	if(wear_shirt)
		switch(wear_shirt.armor_class)
			if(ARMOR_CLASS_HEAVY)
				bonus_weight += 0.5
			if(ARMOR_CLASS_MEDIUM)
				bonus_weight = 0.25
	if(bonus_weight)
		. *= (1 + bonus_weight)

/obj/effect/track/structure
	name = "线索"
	real_icon_state = "tracks_structure"
	markable = FALSE
	var/skill_level
	var/tool_used
	var/tool_used_ambiguous
	var/is_silver

/obj/effect/track/structure/soft_reset()
	..()
	skill_level = null
	tool_used = null
	tool_used_ambiguous = null
	is_silver = null

/obj/effect/track/structure/handle_creation(mob/living/track_source)
	creator = track_source
	RegisterSignal(track_source, COMSIG_PARENT_QDELETING, PROC_REF(clear_creator_reference))
	creation_time = world.time
	track_source.get_track_info(src)
	real_image = image(icon, src, real_icon_state, ABOVE_OPEN_TURF_LAYER, track_source.dir)
	expiry_time = world.time + 15 MINUTES
	SStracks.add_track(src)

/obj/effect/track/structure/knowledge_readout(mob/user, knowledge)
	if(tool_used_ambiguous)
		. += "看起来像是某种<font color = '#0d5381'>[tool_used_ambiguous]</font>留下的痕迹<br>"
	else if(!tool_used)
		. += "我完全看不出这是什么弄坏的。"
	if(knowledge > ANALYSIS_TERRIBLE && creator == user)
		. += "[span_nicegreen("这是你自己留下的痕迹！")]<br>"
	if(knowledge < ANALYSIS_DECENT)
		return .
	if(knowledge > ANALYSIS_DECENT)
		var/timepassed = ((world.time - creation_time) * SSticker.station_time_rate_multiplier)
		var/timetext = ""
		var/realtime = round((world.time - creation_time) / 600, 1)
		if(timepassed >= 36000)
			timetext = "[round(timepassed / 36000)]小时"
		else
			timetext = "[round(timepassed / 600)]分钟"
		. += "这些痕迹大约留下了[timetext]。 <i>（现实时间[realtime]分钟）</i><br>"
	if(knowledge >= ANALYSIS_GOOD)
		if(skill_level)
			. += "此人对这件物品的熟练度为<font color = '#ebebeb'>[SSskills.level_names_plain[skill_level]]</font>。<br>"
	if(knowledge >= ANALYSIS_PERFECT)
		. += "这看起来像是<font color = '#5ca2d1'>[tool_used]</font>留下的独特痕迹。<br>"
	return .

/obj/effect/track/structure/attack_right(mob/user)
	to_chat(user,span_info("你无法从这样的物体上分辨出什么。"))
	return

/obj/effect/track/attack_right(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_skill_level(/datum/skill/misc/tracking) > SKILL_LEVEL_JOURNEYMAN)	//Expert+
			if(!markable)
				to_chat(H, span_warning("这些还不足以标记对方。我需要更完整的痕迹。"))
			to_chat(H, span_info("你开始记下此人的步态、体重和其他独特特征。"))
			if(do_after(user, (50 - H.STAPER*2)))
				H.current_mark = creator
				to_chat(H, span_warning("你已标记此人。若再发现新的痕迹，你会认出来。"))
		else
			to_chat(H, span_info("我的技巧还不够！（需要专家级）"))

/obj/effect/track/thievescant
	name = "刻下的符号"
	gender = PLURAL
	real_icon_state = "thieves_cant"
	markable = FALSE
	base_diff = 5 //Easier to notice
	var/message

/obj/effect/track/thievescant/soft_reset()
	..()
	message = null
	alpha = initial(alpha)

/obj/effect/track/thievescant/handle_creation(mob/living/track_source, thiefmessage)
	creator = track_source
	RegisterSignal(track_source, COMSIG_PARENT_QDELETING, PROC_REF(clear_creator_reference))
	creation_time = world.time
	track_source.get_track_info(src)
	real_image = image(icon, src, real_icon_state, BULLET_HOLE_LAYER, track_source.dir)
	alpha = 128
	message = thiefmessage
	// Thieves cant engravings persist much longer - 2 hours
	expiry_time = world.time + 2 HOURS
	SStracks.add_track(src)

/obj/effect/track/thievescant/knowledge_readout(mob/user, knowledge)
	if(!user.has_language(/datum/language/thievescant))
		. += "看起来像是一堆毫无意义的刻痕……"
	else
		. += "[creator == user ? "我" : "我的某位同道"]留下的一则刻文。内容是……<br>"
		. += "<font color = '#0d5381'>\"[message]\"</font>"

	return .

/obj/effect/track/thievescant/attack_right(mob/user)
	to_chat(user,span_info("你无法从这样的物体上分辨出什么。"))
	return

#undef ANALYSIS_TERRIBLE
#undef ANALYSIS_BAD
#undef ANALYSIS_DECENT
#undef ANALYSIS_GOOD
#undef ANALYSIS_PERFECT
