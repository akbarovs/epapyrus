loadPaper = () ->
	canvas = document.createElement 'canvas'
	document.body.appendChild canvas
	paper.setup canvas

	window.$p = paper

$ ->
	loadPaper()

	a = new StartEvent "test", {x: 100, y: 100}
	b = new EndEvent "test2", {x: 300, y: 100}
	c = new UserTask "userTask", {x: 200, y: 100}

	scene = new Scene
	scene.add a
	scene.add b
	scene.add c

	scene.draw()

	a.from c
	#c.from b

	$p.view.viewSize = new $p.Size(1000, 1000)
	$p.view.draw()

	tool = new $p.Tool()

	selected = undefined

	tool.onMouseDown = (event) ->
		selected = event.item

	tool.onMouseDrag = (event) ->
		if (selected)
			selected.position.x += event.delta.x
			selected.position.y += event.delta.y

			selected.editorObj.move event.delta

