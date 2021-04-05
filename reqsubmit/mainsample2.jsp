<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
 /**�䱸�� ��� */
 ResultSetHelper objReqBoxRs=null;	
 /**�䱸������ �븮�� */
 RequestBoxDelegate objReqBox=null;			
 String strMainIsRequeser=(String)request.getSession().getAttribute("IS_REQUESTER");
 try{
   /** ������ �䱸�� ���  ��� �븮��.*/
   objReqBox=new RequestBoxDelegate();
   objReqBoxRs=objReqBox.getMainReqBoxList((String)request.getSession().getAttribute("ORGAN_ID"),(String)request.getSession().getAttribute("ORGAN_KIND"),strMainIsRequeser);
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;
 }
%>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>�������� �ý���</title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<h3>����ȭ�� �䱸�� ���</h3>
<%
	if(objReqBoxRs.getRecordSize() >0) {//����� ������.
%>
		<table border="1" width="400">
	   <%
		while(objReqBoxRs.next()){
	   %>
		<tr><td>
			<%
			  out.print("<a href=\"" + objReqBox.getGotoMainReqBoxLink(objReqBoxRs) + "\">");
			  out.print((String)objReqBoxRs.getObject("REQ_BOX_NM"));//�䱸�Ը�
			  out.print("</a>");
			  if(strMainIsRequeser.equalsIgnoreCase("true")){//�䱸��
			      out.print((String)objReqBoxRs.getObject("SUBMT_ORGAN_NM"));//��������
			  }else{
				  out.print((String)objReqBoxRs.getObject("REQ_ORGAN_NM"));//�䱸�����
			  }
			  out.println(nads.lib.reqsubmit.util.StringUtil.getDate((String)objReqBoxRs.getObject("REG_DT")));//�����
			 %>		
			</a>
		</td></tr>
	  <%
		}//endofwhile
	  %>
		</table>
<%
	}//endif���üũ.
%>
</body>
</html>              
