//ɾ���������˵Ŀո�
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, "");
}
//ɾ����ߵĿո�
function ltrim(str){ 
	return str.replace(/(^\s*)/g,"");
}
//ɾ���ұߵĿո�
function rtrim(str){ 
	return str.replace(/(\s*$)/g,"");
}
//��ⱸע�ĳ���,ϵͳ������memoͳһ�������볤��1000�ַ�
function checkmemolength(id){
	var length = checklength(id);
	if(length>1000){
		alert("˵���ı���������볤��Ϊ1000���ַ���ÿ������ռ2���ַ�������ǰ�������ַ��� "+length+" !");
		document.getElementById("memo").focus();
		return false;
	}
	return true;
}
//�ı���������ͳ�ƣ�������2��
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
//����Ƿ��������
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
//�������ݵ�������
function copyText(id) 
{ 
	var a = document.getElementById(id);
	window.clipboardData.setData('text',a.value);
	alert("�ѳɹ����Ƶ�������!");
} 
//��ʾor����ָ��id�����
function display(y){
	$(y).style.display=($(y).style.display=="none")?"":"none";
} 
//document.getElementById�ļ�д
function $(s){
	return document.getElementById(s);
} 
//��껬��ĳһ��
function on_mouse_over(me)
{	
	me.className = "css_tr_move_on";
}
//����뿪ĳһ��
function on_mouse_out(me)
{
	me.className = "";
}

//ʵ��ȫѡ��ȡ��ȫѡ
function selectAll(sourceObject) {
	var obj = document.getElementsByName("pk");
	if (sourceObject.checked == true) {
		for ( var i = 0; i < obj.length; i++) {
			obj[i].checked = true;
			
			//obj[i].id=checkbox0��checkbox0��checkbox2������
			//"checkbox0".substr(8)�Ľ����"0"
			document.getElementById("line" + obj[i].id.substr(8)).className = "css_TR_move";
		}
	} else {
		for ( var j = 0; j < obj.length; j++) {
			obj[j].checked = false;
			document.getElementById("line" + obj[j].id.substr(8)).className = "";
		}
	}
}
//ѡ��ѡ��ʱ������ͬ����ɫ
function changeBgColor(obj){
	if(obj.checked == true){
		document.getElementById("line" + obj.id.substr(8)).className = "css_TR_move";
	}else{
		document.getElementById("line" + obj.id.substr(8)).className = "";
	}
}
//���ĳһ�У���ѡ�л�ȡ��ѡ�и��С�
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
//����һ��checkbox���飬�������д���ѡ��״̬�ĸ�����
function checkedNumber(obj) {
	var count = 0;
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked == true) {
			count++;
		}
	}
	return count;
}
//�ж�һ���ַ������ǲ���ȫ������
function isNumber(str){ 
	if(""==str){ 
	return false; 
	} 
	var reg = /\D/; 
	return str.match(reg)==null; 
	} 

//�ֹ�����Ҫ��ת��ҳ��
function checkPageNumber() {
	var showPage = document.public_info.temp.value;
	if (showPage == "") {
		$("tips").innerHTML="<font color='red'>������Ҫ�鿴��ҳ����</font>";
		return;
	}
	if(!isNumber(showPage)){
		$("tips").innerHTML="<font color='red'>��������������</font>";
		return;
	}
	//ת����ʮ�����������ٽ��бȽ�
	var pageCount = parseInt(document.public_info.pageCount.value,10);
	if(pageCount<parseInt(showPage,10)){
		$("tips").innerHTML="<font color='red'>�������ҳ�������ڣ�</font>";;
		return;
	}
	document.public_info.showPage.value = document.public_info.temp.value;
	document.public_info.submit();
}
//ִ�з�ҳ
function submit_public_info_form(obj) {
	
	//ת����ʮ�����������ٽ��бȽ�
	var pageCount = parseInt(document.public_info.pageCount.value,10);//��ҳ��
	var currentPage = parseInt(document.public_info.currentPage.value,10);//��ǰ��ʾҳ��
	
	//�����ǰ���ǵ�һҳ����������ǰ��ҳ
	if((obj.id=="1"||obj.id=="2")&&currentPage==1){
		$("tips").innerHTML="<font color='red'>��ǰ���ǵ�һҳ!</font>";
		return;
	}
	//�����ǰ�������һҳ������������ҳ
	if((obj.id=="3"||obj.id=="4")&&(currentPage==pageCount||pageCount==0)){
		$("tips").innerHTML="<font color='red'>��ǰ�������һҳ!</font>";
		return;
	}
	document.public_info.view.value = obj.id;
	document.public_info.submit();
}
//��ѡ��ť�б����¼�����
function click_radio_line(obj){
	var line_id=obj.id;
	var radio_id="radio"+line_id.substr(4);
	var radio=document.getElementById(radio_id);
	if (radio.checked == false) {
		radio.checked=true;
	}	
}
//����ı�������
function clear_condition(obj){
	obj.value="";
}