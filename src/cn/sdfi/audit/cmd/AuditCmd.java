package cn.sdfi.audit.cmd;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import cn.sdfi.audit.bean.Audit;
import cn.sdfi.audit.dao.AuditDao;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.user.dao.UserDao;

public class AuditCmd{
	
	private AuditDao auditDao = (AuditDao)ObjectFactory.getObject(AuditDao.class.getName());
	private UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());

	/*
	 * 删除操作
	 */
	@Trans
	public String delete() {
		String url = null;	
		HttpServletRequest request = CommandContext.getRequest();
		String[] pks = request.getParameterValues("pk");
		auditDao.batchDeleteByPK(pks);
		
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		url = "auditdo.do?method=query";
		
		return url;
	}
	/*
	 * 清空审计表
	 */
	@Trans
	public String deleteAll() {

		HttpServletRequest request = CommandContext.getRequest();
		auditDao.deleteAll();
		
		request.setAttribute("msg", "清空审计表成功！");
		return "auditdo.do?method=query";
	}
	/*
	 * 查询
	 */
	public String query() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpSession session = request.getSession();
			
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照时间倒序。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String accessTimeBegin=request.getParameter("accessTimeBegin");
		String accessTimeEnd=request.getParameter("accessTimeEnd");
		String username=request.getParameter("username");
		String url=request.getParameter("url");

		//空值处理
		if(sort==null)sort="accessTime";	
		if(sortType==null)sortType="DESC";
		if(accessTimeBegin==null)accessTimeBegin="";
		if(accessTimeEnd==null)accessTimeEnd="";
		if(username==null)username="";
		if(url==null)url="";
		if(pageSize==null||"".equals(pageSize)){
			pageSize=request.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(request.getSession().getAttribute("pageSize").toString())){
				request.getSession().setAttribute("pageSize", pageSize);
				userDao.changePageSize(session.getAttribute("username")+"", pageSize);
			}
		}						
		//将查询条件组合成对象
		Audit query_condition = new Audit();
		query_condition.setUsername(username.trim());
		query_condition.setAccessTimeBegin(accessTimeBegin.trim());
		query_condition.setAccessTimeEnd(accessTimeEnd.trim());
		query_condition.setUrl(url.trim());
		query_condition.setSort(sort);
		query_condition.setSortType(sortType);
		query_condition.setPageSize(Integer.parseInt(pageSize));
		
		//分页
		int showPage =1;//showpage默认显示第1页
		
		//如果是手工输入显示第几页
		if (request.getParameter("showPage") != null&&!"".equals(request.getParameter("showPage"))){		
			showPage=Integer.parseInt(request.getParameter("showPage").trim());
		
		//如果是点击翻页按钮
		}else if (request.getParameter("view")!=null&&(!(request.getParameter("view").equals("")))){

			int select=1;//1代表第一页、2代表上一页、3代表下一页、4代表最后一页，默认显示第一页
			int oldPageCount = Integer.parseInt(request.getParameter("pageCount"));
			select = Integer.parseInt(request.getParameter("view"));
			showPage = Integer.parseInt(request.getParameter("currentPage"));

			if(select==1){
				showPage = 1;
			}else if(select==2){
				if (showPage == 1) {
					showPage = 1;
				} else {
					showPage--;
				}
			}else if(select==3){
				if (showPage == oldPageCount) {
					showPage = oldPageCount;
				} else {
					showPage++;
				}
			}else if(select==4){
				showPage = oldPageCount;
			}else{
				showPage = 1;
			}
		}
		//执行查询，返回Map
		query_condition.setShowPage(showPage);
		Map<String,Object> map = auditDao.queryAudit(query_condition);
		List<Audit> list = (List<Audit>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("audit_query_result", list);
		
		// 将查询条件放入request
		int newRecordCount = Integer.parseInt(map.get("count").toString());
		int newPageCount = (newRecordCount % query_condition.getPageSize() == 0) ? (newRecordCount / query_condition.getPageSize()): (newRecordCount / query_condition.getPageSize() + 1);
		query_condition.setRecordCount(newRecordCount); //总记录数
		query_condition.setPageCount(newPageCount);//总页数
		request.setAttribute("query_condition",query_condition);

		//如果查询结果为空
		if(newRecordCount<1){				
			request.setAttribute("msg", "Sorry，无符合条件的记录！");
		}
		return "audit_query.jsp";
	}
}
