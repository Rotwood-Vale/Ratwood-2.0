# Prints every write to a heart HUD input that bypasses its setter.
# Allowed: a type-level default (one tab under a type path) and the body of a proc listed for that var.

BEGIN {
	rules = 0
	add_rule("blood_volume", "set_blood_volume", "set_blood_volume() / adjust_blood_volume()")
	add_rule("toxloss", "adjustToxLoss setToxLoss", "adjustToxLoss() / setToxLoss()")
	add_rule("oxyloss", "adjustOxyLoss setOxyLoss", "adjustOxyLoss() / setOxyLoss()")
	add_rule("brute_dam", "receive_damage heal_damage set_damage", "receive_damage() / heal_damage() / set_damage()")
	add_rule("burn_dam", "receive_damage heal_damage set_damage", "receive_damage() / heal_damage() / set_damage()")
	add_rule("woundpain", "set_woundpain heal_wound sew_wound upgrade", "set_woundpain()")
	add_rule("pain_mod", "adjust_pain_mod", "adjust_pain_mod()")
	names_re = ""
	for (r = 1; r <= rules; r++)
		names_re = names_re (r > 1 ? "|" : "") rule_var[r]
	names_re = "(" names_re ")"
}

function add_rule(var_name, allowed, use) {
	rules++
	rule_var[rules] = var_name
	rule_allowed[rules] = " " allowed " "
	rule_use[rules] = use
	rule_unqualified_re[rules] = "(^|[^._a-zA-Z0-9])" var_name "[ \t]*(([-+*/%|&^]|[|][|]|&&|<<|>>)?=([^=]|$)|[+][+]|--)|(^|[^._a-zA-Z0-9])([+][+]|--)[ \t]*" var_name "([^_a-zA-Z0-9]|$)"
	rule_qualified_re[rules] = "[.]" var_name "[ \t]*(([-+*/%|&^]|[|][|]|&&|<<|>>)?=([^=]|$)|[+][+]|--)|([+][+]|--)[ \t]*([_a-zA-Z0-9]+[.])+" var_name "([^_a-zA-Z0-9]|$)"
	rule_vars_re[rules] = "vars[[][^]]*" var_name "[^]]*[]][ \t]*=([^=]|$)"
	rule_local_re[rules] = "(^|[^_a-zA-Z0-9])var/([_a-zA-Z0-9]+/)*" var_name "([^_a-zA-Z0-9]|$)"
}

function strip(line,    out, i, n, c, quote) {
	out = ""
	quote = ""
	n = length(line)
	for (i = 1; i <= n; i++) {
		c = substr(line, i, 1)
		if (in_comment) {
			if (c == "*" && substr(line, i + 1, 1) == "/") {
				in_comment = 0
				i++
			}
			continue
		}
		if (quote != "") {
			if (c == "\\")
				i++
			else if (c == quote)
				quote = ""
			continue
		}
		if (c == "\"" || c == "'") {
			quote = c
			continue
		}
		if (c == "/" && substr(line, i + 1, 1) == "/")
			break
		if (c == "/" && substr(line, i + 1, 1) == "*") {
			in_comment = 1
			i++
			continue
		}
		out = out c
	}
	return out
}

function report(r) {
	printf("%s:%d: %s -> use %s: %s\n", FILENAME, FNR, rule_var[r], rule_use[r], raw)
}

function check_line(code, anywhere,    r) {
	for (r = 1; r <= rules; r++) {
		if (!index(raw, rule_var[r]))
			continue
		if (!anywhere && code ~ rule_local_re[r]) {
			local[r] = 1
			continue
		}
		if (!(code ~ rule_qualified_re[r] || ((anywhere || !local[r]) && code ~ rule_unqualified_re[r]) || (index(code, "vars[") && raw ~ rule_vars_re[r])))
			continue
		if (!anywhere && in_proc && index(rule_allowed[r], " " proc_name " "))
			continue
		if (!anywhere && !in_proc && raw ~ /^\t[^\t]/)
			continue
		report(r)
	}
}

FNR == 1 {
	in_comment = 0
	in_proc = 0
	in_macro = 0
	proc_name = ""
	split("", local)
}

{
	raw = $0
	sub(/\r$/, "", raw)
	if (in_comment && !index(raw, "*/"))
		next
	first = substr(raw, 1, 1)
	col0 = (raw != "" && first != "\t" && first != " ")
	macro_line = in_macro || (col0 && first == "#")
	in_macro = macro_line && raw ~ /\\[ \t]*$/
	if (!in_comment && !col0 && !macro_line && !index(raw, "/*") && raw !~ names_re)
		next
	code = strip(raw)
	if (macro_line) {
		check_line(code, 1)
		next
	}
	if (col0) {
		if (code ~ /^[ \t]*$/)
			next
		split("", local)
		in_proc = index(code, "(") > 0
		proc_name = ""
		if (in_proc) {
			header = code
			args = substr(header, index(header, "(") + 1)
			sub(/[(].*/, "", header)
			n = split(header, parts, "/")
			proc_name = parts[n]
			for (r = 1; r <= rules; r++)
				if (args ~ ("(^|[^_a-zA-Z0-9])" rule_var[r] "([^_a-zA-Z0-9]|$)"))
					local[r] = 1
		}
		next
	}
	if (raw ~ names_re)
		check_line(code, 0)
}
