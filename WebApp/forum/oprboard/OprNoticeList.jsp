<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	//���� �������� �޴����� �Ѿ�� �Ķ����.(���� �������� : 14/001, ���� �ڷ�� : 47/003)
	String strBbrdID = "0000000001"; 					//StringUtil.getNVLNULL(request.getParameter("bbrdid"));

	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//���� ������
	String strCountPerPage;																										//�������� ROW���� 
	
	//�˻��� �߰��Ǵ� �Ķ����
	String strSrchType = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchType")));
	String strSrchText = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchText")));
	
	nads.dsdm.app.board.SLBoardDelegate objOprBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;						//�Խ��� 
	ArrayList objAryBbrdData = null;							//�Խù� 
	
	try {
	
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
		
	} catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}

	try{
		
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objOprBoard.selectBbrdInfo(strBbrdID);
		
		//2. �Խ��� ����Ʈ ������ �����´�.
		if(strSrchText.equals("") || strSrchText == null){
		
			//�˻� ������ ���� ���
			objAryBbrdData = objOprBoard.selectBbrdDataListPerPage(strBbrdID, "1", strCurrentPage, strCountPerPage);	
		
		} else {
		
			//�˻� ������ ���� ���.
			objAryBbrdData = objOprBoard.selectBbrdSearchListPerPage(strBbrdID, "1", strCurrentPage, 
																strCountPerPage, strSrchType, strSrchText);
		
		}

	} catch (AppException objAppEx) {
	
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode() + "<br>");
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
		return;
		
	}
	
	//�Խ��� ���� 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");		//�˻��� ��� 
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	int intBbrdLength = strBbrdNm.length() * 3  - 2;
	int intBbrdLength2 = 0;
	if (intBbrdLength < 100){
		intBbrdLength2 = 100 - intBbrdLength;
	}

	//��ü �������� ���ϱ�.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf(strCountPerPage).intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;
	
	//out.println("strCurrentPage : " + strCurrentPage + "<br>");
	//out.println("strSrchType : " + strSrchType + "<br>");
	//out.println("strSrchText : " + strSrchText + "<br>");
	
%>

<html>
<head>
<title>��ȸ ����Ȱ�� �������� �������� �ý���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">

	function goPage(varPageNo) {
		document.frmNoticeList.strCurrentPage.value = varPageNo;
		document.frmNoticeList.submit();
	}
	
	function doSearch(){
		var frm = document.frmSearch;
		
		if (frm.txtSearch.value == "" || frm.txtSearch.value == null){
			alert("�˻�� �Է��� �ּ���.");
			frm.txtSearch.focus();
			return false;
		} 
		
		frm.srchType.value = frm.selSearch.options[frm.selSearch.selectedIndex].value;
		frm.srchText.value = frm.txtSearch.value;

	}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop2.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
