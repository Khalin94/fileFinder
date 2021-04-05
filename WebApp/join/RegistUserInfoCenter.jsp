<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.join.*"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.encode.*"%>
<%@ page import="ksign.jce.util.*"%>
<%@ page import="ksign.jce.sample.*"%>
<%@ page import="java.io.*"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<%
	String regsid1 = "";

	String in_symm_enckey = "";
	String in_regsid1 = "";
	String in_regsid2 = "";

	byte[] bt_regsid1 = null;
	byte[] bt_regsid2 = null;

	String regsid2 = "";
	String resid_no = "";
	String strresid_no = "";
	String safeon_regsid1 = "";
	String safeon_regsid2 = "";
	//String EncData = null;

	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strJuminNoTemp = "";
	
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();
	
	Hashtable objorgandata = null;

	//EncData = ((String)java.net.URLDecoder.decode(StringUtil.getNVLNULL(request.getParameter("issacweb_data")),"KSC5601")).replaceAll(" ","+");
	
	ResultSetSingleHelper objRS = null;



	in_symm_enckey = request.getParameter("symm_enckey");
	in_regsid1 = request.getParameter("regsid1");
	in_regsid2 = request.getParameter("regsid2");

	besoft.safeon.assembly.SafeonCryptModule scm = new besoft.safeon.assembly.SafeonCryptModule(request);
	safeon_regsid1 = scm.decrypt( request.getParameter("_E2E_SAFEON_regsid1") );
	safeon_regsid2 = scm.decrypt( request.getParameter("_E2E_SAFEON_regsid2") );

	if(safeon_regsid1.indexOf("DecryptError") == -1 && safeon_regsid2.indexOf("DecryptError") == -1 ){
		resid_no = safeon_regsid1 + safeon_regsid2;
		regsid1 = safeon_regsid1;
		regsid2 = safeon_regsid2;
		System.out.println("besoft");
	}else{
		if (in_symm_enckey != null){
			System.out.println("ksign");
			///////////////////////////////////////////////////// START

			System.out.println("암호화된 키값  : " + in_symm_enckey );
			System.out.println("in_regsid1 : " + in_regsid1 );
			System.out.println("in_regsid2 : " + in_regsid2 );
			System.out.println("------------------------------------------------------------------------------<BR>");

			JCEUtil.initProvider();
			try {

				AsymmDecrypt asymmDecryt = new AsymmDecrypt();
				SymmDecrypt symmdecrypt = new SymmDecrypt();
	  
				//위에서 부터
				//서버 인증서 경로 로컬의 경우 아래 처럼 , LDAP의 경우 해당 LDAP을 
				//해당하는 암호하고
				//서버인증서의 키값
				String priPath = "/usr/libgpkiapi_jni";
				String passwd = "dlswmdrhksfl11!";	
				String sendKey = "SVR9710000001_env.key"; //서버인증서 키값  
				String licPath = "/usr/libgpkiapi_jni/conf";

				//비대칭키 복호화
				//파라매터로는 (암호화 값, 인증서 패스워드, 인증서 경로 또는 LDAP, 서버인증서의 키)
				String key = asymmDecryt.AsymmDecrypt(in_symm_enckey, passwd, priPath, sendKey, licPath);

				if(key == null){
					System.out.println("에러 메시지 : " + JCEUtil.getErrormsg());
					System.out.println("에러 코드 : " + JCEUtil.getErrorcode());
				}

				//암호화된 문장을 원문으로 복호화
				//파라메터로는(암호화된 값, )
				//byte[] bt_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//세션키로 원문 복호화
				bt_regsid1 = symmdecrypt.SymmDecrypt(in_regsid1, key, "SEED");//세션키로 원문 복호화
				//byte[] bt_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");
				bt_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");

				regsid1 = new String(bt_regsid1);
				regsid2 = new String(bt_regsid2);

				System.out.println("복원한 키값 : " + key );
				System.out.println("in_regsid1 : " + regsid1 );
				System.out.println("in_regsid2 : "	+ regsid2 );

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println(e.toString());
				System.out.println("error1 :  " + e.toString());
				System.out.println("error2 : " + JCEUtil.getErrormsg());
				System.out.println("error3 : " + JCEUtil.getErrorcode());
			}
			
		  resid_no = (new String(bt_regsid1)) + (new String(bt_regsid2));

			//System.out.println( request.getParameter("_E2E_SAFEON_regsid1") );
			//System.out.println( request.getParameter("_E2E_SAFEON_regsid2") );
			//System.out.println( "safeon1 : " + regsid1 ); 
			//System.out.println( ",safeon2 : " + regsid2 ); 
			//가상키보드 safeon 복호 끝   

			System.out.println("resid_no :: "  + resid_no);
			

		}else{
			Base64Code objBase64Code = new Base64Code();
			resid_no = StringUtil.getNVLNULL(request.getParameter("resid_no"));	
			resid_no  = new String(objBase64Code.decode(resid_no));
		}
			///////////////////////////////////////////////////// END
	}

	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	java.util.Hashtable objHshParam = new java.util.Hashtable();
	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();

	objHshParam.put("JUMIN_NO",resid_no);
	if(resid_no.equals("") != true)
		objHshReqUserInfo = objJoinMemberDelegate.getUserInfo(objHshParam);
	if(objHshReqUserInfo.get("STT_CD").equals("005") != true){
		response.sendRedirect("/index.html");		
	}
	try
	{			
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();

		Config objConfig = PropertyConfig.getInstance();
		strUserInGrpId = objConfig.get("join.userInGrpId");
		strUserOutGrpId = objConfig.get("join.userOutGrpId");
		strSrchRecordCnt = objConfig.get("join.srchRecordCnt");  
		strSrchDisplayKind = objConfig.get("join.srchDisplayKind");
		strGtherPeriod = objConfig.get("join.gtherPeriod");  
		strReqSubmtFlag = objConfig.get("join.reqSubmtFlag4Submit"); 			
	}
	catch(AppException objAppEx)
	{	
		
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}	

