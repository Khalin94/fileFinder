<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");										//�α��� ID
	
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 				 //���� ���̵�
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt")));		 		 //ȸ������
	String strOpenFlag = ""; 	//��������
	String strForumNM = ""; 	//������
	
	/*GET �Ķ����*/
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //����
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�(����, ����)
	String strBbrdNm =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdnm")));			 //�Խ��� �̸�
	String strBbrdKind =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdkind")));		 //�Խ��� ����
	String strBbrdFileCnt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("filecnt")));	 //�Խ��� ÷������ ����
	String strBbrdAnsExt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ansext")));		 //�Խ��� �������
	String strBbrdOneExt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneext")));		 //�Խ��� ���ٴ�� ����
	String strBbrdDsc =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dsc")));			 //�Խ��� ����
	String strDataCnt =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("datacnt")));		 //�Խ��� ���� �Խù� ����

	/*�ʱⰪ ���� */
	nads.dsdm.app.forum.SLMngBoardDelegate objMngBoard = new nads.dsdm.app.forum.SLMngBoardDelegate();
	int intResult = 0;
	
	if(strCmd.equals("CREATE")){
		
		//out.println ("����<br>");
		
		//1. BbrdInfo ��ü�� �����Ѵ�.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("FORUM_ID", strForumID);
		objHshBbrdInfo.put("BBRD_NM", strBbrdNm);
		objHshBbrdInfo.put("BBRD_KIND", strBbrdKind);
		objHshBbrdInfo.put("ANS_EXT", strBbrdAnsExt);
		objHshBbrdInfo.put("APD_FILE_CNT", strBbrdFileCnt);
		objHshBbrdInfo.put("ONE_ANS_EXT", strBbrdOneExt);
		objHshBbrdInfo.put("BBRD_COLOR", "");								//������������ ������� �ʴ� �� 
		objHshBbrdInfo.put("IMG_ID", "");											//������������ ������� �ʴ� �� 
		objHshBbrdInfo.put("DSC", strBbrdDsc);
		objHshBbrdInfo.put("REGR_ID", strLoginID);
		objHshBbrdInfo.put("AUTH_NEED_FLAG", "N");						//����Ʈ �� - N
		objHshBbrdInfo.put("ORD", new Integer(0));						//����Ʈ �� - 0
		objHshBbrdInfo.put("DEL_FLAG", "N");
		objHshBbrdInfo.put("REMARK", "OPERATOR");

		try {
			//2. ���� �޼ҵ� ȣ���Ѵ�.

			intResult = objMngBoard.insertBbrdInfo(objHshBbrdInfo);

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

		if(intResult != 0 ){
		
			//����� �����ϸ� �Խ��� ��� �������� �̵��Ѵ�.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
		
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
			
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}

	} else if (strCmd.equals("UPDATE")){
		
		//out.println ("����<br>");
		
		//1. BbrdInfo ��ü�� �����Ѵ�.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("BBRD_ID", strBbrdID);
		objHshBbrdInfo.put("BBRD_NM", strBbrdNm);
		objHshBbrdInfo.put("BBRD_KIND", strBbrdKind);
		objHshBbrdInfo.put("ANS_EXT", strBbrdAnsExt);
		objHshBbrdInfo.put("APD_FILE_CNT", strBbrdFileCnt);
		objHshBbrdInfo.put("ONE_ANS_EXT", strBbrdOneExt);
		objHshBbrdInfo.put("DSC", strBbrdDsc);
		objHshBbrdInfo.put("UPDR_ID", strLoginID);
		
		try {
			//2. ���� �޼ҵ� ȣ���Ѵ�.
			intResult = objMngBoard.updateBbrdInfo(objHshBbrdInfo);
		
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

		if(intResult != 0 ){
		
			//������ �����ϸ� �Խ��� ��� �������� �̵��Ѵ�.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
		
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0011");
			
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	} else if (strCmd.equals("DELETE")){
	
		//out.println ("����<br>");
		
		//1. BbrdInfo ��ü�� �����Ѵ�.
		Hashtable objHshBbrdInfo = new Hashtable();
		
		objHshBbrdInfo.put("BBRD_ID", strBbrdID);
		objHshBbrdInfo.put("UPDR_ID", strLoginID);
		objHshBbrdInfo.put("DEL_FLAG", "Y");

		try {
			//2. ���� �޼ҵ� ȣ���Ѵ�.
			intResult = objMngBoard.updateBbrdDelFlag(objHshBbrdInfo);
		
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
		
		if(intResult != 0 ){
			//������ �����ϸ� �Խ��� ��� �������� �̵��Ѵ�.
			response.sendRedirect("ManageBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt);
			
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0012");
			
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	}
%>