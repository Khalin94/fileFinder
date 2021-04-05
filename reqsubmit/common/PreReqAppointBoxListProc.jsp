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
  String[] strReqBoxIDs=StringUtil.getStringArr(request.getParameter("ReqBoxIDs"),"|");
  
    
  //�Ķ� ������ �ȵǾ������.
  if(strReqInfoIDs==null || strReqBoxIDs==null){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�䱸ID �Ǵ� �䱸��ID�� ���޵��� �ʾҽ��ϴ�.");
  	out.println("�䱸ID �Ǵ� �䱸��ID�� ���޵��� �ʾҽ��ϴ�.");
  	%>

  	<%
  	return;  	
  }

%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/
  boolean blnHasIDs=false;
  /** ó���� �䱸 ID�� �ִ��� üũ */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //ó�� ����.
	 try{
	   /********* �븮�� ���� ���� *********/
	   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** �䱸 ���� �� */
	   //���� �䱸�� ��ŭ ����.
	   for(int i=0;i<strReqBoxIDs.length;i++){
	   	  String strTmpReqBoxID=strReqBoxIDs[i];
		   /**������ŭ Loop ���� */
		   for(int j=0;j<strReqInfoIDs.length;j++){
		       String strTmpReqInfoID=strReqInfoIDs[j];
			   String strNewReqID=objReqInfo.appointRecord(strTmpReqInfoID,strTmpReqBoxID);
			   //out.println("�䱸���̵�"+strTmpReqInfoID);
			   //out.println("�䱸�� ���̵�"+strTmpReqBoxID);
			   if(!StringUtil.isAssigned(strNewReqID)){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ���� ���� ���߽��ϴ�");
				  	out.println("��û�Ͻ� �䱸 ������ ���� ���� ���߽��ϴ�");
				  
				  	return;   				   	
			   }
			   
	       }//endfor
	       //if(blnIsReqMove) break;//�̵��ô� �ѹ��� ���;���...
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
		
		alert("�����Ͻ� �䱸 ������  ���� �䱸 ���� �Ǿ����ϴ�");
		window.location.href='<%=request.getParameter("ReturnUrl")%>';
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="get" action="<%=request.getParameter("ReturnUrl")%>" ><!--�䱸�� �󼼺��� ���� ���� -->
				    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
				    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">		    		    		    		    				
				    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				</form>
</body>
</html>