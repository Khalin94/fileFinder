<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<html>

<head>

<title>의정자료 전자유통 시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="/css/System.css" rel="stylesheet" type="text/css">

</head>



<%@ page import=" kr.co.kcc.bf.log.Log" %>

<%@ include file="./SelectUserInfoProc.jsp" %>











<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>

<title>상세 정보</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<link href="/css/System.css" rel="stylesheet" type="text/css">

</head>



<%

	String strHeight = "";

	

	if(strInoutGbn.equals("X") )

		strHeight = "550";

	else

		strHeight = "390";



%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:window.resizeTo(575, <%=strHeight%>);" >

<table width="570" height="363" border="0" cellpadding="0" cellspacing="0">

  <tr> 

    <td height="39" align="left" valign="top" background="/image/reqsubmit/bg_searchStaff.gif"><img src="/image/reqsubmit/searchStaff_top.gif" width="170" height="39"></td>

  </tr>

  <tr height="18"> 

    <td height="18" align="left" valign="top"></td>

  </tr>

  <tr> 

    <td align="center" valign="top"><table width="92%" border="0" cellspacing="0" cellpadding="0">

        <tr class="td_join"> 

          <td width="104" height="2"></td>

          <td height="2" colspan="2"></td>

        </tr>

        <tr> 

          <td rowspan="9" align="center" valign="middle" bgcolor="EAEAEA"><table width="90" height="100" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">







<%

	if(strPhotoPath.length()  < 1){

%>   



		<td align="center" bgcolor="ffffff">사진 없음</td>



<%

	}else{

%>

		<td align="center" bgcolor="ffffff">
		<%
			nads.lib.reqsubmit.encode.Base64Code base = new nads.lib.reqsubmit.encode.Base64Code();
			nads.lib.reqsubmit.util.HashEncrypt base2 = new nads.lib.reqsubmit.util.HashEncrypt();
		%>

             <img src="../../activity/mem_info_pic.jsp?mem_code=<%=base.encode(base2.encrypt(strPhotoPath))%>" width="90" height="100">

		</td>

<%

	}

%>		  





            </table></td>

          <td width="84" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            이름</td>

          <td width="160" height="25" class="td_lmagin"><%=strUserNm%></td>

        </tr>

        <tr height="1"> 

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line"></td>

        </tr>
        <!-- 성별표현 제거 2015.05.08 ksw -->
        <!-- <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            성별</td>

          <td class="td_lmagin"><%=strGender%></td>

        </tr>  -->

        <tr height="1"> 

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line"></td>

        </tr>



  <tr> 

    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

	<%

		String strInoutGbnWord = (strInoutGbn.equals("I")) ? "부서명":"기관명";

		out.print(strInoutGbnWord);

	%>

	</td>

    <td class="td_lmagin"><%=strOrganNm%></td>

  </tr>

  <tr height="1"> 

    <td height="1" class="tbl-line"></td>

    <td height="1" class="tbl-line"></td>

    <td height="1" class="tbl-line"></td>

  </tr>

<%

	String strOfficeTelColspan = "";

	if(strInoutGbn.equals("X")) {

%>

  <tr> 

    <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

      부서명</td>

    <td class="td_lmagin"><%=strDeptNm%></td>

  </tr>

  <tr height="1"> 

    <td height="1" class="tbl-line"></td>

    <td height="1" class="tbl-line"></td>

    <td height="1" class="tbl-line"></td>

  </tr>



<%

		strOfficeTelColspan = "colspan='2'";

	}



	

