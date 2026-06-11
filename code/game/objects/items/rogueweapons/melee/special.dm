/// INTENT DATUMS	v
/datum/intent/lordbash
	name = "重砸"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("重砸", "痛击")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/lord_electrocute
	name = "电击"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/datum/intent/lord_silence
	name = "缄默"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/// INTENT DATUMS	^

/obj/item/rogueweapon/lordscepter
	force = 20
	force_wielded = 20
	possible_item_intents = list(/datum/intent/lordbash, /datum/intent/lord_electrocute, /datum/intent/lord_silence)
	gripped_intents = list(/datum/intent/lordbash)
	name = "领主权杖"
	desc = "俯首屈膝。无法在庄园外使用。"
	icon_state = "scepter"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ingot/iron
	swingsound = BLUNTWOOSH_MED
	minstr = 5
	COOLDOWN_DECLARE(scepter)

	grid_height = 96
	grid_width = 32

/obj/item/rogueweapon/lordscepter/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -7,"nx" = 11,"ny" = -6,"wx" = -1,"wy" = -6,"ex" = 3,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -1,"sy" = -4,"nx" = 1,"ny" = -3,"wx" = -1,"wy" = -6,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 20,"wturn" = 18,"eturn" = -19,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 4,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/lordscepter/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return

	user.changeNext_move(CLICK_CD_MELEE)

	if(ishuman(user))
		var/mob/living/carbon/human/HU = user

		if(HU.job != "Grand Duke")
			to_chat(user, span_danger("这柄权杖不听我使唤。"))
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/area/target_area = get_area(H)

			if(!istype(target_area, /area/rogue/indoors/town/manor))
				to_chat(user, span_danger("这柄权杖不能对庄园外的目标使用！"))
				return

			if(H == HU)
				return

			if(!COOLDOWN_FINISHED(src, scepter))
				to_chat(user, span_danger("[src]还没准备好！还剩 [round(COOLDOWN_TIMELEFT(src, scepter) / 10, 1)] 秒！"))
				return

			if(H.anti_magic_check())
				to_chat(user, span_danger("有什么东西正在干扰权杖的力量！"))
				return

			if(!(H in SStreasury.bank_accounts))
				to_chat(user, span_danger("目标必须拥有 Nervelock 账户！"))
				return

			if(istype(user.used_intent, /datum/intent/lord_electrocute))
				HU.visible_message(span_warning("[HU]用[src]电击了[H]。"))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, scepter, 20 SECONDS)
				to_chat(H, span_danger("我被权杖电击了！"))
				return

			if(istype(user.used_intent, /datum/intent/lord_silence))
				HU.visible_message("<span class='warning'>[HU]用[src]让[H]失声了。</span>")
				H.set_silence(20 SECONDS)
				COOLDOWN_START(src, scepter, 10 SECONDS)
				to_chat(H, "<span class='danger'>我被权杖噤声了！</span>")
				return

/obj/item/rogueweapon/mace/stunmace
	force = 25
	force_wielded = 25
	name = "震击钉头锤"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "stunmace0"
	desc = "在这里，痛苦就是通用货币。"
	gripped_intents = null
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(/datum/intent/mace/strike/stunner, /datum/intent/mace/smash/stunner)
	wbalance = WBALANCE_NORMAL
	minstr = 5
	wdefense = 0
	var/charge = 100
	var/on = FALSE

/obj/item/rogueweapon/mace/stunmace/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -8,"sy" = -7,"nx" = 10,"ny" = -7,"wx" = -1,"wy" = -8,"ex" = 1,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 91,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/mace/strike/stunner/afterchange()
	var/obj/item/rogueweapon/mace/stunmace/I = masteritem
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/datum/intent/mace/smash/stunner/afterchange()
	var/obj/item/rogueweapon/mace/stunmace/I = masteritem
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/obj/item/rogueweapon/mace/stunmace/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/rogueweapon/mace/stunmace/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/rogueweapon/mace/stunmace/funny_attack_effects(mob/living/target, mob/living/user, nodmg)
	. = ..()
	if(on)
		if(target.stamina >= target.max_stamina)
			target.electrocute_act(5, src)
			charge -= 6
		else/// TODO: Check target.STACON!!!!!!!!!! - EDIT: I never did. Whoops!
			target.energy_add(-10)
			target.stamina_add(5)
			charge -= 3
		if(charge <= 0)
			on = FALSE
			charge = 0
			update_icon()
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()

