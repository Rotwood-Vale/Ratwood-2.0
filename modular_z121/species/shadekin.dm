// =====================================================================================
// 暗影裔 / Shadekin —— 从 S.P.L.U.R.T-Station-13 移植到 Ratwood (Rogue Town) 的种族
// Ported from: modular_splurt/code/modules/mob/living/carbon/human/species_types/shadekin.dm
// -------------------------------------------------------------------------------------
// 为什么需要"重写"而不是"复制"：源工程是 TG/SPLURT 引擎，其 /datum/species/mammal/shadekin
// 使用 mutant_bodyparts / eye_type / override_bp_icon 等字段；而 Ratwood 是中世纪奇幻分支，
// 种族系统完全不同（customizers / organs / bodypart_features / inherent_traits）。因此这里把
// 源种族的每一个特征"映射"到 Ratwood 的等价实现，而非逐字段照搬。
// Why this is a rewrite, not a copy: the source is the TG/SPLURT engine whose species datum
// uses mutant_bodyparts / eye_type / override_bp_icon; Ratwood's species system is completely
// different. Every source feature is therefore mapped onto its Ratwood equivalent.
//
// 源字段 -> Ratwood 映射 (Source field -> Ratwood mapping):
//   say_mod = "mars"                      -> 保留默认说话动词 (kept default; "mars" is SPLURT-only)
//   eye_type = "shadekin" (发光眼)         -> inherent_traits += TRAIT_DARKVISION (暗视，发光眼夜视)
//   mcolor/mcolor2/mcolor3 (三段变异色)     -> species_traits += MUTCOLORS (三色变异体)
//   mam_tail = "Shadekin" / mam_ears       -> 通用 anthro 尾巴/耳朵 customizer (generic anthro parts)
//   legs = "Plantigrade"                   -> Ratwood 人形默认即为跖行 (default humanoid legs)
//   override_bp_icon = *_greyscale.dmi     -> 使用 Ratwood 的 anthro 灰度躯体 (mta/fma greyscale)
// =====================================================================================

// 为什么要定义这个 mob 子类型：Ratwood 通过 /mob/living/carbon/human/species/<id> 把一个
// 具体的人类 mob 与其种族 datum 绑定，所有 RT 种族（提夫林/卢皮安/兽人化等）都遵循此模式。
// Why: Ratwood binds a concrete human mob to its species datum via this subtype, exactly like
// every other RT species (tiefling/lupian/anthromorph).
/mob/living/carbon/human/species/shadekin
	// race 指向下方的种族 datum，引擎据此装配躯体、器官与特性。
	// race points at the species datum below; the engine assembles body/organs/traits from it.
	race = /datum/species/shadekin

