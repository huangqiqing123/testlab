package test.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DButil {

	  public static final String FROM_DRIVER_NAME="com.ibm.db2.jcc.DB2Driver";
      public static final String FROM_URL="jdbc:db2://10.162.1.117:50000/ls5";
      public static final String FROM_USER_NAME="db2admin";
      public static final String FROM_PASSWORD="db2admin";
	
//      public static final String TO_DRIVER_NAME="com.microsoft.jdbc.sqlserver.SQLServerDriver";
//      public static final String TO_URL="jdbc:microsoft:sqlserver://10.162.12.78:1433;DatabaseName=testlab";
//      public static final String TO_USER_NAME="sa";
//      public static final String TO_PASSWORD="loushang";
      
	//  获取源数据库连接
	public static Connection getSourceConnection() {
		Connection conn = null;
		try {
			String sql = "SELECT * FROM ls5.pub_organ WHERE RM_CUST.CUST_ID=RM_LICENSE.CUST_ID AND RM_CUST.REGIE_ID ='O00000000000015' AND RM_CUST.INSPORG_ID ='O00000000000081'  AND RM_CUST.PAUSE_TERM BETWEEN '20060101' AND '20081231' WITH UR";
			Class.forName("com.ibm.db2.jcc.DB2Driver");
			conn = DriverManager.getConnection("jdbc:db2://10.162.1.117:50000/ls5", "db2admin","db2admin");		
			PreparedStatement ps = conn.prepareStatement("select * from ls5.pub_organ");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				System.out.println(rs.getObject(1));
			}
			
			
//			DatabaseMetaData t = conn.getMetaData();
//			System.out.println(t.getDatabaseProductName());
//			System.out.println(t.getDatabaseProductVersion());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		//System.out.println("---获取源数据库连接成功");
		return conn;
		}
//	//  获取目的数据库连接
//	public static Connection geDestinationConnection() {
//		Connection conn = null;
//		try {
//			Class.forName(TO_DRIVER_NAME);
//			conn = DriverManager.getConnection(TO_URL, TO_USER_NAME,TO_PASSWORD);
//		} catch (ClassNotFoundException e) {
//			e.printStackTrace();
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		System.out.println("---获取目的数据库连接成功");
//		return conn;
//		}
//	//获取源数据库表中的数据
//	public static List getSourceDate(String tableName) {
//		
//		List list = new ArrayList();
//		StringBuffer sql = new StringBuffer();
//		sql.append("select * FROM  ");
//		sql.append(tableName);
//		try {
//			PreparedStatement ps = getSourceConnection().prepareStatement(sql.toString());
//			ResultSet rs = ps.executeQuery();
//			list = toList_FileCoverContent(rs);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return list;
//	}
//	//文件
//	private static List toList_FileCoverContent(ResultSet rs) {
//		
//		List<FileCoverContent> list=new ArrayList<FileCoverContent>();
//		FileCoverContent view=null;
//		if (rs==null) {
//			
//			return list;
//		}
//		try {
//			while(rs.next()){		
//				view=new FileCoverContent();
//				view.setPk(rs.getString("pk"));
//				view.setFk(rs.getString("fk"));
//				view.setFile_cover_content_code(rs.getString("file_cover_content_code"));
//				view.setFile_cover_content_name(rs.getString("file_cover_content_name"));
//				view.setPages(rs.getString("pages"));
//				view.setVersion(rs.getString("version"));
//				view.setMemo(rs.getString("memo"));
//				list.add(view);	
//			}
//		} catch (SQLException e) {
//			e.printStackTrace();
//		}
//		return list;
//	}
	public static void main(String[] args) throws Exception {
//		List list = getSourceDate("t_file_cover_content");
//		System.out.println("获取源数据记录条数 "+list.size());
//		FileCoverContentDao filecovercontentDAO = new FileCoverContentDao();
//		for(int i=0;i<list.size();i++){
//			filecovercontentDAO.save((FileCoverContent)list.get(i));
//		}
		System.out.println(getSourceConnection());
		
	}

}
