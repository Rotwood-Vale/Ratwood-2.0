#define T1SELLPRICE 2
#define T2SELLPRICE 15
#define T3SELLPRICE 50
#define T4SELLPRICE 250

// Magical resources for the Ratwood ported Mage Gameplay Loop system
// Chose to not use /natural typepath because it didn't make much sense and this
// Let me use another .dmi
// Since the enchanting / summoning system is not here yet, sellprice has been adjusted.
/obj/item/magic
	name = "魔法材料"
	desc = "你本不该看到这个。"
	icon = 'icons/roguetown/items/magic_resources.dmi'
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	var/tier = 0 //used for determining potency for mob healing
	dropshrink = 0.85

// MELD
/obj/item/magic/melded
	name = "奥术融合体"
	icon_state = "wessence"
	desc = "你本不该看到这个。"
	w_class = WEIGHT_CLASS_SMALL
	sellprice = T1SELLPRICE

/obj/item/magic/melded/t1
	name = "奥能融块"
	icon_state = "meld"
	desc = "由炼狱灰烬、仙灵粉尘与元素微尘融合而成。"
	sellprice = T1SELLPRICE

/obj/item/magic/melded/t2
	name = "致密奥能融块"
	icon_state = "dmeld"
	desc = "由地狱犬獠牙、虹彩鳞片与元素碎片融合而成。"
	sellprice = T2SELLPRICE

/obj/item/magic/melded/t3
	name = "术法织结"
	icon_state = "weave"
	desc = "由炼狱核心、心木之核与元素残片融合而成。"
	sellprice = T3SELLPRICE

/obj/item/magic/melded/t4
	name = "魔力汇流"
	icon_state = "confluence"
	desc = "由深渊之焰、林野精粹与元素遗物融合而成。"
	sellprice = T4SELLPRICE

/obj/item/magic/melded/t5
	name = "奥能畸变体"
	icon_state = "abberant"
	desc = "由奥术聚合物与虚空石融合而成。它脉动紊乱，危险的力量紧缠其中，令人连靠近都心生畏惧，更别说将其握在手中。"
	sellprice = T4SELLPRICE * 2

//mapfetchable items
/obj/item/magic/obsidian
	name = "黑曜石碎片"
	icon = 'icons/obj/shards.dmi'
	icon_state = "obsidian"
	desc = "由熔岩急速冷却而成的火山玻璃。"
	sellprice = 0

/obj/item/magic/leyline
	name = "地脉碎晶"
	icon_state = "leyline"
	desc = "一块断裂地脉的碎片，闪烁着失落的力量。"

/obj/item/reagent_containers/food/snacks/grown/manabloom
	name = "魔力花"
	icon_state = "manabloom"
	desc = "浓郁魔力凝成了植物的形态。"
	seed = /obj/item/herbseed/manabloom
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer  = 8.9

/obj/item/magic/manacrystal
	name = "结晶化魔力"
	icon_state = "manacrystal"
	desc = "由魔力编织成人工结构后形成的晶体。"
	w_class = WEIGHT_CLASS_SMALL
	grind_results = list(/datum/reagent/medicine/manapot = 20)
	mill_result = /obj/item/reagent_containers/powder/mana

/obj/item/magic/artifact
	name = "符文遗物"
	icon_state = "runedartifact"
	desc = "一块来自久远时代的古石，其上刻有发光符文。"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8

/obj/item/magic/artifact/Initialize(mapload)
	.=..()
	var/list/listy = list("runedartifact", "runedartifact1")
	var/newicon = pick(listy)
	icon_state = newicon

/obj/item/magic/voidstone
	name = "虚空石"
	icon_state = "voidstone"
	desc = "一块漆黑的石头，盯着它看久了会令人心神不安。"
	w_class = WEIGHT_CLASS_SMALL

// INFERNAL
/obj/item/magic/infernal
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/infernal/examine(mob/user)
	. = ..()
	. += span_notice("它可用于治疗炼狱召唤物。")

