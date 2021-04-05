<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	String[] arrReqBoxIDs = request.getParameterValues("ReqBoxID");
	if(arrReqBoxIDs == null || arrReqBoxIDs.length < 1) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	boolean blnEditOk = false; //���� ����.
	
	try{
		
		MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();   
		ResultSetSingleHelper Rsh = null;
		String strOrganId = objUserInfo.getOrganID();
		for(int i=0; i<arrReqBoxIDs.length; i++) {
			Rsh = new ResultSetSingleHelper(objReqBox.getRecord(arrReqBoxIDs[i]));
			if(((String)Rsh.getObject("REQ_ORGAN_ID")).equals(strOrganId)){
				blnEditOk = ((Boolean)objReqBox.removeRecord(arrReqBoxIDs[i])).booleanValue(); 
			}
			
			if(!blnEditOk){
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
				objMsgBean.setStrCode("DSDATA-0012");
				objMsgBean.setStrMsg("��û�Ͻ� �䱸�� ������ �������� ���߽��ϴ�");
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
				return;   	
			}
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

<script language="JavaScript">	
	//parent.notProcessing();
	var elem = parent.document.getElementById('loading_layer');
	
	elem.parentNode.removeChild(elem);

	alert("�䱸�� ������ �����Ǿ����ϴ� ");
	parent.location.href='./RMakeReqBoxList.jsp?AuditYear=<%=StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"))%>&CmtOrganID=<%=(String)request.getParameter("CmtOrganID")%>';
	self.close();
</script>
				