function fillCategories()
{
	var divId ="#adminPage_container";
	
	$(divId).append('<div id=categoryList class=categoryBox></div>');
	$(divId).append('<div id=categoryPathBar class=pathBar></div>');
	$(divId).append('<div id=subCategoryList class=subCategoryBox></div>');
	
	function success(data)
	{
		items_fillCategoryList(data);
	}
	
	services_getCategories(success);
}

function clearItems()
{
	var divId ="#adminPage_container";	
	$(divId).html('');
}

function loadItems()
{
	fillCategories();
}

function items_fillCategoryList(categoryList)
{
	$("#categoryList").html('');
	for(var i=0;i<categoryList.length;i++)
	{
		var html =$('<div class=categoryItem>'+
									'<div class=categoryName>'+categoryList[i].name+'</div>'+
								  '</div>').on('click', categoryList[i],items_fillSubCategoryList) ;
		$("#categoryList").append(html);
	}
}

function items_fillSubCategoryList(event)
{
	var category = event.data;
	
	if(event.srcElement.className==="categoryName")
	{
		$("#categoryPathBar").html('');
		var html = $('<div class=pathBarCategoryItem>'+
							category.name+
						'</div>').on('click', category,items_fillSubCategoryList) ;
		$("#categoryPathBar").append(html);
		
	}else if(event.srcElement.className==="pathBarCategoryItem")
	{
		removeAllNextElements(event.srcElement.nextElementSibling);
		
	}else if(event.srcElement.className==="subCategoryItem")
	{
		var html = $('<div class=pathBarCategoryItem>'+
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
	
		var html = $('<div class=subCategoryItem>'+
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
	var input = JSON.stringify(category.id);
	services_getItems(input,success);
}

function items_fillItems(itemList)
{
	$("#subCategoryList").html('');
	
	
	for(var index=0;index<itemList.length;index++)
	{
	
		var divVariance='';
		var itemCategory = itemList[index];
	
		if(itemCategory.itemList.length>1)
		{
			var divVariance = '<div class=productVariance> <select name="productVariance">';
	
			for(var i=0;i<itemCategory.itemList.length;i++)
			{
				divVariance =divVariance+'<option value='+itemCategory.itemList[i].id+'>'+itemCategory.itemList[i].name+'</option>'
			}					
							
			divVariance =divVariance+'</select></div>';
		
		}else if(itemCategory.itemList.length>0)
		{
			divVariance ='<div class=productVariance>'+itemCategory.itemList[0].name+'</div>'
		}
	
	
		var divQuantity = '<div class=productQuantity>Qty: <select name="productQuantity" >';
	
		for(var i=0;i<6;i++)
		{
			divQuantity =divQuantity+'<option value='+(i+1)+'>'+(i+1)+'</option>'
		}					
						
		divQuantity =divQuantity+'</select></div>';
	
		var html = $('<div class=productItem>'+
							'<div class=productIcon>image</div>'+
							'<div class=productName>'+itemCategory.name+'</div>'+
							divVariance+
							divQuantity+
							'<div class=productPrice>price</div>'+
							
						'</div>').on('click', itemCategory,'') ;
						
		$("#subCategoryList").append(html);
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
