<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxWriteForm"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>


<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RNewPreBoxMakeProc.jsp
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /** �䱸�� �������� ���� �Ķ���� ����.*/
  RPreReqBoxWriteForm objParams =new RPreReqBoxWriteForm();  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸�������.
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//�䱸�� ID����.
  /** ���� ������ SELECT Box Param */ 
  String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**����ȸ ��� */
  String strBoxID=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxID"));/** �䱸��  */

  
  
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
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
   PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();   /** �䱸�� ���� �Է¿� */
   
   /********* ��Ͻ����ϱ�  **************/
   strReqBoxID =objReqBox.setNewRecord(objParams); 
   
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

 /******** �̵��� �������� �̵� *******/
 //response.sendRedirect("../20_databoxsh/RBasicReqBoxList.jsp");	
%>
<html>
<script language="JavaScript">
	function init(){
		if(confirm("�ű� �䱸�� ������ ��ϵǾ����ϴ�.\n\n ����ؼ� �䱸������ ����Ͻðڽ��ϱ�?")){
		  formName.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqInfoWrite.jsp";
		}
		formName.submit();
	}
	
</script>

<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxVList.jsp"  ><!--�䱸�� �ű����� ���� -->
	             <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
				    <input type="hidden" name="AuditYear" value="<%=StringUtil.getSysDate().substring(0,4)%>">
				    <input type="hidden" name="CmtOrganID" value="<%=strCmtOrganID%>"><!--����ȸ ��� ID -->
					<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>"><!--�������� -->
					<input type="hidden" name="SubmtOrganID" value="<%=objParams.getParamValue("SubmtOrganID")%>"><!--������ID -->
				</form>
</body>



</html>
