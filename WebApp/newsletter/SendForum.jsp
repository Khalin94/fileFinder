<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.dsdm.app.activity.userinfo.UserInfoDelegate" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/> 

<%
	String webURL = ""; //http 주소
	try {

		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}

	String strGbn = StringUtil.getNVLNULL(request.getParameter("gbn")); 
	//구분자 (회원가입:joinUser 회원탈퇴:leaveUser 포럼회원가입:joinFUser 포럼회원탈퇴:leaveFUser)
	String strForumID = StringUtil.getNVLNULL(request.getParameter("fid")); //포럼id
	String strUserID = StringUtil.getNVLNULL(request.getParameter("uid")); //사용자id
	String strForumNM = StringUtil.getNVLNULL(request.getParameter("fNM")); //포럼명
	String strForumSort = StringUtil.getNVLNULL(request.getParameter("fSort")); //포럼분류
	strForumSort = strForumSort.replaceAll("@1","/");

	String strForumIntro = StringUtil.getNVLNULL(request.getParameter("fIntro")); //포럼소개
	strForumIntro = strForumIntro.replaceAll("@@","<br>&nbsp;&nbsp;&nbsp;&nbsp;");
	strForumIntro = strForumIntro.replaceAll("@1","/");

	String strForumForceLeaveRsn = StringUtil.getNVLNULL(request.getParameter("fRsn")); //포럼 강제탈퇴 사유

	String strSessInOutGbn =  StringUtil.getNVLNULL(request.getParameter("inout")); //내외부 구분
	//외부 이용자에게만 담당업무 표시

	String strOprtrGbn = StringUtil.getNVLNULL(request.getParameter("fOGbn")); //회원유형
	strOprtrGbn = (strOprtrGbn.equals("Y"))?"운영자":"회원";
	
	String strJoinTS = request.getParameter("fJTs"); //가입일
	if(strJoinTS.length() >= 8) {
		strJoinTS = strJoinTS.substring(0, 4) + "-" + strJoinTS.substring(4, 6) + "-" + strJoinTS.substring(6, 8);
	}


	Hashtable objUserInfoHt;
	ArrayList objChargeInfoArry = new ArrayList();
	ArrayList objUserChargeArry = new ArrayList();	
	UserInfoDelegate objUserInfoDelegate = new UserInfoDelegate();

	try {

		objUserInfoHt = objUserInfoDelegate.selectUserInfo(strUserID);

		if(strSessInOutGbn.equals("X")){
			objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();
			objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserID);
		}

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// 에러 발생 메세지 페이지로 이동한다.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}

%>	

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>
<style type='text/css'>
<!--
.title {
	FONT-WEIGHT: bold; FONT-SIZE: 15px; COLOR: #5c5c5c; FONT-FAMILY: 돋움,verdana,seoul,Arial ;letter-spacing: -1px 
}
-->
</style>

<style type='text/css'>
<!--
.TD {
     FONT-SIZE: 12px; COLOR: #5c5c5c; FONT-FAMILY: 돋움,verdana,seoul,Arial ;letter-spacing: 0.5px; line-height: 150%;
}
</style>

