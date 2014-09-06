	
function fillAccountForm()
{

	var divId ="#adminPage_container";
	$(divId).append( '<div id=listUserBox class=userBox></div>');
	$(divId).append('<div id=addUserBox class=userBox></div>');
	
	function success(data)
	{
		buildUserListForm(data);
	}
	
	services_getShopUsers(success);
	buildUserAddForm();
}

function clearAccounts()
{
	var divId ="#adminPage_container";	
	$(divId).html('');
}

function loadAccounts()
{
	fillAccountForm();
}

function accounts_addUser()
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
		services_addShopUser(data,success);
	}
}

function accounts_editUser(userid)
{
	function success(msg)
	{
		alert(msg);
	}
	
	var role = $("input[type='radio'][name='role']:checked").val();
    
     
   var obj = {userID:userid,role:role};
   var data =JSON.stringify(obj);
   services_editShopUser(data,success);
}

function accounts_deleteUser(userid)
{
	function success(msg)
	{
		alert(msg);
	}
	    
    var obj = {userID:userid};
	var data =JSON.stringify(obj);
	services_deleteShopUser(data,success);
}

function buildUserListForm(users)
{
	$('#listUserBox').append('<div class=userItem>'+
									'<div class=userField>Add User</div>'+
									'<div class=userField></div>'+
									'<img class=userAdd onclick="buildUserAddForm();"/>'+
								'</div>');
								
	for(var i=0;i<users.length;i++)
	{
		var user = users[i];
		$('#listUserBox').append('<div class=userItem>'+
									'<div class=userField>'+user.userID+'</div>'+
									'<div class=userField>'+user.role+'</div>'+
									// '<div class="userRole actionable">edit</div>'+
// 									'<div class="userRole actionable">delete</div>'+
									'<img id=userEdit class=editImg onclick="buildUserEditForm(\''+user.userID+'\',\''+user.role+'\');"/>'+
									'<img id=userDelete class=deleteImg onclick="accounts_deleteUser(\''+user.userID+'\');"/>'+
								'</div>');
	}
}

function buildUserAddForm()
{
	var html = '<input class="input_field" type="text" name="user" placeholder="User">'+
				'<div id=role class="input_radio" >'+
					'<input type="radio" value="ADMIN" name="role">Admin'+
							'<input type="radio" value="MANAGER" name="role">Manager'+
							'<input type="radio" value="CASHIER" name="role">Cashier'+
							'<input type="radio" value="PACKER" name="role">Packer'+
							'<br>'+
				'</div>'+		
				'<input class="input_field" type="password" name="password" placeholder="Password">'+
				'<input class="input_field" type="password" name="repassword" placeholder="Confirm password">'+
				'<input class="button" type="submit" value="Add" onclick="accounts_addUser();" >';
	
	$('#addUserBox').html('');			
	$('#addUserBox').append(html);
}

function buildUserEditForm(userid,role)
{
	var html = '<input class="input_field" type="text" name="user" placeholder="User">'+
					'<div id=role class="input_radio" >'+
						'<input type="radio" value="ADMIN" name="role">Admin'+
								'<input type="radio" value="MANAGER" name="role">Manager'+
								'<input type="radio" value="CASHIER" name="role">Cashier'+
								'<input type="radio" value="PACKER" name="role">Packer'+
								'<br>'+
					'</div>'+		
				'<input class="button" type="submit" value="Edit" onclick="accounts_editUser(\''+userid+'\');" >';
				
	$('#addUserBox').html('');
	$('#addUserBox').append(html);
	
	$("input[name=user]").val(userid);
	$("input[name=user]").prop('disabled', true);
    $("input[type='radio'][name='role'][value="+role+"]").prop('checked',true);
}