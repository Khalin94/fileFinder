<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.ss.app.statistics.MainStaticsDelegate"%>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%--@ include file="../common/include/AuthCheck.jsp" --%>

<%
     //※Delegate 선언※
     MainStaticsDelegate objStatics = new  MainStaticsDelegate();
            
     //위원회명
	 ArrayList objComm = new ArrayList();
     objComm = objStatics.getCommSch();
     
   	 String AUDIT_YEAR = request.getParameter("year_cd");
     String COMM_GBN =request.getParameter("Comm_cd");
     
     if(StringUtil.getNVLNULL(COMM_GBN).equals("")){
  	 	COMM_GBN = "000";		//위원회명
  	 }//end if
     
     if(StringUtil.getNVLNULL(AUDIT_YEAR).equals("")){
  	 	AUDIT_YEAR = "2004";		//년도
  	 }//end if
  	 
  	 
     ArrayList objCommInMemList = new ArrayList();
     try {
		objCommInMemList = objStatics.select_Year_CommInMem(AUDIT_YEAR, COMM_GBN);
		} catch (AppException objAppEx) {
		
		// 에러 발생 메세지 페이지로 이동한다.
		out.println(objAppEx.getStrErrCode());
		out.println("메세지 페이지로 이동하여야 한다.");
		return;
	} 
%>

<html>
<title>의정자료 전자유통 지원시스템</title>
<link href="../css/global.css"  rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head>
<script language="javascript">
function fUsrAction(mode, strYear,  strComm_cd) {
  switch(mode) {   
    case "list" :
//         alert(strYear);
//         alert(strComm_cd);               
         if (!fCheckField()) return false;
      	 form1.submit();
         break;                  
  }
}

function fCheckField() {
  with (form1) {
    if (year_cd.value.length < 4 ) {
      alert('년도를 입력하세요!');
      year_cd.focus();
      return false;
    }            
  }
  return true;
}


function fUsrActionDel(mode, strComm_cd, strMen_cd, strYear, strCombo) {
  switch(mode) {   
    case "Del" :
//         alert(strComm_cd);               
//         alert(strMen_cd);                            
//         alert(strYear);         
//         alert(strCombo);                  
	     if (!confirm("해당 의원실을 삭제하시겠습니까?")) {
             return ;
         };         
       	 form1.action = "DeleteYear_Comm_In_Men.jsp?cmd="+mode+"&strComm_cd="+strComm_cd+"&strMen_cd="+strMen_cd+"&strYear="+strYear+"&strCombo="+strCombo;  
      	 form1.submit();
         break;                  
  }
}

function fUsrActionInsert(mode,  strYear) {
  switch(mode) {   
    case "Insert" :
//         alert(strComm_cd);               
//         alert(strMen_cd);                            
//         alert(strYear);         
	     if (!confirm(strYear + " 년도의 정보를 모두 삭제 후 새로 생성합니다.")) {
             return ;
         };         
        
       	 form1.action = "InsertYear_Comm_In_Men_All.jsp?cmd="+mode+"&strYear="+strYear;  
      	 form1.submit();
         break;
  }
}



function change_stat()
{
	if(document.form1.allbox.checked == true) {
		document.form1.allbox.checked=true;
		checkall('form1','CHECKID',true);
	}
	else {
		document.form1.allbox.checked=false;
		checkall('form1','CHECKID',false);
	}
}

