<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.excel.ExcelDownload" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
     //��Delegate �����
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();
     
     //�䱸�⵵
	 ArrayList objYear = new ArrayList();
     objYear = objStatics.getYearSch();
     
     //��������
	 ArrayList objRltd = new ArrayList();
     objRltd = objStatics.getRltdSch();
     
     //����ȸ��
	 ArrayList objComm = new ArrayList();
     objComm = objStatics.getCommSch();
     
   	 String AUDIT_YEAR = request.getParameter("year_cd"); 
     String RLTD_GBN =request.getParameter("Rltd_cd"); 
     String COMM_GBN =request.getParameter("Comm_cd"); 
          
     //�Ķ���ͷ� ����� ���� ������ �⺻ �� ����.
     if(StringUtil.getNVLNULL(AUDIT_YEAR).equals("")){
  	 	AUDIT_YEAR = "";		//�⵵
  	 }//end if
  	 
 	 if(StringUtil.getNVLNULL(RLTD_GBN).equals("")){
  	 	RLTD_GBN = "";		//��������
  	 }//end if
  	 
     if(StringUtil.getNVLNULL(COMM_GBN).equals("")){
  	 	COMM_GBN = "";		//����ȸ��
  	 }//end if
  	 
     ArrayList objCommList = new ArrayList();
     try {
		objCommList = objStatics.select_Organ_Sys(AUDIT_YEAR, RLTD_GBN, COMM_GBN);
		ExcelDownload myExcle = new ExcelDownload();		
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
function fUsrAction(mode, strYear, strRltd_cd, strComm_cd) {
  switch(mode) {   
    case "list" :
//         alert(strYear);
//         alert(strRltd_cd);         
//         alert(strComm_cd);                  
         if (!fCheckField()) return false;
      	 form1.submit();
         break;
                  
  }
}

function fUsrActionExcel(mode, strYear, strRltd_cd, strComm_cd) {
  switch(mode) {   
    case "excel" :
//         alert(strYear);
//         alert(strRltd_cd);         
//         alert(strComm_cd);                  
         if (!fCheckField()) return false;

		 location.href=window.open("SelectSystem_Organ_Excel.jsp?strYear="+strYear+"&strRltd_cd="+strRltd_cd+"&strComm_cd="+strComm_cd);
      	 form1.submit();
         break;
  }
}


function fCheckField() {
  with (form1) {
    if (year_cd.value == '000') {
      alert('��ȸ �⵵�� �����ϼ���!');
      year_cd.focus();
      return false;
    }
    if (Rltd_cd.value == '000') {
      alert('���������� �����ϼ���!');
      Rltd_cd.focus();
      return false;
    }  
    if (Comm_cd.value == '000') {
      alert('����ȸ�� �����ϼ���!');
      Comm_cd.focus();
      return false;
    }      
  }
  return true;
}


function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
            &gt; ��� ���� &gt; ���� �䱸 ���� ��� &gt; <strong>����� �䱸/���� ��Ȳ</strong></td>
        </tr> 
        <tr> 
          <td width="27" height="21" align="left" valign="top"><img src="../image/common/left_white.gif" width="27" height="1"></td>
          <td width="2949" height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" class="copy-exb"><img src="../image/common/icon_bigTit.gif" width="13" height="13" align="absmiddle"> 
            ����� �䱸/���� ��Ȳ</td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
          <td height="15" align="left"></td>
        </tr>                
        <tr height="10"> 
          <td height="10" align="left" valign="top"></td>
          <td height="10" align="left" valign="top"><table width="95%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
              <tr> 
                <td height="50" align="left" bgcolor="#F3F3F3"><table width="560" border="0" cellspacing="5" cellpadding="0">
                    <tr>                                                                                
		                <td valign="middle">&nbsp;<img src="../image/common/icon_sqaure_grary.gif" width="3" height="6">&nbsp;
		                	<span class="copy_b">
		                		�⵵ :
		                	</span>
					       <select name="year_cd">
					            <option value="000" >-����-</option>					       
								<%   //�⵵�� �������ش�.
								        if (objYear != null) {
											for(int i=0; i < objYear.size(); i++){
											Hashtable objAUDIT_YEAR = (Hashtable)objYear.get(i);
											String strYear = (String)objAUDIT_YEAR.get("AUDIT_YEAR");
								%>
					            <option <%=(AUDIT_YEAR.equals(strYear))? "selected":"" %> value="<%=strYear%>" ><%=strYear%></option>
								<%
								            }
								          }
								%>
					        </select>					        
		                	<span class="copy_b">
		                		&nbsp;&nbsp; ���� :
		                	</span>				        
  					        <select name="Rltd_cd">
					            <option value="000" >-����-</option>					       
								<%   //�������и� �������ش�.
								        if (objRltd != null) {
											for(int i=0; i < objRltd.size(); i++){
											Hashtable objRLTD_GBN = (Hashtable)objRltd.get(i);
											String strMostrCd = (String)objRLTD_GBN.get("MSORT_CD");
											String strCdNm = (String)objRLTD_GBN.get("CD_NM");											
								%>
					            <option  <%=(RLTD_GBN.equals(strMostrCd))? "selected":"" %> value="<%=strMostrCd%>" ><%=strCdNm%></option>
								<% 
								            }
								          }
	   							%>					       							            
					        </select>					        
		                	<span class="copy_b">
		                		&nbsp;&nbsp; ����ȸ :
		                	</span>
					       <select name="Comm_cd">
					            <option value="000" >-����-</option>					       
								<%   //����ȸ�� �������ش�.
								        if (objComm != null) {
											for(int i=0; i < objComm.size(); i++){
											Hashtable objCOMM_GBN = (Hashtable)objComm.get(i);
											String strOrganId = (String)objCOMM_GBN.get("ORGAN_ID");
											String strOrganNm = (String)objCOMM_GBN.get("ORGAN_NM");											
								%>
					            <option  <%=(COMM_GBN.equals(strOrganId))? "selected":"" %> value="<%=strOrganId%>" ><%=strOrganNm%></option>
								<% 
								            }
								          }
	   							%>					       							            
					        </select>					        
						</td>									
						<td>
           				  <img src="../image/button/bt_refer.gif"  height="20"  style="cursor:hand" OnClick="JavaScript:fUsrAction('list',form1.year_cd.value, form1.Rltd_cd.value,form1.Comm_cd.value);">
						</td>					                                                                                                                                                         
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="25" align="left" valign="top">&nbsp;</td>
          <td height="25" align="left" valign="top"><table width="95%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="30" align="right" valign="bottom"> <div align="right"><span class="copy_s">(���� 
                    : ��)&nbsp;</span> </div></td>
              </tr>
            </table></td>
        </tr>        
        <tr height="10"> 
          <td height="10" align="left" valign="top"></td>
          <td align="left" valign="top"><table width="95%"  border="0" cellpadding="0" cellspacing="1" bgcolor="F4F4F4">          
			<tr align="center">
			    <td width="25%" height="25" class="td0_2" rowspan="2">�����</td>
			    <td width="15%" height="25" class="td0_2" rowspan="2">�� �䱸�Ǽ�</td>
			    <td width="75%" height="25" class="td0_2" colspan="4">�������</td>
			</tr>
			<tr align="center">
			    <td width="15%" height="25" class="td0_2" >���ڹ���</td>
			    <td width="15%" height="25" class="td0_2" >�����ڹ���</td>
			    <td width="15%" height="25" class="td0_2" >�ش����ƴ�</td>
			    <td width="15%" height="25" class="td0_2" >��</td>
			</tr>              
