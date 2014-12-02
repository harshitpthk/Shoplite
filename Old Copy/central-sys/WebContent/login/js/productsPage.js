var product_menu_items=['Update Quantity', 'Update Price'];
var product_current_screen=-1;

function productPage_loadScreen(key)
{
	switch (key)
	{
		case "Update Quantity":
  		loadItems("quantity");
  		break;
  	 		
  		case "Update Price":
  		loadItems("price");
  		break;
  	
	}
}

function productPage_unLoadScreen(key)
{
	switch (key)
	{
		case "Update Quantity":
  		clearItems();
  		break;
  		
  		case "Update Price":
  		clearItems();
  		break;
  	
	}
}


function productPage_showscreen(index,element)
{
	if(product_current_screen!=-1)
	{
		productPage_unLoadScreen(product_menu_items[product_current_screen]);
	}
	
	for(var i=0;i<product_menu_items.length;i++)
	{
		
		if(i==index)
		{
			productPage_loadScreen(product_menu_items[i]);
			product_current_screen=i;
		}
	}
	
	$('.menu_title').removeClass('highlight');
	$(element.getElementsByClassName('menu_title')).addClass('highlight');	
}