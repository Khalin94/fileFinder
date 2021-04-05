<%@ page contentType="text/html;charset=euc-kr" %>

<%
	String strFLAG = request.getParameter("SFLAG");
	String strtemp = "";
	if(strFLAG != null && strFLAG.equals("Y")){
		strtemp = "(신규)";
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
.TEXT {
	FONT-SIZE: 13px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: 돋움,verdana,seoul,Aria ;letter-spacing: -1px l 
}
.TEXT_S {
	FONT-SIZE: 12px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: 돋움,verdana,seoul,Arial ;letter-spacing: -1px 
}
.TITLE {
	FONT-SIZE: 17px; COLOR: #000000; FONT-FAMILY: 돋움,verdana,seoul,Arial ;letter-spacing: -1px 
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
<script Language="Javascript">
//오른쪽마우스 클릭금지
function clickIE() {
if (document.all) {
return false;
}
} 
function clickNS(e) {
if (document.layers||(document.getElementById&&!document.all)) { 
if (e.which==2||e.which==3) {
return false;
}
}
} 
if (document.layers) {
document.captureEvents(Event.MOUSEDOWN);
document.onmousedown=clickNS;
} 
else{
document.onmouseup=clickNS;
document.oncontextmenu=clickIE;
} 
document.oncontextmenu=new Function("return false") 
</script>
</head>

<%@ page import="kr.co.kcc.bf.bfutil.DateUtil"%>

<%
	String strDate = DateUtil.getSysDate();
%>

<body leftmargin="20" topmargin="0" marginwidth="0" marginheight="0">
<div id="Layer1" style="position:absolute;display:none; left:112px; top:461px; width:488px; height:47px; z-index:1">
  <table width="100%" height="47" border="1" cellpadding="0" cellspacing="0">
    <tr>
      <td width="16%" align="center" class="TEXT"><strong>재발급 ·<br>
        폐지 사유</strong></td>
      <td width="84%" align="center"><table width="95%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="59%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
              <span class="TEXT">인증정보 노출&nbsp;</span></td>
            <td width="41%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
              <span class="TEXT">소속기관 변경</span></td>
          </tr>
          <tr> 
            <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
              <span class="TEXT">저장매체파손 또는 비밀번호 분실</span></td>
            <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
              <span class="TEXT">기타(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
              )&nbsp;</span></td>
          </tr>
        </table></td>
    </tr>
  </table>
</div>
<br>

<script>
	
	document.all.Layer1.style.display = "none";
	
</script>

<table width="580" border="0" cellpadding="0" cellspacing="0">
<form name="form">
  <tr> 
    <td width="372" valign="bottom" class="TEXT_S">&#40;별지 서식 제1호&#41;</td>
    <td width="208" height="30" align="right" class="TEXT_S"><div align="right"></div>
      <table width="208" height="30" border="1" cellpadding="0" cellspacing="0">
        <tr bgcolor="FFFFFF"> 
          <td width="90" align="center" class="TEXT"><strong>접수번호</strong></td>
          <td width="118">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr height="8"> 
    <td height="8" colspan="2"></td>
  </tr>
  <tr> 
    <td colspan="2" align="left" valign="top"><table width="580" border="1" cellspacing="0" cellpadding="0">
        <tr align="center"> 

			<script>
				
					document.write("<td height='45' colspan='4' class='TITLE'><strong>");
					document.write("의정자료 전자유통 시스템 사용자 등록 신청서");
				
			</script>
			</strong></td>
        </tr>
        <tr> 
          <td width="96" height="45" align="center" class="TEXT"><strong>소속(기관명)</strong></td>
          <td height="45" colspan="3" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].ORGAN_NM.value)</script><%=strtemp%></td>
        </tr>
        <tr> 
          <td height="45" align="center" class="TEXT"><strong>부 서 명</strong></td>
          <td width="203" height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].DEPT_NM.value)</script></td>
          <td width="100" height="45" align="center" class="TEXT"><strong>사업자<br>등록번호</strong></td>
          <td width="171" height="45" class="TEXT">
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
        <tr> 
          <td height="45" align="center" class="TEXT"><strong>성 명</strong></td>
          <td width="203" height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script></td>
          <td width="100" height="45" align="center" class="TEXT"><strong>주민번호</strong></td>
          <td width="171" height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].JUMIN_NO1.value)</script> - ●●●●●●●</td>
        </tr>
        <tr> 
          <td height="45" align="center" class="TEXT"><strong>직 급</strong></td>
          <td width="203" height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].GRD_NM.value)</script></td>
          <td width="100" height="45" align="center" class="TEXT"><strong>대표자여부</strong></td>
          <td width="171" height="45" class="TEXT">
