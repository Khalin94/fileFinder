<%
/**
* Title	: 인트로화면
* Copyright	: 2006 by HIT inc.,
* @author	: 강상구
* @version	: %I%, %G%
* Company	: 현대정보기술
* Created on 	: 2006.03.13
* Description	: 인트로 화면
*
	=======================================================================
	* 수정 내역
	* NO         날짜        작업자            내용
	*
	=======================================================================
**/
%> 
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%//@ page import = "com.potal.control.PT_PopCtr" %>
<%//@ page import = "com.hitlive.collection.*" %>
<html>
<head>
<title>국회 의정자료전자유통시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<!-- 2010-07-29 비이소프트 스크립트 -->
<link href="/common/css/style.css" rel="stylesheet" type="text/css">
<script type='text/javascript' src='/javascript/safeon.js'></script>
<script type='text/javascript' src='/javascript/CKKeyPro.js'></script>    

<script language='javascript'>

/*--------------------------------------------
* Button Image Roll Over
--------------------------------------------*/
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

/*--------------------------------------------
* Login Click
--------------------------------------------*/
function CheckAX()
{
	var Installed = false;
	// AxKSignCASE 프로젝트 일때
	var KSIGNActiveXProgID = "AxNAROKPPD.AxNAROKPPD.1"
	
	try
	{
		var xObj = new ActiveXObject(KSIGNActiveXProgID);
	
		if(xObj){
			Installed = true;
		}
		else
		{
			Installed = false;
		}
	}
	catch(ex)
	{
		Installed = false;
	}
	
	return Installed;
} 

function TryLogin(){

	
	var dn;
	var signeddata;
	
	if(!CheckAX()) {
		alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
		return;
	}

	dn = document.AxKCASE.SelectCert();
	if ((dn == null) || (dn == ""))
	{
		if(document.AxKCASE.GetErrorCode() != -1)
			alert(document.AxKCASE.GetErrorContent());
		return;
	}

	signeddata = document.AxKCASE.SignedData(dn, "", dn);
	if( signeddata == null || signeddata == "" )
	{
		errmsg = document.AxKCASE.GetErrorContent();
		errcode = document.AxKCASE.GetErrorCode();
		alert( "인증서 로그인 오류 :"+errmsg );
		return;
	}
	
	document.loginform_cert.signed_data.value = signeddata;
	document.loginform_cert.action = "./pkicert.jsp";
	//document.loginform_cert.action = "./test02.jsp";
	document.loginform_cert.submit();
}


/*--------------------------------------------
* 이용안내
--------------------------------------------*/
function MM_openBrWindow(theURL,winName,features){
	window.open(theURL,winName,features);
}


/*--------------------------------------------
* 팝업
--------------------------------------------*/
function setCookie( name, value, expiredays ){
        var today = new Date();
        today.setDate( today.getDate() + expiredays );
        document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + today.toGMTString() + ";";
}

function getCookie(strName){
    var strArg = new String(strName + "=");
    var nArgLen, nCookieLen, nEnd;
    var i = 0, j;

    nArgLen    = strArg.length;
    nCookieLen = document.cookie.length;
    if(nCookieLen > 0) {
        while(i < nCookieLen) {
            j = i + nArgLen;
            if(document.cookie.substring(i, j) == strArg) {
                nEnd = document.cookie.indexOf (";", j);
                if(nEnd == -1) nEnd = document.cookie.length;
                return unescape(document.cookie.substring(j, nEnd));
            }
            i = document.cookie.indexOf(" ", i) + 1;
            if (i == 0) break;
        }
    }
    return("");
}