<style type='text/css'>
<!--
.text {
	font-family: 돋움,verdana,seoul,Arial
	font-size: 12px;
	line-height: 150%;
	color: 5c5c5c;
	text-decoration: none;
	font-weight: normal;
	text-align: justify;
}
-->
</style>
</head>
<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>
<%
	if((objUserInfoHt != null) && (objUserInfoHt.size() > 0)){
		String strUserNm = (String)objUserInfoHt.get("USER_NM");
		String strJuminNo = (String)objUserInfoHt.get("JUMIN_NO");
		String strGender = "";
		if(strJuminNo.length() >= 13){
			if((strJuminNo.substring(6,7).equals("1")) || (strJuminNo.substring(6,7).equals("3")))
				strGender = "남";

			if((strJuminNo.substring(6,7).equals("2")) || (strJuminNo.substring(6,7).equals("4")))
				strGender = "여";
			
			strJuminNo = strJuminNo.substring(0,6) + "-" + strJuminNo.substring(6,13);
		}

		String strOrganNm = (String)objUserInfoHt.get("ORGAN_NM");
		String strRegTs = (String)objUserInfoHt.get("REG_TS");
		String strInitDate = strRegTs.substring(0,4) + "년" + strRegTs.substring(4,6) + "월" + strRegTs.substring(6,8) + "일" ;
		String strDeptNm   = (String)objUserInfoHt.get("DEPT_NM");
		String strEmail   = (String)objUserInfoHt.get("EMAIL");
		String strOfficeTel   = (String)objUserInfoHt.get("OFFICE_TEL");
		String strFaxNo   = (String)objUserInfoHt.get("FAX_NO");
		String strCphone   = (String)objUserInfoHt.get("CPHONE");
		String strPostCd   = (String)objUserInfoHt.get("POST_CD");
		if(strPostCd.length() >= 6)
			strPostCd = "("+strPostCd.substring(0, 3) + "-"+strPostCd.substring(3, 6)+") ";

		String strJuso1   = (String)objUserInfoHt.get("JUSO1");
		String strJuso2   = (String)objUserInfoHt.get("JUSO2");
		String strRepFlag   = (String)objUserInfoHt.get("REP_FLAG");
		strRepFlag = (strRepFlag.equals("Y")) ? "대표담당자":"일반사용자";

		String strPhotoPath   = (String)objUserInfoHt.get("PHOTO_PATH");
		String strRemark   = (String)objUserInfoHt.get("REMARK");

/*
		String strRegTs = (String)objUserInfoHt.get("REG_TS");
		String strInoutGbn = (String)objUserInfoHt.get("INOUT_GBN");
		String strGovGbn = (String)objUserInfoHt.get("GOV_GBN");
*/
%>
<table width='588' border='0' cellpadding='0' cellspacing='3' bgcolor='E7E7E7'>
  <tr>
    <td align='left' valign='top'><table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='AAAAAA'>
        <tr>
          <td bgcolor='ffffff'><table width='100%' border='0' cellspacing='0' cellpadding='0'>
              <tr> 
                <td align='left' valign='top'><img src='<%=webURL%>/image/newsletter/img_forum.jpg' width='580' height='170' border='0' usemap='#Map'></td>
              </tr>
              <tr> 
                <td height='1' align='left' valign='top' bgcolor='DBDBDB'></td>
              </tr>
              <tr> 
                <td height='35' align='center' valign='middle'><table width='568' height='29' border='0' cellpadding='0' cellspacing='0' bgcolor='E7E7E7'>
                    <tr> 
                      <td width='30' align='center'><img src='<%=webURL%>/image/newsletter/icon_tit.gif' width='20' height='20'></td>
                      <td width='538' align='left' valign='middle' class='title'><font color='3F74BE'>[<%=strForumNM%>]</font>
						<%
							if(strGbn.equals("joinFUser"))
								out.print("포럼 회원으로 가입하셨습니다.");
							else
								out.print("포럼 회원에서 탈퇴하셨습니다.");
						%>
					  </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height='1' align='left' valign='top' bgcolor='DBDBDB'></td>
              </tr>
              <tr> 
                <td height='17' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td align='center' valign='top'><table width='87%' border='0' cellspacing='0' cellpadding='0'>
                    <tr> 
                      <td align='left' valign='top' class='TD'><strong><%=strUserNm%></strong>님 반갑습니다.<br>
                        의정자료 전자유통 시스템에서 운영하는 [<%=strForumNM%>]
						<%
							if(strGbn.equals("joinFUser"))
								out.print(" 포럼회원으로 가입하셨습니다.");
							else
								out.print(" 포럼회원에서 탈퇴하셨습니다.");
						%>
					  </td>
                    </tr>
                    <tr> 
                      <td align='left' valign='top' class='TD'>&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height='25' valign='middle'><img src='<%=webURL%>/image/newsletter/icon_soti.gif' width='9' height='9' align='absmiddle'> 
                        <span class='TD'><strong><font color='006699'>회원정보</font></strong></span></td>
                    </tr>
                    <tr height='5'> 
                      <td height='5' align='left' valign='top'></td>
                    </tr>
                    <tr> 
                      <td align='left' valign='top'><table width='100%' border='0' cellpadding='0' cellspacing='0' class='TD'>
                          <tr bgcolor='75B2D0'> 
                            <td width='26%' height='2'></td>
                            <td width='74%' height='2'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>포럼명</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;[<%=strForumSort%>]<%=strForumNM%></td>
                          </tr>
                          <tr bgcolor='E0E0E0' height='1'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>포럼소개</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strForumIntro%></td>
                          </tr>
                          <tr bgcolor='E0E0E0' height='1'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>

                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>회원유형</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strOprtrGbn%></td>
                          </tr>
                          <tr bgcolor='E0E0E0' height='1'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>가입일</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strJoinTS%></td>
                          </tr>
                          <tr bgcolor='E0E0E0' height='1'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
<!-- 가입인사말
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>가입인사말</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%//strRsn%></td>
                          </tr>
                          <tr bgcolor='E0E0E0' height='1'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
-->

						  <!-- 강제탈퇴시 사유 -->
						<%
							if(!strForumForceLeaveRsn.equals("")) {
								strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("@@", "<br>&nbsp;&nbsp;&nbsp;&nbsp;");
								strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("@1", "/");
						%>
							  <tr> 
								<td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
								  <strong>탈퇴사유</strong> </td>
								<td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strForumForceLeaveRsn%></td>
							  </tr>
							  <tr bgcolor='E0E0E0' height='1'> 
								<td height='1'></td>
								<td height='1'></td>
							  </tr>
						<%
							}
						%>
						  <!-- 회원기본정보 -->
                          <tr bgcolor='75B2D0'> 
                            <td width='26%' height='2'></td>
                            <td width='74%' height='2'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>이름</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strUserNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>성별</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strGender%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>

                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>소속기관</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strOrganNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>부서명</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strDeptNm%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
				<%
					if(strSessInOutGbn.equals("X")){ //외부사용자에게만 담당업무를 보여준다
				%>
						<!--
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>담당업무</strong> </td>
                            <td height='25'>
							<%
								String strMDutyWord = "";
								String strSDutyWord = "";
								String strMsortCd = "";
								String strCdNm = "";
								
								String strType = "";
								String strCharge = "";
								
								String strChecked = "";
								String strDisabled = "";
								String strFunction = "";
								String strChkName = "";
								String strSpace = "";
								String strMRemark = "";
								String strTextType="hidden";
								
								Hashtable objChargeInfoHt = new Hashtable();
								Hashtable objUserChargeHt = new Hashtable();
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");			
									
									strChecked = "";
									strDisabled = "";
									for(int k=0; k < objUserChargeArry.size(); k++){
										objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
										strType = (String)objUserChargeHt.get("CHARGE_TYPE");
										strCharge = (String)objUserChargeHt.get("CHARGE_CD");
										if(strType.equals("S") && !strCharge.equals("999")){  ////담당업무가 기타항목이 아닐 경우 적용
											if(strCharge.equals(strMsortCd)){
												strDisabled = "disabled";
												break;
											}
											continue;
										}
										if(strType.equals("M") && strCharge.equals(strMsortCd)){
											strChecked = "checked";
											if(!strCharge.equals("999")){   //담당업무가 기타항목에 적용
												strMDutyWord = strMDutyWord + "&nbsp;&nbsp;&nbsp;"+ strCdNm;
											} else {
												strMDutyWord = strMDutyWord + "&nbsp;&nbsp;&nbsp;"+ (String)objUserChargeHt.get("REMARK");
											}

											if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
												strMRemark = (String)objUserChargeHt.get("REMARK");
											}
											break;
										}
									}
									if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
										strDisabled = "";
										strChkName = "mchr999";
										strSpace = "";
										strFunction = "fun_make('m', '" + strMRemark + "')";
									}else{
										strChkName = "mchr" + Integer.toString(i);
										strFunction = "fun_check(this)";
										strSpace = "&nbsp;&nbsp;";
									}

								}

								// 부업무
								strChecked = "";
								strDisabled = "";
								strFunction = "";
								strTextType="hidden";
								strChkName = "";
								strSpace = "";
								String strSRemark = "";
								
								for(int i=0; i < objChargeInfoArry.size(); i++){
									objChargeInfoHt = (Hashtable)objChargeInfoArry.get(i);
									strMsortCd = (String)objChargeInfoHt.get("MSORT_CD");
									strCdNm = (String)objChargeInfoHt.get("CD_NM");
									
									strChecked = "";
									strDisabled = "";
									for(int k=0; k < objUserChargeArry.size(); k++){
										objUserChargeHt = (Hashtable)objUserChargeArry.get(k);
										strType = (String)objUserChargeHt.get("CHARGE_TYPE");
										strCharge = (String)objUserChargeHt.get("CHARGE_CD");
										if(strType.equals("M")){
											if(strCharge.equals(strMsortCd) && !strCharge.equals("999")){ //담당업무가 기타항목이 아닐 경우 적용
												strDisabled = "disabled";
												break;
											}
											continue;
										}
										if(strType.equals("S") && strCharge.equals(strMsortCd)){
											strChecked = "checked";

											if(!strCharge.equals("999")){   //담당업무가 기타항목에 적용
												strSDutyWord = strSDutyWord + "&nbsp;&nbsp;&nbsp;"+ strCdNm;
											} else {
												strSDutyWord = strSDutyWord + "&nbsp;&nbsp;&nbsp;"+ (String)objUserChargeHt.get("REMARK");
											}

											if(strCharge.equals("999")){   //담당업무가 기타항목에 적용
												strSRemark = (String)objUserChargeHt.get("REMARK");
											}
											break;
										}
									}
									if(strMsortCd.equals("999")){   //담당업무가 기타항목에 적용
										strDisabled = "";
										strSpace = "";
										strChkName = "schr999";
										strFunction = "fun_make('s', '" + strSRemark + "')";
									}else{
										strChkName = "schr" + Integer.toString(i);
										strFunction = "fun_checkm(this)";
										strSpace = "&nbsp;&nbsp;";
									}

								}
							%>
							&nbsp;&nbsp;&nbsp;&nbsp;<b>주업무 : </b><%=strMDutyWord%>
							<br>&nbsp;&nbsp;&nbsp;&nbsp;<b>부업무 : </b><%=strSDutyWord%>
							</td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
						-->
				<%
					}
				%>

				<%
					if(strGbn.equals("joinFUser")) { //가입메일일 경우에만 표시
				%>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>e-mail</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strEmail%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>사무실</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strOfficeTel%></td>
                          </tr>
                          <tr height='1' bgcolor='E0E0E0'> 
                            <td height='1'></td>
                            <td height='1'></td>
                          </tr>
                          <tr> 
                            <td height='25' bgcolor='F5F5F5'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src='<%=webURL%>/image/newsletter/icon_nemo_gray.gif' width='3' height='6'> 
                              <strong>이동통신번호</strong> </td>
                            <td height='25'>&nbsp;&nbsp;&nbsp;&nbsp;<%=strCphone%></td>
                          </tr>
                          <tr height='2' bgcolor='E0E0E0'> 
                            <td height='2'></td>
                            <td height='2'></td>
                          </tr>
				<%
					}
				%>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height='15' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td height='20' align='center' valign='top'><table width='87%' border='0' cellspacing='0' cellpadding='0'>
                    <tr> 
                      <td align='right' valign='top'><a href='<%=webURL%>'><img src='<%=webURL%>/image/newsletter/bt_goNaps.gif' width='107' height='20' border=0></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height='35' align='left' valign='top'>&nbsp;</td>
              </tr>
              <tr> 
                <td align='left' valign='top'><img src='<%=webURL%>/image/newsletter/copyright.gif' width='580' height='47'></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<p class='text'>&nbsp;</p>
<p class='text'>&nbsp;</p>
<p class='title'>&nbsp; </p>
<map name='Map'>
  <area shape='rect' coords='5,3,191,40' href='#'>
</map>

<%
	} //end if(objHashData)
%>
</body>
</html>