<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null; // 이용자 정보
	CDInfoDelegate objCdinfo =null; // 시스템 변수(상수)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// 파라미터가 정상적으로 넘어온건지 확인해보자
	boolean blnParamCheck = false;
	blnParamCheck = objParamForm.validateParams(request);
  	if(!blnParamCheck) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end if 

	try {
		String strAnsType = (String)objParamForm.getParamValue("AnsType");
		
		// 답변 ID를 미리 받아와야 나중에 유니플로 관련 백그라운드 작업을 처리할 수 있다.
		String strAnsID = objSMAIDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
		objParamForm.setParamValue("AnsID", StringUtil.padl(strAnsID, 10));
		
		if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(strAnsType)) { // 전자문서이다.
			// 1. 파일명 시퀀스 아이디로 복사
			// 2. 답변파일등록
			// 3. 답변등록
			// 4. PDF 파일 하일라이트 인덱스 파일 생성
			// 5. PDF 파일 검색엔진 색인용 TXT 파일 생성
			// 6. 정리된 모든 파일 저장 경로로 이동(복사)
			// 위의 작업을 진행하는 함수를 호출한다. 
			
			String strAnsFileID = objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO");
			objParamForm.setParamValue("AnsFileID", StringUtil.padl(strAnsFileID, 10));

			int intElcAnsInfoProcResult = objSMAIDelegate.setNewRecordElcAnsInfoProc(objParamForm);
			
			if (intElcAnsInfoProcResult< 1) { // 정상적으로 처리되지 못했다면
				out.println("<script language='javascript'>alert('답변(전자문서) 등록을 에러 발생.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			} else {
				out.println("<script language='javascript'>alert('답변(전자문서) 등록을 정상적으로 완료하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			}
		
		} else { // 비전자문서 or 해당기관아님
			// 그냥 답변테이블에 등록하면 된다.
			int intInsertAnsInfoResult = objSMAIDelegate.setNewRecordToAnsInfo(objParamForm);
			if (intInsertAnsInfoResult < 1) { // 정상적으로 처리되지 못했다면
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("");
	  			objMsgBean.setStrMsg("");
%>
  				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
				return;
			} else {
				out.println("<script language='javascript'>alert('답변 등록을 정상적으로 완료하였습니다.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url="+(String)objParamForm.getParamValue("returnURL")+"'>");
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println(e.getMessage());
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
		objMsgBean.setStrMsg(e.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>