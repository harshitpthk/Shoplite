package com.shoplite.shop.statics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;

import com.shoplite.models.User;

public class SQLUtil {

public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		
		if(rs != null) {
			try {
				rs.close();
			} catch(Exception e) {}
		}
		if(pstmt != null) {
			try {
				pstmt.close();
			} catch(Exception e) {}
		}
		if(conn != null) {
			try {
				conn.close();
			} catch(Exception e) {}
		}
	}

public static boolean addUser(User user,Connection conn,Logger logger) throws Exception {
	String getValueStatement ="insert into USERS values(?,?,?,?,?,?,?)";
	PreparedStatement pstmt=null;
	ResultSet rs = null;
	int userId;
	try{
		String seqSQL = "SELECT USERS_SEQ.NEXTVAL FROM DUMMY";
		pstmt = conn.prepareStatement(seqSQL);
		rs = pstmt.executeQuery();
		rs.next();
		userId = rs.getInt(1);
		close(null, pstmt, rs);
		
		
		pstmt = conn.prepareStatement(getValueStatement);
		pstmt.setInt(1, userId);
		pstmt.setString(2, user.getName());
		pstmt.setString(3, user.getEmail());
		pstmt.setString(4, "");
		pstmt.setString(5, user.getPhno());
		pstmt.setString(6, user.getLocation().getLatitude());
		pstmt.setString(7,  user.getLocation().getLongitude());
		
		int row = pstmt.executeUpdate();
		SQLUtil.close(null, pstmt, rs);
		
		if(row==1)
		{
			
			return true;
		}
		
		return false;
		
	} catch (SQLException e) {
		throw e;
		
	}finally
	{
		SQLUtil.close(null, pstmt, rs);
	}
	
}

public static int getUserId(String email,Connection conn,Logger logger) throws Exception {
	String getValueStatement ="Select USER_ID from USERS where USER_E_MAIL=?";
	PreparedStatement pstmt=null;
	ResultSet rs = null;
	int userId=-1;
	try{
		pstmt = conn.prepareStatement(getValueStatement);
		pstmt.setString(1, email);
		rs = pstmt.executeQuery();
		if(rs.next())
			userId = rs.getInt(1);
		
		close(null, pstmt, rs);
		return userId;
	}catch (SQLException e) {
		throw e;
		
	}finally
	{
		SQLUtil.close(null, pstmt, rs);
	}
}


public static boolean updateUser(User user,Connection conn,Logger logger) throws Exception {
	String updateStatement ="UPDATE USERS SET USER_NAME=?,"+ 
												"USER_E_MAIL=?,"+ 
												"USER_GENDER=?,"+
												"USER_PHNO=?,"+
												"USER_LANG=?,"+
												"USER_LONG=? WHERE USER_ID = ?";
	PreparedStatement pstmt=null;
	try{
		
		
		pstmt = conn.prepareStatement(updateStatement);
		pstmt.setInt(7, user.getId());
		pstmt.setString(1, user.getName());
		pstmt.setString(2, user.getEmail());
		pstmt.setString(3, "");
		pstmt.setString(4, user.getPhno());
		pstmt.setString(5, user.getLocation().getLatitude());
		pstmt.setString(6,  user.getLocation().getLongitude());
		
		int row = pstmt.executeUpdate();
		SQLUtil.close(null, pstmt, null);
		
		if(row==1)
		{
			
			return true;
		}
		
		return false;
		
	} catch (SQLException e) {
		throw e;
		
	}finally
	{
		SQLUtil.close(null, pstmt, null);
	}
	
}

}
