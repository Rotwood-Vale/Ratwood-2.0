// ===========================================================================
// modular_z121 自定义物品：猎魔人剑油（Witcher-style Sword Oils）
// ---------------------------------------------------------------------------
// English overview:
//   Seven sword oils inspired by "The Witcher 3". Each oil bottle can be
//   applied to a melee weapon (/obj/item/rogueweapon). For a limited time the
//   coated weapon deals HEAVY BONUS DAMAGE against one specific family of
//   enemies (humanoids / beasts / arachnids / demons / cursed ones /
//   vampires / necrophages). One bottle holds several applications; when the
//   last application is used, an empty glass bottle is returned.
//
// 中文总览：
//   移植自《巫师3》的七种剑油。手持剑油瓶点击一件【近战武器】即可把油脂涂抹
//   到武器上；在持续时间内，该武器每次命中【对应类别的敌人】都会追加【本次挥击
//   伤害 50% 的百分比加成】（随武器力度/力量/锋利度动态缩放；对其它目标毫无
//   效果——正如原作设定）。
//     · 一瓶剑油可涂抹 3 次；全部用完后会退还一个空玻璃瓶。
//     · 同一件武器同一时间只能有一层剑油；涂新油会直接替换旧油（原作行为）。
//     · 涂层到期自动挥发，武器名字恢复原样。
//   七种剑油与克制目标：
//     · 绞刑者之油   → 人形生物（人类、蜥蜴人、兽人、哥布林等一切类人存在）
//     · 兽类之油     → 熊、狼、巨兽与野外掠食动物等普通兽类
//     · 蛛形怪之油   → 蜘蛛、毒虫与地底巢穴生物
//     · 恶魔之油     → 恶魔、地狱犬与炼狱召唤物
//     · 诅咒之油     → 狼人、受诅咒的兽化者与惧银的怪物
//     · 吸血鬼之油   → 吸血鬼及血裔、血魔法相关的敌人
//     · 食尸生物之油 → 骷髅、丧尸、亡灵杂兵等不死者
//
// 约束（严格遵守项目规则）：本文件只存在于 modular_z121 内，仅【调用/继承】主线
//   现成类型与接口（/obj/item、/datum/component、COMSIG_ITEM_ATTACK_EFFECT_SELF
//   命中信号、apply_damage 伤害接口、mob_biotypes 生物类别位旗标、species/antag
//   数据判定等），绝不修改 modular_z121 之外的任何文件。
//
// 注册方式：modular_z121/_load.dm -> #include "items/sword_oils.dm"
// 配方定义：modular_z121/crafting/sword_oil_recipes.dm（炼金台调配，需炼金 1 级）
// ===========================================================================

// ===== 数值旋钮（集中定义，文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以集中放这些魔法数字，是为了让后续平衡性调整一目了然。
#define SWORD_OIL_BONUS_MULT     0.5             // 命中克制目标时的伤害加成【百分比】（0.5 = 本次挥击伤害的 50%，随武器/力量/锋利度动态缩放）
#define SWORD_OIL_DURATION       (4 MINUTES)     // 一次涂抹的持续时间（到期涂层自动挥发）
#define SWORD_OIL_USES           3               // 一瓶剑油可涂抹的次数（用尽退还空瓶）
#define SWORD_OIL_CHANNEL        (2 SECONDS)     // 涂抹时的引导时长（可被打断，防误触 + 表现仪式感）
#define SWORD_OIL_MSG_CD         (3 SECONDS)     // 命中反馈消息的节流间隔（防止刷屏）

