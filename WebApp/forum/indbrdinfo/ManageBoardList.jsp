<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%	
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");							//�α��� ID
	
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 	//ȸ������
	String strOpenFlag = ""; 																									//��������
	String strForumNM = ""; 																									//������
	
	if(strForumID == null || strForumID.equals("") || strForumID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("���� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*�ʱⰪ ���� */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	ArrayList objAryBbrdList = null;
	
	try{

		//1. �Խ��� ����Ʈ ������ �����´�.
		objAryBbrdList = objMngBoard.selectBbrdInfoList(strForumID);	
		
	} catch (AppException objAppEx) {
	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
		
	}
%>
<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">	
	function goToMngWrite(cnt){

		if(cnt >= "<%=boardMaxCnt%>"){
			var msg = "�������� �Խ��� �ִ� ���� ������ " + "<%=boardMaxCnt%>" + "�� �̹Ƿ� ���̻� �Խ��� �����Ͻ� �� �����ϴ�."
							+ " \n �Խ����� �߰� �Ͻ÷��� �����Խ����� �����Ͻ� �� �߰� �Ͻ� �� �ֽ��ϴ�.";
			alert(msg);
			return false;
		}
	
	}
</script>	
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
<%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
</td>
    <td align="center"><table width="589" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="15%" background="/image/forum/bg_forumpop_tit.gif"><span class="title">�Խ��� ����</span></td>
                <td width="85%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <!--<td height="30" align="left" class="text_s">-->
          <td height="50" align="left" class="text_s">
          	�������� �����Ǵ� �Խ��� ������ �޴��� �����Ͻ� �� �ֽ��ϴ�. <br>
          	�������� �����Ǵ� �⺻ �Խ��� 3���� ����, ���� �Ͻ� �� �����ϴ�.  <br>      	
          	���� ���� �Խ��� �ִ� ���� ������ <%=boardMaxCnt%>�� �Դϴ�.
          </td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
            <!-- �Խ��� ����Ʈ ���̺� ���� ---------------------------->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="5" class="td_forumpop"></td>
              </tr>
              <tr class="td_top"> 
                <td width="46" height="22" align="center">NO</td>
                <td width="370" height="22" align="center">�Խ��� �̸�</td>
                <td width="100" height="22" align="center">�������</td>
                <td width="55" height="22" align="center">�Խù�</td>
              </tr>
              <tr> 
                <td height="1" colspan="5" class="td_forumpop"></td>
              </tr>
              <%
              int intBbrdCnt  = 0;						//���� OPERATOR �Խ��� �� 
              
              if (objAryBbrdList != null) {
	              if (objAryBbrdList.size() != 0) {
	              	for (int i = 0; i < objAryBbrdList.size(); i++) {
	              		Hashtable objHshBbrdList = (Hashtable)objAryBbrdList.get(i);
	              		
	              		String strBbrdID = (String)objHshBbrdList.get("BBRD_ID");
	              		String strRegTs = (String)objHshBbrdList.get("REG_TS");
	              		String strUpdTs = (String)objHshBbrdList.get("UPD_TS");
	              		if(!strUpdTs.equals("")){
								strRegTs = strUpdTs;
						}
	              		strRegTs = strRegTs.substring(0, 4) + "-" + strRegTs.substring(4, 6) + "-"  + strRegTs.substring(6, 8);
	              		String strRemark = (String)objHshBbrdList.get("REMARK");
	              		if(strRemark.equals("OPERATOR")){
	              			intBbrdCnt = intBbrdCnt + 1;
	              		}
              %>
              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22" align="center" width="46"><%=i+1%></td>
                <td height="22" class="td_lmagin" width="355">
                	<% if (strRemark.equals("ADMIN")) { %>
                	<b><%=objHshBbrdList.get("BBRD_NM")%></b>
                	<% } else if (strRemark.equals("OPERATOR")) { %>
                	<a href="ManageBoardContent.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&bbrdid=<%=strBbrdID%>"><%=objHshBbrdList.get("BBRD_NM")%></a>
                	<% } %>
                </td>
                <td height="22" align="center" width="100"><%=strRegTs%></td>
                <td height="22" align="center" width="70"><%=objHshBbrdList.get("CNT")%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1" width="46"></td>
                <td height="1" width="355"></td>
                <td height="1" align="left" class="td_lmagin" width="100"></td>
                <td height="1" align="left" class="td_lmagin" width="70"></td>
              </tr>
              <%
	              	}
	              } else {
	              		out.println("<tr>");
						out.println("<td height='22' colspan='4' align='center'>�ش� ����Ÿ�� �����ϴ�.");
						out.println("</td>");
						out.println("</tr>");
						out.println("<tr class='tbl-line'> ");
						out.println("<td height='1' width='46'></td>");
						out.println("<td height='1' width='355'></td>");
						out.println("<td height='1' align='left' class='td_lmagin' width='100'></td>");
						out.println("<td height='1' align='left' class='td_lmagin' width='70'></td>");
						out.println("</tr>");
	              }
              }
              %>
              <tr class="tbl-line"> 
                <td height="1" width="46"></td>
                <td height="1" width="355"></td>
                <td height="1" align="left" class="td_lmagin" width="100"></td>
                <td height="1" align="left" class="td_lmagin" width="70"></td>
              </tr>
            </table>
          	<!-- �Խ��� ����Ʈ ���̺� �� ---------------------------->
          </td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="40"><a href="WriteManageBoard.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>"><img src="/image/button/bt_add.gif" width="45" height="20" border="0" onClick="return goToMngWrite('<%=intBbrdCnt%>');"></a>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
