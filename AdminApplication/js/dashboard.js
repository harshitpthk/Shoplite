var pages=['paymentPage','packersPage','homeDeliveryPage','adminPage'];
var admin_menu_items=['Items','Income','Accounts','Alerts','Settings'];
var admin_current_screen=-1;

function fillItems(divID)
{

	var tableID = divID +"itemsTable";
	$("#"+divID).append('<table id='+tableID+'></table>');
	
	for(var i=0;i<10;i++)
	{
		$("#"+tableID).append('<tr>'+
			'<td>MatchedOrder'+i+'</td>'+
			'<td>item'+i+'</td>'+
			'<td>description'+i+'</td>'+
			'<td>quantity'+i+'</td>'+
			'<td>price'+i+'</td>'+
			'</tr>');
	}
}

function fillOrders(divID)
{
	var tableID = divID +"ordersTable";
	
	$("#"+divID).append('<table id='+tableID+'></table>');
	for(var i=0;i<10;i++)
	{
		$("#"+tableID).append('<tr>'+
			'<td>OrderId'+i+'</td>'+
			'<td>MatchedOrder'+i+'</td>'+
			'<td>UserName'+i+'</td>'+
			'</tr>');
	}
					
}

function fillMenu(divID)
{
	var id = "#"+divID;
	for(var i=0;i<admin_menu_items.length;i++)
	{
		$(id).append('<div id= "admin_menu_item'+i+'" class ="menu_item" onclick="showscreen(\''+i+'\');" >'+
								'<div id="menu_item_title" class="menu_title">'+admin_menu_items[i]+'</div>'+
							'<div class="DivHelper"></div>'+'</div>'
							);
	}
}


function showPage(key)
{
	$(".page").addClass('inactive');
	for(var index=0;index<pages.length;index++)
	{
		var tag= "#"+key;
		if(pages[index]==key)
		{
			$(tag).removeClass('inactive');	
		}
	}
}

function getQueryParam(query) {
  var result = {};
  query.split("&").forEach(function(part) {
    var item = part.split("=");
    result[item[0]] = item[1];
  });
  return result;
}

function loadScreen(key)
{
	switch (key)
	{
		case "Items":
  		loadItems();
  		break;
  		
		// case "Income":
//   		loadIncome(a);
//   		break;
  		
  		case "Accounts":
  		loadAccounts();
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

function unLoadScreen(key)
{
	switch (key)
	{
		case "Items":
  		clearItems();
  		break;
  		
		// case "Income":
//   		clearIncome();
//   		break;
  		
  		case "Accounts":
  		clearAccounts();
  		break;
  		
  		// case "Alerts":
//   		clearAlerts();
//   		break;
//   		
//   		case "Settings":
//   		clearSettings();
//   		break;
  
	}
}


function showscreen(index)
{
	if(admin_current_screen!=-1)
	{
		unLoadScreen(admin_menu_items[admin_current_screen]);
	}
	
	for(var i=0;i<admin_menu_items.length;i++)
	{
		
		if(i==index)
		{
			loadScreen(admin_menu_items[i]);
			admin_current_screen=i;
		}
	}	
}


$(document).ready(
	function (){
		var url =document.URL;
		var urlSplitArray= url.split("?");
		
		if(urlSplitArray.length>1)
		{
			var queryString  = decodeURIComponent(urlSplitArray[1]);
			var result = getQueryParam(queryString);
			var user = result["user"];
			var userObj = JSON.parse(user);
		
			var shopUrl = userObj.shop.url;
			SHOPURL = "https://"+shopUrl;
			if(userObj.role==="ADMIN")
			{
				//alert("hi");
			}else 
			{
			
			}
		}

	}
);
