<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_id")); 
		String strNm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_nm")); 
		String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("gubun")); 
		
		if((strNm != null) && (strNm.trim().length() > 0)){
			strNm = strNm.trim() ;
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USER_ID", strUserId);
			objParamHt.put("ID", strId);
			objParamHt.put("NM", strNm);
			objParamHt.put("GUBUN", strGubn);
			int iResult = objBusInfoDelegate.updateName(objParamHt);
			if(iResult == -1){
				strMessage = "������ �ٸ� ����ڰ� ���������� �����Ͽ����ϴ�(Ȯ�ο��).";
			}else if(iResult == -3){
				strMessage = "���� ��ġ�� ������������ ������ �� �����ϴ�.(Ȯ�ο��).";
			}else{
				strMessage = strMessage + String.valueOf(iResult) + "�� ���� �Ǿ����ϴ�.";
			}	
			strError = "no";
		}else{
			strError = "yes";
			strMessage = "������ ����/���ϸ��� �����ϴ�.";
		}
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
