<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
<meta http-equiv="Cache-control" content = "no-cache">
<meta http-equiv="Pragma" content = "no-cache">
<title>KeySharpBiz2.1 Demo</title>
<%@ include file="../../raonnx/jsp/raonnx.jsp" %>
</head>
<body>
	<h1>전자봉투 파일 복호화 테스트</h1>	
	<h4>서버 암호화 파일 복호화</h4>
	<form name="input">
		<input type="text" name="inFile" value="D:\temp\server.fenv"><br/>
		<input type="text" name="outFile" value="D:\temp\server.fenv.dec"><br/>
	</form>
	<button onclick="KeySharpBiz.channelDecryptFile(document.input.inFile.value, document.input.outFile.value, complete)">복호화</button><br/>
	
	<script>
	
	function complete(result){		
		if(result.status==1){
			alert("복호화 성공:" + result.fileName);
		}
		else if(result.status!=0){
			alert("복호화 실패:" + result.message + ":" + result.status);
		}
	}
	</script>
</body>
</html>
