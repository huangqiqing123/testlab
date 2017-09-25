	//发送ajax请求
	function sendRequest(path) {
		clearSuggest();
		var info = trim(document.getElementById('title').value);
		if(info==""){
			 hiddenSuggest();
			return;
		}
		var req = getXmlHttpObject();
		var url = "knowdo.do?method=suggest&info="+info+"&path="+path;
		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				if (req.status == 200) {
					var tips = req.responseXML.getElementsByTagName("res");//alert(req.responseText);//调试用
					if(tips.length!=0){
						for(var i=0;i<tips.length;i++){
							var title=tips[i].firstChild.nodeValue;
							var sDiv = "<div class='out' onmouseover='mover(this);' onmouseout='mout(this);' onclick='setSuggest(this)'>"+title+"</div>";
							document.getElementById('suggest').innerHTML+=sDiv;
							}
							displaySuggest();
						}else{
							 hiddenSuggest();
						}
				}
			}
		};
		req.open("POST", url, true);
		req.send(null);
	}

	function setSuggest(para){
		document.getElementById('title').value=para.firstChild.nodeValue;
		hiddenSuggest();
		query();
		}
	//设置不可见
	function hiddenSuggest(){
		document.getElementById('suggest').style.display="none";
		document.getElementById('frame1').style.display="none";
		}
	//设置可见
	function displaySuggest(){
		document.getElementById('frame1').style.display="block";
		document.getElementById('suggest').style.display="block";
		}
	function clearSuggest(){
		document.getElementById('suggest').innerHTML="";
		}
	function mover(para){
		para.className="over";
		}
	function mout(para){
		para.className="out";
		}
	
	//返回XMLHttpRequest对象
	function getXmlHttpObject() {
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			// Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
		}
		return xmlHttp;
	}