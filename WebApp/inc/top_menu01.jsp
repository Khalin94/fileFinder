<%@ page contentType="text/html;charset=EUC-KR" %>
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
<script type="text/javascript">
function showObj(obj) {
	var str = "";
	for(key in obj) {
		str += key+"="+obj[key]+"\n";
	}

	alert(str);
	return;
}


function MM_showHideLayers() { //v9.0
  var i,p,v,obj;
  var args=MM_showHideLayers.arguments;
  var setVal = 0;
  
  // 2018-08-24 ����
  for (i=0; i<(args.length-2); i+=3) {
	  if(args[i+2]=="show"){
	  $('#'+args[i]).css("visibility","visible");
	  }else{
	  $('#'+args[i]).css("visibility","hidden");
	  }
  }
  // 2018-08-24 ����

  /* 2018-08-24 
  with (document) if (getElementById && ((obj=getElementById(args[i]))!=null)) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
	*/
}
</script>
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
<div id="top_menu">

  <!-- depth1 �޴� -->
  <ul class="depth1">
    <li>
      <h2><img src="/images2/common/topMenu01.gif" alt="����������" onmouseover="MM_showHideLayers('depth2_1','','show','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" /></h2>
    </li>
    <li>
      <h2>
      	 <%if("true".equals(strTopIsRequesterGbn)){ %>
      	 <img src="/images2/common/topMenu02.gif"  alt="�ڷ�䱸" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','show','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" />
         <%}else{%>
         <img src="/images2/common/topMenu02_2.gif"  alt="�ڷ�����" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','show','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" />
         <%}%>
      </h2>
    </li>
    <li>
      <h2><img src="/images2/common/topMenu03.gif" alt="�����˻�" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','show','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" /></h2>
    </li>
    <li>
      <h2><img src="/images2/common/topMenu04.gif" alt="�ֿ��ڷ�" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','show','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" /></h2>
    </li>
    <li>
      <h2><img src="/images2/common/topMenu05.gif" alt="�̿�ȳ�"   onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','show')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" /></h2>
    </li>
    <!-- ��ܰ˻� -->
    <li class="search">
      <jsp:include page="/inc/top_search.jsp" flush="true"/>
    </li>
    <!-- /��ܰ˻� -->
  </ul>

  <!-- depth2 �޴�-->
  <div id="dep2_position" >

    <!-- depth2 : ���������� �޴� -->

    <div id="depth2_1" onmouseover="MM_showHideLayers('depth2_1','','show','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')">
      <p class="my"><a href="/activity/MyReqSubmitSearch.jsp"><img src="/images2/common/topMenu01_on.gif" alt="����������" /></a></p>
      <ul class="depth2 ml_my">
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
                if (!(!(ORGAN_KIND.equals("006"))&&strTopMenuNM.equals("�����������"))){
%>
				  <li><h3><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></h3></li>
<%              }
			}
		}
	}
%>
      </ul>

    </div>

	<%if("true".equals(strTopIsRequesterGbn)){ %>

    <div id="depth2_2" 
    onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','show','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')"
    onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')">
    <p class="req">
    	<a href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp">
    		<img src="/images2/common/topMenu02_on.gif" alt="�ڷ�䱸" />
    	</a>
    </p>
    <%}else{ %>

    <div id="depth2_2_sub" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','show','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')">
      <p class="sub"><a href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp"><img src="/images2/common/topMenu02_2_on.gif" alt="�ڷ�����" /></a></p>
    <%}%>

      <ul class="depth2 ml_req">
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
					 <li><h3><a href="<%= strMenuPath+strMenuFileName+"?"+strMenuParam %>">&nbsp;<%= strMenuName %></a></h3></li>
<% 			} else {
%>

                     <li><h3><a href="<%= strMenuPath+strMenuFileName %>">&nbsp;<%= strMenuName %></a></h3></li>

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

    <!-- depth2 : �����˻� -->
    <div id="depth2_3" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','show','depth2_4','','hide','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')" >
      <p class="ser"><a href="/infosearch/ISearch_All01.jsp"><img src="/images2/common/topMenu03_on.gif" alt="�����˻�" /></a></p>
      <ul class="depth2 ml_ser">
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
				  <li><h3><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></h3></li>
<%
			}
		}
	}
%>
      </ul>
    </div>

    <!-- depth2 : �ֿ��ڷ� -->
    <div id="depth2_4" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','show','depth2_5','','hide')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')">
      <p class="boa"><a href="/board/BoardList.jsp?bbrdid=0000000012"><img src="/images2/common/topMenu04_on.gif" alt="�ֿ��ڷ�" /></a></p>
      <ul class="depth2 ml_boa">
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
				  <li><h3><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></h3></li>
<%
			}
		}
	}
%>
      </ul>
    </div>

    <!-- depth2 : �̿�ȳ� -->
    <div id="depth2_5" onmouseover="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','show')" onmouseout="MM_showHideLayers('depth2_1','','hide','depth2_2','','hide','depth2_2_sub','','hide','depth2_3','','hide','depth2_4','','hide','depth2_5','','hide')">
      <p class="info"><a href="/help/SystemIntroduction.jsp"><img src="/images2/common/topMenu05_on.gif" alt="�̿�ȳ�" /></a></p>
      <ul class="depth2 ml_info">
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
				  <li><h3><a href="<%=strTopGoURL%>">&nbsp;<%=strTopMenuNM%></a></h3></li>
<%
			}
		}
	}
%>
      </ul>
    </div>

  </div>
</div>
<jsp:include page="/inc/top_check.jsp" flush="true"/>
