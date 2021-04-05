<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmitReqBoxApplyForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
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
  CmtSubmitReqBoxApplyForm objParams =new CmtSubmitReqBoxApplyForm();  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
 String strReqScheID=null;  //처리할 요구일자정 ID
 try{
   /********* 대리자 정보 설정 *********/
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();
   /** 1.위원회 일정확인 */
   strReqScheID=objReqBox.checkHavingCommSche(objParams.getParamValue("CmtOrganID"));
   if(!StringUtil.isAssigned(strReqScheID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0020");
  	objMsgBean.setStrMsg("진행중인 위원회 일정이 없습니다.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
   }
   
   /** 2.제출신청 즉시처리. */
   objReqBox.approveCmtSubmtReqBox(objParams.getParamValue("ReqBoxID"),true);
 }catch(AppException objEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objEx.getStrErrCode());
  	objMsgBean.setStrMsg(objEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }
  String strFormType="hidden";
%>
<html>
<head>
<title>위원회 제출신청 완료</title>
<script language="javascript">
	function selfClose(){
	  opener.location.reload();
	  self.close();
	}
</script>
</head>
<body>
<center>
<h4>위원회 제출신청서 처리가 완료되었습니다.</h4>
<a href="javascript:selfClose()"><font size="3">닫기</font></a>
</center>
</body>
</html>