// 暗影裔种族 datum 本体 / The Shadekin species datum itself.
/datum/species/shadekin
	// name 为玩家在角色创建界面看到的种族名（中文本地化）。
	// name is what the player sees in character creation (localized to Chinese here).
	name = "暗影裔"
	// id 为内部唯一标识，必须与配置/白名单系统一致，且全局唯一。
	// id is the unique internal key; must stay unique across all species.
	id = "shadekin"
	// desc 为创建界面的简介，沿用 RT 的富文本格式并附带属性加成说明（与 race_bonus 对应）。
	// desc is the creation-screen blurb; follows RT rich-text format and states the stat bonuses.
	desc = "<b>暗影裔 (Shadekin)</b><br>\
	暗影裔是栖身于阴影与暗界缝隙之间的异族，传说其先祖在世界初成时便与无尽的黑暗结下了血脉之约。\
	他们生有兽类般的尾巴与耳朵，瞳孔在黑暗中如鬼火般幽幽发亮，能在伸手不见五指的暗夜里行走自如。\
	更为人所惧的是其与生俱来的'暗影穿行'之力——只需一念，便能化作一缕黑烟，自一片阴影瞬移至另一片阴影之中。\
	正因如此，他们历来被光明信仰所猜忌，多隐居于洞窟、密林与无人问津的废墟，行踪如鬼魅。<br>\
	(+1 感知, +1 速度, 暗视, 暗影穿行)"

	// expanded_desc 为更详尽的世界观文本（examine/百科用），解释其文化与被排斥的处境。
	// expanded_desc is the longer lore text used by examine/codex screens.
	expanded_desc = "暗影裔并非单一族群，而是所有'与暗影结契者'的统称。有的天生如此，血脉中流淌着暗界的力量；\
	有的则是误入暗影裂隙、被其改造而成。无论来历，他们都共享着对黑暗的亲和：强光会令其不适，而幽暗才是他们的家园。\
	由于'暗影穿行'之力难以防范，凡人聚落对其既敬且惧，暗影裔因而多以游商、斥候、刺客或隐士的身份游走于文明的边缘。"

	// skin_tone_wording：examine 时对"肤色/血统"一栏的称呼，主题化为'暗影血脉'。
	// skin_tone_wording: the label used for the skin/lineage entry on examine, themed as "Shadow Lineage".
	skin_tone_wording = "暗影血脉"

	// species_traits 控制角色创建时可调整的外观维度。
	// MUTCOLORS 对应源工程的三段变异色 (mcolor/mcolor2/mcolor3)；其余允许自定义眼色/嘴唇/发型。
	// species_traits controls which appearance dimensions are editable in chargen.
	// MUTCOLORS maps the source's 3 mutant colors; the rest enable eye color / lips / hair.
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAIR,
	)

	// inherent_biotypes：标记为"有机 + 人形"，使其受常规生物效果（中毒/治疗/魔法变形）影响。
	// inherent_biotypes: organic + humanoid so normal biological effects (poison/heal/polymorph) apply.
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	// use_skintones：开启肤色选择，配合 get_skin_list() 提供主题化的暗影肤色。
	// use_skintones: enables the skin-color picker, paired with get_skin_list() below.
	use_skintones = 1
	// attack_verb：徒手攻击的动词；暗影裔有兽爪，使用"撕抓"。
	// attack_verb: unarmed attack verb; shadekin have claws, so "slash".
	attack_verb = "slash"
	// changesource_flags：允许哪些"变身来源"把目标变成本种族（镜子/魔法/史莱姆提取等），与其他 RT 种族保持一致。
	// changesource_flags: which transformation sources may turn a target into this species; matches other RT races.
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	// possible_ages：可选年龄段，沿用全年龄列表（成年/中年/老年）。
	// possible_ages: selectable ages; uses the all-ages list.
	possible_ages = ALL_AGES_LIST
	// limbs_icon_*：躯体贴图。源工程用 *_greyscale.dmi，这里映射到 RT 的 anthro 灰度躯体（可被变异色染色）。
	// limbs_icon_*: body sprites. The source used a greyscale sheet; mapped to RT's anthro greyscale body
	// (mutant-color tintable), which is the closest existing asset — avoids shipping new DMIs.
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mta.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fma.dmi'
	// dam_icon_*：受伤覆盖层贴图，沿用通用人形伤痕图。
	// dam_icon_*: damage-overlay sprites; reuse the generic humanoid wound sheets.
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	// soundpack_*：语音音效包，使用通用男/女音。
	// soundpack_*: voice packs; use the generic male/female voices.
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	// offset_features：各装备/部件在 anthro 躯体上的像素偏移；直接沿用 anthro 标准偏移以保证穿戴对齐。
	// offset_features: per-slot pixel offsets on the anthro body; copied from the anthro standard so gear aligns.
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
	// inherent_traits：天生特性。TRAIT_DARKVISION 实现源工程"发光眼/暗夜视物"的设定（引擎自动应用/移除）。
	// inherent_traits: innate traits. TRAIT_DARKVISION realizes the source's glowing-eye night vision
	// (the base on_species_gain/on_species_loss apply and strip these automatically).
	inherent_traits = list(TRAIT_DARKVISION)
	// race_bonus：开局属性加成。暗影裔敏捷而警觉，故 +1 感知、+1 速度（与 desc 中说明一致）。
	// race_bonus: starting stat bonuses. Shadekin are agile and alert: +1 PER, +1 SPD (matches desc).
	race_bonus = list(STAT_PERCEPTION = 1, STAT_SPEED = 1)
	// enflamed_icon：着火时的火焰覆盖贴图，沿用通用宽体火焰。
	// enflamed_icon: fire overlay state when ablaze; use the generic wide fire.
	enflamed_icon = "widefire"
	// organs：内部器官清单。沿用 anthro 标准器官集；尾巴/口鼻/耳朵交由下方 customizers 动态生成。
	// organs: internal organ loadout. Uses the anthro standard set; tail/snout/ears are added via customizers.
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
		)
	// bodypart_features：可独立渲染的躯体部件特征（头发/胡须），供发型/胡须自定义挂载。
	// bodypart_features: per-bodypart rendered features (head/facial hair) that the hair customizers hook into.
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	// customizers：角色创建时可调整的部件清单。沿用通用 anthro 部件集，对应源工程的兽尾/兽耳/口鼻。
	// customizers: the chargen-editable parts. Reuses the generic anthro set, covering the source's
	// shadekin tail / ears / snout via anthro equivalents.
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		// 暗影裔专属尾巴/耳朵：引用移植自 SPLURT 的贴图(shadekin_tails.dmi / shadekin_ears.dmi)，
		// 把"暗影裔尾/耳"作为默认特色项；定义见 modular_z121/species/shadekin_sprites.dm。
		// Shadekin-specific tail/ears: reference the textures ported from SPLURT (shadekin_tails.dmi /
		// shadekin_ears.dmi), featured as the default; defined in modular_z121/species/shadekin_sprites.dm.
		/datum/customizer/organ/tail/shadekin,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/shadekin,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/anthro,
	)
	// body_marking_sets：可整体套用的体表花纹方案（无/腹部/虎纹/渐变等）。
	// body_marking_sets: whole-body marking presets (none/belly/tiger/gradient...).
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	// body_markings：可单独叠加的体表花纹，沿用 anthro 通用花纹清单。
	// body_markings: individually toggleable markings; reuse the generic anthro list.
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/wolf,
		/datum/body_marking/plain,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/tonage,
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
	// descriptor_choices：examine 时显示的"外貌描述"下拉项（身高/体格/毛发等），沿用 anthro 野性版。
	// descriptor_choices: the appearance-descriptor dropdowns shown on examine; uses the anthro "wild" set.
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/fur,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)
	// languages：可掌握的语言。暗影裔通晓通用语；保持最小集合以避免引用不存在的语言 datum。
	// languages: known languages. Shadekin speak Common; kept minimal to avoid referencing missing datums.
	languages = list(
		/datum/language/common,
	)

