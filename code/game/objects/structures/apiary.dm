/obj/effect/bees
	name = "蜜蜂"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "bee"
	pass_flags = PASSTABLE | PASSMOB

	var/atom/target
	var/obj/effect/bees/merge_target
	var/obj/structure/apiary/hive

	var/stored_pollen = 0
	var/bee_count = 1

	var/pollinating = FALSE
	var/turf/last_pollinated

	// Bee genetics variables
	var/bee_efficiency = 1.0 // Pollen collection multiplier
	var/bee_aggression = 0 // Chance to attack on disturbance (0-100)
	var/bee_lifespan = 1.0 // Lifespan multiplier
	var/bee_color = "#FFD700" // Bee color, default gold
	var/bee_disease_resistance = 1.0 // Resistance to disease

	// Aggression variables
	var/agitated = FALSE
	var/agitation_countdown = 0
	var/list/attacked_mobs = list() // Remember who we've attacked

	// Seasonal variables
	var/last_season_check = 0
	var/seasonal_activity = 1.0 // Modifier for bee activity

/obj/effect/bees/update_overlays()
	. = ..()
	cut_overlays()
	var/bee_spawn = bee_count - 1
	if(!bee_spawn)
		return

	for(var/i=1 to bee_spawn)
		var/mutable_appearance/bee = mutable_appearance(icon, icon_state)
		bee.pixel_x = rand(12, -12)
		bee.pixel_y = rand(12, -12)
		bee.color = bee_color // Apply genetic color
		overlays += bee

/obj/effect/bees/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	update_overlays()

/obj/effect/bees/process()
	// Handle movement and merging
	if(merge_target)
		var/turf/turf = get_step_towards2(src, merge_target)
		Move(turf, get_dir(src, turf))
		if(get_dist(merge_target, src) == 0)
			merge_target.bee_count += bee_count
			merge_target.update_overlays()
			merge_target = null
			hive?.bee_objects -= src
			qdel(src)
			return

	if(target)
		var/turf/turf = get_step_towards2(src, target)
		Move(turf, get_dir(src, turf))
		if(get_dist(target, src) == 0)
			if(istype(target, /obj/structure/apiary))
				enter_hive()
				return
			target = null
			try_pollinate()

	if(agitated)
		if(agitation_countdown > 0)
			agitation_countdown--
			attack_nearby_targets()
		else
			agitated = FALSE
			attacked_mobs.Cut()

/obj/effect/bees/proc/enter_hive()
	hive.bee_objects -= src
	hive.sleeping_bees += bee_count
	hive.outside_bees -= bee_count
	hive.pollen += stored_pollen
	hive.on_bee_enter(bee_count)
	hive = null
	target = null
	qdel(src)

/obj/effect/bees/proc/try_pollinate()
	if(pollinating)
		return TRUE
	if(last_pollinated == get_turf(src))
		return FALSE

	if(prob((1 - seasonal_activity) * 100))
		return FALSE

	var/turf/turf = get_turf(src)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in turf
	var/obj/structure/flora/roguegrass/herb/herb = locate(/obj/structure/flora/roguegrass/herb) in turf
	if(!soil && !herb)
		return FALSE

	pollinating = TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_pollinating), turf), (30 / (seasonal_activity * bee_efficiency)) SECONDS)

/obj/effect/bees/proc/finish_pollinating(turf/turf)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in turf
	soil?.pollination_time = 5 MINUTES
	pollinating = FALSE
	last_pollinated = get_turf(src)

	stored_pollen += rand(1, 2) * bee_count * bee_efficiency

	// Record what plant type was pollinated
	if(soil?.plant)
		var/plant_type = soil.plant.type
		if(hive && !isnull(hive))
			hive.record_pollen_source(plant_type)
	var/obj/structure/flora/roguegrass/herb/herb = locate(/obj/structure/flora/roguegrass/herb) in turf
	if(herb)
		if(hive && !isnull(hive))
			hive.record_pollen_source(herb.type)

	if(stored_pollen > (5 * bee_count))
		return_to_hive()

/obj/effect/bees/proc/return_to_hive()
	target = hive

/obj/effect/bees/proc/attack_nearby_targets()
	if(pollinating || merge_target)
		return

	var/attack_chance = (bee_aggression * seasonal_activity) / 100
	if(!prob(attack_chance))
		return

	for(var/mob/living/carbon/human/H in view(1, src))
		if(is_wearing_bee_protection(H))
			continue
		if(attacked_mobs[H])
			continue

		attack_mob(H)
		break

