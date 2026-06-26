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
// 自定义精炼药剂框架：精炼炼药锅 /obj/machinery/light/rogue/cauldron/refining(覆盖 process())。
// 仍用【原版炼金材料的气味积分】选出配方家族，再由【液体底料(单一/复合)】决定产物：清水→回退原版
// 普通药水；特殊底料→精炼出新药。配方用数据 /datum/alch_refining_formula 描述(base_recipe 现成配方
// + required_base 现成液体 + output_reagents 新药)，未来扩展不新增任何材料。含两条示例(生命药水家族
// +水60板油30→凝脂润肤膏；5级春日气味+葡萄酒90→暖心酒剂)及成品试剂，并提供精炼锅合成配方。
// ★酒基设定★：底料含任意酒类的配方，其成品为"酒基药剂"，喝下会像喝酒一样醉酒；酒劲＝【酒底加权平均
// boozepwr】+【技能加成】并封顶(酒越烈/技能越高越烈)，写入成品试剂 data 随装瓶保留；继承 ethanol/refined_potion。
// Custom medicine-refining framework: a cauldron subtype whose brew reads the LIQUID BASE
// (single/composite) alongside the original materials' scent to produce new potions.
#include "alchemy/refining_framework.dm"
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
// 自定义美德：天才（仅限年轻角色、消耗 11 凯旋点）；授予【天才】特性：
// 所获得的一切技能经验放大到 300%（经验倍率 ×3），任何技能都"一学就会"，学得远比常人迅速。
// Custom virtue: Genius (young-age-only, costs 11 TRIUMPH); grants the "Genius" trait:
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
