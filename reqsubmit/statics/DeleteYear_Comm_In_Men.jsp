<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%
	String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����
	
	//���� �������� ������ ��.
	String strCommCd  = StringUtil.getNVLNULL(request.getParameter("strComm_cd"));		//����ȸ ID
	String strMenCd  = StringUtil.getNVLNULL(request.getParameter("strMen_cd"));		    //�ǿ��� ID
	String stryearCd =StringUtil.getNVLNULL(request.getParameter("strYear"));					//�⵵
	String strCombo =StringUtil.getNVLNULL(request.getParameter("strCombo"));				//�����޺���
		
//	out.print("strCmd : " + strCmd + "<br>");
//	out.print("strCommCd : " + strCommCd + "<br>");
//	out.print("strMenCd : " + strMenCd + "<br>");
//	out.print("stryearCd : " + stryearCd + "<br>");
	
	//��Delegate �����.
	
    MainStaticsDelegate objStatics = new  MainStaticsDelegate();	

	//�Է��� ����Ÿ�� HashTable ���� 
	Hashtable objHashData = new Hashtable();
	int intResult = 0;


	if(strCmd.equals("Del")){
//		out.println("����<br>");
		
		objHashData.put("REL_ORGAN_ID", strCommCd);
		objHashData.put("ORGAN_ID", strMenCd);
		objHashData.put("AUDIT_YEAR", stryearCd);
				
		try {
			intResult = objStatics.Delete_CommInMen(objHashData);	
		} catch (AppException objAppEx) {
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
			out.println(objAppEx.getStrErrCode() + "<br>");
			out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
			return;
		
		}
		
//		out.print("intResult : " + intResult);
		
		if(intResult != 0 ){
//			out.println("���� ����<br>");
//			response.sendRedirect("SelectYear_Comm_In_Mem.jsp?year_cd=" + stryearCd +"&Comm_cd="+strCommCd);
//			response.sendRedirect("SelectYear_Comm_In_Mem.jsp");
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
