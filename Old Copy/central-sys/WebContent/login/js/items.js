var items_itemsFor="quantity";
var items_categoryList;

function fillCategories()
{
	var divId ="#productsPage_container";
	$(divId).append('<div id=categoryPathBar class=pathBar></div>');
	
	$(divId).append('<div id=categoryList class=categoryBox></div>');
	$(divId).append('<div id=subCategoryList class=subCategoryBox></div>');
	
	function success(data)
	{
		items_categoryList=data;
		items_fillCategoryList(data);
	}
	
	if(undefined ===items_categoryList)
		services_getCategories(success);
	else
		items_fillCategoryList(items_categoryList);
}

function clearItems()
{
	var divId ="#productsPage_container";	
	$(divId).html('');
}

function loadItems(itemsFor)
{
	items_itemsFor=itemsFor;
	fillCategories();
}

function items_fillCategoryList(categoryList)
{
	$("#categoryList").html('');
	for(var i=0;i<categoryList.length;i++)
	{
		if(items_itemsFor !== "quantity" && !categoryList[i].isPriceUpdateAvailable)
			continue;
			
		var html =$('<div class="categoryItem actionable">'+
									'<div class=categoryName>'+categoryList[i].name+'</div>'+
								  '</div>').on('click', categoryList[i],items_fillSubCategoryList) ;
		$("#categoryList").append(html);
	}
}

function items_fillSubCategoryList(event)
{
	var category = event.data;
	
	if(event.srcElement.classList.contains("categoryName"))
	{
		$("#categoryPathBar").html('');
		var html = $('<div class="pathBarCategoryItem actionable">'+
							category.name+
						'</div>').on('click', category,items_fillSubCategoryList) ;
		$("#categoryPathBar").append(html);
		
		$(".categoryName").removeClass("highlight");
		$(event.srcElement).addClass("highlight");
		
	}else if(event.srcElement.classList.contains("pathBarCategoryItem"))
	{
		removeAllNextElements(event.srcElement.nextElementSibling);
		
	}else if(event.srcElement.classList.contains("subCategoryItem"))
	{
		var html = $('<div class="pathBarCategoryItem actionable">'+
							category.name+
						'</div>').on('click', category,items_fillSubCategoryList) ;
		$("#categoryPathBar").append(html);
	}
	
	
	
	$("#subCategoryList").html('');
	
	if(category.childList.length==0)
	{
		items_getItems(category);
	}
	
	for(var i=0;i<category.childList.length;i++)
	{
	
		var html = $('<div class="subCategoryItem actionable">'+
							category.childList[i].name+
						'</div>').on('click', category.childList[i],items_fillSubCategoryList) ;
		$("#subCategoryList").append(html);
	}
}

function items_getItems(category)
{
	function success(data)
	{
		items_fillItems(data);
	}
	var obj ={type:items_itemsFor,id:category.id};
	var input = JSON.stringify(obj);
	services_getItems(input,success);
}

