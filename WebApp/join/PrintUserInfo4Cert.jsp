<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style>
.TEXT {
	FONT-SIZE: 12px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: ����,verdana,seoul,Aria ;letter-spacing: -1px l 
}
.TEXT_S {
	FONT-SIZE: 9px; COLOR: #000000; LINE-HEIGHT: 140%; FONT-FAMILY: "����", "verdana", "seoul", "Arial";letter-spacing: -1px 
}
.TITLE {
	FONT-SIZE: 15px; COLOR: #000000; FONT-FAMILY: ����,verdana,seoul,Arial ;letter-spacing: -1px 
}
.TITLE2 {
	FONT-SIZE: 14px; COLOR: #000000; FONT-FAMILY: ����,verdana,seoul,Arial ;letter-spacing: -1px 
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
    <td align="center" valign="middle" class="TITLE"><strong>��ȸ�����ڷ���������ý��� ������������ 
      ��û��</strong></td>
  </tr>
</table>
<table width="600" border="1" cellpadding="1" cellspacing="0">
  <tr align="center" bgcolor="GRAY" class="TEXT"> 
    <td height="25" colspan="5" class="TITLE2"><strong>��� ����</strong></td>
  </tr>
  <tr align="center" class="TEXT"> 
    <td width="53" rowspan="2">�����</td>
    <td width="57" height="25">*����</td>
    <td width="163" height="25"><script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td width="85" height="25">��ǥ��</td>
    <td width="160" height="25">&nbsp;</td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">����</td>
    <td height="25" class="TEXT">&nbsp;</td>
    <td height="25" align="center" class="TEXT">�ֹε�Ϲ�ȣ</td>
    <td height="25">&nbsp;</td>
  </tr>
  <tr align="center" class="TEXT"> 
    <td height="25" colspan="2">Ȩ������ �ּ�</td>
    <td height="25">&nbsp;</td>
    <td height="25">*��Ϲ�ȣ</td>
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
    <td height="25" colspan="2">*�ּ�</td>
    <td height="25" colspan="3"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script></td>
  </tr>
</table>
<table width="600" border="1" cellpadding="1" cellspacing="0">
  <tr align="center" bgcolor="GRAY" class="TEXT"> 
    <td height="25" colspan="5" class="TITLE2"><strong>����� ����</strong></td>
  </tr>
  <tr class="TEXT"> 
    <td width="54" rowspan="2" align="center">����</td>
    <td width="56" height="25" align="center">*����</td>
    <td width="163" height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script></td>
    <td width="86" height="25" align="center">*�Ҽ�</td>
    <td width="159" height="25">&nbsp;<script>document.write(opener.document.forms[0].DEPT_NM.value)</script></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">����</td>
    <td height="25" align="center">&nbsp;</td>
    <td width="86" height="25" align="center" class="TEXT">*����</td>
    <td height="25" CLASS="TEXT">&nbsp;<script>document.write(opener.document.forms[0].GRD_NM.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*�ֹε�Ϲ�ȣ</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].JUMIN_NO1.value)</script> -
		  �ܡܡܡܡܡܡ�</script></td>
    <td height="25" align="center">����</td>
    <td height="25">&nbsp;<strong>�־��� :</strong><script>document.write(opener.document.forms[0].MchrWord.value)</script>
		  <br>&nbsp;<strong>�ξ��� :</strong><script>document.write(opener.document.forms[0].SchrWord.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*��ȭ��ȣ</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].OFFICE_TEL.value)</script></td>
    <td height="25" align="center">�޴���</td>
    <td height="25">&nbsp;<script>document.write(opener.document.forms[0].CPHONE.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">*E-Mail</td>
    <td height="25" align="center">&nbsp;<script>document.write(opener.document.forms[0].EMAIL.value)</script></td>
    <td height="25" align="center">�ѽ���ȣ</td>
    <td height="25">&nbsp;<script>document.write(opener.document.forms[0].FAX_NO.value)</script></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" colspan="2" align="center">��ǥ�� ����</td>
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
            <span class="TEXT">��ȸ��ǥ�����</span></td>
          <td width="64%"><script> document.write("<img src='../image/join/"+strRepFlagImg2+"' width='13' height='13' align='absmiddle'>")</script>
            <span class="TEXT">�Ϲݻ����</span></td>
        </tr>
      </table>
	  </td>
  </tr>
</table>
<table width="600" border="1" cellspacing="0" cellpadding="1">
  <tr align="center" bgcolor="GRAY"> 
    <td height="25" colspan="3" class="TITLE2"><strong>��û ����</strong></td>
  </tr>
  <tr class="TEXT"> 
    <td width="101" rowspan="3" align="center">��û����</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">�űԹ߱�</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">���Ź߱�</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">��߱�</span></td>
          <td width="23%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">����</span></td>
        </tr>
        <tr> 
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">ȿ������</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">ȿ��ȸ��</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">��������</span></td>
          <td>&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="191" height="25" align="center" class="TEXT">����/ȿ������/<br>
      ȿ��ȸ��/�������� ����</td>
    <td width="294" height="25">&nbsp;</td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">��ȿ�Ⱓ ������</td>
    <td height="25" align="center"><table width="93%" height="20" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="23%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">�߱���</span></td>
          <td width="77%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">������ (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��)</span></td>
        </tr>
      </table></td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" align="center">������ �뵵</td>
    <td height="25" colspan="2" align="left" valign="top">&nbsp;&nbsp; �� ȸ �� �� �� �� �� �� �� �� �� �� �� Ư �� �� �� ��</td>
  </tr>
  <tr class="TEXT"> 
    <td height="25" align="center">������ ���</td>
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
    <td height="25" align="center">������ �Ⱓ</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="27%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">1��</span></td>
          <td width="25%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">2��</span></td>
          <td><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">��Ÿ (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 
            ) </span></td>
        </tr>
      </table></td>
  </tr>
  <tr class="TEXT"> 
    <td rowspan="3" align="center">������� ���</td>
    <td height="25" colspan="2" align="center" valign="top"><table width="97%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="21%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">�ڵ���ü</span></td>
          <td width="17%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">����</span></td>
          <td width="17%"><img src="../image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">ī��</span></td>
          <td width="45%"><img src="../image/join/nemo_black.gif" width="13" height="13" align="absmiddle"> 
            <span class="TEXT">��Ÿ (&nbsp;���� )</span></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">�����/�ſ�ī���</td>
    <td height="25"><img src="../image/join/line.gif" width="294" height="21"></td>
  </tr>
  <tr> 
    <td height="25" align="center" class="TEXT">���¹�ȣ/ī���ȣ</td>
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
          <td class="TEXT">&nbsp;&nbsp;&nbsp;���� ���� �������� ��û�ϸ� �������� ��û �� �̿뿡 �־� 
            �ѱ������ �������� ������ ����������Ģ�� �����Ͽ����� �������� �ǹ��� å�� �� �������� �̿� ���� ������ �ؼ��� ���� 
            ����մϴ�. </td>
        </tr>
        <tr> 
          <td align="right" class="TEXT"><%=strDate.substring(0,4)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT">����(��ǥ��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� 
            �Ǵ�����)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr height="15"> 
          <td height="15" class="TEXT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ѱ�������� 
            ����</td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td width="410" rowspan="4" align="center"><table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="TEXT">�� ÷�μ��� : �ſ�Ȯ�� ��������<br>
            - ������� �ź������� �纻(��������) �� �������� �� 1��<br>
            - ���� �ΰ�����, ����ڵ���� �纻 �Ǵ� ���ε��ε �� 1��<br>
            - �븮���� �ź������� �纻(��������) �� ������ �� 1��<br>
