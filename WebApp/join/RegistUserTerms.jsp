<%@ page contentType="text/html;charset=euc-kr" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>의정자료전자유통시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<link type="text/css" href="/css2/style.css" rel="stylesheet">
<!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie6.css" media="screen" />
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie7.css" media="screen" />
<![endif]-->
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
	
	function funIntro(){
		
		window.location = "/index.html";
	}
	
	function funAgree(){
	
		var form = document.NAPS;
		
		form.action = "/join/RegistUserConfirm.jsp";
		form.target = "_self";
		form.submit();
	}
	
	function MM_openBrWindow3(theURL,winName,features)
	{
		var winl = (screen.width - 800) / 2;
		var wint = (screen.height - 920) / 2;
		var winProp='width=800,height=920,scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no,top=' + wint + ',left=' + winl;
		window.open(theURL, winName, winProp);
	}

	function lsw_write(){

		var ecp_code;
		var ecp_code1;
		var ecp_code2;
		var form = document.NAPS;
		var obj = null;
		var obj1 = null;
		var obj2 = null;
		var find = false;
		var find1 = false;
		var find2 = false;
		obj = form.cert_type;
		obj1 = form.cert_type1;
		obj2 = form.cert_type2;
		var size = obj.length; // 라디오버튼의 수
		var size1 = obj1.length;
		var size2 = obj2.length;

		if(obj[0]) {
			for ( var i = 0; i < size; i++) {
				if (obj[i].checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우
					ecp_code = obj[i].value;
					find = true; // *구분을 찾았다는걸로(true)로 변환
					break; // *for문을 빠져나온다.
				} // end if
			} // end for
		} else {
			if (obj.checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우				
				ecp_code = obj.value;
				find = true; // *구분을 찾았다는걸로(true)로 변환
				//break; // *for문을 빠져나온다.
			} // end if
		}

		if (find == false) { // 라디오버튼을 못찾았을 경우 메세지 띄우고 종료
			alert("이용약관을 체크하여 주시기 바랍니다.");
			obj[0].focus();
			return;
		}

		if(obj1[0]) {
			for ( var i = 0; i < size1; i++) {
				if (obj1[i].checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우
					ecp_code1 = obj1[i].value;
					find1 = true; // *구분을 찾았다는걸로(true)로 변환
					break; // *for문을 빠져나온다.
				} // end if
			} // end for
		} else {
			if (obj1.checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우				
				ecp_code1 = obj1.value;
				find1 = true; // *구분을 찾았다는걸로(true)로 변환
				//break; // *for문을 빠져나온다.
			} // end if
		}

		if (find1 == false) { // 라디오버튼을 못찾았을 경우 메세지 띄우고 종료
			alert("개인정보 수집 및 이용 동의에 체크하여 주시기 바랍니다.");
			obj1[0].focus();
			return;
		}

		if(obj2[0]) {
			for ( var i = 0; i < size2; i++) {
				if (obj2[i].checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우
					ecp_code2 = obj2[i].value;
					find2 = true; // *구분을 찾았다는걸로(true)로 변환
					break; // *for문을 빠져나온다.
				} // end if
			} // end for
		} else {
			if (obj2.checked == true) { // 만약 채크되어있는 라디오 버튼을 찾았을 경우				
				ecp_code2 = obj2.value;
				find2 = true; // *구분을 찾았다는걸로(true)로 변환
				//break; // *for문을 빠져나온다.
			} // end if
		}

		if (find2 == false) { // 라디오버튼을 못찾았을 경우 메세지 띄우고 종료
			alert("개인정보 제3자 제공 동의에 체그하여 주시기 바랍니다.");
			obj2[0].focus();
			return;
		}

		if(ecp_code == '0' && ecp_code1 == '0' && ecp_code2 == '0'){
			form.action = "/join/RegistUserConfirm.jsp";
			form.target = "_self";
			form.submit();
		}else{
			alert("관련 약관에 동의하여 주시기 바랍니다.");
			return;
		}
	}


	
</script>
</head>

<body>
<form name="NAPS" method="post">
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <div class="schBox" >
                <p>이용약관</p>
                <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
                <div class="box"> 
                    <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
                    <table width="700px" border="0" cellspacing="3" cellpadding="0">
                        <tr>
                            <td><iframe height="300" src="/PT_UserAgree.html" frameborder="1" width="100%" scrolling="Yes"></iframe></td>
                        </tr>
                        <tr>
                            <td align="center"><input  value="0"  type="radio" name="cert_type" class="borderNo" />
                                동의함
                                <input  value="1" type="radio" name="cert_type" class="borderNo" />
                                동의안함</td>
                        </tr>
                    </table>
                </div>
            </div>
			
			<div class="schBox" >
                <p>개인정보 수집 및 이용 동의</p>
                <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
                <div class="box"> 
                    <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
                    <table width="700px" border="0" cellspacing="3" cellpadding="0">
                        <tr>
                            <td><iframe height="300" src="/PT_UserAgree1.html" frameborder="1" width="100%" scrolling="Yes"></iframe></td>
                        </tr>
                        <tr>
                            <td align="center"><input  value="0"  type="radio" name="cert_type1" class="borderNo" />
                                동의함
                                <input value="1" type="radio" name="cert_type1" class="borderNo" />
                                동의안함</td>
                        </tr>
                    </table>
                </div>
            </div>
			
			<div class="schBox" >
                <p>개인정보 제3자 제공 동의</p>
                <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
                <div class="box"> 
                    <!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
                    <table width="700px" border="0" cellspacing="3" cellpadding="0">
                        <tr>
                            <td><iframe height="300" src="/PT_UserAgree2.html" frameborder="1" width="100%" scrolling="Yes"></iframe></td>
                        </tr>
                        <tr>
                            <td align="center"><input  value="0"  type="radio" name="cert_type2" class="borderNo" />
                                동의함
                                <input  value="1" type="radio" name="cert_type2" class="borderNo" />
                                동의안함</td>
                        </tr>
                    </table>
                </div>
            </div>
			
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="javascript:lsw_write()">사용자등록확인</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">취 소</a></span> </div>
            <!-- /리스트 버튼--> 
            
        </div>
    </div>
    <div id="log_footer"> <span class="copy" ><a href="javascript:MM_openBrWindow3('http://naps.assembly.go.kr/persnalinfo.htm','','width=600,height=520')"><img src="/images2/login/movie_04_con4.gif"/></a><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
</form>
</body>
</html>