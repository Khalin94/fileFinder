<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script language="JavaScript">
<!--
//파일 첨부
function showImageFile(fileValue, showValue) {
	eval("document.frmJoinMember."+showValue+".value = document.frmJoinMember."+fileValue+".value");
}
//-->
</script>
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.gpki.ips.driver.*" %>
<%@ page import="nads.lib.reqsubmit.encode.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strUserInGrpId = "";
	String strUserOutGrpId = "";
	String strSrchRecordCnt = "";
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strCertDn = "";
	String strRetVal = "";
	boolean isAlreadyExistDn = false;

	String strJuminNo = request.getParameter("juminNo1")==null?"":request.getParameter("juminNo1") ;
	strJuminNo += request.getParameter("juminNo2")==null?"":request.getParameter("juminNo2") ;
	strCertDn = request.getParameter("CERT_DN")==null?"":request.getParameter("CERT_DN") ;//인증서 dn값.
	strRetVal = request.getParameter("retVal");//인증서 결과값

	int nStartIndex = 0;
	int nIndex = 0;
	int n = 0;
	String arg[] = new String[3];
	Base64Code objBase64Code = new Base64Code();
	int nUserResult = 0;
	int nOrganResult = 0;

	while(nIndex != -1)
	{

			nIndex = strRetVal.indexOf("|",nStartIndex);
			if(nIndex == -1){

				arg[n] = strRetVal.substring(nStartIndex,strRetVal.length());

			}else
			{

				arg[n] = strRetVal.substring(nStartIndex,nIndex);
			}

			nStartIndex = nIndex+1;
			n++;

	}



%>



<%
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	java.util.Hashtable objHshParam = new java.util.Hashtable();

	try
	{
		Config objConfig = PropertyConfig.getInstance();
		strUserInGrpId = objConfig.get("join.userInGrpId");
		strUserOutGrpId = objConfig.get("join.userOutGrpId");
		strSrchRecordCnt = objConfig.get("join.srchRecordCnt");
		strSrchDisplayKind = objConfig.get("join.srchDisplayKind");
		strGtherPeriod = objConfig.get("join.gtherPeriod");
		strReqSubmtFlag = objConfig.get("join.reqSubmtFlag4Submit");




		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();

		objHshParam.put("CERT_DN",strCertDn);
		objHshParam.put("JUMIN_NO",strJuminNo);

		if(strJuminNo.equals("") != true)
			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo(objHshParam);

		//동일한 인증서번호를 가진 사용자가 있는경우
		if(objHshReqUserInfo.get("CERT_DN") != null && objHshReqUserInfo.get("CERT_DN").toString().equals(request.getParameter("CERT_DN")) ){
			isAlreadyExistDn = true;
			objHshReqUserInfo.put("USER_ID","");
			objHshReqUserInfo.put("USER_NM","");
			objHshReqUserInfo.put("STT_CD","000");
			objHshReqUserInfo.put("JUMIN_NO","");
			objHshReqUserInfo.put("INOUT_GBN","");
			objHshReqUserInfo.put("REP_FLAG","");
			objHshReqUserInfo.put("ORGAN_NM","");
			objHshReqUserInfo.put("DEPT_NM","");
			objHshReqUserInfo.put("POSI_NM","");
			objHshReqUserInfo.put("GRD_NM","");
			objHshReqUserInfo.put("USER_DN","");
			objHshReqUserInfo.put("EMAIL","");
			objHshReqUserInfo.put("OFFICE_TEL","");
			objHshReqUserInfo.put("CPHONE","");
			objHshReqUserInfo.put("FAX_NO","");
			objHshReqUserInfo.put("POST_CD","");
			objHshReqUserInfo.put("JUSO1","");
			objHshReqUserInfo.put("JUSO2","");
			objHshReqUserInfo.put("CG_DUTY","");
			objHshReqUserInfo.put("REMARK","");
			objHshReqUserInfo.put("INOUT_GBN","I");
		}

		if(objHshReqUserInfo.isEmpty()){

			objHshReqUserInfo.put("USER_ID","");
			objHshReqUserInfo.put("USER_NM","");
			objHshReqUserInfo.put("STT_CD","000");
			objHshReqUserInfo.put("JUMIN_NO","");
			objHshReqUserInfo.put("INOUT_GBN","");
			objHshReqUserInfo.put("REP_FLAG","");
			objHshReqUserInfo.put("ORGAN_NM","");
			objHshReqUserInfo.put("DEPT_NM","");
			objHshReqUserInfo.put("POSI_NM","");
			objHshReqUserInfo.put("GRD_NM","");
			objHshReqUserInfo.put("USER_DN","");
			objHshReqUserInfo.put("EMAIL","");
			objHshReqUserInfo.put("OFFICE_TEL","");
			objHshReqUserInfo.put("CPHONE","");
			objHshReqUserInfo.put("FAX_NO","");
			objHshReqUserInfo.put("POST_CD","");
			objHshReqUserInfo.put("JUSO1","");
			objHshReqUserInfo.put("JUSO2","");
			objHshReqUserInfo.put("CG_DUTY","");
			objHshReqUserInfo.put("REMARK","");
			objHshReqUserInfo.put("INOUT_GBN","I");

		}



	}
	catch(Exception objExcept)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(objExcept.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}

