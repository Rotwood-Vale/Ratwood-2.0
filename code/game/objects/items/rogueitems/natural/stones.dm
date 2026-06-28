GLOBAL_LIST_INIT(stone_sharpness_names, list(
	"锋利的",
	"凶悍的",
	"夺命的",
	"锐利的",
	"尖利的",
	"有刃的",
	"猛烈的",
	"刺痛的",
))

GLOBAL_LIST_INIT(stone_sharpness_descs, list(
	"它有一道凶悍的锋刃。",
	"这块石头就像一把刀。",
	"它有一面是尖的。",
	"它带着锯齿状的刃。",
))

GLOBAL_LIST_INIT(stone_bluntness_names, list(
	"钝重的",
	"圆滚的",
	"沉重的",
	"结实的",
	"胖墩的",
	"富态的",
	"厚实的",
	"矮胖的",
	"壮实的",
	"圆润的",
))

GLOBAL_LIST_INIT(stone_bluntness_descs, list(
	"它钝得很。",
	"它相当有分量。",
	"握在手里满满当当。",
	"握着还挺趁手。",
	"这块石头简直是为我量身定做的！",
))

GLOBAL_LIST_INIT(stone_magic_names, list(
	"微光闪烁的",
	"发光的",
	"附魔的",
	"古老的",
	"奥秘的",
	"增强的",
	"魔法的",
	"神秘的",
	"光芒四射的",
	"吟唱的",
	"美丽的",
	"诱人的",
	"魅惑的",
	"邪恶的",
	"神话般的",
	"凶煞的",
	"天堂般的",
	"天使般的",
	"恶魔般的",
	"魔鬼般的",
	"顽皮的",
))

GLOBAL_LIST_INIT(stone_magic_descs, list(
	"它内部发出嗡嗡的能量波动。",
	"它带着一层淡淡的光晕。",
	"上面刻着一个奇怪的符文。",
	"上面嵌着一颗小小的红色石头。",
	"表面布满了细小的裂纹。",
	"总感觉这东西不太安全。",
))

GLOBAL_LIST_INIT(stone_personalities, list(
	"仇恨",
	"愚蠢",
	"哀悼",
	"荣耀",
	"坚如磐石",
	"冷静",
	"愤怒",
	"暴怒",
	"虚荣",
	"规避风险",
	"胆大妄为",
	"野蛮",
	"花哨",
	"悠闲",
	"贪婪",
	"邪恶",
	"善良",
	"中立",
	"骄傲",
	"色欲",
	"懒惰",
	"胜利",
	"败北",
	"反冲",
	"冲击",
	"穿刺",
	"毁灭",
	"地狱",
	"基佐",
	"烈焰",
	"黑暗",
	"光明",
	"英雄气概",
	"天堂",
	"懦夫",
	"征服者",
	"征服",
	"毛骨悚然",
	"恐怖",
	"地震",
	"雷霆",
))

GLOBAL_LIST_INIT(stone_personality_descs, list(
	"这块石头充满了个性！",
	"据说智慧种族都是拿石头打地基的。",
	"真让人好奇：这块石头究竟从何而来？",
	"如果所有石头都这样，那它们可都是些了不起的石头。",
	"真希望我的性格也能像这块石头一样……",
	"有了这块石头，我肯定能干成不少事。",
	"我爱石头！",
))

/obj/item/natural/stone
	name = "石头"
	icon_state = "stone1"
	desc = "一块粗糙打磨过的石头。"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 15
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	associated_skill = /datum/skill/combat/unarmed
	mill_result = /obj/item/reagent_containers/powder/mineral
	/// If our stone is magical, this lets us know -how- magical. Maximum is 15.
	var/magic_power = 0
	sharpening_factor = 12
	spark_chance = 35

/obj/item/natural/stone/Initialize(mapload)
	. = ..()
	stone_lore()

	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/stoneaxe,
		/datum/crafting_recipe/roguetown/survival/stonehammer,
		/datum/crafting_recipe/roguetown/survival/stonepick,
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/stonetongs,
		/datum/crafting_recipe/roguetown/survival/stoneknife,
		/datum/crafting_recipe/roguetown/survival/stonespear,
		/datum/crafting_recipe/roguetown/survival/stonesword,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/whetstone
	name = "磨刀石"
	icon_state = "whetstone"
	desc = "一块磨制好的石片，可用于打磨刀刃和击出火花。"
	force = 12
	throwforce = 18
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	mill_result = /obj/item/reagent_containers/powder/mineral
	possible_item_intents = list(/datum/intent/hit, /datum/intent/dagger/cut)
	sharpening_factor = 21
	spark_chance = 80