</td>
        </tr>
      </table></td>
    <td width="68" height="28" align="center" class="TEXT">������</td>
    <td width="88" height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">������ȣ</td>
    <td height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">��ϱ��</td>
    <td height="28" class="TEXT">&nbsp;</td>
  </tr>
  <tr> 
    <td height="28" align="center" class="TEXT">�����</td>
    <td height="28" align="right" class="TEXT">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
      (��) &nbsp;</td>
  </tr>
  <tr align="center" valign="top"> 
    <td height="25" colspan="3"><table width="95%" border="0" cellspacing="0" cellpadding="0">
        <tr height="15"> 
          <td height="7" class="TEXT"></td>
        </tr>
        <tr> 
          <td align="center" class="TITLE2"><strong>������ ���� �� ���� �� Ȱ�� ���Ǽ�</strong></td>
        </tr>
        <tr> 
          <td class="TEXT">&nbsp;&nbsp;&nbsp;���� ��û����� �����Ͽ� ���� �ѱ������ �����������Ͱ� ����� 
            ���������� �����ϰ�, ���κ��� ����� ���������� ����� �������� �̿��ϴ� �ŷڴ���ڿ��� ���� �� Ȱ���ϴµ� �����մϴ�.</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT"><%=strDate.substring(0,4)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td align="right" class="TEXT">����(��ǥ��)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(���� 
            �Ǵ�����)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr height="10"> 
          <td height="10"></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="600" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="22" align="left" valign="bottom" class="TEXT">*�� �ʼ��Է� �׸���.</td>
  </tr>
