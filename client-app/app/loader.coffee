loadPaper = () ->
	paper.setup 'editorCanvas'

	window.$p = paper
$ ->
	loadPaper()
	
	window.$t = $.render

	loadTemplates './templates.html'
	loadMenu './menu.json'

	a = new StartEvent "test", {x: 100, y: 100}
	b = new EndEvent "test2", {x: 350, y: 150}
	c = new UserTask "userTask", {x: 200, y: 100}

	scene = new Scene
	scene.add a
	scene.add b
	scene.add c

	scene.draw()

	a.from c
	c.from b
	i = 1
	i++

	$p.view.viewSize = new $p.Size(1200, 1200)
	$p.view.draw()

	tool = new $p.Tool()

	selected = undefined
	toConnect = undefined

	tool.onMouseDown = (event) ->
		selected = event.item

		$p.project.activeLayer.selected = false

		if selected
			selected.editorObj.select()

		if event.modifiers.shift and not selected
			element = new UserTask "userTask" + i, {x:event.point.x, y:event.point.y}
			i++
			element.draw()

		if event.modifiers.option and selected
			if not toConnect
				toConnect = selected
			else
				toConnect.editorObj.from selected.editorObj
				toConnect = undefined

	tool.onMouseDrag = (event) ->
		if (selected)
			selected.position.x += event.delta.x
			selected.position.y += event.delta.y

			selected.editorObj.move event.delta

