<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">


</head>


<%@ page import="kr.co.kcc.bf.config.*" %>

<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="605" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top"> 
          <td width="203" height="55" background="../image/join/bg_top_middle.gif"><img src="../image/join/join_logo.gif" width="203" height="55"></td>
          <td width="100%" height="55" background="../image/join/bg_top_middle.gif"></td>
          <td width="7" height="55" align="right"><img src="../image/join/bg_top_right.gif" width="7" height="55"></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td width="1" height="100" align="left" background="../image/join/bg_left.gif"><img src="../image/join/bg_left.gif" width="1" height="1"></td>
          <td width="601" bgcolor="ffffff"><table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr valign="top"> 
                <td height="20"></td>
              </tr>
              <tr> 
                <td valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="13%" background="../image/join/bg_join_tit.gif"><span class="title">회원 
                        가입 </span></td>
                      <td width="28%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="../image/common/bg_titLine.gif" class="text_s">&nbsp;</td>
                    </tr>
                  </table> </td>
              </tr>
              <tr> 
                <td height="30" class="text_s"><strong><font color="990033">*</font></strong> 
                  <strong>표시</strong>는 필수 입력 사항입니다.</td>
              </tr>
            </table> 
			<form action="/join/PreJoinMemberProc.jsp" method="post" name="frmPreJoinMember" encType="multipart/form-data" onsubmit="return checkValidation(this)">
			
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" colspan="4" class="td_join"></td>
              </tr>
              <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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

                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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
				<input type=text name="JUMIN_NO1" class="textfield" VALUE="<%=strJuminNo1%>" readonly>
				<input type=text name="JUMIN_NO2" class="textfield" VALUE="<%=strJuminNo2%>" readonly>
				
				</td>
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
                <td height="25" colspan="2" class="td_lmagin"><input type=radio name="GENDER" VALUE="W" <%=strGender.equals("2")?"checked":""%>>여자<input type=radio name="GENDER" VALUE="M" <%=strGender.equals("1")?"checked":""%>>남자</td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  기관명<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="ORGAN_NM" type="text" class="textfield" style="WIDTH: 220px" readonly> 
				<input name="ORGAN_ID" type="hidden" > 
                  <img src="../image/button/bt_search_icon.gif" width="47" height="19" style="cursor:hand" align="absmiddle" onclick="winopen('/join/SearchOrgPop.jsp','SearchOrgPop','height=400,width=520,scrollbars=yes,resize=yes')"></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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
                <td colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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

                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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

                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  이동통신번호<font color="990033">*</font></td>
				  <input type=hidden name="CPHONE" >
                <td height="25" colspan="2" class="td_lmagin"><select name="CPHONE1" class="select" >
                    <option <%=strCphone1.equals("011")?"selected":""%> value="011">011</option>
                    <option <%=strCphone1.equals("016")?"selected":""%> value="016">016</option>
                    <option <%=strCphone1.equals("017")?"selected":""%> value="017">017</option>
                    <option <%=strCphone1.equals("018")?"selected":""%> value="018">018</option>
                    <option <%=strCphone1.equals("019")?"selected":""%> value="019">019</option>
                    <option <%=strCphone1.equals("010")?"selected":""%> value="010">010</option>
                    <option <%=strCphone1.equals("001")?"selected":""%> value="001">001</option>
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
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  우편번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">
					<input name="POST_CD" type="hidden"  >
					<input name="POST_CD1" type="text" class="textfield" style="WIDTH: 30px"  maxlength=3 readonly>
                  - 
                  <input name="POST_CD2" type="text" class="textfield" style="WIDTH: 30px" maxlength=3 readonly> 
                  <img src="../image/button/bt_searchZipCode.gif" width="96" height="19" align="absmiddle" style="cursor:hand" readonly onclick="winopen('/common/SearchZipCodePop.jsp','SearchZipCodePop','height=430,width=520,scrollbars=yes,resize=yes')"> 
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
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO1" type="text" class="textfield" style="WIDTH: 300px" readonly></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  상세주소<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO2" type="text" class="textfield" style="WIDTH: 300px"></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  담당업무</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="CG_DUTY" type="text" class="textfield" style="WIDTH: 300px" maxlength=15> </td>
              </tr>
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
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
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
              <tr> 
                <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  사진등록</td>
                <td height="25" colspan="2" class="td_lmagin">
				<!-- 버튼을 이미지로(파일업로드가 안됨)
				<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" > 
				<input name="selFile" type="file" class="textfield" style="WIDTH: 220px" > 
				<img src="../image/button/bt_find.gif" width="69" height="19" align="absmiddle" style='cursor:hand' onclick='document.all.selFile.click(); document.all.PHOTO_PATH.value=document.all.selFile.value'>
				-->
 				<input name="PHOTO_PATH" type="hidden" class="textfield" style="WIDTH: 220px" > 
				<input name="selFileShow" type="text" class="textfield" style="WIDTH: 220px" readonly><input name="selFile" type="file" class="textfield" style="WIDTH:0px" onChange="javascript:showImageFile('selFile', 'selFileShow');">
				<!-- <a href="javascript:viewFile();"><img src="/image/button/bt_preview_icon.gif" border=0></a> -->
				</td>
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
				<input type=image src="../image/button/bt_ok.gif">
				&nbsp;<img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand" onclick="document.location='/index.html'"></td>
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
	  <input type=hidden name="STT_CD" VALUE="005">
	  <input type=hidden name="STT_CHG_RSN" VALUE="사전신청을 하셨습니다.">
	  <input type=hidden name="USER_GRP_ID" VALUE="<%=strUserOutGrpId%>">
	  <input type=hidden name="SRCH_RECORD_CNT" VALUE="<%=strSrchRecordCnt%>">
	  <input type=hidden name="SRCH_DISPLAY_KIND" VALUE="<%=strSrchDisplayKind%>">
	  <input type=hidden name="GTHER_PERIOD" VALUE="<%=strGtherPeriod%>">
	  <input type=hidden name="GRD_CD" VALUE="">
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

frm.JUMIN_NO.value='7010301850023';
frm.CPHONE1.value='011';
frm.GTHER_PERIOD.value='7';
frm.JUSO1.value='목동';
frm.JUMIN_NO1.value='701030';
frm.ORGAN_NM.value='TEST';
frm.OFFICE_TEL.value='052-2344-1111';
frm.EMAIL.value='newpops@daum.net';
frm.JUMIN_NO2.value='2850023';
frm.CPHONE2.value='2031';
frm.JUSO2.value='1번지';
frm.DEPT_NM.value='부서명1';
frm.SRCH_RECORD_CNT.value='5';
//frm.CERT_DN.value='임시';
frm.STT_CHG_RSN.value='회원가입 신청을 성공적으로 마쳤습니다.';
frm.CG_DUTY.value='열심히';
frm.FAX_NO.value='02-3783-7800';
frm.POST_CD2.value='123';
frm.POST_CD.value='321123';
frm.CPHONE.value='011-2031-0016';
frm.SRCH_DISPLAY_KIND.value='001';
frm.USER_NM.value='양재경';
frm.FAX_NO1.value='02';
frm.FAX_NO2.value='3783';
frm.CPHONE3.value='0016';
frm.OFFICE_TEL1.value='052';
frm.REP_FLAG.value='';
frm.POST_CD1.value='321';
frm.OFFICE_TEL3.value='1111';
frm.REMARK.value='자기소개란입니다.';
frm.ORGAN_ID.value='';
frm.FAX_NO3.value='7800';
frm.OFFICE_TEL2.value='2344';

</script>
-->
