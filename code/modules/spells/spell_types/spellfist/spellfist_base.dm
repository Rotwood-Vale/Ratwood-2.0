/obj/effect/proc_holder/spell/invoked/spellfist
	var/momentum_cost = 3
	var/spell_color = "#FFFFFF"

/proc/psydon_strike(mob/living/user, mob/living/target, damage, def_zone, attack_flag = "blunt")
    if(QDELETED(user) || QDELETED(target))
        return FALSE
    if(target.anti_magic_check())
        target.visible_message(span_warning("The arcyne force dissipates against [target]!"))
        playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
        return FALSE
    if(!def_zone)
        def_zone = user.zone_selected || BODY_ZONE_CHEST
    var/armor_block = target.run_armor_check(def_zone, attack_flag, damage = damage)
    target.apply_damage(damage, BRUTE, def_zone, armor_block)
    return TRUE

/obj/effect/proc_holder/spell/invoked/spellfist/proc/try_empower(mob/living/user)
    var/datum/status_effect/buff/arcyne_momentum/momentum = user.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
    if(!momentum || momentum.stacks < momentum_cost)
        return FALSE
    momentum.consume_stacks(momentum_cost)
    to_chat(user, span_notice("[momentum_cost] momentum released - empowered strike!"))
    return TRUE
