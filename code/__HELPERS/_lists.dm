/*
 * Holds procs to help with list operations
 * Contains groups:
 *			Misc
 *			Sorting
 */

/*
 * Misc
 */

#define LAZYINITLIST(L) if (!L) L = list()
#define UNSETEMPTY(L) if (L && !length(L)) L = null
#define ASSOC_UNSETEMPTY(L, K) if (!length(L[K])) L -= K;
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = list(); } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
///This is used to add onto lazy assoc list when the value you're adding is a /list/. This one has extra safety over lazyaddassoc because the value could be null (and thus cant be used to += objects)
///Accesses an associative list, returns null if nothing is found
#define LAZYACCESSASSOC(L, I, K) L ? L[I] ? L[I][K] ? L[I][K] : null : null : null
#define LAZYADDASSOCLIST(L, K, V) if(!L) { L = list(); } L[K] += list(V);
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
#define LAZYFIND(L, V) L ? L.Find(V) : 0
#define LAZYISIN(L, V) L ? (V in L) : FALSE
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
#define LAZYLEN(L) length(L)
#define LAZYCLEARLIST(L) if(L) L.Cut()
#define LAZYNULL(L) L = null
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
#define reverseList(L) reverseRange(L.Copy())

/// Passed into BINARY_INSERT to compare keys
#define COMPARE_KEY __BIN_LIST[__BIN_MID]
/// Passed into BINARY_INSERT to compare values
#define COMPARE_VALUE __BIN_LIST[__BIN_LIST[__BIN_MID]]

/****
	* Binary search sorted insert
	* INPUT: Object to be inserted
	* LIST: List to insert object into
	* TYPECONT: The typepath of the contents of the list
	* COMPARE: The object to compare against, usualy the same as INPUT
	* COMPARISON: The variable on the objects to compare
	* COMPTYPE: How should the values be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			var ##TYPECONT/__BIN_ITEM;\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(__BIN_ITEM.##COMPARISON <= COMPARE.##COMPARISON) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = __BIN_ITEM.##COMPARISON > COMPARE.##COMPARISON ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

#define SORT_FIRST_INDEX(list) (list[1])
#define SORT_COMPARE_DIRECTLY(thing) (thing)
#define SORT_VAR_NO_TYPE(varname) var/varname
/****
	* Even more custom binary search sorted insert, using defines instead of vars
	* INPUT: Item to be inserted
	* LIST: List to insert INPUT into
	* TYPECONT: A define setting the var to the typepath of the contents of the list
	* COMPARE: The item to compare against, usualy the same as INPUT
	* COMPARISON: A define that takes an item to compare as input, and returns their comparable value
	* COMPTYPE: How should the list be compared? Either COMPARE_KEY or COMPARE_VALUE.
	*/
#define BINARY_INSERT_DEFINE(INPUT, LIST, TYPECONT, COMPARE, COMPARISON, COMPTYPE) \
	do {\
		var/list/__BIN_LIST = LIST;\
		var/__BIN_CTTL = length(__BIN_LIST);\
		if(!__BIN_CTTL) {\
			__BIN_LIST += INPUT;\
		} else {\
			var/__BIN_LEFT = 1;\
			var/__BIN_RIGHT = __BIN_CTTL;\
			var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			##TYPECONT(__BIN_ITEM);\
			while(__BIN_LEFT < __BIN_RIGHT) {\
				__BIN_ITEM = COMPTYPE;\
				if(##COMPARISON(__BIN_ITEM) <= ##COMPARISON(COMPARE)) {\
					__BIN_LEFT = __BIN_MID + 1;\
				} else {\
					__BIN_RIGHT = __BIN_MID;\
				};\
				__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
			};\
			__BIN_ITEM = COMPTYPE;\
			__BIN_MID = ##COMPARISON(__BIN_ITEM) > ##COMPARISON(COMPARE) ? __BIN_MID : __BIN_MID + 1;\
			__BIN_LIST.Insert(__BIN_MID, INPUT);\
		};\
	} while(FALSE)

//Returns a list in plain english as a string
/proc/english_list(list/input, nothing_text = "nothing", and_text = " and ", comma_text = ", ", final_comma_text = "" )
	var/total = length(input)
	switch(total)
		if (0)
			return "[nothing_text]"
		if (1)
			return "[input[1]]"
		if (2)
			return "[input[1]][and_text][input[2]]"
		else
			var/output = ""
			var/index = 1
			while (index < total)
				if (index == total - 1)
					comma_text = final_comma_text

				output += "[input[index]][comma_text]"
				index++

			return "[output][and_text][input[index]]"