// ===========================================================================
// 剑油瓶基类：/obj/item/z121_sword_oil
// ---------------------------------------------------------------------------
// WHY 直接继承 /obj/item 而不是 reagent_containers：剑油是“按次数消耗的涂抹工具”，
//   不需要液体转移/饮用交互；用简单的 uses 计数即可精确表达“一瓶涂 N 次”，
//   也避免玩家把剑油当饮料喝掉或倒掉导致数值失控。
// 贴图：使用本模块专属贴图文件 modular_z121/icon/item.dmi，七种油各有一个
//   与英文原名同名的专属图标态（已用 zTXt 解析确认全部存在），无需 color 染色。
// ===========================================================================
/obj/item/z121_sword_oil
	name = "剑油"                                              // 基类占位名（不会直接出现在游戏里，见 coating_component_type 守卫）
	desc = "一瓶猎魔人风格的兵刃涂油。"                          // 基类占位描述
	icon = 'modular_z121/icon/item.dmi'                         // 本模块专属贴图文件（七种剑油贴图都在里面）
	icon_state = "Hanged Man's Oil"                             // 基类兜底图标态（子类各自覆写为专属贴图）
	w_class = WEIGHT_CLASS_SMALL                                // 体积“小”：方便揣在身上随时补涂
	dropshrink = 0.8                                            // 掉地上时缩小一点（与主线瓶子的习惯一致）
	slot_flags = ITEM_SLOT_HIP                                  // 可以挂在腰间（与药瓶一致的携带体验）
	sellprice = 25                                              // 战斗消耗品，给一个中等偏上的售价

	// —— 每瓶剩余的涂抹次数（用尽后瓶子销毁并退还空玻璃瓶）——
	var/oil_uses = SWORD_OIL_USES
	// —— 本油克制目标的中文说明（examine 展示 + 涂层组件的命中反馈用）——
	var/target_desc = "某类敌人"
	// —— 涂抹后挂到武器上的“涂层组件”具体子类型 ——
	// WHY 用组件子类而不是在物品上塞一堆 if：目标判定逻辑随七种油各不相同，
	//   每种油对应一个覆写了 is_valid_target() 的组件子类，职责单一、互不干扰；
	//   基类保持 null 以充当“抽象类守卫”——万一有人直接刷出基类瓶子，
	//   try_apply 会礼貌报错而不是运行时崩溃。
	var/coating_component_type = null

// ===========================================================================
// examine：查看剑油瓶时展示——克制目标 / 剩余涂抹次数 / 用法提示。
// 目的：让玩家不查任何攻略也能明白这瓶油怎么用、对谁有效。
// ===========================================================================
/obj/item/z121_sword_oil/examine(mob/user)
	. = ..()                                                    // 先取父类标准描述
	// 克制目标说明（红字强调“只对这类敌人生效”）。
	. += span_info("这种油专克：<b>[target_desc]</b>。")
	// 剩余涂抹次数（数值反馈，方便玩家规划补给）。
	. += span_notice("瓶中剩余的油还够涂抹 <b>[oil_uses]</b> 次。")
	// 用法提示（加成为百分比：按本次挥击的实际伤害折算，而非固定数值）。
	. += span_notice("手持本瓶点击一件近战武器即可涂抹；涂层持续 [SWORD_OIL_DURATION / (1 MINUTES)] 分钟，命中克制目标时额外造成 <b>[SWORD_OIL_BONUS_MULT * 100]%</b> 的挥击伤害。")

// ===========================================================================
// attack_self：玩家空手激活（手里点一下）时给出用法提示。
// WHY：剑油不是饮品也没有“激活”功能，这里友好提示防止玩家困惑。
// ===========================================================================
/obj/item/z121_sword_oil/attack_self(mob/user)
	to_chat(user, span_notice("这是涂在兵刃上的油——手持它点击一件近战武器即可涂抹，可不是拿来喝的。"))

// ===========================================================================
// pre_attack：手持剑油瓶点击“某个目标”时最先触发。
// 若目标是近战武器（/obj/item/rogueweapon）→ 走涂抹流程并返回 TRUE（消费本次
// 点击，阻止把瓶子当钝器抡向武器）；其余目标一律 return ..() 放行原有行为。
// ===========================================================================
/obj/item/z121_sword_oil/pre_attack(atom/A, mob/living/user, params)
	// 错误处理：缺目标 / 缺使用者时交回父类默认逻辑，避免空指针。
	if(!A || !user)
		return ..()
	// 只拦截“近战武器”这一类可涂抹目标（剑/斧/矛等 rogueweapon 全家族）；其它一律放行。
	if(istype(A, /obj/item/rogueweapon))
		try_apply(A, user)                                      // 执行涂抹
		return TRUE                                             // 消费本次点击
	return ..()                                                 // 非武器目标：放行原逻辑

