<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit.js"></script>
<script src="/js/common.js"></script>
</head>

<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	Hashtable objHshSearchOrganList = new Hashtable();
	Hashtable objHshParam = new Hashtable();
	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();
	ArrayList objArySearchOrgan = new ArrayList();

	String srchWord = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchWord")); 
	String srchMode = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchMode")); 
	String InOutMode = "X";
	
	String strRelCd = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("RelCd"));

	String strRootOrganId = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("organId"));


 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="819" border="0" cellpadding="0" cellspacing="0">
  <tr height="54">
    <td height="54" align="left" valign="top" background="/image/reqsubmit/bg_bottomsearch.gif"><img src="/image/reqsubmit/logo_bottomsearch.gif" width="270" height="54"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><table width="759" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="23" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="18%" background="/image/join/bg_join_tit.gif"><span class="title">기관 
                  담당자 조회</span></td>
                <td width="22%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="60%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s">위원회 관련 기관의 담당자를 조회하실 수 있습니다.</td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="45" align="center" bgcolor="#F3F3F3">


					   <!--검색-->
			<%
				String strTitle1 = "";
				String strTitle2 = "";
				if(InOutMode == null || InOutMode.equals("I") )
				{
					
					strTitle1 = "국회의원 및 직원 조회";
					strTitle2 = "국회 직원";
				}
				else
				{
					strTitle1 = "기관 담당자 조회";
					strTitle2 = "기관 담당자";


				}
			%>
						<%@ include file="/reqsubmit/70_organchargesh/SearchRelOrganForm.jsp" %>
					</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="22" align="left" valign="middle" class="soti_reqsubmit"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="46%" height="30"><img src="/image/join/icon_join_soti.gif" width="9" height="9" align="absmiddle"> 
                  <span class="soti_join">위원회별 관련기관</span></td>
                <td width="54%" height="30" align="right" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="2" align="left" valign="top" class="td_join"></td>
        </tr>
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
						


				 <!---중간---->
				<%

					if(strRootOrganId != null && strRootOrganId.equals("") != true){

				%>
					<%@ include file="/reqsubmit/70_organchargesh/SearchOutRelOrganByOrganCenter.jsp" %>
				<% 
					}else{
				%>
					<%@ include file="/reqsubmit/70_organchargesh/SearchOutRelOrganCenter.jsp" %>
				<% 
					}
				%>
				<!---중간 끝--->
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="1" align="left" valign="top" class="tbl-line"></td>
        </tr>
        <tr> 
          <td height="45" align="left" valign="top" class="soti_reqsubmit">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr height="38">
    <td height="38" align="left" valign="top" background="/image/reqsubmit/bbg_bottomsearch.gif"><img src="/image/reqsubmit/copyright_bottomsearch.gif" width="270" height="38"></td>
  </tr>
</table>

</body>
</html>