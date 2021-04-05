<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*���ǰ� */
	String strLoginID = (String)session.getAttribute("USER_ID");					//�α��� ID
	String strLoginNm = (String)session.getAttribute("USER_NM");					//�α��� Name

	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));              //�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));               //�Խù� ���̵�

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

	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){

		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("�Խù� ������ �˼� �����ϴ�.");

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;

	}

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objQnaBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;		//�Խ���
	Hashtable objHshMainInfo = null;		//�ֱ�
	Hashtable objHshBeforeInfo = null;		//������
	Hashtable objHshNextInfo = null;		//������
	ArrayList objAryTtopList = null;			//���ñ�
	ArrayList objAryFileList = null;				//��������
	String strGoToPage = URLEncoder.encode("/help/BoardContent.jsp", "UTF-8");
	String strDelGoToPage = URLEncoder.encode("/help/BoardList.jsp", "UTF-8");

	try{
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objQnaBoard.selectBbrdInfo(strBbrdID);

		//2. �ֱ�, ������, ������ ������ �����´�.
		Hashtable objHshDataInfo = objQnaBoard.selectBbrdBNInfo(strBbrdID, strDataID, "0");
		objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		objHshBeforeInfo = (Hashtable)objHshDataInfo.get("BEFORE_INFO");
		objHshNextInfo = (Hashtable)objHshDataInfo.get("NEXT_INFO");

		//3. �ش� �Խù��� ���ñ� ����Ʈ�� �����´�.
		objAryTtopList = objQnaBoard.selectTtopDataList((String)objHshMainInfo.get("TTOP_BBRD_ID"));

		//4. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshMainInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objQnaBoard.selectFileList(strDataID);
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

	//�Խ��� ����
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	String strBbrdColor = (String)objHshBbrdInfo.get("BBRD_COLOR");
	strBbrdColor = strBbrdColor.equals("")?"#B8C67F":strBbrdColor;
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	int intBbrdLength = strBbrdNm.length() * 2 - 1;
	int intBbrdLength2 = 0;
	if(intBbrdLength < 40){
		intBbrdLength2 = 40 - intBbrdLength;
	}
	String strBbrdAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	String strEditorExt = (String)objHshMainInfo.get("HTML_USE_FLAG");

	//�Խù� ����
	String strTitle = (String)objHshMainInfo.get("TITLE");
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strUserNm = (String)objHshMainInfo.get("USER_NM");
	if (strUserNm.equals("") || strUserNm.equals(" " ) || strUserNm == null){
		strUserNm = "&nbsp;";
	}
	String strCont = (String)objHshMainInfo.get("CONT");
	if (strCont.equals("") || strCont.equals(" " ) || strCont == null){
		strCont = "&nbsp;";
	}
	strCont = strCont.replaceAll("&lt;","<");
	strCont = strCont.replaceAll("&gt;",">");
	strCont = strCont.replaceAll("&#39;","'");

	if(strEditorExt.equals("N")) {
		strCont = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strCont);
		strCont = strCont.replaceAll("\n", "<br>");
	}

	if(strEditorExt.equals("N")) {
		strUserNm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strUserNm);		
	}

    strTitle = strTitle.replaceAll("&lt;","<");
	strTitle = strTitle.replaceAll("&gt;",">");
	strTitle = strTitle.replaceAll("&#39;","'");

	if(strEditorExt.equals("N")) {
		strTitle = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strTitle);		
	}



	String strWriteTs = (String)objHshMainInfo.get("WRITE_TS");
	String strUpdTs = (String)objHshMainInfo.get("UPD_TS");
	if(!strUpdTs.equals("")){
		strWriteTs = strUpdTs;
	}
	strWriteTs = strWriteTs.substring(0, 4) + "-" + strWriteTs.substring(4, 6) + "-"
						+ strWriteTs.substring(6, 8) + "&nbsp;&nbsp;" + strWriteTs.substring(8, 10) + ":"
						+ strWriteTs.substring(10, 12) + ":" + strWriteTs.substring(12, 14);
	String strQryCnt = (String)objHshMainInfo.get("QRY_CNT");
	String strWriterID = (String)objHshMainInfo.get("WRITER_ID");
	//�����ڿ� ���� ������ ó��
	String strDelFlag = (String)objHshMainInfo.get("DEL_FLAG");
	if(strDelFlag.equals("A") || strDelFlag.equals("Y")){
		strTitle = "�ش���� ���� �Ǿ����ϴ�";
		//���뿡 ���� ������ ��Ÿ����.
		strCont = "�������� : " + (String)objHshMainInfo.get("DEL_RSN");
	}
	//���ٴ亯�� ���ؼ� �ʿ��� ��
	String strOneExt = (String)objHshMainInfo.get("ONE_ANS_EXT");
	//����� ���ؼ� �ʿ��� ��.
	String strTtopID = (String)objHshMainInfo.get("TTOP_BBRD_ID");
	String strLevel = (String)objHshMainInfo.get("DATA_LEVEL");
	String strOrder = (String)objHshMainInfo.get("DATA_ORDER");
	String strFileExt = (String)objHshMainInfo.get("APD_FILE_EXT");

	session.setAttribute("DELID",strWriterID);
	session.setAttribute("DATA_ID",strDataID);
	session.setAttribute("BBRD_ID",strBbrdID);
