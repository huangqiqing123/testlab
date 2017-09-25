//删除左右两端的空格
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, "");
}
//删除左边的空格
function ltrim(str){ 
	return str.replace(/(^\s*)/g,"");
}
//删除右边的空格
function rtrim(str){ 
	return str.replace(/(\s*$)/g,"");
}
//检测备注的长度,系统中所有memo统一最大可输入长度1000字符
function checkmemolength(id){
	var length = checklength(id);
	if(length>1000){
		alert("说明文本域最长可输入长度为1000个字符，每个汉字占2个字符，您当前已输入字符数 "+length+" !");
		document.getElementById("memo").focus();
		return false;
	}
	return true;
}
//文本框内字数统计，中文算2个
function checklength(id) 
{ 
	var len = 0; 
	var str=$(id).value; 
	for (var i=0; i<str.length; i++) 
	{ 
		if (str.charCodeAt(i)>127 || str.charCodeAt(i)==94) { 
			len += 2; 
		} else { 
			len ++; 
		} 
	}
	return len;
} 
//检查是否包含中文
function isContainChineseChar(id){
	var str=$(id).value; 
	for (var i=0; i<str.length; i++) 
	{ 
		if (str.charCodeAt(i)>127 || str.charCodeAt(i)==94) { 
			return true;
		}
	}
	return false;
}
//复制内容到剪贴板
function copyText(id) 
{ 
	var a = document.getElementById(id);
	window.clipboardData.setData('text',a.value);
	alert("已成功复制到剪贴板!");
} 
//显示or隐藏指定id的组件
function display(y){
	$(y).style.display=($(y).style.display=="none")?"":"none";
} 
//document.getElementById的简写
function $(s){
	return document.getElementById(s);
} 
//鼠标滑过某一行
function on_mouse_over(me)
{	
	me.className = "css_tr_move_on";
}
//鼠标离开某一行
function on_mouse_out(me)
{
	me.className = "";
}

//实现全选、取消全选
function selectAll(sourceObject) {
	var obj = document.getElementsByName("pk");
	if (sourceObject.checked == true) {
		for ( var i = 0; i < obj.length; i++) {
			obj[i].checked = true;
			
			//obj[i].id=checkbox0、checkbox0、checkbox2、、、
			//"checkbox0".substr(8)的结果是"0"
			document.getElementById("line" + obj[i].id.substr(8)).className = "css_TR_move";
		}
	} else {
		for ( var j = 0; j < obj.length; j++) {
			obj[j].checked = false;
			document.getElementById("line" + obj[j].id.substr(8)).className = "";
		}
	}
}
//选中选框时，背景同步变色
function changeBgColor(obj){
	if(obj.checked == true){
		document.getElementById("line" + obj.id.substr(8)).className = "css_TR_move";
	}else{
		document.getElementById("line" + obj.id.substr(8)).className = "";
	}
}
//点击某一行，则选中或取消选中该行。
function clickLine(currentLine) {
	var obj = document.getElementById("checkbox" + currentLine.id);
	if (obj.checked == true) {
		obj.checked = false;
		document.getElementById("line" + currentLine.id).className = "";
	} else {
		obj.checked = true;
		document.getElementById("line" + currentLine.id).className = "css_TR_move";
		
	}
}
//接收一个checkbox数组，返回其中处于选中状态的个数。
function checkedNumber(obj) {
	var count = 0;
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked == true) {
			count++;
		}
	}
	return count;
}
//判断一个字符串中是不是全是数字
function isNumber(str){ 
	if(""==str){ 
	return false; 
	} 
	var reg = /\D/; 
	return str.match(reg)==null; 
	} 

//手工输入要跳转的页数
function checkPageNumber() {
	var showPage = document.public_info.temp.value;
	if (showPage == "") {
		$("tips").innerHTML="<font color='red'>请输入要查看的页数！</font>";
		return;
	}
	if(!isNumber(showPage)){
		$("tips").innerHTML="<font color='red'>请输入正整数！</font>";
		return;
	}
	//转换成十进制整数后，再进行比较
	var pageCount = parseInt(document.public_info.pageCount.value,10);
	if(pageCount<parseInt(showPage,10)){
		$("tips").innerHTML="<font color='red'>你输入的页数不存在！</font>";;
		return;
	}
	document.public_info.showPage.value = document.public_info.temp.value;
	document.public_info.submit();
}
//执行翻页
function submit_public_info_form(obj) {
	
	//转换成十进制整数后，再进行比较
	var pageCount = parseInt(document.public_info.pageCount.value,10);//总页数
	var currentPage = parseInt(document.public_info.currentPage.value,10);//当前显示页数
	
	//如果当前已是第一页，则不能再往前翻页
	if((obj.id=="1"||obj.id=="2")&&currentPage==1){
		$("tips").innerHTML="<font color='red'>当前已是第一页!</font>";
		return;
	}
	//如果当前已是最后一页，则不能再往后翻页
	if((obj.id=="3"||obj.id=="4")&&(currentPage==pageCount||pageCount==0)){
		$("tips").innerHTML="<font color='red'>当前已是最后一页!</font>";
		return;
	}
	document.public_info.view.value = obj.id;
	document.public_info.submit();
}
//单选按钮列表单击事件处理
function click_radio_line(obj){
	var line_id=obj.id;
	var radio_id="radio"+line_id.substr(4);
	var radio=document.getElementById(radio_id);
	if (radio.checked == false) {
		radio.checked=true;
	}	
}
//清除文本框内容
function clear_condition(obj){
	obj.value="";
}