//Returns list element or null. Should prevent "index out of bounds" error.
/proc/listgetindex(list/L, index)
	if(LAZYLEN(L))
		if(isnum(index) && ISINTEGER(index))
			if(ISINRANGE(index,1,L.len))
				return L[index]
		else if(index in L)
			return L[index]
	return

//Return either pick(list) or null if list is not of type /list or is empty
/proc/safepick(list/L)
	if(LAZYLEN(L))
		return pick(L)

//Checks if the list is empty
/proc/isemptylist(list/L)
	if(!L.len)
		return TRUE
	return FALSE

//Checks for specific types in a list
/proc/is_type_in_list(atom/A, list/L)
	if(!LAZYLEN(L) || !A)
		return FALSE
	for(var/type in L)
		if(istype(A, type))
			return TRUE
	return FALSE

//Checks for specific types in specifically structured (Assoc "type" = TRUE) lists ('typecaches')
#define is_type_in_typecache(A, L) (A && length(L) && L[(ispath(A) ? A : A:type)])

//Checks for a string in a list
/proc/is_string_in_list(string, list/L)
	if(!LAZYLEN(L) || !string)
		return
	for(var/V in L)
		if(string == V)
			return TRUE
	return

//Removes a string from a list
/proc/remove_strings_from_list(string, list/L)
	if(!LAZYLEN(L) || !string)
		return
	for(var/V in L)
		if(V == string)
			L -= V //No return here so that it removes all strings of that type
	return