/obj/item/rogueweapon/mace/stunmace/update_icon()
	if(on)
		icon_state = "stunmace1"
	else
		icon_state = "stunmace0"

/obj/item/rogueweapon/mace/stunmace/attack_self(mob/user)
	if(on)
		on = FALSE
		force = 25
		force_wielded = 25
	else
		if(charge <= 33)
			to_chat(user, span_warning("它没剩多少电了。"))
			return
		user.visible_message(span_warning("[user]启动了[src]。"))
		on = TRUE
		charge--
		force = 6
		force_wielded = 6
	playsound(user, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	update_icon()
	add_fingerprint(user)

/obj/item/rogueweapon/mace/stunmace/process()
	if(on)
		charge--
	else
		if(charge < 100)
			charge++
	if(charge <= 0)
		on = FALSE
		charge = 0
		force = 25
		force_wielded = 25
		update_icon()
		var/mob/user = loc
		if(istype(user))
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

/obj/item/rogueweapon/mace/stunmace/extinguish()
	if(on)
		var/mob/living/user = loc
		if(istype(user))
			user.electrocute_act(5, src)
		on = FALSE
		charge = 0
		force = 25
		force_wielded = 25
		update_icon()
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

///Peasantry / Militia Weapon Pack///

/obj/item/rogueweapon/woodstaff/militia
	force = 20
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH, SPEAR_CUT_1H)
	gripped_intents = list(/datum/intent/pick/ranged, /datum/intent/spear/thrust, SPEAR_BASH)
	name = "民兵古登棒"
	desc = "棍棒，以及它们那些带刺的后裔，比大多数语言与文明都更加古老。不过岁月并未让它们少上一分致命。"
	icon_state = "peasantwarclub"
	icon = 'icons/roguetown/weapons/64.dmi'
	smeltresult = /obj/item/rogueore/coal
	sharpness = IS_SHARP
	walking_stick = TRUE
	wdefense = 6
	max_blade_int = 140

/obj/item/rogueweapon/woodstaff/militia/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/greataxe/militia
	name = "民兵长柄战斧"
	desc = "铲子在民兵的生涯里始终有其意义。只不过这把长柄战斧如今不再负责挖尸坑，而是负责把尸坑填满。"
	icon_state = "peasantwaraxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/axe/chop/battle/greataxe, /datum/intent/sword/peel/big, SPEAR_BASH)
	force = 15
	force_wielded = 25
	minstr = 10
	max_blade_int = 130
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	wdefense = 4
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/greataxe/militia/silver
	name = "银制民兵铲战斧"
	desc = "“你觉得普赛顿留在天界，是不是也因为祂害怕自己造出的东西？” </br>一把银铲，也许出自某个走投无路的掘墓人之手，被临时改造成了一件长柄兵器。"
	icon_state = "silvershovelwaraxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/axe/chop/battle/greataxe, /datum/intent/sword/peel/big, SPEAR_BASH)
	force = 15
	force_wielded = 25
	minstr = 11
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/silver
	wdefense = 6
	wbalance = WBALANCE_HEAVY
	is_silver = TRUE

/obj/item/rogueweapon/greataxe/militia/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/militia/silver/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/militia
	force = 18
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_CUT_1H)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH)
	name = "民兵战矛"
	desc = "干草叉与锄头本来是用来翻耕土地的。但在危难之时，民兵把它们改造成长柄武器也并不稀奇。"
	icon_state = "peasantwarspear"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 8
	max_blade_int = 120
	max_integrity = 200
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	resistance_flags = FIRE_PROOF
	light_system = MOVABLE_LIGHT
	light_power = 5
	light_outer_range = 5
	light_on = FALSE
	light_color = "#db892b"
	var/is_loaded = FALSE
	var/list/hay_types = list(/obj/structure/fluff/nest, /obj/structure/composter, /obj/structure/flora/roguegrass, /obj/item/reagent_containers/food/snacks/grown/wheat)

