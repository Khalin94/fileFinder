<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>

<%@ include file="./SelectUserInfoProc.jsp" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="td_join"> 
    <td width="104" height="2"></td>
    <td height="2" colspan="2"></td>
  </tr>
  <tr> 
    <td rowspan="10" align="center" valign="middle" bgcolor="EAEAEA">
	<table width="90" height="100" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
        <tr> 
<%
	if(strPhotoPath.length()  < 1){
%>   

		<td align="center" bgcolor="ffffff">사진 없음</td>

<%
	}else{
%>
		<td align="center" bgcolor="ffffff">
             <img src="<%=strPhotoPath%>" width="90" height="100">
		</td>
<%
	}
%>		  


        </tr>
      </table>
	  </td>
    <td width="84" height="18" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      이름</td>
    <td width="160" class="td_lmagin"><%=strUserNm%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      e-mail</td>
    <td class="td_lmagin"><%=strEmail%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      성별</td>
    <td class="td_lmagin"><%=strGender%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      부서명</td>
    <td class="td_lmagin"><%=strOrganNm%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr>
  <!--
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      가입일자</td>
    <td class="td_lmagin"><%=strInitDate%></td>
  </tr>
  -->
  <!-- <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      부서명</td>
    <td class="td_lmagin"><%=strDeptNm%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr> -->
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      사무실 전화</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strOfficeTel1%>-<%=strOfficeTel2%>-<%=strOfficeTel3%></td>
  </tr>
  <tr height="1"> 
    <td height="1" class="tbl-line"></td>
    <td height="1" class="tbl-line"></td>
  </tr>
  <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      사무실 FAX</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strFaxNo1%>-<%=strFaxNo2%>-<%=strFaxNo3%></td>
  </tr>
  <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      이동통신</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strCphone1%>-<%=strCphone2%>-<%=strCphone3%></td>
  </tr>
  <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      우편번호</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strPostCd1%>-<%=strPostCd2%></td>
  </tr>
  <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      주소</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strJuso1%> </td>
  </tr>
  <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>

  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      상세주소</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strJuso2%> </td>
  </tr>
  <!-- <tr class="tbl-line"> 
    <td height="1"></td>
    <td height="1" colspan="2"></td>
  </tr>
  <tr> 
    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
      담당업무</td>
    <td height="25" colspan="2" class="td_lmagin"><%=strCgDuty%></td>
  </tr> -->
  <tr height="1" class="tbl-line"> 
    <td height="2"></td>
    <td height="2" colspan="2"></td>
  </tr>
</table>

