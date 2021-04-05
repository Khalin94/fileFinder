<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>
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
				return true;
		}else
			return false;



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

<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import=" kr.co.kcc.bf.log.Log" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	
	ArrayList objChargeInfoArry = new ArrayList();
	String strError = "no";	
	try
	{

		
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
		
		
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



<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="605" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top"> 
          <td width="203" height="55" background="/image/join/bg_top_middle.gif"><img src="/image/join/join_logo.gif" width="250" height="55"></td>
          <td width="100%" height="55" background="/image/join/bg_top_middle.gif"></td>
          <td width="7" height="55" align="right"><img src="/image/join/bg_top_right.gif" width="7" height="55"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td width="1" height="100" align="left" background="/image/join/bg_left.gif"><img src="/image/join/bg_left.gif" width="1" height="1"></td>
          <td width="601" bgcolor="ffffff"><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr valign="top"> 
                <td height="20"></td>
              </tr>
              <tr> 
                <td valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" background="/image/join/bg_join_tit.gif"><span class="title">개인정보 </span></td>
                      <td width="28%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
                    </tr>
                  </table> </td>
              </tr>
              <tr> 
                <td height="30" class="text_s"><strong><font color="990033">*</font></strong> 
                  <strong>표시</strong>는 필수 항목입니다.</td>
              </tr>
            </table> 
			<form action="/join/PreJoinMemberProc.jsp" method="post" name="frmPreJoinMember" encType="multipart/form-data" onsubmit="return checkUserCharge(document.frmPreJoinMember)">
			
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" colspan="4" class="td_join"></td>
              </tr>
              <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                이름<font color="990033">*</font></td>
              <td height="25" colspan="2" class="td_lmagin"><input name="USER_NM" type="text" class="textfield" style="WIDTH: 220px">
			</td>
              </tr>
              <tr class="tbl-line"> 
                <td width="9%" height="1"></td>
                <td width="23%" height="1"></td>
                <td width="24%" height="1"></td>
                <td width="44%" height="1"></td>
              </tr>
              <tr> 

                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
			  <% 
				
				String strJuminNo1 = "";
				String strJuminNo2 = "";
				String strGender = "1";

				if(strJuminNo != null&&strJuminNo.equals("") != true){
					strJuminNo1 = strJuminNo.substring(0,6);
					strJuminNo2 = strJuminNo.substring(6,13);
					strGender = strJuminNo2.substring(0,1);
					
		
				}

			  %>
                  주민등록번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">
				
				<input type=hidden name="JUMIN_NO" VALUE=<%=strJuminNo%>>
				<input type=text name="JUMIN_NO1" class="textfield" VALUE="<%=strJuminNo1%>" readonly maxlength=6 size=6>&nbsp;-&nbsp;<input type="password" name="JUMIN_NO2" class="textfield" VALUE="<%=strJuminNo2%>" readonly maxlength=7 size=7>
				
				</td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  성별<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input type=radio name="GENDER" VALUE="W" <%=strGender.equals("2")?"checked":""%>>여자<input type=radio name="GENDER" VALUE="M" <%=strGender.equals("1")?"checked":""%>>남자</td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  기관명<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="ORGAN_NM" type="text" class="textfield" style="WIDTH: 220px" readonly> 
				<input name="ORGAN_ID" type="hidden" > 
				<input name="ORGAN_NO" type="hidden" > 
				<input name="HOME_URL" type="hidden" > 
				<input name="ORGAN_JUSO1" type="hidden" > 
				<input name="ORGAN_JUSO2" type="hidden" > 
                  <img src="/image/button/bt_search_icon.gif" width="47" height="19" style="cursor:hand" align="absmiddle" onclick="winopen('/join/SearchOrgPop.jsp','SearchOrgPop','height=400,width=520,scrollbars=yes,resize=yes')"></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  부서명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="DEPT_NM" type="text" class="textfield" style="WIDTH: 300px"> </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr> 
                <td colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  직위명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="POSI_NM" type="text" class="textfield" style="WIDTH: 300px"> </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
                <td colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  직급명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="GRD_NM" type="text" class="textfield" style="WIDTH: 300px"> </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  e-mail<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="EMAIL" type="text" class="textfield" style="WIDTH: 300px" ></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 

                <td rowspan="5" align="center" class="td_gray2">전<br>
                  화<br>
                  번<br>
                  호 </td>
				  <input type=hidden name="OFFICE_TEL" >
                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  사무실<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="OFFICE_TEL1" type="text" class="textfield" style="WIDTH: 30px"  maxlength=3>
                  - 
                  <input name="OFFICE_TEL2" type="text" class="textfield" style="WIDTH: 30px"  maxlength=4>
                  - 
                  <input name="OFFICE_TEL3" type="text" class="textfield" style="WIDTH: 40px" maxlength=4></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 

                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  FAX<font color="990033">*</font></td>
				   <input type=hidden name="FAX_NO" >
                <td height="25" colspan="2" class="td_lmagin"><input name="FAX_NO1" type="text" class="textfield" style="WIDTH: 30px"  maxlength=3>
                  - 
                  <input name="FAX_NO2" type="text" class="textfield" style="WIDTH: 30px"  maxlength=4>
                  - 
                  <input name="FAX_NO3" type="text" class="textfield" style="WIDTH: 40px"  maxlength=4></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 

			  <% 
				String strCphone = "";
				String strCphone1 = "";
				String strCphone2 = "";
				String strCphone3 = "";
				


			  %>

                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  이동통신번호<font color="990033">*</font></td>
				  <input type=hidden name="CPHONE" >
                <td height="25" colspan="2" class="td_lmagin"><select name="CPHONE1" class="select" >
                    <option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                    <option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
                    <option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
                    <option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
                    <option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
                    <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
                  </select>
                  - 
                  <input name="CPHONE2" type="text" class="textfield" style="WIDTH: 30px" maxlength=4>
                  - 
                  <input name="CPHONE3" type="text" class="textfield" style="WIDTH: 40px"  maxlength=4></td>
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
                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  우편번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">
					<input name="POST_CD" type="hidden"  >
					<input name="POST_CD1" type="text" class="textfield" style="WIDTH: 30px"  maxlength=3 readonly>
                  - 
                  <input name="POST_CD2" type="text" class="textfield" style="WIDTH: 30px" maxlength=3 readonly> 
                  <img src="/image/button/bt_searchZipCode.gif" width="96" height="19" align="absmiddle" style="cursor:hand" readonly onclick="winopen('/common/SearchZipCodePop.jsp','SearchZipCodePop','height=450,width=520,scrollbars=yes,resize=yes')"> 
                </td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  기본주소<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO1" type="text" class="textfield" style="WIDTH: 300px" readonly></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  상세주소<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO2" type="text" class="textfield" style="WIDTH: 300px"></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>

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
		
		Hashtable objChargeInfoHt = new Hashtable();

		for(int i=0; i < objChargeInfoArry.size(); i++){
			objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
			strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
			strCdNm = (String)objChargeInfoHt.get("CD_NM");			
			

			if(strMsortCd.equals("999")){
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'MRK')"><%=strCdNm%>&nbsp;&nbsp;<BR>
<%
			}else{
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_check(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
		}
%>                      
<SPAN ID="MRK" ></SPAN>

					  </td>
                    </tr>
                    <tr> 
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                      <td height="1" class="tbl-line"></td>
                    </tr>
                    <tr> 
                      <td height="25"  class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        부업무</td>
                      <td height="25" colspan="2" class="td_lmagin">
<%
		
		for(int i=0; i < objChargeInfoArry.size(); i++){
			objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
			strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
			strCdNm = (String)objChargeInfoHt.get("CD_NM");

			if(strMsortCd.equals("999")){
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="makeTextBox(this,'SRK')"><%=strCdNm%>&nbsp;&nbsp;<BR>
<%
			}else{
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> onclick="fun_checkm(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
		}
%>  
<SPAN ID="SRK"></SPAN>

                      </td>
                    </tr>
<!-- 담당업무끝 -->


              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
			  <%
				String strRepFlag = "N";
			  %>
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  대표자 여부<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input type="radio" name="REP_FLAG" value="Y" <%=strRepFlag.equals("Y")?"checked":""%>>
                  대표자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                  <input type="radio" name="REP_FLAG" value="N" <%=strRepFlag.equals("N")?"checked":""%>>
                  일반</td>
              </tr>
			  <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
			  <!-- 공인전자서명 신청여부 (예:비행정기관   아니오:행정기관) -->
              <tr> 
			  <%
				String strOffiSignFlag = "N";
			  %>
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  공인전자서명 신청여부<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input type="radio" name="OFFISIGN_FLAG" value="Y" <%=strOffiSignFlag.equals("Y")?"checked":""%>>
                  예&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
                  <input type="radio" name="OFFISIGN_FLAG" value="N" <%=strOffiSignFlag.equals("N")?"checked":""%>>
                  아니오
				<br>
				("행자부인증서"나 "국회특수목적용인증서"가 없을 경우 신청)
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  사진등록</td>
                <td height="25" colspan="2" class="td_lmagin" onMouseover="showtip(this,event,'사진크기:공무원증(가로 5cm * 세로 4cm )')" onMouseout="hidetip()" valign=middle>
 				<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" > 
				<input name="selFileShow" type="text" class="textfield" style="WIDTH: 170px" readonly><input name="selFile" type="file" class="textfield" style="WIDTH:0px" onChange="javascript:showImageFile('selFile', 'selFileShow');">
				&nbsp<a href="javascript:fun_view(document.frmPreJoinMember);"><img src="/image/button/bt_preview_icon.gif" width="71" height="19" align="absmiddle" border=0></a> 
				</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="65" colspan="2" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  자기소개</td>
                <td height="65" colspan="2" class="td_box" ><textarea name="REMARK" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 60"></textarea></td>
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
				<input type=image src="/image/button/bt_ok.gif" >
				&nbsp;<img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand" onclick="document.location='/index.html'"></td>
                <td width="306" height="40" align="right">&nbsp;</td>
              </tr>
              <tr>
                <td height="10" align="left"></td>
                <td height="10" align="right"></td>
              </tr>
            </table></td>
          <td width="4" align="right" background="/image/join/bg_right.gif"><img src="/image/join/bg_right.gif" width="4" height="1" ></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top">
          <td width="140" height="42"><img src="/image/join/copyright.gif" width="258" height="42"></td>
          <td width="99%" height="42" background="/image/join/bg_bottom_middle.gif"></td>
          <td width="6" height="42" align="right"><img src="/image/join/bottom_right.gif" width="6" height="42"></td>
        </tr>
      </table>
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
	  <input type=hidden name="REQ_SUBMT_FLAG" VALUE="<%=strReqSubmtFlag%>">

	  </form>
	  </td>
  </tr>
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
</table>

</body>
</html>

<!--
<script>

var frm = this.document.frmPreJoinMember;

frm.JUMIN_NO.value='7711142674211';
frm.CPHONE1.value='011';
frm.GTHER_PERIOD.value='7';
frm.JUSO1.value='목동';
frm.JUMIN_NO1.value='771114';
frm.ORGAN_NM.value='한국통신';
frm.OFFICE_TEL.value='052-2344-1111';
frm.EMAIL.value='jhlee@kcc.co.kr';
frm.JUMIN_NO2.value='2674211';
frm.CPHONE2.value='2031';
frm.JUSO2.value='1번지';
frm.DEPT_NM.value='부서명1';
frm.SRCH_RECORD_CNT.value='5';
//frm.CERT_DN.value='임시';
frm.STT_CHG_RSN.value='회원가입 신청을 성공적으로 마쳤습니다.';
//frm.CG_DUTY.value='열심히';
frm.FAX_NO.value='02-3783-7800';
frm.POST_CD2.value='123';
frm.POST_CD.value='321123';
frm.CPHONE.value='011-2031-0016';
frm.SRCH_DISPLAY_KIND.value='001';
frm.USER_NM.value='김경연';
frm.FAX_NO1.value='02';
frm.FAX_NO2.value='3783';
frm.CPHONE3.value='0016';
frm.OFFICE_TEL1.value='052';
frm.REP_FLAG.value='';
frm.OFFISIGN_FLAG.value='';
frm.POST_CD1.value='321';
frm.OFFICE_TEL3.value='1111';
frm.REMARK.value='자기소개란입니다.';
frm.ORGAN_ID.value='GX00000018';
frm.FAX_NO3.value='7800';
frm.OFFICE_TEL2.value='2344';

</script>

-->