//returns a new list with only atoms that are in typecache L
/proc/typecache_filter_list(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if (typecache[A.type])
			. += A

/proc/typecache_filter_list_reverse(list/atoms, list/typecache)
	RETURN_TYPE(/list)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(!typecache[A.type])
			. += A

/proc/typecache_filter_multi_list_exclusion(list/atoms, list/typecache_include, list/typecache_exclude)
	. = list()
	for(var/thing in atoms)
		var/atom/A = thing
		if(typecache_include[A.type] && !typecache_exclude[A.type])
			. += A

//Like typesof() or subtypesof(), but returns a typecache instead of a list
/proc/typecacheof(path, ignore_root_path, only_root_path = FALSE)
	if(ispath(path))
		var/list/types = list()
		if(only_root_path)
			types = list(path)
		else
			types = ignore_root_path ? subtypesof(path) : typesof(path)
		var/list/L = list()
		for(var/T in types)
			L[T] = TRUE
		return L
	else if(islist(path))
		var/list/pathlist = path
		var/list/L = list()
		if(ignore_root_path)
			for(var/P in pathlist)
				for(var/T in subtypesof(P))
					L[T] = TRUE
		else
			for(var/P in pathlist)
				if(only_root_path)
					L[P] = TRUE
				else
					for(var/T in typesof(P))
						L[T] = TRUE
		return L

//Empties the list by setting the length to 0. Hopefully the elements get garbage collected
/proc/clearlist(list/list)
	if(istype(list))
		list.len = 0
	return

//Removes any null entries from the list
//Returns TRUE if the list had nulls, FALSE otherwise
/proc/listclearnulls(list/L)
	var/start_len = L.len
	var/list/N = new(start_len)
	L -= N
	return L.len < start_len

/*
 * Returns list containing all the entries from first list that are not present in second.
 * If skiprep = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/difflist(list/first, list/second, skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		for(var/e in first)
			if(!(e in result) && !(e in second))
				result += e
	else
		result = first - second
	return result

/*
 * Returns list containing entries that are in either list but not both.
 * If skipref = 1, repeated elements are treated as one.
 * If either of arguments is not a list, returns null
 */
/proc/uniquemergelist(list/first, list/second, skiprep=0)
	if(!islist(first) || !islist(second))
		return
	var/list/result = new
	if(skiprep)
		result = difflist(first, second, skiprep)+difflist(second, first, skiprep)
	else
		result = first ^ second
	return result

/**
 * Given a list, return a copy where values without defined weights are given weight 1.
 * For example, fill_with_ones(list(A, B=2, C)) = list(A=1, B=2, C=1)
 * Useful for weighted random choices (loot tables, syllables in languages, etc.)
 */
/proc/fill_with_ones(list/list_to_pad)
	if (!islist(list_to_pad))
		return list_to_pad

	var/list/final_list = list()

	for (var/key in list_to_pad)
		if (list_to_pad[key])
			final_list[key] = list_to_pad[key]
		else
			final_list[key] = 1

	return final_list

//Picks a random element from a list based on a weighting system:
//1. Adds up the total of weights for each element
//2. Gets a number between 1 and that total
//3. For each element in the list, subtracts its weighting from that number
//4. If that makes the number 0 or less, return that element.
/proc/pickweight(list/L)
	var/total = 0
	var/item
	for (item in L)
		if (!L[item])
			L[item] = 1
		total += L[item]

	total = rand(1, total)
	for (item in L)
		total -=L [item]
		if (total <= 0)
			return item

	return null

/proc/pickweightAllowZero(list/L) //The original pickweight proc will sometimes pick entries with zero weight.  I'm not sure if changing the original will break anything, so I left it be.
	var/total = 0
	var/item
	for (item in L)
		if (!L[item])
			L[item] = 0
		total += L[item]

	total = rand(0, total)
	for (item in L)
		total -=L [item]
		if (total <= 0 && L[item])
			return item

	return null

//Pick a random element from the list and remove it from the list.
/proc/pick_n_take(list/L)
	RETURN_TYPE(L[_].type)
	if(L.len)
		var/picked = rand(1,L.len)
		. = L[picked]
		L.Cut(picked,picked+1)			//Cut is far more efficient that Remove()

/// Fetch a random value from an associated list.
#define pick_assoc(L) L[pick(L)]

//Returns the top(last) element from the list and removes it from the list (typical stack function)
/proc/pop(list/L)
	if(L.len)
		. = L[L.len]
		L.len--

/proc/popleft(list/L)
	if(L.len)
		. = L[1]
		L.Cut(1,2)

/proc/sorted_insert(list/L, thing, comparator)
	var/pos = L.len
	while(pos > 0 && call(comparator)(thing, L[pos]) > 0)
		pos--
	L.Insert(pos+1, thing)

// Returns the next item in a list
/proc/next_list_item(item, list/L)
	var/i
	i = L.Find(item)
	if(i == L.len)
		i = 1
	else
		i++
	return L[i]

// Returns the previous item in a list
/proc/previous_list_item(item, list/L)
	var/i
	i = L.Find(item)
	if(i == 1)
		i = L.len
	else
		i--
	return L[i]

//Randomize: Return the list in a random order
/proc/shuffle(list/L)
	if(!L)
		return
	L = L.Copy()

	for(var/i=1, i<L.len, ++i)
		L.Swap(i,rand(i,L.len))

	return L

//same, but returns nothing and acts on list in place
/proc/shuffle_inplace(list/L)
	if(!L)
		return

	for(var/i=1, i<L.len, ++i)
		L.Swap(i,rand(i,L.len))

//Return a list with no duplicate entries
/proc/uniqueList(list/L)
	. = list()
	for(var/i in L)
		. |= i

//same, but returns nothing and acts on list in place (also handles associated values properly)
/proc/uniqueList_inplace(list/L)
	var/temp = L.Copy()
	L.len = 0
	for(var/key in temp)
		if (isnum(key))
			L |= key
		else
			L[key] = temp[key]

//for sorting clients or mobs by ckey
/proc/sortKey(list/L, order=1)
	return sortTim(L, order >= 0 ? /proc/cmp_ckey_asc : /proc/cmp_ckey_dsc)

//Specifically for record datums in a list.
/proc/sortRecord(list/L, field = "name", order = 1)
	GLOB.cmp_field = field
	return sortTim(L, order >= 0 ? /proc/cmp_records_asc : /proc/cmp_records_dsc)

//any value in a list
/proc/sortList(list/L, cmp=/proc/cmp_text_asc)
	return sortTim(L.Copy(), cmp)

///sort any value in a list
/proc/sort_list(list/list_to_sort, cmp=/proc/cmp_text_asc)
	return sortTim(list_to_sort.Copy(), cmp)

//uses sortList() but uses the var's name specifically. This should probably be using mergeAtom() instead
/proc/sortNames(list/L, order=1)
	return sortTim(L, order >= 0 ? /proc/cmp_name_asc : /proc/cmp_name_dsc)


//Converts a bitfield to a list of numbers (or words if a wordlist is provided)
/proc/bitfield2list(bitfield = 0, list/wordlist)
	var/list/r = list()
	if(islist(wordlist))
		var/max = min(wordlist.len,16)
		var/bit = 1
		for(var/i=1, i<=max, i++)
			if(bitfield & bit)
				r += wordlist[i]
			bit = bit << 1
	else
		for(var/bit=1, bit<=65535, bit = bit << 1)
			if(bitfield & bit)
				r += bit

	return r

// Returns the key based on the index
#define KEYBYINDEX(L, index) (((index <= length(L)) && (index > 0)) ? L[index] : null)

/proc/count_by_type(list/L, type)
	var/i = 0
	for(var/T in L)
		if(istype(T, type))
			i++
	return i

/// Returns datum/data/record
/proc/find_record(field, value, list/L)
	for(var/datum/data/record/R in L)
		if(R.fields[field] == value)
			return R
	return FALSE


//Move a single element from position fromIndex within a list, to position toIndex
//All elements in the range [1,toIndex) before the move will be before the pivot afterwards
//All elements in the range [toIndex, L.len+1) before the move will be after the pivot afterwards
//In other words, it's as if the range [fromIndex,toIndex) have been rotated using a <<< operation common to other languages.
//fromIndex and toIndex must be in the range [1,L.len+1]
//This will preserve associations ~Carnie
/proc/moveElement(list/L, fromIndex, toIndex)
	if(fromIndex == toIndex || fromIndex+1 == toIndex)	//no need to move
		return
	if(fromIndex > toIndex)
		++fromIndex	//since a null will be inserted before fromIndex, the index needs to be nudged right by one

	L.Insert(toIndex, null)
	L.Swap(fromIndex, toIndex)
	L.Cut(fromIndex, fromIndex+1)


//Move elements [fromIndex,fromIndex+len) to [toIndex-len, toIndex)
//Same as moveElement but for ranges of elements
//This will preserve associations ~Carnie
/proc/moveRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len >= distance)	//there are more elements to be moved than the distance to be moved. Therefore the same result can be achieved (with fewer operations) by moving elements between where we are and where we are going. The result being, our range we are moving is shifted left or right by dist elements
		if(fromIndex <= toIndex)
			return	//no need to move
		fromIndex += len	//we want to shift left instead of right

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(fromIndex > toIndex)
			fromIndex += len

		for(var/i=0, i<len, ++i)
			L.Insert(toIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(fromIndex, fromIndex+1)

//Move elements from [fromIndex, fromIndex+len) to [toIndex, toIndex+len)
//Move any elements being overwritten by the move to the now-empty elements, preserving order
//Note: if the two ranges overlap, only the destination order will be preserved fully, since some elements will be within both ranges ~Carnie
/proc/swapRange(list/L, fromIndex, toIndex, len=1)
	var/distance = abs(toIndex - fromIndex)
	if(len > distance)	//there is an overlap, therefore swapping each element will require more swaps than inserting new elements
		if(fromIndex < toIndex)
			toIndex += len
		else
			fromIndex += len

		for(var/i=0, i<distance, ++i)
			L.Insert(fromIndex, null)
			L.Swap(fromIndex, toIndex)
			L.Cut(toIndex, toIndex+1)
	else
		if(toIndex > fromIndex)
			var/a = toIndex
			toIndex = fromIndex
			fromIndex = a

		for(var/i=0, i<len, ++i)
			L.Swap(fromIndex++, toIndex++)

//replaces reverseList ~Carnie
/proc/reverseRange(list/L, start=1, end=0)
	if(L.len)
		start = start % L.len
		end = end % (L.len+1)
		if(start <= 0)
			start += L.len
		if(end <= 0)
			end += L.len + 1

		--end
		while(start < end)
			L.Swap(start++,end--)

	return L


//return first thing in L which has var/varname == value
//this is typecaste as list/L, but you could actually feed it an atom instead.
//completely safe to use
/proc/getElementByVar(list/L, varname, value)
	varname = "[varname]"
	for(var/datum/D in L)
		if(D.vars.Find(varname))
			if(D.vars[varname] == value)
				return D

//remove all nulls from a list
/proc/removeNullsFromList(list/L)
	while(L.Remove(null))
		continue
	return L

//Copies a list, and all lists inside it recusively
//Does not copy any other reference type
/proc/deepCopyList(list/l)
	if(!islist(l))
		return l
	. = l.Copy()
	for(var/i = 1 to l.len)
		var/key = .[i]
		if(isnum(key))
			// numbers cannot ever be associative keys
			continue
		var/value = .[key]
		if(islist(value))
			value = deepCopyList(value)
			.[key] = value
		if(islist(key))
			key = deepCopyList(key)
			.[i] = key
			.[key] = value

//takes an input_key, as text, and the list of keys already used, outputting a replacement key in the format of "[input_key] ([number_of_duplicates])" if it finds a duplicate
//use this for lists of things that might have the same name, like mobs or objects, that you plan on giving to a player as input
/proc/avoid_assoc_duplicate_keys(input_key, list/used_key_list)
	if(!input_key || !istype(used_key_list))
		return
	if(used_key_list[input_key])
		used_key_list[input_key]++
		input_key = "[input_key] ([used_key_list[input_key]])"
	else
		used_key_list[input_key] = 1
	return input_key

//Flattens a keyed list into a list of it's contents
/proc/flatten_list(list/key_list)
	if(!islist(key_list))
		return null
	. = list()
	for(var/key in key_list)
		. |= key_list[key]

/proc/make_associative(list/flat_list)
	. = list()
	for(var/thing in flat_list)
		.[thing] = TRUE

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((islist(L) && length(L)) ? pick(L) : default)

/* Definining a counter as a series of key -> numeric value entries

 * All these procs modify in place.
*/

/proc/counterlist_scale(list/L, scalar)
	var/list/out = list()
	for(var/key in L)
		out[key] = L[key] * scalar
	. = out

/proc/counterlist_sum(list/L)
	. = 0
	for(var/key in L)
		. += L[key]

/proc/counterlist_normalise(list/L)
	var/avg = counterlist_sum(L)
	if(avg != 0)
		. = counterlist_scale(L, 1 / avg)
	else
		. = L

/proc/counterlist_combine(list/L1, list/L2)
	for(var/key in L2)
		var/other_value = L2[key]
		if(key in L1)
			L1[key] += other_value
		else
			L1[key] = other_value

/proc/counterlist_ceiling(list/L)
	var/list/out = list()
	for(var/key in L)
		out[key] = ceil(L[key])
	. = out

/proc/assoc_list_strip_value(list/input)
	var/list/ret = list()
	for(var/key in input)
		ret += key
	return ret

/proc/compare_list(list/l,list/d)
	if(!islist(l) || !islist(d))
		return FALSE

	if(l.len != d.len)
		return FALSE

	for(var/i in 1 to l.len)
		if(l[i] != d[i])
			return FALSE

	return TRUE

//Scales a range (i.e 1,100) and picks an item from the list based on your passed value
//i.e in a list with length 4, a 25 in the 1-100 range will give you the 2nd item
//This assumes your ranges start with 1, I am not good at math and can't do linear scaling
/proc/scale_range_pick(min,max,value,list/L)
	if(!length(L))
		return null
	var/index = 1 + (value * (length(L) - 1)) / (max - min)
	if(index > length(L))
		index = length(L)
	return L[index]

GLOBAL_LIST_EMPTY(string_lists)

/**
 * Caches lists with non-numeric stringify-able values (text or typepath).
 */
/proc/string_list(list/values)
	var/string_id = values.Join("-")

	. = GLOB.string_lists[string_id]

	if(.)
		return

	return GLOB.string_lists[string_id] = values

// Generic listoflist safe add and removal macros:
///If value is a list, wrap it in a list so it can be used with list add/remove operations
#define LIST_VALUE_WRAP_LISTS(value) (islist(value) ? list(value) : value)
///Add an untyped item to a list, taking care to handle list items by wrapping them in a list to remove the footgun
#define UNTYPED_LIST_ADD(list, item) (list += LIST_VALUE_WRAP_LISTS(item))
///Remove an untyped item to a list, taking care to handle list items by wrapping them in a list to remove the footgun
#define UNTYPED_LIST_REMOVE(list, item) (list -= LIST_VALUE_WRAP_LISTS(item))

///Copies a list, and all lists inside it recusively
///Does not copy any other reference type
/proc/deep_copy_list(list/inserted_list)
	if(!islist(inserted_list))
		return inserted_list
	. = inserted_list.Copy()
	for(var/i in 1 to inserted_list.len)
		var/key = .[i]
		if(isnum(key))
			// numbers cannot ever be associative keys
			continue
		var/value = .[key]
		if(islist(value))
			value = deep_copy_list(value)
			.[key] = value
		if(islist(key))
			key = deep_copy_list(key)
			.[i] = key
			.[key] = value

/// A version of deep_copy_list that actually supports associative list nesting: list(list(list("a" = "b"))) will actually copy correctly.
/proc/deep_copy_list_alt(list/inserted_list)
	if(!islist(inserted_list))
		return inserted_list
	var/copied_list = inserted_list.Copy()
	. = copied_list
	for(var/key_or_value in inserted_list)
		if(isnum(key_or_value) || !inserted_list[key_or_value])
			continue
		var/value = inserted_list[key_or_value]
		var/new_value = value
		if(islist(value))
			new_value = deep_copy_list_alt(value)
		copied_list[key_or_value] = new_value

/**
 * Removes any null entries from the list
 * Returns TRUE if the list had nulls, FALSE otherwise
**/
/proc/list_clear_nulls(list/list_to_clear)
	return (list_to_clear.RemoveAll(null) > 0)

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

// Return the index using dichotomic search
/proc/FindElementIndex(atom/A, list/L, cmp)
	var/i = 1
	var/j = L.len
	var/mid

	while(i < j)
		mid = round((i+j)/2)

		if(call(cmp)(L[mid],A) < 0)
			i = mid + 1
		else
			j = mid

	if(i == 1 || i ==  L.len) // Edge cases
		return (call(cmp)(L[i],A) > 0) ? i : i+1
	else
		return i


/**
 * Picks a random element from a list based on a weighting system.
 * For example, given the following list:
 * A = 6, B = 3, C = 1, D = 0
 * A would have a 60% chance of being picked,
 * B would have a 30% chance of being picked,
 * C would have a 10% chance of being picked,
 * and D would have a 0% chance of being picked.
 * You should only pass integers in.
 */
/proc/pick_weight(list/list_to_pick)
	if(length(list_to_pick) == 0)
		return null

	var/total = 0
	for(var/item in list_to_pick)
		if(!list_to_pick[item])
			list_to_pick[item] = 0
		total += list_to_pick[item]

	total = rand(1, total)
	for(var/item in list_to_pick)
		var/item_weight = list_to_pick[item]
		if(item_weight == 0)
			continue

		total -= item_weight
		if(total <= 0)
			return item

	return null

/**
 * Like pick_weight, but allowing for nested lists.
 *
 * For example, given the following list:
 * list(A = 1, list(B = 1, C = 1))
 * A would have a 50% chance of being picked,
 * and list(B, C) would have a 50% chance of being picked.
 * If list(B, C) was picked, B and C would then each have a 50% chance of being picked.
 * So the final probabilities would be 50% for A, 25% for B, and 25% for C.
 *
 * Weights should be integers. Entries without weights are assigned weight 1 (so unweighted lists can be used as well)
 */
/proc/pick_weight_recursive(list/list_to_pick)
	var/result = pick_weight(fill_with_ones(list_to_pick))
	while(islist(result))
		result = pick_weight(fill_with_ones(result))
	return result

/**
* Like pick_weight, but decreases the value of the picked element by 1
 * For example, given the following list:
 * A = 6, B = 3, C = 1, D = 0
 * A would have a 60% chance of being picked, after which it would decrease by one and the new list would be
 * A = 5, B = 3, C = 1, D = 0
 * Tt would then have a 55.55...% to be picked, rinse and repeat
*/
/proc/pick_weight_take(list/list_to_pick)
	. = pick_weight(list_to_pick)
	list_to_pick[.]--

///Returns a list with all weakrefs resolved
/proc/recursive_list_resolve(list/list_to_resolve)
	. = list()
	for(var/element in list_to_resolve)
		if(istext(element))
			. += element
			var/possible_assoc_value = list_to_resolve[element]
			if(possible_assoc_value)
				.[element] = recursive_list_resolve_element(possible_assoc_value)
		else
			. += list(recursive_list_resolve_element(element))

///Helper for recursive_list_resolve()
/proc/recursive_list_resolve_element(element)
	if(islist(element))
		var/list/inner_list = element
		return recursive_list_resolve(inner_list)
	else if(isweakref(element))
		var/datum/weakref/ref = element
		return ref.resolve()
	else
		return element

/**
 * Intermediate step for preparing lists to be passed into the lua editor tgui.
 * Resolves weakrefs, converts some values without a standard textual representation to text,
 * and can handle self-referential lists and potential duplicate output keys.
 */
/proc/prepare_lua_editor_list(list/target_list, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	var/list/duplicate_keys = list()
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(isweakref(key))
			var/datum/weakref/ref = key
			new_key = ref.resolve() || "null weakref"
		else if(key == world)
			new_key = world.name
		else if(ref(key) == "\[0xe000001\]")
			new_key = "global"
		else if(islist(key))
			if(visited[key])
				new_key = visited[key]
			else
				new_key = prepare_lua_editor_list(key, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(isweakref(value))
			var/datum/weakref/ref = value
			value = ref.resolve() || "null weakref"
		if(value == world)
			value = "world"
		else if(ref(value) == "\[0xe000001\]")
			value = "global"
		else if(islist(value))
			if(visited[value])
				value = visited[value]
			else
				value = prepare_lua_editor_list(value, visited)
		var/list/to_add = list()
		if(!isnull(value))
			var/final_key = new_key
			while(duplicate_keys[final_key])
				duplicate_keys[new_key]++
				final_key = "[new_key] ([duplicate_keys[new_key]])"
			duplicate_keys[final_key] = 1
			to_add[final_key] = value
		else
			to_add += list(new_key)
		ret += to_add
		if(i < target_list.len)
			CHECK_TICK
	return ret

/**
 * Converts a list into a list of assoc lists of the form ("key" = key, "value" = value)
 * so that list keys that are themselves lists can be fully json-encoded
 * and that unique objects with the same string representation do not
 * produce duplicate keys that are clobbered by the standard JavaScript JSON.parse function
 */
/proc/kvpify_list(list/target_list, depth = INFINITY, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(islist(key) && depth)
			if(visited[key])
				new_key = visited[key]
			else
				new_key = kvpify_list(key, depth-1, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(islist(value) && depth)
			if(visited[value])
				value = visited[value]
			else
				value = kvpify_list(value, depth-1, visited)
		if(!isnull(value))
			ret += list(list("key" = new_key, "value" = value))
		else
			ret += list(list("key" = i, "value" = new_key))
		if(i < target_list.len)
			CHECK_TICK
	return ret

/// Compares 2 lists, returns TRUE if they are the same
/proc/deep_compare_list(list/list_1, list/list_2)
	if(list_1 == list_2)
		return TRUE

	if(!islist(list_1) || !islist(list_2))
		return FALSE

	if(list_1.len != list_2.len)
		return FALSE

	for(var/i in 1 to list_1.len)
		var/key_1 = list_1[i]
		var/key_2 = list_2[i]
		if (islist(key_1) && islist(key_2))
			if(!deep_compare_list(key_1, key_2))
				return FALSE
		else if(key_1 != key_2)
			return FALSE
		if(istext(key_1) || islist(key_1) || ispath(key_1) || isdatum(key_1) || key_1 == world)
			var/value_1 = list_1[key_1]
			var/value_2 = list_2[key_1]
			if (islist(value_1) && islist(value_2))
				if(!deep_compare_list(value_1, value_2))
					return FALSE
			else if(value_1 != value_2)
				return FALSE
	return TRUE

/// Returns a copy of the list where any element that is a datum is converted into a weakref
/proc/weakrefify_list(list/target_list, list/visited)
	if(!visited)
		visited = list()
	var/list/ret = list()
	visited[target_list] = ret
	for(var/i in 1 to target_list.len)
		var/key = target_list[i]
		var/new_key = key
		if(isdatum(key))
			new_key = WEAKREF(key)
		else if(islist(key))
			if(visited.Find(key))
				new_key = visited[key]
			else
				new_key = weakrefify_list(key, visited)
		var/value
		if(!isnull(key) && !isnum(key))
			value = target_list[key]
		if(isdatum(value))
			value = WEAKREF(value)
		else if(islist(value))
			if(visited[value])
				value = visited[value]
			else
				value = weakrefify_list(value, visited)
		var/list/to_add = list(new_key)
		if(!isnull(value))
			to_add[new_key] = value
		ret += to_add
		if(i < target_list.len)
			CHECK_TICK
	return ret

/// Runtimes if the passed in list is not sorted
/proc/assert_sorted(list/list, name, cmp = GLOBAL_PROC_REF(cmp_numeric_asc))
	var/last_value = list[1]

	for (var/index in 2 to list.len)
		var/value = list[index]

		if (call(cmp)(value, last_value) < 0)
			stack_trace("[name] is not sorted. value at [index] ([value]) is in the wrong place compared to the previous value of [last_value] (when compared to by [cmp])")

		last_value = value

/**
 * Converts a list of coordinates, or an assosciative list if passed, into a turf by calling locate(x, y, z) based on the values in the list
 */
/proc/coords2turf(list/coords)
	if("x" in coords)
		return locate(coords["x"], coords["y"], coords["z"])
	return locate(coords[1], coords[2], coords[3])

/**
 * Given a list and a list of its variant hints, appends variants that aren't explicitly required by dreamluau,
 * but are required by the lua editor tgui.
 */
/proc/add_lua_editor_variants(list/values, list/variants, list/visited, path = "")
	if(!islist(visited))
		visited = list()
		visited[values] = "\[\]"
	if(!islist(values) || !islist(variants))
		return
	if(values.len != variants.len)
		CRASH("values and variants must be the same length")
	for(var/i in 1 to variants.len)
		var/pair = variants[i]
		var/pair_modified = FALSE
		if(isnull(pair))
			pair = list("key", "value")
		var/key = values[i]
		if(islist(key))
			if(visited[key])
				pair["key"] = list("cycle", visited[key])
			else
				var/list/key_variants = pair["key"]
				var/new_path = path + "\[[i], \"key\"\],"
				visited[key] = new_path
				add_lua_editor_variants(key, key_variants, visited, new_path)
				visited -= key
				pair["key"] = list("list", key_variants)
			pair_modified = TRUE
		else if(isdatum(key) || key == world || ref(key) == "\[0xe000001\]")
			pair["key"] = list("ref", ref(key))
			pair_modified = TRUE
		var/value
		if(!isnull(key) && !isnum(key))
			value = values[key]
		if(islist(value))
			if(visited[value])
				pair["value"] = list("cycle", visited[value])
			else
				var/list/value_variants = pair["value"]
				var/new_path = path + "\[[i], \"value\"\],"
				visited[value] = new_path
				add_lua_editor_variants(value, value_variants, visited, new_path)
				visited -= value
				pair["value"] = list("list", value_variants)
			pair_modified = TRUE
		else if(isdatum(value) || value == world || ref(value) == "\[0xe000001\]")
			pair["value"] = list("ref", ref(value))
			pair_modified = TRUE
		if(pair_modified && pair != variants[i])
			variants[i] = pair
		if(i < variants.len)
			CHECK_TICK

/proc/add_lua_return_value_variants(list/values, list/variants)
	if(!islist(values) || !islist(variants))
		return
	if(values.len != variants.len)
		CRASH("values and variants must be the same length")
	for(var/i in 1 to values.len)
		var/value = values[i]
		if(islist(value))
			add_lua_editor_variants(value, variants[i])
		else if(isdatum(value) || value == world || ref(value) == "\[0xe000001\]")
			variants[i] = list("ref", ref(value))

/proc/deep_copy_without_cycles(list/values, list/visited)
	if(!islist(visited))
		visited = list()
	if(!islist(values))
		return values
	var/list/ret = list()
	var/cycle_count = 0
	visited[values] = TRUE
	for(var/i in 1 to values.len)
		var/key = values[i]
		var/out_key = key
		if(islist(key))
			if(visited[key])
				do
					out_key = "\[cyclical reference[cycle_count ? " (i)" : ""]\]"
					cycle_count++
				while(values.Find(out_key))
			else
				visited[key] = TRUE
				out_key = deep_copy_without_cycles(key, visited)
				visited -= key
		var/value
		if(!isnull(key) && !isnum(key))
			value = values[key]
		var/out_value = value
		if(islist(value))
			if(visited[value])
				out_value = "\[cyclical reference\]"
			else
				visited[value] = TRUE
				out_value = deep_copy_without_cycles(value, visited)
				visited -= value
		var/list/to_add = list(out_key)
		if(!isnull(out_value))
			to_add[out_key] = out_value
		ret += to_add
		if(i < values.len)
			CHECK_TICK
	return ret

/**
 * Given a list and a list of its variant hints, removes any list key/values that are represent lua values that could not be directly converted to DM.
 */
/proc/remove_non_dm_variants(list/return_values, list/variants, list/visited)
	if(!islist(visited))
		visited = list()
	if(!islist(return_values) || !islist(variants) || visited[return_values])
		return
	visited[return_values] = TRUE
	if(return_values.len != variants.len)
		CRASH("return_values and variants must be the same length")
	for(var/i in 1 to variants.len)
		var/pair = variants[i]
		if(!islist(variants))
			continue
		var/key = return_values[i]
		if(pair["key"])
			if(!islist(pair["key"]))
				return_values[i] = null
				continue
			remove_non_dm_variants(key, pair["key"], visited)
		if(pair["value"])
			if(!islist(pair["value"]))
				return_values[key] = null
				continue
			remove_non_dm_variants(return_values[key], pair["value"], visited)

/proc/compare_lua_logs(list/log_1, list/log_2)
	if(log_1 == log_2)
		return TRUE
	for(var/field in list("status", "name", "message", "chunk"))
		if(log_1[field] != log_2[field])
			return FALSE
	switch(log_1["status"])
		if("finished", "yield")
			return deep_compare_list(
					recursive_list_resolve(log_1["return_values"]),
					recursive_list_resolve(log_2["return_values"])
					) && deep_compare_list(log_1["variants"], log_2["variants"])
		if("runtime")
			return log_1["file"] == log_2["file"]\
				&& log_1["line"] == log_2["line"]\
				&& deep_compare_list(log_1["stack"], log_2["stack"])
		else
			return TRUE

