<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.join.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ksign.jce.util.*"%>
<%@ page import="ksign.jce.sample.*"%>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);


	//String in_symm_enckey = "";
	String in_eventdate = "";
	String in_username = "";

	byte[] bt_eventdate = null;
	byte[] bt_username = null;


	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strJuminNoTemp = "";
	String ORGAN_NM = "";
	String ORGAN_NO = "";
	String HOME_URL = "";
	String ORGAN_JUSO1 = "";
	String ORGAN_JUSO2 = "";
	String eventdate = "";
	String username = "";
	String organid = "";

	
	
	ArrayList objChargeInfoArry = new ArrayList();
	Hashtable objorgandata = null;

System.out.println("RegistUserInfoInPut.jsp Start~~~~~~~~~~");
	//EncData = ((String)java.net.URLDecoder.decode(request.getParameter("issacweb_data"),"KSC5601")).replaceAll(" ","+");
//	in_symm_enckey = request.getParameter("symm_enckey");
	in_eventdate = request.getParameter("eventdate");
	in_username = request.getParameter("username");

	String strOrganID 	= StringUtil.getNVLNULL(request.getParameter("ORGAN_ID")).trim();
	String strSFlag 	= StringUtil.getNVLNULL(request.getParameter("SFLAG")).trim();
	ResultSetSingleHelper objRS = null;
	
	
/*	
	if (in_symm_enckey != null){
		System.out.println("ksign");
		///////////////////////////////////////////////////// START

		System.out.println("암호화된 키값  : " + in_symm_enckey );
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
			//byte[] bt_regsid2 = symmdecrypt.SymmDecrypt(in_regsid2, key, "SEED");

			bt_eventdate = symmdecrypt.SymmDecrypt(in_eventdate, key, "SEED");

			bt_username = symmdecrypt.SymmDecrypt(in_username, key, "SEED");


			eventdate = new String(bt_eventdate);
			username = new String(bt_username);

			System.out.println("복원한 키값 : " + key );

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.toString());
			System.out.println("error1 :  " + e.toString());
			System.out.println("error2 : " + JCEUtil.getErrormsg());
			System.out.println("error3 : " + JCEUtil.getErrorcode());
		}
		
		//System.out.println( request.getParameter("_E2E_SAFEON_regsid1") );
		//System.out.println( request.getParameter("_E2E_SAFEON_regsid2") );
		//System.out.println( "safeon1 : " + regsid1 ); 
		//System.out.println( ",safeon2 : " + regsid2 ); 
		//가상키보드 safeon 복호 끝		

	}
*/


		
		

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
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

			JoinMemberDelegate  objOrgan = new JoinMemberDelegate();
						
			if(!strOrganID.equals("")){
				objRS = new ResultSetSingleHelper(objOrgan.getOrganInfo(strOrganID));
				ORGAN_NM = (String)objRS.getObject("ORGAN_NM");
				ORGAN_NO = (String)objRS.getObject("ORGAN_NO");
				HOME_URL = (String)objRS.getObject("HOME_URL");
				ORGAN_JUSO1 = (String)objRS.getObject("JUSO1");
				ORGAN_JUSO2 = (String)objRS.getObject("JUSO2");
			}	
		}
		catch(AppException objAppEx)
		{	
			
	%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%  	
			return;
		}			
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<!-- 우편번호 참조를 위함  -->
<script type="text/javascript" src="/zipinfo/js/jquery-1.8.3.min.js"></script>
<script language="javascript">
var winBG;
function fun_view(frm) {
		var img;

		if(img == "")
		{
			alert("선택된 사진이 없습니다.");
			return;
		}

		if(img != ""){
			var vafile = frm.selFile.value.substr(frm.selFile.value.length - 4, frm.selFile.value.length);
			
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다." + vafile);
				return;
			}	
		} 
				
		img=frm.selFile.value;
		img=img.replace(/:/, "|");
		img=img.replace(/\\/gi, "/");
		img="file:///"+img;

		if ((winBG==null)||(winBG.closed==true)) {
			winBG=window.open("", "", "width=220,height=200,resizable=1");
		}
		winBG.document.open();
		winBG.document.write("<html>");
		winBG.document.write("<head></head>");
		winBG.document.write("<body>");
		winBG.document.write("<table width='205' border='0' cellspacing='0' cellpadding='0'>");
		winBG.document.write("<tr>");
		winBG.document.write("<td align='center'><img src='" +  img + "' width='200' height='160'></td>");
		winBG.document.write("</tr>");
		winBG.document.write("<tr>");
		winBG.document.write("<td height='10' class='tbl-line'></td>");
		winBG.document.write("</tr>");
		winBG.document.write("<tr>");
		winBG.document.write("<td align='center'><a href='javascript:self.close()'><img src='/image/button/bt_close.gif' width='46' height='11' border='0'></a></td>");
		winBG.document.write("</tr>");
		winBG.document.write("</body>");
		winBG.document.write("</html>");
		winBG.document.close();
		winBG.window.focus();
	}



	function fun_check(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			
			varCheck = 'document.frmPreJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmPreJoinMember.s' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}
	
	function fun_checkm(varObj){
		var varCheck ='';
		if(varObj.checked == true){
			varCheck = 'document.frmPreJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = true';
		}else{
			varCheck = 'document.frmPreJoinMember.m' + varObj.name.substring(1, varObj.name.length)
			                      + '.disabled = false';
			
		}
		eval(varCheck);		 
	}