// ===========================================================================
// try_apply：把剑油涂抹到目标武器上的核心流程（含完整错误处理）。
// 流程：前置校验 → 引导读条 → 二次校验 → 替换旧涂层 → 挂新涂层组件 → 扣次数。
// ===========================================================================
/obj/item/z121_sword_oil/proc/try_apply(obj/item/target, mob/living/user)
	// —— 前置错误处理 —— //
	// 1) 目标已失效（可能在派发途中被删除）。
	if(QDELETED(target))
		to_chat(user, span_warning("目标已经不在了。"))
		return
	// 2) 抽象类守卫：基类瓶子没有配置涂层组件（配置错误 / 管理员误刷基类），礼貌报错。
	if(!coating_component_type)
		to_chat(user, span_warning("[src]似乎只是一瓶没有任何效力的废油。"))
		return
	// 3) 瓶中的油已经用完（理论上用完即销毁，这里再兜一层防御）。
	if(oil_uses <= 0)
		to_chat(user, span_warning("[src]已经空了。"))
		return

	// —— 引导：短暂读条，可被打断，表现“沿着剑刃细细涂抹”的仪式感 —— //
	user.visible_message(
		span_notice("[user]正沿着[target]的锋刃细细涂抹[src]……"),   // 旁观者视角
		span_notice("我沿着[target]的锋刃细细涂抹[src]……")           // 自身视角
	)
	if(!do_after(user, SWORD_OIL_CHANNEL, target = user))       // 读条被打断则返回 FALSE
		to_chat(user, span_warning("涂抹被打断了。"))
		return

	// —— 引导后二次校验：读条期间任何前提都可能失效 —— //
	if(QDELETED(target) || QDELETED(src))                       // 目标或油瓶没了
		return
	if(!user.Adjacent(target) && !(target in user.contents))    // 武器既不在身边、也不在身上（够不到）
		to_chat(user, span_warning("[target]已经不在手边了。"))
		return
	if(oil_uses <= 0)                                           // 读条期间次数被并发用完（双持连点等边角情况）
		to_chat(user, span_warning("[src]已经空了。"))
		return

	// —— 替换旧涂层：同一件武器同一时间只保留一层剑油（原作行为） —— //
	// WHY 用基类路径查找：组件会以其全部父类型登记进 datum_components 查找表，
	//   所以用基类 /datum/component/z121_sword_oil 一次就能找到任意一种旧剑油涂层。
	var/datum/component/z121_sword_oil/old_oil = target.GetComponent(/datum/component/z121_sword_oil)
	if(old_oil)
		to_chat(user, span_notice("我抹去了[target]上残留的旧油，换上新的一层。"))
		qdel(old_oil)                                           // 删除旧涂层组件（其 Destroy 会自动还原武器名字）

	// —— 挂上新涂层组件，让武器获得“克制加伤”的能力 —— //
	// 传参：加成百分比（0.5=+50%）/ 持续时间 / 克制目标说明 / 油名（用于命名与战斗日志）。
	var/datum/component/z121_sword_oil/oil_comp = target.AddComponent(coating_component_type, SWORD_OIL_BONUS_MULT, SWORD_OIL_DURATION, target_desc, name)
	// 错误处理：组件因目标不兼容等原因挂载失败（返回 null 或已被删除）→ 不扣次数，直接报错返回。
	if(!oil_comp || QDELETED(oil_comp))
		to_chat(user, span_warning("油脂无法附着在[target]上。"))
		return

	// —— 成功：扣一次涂抹次数 + 反馈 + 音效 —— //
	oil_uses--
	playsound(get_turf(user), 'sound/items/drink_gen (1).ogg', 40, TRUE)  // 借用主线“液体”音效表现涂油
	user.visible_message(
		span_notice("[user]给[target]涂上了一层泛着微光的油脂。"),          // 旁观者视角
		span_green("我给[target]涂上了[name]——接下来 [SWORD_OIL_DURATION / (1 MINUTES)] 分钟内，它对[target_desc]的杀伤提高 [SWORD_OIL_BONUS_MULT * 100]%。")  // 自身视角
	)

	// —— 用尽处理：退还一个空玻璃瓶，销毁油瓶 —— //
	// WHY 退空瓶：配方消耗了一个玻璃瓶，用完退瓶让容器可以循环利用，贴合本服炼金生态。
	if(oil_uses <= 0)
		to_chat(user, span_notice("[src]见了底，只剩下一个空瓶。"))
		var/obj/item/empty_bottle = new /obj/item/reagent_containers/glass/bottle/rogue(get_turf(user))  // 在脚下生成空瓶
		user.put_in_hands(empty_bottle)                          // 尽量直接塞回手里（手满则自然落地）
		qdel(src)                                                // 销毁用尽的油瓶

// ===========================================================================
// 七种剑油瓶的具体定义：只负责“名字/描述/染色/克制说明/对应涂层组件”，
// 真正的目标判定逻辑在各自的组件子类里（见文件下半部分）。
// ===========================================================================

// —— 绞刑者之油：克制人形生物 ——
/obj/item/z121_sword_oil/hanged_man
	name = "绞刑者之油"
	desc = "以尸毒与烟叶粉调和的浑浊毒油，散发着绞刑架下的气味。涂在兵刃上，对一切人形生物造成可怖的杀伤。"
	icon_state = "Hanged Man's Oil"                             // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "人形生物（人类、蜥蜴人、兽人、哥布林等）"
	coating_component_type = /datum/component/z121_sword_oil/hanged_man

