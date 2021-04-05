<html>
<head>
<title>로그인</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/global.css" rel="stylesheet" type="text/css">
<link href="../css/System.css" rel="stylesheet" type="text/css">
</head>

<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="java.util.*"%>

<%

	String strUserId= request.getParameter("USER_ID") ;
	String strPwd= request.getParameter("PWD");

	System.out.println("CLIENT_ID : "+strUserId);
	System.out.println("CLIENT_PWD : "+strPwd);

	//사용자 아이피를 얻어 세션값에 저장.
	String strClientIP = request.getHeader("Proxy-Client-IP");
%>
<%
	System.out.println("헤더 값<br>");
	for (java.util.Enumeration<?> e = request.getHeaderNames(); e.hasMoreElements();) {
	  String attr = e.nextElement().toString();
	  Object value = (Object)request.getHeader(attr);
	  System.out.println(attr + " : " + value);
	  System.out.println("<br>");
	}
%>
<%
    String strUrl="";

	java.util.Hashtable objHshUserInfo = new java.util.Hashtable();

	System.out.println("IPADRESS : "+request.getHeader("Proxy-Client-IP"));
	
	objHshUserInfo.put("USER_ID",strUserId);
	objHshUserInfo.put("PWD",strPwd);

System.out.println( "strUserId : " + strUserId);
System.out.println( "strPwd : " + strPwd);

	try
	{
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		objHshUserInfo = objJoinMemberDelegate.loginUser(objHshUserInfo);
System.out.println("objHshUserInfo : " + objHshUserInfo);
		Log.debug.println("[JSP] Delegate Method Call....끝");

		HttpSession objSession = request.getSession();
System.out.println("objSession : " + objSession);
		boolean isSuccess = ((Boolean)objHshUserInfo.get("isSuccess")).booleanValue();

System.out.println("isSuccess : " + isSuccess);

		//성공하면 세션정보를 셋팅
		if (isSuccess){

			strUrl = "/main.jsp";
			String strIsRequester = (String)objHshUserInfo.get("REQ_SUBMT_FLAG");
			strIsRequester = strIsRequester.equals("002") == true ? "false":"true";
			objSession.setAttribute("USER_ID",strUserId);
			objSession.setAttribute("USER_NM",objHshUserInfo.get("USER_NM"));
			objSession.setAttribute("ORGAN_ID",objHshUserInfo.get("ORGAN_ID"));
			objSession.setAttribute("REQ_SUBMT_FLAG",objHshUserInfo.get("REQ_SUBMT_FLAG"));
			objSession.setAttribute("IS_REQUESTER",strIsRequester);
			objSession.setAttribute("ORGAN_KIND",objHshUserInfo.get("ORGAN_KIND"));
			objSession.setAttribute("ORG_POSI_GBN",objHshUserInfo.get("ORG_POSI_GBN"));
			String strsrch_record_cnt = "";
			if(((String)objHshUserInfo.get("SRCH_RECORD_CNT")).equals("") || objHshUserInfo.get("SRCH_RECORD_CNT") == null){
				strsrch_record_cnt = "10";
			}else{
				strsrch_record_cnt = (String)objHshUserInfo.get("SRCH_RECORD_CNT");
			}
			objSession.setAttribute("SRCH_RECORD_CNT",strsrch_record_cnt);
			objSession.setAttribute("SRCH_DISPLAY_KIND",objHshUserInfo.get("SRCH_DISPLAY_KIND"));
			objSession.setAttribute("GTHER_PERIOD",objHshUserInfo.get("GTHER_PERIOD"));
			objSession.setAttribute("INOUT_GBN",objHshUserInfo.get("INOUT_GBN"));
			objSession.setAttribute("MSG_OPEN_GBN","N");
			objSession.setAttribute("BASIC_ORGAN_ID",objHshUserInfo.get("ORGAN_ID"));
			objSession.setAttribute("CHECKIP",strClientIP);

			java.util.Hashtable objHshTopMenuList = new java.util.Hashtable();
			nads.dsdm.app.common.menu.MenuDelegate objTopMenu = new nads.dsdm.app.common.menu.MenuDelegate();
			java.util.ArrayList objAryTopMenu = new java.util.ArrayList();
		
		
			java.util.Hashtable objHshTopParam = new java.util.Hashtable();
			objHshTopParam.put("TOP_MENU_ID","0000000002");
			objHshTopParam.put("USER_ID",(String)session.getAttribute("USER_ID"));

			objAryTopMenu = objTopMenu.getTopMenuList(objHshTopParam);

			objSession.setAttribute("TOP_MENU",objAryTopMenu);

			nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqTopMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();	

			java.util.Hashtable hashOrgMenu = (java.util.Hashtable)objReqTopMenu.getOrgMenuList(String.valueOf(objHshUserInfo.get("ORGAN_KIND")), strIsRequester);		

			objSession.setAttribute("TOP_MENU_SUB",hashOrgMenu);

			//사무처, 예산정책처, 도서관 사용자 기관ID 예외사항 처리
			String strOrganId 			 = (String)objHshUserInfo.get("ORGAN_ID");
			String strOrganKind			 = (String)objHshUserInfo.get("ORGAN_KIND");
			//법제실 또는 법제실 하위 부서(의회법제과, 행정법제과, 경재법제과, 산업법제과, 사회법제과)인 경우
			if ( strOrganId.equals("GI00004754") || strOrganId.equals("GI00005273") || strOrganId.equals("GI00005274") || strOrganId.equals("GI00005277") || strOrganId.equals("GI00005275") || strOrganId.equals("GI00005276")) {
				strOrganId  = "GI00004754";  			//법제실 부서코드로 세팅

			}else{

				// 001(국회사무처), 002(예산정책처), 005(국회도서관) 하위 부서는 Organ_ID를 해당 상위 기관의 Organ_ID로 셋팅한다.
				if ( strOrganKind.equals("001") || strOrganKind.equals("002") || strOrganKind.equals("005")|| strOrganKind.equals("007") ){
					nads.dsdm.app.common.addjob.AddJobDelegate objAddJobList = new  nads.dsdm.app.common.addjob.AddJobDelegate();
					ArrayList objSuperOrganID = new ArrayList();
					objSuperOrganID = objAddJobList.getSuperOrganID(strOrganId);

					//상위기관이 존재하면
					if (objSuperOrganID.size()  > 0) {
						Hashtable objSuperList = (Hashtable)objSuperOrganID.get(0); //조회 LIST의 첫번째 기관정보를 가져온다.
						String strNational = (String)objSuperList.get("ORGAN_ID");		 //조회한 기관ID세팅

						//strNational 정보가 국회사무처, 예산정책처, 국회도서관 기관ID와 동일한지 확인한다.
						if ( strNational.equals("GI00004739") || strNational.equals("GI00004746") || strNational.equals("GI00004743")|| strNational.equals("GI00006570")) {
								strOrganId  = (String)objSuperList.get("ORGAN_ID");  						//상위기관코드
						}
					}
				}
			}

			objSession.setAttribute("ORGAN_ID",strOrganId);

		}
		else
			//strUrl = "/login/Login.jsp";
			strUrl = "/login/LoginFail.jsp";
		response.sendRedirect(strUrl);
	}
	catch(Exception objExcept)
	{
		Log.debug.println(objExcept.toString());
%>
<%
	}

%>