<script language="JavaScript">
<!--
/**********************************************************
* SSO Agent가 떠있는지 확인
*   document.ISignLtw.IsRunning()
*   떠있을때 1, 죽었을때 0를 Return한다.
**********************************************************/
function checkSession()
{
    var isSession = '<%=session.getAttribute("ORGAN_ID")%>';
	
    if(isSession == 'null' || isSession ==''){
           if(document.ISignLtw.IsRunFromReg() == "1")
            {
                  
					window.location = "/login/Login4ReSession.jsp";
					
            }
            else
            {
                    window.location = "/index.html";
	
            }
    }
}
//-->

</script>

<script language="JavaScript">
	/*TopMenu 의 팝업을 위한 링크*/
	function openPopLeftMenu(url)
	{ //팝업창 띄우기
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=auto,left=1,top=1,width=800,height=600,resizable=yes, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	/*TopMenu 의 새창을 위한 링크*/
	function openNewWinLeftMenu(url)
	{ //새창 띄우기
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url);
		hWin.focus();
	}
</script>

<%
	//세션정보이용
//	String strTopInOutGbn = (String)session.getValue("INOUT_GBN");
	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");
	//strTopIsRequesterGbn = true 이면 요구자(내부)

	//메뉴id
	String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};

	String strArrMenu [] = new String[4];
	strArrMenu = strArrMenuId4Out;
	//strArrMenu = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? strArrMenuId4In : strArrMenuId4Out;

	//상단 큰 이미지 링크를 위한 변수
	String strMypageURL ="/activity/MyReqSubmitList.jsp";
	String strReqSubmitURL = "/reqsubmit/index.jsp";
	String strInfoSearchURL = "/infosearch/ISearch_All01.jsp";
	String strForumURL = "/forum/newinfo/ForumMain.jsp";
	String strBoardURL = "/board/BoardList.jsp";
	String strHelpURL = "/help/SystemIntroduction.jsp";
%>

<%
	//TopMenu 를 위한 정보
	//TopMenu 를 위한 정보
	java.util.Hashtable objHshTopMenuList = new java.util.Hashtable();
	//nads.dsdm.app.common.menu.MenuDelegate objTopMenu = new nads.dsdm.app.common.menu.MenuDelegate();
	java.util.ArrayList objAryTopMenu = new java.util.ArrayList();


	//java.util.Hashtable objHshTopParam = new java.util.Hashtable();
	//objHshTopParam.put("TOP_MENU_ID","0000000002");
	//objHshTopParam.put("USER_ID",(String)session.getAttribute("USER_ID"));


	try{
		objAryTopMenu = (java.util.ArrayList)session.getAttribute("TOP_MENU");
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}

%>

<script language="javascript" src="/js/ISignLtw.js"></script>


<!--세션 timeout과 sso존재여부를 판단하여 timeout시 이동 페이지를 설정--->
<script>checkSession(); </script>

<%
	if(session.getAttribute("ORGAN_KIND") == null)
	{
		return;
	}
%>


<!--메뉴 시작--->
<%
	String strTURL = request.getRequestURI();
	String strTGbn = strTURL.substring(1,strTURL.length());
	if(strTGbn.indexOf("/") >0 )
		strTGbn = strTGbn.substring(0,strTGbn.indexOf("/"));

	// mypage : 나의폐이지
	// reqsubmit : 서류제출
	// infosearch : 정보검색
	// forum : 포럼
	// board : 게시판
	// help : 이용안내

	String strArrURL[] =  {"activity", "reqsubmit", "infosearch", "forum", "board", "help"}; //URL 비교할때 사용하는 변수
	String strArrImage[] = {"mypage", "reqsubmit", "infosearch", "forum", "board", "help"};
	strArrImage[1] = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? "req" : "submit"; //서류 요구/제출에 따라 이미지 변경
	String strReqSubmitImage = strArrImage[1];

	String strArrDirNmTopMenu[] = {"mypage", "reqsubmit", "infosearch", "forum", "board", "help"};
	String strArrMenuImgTopMenu[] = {"img_mypage", "img_reqsubmit", "img_infosearch", "img_forum", "img_board", "img_help"};
	strArrMenuImgTopMenu[1] = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? "img_req" : "img_submit"; //서류 요구/제출에 따라 이미지 변경
	String strArrDirNmTopMenu4Left = "";
	String strArrMenuImgTopMenu4Left = "";

	 //배열의 크기를 줄일경우 에러발생(하단에서 호출)

	int iTopMenu = 0;
	for(int i=0; i<strArrImage.length; i++) {

		if(strTGbn.equals(strArrURL[i])) {
			strArrImage[i] += "_over";
			iTopMenu = 1;

			strArrDirNmTopMenu4Left = strArrDirNmTopMenu[i];
			strArrMenuImgTopMenu4Left = strArrMenuImgTopMenu[i];

		}

		strArrImage[i] = "/image/common/smenu_"+strArrImage[i]+".gif";
	}

	if(strTGbn.equals("sitemap")) {
		strArrDirNmTopMenu4Left = "sitemap";
		strArrMenuImgTopMenu4Left = "img_sitemap";
	}
