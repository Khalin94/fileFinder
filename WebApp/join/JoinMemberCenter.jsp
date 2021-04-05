<script src="/js/activity.js"></script>
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
			var vafile = frm.selFileShow.value.substr(frm.selFileShow.value.length - 4, frm.selFileShow.value.length);
			
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다." + vafile);
				return;
			}	
		} 
				
		img=frm.selFileShow.value;
		

		if(img.indexOf("C:") ==0){
			img=img.replace(/:/, "|");
			img=img.replace(/\\/gi, "/");
			img="file:///"+img;
		}else
		{
			img = "http://<%=request.getServerName()%>"+":"+"<%=request.getServerPort()%>"+img;
		}


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

function fun_viewRemoteFile(frm) {
		var img;

		if(img == "")
		{
			alert("선택된 사진이 없습니다.");
			return;
		}

		if(img != ""){
			var vafile = frm.selFileShow.value.substr(frm.selFileShow.value.length - 4, frm.selFileShow.value.length);
			alert(vafile);
			if((vafile.toLowerCase() != ".gif") && (vafile.toLowerCase() != ".jpg") &&
			   (vafile.toLowerCase() != ".bmp") && (vafile.toLowerCase() != ".jpeg")){
				alert("사진파일은 확장명이 .gif, .jpg .jpeg .bmp 만 등록할 수 있습니다." + vafile);
				return;
			}	
		} 
				
		img=frm.selFile.value;
		img=img.replace(/:/, "|");
		img=img.replace(/\\/gi, "/");
		img="http:///"+img;

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

<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>


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
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(objConfigEx.getMessage());
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>

<!-- 담당업무구분시작 -->
<%
		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();

	String strError = "no";	
	String strUserId = (String)objHshReqUserInfo.get("USER_ID");
	try
	{

		
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserId);
		
		
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		Log.debug.println("Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>

<table width="605" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top"> 
          <td width="203" height="55" background="../image/join/bg_top_middle.gif"><img src="../image/join/join_logo.gif" width="250" height="55"></td>
          <td width="100%" height="55" background="../image/join/bg_top_middle.gif"></td>
          <td width="7" height="55" align="right"><img src="../image/join/bg_top_right.gif" width="7" height="55"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0" >
        <tr valign="top">
          <td width="1" height="100" align="left" background="../image/join/bg_left.gif"><img src="../image/join/bg_left.gif" width="1" height="1"></td>
          <td width="601" bgcolor="ffffff"><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr valign="top"> 
                <td height="20"></td>
              </tr>
              <tr> 
                <td valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" background="../image/join/bg_join_tit.gif"><span class="title">개인정보 </span></td>
                      <td width="28%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
                    </tr>
                  </table> </td>
              </tr>
              <tr> 
                <td height="30" class="text_s"><strong><font color="990033">*</font></strong> 
                  <strong>표시</strong>는 필수 항목입니다.</td>
              </tr>
            </table> 
			<form action="/join/JoinMemberProc.jsp" method="post" name="frmJoinMember" encType="multipart/form-data" onsubmit="return checkValidation(this)">
			<input type=hidden name='organ_no_old' value='<%=objHshReqUserInfo.get("ORGAN_NO")%>'>
			<input type=hidden name='organ_no_new' value='<%=strOfficeSsn%>'>
			
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" colspan="4" class="td_join"></td>
              </tr>
              <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                이름<font color="990033">*</font></td>
              <td height="25" colspan="2" class="td_lmagin"><%=objHshReqUserInfo.get("USER_NM")%>
			 &nbsp;&nbsp;<input type=HIDDEN name="CERT_DN" class="textfield" VALUE="<%=request.getParameter("CERT_DN")%>">
			  <input type=hidden name="USER_NM" VALUE=<%=objHshReqUserInfo.get("USER_NM")%>>
			   <input type=hidden name="USER_ID" VALUE=<%=objHshReqUserInfo.get("USER_ID")%>>
			   <input type=hidden name="INOUT_GBN" VALUE=<%=strInOutGbn%>></td>
              </tr>
              <tr class="tbl-line"> 
                <td width="9%" height="1"></td>
                <td width="23%" height="1"></td>
                <td width="24%" height="1"></td>
                <td width="44%" height="1"></td>
              </tr>
              <tr> 
			  <% 
				
				String strJuminNo1 = "";
				String strJuminNo2 = "";
				String strGender = "";
				
				
				if(strJuminNo != null&&strJuminNo.equals("") != true){
					strJuminNo1 = strJuminNo.substring(0,6);
					strJuminNo2 = strJuminNo.substring(6,13);
					
					if(strJuminNo2.substring(0,1).equals("1") || strJuminNo2.substring(0,1).equals("3"))
						strGender = "남자";
					else
						strGender = "여자";

		
				}

			  %>

                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  주민등록번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><%=strJuminNo1%> - ●●●●●●●
				<input type=hidden name="JUMIN_NO" VALUE=<%=strJuminNo%>></td>
				<input type=hidden name="JUMIN_NO1" VALUE=<%=strJuminNo1%>></td>
				<input type=hidden name="JUMIN_NO2" VALUE=<%=strJuminNo2%>></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  성별<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><%=strGender%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                   <%=strOrganTitle%><font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">

				<input name="ORGAN_ID" type="hidden" class="textfield" style="WIDTH: 220px" value="<%=objHshReqUserInfo.get("ORGAN_ID")%>"> 
				<input name="ORGAN_NM" type="hidden" class="textfield" style="WIDTH: 220px" value="<%=objHshReqUserInfo.get("ORGAN_NM")%>"> 
				<%=objHshReqUserInfo.get("ORGAN_NM")%>
                  <!--img src="../image/button/bt_search_icon.gif" width="47" height="19" align="absmiddle" style="cursor:hand" onclick=winopen('/join/FindOrganPop.jsp','FindOrganPop','scrollbars=yes,height=300,width=200')--></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <% if(StringUtil.getNVLNULL(strInOutGbn).equals("X")) { %>
              <tr> 
                <td colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  부서명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="DEPT_NM" type="text" class="textfield" style="WIDTH: 300px" VALUE=<%=objHshReqUserInfo.get("DEPT_NM")%>></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <% } else {%>
				<input type=hidden name="DEPT_NM" VALUE=<%=objHshReqUserInfo.get("DEPT_NM")%> >
			  <% }%>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  e-mail<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="EMAIL" type="text" class="textfield" style="WIDTH: 300px" VALUE=<%=objHshReqUserInfo.get("EMAIL")%>></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
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
                <td rowspan="5" align="center" class="td_gray2">전<br>
                  화<br>
                  번<br>
                  호 </td>
				  <input type=hidden name="OFFICE_TEL" VALUE=<%=strTel%>>
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  사무실<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="OFFICE_TEL1" type="text" class="textfield" style="WIDTH: 30px" maxlength=3 VALUE=<%=strTel1%> >
                  - 
                  <input name="OFFICE_TEL2" type="text" class="textfield" style="WIDTH: 30px" maxlength=4 VALUE=<%=strTel2%> >
                  - 
                  <input name="OFFICE_TEL3" type="text" class="textfield" style="WIDTH: 40px"  maxlength=4 VALUE=<%=strTel3%> ></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
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
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  FAX<font color="990033">*</font></td>
				   <input type=hidden name="FAX_NO" VALUE=<%=strFax%>>
                <td height="25" colspan="2" class="td_lmagin"><input name="FAX_NO1" type="text" class="textfield" style="WIDTH: 30px" maxlength=3 value=<%=strFax1%> >
                  - 
                  <input name="FAX_NO2" type="text" class="textfield" style="WIDTH: 30px"  maxlength=4 value=<%=strFax2%> >
                  - 
                  <input name="FAX_NO3" type="text" class="textfield" style="WIDTH: 40px"  maxlength=4 value=<%=strFax3%> ></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 

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

                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  이동통신번호<font color="990033">*</font></td>
				  <input type=hidden name="CPHONE" VALUE=<%=strCphone%>>
                <td height="25" colspan="2" class="td_lmagin"><select name="CPHONE1" class="select" >
                    <option value ="011" <%=strCphone1.equals("011")?"selected":""%>>011</option>
                    <option  value ="016" <%=strCphone1.equals("016")?"selected":""%>>016</option>
                    <option  value ="017" <%=strCphone1.equals("017")?"selected":""%>>017</option>
                    <option  value ="018" <%=strCphone1.equals("018")?"selected":""%>>018</option>
                    <option  value ="019" <%=strCphone1.equals("019")?"selected":""%>>019</option>
                    <option  value ="010" <%=strCphone1.equals("010")?"selected":""%>>010</option>
                  </select>
                  - 
                  <input name="CPHONE2" type="text" class="textfield" style="WIDTH: 30px" maxlength=4 value=<%=strCphone2%> >
                  - 
                  <input name="CPHONE3" type="text" class="textfield" style="WIDTH: 40px" maxlength=4 value=<%=strCphone3%> ></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td rowspan="5" align="center" class="td_gray2">근<br>
                  무<br>
                  지 </td>
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  우편번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">
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
					<input name="POST_CD" type="hidden"  VALUE=<%=strPostCd%>>
					<input name="POST_CD1" type="text" class="textfield" style="WIDTH: 30px" value=<%=strPostCd1%> >
                  - 
                  <input name="POST_CD2" type="text" class="textfield" style="WIDTH: 30px" maxlength=3 value=<%=strPostCd2%> > 
                  <img src="../image/button/bt_searchZipCode.gif" width="96" height="19" align="absmiddle" style="cursor:hand" onclick="winopen('/common/SearchZipCodePop.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')"> 
                </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  기본주소<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO1" type="text" class="textfield" style="WIDTH: 300px" value="<%=strJuso1%>" readonly></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  상세주소<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO2" type="text" class="textfield" style="WIDTH: 300px" VALUE=<%=strJuso2%>></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>

<%

if(strInOutGbn.equals("X") ==true)
{
%>

<!-- 담당업무시작 -->
              <tr> 
                <td rowspan="3" align="center" class="td_gray2">담당<br>
                  업무</td>
                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  주업무</td>
                <td height="25" colspan="2" class="td_lmagin">
<%
		String strMsortCd = "";
		String strCdNm = "";
		
		String strType = "";
		String strCharge = "";
		
		String strChecked = "";
		String strDisabled = "";
		String strRemark = "";
		
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
					break;
				}
			}


			if(strType.equals("S"))
				strRemark="";

			if( strMsortCd.equals("999")){
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'MRK')" ><%=strCdNm%>&nbsp;&nbsp;<br>
						

                       <SPAN id="MRK"> <input name="MRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15>&nbsp;&nbsp;</SPAN>
						

<%
			}else{
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
		}
