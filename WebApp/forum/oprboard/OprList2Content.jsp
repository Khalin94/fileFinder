<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));				//�Խù� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));				 //�Խù� ���̵�	
	
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	int intResult = 0;
	
	try{

		//�������� ��ȸ�� +1 �� �Ѵ�.
		intResult = objIndBoard.updateQryCnt(strDataID);

	} catch (AppException objAppEx) {
	
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode());
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
		return;
		
	}
	
	if(intResult != 0){
	
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&dataid=" + strDataID + "&bbrdid="+ strBbrdID);
	
	}
%>