// 为什么覆盖 on_species_gain：在获得本种族时挂接"说话口音处理"信号，并授予签名能力【暗影穿行】。
// Why override on_species_gain: when this race is gained, hook the speech-accent signal and grant the
// signature ability "Shadow Step".
/datum/species/shadekin/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	// 先调用父类逻辑：装配器官、应用 inherent_traits(含暗视) 等基础流程。
	// Call the parent first: it assembles organs and applies inherent_traits (incl. darkvision).
	. = ..()
	// 防御性检查：理论上 C 必然存在，但严谨起见仍校验，避免对空对象注册信号导致运行时报错。
	// Defensive check: C should always exist, but verify to avoid registering signals on null (runtime error).
	if(!C)
		return
	// 注册说话信号，使本种族可走 RT 的口音替换管线（与提夫林/卢皮安等一致）。
	// Register the say signal so this race flows through RT's accent pipeline (like tiefling/lupian).
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	// 授予签名能力【暗影穿行】：用 mob.AddSpell 直接绑定到身体而非 mind，因为这是种族先天能力，
	// 即便角色尚无 mind（创建早期）也应可靠获得；先去重，避免重复授予叠加多个按钮。
	// Grant the signature "Shadow Step": use mob.AddSpell so it binds to the BODY (not the mind), since it is
	// an innate racial power that must be granted reliably even before a mind exists. De-dupe first to avoid
	// stacking duplicate action buttons on repeated gains.
	for(var/obj/effect/proc_holder/spell/existing in C.mob_spell_list)
		// 若已存在同类能力则直接返回，跳过重复授予。
		// If the ability already exists, bail out to skip a duplicate grant.
		if(istype(existing, /obj/effect/proc_holder/spell/invoked/shadow_step))
			return
	// 实例化并授予能力（参数 null 表示该能力不绑定特定母对象/咒语书）。
	// Instantiate and grant the ability (null = not tied to a specific parent object/spellbook).
	C.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadow_step(null))