/*
	This right here is stone lore,
	Yakub from BBC lore has inspired me
*/
/obj/item/natural/stone/proc/stone_lore()
	var/stone_title = "石头" // Our stones title
	var/stone_desc = "[desc]" // Total Bonus desc the stone will be getting

	icon_state = "stone[rand(1,5)]"

	var/bonus_force = 0 // Total bonus force the rock will be getting
	var/list/given_intent_list = list(/datum/intent/hit) // By default you get this at least
	var/list/extra_intent_list = list() // List of intents that we can possibly give it by the end of this
	var/list/blunt_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	var/list/sharp_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)

	var/bluntness_rating = rand(0,10)
	var/sharpness_rating = rand(0,10)

	var/stone_personality_rating = rand(0,25)

	//This is so sharpness and bluntness's name and descs come in randomly before or after each other
	//Magic will always be in front for now, and personality will be after magic.
	var/list/name_jumbler = list()
	var/list/desc_jumbler = list()

	switch(bluntness_rating)
		if(2 to 8)
			extra_intent_list += pick(blunt_intents) // Add one
		if(9 to 10)
			for(var/muhdik in blunt_intents) // add all intent to possible things
				extra_intent_list += muhdik

			name_jumbler += pick(GLOB.stone_bluntness_names)
			desc_jumbler += pick(GLOB.stone_bluntness_descs)

	switch(sharpness_rating)
		if(2 to 8)
			extra_intent_list += pick(sharp_intents) // Add one
		if(9 to 10)
			for(var/mofugga in sharp_intents) // add all intent to possible things
				extra_intent_list += mofugga

			name_jumbler += pick(GLOB.stone_sharpness_names)
			desc_jumbler += pick(GLOB.stone_sharpness_descs)

	if(name_jumbler.len) // Both name jumbler and desc jumbler should be symmetrical in insertions conceptually anyways.
		for(var/i in 1 to name_jumbler.len) //Theres only two right now
			if(!name_jumbler.len) // If list somehow empty get the hell out! Now~!
				break
			//Remove so theres no repeats
			var/picked_name = pick(name_jumbler)
			name_jumbler -= picked_name
			var/picked_desc = pick(desc_jumbler)
			desc_jumbler -= picked_desc

			stone_title = "[picked_name][stone_title]" // Prefix and then stone
			stone_desc += " [picked_desc]" // We put the descs after the original one

	var/personality_modifier = 0
	switch(stone_personality_rating)
		if(10 to 22)
			if(prob(3)) // Stone has a 3 percent chance to have a personality despite missing its roll
				stone_title = "[pick(GLOB.stone_personalities)]之[stone_title]"
				stone_desc += " [pick(GLOB.stone_personality_descs)]"
				personality_modifier += rand(1,5) // Personality gives a stone some more power too
		if(23 to 25)
			stone_title = "[pick(GLOB.stone_personalities)]之[stone_title]"
			stone_desc += " [pick(GLOB.stone_personality_descs)]"
			personality_modifier += rand(1,5) // Personality gives a stone some more power too

	if (personality_modifier)
		bonus_force += personality_modifier
		magic_power += personality_modifier

	var/max_force_range = sharpness_rating + bluntness_rating // Add them together
	//max_force_range = round(max_force_range/2) // Divide by 2 and round jus incase

	bonus_force = rand(0, max_force_range) // Your total bonus force is now between 1 and your sharpness/bluntness totals

	if(prob(5)) // We hit the jackpot, a magical stone! JUST FOR ME!
		filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		var/magic_force = rand(1,10) //Roll, we need this seperate for now otherwise people will know the blunt/sharp boosts too
		stone_title = "[pick(GLOB.stone_magic_names)][stone_title] +[magic_force]"
		stone_desc += " [pick(GLOB.stone_magic_descs)]"
		bonus_force += magic_force // Add on the magic force modifier
		magic_power += magic_force

	if(extra_intent_list.len)
		for(var/i in 1 to min(4, extra_intent_list.len))
			// No more than 4 bro, and if we are empty on intents just stop here
			if(!length(extra_intent_list))
				break
			var/cock = pick(extra_intent_list) // We pick one
			given_intent_list += cock // Add it to the list
			extra_intent_list -= cock // Remove it from the prev list

	//Now that we have built the history and lore of this stone, we apply it to the main vars.
	name = stone_title
	desc = stone_desc
	force += bonus_force // This will result in a stone that has only 40 max at a extremely low chance damage at this time of this PR.
	throwforce += bonus_force // It gets added to throw damage too
	possible_item_intents = given_intent_list // And heres ur new extra intents too

