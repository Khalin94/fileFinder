<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
	<meta http-equiv="Cache-control" content = "no-cache">
	<meta http-equiv="Pragma" content = "no-cache">
	<title>KeySharpBiz2.1 Demo</title>
	<style type="text/css">
		body,td,th {
			font-family: "돋움";
			font-size: 12px;
		}
		body {
			margin-left: 0px;
			margin-top: 0px;
			margin-right: 0px;
		}
		table {
			border: 1px solid #444444;
			border-collapse: collapse;
			table-layout: fixed;
			word-break:break-all;			
		}
		th, td{
			border: 1px solid #444444;
			padding: 10px;
			line-height:150%;
		}
		th{			
			background-color: #dddddd;
		}
		span{
			color: red;
		}
	</style>	
	<%@ include file="../../raonnx/jsp/raonnx.jsp" %>
	<script type='text/javascript'>		
		// 요청할 서버 주소
		var demoEncUrl = "./testChannelEncryptAction.jsp";
		
		// 값 암/복호화
		function demoTest1(){
			var data = document.getElementById("name0").value;
			document.getElementById("clientPlain").innerHTML = data;
			// KeySharpBiz.symEncrypt({"data":data}, complete_encrypt);
			KeySharpBiz.channelEncrypt({"data":data}, complete_encrypt);
		}

		// 폼 암/복호화
		function demoTest2(){
			var data = nxBizFormSerialize(document.getElementById("inputform"));
			document.getElementById("clientPlain").innerHTML = data;
			//KeySharpBiz.symEncrypt(inputform, complete_encrypt);
			//KeySharpBiz.symEncrypt({"data":data}, complete_encrypt);
			KeySharpBiz.channelEncrypt(inputform, complete_encrypt);
		}
		
		function complete_channelInit(result){
			if(result.status==1){
				alert("키교환 성공");
			}
			else if(result.status!=0){
				alert("암호화 실패:" + result.message + ":" + result.status);
			}
		}
		
		function complete_encrypt(result){
			if(result.status==1){
				var clientCT = result.data;
				document.getElementById("clientCT").innerHTML = clientCT;
				
				var keyValue = "msg=" + encodeURIComponent(clientCT);
				DC_get(demoEncUrl, keyValue, function(serverCT){
					if(serverCT){
						document.getElementById("serverCT").innerHTML = serverCT;
						if(!serverCT.startsWith("-")){
							//var decData = KeySharpBiz.symDecrypt(serverCT, function(plain){
							var decData = KeySharpBiz.channelDecryptAsync(serverCT, function(plain){
								if(plain.status == 1){
									document.getElementById("serverPlain").innerHTML = plain.data;
								} else {
									alert("복호화 실패: " + plain.message + ":" + plain.status);
								}
							}); // 복호화 API 사용
						} else {
							alert("서버 에러: " + serverCT);
						}
					} else {
						alert("서버 에러: serverCT not exist");
					}
				});
			} else if(result.status!=0){
				alert("암호화 실패: " + result.message + ":" + result.status);
			}
		}
	</script>
</head>
<body leftmargin="0" topmargin="0">

	<div id="wrapper" style="width:100%;padding:30px 70px;">
		<h1>암호화 테스트</h1>
		<br/>
		<br/> <b>현재 진행 상황, 20171101</b>
		<br/> 1. Client 스크립트 Dump 데이터 : ClientRandom, ClientKeyExchange|ClientFinished
		<br/> 2. Server 모듈 Fix 데이터 : ServerRandom, server_public_key, server_private_key
		<br/> ※ <u>optional 메시지들은 현재 작업 중이므로, required 메시지에 대해서만  테스트 가능합니다.</u>
		<br/> ※ <u>optional 메시지 : CertificateRequest, (Client)Certificate, CertificateVerify</u>
		<br/>
		<br/> <b>통신 관계</b>
		<br/> 1. 키 교환 채널 : channelEncrypt.jsp &lt;-> ksbiz_server.jsp
		<br/> 2. 구간 암호화 채널 : channelEncrypt.jsp &lt;-> channelEncryptAction.jsp
		<br/>
		
		<table>
			<!--
			<tr>
				<th>키 교환 채널</th>
				<td>
					<button onclick="KeySharpBiz.channelInit(complete_channelInit);">키 교환</button>
				</td>
			</tr>
			-->
			<tr>
				<th>구간 암호화 채널</th>
				<td>
					<div style="background-color:#dddddd; padding:5px;">
						<button onclick="demoTest1();">값 암호화 후 전송</button><br/>
						데이터 : <input type="text" id="name0" name="name0" value="abcd가나다라"/><br/>						
					</div><br/>
					<div style="background-color:#dddddd; padding:5px;">
						<button onclick="demoTest2()">폼 암호화 후 전송</button><br/>
						<form id="inputform" name="inputform" method="post">
							데이터 1 : <input type="text" id="name1" name="name1" value="abcd"/><br/>
							데이터 2 : <input type="text" id="name2" name="name2" value="가나다라"/><br/>
						</form>
					</div><br/>

					(클라이언트에서 전달하는)<br/>
					평문 데이터 : <span id="clientPlain"></span><br/><br/>
					(클라이언트에서 암호화한)<br/>
					암호화 데이터 : <span id="clientCT"></span><br/><br/>
					(서버로부터 전달받은)<br/>
					암호화 데이터 : <span id="serverCT"></span><br/><br/>
					(클라이언트에서 복호화한)<br/>
					평문 데이터 : <span id="serverPlain"></span>
				</td>
			</tr>
			<!--<tr>
				<th>키교환+암호화+전송</th>
				<td>
					<button onclick="KeySharpBiz.channelEncrypt(name0.value);">키교환 + 값암호화 후 전송</button>
					<button onclick="KeySharpBiz.channelEncrypt(inputform);">키교환 + 폼암호화 후 전송</button>
				</td>
			</tr>-->
		</table>	
		
	</div>
</body>
</html>