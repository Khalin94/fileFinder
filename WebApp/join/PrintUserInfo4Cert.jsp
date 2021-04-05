<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
.TEXT {
	FONT-SIZE: 12px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: 바탕,verdana,seoul,Aria ;letter-spacing: -1px l 
}
.TEXT_S {
	FONT-SIZE: 9px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: "바탕", "verdana", "seoul", "Arial";letter-spacing: -1px 
}
.TITLE {
	FONT-SIZE: 15px; COLOR: #000000; FONT-FAMILY: 바탕,verdana,seoul,Arial ;letter-spacing: -1px 
}
.TITLE2 {
	FONT-SIZE: 14px; COLOR: #000000; FONT-FAMILY: 바탕,verdana,seoul,Arial ;letter-spacing: -1px 
}
</style>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

</head>


<%@ page import="kr.co.kcc.bf.bfutil.DateUtil"%>

<%
	String strDate = DateUtil.getSysDate();
%>


<body leftmargin="20" topmargin="0" marginwidth="0" marginheight="0">
<br><br>
<table width="600" height="35" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="middle" class="TITLE"><strong>국회의정자료전자유통시스템 공인인증서비스 
      신청서</strong></td>
  </tr>
</table>
<table width="600" border="1" cellpadding="1" cellspacing="0">
  <tr align="center" bgcolor="GRAY" class="TEXT"> 
    <td height="25" colspan="5" class="TITLE2"><strong>기관 정보</strong></td>
  </tr>
  <tr align="center" class="TEXT"> 
    <td width="53" rowspan="2">기관명</td>
    <td width="57" height="25">*국문</td>
    <td width="163" height="25"><script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td width="85" height="25">대표자</td>
    <td width="160" height="25">&nbsp;</td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">영문</td>
    <td height="25" class="TEXT">&nbsp;</td>
    <td height="25" align="center" class="TEXT">주민등록번호</td>
    <td height="25">&nbsp;</td>
  </tr>
  <tr align="center" class="TEXT"> 
    <td height="25" colspan="2">홈페이지 주소</td>
    <td height="25">&nbsp;</td>
    <td height="25">*등록번호</td>
    <td height="25" align="left" valign="bottom" class="TEXT">			
	<script>
				var v_organNo = opener.document.forms[0].ORGAN_NO.value;
				if(v_organNo.length >=10) {
					document.write("&nbsp;"+v_organNo.substring(0,3)+"-"+v_organNo.substring(3,5)+"-"+v_organNo.substring(5));
				} else {
					document.write("&nbsp;"+v_organNo);
				}
			</script>
	</td>
  </tr>
  <tr align="center" class="TEXT"> 
    <td height="25" colspan="2">*주소</td>
    <td height="25" colspan="3"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script></td>
  </tr>
