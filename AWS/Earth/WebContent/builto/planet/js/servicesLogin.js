function services_login(varData,successFunction)
{
	var Type = "POST";
	var ServiceUrl = "login";
	connectServer(Type,ServiceUrl,varData,successFunction);
}