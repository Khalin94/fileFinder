<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommNewBoxForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommNewBoxMakeProc.jsp
* Summary	  : �ű� �䱸�� ��� ó��.
* Description : �䱸�� ��� ó�� ��� ����.
* 				�ء� üũ �ء�
*				 ���� ����ó���� ������ �������� �ѱ��� ����.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /** �䱸�� �������� ���� �Ķ���� ����.*/
  RCommNewBoxForm objParams =new RCommNewBoxForm();  
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//�䱸�� ID����.

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
  	//return;
  }//endif
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 String strReqBoxID="";//��ȯ�� �䱸�Թ�ȣ �ޱ�.
 
 try{
   /********* �븮�� ���� ���� *********/
   CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */
   
   /********* ��Ͻ����ϱ�  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 

   if(strReqBoxID.equalsIgnoreCase("False")){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0010");
%>
	<script language="JavaScript">
		alert("�ű� �䱸�� ��� ������ �ߺ��Ǿ����ϴ�.");
		history.go(-1);
	</script>
<%
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	//objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return; 
 }

	String strReturnUrl = "";
	String strReqBoxStt = (String)objParams.getParamValue("ReqBoxStt");
	if(strReqBoxStt.equalsIgnoreCase("001")){
		strReturnUrl = "./RCommReqBoxVList.jsp";
	} else {
		strReturnUrl = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
	}
%>
<html>
<script language="JavaScript">
	function init(strReturn){
		if (confirm(" �ű� �䱸�� ������ ��ϵǾ����ϴ�. \n ���� ������ �䱸�Կ� �䱸�� ����Ͻðڽ��ϱ�?")) {
			formName.action="./RCommReqInfoWrite.jsp";
		} else {
			formName.action=strReturn;
		}
		formName.submit();	
	}
</script>
<body onLoad="init('<%=strReturnUrl%>')">
	<!-- ���� ����� �Ķ� ���� -->

	<form name="formName" method="post" action="">
	<input type="hidden" name="ReqScheID" value="<%=(String)request.getParameter("ReqScheID")%>">
	<input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	<input type="hidden" name="IngStt" value="<%=(String)objParams.getParamValue("ReqBoxStt")%>">	
	</form>
</body>
</html>
