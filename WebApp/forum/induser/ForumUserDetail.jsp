<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������

	String strUserID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uid"))); //ȸ��ID
	String strGbn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("gbn")));
					//ȸ�����:���� ����ȸ�����:O ���Խ�û���:jReq Ż���û���:lReq
	String strTitle = "���� ȸ��";
	String strTitleWidth = "12";
	if(strGbn.equals("jReq")) {
		strTitle = "���Խ�û ȸ��";
		strTitleWidth = "20";
	} else if (strGbn.equals("lReq")) {
		strTitle = "Ż���û ȸ��";
		strTitleWidth = "20";
	}

	Hashtable objHashData;
	SLForumUserDelegate objForumUser = new SLForumUserDelegate();

	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();	
	UserInfoDelegate objUserInfoDelegate = new UserInfoDelegate();

	try {

		objHashData = objForumUser.selectForumUserInfo(strForumID, strUserID);

		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserID);

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
<script src='/js/forum.js'></script>
<script language="JavaScript">
<!--
function fnChk(cmd) {
	if(cmd=="forceLeave") { //����Ż��
		openWinB('ForumLeavereq.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd='+cmd+'&uids=<%=strUserID%>','winJoin','380','280');
		return;
	} else if(cmd=="entrust") { //�������

		if(confirm("�����Ͻ� ȸ������ \n����� ������ �����Ͻðڽ��ϱ�?")) {
		} else {
			return;
		}

	} else if(cmd=="joinRjt" || cmd=="leaveRjt") { //���Խ��ΰź�,Ż����ΰź�
		openWinB('ForumUserrjt.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&cmd='+cmd+'&uids=<%=strUserID%>','winJoin','380','280');
		return;

	} //end if(gbn)
	document.form.action="ForumUserProc.jsp"
	document.form.cmd.value = cmd;
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
          <td height="30" align="left" class="text_s">ȸ���� ������ �Դϴ�.</td>
        </tr>
        <tr> 
          <td height="30" align="left"><img src="/image/forum/icon_forumpop_soti.gif" width="9" height="9">&nbsp;<span class="soti_forumpop">�⺻ ���� </span></td>
        </tr>
<%
	if(objHashData!=null) {

		String strUserNM = StringUtil.getNVLNULL((String)objHashData.get("USER_NM")); //�̸�
		String strJuminNo = StringUtil.getNVLNULL((String)objHashData.get("JUMIN_NO"));
		String strSex = ""; //����
		if(strJuminNo.length()==13) {
			if((strJuminNo.substring(6,7)).equals("1") || (strJuminNo.substring(6,7)).equals("3"))
				strSex = "����";
			else
				strSex = "����";
		}

		String strOrganNM = StringUtil.getNVLNULL((String)objHashData.get("ORGAN_NM")); //�Ҽӱ��
		String strDeptNM = StringUtil.getNVLNULL((String)objHashData.get("DEPT_NM")); //�μ���


//		String strCGDuty = StringUtil.getNVLNULL((String)objHashData.get("CG_DUTY")); //������



		String strEmail = StringUtil.getNVLNULL((String)objHashData.get("EMAIL")); //e-mail
		String strOfficeTel = StringUtil.getNVLNULL((String)objHashData.get("OFFICE_TEL")); //�繫����ȭ
		String strCphone = StringUtil.getNVLNULL((String)objHashData.get("CPHONE")); //�̵���Ź�ȣ
		String strOprtrGbn = StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //ȸ������
		strOprtrGbn = (strOprtrGbn.equals("Y"))?"���":"ȸ��";
		
		String strJoinTS = (String)objHashData.get("JOIN_TS"); //������
		if(strJoinTS.length() > 8) {
			strJoinTS = strJoinTS.substring(0, 4) + "-" + strJoinTS.substring(4, 6) + "-" + strJoinTS.substring(6, 8);
		}

		String strRcntConnTS = (String)objHashData.get("RCNT_CONN_TS"); //����������
		if(strRcntConnTS.length() > 14) {
			strRcntConnTS = strRcntConnTS.substring(0,4) + "-" + strRcntConnTS.substring(4,6) + "-" + strRcntConnTS.substring(6,8) + " "+strRcntConnTS.substring(8,10) + ":"+strRcntConnTS.substring(10,12) + ":"+strRcntConnTS.substring(12,14);
		}

		String strVisitCnt = StringUtil.getNVLNULL((String)objHashData.get("VISIT_CNT")); //����ȸ��

		String strRsnTitle = "���� �λ縻";
		String strRsn = StringUtil.getNVLNULL((String)objHashData.get("JOIN_RSN")); //�����λ縻 �� ���Ի���
		if(strGbn.equals("jReq")) {
			strRsnTitle = "���� ����";
		} else if(strGbn.equals("lReq")) {
			strRsnTitle = "Ż�� ����";
			strRsn = StringUtil.getNVLNULL((String)objHashData.get("LEAVE_RSN")); //Ż�����
		}
%>
		<!-- form -->
		<form name="form" method="post">

		<input type="hidden" name="fid" value="<%=strForumID%>">
		<input type="hidden" name="uStt" value="<%=strUserStt%>">
		<input type="hidden" name="uids" value="<%=strUserID%>">
		<input type="hidden" name="cmd">

		<!-- ������� -->
		<input type="hidden" name="uid1" value="<%=(String)session.getAttribute("USER_ID")%>"><!--���ǿ��� �޾ƿ�-->
		<input type="hidden" name="uid2" value="<%=strUserID%>">
        <tr> 
          <td align="left" valign="top"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" class="td_forumpop"></td>
                <td class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �̸�</td>
                <td class="td_lmagin"><%=strUserNM%></td>
              </tr>
              <tr> 
                <td width="22%" height="1" class="tbl-line"></td>
                <td width="78%" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                <td class="td_lmagin"><%=strSex%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �Ҽӱ��</td>
                <td class="td_lmagin"><%=strOrganNM%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �μ���</td>
                <td class="td_lmagin"><%=strDeptNM%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������</td>
                <td class="td_lmagin"> <b>�־��� : </b>
				<%
					String strMsortCd = "";
					String strCdNm = "";
					
					String strType = "";
					String strCharge = "";
					
					String strChecked = "";
					String strDisabled = "";
					String strFunction = "";
					String strChkName = "";
					String strSpace = "";
					String strMRemark = "";
					String strTextType="hidden";
					
					Hashtable objChargeInfoHt = new Hashtable();
					Hashtable objUserChargeHt = new Hashtable();
					for(int i=0; i < objChargeInfoArry.size(); i++){
						objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
						strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
						strCdNm = (String)objChargeInfoHt.get("CD_NM");			
						
						strChecked = "";
						strDisabled = "";
						for(int k=0; k < objUserChargeArry.size(); k++){
							objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
							strType = (String)objUserChargeHt.get("CHARGE_TYPE");
							strCharge = (String)objUserChargeHt.get("CHARGE_CD");
							if(strType.equals("S") && !strCharge.equals("999")){  ////�������� ��Ÿ�׸��� �ƴ� ��� ����
								if(strCharge.equals(strMsortCd)){
									strDisabled = "disabled";
									break;
								}
								continue;
							}
							if(strType.equals("M") && strCharge.equals(strMsortCd)){
								strChecked = "checked";
								if(strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
									strMRemark = (String)objUserChargeHt.get("REMARK");
								}
								break;
							}
						}
						if(strMsortCd.equals("999")){   //�������� ��Ÿ�׸� ����
							strDisabled = "";
							strChkName = "mchr999";
							strSpace = "";
							strFunction = "fun_make('m', '" + strMRemark + "')";
						}else{
							strChkName = "mchr" + Integer.toString(i);
							strFunction = "fun_check(this)";
							strSpace = "&nbsp;&nbsp;";
						}
				%>
                        <input name="<%=strChkName%>" type="checkbox" value="<%=strMsortCd%>"   <%=strChecked%>  disabled><%=strCdNm%><%=strSpace%>
				<%
					}
					if(!strMRemark.equals("")) {
				%>
						<input type="text" name="MRemark" class="textfield" size="15" maxlength='15' value="<%=strMRemark%>">
				<%
					}
				%>

				<br> <b>�ξ��� : </b>
				<%
					strChecked = "";
					strDisabled = "";
					strFunction = "";
					strTextType="hidden";
					strChkName = "";
					strSpace = "";
					String strSRemark = "";
					
					for(int i=0; i < objChargeInfoArry.size(); i++){
						objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
						strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
						strCdNm = (String)objChargeInfoHt.get("CD_NM");
						
						strChecked = "";
						strDisabled = "";
						for(int k=0; k < objUserChargeArry.size(); k++){
							objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
							strType = (String)objUserChargeHt.get("CHARGE_TYPE");
							strCharge = (String)objUserChargeHt.get("CHARGE_CD");
							if(strType.equals("M")){
								if(strCharge.equals(strMsortCd) && !strCharge.equals("999")){ //�������� ��Ÿ�׸��� �ƴ� ��� ����
									strDisabled = "disabled";
									break;
								}
								continue;
							}
							if(strType.equals("S") && strCharge.equals(strMsortCd)){
								strChecked = "checked";
								if(strCharge.equals("999")){   //�������� ��Ÿ�׸� ����
									strSRemark = (String)objUserChargeHt.get("REMARK");
								}
								break;
							}
						}
						if(strMsortCd.equals("999")){   //�������� ��Ÿ�׸� ����
							strDisabled = "";
							strSpace = "";
							strChkName = "schr999";
							strFunction = "fun_make('s', '" + strSRemark + "')";
						}else{
							strChkName = "schr" + Integer.toString(i);
							strFunction = "fun_checkm(this)";
							strSpace = "&nbsp;&nbsp;";
						}
				%>
						<input name="<%=strChkName%>" type="checkbox" value="<%=strMsortCd%>" <%=strChecked%> disabled><%=strCdNm%><%=strSpace%>
				<%
					}
					if(!strSRemark.equals("")) {
				%>
						<input type="text" name="MRemark" class="textfield" size="15" maxlength='15' value="<%=strSRemark%>">
				<%
					}
				%>
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> e-mail</td>
                <td class="td_lmagin"><%=strEmail%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �繫�� </td>
                <td class="td_lmagin"><%=strOfficeTel%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �̵���Ź�ȣ</td>
                <td class="td_lmagin"><%=strCphone%></td>
              </tr>
              <tr> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="15"></td>
                <td height="15"></td>
              </tr>
              <tr> 
                <td height="2" class="td_forumpop"></td>
                <td class="td_forumpop"></td>
              </tr>
	<%
		if(strGbn.equals("O") || strGbn.equals("")) {
	%>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ȸ������</td>
                <td class="td_lmagin"><%=strOprtrGbn%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������</td>
                <td class="td_lmagin"><%=strJoinTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������������</td>
                <td class="td_lmagin"><%=strRcntConnTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����ȸ��</td>
                <td class="td_lmagin"><%=strVisitCnt%>ȸ</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
	<%
		} //end if(����ȸ������)
	%>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> <%=strRsnTitle%></td>
                <td valign="top" class="td_box"><%=strRsn%></td>
              </tr>
              <tr> 
                <td height="2" class="tbl-line"></td>
                <td class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="35" align="left" valign="middle">
		<%
			//ȸ�����:���� ����ȸ�����:O ���Խ�û���:jReq Ż���û���:lReq
			if(strGbn.equals("O") && strOprtrGbn.equals("ȸ��")) { //����ȸ�����(Ż��,�������)
		%>
				<a href="javascript:fnChk('forceLeave');"><img src="/image/button/bt_break.gif" width="43" height="20" border="0"></a>&nbsp;
				<a href="javascript:fnChk('entrust');"><img src="/image/button/bt_entrustSysop.gif" width="83" height="20" border="0"></a>&nbsp;
		<%
			} else if(strGbn.equals("jReq")) { //���Խ�û���(ȸ������,���ΰź�)
		%>

				  <a href="javascript:fnChk('joinApv');"><img src="/image/button/bt_agreeMember.gif" width="67" height="20" border="0"></a>&nbsp;
				  <a href="javascript:fnChk('joinRjt');"><img src="/image/button/bt_rejectionAgree.gif" width="67" height="20" border="0"></a>&nbsp;

		<%
			} else if(strGbn.equals("lReq")) { //Ż���û���(ȸ������,���ΰź�)
		%>

				  <a href="javascript:fnChk('leaveApv');"><img src="/image/button/bt_agreeQuit.gif" width="67" height="20" border="0"></a>&nbsp;
				  <a href="javascript:fnChk('leaveRjt');"><img src="/image/button/bt_rejectionAgree.gif" width="67" height="20" border="0"></a>&nbsp;

		<%
			}
		%>
			<a href="javascript:history.go(-1);"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>

		  </td>
        </tr>
<%
	} //end if(objHashData)
%>
		</form>
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