/obj/effect/bees/proc/attack_mob(mob/living/carbon/human/H)
	var/obj/item/bodypart/affecting = H.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD))

	H.visible_message("<span class='danger'>[src]蜇了[H]的[affecting.name]！</span>", \
					  "<span class='userdanger'>你的[affecting.name]传来一阵尖锐的刺痛！</span>")

	H.adjustToxLoss(1)

	// Apply reagent (bee venom)
	H.reagents.add_reagent(/datum/reagent/toxin/venom, 2)
	attacked_mobs[H] = TRUE

	// Agitate more bees nearby
	for(var/obj/effect/bees/B in view(3, src))
		if(prob(50))
			B.agitate(H, 30)

/obj/effect/bees/proc/agitate(mob/target, duration)
	agitated = TRUE
	agitation_countdown = duration

	if(target)
		attacked_mobs[target] = TRUE

/proc/is_wearing_bee_protection(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE

	// Check for bee protection items
	var/head_protected = FALSE
	var/body_protected = FALSE

	// Check head slot for beekeeper hat or similar
	var/obj/item/clothing/head/head_item = H.get_item_by_slot(SLOT_HEAD)
	if(head_item && (head_item.flags_cover & HEADCOVERSMOUTH))
		head_protected = TRUE

	// Check suit slot for beekeeper suit or similar
	var/obj/item/clothing/suit/roguetown/armor/suit_item = H.get_item_by_slot(SLOT_ARMOR)
	if(suit_item &&  (suit_item.body_parts_covered & CHEST))
		body_protected = TRUE

	return head_protected && body_protected



/obj/structure/apiary/starter
	bee_count = 5
	stored_combs = 0
	comb_progress = 0

/obj/structure/apiary/starter/Initialize(mapload)
	. = ..()
	create_new_queen()

/obj/structure/apiary
	name = "蜂箱"
	desc = "一座饲养蜜蜂、产蜜并为植物授粉的设施。"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "beebox-empty"

	var/stored_combs = 0
	var/outside_bees = 0
	var/sleeping_bees = 0

	var/bee_count = 0
	var/max_bees = 30

	var/list/bee_objects = list()

	var/comb_progress = 0
	var/pollen = 0

	// Queen bee system
	var/obj/item/queen_bee/queen_bee = null
	var/queen_maturity = 0 // Progress towards creating a new queen
	var/queen_deceased = FALSE // If true, bees will slowly die off without a queen

	// Disease system
	var/has_disease = FALSE
	var/disease_type = null
	var/disease_severity = 0 // 0-100 scale
	var/disease_progression = 0
	var/treatment_progress = 0

	// Swarm mechanics
	var/swarm_progress = 0
	var/can_swarm = TRUE
	var/last_swarm_time = 0

	// Honey types system
	var/list/pollen_sources = list() // Tracks which plants were pollinated
	var/list/honey_types = list(
		"default" = /obj/item/reagent_containers/food/snacks/rogue/honey,
		"addictive" = /obj/item/reagent_containers/food/snacks/rogue/honey/healing,
	)



/obj/structure/apiary/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/apiary/update_icon_state()
	if(stored_combs > 0)
		icon_state = "beebox-full"
	else
		icon_state = "beebox-empty"

/obj/structure/apiary/process()
	if(QDELETED(queen_bee))
		queen_bee = null

	process_comb_gain()

	if((outside_bees + bee_count) < max_bees)
		try_create_bees()

	if(bee_count)
		try_send_bees_out()

	process_bee_objects()

	if(has_disease)
		process_disease()

	check_for_disease()

	if(!queen_bee)
		if(!queen_deceased)
			queen_deceased = TRUE

		if(bee_count > 0 && prob(5))
			bee_count--


		if(bee_count >= 10 && pollen >= 50 && stored_combs >= 2 && !queen_deceased)
			queen_maturity += 0.2
			if(queen_maturity >= 100)
				create_new_queen()
	else
		if((outside_bees + bee_count) < max_bees && prob(30))
			try_create_bees()


	if(bee_count > (max_bees * 0.8) && queen_bee && can_swarm)
		process_swarm()

/obj/structure/apiary/attack_hand(mob/user)
	if(queen_bee && user.a_intent == INTENT_HELP && is_wearing_bee_protection(user))
		user.visible_message("[user]小心翼翼地把手伸进了[src]。", "你小心地从[src]中取出了蜂后。")

		if(!do_after(user, 5 SECONDS, src))
			return

		var/obj/item/queen_bee/extracted_queen = new(get_turf(src))
		// Transfer queen stats
		extracted_queen.bee_efficiency = queen_bee.bee_efficiency
		extracted_queen.bee_aggression = queen_bee.bee_aggression
		extracted_queen.bee_lifespan = queen_bee.bee_lifespan
		extracted_queen.bee_color = queen_bee.bee_color
		extracted_queen.bee_disease_resistance = queen_bee.bee_disease_resistance
		extracted_queen.queen_age = queen_bee.queen_age
		extracted_queen.queen_health = queen_bee.queen_health

		user.put_in_hands(extracted_queen)
		queen_bee = null

		agitate_bees(80, user)
		return

	// Default honey collection
	if(!stored_combs)
		return ..()

	var/safe_handling = is_wearing_bee_protection(user)

	// Check for aggression based on queen traits
	if(!safe_handling && queen_bee && prob(queen_bee.bee_aggression))
		agitate_bees(80, user)
		return

	user.visible_message("[user]开始从[src]中收取蜂巢脾。", "你开始从[src]中收取蜂巢脾。")

	if(!do_after(user, 2.5 SECONDS, src))
		return

	// Determine honey type based on pollination history
	var/honey_type = determine_honey_type()
	var/honey_path = honey_types[honey_type]

	for(var/i=1 to stored_combs)
		new honey_path(get_turf(src))

	stored_combs = 0
	update_icon_state()

/obj/structure/apiary/attackby(obj/item/I, mob/user, params) 
	if(istype(I, /obj/item/queen_bee))
		if(queen_bee)
			to_chat(user, span_warning("里面已经有蜂后了！"))
			return
		new /obj/structure/apiary/starter(get_turf(src))
		qdel(src)
		qdel(I)

/obj/structure/apiary/proc/process_comb_gain()
	if(!pollen)
		return

	var/pollen_multi = CEILING(bee_count * 0.5, 1)
	if(queen_bee)
		pollen_multi *= queen_bee.bee_efficiency

	var/pollen_to_process = min(pollen_multi, pollen)
	pollen -= pollen_to_process
	comb_progress += pollen_to_process

	if(comb_progress > 100)
		stored_combs = min(stored_combs + 1, 5)
		comb_progress -= 100
		update_icon_state()

	if(comb_progress > 100)
		comb_progress = 100

	if(stored_combs >= 5)
		pollen = 0

/obj/structure/apiary/proc/process_bee_objects()
	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN || SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		for(var/obj/effect/bees/bee in bee_objects)
			bee.return_to_hive()
		return

	for(var/obj/effect/bees/bee in bee_objects)
		if(bee.pollinating || bee.target)
			continue
		if(!bee.try_pollinate())
			give_bee_target()


/obj/structure/apiary/proc/process_disease()
	disease_progression += 1

	if(disease_progression >= 100)
		disease_progression = 0
		disease_severity += 10

	// Disease effects
	if(disease_type == "varroa_mites")
		// Varroa mites reduce bee population
		if(prob(disease_severity / 10) && bee_count > 0)
			bee_count--
			if(prob(10))
				visible_message(span_warning("一只蜜蜂从[src]中坠落下来，微微抽搐着。"))
				var/obj/effect/decal/cleanable/insect/dead_bee = new(get_turf(src))
				dead_bee.name = "死蜂"

	else if(disease_type == "foulbrood")
		// Foulbrood prevents new bees from being created
		if(prob(disease_severity))
			comb_progress = max(0, comb_progress - 1)

	else if(disease_type == "wax_moths")
		// Wax moths destroy combs
		if(prob(disease_severity / 5) && stored_combs > 0)
			stored_combs = max(0, stored_combs - 1)
			update_icon_state()


	if(disease_severity >= 100)
		visible_message(span_warning("[src]的蜂群因疾病而彻底崩溃了！"))
		bee_count = 0
		outside_bees = 0
		for(var/obj/effect/bees/B in bee_objects)
			qdel(B)
		bee_objects.Cut()
		has_disease = FALSE
		disease_severity = 0
		queen_deceased = TRUE
		if(queen_bee)
			qdel(queen_bee)
			queen_bee = null

/obj/structure/apiary/proc/check_for_disease()
	if(prob(97))
		return

	var/infected_nearby = FALSE
	for(var/obj/structure/apiary/A in view(5, src))
		if(A.has_disease)
			infected_nearby = TRUE
			break

	var/infection_chance = infected_nearby ? 10 : 2

	if(queen_bee)
		infection_chance = max(0, infection_chance - (queen_bee.bee_disease_resistance * 3))

	if(prob(infection_chance) && !has_disease)
		disease_type = pick("varroa_mites", "foulbrood", "wax_moths")
		has_disease = TRUE
		disease_severity = 10
		visible_message(span_warning("[src]里的蜜蜂看起来变得烦躁不安。"))

/obj/structure/apiary/proc/agitate_bees(chance, mob/user)
	if(prob(chance) && bee_count > 0)
		var/agitated_count = rand(1, min(5, bee_count))
		bee_count -= agitated_count
		outside_bees += agitated_count

		visible_message(span_warning("蜜蜂愤怒地从[src]中涌了出来！"))

		for(var/i in 1 to agitated_count)
			var/obj/effect/bees/B = new(get_turf(src))
			B.hive = src
			B.bee_count = 1
			B.agitate(user, 100)
			B.bee_aggression = queen_bee ? queen_bee.bee_aggression : 50 // Default to aggressive if no queen
			bee_objects += B

/obj/structure/apiary/proc/calm_bees()
	for(var/obj/effect/bees/B in bee_objects)
		B.agitated = FALSE
		B.agitation_countdown = 0
		B.attacked_mobs.Cut()

/obj/structure/apiary/proc/record_pollen_source(plant_type)
	if(!pollen_sources[plant_type])
		pollen_sources[plant_type] = 0
	pollen_sources[plant_type]++

/obj/structure/apiary/proc/determine_honey_type()
	var/highest_count = 0
	var/highest_type = "default"

	for(var/plant_type in pollen_sources)
		if(pollen_sources[plant_type] > highest_count)
			highest_count = pollen_sources[plant_type]

			// Map plant type to honey type this will increase as I make more honey
			if(plant_type == /datum/plant_def/poppy)
				highest_type = "addictive"

	// Clear pollen sources after honey is determined
	pollen_sources.Cut()

	return highest_type

/obj/structure/apiary/proc/try_send_bees_out()
	// Don't send bees out in poor conditions
	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN)
		return

	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		return

	if(pollen && stored_combs < 5)
		return

	var/obj/effect/bees/new_bee = new(get_turf(src))
	transfer_genetics(new_bee) // Apply queen's genetics

	if(length(bee_objects))
		for(var/obj/effect/bees/bee in bee_objects)
			if(bee.bee_count > 5)
				continue
			new_bee.merge_target = bee
			outside_bees++
			bee_count--
			return
	new_bee.hive = src
	outside_bees++
	bee_count--
	bee_objects += new_bee


