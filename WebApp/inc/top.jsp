<%@ page contentType="text/html;charset=EUC-KR" %>

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

					window.location = "/login/Login4ReSession.jsp";

            }
            else
            {
                    window.location = "/index.html";

            }
    }
}
//-->

</script>

<script language="JavaScript">
	/*TopMenu �� �˾��� ���� ��ũ*/
	function openPopLeftMenu(url)
	{ //�˾�â ����
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=auto,left=1,top=1,width=800,height=600,resizable=yes, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	/*TopMenu �� ��â�� ���� ��ũ*/
	function openNewWinLeftMenu(url)
	{ //��â ����
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url);
		hWin.focus();
	}
</script>

<div id="top">
    <h1><a href="/main.jsp" onfocus="this.blur();"><img src="/images2/common/top_logo.gif" width="247" height="32" alt="��ȸ �����ڷ���������ý���" /></a></h1>
    <ul>
        <li  ><a href="/main.jsp" ><img src="/images2/common/top_link01.gif" width="10" height="10" alt="Ȩ" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
        <li><img src="/images2/common/top_link_line.gif" width="1" height="10" /></li>
        <li><a href="/sitemap/SiteMap.jsp"><img src="/images2/common/top_link02.gif" width="38" height="10" alt="����Ʈ��" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
        <li><img src="/images2/common/top_link_line.gif" width="1" height="10" /></li>
        <li><a href="/help/OnlineManual.jsp"><img src="/images2/common/top_link03.gif" width="29" height="10" alt="����"onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
    </ul>
</div>