function makeTextBox_OLD(chbox,divNm)
{
 eval(divNm).innerHTML = "";

 if(chbox.checked == true)
	eval(divNm).innerHTML = "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
 else
	 eval(divNm).innerHTML=" ";
 

}

function makeTextBox(chbox,divNm)
{
 
	 var txtbox = " ";

	 if(chbox.checked == true)
	{
		eval(divNm).innerHTML = txtbox+ "<input type='text' name='"+divNm+"' class='textfield' style='WIDTH: 200px' maxlength=15 >";
	 }
	 else
	{
		 eval(divNm).innerHTML=txtbox+"";
	}

}


function checkUserCharge(frm){

//담당업무는 반드시 선택해야 함(담당업무는 외부사용자만 있음)

		
		
		var varCheck = 0;
		var varCnt = 0;
		for(var i=0; i < frm.elements.length; i++){
			if(frm.elements[i].name.substring(0,4)=='mchr'){
				varCnt = parseInt(varCnt + 1);
				if(frm.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
			if(frm.elements[i].name.substring(0,4)=='schr'){
				varCnt = parseInt(varCnt + 1);
				if(frm.elements[i].checked == true){
					varCheck = 1;
					break;
				}
			}
		}
		
        if(checkValidation(frm)){

			if((varCnt > 0) && (varCheck == 0)){
				alert("담당업무는 반드시 있어야 합니다.");
				return false;		
			}else
				frm.submit();
				return true;
		}else
			return false;



}

function openWindow(url, name, width, height, scroll)   {
    var top  = screen.height / 2 - height / 2 - 50;
    var left = screen.width / 2 - width / 2 ;
    var scrollbars = "auto";

    if(scrollbars != null) {
    	scrollbars = scroll;
    }

    var win =
        open(url,
            name,
            'width=' + width + ', height=' + height + ', top=' + top +
            ', left=' + left + ', resizable=no, status=yes, toolbar=no, menubar=no, resizable, scrollbars=' + scrollbars);
    win.focus();
    return win;
}


function wincall() {
		
	openWindow('/zipinfo/roadSearchAddress.html', 'search', '500', '573', 'N');
	return false;
}
  function _callbackZipCode(data) {
	  $("#POST_CD").val(data.zipcode);
	  $("#POST_CD1").val(data.zipcode);
	  $("#JUSO1").val(data.addr);	  
}
  
</script>
<script Language="Javascript">
//오른쪽마우스 클릭금지
function clickIE() {
if (document.all) {
return false;
}
} 
function clickNS(e) {
if (document.layers||(document.getElementById&&!document.all)) { 
if (e.which==2||e.which==3) {
return false;
}
}
} 
if (document.layers) {
document.captureEvents(Event.MOUSEDOWN);
document.onmousedown=clickNS;
} 
else{
document.onmouseup=clickNS;
document.oncontextmenu=clickIE;
} 
document.oncontextmenu=new Function("return false") 
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

<body onload="init();">
<div id="log_wrap">
    <div class="login">
        <h1><img src="/images2/login/logo02.gif" width="194" height="46" /></h1>
        <div class="user_con"> <br />
            <br />
            <!-- list --> 
			<form action="/join/RegistUserInfoInPutProc.jsp" method="post" name="frmPreJoinMember" encType="multipart/form-data" onsubmit="return checkUserCharge(document.frmPreJoinMember)">
            <span class="list02_tl">사용자 정보 입력</span> <span class="list_total">(*) 표시는 필수 항목 입니다.</span>
            <table border="0" cellspacing="0" cellpadding="0" class="list03" >
                <tr>
                    <th width="18%" rowspan="3" align="middle" valign="top"><img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" /></th>
                    <th width="85" align="middle">성명<span class="warning">*</span></th>
                    <td ><%=in_username%><input name="USER_NM" type="hidden" value="<%=in_username%>"></td>
                </tr>				
                <tr>
                    <th align="middle">생년월일</th>
                    <td height="25">										
					<input type=hidden name="eventdate" value="<%=in_eventdate%>">
					<%=in_eventdate.substring(0,4)%>년&nbsp;<%=in_eventdate.substring(4,6)%>월&nbsp;<%=in_eventdate.substring(6,8)%>일
					</td>
                </tr>                
                <tr>
                    <th align="middle">기관명<span class="warning">*</span></th>
                    <td height="25"><input name="ORGAN_NM" value="<%=ORGAN_NM%>" type="text" class="textfield" style="WIDTH: 220px" readonly / b /> 
					<input name="ORGAN_ID" type="hidden" value="<%=strOrganID%>" > 
					<input name="ORGAN_NO" type="hidden" value="<%=ORGAN_NO%>"> 
					<input name="HOME_URL" type="hidden" value="<%=HOME_URL%>"> 
					<input name="ORGAN_JUSO1" type="hidden" value="<%=ORGAN_JUSO1%>"> 
					<input name="ORGAN_JUSO2" type="hidden" value="<%=ORGAN_JUSO2%>">
					<img src="/image/button/bt_search_icon.gif" width="47" height="19" style="cursor:hand" align="absmiddle" onclick="winopen('/join/SearchOrgPop.jsp','SearchOrgPop','height=400,width=520,scrollbars=yes,resize=yes')">
					</td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">부서명<span class="warning">*</span></th>
                    <td height="25"><input name="DEPT_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">직위명</th>
                    <td height="25"><input name="POSI_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">직급명</th>
                    <td height="25"><input name="GRD_NM" style="width:120px;" / b /></td>
                </tr>
                <tr>
                    <th colspan="2" align="middle" valign="top">e-mail<span class="warning">*</span></th>
                    <td height="25"><input maxlength="30" name="EMAIL"  style="width:250px;"/></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >전화번호</th>
					<input type=hidden name="OFFICE_TEL" >
                    <th height="25" class="fonts" >사무실<span class="warning">*</span></th>
                    <td height="25" colspan="2"><input maxlength="4" name="OFFICE_TEL1" style="width:30px;text-align:right;padding:1px" / b />
                        -
                        <input maxlength="4" name="OFFICE_TEL2" style="width:30px;text-align:right;padding:1px"/ b />
                        -
                        <input maxlength="4" name="OFFICE_TEL3" style="width:55px;text-align:right;padding:1px"/ b /></td>
                </tr>
                <input value="0081" maxlength="4" type="hidden" name="innerphone" / b />
                <tr>
                    <th height="25" class="fonts"  >FAX<span class="warning">*</span></th>
					<input type=hidden name="FAX_NO" >
                    <td height="25" colspan="2"><input maxlength="4" name="FAX_NO1" style="width:30px;text-align:right;padding:1px" / b />
                        -
                        <input maxlength="4" name="FAX_NO2" style="width:30px;text-align:right;padding:1px"/ b />
                        -
                        <input maxlength="4" name="FAX_NO3" style="width:55px;text-align:right;padding:1px"/ b /></td>
                </tr>
				<% 
					String strCphone = "";
					String strCphone1 = "";
					String strCphone2 = "";
					String strCphone3 = "";				
				%>
                <tr>
                    <th height="25" class="fonts" >이동통신번호<span class="warning">*</span></th>
					<input type=hidden name="CPHONE" >
                    <td height="25" colspan="2"><select name="CPHONE1" style="width:45px">
                            <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
							<option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
							<option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
							<option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
							<option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
							<option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                        </select>
                        -
                        <input maxlength="4" name="CPHONE2" style="width:30px;text-align:right;padding:1px" />
                        -
                        <input maxlength="4" name="CPHONE3" style="width:40px;text-align:right;padding:1px" /></td>
                </tr>
                <tr>
                    <th rowspan="3" align="middle" >근무지</th>
                    <th align="middle" class="fonts" >우편번호</th>
                    <td height="25" colspan="4"><input name="POST_CD" id="POST_CD" type="hidden"/>
					<input maxlength="7" name="POST_CD1" id="POST_CD1" style="width:60px"/>
                        &nbsp;
                        <!-- 2015-04-24 수정 전
                        <span class="list_bts"><a href="#" onclick="winopen('/common/SearchZipCodePop2.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">우편번호검색</a></span>
                         -->
                           <!-- 2015-04-24 수정 후 -->
                           <!-- <span class="list_bts"><a href="#" onclick="winopen('/common/doro.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')">우편번호검색</a></span> -->
                           <span class="list_bts"><a href="#" onclick="wincall()">우편번호검색</a></span>
                     </td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >기본주소</th>
                    <td height="25"><input maxlength="100" name="JUSO1" id="JUSO1" readonly  style="width:350px;"/></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >상세주소</th>
                    <td height="25" colspan="2"><input maxlength="100" name="JUSO2" style="width:350px;" /></td>
                </tr>
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
							
							Hashtable objChargeInfoHt = new Hashtable();

							for(int i=0; i < objChargeInfoArry.size(); i++){
								objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
								strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
								strCdNm = (String)objChargeInfoHt.get("CD_NM");			
								

								if(strMsortCd.equals("999")){
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'MRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
					<%
								}else{
					%>
											<input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

					<%
								}
							}
					%>
					<span id="MRK"></span></td>
                </tr>
                <tr>
                    <th align="middle" class="fonts" >부업무</th>
                    <td height="25">
						<%
		
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");

									if(strMsortCd.equals("999")){
						%>
												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'SRK')" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;<BR>
						<%
									}else{
						%>
												<input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)" class=" borderNo"><%=strCdNm%>&nbsp;&nbsp;

						<%
									}
								}
						%>
						<span id="SRK"></span></td>
                </tr>
				<%
					String strRepFlag = "N";
				%>
                <tr>
                    <th height="25" colspan="2" align="middle">대표자   여부<span class="warning">*</span></th>
                    <td height="25"><input value="Y" <%=strRepFlag.equals("Y")?"checked":""%> type="radio" name="REP_FLAG" class=" borderNo" />
                        대표자
                        <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>  class=" borderNo"/>
                        일반
						&nbsp;<font color="red">※ 대표자로 설정하는 경우 해당기관의 요구서 등록 시 <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문자 알림서비스 (국회기관 담당자 여부)</font>

					</td>
                </tr>
                <tr>
                    <th height="25" colspan="2">사진등록</th>
                    <td onmouseover="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" title="사진크기:공무원증(가로 5cm * 세로 4cm )" onmouseout="hidetip()" height="25" colspan="2">
					<input name="PHOTO_PATH" type="hidden" class="textfield">
					<input name="selFileShow" type="hidden" class="textfield" style="WIDTH: 170px" readonly>
					<input name="selFile" type="file" class="textfield" style="WIDTH:220px" onChange="javascript:showImageFile('selFile', 'selFileShow');">
				&nbsp&nbsp&nbsp&nbsp<a href="javascript:fun_view(document.frmPreJoinMember);"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" border=0></a></td>
                </tr>
                <tr>
                    <th height="65" colspan="2">자기소개</th>
                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"></textarea>
					</td>
                </tr>
            </table>
            <!-- /list -->
            <div id="btn_all" class="t_right"> <span class="list_bt"><a href="#" onclick="checkUserCharge(document.frmPreJoinMember);">신 청</a></span> <span class="list_bt"><a href="#" onclick="window.location='/index.html'">취 소</a></span> </div>
            
            <!-- /리스트 버튼--> 
            
            <span class="warning"> (*) 표시는 필수 항목 입니다.</span> </div>
    </div>
    <div id="log_footer"> <span class="copy" ><img src="/images2/login/copyright.gif" width="448" height="26" /></span></div>
