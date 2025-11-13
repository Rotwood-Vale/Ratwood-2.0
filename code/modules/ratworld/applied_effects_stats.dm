// Ratworld: Clickable Stats panel entry to show applied effects (enchants + statuses)

// Per-mob handle for the clickable stat line
/mob/living
    var/obj/effect/statclick/applied_effects/rw_applied_effects_click

// Clickable stat object that opens the Applied Effects window
/obj/effect/statclick/applied_effects
    name = "Applied Effects"
    var/mob/living/owner

/obj/effect/statclick/applied_effects/Initialize(mapload, mob/living/owner)
    . = ..()
    src.owner = owner
    if(isdatum(owner))
        RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(on_owner_qdel))

/obj/effect/statclick/applied_effects/Destroy()
    owner = null
    return ..()

/obj/effect/statclick/applied_effects/Click()
    if(!usr || !istype(usr, /mob/living))
        return
    var/mob/living/L = owner ? owner : usr
    // Build HTML once per click
    var/html = L.rw_build_applied_effects_html()
    var/win_id = "AppliedEffects:[REF(L)]"
    var/enc_win = url_encode(win_id)
    usr << browse(html, "window=[enc_win];size=500x650")

// Build HTML contents for the Applied Effects window
/mob/living/proc/rw_build_applied_effects_html()
    var/list/lines = list()
    lines += "<h2>Applied Effects</h2>"

    // Section: Gear enchantments currently applying to you
    var/list/agg_by_cat = list() // cat -> list of html lines
    var/list/totals = list() // id -> list(name, total, percent)

    // Iterate items that are currently applying wearer effects to us
    for(var/obj/item/I as anything in contents)
        if(!I) continue
        if(I.vars && ("rw_discovered" in I.vars) && !I.vars["rw_discovered"]) continue
        if(!islist(I.vars?["rw_enchants"]))
            continue
        // Only include items whose effects are currently applied to this mob
        if(I.rw_effects_owner && I.rw_effects_owner != src)
            continue
        var/list/ids = I.vars["rw_enchants"]
        var/list/vals = islist(I.vars?["rw_enchant_vals"]) ? I.vars["rw_enchant_vals"] : null
        var/slot_key = ratworld_slot_key_for_item(I)
        for(var/id in ids)
            if(!istext(id))
                continue
            var/list/def = ratworld_get_enchant_def(id)
            var/name = id
            var/cat = "OTHER"
            if(islist(def))
                if(def["name"]) name = def["name"]
                if(def["category"]) cat = def["category"]
            var/value = (vals && !isnull(vals[id])) ? vals[id] : null
            var/is_percent = FALSE
            if(istext(slot_key))
                var/list/rng = ratworld_get_enchant_slot_range(id, slot_key)
                if(islist(rng) && rng["percent"])
                    is_percent = TRUE
            // Aggregate totals
            if(!isnull(value))
                if(!islist(totals[id]))
                    totals[id] = list("name" = name, "total" = 0, "percent" = is_percent)
                totals[id]["total"] += value
            // Per-source line
            var/sign = (isnum(value) && value >= 0) ? "+" : ""
            var/vsuffix = is_percent ? "%" : ""
            var/valtxt = isnull(value) ? "" : " [sign][value][vsuffix]"
            var/item_name = I.name
            var/line = "- [name][valtxt] <i>([item_name])</i>"
            if(!islist(agg_by_cat[cat]))
                agg_by_cat[cat] = list()
            agg_by_cat[cat] += line

    if(length(agg_by_cat))
        lines += "<h3>Gear Enchantments</h3>"
        // Print totals first
        if(length(totals))
            lines += "<b>Totals</b><br>"
            for(var/id in totals)
                var/list/T = totals[id]
                var/tname = T["name"]
                var/tval = T["total"]
                var/tperc = T["percent"]
                var/tsign = (isnum(tval) && tval >= 0) ? "+" : ""
                var/tsuffix = tperc ? "%" : ""
                lines += "&bull; [tname]: [tsign][tval][tsuffix]"
        // Then per-category breakdown
        for(var/cat in agg_by_cat)
            lines += "<br><b>[cat]</b>"
            for(var/line in agg_by_cat[cat])
                lines += line
    else
        lines += "<i>No gear-based effects currently applied.</i>"

    // Divider
    lines += "<hr>"

    // Section: Aggregated bonuses (from currently applied gear)
    lines += "<h3>Aggregated Bonuses</h3>"
    var/as_total = isnum(vars?["rw_action_speed_pct_total"]) ? round(vars["rw_action_speed_pct_total"], 0.1) : 0
    var/cs_total = isnum(vars?["rw_cast_speed_pct_total"]) ? round(vars["rw_cast_speed_pct_total"], 0.1) : 0
    var/cdr_pct = isnum(vars?["rw_cdr_pct_total"]) ? round(vars["rw_cdr_pct_total"], 0.1) : 0
    var/mdef_pct = isnum(vars?["rw_magic_def_pct_total"]) ? round(vars["rw_magic_def_pct_total"], 0.1) : 0
    var/luck_pct = isnum(vars?["rw_luck_pct_total"]) ? round(vars["rw_luck_pct_total"], 0.1) : 0
    var/heal_add = isnum(vars?["rw_outgoing_heal_add_total"]) ? round(vars["rw_outgoing_heal_add_total"], 0.1) : 0
    var/list/agg_lines = list()
    if(as_total)
        var/as_sign = (as_total >= 0) ? "+" : ""
        agg_lines += "Action Speed: [as_sign][as_total]%"
    if(cs_total)
        var/cs_sign = (cs_total >= 0) ? "+" : ""
        agg_lines += "Cast Speed: [cs_sign][cs_total]%"
    if(cdr_pct)
        var/cdr_sign = (cdr_pct >= 0) ? "+" : ""
        agg_lines += "Cooldown Reduction: [cdr_sign][cdr_pct]%"
    if(mdef_pct)
        var/mdef_sign = (mdef_pct >= 0) ? "+" : ""
        agg_lines += "Magical Defense: [mdef_sign][mdef_pct]%"
    if(luck_pct)
        var/luck_sign = (luck_pct >= 0) ? "+" : ""
        agg_lines += "Luck: [luck_sign][luck_pct]%"
    if(heal_add)
        var/heal_sign = (heal_add >= 0) ? "+" : ""
        agg_lines += "Outgoing Heal Add: [heal_sign][heal_add]"
    if(agg_lines.len)
        for(var/LN in agg_lines)
            lines += "&bull; [LN]"
    else
        lines += "<i>No active aggregated bonuses.</i>"

    // Section: Status Effects on the mob
    lines += "<h3>Status Effects</h3>"
    if(status_effects && status_effects.len)
        for(var/datum/status_effect/S as anything in status_effects)
            var/ename = S.linked_alert? S.linked_alert.name : "[S.type]"
            var/edesc = S.linked_alert? S.linked_alert.desc : S.examine_text
            var/timeleft = "permanent"
            if(isnum(S.duration) && S.duration != -1)
                var/decis = max(S.duration - world.time, 0)
                timeleft = "[round(decis/10, 0.1)]s remaining"
            lines += "<b>[ename]</b> <span style='color:#888'>([timeleft])</span>"
            if(edesc)
                lines += "<div style='margin-left:10px;color:#bbb'>[edesc]</div>"
            // Show stat modifiers, if any
            if(islist(S.effectedstats) && S.effectedstats.len)
                for(var/K in S.effectedstats)
                    var/V = S.effectedstats[K]
                    var/color = V >= 0 ? "#9fdc9f" : "#ff9f9f"
                    var/absV = V >= 0 ? V : -V
                    var/sym = V >= 0 ? "+" : "-"
                    lines += "<div style='margin-left:10px;color:[color]'>[K]: [sym][absV]</div>"
    else
        lines += "<i>No active status effects.</i>"

    // Render as a simple scrollable page
    var/html = "<html><head><title>Applied Effects</title></head><body style='font-family:Verdana,Arial,Helvetica,sans-serif;font-size:12px;color:#ddd;background:#151515'>[lines.Join("<br>")]</body></html>"
    return html

// Cleanup helper when the owner is deleted
/obj/effect/statclick/applied_effects/proc/on_owner_qdel()
    qdel(src)
