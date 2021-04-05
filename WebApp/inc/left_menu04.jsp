<%@ page contentType="text/html;charset=EUC-KR" %>
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
	function menuOpenFold(id){

		if(document.getElementById(id+"U").style.display == "none"){
			document.getElementById(id+"U").style.display = "";
		} else {
			document.getElementById(id+"U").style.display = "none"
		}
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
	String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};

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
	if (request.getParameter("folderId") != null)
		session.setAttribute("folderId",request.getParameter("folderId"));

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
<div id="left_menu">
  <h2><img src="/images2/foundation/tl04.gif" /></h2>
  <ul>
	<!-- 트리메뉴 시작 -->
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
					int j=0;
					String strliYn = "N";
					String strulYn = "N";
					String strMenuIdOld = "";

					for(int i=0;i < objAryMenu.size();i++){
						objHshMenuList = (Hashtable)objAryMenu.get(i);
						strMenuLevel = (String)objHshMenuList.get("LEVEL");
						strMenuNm = (String)objHshMenuList.get("MENU_NM");
						strMenuId = (String)objHshMenuList.get("MENU_ID");
						strAppUrl = (String)objHshMenuList.get("APP_URL");
						strParam = (String)objHshMenuList.get("PARAM");
						strDisplayKind = (String)objHshMenuList.get("DISPLAY_KIND"); //001:메인 002:팝업 003:새창

                        if (!strMenuNm.equals("자유게시판")&&!strMenuNm.equals("서식/양식")){
                            //새창 뜨울 때 파라미터(index,folderId,step) 안 주기 위하여 로직 추가(2004.06.01)
                            if((strParam != null) && (!strParam.equals(""))){
                                strParam = "?" + strParam;
                            }

                            String strGoURL = "goUrl";
                            if(strDisplayKind.equals("002"))
                                strGoURL = "openPopLeftMenu";
                            else if(strDisplayKind.equals("003"))
                                strGoURL = "openNewWinLeftMenu";

                            if (strMenuLevel.equals("1")&&strulYn.equals("Y")) {
                                out.println("</ul>");
                                strulYn = "N";
                            }

                            if (strMenuLevel.equals("1")&&strliYn.equals("Y")) {
                                out.println("</li>");
                                strliYn = "N";
                            }
                            if(strMenuLevel.equals("1")){
                                index++;
                                out.println("<li id='"+index+"0"+strMenuLevel+"0'>");
                                strliYn = "Y";
                            }


                            if(strMenuLevel.equals("2")&&strulYn.equals("N")){
                                out.println("<ul class='dep3' id='"+index+"0"+strMenuLevel+"0U'>");
                                strulYn = "Y";
                            }


                            if(strMenuLevel.equals("2")) out.println("<li>");

                            if(!strAppUrl.equals("#")&&!strAppUrl.equals("")){
                                if(strDisplayKind.equals("003")){
                  %>
                            <<%=strMenuLevel.equals("1")?"h3":"h4"%>><a href="javascript:<%=strGoURL%>('<%=strAppUrl%><%=strParam%>')"><%=strMenuNm%></a><<%=strMenuLevel.equals("1")?"/h3":"/h4"%>>
                  <%
                                }else{
                                    if((strParam == null) || (strParam.equals(""))){
                  %>
                            <<%=strMenuLevel.equals("1")?"h3":"h4"%>><a href="javascript:menuOpenFold('<%=index%>020');"><%=strMenuNm%></a><<%=strMenuLevel.equals("1")?"/h3":"/h4"%>>
                  <%
                                    } else {
                  %>
                            <<%=strMenuLevel.equals("1")?"h3":"h4"%>><a href="javascript:<%=strGoURL%>('<%=strAppUrl%><%=strParam%>')"><%=strMenuNm%></a><<%=strMenuLevel.equals("1")?"/h3":"/h4"%>>
                  <%
                                    }
                                }
                            }
                            else
                            {
                  %>
                  <%
                            }
                            if(strMenuLevel.equals("2")) out.println("</li>");
                        }

					  j++;

					} //end for
				}
				else{
					out.println("데이타 없음<br>");
				}

			  %>
    </li>
</ul>
<p><img src="/images2/foundation/tl_bottom.gif"  /></p>
</div>
