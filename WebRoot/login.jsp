<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="cn.sdfi.user.bean.User"%>
<%@page import="cn.sdfi.framework.factory.ObjectFactory"%>
<%@page import="cn.sdfi.user.dao.UserDao"%><HTML>
<HEAD>
<TITLE>�˳��������ʵ�����ĵ�����ϵͳ</TITLE>
<SCRIPT language="javascript">

	//���ˢ����֤��
	function refresh(obj) {

		//IE7��IE8�£���Ҫ��url��һ�����������������֤�벻��ˢ�£�ԭ������ie7��firefox�Ļ�����ƺ�ie6��ͬ������jsָ����src��ԭ��ͼƬ��src��ͬ�����ie7��firefox��ˢ����֤�롣
		//IE6�²��ô������
		obj.src="includes/checkNum.jsp?temp="+Math.random();	
	}
	//�س���¼
	function keypress(obj) {
		if (event.keyCode == 13 || event.keyCode == 42) {
			login();
		}
	}
	//����û���
	function check_name() {
		if (document.forms[0].username.value == "") {
			$("name_check_result").innerHTML = "<font color='red' size='3px'>��ѡ���½�û�����</font>";
			return false;
		} else {
			$("name_check_result").innerHTML = "";
			return true;
		}
	}
	//�������
	function check_pwd() {
		if (document.forms[0].password.value == "") {
			$("pwd_check_result").innerHTML = "<font color='red' size='3px'>���������룡</font>";
			return false;
		} else {
			$("pwd_check_result").innerHTML = "";
			return true;
		}
	}
	//�����֤��
	function check_number() {
		if (document.forms[0].checkNumber.value == "") {
			$("number_check_result").innerHTML = "<font color='red' size='3px'>��������֤�룡</font>";
			return false;
		} else {
			$("number_check_result").innerHTML = "";
			return true;
		}
	}
	//ִ�е�½
	function login() {

		if (check_name() && check_pwd() && check_number()) {

			//�����ǰ�������е�������cookie�е����벻��ͬ���������м��ܡ�
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
						<P>�û���</P>
						</TD>
						<TD>
					<select id="username" name="username" size="1"
							style="font-family: ����; font-size: 15" onblur="check_name()">
							<option value="">---��ѡ��--- <%
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
						<P>����</P>
						</td>
						<td><INPUT type="password" value="" id="password"
							name="password" size="21" maxlength="15" onblur=" check_pwd()">
						<span id="pwd_check_result" style="background-color: white"></span>
						</td>
					</TR>
					<tr>
						<td width="180" align="right"><a style="CURSOR: hand"> <img
							id="img1" name="img1" src="includes/checkNum.jsp"
							alt="�����壿�����..." onclick="refresh(this)"> </a></td>
						<td><input type="text" name="checkNumber" value=""
							maxlength="4" onblur="check_number()"> <span
							id="number_check_result" style="background-color: white"></span>
						</td>
					</tr>
					<tr>
						<TD></td>
						<td align="left">
						<input type="checkbox" id="remember" 
							   name="remember" value="" ><font size="2px">��ס�ҵ��û���������</font>
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

	//�����ֱ�ӽ����½ҳ��
	if ("null".equals(username)) {

		Cookie jcookies[] = request.getCookies();
		Cookie sCookie = null;
		String sname = null;

		if(jcookies!=null){//���Ӵ��жϣ���ĳ���������һ�η��ʸ�վ��ʱ�����׿�ָ���쳣��
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

if($("username").value!=""){//�����cookie���Ѽ�סusername���򽫡���ס�û��������롱ѡ��ѡ�С�
	$("remember").checked=true;
}
if($("password").value!=""){//�����cookie���Ѽ�סpassword����rememberֵ��Ϊ��ס�ļ��ܺ�����룬�ύ��ʱ���ٶ�������м��ܡ�
	$("remember").value=$("password").value;
}
</script>

<%
	} else {//����ǵ�½ʧ�ܺ󷵻�����½ҳ��
%>
<script type="text/javascript">
$("username").value='<%=username%>';
</script>
<%
	}
%>
</HTML>
<jsp:include page="includes/alert.jsp" flush="true" />

