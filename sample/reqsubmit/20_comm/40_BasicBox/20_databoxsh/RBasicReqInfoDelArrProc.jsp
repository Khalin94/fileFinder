<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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
  /**일반 요구함 상세보기 파라미터 설정.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
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
  
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoIDs");
%>
 
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  int intFailtoRemove=0; //삭제실패개수.
  
  /** 처리할 요구 ID가 있는지 체크 */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //삭제 여부.
	 try{
	   /********* 대리자 정보 설정 *********/
	   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** 요구 정보 용 */
	   
	   /**개수만큼 Loop 돌기 */
	   for(int i=0;i<strReqInfoIDs.length;i++){
	       String strReqInfoID=strReqInfoIDs[i];
		   /********* 데이터 삭제 하기  **************/
		   blnOk =((Boolean)objReqInfo.removeRecord(strReqInfoID,objUserInfo.getUserID())).booleanValue(); 
		   if(!blnOk){
		   	intFailtoRemove++;
		   }
	   }//end for
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
			alert("선택하신 요구 정보(<%=strReqInfoIDs.length%>) 중 (<%=strReqInfoIDs.length -intFailtoRemove%>)개가  삭제되었습니다 ");
		<%
		}else{
		%>
			alert("삭제할 요구정보가 선택되지 않았습니다.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RBasicReqBoxVList.jsp" ><!--요구함 상세보기 정보 전달 -->
				<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>