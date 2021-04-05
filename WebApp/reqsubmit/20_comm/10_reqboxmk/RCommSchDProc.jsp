<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
    System.out.println("123123123123123");

	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));							//구분

	String strReqScheId  = StringUtil.getNVLNULL(request.getParameter("ReqScheId"));		//seq

	//※Delegate 선언※.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	//입력할 데이타를 HashTable 생성
	Hashtable objHashData = new Hashtable();
	int intResult = 0;

//	try{
		 if(strCmd.equals("delet")){
			out.print("삭제<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);

			try {
				intResult = objCommReq.deleteCommSch(strReqScheId);
			} catch (AppException objAppEx) {

				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}

			out.print("intResult : " + intResult);

			if(intResult != 0 ){
				out.print("삭제 성공<br>");
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RNewBoxMake.jsp");
			} else {
				out.println("에러페이지로 이동 <br>");
			}
		}
		else if(strCmd.equals("updat")){
		    //요구일정 접수 마감
			//out.print("수정<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);
			try {
				intResult = objCommReq.updateCommSchStt(strReqScheId);
			} catch (AppException objAppEx) {

				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}

			//out.print("서버 호출<br>");

			//out.print("intResult : " + intResult);

			if(intResult != 0 ){
				out.print("수정 성공<br>");
//				response.sendRedirect("RCommSchVList.jsp?ReqSchId=" + strReqSchId);
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RCommSchVList.jsp?ReqSchId="+strReqScheId);
			}

		}else if(strCmd.equals("updateback")){
		    //요구일정 접수 마감 취소
			out.print("마감취소<br>");

			//objHashData.put("REQ_SCHE_ID", strReqSchId);
			try {
				intResult = objCommReq.updateCommSchSttCancel(strReqScheId);
			} catch (AppException objAppEx) {

				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("메세지 페이지로 이동하여야 한다.<br>");
				return;
			}

			out.print("서버 호출<br>");

			out.print("intResult : " + intResult);

			//요구마감이 되어도 요구함은 수정될수 있다 그래서 요구마감일정의 요구함이 모두 삭제 될수 있다.
			//if(intResult != 0 ){
			//	out.print("수정 성공<br>");
				response.sendRedirect("/reqsubmit/20_comm/10_reqboxmk/RNewBoxMake.jsp");
			//}
		}

%>
