 <%
 	Object msg = request.getAttribute("msg");
 	if (msg != null&&(!"".equals(msg.toString()))) {
 		out.println("<script type=\"text/javascript\">");
 		out.println("document.getElementById('tips').innerHTML=\"<font color='red'>"+msg+"</font>\";");
 		out.print("</script>");
 	}
 %> 