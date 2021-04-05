<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<script src="/js/reqsubmit.js"></script>
<script src="/js/leftmenu.js"></script>
<script language="JavaScript">
	var NS4 = (document.layers);
	var IE4 = (document.all);
	var win = window;
	var n   = 0;


	function fun_bottomhomepage(strUrl, strNm){
		window.open(strUrl, strNm);
	}
	
</script>

<%
	String strLURL = request.getRequestURI();
	String strLGbn = strLURL.substring(1,strLURL.length());
	if(strLGbn.indexOf("/") >0 )
		strLGbn = strLGbn.substring(0,strLGbn.indexOf("/"));

	// mypage : 나의폐이지
	// reqsubmit : 서류제출
	// infosearch : 정보검색
	// forum : 포럼
	// board : 게시판
	// help : 이용안내
	
	//각 메뉴에 해당하는 코드값.
	 //배열의 크기를 줄일경우 에러발생(하단에서 호출)

	String strArrMenuNm[] = {"activity", "reqsubmit", "infosearch", "forum", "board", "help"};
	String strArrDirNm4In[] = {"activity", "reqsubmit", "infosearch", "forum", "board", "help"};
	String strArrDirNm4Out[] = {"mypage", "reqsubmit", "infosearch", "forum", "board", "help"};

	//메뉴id 는 TopMenu.jsp 파일
	//String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	//String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	
	String strArrMenuImg4In[] = {"img_mypage", "reqsubmit", "img_infosearch", "img_forum", "img_board", "img_help"};
	String strArrMenuImg4Out[] = {"img_mypage", "reqsubmit", "img_infosearch", "img_forum", "img_board", "img_help"};
	
	//내부/외부 구분
	String strTopMenuId = "";
	String strDirNm = "";
	String strMenuImg = "";
	String strMenuNm = "";


	//세션정보이용
	String strLeftInOutGbn = (String)session.getValue("INOUT_GBN");


	//strLGbn="mypage";
	for(int i=0; i<strArrMenuNm.length; i++) {

		if(strLGbn.equals(strArrMenuNm[i])) {
			if(strLeftInOutGbn !=null && strLeftInOutGbn.equals("I") )
			{
				//strTopMenuId = strArrMenuId4In[i];
				//strMenuImg= strArrMenuImg4In[i];
				//strDirNm= strArrDirNm4In[i];
				strTopMenuId = strArrMenuId4Out[i];
				strMenuImg= strArrMenuImg4Out[i];
				strDirNm= strArrDirNm4Out[i];
			}else{

				strTopMenuId = strArrMenuId4Out[i];
				strMenuImg= strArrMenuImg4Out[i];
				strDirNm= strArrDirNm4Out[i];

			}

			strMenuNm= strArrMenuNm[i];
			
		}
	}

	Hashtable objHshMenuList = new Hashtable();
	nads.dsdm.app.common.menu.MenuDelegate objMenu = new nads.dsdm.app.common.menu.MenuDelegate();
	ArrayList objAryMenu = new ArrayList();


	Hashtable objHshParam = new Hashtable();
	objHshParam.put("TOP_MENU_ID",strTopMenuId);
	objHshParam.put("USER_ID",(String)session.getAttribute("USER_ID"));
	objHshParam.put("USER_ID2",(String)session.getAttribute("USER_ID"));
	objHshParam.put("USER_ID3",(String)session.getAttribute("USER_ID"));
	

//System.out.println(strTopMenuId);
//System.out.println((String)session.getAttribute("USER_ID"));

	if (request.getParameter("folderId") != null)
		session.setAttribute("folderId",request.getParameter("folderId"));
	//out.println("folderId---->"+request.getParameter("folderId"));
	//out.println("session.getValue--->"+session.getValue("folderId"));
	
	try{		
		objAryMenu = objMenu.getMenuList(objHshParam);		
	}
	catch(Exception e){
		out.println(e);
%>

	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		System.out.println("[JSP] " + e.toString());
	}

%>

