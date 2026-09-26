# Prints every write to blood_volume that bypasses set_blood_volume()/adjust_blood_volume().
# Allowed: a type-level default (one tab under a type path) and the body of set_blood_volume() itself.

BEGIN {
	write_re = "(^|[^_a-zA-Z0-9])blood_volume[ \t]*(([-+*/%|&^]|[|][|]|&&|<<|>>)?=([^=]|$)|[+][+]|--)"
	increment_re = "([+][+]|--)[ \t]*([_a-zA-Z0-9]+[.])*blood_volume([^_a-zA-Z0-9]|$)"
	vars_re = "vars[[][^]]*blood_volume[^]]*[]][ \t]*=([^=]|$)"
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

function is_write(code, raw) {
	return code ~ write_re || code ~ increment_re || (index(code, "vars[") && raw ~ vars_re)
}

FNR == 1 {
	in_comment = 0
	in_proc = 0
	in_setter = 0
	in_macro = 0
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
	if (!in_comment && !col0 && !macro_line && !index(raw, "/*") && !index(raw, "blood_volume"))
		next
	code = strip(raw)
	if (macro_line) {
		if (is_write(code, raw))
			printf("%s:%d: %s\n", FILENAME, FNR, raw)
		next
	}
	if (col0) {
		if (code ~ /^[ \t]*$/)
			next
		in_proc = index(code, "(") > 0
		in_setter = in_proc && index(code, "/set_blood_volume(") > 0
		next
	}
	if (!is_write(code, raw) || in_setter)
		next
	if (!in_proc && raw ~ /^\t[^\t]/)
		next
	printf("%s:%d: %s\n", FILENAME, FNR, raw)
}
