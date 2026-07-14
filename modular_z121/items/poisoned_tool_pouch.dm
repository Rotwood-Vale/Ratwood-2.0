// ===========================================================================
// modular_z121 自定义物品：涂毒工具袋（Poisoned Tool Pouch）
// ---------------------------------------------------------------------------
// English overview:
//   A pouch that holds a poured-in liquid. Use it on a weapon or an arrow to
//   "smear"/coat that item with the pouch's liquid, so the coated item then
//   delivers that liquid into a living target it strikes (the reagent's own
//   metabolism is what actually deals the damage — we only provide the
//   delivery hook).
//     * Weapon : one application consumes 10u and lasts 10 hits (1u per hit).
//     * Arrow  : one application consumes 1u  and works exactly once.
//   The pouch's SPRITE never changes with amount/type of liquid; only its
//   NAME reflects what is inside (e.g. "Poisoned Tool Pouch for poison").
//
// 中文总览：
//   一个可以“倒入液体”的工具袋。手持它点击一件【武器】或【箭矢】即可把袋中
//   液体“涂抹”到该物品上；被涂抹的物品在命中活体目标时，会把这份液体注入目标
//   （真正造成伤害的是液体/试剂自身的代谢效果，本物品只负责“投递”这一环）。
//     · 武器：一次涂抹消耗 10u，可生效 10 次（每次命中投递 1u）。
//     · 箭矢：一次涂抹消耗 1u，仅生效 1 次。
//   袋子的【贴图】不随内含液体的数量/种类变化；只有【名字】会反映内容物，
//   例如“涂毒工具袋（毒药）”。
//
// 约束（严格遵守项目规则）：本文件只存在于 modular_z121 内，仅“调用/继承”主线
//   现成类型与接口（/obj/item/reagent_containers、/datum/reagents、
//   /obj/item/rogueweapon、/obj/item/ammo_casing、projectile.poisontype 等），
//   绝不修改 modular_z121 之外的任何文件。
//
// 注册方式：modular_z121/_load.dm -> #include "items/poisoned_tool_pouch.dm"
// 贴图：'modular_z121/icon/item.dmi' 内图标态 "Poisoned Tool Pouch"（已确认存在）。
// ===========================================================================

// ===== 数值旋钮（集中定义，文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以集中放这些魔法数字，是为了让后续平衡性调整一目了然。
#define POUCH_ICON              'modular_z121/icon/item.dmi'  // 物品贴图文件（本模块内）
#define POUCH_STATE             "Poisoned Tool Pouch"         // 贴图内图标态名（贴图固定，不随内容变化）
#define POUCH_VOLUME            100                           // 袋子容量（可反复容纳多次涂抹所需的液体）

#define SMEAR_WEAPON_COST       10   // 涂抹一件【武器】消耗的液体单位（10u）
#define SMEAR_WEAPON_CHARGES    10   // 涂抹一件【武器】后可生效的次数（10 次）
#define SMEAR_AMMO_COST         1    // 涂抹一支【箭矢】消耗的液体单位（1u）
#define SMEAR_AMMO_CHARGES      1    // 涂抹一支【箭矢】后可生效的次数（1 次）

#define SMEAR_CHANNEL           (1.5 SECONDS)  // 涂抹时的引导时长（可被打断，纯表现 + 防误触）

