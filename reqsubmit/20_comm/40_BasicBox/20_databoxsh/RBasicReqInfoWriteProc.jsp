<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoWriteForm" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
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

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ���� ��Ͽ��� ��� ����ٴ�..*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */

  /**Multipart�ϰ�� �ݵ�� �̳༮�� �̿��ؼ� ���� Valid�Ķ����� �Ѱ������ */
  nads.lib.reqsubmit.form.RequestWrapper objRequestWrapper=null;
  try{
  	objRequestWrapper=
  	new nads.lib.reqsubmit.form.RequestWrapper(request);
  }catch(java.io.IOException ex){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0010");
  	objMsgBean.setStrMsg("���ε��� ���ϻ���� �ʰ��Ͽ����ϴ�. ���ѵ� ���ϻ���� Ȯ���� �ּ���!!");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;  	
  }
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
  //out.println(objParams.getValuesForDebug()); 
  //out.println("<br><br>");

  /** �䱸 ��Ͽ� �ʿ��� �Ķ� ���� üũ.*/
  RPreReqInfoWriteForm objWriteParams =new RPreReqInfoWriteForm();  
  objWriteParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.
  objWriteParams.setParamValue("RegrID",objUserInfo.getUserID());//�䱸�����ڸ� ���ǿ��� �־���.
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
   PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** �䱸�� ���� �Է¿� */

   /********* ������ ��� �ϱ�  **************/
   String strReqID=objReqInfo.setNewRecord(objWriteParams);  
   if(!StringUtil.isAssigned(strReqID)){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸 ������ ������� ���߽��ϴ�");
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
		if (confirm(" �䱸 ������ ��ϵǾ����ϴ�. \n ��� ����Ͻðڽ��ϱ�?")) {
			formName.action="./RBasicReqInfoWrite.jsp";
		} else {
			formName.action="./RBasicReqBoxVList.jsp";
		}
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RBasicReqBoxVList.jsp" ><!--�䱸�� �ű����� ���� -->
	             <%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
			
