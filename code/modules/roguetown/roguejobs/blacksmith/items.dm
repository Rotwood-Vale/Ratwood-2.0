
/obj/item/roguestatue
	icon = 'icons/roguetown/items/valuable.dmi'
	name = "雕像"
	icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	experimental_inhand = FALSE
	smeltresult = null
	grid_width = 32
	grid_height = 64

/obj/item/roguestatue/gold
	name = "黄金雕像"
	desc = "一尊由沉重而闪亮的黄金制成的雕像！"
	icon_state = "gstatue1"
	smeltresult = /obj/item/ingot/gold
	sellprice = 120

/obj/item/roguestatue/gold/Initialize(mapload)
	. = ..()
	icon_state = "gstatue[pick(1,2)]"

/obj/item/roguestatue/gold/loot
	name = "黄金小雕像"
	desc = "一尊由沉重而闪亮的黄金制成的雕像！"
	icon_state = "lstatue1"
	sellprice = 45

/obj/item/roguestatue/gold/loot/Initialize(mapload)
	. = ..()
	sellprice = rand(45,150)
	icon_state = "lstatue[pick(1,2,3,4)]"

/obj/item/roguestatue/silver
	name = "白银雕像"
	desc = "一尊由纯净闪耀的白银制成的雕像！"
	icon_state = "sstatue1"
	smeltresult = /obj/item/ingot/silver
	sellprice = 90

/obj/item/roguestatue/silver/Initialize(mapload)
	. = ..()
	icon_state = "sstatue[pick(1,2)]"

/obj/item/roguestatue/steel
	name = "钢制雕像"
	desc = "一尊由坚韧钢材铸成的坚固雕像。"
	icon_state = "ststatue1"
	smeltresult = /obj/item/ingot/steel
	sellprice = 40

/obj/item/roguestatue/steel/Initialize(mapload)
	. = ..()
	icon_state = "ststatue[pick(1,2)]"

/obj/item/roguestatue/decrepit
	name = "衰朽雕像"
	desc = "一尊锻造青铜制成的雕像，用以纪念某位古老的勇士。"
	icon_state = "astatue1"
	smeltresult = /obj/item/ingot/aaslag
	sellprice = 77
	color = "#bb9696"

/obj/item/roguestatue/decrepit/Initialize(mapload)
	. = ..()
	icon_state = "astatue[pick(1,2)]"

/obj/item/roguestatue/iron
	name = "铁制雕像"
	desc = "一尊由铸铁打造的雕像！"
	icon_state = "istatue1"
	smeltresult = /obj/item/ingot/iron
	sellprice = 20

/obj/item/roguestatue/iron/Initialize(mapload)
	. = ..()
	icon_state = "istatue[pick(1,2)]"

/obj/item/roguestatue/blacksteel
	name = "黑钢雕像"
	desc = "一尊由闪亮而坚韧的黑钢铸成的深色雕像。"
	icon_state = "bsstatue1"
	smeltresult = /obj/item/ingot/blacksteel
	sellprice = 160

/obj/item/roguestatue/blacksteel/Initialize(mapload)
	. = ..()
	icon_state = "bsstatue[pick(1,2)]"
//000000000000000000000000000--

/obj/item/var/polished = FALSE
/obj/item/var/polish_bonus = 0
/obj/item/var/pottery_quality = 0
/obj/item/var/creator_skill = 0
/obj/item/var/pottery_fragile = FALSE
/obj/item/var/pottery_baked_at = 0
/obj/item/var/pottery_shatter_chance = 100

/obj/item/examine(mob/user)
	. = ..()
	switch(polished)
		if(1)
			. += span_info("上面还残留着一些抛光剂。")
		if(2, 3)
			. += span_info("它已经被彻底刷拭过了。")
		if(4)
			. += span_green("它已被细致地抛光过。")
	if(shoddy_repair)
		. += span_warning("这件物品只是被临时修补过，仍需由合格工匠彻底修复。")

/obj/item/polishing_cream
	icon = 'icons/roguetown/items/misc.dmi'
	name = "抛光膏"
	desc = "一种纯银配制的抛光膏，专为让上等金属焕发光泽而制。"
	icon_state = "cream"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8
	var/uses = 12
	grid_width = 32
	grid_height = 32

/obj/item/polishing_cream/examine(mob/user)
	. = ..()
	. += span_info("还剩 [uses] 次使用次数。")

/obj/item/polishing_cream/attack_obj(obj/O, mob/living/user)
	if(!isitem(O) || !uses)
		return ..()
	var/obj/item/thing = O
	if(!thing.anvilrepair)
		return ..()
	if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)) && thing.polished == 0 && obj_integrity <= max_integrity)
		to_chat(user, span_info("我开始往[thing]上涂抹抛光膏……"))
		if(do_after(user, 50 - user.STASPD*2, target = O))
			thing.polished = 1
			uses--
			thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
			thing.add_atom_colour("#635e65", FIXED_COLOUR_PRIORITY)
			thing.RegisterSignal(thing, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(remove_polish))
			if(uses <= 8)
				smeltresult = null
				icon_state = "low_cream"
			if(!uses)
				icon_state = "empty_cream"

