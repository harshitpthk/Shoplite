function services_login(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl = "login";
	connectServer(Type,ServiceUrl,varData,successFunction);
}

function fetch_accounts(successFunction)
{
	var Type = "GET";
	var ServiceUrl ="service/accounts";	
	connectServer(Type,ServiceUrl,'',successFunction);
}
