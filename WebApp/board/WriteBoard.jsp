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

	/*세션값 */

	String strLoginID = (String)session.getAttribute("USER_ID");						//로그인 ID

	String strLoginNm = (String)session.getAttribute("USER_NM");					//로그인 Name



	/*GET 파라미터*/

	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지

	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//게시판 아이디

	String strEditorExt =  "N";																										//디폴트값 "N"

	/* 답변일 경우 추가되는 사항 GET 파라미터 */

	String strDataID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));

	String strTTopID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("ttopid")));

	String strTopLevel =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toplevel")));

	String strTopOrder =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("toporder")));



	if(strBbrdID == null || strBbrdID.equals("") || strBbrdID.equals(" ")){



		objMsgBean.setMsgType(MessageBean.TYPE_ERR);

		objMsgBean.setStrCode("DSPARAM-0000");

		objMsgBean.setStrMsg("게시판 정보를 알수 없습니다.");



		// 에러 발생 메세지 페이지로 이동한다.

%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%

		return;


	}

	if(strBbrdID.equals("0000000012") || strBbrdID.equals("0000000127")){
		if(strLoginID.equals("ADMIN") || strLoginID.equals("ADMIN1") || strLoginID.equals("ADMIN2") || strLoginID.equals("0000039859")){

		}else{
			out.println("<script language=javascript>");
			out.println("alert('게시판에 대한 권한이 없습니다.');");
			out.println("history.go(-1);");
			out.println("</script>");
			return;
		}
	}

	/*초기값 설정 */

	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();

	Hashtable objHshBbrdInfo = null;			//게시판

	Hashtable objHshMainInfo = null;			//게시판

	String strGoToPage = URLEncoder.encode("/board/BoardList.jsp", "UTF-8");	//링크될 페이지 정보



	try{

		//1. 게시판 정보를 가져온다.

		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);


		//2004.08.11 답글시 원글을 보여준다.
		if(!strDataID.equals("")){
			Hashtable objHshDataInfo = objBoard.selectBbrdBNInfo(strBbrdID, strDataID, "0");
			objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		}



	} catch (AppException objAppEx) {



		objMsgBean.setMsgType(MessageBean.TYPE_ERR);

		objMsgBean.setStrCode(objAppEx.getStrErrCode());

		objMsgBean.setStrMsg(objAppEx.getMessage());



		// 에러 발생 메세지 페이지로 이동한다.

%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%

		return;



	}



	//게시판 정보

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


	//2004.08.11 답글시 원글을 보여준다.
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



	//에디터 초기화

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

			alert("제목을 입력해 주세요.");

			frm.title.focus();

			return false;

		}



		if (fnSpaceChk(frm.title.value, "제목을 올바르게 입력하세요.") == false ) 	return false;



		//한글, 영문 구별하여 문자열 길이를 체크한다.

        if(checkStrLen(frm.title, 100, "제목") == false){

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

		if(ext == "Y"){													//HTML에디터를 사용할 경우



			var varCont = myeditor.get_content("NO");

			frm.cont.value = varCont;



		} else {															//텍스트를 사용할 경우



			if (frm.txtCont.value == "" || frm.txtCont.value == null){

				alert("본문 내용을 입력해 주세요.");

				frm.txtCont.focus();

				return false;

			}



			if (fnSpaceChk(frm.txtCont.value, "내용을 올바르게 입력하세요.") == false ) 	return false;

		}



		//첨부파일명 길이를 체크한다.

		var max_file = <%=intBbrdFileCnt%>;		//등록 가능한 파일 갯수



		for(var i = 0; i < max_file; i++) {

			var file_object = "document.frmWrite.upfile" + i + ".value";

			if(eval(file_object) != ""){

				if(checkFileName(eval(file_object)) == false){

					return false;

				}

			}

		}



		//첨부파일의 타입을 체크한다.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}

		//첨부파일의 타입을 체크한다.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmWrite.upfile" + i + ".value";
			if (eval(file_object) != "") {
				 if(fnBoardLimitAttach2(eval(file_object))== false){
		            return false;
		        }
			}
		}



		frm.editorext.value = ext;
		//추가 YCH
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
					<h3><%=strBbrdNm%><!-- <span class="sub_stl" >- 상세보기</span> --></h3>
					<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> &gt;게시판&gt;<%=strBbrdKindNm%></div>
					<p><!--문구--></p>
				</div>
				<!-- /pgTit -->
				<!-- contents -->
				<div id="contents">
					<!-- 각페이지 내용 -->
					<div class="myP">
					<!-- 검색창 -->
					<!-- /검색창  -->
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
								<th height="25" width="141">&bull;&nbsp;제목</th>
								<td height="25">
									<input maxlength="1000" size="70" name="title"  style="width:450px" VALUE="<%=strTitle%>" />
								</td>
							</tr>
							<tr>
								<th height="25" width="141">&bull;&nbsp;등록자</th>
								<td height="25"><%=strLoginNm%></td>
							</tr>
							<tr>
								<th height="45" width="141">&bull;&nbsp;내용</th>
								<td height="310">
                                    <textarea rows="5" cols="70" name="txtCont" style="width:100%; height:290px;"><%=strCont%></textarea>
								</td>
							</tr>
							<% if (intBbrdFileCnt != 0) {	//파일첨부가 0개가 아니라면....%>
							<tr>
								<th height="25" width="141">&bull;&nbsp;파일</th>
								<td height="25">
									<% for(int i = 0; i < intBbrdFileCnt; i++) {%>

										<input readonly="readonly" name="showfile<%=i%>" value="" style="WIDTH: 300px"/>
										<input onChange="javascript:searchFile(this.form, this);" type="file" name="upfile<%=i%>" style="WIDTH: 90px"/></br>

									<% } %>

									<span class="warning">
										<br />
										* 첨부파일 최대용량 : <%=intKBSize%>M
									</span>
								</td>
							</tr>
							<% } %>

						</table>
						<!-- /list -->
						<!-- 리스트 버튼-->
						<div id="btn_all" >
							<span class="right">
								<span class="list_bt">
									<a href="#" onclick="isSave();return false;"> 저장</a>
								</span>
								<span class="list_bt" onClick="reset();">
									<a href="javascript:reset();">취 소</a>
								</span>
								<span class="list_bt">
									<a href="BoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>">목록</a>
								</span>
							</span>
						</div>
						</form>
						<!-- /리스트 버튼-->
						<!-- /각페이지 내용 -->
					</div>
					<!-- /contents -->

				</div>
			</div>
		</div>
		<%//@include file="/common/Bottom.jsp" %>
		<jsp:include page="/inc/footer.jsp" flush="true"/>
	</div>

	<script language="javascript">
		//에디터 초기화
		frmWrite.txtCont.value = stripHTMLtag(frmWrite.txtCont.value) ;
	</script>
</body>

</html>

