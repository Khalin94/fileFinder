<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqInfoWriteForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.form.RequestWrapper" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	/**Multipart일경우 반드시 이녀석을 이용해서 담의 Valid파람으로 넘겨줘야함 */
	RequestWrapper objReqWrapper = null;
	try {
		objReqWrapper = new RequestWrapper(request);
	} catch(java.io.IOException ex) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0010");
		objMsgBean.setStrMsg("업로드할 파일사이즈를 초과하였습니다. 제한된 파일사이즈를 확인해 주세요!!");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;  	
	}
	
	CmtSubmtReqBoxWriteForm objWriteForm = new CmtSubmtReqBoxWriteForm();  
	CmtSubmtReqInfoWriteForm objWriteForm2 = new CmtSubmtReqInfoWriteForm();
	
	// 기본적으로 Session에서 Form에 설정가능한 값들을 설정한다.
	objWriteForm.setParamValue("ReqOrganID", objUserInfo.getOrganID());					// 요구기관을 세션에서 넣어줌.
	objWriteForm.setParamValue("CmtSubmtReqrID", objUserInfo.getUserID());				// 작성자 ID
	objWriteForm2.setParamValue("ReqrNm", objUserInfo.getUserName());						//요구자명을 세션에서 넣어줌.
  	objWriteForm2.setParamValue("RegrID", objUserInfo.getUserID());							//요구자ID를 세션에서 넣어줌.
	
	boolean blnParamCheck1 = false;
	boolean blnParamCheck2 = false;
	blnParamCheck1 = objWriteForm.validateParams(objReqWrapper);
	blnParamCheck2 = objWriteForm2.validateParams(objReqWrapper);
	if(blnParamCheck1 == false || blnParamCheck2 == false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("[1st] "+ objWriteForm.getStrErrors() + "[2nd]" + objWriteForm2.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	
	try {
		// 구분자로 나누어진 긴 파라미터 문자열을 활용 가능한 배열로 전환한다.
		// 1. 위원회, 제출기관
		// 2. 요구제목
		// 3. 요구내용
		String strSubOrganIdList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("SubmtOrganID"));
		String strReqContList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("TempTitle"));
		String strReqDtlContList = StringUtil.getEmptyIfNull(objWriteForm2.getParamValue("TempContent"));
		String[] arrSubmtOrganID = strSubOrganIdList.split(",");
		String[] arrReqCont = strReqContList.split("Ω");
		String[] arrReqDtlCont = strReqDtlContList.split("Ω");
		
		CmtSubmtReqBoxDelegate objReqBox = new CmtSubmtReqBoxDelegate();			// 요구함 정보 입력용
		CmtSubmtReqInfoDelegate objReqInfo = new CmtSubmtReqInfoDelegate();			// 요구 정보 입력용
		
		// 신청함을 등록하면 결과값을 신청함 ID로 반환한다.
		String strReqBoxID = objReqBox.setNewRecord2(objWriteForm);
		String strReqID = "";

		// [요구 등록을 위한 폼 설정] 신청함 ID
		objWriteForm2.setParamValue("ReqBoxID", strReqBoxID);
		
		for(int i=0; i<arrSubmtOrganID.length; i++) {
			String strSubmtOrganID = StringUtil.split("^", arrSubmtOrganID[i])[1];
			// [요구 등록을 위한 폼 설정] 제출기관 ID
			objWriteForm2.setParamValue("SubmtOrganID", strSubmtOrganID);
			for(int j=0; j<arrReqCont.length; j++) {
				//System.out.println(arrReqCont[j]+"<BR>");
				//System.out.println(arrReqDtlCont[j]+"<BR>");
				objWriteForm2.setParamValue("ReqCont", StringUtil.ReplaceString(arrReqCont[j], "'", "`"));
				objWriteForm2.setParamValue("ReqDtlCont", StringUtil.ReplaceString(arrReqDtlCont[j], "'", "`"));
				objWriteForm2.setParamValue("AnsEstyleFilePath", objWriteForm2.getParamValue("AnsEstyleFilePath"+j));
				objWriteForm2.setParamValue("OpenCL", "002"); 			// 임시로
				
				strReqID = objReqInfo.setNewRecord2(objWriteForm2);
				
				if(!StringUtil.isAssigned(strReqID)) {
					objMsgBean.setMsgType(MessageBean.TYPE_WARN);
					objMsgBean.setStrCode("DSDATA-0010");
					objMsgBean.setStrMsg("요청하신 요구 정보를 등록하지 못했습니다");
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
					return;   	
				}
				
			}
		}
%>
		<script language="javascript">
			alert("위원회 제출 신청함 등록을 정상적으로 완료했습니다.");
			opener.window.location.href='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommReqList.jsp?AuditYear=<%= objWriteForm.getParamValue("AuditYear") %>&CmtOrganIDX=<%= objWriteForm.getParamValue("CmtOrganIDX") %>';
			self.close();
		</script>

<%
	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		if(objAppEx.getStrErrCode().equals("DSDATA-0002")) {
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg("중복된 신청함이 있습니다. 신청함 목록을 확인하세요!!");
		} else {
	  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
	  		objMsgBean.setStrMsg(objAppEx.getMessage());
		}
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>