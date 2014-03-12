# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$( ->
	$("textarea#comment_content, input#entry_title").bind 'input propertychange', ->
		character_left =  $(this).data("maximum") - $(this).val().length
		holder = $("h2#character-left")
		if character_left > 0
			holder.text(  character_left + " characters left." )
		else 
			holder.html( "<span class='alert alert-error'> you type too much characters! </span>" )		
)