// —— 兽类之油：克制野兽 ——
/obj/item/z121_sword_oil/beast
	name = "兽类之油"
	desc = "以兽脂、肌腱与尾骨熬炼的粘稠油脂，带着荒野猎物的腥气。涂在兵刃上，对熊、狼与各类野外巨兽造成可怖的杀伤。"
	icon_state = "Beast Oil"                                    // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "野兽（熊、狼、巨兽与野外掠食动物）"
	coating_component_type = /datum/component/z121_sword_oil/beast

// —— 蛛形怪之油：克制蜘蛛与毒虫 ——
/obj/item/z121_sword_oil/arachnid
	name = "蛛形怪之油"
	desc = "以蛛腺与沼泽烟叶粉调和的暗绿色油脂，闻起来像潮湿的地穴。涂在兵刃上，对蜘蛛与毒虫造成可怖的杀伤。"
	icon_state = "Arachnid Oil"                                 // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "蛛形怪（蜘蛛、毒虫与地底巢穴生物）"
	coating_component_type = /datum/component/z121_sword_oil/arachnid

// —— 恶魔之油：克制炼狱造物 ——
/obj/item/z121_sword_oil/demon
	name = "恶魔之油"
	desc = "以火之精质与圣水调和的赤红油脂，表面偶尔泛起细小的火星。涂在兵刃上，对恶魔与炼狱召唤物造成可怖的杀伤。"
	icon_state = "Demon Oil"                                    // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "炼狱造物（恶魔、地狱犬与地狱召唤物）"
	coating_component_type = /datum/component/z121_sword_oil/demon

// —— 诅咒之油：克制狼人等受诅者 ——
/obj/item/z121_sword_oil/cursed
	name = "诅咒之油"
	desc = "以银粉与圣水调和的幽紫油脂，在月光下会泛出冷冽的银辉。涂在兵刃上，对狼人与一切惧银的受诅者造成可怖的杀伤。"
	icon_state = "Cursed Oil"                                   // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "受诅者（狼人、受诅咒的兽化者与惧银的怪物）"
	coating_component_type = /datum/component/z121_sword_oil/cursed

// —— 吸血鬼之油：克制血裔 ——
/obj/item/z121_sword_oil/vampire
	name = "吸血鬼之油"
	desc = "以银粉、圣水与祝圣种子粉调和的暗红油脂，气味神圣得刺鼻。涂在兵刃上，对吸血鬼与血魔法造物造成可怖的杀伤。"
	icon_state = "Vampire Oil"                                  // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "血裔（吸血鬼及血脉、血魔法相关的敌人）"
	coating_component_type = /datum/component/z121_sword_oil/vampire

// —— 食尸生物之油：克制不死者 ——
/obj/item/z121_sword_oil/necrophage
	name = "食尸生物之油"
	desc = "以银粉、骨粉与圣水调和的灰白油脂，散发着墓土的气味。涂在兵刃上，对骷髅、丧尸等一切不死者造成可怖的杀伤。"
	icon_state = "Necrophage Oil"                               // 专属贴图（modular_z121/icon/item.dmi）
	target_desc = "不死者（骷髅、丧尸、亡灵杂兵）"
	coating_component_type = /datum/component/z121_sword_oil/necrophage

// ###########################################################################
// 涂层组件基类：/datum/component/z121_sword_oil
// ---------------------------------------------------------------------------
// 挂在“被涂油的武器”上，负责：
//   · 监听主线命中信号 COMSIG_ITEM_ATTACK_EFFECT_SELF（do_special_attack_effect()
//     在近战/投掷命中时对武器自身发出，携带使用者/受害者/部位等参数）；
//   · 命中后调用 is_valid_target() 判定受害者是否属于本油的克制类别，
//     命中克制目标即通过主线 apply_damage() 追加一段钝击加伤；
//   · 持续时间到期自动挥发（addtimer 定时自毁），Destroy 兜底还原武器名字。
// WHY 选 COMSIG_ITEM_ATTACK_EFFECT_SELF：这是本代码库“武器命中活体”的标准信号
//   （涂毒工具袋等既有模块同样以它为投递钩子），无需改动任何引擎攻击代码。
// ###########################################################################
/datum/component/z121_sword_oil
	// 命中克制目标时的伤害加成【百分比系数】（0.5 = 追加本次挥击伤害的 50%；由油瓶传入，便于统一调参）。
	var/bonus_mult = 0.5
	// 克制目标的中文说明（命中反馈与 examine 展示用）。
	var/target_desc = "某类敌人"
	// 油名（战斗日志与命名后缀用）。
	var/oil_name = "剑油"
	// 到期自毁定时器句柄（TIMER_STOPPABLE 便于在提前替换/武器销毁时取消）。
	var/expire_timer
	// 涂层到期的绝对时刻（world.time 基准，examine 剩余时间展示用）。
	var/expire_at = 0
	// 记录挂载前武器的原始名字，卸载/到期时用来还原。
	var/original_name
	// 命中反馈消息的下次可用时刻（节流，防止连击刷屏）。
	var/next_msg = 0

