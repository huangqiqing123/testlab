package test.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestCur2000 {

	public static void main(String[] args) throws Exception {
		
		Connection con = getCon();
		
		//设置事务不自动提交
		con.setAutoCommit(false);
		
		//创建第一个句柄
		PreparedStatement ps = con.prepareStatement("select * from t_file_user");
		ResultSet rs = ps.executeQuery();
		int count = 0;
		while(rs.next()){
			count++;
		}
		System.out.println("count="+count);
		
		//创建第二个句柄
		PreparedStatement ps2 = con.prepareStatement("select * from t_audit");	
	}

	public static Connection getCon() {
		try {
			//添加 SelectMethod=cursor 可解决该问题
			String url = "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=testlab;SelectMethod=cursor";
			//String url = "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=testlab";
			Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
			return DriverManager.getConnection(url, "sa","loushang");
		} catch (Exception e) {
			e.printStackTrace();
		}	
		return null;
	}
}
