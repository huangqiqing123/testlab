package cn.sdfi.user.cmd;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import cn.sdfi.framework.context.CommandContext;
import cn.sdfi.framework.db.Trans;
import cn.sdfi.framework.factory.ObjectFactory;
import cn.sdfi.tools.Const;
import cn.sdfi.tools.MD5;
import cn.sdfi.tools.Tool;
import cn.sdfi.user.bean.User;
import cn.sdfi.user.dao.UserDao;

public class UserCmd{

	UserDao userDao = (UserDao)ObjectFactory.getObject(UserDao.class.getName());	
	private Logger log = Logger.getLogger(UserCmd.class);

	/*
	 * 新增
	 */
	@Trans
	public String add() {
		
		String url = null;
		HttpServletRequest request = CommandContext.getRequest();
		User user = new User();
		user.setWho(request.getParameter("who"));
		user.setUsername(request.getParameter("username"));
		user.setPassword(request.getParameter("password"));
		user.setMylevel(request.getParameter("mylevel"));
		user.setSex(request.getParameter("sex"));
		user.setSkin(request.getParameter("skin"));
		user.setEntry_time(request.getParameter("entry_time"));
		user.setMemo(request.getParameter("memo"));
		user.setPageSize(10);

		userDao.save(user);

		request.setAttribute("msg","增加记录["+user.getUsername()+","+user.getWho()+"]成功！");
		String forward=request.getParameter("action");
		
		if("continue".equals(forward)){
			url = "user_add.jsp";
		}else{
			request.setAttribute("user.view", user);
			url="user_detail.jsp";
		}
		return url;
	}
	/*
	 * 修改
	 */
	@Trans
	public String update() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		String url = null;
		User user = new User();
		user.setWho(request.getParameter("who"));
		user.setUsername(request.getParameter("username"));
		String password = request.getParameter("password");
		if("是".equals(password)){
			
			//将密码重置为初始密码admin，此处在后台进行加密。
			password=MD5.getInstance().toMD5Str("admin");
		}else{
			password = request.getParameter("old_password");
		}
		user.setPassword(password);
		user.setMylevel(request.getParameter("mylevel"));
		user.setSex(request.getParameter("sex"));
		user.setSkin(request.getParameter("skin"));
		user.setEntry_time(request.getParameter("entry_time"));
		user.setMemo(request.getParameter("memo"));

		userDao.update(user);

		request.setAttribute("msg", "更新用户信息成功！");
		request.setAttribute("user.view", user);
		url="user_detail.jsp";
	