// ===========================================================================
// 物品本体：涂毒工具袋
// ---------------------------------------------------------------------------
// 继承 /obj/item/reagent_containers：直接复用主线“试剂容器”的液体持有/倒入能力。
// reagent_flags 设为 OPENCONTAINER(=REFILLABLE|DRAINABLE|TRANSPARENT)，这样：
//   · REFILLABLE  → 别的容器（酒瓶/水桶等，倒液意图 INTENT_POUR）可以把液体倒进本袋；
//   · DRAINABLE   → 需要时也能把液体从袋里舀出；
//   · TRANSPARENT → 可以查看袋内液体。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch
	name = "涂毒工具袋"                                          // 基础名（会被 update_pouch_name 按内容物动态改写）
	desc = "一只带细颈的皮制小袋，内衬蜡封以盛放液体。\n\
	把液体倒进袋中，再用它涂抹武器或箭矢，即可让兵刃“带毒”出击——\n\
	武器可反复涂抹（每次涂抹 10 单位、生效 10 次），箭矢一次涂抹 1 单位、仅生效一次。"  // 描述（\ 续行）
	icon = POUCH_ICON                                           // 使用本模块贴图文件
	icon_state = POUCH_STATE                                    // 固定图标态（贴图不随内容变化）
	w_class = WEIGHT_CLASS_SMALL                                // 体积“小”：便于携带但不至于像瓶子那样微小
	volume = POUCH_VOLUME                                       // 容量（见上）
	reagent_flags = OPENCONTAINER                               // 允许倒入/舀出/查看液体（见类注释）
	amount_per_transfer_from_this = 10                          // 默认单次转移量（与武器涂抹成本对齐，纯手感）
	possible_transfer_amounts = list(1, 5, 10, 25, 50)         // 可选转移量档位（含 1u，方便精确取用给箭矢）
	spillable = FALSE                                           // 不做“投掷即泼洒”，避免珍贵毒液被随手摔没
	sellprice = 30                                              // 一个有实用价值的工具，给一个中等售价

	// —— 记录“基础名”，供 update_pouch_name 在内容物变化时拼接出动态名字 ——
	// 用 var 缓存而不是每次 initial(name)，是为了让子类/管理员改名后仍以其改后的名字为基准。
	var/pouch_base_name = "涂毒工具袋"

// ===========================================================================
// Initialize：出生即按当前内容物刷新一次名字（空袋则显示基础名）。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch/Initialize(mapload, vol)
	. = ..()                                                    // 先让父类建好 reagents 持有者
	update_pouch_name()                                         // 依据（可能预置的）内容物刷新名字

// ===========================================================================
// on_reagent_change：只要袋内液体发生任何增减，就同步刷新“名字 + 贴图”。
// 父类的 on_reagent_change 负责刷新填充贴图；我们在其后追加“按内容物改名”。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch/on_reagent_change(changetype)
	. = ..()                                                    // 保留父类的贴图刷新逻辑
	update_pouch_name()                                         // 追加：按内容物刷新名字

// ===========================================================================
// update_pouch_name：把袋子名字改写为“基础名（主液体名）”。
// 需求：贴图不变，仅用名字体现差异，形如“Poisoned Tool Pouch for poison”。
// 这里用主线现成的 get_master_reagent_name()（袋内体积占比最大的那种试剂名）。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch/proc/update_pouch_name()
	// 空袋：直接回退到基础名，避免出现“（）”这种空括号尾巴。
	if(!reagents || !reagents.total_volume)
		name = pouch_base_name
		return
	// 非空：取“主试剂”名字拼进袋名（等价于英文示例的 "... for <liquid>"）。
	var/master = reagents.get_master_reagent_name()
	if(!master)                                                 // 极端兜底：有体积却取不到名字
		name = pouch_base_name
		return
	name = "[pouch_base_name]（[master]）"                       // 例：涂毒工具袋（毒药）

// ===========================================================================
// examine：查看袋子时给出内容物与用法提示，降低上手门槛。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch/examine(mob/user)
	. = ..()                                                    // 先取父类标准描述
	// 展示当前液体余量（用主线颜色混合，直观体现“装的是什么色的液体”）。
	if(reagents?.total_volume)
		var/reagent_color = mix_color_from_reagents(reagents.reagent_list)
		. += span_notice("袋中盛有 <font color=[reagent_color]>[round(reagents.total_volume, 0.1)]</font> 单位液体。")
		// 顺带算出“还能涂几件武器 / 几支箭矢”，方便玩家规划。
		. += span_info("大约还能涂抹 [FLOOR(reagents.total_volume / SMEAR_WEAPON_COST, 1)] 件武器，或 [FLOOR(reagents.total_volume / SMEAR_AMMO_COST, 1)] 支箭矢。")
	else
		. += span_warning("袋子是空的——先往里倒些液体（用装液体的容器以“倒”意图点击本袋）。")
	// 用法说明：手持本袋点击目标即可涂抹。
	. += span_notice("手持本袋点击一件武器或箭矢即可为其涂上液体。")

