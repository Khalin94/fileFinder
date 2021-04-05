<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	// 2005-07-27 kogaeng ADD
	// 예산결산특별위원회 소속 의원실에서 로그인을 했을 경우
	// 필요한 내용을 팝업 창으로 띄우기 위해서 아래 코드 추가
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;

	//이용자 정보 설정.
	try {
		objUserInfo = new UserInfoDelegate(request);
	} catch(AppException objAppEx) { 
		objMsgBean.setMsgType(nads.lib.message.MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode("SYS-00099");//세션 타임 아웃.
		response.sendRedirect("/login/Login4ReSession.jsp");
		return; 
	}
	
	//코드 정보 설정.
	objCdinfo = CDInfoDelegate.getInstance();

	// 예산결산특별위원회의 기관코드는 GI00004773
	String strBudgetCode = "GI00004773";
	boolean blnOpenPopup = false;
	if(objUserInfo.getIsMyCmtOrganID(strBudgetCode) && objUserInfo.isRequester()) blnOpenPopup = true;
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script src='/js/activity.js'></script>
<script src='/js/leftmenu.js'></script>
<script language="vbscript" src="/js/activex.vbs"></script>
<script src="/js/axkcase.js"></script>

<script language="JavaScript" type="text/JavaScript">
	function fun_chgcomm(strHighGubn, strLowGubn){
		var vaComm = document.form_main1.committee.value;
		var vaUrl = "/main.jsp?highgubn=" + strHighGubn + "&lowgubn=" + strLowGubn + "&comm=" + vaComm;
		window.location = vaUrl;
	}

	function fun_winopen(strUrl, strTitle){
		window.open(strUrl, strTitle, "status=yes, resizable=yes, menubar=yes,scrollbars=yes");
	}

	function fun_bottomhomepage(strUrl, strNm){
		window.open(strUrl, strNm);
	}

	function fun_bottomhomepage_pop(strUrl, strNm, width, height){
		//window.open(strUrl, strNm);
		var hWin=null;
		hWin = window.open(strUrl, strNm ,"toolbar=no,scrollbars=yes,left=1,top=1,width="+width+",height="+height+",resizable=no, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	function showLayer(layername){
		MM_swapImage2();
		var obj;
		if ((obj=MM_findObj(layername))!=null) {
			obj.style.visibility='visible';
		}
	}

	function hideLayer(layername){
		MM_swapImageRestore2();
		var obj;
		if ((obj=MM_findObj(layername))!=null) {
			obj.style.visibility='hidden';
		}
	}

	function MM_swapImageRestore2(){
	  var i,x,a=document.MM_srr; 
	  if(a==null || a=='null' || a=='undefinded') return;
	  for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_swapImage2(){
	  MM_swapImageRestore2();
	   var i,j=0,x,a=MM_swapImage2.arguments; document.MM_srr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_srr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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

	function MM_showHideLayers() { //v6.0
		var i,p,v,obj,args=MM_showHideLayers.arguments;
		for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
		if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
		obj.visibility=v; }
	}
</script>

<link href="css/Main.css" rel="stylesheet" type="text/css">
<link href="css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}

	MM_reloadPage(true);
</script>

<script language="javascript">
	var objHTTP;
	
	function Login_old() {
		//   alert("Login Messenger");
		//   MessengerAgent.LogIn();
		if(objHTTP == null) {
			objHTTP = new ActiveXObject("Microsoft.XMLHTTP");
			//alert("objHTTP 생성");
		}
		objHTTP.Open('GET','/messenger/GetUserInfo.jsp', false);
		objHTTP.Send();
		var strResult = objHTTP.responseText;
		//alert(strResult);
		MessengerAgent.LogIn(strResult);
	}

	function Login(vaGubn)
	{
		if(vaGubn == 'N'){
			window.open("/common/LogInMessenger.jsp", "LogInMessenger", "status=no,resizable=no,menubar=no,scrollbars=no,width=1, height=1, left=99999, top=99999");
		}
	}

	function Logout()
	{
		//   alert("Logout Messenger");
		MessengerAgent.LogOut();     
	}

	function Exit()
	{
		//   alert("Exit Messenger");
		MessengerAgent.Exit();
	}

</script>

<script language="JavaScript">
	var ie4 = (document.all) ? true : false;
	function selLayer(cmd){
		if (ie4) {
			if (cmd == "reqLayer"){
				//alert("자료요구");
				document.all.Layer5.style.display = "none";
				document.all.Layer6.style.display = "block";
			} else if(cmd == "srhLayer"){
				//alert("검색");
				document.all.Layer6.style.display = "none";
				document.all.Layer5.style.display = "block";
			}
		}
	}

	function getCookie(name) { 
		var Found = false 
		var start, end 
		var i = 0 
		while(i <= document.cookie.length) { 
			start = i 
			end = start + name.length 
			if(document.cookie.substring(start, end) == name) { 
				Found = true 
				break 
			} 
			i++ 
		} 
 		if(Found == true) { 
			start = end + 1 
			end = document.cookie.indexOf(";", start) 
			if(end < start) end = document.cookie.length 
			return document.cookie.substring(start, end) 
		} 
		return "" 
	} 
	 

</script>

<OBJECT ID="AxNAROK" CLASSID="CLSID:1966B8D2-9779-4B05-BE2D-30D55C2586A1" 
 codebase="/cab/AxKCASE(2.0.0.13).cab#Version=2,0,0,12" height="1" width="1">
</OBJECT>

<script language="javascript">
function checkCertification()
{
	
	var CERT_DN ,juminNo,ChangeDnYn;
	juminNo = '<%=session.getAttribute("CERT")%>';
	CERT_DN = '<%=session.getAttribute("CERT_DN")%>';
	//alert(juminNo);
	
	var certFrm = document.certFrm;
	alert('로그인시 사용한 인증서를 확인합니다.\n로그인시 선택한 인증서를 선택하십시오.');
	var retVal = ValidCert_VID(juminNo,certFrm.certDn,certFrm);
	if( retVal == true)
	{
	
		changeProcessImage(0);
		//alert("로그인 인증서 dn:"+CERT_DN); 
		//alert("선택한 인증서 dn:"+certFrm.certDn.value);
	
		if(CERT_DN == certFrm.certDn.value ){
		
			alert('새로 등록할 인증서를 선택하십시오.');
			if ( ValidCert_VID(juminNo,certFrm.certDn,certFrm) != true ){
				
				changeProcessImage(0);
				
			}else {

				changeProcessImage(1);
				document.certFrm.submit();

			}
			
			
		
		} else {
			
			alert("로그인한 인증서가 아닙니다.");
			changeProcessImage(0);

		}

	}

}

</script>

<script language="javascript">
//진행과정 이미지들
var isIE=document.all?true:false;
var isNS4=document.layers?true:false; 
var isNS6=navigator.userAgent.indexOf("Gecko")!=-1?true:false;// now change photo to next 
var arrProcessImg = new Array() 
    arrProcessImg[0]=new Image(); arrProcessImg[0].src='/image/main/procStep1On.gif';
    arrProcessImg[1]=new Image(); arrProcessImg[1].src='/image/main/procStep1Off.gif';
    arrProcessImg[2]=new Image(); arrProcessImg[2].src='/image/main/procStep2On.gif';
    arrProcessImg[3]=new Image(); arrProcessImg[3].src='/image/main/procStep2Off.gif';
    arrProcessImg[4]=new Image(); arrProcessImg[4].src='/image/main/procStep3On.gif';
    arrProcessImg[5]=new Image(); arrProcessImg[5].src='/image/main/procStep3Off.gif';


function changeProcessImage(procStep){ // 클릭했을때 이미지 변하게 하는 부분
  var procImg = document.all.procImg;
 if(isIE)
{
	 for(i=0; procImg.length > i ; i ++){
		procImg[i].src = arrProcessImg[i*2+1].src;

	 }
	 procImg[procStep].src = arrProcessImg[procStep*2].src;
}
 else if(isNS4)
   null;
 else if(isNS6)
   null;
} 
</script>
</head>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strHighGubn = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("highgubn"), "1");
	String strLowGubn = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("lowgubn"), "1");
	String strCommittee = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("comm"), "");
	String strUserId = (String)session.getAttribute("USER_ID");
	String strUserGubn = (String)session.getAttribute("IS_REQUESTER");
	String strMainOrganId = (String)session.getAttribute("ORGAN_ID");
	String strMsgOpenGbn = (String)session.getAttribute("MSG_OPEN_GBN");
