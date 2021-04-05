<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxEditForm"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommReqEditProc.jsp
* Summary	  : ��û�� ���� ó�� ���.
* Description : ��û�� ���� �ܿ� ��ȸ������ ����ٴϴ� �Ķ���� ���� ��Ƽ� ó����.
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

  /** �󼼺��� ����¡�� �Ķ���� ����.*/
  CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
  boolean blnParamCheck=false;
  /**����¡  �ĸ����� üũ */
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
  
  /** �䱸�� ���� �Ķ���� ����.*/
  CmtSubmtReqBoxEditForm objEditParams =new CmtSubmtReqBoxEditForm();  
  objEditParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
  blnParamCheck=false;
  /** �䱸������ ���� �ĸ����� üũ */
  blnParamCheck=objEditParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objEditParams.getStrErrors());
  	//out.println("ParamError:" + objEditParams.getStrErrors());
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
   CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();   

   /********* ������ ���� �ϱ�  **************/
   blnEditOk =((Boolean)objReqBox.setRecord(objEditParams)).booleanValue(); 
   if(!blnEditOk){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0011");
  	objMsgBean.setStrMsg("��û�Ͻ� ��û�� ������ �������� ���߽��ϴ�");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%  	
  	return;   	
   }
 }catch(AppException objAppEx){ 
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
	if(objAppEx.getStrErrCode().equals("DSDATA-0002")){
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg("�ߺ��� ��û���� �ֽ��ϴ�. ��û�� ����� Ȯ���ϼ���!!");
	}else{
	  	objMsgBean.setStrCode("SYS-00010");//AppException����.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	}
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
		alert("��û�� ������ �����Ǿ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RCommReqVList.jsp" >
					<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
