<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<%@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));							//�Խù� ���̵�

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
	Hashtable objHshDataInfo = null;		//�Խù�
	ArrayList objAryFileList = null;				//��������
	int intFileCnt = 0;									//������ ��ϵ� ���� ����
	String strGoToPage = URLEncoder.encode("/help/BoardList.jsp", "UTF-8");	//��ũ�� ������ ����

	try {
		//1. �Խ��� ������ �����´�.
		objHshBbrdInfo = objQnaBoard.selectBbrdInfo(strBbrdID);

		//2. �Խù� ������ �����´�.
		objHshDataInfo = objQnaBoard.selectBbrdDataInfo(strDataID);

		//3. ��ϵ� ������ �ִٸ� �������� ����Ʈ�� �����´�.
		if (((String)objHshDataInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objQnaBoard.selectFileList(strDataID);
			intFileCnt = objAryFileList.size();
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
	if(intBbrdLength < 40 ){
		intBbrdLength2 = 40 - intBbrdLength;
	}

	//�Խù� ����
	String strTitle = (String)objHshDataInfo.get("TITLE");
	if (strTitle.equals("") || strTitle.equals(" " ) || strTitle == null){
		strTitle = "&nbsp;";
	}
	String strUserNm = (String)objHshDataInfo.get("USER_NM");
	if (strUserNm.equals("") || strUserNm.equals(" " ) || strUserNm == null){
		strUserNm = "&nbsp;";
	}
	String strCont = (String)objHshDataInfo.get("CONT");
	if (strCont.equals("") || strCont.equals(" " ) || strCont == null){
		strCont = "&nbsp;";
	}
	//strCont = strCont.replaceAll("<","&lt;");
	//strCont = strCont.replaceAll(">","&gt;");
	//strTitle = strTitle.replaceAll("<","&lt;");
	//strTitle = strTitle.replaceAll(">","&gt;");
	String strWriteTS = (String)objHshDataInfo.get("WRITE_TS");

	String strWriteID = StringUtil.getNVLNULL((String)objHshDataInfo.get("WRITER_ID"));

	session.setAttribute("WRITER_ID",strWriteID);
	session.setAttribute("BBRD_ID",strBbrdID);
	session.setAttribute("DATA_ID",strDataID);

	strWriteTS = strWriteTS.substring(0, 4) + "-" + strWriteTS.substring(4, 6) + "-"
						+ strWriteTS.substring(6, 8);
	String strQryCnt = (String)objHshDataInfo.get("QRY_CNT");
	String strEditorExt = (String)objHshDataInfo.get("HTML_USE_FLAG");
%>
<%@ include file="/board/common/ForumBoardNavigator.jsp" %>

<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script language="javascript">

	//������ �ʱ�ȭ
	var myeditor = new htmleditor("myeditor");

	function setCont() {

		//myeditor.width = 520;
		//myeditor.height = 290;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		//var varCont = document.frmUpdate.cont.value;
		//myeditor.init(varCont);

	}

	function isSave() {

		var frm = document.frmUpdate;

		if (frm.title.value == "" || frm.title.value == null){
			alert("������ �Է��� �ּ���.");
			frm.title.focus();
			return false;
		}

		if (fnSpaceChk(frm.title.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;

		//�ѱ�, ���� �����Ͽ� ���ڿ� ���̸� üũ�Ѵ�.
        if(checkStrLen(frm.title, 100, "����") == false){
            return false;
        }

		var max_file = <%=intBbrdFileCnt%>;		//��� ������ ���� ����
		var del_file = 0;											//���� ��û�� ���� ����
		var new_file = 0;										//���� �߰��� ���� ����
		var old_file = "<%=intFileCnt%>";				//���� ��ϵ� ���� ����
		var total_file = 0;										//��� �� ������ ���� ����
		var fileext = ""											//���� ���� ����

		//���� ��û�� ������ ������ ���Ѵ�.
		if (frm.delfile != null){
			//length�� 1�ϰ�� undefined�� ���� üũ���ش�.
			if(frm.delfile.length == undefined){
				if(frm.delfile.checked == true){
					del_file = 1;
				}
			} else {
				for(var i = 0; i < frm.delfile.length; i++){
					if(frm.delfile[i].checked == true){
						del_file = del_file + 1;
					}
				}
			}
		}

		//���� �߰��Ǵ� ���� ������ ���Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") { new_file = new_file + 1; }
		}
		//alert("new_file : " + new_file);

		total_file = (old_file - del_file) + new_file;

		if(total_file == 0){
			fileext = "N";
		} else {
			fileext = "Y";
		}

		if(total_file > max_file){
			alert("���� ÷�δ� " + max_file + "������ �Դϴ�.");
			return false;
		}

		//������ ���� ����
		var ext = "";
/*		for (i = 0; i < frm.editorflag.length; i++) {
		    if (frm.editorflag[i].checked == true) {
		        ext = frm.editorflag[i].value;
		        break;
		    }
		}
*/
		if(ext == "Y"){														//HTML�����͸� ����� ���

			var varCont = myeditor.get_content("NO");
			frm.cont.value = varCont;

		} else {																//�ؽ�Ʈ�� ����� ���

			if (frm.txtCont.value == "" || frm.txtCont.value == null){
				alert("���� ������ �Է��� �ּ���.");
				frm.txtCont.focus();
				return false;
			}

			if (fnSpaceChk(frm.txtCont.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;
		}

		//÷�����ϸ� ���̸� üũ�Ѵ�.
		for(var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if(eval(file_object) != ""){
				if(checkFileName(eval(file_object)) == false){
					return false;
				}
			}
		}

		//÷�������� Ÿ���� üũ�Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}

		//÷�������� Ÿ���� üũ�Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach2(eval(file_object))== false){
		            return false;
		        }
			}
		}

		frm.editorext.value = ext;
		frm.fileext.value = fileext;
        frm.submit();
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
					<h3><%=strBbrdNm%><!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
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
					<form name="frmUpdate" method="post" action="/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" encType="multipart/form-data">
						<input type="hidden" name="cmd" value="UPDATE">
						<textarea name="cont" wrap="hard" style="display:none;"><%=strCont%></textarea>
						<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
						<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
						<input type="hidden" name="dataid" value="<%=strDataID%>">
						<input type="hidden" name="editorext" value="N">
						<input type="hidden" name="fileext" value="">
						<table cellspacing="0" cellpadding="0" class="list03">

							<tr>
							  <th height="25" width="141">����</th>
							  <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" value="<%=strTitle%>"></td>
							</tr>
							<tr>
							  <th height="25" width="141">�����</th>
							  <td height="25"><%=strUserNm%></td>
							</tr>
							<tr>
							  <th height="25" width="141">�����</th>
							  <td height="25"><%=strWriteTS%></td>
							</tr>
							<!--
							<tr>
							<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� ����</td>
							<td height="25" class="td_lmagin">
							<input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmUpdate.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>�ؽ�Ʈ
							<input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmUpdate.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML ������
							</td>
							</tr>
							<tr class="tbl-line">
							<td height="1"></td>
							<td height="1"></td>
							</tr>
							-->
							<tr>
								<th height="310" width="141">����</th>
								<td height="310" valign="top">
									<span ID="newlayer" style="position:relative;"><textarea name="txtCont"style="width:450px; height:250px;"><%=strCont%></textarea></span>
									<span ID="newlayer2"><script>setCont();</script></span>
								</td>
							</tr>
							<% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
							<tr>
								<th height="25" width="141">����</th>
								<td height="25">
							<%
								for(int i = 0; i < intBbrdFileCnt; i++) {

									out.println("<input name='showfile" + i + "' value='' readonly>");
									out.println("<input type='file' name='upfile" + i + "' onChange='javascript:searchFile(this.form, this);'><br>");

								} //end for

								if (objAryFileList != null) {
									if (objAryFileList.size() != 0){
										for (int i = 0; i < objAryFileList.size(); i++) {
											Hashtable objHshFile = (Hashtable)objAryFileList.get(i);

											String strFileName = (String)objHshFile.get("FILE_NAME");
											out.println("<input type='checkbox' name='delfile' value='"+ (String)objHshFile.get("FILE_ID") + "'>");
											out.println(strFileName + " ����<br>");
										}
									}
								}
							%>
								</td>
							</tr>
							<% } %>
						</table>
						<div id="btn_all" >
							<span class="right">
								<span class="list_bt">
									<a href="#" onclick="isSave();return false;"> ����</a>
								</span>
								<span class="list_bt" onClick="reset();">
									<a href="javascript:reset();">�� ��</a>
								</span>
								<span class="list_bt">
									<a href="BoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>">���</a>
								</span>
							</span>
						</div>
					</form>

                  <!-- �����Խ��� ���� ���̺� �� ------------------------->
				</div>
				<!-- /contents -->
			</div>
		</div>
		<%
			if(strEditorExt.equals("N")) {
				out.println("<script language='javascript'>");
				out.println("selEditor('newlayer', 'newlayer2');");
				out.println("</script>");
			}
			else if (strEditorExt.equals("Y")) {
				out.println("<script language='javascript'>");
				out.println("selEditor('newlayer2', 'newlayer');");
				out.println("</script>");
			}
		%>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</div>
</body>
</html>