// 의정자료전자유통시스템 교육교재 POP링크
function popQnaViewCont(id,hid,num) {
    var objForm		= document.frmNAFSQna;
    var newWidth	= 600;
    var newHeight	= 520;
    var newLeft		= (screen.availWidth - newWidth)/2;
    var newTop		= (screen.availHeight - newHeight)/2;

    var pwin		= window.open('', 'popup_noti', 'left='+newLeft+',top='+newTop+',width='+newWidth+',height='+newHeight+',scrollbars=yes, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

	objForm.qust_bltn_id.value = id;
	objForm.hupper_bltn_id.value = hid;
	objForm.num.value = num;

	objForm.target = "popup_noti";
	objForm.submit();
}	// end function :: popQnaViewCont


</script>

</head>

<body leftmargin="0" topmargin="0" onLoad="MM_preloadImages('/images/intro/nafs_login_05_over.jpg','/images/intro/nafs_login_06_over.jpg','/images/intro/nafs_login_09_over.jpg','/images/intro/nafs_login_10_over.jpg','/images/intro/nafs_login_11_over.jpg','/images/intro/nafs_n_login_05_over.jpg','/images/intro/nafs_n_login_06_over.jpg','/images/intro/nafs_n_login_04_over.gif')">
<form name="test" method="post">
</form>
<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
<tr>
    <td align="center" valign="middle">

		<table cellspacing="0" cellpadding="0" border="0" width="660">
		<tr>
		    <td><img src="/images/intro/nafs01_logo1.gif" width="340" height="65" border="0" alt=""></td>
		</tr>
		<!--tr>
		    <td height="10"></td>
		</tr -->
		<tr>
		    <td height="231" background="/images/intro/nafs_n_login_011.jpg" align="right" valign="bottom">
				<table cellspacing="0" cellpadding="0" border="0">
				<tr>
				    <td align="right"><a href="javascript:TryLogin()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','/images/intro/nafs_n_login_04.gif',1)"><img src="/images/intro/nafs_n_login_04.gif" name="Image4" width="51" height="42" border="0"></a></td>
				    <td rowspan="4" width="20"></td>
				    <!--td align="right"><a href="/jsp/Usr/PT_Log_InR10.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','/images/intro/nafs_n_login_04_over.gif',1)"><img name="Image8" border="0" src="/images/intro/nafs_n_login_04.gif" width="51" height="42"></a></td>
					<td rowspan="4" width="20"></td-->
				</tr>
				<tr>
				    <td height="10"></td>
				</tr>
				<tr>
				    <td><img src="/images/intro/nafs_n_login_03.gif" width="209" height="18" border="0" alt=""></td>
				</tr>
				<tr>
				    <td height="10"></td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
		    <td height="7"><font size="2" color="blue">
인증서 비밀번호 입력시 키보드 보안시스템이 작동되며 [보안입력]버튼을 누르면 가상키보드를 이용한 추가 화면 보안입력이 가능합니다.  마우스로 비밀번호를 입력한 후 마지막에 확인키를 클릭하십시오 ☎ (788-3881,2) </font></td>
		</tr>
		<tr>
		    <td bgcolor="#dfdfdf" style="padding:1pt">
				<table width="100%" bgcolor="#ffffff" cellspacing="0" cellpadding="0" border="0">
				<tr><td align="center" style="padding:2pt">
						<img src="/images/intro/icon_login.gif">&nbsp;&nbsp;<font color="#696969" style="font-size:9pt;"><b>의정자료전자유통시스템 동영상교재</b></font>
						<img src="/images/intro/blank.gif" width="10">
						<img src="/images/intro/mem_organ_bt.gif"  onclick="popQnaViewCont('QB10000742', 'QB10000742', '3');" style="cursor:hand" align="absmiddle">
						&nbsp;<img src="/images/intro/ver_dot.gif" width="1" height="19" align="absmiddle">&nbsp;&nbsp;<img src="/images/intro/cmt_organ_bt.gif"  onclick="popQnaViewCont('QB10000743', 'QB10000743', '2');" style="cursor:hand" align="absmiddle">
						&nbsp;<img src="/images/intro/ver_dot.gif" width="1" height="19" align="absmiddle">&nbsp;&nbsp;<img src="/images/intro/submit_organ_bt.gif" onclick="popQnaViewCont('QB10000753', 'QB10000753', '1');" style="cursor:hand" align="absmiddle">
					</td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
		    <td height="7"></td>
		</tr>
		<tr>
		    <td>
				<table cellspacing="0" cellpadding="0" border="0">
				<tr>
				    <td><a href="/jsp/intro/PT_UserRegR10.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','/images/intro/nafs_n_login_05_over.jpg',1)"><img name="Image5" border="0" src="/images/intro/nafs_n_login_05.jpg" width="303" height="54"></a></td>
				    <td width="6"></td>
				    <td><a href="/jsp/intro/PT_UserRegR30.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','/images/intro/nafs_n_login_06_over.jpg',1)"><img name="Image6" border="0" src="/images/intro/nafs_n_login_06.jpg" width="351" height="54"></a></td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
		    <td height="7"></td>
		</tr>
		<tr>
		    <td>

				<table cellspacing="0" cellpadding="0" border="0">
				<tr>
				    <td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','/images/intro/nafs_n_login_07.jpg',1)"><img src="/images/intro/nafs_n_login_07.jpg" name="Image10" width="216" height="35" border="0" onClick="MM_openBrWindow('../../html/guide/PT_UseGuide_NaR10.htm','','width=727,height=672')"></a></td>
				    <td width="6"></td>
				    <td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','/images/intro/nafs_n_login_08_01.jpg',1)"><img src="/images/intro/nafs_n_login_08_01.jpg" name="Image10" width="216" height="35" border="0" onClick="MM_openBrWindow('../../html/authinfo/PT_AuthntPubctR10.htm','','width=727,height=672')"></a></td>
				    <td width="6"></td>
				    <td><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','/images/intro/nafs_n_login_09.jpg',1)"><img src="/images/intro/nafs_n_login_09.jpg" name="Image10" width="216" height="35" border="0" onClick="MM_openBrWindow('http://nafs.assembly.go.kr:82/jsp/Brd/QustBrd/PT_QustBrdR10Main.jsp','','width=727,height=642')"></a></td>
				</tr>
				</table>

			</td>
		</tr>
		<tr>
		    <td height="7"></td>
		</tr>
		<tr>
		    <td height="1" bgcolor="E9E9E9"></td>
		</tr>
		<tr>
		    <td align="center"><img src="/images/intro/nafs_n_login_03.jpg" ></td>
		</tr>
		</table>

	</td>
</tr>
</table>
<!-- 팝업관리 -->
<iframe src="http://nafs.assembly.go.kr:81/jsp/comm/CM_PopupL10.jsp?sys_flag=P" marginheight="0" marginwidth="0" frameborder="0" width="0" height="0"></iframe>
<!-- certificate login form -->
<form method="post" action="" name="loginform_cert">
    <input type='hidden' name='signed_data' >
</form>

<object id="AxKCASE"  classid="CLSID:49E90C74-4A36-469d-91F8-2BBDE9E6EAAD"
	codebase="/cab/AxNAROKPPD(3.3.2.1).cab#Version=3,3,2,1" width= "1" height= "1">
</object>

<!-- MSXML3 Parser 설치 -->
<OBJECT ID="msxml3p" codebase='/cab/msxml3p.cab#version=8,40,9419,0' WIDTH="5" HEIGHT="5" CLASSID='clsid:3D813DFE-6C91-4A4E-8F41-04346A841D9C' type="application/x-oleobject">
</OBJECT>

</body>
</html>