// 为什么覆盖 on_species_loss：失去本种族时必须解绑信号并回收授予的能力，否则会残留无效按钮/信号。
// Why override on_species_loss: on losing this race we must unhook the signal and reclaim the granted
// ability, otherwise a dangling button/signal would remain.
/datum/species/shadekin/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	// 调用父类先行清理 inherent_traits 等基础内容。
	// Call the parent to clear inherent_traits etc. first.
	. = ..()
	// 防御性检查，避免对空对象操作。
	// Defensive null-check to avoid operating on a null mob.
	if(!C)
		return
	// 注销说话信号，停止口音处理。
	// Unregister the say signal to stop accent handling.
	UnregisterSignal(C, COMSIG_MOB_SAY)
	// 回收【暗影穿行】：mob.RemoveSpell 接受类型路径，按 istype 匹配并 qdel 对应能力实例。
	// Reclaim "Shadow Step": mob.RemoveSpell accepts a type path, matches via istype and qdels the instance.
	C.RemoveSpell(/obj/effect/proc_holder/spell/invoked/shadow_step)

// 为什么覆盖 check_roundstart_eligible：返回 TRUE 使本种族在角色创建界面可直接选择，
// 无需依赖服务器配置白名单（与 anthromorph/lupian 等自定义种族做法一致）。
// Why override check_roundstart_eligible: returning TRUE makes the race selectable in chargen without
// requiring a server config whitelist entry (same approach as anthromorph/lupian).
/datum/species/shadekin/check_roundstart_eligible()
	return TRUE

// 为什么覆盖 qualifies_for_rank：允许暗影裔担任任意职业/头衔，避免被职业种族限制挡下。
// Why override qualifies_for_rank: let shadekin take any job/rank instead of being filtered out.
/datum/species/shadekin/qualifies_for_rank(rank, list/features)
	return TRUE

// 为什么提供 get_skin_list：为肤色选择器提供一组主题化的"暗影"肤色（偏冷暗灰/紫调），
// 键为玩家可见名称，值为十六进制颜色。
// Why provide get_skin_list: supply a themed palette of dark/cool "shadow" skin tones for the picker;
// keys are player-facing names, values are hex colors.
/datum/species/shadekin/get_skin_list()
	return list(
		"暗灰 (Ashen)"      = "3a3a40",
		"夜紫 (Nightviolet)" = "352b3f",
		"幽蓝 (Duskblue)"    = "2b3340",
		"煤黑 (Coal)"        = "242225",
		"灰烬 (Cinder)"      = "4a4640",
		"暮影 (Twilight)"    = "3f3340",
	)

// 为什么提供 get_random_features：当玩家选择"随机外观"或由系统随机生成时，给出符合暗影主题的
// 三段变异色（整体偏暗，带一抹冷调亮色作为点缀），对应源工程的 mcolor/mcolor2/mcolor3。
// Why provide get_random_features: when randomizing appearance, produce shadow-themed mutant colors
// (mostly dark with one cool accent), matching the source's mcolor/mcolor2/mcolor3.
/datum/species/shadekin/get_random_features()
	// 以强制特征列表为基底（含默认腿型/体型等必需键），再覆盖三段颜色。
	// Start from the mandatory feature list (default legs/body size etc.), then override the 3 colors.
	var/list/returned = MANDATORY_FEATURE_LIST
	// 主色/副色/第三色变量：用于承载随机挑选的暗色组合。
	// main/second/third color vars hold the randomly chosen dark combination.
	var/main_color
	var/second_color
	var/third_color
	// 在若干预设暗色方案中随机其一，保证整体暗调统一又有变化。
	// Pick one of several preset dark schemes for a consistent-yet-varied dark look.
	switch(rand(1,5))
		if(1)
			main_color = "2b2b30"; second_color = "1d1b24"; third_color = "4b5d75" // 冷蓝点缀 / cool blue accent
		if(2)
			main_color = "302636"; second_color = "20192a"; third_color = "6a4f7a" // 暗紫点缀 / dark violet accent
		if(3)
			main_color = "262626"; second_color = "171717"; third_color = "5a5a5a" // 纯灰阶 / pure greyscale
		if(4)
			main_color = "2a2f2c"; second_color = "1a1d1b"; third_color = "4d6b5a" // 幽绿点缀 / eerie green accent
		if(5)
			main_color = "33292a"; second_color = "1f1819"; third_color = "7a4f54" // 暗红点缀 / dark crimson accent
	// 写回三段颜色键，供贴图按变异色染色。
	// Write back the three color keys so the sprite is tinted by the mutant colors.
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = third_color
	return returned