%>

<%
	String webPath = ""; //이미지 저장할 물리적 경로
	String imgPath = ""; //포럼이미지 경로
	String strImgPath="";



	String strInOutGbn = StringUtil.getNVLNULL((String)objHshReqUserInfo.get("INOUT_GBN"));
	String strOrganTitle = strInOutGbn.equals("I") == true? "부서명":"기관명";
	String strUserGrpId = strInOutGbn.equals("I") == true? strUserInGrpId:strUserOutGrpId;
	


	
	try {
	
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티

		webPath = objConfig.get("nads.dsdm.url");
		imgPath = objConfig.get("user.photo.path");
		strImgPath = webPath + imgPath;

	} catch (ConfigException objConfigEx) {
		
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<!-- 담당업무구분시작 -->
<%	
	

	String strError = "no";	
	String strUserId = (String)objHshReqUserInfo.get("USER_ID");
	try
	{
		
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserId);		
		
	}
	catch(AppException objAppEx)
	{	
		
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>

<html>
<head>
<title>의정자료전자유통시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
<meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
<script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
<script type="text/javascript" src="/js2/common.js"></script>
<link type="text/css" href="/css2/style.css" rel="stylesheet">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
<script src="/js/activity.js"></script>
<script language="javascript">
function fun_check(varObj){
	var varCheck ='';
	if(varObj.checked == true){
		
		varCheck = 'document.frmJoinMember.s' + varObj.name.substring(1, varObj.name.length)
							  + '.disabled = true';
	}else{
		varCheck = 'document.frmJoinMember.s' + varObj.name.substring(1, varObj.name.length)
							  + '.disabled = false';
		
	}
	eval(varCheck);		 
}

function fun_checkm(varObj){
	var varCheck ='';
	if(varObj.checked == true){
		varCheck = 'document.frmJoinMember.m' + varObj.name.substring(1, varObj.name.length)
							  + '.disabled = true';
	}else{
		varCheck = 'document.frmJoinMember.m' + varObj.name.substring(1, varObj.name.length)
							  + '.disabled = false';
		
	}
	eval(varCheck);		 
}

function makeTextBox(chbox,divNm)
{
 eval(divNm).innerHTML = "";

 if(chbox.checked == true)
	eval(divNm).innerHTML = "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
 else
	 eval(divNm).visibility="hidden";
 

}


function printUserInfo(type){

if(type == "Y")
	winopen('/join/PrintUserInfo4Cert.jsp','PrintUserInfo','height=550,width=658,scrollbars=yes,resize=yes');
else
	winopen('/join/PrintUserInfo.jsp','PrintUserInfo','height=550,width=650,scrollbars=yes,resize=yes');

}

</script>


<!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie6.css" media="screen" />
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" href="/css2/ie7.css" media="screen" />
<![endif]-->
<style>
#log_wrap {
	width:100%;
	height:100%;
}

