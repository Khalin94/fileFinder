<%@ page language="java" contentType="text/html;charset=euc-kr" %><%
	
	String strUserId = null;
	
	try 
	{
		strUserId = (String)session.getAttribute("USER_ID");
		
		if (strUserId != null && !strUserId.trim().equals("")) 
		{	
			//--������ ������ϰ��....(�� ��쿡�� �����ID�� �ٴ´�)
			out.print("1|" + strUserId);
		}
		else
		{
			//--�������� ���� ������� ���....
			out.print("0|");
		}
	}
	catch (Exception objExcept) 
	{
		//--�ý��� ���ܰ� �߻��� ���....
		out.print("-1|");
	}
%>