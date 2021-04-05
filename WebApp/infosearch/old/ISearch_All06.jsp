<!--
**      Program Name : ISearch_All06.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  : ��ȸ ȸ�Ƿ� ���� ��ũ ������
**
**      1)��ȸȸ�Ƿ� �ý����� �Է����� �״�� ������� ��������
**	  2)���հ˻��� �˻�� ������ �״�� ���� �����ְ� �˻�� �ִٸ� �ش� �˻�� �ް�ٴ�
**	  3)ȸ�Ƿ� �ý����� �������� �״�� �����Ͽ� ���̹Ƿ� ���� ȸ�Ƿ� �ý����� ������ �����
**	     ���α׷� ������ ����ٸ� �̺κе� ���� ��������־�� ����� �����Ұ���
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

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
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
<title> �ƢƢƢƢ� ��ȸ ȸ�Ƿ� ���� �ƢƢƢƢ� </title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript">
<!--
function change() {
        DAE1=parseInt(document.searchform.DAE1.value)
		DAE2=parseInt(document.searchform.DAE2.value)
	if(DAE1>DAE2)	{
			alert("��� ������ �ùٸ��� �ʽ��ϴ�.");
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
		alert("�˻�� �Է��Ͻʽÿ�");
		document.searchform.SUB_NAME.focus();
		return ;
	}
		document.searchform.submit();
}