/obj/item/rogueweapon/spear/militia/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/warspear)

/obj/item/rogueweapon/spear/militia/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(user.Adjacent(target) || get_dist(target, user) <= user.used_intent?.reach)
		if(!is_loaded)
			for(var/type in hay_types)
				if(istype(target, type))
					load_hay()
					update_icon()
					user.regenerate_icons()
					visible_message(span_warning("[user]抓起一团[target]，将它缠到了[src]上！"))
					playsound(src, 'sound/misc/hay_collect.ogg', 100)
					qdel(target)
					break

/obj/item/rogueweapon/spear/militia/proc/load_hay()
	var/datum/component/ignitable/CI = GetComponent(/datum/component/ignitable)
	is_loaded = TRUE
	toggle_state = "peasantwarspear_hay"
	icon_state = "[toggle_state][wielded ? "1" : ""]"
	CI.make_ignitable()

/datum/component/ignitable/warspear
	single_use = TRUE
	is_ignitable = FALSE
	icon_state_ignited = "peasantwarspear_hayfire"


/datum/component/ignitable/warspear/light_off()
	..()
	if(istype(parent, /obj/item/rogueweapon/spear/militia))
		var/obj/item/rogueweapon/spear/militia/P = parent
		P.is_loaded = FALSE

//Component used to make any item gain the ability to be lit afire and turned into a light source / usable for single-use fire attack.
//Uses toggle_state for the 'on-fire' sprites.
//By default, all it does is become ignited when you click a fire / light source with it, and spread it to anything else, then extinguish.
/datum/component/ignitable
	var/is_ignitable = TRUE	//This var makes it actually ignitable, so you want to handle it on a per-item-with-component basis.
	var/is_active
	var/single_use = TRUE
	var/icon_state_ignited

/datum/component/ignitable/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, PROC_REF(on_fireact))

/datum/component/ignitable/proc/on_fireact(added, maxstacks)
	if(is_ignitable && !is_active)
		light_on()

/datum/component/ignitable/proc/make_ignitable()
	if(!is_ignitable && !is_active)
		is_ignitable = TRUE

/datum/component/ignitable/proc/light_on()
	var/obj/I = parent
	I.set_light_on(TRUE)
	playsound(I.loc, 'sound/items/firelight.ogg', 100)
	is_active = TRUE
	is_ignitable = FALSE
	update_icon()

/datum/component/ignitable/proc/light_off()
	var/obj/I = parent
	I.set_light_on(FALSE)
	playsound(get_turf(I), 'sound/items/firesnuff.ogg', 100)

/datum/component/ignitable/proc/update_icon()
	var/obj/item/I = parent
	if(is_active)
		I.toggle_state = "[icon_state_ignited]"
		I.icon_state = "[icon_state_ignited][I.wielded ? "1" : ""]"
	else
		I.icon_state = "[initial(I.icon_state)][I.wielded ? "1" : ""]"
		I.toggle_state = null
		I.update_icon()


/datum/component/ignitable/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	var/ignited = FALSE
	if(user.used_intent?.reach >= get_dist(target, user))
		if(is_active)
			if(isobj(target))
				var/obj/O = target
				if(!(O.resistance_flags & FIRE_PROOF))
					O.spark_act()
					O.fire_act()
					ignited = TRUE
			if(isliving(target))
				var/mob/living/M = target
				M.adjust_fire_stacks(5)
				M.ignite_mob()
				ignited = TRUE
			if(ignited && single_use)
				is_active = FALSE
				light_off()
				update_icon()
				user.regenerate_icons()
		else if(is_ignitable && !is_active)
			if(isobj(target))
				var/obj/O = target
				if(O.damtype == BURN || O.light_on == TRUE)	//Super hacky, but should work on every conventional source you'd expect to ignite it. But also a few other weird ones.
					light_on()
					user.regenerate_icons()



