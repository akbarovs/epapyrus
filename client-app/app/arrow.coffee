ArrowParams =
	LENGTH: 10
	DEGREE: 155

class Arrow
	points: {}

	constructor: (@id, @shapeFrom, @shapeTo) ->
		@drawArrow()

	drawArrow: ->
		@from = @shapeFrom.center()
		@to = @shapeTo.center()

		end = new $p.Point @to.x, @to.y
		start = new $p.Point @from.x, @from.y

		mX = @to.x
		mY = @from.y

		middle = new $p.Point mX, mY

		segments = [start, middle, end]
		startPoint = middle
		
		if (@shapeTo.visiblePath().contains(middle) || @shapeFrom.visiblePath().contains(middle))
			segments = [start, end]
			startPoint = @from

		linePath = new $p.Path segments
		linePath.strokeColor = 'black'
		linePath.strokeWidth = 1.5

		pth = @shapeTo.visiblePath()

		intersections = linePath.getIntersections pth

		if intersections[0]?
			lineEnd = intersections[0].point

			arrowEnd = Utils.minus(lineEnd, startPoint).normalize(ArrowParams.LENGTH)

			arrowPath = new $p.Path([Utils.add(lineEnd, arrowEnd.rotate(ArrowParams.DEGREE)), lineEnd, Utils.add(lineEnd, arrowEnd.rotate(-1 * ArrowParams.DEGREE))])
			arrowPath.strokeWidth = 0.75
			arrowPath.fillColor = 'black'

			path = new $p.Group [linePath, arrowPath]
		else
			linePath.remove()

			
		path?.sendToBack()	
		@points =
			start: linePath.firstSegment.point
			end: linePath.lastSegment.point
			ptr: arrowPath
			linePath: linePath	

	move: (isStartPt, pos, shape) ->
		@points.ptr?.remove()
		@points.linePath?.remove()
		@shape
		@drawArrow()
