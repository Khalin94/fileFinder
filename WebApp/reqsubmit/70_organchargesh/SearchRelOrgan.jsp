<html>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<head>
<title>�����ڷ� �������� �ý���</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit.js"></script>
</head>
<%@ page import = "java.util.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%

	String srchWord = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchWord")); 
	String srchMode = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("srchMode")); 
	String InOutMode = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("InOutMode")); 
	String strRelCd = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("RelCd"));


	String strRootOrganId = request.getParameter("organId");


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
			<%
				String strTitle1 = "";
				String strTitle2 = "";
				String strTitle3 = "";
				if(InOutMode == null || InOutMode.equals("I") )
				{
					strTitle1 = "��ȸ�ǿ� �� ������ȸ";
					strTitle2 = "��ȸ ����";
					strTitle3 = "��ȸ�ǿ� �� �ǿ�������, ��ȸ�繫ó, ��ȸ������, ��ȸ������åó, ����ȸ ���� ��ȸ�� �Ͻ� �� �ֽ��ϴ�.";
				}
				else
				{
					strTitle1 = "��� ����� ��ȸ";
					strTitle2 = "��� �����";
					strTitle3 = "��� ����� ��ȸ�� �Ͻ� �� �ֽ��ϴ�.";
				}
			%>

              <tr> 
                <td width="20%" background="/image/join/bg_join_tit.gif"><span class="title"><%=strTitle1%></span></td>
                <td width="20%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=strTitle3%></td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="45" align="center" bgcolor="#F3F3F3">
					   <!--�˻�-->
						<%@ include file="/reqsubmit/70_organchargesh/SearchRelOrganForm.jsp" %>
				  </td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top" class="soti_join">
			<table width="100%" height="319" border="0" cellpadding="0" cellspacing="0">
              <tr align="left" valign="top"> 
                <td width="27%" height="30" valign="middle"><img src="/image/join/icon_join_soti.gif" width="9" height="9" align="absmiddle"> 
					<span class="soti_join">������</span></td>
				  <td width="2%" height="30">&nbsp;</td>
				  <td width="23%" height="30">&nbsp;</td>
				  <td width="2%" height="30">&nbsp;</td>
				  <td width="46%" height="30" valign="middle"><img src="/image/join/icon_join_soti.gif" width="9" height="9" align="absmiddle"> 
					<span class="soti_join">������</span></td>
				</tr>

					<!-- 2 tr ���� -->
                    <tr align="left" valign="top"> 
					<!-- ������ -->
                      <td height="289">
					  
				<!-- 	 <iframe src="/reqsubmit/70_organchargesh/SearchRelOrganCenter.jsp" name="dept" scrolling="yes" frameborder="no" width="260" height="370" align="left" marginwidth="0" marginheight="0"></iframe>  -->

					<iframe src="/reqsubmit/70_organchargesh/DeptTree.jsp#link_here" name="dept" scrolling="yes" frameborder="no" width="220" height="370" align="left" marginwidth="0" marginheight="0"></iframe>
					</td>
                      <td>&nbsp;</td>

					<!-- �μ������ -->
                      <td>
					  
						<iframe src="/reqsubmit/70_organchargesh/UserList.jsp" name="userlist" scrolling="yes" frameborder="no" width="180" height="370" align="left" marginwidth="0" marginheight="0"></iframe>

						</td>
                      <td>&nbsp;</td>

					  <!-- ���������� �Ǵ� �μ� ���� -->
                      <td>

						<iframe src="/reqsubmit/70_organchargesh/OrganInfo.jsp?OrganId=<%=(String)session.getAttribute("ORGAN_ID")%>" name="userinfo" scrolling="no" frameborder="no" width="345" height="370" align="left" marginwidth="0" marginheight="0" ID="userinfo"></iframe>

						</td>
					<!-- 2 tr �� -->
                    </tr>

                  </table>			  
			  
			  
</td>
        </tr>
        <tr> 
          <td height="30" align="left" valign="top" class="soti_reqsubmit">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr height="38">
    <td height="38" align="left" valign="top" background="/image/reqsubmit/bbg_bottomsearch.gif"><img src="/image/reqsubmit/copyright_bottomsearch.gif" width="270" height="38"></td>
  </tr>
</table>

</body>
</html>
