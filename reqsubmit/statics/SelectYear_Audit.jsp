<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
     //��Delegate �����
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();
            
      ArrayList objCommInMemList = new ArrayList();
     try {
		objCommInMemList = objStatics.select_Year_Audit();
		} catch (AppException objAppEx) {
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode());
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
		return;
	} 
%>

<html>
<title>�����ڷ� �������� �����ý���</title>
<link href="../css/global.css"  rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
<script language="javascript">
function fUsrActionInsert(mode) {
  switch(mode) {   
    case "Insert" :
       	 form1.action = "InsertYear_AuditForm.jsp";  
      	 form1.submit();
         break;                  
  }
}

function fUsrActionUpdate(mode,  strYear, strStart, strEnd) {
  switch(mode) {   
    case "Update" :
//         alert(strYear);               
//         alert(strStart);                            
//         alert(strEnd);         
       	 form1.action = "UpdateYear_AuditForm.jsp?cmd="+mode+"&strYear="+strYear+"&strStart="+strStart+"&strEnd="+strEnd;  
      	 form1.submit();
         break;                  
  }
}

function fUsrActionDelete(mode,  strYear) {
  switch(mode) {   
    case "Delete" :
//         alert(strYear);               
 	     if (!confirm(strYear + " �⵵�� �������� �Ⱓ ������ �����ϰڽ��ϱ�?")) {
	        return false;
	     };         
       	 form1.action = "DeleteYear_AuditProc.jsp?cmd="+mode+"&strYear="+strYear;  
      	 form1.submit();
         break;                  
  }
}


</script>
</head>


<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../image/common/manageUser_over_top.gif','../image/common/manageForum_over_top.gif','../image/common/manageBoard_over_top.gif','../image/common/manageSystem_over_top.gif','../image/common/manageStatistics_over_top.gif','../image/common/manageEtc_over_top.gif','../image/common/go_home_over.gif','../image/common/sitemap_over.gif')">
<form name="form1" method="post" >
<%@ include file="../common/include/TopAdmin.jsp" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr align="left" valign="top"> 
    <td width="170" background="../image/common/bg_left.gif"> 
      <%@ include file="../common/include/LeftLogin.jsp" %>
      <%@ include file="include/MenuLeftStatistics.jsp" %>
    </td>
    <td width="973"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr bgcolor="EDEDED"> 
          <td height="25" colspan="2" align="left" valign="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ȩ 
            &gt; ��� ���� &gt; ���� �䱸 ���� ��� &gt; <strong>�⵵�� �������� �Ⱓ ����</strong></td>
        </tr> 
        <tr> 
          <td width="27" height="21" align="left" valign="top"><img src="../image/common/left_white.gif" width="27" height="1"></td>
          <td width="2949" height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" class="copy-exb"><img src="../image/common/icon_bigTit.gif" width="13" height="13" align="absmiddle"> 
            �⵵�� �������� �Ⱓ ����</td>
        </tr>
        <tr>
          <td height="15" align="left" valign="top"></td>
          <td height="15" align="left"></td>
        </tr>
        <tr height="10"> 
          <td height="10" align="left" valign="top"></td>
          <td height="10" align="left" valign="top"><table width="95%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="50" align="left" bgcolor="#F3F3F3"><table width="460" border="0" cellspacing="5" cellpadding="0">
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="25" align="left" valign="top">&nbsp;</td>
          <td height="25" align="left" valign="top"><table width="95%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="30" align="right" valign="bottom">
                	<div align="right">
	  				    <img src="../image/button/bt_newRegister.gif" width="67"  height="20" border=0 style="cursor:hand" OnClick="javascript:fUsrActionInsert('Insert');">
                	</div>
                </td>
              </tr>
            </table></td>
        </tr>        
        <tr height="10">
          <td height="10" align="left" valign="top"></td>
          <td align="left" valign="top"><table width="95%"  border="0" cellpadding="0" cellspacing="1" bgcolor="F4F4F4">          
			<tr align="center">
                <td width="9%" height="25" align="center"  class="td0_2">NO</td>			
			    <td width="15%" height="25" class="td0_2">����⵵</td>
			    <td width="17%" height="25" class="td0_2">������</td>
			    <td width="17%" height="25" class="td0_2">������</td>			    			    
			    <td width="17%" height="25" class="td0_2">�������</td>			    			    
			    <td width="15%" height="25" class="td0_2">�����</td>			
			    <td width="5%" height="25" class="td0_2">����</td>			    			        
			    <td width="5%" height="25" class="td0_2">����</td>			    
			</tr>    		


<%
	int j = 0;
	int N=1;
	if( j != objCommInMemList.size()) {
		for (int i = 0; i < objCommInMemList.size(); i++) {
				Hashtable objHCommInMemList = (Hashtable)objCommInMemList.get(i);
				String strStrTs = (String)objHCommInMemList.get("START_DT");			
		        strStrTs = strStrTs.substring(0, 4) + "-" + strStrTs.substring(4, 6) + "-" + strStrTs.substring(6, 8);
				String strEndTs = (String)objHCommInMemList.get("END_DT");			
		        strEndTs = strEndTs.substring(0, 4) + "-" + strEndTs.substring(4, 6) + "-" + strEndTs.substring(6, 8);				
				String strRegTs = (String)objHCommInMemList.get("REG_TS");			
		        strRegTs = strRegTs.substring(0, 4) + "-" + strRegTs.substring(4, 6) + "-" + strRegTs.substring(6, 8);
%>
			<tr align="center">
                <td height="20" align="center" bgcolor="FFFFFF"><%=N%></td>			
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("AUDIT_YEAR")%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=strStrTs%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=strEndTs%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=strRegTs%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("REGR_ID")%></td>				
                <td height="20" bgcolor="FFFFFF">
	  				<img src="../image/button/bt_modify_icon.gif" width="37"  height="17" border=0 style="cursor:hand" OnClick="javascript:fUsrActionUpdate('Update','<%=objHCommInMemList.get("AUDIT_YEAR")%>', '<%=strStrTs%>', '<%=strEndTs%>' );">	  				
				</td>								
                <td height="20" bgcolor="FFFFFF">
	  				<img src="../image/button/bt_delete_icon.gif" width="37"  height="17" border=0 style="cursor:hand" OnClick="javascript:fUsrActionDelete('Delete','<%=objHCommInMemList.get("AUDIT_YEAR")%>');">	  					  				
				</td>				
			</tr>		
		<%  
			N = N+1;
		}%>          										
	<%}else{%>
			<tr align="center">
            	<td height="20" colspan="8" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	�ش� ���ǿ� �䱸�� ������ �����ϴ�.</td>				
			</tr>					
<%}%>										
			
          </table></td>
        </tr>
        <tr height="35"> 
          <td height="35" align="left" valign="top"></td>
          <td height="35" align="left" valign="top"></td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="../common/include/Bottom.jsp" %>
</form>
</body>
</html>
