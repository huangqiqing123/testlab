package cn.sdfi.cases.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import cn.sdfi.cases.bean.Case;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class CaseDao{
	
	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(CaseDao.class);
	
	/*
	 * 执行保存
	 */
	public void save(Case view) {
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_case(pk,title,summary,detail,analyze,solve,result,type,status,upload_person,upload_time,last_update_time,blob_name,version)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getPk());
			ps.setString(2, view.getTitle());
			ps.setString(3, view.getSummary());
			ps.setString(4, view.getDetail());
			ps.setString(5, view.getAnalyze());
			ps.setString(6, view.getSolve());
			ps.setString(7, view.getResult());
			ps.setString(8, view.getType());
			ps.setString(9, view.getStatus());
			ps.setString(10, view.getUpload_person());
			ps.setString(11, view.getUpload_time());
			ps.setString(12, view.getLast_update_time());
			ps.setString(13, view.getBlob_name());
			ps.setString(14, view.getVersion());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("案例保存出错！",e);
			throw new RuntimeException("案例保存出错!",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}
	/*
	 * 查询数据库中所有记录，返回由主键组成的List
	 */
	public List<String> getAllPks() {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<String> pks = new ArrayList<String>();
		try {	
			ps = conn.prepareStatement("SELECT pk FROM t_case");
			rs = ps.executeQuery();
			while(rs.next()){	
				pks.add(rs.getString("pk"));
			}
		} catch (Exception e) {
			log.error("查询案例表主键出错！",e);
			throw new RuntimeException("查询案例表主键出错!",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return pks;
	}
	//noPageQueryByStauts
	public List<Case> noPageQueryByStauts(String status) { 
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		List<Case> list = new ArrayList<Case>();	
		String sql = "select * from t_case where status='"+status+"'";
		try {
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			list = changeResultSet(rs);
		}catch (Exception e) {
			log.error("查询出错！",e);
			throw new RuntimeException("查询出错!",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return list;
	}
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<Case> changeResultSet(ResultSet rs) {
		
		List<Case> list=new ArrayList<Case>();
		Case view=null;
		if (rs==null) {
			log.debug("ResultSet=null");
			return list;
		}
		try {
			while(rs.next()){			
				view=new Case();
				view.setPk(rs.getString("pk"));
				view.setTitle(rs.getString("title"));
				view.setSummary(rs.getString("summary"));
				view.setDetail(rs.getString("detail"));
				view.setAnalyze(rs.getString("analyze"));
				view.setSolve(rs.getString("solve"));
				view.setResult(rs.getString("result"));
				view.setType(rs.getString("type"));
				view.setStatus(rs.getString("status"));
				view.setUpload_person(rs.getString("upload_person"));
				view.setUpload_time(rs.getString("upload_time"));
				view.setLast_update_time(rs.getString("last_update_time"));
				view.setBlob_name(rs.getString("blob_name"));
				view.setVersion(rs.getString("version"));
				list.add(view);	
			}
		} catch (SQLException e) {
			log.error("转换出错！",e);
			throw new RuntimeException("转换出错!",e);
		}
		return list;
	}
	
	/*
	 * 按照主键批量删除
	 */
	public void batchDeleteByPk(String [] pk){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;

		StringBuffer titles = new StringBuffer();
		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_case where pk in (");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
			sql.append("',");
			titles.append(this.queryByPK(pk[i]).getBlob_name());
			titles.append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
		titles.deleteCharAt(titles.length()-1);

		try {
			ps = conn.prepareStatement(sql.toString());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("删除出错！",e);
			throw new RuntimeException("删除出错!",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
	
/*
 * 修改(状态status是不通过update进行修改的，状态的转化须根据流程流转进行)
 */
	public void update(Case view){
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
	
		StringBuffer sql = new StringBuffer();
		try {
		if(view.getBlob_name()==null||"".equals(view.getBlob_name())){
			sql.append("update t_case set title=?,summary=?,detail=?,analyze=?,solve=?,result=?,type=?,status=?,last_update_time=?,version=? where pk=?");	
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getTitle());
			ps.setString(2, view.getSummary());
			ps.setString(3, view.getDetail());
			ps.setString(4, view.getAnalyze());
			ps.setString(5, view.getSolve());
			ps.setString(6, view.getResult());
			ps.setString(7, view.getType());
			ps.setString(8, view.getStatus());
			ps.setString(9, view.getLast_update_time());
			ps.setString(10, view.getVersion());
			ps.setString(11, view.getPk());
		}else{		
			sql.append("update t_case set title=?,summary=?,detail=?,analyze=?,solve=?,result=?,type=?,status=?,last_update_time=?,blob_name=?,version=? where pk=?");	
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getTitle());
			ps.setString(2, view.getSummary());
			ps.setString(3, view.getDetail());
			ps.setString(4, view.getAnalyze());
			ps.setString(5, view.getSolve());
			ps.setString(6, view.getResult());
			ps.setString(7, view.getType());
			ps.setString(8, view.getStatus());
			ps.setString(9, view.getLast_update_time());
			ps.setString(10, view.getBlob_name());
			ps.setString(11, view.getVersion());
			ps.setString(12, view.getPk());
		}
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("更新出错！",e);
			throw new RuntimeException("更新出错!",e);
		}finally{	
			Tool.closeConnection(null, ps, conn);
		}
	}
	/*
	 * 结果集到实体对象的转换
	 */
	public Case changeRsToView(ResultSet rs) throws Exception {
		
		Case view = new Case();
		if (rs.next()) {
			view.setPk(rs.getString("pk"));
			view.setTitle(rs.getString("title"));
			view.setSummary(rs.getString("summary"));
			view.setDetail(rs.getString("detail"));
			view.setAnalyze(rs.getString("analyze"));
			view.setSolve(rs.getString("solve"));
			view.setResult(rs.getString("result"));
			view.setType(rs.getString("type"));
			view.setStatus(rs.getString("status"));
			view.setUpload_person(rs.getString("upload_person"));
			view.setUpload_time(rs.getString("upload_time"));
			view.setLast_update_time(rs.getString("last_update_time"));
			view.setBlob_name(rs.getString("blob_name"));
			view.setVersion(rs.getString("version"));
			}
		return view;
	}
	/*
	 * 按照主键进行查询
	 */
	public Case queryByPK(String pk) {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Case view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_case");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {		
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			view = changeRsToView(rs);	
		} catch (Exception e) {
			log.error("更新出错！",e);
			throw new RuntimeException("更新出错!",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return view;
	}
	/*
	 * 按照类型进行精确查询
	 * 按照状态进行精确查询
	 * 按照标题进行模糊查询
	 * 按照上传人进行模糊查询
	 */
	public Map<String, Object> queryByCase(Case view) {
		
		Connection conn=pool.getConnection();
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<Case> list = new ArrayList<Case>();			
	
		//拼装wheresql
		StringBuffer wheresql = new StringBuffer();
		if(!"".equals(view.getType())){		
			wheresql.append(" and type = '");
			wheresql.append(view.getType());
			wheresql.append("'");
		}
		if(!"".equals(view.getStatus())){		
			wheresql.append(" and status = '");
			wheresql.append(view.getStatus());
			wheresql.append("'");
		}
		if(!"".equals(view.getTitle())){		
			wheresql.append(" and title like '%");
			wheresql.append(view.getTitle());
			wheresql.append("%'");
		}
		if(!"".equals(view.getUpload_person())){		
			wheresql.append(" and upload_person like '%");
			wheresql.append(view.getUpload_person());
			wheresql.append("%'");
		}		
		//countSql 查询符合指定条件的总记录数。
		int count = 0;
		StringBuffer countSql = new StringBuffer();
		countSql.append("select count(*) from t_case where 1=1 ");
		countSql.append(wheresql);
		try {
			ps1 = conn.prepareStatement(countSql.toString());
			rs1 = ps1.executeQuery();
			if(rs1.next()){	
				count = rs1.getInt(1);
			}
			//如果查询结果不为空
			if(count>0){
				wheresql.append(" order by ");
				wheresql.append(view.getSort());
				wheresql.append(" ");
				wheresql.append(view.getSortType());

				//拼接获取符合指定条件的前 pageSize 条记录的sql
				StringBuffer sql = new StringBuffer();
				sql.append("select top ");
				sql.append(view.getPageSize());
				sql.append("  * FROM t_case where pk not in(select top ");
				sql.append(view.getPageSize()*(view.getShowPage()-1));
				sql.append(" pk from t_case where 1=1");
				sql.append(wheresql);
				sql.append(") ");
				sql.append(wheresql);
				ps2 = conn.prepareStatement(sql.toString());
				rs2 = ps2.executeQuery();
				list = changeResultSet(rs2);	
			}
		}catch (Exception e) {
			log.error("查询出错！",e);
			throw new RuntimeException("查询出错!",e);
		}finally{
			Tool.closeConnection(rs1, ps1, null);
			Tool.closeConnection(rs2, ps2, conn);
		} 
		map.put("count", count);		
		map.put("list",list);
		return map;
	}

		//在 "我的案例库"页面执行提交
		public void submit(String[] pk,String last_update_time) {
			changeStatus(pk, last_update_time, "submit");
		}
		//在 "我的案例库"页面执行撤回
		public void back(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "back");
		}
		//在 "待审核案例"页面执行批准
		public void approve(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "approve");
		}
		//在 "待审核案例"页面执行驳回
		public void reject(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "reject");
		}
		/*
		 * 更新案例的状态
		 */
		public void changeStatus(String pk[],String last_update_time,String action) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			
			StringBuffer sql = new StringBuffer();
			sql.append("update t_case set status=?,last_update_time=? where pk in(");	
			for (int i = 0; i < pk.length; i++) {
				sql.append("'");
				sql.append(pk[i]);
				sql.append("',");
			}
			sql.deleteCharAt(sql.length()-1);
			sql.append(")");
			try {
				ps = conn.prepareStatement(sql.toString());
				if("approve".equals(action)){		
					ps.setString(1, "4");//4 表示"审核通过"状态"
				}else if("reject".equals(action)){
					ps.setString(1, "2");//2表示"驳回"状态"
				}else if("submit".equals(action)){
					ps.setString(1, "3");//3 表示"待审核"状态"
				}else if("back".equals(action)){
					ps.setString(1, "1");//1 表示"保存"状态"
				}else{
					log.error("传入的参数有误，action="+action);
					throw new RuntimeException("传入的参数有误，action="+action);
				}
				ps.setString(2,last_update_time);
				ps.executeUpdate();
			} catch (SQLException e) {
				log.error("更新出错！",e);
				throw new RuntimeException("更新出错！",e);
			}finally{	
				Tool.closeConnection(null, ps, conn);
			}
		}
		/*
		 * 检验指定主键的记录是否是"保存"状态
		 */
		public boolean isSaveOrRejectStatus(String pk) {
			String status = null;
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT status FROM t_case");
			sql.append(" WHERE pk='");
			sql.append(pk);
			sql.append("'");
			try {	
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();
				if (rs.next()) {
					status = rs.getString("status");
				}
			} catch (Exception e) {
				log.error("查询出错！",e);
				throw new RuntimeException("查询出错！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 			
			if("1".equals(status)||"2".equals(status)){//1 表示"保存"状态；2表示驳回状态
				return true;
			}else{			
				return false;
			}
		}
		/*
		 * 检验指定主键的记录是否是"待审核"状态
		 */
		public boolean isSubmitStatus(String pk) {
			String status = null;
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			
			StringBuffer sql = new StringBuffer();
			sql.append("SELECT status FROM t_case");
			sql.append(" WHERE pk='");
			sql.append(pk);
			sql.append("'");
			try {	
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();
				if (rs.next()) {
					status = rs.getString("status");
				}
			} catch (Exception e) {
				log.error("查询出错！",e);
				throw new RuntimeException("查询出错！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 			
			if("3".equals(status)){//3 表示"待审核"状态
				return true;
			}else{			
				return false;
			}
		}
}
