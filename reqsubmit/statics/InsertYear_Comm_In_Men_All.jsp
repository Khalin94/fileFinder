<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����
	
	//���� �������� ������ ��.
	String stryearCd =StringUtil.getNVLNULL(request.getParameter("strYear"));					//�⵵
	String strCombo = "000";				//�����޺���
		
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("stryearCd : " + stryearCd + "<br>");
	
	//��Delegate �����.
	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	

	//�Է��� ����Ÿ�� HashTable ���� 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;


	if(strCmd.equals("Insert")){
//		out.println("�ϰ�����<br>");
		
		objHashData.put("AUDIT_YEAR", stryearCd);
		
		try {
			intResult = objStatics.All_Insert_CommInMen(objHashData);	
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		
		}
		
//		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
//			out.println("���� ����<br>");
		}
	}
	
%>

<form name=form1 method=post action=SelectYear_Comm_In_Mem.jsp>
<input type="hidden" name="year_cd" value="<%=stryearCd%>">
<input type="hidden" name="Comm_cd" value="<%=strCombo%>">
</form>
<script language="javascript">
  document.form1.submit();
</script>