/obj/item/magic/infernal/ash//T1 mage summon loot
	name = "炼狱灰烬"
	icon_state = "infernalash"
	desc = "反复焚烧后的灰烬，散发着硫磺与地狱火的气味，内部仍藏着余烬。"
	sellprice = T1SELLPRICE
	tier = 1

/obj/item/magic/infernal/fang//T2 mage summon loot
	name = "地狱犬獠牙"
	icon_state = "hellhound_fang"
	desc = "一枚锋利的獠牙，不论放凉多久都泛着鲜红光芒。"
	sellprice = T2SELLPRICE
	tier = 2

/obj/item/magic/infernal/core// T3 mage summon loot
	name = "炼狱核心"
	icon_state = "infernal_core"
	desc = "由岩石与魔法构成的熔融球体，不断散发出魔力热浪与能量。"
	sellprice = T3SELLPRICE
	tier = 3

/obj/item/magic/infernal/flame//T4 mage summon loot
	name = "深渊之焰"
	icon_state = "abyssalflame"
	desc = "一簇封存于水晶中的摇曳黑焰，是大恶魔的心脏，至少算得上是类似之物。它跳动着浓密的魔力脉冲。"
	sellprice = T4SELLPRICE
	tier = 4

//FAIRY
/obj/item/magic/fae
	w_class = WEIGHT_CLASS_SMALL
	sellprice = T1SELLPRICE
	tier = 1

/obj/item/magic/fae/examine(mob/user)
	. = ..()
	. += span_notice("它可用于治疗妖精召唤物。")

/obj/item/magic/fae/dust	//T1 mage summon loot
	name = "仙灵粉尘"
	icon_state = "fairy_dust"
	desc = "来自小妖精的闪亮粉末。"
	sellprice = T1SELLPRICE
	tier = 1

/obj/item/magic/fae/scale	//T2 mage summon loot
	name = "虹彩鳞片"
	icon_state = "iridescent_scale"
	desc = "取自辉翼生物的细小彩鳞，闪耀着与生俱来的魔力。"
	sellprice = T2SELLPRICE
	tier = 2

/obj/item/magic/fae/core	//T3 mage summon loot
	name = "心木之核"
	icon_state = "heartwood_core"
	desc = "一块灌注了树妖精华的附魔木材，仅仅握住它，心神便仿佛回到了远古时代。"
	sellprice = T3SELLPRICE
	tier = 3

/obj/item/magic/fae/essence	//T4 mage summon loot
	name = "林野精粹"
	icon_state = "sylvanessence"
	desc = "一团旋涡般的多彩液体，散发出令人目眩的斑斓光辉。"
	sellprice = T4SELLPRICE
	tier = 4

//ELEMENTAL
/obj/item/magic/elemental
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/elemental/examine(mob/user)
	. = ..()
	. += span_notice("它可用于治疗元素召唤物。")

/obj/item/magic/elemental/mote
	name = "元素微尘"
	icon_state = "mote"
	desc = "一缕灌注了 Dendor 力量的神秘精华，仅仅握住它，心神便仿佛回到了远古时代。"
	sellprice = T1SELLPRICE
	tier = 1

/obj/item/magic/elemental/shard
	name = "元素碎片"
	icon_state = "shard"
	desc = "一缕灌注了 Dendor 力量的神秘精华，仅仅握住它，心神便仿佛回到了远古时代。"
	sellprice = T2SELLPRICE
	tier = 2

/obj/item/magic/elemental/fragment
	name = "元素残片"
	icon_state = "fragment"
	desc = "一缕灌注了 Dendor 力量的神秘精华，仅仅握住它，心神便仿佛回到了远古时代。"
	sellprice = T3SELLPRICE
	tier = 3

/obj/item/magic/elemental/relic
	name = "元素遗物"
	icon_state = "relic"
	desc = "一缕灌注了 Dendor 力量的神秘精华，仅仅握住它，心神便仿佛回到了远古时代。"
	sellprice = T4SELLPRICE
	tier = 4

#undef T1SELLPRICE
#undef T2SELLPRICE
#undef T3SELLPRICE
#undef T4SELLPRICE
