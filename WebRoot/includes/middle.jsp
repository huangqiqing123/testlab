<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%> 
<%@page import="cn.sdfi.tools.Tool"%>
<html>  
<head>
<title>分割线</title>  
<style>  
html,body{   
    padding:0;   
    margin:0;  
    cursor: pointer; 
}   
img{   
    margin-top:200px;     
}   
</style>  
<script language="javascript">  
function isShow(){ 
    if(window.parent.document.getElementById("main").cols=="190,9,*"){   
    	window.parent.document.getElementById("main").cols="0,9,*";  
        document.getElementById("lineArrow1").src="../images/mini-right.gif";
        document.getElementById("lineArrow2").src="../images/mini-right.gif";
        document.getElementById("body").title="展开";
    }else{   
    	window.parent.document.getElementById("main").cols="190,9,*";   
        document.getElementById("lineArrow1").src="../images/mini-left.gif";
        document.getElementById("lineArrow2").src="../images/mini-left.gif";
        document.getElementById("body").title="收起";
    }   
}   
</script>  
</head>  
  
<body id="body" onclick="isShow()" title="收起 "> 
<img id="lineArrow1" src="../images/mini-left.gif"  />
<img id="lineArrow2" src="../images/mini-left.gif"  />
</body>  
</html>