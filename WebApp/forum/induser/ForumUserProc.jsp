<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="nads.dsdm.app.common.code.*" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));
		//join:���� / leaveReq:Ż���û / forceLeave:����Ż�� / leaveApv:Ż����� / entrust:�������
		//joinApv:���Խ�û���� / joinRjt:���Խ�û���ΰź� / leaveRjt:Ż���û ���ΰź�

	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); //ȸ������
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("openYN"))); //��������
	String strUserID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uid"))); //ȸ��ID

	String strUserIDs = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uids"))); //�ش�ȸ��ID��
	String strArrUserIDs[] = new String[10];
	int intArrSize = 0;

	if(strUserIDs.indexOf("||") > 0) {
		StringTokenizer st = new StringTokenizer(strUserIDs, "||");
		while(st.hasMoreTokens()) {
			strArrUserIDs[intArrSize]=st.nextToken();
			intArrSize++;
		}
	} else {
		if(!strUserIDs.equals("")) {
			strArrUserIDs[0]=strUserIDs;
			intArrSize = 1;
		}
	}

	// DB ó�� ����
	SLForumUserDelegate objForumUser = new SLForumUserDelegate();
	CodeInfoDelegate objCodeInfo = new CodeInfoDelegate(); //�ڵ���� Delegate

	if(strCmd.equals("join")) { //���� �� ���Խ�û

		try {
			Hashtable objHashData_ForumUserYN = objForumUser.selectForumUserYN(strForumID, strUserID);
			String strUserStt_DB = StringUtil.getNVLNULL((String)objHashData_ForumUserYN.get("USER_STT"));
			if(!strUserStt_DB.equals("")) { //���� �� ������ ���õ� ���
				String strUserSttWord = objCodeInfo.lookUpCodeName("M04", strUserStt_DB);
%>
				<script language="JavaScript">
				<!--
					alert("�ش������� "+strUserSttWord+" �Ǿ��ֽ��ϴ�.");
				//-->
				</script>
<%
				return;
			} else {


				String strJoinRsn = StringUtil.getNVLNULL(request.getParameter("joinRsn")); //���Ե���
				String strLoc = StringUtil.getNVLNULL(request.getParameter("loc")); //������������ ���Թ�ư Ŭ���� ��:Ind

				Vector objForumUserData = new Vector(0);
				objForumUserData.add(strForumID);
				objForumUserData.add(strUserID);
				objForumUserData.add(strJoinRsn);

				int intCnt = objForumUser.insertForumJoinreq(strOpenFlag, objForumUserData);

				if (intCnt < 1) {
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
					return;

				} else {

					//���Ը��� ������
					if (strOpenFlag.equals("Y")) {
%>
						<jsp:include page="/common/MailSend.jsp" flush="true">
							<jsp:param name="gbn" value="joinFUser" />
							<jsp:param name="fid" value="<%=strForumID%>" />
							<jsp:param name="Ruid" value="<%=strUserID%>" />
						</jsp:include>
<%
					}
					out.print("<script language='JavaScript'>\n");
					out.print("<!--\n");
					out.print("	alert('ó���Ǿ����ϴ�.');\n");

					if(strLoc.equals("Ind")) {
						out.print("	opener.location.href='/forum/indmain/ForumVisitProc.jsp?fid="+strForumID+"&openYN="+strOpenFlag+"'\n");
					}

					out.print("	self.close();\n");
					out.print("//-->\n");
					out.print("</script>");
					return;
				} //end if(intCnt < 1)
			} //end if(strUserStt_DB)

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

	} else if(strCmd.equals("leaveReq")) { //Ż���û
/*
			"UPDATE TBDM_FORUM_USER " +
			"SET LEAVE_REQ_TS = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'), USER_STT='004', LEAVE_RSN= ? " +
			"WHERE FORUM_ID = ? AND USER_ID =? ";
*/
		try {
			String strLeaveRsn = StringUtil.getNVLNULL(request.getParameter("leaveRsn")); //Ż�����

			Vector objForumUserData = new Vector(0);
			objForumUserData.add(strLeaveRsn);
			objForumUserData.add(strForumID);
			objForumUserData.add(strUserID);

			int intCnt = objForumUser.updateForumUser(strCmd,objForumUserData);

			if (intCnt < 1) {
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;

			} else {
%>
				<script language="JavaScript">
				<!--
					alert("ó���Ǿ����ϴ�.");
					opener.location.href="/forum/indmain/ForumVisitProc.jsp?fid=<%=strForumID%>&openYN=<%=strOpenFlag%>";
					self.close();
				//-->
				</script>
<%
				return;
			} //end if(intCnt < 1)

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

	} else if(strCmd.equals("forceLeave") || strCmd.equals("leaveApv")) { //����Ż�� �� Ż�����
/*
			"DELETE TBDM_FORUM_USER " +
			"WHERE FORUM_ID = ? AND USER_ID IN (?,?,?,?,?,?,?,?,?,?) ";
*/

		try {
			String strLeaveRsn = StringUtil.getNVLNULL(request.getParameter("leaveRsn")); //����Ż�����(��ڰ� �Է�)

			//Ż����� ������ (���� ���� �� ��񿡼� ������ ����)
			for(int i=0; i<intArrSize; i++) {
%>
				<jsp:include page="/common/MailSend.jsp" flush="true">
					<jsp:param name="gbn" value="leaveFUser" />
					<jsp:param name="fid" value="<%=strForumID%>" />
					<jsp:param name="Ruid" value="<%=strArrUserIDs[i]%>" />
					<jsp:param name="fRsn" value="<%=strLeaveRsn%>" />
				</jsp:include>
<%
			}

			Vector objForumUserData = new Vector(0);
			objForumUserData.add(strForumID);

			for(int i=0; i<10; i++) {
				if(i < intArrSize) {
					objForumUserData.add(strArrUserIDs[i]);
				} else {
					objForumUserData.add("");
				}
			}

			int intCnt = objForumUser.updateForumUser(strCmd,objForumUserData);

			if (intCnt < 1) {
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;

			} else {
				out.print("<script language='JavaScript'>\n");
				out.print("<!--\n");
				out.print("	alert('ó���Ǿ����ϴ�.');\n");

				if(strCmd.equals("forceLeave")) { //����Ż���
					out.print("	opener.location.href='/forum/induser/ForumUserList.jsp?fid="+strForumID+"&uStt="+strUserStt+"&gbn=O';\n");
					out.print("	self.close();\n");
				} else { //Ż����ν�
					out.print("location.href='/forum/induser/ForumReqUserList.jsp?fid="+strForumID+"&uStt="+strUserStt+"&gbn=lReq';\n");
				}

				out.print("//-->\n");
				out.print("</script>");
				return;
			}

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
	} else if(strCmd.equals("entrust")) { //�������
		try {

			String strUserID1 = StringUtil.getNVLNULL(request.getParameter("uid1")); //������ID
			String strUserID2 = StringUtil.getNVLNULL(request.getParameter("uid2")); //������ID

			int intCnt[] = objForumUser.updateForumOprtr(strForumID,strUserID1,strUserID2);

			if (intCnt[0] < 1 || intCnt[1] < 1 || intCnt[2] < 1 ) {
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;

			} else {
%>
				<script language="JavaScript">
				<!--
					alert("ó���Ǿ����ϴ�.");
					location.href='/forum/induser/ForumUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&gbn=O';
				//-->
				</script>
<%
				return;
			} //end if(intCnt < 1)

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

	} else if(strCmd.equals("joinApv")) { //���Խ�û����
/*
			"UPDATE TBDM_FORUM_USER " +
			"SET USER_STT = '003' " +
			"WHERE FORUM_ID = ? AND USER_ID IN (?,?,?,?,?,?,?,?,?,?) ";
*/
		try {
			Vector objForumUserData = new Vector(0);
			objForumUserData.add(strForumID);

			for(int i=0; i<10; i++) {
				if(i < intArrSize) {
					objForumUserData.add(strArrUserIDs[i]);
				} else {
					objForumUserData.add("");
				}
			}

			int intCnt = objForumUser.updateForumUser(strCmd,objForumUserData);

			if (intCnt < 1) {
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;

			} else {

				//���Ը��� ������
				for(int i=0; i<intArrSize; i++) {
%>
					<jsp:include page="/common/MailSend.jsp" flush="true">
						<jsp:param name="gbn" value="joinFUser" />
						<jsp:param name="fid" value="<%=strForumID%>" />
						<jsp:param name="Ruid" value="<%=strArrUserIDs[i]%>" />
					</jsp:include>
<%
				}
%>
				<script language="JavaScript">
				<!--
					alert("ó���Ǿ����ϴ�.");
					location.href='/forum/induser/ForumReqUserList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&gbn=jReq';
				//-->
				</script>
<%
				return;
			} //end if(intCnt < 1)
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

	} else if(strCmd.equals("joinRjt") || strCmd.equals("leaveRjt")) { //���ΰź�(���Խ�û,Ż���û)
/*
			"UPDATE TBDM_FORUM_USER " +
			"SET USER_STT = ?, USER_NOT_RSN = ? " +
			"WHERE FORUM_ID = ? AND USER_ID IN (?,?,?,?,?,?,?,?,?,?) ";
*/
		try {
			String dbUserStt = (strCmd.equals("joinRjt"))?"002":"005";
			String dbUserNotRsn = StringUtil.getNVLNULL(request.getParameter("rjtRsn"));

			Vector objForumUserData = new Vector(0);
			objForumUserData.add(dbUserStt);
			objForumUserData.add(dbUserNotRsn);
			objForumUserData.add(strForumID);

			for(int i=0; i<10; i++) {
				if(i < intArrSize) {
					objForumUserData.add(strArrUserIDs[i]);
				} else {
					objForumUserData.add("");
				}
			}

			int intCnt = objForumUser.updateForumUser(strCmd,objForumUserData);

			if (intCnt < 1) {
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;

			} else {
				String urlGbn=(strCmd.equals("joinRjt")) ? "jReq":"lReq";
				String openerURL = "/forum/induser/ForumReqUserList.jsp?fid="+strForumID+"&uStt="+strUserStt+"&gbn="+urlGbn;
%>
				<script language="JavaScript">
				<!--
					alert("ó���Ǿ����ϴ�.");
					opener.location.href="<%=openerURL%>";
					self.close();
				//-->
				</script>
<%
				return;

			} //end if(intCnt < 1)
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
	} //end if(strCmd)
%>