%>

<!-- 2005-07-27
 kogaeng ADD onLoad 이벤트에 팝업 체크하는 부분 추가 -->
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('/image/main/tab_newReqBoxList_over.gif','/image/main/tab_newSubmitList_over.gif','/image/main/tab_notice_over.gif','/image/main/menu_mypage_over.gif','/image/main/menu_forum_over.gif','/image/main/menu_board_over.gif','/image/main/menu_help_over.gif'); fun_chgcomm_1(); Login('<%=strMsgOpenGbn%>')">

<!-- MainTop.jsp-->

<%@ include file="/common/PopUp.jsp" %>

<%@ include file="/main/MainTop.jsp" %>

	</td>
  </tr>
  <tr> 
    <td align="left" valign="bottom"><table width="900" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top"> 
          <td width="27" background="image/main/bg_body_left.gif">&nbsp;</td>
          <td width="254" align="center" bgcolor="ffffff">
		    <!-- 좌측 테이블 시작 -->
<form name="form_main1" method="post" action="">
<%@ include file="/main/MainLeft.jsp" %>
</form>
          <object classid="CLSID:E8BFD992-24A6-40BA-93EC-A4FDCF940E78" codebase="/cab/messenger/MessengerAgent.cab#version=1,0,0,3" width="0" height="0" id="MessengerAgent">
          </object>
