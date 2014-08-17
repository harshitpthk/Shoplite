var server={requestURL:"", reqType:"",reqdata:"",callBackSuccess:""};
var token;
var BASEURL= "https://starp1940130226trial.hanatrial.ondemand.com/central-sys/service/shopadmin/"
var servercall_success =function(msg)
{
	try{
		data=msg;
    	
    	if("failure"==data.status)
    	{
    		if("invalid session"==data.cause)
    		{
    			//alert("session expired. Login again");
    			
				var cookieClearSuccess = function (){
					window.location.href  = "Login.html";
					return;
				}
	
				var errorFunction = function errorDelete(){
					window.location.href  = "Login.html";
					return;
				}
				clearcookies(cookieClearSuccess,errorFunction);
						
				window.location.href  = "Login.html";
    			
    		}
    		server.callBackSuccess(data);
    	}else
    	{
    		server.callBackSuccess(data);
    	}
    	
    }catch(e){
        
        alert("Syntax Error in the response of "+server.requestURL+"  " +e.message ); 

    }
}
var servercall_error=function(jqXHR, textStatus, errorThrown)
{
		alert(jqXHR.status + ' ' + textStatus + ' - ' + errorThrown);
}

function connectServer(reqType,reqURL,reqdata,successFunction)
{
	try
	{
		var Type = reqType;
		var ServiceUrl = BASEURL+reqURL;
		var varData = reqdata;
		var ContentType = "application/json; charset=utf-8";
		var DataType = "json"; 
		var ProcessData = false; 
		
		server.reqType = reqType;
		server.reqdata = reqdata;
		server.callBackSuccess = successFunction;
		server.requestURL = reqURL;
		var timeout_server = 60000;
	
		
		$.ajax({
					  beforeSend		:  function (xhr){
					  							xhr.setRequestHeader('Access-Control-Allow-Star', 'shoplite');
											},
											
					  cache				: false,
					  complete			: function (xhr) {
					  
												
											},
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
					success            : servercall_success,
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

