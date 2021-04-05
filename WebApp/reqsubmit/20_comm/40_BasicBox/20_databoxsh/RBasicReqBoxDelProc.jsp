<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RBasicReqBoxDelProc.jsp
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
  String strReqBoxNm=(String)request.getParameter("ReqBoxNm");
  if(!StringUtil.isAssigned(strReqBoxID)){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
  	//out.println("ParamError:" + "�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
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
   PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */

   /********* ������ ���� �ϱ�  **************/
   blnEditOk =((Boolean)objReqBox.removeRecord(strReqBoxID)).booleanValue(); 
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
  	out.println("<br>Error!!!" + "��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");   
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
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
		alert("<%=strReqBoxNm%> �䱸�� ������ �����Ǿ����ϴ� ");
		location.href="./RBasicReqBoxList.jsp";
</script>
</html>
					
				