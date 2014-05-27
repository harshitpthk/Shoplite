package com.shoplite.hub.statics;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.google.gson.Gson;

public class MyHashMap<KEY,VALUE> {
	

	public VALUE getItem(KEY k, Connection conn, Class<VALUE> className)
	{
		String getValueStatement ="Select VALUE from DICTIONARY where KEY =?";
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Gson gson = new Gson();
		String key = gson.toJson(k);
		VALUE value=null;
		try{
			pstmt = conn.prepareStatement(getValueStatement);
			pstmt.setString(1, key);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				value=gson.fromJson(rs.getString(1),className);
			}
			SQLUtil.close(null, pstmt, rs);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			SQLUtil.close(null, pstmt, rs);
		}
			
		return value;
	}
	
	public void deleteItem(KEY k, Connection conn)
	{
		String getDeleteStatement ="Delete from DICTIONARY where KEY =?";
		PreparedStatement pstmt=null;
		Gson gson = new Gson();
		String key = gson.toJson(k);
		try{
			pstmt = conn.prepareStatement(getDeleteStatement);
			pstmt.setString(1, key);
			int row = pstmt.executeUpdate();
			
			if(row!=1)
			{
				
			}
			SQLUtil.close(null, pstmt, null);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally
		{
			SQLUtil.close(null, pstmt, null);
		}
			
	}
	
	public void setItem(KEY k,VALUE v, Connection conn)
	{
		String getValueStatement ="INSERT INTO DICTIONARY(KEY,VALUE) VALUES(?,?)";
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Gson gson = new Gson();
		String key = gson.toJson(k);
		String value=gson.toJson(v);
		try{
			pstmt = conn.prepareStatement(getValueStatement);
			pstmt.setString(1, key);
			pstmt.setString(2, value);
			pstmt.executeUpdate();
			SQLUtil.close(null, pstmt, rs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally
		{
			SQLUtil.close(null, pstmt, rs);
		}
	}
}