/obj/structure/apiary/proc/process_swarm()
	if(world.time < (last_swarm_time + 5 MINUTES))
		return

	swarm_progress += 0.1

	if(swarm_progress > 80 && prob(10))
		visible_message(span_warning("[src]里的蜜蜂异常活跃！"))

	if(swarm_progress >= 100)
		create_swarm()

/obj/structure/apiary/proc/create_swarm()
	swarm_progress = 0
	last_swarm_time = world.time
	var/obj/item/queen_bee/new_queen = new(get_turf(src))

	// Copy genetics from current queen with slight variations
	new_queen.bee_efficiency = queen_bee?.bee_efficiency + rand(-20, 20)/100
	new_queen.bee_aggression = queen_bee?.bee_aggression + rand(-10, 10)
	new_queen.bee_lifespan = queen_bee?.bee_lifespan + rand(-20, 20)/100
	new_queen.bee_color = queen_bee?.bee_color
	new_queen.bee_disease_resistance = queen_bee?.bee_disease_resistance + rand(-20, 20)/100

	// Clamp values to reasonable ranges
	new_queen.bee_efficiency = clamp(new_queen.bee_efficiency, 0.5, 2.0)
	new_queen.bee_aggression = clamp(new_queen.bee_aggression, 0, 100)
	new_queen.bee_lifespan = clamp(new_queen.bee_lifespan, 0.5, 2.0)
	new_queen.bee_disease_resistance = clamp(new_queen.bee_disease_resistance, 0.5, 2.0)

	// Create swarm of bees with the new queen
	var/swarm_size = rand(5, 10)
	bee_count -= swarm_size

	// Announce the swarm
	visible_message(span_warning("一群蜜蜂从[src]中分蜂而出！"))

	// Create a visual swarm effect
	var/obj/effect/bee_swarm/swarm = new(get_turf(src))
	swarm.bee_count = swarm_size
	swarm.queen_bee = new_queen

	// Swarm will look for a place to establish a new hive
	swarm.find_new_home()

