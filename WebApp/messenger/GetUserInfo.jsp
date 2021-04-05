<%@ page language="java" contentType="text/html;charset=euc-kr" %><%
	
	String strUserId = null;
	
	try 
	{
		strUserId = (String)session.getAttribute("USER_ID");
		
		if (strUserId != null && !strUserId.trim().equals("")) 
		{	
			//--인증된 사용자일경우....(이 경우에만 사용자ID가 붙는다)
			out.print("1|" + strUserId);
		}
		else
		{
			//--인증되지 않은 사용자일 경우....
			out.print("0|");
		}
	}
	catch (Exception objExcept) 
	{
		//--시스템 예외가 발생한 경우....
		out.print("-1|");
	}
%>