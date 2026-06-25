// =====================================================================================
// 暗影穿行 / Shadow Step —— 暗影裔(Shadekin)的签名种族能力
// -------------------------------------------------------------------------------------
// 为什么要新增这个能力：源工程的 shadekin.dm 仅含外观字段，但"暗影裔"这一设定的核心即
// "在阴影间瞬移"。任务要求"每个效果都要真正执行其描述的功能"，因此把该种族的标志性能力实装为
// 一个可点击施放的瞬移技能：化作黑烟，从当前位置闪现到一片【处于阴影中】的目标地块。
// Why add this ability: the source shadekin.dm is cosmetic only, but phasing between shadows IS the
// defining shadekin power. The task requires every effect to actually execute, so the signature power
// is implemented as a clickable blink: turn to smoke and reappear on a target tile that lies in shadow.
//
// 基类选择 /obj/effect/proc_holder/spell/invoked：RT 中"点击图标后再点目标"的能力基类，
// selection_type="range" 使玩家可点选范围内任意地块；cast() 收到 targets[1] 为被点中的 atom。
// Base class /obj/effect/proc_holder/spell/invoked: RT's "click icon then click target" ability base;
// selection_type="range" lets the player click any tile in range; cast() receives targets[1] as that atom.
// =====================================================================================

/obj/effect/proc_holder/spell/invoked/shadow_step
	// name：能力按钮与提示中显示的名称。
	// name: shown on the ability button and prompts.
	name = "暗影穿行"
	// desc：能力说明，明确"只能瞬移到阴影中"的限制，便于玩家理解失败原因。
	// desc: explains the "shadow-only destination" restriction so failures make sense to the player.
	desc = "化身黑烟，瞬移到一片笼罩在阴影中的地块。强光之地无法落脚。"
	// releasedrain：施放消耗的"耐力/魔力"释放值；设为较低值，因其为轻量级位移能力。
	// releasedrain: the stamina/mana release cost on cast; kept low as this is a light mobility ability.
	releasedrain = 15
	// chargedrain：蓄力期间每 tick 的持续消耗。
	// chargedrain: per-tick drain while charging.
	chargedrain = 1
	// chargetime：蓄力时长。瞬移应当迅捷，故仅 0.5 秒。
	// chargetime: channel time. A blink should be quick, hence 0.5s.
	chargetime = 0.5 SECONDS
	// recharge_time：冷却时间，防止无限连续瞬移。
	// recharge_time: cooldown to prevent infinite chain-blinking.
	recharge_time = 8 SECONDS
	// human_req：要求施法者为人形（暗影裔是人形种族）。
	// human_req: requires a humanoid caster (shadekin are humanoid).
	human_req = TRUE
	// warnie：施放警告音/提示标识，沿用通用法术警告。
	// warnie: cast-warning identifier; reuse the generic spell warning.
	warnie = "spellwarning"
	// school：能力学派，标记为"瞬移系"。
	// school: ability school, tagged as teleportation.
	school = "transmutation"
	// spell_tier：能力强度分级，定为 1（基础种族能力）。
	// spell_tier: power tier; 1 = basic racial ability.
	spell_tier = 1
	// action_icon：按钮图标来源；复用 modular_z121 既有的自定义法术图标表，避免引入新资源。
	// action_icon: source of the button icon; reuse the existing modular custom-spell DMI to avoid new assets.
	action_icon = 'modular_z121/icon/custompell.dmi'
	// overlay_state：按钮覆盖状态，使用通用"闪现"覆盖样式。
	// overlay_state: button overlay state; use the generic "blink" overlay.
	overlay_state = "blink"
	// invocations：施放时的吟唱台词（中文主题化）。
	// invocations: the spoken invocation on cast (themed, in Chinese).
	invocations = list("循影而行……")
	// invocation_type：吟唱方式，"whisper"低语更契合暗影刺客气质。
	// invocation_type: how it's spoken; "whisper" suits a shadowy theme.
	invocation_type = "whisper"
	// glow_color/glow_intensity：施放时角色的微光颜色与强度，使用暗色奥术光。
	// glow_color/glow_intensity: caster glow on cast; use a dim arcane glow.
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	// no_early_release：禁止未蓄满即释放，避免半吟唱意外触发。
	// no_early_release: forbid casting before fully charged, preventing accidental half-channel fires.
	no_early_release = TRUE
	// range：可瞬移的最大格数；7 格是 RT 中一个屏幕半径量级的合理距离。
	// range: maximum blink distance in tiles; 7 is a sensible screen-radius distance in RT.
	range = 7
	// miracle：是否为神迹（神职奇迹）。本能力是种族先天能力，非神迹。
	// miracle: whether this is a divine miracle. This is an innate racial power, so FALSE.
	miracle = FALSE
	// sound：施放音效，使用通用瞬移音。
	// sound: cast sound; use the generic teleport/swap sound.
	sound = 'sound/magic/swap.ogg'
	// 阴影阈值：目标地块光照值(0=全暗,1=全亮)必须 < 此值才允许落脚，实现"只能瞬移进阴影"。
	// Shadow threshold: the destination tile's lumcount (0=dark..1=lit) must be below this to be valid,
	// enforcing the "only into shadow" rule.
	var/shadow_threshold = 0.5