/obj/item/armor_brush
	icon = 'icons/roguetown/items/misc.dmi'
	name = "细刷"
	desc = "一把用来彻底刷洗甲胄的刷子，以最上等的鲁平毛制成。"
	icon_state = "brush_0"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = null
	dropshrink = 0.6
	grid_width = 32
	grid_height = 64
	var/roughness = 0 // 0  for a fine brush, 1 for a coarse brush

/obj/item/armor_brush/examine()
	. = ..()
	. += span_info("要给武器或护甲抛光，你必须具备侍从级知识，或懂得如何修理该物品。步骤如下：")
	. += span_info("I. 先将抛光膏涂在物品上。")
	. += span_info("II. 用粗糙一面（使用物品可翻面）先进行粗刷。")
	. += span_info("III. 再用细面轻轻抛光物品。")
	. += span_info("IV. 最后在装水的木桶中清洗物品完成抛光。")
	. += span_info("完全抛光的物品会略微更强，也可能更耐用。")

/obj/item/armor_brush/attack_self(mob/user)
	roughness = 1 - roughness
	if(roughness)
		to_chat(user, span_info("我把刷子翻到了粗糙的一面。"))
		name = "粗刷"
	else
		to_chat(user, span_info("我把刷子翻到了细致的一面。"))
		name = "细刷"
	icon_state = "brush_[roughness]"

/obj/item/armor_brush/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return ..()
	var/obj/item/thing = O
	if(thing.polished == 1 && roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("我开始粗略地刷开[thing]上的抛光膏……"))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, 50 - user.STASTR*1.5, target = O))
				thing.polished = 2
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#9e9e9e", FIXED_COLOUR_PRIORITY)

	else if(thing.polished == 2 && !roughness)
		if((HAS_TRAIT(user, TRAIT_SQUIRE_REPAIR) || HAS_TRAIT(user, TRAIT_SELF_SUSTENANCE) || user.get_skill_level(thing.anvilrepair)))
			to_chat(user, span_info("我开始轻柔地打磨[thing]的边缘……"))
			playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 100, TRUE)
			if(do_after(user, 50 - user.STASTR*1.5, target = O))
				thing.polished = 3
				thing.remove_atom_colour(FIXED_COLOUR_PRIORITY)
				thing.add_atom_colour("#cccccc", FIXED_COLOUR_PRIORITY)

/obj/item/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity <= max_integrity * 0.25)
		if(polished == 4)
			polished = 0
			force -= 2
			force_wielded -= 3
			max_integrity -= polish_bonus
			polish_bonus = 0
			obj_integrity = min(obj_integrity, max_integrity)
			var/datum/component/glint = GetComponent(/datum/component/metal_glint)
			qdel(glint)
		else if(polished >= 1 && polished <= 3)
			remove_atom_colour(FIXED_COLOUR_PRIORITY)
			UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

/obj/item/proc/remove_polish(datum/source, strength) // kill polska
	if(polished == 3 && obj_integrity >= max_integrity)
		polished = 4
		remove_atom_colour(FIXED_COLOUR_PRIORITY)
		add_atom_colour("#ffffff", FIXED_COLOUR_PRIORITY)
		polish_bonus = ceil(max_integrity * 0.10)
		max_integrity += polish_bonus
		obj_integrity += polish_bonus
		force += 2
		force_wielded += 3
		AddComponent(/datum/component/metal_glint)
		UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

	else if(polished < 4)
		polished = 0
		polish_bonus = 0
		remove_atom_colour(FIXED_COLOUR_PRIORITY)
		UnregisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT)

/obj/effect/temp_visual/armor_glint
	name = "闪光"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "glint"
	alpha = 200
	duration = 13
	plane = -1

/obj/effect/temp_visual/armor_glint/Initialize(mapload, extra_rand = 1)
	. = ..()
	pixel_x = extra_rand * rand(-5,5)
	pixel_y = extra_rand * rand(-5,5)
	animate(src, alpha = 0, time = duration)

/datum/component/metal_glint/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, list(COMSIG_PARENT_QDELETING), PROC_REF(stop_process))
	START_PROCESSING(SSobj, src)

/datum/component/metal_glint/process()
	var/atom/current_parent = parent
	if(istype(current_parent.loc, /turf))
		if(prob(25))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc)
		if(prob(15))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc, 2)
		if(prob(5))
			new /obj/effect/temp_visual/armor_glint(current_parent.loc, 3)
	else if(istype(current_parent.loc, /mob/living) && istype(current_parent, /obj/item/clothing/suit/roguetown/armor))
		var/mob/M = current_parent.loc
		var/turf/T = get_turf(M)
		if(prob(8))
			new /obj/effect/temp_visual/armor_glint(T)
		if(prob(4))
			new /obj/effect/temp_visual/armor_glint(T, 2)
		if(prob(2))
			new /obj/effect/temp_visual/armor_glint(T, 3)

/datum/component/metal_glint/proc/stop_process()
	STOP_PROCESSING(SSobj, src)
