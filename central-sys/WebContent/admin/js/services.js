function services_login(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl = "login";
	connectServer(Type,ServiceUrl,varData,successFunction);
}

function services_addShopUser(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl ="addshopuser";	
	connectServer(Type,ServiceUrl,varData,successFunction);
}

function services_editShopUser(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl ="editshopuser";	
	connectServer(Type,ServiceUrl,varData,successFunction);
}


function services_getShopUsers(successFunction)
{
	var Type = "GET";
	var ServiceUrl ="getshopusers";	
	connectServer(Type,ServiceUrl,'',successFunction);
}

function services_getCategories(successFunction)
{
	var Type = "GET";
	var ServiceUrl ="getcategories";	
	connectServer(Type,ServiceUrl,'',successFunction);
}