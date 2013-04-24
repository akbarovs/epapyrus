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
			arrow.points.start.x += pos.x
			arrow.points.start.y += pos.y

			vec = Utils.minus(arrow.points.end, arrow.points.start).normalize(10)
			
			arrow.points.ptr.segments[0].point = Utils.add arrow.points.end, vec.rotate(155)
			arrow.points.ptr.segments[2].point = Utils.add arrow.points.end, vec.rotate(-155)

		for arrow in @toArrows
			arrow.points.end.x += pos.x
			arrow.points.end.y += pos.y
			arrow.points.ptr.translate pos

			vec = Utils.minus(arrow.points.end, arrow.points.start).normalize(10)
			
			arrow.points.ptr.segments[0].point = Utils.add arrow.points.end, vec.rotate(155)
			arrow.points.ptr.segments[2].point = Utils.add arrow.points.end, vec.rotate(-155)

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
	points: {}

	constructor: (@id, @from, @to) ->
		end = new $p.Point @to.x, @to.y
		start = new $p.Point @from.x, @from.y
		linePath = new $p.Path.Line start, end
		linePath.strokeColor = 'black'
		
		arrowEnd = Utils.minus(end, start).normalize(10)

		arrowPath = new $p.Path([Utils.add(end, arrowEnd.rotate(155)), end, Utils.add(end, arrowEnd.rotate(-155))])
		arrowPath.strokeWidth = 0.75
		arrowPath.fillColor = 'black'

		path = new $p.Group [linePath, arrowPath]

		@points =
			start: linePath.firstSegment.point
			end: linePath.lastSegment.point
			ptr: arrowPath
		



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
		@path.bounds.leftCenter