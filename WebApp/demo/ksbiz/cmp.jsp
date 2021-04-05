<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content = "text/html; charset=utf-8">
<meta http-equiv="Cache-control" content = "no-cache">
<meta http-equiv="Pragma" content = "no-cache">
<title>CMP</title>
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
		</style>
		<%@ include file="../../raonnx/jsp/raonnx.jsp" %>
    	<script type="text/javascript">
    		function complete(result){
    			alert(result.status + ":" + result.message);
    		}
    		function deleteCertificateComplete(result){
    			if(result.status==1){
    				alert("인증서 삭제 완료:" + result.deletedCount);	
    			}
    			else{
    				alert(result.status + ":" + result.message);	
    			}    			
    		}
    	</script>
    </head>

<body>
	<div id="wrapper" style="width:100%;">
	<div id="header" style="background-image:url('images/bg_head.gif');width:100%; height:43px;">
	<img src="images/logo_head.gif" width="187" height="43" style="float:right;"/>
	
	</div>
	<div style="background-color:#eaebec; padding:0;">
	<img src="images/img_top_main01.gif" width="234" height="264" style="float:left;"/><img src="images/img_top_main02.gif"/>
	</div>
	
	<div style="padding:30px 240px" >
		<h3>CMP</h3>
		<a href="https://www.yessign.or.kr/testcert/index.jsp" target="_new">금결원 참조번호/인가코드 발급</a>
		<br><br>
		<form name="form">
			참조번호 : <input type="text" name="referenceValue" value="10995"><br/><br/>
			인가코드 : <input type="text" name="secretValue" value="q350767867U3715039q"><br/><br/>
		</form>
		<button onclick="KeySharpBiz.requestCertificate('yessign', document.form.referenceValue.value, document.form.secretValue.value,complete, {certStoreFilter:'LOCAL_DISK|REMOVABLE_DISK|HSM|USIM'})"> 
		금결원 인증서 발급</button>
		<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.updateCertificate('yessign', complete, {certStoreFilter:'LOCAL_DISK|REMOVABLE_DISK|HSM|USIM'})"> 
		금결원 인증서 갱신</button>
		<br/><br/>
		
		<button onclick="KeySharpBiz.requestCertificate('crosscert', document.form.referenceValue.value, document.form.secretValue.value,complete)"> 
		전자인증 인증서 발급</button>
		<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.updateCertificate('crosscert', complete)"> 
		전자인증 인증서 갱신</button>
		
		<br/><br/>
		<button onclick="KeySharpBiz.requestCertificate('signkorea', document.form.referenceValue.value, document.form.secretValue.value, complete)"> 
		증권 전산 인증서 발급</button>
		<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.updateCertificate('signkorea', complete)"> 
		증권 전산 인증서 갱신</button>
		
		<br/><br/>
		<button onclick="KeySharpBiz.requestCertificate('kica', document.form.referenceValue.value, document.form.secretValue.value, complete)"> 
		정보인증 인증서 발급</button>
		<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.updateCertificate('kica', complete)"> 
		정보인증 인증서 갱신</button>
		<br/><br/>
		<button onclick="KeySharpBiz.requestCertificate('kica', document.form.referenceValue.value, document.form.secretValue.value, complete, {recovery:true})"> 
		정보인증 인증서 재발급</button>
				
		<br/><br/>
		<h3>certStoreFilter 설정안함</h3>
		<button onclick="KeySharpBiz.requestCertificate('yessign', document.form.referenceValue.value, document.form.secretValue.value,complete)"> 
		금결원 인증서 발급</button>
		<button onclick="KeySharpBiz.resetCertificate();KeySharpBiz.updateCertificate('yessign', complete)"> 
		금결원 인증서 갱신</button>
		<br/><br/>
		
		<h3>인증서 삭제</h3>
		<form name="form2">
			subjectDN:<input name="subjectDN" style="width:400px"></input>
		</form>		
		<button onclick="KeySharpBiz.deleteCertificate(document.form2.subjectDN.value, deleteCertificateComplete)">인증서 삭제</button>
	</div>
	<div id="footer" style="width:96%; margin-left:auto; margin-right:auto  "><div style="border-top:1px solid #eaebec;width:100%;"></div><img src="images/logo_foot.gif" width="174" height="49" style="float:right;"/></div>
	</div>
	</body>
</html>