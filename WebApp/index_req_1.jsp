<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*" %>

<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="kr.co.kcc.bf.config.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" type="text/JavaScript">
<!--
	function fun_chgcomm(strHighGubn, strLowGubn){

		var vaComm = document.form_main.committee.value;

		var vaUrl = "/index_req_1.jsp?highgubn=" + strHighGubn + "&lowgubn=" + strLowGubn + "&comm=" + vaComm;

		window.location = vaUrl;

	}

	function fun_chgcomm_1(){

		var vaComm = document.form_main.committee.value;

		NewItem = new Option('관련기관을 선택하십시요', '', false, true);
		document.form_main.relorgan.options[0]=NewItem;
		document.MainRelOrgan.frmRecOrgan.comm.value = vaComm;
		document.MainRelOrgan.frmRecOrgan.submit();
	}	

	function fun_relhomepage(){

		var vaRelUrl = document.form_main.relorgan.value;

		var vaRelNm = document.form_main.relorgan.text;

		if (vaRelUrl == ""){

			alert("해당기관의 홈페이지가 없습니다");

		}else{

			window.open(vaRelUrl, vaRelNm);

		}	 

	}

	

	function fun_systemhomepage(){

		var vaRelUrl = document.form_main.select2.value;

		var vaRelNm = document.form_main.select2.text;

		if (vaRelUrl == ""){

			alert("해당기관의 홈페이지가 없습니다");

		}else{

			if (vaRelUrl == "http://www.assembly.go.kr:8000/guide/index.html"){

				window.open(vaRelUrl, vaRelNm, "status=yes,width=640,height=400");

			}else{

				window.open(vaRelUrl, vaRelNm);

			}

		}	 

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
//-->
</script>
<link href="css/Main.css" rel="stylesheet" type="text/css">
<link href="css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

<script src='/js/activity.js'></script>



<script language="javascript">
<!--
var objHTTP;
function Login_old()
{
//   alert("Login Messenger");
//   MessengerAgent.LogIn();
	if(objHTTP == null)
	{
		objHTTP = new ActiveXObject("Microsoft.XMLHTTP");
		//alert("objHTTP 생성");
    }
	objHTTP.Open('GET','/messenger/GetUserInfo.jsp', false);
	objHTTP.Send();

	var strResult = objHTTP.responseText;
	//alert(strResult);
	MessengerAgent.LogIn(strResult);
}

function Login()
{
	window.open("/common/LogInMessenger.jsp", "LogInMessenger", "status=no,resizable=no,menubar=no,scrollbars=no,width=1, height=1");
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

-->

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

%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('image/main/tab_newSubmitList_over.gif','image/main/tab_notice_over.gif','image/main/menu_mypage_over.gif','image/main/menu_forum_over.gif','image/main/menu_board_over.gif','image/main/menu_help_over.gif'); fun_chgcomm_1()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr height="364"> 
    <td height="364" align="left" valign="top" background="image/main/bg_right.gif">
<!-- MainTop.jsp-->
<%@ include file="main2/MainTop.jsp" %>
	</td>
  </tr>
  <tr> 
<form name="form_main" method="post" action="">
    <td align="left" valign="bottom"><table width="900" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top"> 
          <td width="27" background="image/main/bg_body_left.gif">&nbsp;</td>
          <td width="254" align="center" bgcolor="ffffff">
		    <!-- 좌측 테이블 시작 -->
<%@ include file="main2/MainLeft.jsp" %>
		    <!-- 좌측 테이블 끝 -->
			</td>
          <td width="13">&nbsp;</td>
          <td width="606" align="right" background="image/main/bg_body.gif">
		    <!-- 본문 테이블 시작 -->
			<table width="583" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
			  <tr><td>
			  <!-- 상위목록 테이블 시작 -->
<%@ include file="main2/MainHighTab.jsp" %>       
			  <!-- 상위목록 테이블 끝 -->
			  </td></tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
              </tr>
			  <tr><td>
			  <!-- 하위목록 테이블 시작 -->
<%@ include file="main2/MainLowTab.jsp" %>       
			  <!-- 하위 목록 테이블 끝 -->
			  </td></tr>
              <tr> 
                <td height="15" align="left" valign="top"></td>
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
<%@ include file="main2/MainBottom.jsp" %>          
    </td>
  </tr>
 </form>  
</table>
<!--
<map name="Map">
  <area shape="rect" coords="147,6,251,30" href="#">
  <area shape="rect" coords="11,11,129,52" href="#">
</map>
<-->
</body>
</html>
