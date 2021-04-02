<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RCommReqBoxDelProc.jsp
	* Summary	  : �䱸�� ����  ó�� ���.
	* Description : �䱸�� ������ �����ϰ� �䱸�� ��� ���� �̵��Ѵ�.
	* 				�ء� üũ �ء�
	*				 ���� ����ó���� ������ �������� �ѱ��� ����.
	*				 �䱸�� ������ �䱸��Ͽ� �����Ͱ� ������ ������ �ȵ�(üũ�ϱ�)
	*				 confirm ���� üũ�ϱ�
	******************************************************************************/
%>

<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	 /** �䱸�� ���� ���� */
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");

	if(arrReqBoxIDs.length < 1) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	  	objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
	  	out.println("ParamError:" + "�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
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

	String strDelURL = request.getParameter("DelURL");
	String strReqBoxNm = request.getParameter("ReqBoxNm");

	boolean blnEditOk = false; //���� ����.
	try {
		/********* �븮�� ���� ���� *********/
		CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate();

		/********* ������ ���� �ϱ�  **************/
		blnEditOk = ((Boolean)objReqBox.removeRecords(arrReqBoxIDs)).booleanValue();

		if(!blnEditOk) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSDATA-0012");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<html>
<script language="JavaScript">
		//2018-09-20 hgyoo ȭ�� �ε�â ����
		parent.notProcessing();
		
		alert("�䱸���� ���������� �����Ǿ����ϴ� ");
		
        parent.location.reload();
		self.close();
</script>
</html>

