<%@ page language="java"  contentType="text/html;charset=euc-kr" %>

<%@ page import = "java.util.*" %>

<%@ page import = "java.net.*" %>

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

	String strLoginID = (String)session.getAttribute("USER_ID");						//�α��� ID

	String strLoginNm = (String)session.getAttribute("USER_NM");					//�α��� Name



	/*GET �Ķ����*/

	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //���� ������

	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�

	String strEditorExt =  "N";																										//����Ʈ�� "N"

	/* �亯�� ��� �߰��Ǵ� ���� GET �Ķ���� */

	String strDataID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));

	String strTTopID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ttopid")));

	String strTopLevel =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toplevel")));

	String strTopOrder =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toporder")));



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

	if(strBbrdID.equals("0000000012") || strBbrdID.equals("0000000127")){
		if(strLoginID.equals("ADMIN") || strLoginID.equals("ADMIN1") || strLoginID.equals("ADMIN2") || strLoginID.equals("0000039859")){

		}else{
			out.println("<script language=javascript>");
			out.println("alert('�Խ��ǿ� ���� ������ �����ϴ�.');");
			out.println("history.go(-1);");
			out.println("</script>");
			return;
		}
	}

	/*�ʱⰪ ���� */

	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

	Hashtable objHshBbrdInfo = null;			//�Խ���

	Hashtable objHshMainInfo = null;			//�Խ���

	String strGoToPage = URLEncoder.encode("/board/BoardList.jsp", "UTF-8");	//��ũ�� ������ ����



	try{

		//1. �Խ��� ������ �����´�.

		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);


		//2004.08.11 ��۽� ������ �����ش�.
		if(!strDataID.equals("")){
			Hashtable objHshDataInfo = objBoard.selectBbrdBNInfo(strBbrdID, strDataID, "0");
			objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
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

	String strBbrdImgPath = (String)objHshBbrdInfo.get("IMG_PATH");

	String strBbrdColor = (String)objHshBbrdInfo.get("BBRD_COLOR");

	strBbrdColor = strBbrdColor.equals("")?"D3BA8F":strBbrdColor;

	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();

	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");

	int intBbrdLength = strBbrdNm.length() * 4 + 1;

	int intBbrdLength2 = 0;

	if (intBbrdLength < 40) {

		intBbrdLength2 = 40 - intBbrdLength;

	}

	session.setAttribute("BBRD_ID",strBbrdID);


	//2004.08.11 ��۽� ������ �����ش�.
	String strCont = "";
	String strTitle = "";
	if(!strDataID.equals("")) {
		strTitle ="Re:"+(String)objHshMainInfo.get("TITLE");
		strCont = (String)objHshMainInfo.get("CONT");
		if (strCont.equals("") || strCont.equals(" " ) || strCont == null){

			strCont = "&nbsp;";

		}


		if(strEditorExt.equals("N")) {
			strCont = BoardComm.replaceTag2Text(strCont);
		}
	}

%>

<%@ include file="/board/common/BoardNavigator.jsp" %>

<script language="javascript" src="/js/forum.js"></script>

<script language="javascript" src="/js/editor/htmleditor.js"></script>

<script language="javascript">



	//������ �ʱ�ȭ

	var myeditor = new htmleditor("myeditor");



	function setCont() {



		myeditor.width = 520;

		myeditor.height = 290;

		//myeditor.fontsize = '10pt';

		//myeditor.lineheight = '14pt';

		var varCont = document.frmWrite.cont.value;

		myeditor.init(varCont);



	}



	function isSave() {



		frm = document.frmWrite;



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



		var ext = "";
/*
		for (i = 0; i < frm.editorflag.length; i++) {

		    if (frm.editorflag[i].checked == true) {

		        ext = frm.editorflag[i].value;

		        break;

		    }

		}

*/

		if(ext == "Y"){													//HTML�����͸� ����� ���



			var varCont = myeditor.get_content("NO");

			frm.cont.value = varCont;



		} else {															//�ؽ�Ʈ�� ����� ���



			if (frm.txtCont.value == "" || frm.txtCont.value == null){

				alert("���� ������ �Է��� �ּ���.");

				frm.txtCont.focus();

				return false;

			}



			if (fnSpaceChk(frm.txtCont.value, "������ �ùٸ��� �Է��ϼ���.") == false ) 	return false;

		}



		//÷�����ϸ� ���̸� üũ�Ѵ�.

		var max_file = <%=intBbrdFileCnt%>;		//��� ������ ���� ����



		for(var i = 0; i < max_file; i++) {

			var file_object = "document.frmWrite.upfile" + i + ".value";

			if(eval(file_object) != ""){

				if(checkFileName(eval(file_object)) == false){

					return false;

				}

			}

		}



		//÷�������� Ÿ���� üũ�Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}

		//÷�������� Ÿ���� üũ�Ѵ�.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach2(eval(file_object))== false){
		            return false;
		        }
			}
		}



		frm.editorext.value = ext;
		//�߰� YCH
		frm.submit();


	}

