<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxWriteForm"%>
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqWriteProc.jsp
	* Summary	  : ��û�� ó�� �������.
	* Description : �䱸�� ������ �Է��ϰ� �󼼺��� ȭ������ �̵��Ѵ�.
	******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	
	/** �󼼺��� ����¡�� �Ķ���� ����.*/
	CmtSubmtReqBoxListForm objParams =new CmtSubmtReqBoxListForm();  
	boolean blnParamCheck=false;
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.
	/**����¡  �ĸ����� üũ */
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
	}
  
	/** �䱸�� ���� �Ķ���� ����.*/
	CmtSubmtReqBoxWriteForm objWriteParams =new CmtSubmtReqBoxWriteForm();  
	objWriteParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//�䱸����� ���ǿ��� �־���.
	objWriteParams.setParamValue("CmtSubmtReqrID",objUserInfo.getUserID());//�ۼ��� ID
	  
	blnParamCheck = false;
	/** �䱸������ ���� �ĸ����� üũ */
	blnParamCheck = objWriteParams.validateParams(request);
	if(blnParamCheck == false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objWriteParams.getStrErrors());
		//out.println("ParamError:" + objWriteParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					������ ó�� Part 														  */
	/*************************************************************************************************/

	boolean blnOk = false; //��� ����.
	try {
		/********* �븮�� ���� ���� *********/
		CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();   /** �䱸�� ���� �Է¿� */
		
		/********* ������ ��� �ϱ�  **************/
		String strReturn=objReqBox.setNewRecord(objWriteParams);
		   
		blnOk =StringUtil.isAssigned(strReturn);
		if(!blnOk){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0010");
			objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ ������� ���߽��ϴ�");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
			return;   	
		}
	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		if(objAppEx.getStrErrCode().equals("DSDATA-0002")) {
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg("�ߺ��� ��û���� �ֽ��ϴ�. ��û�� ����� Ȯ���ϼ���!!");
		} else {
	  		objMsgBean.setStrCode("SYS-00010");//AppException����.
	  		objMsgBean.setStrMsg(objAppEx.getMessage());
		}
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return; 
	}
%>

<html>
<script language="JavaScript">
	function init(){
		alert("��û�� ������ ��ϵǾ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="./RCommReqList.jsp" >
					<% objParams.setParamValue("CmtOrganID",objWriteParams.getParamValue("CmtOrganIDX")); //����ȸID�� �����ؼ� ������.%>
					<%=objParams.getHiddenFormTags()%>
				</form>
</body>
</html>
					
					
					