%>

<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('/image/common/smenu_mypage_over.gif','/image/common/smenu_<%=strReqSubmitImage%>_over.gif','/image/common/smenu_infosearch_over.gif','/image/common/smenu_forum_over.gif','/image/common/smenu_board_over.gif','/image/common/smenu_help_over.gif')">

<div id="Layer1" style="position:absolute; left:208px; top:116px; width:763px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer1')" onMouseOver="showLayer('Layer1');MM_swapImage2('Image29','','/image/common/smenu_mypage_over.gif',1)"  >
        <table width="760" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_mypage">
          <tr>
            <td  css="menu_mypage" valign="bottom">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;

		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (java.util.Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";

			if(strTopPMenuID.equals(strArrMenu[0])) {
				intTopMenu ++;
				if(intTopMenu==1) { //상단 큰이미지 링크URL
					strMypageURL = strTopGoURL;
				}
%>
				&nbsp;&nbsp;<img src="/image/mypage/icon_mypage_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		} //end for
	}
%>
			</td>
          </tr>
        </table>
      </div>
	  	  <div id="Layer2" style="position:absolute; left:208px; top:116px; width:763px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer2')" onMouseOver="showLayer('Layer2');MM_swapImage2('Image29','','/image/common/smenu_<%=strReqSubmitImage%>_over.gif',1)"  >
        <table width="760" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_reqsubmit">
          <tr>
            <td  css="menu_reqsubmit" valign="bottom">
<%
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqTopMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	nads.lib.reqsubmit.util.ResultSetHelper objReqTopMenuRs = null;
	try {
		java.util.Hashtable hashOrgMenu = (java.util.Hashtable)session.getAttribute("TOP_MENU_SUB");
		objReqTopMenuRs = new nads.lib.reqsubmit.util.ResultSetHelper(hashOrgMenu);
	
 		while(objReqTopMenuRs.next()) {
	 		String strMenuID = (String)objReqTopMenuRs.getObject("REQ_MENU_ID");
	 		String strMenuName = (String)objReqTopMenuRs.getObject("REQ_MENU_NM");
	 		String strRefMenuID = (String)objReqTopMenuRs.getObject("REF_ID");
	 		String strMenuPath = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqTopMenuRs.getObject("REQ_MENU_PATH"));
	 		String strMenuFileName = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqTopMenuRs.getObject("REQ_MENU_FILE_NAME"));
	 		String strMenuParam = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqTopMenuRs.getObject("REQ_MENU_PARAM"));
	 		if (strRefMenuID.equalsIgnoreCase(strMenuID)) {
	 			if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuParam)) {
	 				out.println("&nbsp;&nbsp;<img src='/image/reqsubmit/icon_reqsubmit_navi.gif' width='3' height='6'> <a href='"+strMenuPath+strMenuFileName+"?"+strMenuParam+"'>"+strMenuName+"</a>");
	 			} else {
	 				out.println("&nbsp;&nbsp;<img src='/image/reqsubmit/icon_reqsubmit_navi.gif' width='3' height='6'> <a href='"+strMenuPath+strMenuFileName+"'>"+strMenuName+"</a>");
	 			}
 			}
 		}

	} catch(Exception e) {
		//System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>
			</td>
          </tr>
        </table>
      </div>

		<div id="Layer3" style="position:absolute; left:208px; top:116px; width:763px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer3')" onMouseOver="showLayer('Layer3');MM_swapImage2('Image29','','/image/common/smenu_infosearch_over.gif',1)"  >
        <table width="760" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_infosearch">
          <tr>
            <td  css="menu_infosearch" valign="bottom">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;

		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (java.util.Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";

			if(strTopPMenuID.equals(strArrMenu[2])) {
				intTopMenu ++;
				if(intTopMenu==1) { //상단 큰이미지 링크URL
					strInfoSearchURL = strTopGoURL;
				}
%>
				&nbsp;&nbsp;<img src="/image/infosearch/icon_infosearch_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>
			</td>
          </tr>
        </table>
      </div>

	<div id="Layer4" style="position:absolute; left:248px; top:116px; width:728px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer4')" onMouseOver="showLayer('Layer4');MM_swapImage2('Image29','','/image/common/smenu_forum_over.gif',1)"  >
        <table width="718" height="19" border="0" cellpadding="0" cellspacing="0" class="menu_forum">
          <tr>            
			<td align="center" valign="bottom"  css="menu_forum">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;

		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (java.util.Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";

			if(strTopPMenuID.equals(strArrMenu[3])) {
				intTopMenu ++;
				if(intTopMenu==1) { //상단 큰이미지 링크URL
					strForumURL = strTopGoURL;
				}
%>
				&nbsp;&nbsp;<img src="/image/forum/icon_forum_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>
			</td>
          </tr>
        </table>
      </div>
	       <div id="Layer5" style="position:absolute; left:486px; top:115px; width:500px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer5')" onMouseOver="showLayer('Layer5');MM_swapImage2('Image29','','/image/common/smenu_board_over.gif',1)"  >
        <table width="500" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_board">
          <tr>            
      <td align="center" valign="bottom"  css="menu_board">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;

		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (java.util.Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";
			

			if(strTopPMenuID.equals(strArrMenu[4])) {
				intTopMenu ++;
				if(intTopMenu==1) { //상단 큰이미지 링크URL
					strBoardURL = strTopGoURL;
				}
				if(strTopDisplayKind.equals("001"))
					strTopGoURL += "&folderId=" + intTopMenu;

%>
				&nbsp;&nbsp;<img src="/image/board/icon_board_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>
			</td>
          </tr>
        </table>
      </div>
	  	<div id="Layer6" style="position:absolute; left:481px; top:116px; width:490px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer6')" onMouseOver="showLayer('Layer6');MM_swapImage2('Image29','','/image/common/smenu_help_over.gif',1)"  >
        <table width="490" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_help">
          <tr>            
      <td align="right" valign="bottom"  css="menu_help">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (java.util.Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";

			if(strTopPMenuID.equals(strArrMenu[5])) {
				intTopMenu ++;
				if(intTopMenu==1) { //상단 큰이미지 링크URL
					strHelpURL = strTopGoURL;
				}
%>
				&nbsp;&nbsp;<img src="/image/help/icon_help_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>
		</td>
          </tr>
        </table>
      </div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="left" valign="top">
    <td height="51" colspan="2"><table width="975" height="51" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top">
          <td width="316"><a href="/main.jsp"><img src="/image/common/logo_sub.gif" width="316" height="51" border=0></a></td>
          <td width="659" align="right" valign="bottom"><table width="105" border="0" cellspacing="0" cellpadding="0">
              <tr align="right"> 
                <td width="155"><a href="/main.jsp"><img src="/image/main/home.gif" width="50" height="21" border=0></a></td>
                <td width="10"><a href="/sitemap/SiteMap.jsp"><img src="/image/main/sitemap.gif" width="61" height="21" border=0></a></td>
                <td width="44"><a href="/help/OnlineManual.jsp"><img src="/image/main/help.gif" width="43" height="21" border=0></a></td>
              </tr>
              <tr height="8"> 
                <td height="8"></td>
                <td height="8"></td>
                <td height="8"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="31" colspan="2" bgcolor="B0ADA2"><table width="975" height="31" border="0" cellpadding="0" cellspacing="0" background="/image/common/bg_login_sub.gif">
        <tr background="/image/common/bg_login_sub.gif">
          <td width="317">
			<!-- TopMenu_Search.jsp 와 include 파일만 다르다 -->
			<%@ include file="/common/Search.jsp"%>
		  </td>
          <td width="658" align="right" valign="middle">
			<jsp:include page="/common/AdditionalJob.jsp" />
			</td>
        </tr>
      </table></td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="34" colspan="2" background="/image/common/bg_menu_right.gif"><table width="975" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top"> 
          <td width="186" align="left" valign="top"><img src="/image/<%=strArrDirNmTopMenu4Left%>/<%=strArrMenuImgTopMenu4Left%>_top.jpg" width="186" height="34"></td>
          <td><a href="<%=strMypageURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image35','','/image/common/smenu_mypage_over.gif',1);MM_showHideLayers('Layer1','','show','Layer2','','hide','Layer3','','hide','Layer4','','hide','Layer5','','hide','Layer6','','hide')"><img src="<%=strArrImage[0]%>" name="Image35" width="130" height="34" border="0"></a></td>
            
          <td><a href="<%=strReqSubmitURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image47','','/image/common/smenu_<%=strReqSubmitImage %>_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','show','Layer3','','hide','Layer4','','hide','Layer5','','hide','Layer6','','hide')"><img src="<%=strArrImage[1]%>" name="Image47" width="130" height="34" border="0"></a></td>
            
          <td><a href="<%=strInfoSearchURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image48','','/image/common/smenu_infosearch_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','show','Layer4','','hide','Layer5','','hide','Layer6','','hide')"><img src="<%=strArrImage[2]%>" name="Image48" width="131" height="34" border="0"></a></td>
            
          <td><a href="<%=strForumURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image49','','/image/common/smenu_forum_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','hide','Layer4','','show','Layer5','','hide','Layer6','','hide')"><img src="<%=strArrImage[3]%>" name="Image49" width="131" height="34" border="0"></a></td>
            
          <td><a href="<%=strBoardURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image50','','/image/common/smenu_board_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','hide','Layer4','','hide','Layer5','','show','Layer6','','hide')"><img src="<%=strArrImage[4]%>" name="Image50" width="131" height="34" border="0"></a></td>
            
          <td><a href="<%=strHelpURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','/image/common/smenu_help_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','hide','Layer4','','hide','Layer5','','hide','Layer6','','show')"><img src="<%=strArrImage[5]%>" name="Image51" width="136" height="34" border="0"></a></td>
          </tr>
      </table></td>
  </tr>
</table>