<%
		int j = 1;
		if( j != objCommList.size()) {
			for (int i = 0; i < objCommList.size(); i++) {
				Hashtable objHCommList = (Hashtable)objCommList.get(i);
				if( i < objCommList.size() - 1) {
%>
			<tr align="center">
				<td height="20" bgcolor="FFFFFF" class="td0_1">&nbsp;<%=objHCommList.get("ORGAN_NM")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("REQ_TOT")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("SYS_SEND_CNT")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("NON_SYS_SEND_CNT")%></td>
				<td height="20" bgcolor="ffffff">&nbsp;<%=objHCommList.get("NOT_REQ")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("SENT_TOT")%></td>
			</tr>		
			<%}else{%>
			<tr align="center">
				<td height="20" bgcolor="#DDDDDD" >&nbsp;<%=objHCommList.get("ORGAN_NM")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("REQ_TOT")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("SYS_SEND_CNT")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("NON_SYS_SEND_CNT")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("NOT_REQ")%></td>
				<td height="20" bgcolor="#EFEFEF">&nbsp;<%=objHCommList.get("SENT_TOT")%></td>
			</tr>	
			<%}%>          							
		<%}%>          										
	<%}else{%>
			<tr align="center">
            	<td height="20" colspan="3" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	�ش� ���ǿ� �䱸�� ������ �����ϴ�.</td>				
			</tr>			
<%}%>          			

              <tr height="2" class="tbl-line"> 
                <td height="2" colspan="12" class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><table width="95%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="444" height="40">&nbsp;</td>
                <td width="355" align="right">
  				<img src="../image/button/bt_excelDownload.gif" height="20"  style="cursor:hand" OnClick="javascript:fUsrActionExcel('excel',form1.year_cd.value, form1.Rltd_cd.value, form1.Comm_cd.value );">                      			                
              </tr>
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