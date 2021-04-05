<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<h2><img src="images2/main/tl_notice.gif" width="225" height="17" /></h2>
<ul>
<!-- �������� �Խ��� Start -->
	<li class="mNotice">
	<ul>
<%
	ArrayList objNoticeArry = new ArrayList();//��������
	Hashtable objNoticeHt = new Hashtable();

	try{
		Config objConfigNotice = PropertyConfig.getInstance();
		String strNoticeAppCode = objConfigNotice.get("activity.useritet.board.noticeBoard");
		nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

		//�Խ��� ID�� �����´�.
		ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("MYBOARD", strUserId, strNoticeAppCode);

		String strBbrdID = "";
		if (objAryBbrdMenu.size() != 0){
			strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
			strBbrdID = strBbrdID.replaceAll(" ", "");
			int intIndex = strBbrdID.indexOf("bbrdid=");
			strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
		}

		//�Խ��� ������ �����´�.
		objNoticeArry = objBoard.selectBbrdThreeData("BoardData", strBbrdID, "5");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	if(objNoticeArry.size() > 0) {
//		for (int i = 0; i < objNoticeArry.size(); i++) {
		for (int i = 0; i < 4; i++) {
			objNoticeHt = (Hashtable)objNoticeArry.get(i);
			String strDataIdData = (String)objNoticeHt.get("DATA_ID");
			String strTitleData = BoardComm.replaceTag2Text((String)objNoticeHt.get("TITLE"));
			String strBbrdIdData = (String)objNoticeHt.get("BBRD_ID");
			String strUpdTsData = (String)objNoticeHt.get("UPD_TS");
			String strWriteTsData = (String)objNoticeHt.get("WRITE_TS");
			String strBbrdNmData = (String)objNoticeHt.get("BBRD_NM");
			if(!strUpdTsData.equals("")){
				strWriteTsData = strUpdTsData;
			}
			strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
									+ strWriteTsData.substring(6, 8);
			String strDelFlagData = (String)objNoticeHt.get("DEL_FLAG");
			if(strDelFlagData.equals("A") || strDelFlagData.equals("Y")){
				strTitleData = "�ش���� ���� �Ǿ����ϴ�";
			}

			String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
%>
	<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage %>&strCurrentPage=1&bbrdid=<%=strBbrdIdData %>&dataid=<%=strDataIdData %>" onfocus="this.blur();"><%=nads.lib.util.ActComm.chrString(strTitleData, 14) %></a></li>
<%
		}
	}
%>
		</ul>
	</li>
<!-- �������� �Խ��� End -->


	<li style=" text-align:center; "> <img src="images2/main/line01.gif" width="205" height="1" /></li>


<!-- �ڷ� �Խ��� Start -->
	<li class="mData">
	<ul>
<%
	ArrayList objDataArry = new ArrayList();//�ڷ��
	Hashtable objDataHt = new Hashtable();

	try{
		Config objConfigData = PropertyConfig.getInstance();
		String strDataAppCode = objConfigData.get("activity.useritet.board.dataBoard");
		nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

		//�Խ��� ID�� �����´�.
		ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("MYBOARD", strUserId, strDataAppCode);

		String strBbrdID = "";
		if (objAryBbrdMenu.size() != 0){
			strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
			strBbrdID = strBbrdID.replaceAll(" ", "");
			int intIndex = strBbrdID.indexOf("bbrdid=");
			strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
		}

		//�Խ��� ������ �����´�.
		objDataArry = objBoard.selectBbrdThreeData("BoardData", strBbrdID, "5");

	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	if(objDataArry.size() > 0) {
//		for (int i = 0; i < objDataArry.size(); i++) {
		for (int i = 0; i < 4; i++) {
			objDataHt = (Hashtable)objDataArry.get(i);
			String strDataIdData = (String)objDataHt.get("DATA_ID");
			String strTitleData = BoardComm.replaceTag2Text((String)objDataHt.get("TITLE"));
			String strBbrdIdData = (String)objDataHt.get("BBRD_ID");
			String strUpdTsData = (String)objDataHt.get("UPD_TS");
			String strWriteTsData = (String)objDataHt.get("WRITE_TS");
			String strBbrdNmData = (String)objDataHt.get("BBRD_NM");
			if(!strUpdTsData.equals("")){
				strWriteTsData = strUpdTsData;
			}
			strWriteTsData = strWriteTsData.substring(0, 4) + "-" + strWriteTsData.substring(4, 6) + "-"
									+ strWriteTsData.substring(6, 8);
			String strDelFlagData = (String)objDataHt.get("DEL_FLAG");
			if(strDelFlagData.equals("A") || strDelFlagData.equals("Y")){
				strTitleData = "�ش���� ���� �Ǿ����ϴ�";
			}

			String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");
%>
	<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage %>&strCurrentPage=1&bbrdid=<%=strBbrdIdData %>&dataid=<%=strDataIdData %>" onfocus="this.blur();"><%=nads.lib.util.ActComm.chrString(strTitleData, 14) %></a></li>
<%
		}
	}
%>
		</ul>
	</li>
<!-- �ڷ� �Խ��� End -->


	<li style=" text-align:center; "> <img src="images2/main/line01.gif" width="205" height="1" /></li>


<!-- ������ϱ� Start -->
	<li class="mWork">
	<ul>
<%
	String strBbrdID = "";

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objQnaBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;						//�Խù�
	Hashtable objHshBbrdInfo = null;						//�Խ���
	String strGoToPage = URLEncoder.encode("/help/BoardContent.jsp", "UTF-8");

	if(strBbrdID == null || strBbrdID.equals("")){

		try {

			//�Խ��� ���̵� ���ٸ� ���� �ֱ��� �������� ���̵� �����´�.
			Hashtable objHshMaxBbrdID = objQnaBoard.selectMaxBbrdID(qnaBoard);
			strBbrdID = (String)objHshMaxBbrdID.get("BBRD_ID");

		} catch (AppException objAppEx) {

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%

			return;

		}

	}

	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");

		// ���� �߻� �޼��� �������� �̵��Ѵ�.

%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}

	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objQnaBoard.selectBbrdInfo(strBbrdID);

		if(objHshBbrdInfo.size() == 0){

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSPARAM-0000");
			objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;

		}

		objAryBbrdData = objQnaBoard.selectBbrdDataListPerPage(strBbrdID, "0", "1", "4");


	} catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.

%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}

	//��ü �������� ���ϱ�.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf("4").intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;

%>
<%

	if(intTotalCount != 0){

	//	for (int i = 1; i < objAryBbrdData.size(); i++) {
		for (int i = 1; i < 5; i++) {
			Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
			String strDataID = (String)objHshBbrdData.get("DATA_ID");
			String strTitle = BoardComm.replaceTag2Text((String)objHshBbrdData.get("TITLE"));
%>
		<li><a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=1&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>"><%=nads.lib.util.ActComm.chrString(strTitle,  14)%></a></li>
<%

		}

	} else {
		out.println("<tr>");
		out.println("<td  height='18' class='news'><img src='image/main/icon_yellowdot.gif' width='3' height='4' align='absmiddle'> ");
		out.println("�ش� ����Ÿ�� �����ϴ�.");
		out.println("</td>");
		out.println("</tr>");
	}

%>
		</ul>
	</li>
<!-- ������ϱ� End -->
</ul>