var admin_menu_items=['Income','Accounts','Alerts','Settings'];
var admin_current_screen=-1;

function adminPage_loadScreen(key)
{
	switch (key)
	{
		
  		
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

function adminPage_unLoadScreen(key)
{
	switch (key)
	{
		
  		
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


function adminPage_showscreen(index,element)
{
	if(admin_current_screen!=-1)
	{
		adminPage_unLoadScreen(admin_menu_items[admin_current_screen]);
	}
	
	for(var i=0;i<admin_menu_items.length;i++)
	{
		
		if(i==index)
		{
			adminPage_loadScreen(admin_menu_items[i]);
			admin_current_screen=i;
		}
	}
	
	$('.menu_title').removeClass('highlight');
	$(element.getElementsByClassName('menu_title')).addClass('highlight');	
}