<link href="/css/System.css" rel="stylesheet" type="text/css">  
<table width="186" border="0" cellpadding="0" cellspacing="0" background="/image/common/bg_left.gif">
  <tr> 
    <td align="left" valign="top"><img src="/image/<%=strDirNm%>/<%=strMenuImg%>.jpg" width="186" height="153"></td>
  </tr>
  <tr> 
    <td align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"> </td>
  </tr>
  <tr> 
    <td height="13" align="left" valign="top" class="menu_<%=strDirNm%>">
	<!-- 트리메뉴 시작 -->
			<script>aux0 = gFld("","","", "")</script>
			  
			  <%
					
					String strIndex = (String)request.getParameter("index");
					String strFolderId = (String)request.getParameter("folderId");
					String strStep= (String)request.getParameter("step");

					if(strFolderId == null || strFolderId.equals(""))
						strFolderId = "0";
					
					if( strIndex== null ||strIndex.equals("") )
						strIndex="0";
					int getIndex = Integer.parseInt(strIndex);
					if( getIndex == 0)
						getIndex = 1;

					String strMenuLevel = "";
					String strMenuId = "";
					String strAppUrl= "";
					String strParam= "";
					String strDisplayKind= "";			

				if(objAryMenu != null){
			 			
					int index=0;

			 		out.println("<script>");	
					for(int i=0;i < objAryMenu.size();i++){
						objHshMenuList = (Hashtable)objAryMenu.get(i);
						strMenuLevel = (String)objHshMenuList.get("LVL");
						strMenuNm = (String)objHshMenuList.get("MENU_NM");
						strMenuId = (String)objHshMenuList.get("MENU_ID");
						strAppUrl = (String)objHshMenuList.get("APP_URL");
						strParam = (String)objHshMenuList.get("PARAM");
						strDisplayKind = (String)objHshMenuList.get("DISPLAY_KIND"); //001:메인 002:팝업 003:새창

						//새창 뜨울 때 파라미터(index,folderId,step) 안 주기 위하여 로직 추가(2004.06.01)
						if((strParam != null) && (!strParam.equals(""))){
							strParam = "?" + strParam;
						}

						String strGoURL = "goUrl";
						if(strDisplayKind.equals("002"))
							strGoURL = "openPopLeftMenu";
						else if(strDisplayKind.equals("003"))
							strGoURL = "openNewWinLeftMenu";

					
						if(strMenuLevel.equals("1"))
							index++;

					
						if(strAppUrl.equals("#") != true && strAppUrl.equals("") != true ){
							//새창 뜨울 때 파라미터(index,folderId,step) 안 주기 위하여 로직 추가(2004.06.01)
							if(strDisplayKind.equals("003")){
			  %>
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, "<%=strGoURL%>('<%=strAppUrl%><%=strParam%>')"));
					<!-- 후에 strAppUrl로 이동하도록 변경해야함.-->
			  <%
			  				}else{
			  					if((strParam == null) || (strParam.equals(""))){
									strParam = "?";
								}
			  %>
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, "<%=strGoURL%>('<%=strAppUrl%><%=strParam%>&index=<%=index%>&folderId=<%=i+1%>&step=<%=strMenuLevel%>')"));
					<!-- 후에 strAppUrl로 이동하도록 변경해야함.-->
			  <%
			  				}
						}
						else
						{
			  %>
			
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, ""));
					<!-- 후에 strAppUrl로 이동하도록 변경해야함.-->
			  <%
				  
						}
					} //end for
					out.println("</script>");
				}
				else{
					out.println("데이타 없음<br>");
				}
				
			  %>
	

	<script>
		initializeDocumentOnReload(<%=getIndex%>,<%=session.getValue("folderId")%>)
	</script>
	<!-- 트리메뉴 끝 -->
	</td>
  </tr>
  <!-- 포럼메뉴 쪽에만 가입된 포럼을 표시 시작-->
