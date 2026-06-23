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
// 自定义炼金配方：催乳剂（骨头x2+玻璃瓶x1+水50+牛奶10 → 装满50单位催乳剂的玻璃瓶，需炼金2级）
#include "crafting/lactation_enhancer_recipe.dm"
// 把催乳剂成品瓶加入浴场商贩机 BRASSFACE 的售货清单（Drugs 分类）
#include "crafting/lactation_enhancer_merchant.dm"
#include "alchemy/blood_tonic_reagent.dm"
// 催乳剂试剂与成品瓶定义（加速泌乳恢复）
#include "alchemy/lactation_enhancer_reagent.dm"
#include "structures/terror_clock.dm"
#include "structures/glaggar_challenge.dm"
#include "items/magic_bedroll.dm"
#include "items/goldface_supply_packs.dm"
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
