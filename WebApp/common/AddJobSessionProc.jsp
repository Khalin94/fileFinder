<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil"%>
<%
	
	String strUrl = "";
	
	try
	{	
		String strStreamAddJob	 = StringUtil.getEmptyIfNull(request.getParameter("addjob"));
		
		//세션정보를 셋팅
		if ( strStreamAddJob != null || !strStreamAddJob.equals("")){

			String TempStrUserId = (String)session.getAttribute("USER_ID");			
			//파라미터를 배열로 파싱한다.
			String[] strCutStreamAddJobArr = StringUtil.split("^", strStreamAddJob);
			
			//배열의 세션정보를 담는다.
			String strUserId   	    	 = strCutStreamAddJobArr[1];
			String strUserNm 	    	 = strCutStreamAddJobArr[2];
			String strOrganId 	     	 = strCutStreamAddJobArr[3];
			String strReqSubmitFlag    = strCutStreamAddJobArr[4];
			String strIsRequester        = strCutStreamAddJobArr[5];
			String strOrganKind	    	 = strCutStreamAddJobArr[6];
			String strOrgPosiGbn 	     = strCutStreamAddJobArr[7];
			String strSrchRecordCnt   = strCutStreamAddJobArr[8];
			String strSrchDisplayKind = strCutStreamAddJobArr[9];
			String strGtherPeriod 	     = strCutStreamAddJobArr[10];
			String strInOutGbn	    	 = strCutStreamAddJobArr[11];
			String strBasicOrganId   	 = strCutStreamAddJobArr[12];
			
			if (strUserId.equals(TempStrUserId)) {
			HttpSession objSession = request.getSession();
			objSession.setAttribute("USER_ID",strUserId);                               		//이용자ID
			objSession.setAttribute("USER_NM",strUserNm);									//이용자명
			objSession.setAttribute("ORGAN_ID",strOrganId);									//소속기관
			objSession.setAttribute("REQ_SUBMT_FLAG",strReqSubmitFlag);		//제출권한여부
			objSession.setAttribute("IS_REQUESTER",strIsRequester);					//요구자/제출자 여부
			objSession.setAttribute("ORGAN_KIND",strOrganKind);						//기관구분코드
			objSession.setAttribute("ORG_POSI_GBN",strOrgPosiGbn);					//원직/겸직
			objSession.setAttribute("SRCH_RECORD_CNT",strSrchRecordCnt);		//페이지당 결과수
			objSession.setAttribute("SRCH_DISPLAY_KIND",strSrchDisplayKind);	//열람방식조회
			objSession.setAttribute("GTHER_PERIOD",strGtherPeriod);					//조회기관
			objSession.setAttribute("INOUT_GBN",strInOutGbn);							//내외구분
			objSession.setAttribute("BASIC_ORGAN_ID",strBasicOrganId);			//Basic 소속기관

			java.util.Hashtable objHshTopMenuList = new java.util.Hashtable();
			nads.dsdm.app.common.menu.MenuDelegate objTopMenu = new nads.dsdm.app.common.menu.MenuDelegate();
			java.util.ArrayList objAryTopMenu = new java.util.ArrayList();
		
		
			java.util.Hashtable objHshTopParam = new java.util.Hashtable();
			objHshTopParam.put("TOP_MENU_ID","0000000002");
			objHshTopParam.put("USER_ID",(String)session.getAttribute("USER_ID"));

			objAryTopMenu = objTopMenu.getTopMenuList(objHshTopParam);

			objSession.setAttribute("TOP_MENU",objAryTopMenu);

			nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqTopMenu = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();	

			java.util.Hashtable hashOrgMenu = (java.util.Hashtable)objReqTopMenu.getOrgMenuList(String.valueOf(strOrganKind), strIsRequester);		

			objSession.setAttribute("TOP_MENU_SUB",hashOrgMenu);
			
			out.println("<b>성공</b><br>");
			out.println("strStreamAddJob :" + strStreamAddJob + "<br>");
			out.println("strCutStreamAddJobArrLength :" + strCutStreamAddJobArr.length + "<br>");
			out.println("<br><br><br><b>Session정보</b><br>");
			out.println("strUserId :" + strCutStreamAddJobArr[1] + "<br>");
			out.println("strUserNm :" + strCutStreamAddJobArr[2] + "<br>");
			out.println("strOrganId :" + strCutStreamAddJobArr[3] + "<br>");
			out.println("strReqSubmitFlag :" + strCutStreamAddJobArr[4] + "<br>");
			out.println("strIsRequester :" + strCutStreamAddJobArr[5] + "<br>");
			out.println("strOrganKind :" + strCutStreamAddJobArr[6] + "<br>");
			out.println("strOrgPosiGbn :" + strCutStreamAddJobArr[7] + "<br>");
			out.println("strSrchRecordCnt :" + strCutStreamAddJobArr[8] + "<br>");
			out.println("strSrchDisplayKind :" + strCutStreamAddJobArr[9] + "<br>");
			out.println("strGtherPeriod :" + strCutStreamAddJobArr[10] + "<br>");
			out.println("strInOutGbn :" + strCutStreamAddJobArr[11] + "<br>");
		    
//			strUrl = "/reqsubmit/test.jsp";
			strUrl = "/main.jsp";
			response.reset();
			response.sendRedirect(strUrl);
			}else{
				session.invalidate();
				%><script>
				alert('비정상 접근 입니다. 로그인 페이지로 이동합니다.');				
				location.href = "http://nafs.assembly.go.kr/egsign/main/login.jsp";
				</script><%
			}
		}else{
			out.println("<b>실패</b><br>");
			out.println("<b>Session 파라미터 정보가 넘어오지 않았습니다.</b><br>");
		}
	} catch(Exception objExcept)	{
		Log.debug.println(objExcept.toString());
	}
	
%>

<input type="button" value="Back" style="cursor:hand" OnClick="javascript:history.go(-1);">