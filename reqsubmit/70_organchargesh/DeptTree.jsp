<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>

<%@ page import="nads.dsdm.app.common.code.CodeInfoDelegate" %>

<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.searchrelorgan.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%

	String strChkOrd = StringUtil.getNVL( request.getParameter("strChkOrd"), "Y" );

	String strOrganID = StringUtil.getNVL(request.getParameter("strOrganID"), "GI00001533" );

	String strLinkGbn = StringUtil.getNVL(request.getParameter("strLinkGbn"), "-_LINK") ;

	String strLVL = StringUtil.getNVL(request.getParameter("strLVL"), "1") ;

	String strSttCDChk = StringUtil.getNVL(request.getParameter("strSttCDChk"), "001") ;

    String strStart =  StringUtil.getNVL(request.getParameter("strStart"), "0") ;

	//out.println(strOrganID);

	int intLVL = Integer.parseInt(strLVL);

	if (strLinkGbn.equals("-_LINK") ) {
		intLVL++;
	}

	CodeInfoDelegate objCodeInfoDelegate = new CodeInfoDelegate();

	SearchOrganDelegate objSearchOrgan = new SearchOrganDelegate();

	/** 부서목록(Tree용) */
	ArrayList objList = null;

	try {

//		if (strOrganID.equals("")) {
//			// 최상위 레벨 조회
//			objList = SearchOrganDelegate.getTopListInOrganChart(strChkOrd);
//		}
//		else {
//			// 아래 조직도를 조회
			System.out.println(strChkOrd+" "+strOrganID+" "+intLVL+" "+strLinkGbn+" "+strSttCDChk);
			objList = objSearchOrgan.getListInOrganChart( strChkOrd, strOrganID, intLVL, strLinkGbn, strSttCDChk );
//		}


	}
	catch (AppException objAppEx) {

		//에러 발생 메세지 페이지로 이동한다.
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("부서 목록 조회 중 에러 발생 || 메세지 페이지로 이동");
%>
		<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>




	<script language="JavaScript" type="text/JavaScript">
	<!--
		function getDeptInfo(varOrganID, varPriorOrganID) {
			frmList.strOrganID.value = varOrganID;
			frmList.strPriorOrganID.value = varPriorOrganID;
			frmList.action = "DeptInfo.jsp";
			frmList.target = "info";
			frmList.submit();
		}
		function reload() {
			frmTree.strChkOrd.value = "N";
			frmTree.submit();
		}
		function reloadORD() {
			frmTree.strChkOrd.value = "Y";
			frmTree.submit();
		}
		function searchOrganChar(varOrganID, varLinkGbn, varLVL) {
			frmTree.strOrganID.value = varOrganID;
			frmTree.strLinkGbn.value = varLinkGbn;
			frmTree.strLVL.value = varLVL;
			frmTree.submit();
		}
	//-->
	</script>
	<link href="/css/Main.css" rel="stylesheet" type="text/css">
	<link href="/css/global.css" rel="stylesheet" type="text/css">
	<link href="/css/System.css" rel="stylesheet" type="text/css">
	<!--------------------------Tree 관련 스크립트 Start--------------------------------->
	<SCRIPT LANGUAGE="JavaScript" src="../js/common.js"></SCRIPT>
	<!--------------------------Tree 관련 스크립트 End--------------------------------->
</head>


  <table width="200" border="0" cellpadding="0" cellspacing="1" bgcolor="cccccc">
      <tr>

        <td align="left" valign="top" bgcolor="ffffff">
		<table width="200" border="0" cellspacing="0" cellpadding="8">
            <tr>
              <td align="left" valign="top" width=200>

<form name="frmTree" method="post" action="DeptTree.jsp#link_here">
<input type="hidden" name="strStart" value="<%=strStart%>">
			<table cellspacing="0" cellpadding="0"  style='position:block;'>
			<tr><td valign="top" nowrap></td></tr>
<%
			String strStep = "";
			String strOrganNm = "";
			String strListOrganId = "";
			String strPriorOrganId = "";
			String strOrganGbn = "";
			String strListLinkGbn = "";
			int intStep = 0;
			for (int i = 0; i < objList.size(); i++) {
				strStep = ((String)((Hashtable)objList.get(i)).get("LVL")).trim() ;
				strOrganNm = ((String)((Hashtable)objList.get(i)).get("ORGAN_NM")).trim() ;
				strListOrganId = ((String)((Hashtable)objList.get(i)).get("ORGAN_ID")).trim() ;
				strPriorOrganId = (String)((Hashtable)objList.get(i)).get("P_ORGAN_ID");
				strOrganGbn = (String)((Hashtable)objList.get(i)).get("ORGAN_GBN");
				strListLinkGbn = (String)((Hashtable)objList.get(i)).get("LINK_GBN");
				intStep = Integer.parseInt(strStep);
%>
			<tr><td valign="top" nowrap>
<%
				for (int j = 0; j < intStep; j++) {
%>
				<img src="/image/menu/ftv2blank.gif" align="absmiddle">
<%
				}
				if (strOrganID.equals(strListOrganId)) {
					strListLinkGbn = strLinkGbn;
%>
					<a name="link_here"></a>
<%
				}
				if (strListLinkGbn.equals("NO_LINK")) {
%>
					<img src="/image/menu/ftv2mnode2.gif" align="absmiddle">
					<a href="javascript:void(0)" onclick="javascript:parent.document.frames['userlist'].location.href='/reqsubmit/70_organchargesh/UserList.jsp?OrganId=<%=strListOrganId%>'"><img src="/image/reqsubmit/icon_library.gif" border="0" align="absmiddle"><%=strOrganNm%></a>
<%
				} else if (strListLinkGbn.equals("+_LINK")) {
%>
					<a href="javascript:searchOrganChar('<%=strListOrganId%>', '-_LINK', '<%=strStep%>');"><img src="/image/menu/ftv2pnode2.gif" border="0" align="absmiddle"></a>
					<a href="javascript:void(0)" onclick="javascript:parent.document.frames['userlist'].location.href='/reqsubmit/70_organchargesh/UserList.jsp?OrganId=<%=strListOrganId%>'"><img src="/image/reqsubmit/icon_folder.gif" border="0" align="absmiddle"><%=strOrganNm%></a>
<%
				} else {
%>
					<a href="javascript:searchOrganChar('<%=strListOrganId%>', '+_LINK', '<%=strStep%>');"><img src="/image/menu/ftv2mnode2.gif" border="0" align="absmiddle"></a>
					<a href="javascript:void(0)" onclick="javascript:parent.document.frames['userlist'].location.href='/reqsubmit/70_organchargesh/UserList.jsp?OrganId=<%=strListOrganId%>'"><img src="/image/reqsubmit/icon_library.gif" border="0" align="absmiddle"><%=strOrganNm%></a>
<%
				}
%>

			</td></tr>
<%
			}
%>
			<tr><td></td></tr>
			</table>

	<input type="hidden" name="strChkOrd" value="<%=strChkOrd%>">
	<input type="hidden" name="strOrganID" value="">
	<input type="hidden" name="strLinkGbn" value="">
	<input type="hidden" name="strLVL" value="">
</form>
<form name="frmList" method="post">
	<input type="hidden" name="strOrganID" value="">
	<input type="hidden" name="strPriorOrganID" value="">
</form>

		  </td>
        </tr>
      </table>
	  </td>
  </tr>
</table>
<script>
    var strStart = frmTree.strStart.value;
    if (strStart=='0'){
        frmTree.strStart.value = '1';
        searchOrganChar("GI00004737", "-_LINK", "1");
    }
</script>