// ===========================================================================
// pre_attack：手持涂毒工具袋点击“某个目标”时最先触发。
// 若目标是可涂抹的武器/箭矢 → 走涂抹流程并返回 TRUE（消费本次点击，阻止把袋子当钝器抡）；
// 其余目标（含被倒液体等交互）一律 return ..() 放行，保留原有行为。
// ---------------------------------------------------------------------------
/obj/item/reagent_containers/z121_poison_pouch/pre_attack(atom/A, mob/living/user, params)
	// 错误处理：缺目标 / 缺使用者时，交回父类默认逻辑，避免空指针。
	if(!A || !user)
		return ..()
	// 只拦截“武器 或 弹药(箭/弩矢/标枪等)”这两类可涂抹目标；其它一律放行。
	if(istype(A, /obj/item/rogueweapon) || istype(A, /obj/item/ammo_casing))
		try_smear(A, user)                                     // 执行涂抹
		return TRUE                                            // 消费本次点击
	return ..()                                                // 非可涂抹目标：放行原逻辑

// ===========================================================================
// try_smear：把袋中液体涂抹到目标武器/箭矢上的核心流程（含完整错误处理）。
// ===========================================================================
/obj/item/reagent_containers/z121_poison_pouch/proc/try_smear(obj/item/target, mob/living/user)
	// —— 前置错误处理 —— //
	// 1) 目标已失效（可能在派发途中被删除）。
	if(QDELETED(target))
		to_chat(user, span_warning("目标已经不在了。"))
		return
	// 2) 袋子里根本没有液体，无从涂抹。
	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src]是空的，先往里倒些液体。"))
		return
	// 3) 目标已经涂过一层（尚未用尽）——不允许叠加，先用完再说，避免数值混乱。
	if(target.GetComponent(/datum/component/z121_pouch_coating))
		to_chat(user, span_warning("[target]上已经涂了一层液体了，先把它用掉。"))
		return

	// —— 判定目标类别，确定“成本 / 生效次数 / 是否弹药” —— //
	// 弹药（箭/弩矢/标枪）：1u / 1 次；其余武器：10u / 10 次。
	var/is_ammo = istype(target, /obj/item/ammo_casing)
	var/cost = is_ammo ? SMEAR_AMMO_COST : SMEAR_WEAPON_COST
	var/charges = is_ammo ? SMEAR_AMMO_CHARGES : SMEAR_WEAPON_CHARGES

	// 4) 液体不够一次涂抹所需的量。
	if(reagents.total_volume < cost)
		to_chat(user, span_warning("袋里的液体不够涂这个（需要 [cost] 单位，现有 [round(reagents.total_volume, 0.1)] 单位）。"))
		return

	// —— 引导：短暂读条，纯表现且可被打断，避免手滑误涂 —— //
	user.visible_message(
		span_notice("[user]正小心地用[src]里的液体涂抹[target]……"),   // 旁观者视角
		span_notice("我小心地把[src]里的液体涂抹到[target]上……")        // 自身视角
	)
	if(!do_after(user, SMEAR_CHANNEL, target = user))          // 读条被打断则返回 FALSE
		to_chat(user, span_warning("涂抹被打断了。"))
		return

	// —— 引导后二次校验：期间任何前提都可能失效 —— //
	if(QDELETED(target) || QDELETED(src))                      // 目标或袋子没了
		return
	if(!user.Adjacent(target) && !(target in user.contents))  // 目标既不在身边、也不在身上（够不到）
		to_chat(user, span_warning("[target]已经不在手边了。"))
		return
	if(reagents.total_volume < cost)                           // 期间液体被倒走/用掉，量又不够了
		to_chat(user, span_warning("涂抹前袋里的液体又不够了。"))
		return
	if(target.GetComponent(/datum/component/z121_pouch_coating)) // 期间被别人抢先涂了
		to_chat(user, span_warning("[target]刚刚已经被涂上了一层。"))
		return

	// —— 快照“每次命中要投递的试剂表” —— //
	// per_hit_volume：每次生效投递的总体积 = 成本 / 次数（武器 10/10=1u，箭矢 1/1=1u）。
	var/per_hit_volume = cost / charges
	// 按袋内各试剂当前的“体积占比”，把 per_hit_volume 拆分到每一种试剂上，
	// 从而完整还原“这袋液体本来的配比”，而不是只投递单一试剂。
	var/list/per_hit_reagents = list()
	var/total_now = reagents.total_volume
	for(var/datum/reagent/R in reagents.reagent_list)
		var/share = R.volume / total_now                      // 该试剂在袋中所占比例
		var/amt = share * per_hit_volume                      // 折算到每次命中的投递量
		if(amt > 0)                                            // 跳过占比为 0 的项，避免投递无意义的 0 单位
			per_hit_reagents[R.type] = amt

	// 记录“主试剂”类型与名字：
	//   · 弹药走主线 projectile.poisontype 投递（该字段只能是单一试剂），故取主试剂；
	//   · 同时用主试剂名字给涂层做展示标签。
	var/primary_type = reagents.get_master_reagent_id()
	var/primary_name = reagents.get_master_reagent_name()

	// 兜底：万一取不到有效的主试剂（异常空表），中止并不扣液体。
	if(!primary_type || !length(per_hit_reagents))
		to_chat(user, span_warning("这份液体似乎无法附着到[target]上。"))
		return

	// —— 扣除成本：remove_all 会按比例从各试剂里等比例扣减，保持余下液体配比不变 —— //
	reagents.remove_all(cost)

	// —— 挂上“涂层组件”，让目标物品获得“命中投递液体”的能力 —— //
	target.AddComponent(/datum/component/z121_pouch_coating, per_hit_reagents, charges, is_ammo, primary_type, per_hit_volume, primary_name)

	// —— 成功反馈 + 音效 —— //
	playsound(get_turf(user), 'sound/items/drink_gen (1).ogg', 40, TRUE)  // 借用“液体”音效表现涂抹（该音效在主线存在）
	user.visible_message(
		span_notice("[user]给[target]涂上了一层[primary_name]。"),                       // 旁观者视角
		span_green("我给[target]涂上了[primary_name]——[is_ammo ? "它下一次命中会带毒" : "接下来 [charges] 次命中都会带毒"]。")  // 自身视角
	)

