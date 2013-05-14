class Utils
	@add: (p1, p2) ->
		ret =
			x: p1.x + p2.x
			y: p1.y + p2.y

	@minus: (p1, p2) ->
		new $p.Point p1.x - p2.x, p1.y - p2.y

	@s4: ->
		Math.floor((1 + Math.random()) * 0x10000)
             .toString(16)
             .substring(1);