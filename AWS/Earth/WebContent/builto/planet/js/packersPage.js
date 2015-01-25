var packersPage_Timer;
var packersPage_unpackedItemsData;
var packersPage_currentOrder;

function openPackers()
{
	packersPage_fetchOrders();
	packersPage_Timer=setInterval(
		function () {
			packersPage_fetchOrders();
		}, 120000);
		
	$(".orders").css("height","26%");
	$(".orders").css("margin-top","20px");
	
	
	if(packersPage_unpackedItemsData === undefined)
	{
		packersPage_getUnpackedItems();
		
	}else
	{
		packersPage_showUnpacked();
	}
}


function closePackers()
{
	clearInterval(packersPage_Timer);
	$(".orders").css("height","50%");
	$(".orders").css("margin-top","0px");
	
	packersPage_clearMiddleContainer();
}	

function packersPage_clearMiddleContainer()
{
	$("#packersPage_itemsContainer").html('');
	
	$("#packersPage_delivered").hide();
	$("#packersPage_print").hide();
	$("#packersPage_next").hide();
	
	$("#packersPage_title").html('Details');
}


function fillUnpackedItems(data)
{
	packersPage_clearMiddleContainer();
	if(data.length>0)
	{
		fillItems("packersPage_itemsContainer",data);	
		$("#unpackedItems").addClass('highlight');
	
		$("#packersPage_delivered").hide();
		$("#packersPage_print").show();
		$("#packersPage_next").show();
		
		$("#packersPage_title").html('Items to Pack');
	}
}

function packersPage_getUnpackedItems()
{
	packersPage_clearMiddleContainer();
	
	function success(data)
	{
		packersPage_unpackedItemsData=data;
		fillUnpackedItems(data);
	}
	
	services_getUnPackedItems("5",success);
}

function packersPage_fetchOrders()
{
	function successDelivery(data)
	{
		$("#packersPage_ordersDeliveryContainer").html('');
		fillOrders("packersPage_ordersDeliveryContainer",data,'packersPage_getItems');
	}
	
	function successHomeDelivery(data)
	{
		$("#packersPage_ordersHomeDeliveryContainer").html('');
		fillOrders("packersPage_ordersHomeDeliveryContainer",data,'packersPage_getItems');
	}
	
	function successConfirmed(data)
	{
		$("#packersPage_ordersConfirmedContainer").html('');
		fillOrders("packersPage_ordersConfirmedContainer",data,'packersPage_getItems');
	}
	
	services_getOrders("FORDELIVERY",successDelivery);
	services_getOrders("FORHOMEDELIVERY",successHomeDelivery);
	services_getOrders("FORPAYMENT",successConfirmed);
}


function packersPage_getItems(element)
{
	$('.orderId').removeClass('highlight');
	$("#unpackedItems").removeClass('highlight');
	
	$(element).addClass('highlight');	
	
	var orderId =element.textContent.trim();
	packersPage_currentOrder =parseInt(orderId);
	
	packersPage_clearMiddleContainer();
	function success(data)
	{
		
		if(data.length>0)
		{
			fillItems("packersPage_itemsContainer",data);
			$("#packersPage_next").hide();
			$("#packersPage_print").show();
			
			//element is td, so its parent is tr, its parent is tbody and its parent is table  
			if(element.parentElement.parentElement.parentElement.id.search("ordersDelivery")>0)
			{
				$("#packersPage_delivered").show();
			}
			
			$("#packersPage_title").html('Details of order '+orderId);
		}
	}
	services_getOrderDetails(orderId,success);
	
	
}

function packersPage_showUnpacked()
{
	$('.orderId').removeClass('highlight');
	
	if(packersPage_unpackedItemsData.length>0)
	{
		fillUnpackedItems(packersPage_unpackedItemsData);
	}
	else
		packersPage_getUnpackedItems();
	
}

function packersPage_getNextSet()
{
	packersPage_getUnpackedItems();
}


function packersPage_registerDelivery()
{	
	var obj = {orderId:packersPage_currentOrder,state:"CLOSED"};
	var data =JSON.stringify(obj);
	function success(data)
	{
		$("#packersPage_delivered").hide();
	}
	services_changeOrderState(data,success);
}