<script language="JavaScript">
<!--
/**********************************************************
* SSO Agent�� ���ִ��� Ȯ��
*   document.ISignLtw.IsRunning()
*   �������� 1, �׾����� 0�� Return�Ѵ�.
**********************************************************/
function checkSession()
{
    var isSession = '<%=session.getAttribute("ORGAN_ID")%>';

    if(isSession == 'null' || isSession ==''){
           if(document.ISignLtw.IsRunFromReg() == "1")
            {

					if('<%=request.getHeader("Proxy-Client-IP")%>' == '<%=session.getAttribute("CHECKIP")%>'){
						window.location = "/login/Login4ReSession.jsp";
					}else{
						window.location = "/index.html";
					}


            }
            else
            {
                    window.location = "/index.html";

            }
    }


}
//-->

</script>

<script language="javascript" src="/js/ISignLtw.js"></script>

<script>checkSession(); </script>

<%
	if(session.getAttribute("ORGAN_KIND") == null)
	{
		return;
	}

	if(!((String)request.getHeader("Proxy-Client-IP")).equals((String)session.getAttribute("CHECKIP"))){

		session.invalidate();
		response.sendRedirect("/index.html");

		//window.location = "/index.html";
	}

%>



<!--%
	//���ǰ��� üũ�Ѵ�.
	if(session.getAttribute("ORGAN_KIND") == null)
		response.sendRedirect("/login/Login4ReSession.jsp");
%-->