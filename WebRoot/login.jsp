<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="cn.sdfi.user.bean.User"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.user.dao.UserDao"%><HTML>
<HEAD>
<TITLE>浪潮软件评测实验室文档管理系统</TITLE>
<SCRIPT language="javascript">

	//点击刷新验证码
	function refresh(obj) {

		//IE7、IE8下，需要给url传一个随机数，否则点击验证码不会刷新，原因在于ie7，firefox的缓存机制和ie6不同：由于js指定的src与原来图片的src相同，因此ie7，firefox不刷新验证码。
		//IE6下不用传随机数
		obj.src="includes/checkNum.jsp?temp="+Math.random();	
	}
	//回车登录
	function keypress(obj) {
		if (event.keyCode == 13 || event.keyCode == 42) {
			login();
		}
	}
	//检查用户名
	function check_name() {
		if (document.forms[0].username.value == "") {
			$("name_check_result").innerHTML = "<font color='red' size='3px'>请选择登陆用户名！</font>";
			return false;
		} else {
			$("name_check_result").innerHTML = "";
			return true;
		}
	}
	//检查密码
	function check_pwd() {
		if (document.forms[0].password.value == "") {
			$("pwd_check_result").innerHTML = "<font color='red' size='3px'>请输入密码！</font>";
			return false;
		} else {
			$("pwd_check_result").innerHTML = "";
			return true;
		}
	}
	//检查验证码
	function check_number() {
		if (document.forms[0].checkNumber.value == "") {
			$("number_check_result").innerHTML = "<font color='red' size='3px'>请输入验证码！</font>";
			return false;
		} else {
			$("number_check_result").innerHTML = "";
			return true;
		}
	}
	//执行登陆
	function login() {

		if (check_name() && check_pwd() && check_number()) {

			//如果当前密码域中的密码与cookie中的密码不相同，则对其进行加密。
			if ($("remember").value != $("password").value) {
			}
				$('password').value = toMD5Str($('password').value);
				document.forms[0].action = "userdo.do?method=login";
				document.forms[0].submit();
		}
	}
</SCRIPT>
<script language="javascript" src="js/pub.js"></script>
<script language="javascript" src="js/md5.js"></script>
</HEAD>
<BODY onkeydown="keypress(this)"; background='images/skins/bluetissue.jpg'>
<span id="tips"></span>
<FORM method="post">
<TABLE height="100%" cellSpacing=0 cellPadding=0 width="100%">

	<TR>
		<TD align=center>
		<TABLE height='333' width='521' cellSpacing=0 cellPadding=0
			background=images/bj.jpg>

			<tr>
				<TD vAlign=bottom>
				<TABLE cellSpacing="1" cellPadding='1' width="100%">

					<tr>
						<TD align="right" width="180">
						<P>用户名</P>
						</TD>
						<TD>
					<select id="username" name="username" size="1"
							style="font-family: 宋体; font-size: 15" onblur="check_name()">
							<option value="">---请选择--- <%
								List<User> list = ((UserDao)(ObjectFactory.getObject(UserDao.class.getName()))).getAllUsers();
								for (int i = 0; i < list.size(); i++) {
							%>	
							<option value="<%=list.get(i).getUsername()%>">
							<%=list.get(i).getUsername()%> 
							<%
 								}
 							%>
							
						</select> <span id="name_check_result" style="background-color: white"></span>
						</td>
					</TR>
					<TR>
						<td align="right" width="180">
						<P>密码</P>
						</td>
						<td><INPUT type="password" value="" id="password"
							name="password" size="21" maxlength="15" onblur=" check_pwd()">
						<span id="pwd_check_result" style="background-color: white"></span>
						</td>
					</TR>
					<tr>
						<td width="180" align="right"><a style="CURSOR: hand"> <img
							id="img1" name="img1" src="includes/checkNum.jsp"
							alt="看不清？点击我..." onclick="refresh(this)"> </a></td>
						<td><input type="text" name="checkNumber" value=""
							maxlength="4" onblur="check_number()"> <span
							id="number_check_result" style="background-color: white"></span>
						</td>
					</tr>
					<tr>
						<TD></td>
						<td align="left">
						<input type="checkbox" id="remember" 
							   name="remember" value="" ><font size="2px">记住我的用户名和密码</font>
						</td>
					</tr>
					<tr height="5"><td colspan="2"></td></tr>
					<tr>
						<TD align=right></TD>
						<TD>
						<TABLE cellSpacing=0 cellPadding=0 width="100%">

							<tr>
								<TD width=60><IMG style="CURSOR: hand" onclick="login()"
									 height=22 src="images/login.jpg" width=53 border=0></TD>
								<TD><IMG style="CURSOR: hand"
									onclick="document.forms[0].reset()" height='22' width='53'
									src="images/cancel.jpg" border=0></TD>
							</tr>
						</TABLE>
						</TD>
					</tr>
					<tr>
						<TD align=center colSpan=2 height=60>
						<DIV
							style="FONT-WEIGHT: bold; FONT-SIZE: 12px; MARGIN-BOTTOM: 25px; WIDTH: 400px; COLOR: #ff9900">
						</DIV>
						</TD>
					</tr>
				</TABLE>
				</TD>
			</tr>
		</TABLE>
		</TD>
	</tr>
</TABLE>
</FORM>
</BODY>
<%
	String username = request.getAttribute("username") + "";
	String snamevalue = null;
	String spwdvalue = null;

	//如果是直接进入登陆页面
	if ("null".equals(username)) {

		Cookie jcookies[] = request.getCookies();
		Cookie sCookie = null;
		String sname = null;

		if(jcookies!=null){//不加此判断，当某个浏览器第一次访问该站点时，会抛空指针异常。
			for (int i = 0; i < jcookies.length; i++) {
				sCookie = jcookies[i];
				sname = sCookie.getName();

				if ("username".equals(sname)) {
					snamevalue = URLDecoder.decode(sCookie.getValue(),"GBK");
				}
				if ("password".equals(sname)) {
					spwdvalue = sCookie.getValue();
				}
			}
		}		
%>
<script type="text/javascript">
$("username").value='<%=snamevalue == null ? "" : snamevalue%>';
$("password").value='<%=spwdvalue == null ? "" : spwdvalue%>';

if($("username").value!=""){//如果在cookie中已记住username，则将“记住用户名和密码”选框选中。
	$("remember").checked=true;
}
if($("password").value!=""){//如果在cookie中已记住password，则将remember值设为记住的加密后的密码，提交的时候不再对密码进行加密。
	$("remember").value=$("password").value;
}
</script>

<%
	} else {//如果是登陆失败后返回至登陆页面
%>
<script type="text/javascript">
$("username").value='<%=username%>';
</script>
<%
	}
%>
</HTML>
<jsp:include page="includes/alert.jsp" flush="true" />

