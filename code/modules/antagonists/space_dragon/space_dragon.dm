/datum/antagonist/space_dragon
	name = "太空龙"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE

/datum/antagonist/space_dragon/greet()
	to_chat(owner, "<b>我是太空龙，曾经的太空鲤鱼，也是守护 Draco 星座秘密的存在。\n\
					就在我高举巫师的变化法杖并喊出“以 Draco 之力，我拥有力量！”的那一天，奇妙而隐秘的伟力向我揭示。\n\
					那名巫师变成了短命的 Pastry Cat，而我则成了宇宙中最强大的巨兽，太空龙。\n\
					点击一个地块就会向那个地块喷吐火焰。\n\
					使用尾扫能让那些靠得太近的家伙吃尽苦头。\n\
					攻击尸体可以将其肢解，以恢复生命值。\n\
					从那名巫师的笔记中，我得知他一直在研究这座空间站及其阶层结构。正因如此，我知道谁是这里的头领，我会杀了他们，让整座站的下属都把我视为新的领袖。</b>")
	owner.announce_objectives()
	SEND_SOUND(owner.current, sound('sound/blank.ogg'))

/datum/antagonist/space_dragon/proc/forge_objectives()
	var/current_heads = SSjob.get_all_heads()
	var/datum/objective/assassinate/killchosen = new
	killchosen.owner = owner
	var/datum/mind/selected = pick(current_heads)
	killchosen.target = selected
	killchosen.update_explanation_text()
	objectives += killchosen
	var/datum/objective/survive/survival = new
	survival.owner = owner
	objectives += survival

/datum/antagonist/space_dragon/on_gain()
	forge_objectives()
	. = ..()
