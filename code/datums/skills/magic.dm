/datum/skill/magic
	abstract_type = /datum/skill/magic
	name = "魔法"
	desc = ""
	randomable_dream_xp = FALSE
	color = "#9f74d6"
	max_skillbook_level = 3

/datum/skill/magic/holy
	name = "神迹"
	desc = "让我能够使用守护神赐予的更高阶神迹。"
	expert_name = "虔信者"

/datum/skill/magic/blood
	name = "血术"
	desc = "目前尚未影响任何内容。"
	expert_name = "术士"

/datum/skill/magic/arcane
	name = "奥术"
	desc = "每级减少 5% 的施法时间。"
	expert_name = "奥术师"

/datum/skill/magic/druidic
	name = "德鲁伊秘术"
	desc = "掌管对 Dendor 自然仪式的精通程度。可解锁更高阶的兽形变化；达到专家后可使用 fey circles；并按等级开放 Sanctified Tree 的仪式权限，从新手直至大师。作为 Dendor 的信徒，通过完成树木委托、祝圣树木与收获作物来提升。"
	expert_name = "德鲁伊"
	max_skillbook_level = 3
