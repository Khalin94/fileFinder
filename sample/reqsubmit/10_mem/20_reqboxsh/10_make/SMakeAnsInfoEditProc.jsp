<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %> 

<%
	SMemAnsInfoEditForm objParamForm = new SMemAnsInfoEditForm();
	AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();

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
	
	String strContentType = request.getContentType();
	if (strContentType != null) strContentType = StringUtil.substring(strContentType, 19);
	
	if (strContentType.equalsIgnoreCase("multipart/form-data...")) { // MultipartRequest를 이용해야하는 경우
		// 언제 어디서 어떻게 또 쓸지 모른다.. 그냥 변수에 담아두겠습니다.
		String strReqBoxID = String.valueOf(objParamForm.getParamValue("ReqBoxID"));
		String strReqID = String.valueOf(objParamForm.getParamValue("ReqID"));
		String strAnsID = String.valueOf(objParamForm.getParamValue("AnsID"));
		String strAnsFileID = String.valueOf(objParamForm.getParamValue("AnsFileID"));
		String strAnsType = String.valueOf(objParamForm.getParamValue("AnsType"));
		String strOriginFile = String.valueOf(objParamForm.getParamValue("OriginFile"));
		strOriginFile = StringUtil.ReplaceString(strOriginFile, "\\", "/");
		String strPdfFile = String.valueOf(objParamForm.getParamValue("PdfFile"));
		strPdfFile = StringUtil.ReplaceString(strPdfFile, "\\", "/");
		String strAnsOpin = String.valueOf(objParamForm.getParamValue("AnsOpin"));
		String strOpenCL = String.valueOf(objParamForm.getParamValue("OpenCL"));
		String strRegrID = String.valueOf(objParamForm.getParamValue("RegrID"));
		String msgDigest = null;
		
		// 전자 서명 Msg Digest 생성
		// PDF 파일 변경을 선택했으면 작업을 진행하고 그렇지 않으면 굳이 만들 이유없음
		if (!StringUtil.isAssigned(strPdfFile)) { // PDF 파일이 선택되지 않았으므로, 그냥 나머지 정보만 업데이트 하자
			// 나머지 정보만 업데이트 한다
			int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo(objParamForm);
			if (intUpdateResult < 1) {
				throw new AppException("답변 정보 업데이트가 정상적으로 처리되지 못했습니다. 확인바랍니다.");
			} else {
				out.println("<script language='javascript'>");
				out.println("alert('답변 정보를 정상적으로 수정하였습니다.');");
				out.println("opener.window.location.reload();");
				out.println("self.close();");
				out.println("</script>");
			}
		} else { // 다시 전자 서명의 번거로운 작업을 시작한다... -ㅅ-
			msgDigest = objSMAIDelegate.getMsgDigest((String)objParamForm.getParamValue("PdfFile"));
			if (!StringUtil.isAssigned(msgDigest)) throw new AppException("Msg Digest 생성에 실패");
			
			out.println("<form method='post' name='autoForm' action=''>\n");
			out.println("<input type='hidden' name='MsgDigest' value=''>\n");
			out.println("<input type=\"hidden\" name=\"ReqBoxID\" value=\""+strReqBoxID +"\">\n");
			out.println("<input type=\"hidden\" name=\"ReqID\" value=\""+strReqID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsID\" value=\""+strAnsID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsFileID\" value=\""+strAnsFileID+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsType\" value=\""+strAnsType+"\">\n");
			out.println("<input type=\"hidden\" name=\"OriginFile\" value=\""+strOriginFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"PdfFile\" value=\""+strPdfFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"AnsOpin\" value=\""+strAnsOpin+"\">\n");
			out.println("<input type=\"hidden\" name=\"OpenCL\" value=\""+strOpenCL+"\">\n");
			out.println("<input type=\"hidden\" name=\"RegrID\" value=\""+strRegrID+"\">\n");
			out.println("</form>\n");
%>
			<html>
			<head>
			<title></title>
			<script language="vbscript" src="/js/activex.vbs"></script>
			<script language="javascript" src="/js/axkcase.js"></script>
			<script language="javascript">
				function NADSEncryptDigest() {
					var encdigetdata;
					if(!CheckAX()) {
						alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
						return;
					}
					var dn = document.AxKCASE.SelectCert();
					if ((dn == null) || (dn == "")) {
						if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
						return false;
					}
					encdigetdata = document.AxKCASE.EncryptedDigest(dn, "", '<%= msgDigest %>');
					
					if((encdigetdata == null) || (encdigetdata == "")) {
						if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
						return;
					}
					
					autoSubmit(encdigetdata);
				}
				
				function autoSubmit(str) {
					var f = document.autoForm;
					f.MsgDigest.value = str;
					f.OriginFile.value = "<%= strOriginFile %>";
					f.PdfFile.value = "<%= strPdfFile %>";
					f.action = "SMakeAnsInfoEditProc2.jsp";
					f.submit();		
				}
			</script>
			</head>
			<body onLoad="javascript:NADSEncryptDigest()">
				<script language="javascript" src="/js/AxNAROK2.js"></script>
			</body>
			</html>
<%		
		} // end if (PDF FILE NULL CHECK)
		
	} else { // 일반 Normal Form의 경우
		
		// 비전자 문서 OR 해당기관아님 의 경우
		int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo(objParamForm);
		if (intUpdateResult < 1) {
			throw new AppException("답변 정보 업데이트가 정상적으로 처리되지 못했습니다. 확인바랍니다.");
		} else {
			out.println("<script language='javascript'>");
			out.println("alert('답변 정보를 정상적으로 수정하였습니다.');");
			out.println("opener.window.location.reload();");
			out.println("self.close();");
			out.println("</script>");
		}
	
	} // end if
%>