// ===========================================================================
// Initialize：接收油瓶传入的涂层数据，注册命中/查看信号，起到期定时器并改名。
// 返回 COMPONENT_INCOMPATIBLE 可让 AddComponent 判定“不兼容”而放弃挂载。
// ===========================================================================
/datum/component/z121_sword_oil/Initialize(_bonus_mult, _duration, _target_desc, _oil_name)
	// 只允许挂在 /obj/item 上（武器都是 item）；否则拒绝挂载（防御异常调用）。
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	// 加成系数或持续时间非法（<=0）则毫无意义，拒绝挂载（防御异常调用）。
	if(!(_bonus_mult > 0) || !(_duration > 0))
		return COMPONENT_INCOMPATIBLE

	// —— 落盘各项涂层数据 —— //
	bonus_mult = _bonus_mult
	if(_target_desc)                                            // 有说明就用，否则维持默认占位
		target_desc = _target_desc
	if(_oil_name)                                               // 有油名就用，否则维持默认占位
		oil_name = _oil_name

	var/obj/item/I = parent
	original_name = I.name                                      // 记录原名，便于到期时还原
	// 给武器名加“(涂有 X)”后缀，让玩家一眼看出这把兵刃上了油。
	I.name = "[original_name]（涂有[oil_name]）"

	// —— 到期定时器：持续时间一到就调用 expire() 自毁 —— //
	// WHY TIMER_STOPPABLE：武器中途换油/被销毁时需要 deltimer 取消，避免残留定时器。
	expire_at = world.time + _duration
	expire_timer = addtimer(CALLBACK(src, PROC_REF(expire)), _duration, TIMER_STOPPABLE)

	// —— 命中信号：近战命中 / 投掷命中都会经此信号 —— //
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(on_attack_hit))
	// —— 查看信号：让玩家 examine 武器时看到“涂有 X（剩余时间）” —— //
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

// ===========================================================================
// is_valid_target：判定受害者是否属于本油的克制类别（基类恒 FALSE）。
// WHY 设计成组件子类各自覆写：七种油的判定标准完全不同（种族/生物位旗标/
//   反派身份/类型路径混合判定），分散到子类里比一个巨型 switch 清晰得多。
// ===========================================================================
/datum/component/z121_sword_oil/proc/is_valid_target(mob/living/victim)
	return FALSE                                                // 基类不克制任何目标（抽象基准）

// ===========================================================================
// —— 以下是各子类共用的“身份判定小工具”，全部只读、无副作用 ——
// 之所以放在基类：不死/吸血鬼/狼人/蜘蛛/恶魔这些判定会被多个油交叉引用
//（例如兽油要“排除”蜘蛛与恶魔，绞刑者油要“排除”不死者），复用避免拷贝粘贴。
// ===========================================================================

// —— 判定“不死者”：生物位旗标含 MOB_UNDEAD / 携带丧尸反派身份 / 骷髅杂兵 / 死人镇 NPC ——
// WHY 多路兜底：本服的不死者来源多样——简单动物骷髅用 MOB_UNDEAD 位旗标，
//   玩家丧尸挂 /datum/antagonist/zombie 反派数据，野外死人 NPC 则是专门的人类子类型。
/datum/component/z121_sword_oil/proc/is_undead_like(mob/living/victim)
	if(victim.mob_biotypes & MOB_UNDEAD)                        // 位旗标判定（骷髅/亡灵兽等简单动物走这里）
		return TRUE
	if(victim.mind?.has_antag_datum(/datum/antagonist/zombie))  // 玩家丧尸（反派数据判定；?. 防无 mind 的 NPC 空指针）
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/rogue/skeleton))  // 骷髅杂兵（召唤/巢穴刷出的骷髅系）
		return TRUE
	if(istype(victim, /mob/living/carbon/human/species/npc/deadite))      // 野外“死人”NPC（deadite 专用人类子类）
		return TRUE
	return FALSE

