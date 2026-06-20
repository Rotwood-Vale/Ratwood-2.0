/datum/species/ooze
	name = "软泥"
	id = "ooze"
	desc = "<b>软泥</b><br>\
	在岩丘公国的地牢与废墟中，古老与新鲜的尸体遍布地面。\
	随着腐化出现在我们的领域，自然界形成了一种反应性物质——软泥。\
	它们以无智软泥的形态出现，作为重生的使者，消化死者的遗骸并中和所到之处的腐化。\
	它们不依附于任何单一神祇，仿佛是这颗星球的免疫系统获得了生命，然而在这片诅咒的谷地沃土中，有时会产生独特的结果……\
	当软泥吞食一具新鲜的、干尸化的或仅剩骨骼的尸体时，它们会保留那些散落废墟中的陨落冒险者或平民的记忆与技能。\
	获得新生后，它们会继承这顿塑造性大餐的言行举止，即使它们能意识到并能在精神上与自己的模版区分开来，尽管许多软泥会把自己当作那些死者，坚称这不过是生命中的第二次机会……<br>\
	(+1 体质 | +1 意志 | -1 智力) <br>\
	易肢解 | 肢体再生 | 无骨骼 | 无血液</b></span><br><br>"


	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,MUTCOLORS,INVISBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = FALSE
	possible_ages = ALL_AGES_LIST
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_TAUR = list(-16,0), OFFSET_TAUR_F = list(-16,0), \
		)
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_WILLPOWER = 1, STAT_INTELLIGENCE = -1)
	inherent_traits = list(
						TRAIT_NOBREATH,
						TRAIT_ZOMBIE_IMMUNE,
						TRAIT_BLOODLOSS_IMMUNE,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_NASTY_EATER,
						)
	allowed_taur_types = list(
		/obj/item/bodypart/taur/lamia,
		/obj/item/bodypart/taur/spider,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/tentacle,
		/obj/item/bodypart/taur/feline,
		/obj/item/bodypart/taur/drake,
		/obj/item/bodypart/taur/otie,
		/obj/item/bodypart/taur/deer,
		/obj/item/bodypart/taur/wasp,
		/obj/item/bodypart/taur/mermaid,
	)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
		)
	body_markings = list(
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/plain,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/bellyscaleslimsmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/drake_eyes,
		/datum/body_marking/spotted,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
//		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "软泥神经核心"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/heart/ooze
	name = "软泥流体泵"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "软泥视觉感应器"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "软泥味蕾"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "软泥消化腔"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "软泥解毒细胞器"
	icon = 'modular_ochrevalley/icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE

//SLIME FORM WOOO

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze
	name = "团块形态"
	desc = ""
	overlay_state = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 50
	cooldown_min = 50
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	convert_damage = FALSE
	do_gib = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/transformed
	melee_damage_lower = 9
	melee_damage_upper = 14
	del_on_deaggro = null
	defprob = 70

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering
	name = "痛苦的软泥"
	melee_damage_lower = 1
	melee_damage_upper = 1
	del_on_deaggro = null
	defprob = 70
	move_to_delay = 20
	STASTR = 2
	STASPD = 2

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/suffering/revive(full_heal = FALSE, admin_revive = FALSE)
	var/obj/shapeshift_holder/ooze_death/H = locate() in src
	if(H)
		H.restore()

/obj/effect/proc_holder/spell/targeted/shapeshift/ooze/Shapeshift(mob/living/caster)
	var/obj/shapeshift_holder/H = locate() in caster
	if(H)
		to_chat(caster, span_warning("你已经处于变形状态！"))
		return

	var/mob/living/shape = new shapeshift_type(caster.loc)
	if(ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		shape.color = "#[human_caster.dna.features["mcolor"]]"
	H = new(shape,src,caster)
	shape.name = "[shape]"
	shape.faction = caster.faction

	clothes_req = FALSE
	human_req = FALSE

	if(do_gib)
		playsound(caster.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		caster.spawn_gibs(FALSE)

/obj/shapeshift_holder/ooze_death/Initialize(mapload,mob/living/caster)
	if(!caster)
		return ..()
	shape = loc
	if(!istype(shape))
		CRASH("shapeshift holder created outside mob/living")
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)
	stored.forceMove(src)
	stored.notransform = TRUE
	shape.visible_message(span_warning("[stored]失去了形态，他们变得脆弱并濒临死亡。"),span_warningbig("你已濒死，无法再维持形态。需要被复活才能恢复你的人类形态。"))
	playsound(shape.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	slink = soullink(/datum/soullink/shapeshift, stored , shape)
	slink.source = src

/obj/shapeshift_holder/ooze_death/restore(death=FALSE, knockout=0)
	if(restoring || QDELETED(src))
		return

	restoring = TRUE
	qdel(slink)
	if (stored)
		stored.forceMove(get_turf(src))
		stored.notransform = FALSE

		// leave a track to indicate something has shifted out here
		var/obj/effect/track/the_evidence = new(stored.loc)
		the_evidence.handle_creation(stored)
		the_evidence.track_type = "从动物足迹扩展为人形脚印"
		the_evidence.ambiguous_track_type = "奇怪的脚印"
		the_evidence.base_diff = 6

	if(shape && shape.mind)
		shape.mind?.transfer_to(stored)
	stored.revive(full_heal = TRUE, admin_revive = FALSE)
	to_chat(stored, span_notice("Bug提示：如果你看不到表情动作，请移动到不同的z层级再返回（上/下一层）。这是一个已知的bug。"))
	stored.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/ooze)
	stored.Knockdown(200)
	stored.Stun(200)
	stored.apply_status_effect(/datum/status_effect/debuff/revived)
	stored.adjust_fire_stacks(2)
	qdel(shape)
	shape = null
