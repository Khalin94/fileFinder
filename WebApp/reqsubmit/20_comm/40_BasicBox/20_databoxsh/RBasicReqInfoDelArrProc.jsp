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
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
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
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  int intFailtoRemove=0; //�������а���.
  
  /** ó���� �䱸 ID�� �ִ��� üũ */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //���� ����.
	 try{
	   /********* �븮�� ���� ���� *********/
	   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** �䱸 ���� �� */
	   
	   /**������ŭ Loop ���� */
	   for(int i=0;i<strReqInfoIDs.length;i++){
	       String strReqInfoID=strReqInfoIDs[i];
		   /********* ������ ���� �ϱ�  **************/
		   blnOk =((Boolean)objReqInfo.removeRecord(strReqInfoID,objUserInfo.getUserID())).booleanValue(); 
		   if(!blnOk){
		   	intFailtoRemove++;
		   }
	   }//end for
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException����.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	//out.println("<br>Error!!!" + objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return; 
	 }//endoftry
	 blnHasIDs=true;//ó����.
  }
%>
<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		<%
		 if(blnHasIDs){
		%>
			alert("�����Ͻ� �䱸 ����(<%=strReqInfoIDs.length%>) �� (<%=strReqInfoIDs.length -intFailtoRemove%>)����  �����Ǿ����ϴ� ");
		<%
		}else{
		%>
			alert("������ �䱸������ ���õ��� �ʾҽ��ϴ�.");
		<%
		}
		%>
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RBasicReqBoxVList.jsp" ><!--�䱸�� �󼼺��� ���� ���� -->
				<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>