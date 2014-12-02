var BASEURL= "https://starp1940130226trial.hanatrial.ondemand.com/central-sys/service/shopadmin/"
var SHOPURL = ""

var servercall_error=function(jqXHR, textStatus, errorThrown)
{
		alert(jqXHR.status + ' ' + textStatus + ' - ' + errorThrown);
}

function connectServer(reqType,reqURL,reqdata,successFunction,isShop)
{
	try
	{
		var Type = reqType;
		var ServiceUrl = BASEURL+reqURL;
		
		if(isShop)
		{
			ServiceUrl = SHOPURL+reqURL;
		}
		var varData = reqdata;
		var ContentType = "application/json; charset=utf-8";
		var DataType = "json"; 
		var ProcessData = false; 
		
		var timeout_server = 60000;
	
		
		$.ajax({
					  beforeSend		:  function (xhr){
					  							xhr.setRequestHeader('Access-Control-Allow-Star', 'shoplite');
					  							},
					  complete			: function (xhr) {
					  
												
												if(xhr.getResponseHeader('Set-Cookie'))
												{
														
													alert( xhr.getResponseHeader('Set-Cookie'));
												}
												
											},
					
					cache				: false,
					type               : Type, //GET or POST or PUT or DELETE verb
					url                : ServiceUrl, // Location of the service
					data               : varData, //Data sent to server
					contentType        : ContentType, // content type sent to server
					dataType           : DataType, //Expected data format from server
					processdata        : ProcessData, //True or False
					timeout			   : timeout_server,
					crossDomain		   : true,
					xhrFields          : {
											withCredentials: false
										 },
					success            : function(data,textStaus,jqXHR)
											{
													if("failure"==data.status)
													{
														if("invalid session"==data.cause)
														{
															alert("session expired. Login again");
				
														}
														alert(data.cause);
													}else
													{
														successFunction(data);
													}
	
											},
					error			   : servercall_error	 
		});
	}					
	catch (e)
	{
		if (e instanceof TypeError)
		{
			alert("Type Error encountered. The description is " + e.message);
		}
		else if (e instanceof SyntaxError)
		{
			alert("Syntax Error encountered. The description is " + e.message);
		}
		else
		{
			alert("Error encountered. The description is " + e.message);
		}
	}
}