</table>
<br>
<br>
<br>
<br>
<br>


<!-- ������������ ��û�� ������ -->
<table width="590" height="35" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top" class="TITLE"><strong>������������ ��û�� ������</strong></td>
  </tr>
</table>
<table width="600" height="160" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" rowspan="4" align="center" valign="middle" bgcolor="#CCCCCC"><strong>������<br>
      �޴��� </strong></td>
    <td width="88" align="center"><strong>����</strong></td>
    <td width="124">&nbsp;<script>document.write(opener.document.forms[0].USER_NM.value)</script></td>
    <td width="110" align="center"><strong>�ֹε�Ϲ�ȣ</strong></td>
    <td width="153"><font size="2">&nbsp;<script>document.write(opener.document.forms[0].JUMIN_NO1.value)</script> -
		  �ܡܡܡܡܡܡ�</script></font></td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>�����</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td align="center"><strong>����</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].GRD_NM.value)</script></td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>��ȭ��ȣ</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].OFFICE_TEL.value)</script></td>
    <td align="center"><strong>�����ΰ��� ����</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>�ּ�</strong></td>
    <td colspan="3" align="left"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;<script>document.write(opener.document.forms[0].POST_CD1.value)</script>- 
     <script>document.write(opener.document.forms[0].POST_CD2.value)</script></td>
  </tr>
</table>
<table width="600" height="160" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" rowspan="4" align="center" valign="middle" bgcolor="#CCCCCC"><strong>������<br>
      �ϴ���<br>
      (��ǥ��)&nbsp; <br>
      </strong></td>
    <td width="88" align="center"><strong>����</strong></td>
    <td width="124">&nbsp;</td>
    <td width="110" align="center"><strong>�ֹε�Ϲ�ȣ</strong></td>
    <td width="153">&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>�����</strong></td>
    <td>&nbsp;<script>document.write(opener.document.forms[0].ORGAN_NM.value)</script></td>
    <td align="center"><strong>����</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>��ȭ��ȣ</strong></td>
    <td>&nbsp;</td>
    <td align="center"><strong>���ӻ���</strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr class="TITLE2"> 
    <td align="center"><strong>�ּ�</strong></td>
    <td colspan="3" align="left"><SCRIPT>document.write(opener.document.forms[0].ORGAN_JUSO1.value+"&nbsp;"+opener.document.forms[0].ORGAN_JUSO2.value)</script>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(��)&nbsp;<script>document.write(opener.document.forms[0].POST_CD1.value)</script>- 
     <script>document.write(opener.document.forms[0].POST_CD2.value)</script></td>
  </tr>
</table>
<table width="600" height="95" border="1" cellpadding="1" cellspacing="0">
  <tr class="TITLE2"> 
    <td width="93" align="center" valign="middle" bgcolor="#CCCCCC"><strong>���ӻ���<br>
      </strong></td>
    <td width="497" align="center"><table width="97%" height="57" border="0" cellpadding="0" cellspacing="0" class="TITLE2">
        <tr> 
          <td width="27%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">�űԹ߱�</span></strong></td>
          <td width="25%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">���Ź߱�</span></strong></td>
          <td width="25%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">��߱�</span></strong></td>
          <td width="23%"><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">����</span></strong></td>
        </tr>
        <tr> 
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">ȿ������</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">ȿ��ȸ��</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">��������</span></strong></td>
          <td><strong><img src="file:///F|/%C0%C7%C1%A4%C8%B0%B5%BF%BC%AD%B7%F9%C1%A6%C3%E2/%B0%B3%B9%DF/%B5%F0%C0%DA%C0%CE%BC%F6%C1%A4%BA%CE%BA%D0html_%C1%A6%C3%E2/image/join/nemo.gif" width="13" height="13" align="absmiddle"> 
            <span class="TITLE2">ȯ�ҽ�û</span></strong></td>
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
          <td height="30" class="TITLE2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� 
            ���� �����մϴ�.</td>
        </tr>
        <tr> 
          <td height="20" align="right" class="TITLE2">&nbsp;</td>
        </tr>
        <tr> 
          <td height="40" align="right" class="TITLE2"><%=strDate.substring(0,4)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(4,6)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;<%=strDate.substring(6,8)%>&nbsp;��&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr> 
          <td height="30" align="right" class="TITLE2">������(&nbsp;��ǥ��&nbsp;) 
            : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(&nbsp;��&nbsp;)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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