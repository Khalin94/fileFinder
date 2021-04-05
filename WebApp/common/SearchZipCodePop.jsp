<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.common.zipinfo.ZipInfoDelegate"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%

	// 화면에 입력한 동
	String strDong = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strDong")));
	
	// 현재 페이지 번호
	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));
	
	// 페이지당 row의 갯수
	String strCountPerPage;
	
	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}
	
	
	// 우편번호 목록
	ArrayList objZipInfoLists = null;
	int intTotalCount = 0;
	
	if ( !strDong.equals("") ) {	
		try {
			
			ZipInfoDelegate objZipInfoDelegate = new ZipInfoDelegate();
			Hashtable objParams = new Hashtable(0);
			objParams.put("strDong", strDong);
			
			objZipInfoLists = objZipInfoDelegate.getZipInfoListPerPage(strCurrentPage, strCountPerPage, objParams);
		}
		catch (AppException objAppEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
	
			// 에러 발생 메세지 페이지로 이동한다.
	%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
	<%
			return;
	
		}
		intTotalCount = Integer.parseInt( (String)((Hashtable)objZipInfoLists.get(0)).get("TOTAL_COUNT") );
	}
	else {
		intTotalCount = 0;
	}
	
%>

<html>
<head>
<title>우편번호 찾기</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/formchek.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function Close(){
	self.close();
}
function setCurrPage(varCurrPage) {
	document.frm1.strCurrentPage.value = varCurrPage;
}
function goPage(varCurrPage) {
	if (isSearch()) {
		setCurrPage(varCurrPage);
		document.frm1.submit();
	}
}
function selectZipCd(varZipCd1, varZipCd2, varAddr1) {
	if (opener != null) {
		opener.selectZipCd(varZipCd1, varZipCd2, varAddr1);
	}
}
function goSearch() {
	if (isSearch()) {
		document.frm1.submit();
	}
}
function isSearch() {

	// 우편번호 동을 입력했는지 확인한다.
	if ( !isValidatestrDong() ) {
		return false;
	}
	return true;

}
function isValidatestrDong() {
	if (isWhitespace(document.frm1.strDong.value)) {
		alert("우편번호의 동을 입력하십시요!");
		return false;
	}
	return true;
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr class="td_join"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td height="25" valign="middle"><img src="../image/join/icon_join_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_join"> 우편번호 찾기</span></td>
  </tr>
  <tr height="14"> 
    <td height="14"></td>
    <td height="14"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td height="2"><table width="97%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
        <tr> 
          <td height="45" align="center" bgcolor="#F3F3F3"><table width="79%" border="0" cellspacing="3" cellpadding="0">
		  <form name="frm1" action="<%=request.getRequestURI()%>" method="post" onSubmit="return isSearch()">
		  	  <input type="hidden" name="strCurrentPage" value="">
              <tr> 
                <td width="28%" align="left"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                  <strong>읍/면/동 이름</strong></td>
                <td width="55%" align="left"><strong> 
				  <input name="strDong" type="text" class="textfield" style="WIDTH: 200px" value="<%=strDong%>" >
                  </strong></td>
                <td width="17%" align="left"><strong><a href="javascript:goSearch();"><img src="../image/button/bt_inquiry.gif" width="43" height="20" align="absmiddle" border=0></a></strong></td>
              </tr>
		   </form>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>

<%
	if (intTotalCount > 0) {
%>
  <tr> 
	  <td width="14" height="20">&nbsp;</td>
	  <td width="386" height="25">&nbsp;&nbsp;아래 목록에서 원하는 주소를 Click하세요.</td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="97%" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="2" class="td_join"></td>
              </tr>
			<%
				Hashtable objRowInfos = new Hashtable(0);
				String strAddr1 = "";
				String strAddr2 = "";
				for (int i = 1; i < objZipInfoLists.size(); i++) {
					objRowInfos = (Hashtable)objZipInfoLists.get(i);
					strAddr1 = (String)objRowInfos.get("SIDO") + (String)objRowInfos.get("GUGUN") + (String)objRowInfos.get("DONG")
								  + (String)objRowInfos.get("RI") + (String)objRowInfos.get("BUNJI");
								 
					strAddr2 = (String)objRowInfos.get("SIDO") + (String)objRowInfos.get("GUGUN") + (String)objRowInfos.get("DONG")
								  + (String)objRowInfos.get("RI");					
			%>
              <tr align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" OnMouseOut="this.style.backgroundColor=''"> 
                <td width="19%" height="21"><%=objRowInfos.get("ZIPCODE1")%>-<%=objRowInfos.get("ZIPCODE2")%></td>
                <td width="81%" height="21" align="left">
					<a href="javascript:selectZipCd('<%=objRowInfos.get("ZIPCODE1")%>', '<%=objRowInfos.get("ZIPCODE2")%>', '<%=strAddr2%>');Close();">
					<%=strAddr1%>
					</a>
				  </td>
              </tr>
              <tr> 
                <td height="1" colspan="2" class="tbl-line"></td>
              </tr>
			<%
				}
			%>
            </table></td>
        </tr>
        <tr> 
          <td height="40" align="center" valign="middle"><table>
              <tr> 
                <td><%=PageCount.getLinkedString( String.valueOf(intTotalCount), strCurrentPage)%></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>

<%
	}else {
		out.println("<tr>");
		out.println("<td height='22' colspan='2' align='center'>해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr class='tbl-line'>");
		out.println("<td height='1'></td>");
		out.println("<td height='1'></td>");
		out.println("</tr>");
	}
%>

  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>