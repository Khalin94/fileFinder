<%@ page contentType="text/html;charset=euc-kr" %>
<html>
<head>
    <script language="JavaScript">
    <!--
    /**********************************************************
    * SSO Agent�� ���ִ��� Ȯ��
    *   document.ISignLtw.IsRunning()
    *   �������� true, �׾����� false�� Return�Ѵ�.
    **********************************************************/
    function test()
    {
	var isSession = '<%=session.getAttribute("ORGAN_ID")%>';
	if(isSession == 'null'){
	       if(document.ISignLtw.IsRunning() && isSession == null)
        	{
           		//alert("ok:");
	   		document.location = "/login/Login4ReSession.jsp"; 
        	}
        	else
        	{
           		//alert("no:");
	   		document.location = "/index.html"; 
        	}
	}
    }
    //-->
    </script>
</head>
<body>
   <script language="javascript" src="/js/ISignLtw_2.js"></script>

</body>
</html>