<%@ include file="/forum/common/MenuLeftForumPop2.jsp" %>
</td>
    <td align="center"><table width="590" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=objHshBbrdInfo.get("DSC")%></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="15" align="left"><table width="100%" border="0" cellspacing="5" cellpadding="0">
              <tr> 
                <td width="50%" class="text_s"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  ��ü �ڷ�� : <%=strTotalCount%>��</td>
                <td width="50%" align="right" class="text_s"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                  Page : <%=strCurrentPage%>/<%=intTotalPage%> Page</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          <!-- ��� �������� ����Ʈ ���� --------------------------------->
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <form name="frmNoticeList" method="post" action="OprNoticeList.jsp">
		  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
              <tr> 
                <td height="2" colspan="6" class="td_forumpop"></td>
              </tr>
              <tr class="td_top"> 
                <td width="45" height="22" align="center">NO</td>
                <td width="310" height="22" align="center">����</td>
                <td width="50" height="22" align="center">����</td>
                <td width="70" height="22" align="center">�����</td>
                <td width="70" height="22" align="center">�������</td>
                <td width="45" height="22" align="center">��ȸ</td>
              </tr>
              <tr> 
                <td height="1" colspan="6" class="td_forumpop"></td>
              </tr>
              <%
				if(intTotalCount != 0) {

					for (int i = 1; i < objAryBbrdData.size(); i++) {
					
						Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
						
						String strDataID = (String)objHshBbrdData.get("DATA_ID");
						//NO = ��ü���� - rownum + 1 
						int intViewDataID = Integer.valueOf(strTotalCount).intValue() - Integer.valueOf((String)objHshBbrdData.get("RNUM")).intValue() + 1;
						String strTitle = (String)objHshBbrdData.get("TITLE");
						String strUserNm = (String)objHshBbrdData.get("USER_NM");
						String strFileExt = (String)objHshBbrdData.get("APD_FILE_EXT");
						String strFileExtImg = "&nbsp;";
						if(strFileExt.equals("Y")){
							strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
						}
						String strWriteTs = (String)objHshBbrdData.get("WRITE_TS");
						String strUpdTs = (String)objHshBbrdData.get("UPD_TS");
						if(!strUpdTs.equals("")){
							strWriteTs = strUpdTs;
						}
						strWriteTs = strWriteTs.substring(0, 4) + "-" +strWriteTs.substring(4, 6) 
											+ "-" + strWriteTs.substring(6, 8);
						String strQryCnt = (String)objHshBbrdData.get("QRY_CNT");
						int intDataLevel = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
						String strDelFlag = (String)objHshBbrdData.get("DEL_FLAG");
						if(strDelFlag.equals("A")){
							strTitle = "�ش���� ���� �Ǿ����ϴ�";
						}
			  %>
              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                <td height="22" align="center"><%=intViewDataID%></td>
                <td height="22" class="td_lmagin">
                <%
					if(intDataLevel > 0 ){

						String strWid = "";
						
						for(int j=0; j < intDataLevel ; j++){
							strWid = strWid + "&nbsp;&nbsp;&nbsp;";
						}
						out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
					
					}
                 %>
                	<a href="OprList2Content.jsp?strCurrentPage=<%=strCurrentPage%>&dataid=<%=strDataID%>&bbrdid=<%=strBbrdID%>"><%=strTitle%></a>
                </td>
                <td height="22" align="center"><%=strFileExtImg%></td>
                <td height="22" align="center"><%=strUserNm%></td>
                <td height="22" align="center"><%=strWriteTs%></td>
                <td height="22" align="center"><%=strQryCnt%></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1"></td>
              </tr>
              <%
					}	
				} else {

					out.println("<tr>");
					out.println("<td height='22' colspan='6' align='center'>�ش� ����Ÿ�� �����ϴ�.");
					out.println("</td>");
					out.println("</tr>");
					out.println("<tr class='tbl-line'> ");
					out.println("<td height='1'></td>");
					out.println("<td height='1'></td>");
					out.println("<td height='1'></td>");
					out.println("<td height='1' align='left' class='td_lmagin'></td>");
					out.println("<td height='1' align='left' class='td_lmagin'></td>");
					out.println("<td height='1'></td>");
					out.println("</tr>");
				
				}
			  %>
			  <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
                <td height="1"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1" align="left" class="td_lmagin"></td>
                <td height="1"></td>
              </tr>
              </form>
            </table>
            <!-- ��� �������� ����Ʈ �� --------------------------------->
            </td>
        </tr>
        <tr> 
          <td height="35" align="center" valign="middle">
          	<!--<img src="/image/button/bt_prev5.gif" width="13" height="12" align="absmiddle">&nbsp;
          	<img src="/image/button/bt_prev.gif" width="13" height="12" align="absmiddle" >&nbsp;&nbsp;
          	<strong><a href="#">[1]</a> 2 3 </strong>&nbsp;
            <img src="/image/button/bt_next.gif" width="13" height="12" align="absmiddle" >&nbsp;
            <img src="/image/button/bt_next5.gif" width="13" height="12" align="absmiddle" >-->
            <%=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %>
            </td>
        </tr>
        <tr height="3"> 
          <td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top">
            <!-- �˻� ���̺� ���� ------------------------------->
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <form name="frmSearch" method="post"  action="OprNoticeList.jsp">
            <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
            <input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="srchType" value="">
			<input type="hidden" name="srchText" value="">
              <tr> 
                <td width="503" align="right" valign="middle"><div align="right">
                    <select name="selSearch" class="select">
                        <option value="NOTICE_ALL" <% if(strSrchType.equals("NOTICE_ALL")) out.println("selected"); %>>��ü</option>
						<option value="TITLE" <% if(strSrchType.equals("TITLE")) out.println("selected"); %>>����</option>
						<option value="CONT" <% if(strSrchType.equals("CONT")) out.println("selected"); %>>����</option>
                    </select>
                    <input name="txtSearch" type="text" class="textfield" style="WIDTH: 180px" value="<%=strSrchText %>">
                    <img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" style="cursor:hand;" onClick="doSearch()">
                  </div></td>
              </tr>
            </form>
            </table>
            <!-- �˻� ���̺� �� ------------------------------->
          </td>
        </tr>
        <tr> 
          <td height="15" align="left" valign="top"></td>
        </tr>
      </table>
      </td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
