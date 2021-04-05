<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="java.util.*"%>

<%
    String strFlag = request.getParameter("FLAG")==null?"":request.getParameter("FLAG");
    String strUserId = request.getParameter("USERID")==null?"":request.getParameter("USERID");
    HttpSession objSession = request.getSession();
    String strClientIP = request.getHeader("Proxy-Client-IP");

	System.out.println("strClientIP :: "+strClientIP);

/*
	if(!strClientIP.equals("10.201.15.157")&&!strClientIP.equals("10.201.15.172")&&!strClientIP.equals("10.201.15.153")&&!strClientIP.equals("10.201.177.46")&&!strClientIP.equals("10.201.177.48")&&!strClientIP.equals("10.201.177.62")){
		strFlag = "";
	}
*/

    try
    {
        nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
        Hashtable objHshUserInfo = objJoinMemberDelegate.loginUserBack(strUserId);

        Log.debug.println("[JSP] Delegate Method Call....끝");



        String strIsRequester = (String)objHshUserInfo.get("REQ_SUBMT_FLAG");
		System.out.println(" REQ_SUBMT_FLAG : "+strIsRequester);
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
        String strOrganId              = (String)objHshUserInfo.get("ORGAN_ID");
        String strOrganKind             = (String)objHshUserInfo.get("ORGAN_KIND");
        //법제실 또는 법제실 하위 부서(의회법제과, 행정법제과, 경재법제과, 산업법제과, 사회법제과)인 경우
        if ( strOrganId.equals("GI00004754") || strOrganId.equals("GI00005273") || strOrganId.equals("GI00005274") || strOrganId.equals("GI00005277") || strOrganId.equals("GI00005275") || strOrganId.equals("GI00005276")) {
            strOrganId  = "GI00004754";              //법제실 부서코드로 세팅

        }else{

            // 001(국회사무처), 002(예산정책처), 005(국회도서관) 하위 부서는 Organ_ID를 해당 상위 기관의 Organ_ID로 셋팅한다.
            if ( strOrganKind.equals("001") || strOrganKind.equals("002") || strOrganKind.equals("005") || strOrganKind.equals("007") ){
                nads.dsdm.app.common.addjob.AddJobDelegate objAddJobList = new  nads.dsdm.app.common.addjob.AddJobDelegate();
                ArrayList objSuperOrganID = new ArrayList();
                objSuperOrganID = objAddJobList.getSuperOrganID(strOrganId);

                //상위기관이 존재하면
                if (objSuperOrganID.size()  > 0) {
                    Hashtable objSuperList = (Hashtable)objSuperOrganID.get(0); //조회 LIST의 첫번째 기관정보를 가져온다.
                    String strNational = (String)objSuperList.get("ORGAN_ID");         //조회한 기관ID세팅

                    //strNational 정보가 국회사무처, 예산정책처, 국회도서관 기관ID와 동일한지 확인한다.
                    if ( strNational.equals("GI00004739") || strNational.equals("GI00004746") || strNational.equals("GI00004743")|| strNational.equals("GI00006570")) {
                            strOrganId  = (String)objSuperList.get("ORGAN_ID");                          //상위기관코드
                    }
                }
            }
        }

    objSession.setAttribute("ORGAN_ID",strOrganId);

    }
    catch(Exception objExcept)
    {
        Log.debug.println(objExcept.toString());
    }

%>
<%


    if(!strUserId.equals("")&&strFlag.equals("1")){
        out.println("<script language='javascript'>");
        out.println("location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp';");
        out.println("</script>");

    }else if(!strUserId.equals("")&&strFlag.equals("2")){
        out.println("<script language='javascript'>");
//        out.println("location.href='/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxList.jsp';");
        out.println("location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp';");

        out.println("</script>");

    }else if(!strUserId.equals("")&&strFlag.equals("3")){
        out.println("<script language='javascript'>");
//        out.println("location.href='/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp';");
        out.println("location.href='/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxList.jsp';");
        out.println("</script>");

    }else{
        objSession.removeAttribute("USER_ID");
        objSession.removeAttribute("USER_NM");
        objSession.removeAttribute("ORGAN_ID");
        objSession.removeAttribute("REQ_SUBMT_FLAG");
        objSession.removeAttribute("IS_REQUESTER");
        objSession.removeAttribute("ORGAN_KIND");
        objSession.removeAttribute("ORG_POSI_GBN");
        objSession.removeAttribute("SRCH_RECORD_CNT");
        objSession.removeAttribute("SRCH_DISPLAY_KIND");
        objSession.removeAttribute("GTHER_PERIOD");
        objSession.removeAttribute("INOUT_GBN");
        objSession.removeAttribute("MSG_OPEN_GBN");
        objSession.removeAttribute("BASIC_ORGAN_ID");
        objSession.removeAttribute("CHECKIP");

        out.println("<script language='javascript'>");
        out.println("location.href='http://naps.assembly.go.kr';");
        out.println("</script>");
    }
%>