/obj/structure/apiary/proc/give_bee_target()
	var/list/targets = list()
	for(var/obj/structure/soil/soil in view(7, src))
		if(!soil.plant)
			continue
		targets |= soil
	for(var/obj/structure/flora/roguegrass/herb/herb in view(7, src))
		targets |= herb

	for(var/obj/effect/bees/bee in bee_objects)
		if(bee.pollinating || bee.target)
			continue
		if(targets.len)
			bee.target = pick(targets)

/obj/structure/apiary/proc/try_create_bees()
	if(!comb_progress)
		return
	if((outside_bees + bee_count + sleeping_bees) > max_bees)
		return

	if(comb_progress < 10)
		return

	comb_progress -= 10
	bee_count++

/obj/structure/apiary/proc/on_bee_enter(amount)
	addtimer(CALLBACK(src, PROC_REF(finish_sleep), amount), 30 SECONDS)

/obj/structure/apiary/proc/finish_sleep(amount)
	sleeping_bees -= amount
	bee_count += amount

/obj/structure/apiary/proc/transfer_genetics(obj/effect/bees/bee)
	if(!queen_bee)
		return

	// Transfer primary genetics from the queen with slight mutations
	bee.bee_efficiency = queen_bee.bee_efficiency + rand(-10, 10)/100
	bee.bee_aggression = queen_bee.bee_aggression + rand(-5, 5)
	bee.bee_lifespan = queen_bee.bee_lifespan + rand(-10, 10)/100
	bee.bee_color = queen_bee.bee_color
	bee.bee_disease_resistance = queen_bee.bee_disease_resistance + rand(-10, 10)/100

	// Clamp values to reasonable ranges
	bee.bee_efficiency = clamp(bee.bee_efficiency, 0.5, 2.0)
	bee.bee_aggression = clamp(bee.bee_aggression, 0, 100)
	bee.bee_lifespan = clamp(bee.bee_lifespan, 0.5, 2.0)
	bee.bee_disease_resistance = clamp(bee.bee_disease_resistance, 0.5, 2.0)

