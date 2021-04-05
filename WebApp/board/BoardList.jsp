<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%

	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");						//�α��� ID

	/*GET �Ķ����*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�
	String strCurrentPage = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVL(request.getParameter("strCurrentPage"), "1"));	//���� ������
	String strCountPerPage;																										//�������� ROW����
	String strSrchType = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchType")));				//�˻�Ÿ��(�˻�)
	String strSrchText = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("srchText")));					//�˻���(�˻�)

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	ArrayList objAryBbrdData = null;							//�Խù�
	Hashtable objHshBbrdInfo = null;						//�Խ���
	Hashtable objHshBbrdAuthInfo = null;					//�Խ��� ����� ����
	String strBbrdUserAuth = "Y";								//�Խ��� ����� ����
	String strGoToPage = URLEncoder.encode("/board/BoardContent.jsp", "UTF-8");

	if(strBbrdID == null || strBbrdID.equals("")) {
		try {

			//�Խ��� ���̵� ���ٸ� ���� �ֱ��� �Խ��������� ���� ���̵� �����´�.
			ArrayList objAryBbrdMenu = objBoard.selectBbrdMenu("BOARD", strLoginID, "");
			if (objAryBbrdMenu.size() != 0) {
				strBbrdID = (String)((Hashtable)objAryBbrdMenu.get(0)).get("PARAM");
				strBbrdID = strBbrdID.replaceAll(" ", "");
				int intIndex = strBbrdID.indexOf("bbrdid=");
				strBbrdID = strBbrdID.substring(intIndex+7, intIndex+17);
			}

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

	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");

		// ���� �߻� �޼��� �������� �̵��Ѵ�.

%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%

		return;
	}

	try {

		//CountPerPage�� �����´�.
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");

	} catch (ConfigException objConfigEx) {

		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");

	}

	try{

		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);
		if(objHshBbrdInfo.size() == 0) {

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSPARAM-0000");
			objMsgBean.setStrMsg("�Խ��� ������ �˼� �����ϴ�.");

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%

			return;

		}

		//2. �Խ��� ����Ʈ ������ �����´�.
		if(strSrchText.equals("") || strSrchText == null) {

			//�˻� ������ ���� ���
			objAryBbrdData = objBoard.selectBbrdDataListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage);

		}else {

			//�˻� ������ ���� ���.
			objAryBbrdData = objBoard.selectBbrdSearchListPerPage(strBbrdID, "0", strCurrentPage, strCountPerPage, strSrchType, strSrchText);

		}

		//3. �Խ��� ����� ������ �����´�.
		if(objHshBbrdInfo.get("AUTH_NEED_FLAG").equals("Y")) {

			objHshBbrdAuthInfo = objBoard.selectBbrdAuth(strBbrdID, strLoginID);

			if(objHshBbrdAuthInfo.size() == 0) {

				strBbrdUserAuth = "N";

			}

		}

	}catch (AppException objAppEx) {

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%

		return;
	}

	//�Խ��� ����

	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");		//�˻��� ���
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	String strBbrdExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdApdFileCnt = (String)objHshBbrdInfo.get("APD_FILE_CNT");
	String strBbrdOneAnsExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	String strBbrdColor = (String)objHshBbrdInfo.get("BBRD_COLOR");
	strBbrdColor = strBbrdColor.equals("")?"D3BA8F":strBbrdColor;
	String strBbrdImgPath = (String)objHshBbrdInfo.get("IMG_PATH");
	String strBbrdDsc = (String)objHshBbrdInfo.get("DSC");
	String strBbrdAuthNeedFlag = (String)objHshBbrdInfo.get("AUTH_NEED_FLAG");

	int intBbrdLength = strBbrdNm.length() * 4 + 1;
	int intBbrdLength2 = 0;
	if (intBbrdLength < 40) {
		intBbrdLength2 = 40 - intBbrdLength;
	}

	//��ü �������� ���ϱ�.
	String strTotalCount = (String)((Hashtable)objAryBbrdData.get(0)).get("TOTAL_COUNT");
	int intTotalCount = Integer.valueOf(strTotalCount).intValue();
	int intCountPerPage= Integer.valueOf(strCountPerPage).intValue();
	int  intTotalPage = intTotalCount / intCountPerPage + 1;
%>

<%@ include file="/board/common/BoardNavigator.jsp" %>

		<link href="/css2/style.css" rel="stylesheet" type="text/css">
		<script language="javascript">
			function goPage(varPageNo) {

				document.frmSearch.strCurrentPage.value = varPageNo;
				document.frmSearch.submit();

			}

			function doSearch() {

				var frm = document.frmSearch;
				if (frm.txtSearch.value == "" || frm.txtSearch.value == null) {

					alert("�˻�� �Է��� �ּ���.");
					frm.txtSearch.focus();
					return false;

				}

				frm.srchType.value = frm.selSearch.options[frm.selSearch.selectedIndex].value;
				frm.srchText.value = frm.txtSearch.value;
                frm.submit();
			}
		</script>
	</head>
	<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="wrap">
			<jsp:include page="/inc/top.jsp" flush="true"/>
			<jsp:include page="/inc/top_menu04.jsp" flush="true"/>
			<div id="container">
				<div id="leftCon">
					<jsp:include page="/inc/log_info.jsp" flush="true"/>
					<jsp:include page="/inc/left_menu04.jsp" flush="true"/>
				</div>
				<div id="rightCon">
					<!-- pgTit -->
					<div id="pgTit" style="background:url(/images2/foundation/stl_bg_board.jpg) no-repeat left top;">
						<h3><%=strBbrdNm%> <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
						<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> &gt;�Խ���&gt;<%=strBbrdKindNm%></div>
						<p><!--����--></p>
					</div>
					<!-- /pgTit -->
					<!-- contents -->
					<div id="contents">
					<!-- �������� ���� -->
						<div class="myP">
							<!-- �˻�â -->
							<!-- /�˻�â  -->
							<!-- list -->
							<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=strTotalCount%>�� (<%=strCurrentPage%>/<%=intTotalPage%> page)</span>
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
								<thead>
									<tr>
										<th scope="col"><a href="#">NO</a></th>
										<th scope="col" style="width:450px; "><a href="#">����</a></th>
										<th scope="col"><a href="#">����</a></th>
										<th scope="col"><a href="#">�����</a></th>
										<th scope="col"><a href="#">�������</a></th>
										<th scope="col"><a href="#">��ȸ</a></th>
									</tr>
								</thead>
								<tbody>
									<%
										if(intTotalCount != 0) {
											for (int i = 1; i < objAryBbrdData.size(); i++) {
												Hashtable objHshBbrdData = (Hashtable)objAryBbrdData.get(i);
												String strDataID = (String)objHshBbrdData.get("DATA_ID");
												int intViewDataID = Integer.valueOf(strTotalCount).intValue() - Integer.valueOf((String)objHshBbrdData.get("RNUM")).intValue() + 1;
												String strTitle = nads.lib.reqsubmit.util.StringUtil.getNoTagStr((String)objHshBbrdData.get("TITLE"));

                                                String strUserNm = (String)objHshBbrdData.get("USER_NM");
												String strWriteTs = (String)objHshBbrdData.get("WRITE_TS");
												String strUpdTs = (String)objHshBbrdData.get("UPD_TS");

												if(!strUpdTs.equals("")) {
													strWriteTs = strUpdTs;
												}

												strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-" + strWriteTs.substring(6, 8);
												String strFileExt = (String)objHshBbrdData.get("APD_FILE_EXT");
												String strFileExtImg = "&nbsp;";

												if(strFileExt.equals("Y")) {
													strFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
												}

												String strQryCnt = (String)objHshBbrdData.get("QRY_CNT");
												int intDataLevel = Integer.valueOf((String)objHshBbrdData.get("DATA_LEVEL")).intValue();
												String strDelFlag = (String)objHshBbrdData.get("DEL_FLAG");

												if(strDelFlag.equals("A") || strDelFlag.equals("Y")) {
													strTitle = "�ش���� ���� �Ǿ����ϴ�";
												}
									%>
									<tr>
										<td><%=intViewDataID%></td>
										<td style="text-align:left;">
											<%
												if(intDataLevel > 0 ) {

													String strWid = "";

													for(int j=0; j < intDataLevel ; j++){
														strWid = strWid + "&nbsp;&nbsp;&nbsp;";
													}

													out.print(strWid + "<img src='/image/board/icon_reply.gif' border='0'>");
												}

											%>
											<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>">
												<%=strTitle%>
											</a>
										</td>
										<td><%=strFileExtImg%></td>
										<td><%=strUserNm%></td>
										<td><%=strWriteTs%></td>
										<td><p><%=strQryCnt%></p></td>
									</tr>
									<%

											}

										} else {
											out.println("<tr>");
											out.println("<td height='22' colspan='6' align='center'>�ش� ����Ÿ�� �����ϴ�.");
											out.println("</td>");
											out.println("</tr>");
										}

									%>
								</tbody>
							</table>

							<!-- ����¡-->
							<table  align="center">
								  <tr>
									<td height="35" align="center">
										<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
										<%//=PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage) %>
										<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
										<%=objPaging.pagingTrans(PageCount.getLinkedString(strTotalCount , strCurrentPage, strCountPerPage))%>
									</td>
								  </tr>
							</table>
							<!-- /����¡-->

							<!-- /list -->
							<!-- ����Ʈ ��ư-->
							<div id="btn_all" >
								<!-- ����Ʈ �� �˻� -->
								<div class="list_ser" >
								<form name="frmSearch" method="post" action="<%=request.getRequestURI()%>">
									<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
									<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
                                    <input type="hidden" name="srchType" value="<%=strSrchType%>">
                                    <input type="hidden" name="srchText" value="<%=strSrchText%>">
									<%

										String strSelValue = "";

										if(strBbrdKind.equals(noticeBoard)) {
											strSelValue = "NOTICE_ALL";
										}else {
											strSelValue = "FREE_ALL";
										}

									%>
									<select name="selSearch" class="selectBox5" style="width:70px;" >
										<option value="<%=strSelValue%>" <% if(strSrchType.equals("FREE_ALL") || strSrchType.equals("NOTICE_ALL")) out.println("selected"); %>>��ü</option>
										<option value="TITLE" <% if (strSrchType.equals("TITLE")) out.println("selected"); %>>����</option>
										<option value="CONT" <% if (strSrchType.equals("CONT")) out.println("selected"); %>>����</option>
										<% if (!strBbrdKind.equals(noticeBoard)) { %>
										<option value="USER_NM" <% if (strSrchType.equals("USER_NM")) out.println("selected"); %>>�ۼ���</option>
										<% } %>
									</select>
									<input name="txtSearch" onKeyDown="if(event.keyCode==13) doSearch();return ch();" onMouseDown="return ch()" class="li_input" style="width:100px" value="<%=strSrchText%>" />
									<img src="/images2/btn/bt_list_search.gif" style="cursor:hand;" onclick="doSearch()" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
									<!-- /����Ʈ �� �˻� -->
									<span class="right">
										<span class="list_bt">
											<!-- �����ڷ��ɰ������_2011 -->
											<%// if (strBbrdUserAuth.equals("Y") ) {%>
											<a href="WriteBoard.jsp?bbrdid=<%=strBbrdID%>">����</a>
											<%// } %>
											<a href="BoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>">
												���
											</a>
										</span>
									</span>
								</div>
								</form>
								<!-- /����Ʈ ��ư-->
								<!-- /�������� ���� -->
							</div>
							<!-- /contents -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</body>
</html>

