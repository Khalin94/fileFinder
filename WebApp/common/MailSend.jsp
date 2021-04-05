<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="java.io.*" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	/* 받아올 파라미터 */
	String strGbn = StringUtil.getNVLNULL(request.getParameter("gbn")); 
	//구분자 (회원가입:joinUser 회원탈퇴:leaveUser 포럼회원가입:joinFUser 포럼회원탈퇴:leaveFUser)
	String strForumID = StringUtil.getNVLNULL(request.getParameter("fid")); //포럼ID
	String strRUserID = StringUtil.getNVLNULL(request.getParameter("Ruid")); //수신자ID
	String strForumForceLeaveRsn = StringUtil.getNVLNULL(request.getParameter("fRsn")); //포럼 강제탈퇴 사유

	String strSessInOutGbn = (String)session.getAttribute("INOUT_GBN");

	/*
	SELECT A.FORUM_NM, D.CD_NM FORUM_SORT, A.FORUM_INTRO, 
		   B.JOIN_TS, B.OPRTR_GBN, B.JOIN_RSN,  
		   C.USER_NM R_USER_NM, C.CPHONE, C.DEPT_NM R_DEPT_NM, C.EMAIL R_EMAIL,
	       E.USER_ID S_USER_ID, E.USER_NM S_USER_NM, E.EMAIL S_EMAIL, G.ORGAN_NM S_ORGAN_NM, G.GOV_STD_CD S_GOV_STD_CD
	FROM TBDM_FORUM A, TBDM_FORUM_USER B, TBDM_USER_INFO C, TBDM_CD_INFO D, TBDM_USER_INFO E, TBDM_BRG_DEPT F, TBDM_ORGAN G
	WHERE A.FORUM_ID = '0000000035'
	AND A.FORUM_ID = B.FORUM_ID
	AND B.USER_ID = '0000018684'
	AND B.USER_ID = C.USER_ID
	AND D.BSORT_CD = 'M02'
	AND A.FORUM_SORT = D.MSORT_CD
	AND A.FORUM_OPRTR_ID = E.USER_ID
	AND F.USER_ID = E.USER_ID
	AND F.ORG_POSI_GBN = '1'
	AND F.ORGAN_ID = G.ORGAN_ID

 	SELECT A.USER_NM R_USER_NM, A.CPHONE, NVL(A.DEPT_NM, F.ORGAN_NM) R_DEPT_NM, A.EMAIL R_EMAIL, 
		   B.USER_ID S_USER_ID, B.USER_NM S_USER_NM, B.EMAIL S_EMAIL, D.ORGAN_NM S_ORGAN_NM, D.GOV_STD_CD S_GOV_STD_CD 
	FROM TBDM_USER_INFO A,  TBDM_BRG_DEPT E, TBDM_ORGAN F, 
						(SELECT USER_ID, USER_NM, EMAIL
						FROM TBDM_USER_INFO
						WHERE USER_GRP_ID = '0000000002'
						AND ROWNUM < 2) B, TBDM_BRG_DEPT C, TBDM_ORGAN D
	WHERE A.USER_ID = '0000020711'
	AND A.USER_ID = E.USER_ID
	AND E.ORG_POSI_GBN = '1'
	AND E.ORGAN_ID = F.ORGAN_ID
	AND B.USER_ID = C.USER_ID
	AND C.ORG_POSI_GBN = '1'
	AND C.ORGAN_ID = D.ORGAN_I
	*/

	
	String strForumNM = "";
	String strForumSort = "";
	String strForumIntro = "";
	String strForumJoinTS = "";
	String strForumOprtrGbn = "";
	//String strForumJoinRsn = "";

	String strRUserNM = "";
	//String strCPhone = "";
	//String strRDeptNM = "";
	String strREmail = "";

	String strSUserID = "";
	String strSUserNM = "";
	String strSOrganNM = "";
	String strSEmail = "";
	String strSGovStdCd = "";
	String strSOrganID = "";

	/* DB로부터 메일에 보낼 정보 읽어오기 START */
	try {

		SLDBForumDelegate objForum = new SLDBForumDelegate();

		Hashtable objHashData = objForum.selectMailInfo(strForumID, strRUserID);

		if(!strForumID.equals("")) {
			strForumNM = StringUtil.getNVLNULL((String)objHashData.get("FORUM_NM")); //포럼명
			strForumSort = StringUtil.getNVLNULL((String)objHashData.get("FORUM_SORT")); //포럼분류
			strForumSort = strForumSort.replaceAll("/","@1");

			strForumIntro = StringUtil.getNVLNULL((String)objHashData.get("FORUM_INTRO")); //포럼소개
			strForumIntro = strForumIntro.replaceAll("\n","@@");
			strForumIntro = strForumIntro.replaceAll("\r","");
			strForumIntro = strForumIntro.replaceAll("/","@1");

			strForumJoinTS =  StringUtil.getNVLNULL((String)objHashData.get("JOIN_TS")); //가입일자
			strForumOprtrGbn =  StringUtil.getNVLNULL((String)objHashData.get("OPRTR_GBN")); //회원유형
			//strForumJoinRsn =  StringUtil.getNVLNULL((String)objHashData.get("JOIN_RSN")); //가입인사말
		}

		strRUserNM = StringUtil.getNVLNULL((String)objHashData.get("R_USER_NM")); //수신자이름
		//strCPhone = StringUtil.getNVLNULL((String)objHashData.get("CPHONE")); //전화번호
		strREmail = StringUtil.getNVLNULL((String)objHashData.get("R_EMAIL")); //수신자이메일
		//strRDeptNM = StringUtil.getNVLNULL((String)objHashData.get("R_DEPT_NM")); //수신자부서명

		strSUserID = StringUtil.getNVLNULL((String)objHashData.get("S_USER_ID")); //발신자ID
		strSUserNM = StringUtil.getNVLNULL((String)objHashData.get("S_USER_NM")); //발신자이름
		strSEmail = StringUtil.getNVLNULL((String)objHashData.get("S_EMAIL")); //발신자이메일
		strSOrganNM = StringUtil.getNVLNULL((String)objHashData.get("S_ORGAN_NM")); //발신자부서명
		strSGovStdCd = StringUtil.getNVLNULL((String)objHashData.get("S_GOV_STD_CD")); //발신자부서ID
		strSOrganID = StringUtil.getNVLNULL((String)objHashData.get("S_ORGAN_ID")); //발신자부서ID (변경됨)
		if(strSGovStdCd.equals(""))
			strSGovStdCd = "0000000";

		if(strSOrganID.equals(""))
			strSOrganID = "0000000000";
		
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
	/* DB로부터 메일에 보낼 정보 읽어오기 END */


	/* 메일내용 START */
	String webURL = ""; //http 주소
	try {

		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}

	String strMailContentURL = webURL + "/newsletter/";

	if(strForumID.equals("")) { //회원가입/탈퇴
		strMailContentURL += "SendUser.jsp?gbn="+strGbn+"&inout="+strSessInOutGbn+"&uid="+strRUserID;
	} else {
		strMailContentURL += "SendForum.jsp?gbn="+strGbn+"&inout="+strSessInOutGbn+"&uid="+strRUserID;
		strMailContentURL += "&fNM=" + strForumNM + "&fSort=" + strForumSort + "&fIntro="+ strForumIntro;
		strMailContentURL += "&fJTs=" + strForumJoinTS + "&fOGbn=" + strForumOprtrGbn;
	}

	//strMailContentURL += "&uNM=" + strRUserNM + "&cPH=" + strCPhone + "&dNM=" + strRDeptNM + "&eM=" + strREmail;

	if(!strForumForceLeaveRsn.equals("")) {
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("\n","@@");
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("\r","");
		strForumForceLeaveRsn = strForumForceLeaveRsn.replaceAll("/","@1");
		strMailContentURL += "&fRsn=" + strForumForceLeaveRsn;
	}

	//out.print(strMailContentURL+"<br>length:"+strMailContentURL.length());
	/* 메일내용 END */


	/* 메일보내기 START */
	try {

		UmsInfoDelegate objUmsInfo = new UmsInfoDelegate();
		Hashtable objHashData = new Hashtable();
		int intResult = 0;

		String strSubject   = ""; //제목
		String strServiceGbn = ""; //서비스구분 (회원가입:001 회원탈퇴:002 포럼회원가입:003 포럼회원탈퇴:004)
		if(strGbn.equals("joinUser")) {
			strSubject = "[의정자료 전자유통 시스템]사용자등록을 축하드립니다.";
			strServiceGbn = "001";
		} else if(strGbn.equals("leaveUser")) {
			strSubject = "[의정자료 전자유통 시스템]사용자탈퇴 되었습니다.";
			strServiceGbn = "002";
		} else if(strGbn.equals("joinFUser")) {
			strSubject = "[의정자료 전자유통 시스템]" + strForumNM + " 포럼가입을 축하드립니다.";
			strServiceGbn = "003";
		} else {
			strSubject = "[의정자료 전자유통 시스템]" + strForumNM + " 포럼 탈퇴하셨습니다.";
			strServiceGbn = "004";
		}

		String strStatus    = "0"; //전송상태(전송대기='9' 전송요청 = '0')
		String strSystemGbn  = "S13002"; //시스템구분(정보관리:S13002)

		//수신자정보
		objHashData.put("RID", strRUserID); //수신자ID
		objHashData.put("RNAME", strRUserNM); //수신자명
		objHashData.put("RMAIL", strREmail); //수신자 이메일
		//발신자정보
		objHashData.put("SID", strSUserID); //발신자ID
		objHashData.put("SNAME", strSUserNM); //발신자명
		objHashData.put("SMAIL", strSEmail); //발신자 이메일

		objHashData.put("SUBJECT", strSubject); //제목
		objHashData.put("CONTENTS", strMailContentURL); //내용
		objHashData.put("SYSTEM_GBN", strSystemGbn); //시스템구분
		objHashData.put("SERVICE_GBN", strServiceGbn); //서비스구분
		objHashData.put("STATUS", strStatus); //전송상태
		//objHashData.put("DEPT_GBN", strSGovStdCd); //부서구분(부서ID)
		objHashData.put("DEPT_GBN", strSOrganID); //부서구분(부서ID)
		objHashData.put("DEPT_NM", strSOrganNM); //부서명

		intResult = objUmsInfo.insertSMTP_WEB_REC(objHashData);
		
		if(intResult != 0 ){
			//out.println("<br>생성 성공<br>");
		}

		if (intResult < 1) {
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
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

	//out.print("<br>메일 보내기 성공");
	/* 메일보내기 END */
%>