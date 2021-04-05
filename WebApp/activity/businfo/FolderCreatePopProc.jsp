<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	Vector objDocbox = new Vector();
	try
	{	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strUserId = (String)session.getAttribute("USER_ID");  //�����ID
		String strOrganId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("organ_id"), ""));  //������ ���ID
		String strDocboxNm   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("docbox_nm"), ""));  //�����ϰ��� �ϴ� �з��� ��
		String strTopDocboxId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("top_docbox_id"), ""));  //�����з���ID

		if((strDocboxNm != null) && (strDocboxNm.trim().length() > 0)){ 
			strDocboxNm = strDocboxNm.trim();
			objDocbox.add(strUserId);
			objDocbox.add(strOrganId);
			objDocbox.add(strDocboxNm);
			objDocbox.add(strTopDocboxId);
			int intResult = objBusInfoDelegate.insertDocbox(objDocbox);
			//--out.println("Result : " + intResult);
			if (intResult > 0){
				strMessage = String.valueOf(intResult) + "�� ���� �Ǿ����ϴ�.";
			}else{
				strError = "yes";
				strMessage = "���� �̸��� ������ �����մϴ�.";
			}
		}else{
			strError = "yes";
			strMessage = "������ �������� �����ϴ�.";
		}
		//--response.sendRedirect("SendFax.jsp");
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