<%
	if(strLGbn.equals("forum")) { //포럼쪽 메뉴에는 "나의포럼 바로가기" 메뉴 표시

		nads.dsdm.app.activity.forum.UserForumDelegate objGoMyForum_UserForumDelegate = null;

		String strGoMyForum_Rownum = "";
		String strGoMyForum_Fid = "";
		String strGoMyForum_ForumNm = "";
		String strGoMyForum_OpenFlag = "";

		Vector objGoMyForum_Rownum = new Vector();
		Vector objGoMyForum_Fid = new Vector();
		Vector objGoMyForum_ForumNm = new Vector();
		Vector objGoMyForum_OpenFlag = new Vector();

		try {

			objGoMyForum_UserForumDelegate = new nads.dsdm.app.activity.forum.UserForumDelegate();
			Hashtable objGoMyForum_JoinHtable = objGoMyForum_UserForumDelegate.selectJoinForum((String)session.getAttribute("USER_ID"));
		
			objGoMyForum_Rownum = (Vector)objGoMyForum_JoinHtable.get("ROWNUM");
			objGoMyForum_Fid = (Vector)objGoMyForum_JoinHtable.get("FID");
			objGoMyForum_ForumNm = (Vector)objGoMyForum_JoinHtable.get("FORUM_NM");
			objGoMyForum_OpenFlag = (Vector)objGoMyForum_JoinHtable.get("OPEN_FLAG");

		} catch(kr.co.kcc.pf.exception.AppException e) {
%>

	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
			System.out.println("MENU Exception : " + e.getMessage());
		}
	
		if ((objGoMyForum_Rownum != null) && (objGoMyForum_Rownum.size() > 0)){	
%>
			<script language="JavaScript">
				function openForum_goMyForum()
				{
					var vgoMyForum = document.form_goMyForum.goMyForum.value;
					var strForumID = null;
					var strOpenFlag = null;

					if(vgoMyForum!="") {
						//alert(vgoMyForum);
						if(vgoMyForum.indexOf("|") > 0) {
							strForumID = vgoMyForum.substring(0, vgoMyForum.indexOf("|"));
							strOpenFlag = vgoMyForum.substring(vgoMyForum.indexOf("|")+1);

							//alert(strForumID);
							openForum(strForumID, strOpenFlag);
						}
					}
				}
			</script>

  <tr> 
    <td align="center" valign="top"><table width="173" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td align="left" valign="top"><img src="/image/forum/box_myforum_top.gif" width="173" height="39"></td>
        </tr>
        <tr>
          <td height="8" align="center" valign="top" bgcolor="EBE2F1"></td>
        </tr>

		<form name="form_goMyForum" method="post">	
        <tr> 
          <td align="center" valign="top" bgcolor="EBE2F1"><select name="goMyForum" class="text_s" style="WIDTH: 153px"  onChange="javascript:openForum_goMyForum();">
              <option>::: 가입된 포럼</option>
<%
					for (int i=0; i < objGoMyForum_Rownum.size(); i++){
						strGoMyForum_Rownum = (String)objGoMyForum_Rownum.elementAt(i);
						strGoMyForum_Fid = (String)objGoMyForum_Fid.elementAt(i);
						strGoMyForum_ForumNm = (String)objGoMyForum_ForumNm.elementAt(i);
						strGoMyForum_OpenFlag = (String)objGoMyForum_OpenFlag.elementAt(i);
%>
						  <option value="<%=strGoMyForum_Fid%>|<%=strGoMyForum_OpenFlag%>"><%=strGoMyForum_ForumNm%></option>
<%
					} //end for
%>
            </select></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><img src="/image/forum/box_myforum_bot.gif" width="173" height="10"></td>
        </tr>
		</form>

      </table></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<%
		}

	} //end if(strLGbn.equals("forum"))
%>
<!-- 포럼 표시 끝 -->
<!-- 요구자한테만 표시 시작 -->
<%
	// 내부 사용자에게만 표시
	if(strLeftInOutGbn !=null && strLeftInOutGbn.equals("I") )
	{
%>
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','국회전자문서시스템')"><img src="/image/common/ban_elect_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('http://mail.assembly.go.kr','국회메일')"><img src="/image/common/ban_mail_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<%
	} else { 
%>
<!-- 요구자한테만 표시 끝 -->
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top">
		<%@ include file="/common/LeftLinkMenu.jsp" %>	
	  <!-- 관련사이트 테이블 시작 -->
	  <%@ include file="/common/LeftOrganMenu.jsp" %>
	  <!-- 관련사이트 테이블 끝 -->
	</td>
  </tr>
  <tr height="9"> 
    <td height="12" align="left" valign="top"></td>
  </tr>
<% } %>
</table>