</script>

</head>



<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

	<div id="wrap">
		<%//@include file="/common/TopMenu.jsp" %>
		<jsp:include page="/inc/top.jsp" flush="true"/>
		<jsp:include page="/inc/top_menu04.jsp" flush="true"/>
		<div id="container">
			<%//@include file="/common/LeftMenu.jsp" %>
			<div id="leftCon">
				<jsp:include page="/inc/log_info.jsp" flush="true"/>
				<jsp:include page="/inc/left_menu04.jsp" flush="true"/>
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
						<form name="frmWrite" method="post" action="/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" encType="multipart/form-data">
							<input type="hidden" name="cmd" value="CREATE">
                            <textarea name="cont" wrap="hard" style="display:none;"></textarea>
							<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
							<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
							<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
							<input type="hidden" name="dataid" value="<%=strDataID%>">
							<input type="hidden" name="ttopid" value="<%=strTTopID%>">
							<input type="hidden" name="toplevel" value="<%=strTopLevel%>">
							<input type="hidden" name="toporder" value="<%=strTopOrder%>">
							<input type="hidden" name="editorext" value="">
						<table cellspacing="0" cellpadding="0" class="list03">

							<tr>
								<th height="25" width="141">&bull;&nbsp;����</th>
								<td height="25">
									<input maxlength="1000" size="70" name="title"  style="width:450px" VALUE="<%=strTitle%>" />
								</td>
							</tr>
							<tr>
								<th height="25" width="141">&bull;&nbsp;�����</th>
								<td height="25"><%=strLoginNm%></td>
							</tr>
							<tr>
								<th height="45" width="141">&bull;&nbsp;����</th>
								<td height="310">
                                    <textarea rows="5" cols="70" name="txtCont" style="width:100%; height:290px;"><%=strCont%></textarea>
								</td>
							</tr>
							<% if (intBbrdFileCnt != 0) {	//����÷�ΰ� 0���� �ƴ϶��....%>
							<tr>
								<th height="25" width="141">&bull;&nbsp;����</th>
								<td height="25">
									<% for(int i = 0; i < intBbrdFileCnt; i++) {%>

										<input readonly="readonly" name="showfile<%=i%>" value="" style="WIDTH: 300px"/>
										<input onChange="javascript:searchFile(this.form, this);" type="file" name="upfile<%=i%>" style="WIDTH: 90px"/></br>

									<% } %>

									<span class="warning">
										<br />
										* ÷������ �ִ�뷮 : <%=intKBSize%>M
									</span>
								</td>
							</tr>
							<% } %>

						</table>
						<!-- /list -->
						<!-- ����Ʈ ��ư-->
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
						<!-- /����Ʈ ��ư-->
						<!-- /�������� ���� -->
					</div>
					<!-- /contents -->

				</div>
			</div>
		</div>
		<%//@include file="/common/Bottom.jsp" %>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</div>

	<script language="javascript">
		//������ �ʱ�ȭ
		frmWrite.txtCont.value = stripHTMLtag(frmWrite.txtCont.value) ;
	</script>
</body>

</html>