%>


<!--기관확인(n==2)/본인확인(n==3) 서비스 시작-->
<%
	//arg[1] = "한국지역난방공사   ";
	if(n == 2){

		if(arg[1].trim().equals(((String)objHshReqUserInfo.get("ORGAN_NM")).trim()) != true )
			nOrganResult = 1;

		Log.debug.println("arg[1]===>"+arg[1]);
		Log.debug.println("organ_nm==>"+(String)objHshReqUserInfo.get("ORGAN_NM"));
	}else if(n > 2){
		strCertDn = new String(objBase64Code.decode(arg[2]));
		try{
			//ConfigManager con = ConfigManager.getInstance();
			IdentifyService ips = new IdentifyService();
			IdentifyServiceResult result;


			byte [] randNum = new byte[20];

			result = ips.Identify(objBase64Code.decode(arg[2]), strJuminNo, randNum);

			nUserResult = result.getResultCd();

			//사용자 정보를 초기화
			if(nUserResult != 0){
				strJuminNo = "";
			}

			Log.debug.println("Result CD :" + result.getResultCd());
			Log.debug.println("Result MSG :" + result.getResultMsg());
		}catch(Exception e)
		{
			e.printStackTrace();
			Log.debug.println(e);
		}
	}

%>
<!--확인서비스끝-->





<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<%
	//System.out.println("======>"+objHshReqUserInfo.get("STT_CD"));
	if(objHshReqUserInfo.get("STT_CD").equals("006") != true || isAlreadyExistDn == true){
%>
		<%@ include file="/join/PreJoinMemberCenter.jsp"%>
<%
	}
	else{
%>
		<%@ include file="/join/JoinMemberCenter.jsp"%>
<%
	}