// 为什么覆盖 cast：这里实现真正的瞬移逻辑与全部错误处理。targets[1] 是玩家点中的目标 atom。
// Why override cast: this is where the real blink logic and all error handling live. targets[1] is the
// atom the player clicked.
/obj/effect/proc_holder/spell/invoked/shadow_step/cast(list/targets, mob/living/user = usr)
	// 错误处理①：无目标（点空/越界）。回滚施放并提示。
	// Error handling (1): no target (clicked nothing / out of bounds). Revert and warn.
	if(!length(targets) || !targets[1])
		to_chat(user, span_warning("我没有锁定任何落脚之处。"))
		revert_cast()
		return FALSE

	// 取被点中目标所在地块作为目标地块（无论点中的是地块还是地块上的物体）。
	// Resolve the clicked atom to its turf as the destination (works whether a turf or an object was clicked).
	var/turf/target_turf = get_turf(targets[1])
	// 取施法者当前地块，用于距离与有效性校验。
	// The caster's current turf, used for distance and validity checks.
	var/turf/user_turf = get_turf(user)

	// 错误处理②：地块解析失败（目标或自身不在任何地块上，如处于异常容器中）。
	// Error handling (2): turf resolution failed (target or self not on any turf, e.g. in an odd container).
	if(!isturf(target_turf) || !isturf(user_turf))
		to_chat(user, span_warning("此地的阴影太过混乱，无法穿行。"))
		revert_cast()
		return FALSE

	// 错误处理③：超出射程。invoked 基类通常已限制点选范围，这里再次校验以防绕过。
	// Error handling (3): out of range. The invoked base usually limits selection, re-check to be safe.
	if(get_dist(user_turf, target_turf) > range)
		to_chat(user, span_warning("那片阴影太遥远了，我无法企及。"))
		revert_cast()
		return FALSE

	// 错误处理④：目标地块为实心（墙/封闭地块），无法落脚，否则会卡进墙体。
	// Error handling (4): destination is dense (a wall/solid tile); can't land there or we'd clip into it.
	if(target_turf.density)
		to_chat(user, span_warning("我无法穿行到坚实的障碍物之中。"))
		revert_cast()
		return FALSE

	// 错误处理⑤：目标地块被标记为禁止瞬移（地图/事件保护区）。
	// Error handling (5): destination is flagged as teleport-restricted (map/event protected area).
	if(target_turf.teleport_restricted)
		to_chat(user, span_warning("一股力量阻止我闪现到那里。"))
		revert_cast()
		return FALSE

	// 错误处理⑥：核心机制——目标必须处于阴影中。光照过亮则拒绝，体现"暗影裔只能遁入阴影"。
	// Error handling (6): core mechanic — destination must be in shadow. Reject if too brightly lit.
	if(target_turf.get_lumcount() >= shadow_threshold)
		to_chat(user, span_warning("那里光线太亮，没有足够的阴影供我藏身。"))
		revert_cast()
		return FALSE

	// 错误处理⑦：反魔法检查。若施法者受反魔法压制则瞬移失败（do 'self' 检查自身携带的反魔法）。
	// Error handling (7): anti-magic check. If the caster is suppressed by anti-magic, the blink fails.
	if(user.anti_magic_check(magic = TRUE, self = TRUE))
		to_chat(user, span_warning("一股反魔法的力量扼住了我的暗影之力。"))
		revert_cast()
		return FALSE

	// 若施法者被固定（绑在床/椅等），先解除固定再瞬移，避免位移异常。
	// If the caster is buckled (to a bed/chair etc.), unbuckle before teleporting to avoid movement bugs.
	if(user.buckled)
		user.buckled.unbuckle_mob(user, TRUE)

	// 在出发地块生成"消散"特效，并播放音效——表现化为黑烟离开。
	// Spawn a "vanish" visual at the origin and play the sound — the caster dissolves into smoke.
	new /obj/effect/temp_visual/wizard/out(user_turf)
	playsound(user_turf, sound, 50, TRUE)

	// 执行真正的瞬移：走 RT 的 do_teleport 标准管线（带魔法频道，便于被反瞬移/反魔法系统拦截）。
	// 若失败（被某系统拦截）则回滚并提示，确保不会"消耗冷却却没动"。
	// Perform the actual teleport via RT's do_teleport pipeline (magic channel, so anti-teleport systems
	// can intercept). If it fails, revert and warn so the cooldown isn't wasted on a no-op.
	if(!do_teleport(user, target_turf, forceMove = TRUE, channel = TELEPORT_CHANNEL_MAGIC))
		to_chat(user, span_warning("暗影穿行失败了，某种力量将我挡了回来。"))
		revert_cast()
		return FALSE

	// 在落脚地块生成"现身"特效并再次播放音效——表现自阴影中重新凝聚。
	// Spawn a "reappear" visual at the destination and play the sound — the caster reforms from shadow.
	new /obj/effect/temp_visual/wizard(target_turf)
	playsound(target_turf, sound, 50, TRUE)

	// 给出旁观与自身的反馈文本，强化"鬼魅般闪现"的观感。
	// Provide onlooker and self feedback text to sell the ghostly-blink effect.
	user.visible_message(
		span_warning("[user] 的身形骤然化作一缕黑烟，转瞬间消失，又在不远处的阴影中重新凝聚！"),
		span_notice("我循着阴影的脉络穿行，于幽暗之间重现身形。"),
	)
	// 返回 TRUE 表示施放成功，由基类据此进入冷却。
	// Return TRUE to mark a successful cast so the base class starts the cooldown.
	return TRUE