/datum/component/ignitable/proc/on_examine(datum/source, mob/user, list/examine_list)
	return

/obj/item/rogueweapon/scythe
	force = 15
	force_wielded = 25
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/cut/scythe, SPEAR_BASH, MACE_STRIKE)
	name = "战镰"
	desc = "田野的克星，草叶的修剪者，小麦的收割人，或者按某些人的说法，还是将灵魂送往来世的牧者。"
	icon_state = "peasantscythe"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 120
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	associated_skill = /datum/skill/labor/farming
	walking_stick = TRUE
	wdefense = 6
	thrown_bclass = BCLASS_BLUNT
	throwforce = 10
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/scythe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/pick/militia
	name = "民兵长战镐"
	desc = "说到底，骑士的尖顶盔和一块特别大的石头也没多大区别。毕竟两者在遇上磨尖的镐头时，都会轻易裂开。"
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick, /datum/intent/stab/militia)
	icon_state = "milpick"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	sharpness = IS_SHARP
	wlength = WLENGTH_SHORT
	max_blade_int = 140
	max_integrity = 400
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/labor/mining
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/iron
	wdefense = 2
	wdefense_wbonus = 4
	wbalance = WBALANCE_NORMAL

/obj/item/rogueweapon/pick/militia/steel
	force = 25
	force_wielded = 30
	name = "民兵钢制长战镐"
	desc = "说到底，骑士的尖顶盔和一块特别大的石头也没多大区别。毕竟两者在遇上磨尖的镐头时，都会轻易裂开。这把则是用钢制部件打磨而成。"
	icon_state = "milsteelpick"
	max_blade_int = 180
	max_integrity = 600
	associated_skill = /datum/skill/combat/axes
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	wdefense = 3
	wdefense_wbonus = 5
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/sword/falchion/militia
	name = "马切约夫斯基猎刀"
	desc = "这把猎剑被恰如其分地称作“农夫的弯刀”，其刃身经过重新回火，专为猎杀最危险的猎物而生。那布满锯齿的刃缘正适合撕开血肉与锁甲。"
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	icon_state = "maciejowski"
	gripped_intents = list(/datum/intent/rend, /datum/intent/sword/chop/militia, /datum/intent/sword/peel, /datum/intent/sword/strike)
	force = 18
	force_wielded = 25
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/iron
	wdefense = 3
	wbalance = WBALANCE_HEAVY

/datum/intent/peculate
	name = "夺貌"
	hitsound = null
	desc = "窃取他人的外貌。"
	icon_state = "peculate"