%>
<%
	if(nOrganResult != 0){
		out.println("<script> alert('올바른 인증서를 선택하여 주십시요.'); history.back();</script>");
	}else if(nUserResult != 0){
		out.println("<script> alert('올바른 주민번호와 인증서를 선택하여 주십시요.'); history.back();</script>");
	}else if(objHshReqUserInfo.get("ORGAN_ID")!=null &&
	objHshReqUserInfo.get("ORGAN_ID").equals("") &&
	objHshReqUserInfo.get("STT_CD").equals("006") == true &&
	isAlreadyExistDn != true){
		out.println("<script> alert('소속부서 정보가 없습니다. 관리자에게 문의하십시요.'); document.location = '/index.html';</script>");
	}else if(isAlreadyExistDn == true){
		out.println("<script> alert('동일한 인증서를 이용하는 사용자가 존재합니다.'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("000")){
		out.println("<script> alert('사전신청을 하셔야 합니다'); </script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("001")){
		out.println("<script> alert('이미 가입하셨습니다'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("002")){
		out.println("<script> alert('사용정지상태입니다'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("003")){
		out.println("<script> alert('탈퇴 대기중입니다.'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("005")){
		out.println("<script> alert('관리자가 가입 처리를 확인 중입니다.'); document.location = '/index.html';</script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("006")){
		out.println("<script> alert('확인을 누르시면 신청이 완료됩니다'); </script>");
	}else if(objHshReqUserInfo.get("STT_CD").equals("007")){
		out.println("<script> alert('관리자가 신청을 반려하였습니다'); document.location = '/index.html';</script>");
	}

%>


</body>
</html>
<script language="javascript">

function init()
{

	// 필수입력
	define('USER_NM', 'string', '이름', 1);
	define('JUMIN_NO', 'string', '주민등록번호', 1);
	define('JUMIN_NO1', 'string', '주민등록번호', 6,6);
	define('JUMIN_NO2', 'string', '주민등록번호', 7,7);
	//define('ORGAN_NM', 'string', '기관', 1);
	//define('ORGAN_ID', 'string', '기관', 1);
	//define('DEPT_NM', 'string', '부서', 1);
	define('EMAIL', 'string', '이메일', 1);
	define('OFFICE_TEL1', 'num', '사무실전화번호', 2,3);
	define('OFFICE_TEL2', 'num', '사무실전화번호', 3,4);
	define('OFFICE_TEL3', 'num', '사무실전화번호', 4,4);
	define('FAX_NO1', 'num', '팩스번호', 2,3);
	define('FAX_NO2', 'num', '팩스번호', 3,4);
	define('FAX_NO3', 'num', '팩스번호', 4,4);
	//define('CPHONE1', 'num', '핸드폰', 3,3);
	define('CPHONE2', 'num', '핸드폰', 3,4);
	define('CPHONE3', 'num', '핸드폰', 4,4);
	define('POST_CD1', 'num', '우편번호', 3,3);
	define('POST_CD2', 'num', '우편번호', 3,3);
	define('JUSO2', 'string', '상세주소', 1);
	//define('REP_FLAG', 'string', '대표자여부', 1);


}
function checkValidation(frm)
{


	frm.POST_CD.value = frm.POST_CD1.value + frm.POST_CD2.value;
	frm.JUMIN_NO.value = frm.JUMIN_NO1.value + frm.JUMIN_NO2.value;
	frm.OFFICE_TEL.value = frm.OFFICE_TEL1.value + "-"+ frm.OFFICE_TEL2.value + "-"+ frm.OFFICE_TEL3.value;
	frm.CPHONE.value = frm.CPHONE1.value +"-"+ frm.CPHONE2.value + "-"+ frm.CPHONE3.value;
	frm.FAX_NO.value = frm.FAX_NO1.value + "-"+ frm.FAX_NO2.value + "-"+ frm.FAX_NO3.value;


	if( OnValidationSubmit() == true)
	{

		if(frm.selFile.value != ""){

			var vafile = frm.selFile.value.substr(frm.selFile.value.length - 4, frm.selFile.value.length);

			frm.PHOTO_PATH.value=frm.selFile.value.substr(frm.selFile.value.lastIndexOf("\\")+1,frm.selFile.value.length);


			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다. (." + vafile+")");
				return false;
			}

		}
		return true;
	}else{

		return false;
	}

}

function selectZipCd(varZipCd1, varZipCd2, varAddr1)
{
	var frm = document.forms[0];
	frm.POST_CD1.value = varZipCd1;
	frm.POST_CD2.value = varZipCd2;
	frm.JUSO1.value = varAddr1;
}
function selectOrgan(organId,organNm) {
	var frm = document.forms[0];
	frm.ORGAN_ID.value = organId;
	frm.ORGAN_NM.value = organNm;
}

function viewFile() {
	var frm = document.forms[0];
	var img = frm.selFile.value;


	img=img.replace(/:/, "|");
    img=img.replace(/\\/gi, "/");
	img= 'file:///' + img;


	winBG=window.open("", "", "width=200,height=190,resizable=false");
	winBG.document.open();
	winBG.document.write("<html>");
	winBG.document.write("<head></head>");
	winBG.document.write("<body background='"+img+"'></body>");
	winBG.document.write("</html>");
	winBG.document.close();
	winBG.window.focus();
}
</script>