/obj/structure/apiary/proc/create_new_queen()
	queen_maturity = 0
	pollen -= 50
	stored_combs -= 2
	update_icon_state()

	var/obj/item/queen_bee/new_queen = new(get_turf(src))
	// Generate random genetics for the new queen
	new_queen.bee_efficiency = rand(80, 120)/100
	new_queen.bee_aggression = rand(0, 30)
	new_queen.bee_lifespan = rand(80, 120)/100
	new_queen.bee_color = pick("#FFD700", "#FFA500", "#FFFF00", "#DAA520")
	new_queen.bee_disease_resistance = rand(80, 120)/100

	visible_message(span_notice("一只新的蜂后从[src]中诞生了！"))

	// Insert the queen into the hive
	insert_queen(new_queen)

/obj/structure/apiary/proc/insert_queen(obj/item/queen_bee/new_queen)
	queen_bee = new_queen
	queen_deceased = FALSE
	max_bees = 30 + (queen_bee.bee_efficiency * 10) // Queen efficiency affects max colony size
	visible_message(span_notice("[src]里的蜜蜂迎来了它们的新蜂后！"))
	new_queen.forceMove(src)

/obj/item/queen_bee
	name = "蜂后"
	desc = "蜂群真正的核心。"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "queen_bee"

	var/bee_efficiency = 1.0
	var/bee_aggression = 0
	var/bee_lifespan = 1.0
	var/bee_color = "#FFD700"
	var/bee_disease_resistance = 1.0
	var/queen_age = 0 // In days
	var/queen_health = 100
	var/max_queen_age = 30 // Queens live for 30 days

/obj/item/queen_bee/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/queen_bee/process()
	// Age the queen
	queen_age += 0.01

	// Queen health decreases with age
	if(queen_age > (max_queen_age * 0.7))
		queen_health -= 0.05

	if(queen_health <= 0)
		visible_message(span_warning("[src]因年老而死！"))
		qdel(src)

/obj/item/bee_smoker
	name = "养蜂烟熏器"
	desc = "一种利用烟雾安抚蜜蜂的装置。"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "smoker"
	w_class = WEIGHT_CLASS_SMALL
	var/fuel = 20
	var/max_fuel = 20
	var/active = FALSE

