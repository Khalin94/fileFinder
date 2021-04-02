<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /**일반 요구함 상세보기 파라미터 설정.*/
  RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();  
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
  /** 요구 이동인지 복사 인지: 기본은 복사 */
  boolean blnIsReqMove=false;
  if(StringUtil.isAssigned(request.getParameter("IsReqMove"))){
  	blnIsReqMove=true;
  }
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoIDs");
  String[] strReqBoxIDs=StringUtil.getStringArr(request.getParameter("ReqBoxIDs"),"|");
  
    
  //파람 전달이 안되었을경우.
  if(strReqInfoIDs==null || strReqBoxIDs==null){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("요구ID 또는 요구함ID가 전달되지 않았습니다.");
  	//out.println("요구ID 또는 요구함ID가 전달되지 않았습니다.");
  	%>
    <jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;  	
  }

%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/

 ResultSetSingleHelper objRsSH=null;		/** 요구함 상세보기 정보 */
 String strTmpReqBoxID="";/** 마지막 할당 받은 작성중 요구함ID*/
  boolean blnHasIDs=false;
  /** 처리할 요구 ID가 있는지 체크 */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //처리 여부.
	 try{
	   /********* 대리자 정보 설정 *********/
	   MemRequestInfoDelegate objReqInfo=new MemRequestInfoDelegate();   /** 요구 정보 용 */
	   //받은 요구함 만큼 돌기.
	   for(int i=0;i<strReqBoxIDs.length;i++){
	   	  strTmpReqBoxID=strReqBoxIDs[i];
		   /**개수만큼 Loop 돌기 */
		   //for(int j=0;j<strReqInfoIDs.length;j++){
		   for(int j=strReqInfoIDs.length -1;j>=0;j--){		   
		       String strTmpReqInfoID=strReqInfoIDs[j];
			   String strNewReqID=objReqInfo.copyRecord(strTmpReqInfoID,strTmpReqBoxID);
			   if(!StringUtil.isAssigned(strNewReqID)){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("요청하신 요구 정보를 복사 하지 못했습니다");
				  	//out.println("요청하신 요구 정보를 복사 하지 못했습니다");
				  	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
				  	<%  	
				  	return;   				   	
			   }
			   if(blnIsReqMove){//이동시만 삭제
				   /********* 데이터 삭제 하기  **************/
				   blnOk =((Boolean)objReqInfo.removeRecord(strTmpReqInfoID)).booleanValue();
				   if(!blnOk){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("요청하신 요구 정보를 삭제하지 못했습니다");
				  	//out.println("요청하신 요구 정보를 삭제하지 못했습니다");
				  	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
				  	<%  	
				  	return;   	
				   }
			   }//endif
	       }//endfor
	       if(blnIsReqMove) break;//이동시는 한번만 들어와야해...
	    }//endfor
	    
	    //기본 요구함 정보 파람 전달
	    MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();
	    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord(strTmpReqBoxID));
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	out.println("<br>Error!!!" + objAppEx.getMessage());
	  	%>
	  	 
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
		 if(blnIsReqMove){
		%>
			alert("선택하신 요구 정보가  이동되었습니다 \n\n 이동된 요구함 상세보기화면으로 이동합니다.");
		<%
		}else{
		%>
			alert("선택하신 요구 정보가  복사 되었습니다 \n\n 복사된 요구함 상세보기화면으로 이동합니다.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
   <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp">
   		<input type="hidden" name="AuditYear" value="<%=(String)objRsSH.getObject("AUDIT_YEAR")%>">
   		<input type="hidden" name="CmtOrganID" value="<%=(String)objRsSH.getObject("CMT_ORGAN_ID")%>">
   		<input type="hidden" name="ReqBoxID" value="<%=(String)objRsSH.getObject("REQ_BOX_ID")%>">
   </form>
</body>
</html>