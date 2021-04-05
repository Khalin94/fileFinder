<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RMakeReqBoxDelProc.jsp
* Summary	  : �䱸�� ����  ó�� ���.
* Description : �䱸�� ������ �����ϰ� �䱸�� ��� ���� �̵��Ѵ�.
* 				�ء� üũ �ء�
*				 ���� ����ó���� ������ �������� �ѱ��� ����.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /** �䱸�� ���� ���� */  
  String strReqBoxID=(String)request.getParameter("ReqBoxID");
  if(!StringUtil.isAssigned(strReqBoxID)){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
  	//out.println("ParamError:" + "�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
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
   MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();   
   String strOrganId = objUserInfo.getOrganID();
   ResultSetSingleHelper Rsh = null;
   Rsh = new ResultSetSingleHelper(objReqBox.getRecord(strReqBoxID));

   /********* ������ ���� �ϱ�  **************/
   if(((String)Rsh.getObject("REQ_ORGAN_ID")).equals(strOrganId)){
	   blnEditOk =((Boolean)objReqBox.removeRecord(strReqBoxID)).booleanValue(); 
   }
   
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0012");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
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
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RMakeReqBoxList.jsp" >
				    <input type="hidden" name="AuditYear" value="<%=StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"))%>">
				    <input type="hidden" name="CmtOrganID" value="<%=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"))%>"><!--����ȸ ��� ID -->
				</form>
</body>

<html>
				