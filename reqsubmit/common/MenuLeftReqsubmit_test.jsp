<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>


<%
	
	

	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

	<%@ include file="RUserCodeInfoInc.jsp" %>

<%


	String strOrgGBN = objUserInfo.getOrganGBNCode();
	String strIsRequester = String.valueOf(objUserInfo.isRequester());
	String strImgName = null;
	if ("true".equalsIgnoreCase(strIsRequester)) strImgName = "req";
	else strImgName = "submit";

	// 2005-07-29 kogaeng ADD
	System.out.println("strOrgGBN : "+strOrgGBN);
	System.out.println("strIsRequester : "+strIsRequester);
	String strMenuCmtOrganID = "";
	if("004".equalsIgnoreCase(strOrgGBN)) {
		strMenuCmtOrganID = (String)objUserInfo.getOrganID();
	} else if ("003".equalsIgnoreCase(strOrgGBN)) {
		if(nads.lib.reqsubmit.util.StringUtil.isAssigned(request.getParameter("CmtOrganID"))) {
			strMenuCmtOrganID = request.getParameter("CmtOrganID");
		} else {
			nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate objMenuReqBox = new nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate();
			nads.lib.reqsubmit.util.ResultSetHelper objMenuCmtRs =  null;
			objMenuCmtRs = new nads.lib.reqsubmit.util.ResultSetHelper(objMenuReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(), 
																										nads.lib.reqsubmit.CodeConstants.REQ_ING_STT_002, 
																										nads.lib.reqsubmit.CodeConstants.REQ_BOX_STT_002));   
			if(objMenuCmtRs.next()) strMenuCmtOrganID = (String)objMenuCmtRs.getObject("CMT_ORGAN_ID");
		}
	}
	System.out.println("1111111");
%>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/leftmenu.js"></script>
<table width="186" border="0" cellpadding="0" cellspacing="0" background="/image/common/bg_left.gif">
  <tr> 
    <td align="left" valign="top"><img src="/image/reqsubmit/img_<%= strImgName %>.jpg" width="186" height="153"></td>
  </tr>
  <tr> 
    <td align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"> </td>
  </tr>
  <tr> 
    <td height="13" align="left" valign="top">
	<!------------------------------------------- MENU SCRIPT START ------------------------------------------->
		<script>
  			aux0 = gFld("","","", "");
		</script>

		<script> 
<%
	String strFileName = nads.lib.reqsubmit.util.FileUtil.getFileName(request.getRequestURI(), "/");
	// 기관구분코드에 따라서 다른 메뉴를 구성해줘야 한다.
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	
	// 2005-07-25 kogaeng ADD
	// 간사관련 기능을 체크해서 메뉴명을 제한해야 하므로 추가함
	nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate objCmtMngBean = new nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate();

	boolean blnMngUse = false;
	if(nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuCmtOrganID)) blnMngUse = (objCmtMngBean.getFLAG(strMenuCmtOrganID) > 1) ? true : false;
	else blnMngUse = false;
	
	nads.lib.reqsubmit.util.ResultSetHelper objMenuRs = null;
	nads.lib.reqsubmit.util.ResultSetSingleHelper objMenuRsSH = null;
	try {
		java.util.Hashtable hashOrgMenu = null;
		hashOrgMenu = (java.util.Hashtable)objMenu.getOrgMenuList(strOrgGBN, strIsRequester);
		objMenuRs = new nads.lib.reqsubmit.util.ResultSetHelper(hashOrgMenu);
		//objMenuRsSH = new nads.lib.reqsubmit.util.ResultSetSingleHelper(objMenu.getRefDepthID(strFileName, strOrgGBN)); 	
		objMenuRsSH = new nads.lib.reqsubmit.util.ResultSetSingleHelper(objMenu.getRefDepthID(request.getRequestURI(), strOrgGBN)); 	
 		
 		while(objMenuRs.next()) {
	 		String strMenuID = (String)objMenuRs.getObject("REQ_MENU_ID");
	 		String strMenuName = (String)objMenuRs.getObject("REQ_MENU_NM");
	 		String strRefMenuID = (String)objMenuRs.getObject("REF_ID");
	 		String strMenuPath = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_PATH"));
	 		String strMenuFileName = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_FILE_NAME"));
	 		String strMenuIndex = (String)objMenuRs.getObject("REF_MENU_INDEX");
	 		String strMenuDepth = (String)objMenuRs.getObject("MENU_DEPTH");
	 		String strOrderNum = (String)objMenuRs.getObject("ORDER_NUM");
	 			 		
	 		String strMenuParam = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRs.getObject("REQ_MENU_PARAM"));
	 		if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuParam)) {
	 			// strMenuParam = "?"+strMenuParam+"&index="+strMenuIndex+"&folderId="+strMenuID+"&step="+strMenuDepth;
	 			//strMenuParam = "?"+strMenuParam+"&index="+strMenuIndex+"&folderId="+strOrderNum+"&step="+strMenuDepth;
	 			strMenuParam = "?"+strMenuParam;
	 		} else {
	 			/*
	 			if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuFileName)) {
	 				strMenuParam = "?"+"index="+strMenuIndex+"&folderId="+strMenuID+"&step="+strMenuDepth;
	 			} else {
	 				strMenuParam = "";
	 			}
	 			*/
	 			strMenuParam = "";
	 		}

			// 2005-08-09 kogaeng ADD
			// 요구함 작성의 DB 등록된 URL과 파라미터 값을 수정
			// 2005-07-28 kogaeng EDIT
			// 간사 사용중이면 그대로 처리 하고 아닌 경우만 이름을 바꾸로 '간사승인요구함'은 뺀다.
			if (strRefMenuID.equalsIgnoreCase(strMenuID)) {
				if(blnMngUse) {
					out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
				} else {
					if("간사승인대기".equalsIgnoreCase(strMenuName)) {
						strMenuName = "접수완료";
						out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
					} else if ("간사승인완료".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
						out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
					}
				}
			} else {
				if(blnMngUse) {
					out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
				} else {
					if("간사승인대기".equalsIgnoreCase(strMenuName)) {
						strMenuName = "접수완료";
						out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
					} else if ("간사승인완료".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
						out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl2('../10_mem/20_reqboxsh/10_make/RMakeReqBoxList_test.jsp')\"));");
					}
				}
			}
	
 		}
	} catch(kr.co.kcc.pf.exception.AppException e) {
		System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>
		</script>

		<script>
		<%
			String strIdx = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRsSH.getObject("REF_MENU_INDEX"), "1");
			// String strFolderID = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRsSH.getObject("REQ_MENU_ID"), "2");
			String strFolderID = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objMenuRsSH.getObject("ORDER_NUM"), "2");
		%>
		initializeDocumentOnReload(<%= strIdx %>, <%= strFolderID %>);
  		</script>
