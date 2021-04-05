<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strMessage = "";
	String strError = "no";

	String strDeptNm   = "";
	String strEmail   = "";
	String strOfficeTel   = "";
	String strFaxNo   = "";
	String strCphone   = "";
	String strPostCd   = "";
	String strJuso1   = "";
	String strJuso2   = "";
	String strCgDuty   = "";
	String strRepFlag   = "";
	String strPhotoPath   = "";
	String strRemark   = "";
	
	String strOfficeTel1 = "";
	String strOfficeTel2 = "";
	String strOfficeTel3 = "";
	
	String strFaxNo1 = "";
	String strFaxNo2 = "";
	String strFaxNo3 = "";
	
	String strCphone1 = "";
	String strCphone2 = "";
	String strCphone3 = "";
	
	String strRepFlagY   = "";
	String strRepFlagN   = "";
	
	String strPostCd1   = "";
	String strPostCd2   = "";
	
	String strCphone1_010 = "";
	String strCphone1_011 = "";
	String strCphone1_016 = "";
	String strCphone1_017 = "";
	String strCphone1_018 = "";
	String strCphone1_019 = "";
	String strUserId   = ""; 
	String strUserNm = "";
	String strOrganNm = "";
	String strJuminNo = "";
	String strRegTs = "";
	String strGender = "";
	String strInitDate = "";

	//2004.6.7 추가
	String strInoutGbn = "";
	String strSttCd= "";
	String strInnerPhone = "";
	
	
	try
	{
		strUserId = StringUtil.getNVLNULL(request.getParameter("UserId"));
		//System.out.println(strUserId);

		//선택한 부서가 없을경우 로그인한 사용자의 정보 조회
		if(strUserId.equals(""))
			strUserId = (String)session.getAttribute("USER_ID");


		String strFileUrl = AdminIo.getUrl();
		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
		
		Hashtable objUserInfoHt = objUserInfoDelegate.selectUserInfo(strUserId);
		Hashtable objUserStatusHt = objUserInfoDelegate.selectStatus(strUserId);

		strSttCd   = (String)objUserStatusHt.get("STT_CD");
		strDeptNm   = (String)objUserInfoHt.get("DEPT_NM");
		strEmail   = (String)objUserInfoHt.get("EMAIL");
		strOfficeTel   = (String)objUserInfoHt.get("OFFICE_TEL");
		strFaxNo   = (String)objUserInfoHt.get("FAX_NO");
		strCphone   = (String)objUserInfoHt.get("CPHONE");
		strPostCd   = (String)objUserInfoHt.get("POST_CD");
		strJuso1   = (String)objUserInfoHt.get("JUSO1");
		strJuso2   = (String)objUserInfoHt.get("JUSO2");
		strCgDuty   = (String)objUserInfoHt.get("CG_DUTY");
		strRepFlag   = (String)objUserInfoHt.get("REP_FLAG");
		strPhotoPath   = (String)objUserInfoHt.get("PHOTO_PATH");
		strRemark   = (String)objUserInfoHt.get("REMARK");
		strUserNm = (String)objUserInfoHt.get("USER_NM");
		strOrganNm = (String)objUserInfoHt.get("ORGAN_NM");
		strJuminNo = (String)objUserInfoHt.get("JUMIN_NO");
		strRegTs = (String)objUserInfoHt.get("REG_TS");
		strInnerPhone = (String)objUserInfoHt.get("INNERPHONE");	
		strInitDate = strRegTs.substring(0,4) + "년" + strRegTs.substring(4,6) + "월" + strRegTs.substring(6,8) + "일" ;
		if(strPhotoPath.length()  > 0) 
			strPhotoPath = strPhotoPath;
		
		if(strJuminNo.length() >= 13){
			if((strJuminNo.substring(6,7).equals("1")) || (strJuminNo.substring(6,7).equals("3")))
				strGender = "남";
			
			if((strJuminNo.substring(6,7).equals("2")) || (strJuminNo.substring(6,7).equals("4")))
				strGender = "여";
					
			strJuminNo = strJuminNo.substring(0,6) + "-" + strJuminNo.substring(6,13);
		}
		
		strInoutGbn = (String)objUserInfoHt.get("INOUT_GBN"); //내외부 구분

		Vector objOfficeTel = nads.lib.util.ActComm.makeNoType(strOfficeTel, "-");
		Vector objFaxNo = nads.lib.util.ActComm.makeNoType(strFaxNo, "-");
		Vector objCphone = nads.lib.util.ActComm.makeNoType(strCphone, "-");
		
		for(int i=0; i<objOfficeTel.size(); i++){
			switch (i){
				case 0:
					strOfficeTel1 = (String)objOfficeTel.elementAt(i);
					break;
				case 1:
					strOfficeTel2 = (String)objOfficeTel.elementAt(i);
					break;
				case 2:
					strOfficeTel3 = (String)objOfficeTel.elementAt(i);
					break;
			}
		}

		for(int i=0; i<objFaxNo.size(); i++){
			switch (i){
				case 0:
					strFaxNo1 = (String)objFaxNo.elementAt(i);
					break;
				case 1:
					strFaxNo2 = (String)objFaxNo.elementAt(i);
					break;
				case 2:
					strFaxNo3 = (String)objFaxNo.elementAt(i);
					break;
			}
		}

		for(int i=0; i<objCphone.size(); i++){
			switch (i){
				case 0:
					strCphone1 = (String)objCphone.elementAt(i);
					break;
				case 1:
					strCphone2 = (String)objCphone.elementAt(i);
					break;
				case 2:
					strCphone3 = (String)objCphone.elementAt(i);
					break;
			}
		}	
		if(strCphone1.equals("010"))  strCphone1_010 = "selected";
		if(strCphone1.equals("011"))  strCphone1_011 = "selected";
		if(strCphone1.equals("016"))  strCphone1_016 = "selected";
		if(strCphone1.equals("017"))  strCphone1_017 = "selected";		
		if(strCphone1.equals("018"))  strCphone1_018 = "selected";
		if(strCphone1.equals("019"))  strCphone1_019 = "selected";		
			 
		if(strRepFlag.equals("Y")){
			strRepFlagY = "checked";
		}else{
			strRepFlagN = "checked";
		}	
		
		if(strPostCd.length() >= 6){
			strPostCd1 = strPostCd.substring(0, 3);
			strPostCd2 = strPostCd.substring(3, 6);
		}else if(strPostCd.length() >= 3){
			strPostCd1 = strPostCd.substring(0, 3);
		}else{
			strPostCd1 = strPostCd;
		}
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>