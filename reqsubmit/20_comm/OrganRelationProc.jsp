<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;	
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>


<%		
	//session_user_id	
	String strUpdrID = objUserInfo.getUserID();	
	
	//command
	String strCmd = StringUtil.getNVLNULL(request.getParameter("strCmd")).trim();	
	//������ ������� ID(���õ� ���)
	String strRelOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();	
	//�������
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	//��ȸ �������� �ε���
	String strOrganIndex = StringUtil.getNVLNULL(request.getParameter("strOrganIndex")).trim();
	//���õ� ���	
	String[] arrOrganList 		= request.getParameterValues("ckOrgan");
	
	//��� Array
	String[] arrOrganID 		= request.getParameterValues("strOrganIDs");
	//������ļ��� Array
	String[] arrOrd 				= request.getParameterValues("strOrd");
	
	int intResult = 0;	
	
	/** ������ ���� delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();

	if(strCmd.equals("C")) {	
		try {
			intResult = objRelationMgr.setRelOrganList(strRelOrganID, strRelCd, arrOrganList, strUpdrID);	
		} catch (AppException objAppEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	
			
		<script language="javascript">
		<!--
			alert("<%=String.valueOf(intResult)%>���� ������谡 �����Ǿ����ϴ�.");
			opener.getList();
			this.close();		
		//-->
		</script>

<%	} else if(strCmd.equals("D")) { //������ ���
			try {
				System.out.println("arrOrganList : "+arrOrganList);
				System.out.println("strRelOrganID : "+strRelOrganID);
				System.out.println("strRelCd : "+strRelCd);
				System.out.println("strUpdrID : "+strUpdrID);
				intResult = objRelationMgr.delRelOrganList(arrOrganList, strRelOrganID, strRelCd, strUpdrID);	
			} catch (AppException objAppEx) {
			
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());
		
				// ���� �� �����߻��Ͽ� ���� �߻� �޼��� �������� �̵�
%>
				<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
				return;		
			}
%>
			<form name="frmList" method="post">
				<input type="hidden" name="strOrganID" value="<%=strRelOrganID%>">
				<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
			</form>

			
			<script language="javascript">
			<!--
				alert("<%=String.valueOf(intResult)%>���� ������谡 �����Ǿ����ϴ�.");								
				frmList.action = "SubmissionOrgan.jsp";
				frmList.submit();
			//-->
			</script>

<% } else if(strCmd.equals("A")) { //��ü ���� ������ ���

		try {
			intResult = objRelationMgr.setAllRelOrganList(strRelOrganID, strRelCd, strUpdrID);	
		} catch (AppException objAppEx) {
			
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	
			
		<script language="javascript">
		<!--
			alert("<%=String.valueOf(intResult)%>���� ������谡 �����Ǿ����ϴ�.");
			opener.getList();
			this.close();		
		//-->
		</script>

<% } else if(strCmd.equals("Z")) { //���ļ��������� ���

		try {
			intResult = objRelationMgr.setOrders(arrOrganID, arrOrd, strRelOrganID, strRelCd, strUpdrID);	
		} catch (AppException objAppEx) {
				
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
			
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
%>	

			<form name="frmList" method="post">
				<input type="hidden" name="strOrganID" value="<%=strRelOrganID%>">
				<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
			</form>

			
			<script language="javascript">
			<!--
				alert("���ļ����� ����Ǿ����ϴ�.");								
				frmList.action = "SubmissionOrgan.jsp";
				frmList.submit();
			//-->
			</script>
				

<% } %>