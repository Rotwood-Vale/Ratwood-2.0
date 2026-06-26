// =====================================================================================
// 暗影裔 贴图移植 / Shadekin texture port —— 尾巴 & 耳朵 的精灵贴图接入
// -------------------------------------------------------------------------------------
// 为什么需要这个文件：源工程 S.P.L.U.R.T 把暗影裔的兽尾/兽耳贴图存放在
//   modular_splurt/icons/mob/mam_tails.dmi  (状态: m_tail_shadekin_*, m_tailwag_shadekin_*)
//   modular_splurt/icons/mob/mam_ears.dmi   (状态: m_ears_shadekin_*)
// 但 SPLURT 的状态命名 (m_tail_<名>_FRONT/BEHIND、m_ears_<名>_ADJ/FRONT) 与 Ratwood 不同；
// Ratwood 的 sprite_accessory 系统期望 <icon_state>_FRONT / _BEHIND / _ADJ(以及尾巴的 _wagging)。
// 因此我们已用脚本把这两张图里的"暗影裔"帧抽取出来、重命名为 Ratwood 约定，另存为：
//   modular_z121/icon/shadekin_tails.dmi (状态: shadekin_FRONT/BEHIND/..wagging.., shadekinshort_*)
//   modular_z121/icon/shadekin_ears.dmi  (状态: shadekin_ADJ, shadekin_FRONT)
// 本文件再把这些贴图"登记"为 Ratwood 原生的精灵配件 + 自定义项，使其在角色创建界面可选。
//
// Why this file exists: the source SPLURT stores the shadekin tail/ear textures in mam_tails.dmi /
// mam_ears.dmi, but with SPLURT's state-naming scheme (m_tail_<name>_FRONT/BEHIND, m_ears_<name>_ADJ/
// FRONT) which Ratwood does NOT use. Ratwood's sprite_accessory system expects <icon_state>_FRONT /
// _BEHIND / _ADJ (and _wagging for tails). The shadekin frames were therefore extracted and renamed into
// modular_z121/icon/shadekin_tails.dmi & shadekin_ears.dmi. This file registers them as native
// Ratwood sprite accessories + customizer choices so they are selectable in character creation.
// =====================================================================================
/*
// -------------------------------------------------------------------------------------
// 1) 精灵配件 (sprite_accessory) —— 把贴图状态包装成可被器官引用的外观数据
//    sprite accessories — wrap the icon states into appearance data an organ can reference
// -------------------------------------------------------------------------------------

// 暗影裔 长尾 / Shadekin long tail.
// 为什么继承 /datum/sprite_accessory/tail：复用其默认 relevant_layers(FRONT+BEHIND) 与 FRONT/BEHIND
// 状态合成逻辑；can_wag=TRUE 启用摇尾，引擎会去找 <state>_wagging_FRONT/BEHIND(我们的图里已有)。
// Why extend /datum/sprite_accessory/tail: reuse its default relevant_layers (FRONT+BEHIND) and the
// FRONT/BEHIND state composition; can_wag=TRUE enables wagging, for which the engine looks up
// <state>_wagging_FRONT/BEHIND (which our DMI provides).
/datum/sprite_accessory/tail/shadekin
	// name：角色创建下拉中显示的名称。
	// name: shown in the chargen dropdown.
	name = "Shadekin"
	// icon：指向移植后的暗影裔尾巴贴图表。
	// icon: points at the ported shadekin tail sheet.
	icon = 'modular_z121/icon/shadekin_tails.dmi'
	// icon_state：基础状态名；引擎据此合成 shadekin_FRONT / shadekin_BEHIND(及摇尾变体)。
	// icon_state: base state; the engine composes shadekin_FRONT / shadekin_BEHIND (+ wagging variants).
	icon_state = "shadekin"
	// can_wag：暗影裔尾巴支持摇摆动画(源图含 m_tailwag_shadekin_*，已重命名为 shadekin_wagging_*)。
	// can_wag: this tail supports a wag animation (source had m_tailwag_shadekin_*, renamed to shadekin_wagging_*).
	can_wag = TRUE

// 暗影裔 短尾 / Shadekin short tail —— 源工程的 "Shadekin Short" 变体。
// Shadekin short tail — the source's "Shadekin Short" variant.
/datum/sprite_accessory/tail/shadekinshort
	name = "Shadekin Short"
	icon = 'modular_z121/icon/shadekin_tails.dmi'
	// 使用 shadekinshort 系列状态 (shadekinshort_FRONT/BEHIND + _wagging)。
	// Uses the shadekinshort state family (shadekinshort_FRONT/BEHIND + _wagging).
	icon_state = "shadekinshort"
	can_wag = TRUE

// 暗影裔 兽耳 / Shadekin ears.
// 为什么继承 /datum/sprite_accessory/ears：复用其默认 relevant_layers(ADJ+FRONT) 与单色(MUTCOLOR)着色；
// 引擎据 icon_state 合成 shadekin_ADJ / shadekin_FRONT(我们的图里已有)。
// Why extend /datum/sprite_accessory/ears: reuse its default relevant_layers (ADJ+FRONT) and single-color
// (MUTCOLOR) tinting; the engine composes shadekin_ADJ / shadekin_FRONT (which our DMI provides).
/datum/sprite_accessory/ears/shadekin
	name = "Shadekin"
	icon = 'modular_z121/icon/shadekin_ears.dmi'
	icon_state = "shadekin"
*/
// -------------------------------------------------------------------------------------
// 2) 自定义项 (customizer) —— 把上面的配件聚合成角色创建界面里的"尾巴/耳朵"可选条目
//    customizers — group the accessories into selectable "tail/ears" entries in chargen
// -------------------------------------------------------------------------------------

