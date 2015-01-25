var pages=['paymentPage','packersPage','homeDeliveryPage','productsPage','adminPage'];

var dashboard_currentPage;

var max_Limit=20;
var currentOrderSeq=0;

function loadPage(key)
{
	switch (key)
	{
		
  		
		case "paymentPage":
  		openPayments();
  		break;
  		
  		case "packersPage":
  		openPackers();
  		break;
  		
  		case "homeDeliveryPage":
  		openHomeDelivery();
  		break;
  		
  		// case "Alerts":
//   		loadAlerts();
//   		break;
//   		
//   		case "Settings":
//   		loadSettings();
//   		break;
  
	}
}

function unLoadPage(key)
{
	switch (key)
	{
		
  		
		case "paymentPage":
  		closePayments();
  		break;
  		
  		case "packersPage":
  		closePackers();
  		break;
  		
  		case "homeDeliveryPage":
  		closeHomeDelivery();
  		break;
//   		
//   		case "Settings":
//   		clearSettings();
//   		break;
  
	}
}

function fillItems(divID,data)
{

	var tableID = divID +"itemsTable";
	$("#"+divID).append('<table id='+tableID+'></table>');
	
	var sum=0;
	for(var i=0;i<data.length;i++)
	{
		var key = data[i].orderId.toString();
		var matchOrder = 0;
		
		if(localStorage.getItem(key) == null)
		{
			currentOrderSeq=currentOrderSeq+1;
			localStorage.setItem(key, currentOrderSeq.toString());
			matchOrder=currentOrderSeq;
		}else
		{
			matchOrder= parseInt(localStorage.getItem(key));
		}
		
		var rowValue = data[i].price * data[i].quantity;
		$("#"+tableID).append('<tr>'+
			'<td>'+matchOrder+'</td>'+
			'<td>description'+i+'</td>'+
			'<td>'+data[i].quantity+'</td>'+
			'<td>'+data[i].price+'</td>'+
			'<td>'+rowValue.toFixed(2)+'</td>'+
			
			'</tr>');
			
		sum = sum+rowValue;
	}
	
	$("#"+tableID).append('<tr style="color:rgb(160, 12, 160)">'+
			'<td></td>'+
			'<td></td>'+
			'<td></td>'+
			'<td>Total</td>'+
			'<td>'+sum.toFixed(2)+'</td>'+
			'</tr>');
		
			
	return sum;
	
}

function fillOrders(divID,data,action)
{
	var tableID = divID +"ordersTable";
	
	$("#"+divID).append('<table id='+tableID+'></table>');
	
	
	for(var i=0;i<data.length;i++)
	{
		var key = data[i].orderId.toString();
		var matchOrder = 0;
		
		if(localStorage.getItem(key) == null)
		{
			currentOrderSeq=currentOrderSeq+1;
			localStorage.setItem(key, currentOrderSeq.toString());
			matchOrder=currentOrderSeq;
		}else
		{
			matchOrder= parseInt(localStorage.getItem(key));
		}
		
		$("#"+tableID).append('<tr>'+
			'<td class="orderId actionable" onclick="'+action+'(this,'+data[i].paymentId+');">'+data[i].orderId+'</td>'+
			'<td>'+matchOrder+'</td>'+
			'<td>'+data[i].userName+'</td>'+
			'</tr>');
	}

					
}

function fillMenu(divID,array,actionFunction)
{
	var id = "#"+divID;
	for(var i=0;i<array.length;i++)
	{
		$(id).append('<div class ="menu_item" onclick="'+actionFunction+'(\''+i+'\',this);" >'+
								'<div id="menu_item_title" class="menu_title actionable">'+array[i]+'</div>'+
							'<div class="DivHelper"></div>'+'</div>'
							);
	}
}


function showPage(key,element)
{
	$("#"+dashboard_currentPage).addClass('inactive');
	$("#"+key).removeClass('inactive');	
	
	loadPage(key);
	unLoadPage(dashboard_currentPage);
	dashboard_currentPage =key;
	
	$('.mainmenuItem').removeClass('highlight');
	
	$(element).addClass('highlight');
}

function getQueryParam(query) {
  var result = {};
  query.split("&").forEach(function(part) {
    var item = part.split("=");
    result[item[0]] = item[1];
  });
  return result;
}

function buildPaymentInfo(div,orderId,amount,successCallBack)
{
	
	var html = '<div  class="input_label">OrderID : '+orderId+'</div>'+
				'<div  class="input_label">Amount : '+amount+' Rs.</div>'+
				'<div  class="input_radio" >'+
					'<input type="radio" value="SWIPE" name="mode">Card  '+
					'<input type="radio" value="CASH" name="mode">Cash '+
				'</div>'+
				'<input class="input_field" type="text" name="referenceNumber" placeholder="Reference number">';
				
	var obj ={callback:successCallBack,orderId:orderId,amount:amount};			
				
	var inputDiv = $('<input class="button bottombarItem" style="display:block" type="submit" value="Paid"/>').click(obj,submitPayment);
	
	$("#"+div).html(html);
	$("#"+div).append(inputDiv);
}

function submitPayment(event)
{
	var input =event.data;
	
	var mode = $("input[type='radio'][name='mode']:checked").val();
	var refNumber =$("input[name=referenceNumber]").val();  

	var refValue =parseInt(refNumber);
	
	if(mode===undefined || isNaN(refValue))
	{
		alert('please select proper mode and enter valid reference number');
		return;
	}
	var obj ={orderId:input.orderId,amount:input.amount,referenceNumber:refValue,mode:mode};

	var data =JSON.stringify(obj);

	function success(msg)
	{
		input.callback(input.orderId,msg);
	}
	services_makePayment(data,success);
}

$(document).ready(
	function (){

		var userObj = JSON.parse(sessionStorage.user);
		var shopUrl = userObj.shop.url+'service/shopadmin/';
		SHOPURL = "https://"+shopUrl;
		
		if(userObj.role!=="ADMIN")
		{
			$("#adminMenu").remove();
			$("#adminPage").remove();
			
		} 
		
		if(userObj.role==="CASHIER")
		{
			$("#packersMenu").remove();
			$("#packersPage").remove();
			
			$("#productsMenu").remove();
			$("#productsPage").remove();
			
		}else if(userObj.role==="PACKER")
		{
			$(".mainmenu").remove();
			
			$("#paymentPage").remove();
			$("#homeDeliveryPage").remove();
			$("#productsPage").remove();
			
			$("#packersPage").removeClass('inactive');	
			loadPage("packersPage");
		}
		
		
		
		

	}
);
