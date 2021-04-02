<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqInfoWriteForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ���� ��Ͽ��� ��� ����ٴ�..*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */

  /**Multipart�ϰ�� �ݵ�� �̳༮�� �̿��ؼ� ���� Valid�Ķ����� �Ѱ������ */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=
  new nads.lib.reqsubmit.form.RequestWrapper(request);
  blnParamCheck=objParams.validateParams(objRequestWrapper);
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

  /** �䱸 ��Ͽ� �ʿ��� �Ķ� ���� üũ.*/
  RCommReqInfoWriteForm objWriteParams =new RCommReqInfoWriteForm();  
  objWriteParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.
  objWriteParams.setParamValue("RegrID",objUserInfo.getUserID());//�䱸�����ڸ� ���ǿ��� �־���.
  objWriteParams.setParamValue("OldReqOrganId",objUserInfo.getOrganID());//�䱸�����ڸ� ���ǿ��� �־���.
  blnParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  /** ������ ������ Wrapper */
  blnParamCheck=objWriteParams.validateParams(objRequestWrapper);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objWriteParams.getStrErrors());
  	//out.println("ParamError:" + objWriteParams.getStrErrors());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
	
  //out.println(objWriteParams.getValuesForDebug()); 
  
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 boolean blnOk=false; //��� ����.
 try{
   /********* �븮�� ���� ���� *********/
   CommRequestInfoDelegate objReqInfo=new CommRequestInfoDelegate();   /** �䱸�� ���� �Է¿� */

   /********* ������ ��� �ϱ�  **************/
   String strReqID=objReqInfo.setNewRecord(objWriteParams);  
   if(!StringUtil.isAssigned(strReqID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");
  	out.println("<br>Error!!!" + "��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");   
  	%>

  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	
  	<%  	
  	return; 
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
	String strReturnURL = (String)objWriteParams.getParamValue("ReturnURL");
%>
<html>
<script language="JavaScript">
	function init(strReturn){
		if (confirm(" �䱸 ������ ��ϵǾ����ϴ�. \n ��� ����Ͻðڽ��ϱ�?")) {
			formName.action="./RCommReqInfoWrite.jsp";
		} else {
			formName.action=strReturn;
		}
		formName.submit();
	}
</script>
<body onLoad="init('<%=strReturnURL%>')">
	<form name="formName" method="get" action="" ><!--�䱸�� �ű����� ���� -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryMtd")%>"><!--�䱸�� ��ȸ�� -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--�䱸 ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryMtd")%>"><!--�䱸 ��ȸ�� -->										
		<input type="hidden" name="CommReqInfoPage" value="<%=objParams.getParamValue("CommReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="ReturnURL" value="<%=strReturnURL%>"><!-- ���ư� �ּ� -->
	</form>
</body>
</html>
			
