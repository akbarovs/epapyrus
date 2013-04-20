loadPaper = () ->
	canvas = document.createElement 'canvas'
	document.body.appendChild canvas
	paper.setup canvas

	window.$p = paper

$ ->
	loadPaper()

	a = new StartEvent "test", {x: 100, y: 100}
	b = new EndEvent "test2", {x: 200, y: 100}

	a.to b

	scene = new Scene
	scene.add a
	scene.add b

	scene.draw()

	$p.view.draw()