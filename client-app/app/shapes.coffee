class XYPoint
	constructor: (@x, @y) ->

class Scene
	constructor: (@objects = []) ->

	add: (object) ->
		@objects.push object

	draw: ->
		console.log JSON.stringify @objects
		for object in @objects
			object.draw()

class Shape
	type: undefined
	size: undefined
	outgoing: undefined

	constructor: (@id, @coord, @data = {}) ->
		@outgoing = {}
		@size = {}

	draw: ->
		throw new Error "Unsupported"

	center: ->
		throw new Error "Unsupported"

	to: (shape) ->
		#@incoming[shape.id] = shape
		#shape.outgoing[@id] = @

class StartEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'start-event'
		@size.r = 15

	draw: ->
		path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		path.fillColor = 'black'

class EndEvent extends Shape
	constructor: (@id, @coord, @data = {}) ->
		super(@id, @coord, @data)
		@type = 'end-event'
		@size.r = 15

	draw: ->
		path = new $p.Path.Circle new $p.Point(@coord.x, @coord.y), @size.r

		path.fillColor = 'white'
		path.strokeColor = 'black'