%>
<%@ include file="/board/common/ForumBoardNavigator.jsp" %>

<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">

	function goToUpdate(){
        var frm = document.frmContent;
		//delete ������ encType="multipart/form-data"�� ����ϹǷ� get ������� ����Ÿ�� �ѱ�
        frm.action = "UpdateBoard.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>";
        frm.submit();
	}

	function goToDelete(){
        var frm = document.frmContent;
		var msg = "�ش� ���ٴ�۰� ÷�������� ��� �����˴ϴ�.\n�Խù��� ���� �Ͻðڽ��ϱ�?";

	    if(confirm(msg)){
			frm.cmd.value = "DELETE";
			frm.oneext.value = "<%=strOneExt%>";
			frm.fileext.value = "<%=strFileExt%>";
			frm.strGoToPage.value = "<%=strDelGoToPage%>";
			frm.action = "/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>";
            frm.submit();
	    }
	    else{
	        return false;
	    }

	}

	function goToAnswer(){
        var frm = document.frmContent;
		//���� �Խù��� ���� ������ ������.
		//delete ������ encType="multipart/form-data"�� ����ϹǷ� get ������� ����Ÿ�� �ѱ�
        frm.action = "WriteBoard.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&ttopid=<%=strTtopID%>&toplevel=<%=strLevel%>&toporder=<%=strOrder%>";
        frm.submit();
	}

	function goToOneSave(){

		var frm = document.frmOneAns;

		if (frm.oneword.value == "" || frm.oneword.value == null){
			alert("���ٴ�� ������ �Է��� �ּ���.");
			frm.oneword.focus();
			return false;
		}

		if (fnSpaceChk(frm.oneword.value, "���ٴ���� �ùٸ��� �Է��ϼ���.") == false ) 	return false;

		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.oneword, 100, "���� ���") == false){
            return false;
        }

	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<div id="wrap">
		<jsp:include page="/inc/top.jsp" flush="true"/>
		<jsp:include page="/inc/top_menu05.jsp" flush="true"/>
		<div id="container">
			<div id="leftCon">
				<jsp:include page="/inc/log_info.jsp" flush="true"/>
				<jsp:include page="/inc/left_menu05.jsp" flush="true"/>
			</div>
			<div id="rightCon">
				<!-- pgTit -->
				<div id="pgTit" style="background:url(/images2/foundation/stl_bg_board.jpg) no-repeat left top;">
					<h3><%=strBbrdNm%> <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
					<div class="navi">
						<img src="/images2/foundation/home.gif" width="13" height="11" /> &gt;�Խ���&gt;<%=strBbrdKindNm%>
					</div>
					<p><!--����--></p>
				</div>
				<!-- /pgTit -->
              <!-- contents -->
				<form name="frmContent" method="post" action="" encType="multipart/form-data">
					<input type="hidden" name="cmd" value="">
					<input type="hidden" name="strGoToPage" value="">
					<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
					<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
					<input type="hidden" name="dataid" value="<%=strDataID%>">
					<input type="hidden" name="oneext" value="">
					<input type="hidden" name="fileext" value="">
				<table cellspacing="0" cellpadding="0" class="list03">

					<tr>
						<th height="25" width="141">&bull;&nbsp;����</th>
						<td height="25" colspan="3"><strong><%=strTitle%></strong></td>
					</tr>
					<tr>
						<th height="25" width="141">&bull;&nbsp;�����</th>
						<td height="25" width="237"><%=strUserNm%></td>
						<th height="25" width="127">&bull;&nbsp;��ȸ</th>
						<td height="25" width="253"><%=strQryCnt%></td>
					</tr>
					<tr>
						<th height="25" width="141">&bull;&nbsp;�����</th>
						<td height="25" colspan="3"><%=strWriteTs%></td>
					</tr>
					<tr>
						<th height="45" width="141">&bull;&nbsp;����</th>
						<td height="45" valign="top" colspan="3"><p><%=strCont%></p></td>
					</tr>
					<% if (strDelFlag.equals("N") && intBbrdFileCnt != 0) {	//�Խ��� ������ ����÷�ΰ� 0���� �ƴ϶��....%>
					<tr>
						<th height="25" width="141">&bull;&nbsp;����</th>
						<td height="25" colspan="3">
							<%
								String strFileIcon = "";
								String strFileExtNm = "";
								String strFileName = "";

								if (objAryFileList != null) {
								if (objAryFileList.size() != 0){
									for (int i = 0; i < objAryFileList.size(); i++) {
										Hashtable objHshFile = (Hashtable)objAryFileList.get(i);

										float fltSize =  (Integer.valueOf((String)objHshFile.get("FILE_SIZE")).floatValue())/1000;
										int intSize = 0;
										if(fltSize < 1){
											intSize = 1;
										} else {
											 intSize = Math.round(fltSize);
										}

										strFileName =(String)objHshFile.get("FILE_NAME");
										strFileExtNm = strFileName.substring(strFileName.lastIndexOf(".")+1,strFileName.length());

										if(strFileExtNm.toLowerCase().equals("ppt"))
											strFileIcon = "ppt";
										else if(strFileExtNm.toLowerCase().equals("pdf"))
											strFileIcon = "pdf";
										else if(strFileExtNm.toLowerCase().equals("xls"))
											strFileIcon = "excel";
										else if(strFileExtNm.toLowerCase().equals("toc"))
											strFileIcon = "toc";
										else if(strFileExtNm.toLowerCase().equals("doc"))
											strFileIcon = "word";
										else if(strFileExtNm.toLowerCase().equals("html") || strFileExtNm.equals("htm"))
											strFileIcon = "excel";
										else if(strFileExtNm.toLowerCase().equals("hwp"))
											strFileIcon = "hangul";
										else if(strFileExtNm.toLowerCase().equals("gif"))
											strFileIcon = "gif";
										else if(strFileExtNm.toLowerCase().equals("jpg"))
											strFileIcon = "jpg";
										else if(strFileExtNm.toLowerCase().equals("zip"))
											strFileIcon = "zip";
										else
											strFileIcon = "file";

							%>
							<a href="/board/common/FileDownload.jsp?dataid=<%=strDataID%>&fileid=<%=(String)objHshFile.get("FILE_ID")%>">
								<img src="/image/common/icon_<%=strFileIcon%>.gif" width="13" height="15" /> <%=(String)objHshFile.get("FILE_NAME")%>
							</a> (<%=intSize%>KB) Download :  <%=(String)objHshFile.get("DOWN_CNT")%>
							<%
									}	//end for
								} else {
									out.println("&nbsp;<br>");
								}
							  }	//end if (null check)
							%>
						</td>
					</tr>
					<% } %>
					<!-- ������/������ ���� --------------------------------->
                    <% if(objHshBeforeInfo.get("DATA_ID") != null){ %>
					<tr>
						<td height="20" colspan="5">
							<span class="fonts">
								<img src="../images2/common/icon_prev02.gif" width="52" height="20" />&nbsp;
								<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshBeforeInfo.get("DATA_ID")%>">
								<%
									String strBTitle = BoardComm.replaceTag2Text((String)objHshBeforeInfo.get("TITLE"));
									String strBDelFlag = (String)objHshBeforeInfo.get("DEL_FLAG");
									if(strBDelFlag.equals("A") || strBDelFlag.equals("Y")){		//�����ڿ� ���� ����
										strBTitle = "�ش���� ���� �Ǿ����ϴ�";
									}
									out.println(strBTitle);
								%>
								</a>
							</span>
						</td>
					</tr>
					<%
		              }

		              if(objHshNextInfo.get("DATA_ID") != null){
		            %>
					<tr>
						<td colspan="5">
							<span class="fonts">
								<img src="../images2/common/icon_next02.gif" width="52" height="20" />&nbsp;
								<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshNextInfo.get("DATA_ID")%>">
								<%
									String strNTitle = BoardComm.replaceTag2Text((String)objHshNextInfo.get("TITLE"));
									String strNDelFlag = (String)objHshNextInfo.get("DEL_FLAG");
									if(strNDelFlag.equals("A") || strNDelFlag.equals("Y")){		//�����ڿ� ���� ����
										strNTitle = "�ش���� ���� �Ǿ����ϴ�";
									}
									out.println(strNTitle);
								%>
			                    </a>
							</span>
						</td>
					</tr>
					<% } %>
					<!-- ������/������ �� --------------------------------->
				</table></br>
                    <!-- ���ñ� ����Ʈ ���̺� ���� -------------------------------->
				<% if (strBbrdAnsExt.equals("Y")) { 	//�Խ��� ��� ������ "Y"�� ��츸 ���ñ��� �����ش�.%>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
					<thead>
						<tr>
							<th scope="col" style="width:450px; "><a href="#">����</a></th>
							<th scope="col"><a href="#">�����</a></th>
							<th scope="col">�������</th>
							<th scope="col">��ȸ</th>
						</tr>
					</thead>
					<tbody>
					<%
					if (objAryTtopList != null) {
					for (int i = 0; i < objAryTtopList.size(); i++) {
						Hashtable objHshTtopList = (Hashtable)objAryTtopList.get(i);

						String strTtopDataID = (String)objHshTtopList.get("DATA_ID");
						String strTtopTitle = BoardComm.replaceTag2Text((String)objHshTtopList.get("TITLE"));
						String strTtopDelFlag = (String)objHshTtopList.get("DEL_FLAG");
						if(strTtopDelFlag.equals("A") || strTtopDelFlag.equals("Y")){
							strTtopTitle = "�ش���� ���� �Ǿ����ϴ�";
						}
						if (strDataID.equals(strTtopDataID)){
							strTtopTitle = "<b>" + strTtopTitle + "</b>";
						}
						String strTtopWriteTs = (String)objHshTtopList.get("WRITE_TS");
						strTtopWriteTs = strTtopWriteTs.substring(0, 4) + "-" + strTtopWriteTs.substring(4, 6) + "-"
													+ strTtopWriteTs.substring(6, 8);
						int intTtopLevel = Integer.valueOf((String)objHshTtopList.get("DATA_LEVEL")).intValue();
					%>
						<tr>
							<td>
							    <%
									if(intTtopLevel > 0 ){
										String strTtopWid = "";

										for(int j=0; j < intTtopLevel ; j++){
											strTtopWid = strTtopWid + "&nbsp;&nbsp;&nbsp;";
										}
										out.print(strTtopWid + "<img src='/image/board/icon_reply.gif' border='0'>");
									}
			                    %>
	                        	<a href="/board/common/BoardList2Content.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strTtopDataID%>&goToPage=BoardContent.jsp"><%=strTtopTitle%></a>
							</td>
							<td><%=objHshTtopList.get("USER_NM")%></td>
							<td><%=strTtopWriteTs%></td>
							<td><%=objHshTtopList.get("QRY_CNT")%></td>
						</tr>
					<%
						} 	//end for
					}	//end if
					%>
					</tbody>
				</table>
				<% } //end if (���ñ� "Y")%>
				</form>
				<!-- ����Ʈ ��ư-->
				<div id="btn_all" >
					<span class="right">

                        <%
                      		//�Խù��� ������ ���� ��ư�� �ۼ���ID�� �α��� ������� ID�� ���� ��츸 ��Ÿ����.

                      		//if(strBbrdKind.equals(noticeBoard) != true && !strDelFlag.equals("A")){
                            if(strBbrdKind.equals(noticeBoard) != true && !strDelFlag.equals("A")){
							 	if (strLoginID.equals(strWriterID)) {
						 %>
                        <span class="list_bt"><a href="#" onClick="goToUpdate()">����</a></span>
                        <span class="list_bt"><a href="#" onClick="goToDelete()">����</a></span>
                        <%
								}

								//�Խ��� ��� ������ "Y"�� ��츸 ��� ��ư�� �����ش�.
								if (strBbrdAnsExt.equals("Y")) {
						%>
                        <span class="list_bt"><a href="#" onClick="goToAnswer()">���</a></span>
                        <%
                        		}
                        	} //end if (DelFlag Check)
                        %>
                        <span class="list_bt"><a href="BoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>">���</a></span>
                    </span>
				</div>
				<!-- /����Ʈ ��ư-->
				<!-- ���ٴ�� ����Ʈ ���� ---------------------------->
	            <% if(strBbrdOneExt.equals("Y") && !strDelFlag.equals("A")){ %>
              	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<form name="frmOneAns" method="post" action="/board/common/BoardOneAnsProc.jsp?cmd=ONE_CREATE" onSubmit="return goToOneSave();">
					<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
					<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
					<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
					<input type="hidden" name="dataid" value="<%=strDataID%>">
					<input type="hidden" name="nowext" value="<%=strOneExt%>">
	              <%
					if(strOneExt.equals("Y")){
						ArrayList objAryOneAnsList =  null;
						int c=0;
						String strBgColor = "";

						try {
							//�������� �Խù��� �ش��ϴ� ��۸���Ʈ�� �����´�.
							objAryOneAnsList = objQnaBoard.selectOneAnsList(strDataID);

						} catch (AppException objAppEx) {

							// ���� �߻� �޼��� �������� �̵��Ѵ�.
							out.println(objAppEx.getStrErrCode());
							out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.");
							return;

						}

						if(objAryOneAnsList != null){

							int intOneCnt = objAryOneAnsList.size();						//��ü ���ٴ�� ����

							for(int i=0;i < objAryOneAnsList.size();i++){
								Hashtable objHshOneAnsList = (Hashtable)objAryOneAnsList.get(i);

								String strOneUserNm = (String)objHshOneAnsList.get("USER_NM");
								String strOneID = (String)objHshOneAnsList.get("ONE_ANS_ID");
								String strOneDataID = (String)objHshOneAnsList.get("DATA_ID");
								String strOneWord = (String)objHshOneAnsList.get("ONE_WORD");
								String strOneWriterID = (String)objHshOneAnsList.get("WRITER_ID");
								String strOneWriteTs = (String)objHshOneAnsList.get("WRITE_TS");
								strOneWriteTs = strOneWriteTs.substring(0, 4) + ":" + strOneWriteTs.substring(4, 6)
														+ ":" + strOneWriteTs.substring(6, 8);
								String strOneDelFlag = (String)objHshOneAnsList.get("DEL_FLAG");
								if(strOneDelFlag.equals("A") || strOneDelFlag.equals("Y")){
									strOneWord = "�ش���� ���� �Ǿ����ϴ�.";
								}

								if(c%2==0){	strBgColor = "bgcolor='#F7F3F8'"; }
								else{ strBgColor = ""; }
								c++;
					  %>
	                  <tr>
	                    <td align="center" <%=strBgColor%> class="td_box"><%=strOneUserNm%><br>
	                      (<%=strOneWriteTs%>) </td>
	                    <td colspan="2" valign="top" <%=strBgColor%> class="td_box"><%=strOneWord%>
	                    <% if (strLoginID.equals(strOneWriterID) && strOneDelFlag.equals("N")){ %>
	                    <a href="/board/common/BoardOneAnsProc.jsp?strGoToPage=<%=strGoToPage%>&strCurrentPage=<%=strCurrentPage%>&cmd=ONE_DELETE&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&oneid=<%=strOneID%>&onecnt=<%=intOneCnt%>" onClick="return goToOneDelete();"><img src="/image/button/bt_del_board.gif" width="25" height="12" border="0"></a>
	                    <% } %>
	                    </td>
	                  </tr>
	                  <%
								}//end for
							}
						}//end if strOneExt
					  %>
	                  <tr valign="top" class="tbl-line">
	                    <td height="1"></td>
	                    <td height="1"></td>
	                    <td height="1"></td>
	                  </tr>
	                  <tr>
	                    <td width="18%" rowspan="2" bgcolor="E9E9E9" class="td_gray2"><font color="F5F5F5">....</font><img src="/image/common/icon_nemo_gray.gif" width="3" height="6">
	                      <span class="soti_forum">���� ���</span></td>
	                    <td width="67%" height="25" valign="bottom" bgcolor="E9E9E9">&nbsp;&nbsp;&nbsp;&nbsp;�ۼ��� : <%=strLoginNm%>&nbsp;&nbsp;&nbsp;[���� <span id="textlimit">0</span>/�ִ� 100byte(�ѱ� 50��, ���� 100��)]</td>
	                    <td width="15%" valign="middle" bgcolor="E9E9E9">&nbsp;</td>
	                  </tr>
	                  <tr>
	                    <td width="68%" valign="top" bgcolor="E9E9E9" class="td_box"><input name="oneword" type="text" class="textfield" style="WIDTH: 420px" onKeyUp="javascript:textCounter(frmOneAns.oneword, 100);"></td>
	                    <td width="15%" valign="middle" bgcolor="E9E9E9">
	                    	<input type="image" src="/image/button/bt_confirm_icon.gif" width="47" height="19" border="0">
	                    </td>
	                  </tr>
		             </form>
				</table>
				<% } %>
	                <!-- ���ٴ�� ����Ʈ �� ---------------------------->
              	<!-- /�������� ���� -->
			</div>
		</div>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</div>
</body>
</html>
