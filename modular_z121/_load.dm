#include "spells/_registry.dm"
#include "bootstrap/custom_bootstrap.dm"
#include "jobs/arcane_archer.dm"
#include "jobs/musketeer.dm"
#include "jobs/war_shaman.dm"
#include "spells/admin/admin_spells.dm"
#include "spells/druid/wildshape_dragon.dm"
#include "rites/eldritch_ritechalk.dm"
#include "rites/sacrifice_circles.dm"
#include "rites/malicious_skill.dm"
#include "rites/gift_of_the_sun.dm"
#include "rites/mystery_of_magic.dm"
#include "rites/necra_death_curtain.dm"
#include "rites/xylix_music_offering.dm"
#include "rites/pestra_plague_disaster.dm"
#include "rites/victory_glow.dm"
#include "spells/arcane/anti_spoil.dm"
#include "spells/arcane/flight.dm"
#include "spells/arcane/group_buffs.dm"
#include "spells/arcane/group_mindlink.dm"
#include "spells/arcane/endless_magic_arrows.dm"
#include "spells/arcane/clearwater_spring.dm"
#include "spells/arcane/cleaning.dm"
#include "spells/arcane/harmless_dismemberment.dm"
#include "spells/arcane/heal_pristine.dm"
#include "spells/arcane/insight_all_things.dm"
#include "spells/arcane/legilimency.dm"
#include "spells/arcane/levitation_charm.dm"
#include "spells/arcane/locate_person.dm"
#include "spells/arcane/magic_satiety.dm"
#include "spells/arcane/mansion_curse.dm"
#include "spells/arcane/mini_magic_missile.dm"
#include "spells/arcane/moonlight_greatsword_spells.dm"
#include "spells/arcane/pain.dm"
#include "spells/arcane/restore_pristine.dm"
#include "spells/arcane/sectumsempra.dm"
#include "spells/arcane/sensory_sharing.dm"
#include "spells/arcane/small_bet.dm"
#include "spells/arcane/storage_spell.dm"
#include "spells/arcane/summon_magic_bedroll.dm"
#include "spells/arcane/timestop.dm"
#include "spells/arcane/void_clone.dm"
// 自定义 T3 法术：掌控天时（晴 / 雨 / 雪），仅调用主线 SSParticleWeather 接口
#include "spells/arcane/weather_control.dm"
#include "spells/arcane/wish_spell.dm"
#include "spells/arcane/xylix_laughter.dm"
#include "spells/arcane/xray_vision.dm"
#include "spells/arcane/yixinghuanying.dm"
#include "crafting/eldritch_ritual_chalk_recipe.dm"
#include "crafting/moonlight_greatsword_recipes.dm"
#include "crafting/terror_clock_recipe.dm"
#include "crafting/blood_tonic_recipe.dm"
// 自定义合成配方：涂毒工具袋（Poisoned Tool Pouch）——【通用制造】分类、需通用制造 2 级；
// 材料：鞣制皮革x1 + 纤维x1 + 空玻璃瓶x1（均消耗）；工具：缝衣针（不消耗）。产物见 items/poisoned_tool_pouch.dm。
// Custom recipe: Poisoned Tool Pouch — General Manufacturing tab, lvl-2; tanned leather + fiber + glass bottle, needle tool.
#include "crafting/poisoned_tool_pouch_recipe.dm"
// 自定义炼金配方：催乳剂（骨头x2+玻璃瓶x1+水50+牛奶10 → 装满50单位催乳剂的玻璃瓶，需炼金2级）
#include "crafting/lactation_enhancer_recipe.dm"
// 自定义炼金配方：猎魔人剑油 x7（《巫师3》移植）——“台面”分类、统一需炼金 1 级；
// 每种剑油 = 板油 + 各自的特色材料（毒药/蛛腺/银粉/圣水等）+ 玻璃瓶；产物见 items/sword_oils.dm。
// Custom alchemy recipes: 7 Witcher-style sword oils — bench tab, Alchemy lvl-1;
// each = tallow + its signature ingredients (poison/gland/silver/holy water...) + glass bottle.
#include "crafting/sword_oil_recipes.dm"
// 把催乳剂成品瓶加入浴场商贩机 BRASSFACE 的售货清单（Drugs 分类）
#include "crafting/lactation_enhancer_merchant.dm"
#include "alchemy/blood_tonic_reagent.dm"
// 催乳剂试剂与成品瓶定义（加速泌乳恢复）
#include "alchemy/lactation_enhancer_reagent.dm"
// 自定义精炼药剂框架：精炼炼药锅 /obj/machinery/light/rogue/cauldron/refining(覆盖 process())。
// 仍用【原版炼金材料的气味积分】选出配方家族，再由【液体底料(单一/复合)】决定产物：清水→回退原版
// 普通药水；特殊底料→精炼出新药。配方用数据 /datum/alch_refining_formula 描述(base_recipe 现成配方
// + required_base 现成液体 + output_reagents 新药)，未来扩展不新增任何材料。含暖心酒剂/温酒/克林卡特/
// 隐身药水/驱兽药水等示例(均按"气味等级"触发)及成品试剂，并提供精炼锅合成配方。
// ★酒基设定★：底料含任意酒类的配方，其成品为"酒基药剂"，喝下会像喝酒一样醉酒；酒劲＝【酒底酒精含量
// (=酒劲×酒在底料中的占比)】+【少量技能加成】并封顶；写入成品试剂 data 随装瓶保留；继承 ethanol/refined_potion。
// Custom medicine-refining framework: a cauldron subtype whose brew reads the LIQUID BASE
// (single/composite) alongside the original materials' scent to produce new potions.
// ★文件组织★：先加载【框架核心】，再逐一加载【每味药水各自的文件】(alchemy/refining_potions/)，最后加载配方书接入。
// 新增药水：在 refining_potions/ 下新建一个文件并在此 #include 即可。
#include "alchemy/refining_framework.dm"
// —— 每味精炼药水各占一个文件(成品试剂 + 配方)——
#include "alchemy/refining_potions/heart_tonic.dm"			// 暖心酒剂 (mood + alcohol)
#include "alchemy/refining_potions/warm_wine.dm"			// 温酒 (cold immunity + alcohol)
#include "alchemy/refining_potions/klinkat.dm"				// 克林卡特 (crit immunity + alcohol)
#include "alchemy/refining_potions/invisibility.dm"			// 隐身药水 (invisibility)
#include "alchemy/refining_potions/monster_repel.dm"		// 驱兽药水 (no ambush spawns)
#include "alchemy/refining_potions/universal_repair.dm"		// 万能修复溶剂 (object repair on splash)
#include "alchemy/refining_potions/gender_swap.dm"			// 变性药水 (gender swap + organ chooser)
#include "alchemy/refining_potions/aphrodisiac.dm"			// 媚药 (forced estrus, ERP-gated)
#include "alchemy/refining_potions/vigor_potion.dm"			// 精力药剂 (limitless energy / endless ejaculation, ERP-gated)
#include "alchemy/refining_potions/abstinence_potion.dm"		// 禁欲药水 (forced chastity: blocked climax, herb-based)
#include "alchemy/refining_potions/enlargement_potion.dm"		// 丰盈药水 (temporarily enlarges sexual organs)
#include "alchemy/refining_potions/flying.dm"				// 飞行药水 (3-minute magic flight)
#include "alchemy/refining_potions/anticorruption.dm"		// 防腐药水 (splash: food never rots / corpse preserved)
#include "alchemy/refining_potions/hardened_potion.dm"		// 硬化药剂 (take 20% less brute damage for the duration)
// 防蚂蟥药水：气味"死亡"(5级) + 水70/普通毒药30；炼金3级(熟练)；产出50单位。
// 药效期间主动剥离饮用者身上"正在吸血"的水蛭(脱离肢体即停止吸血)，等效"水蛭咬不动你"；并挂 TRAIT_ANTILEECH 状态钩子。
// Anti-leech potion: "death" scent (lvl5) + 70 water/30 common poison; alchemy lvl3; 50u output.
#include "alchemy/refining_potions/anti_leech.dm"			// 防蚂蟥药水 (leeches won't bite for the duration)
// 身体再生药剂：气味"潮湿的苔藓"(5级,未占用) + 水50/强效生命30/强效耐力30；炼金5级(大师)；产出30单位。
// 饮用并消化满10单位后，一次性再生所有已失去的四肢(手臂/腿)。
// Bodily Regeneration potion: "damp moss" scent (lvl5, unused) + 50 water/30 great-life/30 great-endurance; alchemy lvl5 (Master); 30u output; regrows lost limbs after digesting >=10u.
#include "alchemy/refining_potions/bodily_regeneration.dm"	// 身体再生药剂 (regrows lost limbs)
// 复原药剂：气味"毁灭"(5级) + 水70/强效魔力药水30；炼金5级(大师)；产出30单位。
// 泼洒>=10单位到一件物品上，逆向查出"合成/锻造它的配方"(菜单合成 /datum/crafting_recipe 与铁砧锻造
// /datum/anvil_recipe 两套体系)，按其原料清单在原地还原出全部合成原料后销毁原物；无配方的物品不予分解。
// Restorative potion: "doom" scent (lvl5) + 70 water/30 great-mana-potion; alchemy lvl5 (Master); 30u output.
// Splashing >=10u onto an item reverse-looks-up its recipe across BOTH the menu crafting system
// (/datum/crafting_recipe reqs) AND the anvil forging system (/datum/anvil_recipe req_bar/blade + additional_items),
// spawns those materials on the floor, then deletes the item. Items with no recipe are left untouched.
#include "alchemy/refining_potions/restorative_potion.dm"	// 复原药剂 (splash: item -> raw materials)
// 荧光药水：气味"威仪"(5级,未占用,=抗火药剂fire_potion之smells_like，由太阳尘+地狱尘各3点凑成6点) +
// 水70/魔力药水30；炼金2级(学徒)；产出50单位。饮后自体持续发光，光强(半径+强度)与体内残留药量正相关，
// 每30秒消化1单位；发光经 mob_light(duration=0 永久光源) 实现，每代谢拍按 volume 用 set_light_range_power_color 动态刷新。
// Luminescent potion: "majesty" scent (lvl5, unused, = fire_potion's smells_like; solardust 3 + infernaldust 3 = 6pts)
// + 70 water/30 mana potion; alchemy lvl2 (Apprentice); 50u output; emits a continuous glow whose range+power scale
// with the remaining volume in-body; 30s per unit; glow via mob_light(duration=0) live-updated each metabolize tick.
#include "alchemy/refining_potions/luminescent_potion.dm"	// 荧光药水 (self-glow scaling with remaining volume)
// 愚人药水：气味"水"(5级,未占用,=锐思药剂int_potion之smells_like，由水之精质+原初精质各3点凑成6点) +
// 板油(leaf lard)60；炼金3级(熟练)；产出30单位。饮后一段时间内智力-8、胡言乱语(★仍能说话★：不移除任何语言，
// 只【追加】失语症aphasia并把默认发声语言切到它——话语被旁人听成随机音节的胡言，与中文/英文输入无关)、并因
// 【非酒精】的混乱(confused随机乱走)+间歇眩晕Dizzy/抽搐Jitter而步履失控(★不使用drunkenness，因本药非酒★)。
// 效果由减益状态 /datum/status_effect/debuff/idiot_potion 承载，随药剂代谢生命周期施加/刷新/解除；30秒消化1单位。
// Idiot potion: "water" scent (lvl5, unused, = int_potion's smells_like; waterdust 3 + runedust 3 = 6pts)
// + 60 leaf lard (tallow); alchemy lvl3 (Journeyman); 30u output; for a while: INT -8; garbled speech WITHOUT muting
// (keep all languages, ADD aphasia + force it as spoken language → listeners hear gibberish, works for CJK input);
// uncontrolled staggering via NON-ALCOHOL confused + periodic Dizzy/Jitter (no drunkenness — this is not alcohol); 30s per unit.
#include "alchemy/refining_potions/idiot_potion.dm"		// 愚人药水 (INT -8 + non-muting garbled speech + non-alcohol staggering)
// 虚弱药水：气味"缓慢的微风"(5级,未占用,=耐力毒药stam_poison之smells_like，由蒲公英3点+聚合草2点凑成5点) +
// 板油(leaf lard)60；炼金3级(熟练)；产出30单位。饮后一段时间内力量-8(四肢发软、气力尽失)；30秒消化1单位。
// 效果由减益状态 /datum/status_effect/debuff/weakness_potion 承载，随药剂代谢生命周期施加/刷新/解除。
// Potion of Weakness: "slow breeze" scent (lvl5, unused, = stam_poison's smells_like; taraxacum 3 + symphitum 2 = 5)
// + 60 leaf lard (tallow); alchemy lvl3 (Journeyman); 30u output; for a while: STR -8 (sapped strength); 30s per unit.
#include "alchemy/refining_potions/weakness_potion.dm"		// 虚弱药水 (STR -8 for the duration)
// 气化之躯药水：气味"停滞的空气"(5级,未占用,=强效耐力毒药big_stam_poison之smells_like，由重楼3点+地狱尘2点凑成5点) +
// 水70/强效魔力药水30；炼金4级(专家)；产出30单位；12秒消化1单位(≈6分钟)。饮后化作雾气之躯：
// 【只能移动/飞行、不能做任何其它动作】——监听COMSIG_MOB_CLICKON并取消一切点击(攻击/拾取/使用/点选施法)、
// TRAIT_MUTE禁言、TRAIT_EMOTEMUTE禁动作、TRAIT_SPELLCOCKBLOCK禁施法；飞行复用magic_flight(飞行术)状态。
// 借 UNSTOPPABLE 移动位穿门过窗、借 GODMODE 令怪物不选你为敌且免疫一切常规伤害；唯独被龙卷风(GLOB.active_tornadoes)
// 吸入其风眼半径内时，每秒流失最大生命的10%(施伤时临时摘除GODMODE以让carbon.updatehealth真正重算生命)。
// Gasification Body potion: "stagnant air" scent (lvl5, unused, = big_stam_poison's smells_like; paris 3 + infernaldust 2 = 5)
// + 70 water/30 great-mana-potion (strongmana); alchemy lvl4 (Expert); 30u output; 12s per unit (~6 min). Turns the drinker into
// mist that can ONLY move/fly and do NOTHING else: cancels all clicks via COMSIG_MOB_CLICKON (no attacking/pickup/item-use/click-cast),
// TRAIT_MUTE (no speech) + TRAIT_EMOTEMUTE (no emotes) + TRAIT_SPELLCOCKBLOCK (no spellcasting), and grants flight by reusing the
// magic_flight status effect. Phases through doors/windows via the UNSTOPPABLE movement bit; GODMODE makes monsters ignore you & blocks
// all normal damage; the ONLY threat is being inhaled by a tornado (GLOB.active_tornadoes) -> lose 10% max health/second (godmode
// briefly lifted so carbon.updatehealth registers the loss).
#include "alchemy/refining_potions/gasification_body.dm"	// 气化之躯药水 (mist form: phase doors/windows, untargetable, damage-immune, weak to tornadoes)
// 麻痹毒药：气味"恐惧"(5级,未占用,=强效魔力灵药big_mana_potion之smells_like，由纯净精质3点+金粉3点凑成6点) +
// 水50/板油20/毒药30；炼金4级(专家)；产出30单位；6秒消化1单位(≈3分钟)。饮后依【体质】分档麻痹：
// 体质18-20仅舌麻失语(TRAIT_MUTE)；14-17加手臂发麻、无法拾取/使用物品(监听COMSIG_MOB_CLICKON取消一切点击)；
// ≤13周身发麻当场瘫倒、不能移动/说话/做任何事(Paralyze瘫痪 + TRAIT_MUTE/TRAIT_EMOTEMUTE/TRAIT_SPELLCOCKBLOCK)。
// Paralytic Poison: "fear" scent (lvl5, unused, = big_mana_potion's smells_like; magicdust 3 + golddust 3 = 6) +
// 50 water/20 tallow/30 berrypoison; alchemy lvl4 (Expert); 30u output; 6s per unit (~3 min). Numbs the drinker by
// CONSTITUTION tier: CON 18-20 = tongue only (TRAIT_MUTE, can't speak); 14-17 = arms also numb (cancels all clicks via
// COMSIG_MOB_CLICKON, can't pick up/use items); <=13 = whole-body collapse (Paralyze + MUTE/EMOTEMUTE/SPELLCOCKBLOCK: can't move/speak/act).
#include "alchemy/refining_potions/paralytic_poison.dm"	// 麻痹毒药 (constitution-tiered paralysis: mute / can't use hands / full collapse)
// 怠惰药水：气味"清新的空气"(5级,未占用,=疾行药水spd_potion之smells_like，由风之精质3点+小米草3点凑成6点) +
// 水50/板油20/毒药30；炼金5级(大师)；产出30单位；9秒消化1单位(≈4.5分钟)。饮后其间：(A)每次主动动作(攻击/拾取/
// 使用/点选施法等一切鼠标点击)有40%几率被"懒掉"——动作整单取消(监听COMSIG_MOB_CLICKON掷骰后返回取消标记)，并嘟囔
// 一句懒话；(B)移动变慢(add_movespeed_modifier常驻);(C)一切读条动作变慢(physiology.do_after_speed*=1.5,人类);
// (D)若一段时间什么都不做(不移动/不点击)则缓慢回复伤势并补充饥渴(heal_overall_damage+adjust_nutrition/hydration,
// 一动即打断)。键盘移动不被拦截(只是变慢)。
// Potion of Sloth: "fresh air" scent (lvl5, unused, = spd_potion's smells_like; airdust 3 + euphrasia 3 = 6) +
// 50 water/20 tallow/30 berrypoison; alchemy lvl5 (Master); 30u output; 9s per unit (~4.5 min). While digesting:
// (A) every active click-action has a 40% chance to be skipped (cancel via COMSIG_MOB_CLICKON roll) + a lazy mutter;
// (B) movement slowed (movespeed modifier); (C) all progress-bar/do_after actions slowed (physiology.do_after_speed);
// (D) staying idle (no move/click) for a while slowly heals injuries & refills food/water (broken by any activity).
#include "alchemy/refining_potions/sloth_potion.dm"		// 怠惰药水 (skip actions + slow move/do_after; idle-rest regen)
// 回忆药剂：唯一未被占用的等级5气味"洁净的风"(=强效耐力灵药 big_stamina_potion 的 smells_like，
// 种子粉/炼金奥兹姆/圣蓟 major=3 任取两味=6) + 清水70/强效魔力药水30；炼金5级(大师)；产出30单位。
// 效果：消化满5单位后，被传送回饮者【上一次睡觉的地点】(由自包含轮询子系统 SSmemory_sleep 持续记录)。
// Memory Potion: "clean wind" scent (lvl5, the ONLY unused one = big_stamina_potion's smells_like) +
// 70 water/30 strong mana potion; alchemy lvl5 (Master); 30u output; after digesting >=5u, teleports the
// drinker back to where they last slept (a self-contained polling subsystem, SSmemory_sleep, records it).
#include "alchemy/refining_potions/memory_potion.dm"		// 回忆药剂 (teleport to last sleep spot after 5u)
// 把精炼配方接入原版炼金指南"炼金秘要"——新增"精炼药剂"分类并渲染各配方详情(覆盖其 New/分类/详情 过程)。
// Surfaces the refining formulas inside the vanilla alchemy guide under a "精炼药剂" (Refined Potions) category.
#include "alchemy/refining_guide.dm"
#include "structures/terror_clock.dm"
#include "items/magic_bedroll.dm"
#include "items/goldface_supply_packs.dm"
// 自定义药水成品瓶：为 modular_z121 各自定义炼金药水（精力/暖心/温酒/克林卡特/驱兽/隐身/飞行/
// 万能修复/变性/媚药）补一个"预装 50 单位该药水的玻璃瓶物品"，使其能作为即用消耗品在商店兑换。
// Pre-filled bottles for the module's custom potions, so they can be sold as ready-to-use consumables.
#include "items/custom_potion_bottles.dm"
// 自定义物品：贤者之石（Philosopher's Stone）——炼金终极造物，一件手持道具驱动三种奇迹：
// ①点石成金（点击石头→金矿石，无冷却）；②净水嬗变（点击含水容器→任选一种主线炼金药水，冷却3分钟）；
// ③凭空造物（对自身使用→按名称搜索并创造价值>1的物品，冷却时间与其价值正相关）。仅调用主线现成
// 类型/接口（rogueore/gold、/datum/reagents、/datum/alch_cauldron_recipe、sellprice），不改动模块外文件。
// Custom item: Philosopher's Stone — three alchemical miracles from one held tool:
// (1) stone->gold ore (no cooldown), (2) water-in-container -> any vanilla alchemy potion (3-min cooldown),
// (3) create an item from nothing, searched by name, value>1 only, cooldown scaling with the item's value.
#include "items/philosophers_stone.dm"
// 自定义物品：涂毒工具袋（Poisoned Tool Pouch）——可倒入液体的皮袋，手持点击武器/箭矢即可涂抹；
// 被涂抹物命中活体时把液体注入目标（伤害由试剂自身代谢产生）。武器：10u/生效10次；箭矢：1u/生效1次。
// 贴图固定为 item.dmi 的 "Poisoned Tool Pouch"，仅名字随内含主液体变化（如“涂毒工具袋（毒药）”）。
// 弓射箭矢复用主线 projectile.poisontype 投递；近战/投掷复用 COMSIG_ITEM_ATTACK_EFFECT_SELF。
// Custom item: Poisoned Tool Pouch — pour a liquid in, click a weapon/arrow to coat it; the coated item
// delivers that liquid into any living target it strikes. Weapon: 10u over 10 hits; arrow: 1u once.
#include "items/poisoned_tool_pouch.dm"
// 自定义物品：猎魔人剑油 x7（《巫师3》移植）——手持油瓶点击近战武器即可涂抹（一瓶 3 次，用尽退空瓶）；
// 涂层持续 4 分钟，武器命中【对应克制类别】的敌人时追加【本次挥击伤害 50%】的百分比加成
//（经 get_complex_damage 重算基准，随武器力度/力量/锋利度动态缩放；对其它目标毫无效果）。
// 七种：绞刑者（人形）/兽类（野兽）/蛛形怪（蜘蛛毒虫）/恶魔（炼狱）/诅咒（狼人惧银者）/吸血鬼（血裔）/食尸生物（不死者）。
// 命中钩子复用 COMSIG_ITEM_ATTACK_EFFECT_SELF；目标判定用 mob_biotypes / 种族 / 反派数据 / 类型路径多路兜底。
// Custom items: 7 Witcher-style sword oils — apply to a melee weapon (3 uses/bottle, empty bottle returned);
// 4-min coating adds +50% of the swing's damage vs its matching enemy family only (humanoid/beast/arachnid/demon/cursed/vampire/necrophage).
#include "items/sword_oils.dm"
// 记忆之吻：手持点击铭刻他人气息，独处时重温记忆与感受（ERP 饰品）
#include "items/memory_kiss_token.dm"
// 记忆之吻制作配方：炼金台，宝石x1 + 水50 → 记忆之吻，炼金1级
#include "crafting/memory_kiss_token_recipe.dm"
#include "weapons/magical_archery.dm"
#include "weapons/moonlight_greatsword.dm"
#include "admin/adminspell.dm"
#include "admin/bless.dm"
#include "admin/grandcaster.dm"
#include "admin/god.dm"
#include "admin/cleanup_world.dm"
#include "storytellers/god_blessings.dm"
// 自定义美德：永无止境（每日一次、死亡 3 分钟后完美复活，但失忆且技能回退）
// Custom virtue: never-ending (daily, perfect resurrection 3 min after death, amnesia + skill reset)
#include "virtues/never_ending.dm"
// 自定义美德：魅魔血脉（限女性身体、消耗 24 凯旋点；获得 魅魔血脉/美貌/传奇情人 三特性。
// 每当被内射：随机获得 12 分钟"餍足"（对应属性 +1）+ 随餍足数量递增的心情；对方获得 4 分钟
// "魅魔之吻"（心情'与魅魔交合' + 力量-1/耐力-1）；对方处于该状态时再次内射不会餍足。
// 隐藏：被内射满 100 次进化为魅魔女王，意志 +2、耐力 +2）
// Custom virtue: Succubus Bloodline (female-only, 24 TRIUMPH; grants succubus bloodline + Beauty +
// Legendary Lover. On being creampied: random 12-min "Satisfaction" (matching stat +1) + mood scaling
// with satisfaction count; the partner gets a 4-min "Bite of Succubus" (mood + STR/CON -1) which also
// gates re-satisfaction. Hidden: 100 internal shots evolves into the Succubus Queen, WIL +2 / CON +2)
#include "virtues/succubus_bloodline.dm"
// 自定义美德：生命潜能（仅限血肉之躯、消耗 16 凯旋点；濒死时 10% 概率进入 3 分钟"濒死爆发"：
// 立即止血并恢复一半外伤、无痛、无限耐力，力量/速度/感知/意志各 +2；结束后强制沉睡 10 分钟）
// Custom virtue: Life Potential (flesh-and-blood only, costs 16 TRIUMPH; on near-death a 10% chance
// to enter a 3-minute "burst": instant clotting + half-heal, no pain, infinite stamina,
// STR/SPD/PER/WIL +2; forced 10-minute sleep when it ends)
#include "virtues/life_potential.dm"
// 自定义美德：远古造物（仅限金属构装体获取）（消耗 18 凯旋点；授予【亘古长存】特性：
// 智力 +1、意志 +1、识字 +3（上限 6）、工匠系列全部技能 +3（上限 6）并将工匠系列等级上限提升到 6；
// 非金属构装体领取时退还点数并不生效）
// Custom virtue: Ancient Creation (Metal Construct race only; costs 18 TRIUMPH; grants the
// "Ancient existence" trait: INT +1, WIL +1, Literacy +3 (cap 6), the whole Craftsman series +3
// (cap 6) and raises the Craftsman series' level cap to 6; non-construct takers are refunded and get nothing)
#include "virtues/ancient_creation.dm"
// 自定义美德：马丁的早晨（限能睡眠者、消耗 23 凯旋点）；授予【马丁的早晨】特性：
// 每天清晨强制沉睡 30 秒，醒来后随机切换为另一个日常职业（装备/技能/特性等一并替换）
// Custom virtue: Martin's Morning (sleep-capable only, costs 23 TRIUMPH); grants the
// "Martin's Morning" trait: every dawn forced to sleep 30s, then randomly re-roll into
// another everyday profession (advclass) — gear/skills/traits and all, as if chosen from start
#include "virtues/martins_morning.dm"
// 自定义恶习：洁癖（被动）；当身上有污渍（赤手沾血 / 身上附着可清理污物）时，
// 持续触发心情变差（压力事件）并施加意志 -2 减益；把身体清洗干净即可解除
// Custom vice: Neat Freak (passive); while the body is stained (bloody hands /
// cleanable filth on the body) it continuously worsens mood (stress event) and
// applies a Willpower -2 debuff; washing the body clean removes the penalties
#include "vices/neat_freak.dm"
// 自定义恶习：病娇（开局随机暗恋一名玩家）；自动习得【寻人术】并把暗恋对象加入熟人名单；
// 看见暗恋对象时心情达到顶峰，看不见时心情持续变差，超过 5 分钟看不见则不断嘶喊其名
// Custom vice: Yandere (randomly fall in love with a player at round start); auto-learns the
// "Person Searching Technique" (locate_person) and adds the crush to acquaintances; mood peaks
// while the crush is visible, steadily worsens while unseen, and after 5+ minutes unseen the
// character keeps screaming the crush's name
#include "vices/yandere.dm"
// 自定义恶习：脸盲症（被动）；授予【面孔失认 TRAIT_PROSOPAGNOSIA】特性，使患者查看任何人时
// 其姓名都被打码为"陌生人"（看谁都是陌生人）；并周期性清空 mind.known_people（面孔记忆库），
// 使其无论见过多少次都记不住别人的脸/认不出人。移除恶习时收回该特性。
// Custom vice: Facial Blindness (passive); grants the TRAIT_PROSOPAGNOSIA trait so every face the
// afflicted examines shows up as an "unknown" stranger, and periodically wipes mind.known_people
// (the face-memory registry) so they can never remember or recognize anyone. Removing the vice
// takes the trait back.
#include "vices/facial_blindness.dm"
// 自定义美德：地狱血脉后裔（仅限提夫林、消耗 29 凯旋点）；授予【地狱血脉】特性：
// 免疫一切火焰/灼烧/高温伤害（不会被点燃），并习得火焰系法术（火球术/强效火球术/吐焰火球/生成营火）。
// Custom virtue: Hell Bloody Descendants (Tiefling-only, costs 29 TRIUMPH); grants the "Hell Bloodline"
// trait: immune to all fire/burn/heat damage (cannot be ignited) and learns the flame series of spells
// (Fireball / Greater Fireball / Spitfire / Create Campfire)
#include "virtues/hellblood_descendant.dm"
// 自定义美德：天才（任何年龄可选、消耗 11 凯旋点）；授予【天才】特性：
// 所获得的一切技能经验放大到 300%（经验倍率 ×3），任何技能都"一学就会"，学得远比常人迅速。
// Custom virtue: Genius (any age, costs 11 TRIUMPH); grants the "Genius" trait:
// all gained skill experience is multiplied to 300% (×3), learning any skill far faster than normal.
#include "virtues/genius.dm"
// 自定义美德：畸变变种（仅限血肉之躯、消耗 6 凯旋点）；授予【畸变变种】特性：
// 每天夜晚在剧烈疼痛中随机切换成另一个【血肉之躯】的种族（绝不变成构造体/史莱姆/亡魂等非血肉种族），
// 换种族经 set_species 完成，由引擎一并清除上一个种族赋予的特性与能力。
// Custom virtue: Distortion Variant (flesh-and-blood only, costs 6 TRIUMPH); grants the "Distortion
// Variant" trait: every night the body is painfully reshaped into another flesh-and-blood race at random
// (never a construct/ooze/undead); the swap goes through set_species so the engine clears the previous
// race's traits and abilities as part of the change.
#include "virtues/distortion_variant.dm"
// 自定义美德：醉剑仙（消耗 6 凯旋点）；授予【醉剑仙】特性：
// 免疫醉酒带来的一切减益（智力下降/口齿不清/神志不清/眩晕/毒性/昏睡等）；一旦饮酒上头，
// 剑术技能立即被强化到【传奇】等级，直到酒意散尽——即"唯有醉后方能施展的东方剑法"。
// Custom virtue: Wine Sword Immortal (costs 6 TRIUMPH); grants the "Wine Sword Immortal" trait:
// immune to every drunkenness debuff (INT loss / slurring / confusion / dizziness / toxin / sleep);
// once drunk, the Sword-fighting skill is instantly boosted to Legendary until the alcohol wears off.
#include "virtues/wine_sword_immortal.dm"
// 自定义美德：RPG系统（消耗 99 凯旋点）；授予【RPG系统】特性：
// 你是世界旅人、持有作弊外挂——获得专属"系统面板"动词；击杀怪物（敌对 simple_animal）赚取
// 系统积分，积分可在系统商店兑换 物品 / 装备 / 武器 / 消耗品，并可强化技能等级与六维属性。
// Custom virtue: RPG System (costs 99 TRIUMPH); grants the "RPG System" trait: you are a world
// traveler with a cheat system — you get a personal "system panel" verb; killing monsters (hostile
// simple_animals) earns system points, spent in the system shop on items / equipment / weapons /
// consumables, and on enhancing skill levels and the six attributes.
#include "virtues/rpg_system.dm"
// 特例：账号 KUKULING 进入游戏即自动获得【RPG系统】并把系统积分设为 999999（须在 rpg_system.dm 之后引入）
#include "virtues/rpg_system_kukuling_autogrant.dm"
// 按账号赠礼：唯一的登录派发器（统一持有 human/Login() 覆写，逐一调用各账号赠礼 proc）
#include "account_perks/account_perks.dm"
// 按账号赠礼：账号 Sonic121 进入游戏即自动获得自定义特性【温暖力场】（向周围玩家持续散发情绪增益）
#include "account_perks/warm_power_field.dm"
// 自定义种族：暗影裔（Shadekin），从 S.P.L.U.R.T-Station-13 移植。栖身阴影的人形兽族，
// 三段变异体色 + 兽尾兽耳兽口鼻，天生【暗视】（发光眼夜视），+1 感知 / +1 速度；
// 并实装其签名能力【暗影穿行】：化作黑烟瞬移到一片处于阴影中的地块。
// Custom species: Shadekin, ported from S.P.L.U.R.T-Station-13. A shadow-dwelling anthro humanoid with
// 3-tone mutant coloring + anthro tail/ears/snout, innate TRAIT_DARKVISION (glowing-eye night vision),
// +1 PER / +1 SPD; plus its signature ability "Shadow Step" (blink into a shadowed tile).
#include "species/shadekin.dm"
#include "species/shadekin_shadow_step.dm"
// 暗影裔贴图接入：把移植自 SPLURT 的尾巴/耳朵贴图登记为 Ratwood 原生精灵配件 + 自定义项。
// Shadekin texture wiring: register the SPLURT-ported tail/ears textures as native Ratwood
// sprite accessories + customizer choices.
#include "species/shadekin_sprites.dm"
// 暗影裔职业准入修复：运行时把暗影裔注入所有"允许野民"的职业/进阶职业 allowed_races，
// 修复"该种族无法选择任何职业"的 Bug（由 custom_bootstrap 在子系统初始化后调用）。
// Shadekin job-access fix: at runtime, inject Shadekin into every job/advclass that already allows
// Wild-Kin, fixing the "can't choose any profession" bug (invoked from custom_bootstrap post-init).
#include "jobs/shadekin_job_access.dm"
// 暗影裔装备准入修复：运行时把暗影裔注入所有"允许野民"的衣物 allowed_race 共享列表，
// 修复"该种族无法穿戴许多装备"的 Bug（由 custom_bootstrap 调用，仅依赖编译期类型信息）。
// Shadekin equipment-access fix: at runtime, inject Shadekin into the shared allowed_race list of every
// clothing type that already allows Wild-Kin, fixing the "can't wear many items" bug.
#include "species/shadekin_equipment_access.dm"
#include "datum/loadout.dm"//添加新的开局物品选项
