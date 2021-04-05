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

	java.util.Hashtable objHshTopMenuList = new java.util.Hashtable();
	java.util.ArrayList objAryTopMenu = new java.util.ArrayList();
	try{
		objAryTopMenu = (java.util.ArrayList)session.getAttribute("TOP_MENU");
	}
	catch(Exception e){
		out.print("[JSP] : " + e.toString());
	}
%>
<script language="JavaScript">
	/*TopMenu 의 팝업을 위한 링크*/
	function openPopLeftMenu(url)
	{ //팝업창 띄우기
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=auto,left=1,top=1,width=800,height=600,resizable=yes, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	/*TopMenu 의 새창을 위한 링크*/
	function openNewWinLeftMenu(url)
	{ //새창 띄우기
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url);
		hWin.focus();
	}
    var c=false;
    function ch2 () {
        if(c) return;
        document.SearchPageForm.iptName.style.backgroundImage="";
        c=true;
    }

    function SearchPage() {
            document.SearchPageForm.action='/infosearch/ISearch_All01.jsp?sflag=1';
            var str=document.SearchPageForm.iptName.value
            for (var i=0; i < str.length; i++) {
            if (str.charAt(i) == "%" |str.charAt(i) == ">" |str.charAt(i) == "<" |str.charAt(i) == ">" |str.charAt(i) == "(" |str.charAt(i) == ")" |str.charAt(i) == "+" |str.charAt(i) == "," |str.charAt(i) == "[") {
                alert("허용되지않은 문자입니다.");
                document.SearchPageForm.iptName.focus();
                return ;
                }
             }
            document.SearchPageForm.submit();
    }
</script>


<!-- 왼쪽 영역 전체 div-->


<div id="leftCon_main" >


	<!-- 로그인 정보 -->


	<div id="loginfo_main" >
		<jsp:include page="/main2/AdditionalJob.jsp"/>
	</div>


	<!-- /로그인 정보 -->


	<!-- 검색 -->
	<div>
	<ul class="search mt10">
		<li>
			<form  method="post" name="SearchPageForm">
                <input type="hidden" name="docStart" VALUE="1">
				<input name="iptName" onKeyDown="JavaScript: if(event.keyCode == 13) {return SearchPage();};" onMouseDown="return ch2()" style="background-image:url(images2/main/search_bg.gif); background-repeat:no-repeat;background-position:left top; background-color:#819bb9; width:146px;"/>
				<img src="images2/main/bt_search.gif"  width="29" height="25"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onclick="javascript:SearchPage();" style="cursor:hand;"/>
			</form>
		</li>
	</ul>
	</div>
	<!-- /검색 -->


	<!-- depth1 : 메인메뉴 --->


	<div style="position: relative; width:184px; height:285px; padding:0px;" >
		<ul class="mainMenu" >
			<li><a href="#"><img src="images2/main/menu_01.gif" alt="나의페이지" width="184" height="54" onMouseOver="MM_showHideLayers('main_dep2_1','','show','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%if("true".equals(strTopIsRequesterGbn)){ %>
			<li><a href="#"><img src="images2/main/menu_02.gif" width="184" height="54" alt="자료요구" onMouseOver="MM_showHideLayers('main_dep2_2','','show','main_dep2_1','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%}else{ %>
			<li><a href="#"><img src="images2/main/menu_02_2.gif" width="184" height="54" alt="자료제출" onMouseOver="MM_showHideLayers('main_dep2_2','','show','main_dep2_1','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%} %>
			<li><a href="#"><img src="images2/main/menu_03.gif" width="184" height="54" alt="정보검색" onMouseOver="MM_showHideLayers('main_dep2_3','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<li><a href="#"><img src="images2/main/menu_04.gif" width="184" height="54"alt="주요자료" onMouseOver="MM_showHideLayers('main_dep2_4','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_5','','hide')" /></a></li>
			<li><a href="#"><img src="images2/main/menu_05.gif" width="184" height="53" alt="이용안내" onMouseOver="MM_showHideLayers('main_dep2_5','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_4','','hide')" /></a></li>
		</ul>


		<!-- depth2 : 나의페이지 메뉴 -->


		<div id="main_dep2_1" style="position: absolute; height:142px; top:0; left:0; height:54px; width:334px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal;"><a href="/activity/MyReqSubmitSearch.jsp"><img src="images2/main/menu_01_on.gif" width="184" height="54" alt="나의페이지"  style="z-index:1; " /></a>
			<div style="position: absolute; height:142px; top:10px; left:184px; height:140px; width:150px;  z-index:2; font-size:11px; font-weight:normal;"  >
				<ul>
<%
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
			if(strTopMenuNM.equals("개인정보변경")){
				strTopGoURL = "javascript:KeySharpBiz.login('', TryLogin);";
			}
			if(strTopPMenuID.equals(strArrMenu[0])) {
                if (!(!(String.valueOf(session.getAttribute("ORGAN_KIND")).equals("006"))&&strTopMenuNM.equals("기관정보관리"))){
%>
				  <li><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>

<%              }
			}
		}
	}
