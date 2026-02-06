/obj/effect/proc_holder/spell/self/talent_trees
	name = "Open Talent Trees"
	desc = "View and learn talents"
	action_icon_state = "book1"
	sound = null

	school = "transmutation"

	overlay_state = ""

	var/mob/owner = null

/obj/effect/proc_holder/spell/self/talent_trees/learnspell
	name = "Open Spell Trees"
	desc = "View and learn spells"

/obj/effect/proc_holder/spell/self/talent_trees/Destroy()
	owner = null
	return ..()

/obj/effect/proc_holder/spell/self/talent_trees/cast(list/targets, mob/user = usr)
	. = ..()
	if(!owner && user)
		owner = user
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind)
			if(!H.mind.talent_trees)
				H.mind.talent_trees = list()

			var/list/possible_trees = list(/datum/talent_tree/arcane)
			if(get_user_evilness(H) > 0)
				possible_trees += /datum/talent_tree/necromancy

			for(var/tree_type in possible_trees)
				if(!H.mind.talent_trees[tree_type])
					H.mind.talent_trees[tree_type] = new tree_type

			var/total_spent = 0
			for(var/tree_type in possible_trees)
				var/datum/talent_tree/tree = H.mind.talent_trees[tree_type]
				if(tree)
					total_spent += tree.talent_points_spent

			H.mind.used_spell_points = total_spent

			for(var/tree_type in possible_trees)
				var/datum/talent_tree/tree = H.mind.talent_trees[tree_type]
				if(tree)
					tree.talent_points_available = H.mind.spell_points - total_spent
	open_talent_interface(owner)

/obj/effect/proc_holder/spell/self/talent_trees/proc/open_talent_interface(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return

	var/datum/talent_interface/current_interface = new(src, user)
	current_interface.show()

/obj/effect/proc_holder/spell/self/talent_trees/Topic(href, href_list)
	if(href_list["action"] == "learn_talent")
		var/talent_type = text2path(href_list["talent"])
		var/tree_type = text2path(href_list["tree"])

		if(!talent_type || !tree_type)
			return

		if(!ishuman(usr))
			return
		var/mob/living/carbon/human/H = usr
		if(!H.mind)
			return

		var/datum/talent_tree/target_tree = H.mind.talent_trees[tree_type]
		if(!target_tree)
			return

		var/list/possible_trees = list(/datum/talent_tree/arcane)
		if(get_user_evilness(H) > 0)
			possible_trees += /datum/talent_tree/necromancy

		var/total_spent = 0
		for(var/tree_type_iter in possible_trees)
			var/datum/talent_tree/tree = H.mind.talent_trees[tree_type_iter]
			if(tree)
				total_spent += tree.talent_points_spent

		target_tree.talent_points_available = H.mind.spell_points - total_spent

		var/success = target_tree.learn_talent(talent_type, usr)

		if(success && owner == usr)
			total_spent = 0
			for(var/tree_type_iter in possible_trees)
				var/datum/talent_tree/tree = H.mind.talent_trees[tree_type_iter]
				if(tree)
					total_spent += tree.talent_points_spent

			H.mind.used_spell_points = total_spent

			for(var/tree_type_iter in possible_trees)
				var/datum/talent_tree/tree = H.mind.talent_trees[tree_type_iter]
				if(tree)
					tree.talent_points_available = H.mind.spell_points - total_spent

			if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/talent_trees/learnspell))
				if((H.mind.spell_points - H.mind.used_spell_points) > 0)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/talent_trees/learnspell(null))

			if((H.mind.spell_points - H.mind.used_spell_points) <= 0)
				H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/talent_trees/learnspell)

			var/datum/talent_interface/current_interface = new(src, usr)
			current_interface.selected_tree_id = tree_type
			current_interface.show()

	else if(href_list["action"] == "select_tree")
		var/tree_type = text2path(href_list["tree"])
		if(owner == usr)
			var/datum/talent_interface/current_interface = new(src, usr)
			current_interface.selected_tree_id = tree_type
			current_interface.show()

	else if(href_list["action"] == "back")
		if(owner == usr)
			open_talent_interface(usr)