/obj/item/bee_smoker/attack_self(mob/user)
	if(!active && fuel > 0)
		to_chat(user, span_notice("你点燃了[src]。"))
		active = TRUE
		update_icon()
		process_smoker(user)
	else if(active)
		to_chat(user, span_notice("你熄灭了[src]。"))
		active = FALSE
		update_icon()
	else
		to_chat(user, span_warning("[src]没燃料了！"))

/obj/item/bee_smoker/proc/process_smoker(mob/user)
	if(!active)
		return

	if(fuel <= 0)
		active = FALSE
		update_icon()
		to_chat(user, span_warning("[src]的燃料耗尽了！"))
		return

	// Create smoke effects
	var/turf/T = get_turf(src)
	var/datum/effect_system/smoke_spread/chem/S = new
	S.set_up(1, T, 0) // No reagents needed, just visual
	S.start()

	// Calm nearby bees
	for(var/obj/effect/bees/B in view(3, user))
		B.agitated = FALSE
		B.agitation_countdown = 0
		B.attacked_mobs.Cut()

	// Calm bees in nearby apiaries
	for(var/obj/structure/apiary/A in view(2, user))
		A.calm_bees()

	fuel--

	// Continue processing
	addtimer(CALLBACK(src, PROC_REF(process_smoker), user), 1 SECONDS)

/obj/item/bee_smoker/update_icon_state()
	icon_state = active ? "smoker_lit" : "smoker"

/obj/item/bee_smoker/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/natural/bundle/cloth))
		var/obj/item/natural/bundle/cloth/C = I
		if(C.amount >= 1 && fuel < max_fuel)
			to_chat(user, span_notice("你往[src]里塞了些布料。"))
			C.use(1)
			fuel = min(fuel + 5, max_fuel)
			return TRUE
	return ..()


/obj/item/magnifying_glass
	name = "放大镜"
	desc = "一件用于细致检查的工具。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "magnifying_glass"

	grid_height = 64
	grid_width = 32

/obj/item/magnifying_glass/attack(mob/living/M, mob/user)
	return

/obj/item/magnifying_glass/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(istype(target, /obj/structure/apiary))
		var/obj/structure/apiary/A = target

		to_chat(user, span_notice("你仔细检查了[A]。"))

		if(A.has_disease)
			switch(A.disease_type)
				if("varroa_mites")
					to_chat(user, span_warning("你发现有细小的螨虫正爬在蜜蜂身上！"))
				if("foulbrood")
					to_chat(user, span_warning("蜂巢散发着腐臭气味，而且明显已经变色了！"))
				if("wax_moths")
					to_chat(user, span_warning("你看见蜂巢里有小蛾子和它们的幼虫！"))

			// Report severity
			if(A.disease_severity < 30)
				to_chat(user, span_notice("感染看起来还算轻微。"))
			else if(A.disease_severity < 70)
				to_chat(user, span_warning("感染程度已经相当明显。"))
			else
				to_chat(user, span_danger("感染非常严重！蜂群可能很快就会崩溃！"))
		else
			to_chat(user, span_notice("这些蜜蜂看起来很健康。"))


		// Report on bee count
		if(A.bee_count + A.outside_bees == 0)
			to_chat(user, span_warning("蜂巢是空的！"))
		else if(A.bee_count + A.outside_bees < 5)
			to_chat(user, span_warning("这支蜂群规模非常小。"))
		else if(A.bee_count + A.outside_bees < 15)
			to_chat(user, span_notice("这支蜂群规模中等。"))
		else
			to_chat(user, span_notice("这支蜂群十分兴旺，蜜蜂数量众多！"))

/obj/item/bee_treatment
	name = "蜂群药剂"
	desc = "一种用来治疗蜂群疾病的药剂。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clear_vial1"
	var/treatment_type = "general"
	var/treatment_strength = 30

/obj/item/bee_treatment/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return

	if(istype(target, /obj/structure/apiary))
		var/obj/structure/apiary/A = target

		if(!A.has_disease)
			to_chat(user, span_notice("这些蜜蜂看起来并不需要治疗。"))
			return

		to_chat(user, span_notice("你将[src]施用在了[A]上。"))

		// Treatment effectiveness
		var/effectiveness = treatment_strength

		// Specific treatments work better
		if(treatment_type == A.disease_type)
			effectiveness *= 2

		// Apply treatment
		A.treatment_progress += effectiveness

		// Check if treatment is complete
		if(A.treatment_progress >= 100)
			A.has_disease = FALSE
			A.disease_severity = 0
			A.treatment_progress = 0
			to_chat(user, span_notice("这些蜜蜂看起来正在恢复！"))
		else
			to_chat(user, span_notice("治疗似乎已经开始起效了。"))

		// Agitate bees when treated
		A.agitate_bees(20, user)

		// Use up the treatment
		qdel(src)

