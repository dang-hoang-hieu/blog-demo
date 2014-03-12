// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap

$(function(){
	$("textarea#comment_content, input#entry_title").bind('input propertychange', function(){
		var character_left =  $(this).data("maximum") - $(this).val().length
		if (character_left > 0) {
			$("h2#character-left").text(  character_left + " characters left." )
		}else {
			$("h2#character-left").html( "<span class='alert alert-error'> you type too much characters! </span>" )
		}
	});
})