/obj/item/natural/stone/attackby(obj/item/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_level = user.get_skill_level(/datum/skill/craft/masonry)
	var/work_time = (35 - (skill_level * 5))
	if(istype(W, /obj/item/natural/stone))
		playsound(src.loc, pick('sound/items/stonestone.ogg'), 100)
		user.visible_message(span_info("[user]将两块石头互相敲击。"))
		if(prob(10))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user,user.dir)
			S.set_up(1, 1, front)
			S.start()
	if( user.used_intent.type == /datum/intent/chisel )
		if(istype(W, /obj/item/rogueweapon/chisel/assembly))
			var/obj/item/rogueweapon/chisel/assembly/chisel_set = W
			if(chisel_set.wielded)
				var/turf/work_turf = get_turf(src)
				var/obj/item/natural/stone/current_stone = src
				while(current_stone)
					playsound(current_stone.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
					user.visible_message("<span class='info'>[user] chisels the stone into a block.</span>")
					if(!do_after(user, work_time, target = current_stone))
						return
					new /obj/item/natural/stoneblock(get_turf(current_stone.loc))
					if(HAS_TRAIT(user, TRAIT_MASTER_MASON)) //double the amount for any in a stone worker role
						new /obj/item/natural/stoneblock(get_turf(current_stone.loc))
					new /obj/effect/decal/cleanable/debris/stony(get_turf(current_stone))
					playsound(current_stone.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
					qdel(current_stone)
					user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
					if(QDELETED(chisel_set) || !chisel_set.wielded)
						return
					var/obj/item/natural/stone/next_stone = null
					for(var/obj/item/natural/stone/S in work_turf)
						next_stone = S
						break
					if(!next_stone)
						return
					current_stone = next_stone
				return
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将石头凿成方块。</span>")
		if(do_after(user, work_time))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			if(HAS_TRAIT(user, TRAIT_MASTER_MASON)) //double the amount for any in a stone worker role
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			qdel(src)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿方块。"))
	else if(user.used_intent.type == /datum/intent/wing/shred && !user.cmode || user.used_intent.type == /datum/intent/wing/cut && !user.cmode)
		playsound(src.loc, pick('sound/items/sharpen_long1.ogg','sound/items/sharpen_long2.ogg'), 100, TRUE)
		user.visible_message(span_notice("[user]打磨了[W]！"))
		W.add_bintegrity(12, user)
		if(prob(35))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user,user.dir)
			S.set_up(1, 1, front)
			S.start()
	else
		..()

//rock munching
/obj/item/natural/stone/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(M.construct)
			var/healydoodle = magic_power+1
			M.apply_status_effect(/datum/status_effect/buff/rockmuncher, healydoodle)
			qdel(src)
			if(M == user)
				user.visible_message(span_notice("[user]把石头按在自己的身上，石头被吸收了。"), span_notice("我吸收了石头。"))
			else
				user.visible_message(span_notice("[user]把石头按在[M]的身上, 石头被吸收了"), span_notice("我把石头按在[M]身上, 石头被吸收了。"))

		if(iskobold(M))
			if(M == user)
				user.visible_message(span_warning("[user]正试图吃掉[src]！"), span_warning("我开始吃[src]！"))
			else
				user.visible_message(span_warning("[user]开始强迫[M]吃下[src]！"), span_warning("我试图强迫[M]吃下[src]！"))
			if(do_after(user, 40))
				M.reagents.add_reagent(/datum/reagent/consumable/nutriment, magic_power*1.2)
				var/healydoodle_again = magic_power+1
				M.apply_status_effect(/datum/status_effect/buff/rockmuncher_lesser, healydoodle_again)
				playsound(get_turf(src), 'modular_azurepeak/sound/spellbooks/icicle.ogg', 100)
				qdel(src)
				if(M == user)
					user.visible_message(span_danger("[user]吃掉了[src]！"), span_danger("我吞下了[src]！"))
				else
					user.visible_message(span_danger("[user]强迫[M]吃掉了[src]！"), span_danger("我强迫[M]吃掉了[src]！"))


		else // if theyre not either a construct or kobold, and we're not in cmode, beat them 2 death with rocks.
			return ..()
	else // if we're in cmode, beat them to death with rocks.
		return ..()

/obj/item/natural/rock
	name = "巨石"
	desc = "一块露出地面的岩石。"
	icon_state = "stonebig1"
	dropshrink = 0
	throwforce = 25
	grid_width = 96
	grid_height = 96
	throw_range = 2
	force = 20
	obj_flags = CAN_BE_HIT
	force_wielded = 22
	gripped_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	var/obj/item/rogueore/mineralType = null
	var/mineralAmt = 1
	associated_skill = /datum/skill/combat/unarmed
	blade_dulling = DULLING_BASH
	max_integrity = 100
	minstr = 11
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'


/obj/item/natural/rock/Initialize(mapload)
	icon_state = "stonebig[rand(1,2)]"
	..()


/obj/item/natural/rock/Crossed(mob/living/L)
	if(istype(L) && !L.throwing)
		if(L.m_intent == MOVE_INTENT_RUN)
			L.visible_message(span_warning("[L] 被巨石绊倒了！"),span_warning("我被巨石绊倒了！"))
			L.Knockdown(10)
			L.consider_ambush(always = TRUE)
	..()

/obj/item/natural/rock/attacked_by(obj/item/I, mob/living/user)
	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			record_featured_stat(FEATURED_STATS_MINERS, user)

/obj/item/natural/rock/deconstruct(disassembled = FALSE)
	if(!disassembled)
		if(mineralType && mineralAmt)
			if(has_world_trait(/datum/world_trait/malum_diligence))
				mineralAmt += rand(1,2)
			new mineralType(src.loc, mineralAmt)
		for(var/i in 1 to rand(1,4))
			var/obj/item/S = new /obj/item/natural/stone(src.loc)
			S.pixel_x = rand(25,-25)
			S.pixel_y = rand(25,-25)
		record_round_statistic(STATS_ROCKS_MINED)
	qdel(src)

/obj/item/natural/rock/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(damage_amount > 10)
			if(prob(10))
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()

/obj/item/natural/rock/attackby(obj/item/W, mob/living/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	var/skill_level = user.get_skill_level(/datum/skill/craft/masonry)
	var/work_time = (120 - (skill_level * 15))
	if(istype(W, /obj/item/natural/stone))
		user.visible_message(span_info("[user]用石头敲击巨石。"))
		playsound(src.loc, 'sound/items/stonestone.ogg', 100)
		if(prob(35))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
		return
	if(istype(W, /obj/item/natural/rock))
		playsound(src.loc, pick('sound/items/stonestone.ogg'), 100)
		user.visible_message(span_info("[user]将两块巨石互相敲击。"))
		if(prob(10))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
		return
	if(istype(W, /obj/item/rogueweapon/pick))
		if(!isliving(user))
			return ..()
		var/mob/living/living_user = user
		if(!living_user.client || !living_user.client.prefs?.autopicking)
			return ..()
		user.doing = FALSE
		while(!QDELETED(src) && user.Adjacent(src))
			if((living_user.energy <= 0))
				break
			if(!do_after(user, CLICK_CD_MELEE, TRUE, src))
				break
			..()
		return
	if( user.used_intent.type == /datum/intent/chisel )
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将巨石凿成石块。</span>")
		if(do_after(user, work_time))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			if(HAS_TRAIT(user, TRAIT_MASTER_MASON)) //double the amount for any in a stone worker role
				new /obj/item/natural/stoneblock(get_turf(src.loc))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.5))
			qdel(src)
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿方块。"))
	..()