.login {
	width:745px;
	overflow:hidden;
	margin-top:3%;
	margin-left:22%;
}

.login h1 {
	width:685px;
	overflow:hidden;
}

.user_con {
}

#log_footer {
	width:100%;
	overflow:hidden;
	margin-top:10px;
	margin-bottom:20px; 
}

#log_footer .copy {
	display:block;
	width:100%;
	padding-left:30%;
	border-top:#ccc solid 1px;
	padding-top:10px;
}
</style>
</head>

<body>
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <!-- list --> 
			<form action="/join/RegistUserInfoInPutProc.jsp" method="post" name="frmJoinMember" encType="multipart/form-data" onsubmit="return checkUserCharge(document.frmPreJoinMember)">
            <span class="list02_tl">사용자 정보 입력</span> <span class="list_total">(*) 표시는 필수 항목 입니다.</span>
            <table border="0" cellspacing="0" cellpadding="0" class="list03" >
                <tr>
                    <th width="18%" rowspan="4" align="middle" valign="top"><img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" /></th>
                    <th width="85" align="middle">성명<span class="warning">*</span></th>
                    <td ><%=objHshReqUserInfo.get("USER_NM")%><input type=hidden name="USER_NM" VALUE=<%=objHshReqUserInfo.get("USER_NM")%>>
			   <input type=hidden name="USER_ID" VALUE=<%=objHshReqUserInfo.get("USER_ID")%>>
			   <input type=hidden name="INOUT_GBN" VALUE=<%=strInOutGbn%>></td>
                </tr>
				<% 
				
					String strJuminNo1 = "";
					String strJuminNo2 = "";
					String strGender = "";
					
					
					if(resid_no != null&&resid_no.equals("") != true){
						strJuminNo1 = resid_no.substring(0,6);
						strJuminNo2 = resid_no.substring(6,13);
						
						if(strJuminNo2.substring(0,1).equals("1") || strJuminNo2.substring(0,1).equals("3"))
							strGender = "남자";
						else
							strGender = "여자";

			
					}

			   %>
                <tr>
                    <th align="middle">주민등록번호</th>
                    <td height="25">
					****** - <%=strJuminNo2%>
					<input type=hidden name="JUMIN_NO" VALUE=<%=resid_no%>>
					<input type=hidden name="JUMIN_NO1" VALUE=<%=strJuminNo1%>>
					<input type=hidden name="JUMIN_NO2" VALUE=<%=strJuminNo2%>>
					</td>
                </tr>
                <tr>
                    <th align="middle">성별</th>
                    <td height="25"><%=strGender%></td>
                </tr>
                <tr>
                    <th align="middle"><%=strOrganTitle%><span class="warning">*</span></th>
                    <td height="25"><input name="ORGAN_ID" type="hidden" class="textfield" style="WIDTH: 220px" value="<%=objHshReqUserInfo.get("ORGAN_ID")%>"> 
				<input name="ORGAN_NM" type="hidden" class="textfield" style="WIDTH: 220px" value="<%=objHshReqUserInfo.get("ORGAN_NM")%>"> 
				<%=objHshReqUserInfo.get("ORGAN_NM")%></td>
                </tr>
				<% if(StringUtil.getNVLNULL(strInOutGbn).equals("X")) { %>
				<tr>
                    <th colspan="2" align="middle" valign="top">부서명</th>
                    <td height="25"><input name="DEPT_NM" style="width:120px;" value="<%=objHshReqUserInfo.get("DEPT_NM")%>"/ b /></td>
                </tr>
				<% } else {%>
					<input type=hidden name="DEPT_NM" VALUE=<%=objHshReqUserInfo.get("DEPT_NM")%> >
				<% }%>                
                <tr>
                    <th colspan="2" align="middle" valign="top">직위명</th>
                    <td height="25"><input name="POSI_NM" style="width:120px;"  VALUE="<%=objHshReqUserInfo.get("POSI_NM")%>" readonly/ b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">직급명</th>
                    <td height="25"><input name="GRD_NM" style="width:120px;"  VALUE="<%=objHshReqUserInfo.get("GRD_NM")%>"  readonly/ b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">e-mail<span class="warning">*</span></th>
                    <td height="25"><input maxlength="30" name="EMAIL"  style="width:250px;" VALUE=<%=objHshReqUserInfo.get("EMAIL")%> readonly/></td>
                </tr>
				<% 
					String strTel = (String)objHshReqUserInfo.get("OFFICE_TEL");
					
					String strTel1 = "";
					String strTel2 = "";
					String strTel3 = "";
					
					if(strTel != null && strTel.equals("") != true && strTel.indexOf("-") != -1){


						if(strTel.split("-").length > 2){
							strTel1 = strTel.split("-")[0];
							strTel2 = strTel.split("-")[1];
							strTel3 = strTel.split("-")[2];
						}else{
							strTel2 = strTel.split("-")[0];
							strTel3 = strTel.split("-")[1];
					
						}
			
					}

				%>
                <tr>
                    <th rowspan="3" align="middle" >전화번호</th>
					<input type=hidden name="OFFICE_TEL" VALUE=<%=strTel%>>
                    <th height="25" class="fonts" >사무실<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="4" name="OFFICE_TEL1" style="width:30px" VALUE=<%=strTel1%> />
                        -
                        <input maxlength="4" name="OFFICE_TEL2" VALUE=<%=strTel2%> style="width:30px"/>
                        -
                        <input maxlength="4" name="OFFICE_TEL3" VALUE=<%=strTel3%> style="width:55px"/></td>
                </tr>
                <input value="<%=objHshReqUserInfo.get("INNERPHONE")%>" maxlength="4" type="hidden" name="innerphone" />
				<% 
					String strFax = (String)objHshReqUserInfo.get("FAX_NO");
					String strFax1 = "";
					String strFax2 = "";
					String strFax3 = "";
					

					
					if(strFax != null && strFax.equals("") != true && strFax.indexOf("-") != -1){
						if(strFax.split("-").length > 2){
							strFax1 = strFax.split("-")[0];
							strFax2 = strFax.split("-")[1];
							strFax3 = strFax.split("-")[2];	
						}else{
							strFax2 = strFax.split("-")[0];
							strFax3 = strFax.split("-")[1];		
						}
					}

				%>
                <tr>
                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
					<input type=hidden name="FAX_NO" VALUE=<%=strFax%>>
                    <td height="25" colspan="2"><input maxlength="4" name="FAX_NO1" style="width:30px" value=<%=strFax1%> />
                        -
                        <input maxlength="4" name="FAX_NO2" value=<%=strFax2%> style="width:30px"/>
                        -
                        <input maxlength="4" name="FAX_NO3" value=<%=strFax3%> style="width:55px"/></td>
                </tr>
				<% 
					String strCphone = (String)objHshReqUserInfo.get("CPHONE");
					String strCphone1 = "";
					String strCphone2 = "";
					String strCphone3 = "";
					

					if(strCphone != null && strCphone.equals("") != true && strCphone.indexOf("-") != -1){
						strCphone1 = strCphone.split("-")[0];
						strCphone2 = strCphone.split("-")[1];
						strCphone3 = strCphone.split("-")[2];		
					}

				%>
                <tr>
                    <th height="25" class="fonts" >이동통신번호<span class="warning">*</span></th>
					<input type=hidden name="CPHONE" value="<%=strCphone%>">
                    <td height="25" colspan="2"><select name="CPHONE1" style="width:45px">
                            <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
							<option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
							<option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
							<option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
							<option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
							<option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                        </select>
                        -
                        <input maxlength="4" name="CPHONE2" style="width:30px" value="<%=strCphone2%>"  readonly/>
                        -
                        <input maxlength="4" name="CPHONE3" style="width:40px" value="<%=strCphone3%>"  readonly/></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >근무지</th>
                    <th align="middle" class="fonts" >우편번호<span class="warning">*</span></th>
					<%
						String strPostCd = (String)objHshReqUserInfo.get("POST_CD");
						String strJuso1 =  (String)objHshReqUserInfo.get("JUSO1");
						String strJuso2 =  (String)objHshReqUserInfo.get("JUSO2");

						if(StringUtil.getNVLNULL(strInOutGbn).equals("I")) { 
							//내부사용자는 원직 기관의 주소(우편번호, 주소1, 주소2는 빈공백으로)를 표시한다
							strPostCd = (String)objHshReqUserInfo.get("ORGAN_POST_CD");
							strJuso1 =  (String)objHshReqUserInfo.get("ORGAN_JUSO1");
							strJuso2 = "";
						}

						String strPostCd1 = "";
						String strPostCd2 = "";

						if(strPostCd != null && strPostCd.equals("") != true){
							strPostCd1 = strPostCd.substring(0,3);
							strPostCd2 = strPostCd.substring(3,6);
						}
						
					%>
                    <td height="25" colspan="4"><input name="POST_CD" type="hidden" VALUE="<%=strPostCd%>"/>
					<input maxlength="3" name="POST_CD1" readonly style="width:60px" value="<%=strPostCd1%>"  readonly/>
                        -
                        <input maxlength="3" name="POST_CD2" readonly style="width:60px" value="<%=strPostCd2%>"  readonly/>
                        </td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >기본주소<span class="warning">*</span></th>
                    <td height="25"><input maxlength="100" name="JUSO1" readonly  style="width:350px;" value="<%=strJuso1%>" readonly/></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >상세주소<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="100" name="JUSO2" style="width:350px;" VALUE="<%=strJuso2%>"  readonly/></td>
                </tr>
