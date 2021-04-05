<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLForumUserDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); //����ID
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("openYN"))); //��������
	String strUserID = (String)session.getAttribute("USER_ID"); //ȸ��ID
	String uStt = "";
	// OO:����������� CO:������������ Y:����������(����) YL:Ż���û/Ż��ź��� N:�̰����� NJ:���Խ�û/���԰ź���
	// ���Խ�û/���԰ź���, Ż���û/Ż��ź��� ���Դ� ����/Ż�� ��ư�� �������� �ʴ´�. (���������ڿ��Դ� Ż���ư��, �̰����ڿ��Դ� ���Թ�ư�� ǥ��)

	String strParam = request.getQueryString(); //�Խ������� �ٷ� �Ѿ�� ��� ���

	String actionURL = "";
	if(strParam.indexOf("actionURL") > 0) {
		actionURL = strParam.substring(strParam.indexOf("actionURL") + "actionURL=".length(), strParam.length()) + "&";
	} else {
		actionURL = "/forum/indmain/ForumIndMain.jsp?";
	}

	actionURL += "fid="+strForumID;

/*
	out.print("strForumID : "+strForumID);
	out.print("<br>strOpenFlag : "+strOpenFlag);
	out.print("<br>strUserID : "+strUserID);
*/

	try {
		SLForumUserDelegate objForumUser = new SLForumUserDelegate();

		Hashtable objHashData = objForumUser.selectForumUserYN(strForumID, strUserID);
		String strUserStt_DB = StringUtil.getNVLNULL((String)objHashData.get("USER_STT")); //ȸ������
		String strOprtrGbn_DB = StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //��ڱ���

		if(strUserStt_DB.equals("") || strUserStt_DB.equals("001") || strUserStt_DB.equals("002")) { //������ �ȵȰ��
			if(strUserStt_DB.equals("001") || strUserStt_DB.equals("002"))
				actionURL += "&uStt=NJ";

			if(strOpenFlag.equals("Y")) { //���������� ���
				actionURL += "&uStt=N";

			} else { //����������� ���
%>
					<script language="JavaScript">
					<!--
						alert("�ش������� ����������Դϴ�.\n �������� �� �̿����ֽʽÿ�.");
						self.close();
					//-->
					</script>
<%
					return;

			}
		} else { //���Ե� ���
				int intCnt = objForumUser.updateForumVisit(strForumID, strUserID); //�湮ó��

				if (intCnt < 1) {
		%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>			
		<%
					return;

				} else {
					if(strOprtrGbn_DB.equals("Y")) { //����� ���

						actionURL += (strOpenFlag.equals("Y")) ? "&uStt=OO" : "&uStt=CO";
						/*
						if(strOpenFlag.equals("Y")) {
							actionURL += "&uStt=OO";
						} else { //��������� && ����� ���
							actionURL += "&uStt=CO";
						}
						*/

					} else { //��ڰ� �ƴѰ��

						actionURL += (strUserStt_DB.equals("003")) ? "&uStt=Y" : "&uStt=YL";
						/*
						if(strUserStt_DB.equals("004")) { //Ż���û��
							actionURL += "&uStt=L";
						} else {
							actionURL += "&uStt=Y";
						}
						*/
					}

				} //�湮ó��
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

	response.sendRedirect(actionURL);
	return;

	//out.print("actionURL = "+actionURL);
%>