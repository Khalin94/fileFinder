<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>

<title>의정자료 전자유통 시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

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
<%@ page import="import nads.lib.reqsubmit.encode.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%@ page import="java.security.cert.*" %>
<%@ page import="java.security.spec.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javak.crypto.*" %>
<%@ page import="javak.crypto.spec.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.gpki.gpkiapi_jni" %>

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



System.out.println("strRetVal===>"+strRetVal);
System.out.println("==================>"+strCertDn);


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








	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
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



		





		



		//objHshParam.put("CERT_DN",strCertDn);
		//objHshParam.put("JUMIN_NO",strJuminNo);











		if(strJuminNo.equals("") != true)
		{
			System.out.println("juminno:"+strJuminNo);
			if(strCertDn.indexOf("Government") != -1){
				objHshParam.put("CERT_DN",strCertDn);
				objHshParam.put("JUMIN_NO",strJuminNo);
			}else{
				 objHshParam.put("CERT_DN","");
				 objHshParam.put("JUMIN_NO",strJuminNo);
			}
			objHshReqUserInfo = objJoinMemberDelegate.getUserInfo(objHshParam);
		}





		//동일한 인증서번호를 가진 사용자가 있는경우	 strCertDn 


		System.out.println("CERT_DN  >>>>"+strCertDn.indexOf("Government"));


		if(objHshReqUserInfo.get("CERT_DN") != null && objHshReqUserInfo.get("CERT_DN").toString().equals(request.getParameter("CERT_DN"))){

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
		String strOrganNo =  objHshReqUserInfo.get("ORGAN_NO") != null ?  (String)objHshReqUserInfo.get("ORGAN_NO"):"";
		String strOfficeSsn = StringUtil.getNVLNULL(request.getParameter("office_ssn"));
		String strCertType = StringUtil.getNVLNULL(request.getParameter("cert_type"));
		String strOrganNm = StringUtil.getNVLNULL((String)objHshReqUserInfo.get("ORGAN_NM")).trim() ;



	//arg[0] = "cn=한국중부발전(관리부)11111,ou=naps,o=NCASign,c=KR   ";		
	System.out.println("JoinMember.jsp n ==>"+n);
	System.out.println("input param.cert_type:"+strCertType);
	System.out.println("tbdm_organ.organ_no:"+strOrganNo);
	System.out.println("input param.office_ssn:"+strOfficeSsn);
	System.out.println("STT_CD : "+objHshReqUserInfo.get("STT_CD"));    

	System.out.println("isAlreadyExistDn   :"+isAlreadyExistDn);
	System.out.println("strOrganNm1 : "+strOrganNm);
	if( isAlreadyExistDn != true && objHshReqUserInfo.get("STT_CD").equals("006") == true ){
		if("1".equals(strCertType)  && "".equals(strOrganNo) != true && strOrganNo.equals(strOfficeSsn) != true ){
			nOrganResult =1; 
		}
				
		System.out.println("여기오면 중복체크안한다 ...");

		//2004.08.09 수정. 사법부 인증서본인확인서비스 하지 않도록 수정.
	}else if(arg[0].indexOf("대법원") != -1 || arg[0].indexOf("테스트기관") != -1){
		//isAlreadyExistDn = false;
		nOrganResult = 0;
		nUserResult = 0;	
	}else if(n == 2 ){
		System.out.println("여기들어와야지??");
		while(true){
			if( strOrganNm.lastIndexOf("(") > 0 &&	strOrganNm.endsWith(")") == true){
				strOrganNm = strOrganNm.substring(0,strOrganNm.lastIndexOf("("));
				System.out.println("strOrganNm2 : "+strOrganNm);
			}else{
				break;
			}				
		}
		//if(arg[1].trim().equals(   strOrganNm      )     != true )
		System.out.println("strOrganNm2 : "+strOrganNm);
		if(arg[0].indexOf(strOrganNm) == -1 && "1".equals(strCertType) != true){
			nOrganResult = 1;
		}
			

		if(arg[0].indexOf("naps") == -1){
			nOrganResult = 2;		
		}
	   
		int resultIntUser = 0;
		if(strCertDn.indexOf("Government") != -1){
			  resultIntUser = objJoinMemberDelegate.comfirmDnUser(strCertDn);
			  if(resultIntUser > 0){
				nOrganResult = 4;
			  }
		}else{
			
		}
		System.out.println("arg[0].indexOf(strOrganNm)===>"+arg[0].indexOf(strOrganNm));
		System.out.println("arg[0]===>"+arg[0]);
		System.out.println("arg[1]===>"+arg[1]);
		System.out.println("organ_nm==>"+strOrganNm);

	}else if(n > 2){
/* 새롭게 추가된 부분*/
		strCertDn = arg[0]; // 인증서 DN
		String szSSN = arg[1]; // VID 검증을 위한 주민번호
		String szCert = arg[2]; // Base64 인증서 

		String sPath_ServerCert        = "/app/weblogic/bea/user_projects/NADS/dist/EXTEND/Solution/gpki/SVR9710000001_sig.cer"; // GPKI 기관용 서버 인증서
//		String sPath_ServerCert        = "/app/weblogic/bea/user_projects/NADS/dist/EXTEND/Solution/gpki/MyCert.der"; 
		String sPath_ConfFile        = "/app/weblogic/bea/user_projects/NADS/dist/EXTEND/Solution/gpki/conf/gpkiapi.conf"; // 인증서 환경파일

		//out.println("SignedData Input : " + tempEncode +"<BR>");
		System.out.println("SignedData Input : strCertDn -> " + strCertDn);
		System.out.println("SignedData Input : szSSN -> " + szSSN);
		System.out.println("SignedData Input : szCert -> " + szCert);
		boolean isVerify = false;

		try
		{
			gpkiapi_jni gpkiapi =  new gpkiapi_jni();

			int nRv = -1, vRv = -1;
			int rand = -1, gPk = -1;
			byte[] baCert = null, baMyCert = null;
			byte[] baPriKey = null;
			byte[] baRandom =null;
	
			//out.println("GPKI 인증서 검증"+"<BR>");  
				
			// GPKI 디렉토리 경로
			gpkiapi.API_Init("c:/GPKI");

		    // 통합검증 API 에 검증요청 할 수 있는 인증서 읽기
			nRv = gpkiapi.STORAGE_ReadCert(gpkiapi.MEDIA_TYPE_FILE_PATH, sPath_ServerCert, gpkiapi.DATA_TYPE_OTHER);
			if (nRv != 0)
			{
				nUserResult = 1;
				System.out.println("[통합검증 API 에 검증요청 할 수 있는 인증서 읽기] 저장매체에서 GPKI 인증서를 읽는데 실패");
				out.println("[통합검증 API 에 검증요청 할 수 있는 인증서 읽기] 저장매체에서 GPKI 인증서를 읽는데 실패 : "+"<BR>");
			}
			else
			{

				baMyCert = gpkiapi.baReturnArray; //서버 인증서

				// 사용자 인증서 Base64 디코딩 
				nRv =	gpkiapi.BASE64_Decode(szCert);
				if (nRv != 0)
				{
					nUserResult = 1;
					System.out.println("[사용자 인증서 Base64 디코딩] 인증서를 디코딩 하는데 실패 : "+"<BR>");
					out.println("[사용자 인증서 Base64 디코딩] 인증서를 디코딩 하는데 실패 : "+"<BR>");
				}
				else
				{

					baCert = gpkiapi.baReturnArray; //사용자 인증서

					// 통합검증서버를 통하여 인증서를 검증한다.
					nRv = gpkiapi.CERT_VerifyByIVS(sPath_ConfFile, baCert , baMyCert);
					if (nRv != 0)
					{
						nUserResult = 1;
						System.out.println("통합검증서버를 통하여 인증서 유효성을 검증하는데 실패 : "+gpkiapi.sReturnString);
						out.println("통합검증서버를 통하여 인증서 유효성을 검증하는데 실패 : "+gpkiapi.sReturnString+"<BR>");
					}
					else
					{

						//out.println("GPKI 인증서 검증 성공");
						//out.println("GPKI 인증서 본인 확인 검증"+"<BR>");

						// 랜덤값과 사용자 식별번호를 이용하여 인증서의 VID값을 검증한다.
						vRv = gpkiapi.VID_VerifyByIVS(sPath_ConfFile, baCert , baRandom, szSSN ,baMyCert);
						if (vRv != 0) 
						{
							nUserResult = 1;
							System.out.println("[랜덤값과 사용자 식별번호를 이용하여 인증서의 VID값을 검증] GPKI Vid를 검증하는데 실패 : "+gpkiapi.sReturnString);
							out.println("[랜덤값과 사용자 식별번호를 이용하여 인증서의 VID값을 검증] GPKI Vid를 검증하는데 실패 : "+gpkiapi.sReturnString+"<BR>");
						}
						else
						{
							nUserResult = 0;
							//out.println("Vid를 검증하는데 성공 : "+vRv+"<BR>");
						}

					}
				}
			}

			if (gpkiapi != null)
				gpkiapi.API_Finish();


			//사용자 정보를 초기화
			if(nUserResult != 0)
				strJuminNo = "";

		}catch(Exception e){
			e.printStackTrace();
			System.out.println(e);
		}

/* 양재경 수정 2005.02.22
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

	

			System.out.println("Result CD :" + result.getResultCd());

			System.out.println("Result MSG :" + result.getResultMsg());

		}catch(Exception e)

		{

			e.printStackTrace();

			System.out.println(e);

		}
*/

	}


	if(arg[0].indexOf("NCASign") != -1 )
	{
		if(arg[0].indexOf("naps") ==-1)
			nOrganResult=2;

	}

	if(strCertDn.indexOf("personal") != -1 && strCertDn.indexOf("yessign") != -1){
		nOrganResult = 100;
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

	if(nOrganResult == 1){

		out.println("<script> alert('시스템의 기관명과 인증서의 기관명이 다릅니다. 관리자에게 문의하여주십시요.'); history.back();</script>");	

	}else if(nOrganResult == 2){

		out.println("<script> alert('한국전산원에서 발급하는 특수목적용(국회) 공인인증서가 아닙니다. 올바른 인증서를 선택하여 주십시요.'); history.back();</script>");	

	}else if(nOrganResult == 4){

		out.println("<script> alert('중복된 인증서가 있습니다. 관리자에게 문의하여주십시오.'); history.back();</script>");	

	}else if(nUserResult != 0){
		if(isAlreadyExistDn == true){
			out.println("<script> alert('이미 가입하셨습니다. 로그인하셔서 사용하십시요.'); document.location = '/index.html';</script>");
		}else if(objHshReqUserInfo.get("STT_CD").equals("001")){		
			out.println("<script> alert('이미 가입하셨습니다. 로그인하셔서 사용하십시요.'); document.location = '/index.html';</script>");
		}else{
			out.println("<script> alert('올바른 주민번호와 인증서를 선택하여 주십시요.'); history.back();</script>");	
		}
	}else if(nOrganResult == 100){

		out.println("<script> alert('공인인증기관의 법인용인증서가 아닙니다. 올바른 인증서를 선택하여 주십시요.'); history.back();</script>");	

	}else if(objHshReqUserInfo.get("ORGAN_ID")!=null &&

	objHshReqUserInfo.get("ORGAN_ID").equals("") &&

	objHshReqUserInfo.get("STT_CD").equals("006") == true &&

	isAlreadyExistDn != true){

		out.println("<script> alert('소속부서 정보가 없습니다. 관리자에게 문의하십시요.'); document.location = '/index.html';</script>");	

	}else if(isAlreadyExistDn == true){

		out.println("<script> alert('이미 가입하셨습니다. 로그인하셔서 사용하십시요.'); document.location = '/index.html';</script>");	

	}else if(objHshReqUserInfo.get("STT_CD").equals("000")){

		out.println("<script> alert('로그인 화면에서 [사용자 등록 신청]을 하셔야 합니다.'); document.location = '/join/UserCheck4Req.jsp';</script></script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("001")){
		System.out.println("STT_CD : 001"+objHshReqUserInfo.get("STT_CD"));
		out.println("<script> alert('이미 가입하셨습니다. 로그인하셔서 사용하십시요.'); document.location = '/index.html';</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("002")){

		out.println("<script> alert('사용정지상태입니다. 관리자에게 문의하십시요.'); document.location = '/index.html';</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("003")){

		out.println("<script> alert('탈퇴 대기중입니다. 관리자에게 문의하십시요.'); document.location = '/index.html';</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("005")){

		out.println("<script> var retVal = confirm('관리자가 등록 처리를 확인 중입니다. 가입정보를 보시겠습니까?');  if(retVal == false) document.location = '/index.html'; else document.location = '/join/PrintUserInfoCenter.jsp?juminNo="+strJuminNo+"'</script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("006")){

		out.println("<script> alert('화면 하단의 완료버튼을 누르시면 등록이 완료됩니다'); </script>");

	}else if(objHshReqUserInfo.get("STT_CD").equals("007")){

		out.println("<script> alert('관리자가 신청을 반려하였습니다. 관리자에게 문의하십시요.'); document.location = '/index.html';</script>");

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

				alert("사진파일은 확장명이 .gif, jpg .jpeg .bmp 만 등록할 수 있습니다. (." + vafile+")");

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
