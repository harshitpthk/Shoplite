function services_login(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl = "login";
	connectServer(Type,ServiceUrl,varData,successFunction);
}

function services_loginShop(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl = "login";
	connectServer(Type,ServiceUrl,varData,successFunction,true);
}