<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
    System.out.println("123123123123123");

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));							//����

	String strReqScheId  = StringUtil.getNVLNULL(request.getParameter("ReqScheId"));		//seq

	//��Delegate �����.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

//	try{
		 if(strCmd.equals("delet")){
			out.print("����<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);

			try {
				intResult = objCommReq.deleteCommSch(strReqScheId);
			} catch (AppException objAppEx) {

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}

			out.print("intResult : " + intResult);

			if(intResult != 0 ){
				out.print("���� ����<br>");
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RNewBoxMake.jsp");
			} else {
				out.println("������������ �̵� <br>");
			}
		}
		else if(strCmd.equals("updat")){
		    //�䱸���� ���� ����
			//out.print("����<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);
			try {
				intResult = objCommReq.updateCommSchStt(strReqScheId);
			} catch (AppException objAppEx) {

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}

			//out.print("���� ȣ��<br>");

			//out.print("intResult : " + intResult);

			if(intResult != 0 ){
				out.print("���� ����<br>");
//				response.sendRedirect("RCommSchVList.jsp?ReqSchId=" + strReqSchId);
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RCommSchVList.jsp?ReqSchId="+strReqScheId);
			}

		}else if(strCmd.equals("updateback")){
		    //�䱸���� ���� ���� ���
			out.print("�������<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);
			try {
				intResult = objCommReq.updateCommSchSttCancel(strReqScheId);
			} catch (AppException objAppEx) {

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
				return;
			}

			out.print("���� ȣ��<br>");

			out.print("intResult : " + intResult);

			//�䱸������ �Ǿ �䱸���� �����ɼ� �ִ� �׷��� �䱸���������� �䱸���� ��� ���� �ɼ� �ִ�.
			//if(intResult != 0 ){
			//	out.print("���� ����<br>");
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RNewBoxMake.jsp");
			//}
		}

%>
