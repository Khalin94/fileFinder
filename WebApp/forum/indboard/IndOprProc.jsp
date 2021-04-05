<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 			//����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			//ȸ������
	
	
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));			 //�������
	
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));					 //����
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //�Խù� ���̵�
	String strOneID=  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				 //���ٴ�� ���̵�
	String strDelRsn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("delrsn")));			 //��������

	/*�ʱⰪ ���� */ 
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	int intResult = 0;

	if(strCmd.equals("OPR_DELETE")){
		
		//out.println("��� �Խù� ����");
		
		Hashtable objHshDataInfo = new Hashtable();
		objHshDataInfo.put("DEL_FLAG", "Y");					//��� ������ "Y"
		objHshDataInfo.put("DEL_RSN", strDelRsn);
		objHshDataInfo.put("DATA_ID", strDataID);
		
		try {
		
			//�Խù� ���� �޼ҵ带 ȣ���Ѵ�.
			intResult = objIndBoard.updateOprDelFlag(objHshDataInfo);
			
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
			
			//����� �����ϸ� â�� �ݰ� �� �������� Reload�Ѵ�.
			out.println("<script language=javascript>");
            out.println("<!--");
            out.println("opener.location.href='/forum/indboard/IndBoardContent.jsp?fid="+strForumID+"&uStt="+strUserStt+"&anctgt="+strAncTgt+"&strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID+"';");
            out.println("self.close();");
            out.println("//-->"); 
            out.println("</script>");
			
		} else {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
		}

	} 
	else if(strCmd.equals("ONE_OPR_DELETE")) {
		
		//out.println("��� ���ٴ�� ����");
		
		Hashtable objHshOneAns = new Hashtable();
		objHshOneAns.put("DEL_FLAG", "Y");					//��� ������ "Y"
		objHshOneAns.put("DEL_RSN", strDelRsn);
		objHshOneAns.put("ONE_ANS_ID", strOneID);

		try {
		
			//�Խù� ���� �޼ҵ带 ȣ���Ѵ�.
			intResult = objIndBoard.updateOprOneDelFlag(objHshOneAns);
			
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
		
			//����� �����ϸ� â�� �ݰ� �� �������� Reload�Ѵ�.
			out.println("<script language=javascript>");
            out.println("<!--");
            out.println("opener.location.href='/forum/indboard/IndBoardContent.jsp?fid="+strForumID+"&uStt="+strUserStt+"&anctgt="+strAncTgt+"&strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID+"';");
            out.println("self.close();");
            out.println("//-->"); 
            out.println("</script>");
            
		} else {
		
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
		
	}

%>