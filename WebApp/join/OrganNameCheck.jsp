<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.dsdm.app.join.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	
	String strOrganName = StringUtil.getNVLNULL(request.getParameter("strOrganName")).trim();
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();
	
	ArrayList objResult = null;	
	boolean blnDuplicateFlag = false;
		
	
	Hashtable objCondition = new Hashtable();

	objCondition.put("ORGAN_GBN", "001");
	objCondition.put("INOUT_GBN", "X");
	objCondition.put("ORGAN_KIND", "006");
	objCondition.put("STT_CD", "");
	objCondition.put("SRCH_TXT", strOrganName);

	try
	{	/** ���������ȸ */
		JoinMemberDelegate  objSLOrganDelegate = new JoinMemberDelegate();	
		objResult = objSLOrganDelegate.getOrganListDuplicateName(objCondition);	
	}
	catch (Exception objAppEx) {
		System.out.println(objAppEx.toString());
%>
		<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
		return;
	}	

	String strOrganID_Temp = null;

	if(objResult.size() > 0)
	{	
		//out.println("strUserID:" + strUserID);
		//out.println("id:" + StringUtil.getNVLNULL((String)objResult.get("USER_ID")));

		for(int i=0; i<objResult.size(); i++)
		{	
			strOrganID_Temp = String.valueOf(((Hashtable)(objResult.get(i))).get("ORGAN_ID"));

			//out.println("strOrganID : " + strOrganID + "<br>");
			//out.println("strOrganID_Temp : " + strOrganID_Temp + "<br>");

			if(!strOrganID.equals(strOrganID_Temp))
			{
				blnDuplicateFlag = true;
				break;
			}
			else
			{
				blnDuplicateFlag = false;
			}
		}
		
	}
	
%>

<html>
<title>����� �ߺ� üũ^^</title>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

	<script language="JavaScript" type="text/JavaScript">
	<!--
	
	function applyOrganName()
	{
		try
		{
			opener.NAPS.checkFlag.value = "true";
			opener.NAPS.checkORGAN_NM.value = "<%=strOrganName%>";
			self.close();
		}
		catch(err)
		{}
	}

	//-->
	</script>

	<link href="../css/global.css" rel="stylesheet" type="text/css">
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="EDEDED">


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	
	<tr bgcolor="EDEDED"> 
		<td height="30" align="center" valign="middle">
			<b>����� : <%=strOrganName%></b>
		</td>
	</tr>
	<tr> 
		<td height="1" class="tbl-line"></td>
	</tr>

<%
	if(blnDuplicateFlag)
	{
%>	
		
	<tr bgcolor="EDEDED"> 
		<td height="38" align="center" valign="middle">
			�̹� ������ ������� �����մϴ�.<br>
			�ٸ� ������� ����Ͻñ� �ٶ��ϴ�.
		</td>
	</tr>	
	<tr> 
		<td height="1" class="tbl-line"></td>
	</tr>
	<tr bgcolor="EDEDED"> 
		<td height="30" align="center" valign="middle">
			<a href="javascript:self.close();"><b>[Ȯ��]</b></a>
		</td>
	</tr>

<%
	}
	else
	{
%>
		
	<tr bgcolor="EDEDED"> 
		<td height="38" align="center" valign="middle">
			��� ������ ������Դϴ�.<br>
			�����Ͻñ� �ٶ��ϴ�.
		</td>
	</tr>
	<tr> 
		<td height="1" class="tbl-line"></td>
	</tr>
	<tr bgcolor="EDEDED"> 
		<td height="30" align="center" valign="middle">
			<a href="javascript:applyOrganName();"><b>[����]</b></a>
		</td>
	</tr>

<%
	}	
%>

	
</table>

</body>

</html>
