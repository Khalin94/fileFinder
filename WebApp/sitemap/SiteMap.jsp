<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
    String strIsRequester = String.valueOf(objUserInfo.isRequester());
	//세션정보이용
    //String strTopInOutGbn = (String)session.getValue("INOUT_GBN");
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
	String ORGAN_KIND = (String)session.getAttribute("ORGAN_KIND").toString();
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
<jsp:include page="../inc/header.jsp" flush="true"/>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu05.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu05.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(../images2/foundation/stl_bg_site.gif) no-repeat left top;">
        <h3>사이트맵</h3>
        <div class="navi"><img src="../images2/foundation/home.gif" width="13" height="11" /> > 사이트맵
        </div>
      </div>
      <!-- /pgTit -->

      <!-- contents -->
        <div id="contents">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-bottom:50px;">
            <tr>
                <td width="10">&nbsp;</td>
                <td width="138" height="265" valign="top"  style=" background:url(../images2/sitem/bg.gif) no-repeat;">
                    <table width="138" border="0" cellspacing="0" cellpadding="0" >
                        <tr>
                            <td><img src="../images2/sitem/tl01.gif" width="137" height="53" /></td>
                        </tr>
                        <tr>
                            <td >
                            <ul>
<%
	String strSiteMapMenuTitle_ReqSubmit = (strIsRequester !=null && strIsRequester.equals("true")) ? "자료요구" : "자료제출";
%>

<%
	if(objAryTopMenu != null){
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
                if (!(!(ORGAN_KIND.equals("006"))&&strTopMenuNM.equals("기관정보관리"))){
%>
				  <li class="site_t"><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
                }
			}
		}
	}
%>

                            </ul>
                            </td>
                        </tr>
                    </table>
                </td>


                <td width="10">&nbsp;</td>
                <td width="138" height="265" valign="top"  style=" background:url(../images2/sitem/bg.gif) no-repeat;">
                    <table width="138" border="0" cellspacing="0" cellpadding="0" >
                        <tr>
                        <%if(strIsRequester.equals("true")){%>
                            <td><img src="../images2/sitem/tl02.gif" width="137" height="53" /></td>
                        <%}else{%>
                            <td><img src="../images2/sitem/tl02_2.gif" width="137" height="53" /></td>
                        <%}%>
                        </tr>
                        <tr>
                            <td >
                            <ul>
<%
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqSitemap = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	nads.lib.reqsubmit.util.ResultSetHelper objReqSitemapRs = null;
	try {
		java.util.Hashtable hashOrgMenu = (java.util.Hashtable)objReqSitemap.getOrgMenuList(String.valueOf(session.getAttribute("ORGAN_KIND")), strIsRequester);
		objReqSitemapRs = new nads.lib.reqsubmit.util.ResultSetHelper(hashOrgMenu);

 		while(objReqSitemapRs.next()) {
	 		String strMenuID = (String)objReqSitemapRs.getObject("REQ_MENU_ID");
	 		String strMenuName = (String)objReqSitemapRs.getObject("REQ_MENU_NM");
	 		String strRefMenuID = (String)objReqSitemapRs.getObject("REF_ID");
	 		String strMenuPath = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_PATH"));
	 		String strMenuFileName = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_FILE_NAME"));
	 		String strMenuParam = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_PARAM"));

	 		if (strRefMenuID.equalsIgnoreCase(strMenuID)&&!strMenuName.equals("국회의원 비전자 요구")) {
	 			if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuParam)) {
%>
					 <li class="site_t"><a href="<%= strMenuPath+strMenuFileName+"?"+strMenuParam %>">&nbsp;<%= strMenuName %></a></li>
<% 			} else {
%>

                     <li class="site_t"><a href="<%= strMenuPath+strMenuFileName %>">&nbsp;<%= strMenuName %></a></li>

<%
	 			}
 			}
 		}

	} catch(kr.co.kcc.pf.exception.AppException e) {
		System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>

                            </ul>
                            </td>
                        </tr>
                    </table>
                </td>



                <td width="10">&nbsp;</td>
                <td width="138" height="265" valign="top"  style=" background:url(../images2/sitem/bg.gif) no-repeat;">
                    <table width="138" border="0" cellspacing="0" cellpadding="0" >
                        <tr>
                            <td><img src="../images2/sitem/tl03.gif" width="137" height="53" /></td>
                        </tr>
                        <tr>
                            <td >
                            <ul>
<%
	if(objAryTopMenu != null){
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

			if(strTopPMenuID.equals(strArrMenu[2])&&!strTopMenuNM.equals("인기 검색어")) {
%>
				  <li class="site_t"><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>

                            </ul>
                            </td>
                        </tr>
                    </table>
                </td>


                <td width="10">&nbsp;</td>
                <td width="138" height="265" valign="top"  style=" background:url(../images2/sitem/bg.gif) no-repeat;">
                    <table width="138" border="0" cellspacing="0" cellpadding="0" >
                        <tr>
                            <td><img src="../images2/sitem/tl04.gif" width="137" height="53" /></td>
                        </tr>
                        <tr>
                            <td >
                            <ul>
<%
	if(objAryTopMenu != null){
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

			if(strTopPMenuID.equals(strArrMenu[4])&&!strTopMenuNM.equals("자유게시판")) {
%>
				  <li class="site_t"><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>

                            </ul>
                            </td>
                        </tr>
                    </table>
                </td>


                <td width="10">&nbsp;</td>
                <td width="138" height="265" valign="top"  style=" background:url(../images2/sitem/bg.gif) no-repeat;">
                    <table width="138" border="0" cellspacing="0" cellpadding="0" >
                        <tr>
                            <td><img src="../images2/sitem/tl05.gif" width="137" height="53" /></td>
                        </tr>
                        <tr>
                            <td >
                            <ul>
<%
	if(objAryTopMenu != null){
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
%>
				  <li class="site_t"><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>

                            </ul>
                            </td>
                        </tr>
                    </table>
                </td>


              </tr>
          </table>
      </div>
    </div>
  </div>
    <jsp:include page="/inc/footer.jsp" flush="true"/>
    </div>
</body>
</html>