// Specific disease treatments
/obj/item/bee_treatment/antiviral
	name = "蜂群抗病毒剂"
	desc = "用于治疗腐臭病等蜂群病毒性疾病的药剂。"
	treatment_type = "foulbrood"
	treatment_strength = 40

/obj/item/bee_treatment/miticide
	name = "蜂螨杀灭剂"
	desc = "一种用于清除侵染蜂群的瓦螨的药剂。"
	treatment_type = "varroa_mites"
	treatment_strength = 40

/obj/item/bee_treatment/insecticide
	name = "定向杀虫剂"
	desc = "一种用来对付蜡螟和其他蜂巢害虫的药剂。"
	treatment_type = "wax_moths"
	treatment_strength = 40

/obj/item/reagent_containers/food/snacks/rogue/honey/ambrosia
	name = "舒缓蜂蜜"
	desc = "一种带有细微安神效果的甜蜜蜂蜜。"
	icon_state = "greyscale_honey"
	honey_color = COLOR_GREEN_GRAY
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = 3, /datum/reagent/drug/space_drugs = 2)

/obj/item/reagent_containers/food/snacks/rogue/honey/healing
	name = "药用蜂蜜"
	desc = "一种带有疗愈效果的甜蜜蜂蜜。"
	icon_state = "greyscale_honey"
	honey_color = COLOR_MAROON
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = 3)

/obj/item/reagent_containers/food/snacks/rogue/honey/toxic
	name = "奇异蜂蜜"
	desc = "这蜂蜜的气味和外观都透着一股古怪。"
	icon_state = "greyscale_honey"
	honey_color = "#CF3600"
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/toxin = 2)

/obj/item/reagent_containers/food/snacks/rogue/honey/luminescent
	name = "发光蜂蜜"
	desc = "这蜂蜜散发着柔和的生物荧光。"
	icon_state = "greyscale_honey"
	honey_color = "#CCFF99"
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = 3)
	light_system = MOVABLE_LIGHT
	light_outer_range = 2
	light_power = 1
	light_color = "#CCFF99"

/obj/effect/bee_swarm
	name = "蜂群"
	desc = "一团嗡嗡作响的蜂群，正在寻找建立新巢的地方。"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "bee"
	density = FALSE
	anchored = FALSE
	pass_flags = PASSTABLE | PASSMOB

	var/bee_count = 5
	var/obj/item/queen_bee/queen_bee = null
	var/search_time = 0
	var/established = FALSE

/obj/effect/bee_swarm/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	update_overlays()

	addtimer(CALLBACK(src, PROC_REF(swarm_timeout)), 5 MINUTES)

/obj/effect/bee_swarm/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(queen_bee && !established)
		qdel(queen_bee)
	return ..()

/obj/effect/bee_swarm/process()
	if(!established)
		if(prob(50))
			var/turf/T = get_step(src, pick(GLOB.alldirs))
			if(T)
				Move(T)

	search_time++

	if(search_time >= 20)
		search_time = 0
		find_new_home()

/obj/effect/bee_swarm/proc/find_new_home()
	var/turf/T = get_turf(src)
	if(!T.density && !locate(/obj/structure/apiary) in T)
		var/suitable = TRUE
		for(var/atom/A in T)
			if(A.density)
				suitable = FALSE
				break

		if(suitable && prob(20))
			establish_hive()

/obj/effect/bee_swarm/proc/establish_hive()
	var/obj/structure/apiary/A = new(get_turf(src)) //place holder until blanks are made
	A.bee_count = bee_count

	A.insert_queen(queen_bee)
	queen_bee = null

	established = TRUE

	visible_message(span_notice("这群蜜蜂建立起了一个新蜂巢！"))
	qdel(src)

/obj/effect/bee_swarm/proc/swarm_timeout()
	if(!established)
		visible_message(span_notice("这群蜜蜂没能找到合适的新家，最终散去了。"))
		qdel(src)

/obj/effect/bee_swarm/update_overlays()
	. = ..()
	cut_overlays()

	var/bee_spawn = bee_count - 1
	if(!bee_spawn)
		return

	for(var/i=1 to min(bee_spawn, 10))
		var/mutable_appearance/bee = mutable_appearance('icons/obj/structures/apiary.dmi', "bee")
		bee.pixel_x = rand(12, -12)
		bee.pixel_y = rand(12, -12)
		overlays += bee

