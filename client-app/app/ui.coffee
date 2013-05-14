loadMenu = (url) ->
	$.ajax url,
		dataType: 'json',
		type: 'GET',
		success: (resp) ->
			menuItems = $t.menuItem resp['palette']
			$('#palette').append menuItems
			$('.draggable').draggable
				revert: true,
				revertDuration: 10,
				cursorAt:
					left: 1
					top: 1,
				cursor: "default"
				
			$('#editorCanvas').droppable
				accept: ".draggable"
				drop: (event, ui) =>
					pos = {left: event.pageX, top: event.pageY}
					cp = $('#editorCanvas').position()
					elem = ShapeFactory.from ui.draggable.attr('data-type'), {x: pos.left - cp.left , y: pos.top - cp.top}
					elem.draw()
					$p.view.draw()


loadTemplates = (url) ->
	$.when($.get url, null, null, 'html')
		.done (resp) =>
			$(resp).each (item) ->
				$.templates @id, $(@).html()
				@