%>
					<!--li class="on" style=" line-height:20px;"><a href="/activity/MyReqSubmitSearch.jsp">나의자료요구제출</a></li>
					<li><a href="/activity/ConcernInfo.jsp">관심정보</a></li>
					<li><a href="/activity/OrganInfoMng.jsp">기관정보관리</a></li>
					<li><a href="/activity/BizInfo.jsp">부서자료실</a></li>
					<li><a href="/activity/ChangePerInfo.jsp">개인정보변경</a></li>
					<li><a href="/activity/SetupPerEnv_ConcernInfo.jsp">개인환경설정</a></li-->
				</ul>
			</div>
		</div>


		<!-- depth2 : 자료요구 -->

		<!-- 요구자 -->

		<%if("true".equals(strTopIsRequesterGbn)){ %>
		<div id="main_dep2_2" style="position: absolute; height:142px; top:54px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp"><img src="images2/main/menu_02_on.gif" width="184" height="54" alt="자료요구"  style="z-index:1;" /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:140px; width:150px;  z-index:2; font-size:11px; font-weight:normal;">
				<ul >
		<%}else{ %>
		<div id="main_dep2_2" style="position: absolute; height:142px; top:54px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp"><img src="images2/main/menu_02_2_on.gif" width="184" height="54" alt="자료제출"  style="z-index:1; " /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:140px; width:150px;  z-index:2; font-size:11px; font-weight:normal;">
				<ul >
		<%} %>
<%
	nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate objReqSitemap = new nads.dsdm.app.reqsubmit.delegate.common.MenuDelegate();
	nads.lib.reqsubmit.util.ResultSetHelper objReqSitemapRs = null;
	try {
		java.util.Hashtable hashOrgMenu = (java.util.Hashtable)objReqSitemap.getOrgMenuList(String.valueOf(session.getAttribute("ORGAN_KIND")), strTopIsRequesterGbn);
		objReqSitemapRs = new nads.lib.reqsubmit.util.ResultSetHelper(hashOrgMenu);

 		while(objReqSitemapRs.next()) {
	 		String strMenuID = (String)objReqSitemapRs.getObject("REQ_MENU_ID");
	 		String strMenuName = (String)objReqSitemapRs.getObject("REQ_MENU_NM");
	 		String strRefMenuID = (String)objReqSitemapRs.getObject("REF_ID");
	 		String strMenuPath = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_PATH"));
	 		String strMenuFileName = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_FILE_NAME"));
	 		String strMenuParam = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull((String)objReqSitemapRs.getObject("REQ_MENU_PARAM"));
	 		if (strRefMenuID.equalsIgnoreCase(strMenuID)&&!strMenuName.equals("국회의원 비전자 요구")) {
	 			if (nads.lib.reqsubmit.util.StringUtil.isAssigned(strMenuParam)) {
%>
					 <li><a href="<%= strMenuPath+strMenuFileName+"?"+strMenuParam %>">&nbsp;<%= strMenuName %></a></li>
<% 			} else {
%>

                     <li><a href="<%= strMenuPath+strMenuFileName %>">&nbsp;<%= strMenuName %></a></li>

<%
	 			}
 			}
 		}

	} catch(kr.co.kcc.pf.exception.AppException e) {
		System.out.println("MENU Exception : " + e.getMessage());
		e.printStackTrace();
 	}
%>
				</ul>
			</div>
		</div>

		<!-- depth2 : 정보검색 -->


		<div id="main_dep2_3" style="position: absolute; height:142px; top:108px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/infosearch/ISearch_All01.jsp"><img src="images2/main/menu_03_on.gif" width="184" height="54" alt="정보검색"  style="z-index:1; " /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:54px; width:150px;  z-index:2; font-size:11px; font-weight:normal; ">
				<ul >
<%
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

			if(strTopPMenuID.equals(strArrMenu[2])&&!strTopMenuNM.equals("인기 검색어")) {
%>
				  <li><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>
				</ul>
			</div>
		</div>


		<!-- depth2 : 주요자료 -->


		<div id="main_dep2_4" style="position: absolute; height:142px; top:162px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/board/BoardList.jsp?bbrdid=0000000012"><img src="images2/main/menu_04_on.gif" width="184" height="54" alt="주요자료"  style="z-index:1;" /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:54px; width:150px; z-index:2; font-size:11px; font-weight:normal;">
				<ul >
<%
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

			if(strTopPMenuID.equals(strArrMenu[4])&&!strTopMenuNM.equals("자유게시판")) {
%>
				  <li><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>
				</ul>
			</div>
		</div>


		<!-- depth2 : 이용안내 -->


		<div id="main_dep2_5" style="position: absolute; height:142px; top:216px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/help/SystemIntroduction.jsp"><img src="images2/main/menu_05_on.gif" width="184" height="54" alt="이용안내"  style="z-index:1;" /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:54px; width:150px; z-index:2; font-size:11px; font-weight:normal;">
				<ul >
<%
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

			if(strTopPMenuID.equals(strArrMenu[5])) {
%>
				  <li><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>
<%
			}
		}
	}
%>
				</ul>
			</div>
	   </div>


	<!-- /depth2 -->


	</div>

	<!-- /메인메뉴  -->


</div>
<!-- /왼쪽 영역 전체 div-->
<jsp:include page="/inc/top_check.jsp" flush="true"/>