<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%

	String strForm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("Form"));
	String strFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("Flag"));
	String strPopUpId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("PopUpId"));

	if(strForm == null || strForm.equals(""))
	{
		return;
	}
	
	if(strFlag == null || strFlag.equals(""))
	{
		return;
	}

	if(strPopUpId == null || strPopUpId.equals(""))
	{
		return;
	}
	
%>

<html>

<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



<script language="javascript">
<!--

var strFlag = "<%=strFlag%>";

function on_load()
{
	
	try
	{
		document.title = opener.<%=strForm%>.strPopUpNm.value;
	}
	catch(err)
	{}		
	
	try
	{
		if(strFlag == "flag_1")
		{
			window.frames.frame_main.location = opener.<%=strForm%>.strUrl.value;
		}
		else
		{
			//window.frames.frame_main.document.write(opener.<%=strForm%>.strCont.value);
			window.frames.frame_main.location = "./ShowPopUpBody.jsp?Form=<%=strForm%>";
		}	
	}
	catch(err)
	{}

}


//-->
</script>



</head>



<FRAMESET id="frameset_main" rows="*,50" frameborder="0" framespacing="0" onLoad="javascript:on_load();">	
            
	<FRAME id="frame_main" src="" scrolling="auto">
	<FRAME id="frame_bottom" src="ShowPopUpBottom.jsp?PopUpId=<%=strPopUpId%>" noresize scrolling="n">
            
</FRAMESET>


</html>