</table>
<table width="600" border="1" cellpadding="1" cellspacing="0">
  <tr align="center" bgcolor="GRAY" class="TEXT"> 
    <td height="25" colspan="5" class="TITLE2"><strong>사용자 정보</strong></td>
  </tr>
  <tr class="TEXT"> 
    <td width="54" rowspan="2" align="center">성명</td>
    <td width="56" height="25" align="center">*국문</td>
    <td width="163" height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script></td>
    <td width="86" height="25" align="center">*소속</td>
    <td width="159" height="25">&nbsp;<script>document.write(opener.document.forms[0].DEPT_NM.value)</script></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">영문</td>
    <td height="25" align="center">&nbsp;</td>
    <td width="86" height="25" align="center" class="TEXT">*직급</td>
    <td height="25" CLASS="TEXT">&nbsp;<script>document.write(opener.document.forms[0].GRD_NM.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*주민등록번호</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].JUMIN_NO1.value)</script> -
		  ●●●●●●●</script></td>
    <td height="25" align="center">업무</td>
    <td height="25">&nbsp;<strong>주업무 :</strong><script>document.write(opener.document.forms[0].MchrWord.value)</script>
		  <br>&nbsp;<strong>부업무 :</strong><script>document.write(opener.document.forms[0].SchrWord.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*전화번호</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].OFFICE_TEL.value)</script></td>
    <td height="25" align="center">휴대폰</td>
    <td height="25">&nbsp;<script>document.write(opener.document.forms[0].CPHONE.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*E-Mail</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].EMAIL.value)</script></td>
    <td height="25" align="center">팩스번호</td>
    <td height="25">&nbsp;<script>document.write(opener.document.forms[0].FAX_NO.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">대표자 여부</td>
    <td height="25" colspan="3" align="center">

<script>
	var strRepFlag;
	var strRepFlagImg1;
	var strRepFlagImg2;

	if(opener.document.forms[0].REP_FLAG[0].checked == true){
		
		strRepFlagImg1 = "nemo_black.gif"
		strRepFlagImg2 = "nemo.gif"

	}
	else{
		
		strRepFlagImg1 = "nemo.gif"
		strRepFlagImg2 = "nemo_black.gif"
	}

</script>


	<table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="36%"><script> document.write("<img src='../image/join/"+strRepFlagImg1+"' width='13' height='13' align='absmiddle'>")</script>
            <span class="TEXT">국회대표담당자</span></td>
          <td width="64%"><script> document.write("<img src='../image/join/"+strRepFlagImg2+"' width='13' height='13' align='absmiddle'>")</script>
            <span class="TEXT">일반사용자</span></td>
        </tr>
      </table>
	  </td>
  </tr>
</table>
<table width="600" border="1" cellspacing="0" cellpadding="1">
  <tr align="center" bgcolor="GRAY"> 
    <td height="25" colspan="3" class="TITLE2"><strong>신청 정보</strong></td>
  </tr>
  <tr class="TEXT"> 
    <td width="101" rowspan="3" align="center">신청내용</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">신규발급</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">갱신발급</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">재발급</span></td>
          <td width="23%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">폐지</span></td>
        </tr>
        <tr> 
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">효력정지</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">효력회복</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">정보변경</span></td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="191" height="25" align="center" class="TEXT">폐지/효력정지/<br>
      효력회복/정보변경 사유</td>
    <td width="294" height="25">&nbsp;</td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">유효기간 시작일</td>
    <td height="25" align="center"><table width="93%" height="20" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="23%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">발급일</span></td>
          <td width="77%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">지정일 (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일)</span></td>
        </tr>
      </table></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" align="center">인증서 용도</td>
    <td height="25" colspan="2" align="left" valign="top">&nbsp;&nbsp; 국 회 의 정 자 료 전 자 유 통 시 스 템 특 수 목 적 용</td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" align="center">인증서 등급</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">Class 1</span></td>
          <td width="25%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">Class 2</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">Class 3</span></td>
          <td width="23%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">Class 4</span></td>
        </tr>
      </table></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" align="center">인증서 기간</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">1년</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">2년</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">기타 (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;개월 
            ) </span></td>
        </tr>
      </table></td>
  </tr>
  <tr class="TEXT"> 
    <td rowspan="3" align="center">요금지불 방법</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="21%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">자동이체</span></td>
          <td width="17%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">현금</span></td>
          <td width="17%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">카드</span></td>
          <td width="45%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">기타 (&nbsp;무상 )</span></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">은행명/신용카드명</td>
    <td height="25"><img src="../image/join/line.gif" width="294" height="21"></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">게좌번호/카드번호</td>
    <td height="25"><img src="../image/join/line.gif" width="294" height="21"></td>
  </tr>
</table>
<table width="600" border="1" cellspacing="0" cellpadding="1">
  <tr align="center" valign="top"> 
    <td height="25" colspan="3"><table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr height="15"> 
          <td height="7" class="TEXT"></td>
        </tr>
        <tr> 
          <td class="TEXT">&nbsp;&nbsp;&nbsp;위와 같이 인증서를 신청하며 인증서의 신청 및 이용에 있어 
            한국전산원 정보인증 센터의 인증업무준칙을 숙지하였으며 가입자의 의무와 책임 및 인증서의 이용등에 관한 사항을 준수할 것을 
            약속합니다. </td>
        </tr>
        <tr> 
          <td align="right" class="TEXT"><%=strDate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT">성명(대표자)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 
            또는직인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr height="15"> 
          <td height="15" class="TEXT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;한국전산원장 
            귀하</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="410" rowspan="4" align="center"><table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="TEXT">※ 첨부서류 : 신원확인 증빙서류<br>
            - 사용자의 신분증명서의 사본(원본지참) 및 재직증명서 각 1부<br>
            - 법인 인감증명서, 사업자등록증 사본 또는 법인등기부등본 각 1부<br>
            - 대리인의 신분증명서의 사본(원본지참) 및 위임장 각 1부<br>
</td>
        </tr>
      </table></td>
    <td width="68" height="28" align="center" class="TEXT">접수일</td>
    <td width="88" height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">접수번호</td>
    <td height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">등록기관</td>
    <td height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">담당자</td>
    <td height="28" align="right" class="TEXT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
      (인) &nbsp;</td>
  </tr>
  <tr align="center" valign="top"> 
    <td height="25" colspan="3"><table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr height="15"> 
          <td height="7" class="TEXT"></td>
        </tr>
        <tr> 
          <td align="center" class="TITLE2"><strong>정보의 수집 · 제공 · 활용 동의서</strong></td>
        </tr>
        <tr> 
          <td class="TEXT">&nbsp;&nbsp;&nbsp;위의 신청내용과 관련하여 당사는 한국전산원 정보인증센터가 당사의 
            법인정보를 수집하고, 당사로부터 취득한 법인정보를 당사의 인증서를 이용하는 신뢰당사자에게 제공 · 활용하는데 동의합니다.</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT"><%=strDate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT">성명(대표자)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(서명 
            또는직인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr height="10"> 
          <td height="10"></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="600" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="22" align="left" valign="bottom" class="TEXT">*는 필수입력 항목임.</td>
  </tr>
</table>
<br>
<br>
<br>
<br>
<br>


<!-- 공인인증서비스 신청서 위임장 -->
<table width="590" height="35" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top" class="TITLE"><strong>공인인증서비스 신청서 위임장</strong></td>
  </tr>
</table>
<table width="600" height="160" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" rowspan="4" align="center" valign="middle" bgcolor="#CCCCCC"><strong>위임을<br>
      받는자 </strong></td>
    <td width="88" align="center"><strong>성명</strong></td>
    <td width="124">&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script></td>
    <td width="110" align="center"><strong>주민등록번호</strong></td>
    <td width="153"><font size="2">&nbsp;<script>document.write(opener.document.forms[0].JUMIN_NO1.value)</script> -
		  ●●●●●●●</script></font></td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>직장명</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td align="center"><strong>직위</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].GRD_NM.value)</script></td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>전화번호</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].OFFICE_TEL.value)</script></td>
    <td align="center"><strong>위임인과의 관계</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>주소</strong></td>
    <td colspan="3" align="left"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(우)&nbsp;<script>document.write(opener.document.forms[0].POST_CD1.value)</script>- 
     <script>document.write(opener.document.forms[0].POST_CD2.value)</script></td>
  </tr>