%>







        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            사무실 번호</td>
		 

          <td class="td_lmagin"><%=strOfficeTel%>
		  
		  </td>

        </tr>





        <tr height="1"> 

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line" <%=strOfficeTelColspan%>></td>

        </tr>

        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            사무실 FAX</td>

          <td class="td_lmagin"><%=strFaxNo1%>-<%=strFaxNo2%>-<%=strFaxNo3%></td>

        </tr>

        <tr height="1"> 

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line"></td>

        </tr>

        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            이동통신</td>

          <td height="25" colspan="2" class="td_lmagin"><%=strCphone1%>-<%=strCphone2%>-<%=strCphone3%></td>

        </tr>

        <tr class="tbl-line"> 

          <td height="1"></td>

          <td height="1" colspan="2"></td>

        </tr>



        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            e-mail</td>

          <td height="25" colspan="2" class="td_lmagin"><%=strEmail%></td>

        </tr>

        <tr class="tbl-line"> 

          <td height="1"></td>

          <td height="1" colspan="2"></td>

        </tr>







		<% if(strInoutGbn.equals("X")) { %>

        <tr> 

          <td rowspan="3" class="td_gray2">&nbsp;&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            담당업무</td>

          <td width="106" height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            주업무</td>



		<td width="303" height="45" class="td_lmagin"> 





<!-- 담당업무구분시작 -->

<%

		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();

	

	ArrayList objChargeInfoArry = new ArrayList();

	ArrayList objUserChargeArry = new ArrayList();



	try

	{



		

		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();

		objUserChargeArry = objUserInfoDelegate.selectUserCharge(strUserId);

		

		

	}

	catch(AppException objAppEx)

	{	

		//objMsgBean.setMsgType(MessageBean.TYPE_ERR);

  		//objMsgBean.setStrCode(objAppEx.getStrErrCode());

  		//objMsgBean.setStrMsg(objAppEx.getMessage());

  		Log.debug.println("Error!!!" + objAppEx.getMessage());

		strError = "yes";

%>

  	<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%  	

		return;

	}

	

%>





<!-- 담당업무시작 -->



		<%

		String strMsortCd = "";

		String strCdNm = "";

		

		String strType = "";

		String strCharge = "";

		

		String strChecked = "";

		String strDisabled = "";



		

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

                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> disabled ><%=strCdNm%>&nbsp;&nbsp;<br>

						



                       <SPAN id="MRK"> <input name="MRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15 readonly>&nbsp;&nbsp;</SPAN>

						



<%

			}else{

%>

                        <input name="mchr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> disabled><%=strCdNm%>&nbsp;&nbsp;



<%

			}

		}

%>                

		</td>

		</tr>



        <tr> 

          <td height="1" class="tbl-line"></td>

          <td height="1" class="tbl-line"></td>

        </tr>





        <tr>

        <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            부업무</td>

		<td height="45" class="td_lmagin">

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

                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%> disabled ><%=strCdNm%>&nbsp;&nbsp;<br>



					

                        <SPAN id="SRK"><input name="SRK" value="<%=strRemark%>"  class='textfield' style='WIDTH: 200px' maxlength=15 readonly>&nbsp;&nbsp;</SPAN>

						



<%



			}else{

%>

                        <input name="schr<%=Integer.toString(i)%>" type="checkbox" value="<%=strMsortCd%>"    <%=strChecked%>  <%=strDisabled%> disabled><%=strCdNm%>&nbsp;&nbsp;



<%

			}

		}

%>      

		</td>

        </tr>

<!-- 담당업무끝 -->  

		  

		  



        <tr class="tbl-line"> 

          <td height="1"></td>

          <td height="1" colspan="2"></td>

        </tr>

		<% } %>

        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            우편번호</td>

          <td height="25" colspan="2" class="td_lmagin"><%=strPostCd1%>-<%=strPostCd2%></td>

        </tr>

        <tr class="tbl-line"> 

          <td height="1"></td>

          <td height="1" colspan="2"></td>

        </tr>

        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            주소</td>

          <td height="25" colspan="2" class="td_lmagin"><%=strSttCd.equals("001")?strJuso1:""%></td>

        </tr>

        <tr class="tbl-line"> 

          <td height="1"></td>

          <td height="1" colspan="2"></td>

        </tr>

        <tr> 

          <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 

            상세주소</td>

          <td height="25" colspan="2" class="td_lmagin"><%=strSttCd.equals("001")?strJuso2:""%></td>

        </tr>

        <tr height="1" class="tbl-line"> 

          <td height="2"></td>

          <td height="2" colspan="2"></td>

        </tr>

      </table></td>

  </tr>

  <tr height="18"> 

    <td height="18" align="left" valign="top"></td>

  </tr>

  <tr height="25"> 

    <td height="25" align="right" valign="middle" class="td_gray1">&nbsp;<a href="javascript:self.close()"><img src="/image/button/bt_close.gif" width="46" height="11" border="0"></a>&nbsp;&nbsp;</td>

  </tr>

</table>

</body>

</html>



