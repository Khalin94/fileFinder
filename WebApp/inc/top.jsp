<%@ page contentType="text/html;charset=EUC-KR" %>

<script language="JavaScript">
<!--
/**********************************************************
* SSO Agent가 떠있는지 확인
*   document.ISignLtw.IsRunning()
*   떠있을때 1, 죽었을때 0를 Return한다.
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
	/*TopMenu 의 팝업을 위한 링크*/
	function openPopLeftMenu(url)
	{ //팝업창 띄우기
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=auto,left=1,top=1,width=800,height=600,resizable=yes, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	/*TopMenu 의 새창을 위한 링크*/
	function openNewWinLeftMenu(url)
	{ //새창 띄우기
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
    <h1><a href="/main.jsp" onfocus="this.blur();"><img src="/images2/common/top_logo.gif" width="247" height="32" alt="국회 의정자료전자유통시스템" /></a></h1>
    <ul>
        <li  ><a href="/main.jsp" ><img src="/images2/common/top_link01.gif" width="10" height="10" alt="홈" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
        <li><img src="/images2/common/top_link_line.gif" width="1" height="10" /></li>
        <li><a href="/sitemap/SiteMap.jsp"><img src="/images2/common/top_link02.gif" width="38" height="10" alt="사이트맵" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a></li>
        <li><img src="/images2/common/top_link_line.gif" width="1" height="10" /></li>
        <li><a href="/help/OnlineManual.jsp"><img src="/images2/common/top_link03.gif" width="29" height="10" alt="도움말"onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" /></a></li>
    </ul>
</div>