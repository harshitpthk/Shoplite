function fillCategories()
{
	var divId ="#adminPage_container";
	
	$(divId).append('<div id=categoryList class=categoryBox></div>');
	$(divId).append('<div id=categoryPathBar class=pathBar></div>');
	$(divId).append('<div id=subCategoryList class=subCategoryBox></div>');
	
	function success(data)
	{
		fillCategoryList(data);
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

function fillCategoryList(categoryList)
{
	$("#categoryList").html('');
	for(var i=0;i<categoryList.length;i++)
	{
		var html =$('<div class=categoryItem>'+
									'<div class=categoryName>'+categoryList[i].name+'</div>'+
								  '</div>').on('click', categoryList[i],fillSubCategoryList) ;
		$("#categoryList").append(html);
	}
}

function fillSubCategoryList(event)
{
	var category = event.data;
	
	if(event.srcElement.className==="categoryName")
	{
		$("#categoryPathBar").html('');
		var html = $('<div class=pathBarCategoryItem>'+
							category.name+
						'</div>').on('click', category,fillSubCategoryList) ;
		$("#categoryPathBar").append(html);
		
	}else if(event.srcElement.className==="pathBarCategoryItem")
	{
		removeAllNextElements(event.srcElement.nextElementSibling);
	}else if(event.srcElement.className==="subCategoryItem")
	{
		var html = $('<div class=pathBarCategoryItem>'+
							category.name+
						'</div>').on('click', category,fillSubCategoryList) ;
		$("#categoryPathBar").append(html);
	}
	
	
	
	$("#subCategoryList").html('');
	
	if(category.childList.length==0)
	{
		alert(category.name);
	}
	
	for(var i=0;i<category.childList.length;i++)
	{
	
		var html = $('<div class=subCategoryItem>'+
							category.childList[i].name+
						'</div>').on('click', category.childList[i],fillSubCategoryList) ;
		$("#subCategoryList").append(html);
	}
}

function removeAllNextElements(element)
{
	if(element.nextElementSibling==null)
		element.remove();
	else
	{
		removeAllNextElements(element.nextElementSibling);
		element.remove();	
	}
}	
