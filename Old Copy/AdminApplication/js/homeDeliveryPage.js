var homeDeliveryPage_Timer;
var homeDeliveryPage_currentOrder;

function openHomeDelivery()
{

	homeDeliveryPage_fetchOrders();
	homeDeliveryPage_Timer=setInterval(
		function () {
			homeDeliveryPage_fetchOrders();
		}, 120000);
	
}


function closeHomeDelivery()
{
	clearInterval(homeDeliveryPage_Timer);	
	homeDeliveryPage_clearMiddleContainer();
}

function homeDeliveryPage_clearMiddleContainer()
{
	$("#homeDeliveryPage_itemsContainer").html('');
	$("#homeDeliveryPage_paymentContainer").html('');
	
	$("#homeDeliveryPage_print").hide();
	$("#homeDeliveryPage_delivered").hide();
	$("#homeDeliveryPage_title").html('Details');
}

function homeDeliveryPage_fetchOrders()
{
	function success(data)
	{
		$("#homeDeliveryPage_ordersContainer").html('');
		fillOrders("homeDeliveryPage_ordersContainer",data,'homeDeliveryPage_getItems');
	}
	services_getOrders("FORHOMEDELIVERY",success);
}

function homeDeliveryPage_paymentSuccess(orderId,msg)
{
	$("#homeDeliveryPage_paymentContainer").html('success');
	homeDeliveryPage_fetchOrders();
	$("#homeDeliveryPage_delivered").show();
}

function homeDeliveryPage_getItems(element,paymentId)
{
	$('.orderId').removeClass('highlight');
	$(element).addClass('highlight');	
	
	var orderId =element.textContent.trim();
	homeDeliveryPage_currentOrder =parseInt(orderId);
	
	homeDeliveryPage_clearMiddleContainer();
		
	function success(data)
	{
		
		if(data.length>0)
		{
			var orderAmount =fillItems("homeDeliveryPage_itemsContainer",data);
			$("#homeDeliveryPage_print").show();
			$("#homeDeliveryPage_title").html('Details of order '+orderId);
			
			if(paymentId==0)
				buildPaymentInfo("homeDeliveryPage_paymentContainer",orderId,orderAmount,homeDeliveryPage_paymentSuccess);
			else
				$("#homeDeliveryPage_delivered").show();
	
		}
	}
	services_getOrderDetails(orderId,success);
}

function homeDeliveryPage_registerDelivery()
{	
	var obj = {orderId:homeDeliveryPage_currentOrder,state:"CLOSED"}
	var data =JSON.stringify(obj);
	function success(data)
	{
		homeDeliveryPage_fetchOrders();
		$("#homeDeliveryPage_delivered").hide();
	}
	services_changeOrderState(data,success);
}
