<%
	if(Tool.isNotLogin(request)){
		request.getRequestDispatcher("no_login.jsp").forward(request, response);
		return;
	}
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<jsp:include page="includes/encoding.jsp" flush="true" />
<%@page import="cn.sdfi.tools.Tool"%><html>
<head>
<style type="text/css">
.nTab{
float: left;
width: 100%;
margin: 0 auto;
border-bottom:1px #AACCEE solid;
background:#d5d5d5;
background-position:left;
background-repeat:repeat-y;
margin-bottom:2px;
}
.nTab .TabTitle{
clear: both;
height: 22px;
overflow: hidden;
}
.nTab .TabTitle ul{
border:0;
margin:0;
padding:0;
}
.nTab .TabTitle li{
float: left;
width: 70px;
cursor: pointer;
padding-top: 4px;
padding-right: 0px;
padding-left: 0px;
padding-bottom: 2px;
list-style-type: none;
font-size: 12px;
text-align: center;
margin: 0;
}
.nTab .TabTitle .active{background:#fff;border-left:1px #AACCEE solid;border-top:1px #AACCEE solid;border-right:1px #AACCEE solid;border-bottom:1px #fff solid;}
.nTab .TabTitle .normal{background:#EBF3FB;border:1px #AACCEE solid;}
.nTab .TabContent{
width:auto;background:#fff;
margin: 0px auto;
padding:10px 0 0 0;
border-right:1px #AACCEE solid;border-left:1px #AACCEE solid;
}
.none {display:none;}
</style>
<script type="text/javascript">
function nTabs(thisObj,Num){
if(thisObj.className == "active")return;
var tabObj = thisObj.parentNode.id;
var tabList = document.getElementById(tabObj).getElementsByTagName("li");
for(var i=0; i <tabList.length; i++)
{
if (i == Num)
{
   thisObj.className = "active"; 
      document.getElementById(tabObj+"_Content"+i).style.display = "block";
}else{
   tabList[i].className = "normal"; 
   document.getElementById(tabObj+"_Content"+i).style.display = "none";
}
} 
}
</script>
<link rel="stylesheet" type="text/css" href="css/pub.css">
</head>
<body background="images/skins/<%=session.getAttribute("skin")%>">
			<h2 align="center">
				实用小工具
			</h2>
<div class="nTab" align="center" style="width: 600px">
    <div class="TabTitle">
      <ul id="myTab1">
        <li class="active" onclick="nTabs(this,0);">全国天气</li>
        <li class="normal" onclick="nTabs(this,1);">万年历</li>
      </ul>
    </div>
    <div class="TabContent">
      <div id="myTab1_Content0" >
      <iframe src="http://flash.weather.com.cn/wmaps/index.swf?url1=http%3A%2F%2Fwww%2Eweather%2Ecom%2Ecn%2Fweather%2F&url2=%2Eshtml&from=cn" width="625" height="457" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="no"></iframe>
      </div>
     
      <div id="myTab1_Content1" class="none">
      <iframe  src="http://site.baidu.com/list/wannianli.htm"  marginwidth="0" marginheight="0" hspace="0" vspace="0" width="800" height="400" frameborder="0" scrolling="no"></iframe>
    
      </div>
     
    </div>
</div>
</body>
</html>

