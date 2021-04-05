<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>

<%@ include file="../raonnx/jsp/raonnx.jsp" %>
<script language='javascript'>

TouchEnNxConfig.use	=	{
		nxkey	:	false,
		nxcr	:	false,
		nxweb	:	false,
		nxfw	:	false,
		ksbiz	: 	true,
		ksbizcompulsion : false
};


function TryLogin(result){

	console.log(result);
	if(result.status==1){			
		//document.getElementById("ksbizSig").value = result.data;
	}else if(result.status==0){
		alert("인증서 선택을 취소하였습니다.");
		return;
	}else if(result.status == -10301){
		//저장매체 설치를 위해 전자서명창이 닫히는 경우
	}else if(result.status!=0){
		alert("전자서명 오류:" + result.message + "[" + result.status + "]");
		return;
	}

	document.loginform_cert.signed_data.value = result.data;
	document.loginform_cert.action = "/activity/ChangePerInfo.jsp";
	//document.loginform_cert.action = "./test02.jsp";
	document.loginform_cert.submit();
}
</script>

<form method="post" action="" name="loginform_cert">
    <input type='hidden' name='signed_data'>
</form>


