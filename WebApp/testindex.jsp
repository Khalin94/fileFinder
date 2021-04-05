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
			alert("못찾음 : " + val.value);
		 }else{
			var aaa = val.value;
//			var t.value = aaa.replace(pattern, "");
//			alert("문자제거함 : " + t.value);
		 }

		/*
		if(formName.user_id.value==""){
			alert("ID를 입력해 주세요.");
			formName.id.focus();
			return false;
		}
		if(formName.pwd.value == "") {
			alert("비밀번호를 입력해 주세요");
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
	요구자 :의원실 작성중 요구함으로 가기 <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=1&USERID=<%=strUsrID%>">GO</a><br>
	요구자 :위원회 발송완료 요구함으로 가기 <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=2&USERID=<%=strUsrID%>">GO</a><br>
	제출자 :의원실  요구함으로 가기 <a href="http://172.16.47.178/reqsubmit/pass.jsp?FLAG=3&USERID=<%=strUsrID%>">GO</a><br>
	<a href="./testindex.jsp?Off=OFF">로그인화면으로 ....</a>
<%
	}else{
%>
	<body onLoad="formName.user_id.focus()">
	<form name="formName" action="testindex.jsp">
	요구자 - 의정01 : 0000039859<br>
	제출자 - 교육08 : 0000039930<br>

	ID:<input type="text" name="user_id" value="0000039859"><br>
	PWD : <input type="password" name="pwd" value="naps337"><BR>
	<input type="hidden" name="flag" value="OK"><br>
	<!--input type="text" name="testval" value="＆#9646;항목별 ‘담당자’ 및 ‘작성자’ 명기"-->
	<input type="text" name="testval" value="123&#">
	<input type="button" onClick="check()" value="로그인해야지..">
	</form><br>
	</body>
<%
	}	
%>
</html>
