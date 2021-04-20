$(document).ready(function(){
	window.addEventListener("message",function(event){
    var id = event.data.css+event.data.diferencial;
		var html = "<br><div id='"+id+"' class="+event.data.css+">"+event.data.mensagem+"</div>";
    // $(html).appendTo("#notifications").fadeIn(1000).delay(5000).fadeOut(1000);

    // CRIA A NOTIFICAÇÃO
    $(html).appendTo("#notifications");
    
    // EXPANDE
    setTimeout(function(){
      $("#notifications").animate({
        maxWidth: "550px"
      }, 500 );
      $("#"+id+"").animate({
        fontSize: "14px"
      }, 500 );
    }, 500);

    // FADEOUT
    setTimeout(function(){
      $("#"+id+"").animate({
        fontSize: "0px",
        height: "30px"
      }, 500 );
      $("#"+id+"").fadeOut(500);
    }, event.data.tempo);

    // REMOVE NOTIFICAÇÃO
    setTimeout(function(){
      // $("#"+event.data.css+"").removeClass("show");
      $("#"+id+"").remove();
      // $("#notifications").removeClass("show");
    }, event.data.tempo + 2500);
	})
});