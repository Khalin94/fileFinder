<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>사전가입후 인쇄</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script src="/js/common.js"></script>
<script src="/js/validate.js" ></script>
</head>


<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import=" kr.co.kcc.bf.log.Log" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="java.text.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%

	String webPath = ""; //이미지 저장할 물리적 경로
	String imgPath = ""; //사진이미지 경로

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("user.photo.path");

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


	String strImgPath = webPath + imgPath;
	String strFullPath = webPath + imgPath;
 	File objDir = new File(strImgPath); // 저장할 디렉토리 (절대경로)
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}

	int intSizeLimit = 50 * 1024 *1024 ; // 50k까지 제한 넘어서면 예외발생

 	MultipartRequest multi=new MultipartRequest(request, strImgPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());

	String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	String fileKind = "";

	String strJuminNo = multi.getParameter("JUMIN_NO");
	String strMessage = "";
%>
<!-- 담당업무구분시작 -->
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




<body bgcolor="F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

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
			<form action="/join/JoinMemberProc.jsp" method="post" name="frmPreJoinMember">
			<input type=hidden name="CERT_DN" VALUE=<%=request.getParameter("CERT_DN")%>>
            <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td height="2" colspan="4" class="td_join"></td>
              </tr>
              <td height="25" colspan="2" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                이름<font color="990033">*</font></td>
              <td height="25" colspan="2" class="td_lmagin"><input name="USER_NM" type="text" class="textfield" style="WIDTH: 220px" >
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
				String strGender = "";
				
 
				if(strJuminNo != null&&strJuminNo.equals("") != true){
					strJuminNo1 = strJuminNo.substring(0,6);
					strJuminNo2 = strJuminNo.substring(6,13);

					if(strJuminNo2.substring(0,1).equals("1") || strJuminNo2.substring(0,1).equals("3"))
						strGender = "m";
					else
						strGender = "f";

		
				}

			  %>
                  주민등록번호<font color="990033">*</font></td>
                <td height="25" colspan="2" class="td_lmagin">
				<%=strJuminNo1%>-<%=strJuminNo2%>
				<input type=hidden name="JUMIN_NO" VALUE=<%=strJuminNo%>>
				<input type=hidden name="JUMIN_NO1" VALUE=<%=strJuminNo%>>
				<input type=hidden name="JUMIN_NO2" VALUE=<%=strJuminNo%>>
				
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

                <td height="25" colspan="2" class="td_lmagin"><input type=radio name="GENDER" VALUE="W" <%=strGender.equals("f")?"checked":""%>>여자<input type=radio name="GENDER" VALUE="M" <%=strGender.equals("m")?"checked":""%>>남자</td>
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
                <td height="25" colspan="2" class="td_lmagin"><input name="ORGAN_NM" type="text" class="textfield" style="WIDTH: 220px"> <input name="ORGAN_ID" type="hidden" class="textfield" style="WIDTH: 220px"> 
                  <img src="../image/button/bt_search_icon.gif" width="47" height="19" align="absmiddle"></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td colspan="2"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  부서명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="DEPT_NM" type="text" class="textfield" style="WIDTH: 300px" </td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td colspan="2"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  직급명</td>
                <td height="25" colspan="2" class="td_lmagin"><input name="GRD_NM" type="text" class="textfield" style="WIDTH: 300px" </td>
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


                <td height="25"  class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  이동통신번호<font color="990033">*</font></td>
				  <input type=hidden name="CPHONE" >
                <td height="25" colspan="2" class="td_lmagin"><select name="CPHONE1" class="select" >
                    <option value="011">011</option>
                    <option value="016">016</option>
                    <option value="017">017</option>
                    <option value="018">018</option>
                    <option value="019">019</option>
                    <option value="010">010</option>
                    <option value="001">001</option>
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
				<%
					String strPostCd = "";
					String strPostCd1 = "";
					String strPostCd2 = "";

					
				%>
					<input name="POST_CD" type="hidden"  >
					<input name="POST_CD1" type="text" class="textfield" style="WIDTH: 30px"  maxlength=3>
                  - 
                  <input name="POST_CD2" type="text" class="textfield" style="WIDTH: 30px" maxlength=3> 
                  <img src="../image/button/bt_searchZipCode.gif" width="96" height="19" align="absmiddle"> 
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
                <td height="25" colspan="2" class="td_lmagin"><input name="JUSO1" type="text" class="textfield" style="WIDTH: 300px" ></td>
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
	
		
		Hashtable objChargeInfoHt = new Hashtable();

		for(int i=0; i < objChargeInfoArry.size(); i++){
			objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
			strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
			strCdNm = (String)objChargeInfoHt.get("CD_NM");	
			
			if(multi.getParameter("mchr"+i) != null)
				strChecked = "checked"; 			

			if(strMsortCd.equals("999")){
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  disabled onclick="makeTextBox(this,'mainJob')"><%=strCdNm%>&nbsp;&nbsp;
<%
			}else{
%>
                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  disabled onclick="fun_check(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
		strChecked = "";
		}
%>                      
<DIV ID="mainJob" ></DIV>
<input type='text' name='MRK' class='textfield' style='WIDTH: 300px' maxlength=25 >

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
			
		
			if(multi.getParameter("schr"+i) != null)
				strChecked = "checked"; 

			if(strMsortCd.equals("999")){
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> disabled onclick="makeTextBox(this,'subJob')"><%=strCdNm%>&nbsp;&nbsp;
<%
			}else{
%>
                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  disabled onclick="fun_checkm(this)"><%=strCdNm%>&nbsp;&nbsp;

<%
			}
			strChecked = "";
		}
