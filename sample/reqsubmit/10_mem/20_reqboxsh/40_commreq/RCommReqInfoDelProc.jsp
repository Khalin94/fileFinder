<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>
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

  /**�Ϲ� �䱸 �󼼺��� �Ķ���� ����.*/
  CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
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
  	return;
  }//endif
%>

<%
 /*************************************************************************************************/
 /** 					������ ó�� Part 														  */
 /*************************************************************************************************/

 boolean blnOk=false; //���� ����.
 try{
   /********* �븮�� ���� ���� *********/
   CmtSubmtReqInfoDelegate objReqInfo=new CmtSubmtReqInfoDelegate();   /** �䱸 ���� �� */

   /********* ������ ���� �ϱ�  **************/
   blnOk =((Boolean)objReqInfo.removeRecord(objParams.getParamValue("ReqInfoID"))).booleanValue(); 
   if(!blnOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� �䱸������ �������� ���߽��ϴ�");
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
		alert("�䱸 ������  �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RCommReqVList.jsp" ><!--�䱸�� �󼼺��� ���� ���� -->
				<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>