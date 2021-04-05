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

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MainReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<%@ include file="/common/CheckSession.jsp" %>
<%
	//세션정보이용
	//String strTopInOutGbn = (String)session.getValue("INOUT_GBN");
	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");
	//strTopIsRequesterGbn = true 이면 요구자(내부) -> 나의의정활동
	String strRequesterImg = "";
	String strRequesterInfoImg = "";
	if (strTopIsRequesterGbn.equals("true")){						//요구자 
		strRequesterImg = "image/main/req_top.gif";	
		strRequesterInfoImg = "image/main/info_top.gif";
	}
	else { 																	//제출자 
		strRequesterImg = "image/main/req_top_submit.gif";	
		strRequesterInfoImg = "image/main/info_top_submit.gif";
	}

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
	
	//TopMenu 를 위한 정보
	Hashtable objHshTopMenuList = new Hashtable();
	nads.dsdm.app.common.menu.MenuDelegate objTopMenu = new nads.dsdm.app.common.menu.MenuDelegate();
	ArrayList objAryTopMenu = new ArrayList();
	
	Hashtable objHshTopParam = new Hashtable();
	objHshTopParam.put("TOP_MENU_ID","0000000002");
	objHshTopParam.put("USER_ID",(String)session.getAttribute("USER_ID"));
	
	try{
		
		objAryTopMenu = objTopMenu.getTopMenuList(objHshTopParam);
		
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
 %>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
}
%>

<%
 /*************************************************************************************************/
 /** 					데이터 호출 Part  														  */
 /*************************************************************************************************/
	java.util.Hashtable objMainCntHashTop=null;//요구개수구하기 해쉬.
	boolean blnIsRequesterTop=false;
	RequestInfoDelegate objReqInfoTop=null;
	try{
  		blnIsRequesterTop=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
		/** 요구목록 출력 대리자.*/
		objReqInfoTop=new RequestInfoDelegate();
		objMainCntHashTop=objReqInfoTop.getMainReqCount((String)request.getSession().getAttribute("ORGAN_ID"),blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"));
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
 %>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
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

	String strArrImage[] = {"mypage", "reqsubmit", "infosearch", "forum", "board", "help"};
	//strArrImage[0] = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? "myactivity" : "mypage";
	String strFirstImage = "mypage";
	//String strFirstImage = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? "myactivity" : "mypage";
	 //배열의 크기를 줄일경우 에러발생(하단에서 호출)

	int iTopMenu = 0;
	for(int i=0; i<strArrImage.length; i++) {

		if(strTGbn.equals(strArrImage[i])) {
			strArrImage[i] += "_over";
			iTopMenu = 1;
		}

		strArrImage[i] = "/image/main/menu_"+strArrImage[i]+".gif";
	}
%>
     <div id="Layer1" style="position:absolute; left:295px; top:115px; width:609px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer1')" onMouseOver="showLayer('Layer1');MM_swapImage2('Image50','','image/main/menu_mypage_over.gif',1)"  >
        <table width="680" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_mypage">
          <tr>
            <td  css="menu_mypage" valign="bottom"> 
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
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
			  &nbsp;&nbsp;<img src="image/mypage/icon_mypage_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>            
              </td>
          </tr>
        </table>
      </div>
	  <div id="Layer2" style="position:absolute; left:295px; top:115px; width:589px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer1')" onMouseOver="showLayer('Layer2');MM_swapImage2('Image51','','image/main/menu_forum_over.gif',1)"  >
        <table width="600" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_forum">
          <tr>            
      <td align="center" valign="bottom"  css="menu_forum">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
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
      	&nbsp;&nbsp;&nbsp;<img src="image/forum/icon_forum_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>      	
        	</td>
          </tr>
        </table>
      </div>
	  <div id="Layer3" style="position:absolute; left:402px; top:115px; width:490px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer1')" onMouseOver="showLayer('Layer3');MM_swapImage2('Image52','','image/main/menu_board_over.gif',1)"  >
        <table width="490" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_board">
          <tr>            
      <td align="center" valign="bottom"  css="menu_board">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
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
      &nbsp;&nbsp;&nbsp;<img src="image/board/icon_board_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>      
        	</td>
          </tr>
        </table>
      </div>
	  <div id="Layer4" style="position:absolute; left:402px; top:115px; width:490px; height:21px; z-index:1; visibility: hidden;" onMouseOut="hideLayer('Layer1')" onMouseOver="showLayer('Layer4');MM_swapImage2('Image53','','image/main/menu_help_over.gif',1)"  >
        <table width="490" height="21" border="0" cellpadding="0" cellspacing="0" class="menu_help">
          <tr>            
      <td align="right" valign="bottom"  css="menu_help">
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
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
      &nbsp;&nbsp;&nbsp;<img src="image/help/icon_help_navi.gif" width="3" height="6" align="absmiddle"> <a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a>
<%
			}
		}
	}
%>       
        	</td>
          </tr>
        </table>
      </div>
      
      
