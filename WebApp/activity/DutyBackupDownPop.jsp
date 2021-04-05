<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>업무정보 백업파일 다운로드</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%
	String strMessage = "";
	String strError = "yes";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();
	
		String strOrganId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("organ_id"));
		
		Vector objParamVt = new Vector();
		objParamVt.add(strUserId);
		objParamVt.add(strOrganId);

		Hashtable objBackUpHt = objBusInfoDelegate.selectBackup(objParamVt);
		
		String strOrganNm = (String)objBackUpHt.get("ORGAN_NM");
		String strFile = (String)objBackUpHt.get("REMARK");
		
		if ((strFile == null) || (strFile.equals(""))){
%>
<script language="javascript">
<!--
	alert("금일에 백업파일이 생성되지 않았습니다.(백업파일 생성버튼을 클릭하여 백업파일 생성 요망)");
	self.close();
//-->
</script>

<%
		}
%>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="380" border="0" cellspacing="0" cellpadding="0">
<form name="form_main" method="post" action="">
  <tr class="td_mypage"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td height="10"></td>
    <td height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td width="386" height="25" valign="middle"><span class="soti_reqsubmit"><img src="../image/mypage/icon_mypage_soti.gif" width="9" height="9" align="absmiddle"> 
      </span><span class="soti_mypage">업무정보 백업파일 다운로드</span></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><table width="96%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="AED889" height="3"> 
          <td height="2"  colspan="2" class="td_mypage"></td>
        </tr>
        <tr > 
          <td width="104" height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
            백업 파일명 : </td>
          <td width="248" height="25"  class="td_lmagin" ><div align="left"> 
              <a href="./businfo/FileDownloadBackupFile.jsp?real_file=<%=strFile%>&file_name=<%=strOrganNm%>"><%=strOrganNm%></a>
            </div></td>
        </tr>
        <tr > 
          <td height="1" colspan="2"  class="tbl-line"></td>
        </tr>
        <tr> 
          <td height="2" colspan="2" class="tbl-line"></td>
        </tr>
      </table></td>
  </tr>
  <tr align="right"> 
    <td height="25" colspan="2" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="../image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>
  </tr>
</form>
</table>
</body>
<%
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>
</html>
