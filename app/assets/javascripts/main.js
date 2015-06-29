$(document).on('click','.readmore, .readless',function(){

	if ($(this).hasClass("readless")) {
            $(this).removeClass("readless");
			$(this).addClass("readmore");
			$(this).find('span').addClass("hidden");
			$(".more").removeClass("hidden");
        } else if ($(this).hasClass("readmore")){
			$(this).removeClass("readmore");
            $(this).addClass("readless");
            $(this).find('span').removeClass("hidden");
			$(".more").addClass("hidden");
        }
});

$(document).ready(function(){
	$('#mail_team').on("change",function(){
	  $.ajax({
	  	url: '/ajax_team/',
	  	type: "POST",
        data: 'tid=' + this.value
	  })
	});
	$('#register').bind('ajax:success', function(evt, data, status, xhr){
    	$(".discover_box7").empty().fadeOut(500).html("<div class='contact_header_font_styles'><h1><span class='fontello-mail newsletter_mail_icon'></span>Bulletin de nouvelles</h1></div><div class='row'><div class='col-sm-3'></div><div class='col-sm-6'><div id='alert-msg'><br>Votre email a été ajouté au Bulletin de nouvelle</div></div><div class='col-sm-3'></div><br><br><br></div>").fadeIn(500);
 	});

	$('#register').bind('ajax:error', function(evt, data, status, xhr){
    	$('#alert-msg').html("Veuillez entrer un email valide");
 	});

	$(".scrollable").on("click", function(){
		$.localScroll({duration:1000});
		return false;
	});

	$(document).on('click','.toggle_blessure',function(){
		if( $('#blessure_'+$(this).attr("id")).is(":visible"))
		{
			$('#blessure_'+$(this).attr("id")).hide();
		}else{
			$(".blessure_frame").hide();
			$('#blessure_'+$(this).attr("id")).show();
			$("#spinner").hide();
		}
	});

	$(document).on('click','.toggle_team',function(){
		if( $('#team_'+$(this).attr("id")).is(":visible"))
		{
			$('#team_'+$(this).attr("id")).hide();
		}else{
			$(".team_frame").hide();
			$('#team_'+$(this).attr("id")).show();
			$("#spinner").hide();
		}
	});

	$(document).on('click','#result_blessure_update,#result_eval_update,#blessure-filter-by-team,#blessure-filter-by-frequence',function(){
		$(".spinner").show();

		$('#form_blessure_picker').on('ajax:success', function(data, status, xhr){
			$(".spinner").hide();
	 	});
	});

	$(document).on('click','.toggle_eval_result',function(){
		if( $('#eval_result_'+$(this).attr("id")).is(":visible"))
		{
			$('#eval_result_'+$(this).attr("id")).hide();
		}else{
			//$(".eval_result_frame").hide();
			$('#eval_result_'+$(this).attr("id")).show();
			$("#spinner").hide();
		}
	});

	$(".input-group.date").datetimepicker({
        pickTime: false
	});

	$('#multiple_team').multiselect();

	$(document).on('click','#btn_mail_decoy',function(){
		$("#btn_mail").get(0).click();
	});

	$(document).on('change','#user_photo, #user_banner',function(){
		$("#form_photo").submit();
	});
});