// 暗影裔 尾巴 自定义器 / Shadekin tail customizer.
// 为什么单列一个 customizer：以便种族 customizers 列表直接引用它，让"暗影裔尾巴"成为默认特色项；
// 仍保留通用 anthro 尾巴作为额外选项，玩家可自由更换。
// Why a dedicated customizer: so the species customizers list can reference it directly, making the
// shadekin tail the featured default while still keeping the generic anthro tail as an extra option.
/datum/customizer/organ/tail/shadekin
	customizer_choices = list(/datum/customizer_choice/organ/tail/shadekin)

/datum/customizer_choice/organ/tail/shadekin
	// name：该自定义条目的标题。
	// name: the title of this customizer entry.
	name = "Shadekin Tail"
	// organ_type：复用既有的 anthro 尾巴器官(无需新建器官类)，它支持任意 anthro 风格的精灵配件。
	// organ_type: reuse the existing anthro tail organ (no new organ class needed); it supports
	// arbitrary anthro-style sprite accessories.
	organ_type = /obj/item/organ/tail/anthro
	// sprite_accessories：本条目可选的尾巴外观——暗影裔长/短尾在前(默认特色)，再附通用兽尾以供替换。
	// sprite_accessories: the tail looks available here — shadekin long/short first (featured default),
	// followed by generic anthro tails as alternatives.
	sprite_accessories = list(
		/datum/sprite_accessory/tail/shadekin,
		/datum/sprite_accessory/tail/shadekin/short,
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/skunk,
	)

// 暗影裔 耳朵 自定义器 / Shadekin ears customizer.
/datum/customizer/organ/ears/shadekin
	customizer_choices = list(/datum/customizer_choice/organ/ears/shadekin)

/datum/customizer_choice/organ/ears/shadekin
	name = "Shadekin Ears"
	// 复用既有 anthro 耳朵器官。
	// Reuse the existing anthro ears organ.
	organ_type = /obj/item/organ/ears/anthro
	// 暗影裔兽耳在前(默认特色)，再附通用兽耳以供替换。
	// Shadekin ears first (featured default), with generic anthro ears as alternatives.
	sprite_accessories = list(
		/datum/sprite_accessory/ears/shadekin,
		/datum/sprite_accessory/ears/shadekin/band_left,
		/datum/sprite_accessory/ears/shadekin/band_right,
		/datum/sprite_accessory/ears/shadekin/fluffy,
		/datum/sprite_accessory/ears/shadekin/smooth,
		/datum/sprite_accessory/ears/cat,
		/datum/sprite_accessory/ears/fox,
		/datum/sprite_accessory/ears/wolf,
	)