function Check(){
		if (document.searchform.SUB_NAME.value == "" && document.searchform.SP_NAME.value == "" && document.searchform.CONTENT.value == "") {
			alert("�˻�� �Է��Ͻʽÿ�");
			document.searchform.SUB_NAME.focus();
			return false;
		}
		var string1=document.searchform.SUB_NAME.value
		var string2=document.searchform.SP_NAME.value
		var string3=document.searchform.CONTENT.value
		if ((string1.indexOf("<")!=-1) || (string1.indexOf(">")!=-1) || (string1.indexOf("(")!=-1) || (string1.indexOf(")")!=-1)  )		{
				alert("<,>,(,) ���ڴ� ����ϽǼ� �����ϴ�.")
			return false ;
		}

		if ((string2.indexOf("<")!=-1) || (string2.indexOf(">")!=-1) || (string2.indexOf("(")!=-1) || (string2.indexOf(")")!=-1)  )		{
				alert("<,>,(,) ���ڴ� ����ϽǼ� �����ϴ�.")
			return false ;
		}

		if ((string3.indexOf("<")!=-1) || (string3.indexOf(">")!=-1) || (string3.indexOf("(")!=-1) || (string3.indexOf(")")!=-1)  )		{
				alert("<,>,(,) ���ڴ� ����ϽǼ� �����ϴ�.")
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
                <option value="0" > ��ü</option>
                <option value="1" >��ȸ��</option>
                <option value="2" >��������ȸ</option>
                <option value="4" >������Ư������ȸ</option>
				<option value="3" >Ư������ȸ</option>
                <option value="5" >��������</option>
                <option value="6" >��������</option>
              </select>
              </font></td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text2.gif" width="84" height="20"></td>
            <td>
              <select name="DAE1" class=text5 onChange="javascript:change();">
                <option value='16' >��16��(2000~2004)</option>
                <option value='15' selected>��15��(1996~2000)</option>
                <option value='14' >��14��(1992~1996)</option>
                <option value='13' >��13��(1988~1992)</option>
                <option value='12' >��12��(1985~1988)</option>
                <option value='11' >��11��(1981~1985)</option>
                <option value='10' >��10��(1979~1980)</option>
                <option value='9' >��9��(1973~1979)</option>
                <option value='8' >��8��(1971~1972)</option>
                <option value='7' >��7��(1967~1971)</option>
                <option value='6' >��6��(1963~1967)</option>
                <option value='5' >��5��(1960~1961)</option>
                <option value='4' >��4��(1958~1960)</option>
                <option value='3' >��3��(1954~1958)</option>
                <option value='2' >��2��(1950~1954)</option>
                <option value='1' >����(1948~1950)</option>
              </select><img src="http://likms.assembly.go.kr/record/index/img/text7.gif" width="20" height="20" align="absmiddle"><select name="DAE2" class=text5 onChange="javascript:change();">
                <option value='17' selected>��17��(2004~2008)</option>
                <option value='16' >��16��(2000~2004)</option>
                <option value='15' >��15��(1996~2000)</option>
                <option value='14' >��14��(1992~1996)</option>
                <option value='13' >��13��(1988~1992)</option>
                <option value='12' >��12��(1985~1988)</option>
                <option value='11' >��11��(1981~1985)</option>
                <option value='10' >��10��(1979~1980)</option>
                <option value='9' >��9��(1973~1979)</option>
                <option value='8' >��8��(1971~1972)</option>
                <option value='7' >��7��(1967~1971)</option>
                <option value='6' >��6��(1963~1967)</option>
                <option value='5' >��5��(1960~1961)</option>
                <option value='4' >��4��(1958~1960)</option>
                <option value='3' >��3��(1954~1958)</option>
                <option value='2' >��2��(1950~1954)</option>
                <option value='1' >����(1948~1950)</option>
              </select>
            </td>
			<td align="left"><a
        href="javascript:winOpen('http://likms.assembly.go.kr/record/index/../shelp.html')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','http://likms.assembly.go.kr/record/index/img/help_but_h.gif',1)"><img src="http://likms.assembly.go.kr/record/index/img/help_but.gif" width="57" height="19" border="0" name="Image2"></a></td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text4.gif" width="84" height="20"></td>
            <td>
              <select name="SES1" class="text5">
                <option value='179'> ��179ȸ (1996.06.05) </option><option value='180'> ��180ȸ (1996.07.08) </option><option value='181'> ��181ȸ (1996.09.10) </option><option value='182'> ��182ȸ (1996.12.23) </option><option value='183'> ��183ȸ (1997.02.17) </option><option value='184'> ��184ȸ (1997.07.01) </option><option value='185'> ��185ȸ (1997.09.10) </option><option value='186'> ��186ȸ (1997.12.22) </option><option value='187'> ��187ȸ (1998.01.15) </option><option value='188'> ��188ȸ (1998.02.02) </option><option value='189'> ��189ȸ (1998.02.25) </option><option value='190'> ��190ȸ (1998.03.06) </option><option value='191'> ��191ȸ (1998.04.08) </option><option value='192'> ��192ȸ (1998.05.01) </option><option value='193'> ��193ȸ (1998.05.25) </option><option value='194'> ��194ȸ (1998.06.24) </option><option value='195'> ��195ȸ (1998.07.25) </option><option value='196'> ��196ȸ (1998.08.24) </option><option value='197'> ��197ȸ (1998.09.04) </option><option value='198'> ��198ȸ (1998.09.10) </option><option value='199'> ��199ȸ (1998.12.19) </option><option value='200'> ��200ȸ (1999.01.08) </option><option value='201'> ��201ȸ (1999.02.08) </option><option value='202'> ��202ȸ (1999.03.10) </option><option value='203'> ��203ȸ (1999.04.09) </option><option value='204'> ��204ȸ (1999.05.31) </option><option value='205'> ��205ȸ (1999.06.29) </option><option value='206'> ��206ȸ (1999.08.02) </option><option value='207'> ��207ȸ (1999.08.17) </option><option value='208'> ��208ȸ (1999.09.10) </option><option value='209'> ��209ȸ (1999.12.20) </option><option value='210'> ��210ȸ (2000.01.21) </option><option value='211'> ��211ȸ (2000.05.03) </option>
           </select><img src="http://likms.assembly.go.kr/record/index/img/text7.gif" width="20" height="20" align="absmiddle"><select name="SES2" class="text5">
 <option value='212' selected> ��212ȸ (2000.06.05) </option><option value='213' selected> ��213ȸ (2000.07.05) </option><option value='214' selected> ��214ȸ (2000.07.31) </option><option value='215' selected> ��215ȸ (2000.09.01) </option><option value='216' selected> ��216ȸ (2000.12.11) </option><option value='217' selected> ��217ȸ (2001.01.10) </option><option value='218' selected> ��218ȸ (2001.02.09) </option><option value='219' selected> ��219ȸ (2001.03.02) </option><option value='220' selected> ��220ȸ (2001.04.02) </option><option value='221' selected> ��221ȸ (2001.05.02) </option><option value='222' selected> ��222ȸ (2001.06.04) </option><option value='223' selected> ��223ȸ (2001.07.06) </option><option value='224' selected> ��224ȸ (2001.08.06) </option><option value='225' selected> ��225ȸ (2001.09.01) </option><option value='226' selected> ��226ȸ (2001.12.14) </option><option value='227' selected> ��227ȸ (2002.02.01) </option><option value='228' selected> ��228ȸ (2002.03.04) </option><option value='229' selected> ��229ȸ (2002.04.03) </option><option value='230' selected> ��230ȸ (2002.05.06) </option><option value='231' selected> ��231ȸ (2002.06.05) </option><option value='232' selected> ��232ȸ (2002.07.05) </option><option value='233' selected> ��233ȸ (2002.08.05) </option><option value='234' selected> ��234ȸ (2002.09.02) </option><option value='235' selected> ��235ȸ (2002.12.30) </option><option value='236' selected> ��236ȸ (2003.02.05) </option><option value='237' selected> ��237ȸ (2003.03.24) </option><option value='238' selected> ��238ȸ (2003.04.01) </option><option value='239' selected> ��239ȸ (2003.05.01) </option><option value='240' selected> ��240ȸ (2003.06.02) </option><option value='241' selected> ��241ȸ (2003.07.02) </option><option value='242' selected> ��242ȸ (2003.08.01) </option><option value='243' selected> ��243ȸ (2003.09.01) </option><option value='244' selected> ��244ȸ (2003.12.10) </option><option value='245' selected> ��245ȸ (2004.02.02) </option><option value='246' selected> ��246ȸ (2004.03.06) </option>
              </select>
            </td>
			<td>&nbsp;</td>
          </tr>
          <tr>
            <td><img src="http://likms.assembly.go.kr/record/index/img/item_text3.gif" width="84" height="20"></td>
            <td >
             <select name="COMM_CODE" class="text2">
                <option value="0" selected>��ü</option>
	<option value='ZA'>��15�뱹ȸ ��ȸ��</option><option value='AA'>��15�뱹ȸ ��ȸ�����ȸ</option><option value='BA'>��15�뱹ȸ �����������ȸ</option><option value='CD'>��15�뱹ȸ ���Ͽܱ��������ȸ</option><option value='DC'>��15�뱹ȸ ������ġ����ȸ</option><option value='FB'>��15�뱹ȸ ������������ȸ</option><option value='GD'>��15�뱹ȸ ���б�������������ȸ</option><option value='JC'>��15�뱹ȸ ���ؾ��������ȸ</option><option value='KD'>��15�뱹ȸ ����ڿ�����ȸ</option><option value='G1'>��15�뱹ȸ ������Ư������ȸ</option><option value='TB'>��15�뱹ȸ ��������ȸ</option><option value='RC'>��15�뱹ȸ ��ȭ��������ȸ</option><option value='RB'>��15�뱹ȸ ��ȭü����������ȸ</option><option value='QB'>��15�뱹ȸ ��������ȸ</option><option value='PB'>��15�뱹ȸ �Ǽ���������ȸ</option><option value='NC'>��15�뱹ȸ ȯ��뵿����ȸ</option><option value='MB'>��15�뱹ȸ ���Ǻ�������ȸ</option><option value='KC'>��15�뱹ȸ ���������ȸ</option><option value='FB'>��15�뱹ȸ ������������ȸ</option><option value='EA'>��15�뱹ȸ ��������ȸ</option><option value='DC'>��15�뱹ȸ ������ġ����ȸ</option><option value='DA'>��15�뱹ȸ ��������ȸ</option><option value='CD'>��15�뱹ȸ ���Ͽܱ��������ȸ</option><option value='CC'>��15�뱹ȸ ���Ͽܹ�����ȸ</option><option value='BA'>��15�뱹ȸ �����������ȸ</option><option value='AA'>��15�뱹ȸ ��ȸ�����ȸ</option><option value='F6'>��15�뱹ȸ �Ǿ���å�װ�����������Ư������ȸ</option><option value='EK'>��15�뱹ȸ ��ġ�����Թ�Ư������ȸ(1999.12.30����)</option><option value='EI'>��15�뱹ȸ ��ġ���������Թ�Ư������ȸ</option><option value='EH'>��15�뱹ȸ ��ġ�����Թ�Ư������ȸ</option><option value='EG'>��15�뱹ȸ ���ش�åƯ������ȸ</option><option value='D1'>��15�뱹ȸ ����Ư������ȸ</option><option value='AE'>��15�뱹ȸ ��������Ư������ȸ</option><option value='AD'>��15�뱹ȸ ��15�뱹ȸ�ǿ��Ѽ��ſ��־�������ú�������Ư������ȸ</option><option value='A1'>��15�뱹ȸ ����Ư������ȸ</option><option value='HA'>��15�뱹ȸ ��������ȸ</option><option value='GD'>��15�뱹ȸ ���б�������������ȸ</option><option value='GC'>��15�뱹ȸ ��Ű��б������ȸ</option><option value='Z3'>��15�뱹ȸ ���ι׵��ÿ����δ�åƯ������ȸ</option><option value='R3'>��15�뱹ȸ 2002������ŵ������ȸ����Ư������ȸ</option><option value='R2'>��15�뱹ȸ ��������ȸ����Ư������ȸ</option><option value='G3'>��15�뱹ȸ ��������°�ȭ�װ�����������������Ư������ȸ</option><option value='F9'>��15�뱹ȸ �������������׽Ǿ���åƯ������ȸ</option><option value='F8'>��15�뱹ȸ �Ѻ���Ǳ�������Ư������ȸ</option><option value='TB'>��15�뱹ȸ ��������ȸ</option><option value='RC'>��15�뱹ȸ ��ȭ��������ȸ</option><option value='RB'>��15�뱹ȸ ��ȭü����������ȸ</option><option value='QB'>��15�뱹ȸ ��������ȸ</option><option value='PB'>��15�뱹ȸ �Ǽ���������ȸ</option><option value='NC'>��15�뱹ȸ ȯ��뵿����ȸ</option><option value='MB'>��15�뱹ȸ ���Ǻ�������ȸ</option><option value='KD'>��15�뱹ȸ ����ڿ�����ȸ</option><option value='KC'>��15�뱹ȸ ���������ȸ</option><option value='JC'>��15�뱹ȸ ���ؾ��������ȸ</option><option value='JA'>��15�뱹ȸ �󸲼�������ȸ</option><option value='J5'>��15�뱹ȸ ��й�������Ը������ѱ�������Ư������ȸ</option><option value='C9'>��15�뱹ȸ IMFȯ�����αԸ�����������������縦���ѱ�������Ư������ȸ</option><option value='C6'>��15�뱹ȸ �ѱ���������ľ������������縦���ѱ�������Ư������ȸ</option><option value='HA'>��15�뱹ȸ ��������ȸ</option><option value='GC'>��15�뱹ȸ ��Ű��б������ȸ</option><option value='EA'>��15�뱹ȸ ��������ȸ</option><option value='DA'>��15�뱹ȸ ��������ȸ</option><option value='CC'>��15�뱹ȸ ���Ͽܹ�����ȸ</option><option value='ZA'>��16�뱹ȸ ��ȸ��</option><option value='AA'>��16�뱹ȸ ��ȸ�����ȸ</option><option value='BA'>��16�뱹ȸ �����������ȸ</option><option value='SD'>��16�뱹ȸ �����(����)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='J8'>��16�뱹ȸ ������������Ư������ȸ</option><option value='SC'>��16�뱹ȸ �߾Ӽ��Ű�������ȸ����(�迵ö)���⿡�����λ�û��Ư������ȸ</option><option value='YY'>��16�뱹ȸ ��������ȸ</option><option value='R6'>��16�뱹ȸ 2003��뱸�ϰ����Ϲ��þƵ��ȸ����Ư������ȸ</option><option value='TA'>��16�뱹ȸ ��������ȸ</option><option value='KI'>��16�뱹ȸ �����δ����̶�ũ�����İߵ��Ǿȿ�������������ȸ</option><option value='SB'>��16�뱹ȸ �����Ѹ��ĺ���(���)�������λ�û��Ư������ȸ</option><option value='SA'>��16�뱹ȸ �����(����ö)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='SG'>��16�뱹ȸ ������Ǽ����ǰ�(�̻��)���⿡�����λ�û��Ư������ȸ</option><option value='PT'>��16�뱹ȸ ���Ż�����Ը�����Ư������ȸ</option><option value='SF'>��16�뱹ȸ �������(����ö)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='HP'>��16�뱹ȸ �����Ư������ȸ</option><option value='SE'>��16�뱹ȸ �������(������)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='S6'>��16�뱹ȸ �߾Ӽ��Ű�������ȸ�������⿡�����λ�û��Ư������ȸ</option><option value='S5'>��16�뱹ȸ �λ�û��Ư������ȸ(����)</option><option value='S4'>��16�뱹ȸ ��������ȸ����ð��Ǿȱ���Ư������ȸ</option><option value='S3'>��16�뱹ȸ �λ�û��Ư������ȸ</option><option value='S2'>��16�뱹ȸ �����Ѹ�(���ѵ�)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='R4'>��16�뱹ȸ 2010�⼼��ڶ�ȸ��ġƯ������ȸ</option><option value='R3'>��16�뱹ȸ 2002������ŵ������ȸ����Ư������ȸ</option><option value='A4'>��16�뱹ȸ ��ȸ��������ȸ�������������ѱ�Ģ����Ư������ȸ</option><option value='A1'>��16�뱹ȸ ����Ư������ȸ</option><option value='G1'>��16�뱹ȸ ������Ư������ȸ</option><option value='CD'>��16�뱹ȸ ���Ͽܱ��������ȸ</option><option value='DC'>��16�뱹ȸ ������ġ����ȸ</option><option value='FB'>��16�뱹ȸ ������������ȸ</option><option value='GD'>��16�뱹ȸ ���б�������������ȸ</option><option value='HA'>��16�뱹ȸ ��������ȸ</option><option value='JC'>��16�뱹ȸ ���ؾ��������ȸ</option><option value='JC'>��16�뱹ȸ ���ؾ��������ȸ</option><option value='HA'>��16�뱹ȸ ��������ȸ</option><option value='GD'>��16�뱹ȸ ���б�������������ȸ</option><option value='FB'>��16�뱹ȸ ������������ȸ</option><option value='DC'>��16�뱹ȸ ������ġ����ȸ</option><option value='CD'>��16�뱹ȸ ���Ͽܱ��������ȸ</option><option value='BA'>��16�뱹ȸ �����������ȸ</option><option value='AA'>��16�뱹ȸ ��ȸ�����ȸ</option><option value='M2'>��16�뱹ȸ �̷�����Ư������ȸ</option><option value='R5'>��16�뱹ȸ 2010����â����ø�����ġƯ������ȸ</option><option value='YS'>��16�뱹ȸ ��������ȸ</option><option value='J0'>��16�뱹ȸ �����ڱݱ�������Ư������ȸ</option><option value='S9'>��16�뱹ȸ �����Ѹ�(�輮��)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='S8'>��16�뱹ȸ �����Ѹ�(���ȯ)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='S7'>��16�뱹ȸ �����Ѹ�(���)�Ӹ��ǿ������λ�û��Ư������ȸ</option><option value='J8'>��16�뱹ȸ �����ڱ��ǿ����±Ը������ѱ�������Ư������ȸ</option><option value='J6'>��16�뱹ȸ �Ѻ�������������Ȥ��ǵ����������縦���ѱ�������Ư������ȸ</option><option value='AR'>��16�뱹ȸ �ֱ��Ϸ��Ǿ�л�������Ը������ѱ�������Ư������ȸ</option><option value='YS'>��16�뱹ȸ ��������ȸ</option><option value='TB'>��16�뱹ȸ ��������ȸ</option><option value='RC'>��16�뱹ȸ ��ȭ��������ȸ</option><option value='QB'>��16�뱹ȸ ��������ȸ</option><option value='PB'>��16�뱹ȸ �Ǽ���������ȸ</option><option value='NC'>��16�뱹ȸ ȯ��뵿����ȸ</option><option value='MB'>��16�뱹ȸ ���Ǻ�������ȸ</option><option value='KD'>��16�뱹ȸ ����ڿ�����ȸ</option><option value='JP'>��16�뱹ȸ �Ϻ����米�����ְ����������Ư������ȸ</option><option value='J9'>��16�뱹ȸ ����Ư������ȸ</option><option value='J7'>��16�뱹ȸ ���ϰ����������Ư������ȸ</option><option value='F7'>��16�뱹ȸ �Ǿ���åƯ������ȸ</option><option value='F0'>��16�뱹ȸ ���ĺ�ȭ�����åƯ������ȸ</option><option value='EL'>��16�뱹ȸ ��ġ����Ư������ȸ</option><option value='EG'>��16�뱹ȸ ���ش�åƯ������ȸ</option><option value='D1'>��16�뱹ȸ ����Ư������ȸ</option><option value='KD'>��16�뱹ȸ ����ڿ�����ȸ</option><option value='MB'>��16�뱹ȸ ���Ǻ�������ȸ</option><option value='NC'>��16�뱹ȸ ȯ��뵿����ȸ</option><option value='PB'>��16�뱹ȸ �Ǽ���������ȸ</option><option value='QB'>��16�뱹ȸ ��������ȸ</option><option value='RC'>��16�뱹ȸ ��ȭ��������ȸ</option><option value='TB'>��16�뱹ȸ ��������ȸ</option>
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





