<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommNewBoxForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommNewBoxMakeProc.jsp
* Summary	  : 신규 요구함 등록 처리.
* Description : 요구함 등록 처리 기능 제공.
* 				※※ 체크 ※※
*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /** 요구함 생성위한 세션 파라미터 설정.*/
  RCommNewBoxForm objParams =new RCommNewBoxForm();  
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//요구자 ID설정.

  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	//return;
  }//endif
%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 String strReqBoxID="";//반환될 요구함번호 받기.
 
 try{
   /********* 대리자 정보 설정 *********/
   CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();   /** 요구함 정보 입력용 */
   
   /********* 등록실행하기  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 

   if(strReqBoxID.equalsIgnoreCase("False")){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0010");
%>
	<script language="JavaScript">
		alert("신규 요구함 등록 정보가 중복되었습니다.");
		history.go(-1);
	</script>
<%
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	//objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }

	String strReturnUrl = "";
	String strReqBoxStt = (String)objParams.getParamValue("ReqBoxStt");
	if(strReqBoxStt.equalsIgnoreCase("001")){
		strReturnUrl = "./RCommReqBoxVList.jsp";
	} else {
		strReturnUrl = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
	}
%>
<html>
<script language="JavaScript">
	function init(strReturn){
		if (confirm(" 신규 요구함 정보가 등록되었습니다. \n 새로 생성된 요구함에 요구를 등록하시겠습니까?")) {
			formName.action="./RCommReqInfoWrite.jsp";
		} else {
			formName.action=strReturn;
		}
		formName.submit();	
	}
</script>
<body onLoad="init('<%=strReturnUrl%>')">
	<!-- 편의 도모용 파람 전달 -->

	<form name="formName" method="post" action="">
	<input type="hidden" name="ReqScheID" value="<%=(String)request.getParameter("ReqScheID")%>">
	<input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="IngStt" value="<%=(String)objParams.getParamValue("ReqBoxStt")%>">	
	</form>
</body>
</html>