// —— 判定“吸血鬼/血裔”：吸血鬼反派数据 / 吸血鬼领主特殊身份 ——
// WHY 遵循主线 necra 神术的同款判定链（含伪装豁免）：本分支的吸血鬼没有独立
//   种族（/datum/species/vampire 并不存在），身份完全由反派数据承载；伪装中的
//   吸血鬼不该被一瓶油“物理开盾”式地当场识破——与神术翻搅不炸伪装吸血鬼一致。
/datum/component/z121_sword_oil/proc/is_vampire_like(mob/living/victim)
	if(victim.mind)
		// 伪装豁免：正处于伪装状态的吸血鬼不触发克制（保护其潜伏玩法，主线 necra 同款处理）。
		if(victim.mind.has_antag_datum(/datum/antagonist/vampire) && !SEND_SIGNAL(victim, COMSIG_DISGUISE_STATUS))
			return TRUE
		if(victim.mind.special_role == "Vampire Lord")          // 吸血鬼领主（特殊身份字符串，主线同款判定）
			return TRUE
	return FALSE

// —— 判定“狼人/受诅者”：狼人兽形种族 / 惧银特性（一切被银克制的存在）——
// WHY 用 TRAIT_SILVER_WEAK 兜底：本服狼人变身时携带“惧银”特性，其它被诅咒的
//   惧银怪物同理——“诅咒之油=对惧银者的银质打击”正好与该特性语义一一对应。
/datum/component/z121_sword_oil/proc/is_werewolf_like(mob/living/victim)
	if(is_species(victim, /datum/species/werewolf))             // 狼人兽形形态（变身后的专用种族）
		return TRUE
	if(HAS_TRAIT(victim, TRAIT_SILVER_WEAK))                    // 惧银特性（受诅咒的兽化者/惧银怪物）
		return TRUE
	return FALSE

// —— 判定“蛛形怪/毒虫”：各类蜘蛛类型路径 / 虫类生物位旗标 / 蛛人种族 ——
/datum/component/z121_sword_oil/proc/is_spider_like(mob/living/victim)
	if(istype(victim, /mob/living/simple_animal/hostile/retaliate/rogue/spider))     // 蜜蛛/岩蛛等野生蜘蛛
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/retaliate/rogue/drider))     // 蛛驱（半人半蛛巢穴怪）
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/retaliate/rogue/mirespider)) // 泥沼蛛（阿拉格蜘蛛）
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/rogue/mirespider_lurker))    // 泥沼潜伏蛛（巢穴伏击型）
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/rogue/mirespider_paralytic)) // 麻痹泥沼蛛（毒虫型）
		return TRUE
	if(victim.mob_biotypes & MOB_BUG)                           // 虫类位旗标（甲虫等一切毒虫/节肢生物兜底）
		return TRUE
	if(is_species(victim, /datum/species/arachnid))             // 蛛人种族（类蛛人形生物也吃这瓶油的克制）
		return TRUE
	return FALSE

// —— 判定“恶魔/炼狱造物”：炼狱系召唤物基类一网打尽（恶鬼/地狱犬/小鬼/看守者）——
/datum/component/z121_sword_oil/proc/is_demon_like(mob/living/victim)
	// /retaliate/rogue/infernal 是本服全部炼狱生物（fiend/hellhound/imp/watcher）的共同基类，
	// 用基类 istype 一次覆盖现有与将来新增的所有炼狱子类型。
	if(istype(victim, /mob/living/simple_animal/hostile/retaliate/rogue/infernal))
		return TRUE
	return FALSE

