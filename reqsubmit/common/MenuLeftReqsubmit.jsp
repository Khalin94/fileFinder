<%
	String strOrgGBN = objUserInfo.getOrganGBNCode();
	String strIsRequester = String.valueOf(objUserInfo.isRequester());
	String strImgName = null;
	if ("true".equalsIgnoreCase(strIsRequester)) strImgName = "req";
	else strImgName = "submit";

	// 2005-07-29 kogaeng ADD
	String strMenuCmtOrganID = "";
	if("004".equalsIgnoreCase(strOrgGBN)) {
		strMenuCmtOrganID = (String)objUserInfo.getOrganID();
	} else if ("003".equalsIgnoreCase(strOrgGBN)) {
		if(nads.lib.reqsubmit.util.StringUtil.isAssigned(request.getParameter("CmtOrganID"))) {
			strMenuCmtOrganID = request.getParameter("CmtOrganID");
		} else {

			if((objUserInfo.getCurrentCMTList()).size() > 0){
				strMenuCmtOrganID = "";
			}else{
			
			}
			
		}
	}
	System.out.println("strMenuCmtOrganID : "+strMenuCmtOrganID);
%>
<script src="/js/leftmenu.js"></script>
<script language="javascript">
	function fun_bottomhomemail(){
		document.formName1.action = " http://naps.assembly.go.kr/egsign/main/gate.jsp";
		document.formName1.target = "xxx";
		window.open('/egsign/blank.html', 'xxx', 'width=1000, height=800, resizable=yes, scrollbars=yes, toolbar=yes, status=yes, location=yes, menubar=yes, directories=yes');
		formName1.submit();
	}
</script>
<form name="formName1" method="POST">
<input type="hidden" name="MAILGUBUN" value="GO">
</form>
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
	// ��������ڵ忡 ���� �ٸ� �޴��� ��������� �Ѵ�.
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	
	// 2005-07-25 kogaeng ADD
	// ������� ����� üũ�ؼ� �޴����� �����ؾ� �ϹǷ� �߰���
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
		System.out.println("request.getRequestURI() : "+request.getRequestURI());
		System.out.println("strOrgGBN : "+strOrgGBN);
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
			// �䱸�� �ۼ��� DB ��ϵ� URL�� �Ķ���� ���� ����
			// 2005-07-28 kogaeng EDIT
			// ���� ������̸� �״�� ó�� �ϰ� �ƴ� ��츸 �̸��� �ٲٷ� '������ο䱸��'�� ����.
			if (strRefMenuID.equalsIgnoreCase(strMenuID)) {
				if(blnMngUse) {
					out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
				} else {
					if("������δ��".equalsIgnoreCase(strMenuName)) {
						strMenuName = "�����Ϸ�";
						out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
					} else if ("������οϷ�".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
						out.println("aux1 = insFld(aux0, gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
					}
				}
			} else {
				if(blnMngUse) {
					out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
				} else {
					if("������δ��".equalsIgnoreCase(strMenuName)) {
						strMenuName = "�����Ϸ�";
						out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
					} else if ("������οϷ�".equalsIgnoreCase(strMenuName)) {
						System.out.println("");
					} else {
						out.println("aux"+strMenuDepth+" = insFld(aux"+(Integer.parseInt(strMenuDepth)-1)+", gFld(\""+strMenuName+"\", \"null\", "+strMenuIndex+", "+strMenuDepth+", \"goUrl('"+strMenuPath+strMenuFileName+strMenuParam+"')\"));");
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
  
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<% if ("true".equalsIgnoreCase(strIsRequester)) {  // '�䱸' ���� �̶�� �Ʒ��� �޴��� ��� %>
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','��ȸ���ڹ����ý���')"><img src="/image/common/ban_elect_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomemail()"><img src="/image/common/ban_mail_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<% } else {  // '����' ���� �̶�� �Ʒ��� �޴��� ��� %>
   <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top">
	    <!-- %@ include file="/common/LeftLinkMenu.jsp" % -->	
		<%@ include file="/common/LeftOrganMenu.jsp" %>
	</td>
  </tr>
<% } %>
  <tr height="9"> 
    <td height="12" align="left" valign="top"></td>
  </tr>
</table>