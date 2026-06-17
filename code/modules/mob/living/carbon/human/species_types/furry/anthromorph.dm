/mob/living/carbon/human/species/anthromorph
	race = /datum/species/anthromorph

/datum/species/anthromorph
	name = "Wild-Kin"
	id = "anthromorph"
	desc = "<b>兽裔</b><br>\
	兽裔是一个高度多样化的族群，其中大多数是登多尔最初追随者的后裔，\
	他们拒绝文明而选择深林生活。不过也有一部分起源于魔法异常或诅咒，无论是否神性所致。<br>\
	(+1 体质, +1 感知)"

	expanded_desc = "兽裔是一个高度多样化的族群，其中大多数是登多尔最初追随者的后裔，\
	他们拒绝文明而选择深林生活。不过也有一部分起源于魔法异常或诅咒，\
	无论是否神性所致。\
	<br><br> \ 他们的血脉因其先祖的虔诚而受到登多尔的祝福，\
	这反映在他们的外貌特征上。一些初代登多尔兽裔的后代，\
	尤其是那些不似先祖般虔诚于登多尔之道、\
	满心怀揣漫游之志者，从偏远社群中走出，\
	拥抱了他们先祖曾经拒绝的文明。\
	<br><br> \
	起初，他们因异于常人的外貌而受到人们猜忌与歧视。\
	然而他们的外貌乃是登多尔的祝福，十神教神职人员在信众的土地上宣告了这一点。\
	兽裔如今已完全被接纳，许多甚至拥有领主贵族头衔。\
	然而，围绕他们仍有一丝不信任与不确定的气氛，\
	尤其是对那些在生命历程中获得兽形特征而非与生俱来者。"

	use_titles = TRUE
	race_titles = list(
	"Cat-Kin", "Dog-Kin", "Volf-Kin", "Lion-Kin", "Venard-Kin", "Tiger-Kin", "Sheep-Kin",
	"Goat-Kin", "Rous-Kin", "Possum-Kin", "Pig-Kin", "Boar-Kin", "Rabbit-Kin", "Cabbit-Kin", "Hare-Kin", "Horse-Kin",
	"Donkey-Kin", "Hyena-Kin", "Deer-Kin", "Bear-Kin", "Panda-Kin", "Coyote-Kin", "Moose-Kin",
	"Jackal-Kin", "Panther-Kin", "Lynx-Kin", "Leopard-Kin", "Monkey-Kin", "Bird-Kin", "Seal-Kin", "Frog-Kin",
	"Bat-Kin", "Otter-Kin", "Cow-Kin", "Bull-Kin", "Bee-Kin", "Lizard-Kin", "Drakian-Kin", "Dragon-Kin", "Insect-Kin", "Spider-Kin", "Monster-Kin", "Chimera", "Moth-Kin"
	)

	default_color = "444"
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAIR,
	)

	allowed_taur_types = list(
		/obj/item/bodypart/taur/otie,
		/obj/item/bodypart/taur/canine,
		/obj/item/bodypart/taur/venard,
		/obj/item/bodypart/taur/drake,
		/obj/item/bodypart/taur/dragon,
		/obj/item/bodypart/taur/noodle,
		/obj/item/bodypart/taur/horse,
		/obj/item/bodypart/taur/goat,
		/obj/item/bodypart/taur/deer,
		/obj/item/bodypart/taur/redpanda,
		/obj/item/bodypart/taur/rat,
		/obj/item/bodypart/taur/skunk,
		/obj/item/bodypart/taur/kitsune,
		/obj/item/bodypart/taur/feline,
		/obj/item/bodypart/taur/snep,
		/obj/item/bodypart/taur/tiger,
		/obj/item/bodypart/taur/spider,
		/obj/item/bodypart/taur/centipede,
		/obj/item/bodypart/taur/sloog,
		/obj/item/bodypart/taur/ant,
		/obj/item/bodypart/taur/wasp,
		/obj/item/bodypart/taur/insect
	)

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	attack_verb = "slash"
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	possible_ages = ALL_AGES_LIST
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mta.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fma.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_BREASTS = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_BREASTS_F = list(0,-1), \
		)
	race_bonus = list(STAT_PERCEPTION = 1, STAT_CONSTITUTION = 1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/knotted,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/antennas/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/anthro,
		/datum/customizer/organ/horns/tusks,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/wolf,
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
		/datum/body_marking/tonage,
		/datum/body_marking/spotted,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/waist,
		/datum/body_marking/diagonal_eyes,
		/datum/body_marking/wide_eyes,
		/datum/body_marking/stripes,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_all,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

/datum/species/anthromorph/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/anthromorph/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/anthromorph/check_roundstart_eligible()
	return TRUE

/datum/species/anthromorph/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/anthromorph/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/third_color
	var/random = rand(1,6)
	switch(random)
		if(1)
			main_color = "FFFFFF"
			second_color = "333333"
			third_color = "333333"
		if(2)
			main_color = "FFFFDD"
			second_color = "DD6611"
			third_color = "AA5522"
		if(3)
			main_color = "DD6611"
			second_color = "FFFFFF"
			third_color = "DD6611"
		if(4)
			main_color = "CCCCCC"
			second_color = "FFFFFF"
			third_color = "FFFFFF"
		if(5)
			main_color = "AA5522"
			second_color = "CC8833"
			third_color = "FFFFFF"
		if(6)
			main_color = "FFFFDD"
			second_color = "FFEECC"
			third_color = "FFDDBB"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = third_color
	return returned