function items_fillItems(itemList)
{
	$("#subCategoryList").html('');
	
	
	for(var index=0;index<itemList.length;index++)
	{
	
		var divVariance='';
		var itemCategory = itemList[index];
		
		if(itemCategory.itemList.length<1)
			continue;
	
		if(itemCategory.itemList.length>1)
		{
			var divVariance = '<div class=productVariance> <select id="'+itemCategory.id+'" name="productVariance">';
	
			for(var i=0;i<itemCategory.itemList.length;i++)
			{
				divVariance =divVariance+'<option value='+itemCategory.itemList[i].id+'>'+itemCategory.itemList[i].name+'</option>'
			}					
							
			divVariance =divVariance+'</select></div>';
		
		}else if(itemCategory.itemList.length>0)
		{
			divVariance ='<div id='+itemCategory.id+' value="'+itemCategory.itemList[0].id+'" class=productVariance>'+itemCategory.itemList[0].name+'</div>'
		}
	
		var updateName="Price:";
		var updateFunction = "items_ChangePrice";
		
		if(items_itemsFor==="quantity")
		{
			updateName="Qty:";
			updateFunction = "items_addQuantity";
		}
		
		var updatePanel = '<div class="update">'+
				'<div class="updateName">'+updateName+'</div>'+
				'<input id="'+itemCategory.id+'" class="inputNumber" type="number"/>'+
				'<img id="'+itemCategory.id+'" class="addImg" onclick="'+updateFunction+'(\''+itemCategory.id+'\')"/>'+
				'</div>';
		
		var quantity = itemCategory.itemList[0].quantity;
		var price = itemCategory.itemList[0].price;
					
				
		var html = '<div class=productItem>'+
							'<div class=productIcon>image</div>'+
							'<div class=productName>'+itemCategory.name+'</div>'+
							divVariance+
							'<div id="'+itemCategory.id+'" class=productQuantity>Qty: '+quantity+'</div>'+
							'<div id="'+itemCategory.id+'" class=productPrice>Price: '+price+' Rs.</div>'+
							updatePanel+
						'</div>';
						
		$("#subCategoryList").append(html);
		$("#"+itemCategory.id).change(itemCategory,items_varianceChanged);
	}
}


function items_varianceChanged(event)
{

	var itemCategory = event.data;
	var indexSelected = event.srcElement.selectedIndex;
	
	var quantity = itemCategory.itemList[indexSelected].quantity;
	var price = itemCategory.itemList[indexSelected].price;
			
			
	var priceDiv = ".productPrice#"+itemCategory.id;
	$(priceDiv).html('Price: '+price+' Rs.');
	
	var qtyDiv = ".productQuantity#"+itemCategory.id;
	$(qtyDiv).html('Qty: '+quantity);
	
}

function items_addQuantity(itemCategoryId)
{
	var itemId= $('select[id='+itemCategoryId+']').val();
	
	if(!itemId)
	{
		itemId= $(".productVariance#"+itemCategoryId).attr("value");
	}
	
	var quantityToAdd = $('input[id='+itemCategoryId+']').val();
	
	if(!isNaN(itemId) && !isNaN(quantityToAdd))
	{
		$('img[id='+itemCategoryId+']').addClass('loaderImg');
		
		var id = parseInt(itemId);
		var value = parseInt(quantityToAdd);
		var type = "quantity";
			
		function success(msg)
		{
			$('img[id='+itemCategoryId+']').removeClass('loaderImg');
			var qtyDiv = ".productQuantity#"+itemCategoryId;
			var html = $(qtyDiv).html();
			
			var qty = html.split('Qty: ');
			var qtyValue = parseInt(qty[1]); 
			
			qtyValue = qtyValue+value;
			$(qtyDiv).html('Qty: '+qtyValue);
		}
	
		var input ={id:id,value:value,type:type};
		var data =JSON.stringify(input);
		services_changeItem(data,success);
	}
}


function items_ChangePrice(itemCategoryId)
{
	var itemId= $('select[id='+itemCategoryId+']').val();
	
	if(!itemId)
	{
		itemId= $(".productVariance#"+itemCategoryId).attr("value");
	}
	
	var priceToChange = $('input[id='+itemCategoryId+']').val();
	
	if(!isNaN(itemId) && !isNaN(priceToChange))
	{
		$('img[id='+itemCategoryId+']').addClass('loaderImg');
		
		var id = parseInt(itemId);
		var value = parseInt(priceToChange);
		var type = items_itemsFor;
			
		function success(msg)
		{
			$('img[id='+itemCategoryId+']').removeClass('loaderImg');
			var qtyDiv = ".productPrice#"+itemCategoryId;
			
			$(qtyDiv).html('Price: '+value+' Rs.');
		}
	
		var input ={id:id,value:value,type:type};
		var data =JSON.stringify(input);
		services_changeItem(data,success);
	}
}

/*move to common field*/
function removeAllNextElements(element)
{
	if(element==null)
	{
		return;
	}else if(element.nextElementSibling==null)
		element.remove();
	else
	{
		removeAllNextElements(element.nextElementSibling);
		element.remove();	
	}
}	