</table>
<table width="600" height="160" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" rowspan="4" align="center" valign="middle" bgcolor="#CCCCCC"><strong>위임을<br>
      하는자<br>
      (대표자)&nbsp; <br>
      </strong></td>
    <td width="88" align="center"><strong>성명</strong></td>
    <td width="124">&nbsp;</td>
    <td width="110" align="center"><strong>주민등록번호</strong></td>
    <td width="153">&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>직장명</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td align="center"><strong>직위</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>전화번호</strong></td>
    <td>&nbsp;</td>
    <td align="center"><strong>위임사유</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>주소</strong></td>
    <td colspan="3" align="left"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(우)&nbsp;<script>document.write(opener.document.forms[0].POST_CD1.value)</script>- 
     <script>document.write(opener.document.forms[0].POST_CD2.value)</script></td>
  </tr>
</table>
<table width="600" height="95" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" align="center" valign="middle" bgcolor="#CCCCCC"><strong>위임사항<br>
      </strong></td>
    <td width="497" align="center"><table width="97%" height="57" border="0" cellpadding="0" cellspacing="0" class="TITLE2">
        <tr> 
          <td width="27%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">신규발급</span></strong></td>
          <td width="25%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">갱신발급</span></strong></td>
          <td width="25%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">재발급</span></strong></td>
          <td width="23%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">폐지</span></strong></td>
        </tr>
        <tr> 
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">효력정지</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">효력회복</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">정보변경</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">환불신청</span></strong></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="600" border="1" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right"><table width="71%" border="0" cellspacing="0" cellpadding="0">
        <tr height="15"> 
          <td height="25" class="TEXT"></td>
        </tr>
        <tr> 
          <td height="30" class="TITLE2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;위와 
            같이 위임합니다.</td>
        </tr>
        <tr> 
          <td height="20" align="right" class="TITLE2">&nbsp;</td>
        </tr>
        <tr> 
          <td height="40" align="right" class="TITLE2"><%=strDate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td height="30" align="right" class="TITLE2">위임인(&nbsp;대표자&nbsp;) 
            : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;인&nbsp;)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr height="15"> 
          <td height="25" class="TEXT">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>



</body>
<script language='javascript'>
window.print();
</script>
</html>