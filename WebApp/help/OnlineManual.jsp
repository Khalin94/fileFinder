<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>
<%@ include file="/common/CheckSession.jsp" %>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<%
	
	boolean IS_REQUEST =  (new Boolean((String)session.getAttribute("IS_REQUESTER"))).booleanValue();
	//boolean IS_REQUEST =  true;
	

	
	if(IS_REQUEST == true){
%>
	<script language="javascript">
		window.open("/manual4req/main.html","manual4req","");
	</script>

<%
	}
	else{
%>
	<script language="javascript">
		window.open("/manual4sub/main.html","manual4sub","");
	</script>

<%
	}
	//out.println(session.getAttribute("IS_REQUESTER"));

%>
	<script language="">
		location.href="/help/SystemIntroduction.jsp";
	</script>


</body>
</html>
