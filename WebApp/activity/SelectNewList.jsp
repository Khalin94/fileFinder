<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>최근기사조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%
    String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));
	String strCountPerPage;

	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCountPerPage"), "10"));
	}

	String strMessage = "";
	String strError = "";
	String strTotal = "0";
	String strSelected1 = "";
	String strSelected2 = "";
	String strGubn = "";
	String strSearch = "";

	ArrayList objNewArry = new ArrayList();
	try{
		strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("gubun"), "0"));
		strSearch = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("search"), ""));
		nads.dsdm.app.activity.useritet.UserItetDelegate  objUserItetDelegate = new nads.dsdm.app.activity.useritet.UserItetDelegate();

		Hashtable objParamHt = new Hashtable();
		objParamHt.put("GUBUN", strGubn);
		objParamHt.put("CONTENT", strSearch);
		objParamHt.put("CURRENTPAGE", strCurrentPage);
		objParamHt.put("COUNTPERPAGE", strCountPerPage);

		Hashtable objNewHt = objUserItetDelegate.selectNewinfo(objParamHt);

		strTotal = (String)objNewHt.get("TOTAL_COUNT");
		objNewArry = (ArrayList)objNewHt.get("NEW");

		if(strGubn.equals("2")){
			strSelected2 = "selected";
		}else{
			strSelected1 = "selected";
		}
	}
	catch(AppException objAppEx)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<script language="javascript">
	function fun_search(){
		document.form_main.strCurrentPage.value = '1';
		document.form_main.submit();
	}

	function goPage(varPageNo) {
		document.form_main.strCurrentPage.value = varPageNo;
		document.form_main.action = "SelectNewList.jsp";
		document.form_main.submit();
	}

	function fun_winopen(strUrl, strTitle){
		window.open(strUrl, strTitle, "status=yes, resizable=yes, menubar=yes,scrollbars=yes");
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="470" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
  <tr class="td_mypage">
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr>
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr>
    <td colspan="2" align="left" valign="top">
      <table width="759" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="2" colspan="5" class="td_forum"></td>
        </tr>
        <tr class="td_top">
          <td width="48" height="22" align="center">NO</td>
          <td width="179" height="22" align="center">출처</td>
          <td width="440" height="22" align="center">제목</td>
          <td width="92" height="22" align="center">등록일자</td>
        </tr>
        <tr>
          <td height="1" colspan="5" class="td_forum"></td>
        </tr>
<%
	if(objNewArry.size() != 0){
		for (int i = 0; i < objNewArry.size(); i++) {
			Hashtable objNewHt = (Hashtable)objNewArry.get(i);

			String strNewNum = (String)objNewHt.get("RN");
			String strNewTitle = (String)objNewHt.get("TITLE");
			String strNewUrl = (String)objNewHt.get("URL");
			String strNewGroupNm = (String)objNewHt.get("GROUPNAME");
			String strNewRegdate = nads.lib.util.ActComm.makeDate((String)objNewHt.get("GETDATE"));
%>
        <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
          <td height="22" align="center"><%=strNewNum%></td>
          <td height="22" align="center"><%=strNewGroupNm%></td>
          <td height="22" class="td_lmagin"><a href="javascript:fun_winopen('<%=strNewUrl%>', '뉴스검색')"><%=strNewTitle%></a></td>
          <td height="22" align="center"><%=strNewRegdate%></td>
        </tr>
        <tr class="tbl-line">
          <td height="1"></td>
          <td height="1"></td>
          <td height="1" align="left" class="td_lmagin"></td>
          <td height="1"></td>
        </tr>
<%
		}
	} else {
		out.println("<tr>");
		out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr class='tbl-line'>");
		out.println("<td height='1'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("<td height='1' align='left' class='td_lmagin'></td>");
		out.println("</tr>");
	}
%>
        <tr class="tbl-line">
          <td height="1"></td>
          <td height="1"></td>
          <td height="1" align="left" class="td_lmagin"></td>
          <td height="1"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="35" align="center" valign="middle"><div align="center">
    <%= PageCount.getLinkedString(strTotal , strCurrentPage, strCountPerPage) %>
    </div></td>
  </tr>
  <tr>
    <td height="40" align="left" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="314" align="right" valign="middle"><div align="right">
            <select name="gubun" class="select">
              <option value="1" <%=strSelected1%> >출처</option>
              <option value="2" <%=strSelected2%> >제목</option>
            </select>
            <input name="search" type="text" class="textfield" style="WIDTH: 180px"  value="<%=strSearch%>" onKeyDown="if (event.keyCode == 13) fun_search();">
            <a href="javascript:fun_search()"><img src="../image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" border="0"></a></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr align="right">
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
</html>
