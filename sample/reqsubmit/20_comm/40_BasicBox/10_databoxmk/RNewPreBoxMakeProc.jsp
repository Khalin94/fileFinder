<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RNewPreBoxMakeProc.jsp
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /** 요구함 생성위한 세션 파라미터 설정.*/
  RPreReqBoxWriteForm objParams =new RPreReqBoxWriteForm();  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관설정.
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//요구자 ID설정.
  /** 편의 제공용 SELECT Box Param */ 
  String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**위원회 목록 */
  String strBoxID=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxID"));/** 요구함  */

  
  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
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
   PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();   /** 요구함 정보 입력용 */
   
   /********* 등록실행하기  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 
   
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%  	
  	return; 
 }
%>

<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/

 /******** 이동할 페이지로 이동 *******/
 //response.sendRedirect("../20_databoxsh/RBasicReqBoxList.jsp");	
%>
<html>
<script language="JavaScript">
	function init(){
		if(confirm("신규 요구함 정보가 등록되었습니다.\n\n 계속해서 요구정보를 등록하시겠습니까?")){
		  formName.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqInfoWrite.jsp";
		}
		formName.submit();
	}
	
</script>

<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxVList.jsp"  ><!--요구함 신규정보 전달 -->
	             <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
				    <input type="hidden" name="AuditYear" value="<%=StringUtil.getSysDate().substring(0,4)%>">
				    <input type="hidden" name="CmtOrganID" value="<%=strCmtOrganID%>"><!--위원회 기관 ID -->
					<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>"><!--업무구분 -->
					<input type="hidden" name="SubmtOrganID" value="<%=objParams.getParamValue("SubmtOrganID")%>"><!--제출기관ID -->
				</form>
</body>



</html>
