<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	 * Name		  : RCommReqDelProc.jsp
	 * Summary	  : ��û�� ���� ó�� ���.
 	 * Description : ��û�� ������ �����ϰ� ��û�� ��� ���� �̵��Ѵ�.
	 * 				�ء� üũ �ء�
	 *				 ���� ����ó���� ������ �������� �ѱ��� ����.
	 ******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	/** �䱸�� ���� ���� */  
	String strReqBoxID = (String)request.getParameter("ReqBoxID");
	String[] arrReqInfoIDs = request.getParameterValues("ReqInfoIDs");
	
	if(!StringUtil.isAssigned(strReqBoxID)){
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("�Ķ����(��û�� ID)�� ���޵��� �ʾҽ��ϴ�");
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
	  }
%>

<%
	/*************************************************************************************************/
	/** 					������ ó�� Part 														  */
	/*************************************************************************************************/
	
	boolean blnOk=false; //���� ����.
	try {
		/********* �븮�� ���� ���� *********/
		CmtSubmtReqBoxDelegate objReqBox=new CmtSubmtReqBoxDelegate();  

		/********* ������ ���� �ϱ�  **************/
		if (arrReqInfoIDs == null || arrReqInfoIDs.length < 1) {
			blnOk =((Boolean)objReqBox.removeRecord(strReqBoxID)).booleanValue(); 
		} else {
			blnOk =((Boolean)objReqBox.removeRecord(strReqBoxID, arrReqInfoIDs)).booleanValue(); 
		}
		
		if(!blnOk) {
	 		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  			objMsgBean.setStrCode("DSDATA-0012");
  			objMsgBean.setStrMsg("��û�Ͻ� ��û�� ������ �������� ���߽��ϴ�");
	  		//out.println("<br>Error!!!" + "��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");   
%>
  			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
	  		return;   	
	   	}
 	} catch(AppException objAppEx) { 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException����.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
  		//out.println("<br>Error!!!" + objAppEx.getMessage());
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
		alert("�����û�� ������ �����Ǿ����ϴ� ");
		location.href="./RCommReqList.jsp";
</script>
</html>