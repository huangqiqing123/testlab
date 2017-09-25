package cn.sdfi.product.cmd;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.product.bean.Product;
import cn.sdfi.product.dao.ProductDao;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.UUIDGenerator;
import cn.sdfi.user.dao.UserDao;

public class ProductCmd{

	ProductDao dao = (ProductDao)ObjectFactory.getObject(ProductDao.class.getName());
	private Logger log = Logger.getLogger(ProductCmd.class);

	/*
	 * 判断是否被引用，如果存在被引用的记录，则不允许删除。
	 */
	public String isInUse() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
	
		response.setHeader("Cache-Control", "no-store");
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		//接收信息
		String[] pk = request.getParameterValues("pk");
		
		//检查所有pks，并将所有‘已被引用’状态的pk放到list中
		List<String> inUsePks = new ArrayList<String>();
		for (int i = 0; i < pk.length; i++) {			
			if(dao.isInUse(pk[i])){
				inUsePks.add(pk[i]);	
			}	
		}
		//如果包含有非"待审核"状态的记录
		if(inUsePks.size()>0){
			StringBuffer names = new StringBuffer();
			for (int i = 0; i < inUsePks.size(); i++) {
				names.append(dao.queryByPK(inUsePks.get(i)).getName());
				names.append(",");
			}
			names.deleteCharAt(names.length()-1);
			
			try{	
				PrintWriter out = response.getWriter();
				out.print(names);
			} catch (IOException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}
		}else{	
			try{	
				PrintWriter out = response.getWriter();
				out.print("ok");//如果使用out.println()，前台接收后，用==号比较会不相等。
			} catch (IOException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}
		}
		return null;
	}
	/*
	 * 删除操作
	 */
	public String delete() {
	
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		String url=null;
		String[] pks = request.getParameterValues("pk");
		dao.batchDeleteByPK(pks);
		
		request.setAttribute("msg", "删除 " + pks.length + " 条记录成功！");
		url="productdo.do?method=query";
		
		//如果是在明细页面执行删除
		String path = request.getParameter("path");
		if("product_detail.jsp".equals(path)){
			try {
				PrintWriter out = response.getWriter();
				out.print("删除1条记录成功！");
			} catch (IOException e) {
				log.error("出错了！",e);
				throw new RuntimeException("出错了！",e);
			}	
			url=null;
		}
		return url;
	}

	/*
	 * 更新
	 */
	public String update() {
		HttpServletRequest request = CommandContext.getRequest();
		String url = "product_detail.jsp";
		Product product = new Product();
		product.setPk(request.getParameter("pk"));
		product.setSortCode(Integer.parseInt(request.getParameter("sortCode").trim()));
		product.setName(request.getParameter("name").trim());
		product.setDept(request.getParameter("dept").trim());
		dao.update(product);	
		request.setAttribute("msg","产品信息更新成功！");
		request.setAttribute("product.view", product);
		return url;
	}

	/*
	 * 查询明细
	 */
	public String detail() {
	
		HttpServletRequest request = CommandContext.getRequest();
		String pk = request.getParameter("pk");
		Product product = dao.queryByPK(pk);
		request.setAttribute("product.view", product);
		return "product_detail.jsp";

	}
	/*
	 * 更新前的查询
	 */
	public String forupdate() {
	
		HttpServletRequest request = CommandContext.getRequest();
		String pk = request.getParameter("pk");
		Product product = dao.queryByPK(pk);
		request.setAttribute("product.view", product);
		return "product_update.jsp";

	}

	/*
	 * 查询
	 */
	public String query() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		//如果指定了排序字段，则按照指定的字段进行排序，如果未指定，则默认按照项目开始时间降序排列。
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String pageSize=request.getParameter("pageSize");
		String dept=request.getParameter("dept");
		String name=request.getParameter("name");
			
		//空值处理
		if(sort==null)sort="sortCode";	
		if(sortType==null)sortType="ASC";
		if(dept==null)dept="";
		if(name==null)name="";
		if(pageSize==null||"".equals(pageSize)){
			pageSize=request.getSession().getAttribute("pageSize").toString();
		}else{
			//如果用户的pageSize发生改变，则同步更新session中的pageSize和数据库中的pageSize
			if(!pageSize.equals(request.getSession().getAttribute("pageSize").toString())){
				request.getSession().setAttribute("pageSize", pageSize);
				UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());
				userDao.changePageSize(CommandContext.getSession().getAttribute("username")+"", pageSize);
			}
		}		
		//将查询条件组合成对象
		Product query_condition=new Product();
		query_condition.setSort(sort.trim());
		query_condition.setSortType(sortType.trim());
		query_condition.setPageSize(Integer.parseInt(pageSize));
		query_condition.setDept(dept.trim());
		query_condition.setName(name.trim());
		
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
		Map<String,Object> map = dao.queryByProduct(query_condition);
		List<Product> list = (List<Product>)map.get("list");
		
		//将查询结果放入request
		request.setAttribute("product_query_result", list);
		
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
		return "product_query.jsp";
	}

	/*
	 * 新增
	 */
	@Trans
	public String add() {
		HttpServletRequest request = CommandContext.getRequest();
		String url = null;
		String pk=UUIDGenerator.getRandomUUID();
		Product product = new Product();
		product.setPk(pk);
		product.setSortCode(Integer.parseInt(request.getParameter("sortCode").trim()));
		product.setName(request.getParameter("name").trim());
		product.setDept(request.getParameter("dept").trim());

		dao.save(product);

		Map<String,String> project_customers = Const.getEnumMap().get("project_customer");
		request.setAttribute("msg","增加记录[产品编号:"+product.getSortCode()+",产品名称:"+product.getName()+",所属部门:"+project_customers.get(product.getDept())+"]成功！");
		String forward=request.getParameter("action");
		
		if("continue".equals(forward)){
			url = "product_add.jsp";
		}else{
			request.setAttribute("product.view", product);
			url="product_detail.jsp";
		}
		return url;
	}
}
