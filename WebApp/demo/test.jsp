<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!-- raonsecure TouchEnKey Create session Random -->
<%@ include file="../raonnx/jsp/raonnx.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<title></title>


<script type="text/javascript" src="/raonnx/jquery/jquery-1.6.3.js"></script>

</head>

<body>
�ѱ��ʵ�� ���ȿ����� �ƴմϴ�.<br/>
�� ���������� Client ���� �԰ݼ��� ����ٶ��ϴ�.<br/>

<form id="frm" name="frm" method="post" action="result.jsp">
	<h1>�⺻ ����</h1>
	<b>E2E����</b><br/>
	txt1 : <input type="text" maxlength="14" id="txt1" name="txt1" data-enc="on" data-dataType="an" />����/���� �Է�<br/> 
	txt2 : <input type="text" maxlength="20" id="txt2" name="txt2" data-enc="on" data-dataType="n" /> ���� �Է� <br/>
	pwd1 : <input type="password" maxlength="4" id="pwd1" name="pwd1" data-enc="on" data-dataType="n" />���� �Է�<br/> 
	pwd2 : <input type="password"  maxlength="12" id="pwd2" name="pwd2" data-enc="on" />��� ���� �Է�<br/> <br/>
	<br><br/>
	
	<input type="submit" id="btn_submit" name="btn_submit" value="submit"></input>
</form>
</body>
</html>
