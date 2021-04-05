<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������

	String strGbn = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("gbn"))); //�������������(O:����� ���ε�ȸ�����)
	String strTitle = "���� ȸ��";
	String strTitleWidth="12";
	String strUsersStt = "M"; //ȸ�����(����,Ż���û, Ż��ź�)
	String strColSpan = "6";
	String strNoWidth = "60";
	String strNameWidth = "107";
	String strRoleWidth = "117";
	if(strGbn.equals("O")) {
		strTitle = "���ε� ȸ��";
		strTitleWidth="15";
		strUsersStt = "O"; //���ε� ȸ�����(����, Ż��ź�)
		strColSpan = "7";
		strNoWidth = "50";
		strNameWidth = "97";
		strRoleWidth = "97";
	}
		
	String strSrchText =  this.replaceXss(StringUtil.getNVLNULL(request.getParameter("strSrchText")));
		
	//out.print("<br>strGbn="+strGbn+":::strSrchText="+strSrchText);

	String strCurrentPage = this.replaceXss(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//���� ������
	String strCountPerPage;

	try {
		//CountPerPage�� �����´�.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		//strCountPerPage = "2";
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}

	ArrayList objForumUserData;
	SLForumUserDelegate objForumUser = new SLForumUserDelegate();
	
	try {

		objForumUserData = objForumUser.selectForumUser(strForumID, strUsersStt, strSrchText, strCurrentPage, strCountPerPage);

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

	String strTotalCount = (String)((Hashtable)objForumUserData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
%>

<html>
<head>
<title>�����ڷ� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk(actionURL) {
	if(document.form.strSrchText.value=="") {
		alert("�˻�� �Է����ּ���");
		document.form.strSrchText.focus();
		return false;
	}
	document.form.strCurrentPage.value = "1";
	document.form.action = actionURL;
	document.form.submit();
}

function fnChkOprtr(cmd) {
	var check_num = 0;
	var uids = "";
	for(i= 0; i < document.form.elements.length ;i++){ 
		 if(document.form.elements[i].name=='choice' && document.form.elements[i].checked==true){
			check_num ++;
			uids = uids + document.form.elements[i].value + "||"
		 }
	}

	if(check_num==0) {
		alert("�׸��� ������ �ּ���");
		return;
	} else {
		uids = uids.substring(0, uids.length-2);
		//alert(uids);
		if(cmd=="entrust") {
			if(check_num > 1) {
				alert("�׸��� �ϳ��� ������ �ּ���");
				return;
			} else {
				if(confirm("�����Ͻ� ȸ������ \n����� ������ �����Ͻðڽ��ϱ�?")) {
				} else {
					return;
				}
			}
		} else {
			openWinB('ForumLeavereq.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd=forceLeave&uids='+uids,'winJoin','380','280');
			return;
		} //end if(cmd)
	}

	document.form.cmd.value = cmd;
	document.form.uid2.value=uids;
	document.form.action="ForumUserProc.jsp"
	document.form.submit();
}
//-->
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
                <td width="<%=strTitleWidth%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strTitle%></span></td>
                <td align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="50" align="left" class="text_s">�� ������ ���� Ȱ�� ���� ȸ������ ����Դϴ�.
		  <br> �̸��� Ŭ���Ͻø� ȸ���� �� ������ Ȯ�� �� �� �ֽ��ϴ�.</td>
        </tr>
		<!-- form -->
		<form name="form" method="post" onSubmit="return fnChk('<%=request.getRequestURI()%>');">
		<input type="hidden" name="gbn" value="<%=strGbn%>">
		<input type="hidden" name="fid" value="<%=strForumID%>">
		<input type="hidden" name="uStt" value="<%=strUserStt%>">
		<input type="hidden" name="strCurrentPage">
		<!-- form(�������, Ż��) -->
		<input type="hidden" name="cmd">
		<input type="hidden" name="uid1" value="<%=(String)session.getAttribute("USER_ID")%>"><!--���ǿ��� �޾ƿ�-->
		<input type="hidden" name="uid2">

        <tr>
          <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="45" align="center" bgcolor="#F3F3F3"><table width="58%" border="0" cellspacing="3" cellpadding="0">
                    <tr> 
                      <td width="33%" align="left"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                        <strong>ȸ���̸� �˻�:</strong></td>
                      <td width="49%" align="left"><strong> 
                        <input name="strSrchText" type="text" class="textfield" style="WIDTH: 150px" value="<%=strSrchText%>">
                        </strong></td>
                      <td width="18%" align="left"><input type="image" src="/image/button/bt_gumsack_icon.gif" border=0 width="47" height="19" align="absmiddle"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="15" align="left"></td>
        </tr>
        <tr> 
          <td height="20" align="left" class="text_s">&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">��üȸ�� : <%=strTotalCount%>��</td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="2" colspan="<%=strColSpan%>" class="td_forumpop"></td>
              </tr>
              <tr align="center" class="td_top">
				<%
					if(strGbn.equals("O")) { //���ε�ȸ�� ������
				%>
						<td width="40" height="22"><input type="checkbox" name="allChoice" onClick="javascript:all_choice()"></td>
				<%
					} //end if(strGbn)
				%>
                <td width="<%=strNoWidth%>" height="22">NO</td>
                <td width="<%=strNameWidth%>" height="22">ȸ�� �̸�</td>
                <td width="<%=strRoleWidth%>" height="22">����</td>
                <td width="116" height="22">������</td>
                <td width="113" height="22">����������</td>
                <td width="76" height="22">����ȸ��</td>
              </tr>

              <tr> 
                <td height="1" colspan="<%=strColSpan%>" class="td_forumpop"></td>
              </tr>
				<%
				if(intTotalCount != 0){
					for(int i=1; i<objForumUserData.size(); i++) {
						Hashtable objHashForumUserData = (Hashtable)objForumUserData.get(i);

						String strRNUM = (String)objHashForumUserData.get("RNUM"); //rownum
						String strUserID = (String)objHashForumUserData.get("USER_ID"); //ȸ��ID
						String strUserNM = (String)objHashForumUserData.get("USER_NM"); //ȸ����
						String strOprtrGbn = (String)objHashForumUserData.get("OPRTR_GBN"); //��ڱ���
						String strRole = "ȸ��";
						if(strOprtrGbn.equals("Y")) {
							strRole = "���";
						}

						String strJoinTS = (String)objHashForumUserData.get("JOIN_TS"); //������
						if(strJoinTS.length() > 8) {
							strJoinTS = strJoinTS.substring(0, 4) + "-" + strJoinTS.substring(4, 6) + "-" + strJoinTS.substring(6, 8);
						}

						String strRcntConnTS = (String)objHashForumUserData.get("RCNT_CONN_TS"); //����������
						if(strRcntConnTS.length() > 14) {
							strRcntConnTS = strRcntConnTS.substring(0,4) + "-" + strRcntConnTS.substring(4,6) + "-" + strRcntConnTS.substring(6,8) + " "+strRcntConnTS.substring(8,10) + ":"+strRcntConnTS.substring(10,12) + ":"+strRcntConnTS.substring(12,14);
						}

						String strVisitCnt = (String)objHashForumUserData.get("VISIT_CNT"); //����ȸ��

						String strH = "1";
						if (i==objForumUserData.size()-1) {
							strH = "2";
						}
				%>
					  <tr align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						<%
							if(strGbn.equals("O")) { //���ε�ȸ�� ������
								if(strOprtrGbn.equals("Y")) {
						%>
									<td height="22">&nbsp;</td>
						<%
								} else {
						%>
									<td height="22"><input type="checkbox" name="choice" value="<%=strUserID%>"></td>
						<%
								}
							} //end if(strGbn)
						%>
						<td height="22"><%=strRNUM%></td>
						<td height="22">
						<%
							if(strUserStt.equals("") || strUserStt.equals("N") || strUserStt.equals("NJ")) { //��ȸ������ �����ȵ�
								out.print(strUserNM);
							} else {
						%>
							<a href="/forum/induser/ForumUserDetail.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&uid=<%=strUserID%>&gbn=<%=strGbn%>"><%=strUserNM%></a>
						<%
							}
						%></td>
						<td height="22" align="center"><%=strRole%></td>
						<td height="22" align="center"><%=strJoinTS%></td>
						<td height="22"><%=strRcntConnTS%></td>
						<td height="22"><%=strVisitCnt%></td>
					  </tr>
					  <tr class="tbl-line"> 
						<td height="<%=strH%>"></td>
						<td height="<%=strH%>"></td>
						<td height="<%=strH%>" align="left" class="td_lmagin"></td>
						<td height="<%=strH%>" align="left" class="td_lmagin"></td>
						<td height="<%=strH%>"></td>
						<td height="<%=strH%>"></td>
						<%
							if(strGbn.equals("O")) { //���ε�ȸ�� ������
						%>
							<td height="<%=strH%>"></td>
						<%
							} //end if(strGbn)
						%>
					  </tr>
				<%
					} //end for
				} //end if
				%>
            </table></td>
        </tr>
        <tr> 
          <td height="35" align="center" valign="middle"><%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %></td>
        </tr>
<%
	if(strGbn.equals("O")) { //���ε�ȸ�� ������
%>
        <tr height="3"> 
          <td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
        </tr>
        <tr>
          <td height="40" align="left" valign="middle"><a href="javascript:fnChkOprtr('forceLeave');"><img src="/image/button/bt_break.gif" width="43" height="20" border="0"></a>&nbsp;<a href="javascript:fnChkOprtr('entrust');"><img src="/image/button/bt_entrustSysop.gif" width="83" height="20" border="0"></a></td>
        </tr>
<%
	} //end if(strGbn)
%>
		</form>
        <tr> 
          <td height="10" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>

<%!
	public String replaceXss(String str){
		
		if(str.equals("") || str == null){			
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");
		}		
		
		return str;
	}	
%>