// ###########################################################################
// 涂层组件：/datum/component/z121_pouch_coating
// ---------------------------------------------------------------------------
// 挂在“被涂抹的武器/箭矢”上，负责在其命中活体目标时投递液体，并按剩余次数递减，
// 用尽后自我卸载（还原物品名字）。
//   · 近战武器 / 投掷武器 / 近战捅刺的箭矢：走主线命中信号 COMSIG_ITEM_ATTACK_EFFECT_SELF；
//   · 从弓/弩射出的箭矢：直接给该箭“已装填的弹丸 BB”写上主线的 poisontype/poisonamount，
//     借助引擎既有的“命中即注毒”逻辑投递（发射后箭矢本体会被消耗、重新掉落为一支干净箭矢，
//     天然满足“仅生效一次”）。
// 注意（弓射路径的取舍）：projectile.poisontype 只能承载“单一试剂”，故弓射时只投递主试剂；
//   近战/投掷路径则按快照配比投递“完整混合液”。此差异已在设计上接受并在注释中说明。
// ###########################################################################
/datum/component/z121_pouch_coating
	// 每次命中要投递的试剂表：list(试剂路径 = 每次投递量)。
	var/list/per_hit_reagents
	// 剩余可生效次数（命中活体一次即 -1，归零即卸载）。
	var/charges = 1
	// 该目标是否为弹药（箭/弩矢等）——决定是否额外走 projectile.poisontype 弓射路径。
	var/is_ammo = FALSE
	// 弓射路径用的“主试剂”类型（projectile.poisontype 只接受单一试剂路径）。
	var/primary_type
	// 每次命中投递的总体积（弓射路径写入 projectile.poisonamount）。
	var/per_hit_volume = 1
	// 展示标签：主试剂名字，用于 examine 与改名。
	var/coating_label = "某种液体"
	// 记录挂载前的物品原始名字，卸载时用来还原。
	var/original_name

