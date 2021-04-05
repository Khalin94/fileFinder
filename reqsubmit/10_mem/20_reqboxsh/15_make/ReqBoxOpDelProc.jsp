<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper " %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	ResultSetSingleHelper objReqRs = null;
	ResultSetHelper objAnsRs = null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	String strReqBoxID = request.getParameter("ReqBoxID");

	boolean blnEditOk = false; //삭제 여부.
	int resultInt = -1;
	int resultInt2 = -1;
	int resultInt3 = -1;
	int resultInt4 = -1;
	try{

		ReqInfoAllInOneDelegate objReqBox=new ReqInfoAllInOneDelegate();
		System.out.println("REQ_BOX_ID : "+strReqBoxID);
		objReqRs = new ResultSetSingleHelper(objReqBox.getReqId(strReqBoxID));
		if(objReqRs != null){
			System.out.println("REQ_ID : "+objReqRs.getObject("REQ_ID"));
			objAnsRs = new ResultSetHelper(objReqBox.getAnsId((String)objReqRs.getObject("REQ_ID")));
		}
		if(((String)objReqRs.getObject("REQ_ID")) != null && !((String)objReqRs.getObject("REQ_ID")).equals("")){
			resultInt3 = objReqBox.deleteAnsInfo((String)objReqRs.getObject("REQ_ID"));
		}
		System.out.println("resultInt3 : "+resultInt3);
		if(objAnsRs != null && objAnsRs.getTotalRecordCount() > 0){
			while(objAnsRs.next()){
				if(resultInt3 > 0 && !((String)objAnsRs.getObject("ANS_FILE_ID")).equals("")){
					System.out.println("ANS_FILE_ID : "+objAnsRs.getObject("ANS_FILE_ID"));
					resultInt4 = objReqBox.deleteAnsFileInfo((String)objAnsRs.getObject("ANS_FILE_ID"));
				}else{
					System.out.println("여기여기");
					resultInt4 = 1;
				}

			}
		}else{
			System.out.println("답변이없는 요구함");
			resultInt4 = 1;
		}
		System.out.println("resultInt4 : "+resultInt4);
		if(resultInt4 > 0){
			resultInt = objReqBox.deleteReqInfo((String)objReqRs.getObject("REQ_ID"));
		}


		if(resultInt > 0){
			resultInt2 = objReqBox.deleteReqBox(strReqBoxID);
		}

		if(resultInt2 < 0){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0012");
			objMsgBean.setStrMsg("요청하신 요구함 정보를 삭제하지 못했습니다");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException에러.
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<script language="JavaScript">
	parent.notProcessing();
	alert("요구함 정보가 삭제되었습니다 ");
	parent.location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp';
	self.close();
</script>
