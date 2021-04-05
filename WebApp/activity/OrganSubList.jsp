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
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();//�Ҽӱ���ڵ�
	String strUserID = StringUtil.getNVLNULL(request.getParameter("strUserID")).trim();

	ArrayList objResult = null;




	try
	{	/** ������� ��� �����ȸ */
		JoinMemberDelegate  objSLOrganDelegate = new JoinMemberDelegate();
		objResult = objSLOrganDelegate.getSubOrganList(strOrganName);
	}
	catch (Exception objAppEx) {
		System.out.println(objAppEx.toString());
%>
		<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
    <title>�����������-�����μ��˻�</title>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
    <script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
    <script type="text/javascript" src="/js2/common.js"></script>
    <link type="text/css" href="/css2/style.css" rel="stylesheet">
	<script language="JavaScript" type="text/JavaScript">
	<!--
	window.focus();
	function applyOrganName()
	{
		try
		{
			opener.frmOrgan.checkFlag.value = "true";
			opener.frmOrgan.checkORGAN_NM.value = "<%=strOrganName%>";
			self.close();
		}
		catch(err)
		{}
	}
	function searchOrgan(){

		if(frmOrgan.strOrganName.value == "" ) {
			alert("������� �Է��Ͻñ� �ٶ��ϴ�.");
			frmOrgan.strOrganName.focus();
			return;
		}
		frmOrgan.submit();
   }

	function selectOrg(varSubOrganID,varSubOrganNM){

		frmOrgan.strSubOrganID.value=varSubOrganID;
		frmOrgan.strSubOrganNM.value=varSubOrganNM;
		frmOrgan.action="OrganSubCreate.jsp";

		frmOrgan.submit();
   }
//-->
</script>
</head>
<body>
<form name="frmOrgan" method="post" action="OrganSubList.jsp">
<input type="hidden" name="strOrganID" value="<%=strOrganID%>"/>
<input type="hidden" name="strUserID" value="<%=strUserID%>"/>
<input type="hidden" name="strSubOrganID" value=""/>
<input type="hidden" name="strSubOrganNM" value=""/>
<div id="contents" style="width:500px;">
        <!-- �������� ���� -->
        <div class="myP" style="width:500px; margin-top:10px;">
        <span class="list01_tl">����� : <input name="strOrganName" type="text" class="input" style="WIDTH: 200px" value="<%=strOrganName%>" maxlength="100"> <a href="javascript:searchOrgan();"><img src="../images2/btn/btn_inquiry.gif" align="absmiddle" onMouseOver="this.src='../images2/btn/btn_inquiry_o.gif'"  onMouseOut="this.src='../images2/btn/btn_inquiry.gif'"></a></span>
        <table width="100%" border="0" cellspacing="0" cellpadding="0"  class="list01">
            <thead>
              <tr>
                <th width="205" scope="col">�������</th>
                <th width="295" scope="col">����Ҽӵȱ����</th>
              </tr>
            </thead>
<%
	String strSubOrganID = null;
	String strSubOrganNM = null;
	String strNowDEPT = null;

	if(objResult.size() > 0)
	{

		for(int i=0; i<objResult.size(); i++)
		{
			strSubOrganID = String.valueOf(((Hashtable)(objResult.get(i))).get("ORGAN_ID"));
			strSubOrganNM = String.valueOf(((Hashtable)(objResult.get(i))).get("ORGAN_NM"));
			strNowDEPT = String.valueOf(((Hashtable)(objResult.get(i))).get("NOW_DEPT"));

%>
	<tr>
		<td>
			<A href="javascript:selectOrg('<%=strSubOrganID%>','<%=strSubOrganNM%>')"><%=strSubOrganNM%></a>
		</td>
		<td>
			<%=strNowDEPT%>
		</td>
	</tr>


<%

		}

	}else{

%>
	<tr>
		<td colspan="2">
			�˻��� ����� �����ϴ�.
		</td>
	</tr>
<%
	}
%>
    </table>
        <div id="btn_all" >
            <span class="right"> <span class="list_bt"><a href="javascript:self.close()">�ݱ�</a></span> </span>
        </div>
        <!-- /contents -->

      </div>
    </div>
</body>
</html>