<script>
	var strRepFlag;
	if(opener.document.forms[0].REP_FLAG[0].checked == true)
		strRepFlag = "Y";
	else
		strRepFlag = "N";

	if(strRepFlag=="Y") {
		//document.form.REP_FLAG_Y.checked=true;
		document.write("&nbsp;국회 대표담당자");

	}
	if(strRepFlag=="N") {
		//document.form.REP_FLAG_N.checked=true;
		document.write("&nbsp;일반사용자");
	}
</script>
		  </td>
        </tr>
        <tr> 
          <td height="45" align="center" class="TEXT"><strong>전화번호</strong></td>
          <td height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].OFFICE_TEL.value)</script></td>
          <td height="45" align="center" class="TEXT"><strong>E-Mail</strong></td>
          <td height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].EMAIL.value)</script></td>
        </tr>
        <tr> 
          <td height="45" align="center" class="TEXT"><strong>이동통신번호</strong></td>
          <td height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].CPHONE.value)</script></td>
          <td height="45" align="center" class="TEXT"><strong>FAX 번호</strong></td>
          <td height="45" class="TEXT">&nbsp;<script>document.write(opener.document.forms[0].FAX_NO.value)</script></td>
        </tr>
        <tr> 
          <td align="center" valign="middle" class="TEXT"><strong>담당업무</strong></td>
          <td height="45" colspan="3" class="TEXT">&nbsp;<strong>주업무 :</strong><script>document.write(opener.document.forms[0].MchrWord.value)</script>
		  <br>&nbsp;<strong>부업무 :</strong><script>document.write(opener.document.forms[0].SchrWord.value)</script>
		  </td>
		</tr>
		
        <tr height="200">
          <td height="200" colspan="4" align="center" class="TEXT"><table width="93%" border="0" cellspacing="0" cellpadding="0">
              <tr height="15"> 
                <td height="15" class="TEXT"></td>
              </tr>
              <tr> 
                <td class="TEXT">
				<script>
					
					document.write("상기와 같이 국회 의정자료 전자유통 시스템 사용자 등록 서비스를 신청합니다. 본 신청서 관련 정보를 시스템에서 활용하는 것에 동의합니다.");
					
				</script>
				</td>
              </tr>
              <tr> 
                <td height="24" class="TEXT">&nbsp;</td>
              </tr>
              <tr> 
                <td align="right" class="TEXT"><strong>신청인 : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서명 
                  또는 (인)</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
              <tr height="15"> 
                <td height="15" class="TEXT"></td>
              </tr>
            </table></td>
        </tr>
        <tr height="200"> 
          <td height="200" colspan="4" align="center" valign="middle" class="TEXT"><table width="93%" border="0" cellspacing="0" cellpadding="0">
              <tr height="15"> 
                <td height="15" class="TEXT"></td>
              </tr>
              <tr> 
                <td class="TEXT">
				<script>
					
					document.write("위와 같이 국회 의정자료 전자유통 시스템 사용자 등록 신청을 확인합니다.");
					
				</script>
				</td>
              </tr>
              <tr> 
                <td height="24" class="TEXT">&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="right" class="TEXT"><strong><%=strDate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;일</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
              <tr> 
                <td height="30" align="right" class="TEXT"><strong>소속 기관장 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(직인)</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              </tr>
			  <!--
              <tr height="15"> 
                <td height="30" align="right" class="TITLE"><strong>귀하&nbsp;&nbsp;&nbsp;</strong></td>
              </tr>
			  -->
              <tr height="15"> 
                <td height="15" class="TEXT"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr height="8"> 
    <td height="8" colspan="2"></td>
  </tr>
  <tr> 
    <td colspan="2" class="TEXT"> &nbsp;&nbsp;*공문서 붙임으로 본 신청서를 제출할 경우, 소속 기관장 확인 (직인)은 생략 가능함.
	

	</td>
  </tr>
  </form>
</table>
<br>



</body>
</html>
<script language='javascript'>
window.print();
</script>