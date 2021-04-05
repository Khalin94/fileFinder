<%@ page contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%
	//세션정보이용
//	String strTopInOutGbn = (String)session.getValue("INOUT_GBN");
	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");
	//strTopIsRequesterGbn = true 이면 요구자(내부)
	//메뉴id
	String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};

	String strArrMenu [] = new String[4];
	strArrMenu = strArrMenuId4Out;
	//strArrMenu = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? strArrMenuId4In : strArrMenuId4Out;

	//상단 큰 이미지 링크를 위한 변수
	String strMypageURL ="/activity/MyReqSubmitList.jsp";
	String strReqSubmitURL = "/reqsubmit/index.jsp";
	String strInfoSearchURL = "/infosearch/ISearch_All01.jsp";
	String strForumURL = "/forum/newinfo/ForumMain.jsp";
	String strBoardURL = "/board/BoardList.jsp";
	String strHelpURL = "/help/SystemIntroduction.jsp";
	String ORGAN_KIND = (String)session.getAttribute("ORGAN_KIND").toString();

	java.util.Hashtable objHshTopMenuList = new java.util.Hashtable();
	java.util.ArrayList objAryTopMenu = new java.util.ArrayList();
	try{
		objAryTopMenu = (java.util.ArrayList)session.getAttribute("TOP_MENU");
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}
%>
<script>

</script>
<div id="left_menu">
  <h2><img src="/images2/foundation/tl01.gif"  /></h2>
  <ul>
<%/*
	if(objAryTopMenu != null){
		for(int i=0;i < objAryTopMenu.size();i++){
			objHshTopMenuList = (Hashtable)objAryTopMenu.get(i);
			String strTopPMenuID = (String)objHshTopMenuList.get("P_MENU_ID");
			String strTopMenuNM = (String)objHshTopMenuList.get("MENU_NM");
			String strTopAppUrl = (String)objHshTopMenuList.get("APP_URL");
			String strTopParam = (String)objHshTopMenuList.get("PARAM");
			String strTopDisplayKind = (String)objHshTopMenuList.get("DISPLAY_KIND");

			String strTopGoURL = strTopAppUrl;
			if(!strTopParam.equals(""))
				 strTopGoURL += "?" + strTopParam;

			if(strTopDisplayKind.equals("002"))
				strTopGoURL = "javascript:openPopLeftMenu('"+strTopGoURL+"');";
			else if(strTopDisplayKind.equals("003"))
				strTopGoURL = "javascript:openNewWinLeftMenu('"+strTopGoURL+"');";

			if(strTopPMenuID.equals(strArrMenu[0])) {
                if (!(!(ORGAN_KIND.equals("006"))&&strTopMenuNM.equals("기관정보관리"))){

*/%>
				  <!--li><h3><a href="<%//=strTopGoURL%>"><%//=strTopMenuNM%></a></h3></li-->
<%/*
                }
			}
		}
	}
*/%>

    <li>
	  <h3><a href="/activity/MyReqSubmitSearch.jsp">나의자료요구제출</a></h3>
	  <ul class="dep3">
	    <li>
		  <h4><a href="/activity/MyReqSubmitSearch.jsp">요구제출자료검색</a></h4>
	    </li>
      </ul>
	</li>
	<li>
	  <h3><a href="/activity/ConcernInfo.jsp">관심정보</a></h3>
	</li>
    <%if(ORGAN_KIND.equals("006")){%>
	<!--
	<li>
	  <h3><a href="/activity/OrganInfoMng.jsp">기관정보관리</a></h3>
	</li>
	-->
    <%} else {%>
	<li>
	  <h3><a href="/activity/BizInfo.jsp">부서자료실</a></h3>
	</li>
    <%}%>
	<li>
	  <h3><a href="javascript:KeySharpBiz.login('', TryLogin);">개인정보변경</a></h3>
	</li>
	<li>
	  <h3><a href="/activity/SetupPerEnv_ConcernInfo.jsp">개인환경설정</a></h3>
	  <ul class="dep3">
	    <li>
	      <h4><a href="/activity/SetupPerEnv_ConcernInfo.jsp">관심정보설정</a></h4>
	    </li>
      </ul>
	</li>
  </ul>
  <p><img src="/images2/foundation/tl_bottom.gif"  /></p>
</div>
