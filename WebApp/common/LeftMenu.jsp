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

	// mypage : ����������
	// reqsubmit : ��������
	// infosearch : �����˻�
	// forum : ����
	// board : �Խ���
	// help : �̿�ȳ�
	
	//�� �޴��� �ش��ϴ� �ڵ尪.
	 //�迭�� ũ�⸦ ���ϰ�� �����߻�(�ϴܿ��� ȣ��)

	String strArrMenuNm[] = {"activity", "reqsubmit", "infosearch", "forum", "board", "help"};
	String strArrDirNm4In[] = {"activity", "reqsubmit", "infosearch", "forum", "board", "help"};
	String strArrDirNm4Out[] = {"mypage", "reqsubmit", "infosearch", "forum", "board", "help"};

	//�޴�id �� TopMenu.jsp ����
	//String strArrMenuId4In[] = {"0000000074", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	//String strArrMenuId4Out[] = {"0000000104", "reqsubmit", "0000000020", "0000000062", "0000000088", "0000000099"};
	
	String strArrMenuImg4In[] = {"img_mypage", "reqsubmit", "img_infosearch", "img_forum", "img_board", "img_help"};
	String strArrMenuImg4Out[] = {"img_mypage", "reqsubmit", "img_infosearch", "img_forum", "img_board", "img_help"};
	
	//����/�ܺ� ����
	String strTopMenuId = "";
	String strDirNm = "";
	String strMenuImg = "";
	String strMenuNm = "";


	//���������̿�
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
	<!-- Ʈ���޴� ���� -->
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
						strDisplayKind = (String)objHshMenuList.get("DISPLAY_KIND"); //001:���� 002:�˾� 003:��â

						//��â �߿� �� �Ķ����(index,folderId,step) �� �ֱ� ���Ͽ� ���� �߰�(2004.06.01)
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
							//��â �߿� �� �Ķ����(index,folderId,step) �� �ֱ� ���Ͽ� ���� �߰�(2004.06.01)
							if(strDisplayKind.equals("003")){
			  %>
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, "<%=strGoURL%>('<%=strAppUrl%><%=strParam%>')"));
					<!-- �Ŀ� strAppUrl�� �̵��ϵ��� �����ؾ���.-->
			  <%
			  				}else{
			  					if((strParam == null) || (strParam.equals(""))){
									strParam = "?";
								}
			  %>
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, "<%=strGoURL%>('<%=strAppUrl%><%=strParam%>&index=<%=index%>&folderId=<%=i+1%>&step=<%=strMenuLevel%>')"));
					<!-- �Ŀ� strAppUrl�� �̵��ϵ��� �����ؾ���.-->
			  <%
			  				}
						}
						else
						{
			  %>
			
					aux<%=strMenuLevel%> = insFld(aux<%=String.valueOf(Integer.parseInt(strMenuLevel)-1)%>, gFld("<%=strMenuNm%>","<%=strMenuId%>",<%=index%>,<%=strMenuLevel%>, ""));
					<!-- �Ŀ� strAppUrl�� �̵��ϵ��� �����ؾ���.-->
			  <%
				  
						}
					} //end for
					out.println("</script>");
				}
				else{
					out.println("����Ÿ ����<br>");
				}
				
			  %>
	

	<script>
		initializeDocumentOnReload(<%=getIndex%>,<%=session.getValue("folderId")%>)
	</script>
	<!-- Ʈ���޴� �� -->
	</td>
  </tr>
  <!-- �����޴� �ʿ��� ���Ե� ������ ǥ�� ����-->
<%
	if(strLGbn.equals("forum")) { //������ �޴����� "�������� �ٷΰ���" �޴� ǥ��

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
              <option>::: ���Ե� ����</option>
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
<!-- ���� ǥ�� �� -->
<!-- �䱸�����׸� ǥ�� ���� -->
<%
	// ���� ����ڿ��Ը� ǥ��
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
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('/common/ControlAccess.jsp','��ȸ���ڹ����ý���')"><img src="/image/common/ban_elect_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="5" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top"><a href="javascript:fun_bottomhomepage('http://mail.assembly.go.kr','��ȸ����')"><img src="/image/common/ban_mail_sub.gif" width="173" height="30" border="0"></a></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
<%
	} else { 
%>
<!-- �䱸�����׸� ǥ�� �� -->
  <tr> 
    <td align="left" valign="top"><img src="/image/common/line_dot.gif" width="186" height="1"></td>
  </tr>
  <tr height="9"> 
    <td height="9" align="left" valign="top"></td>
  </tr>
  <tr> 
    <td align="center" valign="top">
		<%@ include file="/common/LeftLinkMenu.jsp" %>	
	  <!-- ���û���Ʈ ���̺� ���� -->
	  <%@ include file="/common/LeftOrganMenu.jsp" %>
	  <!-- ���û���Ʈ ���̺� �� -->
	</td>
  </tr>
  <tr height="9"> 
    <td height="12" align="left" valign="top"></td>
  </tr>
<% } %>
</table>