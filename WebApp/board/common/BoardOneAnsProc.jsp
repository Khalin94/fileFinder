<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");											//�α��� ID
	
	/*GET �Ķ����*/
	String strGoToPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(URLDecoder.decode(request.getParameter("strGoToPage"), "UTF-8")));//��ũ������
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));	//����
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));
	//�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			//�Խù� ���̵�
	String strOneWord = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneword")));			//���ٴ�� ����
	String strOneID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));				//���ٴ�� ���̵�
	String strOneCnt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("onecnt")));			//���ٴ�� ���� (��ۻ���)
	String strNowExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("nowext")));			//���ٴ�� ����
	
	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խù� ������ �˼� �����ϴ�.");
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();	
	Hashtable objHshOneData = new Hashtable();
	int intResult = 0;
	
	if(strCmd.equals("ONE_CREATE")){
	
		//out.print("���ٴ�� ����<br>");
		
		//1. ONE_ANS�� ����Ÿ�� INSERT �Ѵ�.
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("WRITER_ID", strLoginID);
		objHshOneData.put("ONE_WORD", strOneWord);
		objHshOneData.put("DEL_FLAG", "N");							//'N' �ϵ��ڵ�
		objHshOneData.put("REMARK", ""); 
		objHshOneData.put("ONE_ANS_EXT", "Y");					// "Y" �ϵ��ڵ�
		objHshOneData.put("NOW_EXT", strNowExt);				//���ٴ�� ����
		
		try {
		
			intResult = objBoard.insertOneAns(objHshOneData);
		
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

		if(intResult != 0){
		
			//����� �����ϸ� ������ �������� �̵��Ѵ�.
			response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		
		} else {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0010");
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
			
			}
		
	} else if(strCmd.equals("ONE_DELETE")) {
	
		//out.println("���ٴ�� ����<br>");

		//��Ģ : ������ ��� ������ ��� BBRD_DATA ���̺��� ONE_ANS_EXT �� 'N'�� ���� 
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("ONE_ANS_ID", strOneID);
		objHshOneData.put("ONE_ANS_EXT", "N");			//���ٴ�� ������ 1�� ��츸 ���ǹǷ� "N"�� ���� 
		objHshOneData.put("ONE_CNT", strOneCnt);		//���ٴ�� ���� 

		try {
		
			intResult = objBoard.deleteOneAns(objHshOneData);
			
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
		
		if(intResult != 0){
		
			//������ �����ϸ� ������ �������� �̵��Ѵ�.
			response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		
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