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
	services_getProducts(input,success);
}

function items_fillItems(itemList)
{
	$("#subCategoryList").html('');
	
	
	for(var index=0;index<itemList.length;index++)
	{
	
		var divVariance='';
		var product= itemList[index];
		
		if(product.varianceList.length<1)
			continue;
	
		if(product.varianceList.length>1)
		{
			divVariance = '<div class=productVariance> <select id="'+product.id+'" name="productVariance">';
	
			for(var i=0;i<product.varianceList.length;i++)
			{
				divVariance =divVariance+'<option value='+product.varianceList[i].id+'>'+product.varianceList[i].name+'</option>';
			}					
							
			divVariance =divVariance+'</select></div>';
		
		}else if(product.varianceList.length>0)
		{
			divVariance ='<div id='+product.id+' value="'+product.varianceList[0].id+'" class=productVariance>'+product.varianceList[0].name+'</div>';
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
				'<input id="'+product.id+'" class="inputNumber" type="number"/>'+
				'<img id="'+product.id+'" class="addImg" onclick="'+updateFunction+'(\''+product.id+'\')"/>'+
				'</div>';
		
		var quantity = product.varianceList[0].quantity;
		var price = product.varianceList[0].price;
					
				
		var html = '<div class=productItem>'+
							'<div class=productIcon>image</div>'+
							'<div class=productName>'+product.name+'</div>'+
							divVariance+
							'<div id="'+product.id+'" class=productQuantity>Qty: '+quantity+'</div>'+
							'<div id="'+product.id+'" class=productPrice>Price: '+price+' Rs.</div>'+
							updatePanel+
						'</div>';
						
		$("#subCategoryList").append(html);
		$("#"+product.id).change(product,items_varienceChanged);
	}
}


function items_varienceChanged(event)
{

	var product = event.data;
	var indexSelected = event.srcElement.selectedIndex;
	
	var quantity = product.varianceList[indexSelected].quantity;
	var price = product.varianceList[indexSelected].price;
			
			
	var priceDiv = ".productPrice#"+product.id;
	$(priceDiv).html('Price: '+price+' Rs.');
	
	var qtyDiv = ".productQuantity#"+product.id;
	$(qtyDiv).html('Qty: '+quantity);
	
}

function items_addQuantity(productId)
{
	var varianceId= $('select[id='+productId+']').val();
	
	if(!varianceId)
	{
		varianceId= $(".productVariance#"+productId).attr("value");
	}
	
	var quantityToAdd = $('input[id='+productId+']').val();
	
	if(!isNaN(varianceId) && !isNaN(quantityToAdd))
	{
		$('img[id='+productId+']').addClass('loaderImg');
		
		var id = parseInt(varianceId);
		var value = parseInt(quantityToAdd);
		var type = "quantity";
			
		function success(msg)
		{
			$('img[id='+productId+']').removeClass('loaderImg');
			var qtyDiv = ".productQuantity#"+productId;
			var html = $(qtyDiv).html();
			
			var qty = html.split('Qty: ');
			var qtyValue = parseInt(qty[1]); 
			
			qtyValue = qtyValue+value;
			$(qtyDiv).html('Qty: '+qtyValue);
		}
	
		var input ={id:id,value:value,type:type};
		var data =JSON.stringify(input);
		services_changeProduct(data,success);
	}
}


function items_ChangePrice(productId)
{
	var varianceId= $('select[id='+productId+']').val();
	
	if(!varianceId)
	{
		varianceId= $(".productVariance#"+productId).attr("value");
	}
	
	var priceToChange = $('input[id='+productId+']').val();
	
	if(!isNaN(varianceId) && !isNaN(priceToChange))
	{
		$('img[id='+productId+']').addClass('loaderImg');
		
		var id = parseInt(varianceId);
		var value = parseInt(priceToChange);
		var type = items_itemsFor;
			
		function success(msg)
		{
			$('img[id='+productId+']').removeClass('loaderImg');
			var qtyDiv = ".productPrice#"+productId;
			
			$(qtyDiv).html('Price: '+value+' Rs.');
		}
	
		var input ={id:id,value:value,type:type};
		var data =JSON.stringify(input);
		services_changeProduct(data,success);
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
