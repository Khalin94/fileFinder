<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MainReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /** �䱸��� ��� �Ķ���� ����.*/
  MainReqInfoListForm objParams =new MainReqInfoListForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
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
  //�䱸�� or ������
  boolean blnIsRequester=Boolean.valueOf((String)request.getSession().getAttribute("IS_REQUESTER")).booleanValue();
  
 /*************************************************************************************************/
 /** 					������ ȣ�� Part  														  */
 /*************************************************************************************************/
 ResultSetHelper objReqInfoRs=null;				/**�䱸 ��� */
 try{
   /** �䱸��� ��� �븮��.*/
   RequestInfoDelegate objReqInfo=new RequestInfoDelegate();
   objReqInfoRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
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
<h3>�䱸���</h3>
<%
	if(objReqInfoRs.getRecordSize() >0) {//����� ������.
%>
		<table border="1" width="400">
	   <%
		while(objReqInfoRs.next()){
	   %>
		<tr><td>
			<a href="<%=RequestInfoDelegate.getGotoLink(blnIsRequester,
											objReqInfoRs.getObject("REQ_BOX_ID"),
											objReqInfoRs.getObject("REQ_BOX_TP"),
											objReqInfoRs.getObject("REQ_ID"),
											objReqInfoRs.getObject("AUDIT_YEAR"),
											objReqInfoRs.getObject("CMT_ORGAN_ID"),
											objReqInfoRs.getObject("REQ_ORGAN_ID"))%>">
			<%
			  //��� ��¥.
			  String strOutDate=null;
			  out.print("[");
			  if(objParams.isRequester()){//�䱸��
			  	out.print((String)objReqInfoRs.getObject("SUBMT_ORGAN_NM"));//������
			  	strOutDate=(String)objReqInfoRs.getObject("LAST_ANS_DT");
			  }else{//������
			  	out.print((String)objReqInfoRs.getObject("REQ_ORGAN_NM"));//������
			  	strOutDate=(String)objReqInfoRs.getObject("LAST_REQ_DT");
			  }
			  out.print("] ");
			  out.print(nads.lib.reqsubmit.util.StringUtil.substring((String)objReqInfoRs.getObject("REQ_CONT"),30));//�䱸���� 30�ڸ� ��������...
			  out.println(nads.lib.reqsubmit.util.StringUtil.getDate(strOutDate));
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