		return url;
	}
	/*
	 * 查询
	 */
	public String query() {
		
		HttpServletRequest request = CommandContext.getRequest();
	
		List<User> list = null;
		User user=new User();
		
		String sort=request.getParameter("sort");
		String sortType=request.getParameter("sortType");
		String username=request.getParameter("username");
		String who=request.getParameter("who");
		String sex=request.getParameter("sex");
		String mylevel=request.getParameter("mylevel");
		
		//空值处理
		if(sort==null)sort="who";	
		if(sortType==null)sortType="ASC";
		if(username==null)username="";
		if(who==null)who="";
		if(sex==null)sex="";
		if(mylevel==null)mylevel="";
		
		//将查询条件组合成对象
		user.setSort(sort);
		user.setSortType(sortType);
		user.setMylevel(mylevel);
		user.setSex(sex);
		user.setUsername(username);
		user.setWho(who);

		//执行查询，返回list
		list = userDao.queryByUser(user);

		//将查询条件放入request
		request.setAttribute("query_condition_sort", user.getSort());
		request.setAttribute("query_condition_sortType", user.getSortType());
		request.setAttribute("query_condition_username", user.getUsername());
		request.setAttribute("query_condition_who", user.getWho());
		request.setAttribute("query_condition_sex", user.getSex());
		request.setAttribute("query_condition_mylevel", user.getMylevel());
	
		int showPage =1;//showpage默认显示第1页
		int pageSize = 10;//每页显示记录数
		int select=1;//页面跳转至select页
		int recordCount = list.size(); //获取查询出的总记录数
		int pageCount = (recordCount % pageSize == 0) ? (recordCount / pageSize): (recordCount / pageSize + 1);//总页数


		//手工输入显示第几页的处理
		if (request.getParameter("showPage") != null&&!request.getParameter("showPage").equals("")){
			   try{
					//转换为整数，如果转换异常，说明用户输入的是非数字类型。
					request.setAttribute("showPage",request.getParameter("showPage"));
					showPage=Integer.parseInt(request.getParameter("showPage").trim());
					
					//如果用户输入负数或者不在页数范围内的数, -99=Integer.parseInt("-99")
					if(showPage<1||showPage>pageCount){
						request.setAttribute("msg","你输入的页数不存在！");
						request.setAttribute("pageCount",pageCount);//总页数
						request.setAttribute("recordCount",recordCount);//总记录数
						request.setAttribute("showPage",showPage);//当前是第多少页
						return "user_query.jsp";
					}
					}catch(Exception e){
						log.error(e);
						request.setAttribute("msg","请输入正整数！");
						request.setAttribute("pageCount",pageCount);//总页数
						request.setAttribute("recordCount",recordCount);//总记录数
						request.setAttribute("showPage",request.getParameter("showPage"));//当前是第多少页
						return "user_query.jsp";
					}
					
				}
				//对于第一页、上一页、下一页、最后一页的处理
				if (request.getParameter("view")!=null&&(!(request.getParameter("view").equals("")))){
					select = Integer.parseInt(request.getParameter("view"));
					showPage = Integer.parseInt(request.getParameter("currentPage"));
					switch (select) {
					case 1://如果是  第一页
						showPage = 1;
						request.setAttribute("showPage",showPage);
						break;
					case 2://如果是  上一页
						if (showPage == 1) {
					showPage = 1;
					request.setAttribute("showPage",showPage);
						} else {
					showPage--;
					request.setAttribute("showPage",showPage);
						}
						break;
					case 3://如果是  下一页
						if (showPage == pageCount) {
					showPage = pageCount;
					request.setAttribute("showPage",showPage);
						} else {
					showPage++;
					request.setAttribute("showPage",showPage);
						}
						break;
					case 4://如果是  最后一页
						showPage = pageCount;
						request.setAttribute("showPage",showPage);
						break;
					//default:
					}
				}
				//如果查询记录为空，则直接返回，不再进行分页计算。
				if(list.size()<1){
					
					// 处理从menu.jsp页面或者删除后进入查询页面，即使查询结果为空，也不必给出提示。
					String path = request.getParameter("path");
					if (!"menu.jsp".equals(path)&&!"after_delete".equals(path)) {		
						request.setAttribute("msg", "Sorry，无符合条件的记录！");
					}
					request.setAttribute("pageCount",pageCount);//总页数
					request.setAttribute("recordCount",recordCount);//总记录数
					request.setAttribute("showPage",showPage);//当前是第多少页
					return "user_query.jsp";
				}
				//显示第showPage页，起始记录：(showPage - 1) * pageSize 
				List<User> result=new ArrayList<User>();
				for (int k = (showPage - 1) * pageSize; k < (showPage - 1)* pageSize + pageSize; k++) {
					//对于最后一页的特殊处理，如果最后一页的记录数不到每页显示记录数(pageSize)，则不再继续执行add(list.get(k))
					if (k == recordCount){
						break;
					}else{
					result.add(list.get(k));	
					}
				}
				request.setAttribute("user_query_result", result);//将第showPage页结果放入request
				request.setAttribute("pageCount",pageCount);//总页数
				request.setAttribute("recordCount",recordCount);//总记录数
				request.setAttribute("showPage",showPage);//当前是第多少页

		return "user_query.jsp";
	}
	/*
	 * 修改密码
	 */
	@Trans
	public String changePassword() {
		
		HttpServletRequest request = CommandContext.getRequest();

		//密码合法性校验
		String password_old = request.getParameter("password_old");
		String password1 = request.getParameter("password1");
		String password2 = request.getParameter("password2");
		HttpSession session = request.getSession();

		if(password_old==null||"".equals(password_old.trim())){
			request.setAttribute("msg", "请输入原密码！");
		}
		else if (password1 == null || "".equals(password1.trim())) {
			request.setAttribute("msg", "密码不得为空！");
		}
		else if(!password1.equals(password2)) {
			request.setAttribute("msg", "两次输入的密码不一致！");
		}else if(!session.getAttribute("password").toString().trim().equals(password_old.trim())){
			request.setAttribute("msg", "您输入的原密码不正确！");
		}else
		{
			userDao.changePassword(request.getSession().getAttribute("username")+"", password1);
			session.setAttribute("password", password1);
			request.setAttribute("msg", "修改密码成功！");
		}
		return "changePassword.jsp";
	}

	/*
	 * 接收Ajax请求，检验用户输入的原密码是否正确。
	 */
	@Trans
	public String isCorrect() throws IOException {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		String password_old = request.getParameter("password_old");

		String old_correct_pwd = request.getSession().getAttribute("password").toString().trim();
		String new_pwd = password_old.trim();
		PrintWriter out = response.getWriter();
		
		if(old_correct_pwd.equals(new_pwd)){	
			out.write("ok");
		}else{
			out.print("not_ok");
		}
		return null;
	}
	/*
	 * 查询明细
	 */
	public String detail() {
	
		HttpServletRequest request = CommandContext.getRequest();
		String who = null;
		try {
			who = URLDecoder.decode(request.getParameter("pk"),"GBK");
		} catch (UnsupportedEncodingException e) {
			log.error(e);
			who = "superadmin";
		}
		User user = userDao.queryByWho(who);
		request.setAttribute("user.view", user);
		return "user_detail.jsp";

	}
	/*
	 * 执行更新前的查询
	 */
	public String forupdate() throws UnsupportedEncodingException {
	
		HttpServletRequest request = CommandContext.getRequest();
		String who = URLDecoder.decode(request.getParameter("pk"),"GBK");
		User user = userDao.queryByWho(who);
		request.setAttribute("user.view", user);
		return "user_update.jsp";
	}
	/*
	 * 接收Ajax请求，检验登录用户名和员工姓名是否已存在。
	 */
	public String isExist() throws IOException {
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		response.setHeader("Cache-Control", "no-store");//清除浏览器缓存
		response.setHeader("Pragma","no-cache");
		response.setDateHeader("Expires",0);
		
		User user=null;
		String value = request.getParameter("value");
		String which = request.getParameter("which");

		PrintWriter out = response.getWriter();
		
		//检验登录用户名
		if("username".equals(which)){
		
			user = userDao.queryByUsername(value);
			if(user.getUsername()!=null&&!"".equals(user.getUsername())){
				out.print("username,1");
			}else{
				out.print("username,0");
			}
		//检验员工姓名
		}else if("who".equals(which)){
		
			user = userDao.queryByWho(value);
			if(user.getWho()!=null&&!"".equals(user.getWho())){
				out.print("who,1");
			}else{
				out.print("who,0");
			}
		}else{
			log.error("接收的Ajax请求有误，which="+which);
			throw new RuntimeException("接收的Ajax请求有误，which="+which);
		}	
		return null;
	}
	/*
	 * 注销处理
	 */
	@Trans
	public String logout() {
		
		HttpServletRequest request = CommandContext.getRequest();
		
		// 如果用户直接关闭浏览器，则不再进行页面跳转。
		// 如果用户点击【注销】，则跳转至登陆页面。
		String path = request.getParameter("path");
		HttpSession session = request.getSession();

		// 如果会话已失效，则不再进行注销处理。
		if (session == null || session.getAttribute("username") == null) {
			if ("closeIE".equals(path)) {
				return null;
			} else {
				return "login.jsp";
			}
		}
		// 执行注销操作
		else {
			session.invalidate();

			// 如果是执行的关闭IE
			if ("closeIE".equals(path)) {
				return null;
			}
			// 如果是点击的【安全退出】
			else {
				return "login.jsp";
			}
		}
	}

	/*
	 * 切换皮肤
	 */
	@Trans
	public String changeSkin() {

		HttpServletRequest request = CommandContext.getRequest();
		
		String newskin = request.getParameter("skin");
		userDao.changeSkin(request.getSession().getAttribute("username")+"", newskin);
		request.getSession().setAttribute("skin", newskin);
		return "main.jsp?path=changeSkin";
	}

	// 处理用户登录
	@Trans
	@SuppressWarnings("unchecked")
	public String login() {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();

		// 接收用户登录信息
		String checknumber = request.getParameter("checkNumber");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		HttpSession session = request.getSession();
		
		//用户名非空检查
		if (username==null||"".equals(username)) {
			request.setAttribute("msg", "用户名不能为空！");
			request.setAttribute("username", username);
			return "login.jsp";
		}
		//密码非空检查
		if (password==null||"".equals(password)) {
			request.setAttribute("msg", "请输入密码！");
			request.setAttribute("username", username);
			return "login.jsp";
		}
		//验证码非空检查
		if (checknumber==null||"".equals(checknumber)) {
			request.setAttribute("msg", "请输入验证码！");
			request.setAttribute("username", username);
			return "login.jsp";
		}
		
		//验证码正确性检查
		if (!checknumber.equals(session.getAttribute("rand"))) {
			request.setAttribute("msg", "验证码不正确，请重新输入！");
			request.setAttribute("username", username);
			return "login.jsp";
		}
		
		String msg = userDao.loginProcess(username, password);
		request.setAttribute("msg", msg);
		
		// 如果成功登陆、、、、、、
		if (msg.contains("成功")) {

			// 登陆用户session处理
			Map<String, HttpSession> sessions = Const.getOnlineUserSessionMap();	
			if (sessions == null) {
				sessions = new HashMap<String, HttpSession>();
				Const.setOnlineUserSessionMap(sessions);
			} else {
				// 判断该用户是否已经登录，如果已经在线，则将先登录的用户的session注销，然后从容器中删除该用户的session
				HttpSession loginsession = sessions.get(username);
				// 如果该用户已经登陆，则注销已经登陆的会话
				if (loginsession != null) {
					try {
						loginsession.invalidate();
					} catch (Exception e) {
						log.error(e);
					}
				}
				// 如果该用户已经登陆，则从容器中删除该用户的会话
				if (sessions.containsKey(username)) {
					sessions.remove(username);
				}
			}
			// 将新登陆的用户session放入容器中。
			User user = userDao.queryByUsername(username);
			sessions.put(user.getUsername(), session);


			// 存储在线用户
			Map<String, User> map = Const.getOnlineUserMap();	
			if (map == null) {
				map = new HashMap<String, User>();
				Const.setOnlineUserMap(map);
			} else {
				
				// 判断该用户是否已在线，则将其从容器中删除，将新登陆的该用户信息放入容器
				if (map.containsKey(user.getUsername())) {
					map.remove(user.getUsername());
				}
			}
			user.setLoginTime(Tool.getDateTime());//登陆时间
			user.setIp(request.getRemoteAddr());//登陆机器IP			
			map.put(user.getUsername(), user);

			// 将登陆用户名、级别、皮肤信息存放到session中
			session.setAttribute("username", user.getUsername());
			session.setAttribute("who", user.getWho());
			session.setAttribute("mylevel", user.getMylevel());
			session.setAttribute("skin", user.getSkin());
			session.setAttribute("password", user.getPassword());
			session.setAttribute("pageSize", user.getPageSize());
			
			//判断用户是否选择“记住用户名和密码”，如果不为null，则表示用户选择了“记住”
			String remember = request.getParameter("remember");
			Cookie cookie_username = null;
			Cookie cookie_password = null;
			try {
				cookie_username = new Cookie("username",URLEncoder.encode(user.getUsername(),"GBK"));		
				cookie_password = new Cookie("password",user.getPassword());
				
				if(remember==null){//删除该用户的cookie		
					cookie_username.setMaxAge(0); //存活期为0表示删除该Cookie
					cookie_password.setMaxAge(0); //存活期为0表示删除该Cookie
				}else{//保存该用户信息的cookie
					cookie_username.setMaxAge(360*24*60*60); //存活期为360天
					cookie_password.setMaxAge(360*24*60*60); //存活期为360天
				}		
				response.addCookie(cookie_password); 
				response.addCookie(cookie_username); 
				
			} catch (UnsupportedEncodingException e) {
				log.error("URLEncoder.encode转换中文GBK编码时出错！"+e);
				throw new RuntimeException("URLEncoder.encode转换中文GBK编码时出错！"+e);
			} 		
			log.debug(user.getUsername()+" 登陆成功！登陆IP："+user.getIp());
			return "main.jsp";
		}
		//如果登录失败
		else 
		{
			request.setAttribute("username", username);
			return "login.jsp";
		}
	}

	/*
	 * 管理员强制断开某个会话
	 */
	@Trans
	public String outSession() {
		
		HttpServletRequest request = CommandContext.getRequest();

		// 接收要被强制注销的会话所对应的用户名
		String username = null;
		try {
			username = URLDecoder.decode(request.getParameter("username"),"GBK");
		} catch (UnsupportedEncodingException e) {
			log.error(e);
		}
		
		// 从ServletContext()中取出存有登陆用户会话的容器HashMap
		Map<String, HttpSession> sessions = Const.getOnlineUserSessionMap();
		// 根据该用户名取出其对应的会话
		HttpSession session = sessions.get(username);
		try {
			// 注销该会话
			if (session != null && session.getAttribute("username") != null) {
				session.invalidate();
			}
			// 从容器中删除该会话
			if (sessions.containsKey(username)) {
				sessions.remove(username);
			}
		} catch (Exception e) {
			log.debug("用户[" + username + "]已下线！");
		}
		log.debug("用户[" + username + "]被管理员强制注销！");
		return "showOnLineUsers.jsp";
	}
	/*
	 * 删除操作
	 */
	@Trans
	public String delete() throws IOException {
		
		HttpServletRequest request = CommandContext.getRequest();
		HttpServletResponse response = CommandContext.getResponse();
		
		String url=null;
		String[] who = request.getParameterValues("pk");
		userDao.batchDeleteByWho(who);
		
		//如果是在查询页面执行删除
		request.setAttribute("msg", "删除 " + who.length + " 条记录成功！");
		url="userdo.do?method=query&path=after_delete";
		
		//如果是在明细页面执行删除
		String path = request.getParameter("path");
		if("user_detail.jsp".equals(path)){
			PrintWriter out = response.getWriter();
			out.print("删除1条记录成功！");
			url=null;
		}
		return url;
	}
}
