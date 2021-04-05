<%@ page contentType="text/html;charset=euc-kr" %>
<%@ include file="../raonnx/jsp/raonnx.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>의정자료전자유통시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<!--<script language="javascript" src="/axkcase.js"></script>-->
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>


<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>

<script type="text/javascript" src="/js2/common.js"></script>
<!--<script type='text/javascript' src='/javascript/CKKeyPro_nosign.js'></script>-->
<script src="/js/common.js" ></script>
<script src="/js/validate.js" ></script>
<script src="/js/validate2.js" ></script>

<link type="text/css" href="/css2/style.css" rel="stylesheet">

<style>
#log_wrap {
	width:100%;
	height:100%;
}

.login {
	width:745px;
	overflow:hidden;
	margin-top:3%;
	margin-left:22%;
}

.login h1 {
	width:685px;
	overflow:hidden;
}

.user_con {
}

#log_footer {
	width:100%;
	overflow:hidden;
	margin-top:10px;
	margin-bottom:20px;
}

#log_footer .copy {
	display:block;
	width:100%;
	padding-left:30%;
	border-top:#ccc solid 1px;
	padding-top:10px;
}
</style>

<script language="javascript">

function checkCertification(result)
{
	var form = document.NAPS;
	var retVal = false;

	if(result.status==1){

		retVal = true;

	}else if(result.status==0){
		alert("인증서 선택을 취소하였습니다.");
		return;
	}else if(result.status == -10301){
		//저장매체 설치를 위해 전자서명창이 닫히는 경우
	}else if(result.status!=0){
		alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		return;
	}
	
	if( retVal == true)
	{			
		form.ksbizSig.value = result.data;
		form.ksbizVidRandom.value = result.vidRandom;
		
		form.emp_no.value = document.formEmpNo.emp_no.value;
		form.action = "/join/RegistUserConfirmInPut.jsp";
		form.submit();
	}	

}

function aaa(){
	//checkCertification();
	//setTimeout("checkCertification()",2000);
	//setTimeout("KeySharpBiz.sign(document.getElementById('regsid1').value+document.getElementById('regsid2').value, checkCertification, {addNonce:true}); return false;",2000);	
	setTimeout("KeySharpBiz.sign(document.getElementById('regsid1').value+document.getElementById('regsid2').value, checkCertification, {addNonce:true} );",2000);	
}

function empChk(obj){			
	
//alert('1');
	
	var form = document.NAPS;	
	var jumin = form.regsid1.value + form.regsid2.value;	
	//alert(jumin);	
	//alert('1');
	if(obj == 'regsid1' || obj == 'regsid2') {	
		if(jumin.length == 13 ){
			
			document.formEmpNo.target = "insaEmpNo";
			document.formEmpNo.jomin_no.value = jumin;  
			document.formEmpNo.action = "RegistProcEnc.jsp";
			document.formEmpNo.submit();	
			return true;
		}			
	}
}
</script>
<script language='javascript'>
//개인 법인 선택 radio버튼


function MM_openBrWindow3(theURL,winName,features)
	{
		var winl = (screen.width - 800) / 2;
		var wint = (screen.height - 920) / 2;
		var winProp='width=800,height=920,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
		window.open(theURL, winName, winProp);
	}

</script>
<SCRIPT LANGUAGE="JavaScript">
<!-- 
var isNN = (navigator.appName.indexOf("Netscape")!=-1);

function autoTab(input,len, e) {
        var keyCode = (isNN) ? e.which : e.keyCode; 
        var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
        if(input.value.length >= len && !containsElement(filter,keyCode)) {
        input.value = input.value.slice(0, len);
        input.form[(getIndex(input)+1) % input.form.length].focus();
}

function containsElement(arr, ele) {
        var found = false, index = 0;
        while(!found && index < arr.length)
        if(arr[index] == ele)
        found = true;
        else
        index++;
        return found;
}

function getIndex(input) {
        var index = -1, i = 0, found = false;
        while (i < input.form.length && index == -1)
        if (input.form[i] == input)index = i;
        else i++;
        return index;
        }
return true;
}

// -->
</script>
</head>

<body>
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <div class="schBox" >
                <p>사용자 확인</p>
                <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
                <div class="box"> 
				<form name="NAPS" method="post">
                    <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
                    <table width="600px" border="0" cellspacing="3" cellpadding="0">
                        
						<tr>
                            <td>&bull;&nbsp;<strong>성명</strong></td>
                            <td>
                                <input type="text" name="username" size="15"/></td>
                        </tr>
                        <tr>
                            <td>&bull;&nbsp;<strong>주민등록번호</strong></td>
                            <td><input maxlength="6" size="15" name="regsid1" id="regsid1" onchange="javascript:empChk('regsid1')" onkeyup="return autoTab(this, 6, event);" value='' />
                                -
                                <input maxlength="7" type="password" name="regsid2" id="regsid2" onblur="javascript:empChk('regsid2');" value='' />
                                <input type="hidden" name="CERT_DN" />
								<input type="hidden" name="juminNo1" />
								<input type="hidden" name="juminNo2" />
								<input type="hidden" name="emp_no" />
                                <input type="hidden" name="retVal" />

								<input type="hidden" id="ksbizSig" name="ksbizSig"/>
								<input type="hidden" id="ksbizVidRandom" name="ksbizVidRandom"/>
							</td>
                        </tr>
						
                    </table>
                </div>
            </div>
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="javascript:aaa()">확 인</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">취 소</a></span> </div>
            
            <!-- /리스트 버튼--> 
			 <span class="warning"><b> * '주민등록번호'는 인증서의 본인확인용으로만 사용하고 DB에는 저장하지 않습니다.</b></span><br>
            
            <span class="warning"> 주민등록번호 입력시 키보드 보안시스템이 작동되며 [보안입력]버튼을 누르면 가상키보드를 이용한 추가 화면 보안입력이 가능합니다. 숫자 입력기가 화면에 뜨는 경우 원격해킹보안, 화면정보유출 차단 등 키보드입력정보 유출에 따른 추가화면입력보안이 가능합니다.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<!--
<object id="AxKCASE"  classid="CLSID:49E90C74-4A36-469d-91F8-2BBDE9E6EAAD"
	codebase="/cab/AxNAROKPPD(3.5.3.3).cab#Version=3,5,3,3" width= "1" height= "1">
</object>
-->

</form>
<iframe border="0" name = "insaEmpNo" topmargin="0" marginheight="0" marginwidth="0" scrolling="no" border="0" style = "display:none;" > 
</iframe>
<form id="formEmpNo" name = "formEmpNo" method = "post" target ="insaEmpNo" width = "0" heigth = "0">
	 <input type="hidden" name="jomin_no" id="jomin_no"/>		
	 <input type="hidden" name="emp_no"   id="emp_no" value=""/>	 
</form>
</body>
</html>
