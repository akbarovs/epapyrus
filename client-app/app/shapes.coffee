ShapeConstants =
	strokeColor: 'black'

class XYPoint
	constructor: (@x, @y) ->

class Scene
	constructor: (@objects = []) ->

	add: (object) ->
		@objects.push object

	draw: ->
		for object in @objects
			object.draw()

class Shape
	type: undefined
	size: undefined
	fromArrows: undefined
	toArrows: undefined
	path: undefined

	constructor: (@id, @coord, @data = {}) ->
		@fromArrows = []
		@toArrows = []
		@size = {}
		@path = undefined

	draw: ->
		throw new Error "Unsupported"

	visiblePath: ->
		if @path.children
			pth = @path.children[0]
		else
			pth = @path

	center: ->
		@coord

	from: (shape) ->
		arrow = new Arrow "", @.center(), shape.center(), shape

		@fromArrows.push arrow
		shape.toArrows.push arrow

	select: ->
		@visiblePath().selected = true

	move: (pos) ->
		for arrow in @fromArrows
			arrow.points.start.x += pos.x
			arrow.points.start.y += pos.y

			arrow.move true, pos, @

		for arrow in @toArrows
			arrow.points.end.x += pos.x
			arrow.points.end.y += pos.y
			
			arrow.move false, pos, @

class StartEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'start-event'
		@size.r = 15

	draw: ->
		@path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		@path.fillColor = 'black'
		@path.editorObj = @

class EndEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'end-event'
		@size.r = 15

	draw: ->
		@path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		@path.fillColor = 'white'
		@path.strokeColor = 'black'
		@path.editorObj = @

class UserTask extends Shape
	path: undefined

	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		path = undefined
		@type = 'user-task'
		@size =
			x: 100
			y: 60

	draw: ->
		rect = new $p.Rectangle new $p.Point(@coord.x, @.coord.y), new $p.Size(@size)
		pth = new $p.Path.RoundRectangle rect, new $p.Size(5, 5)

		pth.strokeColor = 'black'
		pth.fillColor = '#DCECB5'

		txt = new $p.PointText(pth.bounds.leftCenter)
		txt.fillColor = 'black'
		txt.content = @id

		txt.bounds.x = txt.bounds.x + 10
		txt.position.y = txt.bounds.y + txt.bounds.height/1.5

		g =  new $p.Group [pth, txt]
		g.applyMatrix = true
		@path = g
		@path.editorObj = @

	center: ->
		@path.bounds.center