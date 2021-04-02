<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxEditForm"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RMakeReqBoxEditProc.jsp
* Summary	  : 요구함 수정 처리 기능.
* Description : 요구함 수정 외에 조회용으로 끌고다니는 파라미터 까지 담아서 처리함.
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

  /** 상세보기 페이징용 파라미터 설정.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**페이징  파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	
  	<%
  	return;
  }//endif
  
  /** 요구함 정보 파라미터 설정.*/
  RPreReqBoxEditForm objEditParams =new RPreReqBoxEditForm();  
  objEditParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관을 세션에서 넣어줌.
  blnParamCheck=false;
  /** 요구함정보 수정 파리미터 체크 */
  blnParamCheck=objEditParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	out.println("ParamError:" + objEditParams.getStrErrors());
  	%>
  	
  	<%
  	return;
  }//endif

%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 boolean blnEditOk=false; //수정 여부.
 try{
   /********* 대리자 정보 설정 *********/
   PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();   /** 요구함 정보 입력용 */

   /********* 데이터 수정 하기  **************/
   blnEditOk =((Boolean)objReqBox.setRecord(objEditParams)).booleanValue(); 
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("요청하신 요구함 정보를 수정하지 못했습니다");
  	//out.println("<br>Error!!!" + "요청하신 요구함 정보를 수정하지 못했습니다");   
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
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
<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("요구함 정보가 수정되었습니다 ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RBasicReqBoxVList.jsp" ><!--요구함 신규정보 전달 -->
					<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
					
					
					

