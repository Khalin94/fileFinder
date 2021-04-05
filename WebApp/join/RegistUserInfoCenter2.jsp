<%@ page contentType="text/html;charset=euc-kr" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.join.*"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.encode.*"%>
<%@ page import="java.io.*"%>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<%

	//String in_symm_enckey = "";


	//String EncData = null;

	String strUserInGrpId = ""; 
	String strUserOutGrpId = ""; 
	String strSrchRecordCnt = ""; 
	String strSrchDisplayKind = "";
	String strGtherPeriod = "";
	String strReqSubmtFlag = "";
	String strJuminNoTemp = "";
	String username = "";
	String eventdate = "";
	String empNo = "";
	
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();
	
	Hashtable objorgandata = null;

	//EncData = ((String)java.net.URLDecoder.decode(StringUtil.getNVLNULL(request.getParameter("issacweb_data")),"KSC5601")).replaceAll(" ","+");
	
	ResultSetSingleHelper objRS = null;



//	in_symm_enckey = request.getParameter("symm_enckey");

	eventdate = request.getParameter("eventdate");
	username = request.getParameter("username");
	empNo = request.getParameter("empNo");
	
	System.out.println("eventdate : "+eventdate);
	System.out.println("username : "+username);
	System.out.println("empNo : "+empNo);
	
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	java.util.Hashtable objHshParam = new java.util.Hashtable();
	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	
	if(eventdate.length() > 6){
		objHshParam.put("eventdate",eventdate.substring(2,8));		
	}else{
		objHshParam.put("eventdate",eventdate);
	}
	
	objHshParam.put("username",username);
	objHshParam.put("empNo","");
	if(eventdate.equals("") != true)
		objHshReqUserInfo = objJoinMemberDelegate.getUserInfo3(objHshParam);
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
	winopen('/join/PrintUserInfo2.jsp','PrintUserInfo','height=550,width=650,scrollbars=yes,resize=yes');

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
                    <th width="18%" rowspan="3" align="middle" valign="top"><img src="/images2/foundation/pic.gif" width="110" height="120" class="pic" /></th>
                    <th width="85" align="middle">성명<span class="warning">*</span></th>
                    <td ><%=objHshReqUserInfo.get("USER_NM")%><input type=hidden name="USER_NM" VALUE=<%=objHshReqUserInfo.get("USER_NM")%>>
			   <input type=hidden name="USER_ID" VALUE=<%=objHshReqUserInfo.get("USER_ID")%>>
			   <input type=hidden name="INOUT_GBN" VALUE=<%=strInOutGbn%>></td>
                </tr>				
                <tr>
                    <th align="middle">생년월일</th>
                    <td height="25">
                    <%
                    	if(eventdate.length() == 8) {
                    %>
					<%=eventdate.substring(0,4)%>년&nbsp;<%=eventdate.substring(4,6)%>월&nbsp;<%=eventdate.substring(6,8)%>일
					<%
                    	} else {
					%>
					<%=eventdate.substring(0,2)%>년&nbsp;<%=eventdate.substring(2,4)%>월&nbsp;<%=eventdate.substring(4,6)%>일
					<%
                    	}
					%>
					<%-- <%
						/* String tempevent = eventdate.substring(0,4)+"년 "+eventdate.substring(4,6)+"월 "+eventdate.substring(6,8)+"일"; */
						String tempevent = eventdate.substring(0,2)+"년 "+eventdate.substring(2,4)+"월 "+eventdate.substring(4,6)+"일";
					%>
					<input type=hidden name="JUMIN_NO1" VALUE="<%=tempevent%>"> --%>					
					<input type=hidden name="eventdate" value="<%=eventdate%>">
					</td>
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
					    System.out.println("kangthis logs strPostCd => " + strPostCd);
						String strJuso1 =  (String)objHshReqUserInfo.get("JUSO1");
						String strJuso2 =  (String)objHshReqUserInfo.get("JUSO2");

						if(StringUtil.getNVLNULL(strInOutGbn).equals("I")) { 
							//내부사용자는 원직 기관의 주소(우편번호, 주소1, 주소2는 빈공백으로)를 표시한다
							strPostCd = (String)objHshReqUserInfo.get("ORGAN_POST_CD");
							strJuso1 =  (String)objHshReqUserInfo.get("ORGAN_JUSO1");
							strJuso2 = "";
						}

						/* String strPostCd1 = "";
						String strPostCd2 = "";

						if(strPostCd != null && strPostCd.equals("") != true){
							strPostCd1 = strPostCd.substring(0,3);
							strPostCd2 = strPostCd.substring(3,6);
						} */
						
					%>
                    <td height="25" colspan="4"><input name="POST_CD" type="hidden" VALUE="<%=strPostCd%>"/>
					<input maxlength="7" name="POST_CD1" readonly style="width:60px" value="<%=strPostCd%>"  readonly/>
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
                    <td height="65" colspan="2"><textarea wrap="hard" name="REMARK" style="width:400px; height:65px;"><%=objHshReqUserInfo.get("REMARK")%>
</textarea>
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