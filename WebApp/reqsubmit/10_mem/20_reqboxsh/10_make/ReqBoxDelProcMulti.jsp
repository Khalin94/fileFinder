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
		objMsgBean.setStrMsg("파라미터(요구함 ID)가 전달되지 않았습니다");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	boolean blnEditOk = false; //삭제 여부.
	
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
				objMsgBean.setStrMsg("요청하신 요구함 정보를 삭제하지 못했습니다");
%>
				<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
				return;   	
			}
		}
	} catch(AppException objAppEx) { 
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException에러.
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

	alert("요구함 정보가 삭제되었습니다 ");
	parent.location.href='./RMakeReqBoxList.jsp?AuditYear=<%=StringUtil.getEmptyIfNull((String)request.getParameter("AuditYear"))%>&CmtOrganID=<%=(String)request.getParameter("CmtOrganID")%>';
	self.close();
</script>
				