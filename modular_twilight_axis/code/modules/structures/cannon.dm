#define CANNON_POWDER_COST 1

/datum/anvil_recipe/cannon
	i_type = "Engineering"
	abstract_type = /datum/anvil_recipe/cannon
	appro_skill = /datum/skill/craft/engineering
	req_trait = TRAIT_GUNSMITH
	craftdiff = 4
	hides_from_books = TRUE

/datum/anvil_recipe/cannon/cannon
	name = "Cannon"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small,)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/structure/cannon

/datum/anvil_recipe/cannon/cannonball
	name = "Cannon Ball"
	additional_items = list(/obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/cannonball

/datum/anvil_recipe/cannon/grapeshot
	name = "Grapeshot Shell"
	additional_items = list(/obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/grapeshot

/datum/crafting_recipe/roguetown/survival/fiberfuse
	name = "fiber fuse"

	result = /obj/item/cannon_fuse/fiber
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/parchmentfuse
	name = "parchment fuse"
	result = /obj/item/cannon_fuse/parchment
	reqs = list(
		/obj/item/paper = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/obj/item/cannon_fuse
	name = "fuse"
	desc = "A fuse for a cannon."
	icon = 'modular_twilight_axis/icons/cannon/cannon_fuse.dmi'
	icon_state = "fiber_fuse"
	w_class = WEIGHT_CLASS_SMALL
	var/burn_time = 3 SECONDS
	var/lit = FALSE
	var/icon_state_lit = "fiber_fuse_lit"

/obj/item/cannon_fuse/fiber
	name = "fiber fuse"
	desc = "A standard braided wick coated with grease. It burns relatively slowly, giving the crew time to move to a safe distance."
	icon_state = "fiber_fuse"
	icon_state_lit = "fiber_fuse_lit"
	burn_time = 3 SECONDS

/obj/item/cannon_fuse/parchment
	name = "parchment fuse"
	desc = "A paper wick soaked in grease. It burns almost instantly, ensuring a quick shot."
	icon_state = "parchment_fuse"
	icon_state_lit = "parchment_fuse_lit"
	burn_time = 1 SECONDS


/obj/item/cannon_shell
	name = "cannon ball"
	desc = "A cannon ball."
	icon = 'modular_twilight_axis/icons/cannon/cannon.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/cannon_shell/cannonball
	name = "cannonball"
	desc = "A heavy steel cannonball."
	icon_state = "cannonball"

/obj/item/cannon_shell/grapeshot
	name = "grapeshot"
	desc = "A projectile filled with dozens of small bullets."
	icon_state = "grapeshot"

/obj/projectile/bullet/cannon_debris
	name = "flying debris"
	desc = "Pieces of earth and stone."
	icon = 'icons/effects/debris.dmi'
	icon_state = "shards"
	color = "#5c544d"
	damage = 0
	nodamage = TRUE
	flag = "blunt"
	speed = 1.0
	pass_flags = PASSTABLE | PASSMOB

/obj/projectile/bullet/cannon_debris/on_hit(atom/target, blocked = 0)
	var/turf/T = get_turf(target)
	if(T && !istype(target, /mob/living))
		new /obj/effect/particle_effect/smoke/arquebus(T)
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/bullet/cannonball_straight
	name = "cannonball"
	desc = "Lead core"
	icon = 'modular_twilight_axis/icons/cannon/cannonball.dmi'
	icon_state = "ball"
	damage = 110
	damage_type = BRUTE
	flag = "bullet"
	speed = 2.5
	var/pierces_left = 3

/obj/projectile/bullet/cannonball_straight/on_hit(atom/target, blocked = 0)
	. = ..()
	var/turf/T = get_turf(target)
	if(!T)
		qdel(src)
		return

	if(isliving(target))
		var/mob/living/L = target

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/valid_limbs = list()
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.body_zone != BODY_ZONE_CHEST && BP.body_zone != BODY_ZONE_HEAD)
					valid_limbs += BP

			var/limbs_to_lose = rand(1, 3)
			for(var/i in 1 to limbs_to_lose)
				if(!length(valid_limbs))
					break
				var/obj/item/bodypart/lost_limb = pick(valid_limbs)
				valid_limbs -= lost_limb
				lost_limb.dismember(BRUTE, BCLASS_CHOP, null, lost_limb.body_zone, 110, TRUE, TRUE)

			for(var/obj/item/bodypart/remaining_limb in H.bodyparts)
				H.apply_damage(100, BRUTE, remaining_limb.body_zone)
		else
			L.adjustBruteLoss(400)

		var/throw_dir = turn(dir, pick(-90, 90))
		var/turf/throw_turf = get_ranged_target_turf(L, throw_dir, rand(2, 4))
		if(throw_turf)
			L.throw_at(throw_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)

		L.Knockdown(60)
		L.Paralyze(40)

	else if(istype(target, /turf/closed) || istype(target, /obj/structure) || istype(target, /obj/machinery))
		target.ex_act(EXPLODE_DEVASTATE)
		new /obj/effect/particle_effect/smoke/arquebus(T)

	pierces_left--

	if(pierces_left > 0)
		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE
		return BULLET_ACT_FORCE_PIERCE

	else
		T.visible_message(span_danger("The cannonball explodes with a loud bang!"))

		for(var/mob/living/M in range(4, T))
			if(!M.mind || istype(M, /mob/living/simple_animal))
				if(get_dist(T, M) <= 3)
					M.adjustBruteLoss(300)
				else
					M.adjustBruteLoss(200)

			if(M != target)
				var/blast_dir = get_dir(T, M)
				if(blast_dir == 0)
					blast_dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

				var/turf/blast_turf = get_ranged_target_turf(M, blast_dir, rand(2, 4))
				if(blast_turf)
					M.throw_at(blast_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)

				M.Knockdown(60)
				M.Paralyze(40)
				M.adjustBruteLoss(rand(40, 80))
				M.visible_message(span_warning("[M] knocks you off your feet with a powerful shock wave!"))

		var/shrapnel_count = rand(6, 12)
		var/list/all_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/i in 1 to shrapnel_count)
			var/obj/projectile/bullet/grapeshot_pellet/S = new(T)
			var/shoot_dir = pick(all_dirs)
			var/turf/shrapnel_target = get_ranged_target_turf(T, shoot_dir, rand(4, 7))

			if(shrapnel_target)
				shrapnel_target = locate(shrapnel_target.x + rand(-2, 2), shrapnel_target.y + rand(-2, 2), shrapnel_target.z)

			S.preparePixelProjectile(shrapnel_target, src, null, rand(-30, 30))
			S.p_x = 16
			S.p_y = 16
			S.fire()

		for(var/i in 1 to 16)
			var/obj/projectile/bullet/cannon_debris/D = new(T)
			var/shoot_dir = pick(all_dirs)
			var/turf/debris_target = get_ranged_target_turf(T, shoot_dir, rand(5, 9))

			if(debris_target)
				debris_target = locate(debris_target.x + rand(-3, 3), debris_target.y + rand(-3, 3), debris_target.z)

			D.preparePixelProjectile(debris_target, src, null, rand(-45, 45))
			D.p_x = 16
			D.p_y = 16
			D.fire()

		explosion(T, devastation_range = 0, heavy_impact_range = 3, light_impact_range = 6, flame_range = 0, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

		qdel(src)
		return BULLET_ACT_HIT

/obj/projectile/bullet/grapeshot_pellet
	name = "shrapnel"
	icon = 'modular_twilight_axis/icons/cannon/ammo.dmi'
	icon_state = "musketball"
	damage = 90
	damage_type = BRUTE
	flag = "piercing"
	armor_penetration = PEN_BSTEEL
	speed = 2.0
	woundclass = BCLASS_PIERCE
	embedchance = 100

/obj/projectile/bullet/grapeshot_pellet/prehit(atom/target)
	if(isliving(target))
		temporary_unstoppable_movement = TRUE
		if(prob(50))
			return FALSE
	return ..()

/obj/structure/cannon
	name = "Cannon"
	desc = "A heavy gun on a wheeled carriage. It fires high-explosive shells."
	icon = 'modular_twilight_axis/icons/cannon/cannon.dmi'
	icon_state = "cannon"
	density = TRUE
	anchored = FALSE
	max_integrity = 2000

	pixel_x = -16
	pixel_y = -16

	var/powder_loaded = FALSE
	var/obj/item/cannon_shell/bullet_loaded = null
	var/rammed = FALSE
	var/obj/item/cannon_fuse/inserted_fuse = null
	var/fuse_burning = FALSE

	var/barrel_integrity = 15
	var/last_fired = 0
	var/cooldown = 10 SECONDS

/obj/structure/cannon/Initialize()
	. = ..()
	dir = NORTH
	update_icon() 

/obj/structure/cannon/Destroy()
	if(bullet_loaded)
		qdel(bullet_loaded)
		bullet_loaded = null
	if(inserted_fuse)
		qdel(inserted_fuse)
		inserted_fuse = null
	return ..()

/obj/structure/cannon/update_icon()
	. = ..()
	cut_overlays()

	if(!inserted_fuse)
		icon_state = "cannon"
	else if(fuse_burning)
		icon_state = "cannon_lit"
	else
		icon_state = "cannon_fib"

/obj/structure/cannon/examine(mob/user)
	. = ..()
	if((world.time - last_fired) < cooldown)
		. += span_warning("The cannon barrel is still hot from a recent shot!")
	else
		. += span_info("The barrel is cold; the gun is ready to be reloaded.")

	if(fuse_burning)
		. += span_bold("THE FUSE IS BURNING AND SPARKLING! A SHOT IS ABOUT TO BE FIRED!")
		return

	if(!powder_loaded)
		. += span_info("The barrel is empty. You need to load it with gunpowder.")
	else if(!bullet_loaded)
		. += span_info("The gunpowder charge has been loaded, but the projectile is missing.")
	else if(!rammed)
		. += span_warning("The gunpowder and projectile are inside the barrel, but the charge hasn't been packed down with a ramrod yet!")
	else if(!inserted_fuse)
		. += span_notice("The cannon is ready and sealed. Insert the fuse into the ignition hole..")
	else
		. += span_bold("There is a fuse inside the cartridge. Light it to fire the shell!")

/obj/structure/cannon/fire_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/spark_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(fuse_burning)
		to_chat(user, span_warning("The fuse is lit! Don't touch the cannon!"))
		return

	dir = turn(dir, -90)
	user.visible_message(span_notice("[user] unfolds [src.name]."), span_notice("You aim the cannon at [dir2text(dir)]."))
	playsound(src, 'modular_twilight_axis//sound/cannon/anglecorrection.ogg', 100, TRUE)

/obj/structure/cannon/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/powderflask))
		var/obj/item/powderflask/P = used_item
		if(powder_loaded)
			to_chat(user, span_warning("The gun is already loaded with gunpowder!"))
			return
		user.visible_message(span_notice("[user] begins to pour gunpowder into the [src.name]..."))
		playsound(src, 'modular_twilight_axis//sound/cannon/powder.ogg', 100, TRUE)
		if(do_after(user, 3 SECONDS, src))
			if(QDELETED(P) || QDELETED(src))
				return
			powder_loaded = TRUE
			to_chat(user, span_notice("You poured gunpowder into the barrel."))
		return

	if(istype(used_item, /obj/item/cannon_shell))
		if(!powder_loaded)
			to_chat(user, span_warning("First, you have to pour in the gunpowder!"))
			return
		if(bullet_loaded)
			to_chat(user, span_warning("There's already a shell in the barrel!"))
			return

		if(user.transferItemToLoc(used_item, src))
			bullet_loaded = used_item
			user.visible_message(span_notice("[user] loads a shell into the [src.name]."))
			playsound(src, 'modular_twilight_axis//sound/cannon/loading.ogg', 100, TRUE)
		return

	if(istype(used_item, /obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge))
		if(!powder_loaded || !bullet_loaded)
			to_chat(user, span_warning("You don't need to tamp anything down! Load the gunpowder and the projectile first."))
			return
		if(rammed)
			to_chat(user, span_warning("The charge in the cannon has already been compacted!!"))
			return
		user.visible_message(span_notice("[user] begins to compress the charge in the [src.name] with a ramrod..."))
		playsound(src, 'modular_twilight_axis//sound/cannon/ramrod.ogg', 100, TRUE)
		if(do_after(user, 4 SECONDS, src))
			rammed = TRUE
			user.visible_message(span_notice("[user] packs the charge down with a ramrod. Now the cannon is ready to fire."))
		return

	if(istype(used_item, /obj/item/cannon_fuse) || istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
		if(inserted_fuse)
			to_chat(user, span_warning("There's already a fuse in the cannon's firing port!"))
			return
		if(!rammed)
			to_chat(user, span_warning("Before inserting the fuse, tamp down the gunpowder and the projectile with a ramrod!"))
			return

		if(istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
			inserted_fuse = new /obj/item/cannon_fuse/fiber(src)
			if(istype(used_item, /obj/item/natural/bundle/fibers))
				var/obj/item/natural/bundle/fibers/B = used_item
				B.amount--
				if(B.amount <= 0)
					qdel(B)
			else
				qdel(used_item)
		else
			if(user.transferItemToLoc(used_item, src))
				inserted_fuse = used_item

		user.visible_message(span_notice("[user] inserts the wick into the [src.name]."))
		playsound(src, 'sound/foley/bandage.ogg', 100, FALSE)
		update_icon()
		return

	var/ignition_msg = used_item.ignition_effect(src, user)
	if(ignition_msg)
		if(inserted_fuse && !fuse_burning)
			visible_message(ignition_msg)
			light_fuse(user)
		return TRUE

	return ..()

/obj/structure/cannon/proc/light_fuse(mob/user)
	if(!inserted_fuse || fuse_burning)
		return

	fuse_burning = TRUE
	inserted_fuse.lit = TRUE
	inserted_fuse.icon_state = inserted_fuse.icon_state_lit
	update_icon()

	if(user)
		user.visible_message(span_danger("[user] lighting the fuse on [src.name]! It's about to go off!"))
	else
		visible_message(span_danger("The wick at [src.name] starts to spark menacingly! It's about to fire!"))

	playsound(src, 'modular_twilight_axis/sound/cannon/fuse.ogg', 100, FALSE)

	addtimer(CALLBACK(src, PROC_REF(detonate_fuse), user), inserted_fuse.burn_time)

/obj/structure/cannon/proc/detonate_fuse(mob/user)
	fuse_burning = FALSE
	if(!inserted_fuse)
		return
	qdel(inserted_fuse)
	inserted_fuse = null
	update_icon()

	fire_cannon(user)

/obj/structure/cannon/proc/fire_cannon(mob/user)
	if(!powder_loaded || !bullet_loaded || !rammed)
		return

	var/turf/start_turf = get_step(src, dir)
	if(!start_turf)
		return

	for(var/mob/M in range(7, src))
		if(M.client)
			shake_camera(M, 4, 2)

	playsound(src, 'modular_twilight_axis/sound/cannon/launch.ogg', 100, 0, 20, 1, null, null, FALSE, TRUE)

	for(var/turf/AT in get_adjacent_turfs(src.loc))
		new /obj/effect/particle_effect/smoke/arquebus(AT)
		if(prob(40))
			for(var/turf/BT in get_adjacent_turfs(AT))
				new /obj/effect/particle_effect/smoke/arquebus(BT)

	var/turf/target_turf = get_ranged_target_turf(src, dir, 16)

	if(istype(bullet_loaded, /obj/item/cannon_shell/grapeshot))
		var/pellet_count = 30
		var/shoot_dir = dir
		for(var/i in 1 to pellet_count)
			var/obj/projectile/bullet/grapeshot_pellet/S = new(start_turf)
			S.def_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			var/turf/pellet_target = get_ranged_target_turf(start_turf, shoot_dir, 8)

			if(pellet_target)
				S.preparePixelProjectile(pellet_target, src, null, rand(-20, 20))

			S.p_x = 16
			S.p_y = 16
			S.fire()
	else
		var/obj/projectile/bullet/cannonball_straight/P = new(start_turf)
		if(target_turf)
			P.preparePixelProjectile(target_turf, src)

		P.p_x = 16
		P.p_y = 16
		P.fire()

	var/user_name = user ? "[user]" : "Unknown (Auto-ignite)"
	log_game("[user_name] fired a cannon in the direction of [dir2text(dir)] on ([x], [y], [z])")
	message_admins("The cannon fired; the player set it on fire. [user_name] on [ADMIN_VERBOSEJMP(src.loc)]")
	qdel(bullet_loaded)
	bullet_loaded = null
	powder_loaded = FALSE
	rammed = FALSE

	var/skill = 0
	if(user && isliving(user))
		var/mob/living/L = user
		skill = L.get_skill_level(/datum/skill/combat/firearms)

	var/misfire_chance = max(2 - (skill * 5))

	if(prob(misfire_chance))
		src.visible_message(span_danger("[src] It's falling apart!"))
		explosion(get_turf(src), 1, 2, 4, 0, TRUE, FALSE, 2)
		qdel(src)
		return

	if((world.time - last_fired) < cooldown)
		barrel_integrity -= 2
	else
		barrel_integrity--
	last_fired = world.time

	if(barrel_integrity <= 0)
		src.visible_message(span_danger("[src] It breaks apart due to severe barrel wear!"))
		explosion(get_turf(src), 1, 2, 4, 0, TRUE, FALSE, 2)
		qdel(src) 
#undef CANNON_POWDER_COST
