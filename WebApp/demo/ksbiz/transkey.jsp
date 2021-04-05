<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
<meta http-equiv="Cache-control" content = "no-cache">
<meta http-equiv="Pragma" content = "no-cache">
<title>KeySharpBiz2.1 Demo</title>
<script type="text/javascript" src="../../raonnx/ksbiz/cxsign/theme/assets/js/jquery-1.11.3.min.js"></script>
<%@ include file="../../raonnx/jsp/raonnx.jsp" %>

<script type="text/javascript" src="../../raonnx/ksbiz/transkey/rsa_oaep_files/rsa_oaep-min.js"></script>
<script type="text/javascript" src="../../raonnx/ksbiz/transkey/jsbn/jsbn-min.js"></script>
<script type="text/javascript" src="../../raonnx/ksbiz/transkey/TranskeyLibPack_op.js"></script>
<script type="text/javascript" src="../../raonnx/ksbiz/transkey/transkey.js"></script>
<link rel="stylesheet" type="text/css" href="../../raonnx/ksbiz/transkey/transkey.css" />

<script type="text/javascript" src="../../raonnx/ksbiz/cxsign/theme/ksbiz/js/ui.js"></script>
<script type="text/javascript" src="../../raonnx/ksbiz/cxsign/theme/ksbiz/js/process.js"></script>
<script type="text/javascript" src="../../raonnx/ksbiz/cxsign/interface.js"></script>
</head>
<script>
if(window.addEventListener){
	window.addEventListener('load', function(){
		secureKeyCtrl.initEncPwd();
	});
} else if(window.attachEvent){
	window.attachEvent('onload', function(){
		secureKeyCtrl.initEncPwd();
	});
}

function bizClickToggle(e){
	var obj;

	var kbdOnImg = ksbizBaseUrl + "/ksbiz/cxsign/theme/ksbiz/images/ico/ico_keyboard_on.png";
	var kbdOffImg = ksbizBaseUrl + "/ksbiz/cxsign/theme/ksbiz/images/ico/ico_keyboard_off.png";
	
	if (e.type == "text" || e.type == "password") {
		obj = event;
	} else {
		e = e ? e : window.event;
		obj = e.target ? e.target : e.srcElement;
	}
	var id = e.id.substring(0,e.id.length - 7);
	//console.log(e.id);
	//console.log(id);
	//console.log(e.src.substring(e.src.length - 'ico_keyboard_off.png'.length));
	var isChecked = e.src.substring(e.src.length - 'ico_keyboard_off.png'.length) == 'ico_keyboard_off.png'; 
	e.src = isChecked ? kbdOnImg : kbdOffImg;
	
	if(isChecked){
		transkey[id].useTranskey=true;
		transkey[id].inputObj.readOnly=true;
		tk.onKeyboard(transkey[id].inputObj);
	}else{
		transkey[id].clear();
		transkey[id].useTranskey=false;
		transkey[id].inputObj.readOnly=false;
	if(tk.now!=null)
		tk.close();
	}
}

function encResult(result){
	//alert(JSON.stringify(result));
	console.log('======== result ====================');
	console.log(result);
	console.log('========== decrypt ================');
	var decStr = [];
	for(var i=0; i<result.encParams.length; i++){
		var encName = result.encParams[i].name;
		var encStr = result.encParams[i].enc;
		if(encStr){
			console.log(encStr);
			encStr = transkey_GetDecnxBiz(encStr);
			console.log(encStr);
			encStr = decode64(encStr);
			console.log(encStr);
		}
		decStr.push({"name":encName, 'decString':encStr});
	}
	alert(JSON.stringify(decStr));
}
</script>
<body>
<br><br>
<!-- input type="button" value="초기화" onclick="makeinput()"/><br><br -->
[Single Input]
<form name="frm">
	<input type="password" maxlength="12" id="certpwd" name="certpwd" />
	<img class='TranskeyToggle' alt='' style='vertical-align:middle; cursor:pointer;' id='certpwd_toggle' onclick="bizClickToggle(this);" src='../../raonnx/ksbiz/cxsign/theme/ksbiz/images/ico/ico_keyboard_off.png' border='0'>
</form>
<input type="button" value="암호화확인" onclick='secureKeyCtrl.encPwdEcrypt({"form":"frm","encFields":["certpwd"]}, encResult);' ></input>
<br><br>
[Multi Input]
<form name="frm1">
	<input type="password" maxlength="12" id="certpwd11" name="certpwd11" />
	<img class='TranskeyToggle' alt='' style='vertical-align:middle; cursor:pointer;' id='certpwd11_toggle' src='../../raonnx/ksbiz/cxsign/theme/ksbiz/images/ico/ico_keyboard_off.png' onclick="bizClickToggle(this);" border='0'>
	<input type="password" maxlength="12" id="certpwd12" name="certpwd12" />
	<img class='TranskeyToggle' alt='' style='vertical-align:middle; cursor:pointer;' id='certpwd12_toggle' src='../../raonnx/ksbiz/cxsign/theme/ksbiz/images/ico/ico_keyboard_off.png' onclick="bizClickToggle(this);" border='0'>
</form>
<input type="button" value="암호화확인" onclick='secureKeyCtrl.encPwdEcrypt({"form":"frm1","encFields":["certpwd11", "certpwd12"]}, encResult);' ></input>
</body>
</html>
