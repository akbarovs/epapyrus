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

	constructor: (@id, @coord, @data = {}) ->
		@fromArrows = []
		@toArrows = []
		@size = {}

	draw: ->
		throw new Error "Unsupported"

	center: ->
		@coord

	from: (shape) ->
		arrow = new Arrow "", @.center(), shape.center()

		@fromArrows.push arrow
		shape.toArrows.push arrow

	move: (pos) ->
		for arrow in @fromArrows
			arrow.path.firstSegment.point.x += pos.x
			arrow.path.firstSegment.point.y += pos.y

		for arrow in @toArrows
			arrow.path.lastSegment.point.x += pos.x
			arrow.path.lastSegment.point.y += pos.y

class StartEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'start-event'
		@size.r = 15

	draw: ->
		path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		path.fillColor = 'black'
		path.editorObj = @

class EndEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'end-event'
		@size.r = 15

	draw: ->
		path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		path.fillColor = 'white'
		path.strokeColor = 'black'
		path.editorObj = @

class Arrow
	path: undefined

	constructor: (@id, @from, @to) ->
		@path = new $p.Path.Line new $p.Point(@from.x, @from.y), new $p.Point(@to.x, @to.y)
		@path.strokeColor = 'black'


class UserTask extends Shape
	path: undefined

	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		path = undefined
		@type = 'user-task'
		@size =
			x: 80
			y: 50

	draw: ->
		rect = new $p.Rectangle new $p.Point(@coord.x, @.coord.y), new $p.Size(@size)
		@path = new $p.Path.RoundRectangle rect, new $p.Size(5, 5)

		@path.strokeColor = 'black'
		@path.fillColor = 'white'
		@path.editorObj = @

	center: ->
		@path.getPointAt (@path.length / 15)