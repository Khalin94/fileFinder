<%@ page contentType="text/html;charset=euc-kr" %>
<html>
<head>
    <script language="JavaScript">
    <!--
    /**********************************************************
    * SSO Agent가 떠있는지 확인
    *   document.ISignLtw.IsRunning()
    *   떠있을때 true, 죽었을때 false를 Return한다.
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