%>                
                      </td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        부업무</td>
                      <td height="25" colspan="2" class="td_lmagin">
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
					break;
				}
			}
			
			if(strType.equals("M"))
				strRemark="";

			if( strMsortCd.equals("999")){
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> onclick="makeTextBox(this,'SRK')" ><%=strCdNm%>&nbsp;&nbsp;<br>

					
                        <SPAN id="SRK"><input name="SRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15>&nbsp;&nbsp;</SPAN>
						

<%

			}else{
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
		}
%>      
                      </td>
                    </tr>
<!-- 담당업무끝 -->

<%
}
%>


              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
             <%

				String strRepFlag = (String)objHshReqUserInfo.get("REP_FLAG");

				if(strInOutGbn.equals("X")){
					
				
				if(strRepFlag == null)
					strRepFlag = "N";
			  %>
				<tr>
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  대표자 여부<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input type="radio" name="REP_FLAG" value="Y" <%=strRepFlag.equals("Y")?"checked":""%> disabled>
                  대표자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                  <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%> disabled>
                  일반</td>
              </tr>
			<% }else{
			%>
			  <input type="hidden" name="REP_FLAG">
			  <%}%>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  사진등록</td>
                <td height="25" colspan="2" class="td_lmagin" onMouseover="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" onMouseout="hidetip()">
				<!-- 버튼을 이미지로(파일업로드가 안됨)
				<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" > 
				<input name="selFile" type="file" class="textfield" style="WIDTH: 220px" > 
				<img src="../image/button/bt_find.gif" width="69" height="19" align="absmiddle" style='cursor:hand' onclick='document.all.selFile.click(); document.all.PHOTO_PATH.value=document.all.selFile.value'>
				-->
				
				<%
					String strPhoto =  StringUtil.getNVLNULL( (String)objHshReqUserInfo.get("PHOTO_PATH")); //현재 페이지
 				%>
				<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" VALUE=<%=objHshReqUserInfo.get("PHOTO_PATH")%>>
				<input name="selFileShow" type="text" class="textfield" style="WIDTH: 170px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>" readonly><input name="selFile" type="file" class="textfield" style="WIDTH:0px" VALUE="<%=objHshReqUserInfo.get("PHOTO_PATH")%>" onChange="javascript:showImageFile('selFile', 'selFileShow');">&nbsp<a href="javascript:fun_view(document.frmJoinMember);"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" border=0></a>
				</td>
              </tr>

              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="65" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  자기소개</td>
                <td height="65" colspan="2" class="td_box" ><textarea name="REMARK" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 60"><%=objHshReqUserInfo.get("REMARK")%></textarea></td>
              </tr>
              <tr> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
            </table> 
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="474" height="30" align="left">
				<input type=image src="../image/button/bt_finish.gif">&nbsp;<img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand" onclick="document.location='/index.html'"></td>
                <td width="306" height="40" align="right">&nbsp;</td>
              </tr>
              <tr>
                <td height="10" align="left"></td>
                <td height="10" align="right"></td>
              </tr>
            </table></td>
          <td width="4" align="right" background="../image/join/bg_right.gif"><img src="../image/join/bg_right.gif" width="4" height="1" ></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top">
          <td width="140" height="42"><img src="../image/join/copyright.gif" width="258" height="42"></td>
          <td width="99%" height="42" background="../image/join/bg_bottom_middle.gif"></td>
          <td width="6" height="42" align="right"><img src="../image/join/bottom_right.gif" width="6" height="42"></td>
        </tr>
      </table>
	  <input type=hidden name="STT_CD" VALUE="001">
	  <input type=hidden name="STT_CHG_RSN" VALUE="회원가입 신청을 성공적으로 마쳤습니다.">
	  <input type=hidden name="USER_GRP_ID" VALUE="<%=strUserGrpId%>">
	  <input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
	  <input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
	  <input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
	  <input type=hidden name="CG_DUTY">


	  </form>
	  </td>
  </tr>
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
</table>

