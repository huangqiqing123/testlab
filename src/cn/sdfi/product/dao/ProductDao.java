package cn.sdfi.product.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.framework.db.Trans;
import cn.sdfi.product.bean.Product;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class ProductDao{

	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(this.getClass());
	
	/*
	 * 执行保存
	 */
	public void save(Product view){		
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		StringBuffer sql = new StringBuffer("insert into t_product(pk,sortCode,name,dept)values(?,?,?,?)");
		try{
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getPk());
			ps.setInt(2, view.getSortCode());
			ps.setString(3, view.getName());
			ps.setString(4, view.getDept());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}

	/*
	 * 根据主键查询
	 */
	public Product queryByPK(String pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		Product view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_product");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			view = this.changeRsToView(rs);
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{	
			Tool.closeConnection(rs, ps, conn);
		}
		return view;
	}
	//检验指定主键的记录是否是"已被引用"
	public boolean isInUse(String pk) {
		int num = 0;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT count(*) as num FROM t_defect_chart");
		sql.append(" WHERE chart_project='");
		sql.append(pk);
		sql.append("'");
		try {	
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			if (rs.next()) {
				num = rs.getInt("num");
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 			
		if(num>0){
			return true;
		}else{			
			return false;
		}
	}

	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	public List<Product> changeResultSet(ResultSet rs) {
		List<Product> list = new ArrayList<Product>();
		Product view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new Product();
				view.setPk(rs.getString("pk"));
				view.setSortCode(rs.getInt("sortCode"));
				view.setName(rs.getString("name"));
				view.setDept(rs.getString("dept"));
				list.add(view);
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return list;
	}

	/*
	 * 根据主键批量删除
	 */
	public void batchDeleteByPK(String[] pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		
		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_product where pk in(");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
			sql.append("'");
			sql.append(",");	
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 结果集到实体对象的转换
	 */
	private Product changeRsToView(ResultSet rs){
	
		Product view = new Product();
		try {	
			if (rs.next()) {
				view = new Product();
				view.setPk(rs.getString("pk"));
				view.setSortCode(rs.getInt("sortCode"));
				view.setName(rs.getString("name"));
				view.setDept(rs.getString("dept"));
			}
		} catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return view;
	}
	/*
	 * 接收一个 Product 对象作为查询条件，查询结果将以 Map 的形式返回。
	 * map中第一个元素是count，存储的是符合条件的总记录数（类型：String）
	 * map中第二个元素是list，存储的是符合条件的前pageSize条记录（类型：List）
	 */
	public Map<String, Object> queryByProduct(Product view) {
		
		Connection conn=pool.getConnection();
		
		try {
			System.out.println(Thread.currentThread().getName()+"开始休眠10s");
			Thread.currentThread().sleep(10000);
		} catch (InterruptedException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<Product> list = new ArrayList<Product>();	
		String wheresql = this.getWhereSql(view);

		//countSql 查询符合指定条件的总记录数。
		int count = 0;
		StringBuffer countSql = new StringBuffer();
		countSql.append("select count(*) from t_product where 1=1 ");
		countSql.append(wheresql);
		try {
			ps1 = conn.prepareStatement(countSql.toString());
			rs1 = ps1.executeQuery();
			if(rs1.next()){	
				count = rs1.getInt(1);
			}
			//如果查询结果不为空
			if(count>0){

				//拼接获取符合指定条件的前 pageSize 条记录的sql
				StringBuffer sql = new StringBuffer();
				sql.append("select top ");
				sql.append(view.getPageSize());
				sql.append("  * FROM t_product where pk not in(select top ");
				sql.append(view.getPageSize()*(view.getShowPage()-1));
				sql.append(" pk from t_product where 1=1");
				sql.append(wheresql);
				sql.append(" order by ");
				sql.append(view.getSort());
				sql.append(" ");
				sql.append(view.getSortType());
				sql.append(") ");
				sql.append(wheresql);
				sql.append(" order by ");
				sql.append(view.getSort());
				sql.append(" ");
				sql.append(view.getSortType());

				ps2 = conn.prepareStatement(sql.toString());
				rs2 = ps2.executeQuery();
				list = changeResultSet(rs2);
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs1, ps1, null);
			Tool.closeConnection(rs2, ps2, conn);
		} 
		map.put("count", count);		
		map.put("list",list);
		return map;		
	}	
		//获取查询sql语句
		private String getWhereSql(Product view){
			/*
			 * 按照 产品名称name进行模糊查询
			 * 按照 所属部门dept进行精确查询
			 */
			StringBuffer wheresql = new StringBuffer();
			if(!"".equals(view.getDept())){		
				wheresql.append(" and dept = '");
				wheresql.append(view.getDept());
				wheresql.append("'");
			}		
			if(!"".equals(view.getName())){		
				wheresql.append(" and name like '%");
				wheresql.append(view.getName());
				wheresql.append("%'");
			}	
			return wheresql.toString();
		}
	/*
	 * 更新
	 * 如果项目所属部门发生改变（在后台判断是否发生了改变），则同步修改缺陷表中的数据。
	 * update t_defect_chart set project_customer=? where chart_project=?
	 */
	@Trans
	public void update(Product product) {

		Connection conn = pool.getConnection();
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		ResultSet rs = null;
		
		String querySQL = "select dept from t_product where pk=?";
		String updateSQL = "update t_product set sortCode=?,name=?,dept=? where pk=?";
		String updateSQL2 = "update t_defect_chart set project_customer=? where chart_project=?";
		try {
			//查询当前项目原所属部门
			ps1 = conn.prepareStatement(querySQL);
			ps1.setString(1,product.getPk());
			rs = ps1.executeQuery();
			String oldDept = null;
			if(rs.next()){
				oldDept = rs.getString("dept");
			}
			//如果产品所属部门发生了改变，则同步修改缺陷表中的数据。
			if(!product.getDept().equals(oldDept)){
				ps2 = conn.prepareStatement(updateSQL2);
				ps2.setString(1,product.getDept());
				ps2.setString(2, product.getPk());
				ps2.executeUpdate();
			}
			//修改产品信息
			ps3 = conn.prepareStatement(updateSQL);
			ps3.setInt(1,product.getSortCode());
			ps3.setString(2,product.getName());
			ps3.setString(3,product.getDept());
			ps3.setString(4,product.getPk());
			ps3.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps2, null);
			Tool.closeConnection(null, ps3, null);
			Tool.closeConnection(rs, ps1, conn);
		}
	}
	/*
	 * queryAll，查询所有，返回Map<String,String>，下拉列表展现时使用。
	 */
	public Map<String, String> queryAll() {
		Connection conn = pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		Map<String, String> map = new LinkedHashMap<String, String>();
		try {
			ps = conn.prepareStatement("select pk,name FROM t_product order by sortCode ASC");
			rs = ps.executeQuery();
			while(rs.next()){	
				map.put(rs.getString("pk"),rs.getString("name"));
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return map;		
	}
	/*
	 * 根据产品PK获取其所属部门ID
	 */
	public String getDeptId(String productPK) {
		Connection conn = pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String deptId = null;
		try {
			ps = conn.prepareStatement("select dept FROM t_product where pk='"+productPK+"'");
			rs = ps.executeQuery();
			if(rs.next()){	
				deptId = rs.getString("dept");
			}
		}catch (Exception e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return deptId;		
	}
}