//Unique assassin/antag dagger.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane
	name = "亵渎匕首"
	desc = "一把由受诅黑钢打造的亵渎匕首。低语不断自其柄首宝石中渗出。"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/peculate)
	sellprice = 250
	icon_state = "pdagger"
	embedding = list("embed_chance" = 0) // Embedding the cursed dagger has the potential to cause duping issues. Keep it like this unless you want to do a lot of bug hunting.
	resistance_flags = INDESTRUCTIBLE
	stealthy_audio = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ASSASSIN))
		. += "亵渎匕首低语道：“[span_danger("我们到了！")]”"

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pickup(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!HAS_TRAIT(H, TRAIT_ASSASSIN)) // Non-assassins don't like holding the profane dagger.
			H.add_stress(/datum/stressevent/profane)
			to_chat(M, "<span class='danger'>当你拾起这把匕首时，呼吸都变得冰冷。你感到一种不祥而悖逆的异样！</span>")
			var/message = pick(
				"<span class='danger'>救救我……</span>",
				"<span class='danger'>救我出去……</span>",
				"<span class='danger'>好冷……</span>",
				"<span class='danger'>放了我们吧……求你了……</span>",
				"<span class='danger'>Necra……带……我们走……</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "亵渎匕首低语道：“[message]”")
		else
			var/message = pick(
				"<span class='danger'>为什么……</span>",
				"<span class='danger'>……是谁派你来的？</span>",
				"<span class='danger'>……你会为自己做过的事付出代价……</span>",
				"<span class='danger'>我恨你……</span>",
				"<span class='danger'>谁来阻止他们！</span>",
				"<span class='danger'>卫兵！救命！</span>",
				"<span class='danger'>……你手里拿着什么？</span>",
				"<span class='danger'>……你爱我……不是吗？</span>",
				"<span class='danger'>等等……我是不是认识你？</span>",
				"<span class='danger'>我还以为你是……我的朋友……</span>",
				"<span class='danger'>我已经被困在这里多久了……</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "亵渎匕首低语道：“[message]”")

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pre_attack(mob/living/carbon/human/target, mob/living/user = usr, params)
	if(!istype(target))
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted)) // Check to see if the dagger will do 20 damage or 14
		force = 20 * 2	//vs trait havers, 2x damage over a steel knife
	else
		force = 20 + 4	//vs non-trait havers, 4 more damage over a steel knife
	return FALSE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/afterattack(mob/living/carbon/human/target, mob/living/user = usr, proximity)
	. = ..()
	if(!ishuman(target))
		return
	if(target.stat == DEAD || (target.health < target.crit_threshold)) // Trigger soul steal or identity theft if the target is either dead or in crit
		if(istype(user.used_intent, /datum/intent/peculate))
			if(!ishuman(user)) // carbons don't have all features of a human
				to_chat(user, span_danger("你做不到那样！"))
				return
			var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
			if(QDELETED(target_head))
				to_chat(user, span_notice("我得拿到他们的头，否则就没法确认这笔血赏！"))
				return

			var/datum/beam/transfer_beam = user.Beam(target, icon_state = "drain_life", time = 6 SECONDS)

			playsound(
				user,
				get_sfx("changeling_absorb"), //todo: turn sound keys into defines.
				100,
			)
			to_chat(user, span_danger("我开始夺取 [target] 的身份。"))
			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			playsound( // and anotha one
				user,
				get_sfx("changeling_absorb"),
				100,
			)

			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			if(!user.client)
				qdel(transfer_beam)
				return
			qdel(transfer_beam)

			var/mob/living/carbon/human/human_user = user

			human_user.copy_physical_features(target)
			to_chat(user, span_purple("我披上了一副新的面孔……"))
			ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)

			return

		if(target.has_flaw(/datum/charflaw/hunted)) // The profane dagger only thirsts for those who are hunted, by flaw or by zizoid curse.
			if(target.client == null) //See if the target's soul has left their body
				to_chat(user, "<span class='danger'>你目标的灵魂早已逃离尸身……你试图把它重新唤回来！</span>")
				get_profane_ghost(target,user) //Proc to capture a soul that has left the body.
			else
				user.adjust_triumphs(1)
				init_profane_soul(target, user) //If they are still in their body, send them to the dagger!

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/init_profane_soul(mob/living/carbon/human/target, mob/user)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_ASSASSINATIONS)
	var/mob/dead/observer/profane/S = new /mob/dead/observer/profane(src)
	S.AddComponent(/datum/component/profaned, src)
	S.name = "[target.real_name]的灵魂"
	S.real_name = "[target.real_name]的灵魂"
	S.deadchat_name = target.real_name
	S.ManualFollow(src)
	S.key = target.key
	S.language_holder = target.language_holder.copy(S)
	target.visible_message("<span class='danger'>[target] 的灵魂被硬生生从体内扯出，吸进了那把亵渎匕首！</span>", "<span class='danger'>我的灵魂被困进了亵渎匕首里。该死！</span>")
	playsound(src, 'sound/magic/soulsteal.ogg', 100, extrarange = 5)
	blade_int = max_blade_int // Stealing a soul successfully sharpens the blade.
	obj_fix(max_integrity) // And fixes the dagger. No blacksmith required!

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/get_profane_ghost(mob/living/carbon/human/target, mob/user)
	var/mob/dead/observer/chosen_ghost
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit() //Check if a soul has already gone to the underworld
	if(underworld_spirit) // If they are in the underworld, pull them back to the real world and make them a normal ghost. Necra can't save you now!
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		chosen_ghost = ghost.get_ghost(TRUE,TRUE)
	else //Otherwise, try to get a ghost from the real world
		chosen_ghost = target.get_ghost(TRUE,TRUE)
	if(!chosen_ghost || !chosen_ghost.client) // If there is no valid ghost or if that ghost has no active player
		return FALSE
	user.adjust_triumphs(1)
	init_profane_soul(target, user) // If we got the soul, store them in the dagger.
	qdel(target) // Get rid of that ghost!
	return TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/release_profane_souls(mob/user) // For ways to release the souls trapped within a profane dagger, such as a Necrite burial rite. Returns the number of freed souls.
	var/freed_souls = 0
	for(var/mob/dead/observer/profane/A in src) // for every trapped soul in the dagger, whether they have left the game or not
		to_chat(A, "<b>我已从那可憎的牢笼中解脱，如今只待 Necra 冰冷的掌握降临。得救了！</b>")
		A.returntolobby() //Send the trapped soul back to the lobby
		user.visible_message("<span class='warning'>[A.name] 自亵渎匕首中流泻而出，终于摆脱了它的掌控。</span>")
		freed_souls += 1
	user.visible_message("<span class='warning'>亵渎匕首炸裂成一团腐臭烟雾！</span>")
	qdel(src) // Delete the dagger. Forevermore.
	return freed_souls

