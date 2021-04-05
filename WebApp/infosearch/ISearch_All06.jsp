<!--
**      Program Name : ISearch_All06.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  : 국회 회의록 서비스 링크 페이지
**
**      1)국회회의록 시스템의 입력폼을 그대로 끌어오는 페이지임
**	  2)통합검색시 검색어가 없으면 그대로 폼을 보여주고 검색어가 있다면 해당 검색어를 달고다님
**	  3)회의록 시스템의 디자인을 그대로 차용하여 것이므로 차후 회의록 시스템의 디자인 변경및
**	     프로그램 변경이 생긴다면 이부분도 같이 변경시켜주어야 제대로 동작할것임
-->
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*"%>
<%@ page import="nads.dsdm.app.infosearch.common.IsSelectDelegate" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>



<%

	Hashtable objHtSelectSysdate;
	IsSelectDelegate objCMDsysdate = new IsSelectDelegate();

	try {

		objHtSelectSysdate = objCMDsysdate.selectSysdate();

	} catch (AppException objAppEx) {

		// 에러 발생 메세지 페이지로 이동한다.
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
		System.out.println(objAppEx.getStrErrCode());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	String query = StringUtil.getEmptyIfNull(request.getParameter("query"));
	if(query==null) query = "";

	String audit_year_to = StringUtil.getEmptyIfNull(request.getParameter("audit_year_to"));
	if(audit_year_to==null || audit_year_to.equals("")) audit_year_to = (String)objHtSelectSysdate.get("YYYYMMDD");

%>
<html>
<head>
<title> ▒▒▒▒▒ 국회 회의록 서비스 ▒▒▒▒▒ </title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript">
<!--
function change() {
        DAE1=parseInt(document.searchform.DAE1.value)
		DAE2=parseInt(document.searchform.DAE2.value)
	if(DAE1>DAE2)	{
			alert("대수 선택이 올바르지 않습니다.");
			document.searchform.DAE1.focus();
			return;
	}

		document.searchform2.CLASS_CODE.value = document.searchform.CLASS_CODE.value;
		document.searchform2.DAE1.value = document.searchform.DAE1.value;
		document.searchform2.DAE2.value = document.searchform.DAE2.value;
		document.searchform2.CONF_DATE1.value = document.searchform.CONF_DATE1.value;
		document.searchform2.CONF_DATE2.value = document.searchform.CONF_DATE2.value;
		document.searchform2.SES1.value = document.searchform.SES1.value;
		document.searchform2.SES2.value = document.searchform.SES2.value;
		document.searchform2.COMM_CODE.value = document.searchform.COMM_CODE.value;
		document.searchform2.SUB_NAME.value = document.searchform.SUB_NAME.value;
		document.searchform2.SP_NAME.value = document.searchform.SP_NAME.value;
		document.searchform2.CONTENT.value = document.searchform.CONTENT.value;
		document.searchform2.submit();
}

function winOpen(Url)
{
	window.open(Url, '', "height=680,width=500,status=no,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes");
}
function mainsearch() {
	if (document.searchform.SUB_NAME.value == "" && document.searchform.SP_NAME.value == "" && document.searchform.CONTENT.value == "") {
		alert("검색어를 입력하십시오");
		document.searchform.SUB_NAME.focus();
		return ;
	}
		document.searchform.submit();
}

function Check(){
		if (document.searchform.SUB_NAME.value == "" && document.searchform.SP_NAME.value == "" && document.searchform.CONTENT.value == "") {
			alert("검색어를 입력하십시오");
			document.searchform.SUB_NAME.focus();
			return false;
		}
		var string1=document.searchform.SUB_NAME.value
		var string2=document.searchform.SP_NAME.value
		var string3=document.searchform.CONTENT.value
		if ((string1.indexOf("<")!=-1) || (string1.indexOf(">")!=-1) || (string1.indexOf("(")!=-1) || (string1.indexOf(")")!=-1)  )		{
				alert("<,>,(,) 문자는 사용하실수 없습니다.")
			return false ;
		}

		if ((string2.indexOf("<")!=-1) || (string2.indexOf(">")!=-1) || (string2.indexOf("(")!=-1) || (string2.indexOf(")")!=-1)  )		{
				alert("<,>,(,) 문자는 사용하실수 없습니다.")
			return false ;
		}

		if ((string3.indexOf("<")!=-1) || (string3.indexOf(">")!=-1) || (string3.indexOf("(")!=-1) || (string3.indexOf(")")!=-1)  )		{
				alert("<,>,(,) 문자는 사용하실수 없습니다.")
			return false ;
		}

	}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<link rel="stylesheet" href="../css.css" type="text/css">
</head>

<%
	if (query.equals("")) {//%>
<body bgcolor="#FFFFFF" text="#000000" background="../img/acc_backimg.gif" class="norepeat" onLoad="MM_preloadImages('img/help_but_h.gif');document.searchform.SUB_NAME.focus();">
<%	}else{%>
<body bgcolor="#FFFFFF" text="#000000" background="../img/acc_backimg.gif" class="norepeat" onLoad="mainsearch();">
<%   }%>


<br>
<br>
<table border="0" cellspacing="0" cellpadding="0" align="center" width="650">
  <tr>
    <td width="552"><img src="http://likms.assembly.go.kr/record/index/img/tile_img.gif" hspace="4" vspace="4"></td>
  </tr>
  <tr>
    <td background="../img/main_boxback3.gif"> <br>
      <table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
  		<form name=searchform method=post action="http://likms.assembly.go.kr/record/index/../unity/uni_search1.jsp" onsubmit="return Check();">
		<input type="hidden" name="DIV" value='1'>
		<input type="hidden" name="host" value="localhost">
		<input type="hidden" name="docStart" value="1">
		<input type="hidden" name="docPage" value="10">
		<input type="hidden" name="port" VALUE="9902">
	          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/index_text2.gif" width="84" height="20"></td>
            <td><font size=3>
              <select name=CLASS_CODE class="text5" onChange="javascript:change();">
                <option value="0" > 전체</option>
                <option value="1" >본회의</option>
                <option value="2" >상임위원회</option>
                <option value="4" >예산결산특별위원회</option>
				<option value="3" >특별위원회</option>
                <option value="5" >국정감사</option>
                <option value="6" >국정조사</option>
              </select>
              </font></td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text2.gif" width="84" height="20"></td>
            <td>
              <select name="DAE1" class=text5 onChange="javascript:change();">
                <option value='16' >제16대(2000~2004)</option>
                <option value='15' selected>제15대(1996~2000)</option>
                <option value='14' >제14대(1992~1996)</option>
                <option value='13' >제13대(1988~1992)</option>
                <option value='12' >제12대(1985~1988)</option>
                <option value='11' >제11대(1981~1985)</option>
                <option value='10' >제10대(1979~1980)</option>
                <option value='9' >제9대(1973~1979)</option>
                <option value='8' >제8대(1971~1972)</option>
                <option value='7' >제7대(1967~1971)</option>
                <option value='6' >제6대(1963~1967)</option>
                <option value='5' >제5대(1960~1961)</option>
                <option value='4' >제4대(1958~1960)</option>
                <option value='3' >제3대(1954~1958)</option>
                <option value='2' >제2대(1950~1954)</option>
                <option value='1' >제헌(1948~1950)</option>
              </select><img src="http://likms.assembly.go.kr/record/index/img/text7.gif" width="20" height="20" align="absmiddle"><select name="DAE2" class=text5 onChange="javascript:change();">
                <option value='17' selected>제17대(2004~2008)</option>
                <option value='16' >제16대(2000~2004)</option>
                <option value='15' >제15대(1996~2000)</option>
                <option value='14' >제14대(1992~1996)</option>
                <option value='13' >제13대(1988~1992)</option>
                <option value='12' >제12대(1985~1988)</option>
                <option value='11' >제11대(1981~1985)</option>
                <option value='10' >제10대(1979~1980)</option>
                <option value='9' >제9대(1973~1979)</option>
                <option value='8' >제8대(1971~1972)</option>
                <option value='7' >제7대(1967~1971)</option>
                <option value='6' >제6대(1963~1967)</option>
                <option value='5' >제5대(1960~1961)</option>
                <option value='4' >제4대(1958~1960)</option>
                <option value='3' >제3대(1954~1958)</option>
                <option value='2' >제2대(1950~1954)</option>
                <option value='1' >제헌(1948~1950)</option>
              </select>
            </td>
			<td align="left"><a
        href="javascript:winOpen('http://likms.assembly.go.kr/record/index/../shelp.html')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','http://likms.assembly.go.kr/record/index/img/help_but_h.gif',1)"><img src="http://likms.assembly.go.kr/record/index/img/help_but.gif" width="57" height="19" border="0" name="Image2"></a></td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text4.gif" width="84" height="20"></td>
            <td>
              <select name="SES1" class="text5">
                <option value='179'> 제179회 (1996.06.05) </option><option value='180'> 제180회 (1996.07.08) </option><option value='181'> 제181회 (1996.09.10) </option><option value='182'> 제182회 (1996.12.23) </option><option value='183'> 제183회 (1997.02.17) </option><option value='184'> 제184회 (1997.07.01) </option><option value='185'> 제185회 (1997.09.10) </option><option value='186'> 제186회 (1997.12.22) </option><option value='187'> 제187회 (1998.01.15) </option><option value='188'> 제188회 (1998.02.02) </option><option value='189'> 제189회 (1998.02.25) </option><option value='190'> 제190회 (1998.03.06) </option><option value='191'> 제191회 (1998.04.08) </option><option value='192'> 제192회 (1998.05.01) </option><option value='193'> 제193회 (1998.05.25) </option><option value='194'> 제194회 (1998.06.24) </option><option value='195'> 제195회 (1998.07.25) </option><option value='196'> 제196회 (1998.08.24) </option><option value='197'> 제197회 (1998.09.04) </option><option value='198'> 제198회 (1998.09.10) </option><option value='199'> 제199회 (1998.12.19) </option><option value='200'> 제200회 (1999.01.08) </option><option value='201'> 제201회 (1999.02.08) </option><option value='202'> 제202회 (1999.03.10) </option><option value='203'> 제203회 (1999.04.09) </option><option value='204'> 제204회 (1999.05.31) </option><option value='205'> 제205회 (1999.06.29) </option><option value='206'> 제206회 (1999.08.02) </option><option value='207'> 제207회 (1999.08.17) </option><option value='208'> 제208회 (1999.09.10) </option><option value='209'> 제209회 (1999.12.20) </option><option value='210'> 제210회 (2000.01.21) </option><option value='211'> 제211회 (2000.05.03) </option>
           </select><img src="http://likms.assembly.go.kr/record/index/img/text7.gif" width="20" height="20" align="absmiddle"><select name="SES2" class="text5">
 <option value='212' selected> 제212회 (2000.06.05) </option><option value='213' selected> 제213회 (2000.07.05) </option><option value='214' selected> 제214회 (2000.07.31) </option><option value='215' selected> 제215회 (2000.09.01) </option><option value='216' selected> 제216회 (2000.12.11) </option><option value='217' selected> 제217회 (2001.01.10) </option><option value='218' selected> 제218회 (2001.02.09) </option><option value='219' selected> 제219회 (2001.03.02) </option><option value='220' selected> 제220회 (2001.04.02) </option><option value='221' selected> 제221회 (2001.05.02) </option><option value='222' selected> 제222회 (2001.06.04) </option><option value='223' selected> 제223회 (2001.07.06) </option><option value='224' selected> 제224회 (2001.08.06) </option><option value='225' selected> 제225회 (2001.09.01) </option><option value='226' selected> 제226회 (2001.12.14) </option><option value='227' selected> 제227회 (2002.02.01) </option><option value='228' selected> 제228회 (2002.03.04) </option><option value='229' selected> 제229회 (2002.04.03) </option><option value='230' selected> 제230회 (2002.05.06) </option><option value='231' selected> 제231회 (2002.06.05) </option><option value='232' selected> 제232회 (2002.07.05) </option><option value='233' selected> 제233회 (2002.08.05) </option><option value='234' selected> 제234회 (2002.09.02) </option><option value='235' selected> 제235회 (2002.12.30) </option><option value='236' selected> 제236회 (2003.02.05) </option><option value='237' selected> 제237회 (2003.03.24) </option><option value='238' selected> 제238회 (2003.04.01) </option><option value='239' selected> 제239회 (2003.05.01) </option><option value='240' selected> 제240회 (2003.06.02) </option><option value='241' selected> 제241회 (2003.07.02) </option><option value='242' selected> 제242회 (2003.08.01) </option><option value='243' selected> 제243회 (2003.09.01) </option><option value='244' selected> 제244회 (2003.12.10) </option><option value='245' selected> 제245회 (2004.02.02) </option><option value='246' selected> 제246회 (2004.03.06) </option>
              </select>
            </td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text3.gif" width="84" height="20"></td>
            <td >
             <select name="COMM_CODE" class="text2">
                <option value="0" selected>전체</option>
	<option value='ZA'>제15대국회 본회의</option><option value='AA'>제15대국회 국회운영위원회</option><option value='BA'>제15대국회 법제사법위원회</option><option value='CD'>제15대국회 통일외교통상위원회</option><option value='DC'>제15대국회 행정자치위원회</option><option value='FB'>제15대국회 재정경제위원회</option><option value='GD'>제15대국회 과학기술정보통신위원회</option><option value='JC'>제15대국회 농림해양수산위원회</option><option value='KD'>제15대국회 산업자원위원회</option><option value='G1'>제15대국회 예산결산특별위원회</option><option value='TB'>제15대국회 정무위원회</option><option value='RC'>제15대국회 문화관광위원회</option><option value='RB'>제15대국회 문화체육공보위원회</option><option value='QB'>제15대국회 교육위원회</option><option value='PB'>제15대국회 건설교통위원회</option><option value='NC'>제15대국회 환경노동위원회</option><option value='MB'>제15대국회 보건복지위원회</option><option value='KC'>제15대국회 통상산업위원회</option><option value='FB'>제15대국회 재정경제위원회</option><option value='EA'>제15대국회 내무위원회</option><option value='DC'>제15대국회 행정자치위원회</option><option value='DA'>제15대국회 행정위원회</option><option value='CD'>제15대국회 통일외교통상위원회</option><option value='CC'>제15대국회 통일외무위원회</option><option value='BA'>제15대국회 법제사법위원회</option><option value='AA'>제15대국회 국회운영위원회</option><option value='F6'>제15대국회 실업대책및경제구조개혁특별위원회</option><option value='EK'>제15대국회 정치개혁입법특별위원회(1999.12.30부터)</option><option value='EI'>제15대국회 정치구조개혁입법특별위원회</option><option value='EH'>제15대국회 정치개혁입법특별위원회</option><option value='EG'>제15대국회 재해대책특별위원회</option><option value='D1'>제15대국회 여성특별위원회</option><option value='AE'>제15대국회 제도개선특별위원회</option><option value='AD'>제15대국회 제15대국회의원총선거에있어서공정성시비국정조사특별위원회</option><option value='A1'>제15대국회 윤리특별위원회</option><option value='HA'>제15대국회 국방위원회</option><option value='GD'>제15대국회 과학기술정보통신위원회</option><option value='GC'>제15대국회 통신과학기술위원회</option><option value='Z3'>제15대국회 농어민및도시영세민대책특별위원회</option><option value='R3'>제15대국회 2002년월드컵등국제경기대회지원특별위원회</option><option value='R2'>제15대국회 국제경기대회지원특별위원회</option><option value='G3'>제15대국회 국제경쟁력강화및경제제도개혁에관한특별위원회</option><option value='F9'>제15대국회 경제구조개혁및실업대책특별위원회</option><option value='F8'>제15대국회 한보사건국정조사특별위원회</option><option value='TB'>제15대국회 정무위원회</option><option value='RC'>제15대국회 문화관광위원회</option><option value='RB'>제15대국회 문화체육공보위원회</option><option value='QB'>제15대국회 교육위원회</option><option value='PB'>제15대국회 건설교통위원회</option><option value='NC'>제15대국회 환경노동위원회</option><option value='MB'>제15대국회 보건복지위원회</option><option value='KD'>제15대국회 산업자원위원회</option><option value='KC'>제15대국회 통상산업위원회</option><option value='JC'>제15대국회 농림해양수산위원회</option><option value='JA'>제15대국회 농림수산위원회</option><option value='J5'>제15대국회 언론문건진상규명을위한국정조사특별위원회</option><option value='C9'>제15대국회 IMF환란원인규명과경제위기진상조사를위한국정조사특별위원회</option><option value='C6'>제15대국회 한국조폐공사파업유도진상조사를위한국정조사특별위원회</option><option value='HA'>제15대국회 국방위원회</option><option value='GC'>제15대국회 통신과학기술위원회</option><option value='EA'>제15대국회 내무위원회</option><option value='DA'>제15대국회 행정위원회</option><option value='CC'>제15대국회 통일외무위원회</option><option value='ZA'>제16대국회 본회의</option><option value='AA'>제16대국회 국회운영위원회</option><option value='BA'>제16대국회 법제사법위원회</option><option value='SD'>제16대국회 대법관(김용담)임명동의에관한인사청문특별위원회</option><option value='J8'>제16대국회 재정제도개혁특별위원회</option><option value='SC'>제16대국회 중앙선거관리위원회위원(김영철)선출에관한인사청문특별위원회</option><option value='YY'>제16대국회 전원위원회</option><option value='R6'>제16대국회 2003년대구하계유니버시아드대회지원특별위원회</option><option value='TA'>제16대국회 정보위원회</option><option value='KI'>제16대국회 국군부대의이라크전쟁파견동의안에관한전원위원회</option><option value='SB'>제16대국회 국무총리후보자(고건)에관한인사청문특별위원회</option><option value='SA'>제16대국회 대법관(고현철)임명동의에관한인사청문특별위원회</option><option value='SG'>제16대국회 헌법재판소재판관(이상경)선출에관한인사청문특별위원회</option><option value='PT'>제16대국회 과거사진상규명에관한특별위원회</option><option value='SF'>제16대국회 감사원장(전윤철)임명동의에관한인사청문특별위원회</option><option value='HP'>제16대국회 장애인특별위원회</option><option value='SE'>제16대국회 감사원장(윤성식)임명동의에관한인사청문특별위원회</option><option value='S6'>제16대국회 중앙선거관리위원회위원선출에관한인사청문특별위원회</option><option value='S5'>제16대국회 인사청문특별위원회(헌재)</option><option value='S4'>제16대국회 남북정상회담관련결의안기초특별위원회</option><option value='S3'>제16대국회 인사청문특별위원회</option><option value='S2'>제16대국회 국무총리(이한동)임명동의에관한인사청문특별위원회</option><option value='R4'>제16대국회 2010년세계박람회유치특별위원회</option><option value='R3'>제16대국회 2002년월드컵등국제경기대회지원특별위원회</option><option value='A4'>제16대국회 국회상임위원회위원정수에관한규칙개정특별위원회</option><option value='A1'>제16대국회 윤리특별위원회</option><option value='G1'>제16대국회 예산결산특별위원회</option><option value='CD'>제16대국회 통일외교통상위원회</option><option value='DC'>제16대국회 행정자치위원회</option><option value='FB'>제16대국회 재정경제위원회</option><option value='GD'>제16대국회 과학기술정보통신위원회</option><option value='HA'>제16대국회 국방위원회</option><option value='JC'>제16대국회 농림해양수산위원회</option><option value='JC'>제16대국회 농림해양수산위원회</option><option value='HA'>제16대국회 국방위원회</option><option value='GD'>제16대국회 과학기술정보통신위원회</option><option value='FB'>제16대국회 재정경제위원회</option><option value='DC'>제16대국회 행정자치위원회</option><option value='CD'>제16대국회 통일외교통상위원회</option><option value='BA'>제16대국회 법제사법위원회</option><option value='AA'>제16대국회 국회운영위원회</option><option value='M2'>제16대국회 미래전략특별위원회</option><option value='R5'>제16대국회 2010년평창동계올림픽유치특별위원회</option><option value='YS'>제16대국회 여성위원회</option><option value='J0'>제16대국회 공적자금국정조사특별위원회</option><option value='S9'>제16대국회 국무총리(김석수)임명동의에관한인사청문특별위원회</option><option value='S8'>제16대국회 국무총리(장대환)임명동의에관한인사청문특별위원회</option><option value='S7'>제16대국회 국무총리(장상)임명동의에관한인사청문특별위원회</option><option value='J8'>제16대국회 공적자금의운용실태규명을위한국정조사특별위원회</option><option value='J6'>제16대국회 한빛은행대출관련의혹사건등의진상조사를위한국정조사특별위원회</option><option value='AR'>제16대국회 최근일련의언론사태진상규명을위한국정조사특별위원회</option><option value='YS'>제16대국회 여성위원회</option><option value='TB'>제16대국회 정무위원회</option><option value='RC'>제16대국회 문화관광위원회</option><option value='QB'>제16대국회 교육위원회</option><option value='PB'>제16대국회 건설교통위원회</option><option value='NC'>제16대국회 환경노동위원회</option><option value='MB'>제16대국회 보건복지위원회</option><option value='KD'>제16대국회 산업자원위원회</option><option value='JP'>제16대국회 일본역사교과서왜곡시정을위한특별위원회</option><option value='J9'>제16대국회 보훈특별위원회</option><option value='J7'>제16대국회 남북관계발전지원특별위원회</option><option value='F7'>제16대국회 실업대책특별위원회</option><option value='F0'>제16대국회 기후변화협약대책특별위원회</option><option value='EL'>제16대국회 정치개혁특별위원회</option><option value='EG'>제16대국회 재해대책특별위원회</option><option value='D1'>제16대국회 여성특별위원회</option><option value='KD'>제16대국회 산업자원위원회</option><option value='MB'>제16대국회 보건복지위원회</option><option value='NC'>제16대국회 환경노동위원회</option><option value='PB'>제16대국회 건설교통위원회</option><option value='QB'>제16대국회 교육위원회</option><option value='RC'>제16대국회 문화관광위원회</option><option value='TB'>제16대국회 정무위원회</option>
              </select>
            </td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/index_text4.gif" width="84" height="20"></td>
            <td>
              <input type="text" name="CONF_DATE1" value="1996.05.30" class="text7" >
              <img src="http://likms.assembly.go.kr/record/index/img/text7.gif" width="20" height="20" align="absmiddle">
              <input type="text" name="CONF_DATE2" value="<%=audit_year_to.substring(0,4)%>.<%=audit_year_to.substring(4,6)%>.<%=audit_year_to.substring(6,8)%>" class="text7"></td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text8.gif" width="84" height="20"></td>
            <td colspan="2"> <input type="text" name="SUB_NAME" value="<%=query%>" class="text2"></td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text9.gif" width="84" height="20"></td>
            <td   colspan="2"><input type="text" name="SP_NAME"  value="" class="text2"></td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text10.gif" width="84" height="20"></td>
            <td   colspan="2"><input type="text" name="CONTENT"  value="" class="text2"></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
			<td align="right"><input type=image name="submit"  src="http://likms.assembly.go.kr/record/index/../item/img/button_search.gif" width="64" height="19" border="0">
                <a href="ind_search1.jsp"><img src="http://likms.assembly.go.kr/record/index/../item/img/button_cancel.gif" width="64" height="19" border="0"></a> &nbsp;&nbsp;&nbsp;
            </td>
			<td>&nbsp;</td>
			</tr>
        </form>
      </table>
      <br>
    </td>
  </tr>
</table>

<form  method="post"  name="searchform2" action="http://likms.assembly.go.kr/record/index/ind_search1.jsp">
<input type="hidden" name="DIV" value='1'>
<input type="hidden" name="CLASS_CODE" value="">
<input type="hidden" name="DAE1" value="">
<input type="hidden" name="DAE2" value="">
<input type="hidden" name="SES1" value="">
<input type="hidden" name="SES2" value="">
<input type="hidden" name="CONF_DATE1" value="">
<input type="hidden" name="CONF_DATE2" value="">
<input type="hidden" name="COMM_CODE" value="">
<input type="hidden" name="SUB_NAME" value="">
<input type='hidden' name="SP_NAME" value="">
<input type='hidden' name="CONTENT" value="">
</form>

</body>
</html>