<!------------------------------------------- MENU SCRIPT END ------------------------------------------->

	
	</td>
  </tr>
  <tr> 
    <td align="center" valign="top"><table width="173" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="left" valign="top"><img src="/image/reqsubmit/box_myreqsubmit_top.gif" width="173" height="37"></td>
        </tr>
        <tr> 
          <td align="center" valign="top" bgcolor="D1E2B3"><table width="87%" border="0" cellspacing="0" cellpadding="0">
              <tr height="5"> 
                <td width="10%" height="10"></td>
                <td width="90%" height="10"></td>
              </tr>

<% //------------------------------------------------- 요구 답변 개수 관련 내용 시작 -------------------------------------------------- %>
<%
 	java.util.Hashtable objLeftMenuMainCntHash = null;//요구개수구하기 해쉬.
 	boolean blnLeftMenuIsRequester = false;
 	nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate objLeftMenuReqInfo = null;
 	try {
   		blnLeftMenuIsRequester = Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();

   		objLeftMenuReqInfo = new nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate();
   		objLeftMenuMainCntHash = objLeftMenuReqInfo.getMainReqCount((String)request.getSession().getAttribute("ORGAN_ID"),blnLeftMenuIsRequester,(String)request.getSession().getAttribute("ORGAN_KIND"));
 	} catch(kr.co.kcc.pf.exception.AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
  		return;
 	}
%>
<% //------------------------------------------------- 요구 답변 개수 관련 내용 끝 -------------------------------------------------- %>

              <tr> 
                <td><img src="/image/reqsubmit/icon_box.gif" width="9" height="10"></td>
                <td valign="bottom"><font color="3e3e3e">요구 : <strong><%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"REQ_SUM","0") %></strong>건</font></td>
              </tr>
              <tr> 
                <td><img src="/image/reqsubmit/icon_box.gif" width="9" height="10"></td>
                <td valign="bottom"><font color="3e3e3e"><a href="<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getQuickLinkURL(Boolean.valueOf(strIsRequester).booleanValue(), strOrgGBN, "Y") %>">제출 : <strong><%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"SUBMT_SUM","0") %></strong> 
                  건</a></font></td>
              </tr>
              <tr> 
                <td><img src="/image/reqsubmit/icon_box.gif" width="9" height="10"></td>
                <td valign="bottom"><font color="3e3e3e"><a href="<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getQuickLinkURL(Boolean.valueOf(strIsRequester).booleanValue(), strOrgGBN, "N") %>">미제출 자료 : <strong><%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DIFF_SUM","0") %> </strong>개</a></font></td>
              </tr>
              <tr> 
                <td><img src="/image/reqsubmit/icon_box.gif" width="9" height="10"></td>
                <td valign="bottom"><font color="3e3e3e"><a href="<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getQuickLinkURL(Boolean.valueOf(strIsRequester).booleanValue(), strOrgGBN, "N") %>">기한경과자료 : <strong><%= nads.lib.reqsubmit.util.HashtableUtil.getEmptyIfNull(objLeftMenuMainCntHash,"DELAY_SUBMT","0") %></strong> 
                  개</a></font></td>
              </tr>
              <tr height="5"> 
                <td height="8"></td>
                <td height="8"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><img src="/image/reqsubmit/box_myreqsubmit_bot.gif" width="173" height="6"></td>
        </tr>
      </table></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<% if ("true".equalsIgnoreCase(strIsRequester)) {  // '요구' 권한 이라면 아래의 메뉴를 출력 %>
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','국회전자문서시스템')"><img src="/image/common/ban_elect_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('http://mail.assembly.go.kr','국회메일')"><img src="/image/common/ban_mail_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<% } else {  // '제출' 권한 이라면 아래의 메뉴를 출력 %>
   <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top">
	    <!-- %@ include file="/common/LeftLinkMenu.jsp" % -->	
		<%@ include file="/common/LeftOrganMenu_test.jsp" %>
	</td>
  </tr>
<% } %>
  <tr height="9"> 
    <td height="12" align="left" valign="top"></td>
  </tr>
</table>