<%

if(strInOutGbn.equals("X") ==true)
{
%>				
                <tr>
                    <th rowspan="2" align="middle" >담당업무<span class="warning">*</span></th>
                    <th align="middle" class="fonts" >주업무</th>					
                    <td height="25" colspan="5">
					<%
						String strMsortCd = "";
						String strCdNm = "";
						
						String strType = "";
						String strCharge = "";
						
						String strChecked = "";
						String strDisabled = "";
						String strRemark = "";


						String strMchrWord = ""; //주업무 한글명
						String strSchrWord = ""; //부업무 한글명

						
						Hashtable objChargeInfoHt = new Hashtable();
						Hashtable objUserChargeHt = new Hashtable();

						for(int i=0; i < objChargeInfoArry.size(); i++){
							objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
							strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
							strCdNm = (String)objChargeInfoHt.get("CD_NM");			
							
							strChecked = "";
							strDisabled = "";
							strRemark = "";
							for(int k=0; k < objUserChargeArry.size(); k++){
								objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
								strType = (String)objUserChargeHt.get("CHARGE_TYPE");
								strCharge = (String)objUserChargeHt.get("CHARGE_CD");
								strRemark = (String)objUserChargeHt.get("REMARK");
								if(strType.equals("S")){
									if(strCharge.equals(strMsortCd) && !strMsortCd.equals("999")){
										strDisabled = "disabled";
										break;
									}
									continue;
								}
								if(strCharge.equals(strMsortCd)){
									strChecked = "checked";

									// 주업무 한글명으로 인하여 추가
									if(!strMsortCd.equals("999")) {
										strMchrWord = strMchrWord + " " + strCdNm;
									}

									break;
								}
							}


							if(strType.equals("S"))
								strRemark="";

							if( strMsortCd.equals("999")){
						%>
						<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'MRK')"  class=" borderNo" disabled><%=strCdNm%>&nbsp;&nbsp;<br>
						

                       <SPAN id="MRK"> <input name="MRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15  readonly>&nbsp;&nbsp;</SPAN>
											
					<%
								}else{
					%>
						<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)"  class=" borderNo" disabled><%=strCdNm%>&nbsp;&nbsp;

					<%
								}
							}
					%>  
					<input type='hidden' name='MchrWord' class='textfield' value="<%=strMchrWord+" "+ strRemark %>"></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >부업무</th>
                    <td height="25">
						<%
		
							for(int i=0; i < objChargeInfoArry.size(); i++){
								objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
								strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
								strCdNm = (String)objChargeInfoHt.get("CD_NM");
								
								strChecked = "";
								strDisabled = "";
								strRemark = "";
								for(int k=0; k < objUserChargeArry.size(); k++){
									objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
									strType = (String)objUserChargeHt.get("CHARGE_TYPE");
									strCharge = (String)objUserChargeHt.get("CHARGE_CD");
									strRemark = (String)objUserChargeHt.get("REMARK");
									if(strType.equals("M")){
										if(strCharge.equals(strMsortCd) && !strMsortCd.equals("999")){
											strDisabled = "disabled";
											break;
										}
										continue;
									}
									if(strCharge.equals(strMsortCd)){
										strChecked = "checked";

										// 부업무 한글명으로 인하여 추가
										if(!strMsortCd.equals("999")) {
											strSchrWord = strSchrWord + " " + strCdNm;
										}

										break;
									}
								}
								
								if(strType.equals("M"))
									strRemark="";

								if( strMsortCd.equals("999")){
						%>
								<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'SRK')" class=" borderNo" disabled><%=strCdNm%>&nbsp;&nbsp;<br>

					
								<SPAN id="SRK"><input name="SRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15  readonly>&nbsp;&nbsp;</SPAN>
						<%
									}else{
						%>
								<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)" class=" borderNo" disabled><%=strCdNm%>&nbsp;&nbsp;

						<%
									}
								}
						%>
						<input type='hidden' name='SchrWord' class='textfield' value="<%=strSchrWord+" "+ strRemark %>" ></td>