//begin ore loot rocks
/obj/item/natural/rock/gold
	mineralType = /obj/item/rogueore/gold

/obj/item/natural/rock/silver
	mineralType = /obj/item/rogueore/silver

/obj/item/natural/rock/iron
	mineralType = /obj/item/rogueore/iron

/obj/item/natural/rock/copper
	mineralType = /obj/item/rogueore/copper

/obj/item/natural/rock/tin
	mineralType = /obj/item/rogueore/tin

/obj/item/natural/rock/coal
	mineralType = /obj/item/rogueore/coal

/obj/item/natural/rock/elementalmote
	mineralType = /obj/item/magic/elemental/mote

/obj/item/natural/rock/cinnabar
	mineralType = /obj/item/rogueore/cinnabar

/obj/item/natural/rock/salt
	mineralType = /obj/item/reagent_containers/powder/salt

/obj/item/natural/rock/gem
	mineralType = /obj/item/roguegem/random

/obj/item/natural/rock/random_ore
	name = "石头？"
	desc = "等等，这东西不该出现在这里吧？"
	icon_state = "stonerandom"

/obj/item/natural/rock/random/Initialize(mapload)
	. = ..()
	var/obj/item/natural/rock/theboi = pick(list(
		/obj/item/natural/rock/gold,
		/obj/item/natural/rock/iron,
		/obj/item/natural/rock/coal,
		/obj/item/natural/rock/salt,
		/obj/item/natural/rock/silver,
		/obj/item/natural/rock/copper,
		/obj/item/natural/rock/tin,
		/obj/item/natural/rock/gem
	))
	new theboi(get_turf(src))
	return INITIALIZE_HINT_QDEL

