<%@ page import="java.util.*" %>
<%
	//���������̿�
//	String strTopInOutGbn = (String)session.getValue("INOUT_GBN");
	String strTopIsRequesterGbn = (String)session.getValue("IS_REQUESTER");
    //strTopIsRequesterGbn = true �̸� �䱸��(����)
	//�޴�id
	String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};

	String strArrMenu [] = new String[4];
	strArrMenu = strArrMenuId4Out;
	//strArrMenu = (strTopIsRequesterGbn !=null && strTopIsRequesterGbn.equals("true")) ? strArrMenuId4In : strArrMenuId4Out;

	//��� ū �̹��� ��ũ�� ���� ����
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
	/*TopMenu �� �˾��� ���� ��ũ*/
	function openPopLeftMenu(url)
	{ //�˾�â ����
		var hWin;
		if(hWin !=null){
			hWin.close();
			hWin=null;
		}
		hWin = window.open(url, 'up' ,"toolbar=no,scrollbars=auto,left=1,top=1,width=800,height=600,resizable=yes, screenX=0,screenY=0,top=100,left=100");
		hWin.focus();
	}

	/*TopMenu �� ��â�� ���� ��ũ*/
	function openNewWinLeftMenu(url)
	{ //��â ����
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
                alert("���������� �����Դϴ�.");
                document.SearchPageForm.iptName.focus();
                return ;
                }
             }
            document.SearchPageForm.submit();
    }
</script>


<!-- ���� ���� ��ü div-->


<div id="leftCon_main" >


	<!-- �α��� ���� -->


	<div id="loginfo_main" >
		<jsp:include page="/main2/AdditionalJob.jsp"/>
	</div>


	<!-- /�α��� ���� -->


	<!-- �˻� -->
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
	<!-- /�˻� -->


	<!-- depth1 : ���θ޴� --->


	<div style="position: relative; width:184px; height:285px; padding:0px;" >
		<ul class="mainMenu" >
			<li><a href="#"><img src="images2/main/menu_01.gif" alt="����������" width="184" height="54" onMouseOver="MM_showHideLayers('main_dep2_1','','show','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%if("true".equals(strTopIsRequesterGbn)){ %>
			<li><a href="#"><img src="images2/main/menu_02.gif" width="184" height="54" alt="�ڷ�䱸" onMouseOver="MM_showHideLayers('main_dep2_2','','show','main_dep2_1','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%}else{ %>
			<li><a href="#"><img src="images2/main/menu_02_2.gif" width="184" height="54" alt="�ڷ�����" onMouseOver="MM_showHideLayers('main_dep2_2','','show','main_dep2_1','','hide','main_dep2_3','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<%} %>
			<li><a href="#"><img src="images2/main/menu_03.gif" width="184" height="54" alt="�����˻�" onMouseOver="MM_showHideLayers('main_dep2_3','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_4','','hide','main_dep2_5','','hide')" /></a></li>
			<li><a href="#"><img src="images2/main/menu_04.gif" width="184" height="54"alt="�ֿ��ڷ�" onMouseOver="MM_showHideLayers('main_dep2_4','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_5','','hide')" /></a></li>
			<li><a href="#"><img src="images2/main/menu_05.gif" width="184" height="53" alt="�̿�ȳ�" onMouseOver="MM_showHideLayers('main_dep2_5','','show','main_dep2_1','','hide','main_dep2_2','','hide','main_dep2_3','','hide','main_dep2_4','','hide')" /></a></li>
		</ul>


		<!-- depth2 : ���������� �޴� -->


		<div id="main_dep2_1" style="position: absolute; height:142px; top:0; left:0; height:54px; width:334px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal;"><a href="/activity/MyReqSubmitSearch.jsp"><img src="images2/main/menu_01_on.gif" width="184" height="54" alt="����������"  style="z-index:1; " /></a>
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
			if(strTopMenuNM.equals("������������")){
				strTopGoURL = "javascript:KeySharpBiz.login('', TryLogin);";
			}
			if(strTopPMenuID.equals(strArrMenu[0])) {
                if (!(!(String.valueOf(session.getAttribute("ORGAN_KIND")).equals("006"))&&strTopMenuNM.equals("�����������"))){
%>
				  <li><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></li>

<%              }
			}
		}
	}
%>
					<!--li class="on" style=" line-height:20px;"><a href="/activity/MyReqSubmitSearch.jsp">�����ڷ�䱸����</a></li>
					<li><a href="/activity/ConcernInfo.jsp">��������</a></li>
					<li><a href="/activity/OrganInfoMng.jsp">�����������</a></li>
					<li><a href="/activity/BizInfo.jsp">�μ��ڷ��</a></li>
					<li><a href="/activity/ChangePerInfo.jsp">������������</a></li>
					<li><a href="/activity/SetupPerEnv_ConcernInfo.jsp">����ȯ�漳��</a></li-->
				</ul>
			</div>
		</div>


		<!-- depth2 : �ڷ�䱸 -->

		<!-- �䱸�� -->

		<%if("true".equals(strTopIsRequesterGbn)){ %>
		<div id="main_dep2_2" style="position: absolute; height:142px; top:54px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp"><img src="images2/main/menu_02_on.gif" width="184" height="54" alt="�ڷ�䱸"  style="z-index:1;" /></a>
			<div style="position: absolute; height:142px; top:10px;  left:184px; height:140px; width:150px;  z-index:2; font-size:11px; font-weight:normal;">
				<ul >
		<%}else{ %>
		<div id="main_dep2_2" style="position: absolute; height:142px; top:54px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp"><img src="images2/main/menu_02_2_on.gif" width="184" height="54" alt="�ڷ�����"  style="z-index:1; " /></a>
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
	 		if (strRefMenuID.equalsIgnoreCase(strMenuID)&&!strMenuName.equals("��ȸ�ǿ� ������ �䱸")) {
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

		<!-- depth2 : �����˻� -->


		<div id="main_dep2_3" style="position: absolute; height:142px; top:108px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/infosearch/ISearch_All01.jsp"><img src="images2/main/menu_03_on.gif" width="184" height="54" alt="�����˻�"  style="z-index:1; " /></a>
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

			if(strTopPMenuID.equals(strArrMenu[2])&&!strTopMenuNM.equals("�α� �˻���")) {
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


		<!-- depth2 : �ֿ��ڷ� -->


		<div id="main_dep2_4" style="position: absolute; height:142px; top:162px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/board/BoardList.jsp?bbrdid=0000000012"><img src="images2/main/menu_04_on.gif" width="184" height="54" alt="�ֿ��ڷ�"  style="z-index:1;" /></a>
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

			if(strTopPMenuID.equals(strArrMenu[4])&&!strTopMenuNM.equals("�����Խ���")) {
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


		<!-- depth2 : �̿�ȳ� -->


		<div id="main_dep2_5" style="position: absolute; height:142px; top:216px; left:0px; height:54px; width:150px; visibility: hidden; z-index:1; font-size:11px; font-weight:normal; "><a href="/help/SystemIntroduction.jsp"><img src="images2/main/menu_05_on.gif" width="184" height="54" alt="�̿�ȳ�"  style="z-index:1;" /></a>
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

	<!-- /���θ޴�  -->


</div>
<!-- /���� ���� ��ü div-->
<jsp:include page="/inc/top_check.jsp" flush="true"/>