/datum/talent_interface
	var/obj/effect/proc_holder/spell/self/talent_trees/matrix
	var/datum/browser/window
	var/mob/living/user
	var/selected_tree_id = null

	var/canvas_x = 400
	var/canvas_y = 300
	var/canvas_scale = 1

/datum/talent_interface/New(obj/effect/proc_holder/spell/self/talent_trees/M, mob/U)
	matrix = M
	user = U

/datum/talent_interface/Destroy(force, ...)
	matrix = null
	user = null
	if(window)
		window.close()
		window = null
	return ..()

/datum/talent_interface/proc/show()
	if(!user || !matrix)
		return

	var/content = ""
	if(selected_tree_id)
		content = generate_tree_interface_html()
	else
		content = generate_tree_selection_html()

	window = new(user, "talent_trees", null, 800, 600)
	window.set_content(content)
	window.open()

/datum/talent_interface/proc/refresh_interface(new_x = null, new_y = null, new_scale = null)
	if(!user || !matrix)
		return

	if(new_x != null)
		canvas_x = new_x
	if(new_y != null)
		canvas_y = new_y
	if(new_scale != null)
		canvas_scale = new_scale

	show()

/datum/talent_interface/proc/generate_tree_selection_html()
	var/html = {"
	<html>
	<head>
		<style>
			body {
				background: #1a1a2e;
				color: #eee;
				font-family: Arial, sans-serif;
				padding: 20px;
			}
			.tree-selection {
				display: flex;
				flex-wrap: wrap;
				gap: 20px;
				justify-content: center;
			}
			.tree-card {
				background: linear-gradient(145deg, #16213e, #0f172a);
				border: 2px solid #3b82f6;
				border-radius: 12px;
				padding: 20px;
				width: 250px;
				cursor: pointer;
				transition: all 0.3s ease;
				text-align: center;
			}
			.tree-card:hover {
				border-color: #60a5fa;
				transform: scale(1.05);
				box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
			}
			.tree-title {
				color: #60a5fa;
				font-size: 18px;
				font-weight: bold;
				margin-bottom: 10px;
			}
			.tree-desc {
				font-size: 14px;
				color: #cbd5e1;
				margin-bottom: 15px;
			}
			.tree-progress {
				font-size: 12px;
				color: #10b981;
			}
		</style>
	</head>
	<body>
		<h2 style="text-align: center; color: #60a5fa;">Select a Talent Tree</h2>
		<div class="tree-selection">
	"}

	if(!ishuman(user))
		return html
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return html

	for(var/tree_type in H.mind.talent_trees)
		var/datum/talent_tree/tree = H.mind.talent_trees[tree_type]
		var/progress_text = "[tree.talent_points_spent] points spent, [tree.talent_points_available] available"
		html += {"
			<div class="tree-card" onclick="selectTree('[tree_type]')">
				<div class="tree-title">[tree.name]</div>
				<div class="tree-desc">[tree.desc]</div>
				<div class="tree-progress">[progress_text]</div>
			</div>
		"}

	html += {"
		</div>
		<script>
			function selectTree(treeId) {
				window.location.href = "byond://?src=[REF(matrix)];action=select_tree;tree=" + encodeURIComponent(treeId);
			}
		</script>
	</body>
	</html>
	"}

	return html

/datum/talent_interface/proc/generate_tree_interface_html()
	if(!ishuman(user))
		return ""
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return ""

	var/datum/talent_tree/selected_tree = H.mind.talent_trees[selected_tree_id]
	if(!selected_tree)
		return generate_tree_selection_html()

	user << browse_rsc('html/research_hover.png')
	user << browse_rsc('html/research_base.png')
	user << browse_rsc('html/research_known.png')
	user << browse_rsc('html/research_selected.png')
	user << browse_rsc('html/KettleParallaxBG.png')
	user << browse_rsc('html/KettleParallaxNeb.png')

	var/html = {"
	<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: 0;
				background: #000;
				color: #eee;
				font-family: Arial, sans-serif;
				overflow: hidden;
			}

			.parallax-container {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				z-index: -1;
			}

			.parallax-layer {
				position: absolute;
				width: 120%;
				height: 120%;
				background-repeat: repeat;
			}

			.parallax-bg {
				background-image: url('KettleParallaxBG.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
			}

			.parallax-stars-1 {
				background: radial-gradient(ellipse at center,
					rgba(59, 130, 246, 0.3) 0%,
					rgba(29, 78, 216, 0.2) 40%,
					transparent 70%),
					radial-gradient(circle at 20% 30%, rgba(96, 165, 250, 0.8) 1px, transparent 2px),
					radial-gradient(circle at 80% 20%, rgba(59, 130, 246, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 60% 80%, rgba(37, 99, 235, 0.4) 2px, transparent 4px);
				background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px;
				opacity: 0.8;
			}

			.parallax-stars-2 {
				background: radial-gradient(ellipse at 40% 60%,
					rgba(59, 130, 246, 0.2) 0%,
					rgba(29, 78, 216, 0.15) 30%,
					transparent 60%),
					radial-gradient(circle at 50% 70%, rgba(96, 165, 250, 0.5) 1px, transparent 2px),
					radial-gradient(circle at 30% 40%, rgba(59, 130, 246, 0.4) 1px, transparent 2px),
					radial-gradient(circle at 70% 50%, rgba(37, 99, 235, 0.3) 1.5px, transparent 3px);
				background-size: 600px 500px, 150px 120px, 250px 180px, 200px 150px;
				opacity: 0.6;
			}

			.parallax-neb {
				background-image: url('KettleParallaxNeb.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
				opacity: 0.3;
			}

			.talent-container {
				width: 100vw;
				height: 100vh;
				overflow: hidden;
				position: relative;
				cursor: grab;
			}

			.talent-container.dragging {
				cursor: grabbing;
			}

			.talent-canvas {
				position: absolute;
				width: 2000px;
				height: 2000px;
				transform-origin: 0 0;
			}

			.talent-node {
				position: absolute;
				width: 32px;
				height: 32px;
				border-radius: 50%;
				cursor: pointer;
				transition: all 0.2s ease;
				z-index: 10;
			}

			.talent-node img {
				width: 100%;
				height: 100%;
				border-radius: 50%;
			}

			.talent-node.locked {
				opacity: 0.4;
				filter: grayscale(100%);
			}

			.talent-node.available {
				opacity: 0.8;
				filter: grayscale(50%);
				box-shadow: 0 0 10px rgba(59, 130, 246, 0.5);
			}

			.talent-node.unlocked {
				opacity: 1;
				filter: none;
				box-shadow: 0 0 15px rgba(16, 185, 129, 0.7);
			}

			.talent-node:hover {
				transform: scale(1.2);
				z-index: 100;
			}

			.connection-line {
				position: absolute;
				height: 3px;
				background: rgba(59, 130, 246, 0.3);
				transform-origin: 0 50%;
				z-index: 1;
			}

			.connection-line.unlocked {
				background: rgba(16, 185, 129, 0.6);
			}

			.tooltip {
				position: fixed;
				background: rgba(15,15,30,0.95);
				border: 2px solid #3b82f6;
				border-radius: 8px;
				padding: 15px;
				max-width: 300px;
				z-index: 1000;
				pointer-events: none;
				color: #cbd5e1;
			}

			.tooltip h3 {
				margin: 0 0 10px 0;
				color: #60a5fa;
				font-size: 16px;
			}

			.tooltip p {
				margin: 5px 0;
				font-size: 13px;
			}

			.tooltip .requirements {
				color: #f87171;
				font-size: 12px;
			}

			.info-panel {
				position: fixed;
				top: 10px;
				right: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #3b82f6;
				border-radius: 8px;
				padding: 15px;
				color: #60a5fa;
				z-index: 100;
			}

			.back-button {
				position: fixed;
				top: 10px;
				left: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #3b82f6;
				border-radius: 8px;
				padding: 10px;
				color: #60a5fa;
				cursor: pointer;
				text-decoration: none;
			}

			.back-button:hover {
				background: rgba(25,25,40,0.9);
				border-color: #60a5fa;
			}
		</style>
	</head>
	<body>
		<div class="parallax-container">
			<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
			<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
			<div class="parallax-layer parallax-stars-2" id="parallax-stars-2"></div>
			<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
		</div>

		<a href="byond://?src=[REF(matrix)];action=back" class="back-button">← Back to Trees</a>

		<div class="talent-container" id="container">
			<div class="talent-canvas" id="canvas">
				[generate_talent_connections_html(selected_tree)]
				[generate_talent_nodes_html(selected_tree)]
			</div>
		</div>

		<div class="info-panel">
			<div><strong>[selected_tree.name]</strong></div>
			<div>Available Points: [selected_tree.talent_points_available]</div>
			<div>Spent: [selected_tree.talent_points_spent]</div>
		</div>

		<div class="tooltip" id="tooltip" style="display: none;"></div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = [canvas_x], currentY = [canvas_y];
			let scale = [canvas_scale];

			const container = document.getElementById('container');
			const canvas = document.getElementById('canvas');
			const tooltip = document.getElementById('tooltip');

			const parallaxBg = document.getElementById('parallax-bg');
			const parallaxStars1 = document.getElementById('parallax-stars-1');
			const parallaxStars2 = document.getElementById('parallax-stars-2');
			const parallaxNeb = document.getElementById('parallax-neb');

			updateCanvasTransform();

			container.addEventListener('mousedown', function(e) {
				if (e.target === container || e.target === canvas || e.target.classList.contains('connection-line')) {
					isDragging = true;
					startX = e.clientX - currentX;
					startY = e.clientY - currentY;
					container.classList.add('dragging');
					e.preventDefault();
				}
			});

			document.addEventListener('mousemove', function(e) {
				if (isDragging) {
					currentX = e.clientX - startX;
					currentY = e.clientY - startY;
					updateCanvasTransform();
					updateParallax();
				}

				if (e.target.classList.contains('talent-node') || e.target.parentElement.classList.contains('talent-node')) {
					const node = e.target.classList.contains('talent-node') ? e.target : e.target.parentElement;
					showTooltip(e, node);
				} else {
					hideTooltip();
				}
			});

			document.addEventListener('mouseup', function() {
				isDragging = false;
				container.classList.remove('dragging');
			});

			container.addEventListener('wheel', function(e) {
				e.preventDefault();
				const zoomSpeed = 0.1;
				const rect = container.getBoundingClientRect();
				const mouseX = e.clientX - rect.left;
				const mouseY = e.clientY - rect.top;

				const oldScale = scale;
				scale += e.deltaY > 0 ? -zoomSpeed : zoomSpeed;
				scale = Math.max(0.3, Math.min(3, scale));

				const scaleChange = scale / oldScale;
				currentX = mouseX - (mouseX - currentX) * scaleChange;
				currentY = mouseY - (mouseY - currentY) * scaleChange;

				updateCanvasTransform();
				updateParallax();
			});

			function updateCanvasTransform() {
				canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px) scale(' + scale + ')';
			}

			function updateParallax() {
				const bgSlowness = 0.998046875;
				const stars1Slowness = 0.696625;
				const stars2Slowness = 0.896625;
				const nebSlowness = 0.5;

				parallaxBg.style.transform = 'translate(' + (currentX * (1 - bgSlowness)) + 'px, ' + (currentY * (1 - bgSlowness)) + 'px)';
				parallaxStars1.style.transform = 'translate(' + (currentX * (1 - stars1Slowness)) + 'px, ' + (currentY * (1 - stars1Slowness)) + 'px)';
				parallaxStars2.style.transform = 'translate(' + (currentX * (1 - stars2Slowness)) + 'px, ' + (currentY * (1 - stars2Slowness)) + 'px)';
				parallaxNeb.style.transform = 'translate(' + (currentX * (1 - nebSlowness)) + 'px, ' + (currentY * (1 - nebSlowness)) + 'px)';
			}

			function showTooltip(e, node) {
				try {
					const nodeData = JSON.parse(node.dataset.nodeinfo);

					let html = '<h3>' + nodeData.name + '</h3>';
					html += '<p>' + nodeData.desc + '</p>';
					html += '<p><strong>Cost:</strong> ' + nodeData.cost + ' talent points</p>';

					if (nodeData.requirements && nodeData.requirements.length > 0) {
						html += '<p class="requirements"><strong>Requirements:</strong></p>';
						nodeData.requirements.forEach(function(req) {
							html += '<p class="requirements">' + req + '</p>';
						});
					}

					tooltip.innerHTML = html;
					tooltip.style.display = 'block';
					tooltip.style.left = (e.clientX + 15) + 'px';
					tooltip.style.top = (e.clientY + 15) + 'px';
				} catch(err) {
					console.error('Error showing tooltip:', err);
				}
			}

			function hideTooltip() {
				tooltip.style.display = 'none';
			}

			function selectTalent(talentType) {
				window.location.href = "byond://?src=[REF(matrix)];action=learn_talent;talent=" + encodeURIComponent(talentType) + ";tree=[selected_tree_id]";
			}

			updateParallax();
		</script>
	</body>
	</html>
	"}

	return html

/datum/talent_interface/proc/generate_talent_nodes_html(datum/talent_tree/tree)
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	for(var/node_type in tree.tree_nodes)
		var/datum/talent_node/node = new node_type
		var/is_unlocked = (node_type in tree.unlocked_talents)
		var/is_available = is_unlocked || tree.can_learn_talent(node)

		var/class_list = "talent-node"
		if(is_unlocked)
			class_list += " unlocked"
		else if(is_available)
			class_list += " available"
		else
			class_list += " locked"

		var/node_x = center_x + node.node_x - 16
		var/node_y = center_y + node.node_y - 16

		var/list/req_text = list()
		for(var/prereq_type in node.prerequisites)
			var/datum/talent_node/prereq = new prereq_type
			var/status = (prereq_type in tree.unlocked_talents) ? "✓" : "✗"
			req_text += "[status] [prereq.name]"
			qdel(prereq)

		var/node_data = list(
			"name" = node.name,
			"desc" = node.desc,
			"cost" = node.talent_cost,
			"requirements" = req_text
		)

		html += {"<div class="[class_list]"
			style="left: [node_x]px; top: [node_y]px;"
			data-nodeinfo='[json_encode(node_data)]'
			onclick="selectTalent('[node_type]')"
			title="[node.name]">
			<img src='\ref[node.icon]?state=[node.icon_state]' alt="[node.name]" />
		</div>"}

		qdel(node)

	return html

/datum/talent_interface/proc/generate_talent_connections_html(datum/talent_tree/tree)
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	var/list/node_positions = list()
	for(var/node_type in tree.tree_nodes)
		var/datum/talent_node/temp_node = new node_type
		node_positions[node_type] = list("x" = temp_node.node_x, "y" = temp_node.node_y)
		qdel(temp_node)

	for(var/node_type in tree.tree_nodes)
		var/datum/talent_node/node = new node_type

		for(var/prereq_type in node.prerequisites)
			if(!(prereq_type in node_positions))
				continue

			var/list/prereq_pos = node_positions[prereq_type]
			var/list/current_pos = node_positions[node_type]

			var/start_center_x = center_x + prereq_pos["x"]
			var/start_center_y = center_y + prereq_pos["y"]
			var/end_center_x = center_x + current_pos["x"]
			var/end_center_y = center_y + current_pos["y"]

			var/dx = end_center_x - start_center_x
			var/dy = end_center_y - start_center_y
			var/distance = sqrt(dx*dx + dy*dy)

			if(distance == 0)
				continue

			var/angle = arctan(dx, dy)
			if(angle < 0)
				angle += 360

			var/is_unlocked_connection = (prereq_type in tree.unlocked_talents) && (node_type in tree.unlocked_talents)
			var/connection_class = "connection-line"
			if(is_unlocked_connection)
				connection_class += " unlocked"

			html += {"<div class="[connection_class]"
				style="left: [start_center_x]px; top: [start_center_y - 1.5]px; width: [distance]px; transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;">
			</div>"}

		qdel(node)
	return html
