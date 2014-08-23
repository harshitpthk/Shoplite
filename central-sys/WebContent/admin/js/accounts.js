function fillAccountForm()
{
	var divId ="#adminPage_container";
	$(divId).append(buildUserAddForm());
	
	function success(data)
	{
		buildUserListForm(data,divId)
	}
	
	services_getShopUsers(success);
}

function clearAccounts()
{
	var divId ="#adminPage_container";	
	$(divId).html('');
}

function loadAccounts()
{
	fillAccountForm()
}

function addUser()
{
	function success(msg)
	{
		alert(msg);
	}
	
	var user = $("input[name=user]").val();
    var role = $("input[type='radio'][name='role']:checked").val();
    var code =  $("input[name=password]").val();   	
    var recode =  $("input[name=repassword]").val();
    
     
    if(code!==recode)
    {
    	alert("password didn't match");
    }else
    {    	
		var obj = {userID:user,code:code,role:role};
		var data =JSON.stringify(obj);
		alert(data);
		services_addShopUser(data,success);
	}
}

function buildUserListForm(users,divId)
{
	$(divId).append( '<div id=listUserBox class=userBox></div>');
	
	for(var i=0;i<users.length;i++)
	{
		var user = users[i];
		$('#listUserBox').append('<div class=userItem>'+user.userID+'</div>');
	}
}

function buildUserAddForm()
{
	var html = '<div id=addUserBox class=userBox>'+
					'<input class="input_field" type="text" name="user" placeholder="User">'+
					'Role: <input type="radio" value="ADMIN" name="role">Admin'+
							'<input type="radio" value="MANAGER" name="role">Manager'+
							'<input type="radio" value="CASHIER" name="role">Cashier'+
							'<input type="radio" value="PACKER" name="role">Packer'+
							'<br>'+
					'<input class="input_field" type="password" name="password" placeholder="Password">'+
					'<input class="input_field" type="password" name="repassword" placeholder="Confirm password">'+
					'<input class="button" type="submit" value="Add" onclick="addUser();" >'+
				'</div>';
				
	return html;
}