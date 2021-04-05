<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RNewBoxMakeProc.jsp
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
  RMemReqBoxWriteForm objParams =new RMemReqBoxWriteForm();  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관설정.
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
  
  String strTmpCmtOrganID=objParams.getParamValue("CmtOrganID");
  /** 소속위원회 제출기관이 아니면 기타위원회 설정 2004.05.13  => 다시 무효화( 2004.06.04') */
  //if(objUserInfo.getIsMyCmtOrganID(objParams.getParamValue("CmtOrganID"))==false){
  //   objParams.setParamValue("CmtOrganID",CodeConstants.ETC_CMT_ORGAN_ID);     
  //}endif

%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 String strReqBoxID="";//반환될 요구함번호 받기.
 try{
   /********* 대리자 정보 설정 *********/
   MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();   /** 요구함 정보 입력용 */
   
   /********* 등록실행하기  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 

 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
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
		if(confirm("신규 요구함 정보가 등록되었습니다.\n\n 계속해서 요구정보를 등록하시겠습니까?")){
		  formName.action="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqInfoWrite.jsp";
		}
		formName.submit();
	}
</script>
<body onLoad="init()">
				<!-- 편의 도모용 파람 전달 -->
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp" >
				    <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
				    <input type="hidden" name="AuditYear" value="<%=StringUtil.getSysDate().substring(0,4)%>">
				    <input type="hidden" name="CmtOrganID" value="<%=strTmpCmtOrganID%>"><!--위원회 기관 ID -->
					<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>"><!--업무구분 -->
					<input type="hidden" name="SubmtOrganID" value="<%=objParams.getParamValue("SubmtOrganID")%>"><!--제출기관ID -->
				</form>
</body>
</html>
