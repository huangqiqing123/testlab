package cn.sdfi.know.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.know.bean.Know;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class KnowDao{
	
	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(KnowDao.class);
	
	/*
	 * 执行保存
	 */
	public void save(Know view) {	
		StringBuffer sql = new StringBuffer();
		sql.append("insert into t_know(pk,title,type,status,version,upload_person,upload_time,last_update_time,blob_name,pages,memo)values(?,?,?,?,?,?,?,?,?,?,?)");
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getPk());
			ps.setString(2, view.getTitle());
			ps.setString(3, view.getType());
			ps.setString(4, view.getStatus());
			ps.setString(5, view.getVersion());
			ps.setString(6, view.getUpload_person());
			ps.setString(7, view.getUpload_time());
			ps.setString(8, view.getLast_update_time());
			ps.setString(9, view.getBlob_name());
			ps.setString(10, view.getPages());
			ps.setString(11, view.getMemo());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{		
			Tool.closeConnection(null, ps, conn);
		}	
	}
	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<Know> changeResultSet(ResultSet rs) {
		
		List<Know> list=new ArrayList<Know>();
		if (rs==null) {
			return list;
		}
		try {
			while(rs.next()){			
				Know view=new Know();
				view.setPk(rs.getString("pk"));
				view.setTitle(rs.getString("title"));
				view.setType(rs.getString("type"));
				view.setStatus(rs.getString("status"));
				view.setUpload_person(rs.getString("upload_person"));
				view.setUpload_time(rs.getString("upload_time"));
				view.setLast_update_time(rs.getString("last_update_time"));
				view.setBlob_name(rs.getString("blob_name"));
				view.setVersion(rs.getString("version"));
				view.setPages(rs.getString("pages"));
				view.setMemo(rs.getString("memo"));
				list.add(view);	
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}
		return list;
	}
	
	/*
	 * 按照主键批量删除
	 */
	public void batchDeleteByPk(String [] pk){

		StringBuffer titles = new StringBuffer();
		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_know where pk in (");
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

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
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
 * 修改
 */
	public void update(Know view){
		StringBuffer sql = new StringBuffer();
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		try {
		if(view.getBlob_name()==null||"".equals(view.getBlob_name())){
			sql.append("update t_know set title=?,type=?,status=?,last_update_time=?,version=?,pages=?,memo=? where pk=?");	
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getTitle());
			ps.setString(2, view.getType());
			ps.setString(3, view.getStatus());
			ps.setString(4, view.getLast_update_time());
			ps.setString(5, view.getVersion());
			ps.setString(6, view.getPages());
			ps.setString(7, view.getMemo());
			ps.setString(8, view.getPk());
		}else{		
			sql.append("update t_know set title=?,type=?,status=?,last_update_time=?,blob_name=?,version=?,pages=?,memo=? where pk=?");	
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1, view.getTitle());
			ps.setString(2, view.getType());
			ps.setString(3, view.getStatus());
			ps.setString(4, view.getLast_update_time());
			ps.setString(5, view.getBlob_name());
			ps.setString(6, view.getVersion());
			ps.setString(7, view.getPages());
			ps.setString(8, view.getMemo());
			ps.setString(9, view.getPk());
		}
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
	public Know changeRsToView(ResultSet rs) {		
		Know view = new Know();
		try {
			if (rs.next()) {
				view.setPk(rs.getString("pk"));
				view.setTitle(rs.getString("title"));
				view.setType(rs.getString("type"));
				view.setStatus(rs.getString("status"));
				view.setUpload_person(rs.getString("upload_person"));
				view.setUpload_time(rs.getString("upload_time"));
				view.setLast_update_time(rs.getString("last_update_time"));
				view.setBlob_name(rs.getString("blob_name"));
				view.setVersion(rs.getString("version"));
				view.setPages(rs.getString("pages"));
				view.setMemo(rs.getString("memo"));
			}		
		} catch (Exception e) {
			log.error("转换bean出错！",e);
			throw new RuntimeException("转换bean出错！",e);
		}
		return view;
	}
	/*
	 * 按照主键进行查询
	 */
	public Know queryByPK(String pk) {
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Know view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_know");
		sql.append(" WHERE pk='");
		sql.append(pk);
		sql.append("'");
		try {	
			ps = conn.prepareStatement(sql.toString());
			rs = ps.executeQuery();
			view = changeRsToView(rs);	
		} catch (Exception e) {
			log.error("查询出错！",e);
			throw new RuntimeException("查询出错！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return view;
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
			ps = conn.prepareStatement("SELECT pk FROM t_know");
			rs = ps.executeQuery();
			while(rs.next()){	
				pks.add(rs.getString("pk"));
			}
		} catch (Exception e) {
			log.error("查询出错！",e);
			throw new RuntimeException("查询出错！",e);
		}finally{
			Tool.closeConnection(rs, ps, conn);
		} 
		return pks;
	}
	/*
	 * 接收一个 Know 对象作为查询条件，查询结果将以 Map 的形式返回。
	 * map中第一个元素是count，存储的是符合条件的总记录数（类型：String）
	 * map中第二个元素是list，存储的是符合条件的前十条记录（类型：List）
	 */
		public Map<String, Object> queryByKnow(Know view) {
		
			Connection conn=pool.getConnection();
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			
			PreparedStatement ps2 = null;
			ResultSet rs2 = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			List<Know> list = new ArrayList<Know>();			
		
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
			countSql.append("select count(*) from t_know where 1=1 ");
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
					sql.append("  * FROM t_know where pk not in(select top ");
					sql.append(view.getPageSize()*(view.getShowPage()-1));
					sql.append(" pk from t_know where 1=1");
					sql.append(wheresql);
					sql.append(") ");
					sql.append(wheresql);
					ps2 = conn.prepareStatement(sql.toString());
					rs2 = ps2.executeQuery();
					list = changeResultSet(rs2);
				}
			}catch (Exception e) {
				log.error("查询出错！",e);
				throw new RuntimeException("查询出错！",e);
			}finally{
				Tool.closeConnection(rs1, ps1, null);
				Tool.closeConnection(rs2, ps2, conn);
			} 
			map.put("count", count);		
			map.put("list",list);
			return map;
		}
		
		//在 "我的知识库"页面执行提交
		public void submit(String[] pk,String last_update_time) {
			changeStatus(pk, last_update_time, "submit");
		}
		//在 "我的知识库"页面执行撤回
		public void back(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "back");
		}
		//在 "待审核知识"页面执行批准
		public void approve(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "approve");
		}
		//在 "待审核知识"页面执行驳回
		public void reject(String pk[],String last_update_time) {
			changeStatus(pk, last_update_time, "reject");
		}
		/*
		 * 更新知识的状态
		 */
		public void changeStatus(String pk[],String last_update_time,String action) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			
			StringBuffer sql = new StringBuffer();
			sql.append("update t_know set status=?,last_update_time=? where pk in(");	
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
					ps.setString(1, "2");//2 表示"驳回"状态"
				}else if("submit".equals(action)){
					ps.setString(1, "3");//3 表示"待审核"状态"
				}else if("back".equals(action)){
					ps.setString(1, "1");//1 表示"保存"状态"
				}else{
					log.error("传入参数有误！action="+action);
					throw new RuntimeException("传入参数有误！action="+action);
				}
				ps.setString(2,last_update_time);
				ps.executeUpdate();
			} catch (SQLException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
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
			sql.append("SELECT status FROM t_know");
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
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 			
			if("1".equals(status)||"2".equals(status)){//1表示"保存"状态；2表示驳回状态
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
			sql.append("SELECT status FROM t_know");
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
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 			
			if("3".equals(status)){//3 表示"待审核"状态
				return true;
			}else{			
				return false;
			}
		}
		/*
		 * 智能提示
		 * 部门知识库--普通用户 -----》审核通过,4表示审核通过状态
		 * 部门知识库--管理员  -----》所有状态
		 * 个人知识库--不区分管理员和普通用户---》上传人、所有状态
		 * 待审核文件--待审核状态,3 表示"待审核"状态
		 */
		public List<String> suggest(String title,String status,String upload_person) { 
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			List<String> list = new ArrayList<String>();	
			StringBuffer sql = new StringBuffer();
			sql.append("select top 10 blob_name from t_know where 1=1 ");
			
			if(!"".equals(title)&&title!=null){		
				sql.append(" and title like '%");
				sql.append(title);
				sql.append("%'");
			}
			
			if(!"".equals(status)&&status!=null){		
				sql.append(" and status = '");
				sql.append(status);
				sql.append("'");
			}

			if(!"".equals(upload_person)&&upload_person!=null){		
				sql.append(" and upload_person ='");
				sql.append(upload_person);
				sql.append("'");
			}		
			sql.append(" order by last_update_time desc");
			try {
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();			
				while(rs.next()){						
					list.add(rs.getString("blob_name"));	
				}
			}catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 		
			return list;
		}
		
		//noPageQueryByStauts
		public List<Know> noPageQueryByStauts(String status) { 
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			
			List<Know> list = new ArrayList<Know>();	
			String sql = "select * from t_know where status='"+status+"'";
			try {
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				list = changeResultSet(rs);
			}catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return list;
		}
}
