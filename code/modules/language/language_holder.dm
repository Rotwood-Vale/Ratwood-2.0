/datum/language_holder
	/// Assoc list of language path -> list of sources that granted it. Subtypes declare a plain list of paths.
	var/list/languages = list(/datum/language/common)
	/// As languages, but only speakable while the holder is a body's holder rather than a mind's.
	var/list/shadow_languages = list()
	var/only_speaks_language = null
	var/selected_default_language = null
	var/datum/language_menu/language_menu

	var/omnitongue = FALSE
	var/owner

/datum/language_holder/New(owner)
	src.owner = owner

	languages = build_language_cache(languages)
	shadow_languages = build_language_cache(shadow_languages)

/// typecacheof() with source lists for values, so is_type_in_typecache() still reads them as truthy.
/datum/language_holder/proc/build_language_cache(list/paths)
	var/list/cache = typecacheof(paths)
	for(var/language_path in cache)
		cache[language_path] = list(LANGUAGE_SOURCE_INNATE)
	return cache

/// Deep copies a language cache so the copy does not share source lists with the original.
/datum/language_holder/proc/copy_language_cache(list/cache)
	var/list/copied = list()
	for(var/language_path in cache)
		var/list/sources = cache[language_path]
		copied[language_path] = sources.Copy()
	return copied

/// Languages may be passed as a name string rather than a path. Normalise to a path.
/datum/language_holder/proc/resolve_language(datum/language/dt)
	if(!length(GLOB.all_languages) || !isnull(GLOB.language_datum_instances[dt]))
		return dt
	var/language_name = replacetext("[dt]", "/datum/language/", "")
	for(var/datum/language/candidate as anything in GLOB.all_languages)
		if(language_name == LOWER_TEXT(initial(candidate.name)))
			return candidate
	return dt

/datum/language_holder/Destroy()
	owner = null
	QDEL_NULL(language_menu)
	languages.Cut()
	shadow_languages.Cut()
	return ..()

/datum/language_holder/proc/copy(newowner)
	var/datum/language_holder/copy = new(newowner)
	copy.languages = copy_language_cache(src.languages)
	// shadow languages are not copied.
	copy.only_speaks_language = src.only_speaks_language
	copy.selected_default_language = src.selected_default_language
	// language menu is not copied, that's tied to the holder.
	copy.omnitongue = src.omnitongue
	return copy

/// Adds source to the language's source list, granting it if this is the first source.
/datum/language_holder/proc/grant_language(datum/language/dt, shadow = FALSE, source = LANGUAGE_SOURCE_GENERIC)
	dt = resolve_language(dt)
	if(!dt)
		return FALSE
	var/list/cache = shadow ? shadow_languages : languages
	var/list/sources = cache[dt]
	if(!sources)
		cache[dt] = list(source)
		return TRUE
	if(source in sources)
		return FALSE
	sources += source
	return TRUE

/datum/language_holder/proc/grant_all_languages(omnitongue = FALSE, source = LANGUAGE_SOURCE_GENERIC)
	for(var/la in GLOB.all_languages)
		grant_language(la, source = source)

	if(omnitongue)
		src.omnitongue = TRUE

/datum/language_holder/proc/get_random_understood_language()
	var/list/possible = list()
	for(var/dt in languages)
		possible += dt
	. = safepick(possible)

/// Drops source from the language's source list, forgetting it only once no source is left.
/// Pass LANGUAGE_SOURCE_ALL to forget it regardless of who granted it.
/datum/language_holder/proc/remove_language(datum/language/dt, shadow = FALSE, source = LANGUAGE_SOURCE_GENERIC)
	dt = resolve_language(dt)
	var/list/cache = shadow ? shadow_languages : languages
	var/list/sources = cache[dt]
	if(!sources)
		return FALSE
	if(source != LANGUAGE_SOURCE_ALL)
		sources -= source
		if(length(sources))
			return FALSE
	cache -= dt
	if(!shadow && selected_default_language == dt)
		selected_default_language = null
	return TRUE

/datum/language_holder/proc/remove_all_languages(source = LANGUAGE_SOURCE_ALL, shadow = FALSE)
	if(source == LANGUAGE_SOURCE_ALL)
		if(shadow)
			shadow_languages.Cut()
		else
			languages.Cut()
			selected_default_language = null
		return
	var/list/cache = shadow ? shadow_languages : languages
	for(var/language_path in cache.Copy())
		remove_language(language_path, shadow, source)

/datum/language_holder/proc/has_language(datum/language/dt)
	if(is_type_in_typecache(dt, languages))
		return LANGUAGE_KNOWN
	else
		var/atom/movable/AM = get_atom()
		var/datum/language_holder/L = AM.get_language_holder(shadow=FALSE)
		if(L != src)
			if(is_type_in_typecache(dt, L.shadow_languages))
				return LANGUAGE_SHADOWED
	return FALSE

/datum/language_holder/proc/copy_known_languages_from(thing, replace=FALSE)
	var/datum/language_holder/other
	if(istype(thing, /datum/language_holder))
		other = thing
	else if(ismovableatom(thing))
		var/atom/movable/AM = thing
		other = AM.get_language_holder()
	else if(istype(thing, /datum/mind))
		var/datum/mind/M = thing
		other = M.get_language_holder()

	if(replace)
		src.remove_all_languages()

	for(var/language_path in other.languages)
		for(var/source in other.languages[language_path])
			src.grant_language(language_path, source = source)


/datum/language_holder/proc/open_language_menu(mob/user)
	if(!language_menu)
		language_menu = new(src)
	language_menu.ui_interact(user)

/datum/language_holder/proc/get_atom()
	if(ismovableatom(owner))
		. = owner
	else if(istype(owner, /datum/mind))
		var/datum/mind/M = owner
		if(M.current)
			. = M.current

/datum/language_holder/alien
	languages = list(/datum/language/xenocommon)

/datum/language_holder/swarmer
	languages = list(/datum/language/swarmer)

/datum/language_holder/construct
	languages = list(/datum/language/common, /datum/language/narsie)

/datum/language_holder/drone
	languages = list(/datum/language/common, /datum/language/drone, /datum/language/machine)
	only_speaks_language = /datum/language/drone

/datum/language_holder/drone/syndicate
	only_speaks_language = null

/datum/language_holder/slime
	languages = list(/datum/language/common, /datum/language/slime)
	only_speaks_language = /datum/language/slime

/datum/language_holder/lightbringer
	// TODO change to a lightbringer specific sign language
	languages = list(/datum/language/slime)

/datum/language_holder/synthetic
	languages = list(/datum/language/common)
	shadow_languages = list(/datum/language/common, /datum/language/machine, /datum/language/draconic)

/datum/language_holder/empty
	languages = list()
	shadow_languages = list()

/datum/language_holder/universal/New()
	..()
	grant_all_languages(omnitongue=TRUE)

/datum/language_holder/abyssal
	languages = list(/datum/language/hellspeak)
