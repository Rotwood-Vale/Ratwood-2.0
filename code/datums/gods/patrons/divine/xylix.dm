/datum/patron/divine/xylix
	name = "赛利克斯"
	domain = "诡计、自由、灵感、命运、弗卢维安人"
	desc = "戏弄者是万神殿中最为神秘莫测的一位。祂创造了弗卢维安一族，并赐予他们命运的馈赠；祂存在的唯一目的，就是拿诸神与凡人一并开涮。祂的追随者将自由视作绝对，并憎恶奴役。"
	worshippers = "赌徒、吟游诗人、艺术家、巧舌之人、弗卢维安人"
	virtues = "幽默、友谊、欢乐"
	sins = "奴役、严肃、奴性"
	mob_traits = list(TRAIT_XYLIX)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison				= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/xylixslip					= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/ventriloquism				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/xylixlian_luck        	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 				= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle 	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle 	= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/mockery					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal				= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/mimicry					= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/mastersillusion			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/slick_trick_small/miracle	= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/slick_trick/miracle		= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/abscond					= CLERIC_T4,
					/obj/effect/proc_holder/spell/invoked/wound_heal				= CLERIC_T4,
	)
	traits_tier = list(TRAIT_XYLIX_DEVOTEE = CLERIC_T0) //Requires a minimal holy skill or the 'Devotee' virtue to unlock. Rerolls luck events
	confess_lines = list(
		"阿斯特拉塔即是我的光！",
		"诺克即是黑夜！",
		"登多尔赐予一切！",
		"阿比索尔统御浪涛！",
		"拉沃克斯即是正义！",
		"众魂终将归于内克拉！",
		"呵呵呵呵！啊哈哈哈！哈哈哈哈！",
		"佩斯特拉抚慰一切病苦！",
		"玛勒姆是我的灵感之源！",
		"伊欧拉让我们相聚！",
		"齐坐万岁！",
		"格拉加尔就是我所崇拜的凶兽！",
		"马西奥斯是我的主！",
		"巴奥莎是我的欢愉！",
		"斥退异端者 - 普赛顿 依然长存！",
	)
	storyteller = /datum/storyteller/xylix

// Near a gambling machine, cross, or within the church
/datum/patron/divine/xylix/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer near psycross
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("那座被亵渎的普赛圣十字打断了我的祈祷！"))
			return FALSE
		return TRUE
	// Allows prayer in the church
	if(istype(get_area(follower), /area/rogue/indoors/town/church))
		return TRUE
	// Allows prayer near gambling machines.
	for(var/obj/structure/roguemachine/lottery_roguetown/L in view(4, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("若想让赛利克斯听见我的祈祷，我必须在教堂内、普赛圣十字附近，或在那台受大弄臣祝福的命运机器旁祈祷……"))
	return FALSE

/datum/patron/divine/xylix/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("一阵恍惚似乎短暂掠过了 [target]！")
	*message_self = span_notice("我的伤口仿佛从未存在过般消失了！ ")

	if(prob(20))
		*conditional_buff = TRUE
		*situational_bonus = -1.25
		*message_out = span_warning("赛利克斯扭曲了 [target] 的命运，使治疗效果比平时更差！")
		*message_self = span_warning("赛利克斯扭曲了你的命运，使治疗效果比平时更差！")
	else if(prob(60))
		*conditional_buff = TRUE
		*situational_bonus = rand(1, 2.5)
		*message_out = span_notice("赛利克斯带来了好运，让 [target] 获得了比平时更多的治疗！")
		*message_self = span_notice("赛利克斯带来了好运，让你获得了比平时更多的治疗！")