// ===========================================================================
// on_attack_hit：武器命中目标时的加伤逻辑（近战 / 投掷共用）。
// 信号来源：do_special_attack_effect() 中的
//   SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_EFFECT_SELF, user, affecting, intent, victim, selzone)
// 故形参顺序与之一一对应。
// ===========================================================================
/datum/component/z121_sword_oil/proc/on_attack_hit(obj/item/source, mob/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER                                              // 信号处理器：内部只做轻量、无阻塞操作
	// 错误处理：只对“仍然存活的活体”生效——命中墙/物件/尸体不追加伤害。
	if(!isliving(victim) || QDELETED(victim))
		return
	if(victim.stat == DEAD)                                     // 鞭尸不触发（避免无意义的伤害与刷屏）
		return
	// 核心判定：受害者不属于本油的克制类别 → 剑油毫无效果（原作设定）。
	if(!is_valid_target(victim))
		return

	// —— 计算本次挥击的“基准伤害”，加成 = 基准伤害 × bonus_mult（百分比加成）—— //
	// WHY 用主线全局 proc get_complex_damage(武器, 攻击者)：这正是引擎两条命中路径
	//   （对人类的 species.dm 与对简单动物的 attacked_by）用来算每次挥击实际伤害的
	//   同一个入口——它综合了武器动态力度(force_dynamic/精工)、使用者力量、刀刃
	//   锋利度与攻击意图系数。在命中信号里重算一次，得到与本次挥击一致的基准值，
	//   再乘以 0.5 就是“伤害提高 50%”的忠实实现（而非拍脑袋的固定数值）。
	var/swing_damage = 0
	if(isliving(user))                                          // 常规路径：有活体攻击者（近战/投掷均有 thrownby）
		swing_damage = get_complex_damage(source, user)
	else                                                        // 兜底：攻击者缺失（如投掷者已下线销毁）——退回武器自身力度
		swing_damage = source.force_dynamic ? source.force_dynamic : source.force
	var/bonus = swing_damage * bonus_mult
	// 错误处理：基准伤害无效（徒手系/0 力度武器等）→ 加成为 0，不做无意义的伤害调用。
	if(!(bonus > 0))
		return

	// —— 追加克制伤害：走主线标准伤害入口 apply_damage —— //
	// WHY 用 apply_damage 而非直接改武器 force：force 是武器的共享属性，改它会
	//   影响所有攻击目标且难以按“目标类别”区分；在命中信号里按判定结果补一段
	//   伤害，才能精确实现“只对克制目标加伤”。selzone 原样透传，让加伤落在同一
	//   部位；伤害类型沿用武器自身的 damtype（斩/钝等语义与原挥击保持一致）。
	victim.apply_damage(bonus, source.damtype ? source.damtype : BRUTE, selzone)

	// —— 命中反馈（节流：至多每 SWORD_OIL_MSG_CD 提示一次，防连击刷屏）—— //
	if(world.time >= next_msg)
		next_msg = world.time + SWORD_OIL_MSG_CD
		victim.visible_message(
			span_danger("[source]上的油脂在[victim]的伤口里剧烈灼烧！"),   // 旁观者视角（含双方玩家）
			span_userdanger("兵刃上的油脂在我的伤口里剧烈灼烧！")           // 受害者视角
		)
	// 战斗日志：便于管理员追溯“谁用哪种剑油克制了谁、加成了多少”。
	if(user)
		log_combat(user, victim, "sword-oil bonus hit", addition = "with [oil_name] (+[round(bonus, 0.1)] = [bonus_mult * 100]% of [round(swing_damage, 0.1)])")

// ===========================================================================
// on_examine：查看被涂油的武器时，附加显示涂层信息（油名 + 克制目标 + 剩余时间）。
// ===========================================================================
/datum/component/z121_sword_oil/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	// 剩余时间按“到期时刻 - 当前时刻”计算并向上取整为秒，直观易读。
	var/seconds_left = max(0, round((expire_at - world.time) / 10))
	examine_list += span_green("它涂着一层<b>[oil_name]</b>，专克[target_desc]（约剩 [seconds_left] 秒药效）。")

// ===========================================================================
// expire：涂层持续时间到期——通知持有者、还原武器名字并自毁。
// ===========================================================================
/datum/component/z121_sword_oil/proc/expire()
	var/obj/item/I = parent
	// 若武器此刻正被某个生物携带，则提示 TA“油挥发了”（拿在手里/放在包里都算）。
	if(!QDELETED(I) && ismob(I.loc))
		to_chat(I.loc, span_warning("[I]上的[oil_name]已经挥发殆尽了。"))
	qdel(src)                                                   // 自毁：Destroy 负责还原名字与清理定时器

// ===========================================================================
// Destroy：兜底清理——取消到期定时器、还原武器原始名字，再交回父类。
// （无论是到期、换油替换，还是武器本体被销毁连带删除，都会走到这里。）
// ===========================================================================
/datum/component/z121_sword_oil/Destroy(force, silent)
	// 取消尚未触发的到期定时器，避免对已删除组件的悬空回调。
	if(expire_timer)
		deltimer(expire_timer)
		expire_timer = null
	// 还原武器原始名字（若武器尚在且名字仍带着我们的后缀）。
	var/obj/item/I = parent
	if(!QDELETED(I) && original_name && I.name != original_name)
		I.name = original_name
	return ..()

// ###########################################################################
// 七种剑油各自的涂层组件子类：每个子类只覆写 is_valid_target()。
// ###########################################################################

// ===========================================================================
// 绞刑者之油涂层：克制【人形生物】。
// 判定：人类种族大家族（ishuman 覆盖人类/蜥蜴人/兽人/哥布林等一切可玩人形）
//       或带 MOB_HUMANOID 生物位旗标的简单动物；
// 排除：不死者/吸血鬼/狼人形态——这些“曾经是人”的怪物各有专属剑油，
//       绞刑者之油对付的是“活着的人形生物”（原作设定同理）。
// ===========================================================================
/datum/component/z121_sword_oil/hanged_man/is_valid_target(mob/living/victim)
	// 先做排除：亡者归食尸生物之油，血裔归吸血鬼之油，狼人归诅咒之油。
	if(is_undead_like(victim) || is_vampire_like(victim) || is_werewolf_like(victim))
		return FALSE
	if(ishuman(victim))                                         // 人类种族大家族（含哥布林/蜥蜴人等一切人形种族）
		return TRUE
	if(victim.mob_biotypes & MOB_HUMANOID)                      // 人形位旗标的简单动物兜底
		return TRUE
	return FALSE

// ===========================================================================
// 兽类之油涂层：克制【野兽】（熊、狼、巨兽与野外掠食动物）。
// 判定：带 MOB_BEAST 生物位旗标，或属于本服野生动物基类 /retaliate/rogue；
// 排除：蜘蛛/恶魔/不死者——它们虽然继承同一野生动物基类（或同带 BEAST 旗标），
//       但各有专属剑油；人形生物同样排除（兽人玩家种族可能带兽类旗标）。
// ===========================================================================
/datum/component/z121_sword_oil/beast/is_valid_target(mob/living/victim)
	// 先做排除：蛛归蛛油，魔归魔油，亡者归食尸油，人形归绞刑者油。
	if(is_spider_like(victim) || is_demon_like(victim) || is_undead_like(victim))
		return FALSE
	if(ishuman(victim))                                         // 人形生物不算“野兽”（哪怕是兽人种族）
		return FALSE
	if(victim.mob_biotypes & MOB_BEAST)                         // 兽类位旗标（狼/熊/巨兽等野生动物的标准标记）
		return TRUE
	if(istype(victim, /mob/living/simple_animal/hostile/retaliate/rogue))  // 野生动物基类兜底（个别未设旗标的兽类）
		return TRUE
	return FALSE

// ===========================================================================
// 蛛形怪之油涂层：克制【蜘蛛、毒虫与地底巢穴生物】。
// 判定全部委托给基类的 is_spider_like（类型路径 + MOB_BUG 旗标 + 蛛人种族）。
// ===========================================================================
/datum/component/z121_sword_oil/arachnid/is_valid_target(mob/living/victim)
	return is_spider_like(victim)

// ===========================================================================
// 恶魔之油涂层：克制【恶魔、地狱犬与炼狱召唤物】。
// 判定全部委托给基类的 is_demon_like（炼狱系基类一网打尽）。
// ===========================================================================
/datum/component/z121_sword_oil/demon/is_valid_target(mob/living/victim)
	return is_demon_like(victim)

// ===========================================================================
// 诅咒之油涂层：克制【狼人、受诅咒的兽化者与惧银的怪物】。
// 判定全部委托给基类的 is_werewolf_like（狼人种族 + 惧银特性）。
// ===========================================================================
/datum/component/z121_sword_oil/cursed/is_valid_target(mob/living/victim)
	return is_werewolf_like(victim)

// ===========================================================================
// 吸血鬼之油涂层：克制【吸血鬼及血裔、血魔法相关的敌人】。
// 判定全部委托给基类的 is_vampire_like（反派数据 + 种族 + 领主身份，含伪装豁免）。
// ===========================================================================
/datum/component/z121_sword_oil/vampire/is_valid_target(mob/living/victim)
	return is_vampire_like(victim)

// ===========================================================================
// 食尸生物之油涂层：克制【骷髅、丧尸、亡灵杂兵等不死者】。
// 判定全部委托给基类的 is_undead_like（位旗标 + 丧尸反派 + 骷髅/死人类型路径）。
// ===========================================================================
/datum/component/z121_sword_oil/necrophage/is_valid_target(mob/living/victim)
	return is_undead_like(victim)

// ===== 清理顶部宏定义，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SWORD_OIL_BONUS_MULT
#undef SWORD_OIL_DURATION
#undef SWORD_OIL_USES
#undef SWORD_OIL_CHANNEL
#undef SWORD_OIL_MSG_CD
