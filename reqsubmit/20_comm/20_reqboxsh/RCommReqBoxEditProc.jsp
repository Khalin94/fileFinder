<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxEditForm"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqBoxEditProc.jsp
* Summary	  : �䱸�� ���� ó�� ���.
* Description : �䱸�� ���� �ܿ� ��ȸ������ ����ٴϴ� �Ķ���� ���� ��Ƽ� ó����.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /*************************************************************************************************/
  /** 					�Ķ���� üũ Part 														  */
  /*************************************************************************************************/
  /** �󼼺��� ����¡�� �Ķ���� ����.*/
  /** �䱸�� ���� �Ķ���� ����.*/
  RCommReqBoxEditForm objEditParams =new RCommReqBoxEditForm();  
  objEditParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.

  boolean blnEditParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  blnEditParamCheck=objEditParams.validateParams(request);
  if(blnEditParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	//out.println("Debug Value:\n" + objEditParams.getValuesForDebug());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif

  boolean blnParamCheck=false;
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  /**����¡  �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
  
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 boolean blnEditOk=false; //���� ����.
 try{
   /********* �븮�� ���� ���� *********/
   CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */

   /********* ������ ���� �ϱ�  **************/
   blnEditOk =((Boolean)objReqBox.setRecord(objEditParams)).booleanValue(); 
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
  	//out.println("<br>Error!!!" + "��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");   
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
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
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		alert("�䱸�� ������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<!-- ���� ����� �Ķ� ���� -->
	<%
		String strReturnUrl = "";
	 	String strIngStt = (String)request.getParameter("IngStt");
		if("001".equalsIgnoreCase(strIngStt)){
			strReturnUrl = "./RCommReqBoxVList.jsp";
		} else {
			strReturnUrl = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
		}
	%>
	<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=strReturnUrl%>" ><!--�䱸�� �ű����� ���� -->
	<%=objParams.getHiddenFormTags()%>
	</form>
</body>
</html>
					
					
					

