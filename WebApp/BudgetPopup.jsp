<%@ page language="java" contentType="text/html;charset=MS949" %>

<html>
<head>
<title>�����ڷ� �������� �ý���</title>

<style>
body, table, tr, td 
{ 
	background-color:#ffffff; font-family:verdana, ����; font-size:11px;
}
.title { height:30; font-family:HY������M, ����; font-size:18px; color:#7359C8; }
.line { background-color:#c1c1c1; }
.subtitle { background-color:#ffffff; font-family:verdana, ����; font-size:12px; font-weight:bold; color:#7359C8; }
</style>


<script language="javascript">
	function setCookie(name, value, expiredays){ 
		var todayDate = new Date(); 
		todayDate.setDate( todayDate.getDate() + expiredays ); 
		document.cookie = name + '=' + escape( value ) + '; path=/; expires=' + todayDate.toGMTString() + ';' 
	} 
	 
	function closeWin() { 
		if(document.all.chkClose.checked) { 
			setCookie("naps", "no", 1);
		} 
		self.close();
	}

</script>
</head>

<body leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="400" align="left" valign="middle" height="55">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" valign="middle"><img src="/image/main/assembly.gif" border="0"></td>
						<td style="padding-left:10px">
							<font class="title" style="filter:dropshadow(color=c0c0c0 offx=2 offy=2 positive=1)">������Ư������ȸ �Ҽ�<BR>�ǿ��� ����� �е��� Ȯ�ιٶ��ϴ�!!</font>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="1" class="line"></td>
		</tr>
		<tr>
			<td height="418" align="center" valign="top">
				<br>
				<table border="0" cellpadding="0" cellspacing="0">
					<tr><td width="380" height="20">������Ư������ȸ �Ҽ� �ǿ��ǿ��� �������� ������� </td></tr>
					<tr><td height="20">�ڷ�䱸�� �ϴ� ����� �Ʒ��� �ΰ��� ����� �ֽ��ϴ�.</td></tr>
					<tr><td height="20">�ش��ϴ� ����� �°Բ� ������ ���� ������ �ֽñ� �ٶ��ϴ�.</td></tr>
					<tr><td height="5"></td></tr>
					<tr><td height="20" class="subtitle">[�ǿ��� ���� �ڷ� �䱸]</td></tr>
					<tr><td height="20">�� �������� ���� �α���</td></tr>
					<tr><td height="20">�� ����ȭ�鿡�� �ڷ�䱸 > �ǿ����ڷ�䱸 Ŭ��</td></tr>
					<tr><td height="20">�� �ǿ��� �ڷ�䱸 > �䱸����ȸ > �ۼ��� �䱸�� Ŭ��</td></tr>
					<tr><td height="20">�� '�䱸�� �ۼ�' ��ư�� Ŭ���ؼ� �䱸�� ���� �� �䱸 ���� �ۼ�</td></tr>
					<tr><td height="20">�� �䱸�� �� ���⿡�� '�䱸�� �߼�' ��ư Ŭ��</td></tr>
					<tr><td height="20">�� �䱸�� �߼� �� '�߼ۿϷ�䱸��'���� Ȯ��</td></tr>
					<tr><td height="5"></td></tr>
					<tr><td height="20" class="subtitle">[����ȸ ���� �ڷ� �䱸]</td></tr>
					<tr><td height="20">�� �������� ���� �α���</td></tr>
					<tr><td height="20">�� ����ȭ�鿡�� �ڷ�䱸 > �ǿ����ڷ�䱸 Ŭ��</td></tr>
					<tr><td height="20">�� �ǿ��� �ڷ�䱸 > �䱸����ȸ > �ۼ��� �䱸�� Ŭ��</td></tr>
					<tr><td height="20">�� '�䱸�� �ۼ�' ��ư�� Ŭ���ؼ� �䱸�� ���� �� �䱸 ���� �ۼ�</td></tr>
					<tr><td height="20">�� �䱸�� �� ���⿡�� '����ȸ ���� �䱸�� �߼�' ��ư Ŭ��</td></tr>
					<tr><td height="20">�� ����ȸ �ڷ�䱸 > �䱸����ȸ > �����Ϸ�䱸���� ���� ��ȸ</td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="1" class="line"></td>
		</tr>
		<tr>
			<td height="25" align="right"><input type="checkbox" name="chkClose" onClick="javascript:closeWin();"> ���� �� �̻� �� â�� ����� �ʰڽ��ϴ�.&nbsp;&nbsp;</td>
		</tr>
	</table>
</body>

</html>

