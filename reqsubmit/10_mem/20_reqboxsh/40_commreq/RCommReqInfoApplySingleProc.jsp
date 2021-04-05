<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  //요구정보
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoID");
%>
 
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  String[] strReturns=null; //처리 결과 배열. "" 면 처리못한것임.
  int intOkNumber=0;
  /** 처리할 요구 ID가 있는지 체크 */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //처리 성공여부.
	 try{
	   /********* 대리자 정보 설정 *********/
	   CmtSubmtReqInfoDelegate objReqInfo=new CmtSubmtReqInfoDelegate();
	   strReturns=objReqInfo.copyRecord(objUserInfo.getUserID(),strReqInfoIDs);
	   if(strReturns!=null){
	   		for(int i=0;i<strReturns.length;i++){
	   			if(!strReturns[i].equals("")){
	   			intOkNumber++;
	   			}
	   		}
	   }
	   
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return; 
	 }//endoftry
	 blnHasIDs=true;//처리함.
  }
%>
<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		<%
		 if(blnHasIDs){
		%>
			alert("요구 정보가  제출신청되었습니다 ");
		<%
		}else{
		%>
			alert("신청할 요구정보가 잘못선택되었습니다.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getParameter("ReturnUrl")%>" >
				<%=nads.lib.reqsubmit.form.Form.makeHiddenFormTags(request)%>
				</form>
</body>
</html>