function checkall(formname,checkname,thestate){
	var el_collection=eval("document.forms."+formname+"."+checkname)

	if(el_collection != null)
	{
		if(el_collection.length){
			for (c=0;c<el_collection.length;c++)
				el_collection[c].checked=thestate
		}else{
			el_collection.checked=thestate;
		}
	}
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
          <td height="25" colspan="2" align="left" valign="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;홈 
            &gt; 통계 관리 &gt; 서류 요구 제출 통계 &gt; <strong>위원회별 의원실 관리</strong></td>
        </tr> 
        <tr> 
          <td width="27" height="21" align="left" valign="top"><img src="../image/common/left_white.gif" width="27" height="1"></td>
          <td width="2949" height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top" class="copy-exb"><img src="../image/common/icon_bigTit.gif" width="13" height="13" align="absmiddle"> 
            년도별 위원회소속 의원실 관리</td>
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
                    <tr>
		                <td valign="middle">&nbsp;<img src="../image/common/icon_sqaure_grary.gif" width="3" height="6">
		                	<span class="copy_b">
		                		 위원회 :
		                	</span>
		                	<select name="Comm_cd">
					            <option value="000" >전체</option>					       					       
								<%   //위원회를 세팅해준다.
   								           								        
								        if (objComm != null) {
											for(int i=0; i < objComm.size(); i++){
											Hashtable objCOMM_GBN = (Hashtable)objComm.get(i);
											String strOrganId = (String)objCOMM_GBN.get("ORGAN_ID");
											String strOrganNm = (String)objCOMM_GBN.get("ORGAN_NM");											
								%>
					            <option <%=(COMM_GBN.equals(strOrganId))? "selected":"" %> value="<%=strOrganId%>" ><%=strOrganNm%></option>
								<% 
								            }
								          }
	   							%>
					        </select>					        
						</td>					
						<td>
							<img src="../image/common/icon_sqaure_grary.gif" width="3" height="6">&nbsp;
							<span class="copy_b">조회년도 :</span> 
							<input type="text" name="year_cd" maxlength=4 size=4 value='<%=AUDIT_YEAR%>'> &nbsp; 
						</td>											
						<td>
           				  <img src="../image/button/bt_refer.gif"  height="20"  style="cursor:hand" OnClick="JavaScript:fUsrAction('list',form1.year_cd.value, form1.Comm_cd.value);">		        						   
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
                <td height="30" align="right" valign="bottom">
                	<div align="right">
                		<a href="JavaScript:fUsrActionInsert('Insert','<%=AUDIT_YEAR%>' );">위원회별 의원실 일괄등록</a>
                	</div>
                </td>
              </tr>
            </table></td>
        </tr>        
        <tr height="10">
          <td height="10" align="left" valign="top"></td>
          <td align="left" valign="top"><table width="95%"  border="0" cellpadding="0" cellspacing="1" bgcolor="F4F4F4">          
			<tr align="center">
                <td width="3%" height="25" align="center"  class="td0_2">NO</td>			
			    <td width="10%" height="25" class="td0_2">위원회 코드</td>
			    <td width="27%" height="25" class="td0_2">위원회명</td>
			    <td width="10%" height="25" class="td0_2">의원실코드</td>			    			    
			    <td width="27%" height="25" class="td0_2">의원실명</td>
			    <td width="8%" height="25" class="td0_2">등록일자</td>			    			    
			    <td width="7%" height="25" class="td0_2">등록자</td>			    
			    <td width="6%" height="25" class="td0_2">삭제</td>			    
			</tr>              			

<%
	int j = 0;
	int N=1;
	if( j != objCommInMemList.size()) {
		for (int i = 0; i < objCommInMemList.size(); i++) {
				Hashtable objHCommInMemList = (Hashtable)objCommInMemList.get(i);
				String strRegTs = (String)objHCommInMemList.get("REG_TS");			
		        strRegTs = strRegTs.substring(0, 4) + "-" + strRegTs.substring(4, 6) + "-" + strRegTs.substring(6, 8);
%>
			<tr align="center">
                <td height="20" align="center" bgcolor="FFFFFF"><%=N%></td>			
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("REL_ORGAN_ID")%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("COMM_NM")%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("ORGAN_ID")%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("MEM_NM")%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=strRegTs%></td>
				<td height="20" bgcolor="FFFFFF">&nbsp;<%=objHCommInMemList.get("REGR_ID")%></td>				
                <td height="20" bgcolor="FFFFFF">
	  				<img src="../image/button/bt_delete_icon.gif" width="37"  height="17" border=0 style="cursor:hand" OnClick="javascript:fUsrActionDel('Del','<%=objHCommInMemList.get("REL_ORGAN_ID")%>', '<%=objHCommInMemList.get("ORGAN_ID")%>', '<%=AUDIT_YEAR%>', '<%=COMM_GBN%>' );">
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
            	해당 조건에 요구된 정보가 없습니다.</td>				
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
