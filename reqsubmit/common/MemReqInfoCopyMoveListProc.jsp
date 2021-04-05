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
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();  
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
  /** �䱸 �̵����� ���� ����: �⺻�� ���� */
  boolean blnIsReqMove=false;
  if(StringUtil.isAssigned(request.getParameter("IsReqMove"))){
  	blnIsReqMove=true;
  }
  String[] strReqInfoIDs=request.getParameterValues("ReqInfoIDs");
  String[] strReqBoxIDs=StringUtil.getStringArr(request.getParameter("ReqBoxIDs"),"|");
  
    
  //�Ķ� ������ �ȵǾ������.
  if(strReqInfoIDs==null || strReqBoxIDs==null){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�䱸ID �Ǵ� �䱸��ID�� ���޵��� �ʾҽ��ϴ�.");
  	//out.println("�䱸ID �Ǵ� �䱸��ID�� ���޵��� �ʾҽ��ϴ�.");
  	%>
    <jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;  	
  }

%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
 String strTmpReqBoxID="";/** ������ �Ҵ� ���� �ۼ��� �䱸��ID*/
  boolean blnHasIDs=false;
  /** ó���� �䱸 ID�� �ִ��� üũ */
  if(strReqInfoIDs!=null && strReqInfoIDs.length >0){
	 boolean blnOk=false; //ó�� ����.
	 try{
	   /********* �븮�� ���� ���� *********/
	   MemRequestInfoDelegate objReqInfo=new MemRequestInfoDelegate();   /** �䱸 ���� �� */
	   //���� �䱸�� ��ŭ ����.
	   for(int i=0;i<strReqBoxIDs.length;i++){
	   	  strTmpReqBoxID=strReqBoxIDs[i];
		   /**������ŭ Loop ���� */
		   //for(int j=0;j<strReqInfoIDs.length;j++){
		   for(int j=strReqInfoIDs.length -1;j>=0;j--){		   
		       String strTmpReqInfoID=strReqInfoIDs[j];
			   String strNewReqID=objReqInfo.copyRecord(strTmpReqInfoID,strTmpReqBoxID);
			   if(!StringUtil.isAssigned(strNewReqID)){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ���� ���� ���߽��ϴ�");
				  	//out.println("��û�Ͻ� �䱸 ������ ���� ���� ���߽��ϴ�");
				  	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
				  	<%  	
				  	return;   				   	
			   }
			   if(blnIsReqMove){//�̵��ø� ����
				   /********* ������ ���� �ϱ�  **************/
				   blnOk =((Boolean)objReqInfo.removeRecord(strTmpReqInfoID)).booleanValue();
				   if(!blnOk){
				 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  	objMsgBean.setStrCode("DSDATA-0011");
				  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");
				  	//out.println("��û�Ͻ� �䱸 ������ �������� ���߽��ϴ�");
				  	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
				  	<%  	
				  	return;   	
				   }
			   }//endif
	       }//endfor
	       if(blnIsReqMove) break;//�̵��ô� �ѹ��� ���;���...
	    }//endfor
	    
	    //�⺻ �䱸�� ���� �Ķ� ����
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
		 if(blnIsReqMove){
		%>
			alert("�����Ͻ� �䱸 ������  �̵��Ǿ����ϴ� \n\n �̵��� �䱸�� �󼼺���ȭ������ �̵��մϴ�.");
		<%
		}else{
		%>
			alert("�����Ͻ� �䱸 ������  ���� �Ǿ����ϴ� \n\n ����� �䱸�� �󼼺���ȭ������ �̵��մϴ�.");
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