<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.Hashtable"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>
<%

	Hashtable objBinderHash = null;	
	bindDelegate objBinding = new bindDelegate();
	
	String strReqId = null;
	int intAnsIdSize = 0;
	int intResult = -1;
	String[] strReqIdArray = new String[300];
	
	String strBindingSortField = null;
	String strBindingSortMtd = null;
	String strCurrentPageNum = null;
	int	intCurrentPageNum = 0;
	
		
	// sort �ʵ�
	strBindingSortField = request.getParameter("strBindingSortField");
	System.out.println("[ReqBoxLegiSysConnectDeleteProc.jsp] strBindingSortField = " + strBindingSortField);
	// sort ����
 	strBindingSortMtd= request.getParameter("strBindingSortMtd");
	System.out.println("[ReqBoxLegiSysConnectDeleteProc.jsp] strBindingSortMtd = " + strBindingSortMtd);
	// ���� ������ ��ȣ �ޱ�.
	strCurrentPageNum = request.getParameter("strBindingPageNum");
	if(strCurrentPageNum == null || strCurrentPageNum.equals("")){
		strCurrentPageNum = "1";
	}
	Integer objIntD = new Integer(strCurrentPageNum);
	intCurrentPageNum = objIntD.intValue();
	System.out.println("[ReqBoxLegiSysConnectDeleteProc.jsp] intCurrentPageNum = " + intCurrentPageNum);
		

	
	strReqIdArray = request.getParameterValues("LegiConn");
	
	if (strReqIdArray != null)
	{
		int intlength = strReqIdArray.length ;
		String strDeleteFileIndex = null;		
		String strBinderList = null;
		
		for(int i=0; i<intlength ; i++) {
			strDeleteFileIndex = strReqIdArray[i];
			System.out.println(" [ReqBoxLegiSysConnectDeleteProc.jsp] id  =" + strDeleteFileIndex );
				
			intResult = objBinding.GovConnectBindingDelete(strDeleteFileIndex);
			
			if(intResult < 0){
				objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  	objMsgBean.setStrCode(""); // ���ε� ���Ͽ뷮 �ʰ��� �����ڵ�
			  	objMsgBean.setStrMsg("���������ý��� ���ε� ��� ���� ���� ");		  	
			  	%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
			  	<%
			  	return;	  	
			}
			
		}
	}	
%>
<html>
<head>
<script language="JavaScript">
	function init(){
		alert("���������ý��� ���� �ǿ��䱸�亯 ���ε� �ڷḦ �����Ͽ����ϴ� ");
		formName.submit();
	}
</script>
<head>
<body onLoad="init()">
				<form name="formName" method="post" action="./ReqBoxLegiSysConnectList.jsp" ><!--�䱸�� �ű����� ���� -->
					<input type="hidden" name="strBindingPageNum" value="<%=strCurrentPageNum%>">
					<input type="hidden" name="strBindingSortField" value="<%=strBindingSortField%>">
					<input type="hidden" name="strBindingSortMtd" value="<%=strBindingSortMtd%>">
				</form>
</body>
</html>