// ===========================================================================
// Initialize：接收 try_smear 传入的涂层数据，注册命中/查看信号，并给物品打标。
// 返回 COMPONENT_INCOMPATIBLE 可让 AddComponent 判定为“不兼容”而放弃挂载。
// ===========================================================================
/datum/component/z121_pouch_coating/Initialize(list/_per_hit_reagents, _charges, _is_ammo, _primary_type, _per_hit_volume, _coating_label)
	// 只允许挂在 /obj/item 上（武器/箭矢都是 item）；否则拒绝挂载。
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	// 没有有效的投递数据就没有意义，拒绝挂载（防御异常调用）。
	if(!length(_per_hit_reagents) || !_charges)
		return COMPONENT_INCOMPATIBLE

	// —— 落盘各项涂层数据 —— //
	per_hit_reagents = _per_hit_reagents
	charges = _charges
	is_ammo = _is_ammo
	primary_type = _primary_type
	per_hit_volume = _per_hit_volume
	if(_coating_label)                                         // 有主试剂名就用它，否则维持默认占位名
		coating_label = _coating_label

	var/obj/item/I = parent
	original_name = I.name                                     // 记录原名，便于卸载时还原
	// 给物品名加“(涂有 X)”后缀，让玩家一眼看出这件兵刃已带毒。
	I.name = "[original_name]（涂有[coating_label]）"

	// —— 弓射路径：若是弹药，给其“已装填弹丸”写上主线注毒字段 —— //
	// 引擎在 ready_proj 时会把箭的 reagents 传给弹丸，并在命中 carbon 时按 poisontype/amount 注毒；
	// 我们直接给当前已装填的 BB 写好这两个字段即可复用该逻辑（发射一次后箭本体即被消耗）。
	if(is_ammo)
		apply_ammo_poison()

	// —— 命中信号：近战命中 / 投掷命中 / 用箭近战捅刺都会经此信号 —— //
	// 该信号在 do_special_attack_effect() 里对着“武器自身(src)”发出，携带受害者等参数。
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(on_attack_hit))
	// —— 查看信号：让玩家 examine 时看到“已涂 X（剩余 N 次）” —— //
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

// ===========================================================================
// apply_ammo_poison：把主试剂写进弹药“已装填弹丸 BB”的 poisontype/poisonamount。
// 之所以单独成 proc：既在 Initialize 里调用，也便于将来在补射/换弹时复用。
// ===========================================================================
/datum/component/z121_pouch_coating/proc/apply_ammo_poison()
	var/obj/item/ammo_casing/ammo = parent                    // 类型转换以访问 BB
	// BB 可能为空（例如已被击发或异常状态）——此时静默跳过，近战/投掷信号仍可兜底生效。
	if(!ammo.BB)
		return
	ammo.BB.poisontype = primary_type                         // 命中 carbon 时注入的试剂类型
	ammo.BB.poisonamount = per_hit_volume                     // 注入量（本箭为 1u）