</div>
<input type=hidden name="USER_KIND" VALUE="999"><!-- 사용자분류(외부사용자는 999로 셋팅) -->
<input type=hidden name="STT_CD" VALUE="005">
<input type=hidden name="STT_CHG_RSN" VALUE="사전신청을 하셨습니다.">
<input type=hidden name="USER_GRP_ID" VALUE="<%=strUserOutGrpId%>">
<input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
<input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
<input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
<input type=hidden name="GRD_CD" VALUE="">
<input type=hidden name="CG_DUTY" VALUE="">
<input type=hidden name="ORG_POSI_GBN" VALUE="1">
<input type="hidden" name="SFLAG" value="<%=strSFlag%>">
<input type=hidden name="REQ_SUBMT_FLAG" VALUE="<%=strReqSubmtFlag%>">
</form>
<script language="JavaScript">
<!--
//파일 첨부
function showImageFile(fileValue, showValue) { 
	eval("document.frmPreJoinMember."+showValue+".value = document.frmPreJoinMember."+fileValue+".value");
}
//-->
</script>
<script language="javascript">

function init()
{
	
	// 필수입력
	define('USER_NM', 'string', '이름', 1);	
	define('ORGAN_NM', 'string', '기관', 1);	
	define('ORGAN_ID', 'string', '기관', 1);	
	define('DEPT_NM', 'string', '부서', 1);	
	define('EMAIL', 'string', '이메일', 1);	
	define('OFFICE_TEL1', 'num', '사무실전화번호', 2,3);	
	define('OFFICE_TEL2', 'num', '사무실전화번호', 2,4);	
	define('OFFICE_TEL3', 'num', '사무실전화번호', 3,4);	
	define('FAX_NO1', 'num', '팩스번호', 2,3);	
	define('FAX_NO2', 'num', '팩스번호', 2,4);	
	define('FAX_NO3', 'num', '팩스번호', 3,4);	
	//define('CPHONE1', 'num', '핸드폰', 3,3);	
	define('CPHONE2', 'num', '핸드폰', 3,4);	
	define('CPHONE3', 'num', '핸드폰', 3,4);	
	//define('POST_CD1', 'num', '우편번호', 3,3);	
	//define('POST_CD2', 'num', '우편번호', 3,3);	
	//define('JUSO2', 'string', '상세주소', 1);	
	//define('REP_FLAG', 'string', '대표자여부', 1);	


}
function checkValidation(frm)
{

	
	//frm.POST_CD.value = frm.POST_CD1.value + frm.POST_CD2.value;	
	frm.POST_CD.value = frm.POST_CD1.value;
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

function selectZipCd(varZipCd, varAddr1)
{
	var frm = document.forms[0];
	frm.POST_CD1.value = varZipCd;
	/* frm.POST_CD1.value = varZipCd1;
	frm.POST_CD2.value = varZipCd2; */
	frm.JUSO1.value = varAddr1;
}
function selectOrgan(organId,organNm,organNo,homeUrl,Juso1,Juso2) {
	var frm = document.forms[0];
	frm.ORGAN_ID.value = organId;
	frm.ORGAN_NM.value = organNm;
	frm.ORGAN_NO.value = organNo;
	frm.HOME_URL.value = homeUrl;
	frm.ORGAN_JUSO1.value = Juso1;
	frm.ORGAN_JUSO2.value = Juso2;

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
</body>
</html>