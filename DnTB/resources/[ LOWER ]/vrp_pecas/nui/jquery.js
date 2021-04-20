$(document).ready(function(){
	let actionContainer = $("#actionmenu");
	let actionButton = $("#actionbutton");

	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showMenu":
				actionButton.fadeIn(500);
				actionContainer.fadeIn(500);
			break;

			case "hideMenu":
				actionButton.fadeOut(500);
				actionContainer.fadeOut(500);
			break;
		}
	});

	$("#inicio").load("./inicio.html");

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_pecas/shopClose");
		}
	};
});

$('#actionbutton').click(function(e){
	$.post("http://vrp_pecas/shopClose");
});

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}

const carregarMenu = (name) => {
	return new Promise((resolve) => {
		$("#inicio").load(name+".html",function(){
			resolve();
		});
	});
}

const pecasList = () => {
	$.post("http://vrp_pecas/pecasList",JSON.stringify({}),(data) => {
		let i = 0;
		const nameList = data.shopitens.sort((a,b) => (a.name > b.name) ? 1: -1);
		$('#inicio').html(`
			<input id="amount" class="qtd" maxlength="7" spellcheck="false" value="" placeholder="QUANT..">
			<div class="vender">VENDER</div>
			<div class="obs">Para <b>vender</b> um item selecione-o abaixo, coloque a quantidade no menu acima e clique <b>vender</b>.</div>
			<div class="title">PEÇAS</div>
			${nameList.map((item) => (`
				<div class="model" data-index-key="${item.index}" data-price-key="${item.price}">
					<div class="id">${i = i + 1}</div>
					<div class="name">${item.name}</div>
					<div class="price">$${formatarNumero(item.price)}</div>
				</div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".model",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.model').removeClass('active');
	if(!isActive) $el.addClass('active');
});

$(document).on("click",".vender",function(){
	let $el = $('.model.active');
	let amount = Number($('#amount').val());
	if($el && amount > 0){
		$.post("http://vrp_pecas/shopSell",JSON.stringify({
			index: $el.attr('data-index-key'),
			price: $el.attr('data-price-key'),
			amount
		}));
	}
});