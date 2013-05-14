ArrowParams =
	LENGTH: 10
	DEGREE: 155

class Arrow
	points: {}

	constructor: (@id, @from, @to, @shape) ->
		end = new $p.Point @to.x, @to.y
		start = new $p.Point @from.x, @from.y

		mX = Math.max @from.x, @to.x
		mY = @from.y

		middle = new $p.Point mX, mY

		linePath = new $p.Path [start, middle, end]
		linePath.strokeColor = 'black'

		pth = @shape.visiblePath()

		intersections = linePath.getIntersections pth

		lineEnd = intersections[0].point

		arrowEnd = Utils.minus(lineEnd, middle).normalize(ArrowParams.LENGTH)

		arrowPath = new $p.Path([Utils.add(lineEnd, arrowEnd.rotate(ArrowParams.DEGREE)), lineEnd, Utils.add(lineEnd, arrowEnd.rotate(-1 * ArrowParams.DEGREE))])
		arrowPath.strokeWidth = 0.75
		arrowPath.fillColor = 'black'

		path = new $p.Group [linePath, arrowPath]

		path.sendToBack()

		@points =
			start: linePath.firstSegment.point
			end: linePath.lastSegment.point
			ptr: arrowPath
			linePath: linePath

	move: (isStartPt, pos, shape) ->
		if not isStartPt
			@points.ptr.translate pos

		#this will redraw the arrow sign
		pth = @shape.visiblePath()

		intersections = @points.linePath.getIntersections pth
	
		if intersections.length > 0
			endPoint = intersections[0].point
			vec = Utils.minus(endPoint, @points.linePath.segments[1].point).normalize(ArrowParams.LENGTH)

			@points.ptr.segments[0].point = Utils.add endPoint, vec.rotate(ArrowParams.DEGREE)
			@points.ptr.segments[1].point = endPoint
			@points.ptr.segments[2].point = Utils.add endPoint, vec.rotate(-1 * ArrowParams.DEGREE)