<%
	if(strMsgOpenGbn.equals("N")){    //로그인 시만 메신저 다운메시지를 띠운다.(06.04)
%>          
          <SCRIPT for="MessengerAgent" event="OnMessengerInstall()" language="javascript">
	          window.open('/main/DownMsger_Pop.jsp','MsgerDown','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=no,width=286,height=211,left=0,top=0');		
          </SCRIPT>
<%
		session.setAttribute("MSG_OPEN_GBN","Y");
	}
%>		 
		    <!-- 좌측 테이블 끝 -->
			</td>
          <td width="13">&nbsp;</td>
<form name="form_main" method="post" action="">
          <td width="606" align="right" background="image/main/bg_body.gif">
		    <!-- 본문 테이블 시작 -->
			<table width="583" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="15" align="left" valign="top"></td>
              </tr>
			  <tr><td>
			  <!-- 인증서변경 테이블 시작 -->

				<table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">

                    <tr> 

                      <td width="25%" background="/image/mypage/bg_mypage_tit.gif">

                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>

                      		<span class="title">인증서 변경</span>

                      </td>

                      <td width="24%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>

                      <td width="51%" align="right" background="/image/common/bg_titLine.gif" class="text_s">


                      </td>

                    </tr>

                  </table>


			  <!-- 인증서변경 테이블 끝 -->
			  </td></tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
				<tr> 

                <td height="30" align="left" class="text_s">
				로그인시 사용할 인증서를 변경하는 절차입니다. <br>
				<font color='ff0000'>인증서를 변경하시면 기존의 인증서를 이용하여 로그인 할 수 없습니다.</font><br><br>
				1.  기존 인증서를 확인합니다..<br>
				2. 변경 등록할 인증서를 선택합니다.<br>
				3. 등록이 성공하면 변경한 인증서로 로그인하실 수 있습니다.<br>
				
				
				</td>
				</tr>
              <tr> 
                <td height="30" align="left" valign="top"></td>
              </tr>
				<tr> 

                <td height="30" align="left" class="text_s">

				

					
				<a href="javascript:checkCertification()"><img id=procImg src='/image/main/procStep1Off.gif' border=0>기존인증서확인</a>
				&nbsp;<img src="/image/main/arrow.gif" align=absmiddle >&nbsp;&nbsp;
				<img  id=procImg src='/image/main/procStep2Off.gif'>&nbsp;&nbsp;
				<img src="/image/main/arrow.gif" align=absmiddle>&nbsp;&nbsp; 
				<img  id=procImg src='/image/main/procStep3Off.gif'>
				
				
				</td>
				</tr>


            </table>
		    <!-- 본문 테이블 끝 -->
		  </td>
        </tr>
      </table>
 </td>
  </tr>
  <tr height="101"> 
    <td height="101" align="left" valign="top" background="image/main/bg_bot.gif">
<%@ include file="/main/MainBottom.jsp" %>          
    </td>
  </tr>
 </form>  
</table>

<form name='certFrm' action='./ChangeDnProc.jsp'  method='post'>
<input type=hidden name='retVal'>
<input type=hidden name='certDn'>
<input type=hidden name='juminNo'>
</form>


<%

	String ChangeDnYn = request.getParameter("ChangeDnYn");
	if(ChangeDnYn.equals("Y") == true) {
		out.println("<script>changeProcessImage(2)</script>");

	}else{
		out.println("<script>changeProcessImage(0)</script>");

	}


%>
</body>
</html>