<%
}
%>						
                </tr>
				<%

				String strRepFlag = (String)objHshReqUserInfo.get("REP_FLAG");

				if(strInOutGbn.equals("X")){
					
				
				if(strRepFlag == null)
					strRepFlag = "N";
			    %>
                <tr>
                    <th height="25" colspan="2" align="middle">대표자   여부<span class="warning">*</span></th>
                    <td height="25"><input value="Y" <%=strRepFlag.equals("Y")?"checked":""%> type="radio" name="REP_FLAG" class=" borderNo" />
                        대표자
                        <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>  class=" borderNo"/>
                        일반</td>
                </tr>
				<% }else{%>
					<input type="hidden" name="REP_FLAG">
				<%}%>
                <tr>
                    <th height="25" colspan="2">사진등록</th>
                    <td onmouseover="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" title="사진크기:공무원증(가로 5cm * 세로 4cm )" onmouseout="hidetip()" height="25" colspan="2">
					<%
						String strPhoto =  StringUtil.getNVLNULL( (String)objHshReqUserInfo.get("PHOTO_PATH")); //현재 페이지
					%>
					<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>">
					<input name="selFileShow" type="text" class="textfield" style="WIDTH: 170px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>" readonly>
					</td>
                </tr>
                <tr>
                    <th height="65" colspan="2">자기소개</th>
                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"><%=objHshReqUserInfo.get("REMARK")%></textarea>
					</td>
                </tr>
            </table>
            <!-- /list -->
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="javascript:printUserInfo('N')">인 쇄</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">취 소</a></span> </div>
            
            <!-- /리스트 버튼--> 
            
            <span class="warning"> (*) 표시는 필수 항목 입니다.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<input type=hidden name="STT_CD" VALUE="001">
<input type=hidden name="ORGAN_NO" VALUE="<%=objHshReqUserInfo.get("ORGAN_NO")%>">
<input type=hidden name="HOME_URL" VALUE="<%=objHshReqUserInfo.get("HOME_URL")%>">
<input type=hidden name="ORGAN_JUSO1" VALUE="<%=objHshReqUserInfo.get("ORGAN_JUSO1")%>">
<input type=hidden name="ORGAN_JUSO2" VALUE="<%=objHshReqUserInfo.get("ORGAN_JUSO2")%>">
<input type=hidden name="STT_CHG_RSN" VALUE="회원가입 신청을 성공적으로 마쳤습니다.">
<input type=hidden name="USER_GRP_ID" VALUE="<%=strUserGrpId%>">
<input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
<input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
<input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
<input type=hidden name="CG_DUTY">
</form>
</body>
</html>