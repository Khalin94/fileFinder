<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RNewBoxMakeProc.jsp
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
  RMemReqBoxWriteForm objParams =new RMemReqBoxWriteForm();  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸�������.
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
  
  String strTmpCmtOrganID=objParams.getParamValue("CmtOrganID");
  /** �Ҽ�����ȸ �������� �ƴϸ� ��Ÿ����ȸ ���� 2004.05.13  => �ٽ� ��ȿȭ( 2004.06.04') */
  //if(objUserInfo.getIsMyCmtOrganID(objParams.getParamValue("CmtOrganID"))==false){
  //   objParams.setParamValue("CmtOrganID",CodeConstants.ETC_CMT_ORGAN_ID);     
  //}endif

%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 String strReqBoxID="";//��ȯ�� �䱸�Թ�ȣ �ޱ�.
 try{
   /********* �븮�� ���� ���� *********/
   MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */
   
   /********* ��Ͻ����ϱ�  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 

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

<%
 /*************************************************************************************************/
 /** 					������ ��ȯ Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
	function init(){
		if(confirm("�ű� �䱸�� ������ ��ϵǾ����ϴ�.\n\n ����ؼ� �䱸������ ����Ͻðڽ��ϱ�?")){
		  formName.action="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqInfoWrite.jsp";
		}
		formName.submit();
	}
</script>
<body onLoad="init()">
				<!-- ���� ����� �Ķ� ���� -->
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp" >
				    <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
				    <input type="hidden" name="AuditYear" value="<%=StringUtil.getSysDate().substring(0,4)%>">
				    <input type="hidden" name="CmtOrganID" value="<%=strTmpCmtOrganID%>"><!--����ȸ ��� ID -->
					<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>"><!--�������� -->
					<input type="hidden" name="SubmtOrganID" value="<%=objParams.getParamValue("SubmtOrganID")%>"><!--������ID -->
				</form>
</body>
</html>