/datum/component/profaned
	var/atom/movable/container

/datum/component/profaned/Initialize(atom/movable/container)
	if(!istype(parent, /mob/dead/observer/profane))
		return COMPONENT_INCOMPATIBLE
	var/mob/dead/observer/profane/S = parent

	src.container = container

	S.forceMove(container)

//Standard of the keep.
//Big ol' flag that they keep to give bonuses, used by the manorguard standard bearer.
/obj/item/rogueweapon/spear/keep_standard
	name = "公爵战旗"
	desc = "本地领主的旗帜，被装在黑钢长枪上，化作致命的战争兵器。 \
	据说执掌此旗之人会为其家门，以及守护他的人，带来莫大好运。 \
	<small>枪锋附近有符文微微泛光。这无疑是奥术的征兆。</small>"
	force = 12//Use this in TWO HANDS.
	force_wielded = 34//+4. +1 from boar spear.
	throwforce = 32//It'll be funny. Trust.
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(SPEAR_THRUST, /datum/intent/spear/bash/ranged, /datum/intent/mace/smash/eaglebeak)//GET THEM OFF OF ME!!! OOOUGH!!!
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "standard_old"
	max_blade_int = 260
	max_integrity = 300//+50 from base. Because blacksteel or something.
	smeltresult = /obj/item/ingot/blacksteel
	resistance_flags = FIRE_PROOF
	var/active_item = FALSE
	var/repair_amount = 20
	var/repair_time = 3 MINUTES//Quite some time for a full repair.
	var/last_repair
	var/secondary_tag = FALSE//Does this have two flag states?

//This is an eagle's beak greataxe combination, basically, with some quirks.
//Will actual poleaxes function like this? No. But it's a unique fluff weapon right now.
//At least, when I make them into their own weapon class.
//May as well make it unique, in some regard, until that point.
/obj/item/rogueweapon/spear/keep_standard/poleaxe
	desc = "本地领主的旗帜，被装在长柄战斧上，化作致命的战争兵器。 \
	据说执掌此旗之人会为其家门，以及守护他的人，带来莫大好运。 \
	<small>武器顶端附近的符文偶尔会在瞬息之间亮起。这无疑是奥术的征兆。</small>"
	force_wielded = 30//-4. You know why. Look at the intents.
	minstr = 12//+1 over the eagle's beak.
	max_blade_int = 200//+20 over the eagle's beak. -60 from the pike.
	max_integrity = 260//-40 from parent. No longer blacksteel, but great all the same.
	smeltresult = /obj/item/ingot/steel
	gripped_intents = list(/datum/intent/spear/thrust/eaglebeak, /datum/intent/spear/bash/poleaxe, \
	/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe)//You get special intents, you special guy, you...
	icon_state = "standard"
	secondary_tag = TRUE

