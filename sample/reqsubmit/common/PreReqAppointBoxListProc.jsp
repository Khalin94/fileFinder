<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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
  String[] strReqBoxIDs=StringUtil.getStringArr(request.getParameter("ReqBoxIDs"),"|");
  
    
  //파람 전달이 안되었을경우.
  if(strReqInfoIDs==null || strReqBoxIDs==null){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("요구ID 또는 요구함ID가 전달되지 않았습니다.");
  	out.println("요구ID 또는 요구함ID가 전달되지 않았습니다.");
  	%>

  	<%
  	return;  	
  }

%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  /** 처리할 요구 ID가 있는지 체크 */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //처리 여부.
	 try{
	   /********* 대리자 정보 설정 *********/
	   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** 요구 정보 용 */
	   //받은 요구함 만큼 돌기.
	   for(int i=0;i<strReqBoxIDs.length;i++){
	   	  String strTmpReqBoxID=strReqBoxIDs[i];
		   /**개수만큼 Loop 돌기 */
		   for(int j=0;j<strReqInfoIDs.length;j++){
		       String strTmpReqInfoID=strReqInfoIDs[j];
			   String strNewReqID=objReqInfo.appointRecord(strTmpReqInfoID,strTmpReqBoxID);
			   //out.println("요구아이디"+strTmpReqInfoID);
			   //out.println("요구함 아이디"+strTmpReqBoxID);
			   if(!StringUtil.isAssigned(strNewReqID)){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("요청하신 요구 정보를 복사 하지 못했습니다");
				  	out.println("요청하신 요구 정보를 복사 하지 못했습니다");
				  
				  	return;   				   	
			   }
			   
	       }//endfor
	       //if(blnIsReqMove) break;//이동시는 한번만 들어와야해...
	    }//endfor
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
		
		alert("선택하신 요구 정보가  사전 요구 지정 되었습니다");
		window.location.href='<%=request.getParameter("ReturnUrl")%>';
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="get" action="<%=request.getParameter("ReturnUrl")%>" ><!--요구함 상세보기 정보 전달 -->
				    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">		    		    		    		    				
				    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				</form>
</body>
</html>