// ===========================================================================
// on_attack_hit：物品命中目标时的投递逻辑（近战 / 投掷 / 箭矢捅刺）。
// 信号来源：do_special_attack_effect() 中的
//   SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_EFFECT_SELF, user, affecting, intent, victim, selzone)
// 故形参顺序与之一一对应。
// ===========================================================================
/datum/component/z121_pouch_coating/proc/on_attack_hit(obj/item/source, mob/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER                                            // 信号处理器：内部只做轻量、无阻塞操作
	// 只有命中“活体”才投递（命中墙/物件不消耗次数）。
	if(!isliving(victim))
		return
	// 已无剩余次数（理论上此时组件应已卸载，这里再兜一层）——直接卸载。
	if(charges <= 0)
		remove_coating()
		return

	// —— 真正投递：把“每次命中试剂表”注入受害者体内 —— //
	// 只有具备 reagents 持有者的活体（carbon 等）才能承接液体；缺失者（部分简单生物）跳过注入，
	// 但仍视为“蹭掉了一层”而消耗次数（贴合现实：涂层碰到目标就会被抹去）。
	if(victim.reagents)
		for(var/reagent_path in per_hit_reagents)
			victim.reagents.add_reagent(reagent_path, per_hit_reagents[reagent_path])
		// 战斗日志：便于管理员追溯“谁用带毒兵刃毒了谁、毒的是什么”。
		log_combat(user, victim, "poisoned (tool pouch)", addition = "with [coating_label]")

	// —— 递减次数并按结果处理 —— //
	charges--
	if(charges <= 0)
		remove_coating()                                     // 用尽：卸载涂层、还原名字
	else
		refresh_coated_name()                                // 未尽：刷新名字里的“剩余次数”

// ===========================================================================
// on_examine：查看被涂抹的物品时，附加显示涂层信息（试剂名 + 剩余次数）。
// ===========================================================================
/datum/component/z121_pouch_coating/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_red("它被涂上了一层<b>[coating_label]</b>（还能生效 [charges] 次）。")

// ===========================================================================
// refresh_coated_name：把物品名字更新为“原名（涂有 X · 剩 N 次）”，随命中动态变化。
// ===========================================================================
/datum/component/z121_pouch_coating/proc/refresh_coated_name()
	var/obj/item/I = parent
	if(QDELETED(I))
		return
	I.name = "[original_name]（涂有[coating_label]·剩[charges]次）"

// ===========================================================================
// remove_coating：涂层用尽/失效时的收尾——还原名字、清掉弹丸注毒字段，并删除组件。
// ===========================================================================
/datum/component/z121_pouch_coating/proc/remove_coating()
	var/obj/item/I = parent
	// 还原物品原始名字（若物品尚在）。
	if(!QDELETED(I))
		I.name = original_name
		// 若是弹药且弹丸还在，顺手清掉之前写入的注毒字段，避免残留“空毒”。
		if(is_ammo)
			var/obj/item/ammo_casing/ammo = I
			if(ammo.BB && ammo.BB.poisontype == primary_type)
				ammo.BB.poisontype = null
				ammo.BB.poisonamount = null
	qdel(src)                                                // 删除组件：基类会自动注销已注册的信号

// ===========================================================================
// Destroy：兜底还原名字（例如组件因物品被销毁而连带删除时），再交回父类。
// ===========================================================================
/datum/component/z121_pouch_coating/Destroy(force, silent)
	var/obj/item/I = parent
	if(!QDELETED(I) && original_name && I.name != original_name)
		I.name = original_name                               // 保证不残留“(涂有 X)”后缀
	return ..()

// ===== 清理顶部宏定义，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef POUCH_ICON
#undef POUCH_STATE
#undef POUCH_VOLUME
#undef SMEAR_WEAPON_COST
#undef SMEAR_WEAPON_CHARGES
#undef SMEAR_AMMO_COST
#undef SMEAR_AMMO_CHARGES
#undef SMEAR_CHANNEL