/obj/structure/beehive/wild
	name = "野生蜂巢"
	desc = "一个在野外自然形成的蜂群巢穴。"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "wild_hive"
	density = TRUE
	anchored = TRUE

	var/bee_count = 0
	var/max_bees = 15
	var/aggressiveness = 50 // 0-100 scale
	var/list/bee_objects = list()

/obj/structure/beehive/wild/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	bee_count = rand(5, max_bees)
	aggressiveness = rand(30, 70)

	// Occasionally send out bees
	addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))

/obj/structure/beehive/wild/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/effect/bees/B in bee_objects)
		qdel(B)
	bee_objects.Cut()
	return ..()

/obj/structure/beehive/wild/process()
	if(bee_count < max_bees && prob(5))
		bee_count++

/obj/structure/beehive/wild/proc/send_out_bees()
	if(bee_count <= 0)
		addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))
		return

	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN || SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))
		return

	var/obj/effect/bees/wild/B = new(get_turf(src))
	B.home_hive = src
	B.bee_count = 1
	B.bee_aggression = aggressiveness
	bee_objects += B
	bee_count--

	if(prob(70))
		B.find_pollination_target()
	else
		B.wander_behavior = TRUE

	addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))

/obj/structure/beehive/wild/attack_hand(mob/user)
	user.visible_message(span_warning("[user]惊动了[src]！"), span_warning("你惊动了这个野生蜂巢！"))

	var/protected = is_wearing_bee_protection(user)

	if(!protected || prob(aggressiveness))
		agitate_bees(user)

	if(protected && prob(30))
		to_chat(user, span_notice("你成功取出了一些蜂蜜！"))
		new /obj/item/reagent_containers/food/snacks/rogue/honey/wild(get_turf(src))

/obj/structure/beehive/wild/proc/agitate_bees(mob/target)
	visible_message(span_danger("蜜蜂愤怒地从[src]中蜂拥而出！"))

	// Release angry bees
	var/release_count = min(bee_count, rand(3, 8))
	bee_count -= release_count

	for(var/i=1 to release_count)
		var/obj/effect/bees/wild/B = new(get_turf(src))
		B.home_hive = src
		B.bee_count = 1
		B.bee_aggression = min(aggressiveness + 20, 100)
		B.agitated = TRUE
		B.agitation_countdown = 100

		if(target)
			B.target_mob = target
			B.attacked_mobs[target] = TRUE

		bee_objects += B

/obj/effect/bees/wild
	var/obj/structure/beehive/wild/home_hive = null
	var/mob/living/target_mob = null
	var/wander_behavior = FALSE
	var/return_home_timer = 0

/obj/effect/bees/wild/process()
	. = ..()
	if(agitated && target_mob)
		if(get_dist(src, target_mob) > 1)
			var/turf/T = get_step_towards(src, target_mob)
			Move(T)
		else
			attack_mob(target_mob)

	else if(wander_behavior)
		if(prob(40))
			var/turf/T = get_step(src, pick(GLOB.alldirs))
			Move(T)

		return_home_timer++

		if(return_home_timer > 50)
			return_to_hive()

	if(home_hive && ((agitation_countdown <= 0 && agitated) || stored_pollen > 5))
		return_to_hive()

/obj/effect/bees/wild/proc/find_pollination_target()
	var/list/targets = list()
	for(var/obj/structure/soil/soil in view(10, src))
		if(!soil.plant)
			continue
		targets |= soil
	for(var/obj/structure/flora/roguegrass/herb/herb in view(10, src))
		targets |= herb

	if(targets.len)
		target = pick(targets)

/obj/effect/bees/wild/return_to_hive()
	if(!home_hive)
		return

	if(get_dist(src, home_hive) > 0)
		var/turf/T = get_step_towards(src, home_hive)
		Move(T)
	else
		enter_wild_hive()

/obj/effect/bees/wild/proc/enter_wild_hive()
	if(!home_hive)
		return

	// Return bee to hive
	home_hive.bee_count += bee_count
	home_hive.bee_objects -= src
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/honey/wild
	name = "野生蜂蜜"
	desc = "甜美的野生蜂蜜。它的风味比普通蜂蜜更加复杂。"
	icon_state = "greyscale_honey"
	honey_color = "#6d4633"
	list_reagents = list(/datum/reagent/consumable/honey = 7, /datum/reagent/consumable/nutriment = 3)

/obj/effect/decal/cleanable/insect
