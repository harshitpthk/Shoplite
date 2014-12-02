var paymentPage_Timer;
var paymentPage_currentOrder;

function openPayments()
{
	paymentPage_fetchOrders();
	
	paymentPage_Timer=setInterval(
		function () {
			paymentPage_fetchOrders();
		}, 60000);
	
}

function closePayments()
{
	clearInterval(paymentPage_Timer);
	paymentPage_clearMiddleContainer();	
}

function paymentPage_clearMiddleContainer()
{
	$("#paymentPage_itemsContainer").html('');
	$("#paymentPage_paymentContainer").html('');
	$("#paymentPage_print").hide();	
	$("#paymentPage_title").html('Details');
	
}

function paymentPage_fetchOrders()
{
	function success(data)
	{
		$("#paymentPage_ordersConfirmedContainer").html('');
		fillOrders("paymentPage_ordersConfirmedContainer",data,'paymentPage_getItems');
	}
	services_getOrders("FORPAYMENT",success);
}

function paymentPage_paymentSuccess(orderId,msg)
{
	$("#paymentPage_paymentContainer").html('success');
	paymentPage_fetchOrders();
}

function paymentPage_getItems(element)
{
	$('.orderId').removeClass('highlight');
	$(element).addClass('highlight');	
	
	var orderId =element.textContent.trim();
	var data =JSON.stringify(orderId);
	
	paymentPage_currentOrder =parseInt(orderId);
	
	paymentPage_clearMiddleContainer();
	
	function success(data)
	{
		if(data.length>0)
		{
			var orderAmount = fillItems("paymentPage_itemsContainer",data);
			$("#paymentPage_print").show();	
			$("#paymentPage_title").html('Details of order '+orderId);
			
			buildPaymentInfo("paymentPage_paymentContainer",orderId,orderAmount,paymentPage_paymentSuccess);
		}
	}
	services_getOrderDetails(data,success);
}

