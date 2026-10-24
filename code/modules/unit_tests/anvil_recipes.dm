/// Every craftable anvil recipe needs a name, a product, a bar and a positive yield
/datum/unit_test/anvil_recipe_validity

/datum/unit_test/anvil_recipe_validity/Run()
	for(var/recipe_path in subtypesof(/datum/anvil_recipe))
		if(IS_ABSTRACT(recipe_path))
			continue
		var/datum/anvil_recipe/recipe = allocate(recipe_path)
		if(!length(recipe.name))
			TEST_FAIL("[recipe_path] has no name. If it is a parent type, set abstract_type = [recipe_path]")
		if(!recipe.created_item)
			TEST_FAIL("[recipe_path] has no created_item")
		if(!ispath(recipe.req_bar))
			TEST_FAIL("[recipe_path] has no valid req_bar")
		if(recipe.createditem_num < 1)
			TEST_FAIL("[recipe_path] has createditem_num [recipe.createditem_num]")
