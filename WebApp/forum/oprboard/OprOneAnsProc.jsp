<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	//���� �������� ������ ��.
	String strUserID = "tester1"; 																//�α��� ID
	
	//GET �Ķ����
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("cmd")));						 //����
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));				 //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));				 //�Խù� ���̵�
	String strOneWord = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneword")));				//���ٴ�� ����
	String strOneID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("oneid")));					 //���ٴ�� ���̵�
	String strOneCnt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("onecnt")));				 //���ٴ�� ���� (��ۻ���)
	String strNowExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("nowext")));				 //���ٴ�� ����

	out.print("strDataID : " + strDataID + "<br>");
	out.println("strOneID " + strOneID + "<br>");
	out.println("strOneWord " + strOneWord + "<br>");
	out.println("strOneCnt " + strOneCnt + "<br>");
	
	//�ʱⰪ ���� 
	nads.dsdm.app.board.SLBoardDelegate objOprBoard = new nads.dsdm.app.board.SLBoardDelegate();	
	Hashtable objHshOneData = new Hashtable();
	int intResult = 0;
	
	if(strCmd.equals("ONE_CREATE")){
	
		out.print("���ٴ�� ����<br>");
		
		//1. ONE_ANS�� ����Ÿ�� INSERT �Ѵ�.
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("WRITER_ID", strUserID);
		objHshOneData.put("ONE_WORD", strOneWord);
		objHshOneData.put("DEL_FLAG", "N");							//�ӽ÷� 'N' �ϵ��ڵ� => �ڵ����̺�
		objHshOneData.put("REMARK", ""); 
		objHshOneData.put("ONE_ANS_EXT", "Y");					//�ӽ÷� "Y" �ϵ��ڵ� => �ڵ����̺�
		objHshOneData.put("NOW_EXT", strNowExt);				//���ٴ�� ����
		
		try {
		
			intResult = objOprBoard.insertOneAns(objHshOneData);
			
		} catch (AppException objAppEx) {
	
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode());
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
			return;
			
		}
		
		out.print("intResult : " + intResult +"<br>");
		
		if(intResult != 0){
			out.print("���ٴ�� �Է� ����<br>");
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		}
		
	} else if(strCmd.equals("ONE_DELETE")) {
	
		out.println("���ٴ�� ����<br>");
		
		//���ٴ���� �����Ѵ�.
		//��Ģ : ������ ��� ������ ��� BBRD_DATA ���̺��� ONE_ANS_EXT �� 'N'�� ���� 
		objHshOneData.put("DATA_ID", strDataID);
		objHshOneData.put("ONE_ANS_ID", strOneID);
		objHshOneData.put("ONE_ANS_EXT", "N");			//���ٴ�� ������ 1�� ��츸 ���ǹǷ� "N"�� ���� 
		objHshOneData.put("ONE_CNT", strOneCnt);		//���ٴ�� ���� 

		try {
		
			intResult = objOprBoard.deleteOneAns(objHshOneData);
			
		} catch (AppException objAppEx) {
	
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode());
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
			return;
		
		}
		
		if(intResult != 0){
			out.print("���ٴ�� ���� ����<br>");
			response.sendRedirect("OprNoticeContent.jsp?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&dataid=" + strDataID);
		}
	}
	
%>