%>  
<DIV ID="subJob"></DIV>
<input type='text' name='SRK' class='textfield' style='WIDTH: 300px' maxlength=25 >
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
				String strRepFlag = multi.getParameter("REP_FLAG");
				
				
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
                <td height="25" colspan="2" class="td_lmagin"><input name="PHOTO_PATH" type="text" class="textfield" style="WIDTH: 220px" >
				<input name="selFileShow" type="hidden" class="textfield" style="WIDTH: 220px">
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
                <td width="474" height="30" align="left"><img src="../image/button/bt_printing.gif" width="43" height="20" onclick="winopen('/join/PrintUserInfo.jsp','PrintUserInfo','height=550,width=650,scrollbars=yes,resize=yes')"" style="cursor:hand">&nbsp;<img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand" onclick="window.location='/index.html'"></td>
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
	  <input type=hidden name="USER_GRP_ID" >
	  <input type=hidden name="SRCH_RECORD_CNT" >
	  <input type=hidden name="SRCH_DISPLAY_KIND" >
	  <input type=hidden name="GTHER_PERIOD" >
	  <input type=hidden name="GRD_CD">
	  <input type=hidden name="CG_DUTY">
	  <input type=hidden name="ORG_POSI_GBN" >
	  <input type=hidden name="REQ_SUBMT_FLAG" >

	  </form>
	  </td>
  </tr>
  <tr> 
    <td height="35" align="left" valign="top">&nbsp;</td>
  </tr>
</table>


<%

	Enumeration formNames = multi.getFileNames();
	String strFormName=(String)formNames.nextElement(); 		// 자료가 많을 경우엔 while 문을 사용		
	String strFileName = multi.getFilesystemName(strFormName); 	// 파일의 이름 얻기
	String strOrgName = multi.getOriginalFileName(strFormName);
	File objFile = multi.getFile(strFormName);
	
	if(strFileName == null) {   // 파일이 업로드 되지 않았을때
	
		Log.debug.print("파일 업로드 되지 않았음");
		
	} else {  // 파일이 업로드 되었을때
		strImgPath = imgPath+strFileName;

		if(strFileName.lastIndexOf(".") > 0) {
			fileKind = strFileName.substring(strFileName.lastIndexOf("."));
		}

		File uploadImg = new File(strFullPath,strFileName);
		File renameImg = new File(strFullPath,realDate+fileKind);

		if(uploadImg.renameTo(renameImg) == true) {
			strImgPath = imgPath + renameImg.getName();
		}

		/*
		out.print("Form Name : " + strFormName + "<BR>");
		out.print("File Name  : " + strFileName + "<BR>");
		out.print("Org File Name " + strOrgName + "<BR>");
		out.println("File length : " + objFile.length() + "<br>");
		out.print("===============================<br>");
		*/
	}
	


	
	Enumeration objEnuNames = multi.getParameterNames();
	String strParamName = "";
	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	Vector objVctMain = new Vector();
	Vector objVctSub = new Vector();

	out.println("<script language='javascript'>");
	for(int i =0;objEnuNames.hasMoreElements() ;){
		strParamName = (String)objEnuNames.nextElement();
		Log.debug.println(strParamName+":"+multi.getParameter(strParamName));
		
		//파라미터 설정
		if(strParamName.indexOf("mchr") > -1 )
		{
			Log.debug.println("strParamName main===========>"+multi.getParameter(strParamName));
			objVctMain.add(	multi.getParameter(strParamName));

		}else if(strParamName.indexOf("schr") > -1 )
		{
			Log.debug.println("strParamName sub===========>"+multi.getParameter(strParamName));
			objVctSub.add(	multi.getParameter(strParamName));

		}else {
			objHshReqUserInfo.put(strParamName,multi.getParameter(strParamName));
		}

		if(strParamName.equals("x") || strParamName.equals("y") )
			continue;
		out.println("document.frmPreJoinMember."+strParamName+".value='"+multi.getParameter(strParamName)+"';");

		
	}
	objHshReqUserInfo.put("M",objVctMain);
	objHshReqUserInfo.put("S",objVctSub);

	Log.debug.println("objVctMain:"+objVctMain.size());
	Log.debug.println("objVctSub:"+objVctSub.size());


	if(strFileName != null){
		objHshReqUserInfo.put("PHOTO_PATH",strImgPath);
		out.println("document.frmPreJoinMember.PHOTO_PATH.value='"+realDate+fileKind+"'");
	}
    
	out.println("</script>");
	Log.debug.println("===>"+imgPath+strFileName);

	try
	{	



		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		String strResult = objJoinMemberDelegate.preJoinMember(objHshReqUserInfo);

		if(strResult.equals("005"))
			out.println("<script>alert('관리자가 가입처리를 진행중입니다'); document.location = '/index.html';</script>");

	

		//--response.sendRedirect("SendFax.jsp");
	}
	catch(Exception objExcept)
	{	

		strMessage = strMessage + "[예외발생]" + objExcept.toString();
		String strErrCode = ((AppException)objExcept).getStrErrCode();

		Log.debug.println(strMessage);

		if(strErrCode.equals("ORA-00001")){
			out.println("<script>alert('관리자가 가입처리를 진행중입니다'); document.location = '/index.html';</script>");
		}else{
	

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("SYS-00001");
			objMsgBean.setStrMsg(objExcept.getMessage());
	
			
			
		// 에러 발생 메세지 페이지로 이동한다.
%>
		   <jsp:forward page="/common/message/ViewMsg.jsp"/>	
<%
		   return;
		}
	}
	
%>

</body>


