<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%
	String strFlag = request.getParameter("flag")==null?"":request.getParameter("flag");
	String strPassword = request.getParameter("pwd")==null?"":request.getParameter("pwd");
	String strUsrID = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	strPassword = strPassword.trim();
	strUsrID = strUsrID.trim();


%>

<html>
<head>
<script language="javascript">
	function check(){
		var val = formName.testval;
		
		alert(val.value);

		var pattern = /^["&"]$/;

		 if(!pattern.test(val.value)) {
			alert("��ã�� : " + val.value);
		 }else{
			var aaa = val.value;
//			var t.value = aaa.replace(pattern, "");
//			alert("���������� : " + t.value);
		 }

		/*
		if(formName.user_id.value==""){
			alert("ID�� �Է��� �ּ���.");
			formName.id.focus();
			return false;
		}
		if(formName.pwd.value == "") {
			alert("��й�ȣ�� �Է��� �ּ���");
			formName.pwd.focus();
			return;
		}
		*/
		//formName.submit();
	}
</script>
</head>
<%
	if(strFlag.equals("OK")&&strPassword.equals("naps337")){
%>
	�䱸�� :�ǿ��� �ۼ��� �䱸������ ���� <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=1&USERID=<%=strUsrID%>">GO</a><br>
	�䱸�� :����ȸ �߼ۿϷ� �䱸������ ���� <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=2&USERID=<%=strUsrID%>">GO</a><br>
	������ :�ǿ���  �䱸������ ���� <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=3&USERID=<%=strUsrID%>">GO</a><br>
	<a href="./testindex.jsp?Off=OFF">�α���ȭ������ ....</a>
<%
	}else{
%>
	<body onLoad="formName.user_id.focus()">
	<form name="formName" action="testindex.jsp">
	�䱸�� - ����01 : 0000039859<br>
	������ - ����08 : 0000039930<br>

	ID:<input type="text" name="user_id" value="0000039859"><br>
	PWD : <input type="password" name="pwd" value="naps337"><BR>
	<input type="hidden" name="flag" value="OK"><br>
	<!--input type="text" name="testval" value="��#9646;�׸� ������ڡ� �� ���ۼ��ڡ� ���"-->
	<input type="text" name="testval" value="123&#">
	<input type="button" onClick="check()" value="�α����ؾ���..">
	</form><br>
	</body>
<%
	}	
%>
</html>
