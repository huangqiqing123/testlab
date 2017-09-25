package cn.sdfi.project.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

import cn.sdfi.project.bean.Project;
import cn.sdfi.tools.ConnectionPool;
import cn.sdfi.tools.Tool;

public class ProjectDao{

	private ConnectionPool pool=ConnectionPool.getInstance();
	private Logger log = Logger.getLogger(ProjectDao.class);
	/*
	 * 执行保存
	 */
	public void save(Project view){

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		String sql = "insert into t_project(pk,code,name,devmanager,testmanager,begintime,endtime,memo,project_year,state,project_type,tester,isLabProject,project_customer)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		try{
			ps = conn.prepareStatement(sql);
			ps.setString(1, view.getPk());
			ps.setString(2, view.getCode());
			ps.setString(3, view.getName());
			ps.setString(4, view.getDevmanager());
			ps.setString(5, view.getTestmanager());
			ps.setString(6, view.getBegintime());
			ps.setString(7, view.getEndtime());
			ps.setString(8, view.getMemo());
			ps.setString(9, view.getYear());
			ps.setString(10, view.getState());
			ps.setString(11, view.getProject_type());
			ps.setString(12, view.getTester());
			ps.setString(13, view.getIsLabProject());
			ps.setString(14, view.getProject_customer());
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
	public Project queryByPK(String pk) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		Project view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_project");
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
	/*
	 * 根据项目编号查询
	 */
	public Project queryByCode(String code) {

		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Project view = null;
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT * FROM t_project");
		sql.append(" WHERE code='");
		sql.append(code);
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
	/*
	 * 检查指定的项目编号是否已存在
	 */
	public boolean isExist(String project_code) {
		boolean flag = false;
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		String sql = "SELECT * FROM t_project WHERE code=?";
		try {
			ps = conn.prepareStatement(sql);
			ps.setString(1, project_code);
			rs = ps.executeQuery();
			if(rs.next()){
				flag=true;
			}
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{	
			Tool.closeConnection(rs, ps, conn);
		}
		return flag;
	}

	/*
	 * 把 ResultSet 纪录封装到 list 中
	 */
	private List<Project> changeResultSet(ResultSet rs) {
		List<Project> list = new ArrayList<Project>();
		Project view = null;
		if (rs == null) {
			return list;
		}
		try {
			while (rs.next()) {
				view = new Project();
				view.setPk(rs.getString("pk"));
				view.setCode(rs.getString("code"));
				view.setName(rs.getString("name"));
				view.setDevmanager(rs.getString("devmanager"));
				view.setTestmanager(rs.getString("testmanager"));
				view.setBegintime(rs.getString("begintime"));
				view.setEndtime(rs.getString("endtime"));
				view.setMemo(rs.getString("memo"));
				view.setYear(rs.getString("project_year"));
				view.setState(rs.getString("state"));
				view.setProject_type(rs.getString("project_type"));
				view.setTester(rs.getString("tester"));
				view.setIsLabProject(rs.getString("isLabProject"));
				view.setProject_customer(rs.getString("project_customer"));
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

		StringBuffer sql = new StringBuffer();
		sql.append("delete from t_project where pk in(");
		for (int i = 0; i < pk.length; i++) {
			sql.append("'");
			sql.append(pk[i]);
			sql.append("'");
			sql.append(",");
		}
		sql.deleteCharAt(sql.length()-1);
		sql.append(")");
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
	 * 结果集到实体对象的转换
	 */
	private Project changeRsToView(ResultSet rs) throws SQLException {	
		Project view = new Project();
		if (rs.next()) {
			view.setPk(rs.getString("pk"));
			view.setCode(rs.getString("code"));
			view.setName(rs.getString("name"));
			view.setDevmanager(rs.getString("devmanager"));
			view.setTestmanager(rs.getString("testmanager"));
			view.setBegintime(rs.getString("begintime"));
			view.setEndtime(rs.getString("endtime"));
			view.setMemo(rs.getString("memo"));
			view.setYear(rs.getString("project_year"));
			view.setState(rs.getString("state"));
			view.setProject_type(rs.getString("project_type"));
			view.setTester(rs.getString("tester"));
			view.setIsLabProject(rs.getString("isLabProject"));
			view.setProject_customer(rs.getString("project_customer"));
		}
		return view;
	}
	/*
	 * 接收一个 Project 对象作为查询条件，查询结果将以 Map 的形式返回。
	 * map中第一个元素是count，存储的是符合条件的总记录数（类型：String）
	 * map中第二个元素是list，存储的是符合条件的前pageSize条记录（类型：List）
	 */
	public Map<String, Object> queryByProject(Project view) {
		Connection conn=pool.getConnection();
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		List<Project> list = new ArrayList<Project>();	
		String wheresql = this.getWhereSql(view);

		//countSql 查询符合指定条件的总记录数。
		int count = 0;
		StringBuffer countSql = new StringBuffer();
		countSql.append("select count(*) from t_project where 1=1 ");
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
				sql.append("  * FROM t_project where pk not in(select top ");
				sql.append(view.getPageSize()*(view.getShowPage()-1));
				sql.append(" pk from t_project where 1=1");
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
	/*
	 * 导出excel
	 */
		public List<Project> export(Project view) {
			Connection conn=pool.getConnection();
			PreparedStatement ps = null;
			ResultSet rs = null;
			List<Project> list = new ArrayList<Project>();
			StringBuffer sql = new StringBuffer();
			String wheresql = this.getWhereSql(view);
			sql.append("select * FROM t_project where 1=1");
			sql.append(wheresql);
			sql.append(" order by ");
			sql.append(view.getSort());
			sql.append(" ");
			sql.append(view.getSortType());
			try {
				ps = conn.prepareStatement(sql.toString());
				rs = ps.executeQuery();
				list = changeResultSet(rs);
			} catch (Exception e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}finally{
				Tool.closeConnection(rs, ps, conn);
			} 
			return list;
		}
		
		//获取查询sql语句
		private String getWhereSql(Project view){
			/*
			 * 按照 项目编号code、项目名称name、测试经理testmanager进行模糊查询
			 * 按照 年度project_year 、是否实验室项目isLabProject、状态state、类型project_type、客户project_customer进行精确查询
			 */
			StringBuffer wheresql = new StringBuffer();
			if(!"".equals(view.getYear())){		
				wheresql.append(" and project_year = '");
				wheresql.append(view.getYear());
				wheresql.append("'");
			}
			if(!"".equals(view.getIsLabProject())){		
				wheresql.append(" and isLabProject = '");
				wheresql.append(view.getIsLabProject());
				wheresql.append("'");
			}
			if(!"".equals(view.getState())){		
				wheresql.append(" and state = '");
				wheresql.append(view.getState());
				wheresql.append("'");
			}
			if(!"".equals(view.getProject_type())){		
				wheresql.append(" and project_type = '");
				wheresql.append(view.getProject_type());
				wheresql.append("'");
			}
			if(!"".equals(view.getProject_customer())){		
				wheresql.append(" and project_customer = '");
				wheresql.append(view.getProject_customer());
				wheresql.append("'");
			}	
			if(!"".equals(view.getCode())){		
				wheresql.append(" and code like '%");
				wheresql.append(view.getCode());
				wheresql.append("%'");
			}
			if(!"".equals(view.getName())){		
				wheresql.append(" and name like '%");
				wheresql.append(view.getName());
				wheresql.append("%'");
			}	
			if(!"".equals(view.getTestmanager())){		
				wheresql.append(" and testmanager like '%");
				wheresql.append(view.getTestmanager());
				wheresql.append("%'");
			}	
			return wheresql.toString();
		}
	/*
	 * 更新
	 */
	public void update(Project project) {
		
		Connection conn=pool.getConnection();
		PreparedStatement ps = null;
		String sql = "update t_project set name=?,devmanager=?,tester=?,testmanager=?,begintime=?,endtime=?,project_year=?,memo=?,state=?,project_type=?,isLabProject=?,code=?,project_customer=? where pk=?";
		try {
			ps = conn.prepareStatement(sql.toString());
			ps.setString(1,project.getName());
			ps.setString(2,project.getDevmanager());
			ps.setString(3,project.getTester());
			ps.setString(4,project.getTestmanager());
			ps.setString(5,project.getBegintime());
			ps.setString(6,project.getEndtime());
			ps.setString(7,project.getYear());
			ps.setString(8,project.getMemo());
			ps.setString(9,project.getState());
			ps.setString(10,project.getProject_type());
			ps.setString(11,project.getIsLabProject());
			ps.setString(12,project.getCode());
			ps.setString(13,project.getProject_customer());
			ps.setString(14,project.getPk());
			ps.executeUpdate();
		} catch (SQLException e) {
			log.error("出错了！",e);
			throw new RuntimeException("出错了！",e);
		}finally{
			Tool.closeConnection(null, ps, conn);
		}
	}
}
