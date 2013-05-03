loadMenu = (url) ->
	$.ajax url,
		dataType: 'json',
		type: 'GET',
		success: (resp) ->
			menuItems =$t.menuItem resp['palette']
			$('#palette').append menuItems


loadTemplates = (url) ->
	$.when($.get url, null, null, 'html')
		.done (resp) =>
			$(resp).each (item) ->
				$.templates @id, $(@).html()
				@