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
<div id="left_menu">
  <h2><img src="/images2/foundation/tl03.gif"  /></h2>
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

			if(strTopPMenuID.equals(strArrMenu[2])&&!strTopMenuNM.equals("�α� �˻���")) {
%>
				  <li><h3><a href="<%=strTopGoURL%>"><%=strTopMenuNM%></a></h3></li>
<%
			}
		}
	}
%>
    <!--li>
		<h3><a href="/infosearch/ISearch_All01.jsp">���հ˻�</a></h3>
    </li>
    <li>
		<h3><a href="/infosearch/ISearch_Nads.jsp?&index=2&folderId=2&step=1">�䱸�����ڷ�</a></h3>
    </li>
    <li>
		<h3><a href="/infosearch/ISearch_Submit.jsp?&index=3&folderId=3&step=1">ȸ���ڷ�</a></h3>
    </li>

    <li>
		<h3><a href="javascript:openNewWinLeftMenu('http://www.assembly.go.kr/renew10/anc/news/natv_list.jsp');">��ȸ����</a></h3>
    </li>
    <%if(!ORGAN_KIND.equals("006")){%>
    <li>
		<h3><a href="javascript:openNewWinLeftMenu('http://www.assembly.go.kr/renew10/anc/report/total_list.jsp');">�����ڷ�</a></h3>
    </li>

    <li>
		<h3><a href="/infosearch/ISearch_News.jsp">�Ź��˻�</a></h3>
    </li>
    <%}%>
    <li>
		<h3><a href="javascript:openNewWinLeftMenu('/infosearch/ISearch_All06.jsp');">��ȸȸ�ǷϽý���</a></h3>
    </li-->
  </ul>
  <p><img src="/images2/foundation/tl_bottom.gif"  /></p>
</div>