<!-- 정보검색 테이블 시작 -->
<div id="Layer5" style="position:absolute; left:27px; top:63px; width:254px; height:301px; z-index:2; visibility: visible;"> 
  <table width="254" height="301" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td align="left" valign="top"><img src="<%=strRequesterInfoImg%>" width="254" height="69" border="0" usemap="#MapMap"></td>
    </tr>
    <tr> 
      <td width="254" height="181" align="center" valign="top" background="image/main/info_mid.gif"><table width="208" border="0" cellpadding="0" cellspacing="0" class="main_reqsubmit">
          <tr height="5"> 
            <td height="5" align="left" valign="top"></td>
          </tr>
<%
	if(objAryTopMenu != null){
		int intTopMenu = 0;
		
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
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
          <tr height="19"> 
            <td height="19" align="left" valign="top" class="main_infosearch"><img src="image/main/icon_info_enter.gif" width="6" height="8" align="texttop">&nbsp;<a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a></td>
          </tr>
<%
			}
		}
	}
%>          
        </table></td>
    </tr>
    <tr> 
      <td width="254" height="51" align="center" valign="top" background="image/main/info_bottom.gif"><table width="223" height="38" border="0" cellpadding="0" cellspacing="0">
          <tr height="17"> 
            <td height="19" align="left" valign="middle" background="image/main/bg_midab_info01.gif" class="special">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=RequestInfoDelegate.gotoMainMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>">미제출 
              자료&nbsp;&nbsp;&nbsp;&nbsp; : <strong><font color="02FAFD">&nbsp;<%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DIFF_SUM","0")%>&nbsp;</font></strong>개</a></td>
          </tr>
          <tr height="4"> 
            <td height="4"></td>
          </tr>
          <tr height="17"> 
            <td height="19" align="left" valign="middle" background="image/main/bg_midab_info02.gif" class="special">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=RequestInfoDelegate.gotoMainMoreLink(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"))%>">기한경과 
              자료 &nbsp;: <strong><font color="FBFE01">&nbsp;<%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DELAY_SUBMT","0")%>&nbsp;</font></strong>개</a></td>
          </tr>
        </table></td>
    </tr>
  </table>
  <map name="MapMap">
    <area shape="rect" coords="147,6,251,30" href="#" onClick="selLayer('reqLayer');">
    <area shape="rect" coords="11,11,129,52" href="<%=strInfoSearchURL%>">
  </map>
</div>
<!-- 자료요구 테이블 시작 -->
<div id="Layer6" style="position:absolute; left:27px; top:63px; width:254px; height:301px; z-index:3; visibility: visible;">
  <table width="254" height="301" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td align="left" valign="top"><img src="<%=strRequesterImg%>" width="254" height="69" border="0" usemap="#MapMap2"></td>
    </tr>
    <tr> 
      <td width="254" height="181" align="center" valign="top" background="image/main/req_mid.gif"><table width="208" border="0" cellpadding="2" cellspacing="0" class="main_reqsubmit">
          <tr height="5"> 
            <td height="5" align="left" valign="top"></td>
          </tr>

<!--------------------------- 2004-06-02 자료요구.제출(구.서류제출) 관련 메뉴 시작 ------------------------------------->
<%
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqTopMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	nads.lib.reqsubmit.util.ResultSetHelper objReqTopMenuRs = null;
	try {
		java.util.Hashtable hashOrgMenu = (java.util.Hashtable)objReqTopMenu.getOrgMenuList(String.valueOf(session.getAttribute("ORGAN_KIND")), strTopIsRequesterGbn);
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
%>
		<tr> 
		        <td height="21" align="left" valign="top" class="main_reqsubmit"><img src="image/main/icon_req_enter.gif" width="6" height="8" align="texttop">&nbsp;<a href="<%= strMenuPath+strMenuFileName+"?"+strMenuParam %>"><%= strMenuName %></a> </td>
		</tr>
<%			} else { %>
	 	<tr> 
		        <td height="21" align="left" valign="top" class="main_reqsubmit"><img src="image/main/icon_req_enter.gif" width="6" height="8" align="texttop">&nbsp;<a href="<%= strMenuPath+strMenuFileName %>"><%= strMenuName %></a> </td>
		</tr>
<%
				}
 			}
 		}
	} catch(kr.co.kcc.pf.exception.AppException e) {
		System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>
<!--------------------------- 2004-06-02 자료요구.제출(구.서류제출) 관련 메뉴 끝  ------------------------------------->		  

          <tr> 
            <td height="21" align="left" valign="top" class="main_reqsubmit">&nbsp;</td>
          </tr>
          <tr> 
            <td height="21" align="left" valign="top" class="main_reqsubmit">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td width="254" height="51" align="center" valign="top" background="image/main/req_bottom.gif"><table width="223" height="38" border="0" cellpadding="0" cellspacing="0">
          <tr height="17"> 
            <td height="19" align="left" valign="middle" background="image/main/bg_midab_01.gif" class="special">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				String strGoUrl = "";
				if(blnIsRequesterTop == false){
					strGoUrl = "/reqsubmit/25_total/30_reqlistsh/20_nonsub/TotalNonReqList.jsp";
				}else{
					strGoUrl = RequestInfoDelegate.getQuickLinkURL(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"), "N");
				}
			%>
			<a href="<%=strGoUrl%>">미제출 
              자료&nbsp;&nbsp;&nbsp;&nbsp; : <strong><font color="02FAFD">&nbsp;<%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DIFF_SUM","0")%>&nbsp;</font></strong>개</a></td>
          </tr>
          <tr height="4"> 
            <td height="4"></td>
          </tr>
          <tr height="17"> 
            <td height="19" align="left" valign="middle" background="image/main/bg_midab_02.gif" class="special">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=RequestInfoDelegate.getQuickLinkURL(blnIsRequesterTop,(String)request.getSession().getAttribute("ORGAN_KIND"), "N")%>">기한경과 
              자료 &nbsp;: <strong><font color="FBFE01">&nbsp;<%=nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objMainCntHashTop,"DELAY_SUBMT","0")%>&nbsp;</font></strong>개</a></td>
          </tr>
        </table></td>
    </tr>
  </table>
  <map name="MapMap2">
    <area shape="rect" coords="147,6,251,30" href="#" onClick="selLayer('srhLayer');">
    <area shape="rect" coords="11,11,129,52" href="<%=strReqSubmitURL%>">
  </map>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr height="364"> 
    <td height="364" align="left" valign="top" background="image/main/bg_right.gif">
	  <!-- 상위 테이블 시작 -->
	  <table width="900" height="364" border="0" cellpadding="0" cellspacing="0">
        <tr align="left" valign="top"> 
          <td width="27" height="364"><img src="image/main/bg_n_left.gif" width="27" height="364"></td>
          <td width="254" bgcolor="ffffff"><table width="254" height="90" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="254" height="51" align="left" valign="top"><a href="/main.jsp"><img src="image/main/logo.gif" width="254" height="51" border="0"></a></td>
              </tr>
              <tr> 
                <td height="12" align="left" valign="top"><img src="image/main/box_top.gif" width="254" height="12"></td>
              </tr>
              <tr>
                <td height="301" align="left" valign="top">&nbsp;</td>
              </tr>
            </table></td>
          <td width="10"><img src="image/main/bg_n_right.gif" width="13" height="364"></td>
          <td width="606"><table width="606" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="51" align="right" valign="bottom"><table width="105" border="0" cellspacing="0" cellpadding="0">
                    <tr align="right"> 
                      <td width="155"><a href="/main.jsp"><img src="image/main/home.gif" width="50" height="21" border="0"></a></td>
                      <td width="10"><a href="/sitemap/SiteMap.jsp"><img src="image/main/sitemap.gif" width="61" height="21" border="0"></a></td>
                      <td width="44"><a href="/help/BoardList.jsp"><img src="image/main/help.gif" width="43" height="21" border="0"></a></td>
                    </tr>
                    <tr height="8"> 
                      <td height="8"></td>
                      <td height="8"></td>
                      <td height="8"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="31" align="right" valign="middle" background="image/main/bg_login.gif"><table width="541" border="0" cellspacing="1" cellpadding="0">
                    <tr> 
                      <td width="457" align="right" valign="middle"><jsp:include page="/common/AdditionalJob.jsp" /></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="33" align="left" valign="top">
				  <!-- 메뉴 테이블 시작 -->
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="left" valign="top"> 
                      <td width="25%"><a href="<%=strMypageURL%>"  onMouseOver="MM_swapImage2('Image50','','image/main/menu_mypage_over.gif',1);MM_showHideLayers('Layer1','','show','Layer2','','hide','Layer3','','hide','Layer4','','hide')"><img src="image/main/menu_mypage.gif" name="Image50" width="153" height="33" border="0"></a></td>
                      <td width="25%"><a href="<%=strForumURL%>"  onMouseOver="MM_swapImage2('Image51','','image/main/menu_forum_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','show','Layer3','','hide','Layer4','','hide')"><img src="image/main/menu_forum.gif" name="Image51" width="152" height="33" border="0"></a></td>
                      <td width="2%"><a href="<%=strBoardURL%>"  onMouseOver="MM_swapImage2('Image52','','image/main/menu_board_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','show','Layer4','','hide')"><img src="image/main/menu_board.gif" name="Image52" width="150" height="33" border="0"></a></td>
                      <td width="48%"><a href="<%=strHelpURL%>"  onMouseOver="MM_swapImage2('Image53','','image/main/menu_help_over.gif',1);MM_showHideLayers('Layer1','','hide','Layer2','','hide','Layer3','','hide','Layer4','','show')"><img src="image/main/menu_help.gif" name="Image53" width="151" height="33" border="0"></a></td>
                    </tr>
                  </table>
				  <!-- 메뉴 테이블 끝 -->
				</td>
              </tr>
              <tr> 
                <td height="24" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr>
                <td width="606" height="195" align="left" valign="top"><script language="javascript" src="/js/main.js"></script></td>
              </tr>
              <tr> 
                <td height="30" align="right" valign="middle" background="image/main/bg_search.gif">
				  <!-- 검색 테이블 시작 -->
				  <%@ include file="/common/Search_main.jsp"%>
				</td>
              </tr>
            </table></td>
        </tr>
      </table>
	  <!-- 상위 테이블 끝 -->