//................	Stone blocks	............... //
/obj/item/natural/stoneblock
	name = "石块"
	desc = "一块用于建造的长方形石块。"
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "stoneblock"
	drop_sound = 'sound/foley/brickdrop.ogg'
	hitsound = 'sound/foley/brickdrop.ogg'
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 18 //brick is valid weapon
	w_class = WEIGHT_CLASS_SMALL
	bundletype = /obj/item/natural/bundle/stoneblock
	sellprice = 2

/obj/item/natural/stoneblock/attackby(obj/item, mob/living/user)
	if(item_flags & IN_STORAGE)
		return
	. = ..()

/obj/item/natural/stoneblock/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("我开始收集[src]..."))
	if(move_after(user, bundling_time, target = src))
		var/stackcount = 0
		for(var/obj/item/natural/stoneblock/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				var/obj/item/natural/stoneblock/S = new(get_turf(user))
				user.put_in_hands(S)
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/natural/bundle/stoneblock/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 4)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 4)
				user.put_in_hands(B)
		for(var/obj/item/natural/stoneblock/F in get_turf(src))
			playsound(get_turf(user.loc), 'sound/foley/stone_scrape.ogg', 100)
			qdel(F)

//................ Stone block stack	............... //
/obj/item/natural/bundle/stoneblock
	name = "一堆石块"
	desc = "一堆石块"
	icon_state = "stoneblockbundle1"
	icon = 'icons/roguetown/items/crafting.dmi'
	item_state = "block"
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 64
	base_width = 64
	base_height = 64
	drop_sound = 'sound/foley/brickdrop.ogg'
	pickup_sound = 'sound/foley/brickdrop.ogg'
	hitsound = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	possible_item_intents = list(/datum/intent/use)
	force = 2
	throwforce = 0	// useless for throwing unless solo
	throw_range = 2
	w_class = WEIGHT_CLASS_NORMAL
	stackname = "个石块"
	stacktype = /obj/item/natural/stoneblock
	maxamount = 4
	icon1 = "stoneblockbundle2"
	icon1step = 3
	icon2 = "stoneblockbundle3"
	icon2step = 4

/obj/structure/roguerock/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	var/stonetotal = 4
	if(HAS_TRAIT(user, TRAIT_MASTER_MASON)) //double the amount for any in a stone worker role
		stonetotal += stonetotal
	if( user.used_intent.type == /datum/intent/chisel )
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user]将岩石凿成了石块。</span>")
		if(do_after(user, 10 SECONDS))
			for(var/i=1, i<=stonetotal, ++i)
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			new /obj/effect/decal/cleanable/debris/stony(get_turf(src))
			playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*1))
			qdel(src)
		return
	else if(istype(W, /obj/item/rogueweapon/chisel/assembly))
		to_chat(user, span_warning("你必须用双手来凿石块。"))
