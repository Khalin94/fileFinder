<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqInfoAppyProc.jsp
* Summary	  : 위원회 제출신청 처리 
* Description : 선택된 일반요구함 ID 배열을 받아서
*               같은년도, 같은 위원회,같은 소관업무에 해당하는 신청함을 찾아서 넣어줌.
*				
* 				
*				
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
  /**요구목록용 파라미터 설정 체크 */
  RMemReqInfoListForm objParams =new RMemReqInfoListForm();  
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
  	return;
  }//endif
  
  String strReqBoxID = StringUtil.getEmptyIfNull(request.getParameter("ReqBoxID"));
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoIDs");
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
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	//out.println("<br>Error!!!" + objAppEx.getMessage());
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
			alert("선택하신 요구 정보(<%=strReqInfoIDs.length%>) 중 (<%=intOkNumber%>)개가  제출신청되었습니다 ");
		<%
		}else{
		%>
			alert("신청할 요구정보가 선택되지 않았습니다.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getParameter("ReturnUrl")%>" >
					<%=objParams.getHiddenFormTags()%>
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
				</form>
</body>
</html>