//This is awful and I apologise.
/obj/item/rogueweapon/spear/keep_standard/attack_self(mob/living/user)
	..()
	if(secondary_tag)
		if(wielded)
			detail_tag = "_det1"
			update_icon()
			user.update_inv_hands()
		else
			detail_tag = "_det"
			update_icon()
			user.update_inv_hands()

/obj/item/rogueweapon/spear/keep_standard/equipped(mob/living/user)
	. = ..()
	if(secondary_tag)
		detail_tag = "_det"
		update_icon()
	if(active_item)
		return
	active_item = TRUE
	if(user.job == "Man at Arms" || user.job == "Janissary")
		to_chat(user, span_suppradio("战旗上的符文脉动着，承认我是它的<b>主人</b>。"))
		user.change_stat(STATKEY_LCK, 3)
		user.add_stress(/datum/stressevent/keep_standard)
		ADD_TRAIT(user, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)//KEEP AT IT!!
		ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)//AND KEEP UP!!!
		if(HAS_TRAIT(user, TRAIT_STANDARD_BEARER))
			to_chat(user, span_suppradio("<small>它依然随时听候你的号令。你只需开口。</small>"))
			user.verbs |= /mob/proc/standard_position
			user.verbs |= /mob/proc/standard_recuperate
			user.verbs |= /mob/proc/standard_steady
			user.verbs |= /mob/proc/standard_rally
	else
		to_chat(user, span_suicide("战旗上的符文脉动着，拒绝承认我是它的<b>主人</b>。"))

/obj/item/rogueweapon/spear/keep_standard/dropped(mob/living/user)
	..()
//	if(secondary_tag)
//		detail_tag = "_det"
	if(!active_item)
		return
	active_item = FALSE
	if(user.job == "Man at Arms" || user.job == "Janissary")
		to_chat(user, span_monkeyhive("战旗上的符文有节奏地脉动着，仿佛因你放开掌控而感到惋惜。"))
		user.change_stat(STATKEY_LCK, -3)
		user.remove_stress(/datum/stressevent/keep_standard)
		REMOVE_TRAIT(user, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		if(HAS_TRAIT(user, TRAIT_STANDARD_BEARER))
			to_chat(user, span_monkeyhive("<small>我感到一阵不适。方才那是个错误吗？</small>"))
			user.verbs -= /mob/proc/standard_position
			user.verbs -= /mob/proc/standard_recuperate
			user.verbs -= /mob/proc/standard_steady
			user.verbs -= /mob/proc/standard_rally
	else
		to_chat(user, span_suicide("我一松手，战旗上的符文便脉动起来，像是终于松了口气。"))

/obj/item/rogueweapon/spear/keep_standard/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity < max_integrity)
		START_PROCESSING(SSobj, src)
		return

/obj/item/rogueweapon/spear/keep_standard/process()
	if(obj_integrity >= max_integrity)
		STOP_PROCESSING(SSobj, src)
		src.visible_message(span_notice("[src]在符文脉动中扭曲弯折，自行修复如初……"), vision_distance = 1)
		return
	else if(world.time > src.last_repair + src.repair_time)
		src.last_repair = world.time
		obj_integrity = min(obj_integrity + src.repair_amount, src.max_integrity)
	..()

//Shameless copy of how clothes handle it.
/obj/item/rogueweapon/spear/keep_standard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/rogueweapon/spear/keep_standard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/rogueweapon/spear/keep_standard/lordcolor(primary,secondary)
	detail_tag = "_det"
	detail_color = primary
	update_icon()

/obj/item/rogueweapon/spear/keep_standard/Destroy()
	GLOB.lordcolor -= src
	return ..()
