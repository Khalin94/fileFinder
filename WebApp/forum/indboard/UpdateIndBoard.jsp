<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>	
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%
	/*세션값 */
	String strLoginID = (String)session.getAttribute("USER_ID");							//로그인 ID
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 			//포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			//회원상태
	String strOpenFlag = ""; 																						//공개여부
	String strForumNM = "";																						//포럼명
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//게시판 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));							//게시물 아이디
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));							//공지대상
	
	System.out.println(strForumID);
	System.out.println(strBbrdID);
	
	
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
	
	if(strDataID == null || strDataID.equals("") || strDataID.equals(" ")){
		
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("게시물 정보를 알수 없습니다.");
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
			
	}
	
	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objForumBoard = new nads.dsdm.app.board.SLBoardDelegate();
	nads.dsdm.app.forum.SLDBForumDelegate objDBForum = new nads.dsdm.app.forum.SLDBForumDelegate();
	
	Hashtable objHshBbrdInfo = null;		//게시판 
	Hashtable objHshDataInfo = null;		//게시물 
	Hashtable objHshFidInfo = null;
	String strFORUM_OPRTR_ID = "";
	
	ArrayList objAryFileList = null;				//파일정보 
	int intFileCnt = 0;									//기존에 등록된 파일 갯수 
	
	try {
		//1. 게시판 정보를 가져온다.
		objHshBbrdInfo = objForumBoard.selectBbrdInfo(strBbrdID);
		
		//2. 게시물 정보를 가져온다.
		objHshDataInfo = objForumBoard.selectBbrdDataInfo(strDataID);

		objHshFidInfo = objDBForum.selectIndForumInfo(strForumID);
		
		strFORUM_OPRTR_ID = StringUtil.getNVLNULL((String)objHshFidInfo.get("FORUM_OPRTR_ID"));

		System.out.println(strFORUM_OPRTR_ID);
			
		
		//3. 등록된 파일이 있다면 파일정보 리스트를 가져온다.
		if (((String)objHshDataInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objForumBoard.selectFileList(strDataID);
			intFileCnt = objAryFileList.size();
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

	if(strForumID.equals("0000000178") || strForumID.equals("0000000180")){
		if(strBbrdID.equals("0000000141") || strBbrdID.equals("0000000144")){
			if(strLoginID.equals(strFORUM_OPRTR_ID) || strLoginID.equals("ADMIN")){
				
			}else{
				out.println("<script language=javascript>");
				out.println("alert('게시판에 대한 권한이 없습니다.');");
				out.println("history.go(-1);");
				out.println("</script>");				
				return;
			}
		}
	}
	
	//게시판 정보 
	String strBbrdKind = (String)objHshBbrdInfo.get("BBRD_KIND");
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
	String strBbrdNm = (String)objHshBbrdInfo.get("BBRD_NM");
	if(strAncTgt.equals("1")){
		strBbrdNm = "운영자 공지사항";
	}
	String strBbrdDsc = (String)objHshBbrdInfo.get("DSC");
	if(strAncTgt.equals("1")){
		strBbrdDsc = "포럼 운영자 공지사항입니다.";
	}
	int intBbrdLength = strBbrdNm.length() * 3;
	int intBbrdLength2 = 0;
	if(intBbrdLength < 100) {
		intBbrdLength2 = 100 - intBbrdLength;
	}

	//게시물 정보 
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
	String strWriteTS = (String)objHshDataInfo.get("WRITE_TS");
	strWriteTS = strWriteTS.substring(0, 4) + "-" + strWriteTS.substring(4, 6) + "-" 
						+ strWriteTS.substring(6, 8);
	String strQryCnt = (String)objHshDataInfo.get("QRY_CNT");
	String strEditorExt = (String)objHshDataInfo.get("HTML_USE_FLAG");
	String strWriterID = (String)objHshDataInfo.get("WRITER_ID");
	String strWriteID = StringUtil.getNVLNULL((String)objHshDataInfo.get("WRITER_ID"));
	session.setAttribute("WRITER_ID",strWriteID);
	session.setAttribute("BBRD_ID",strBbrdID);
	session.setAttribute("DATA_ID",strDataID);
		
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script language="javascript">
	
	//에디터 초기화
	var myeditor = new htmleditor("myeditor");
	
	function setCont() {

		myeditor.width = 485;
		myeditor.height = 250;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmUpdate.cont.value;
		myeditor.init(varCont);
		
	}

	function isSave() {
		var frm = document.frmUpdate;
		
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
        
        var max_file = <%=intBbrdFileCnt%>;		//등록 가능한 파일 갯수 
		var del_file = 0;											//삭제 요청된 파일 갯수 
		var new_file = 0;										//새로 추가된 파일 갯수 
		var old_file = "<%=intFileCnt%>";				//기존 등록된 파일 갯수 
		var total_file = 0;										//계산 후 마지막 파일 갯수
		var fileext = ""											//파일 존재 유무 

		//삭제 요청된 파일의 갯수를 구한다.
		if (frm.delfile != null){
			//length가 1일경우 undefined로 따로 체크해준다.
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
		
		//새로 추가되는 파일 갯수를 구한다.
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") { new_file = new_file + 1; }
		}

		total_file = (old_file - del_file) + new_file;
		//alert("파일총갯수 : " + total_file);

		if(total_file == 0){ 
			fileext = "N"; 
		} else { 
			fileext = "Y"; 
		}
	
		if(total_file > max_file){
			alert("파일 첨부는 " + max_file + "개까지 입니다.");
			return false;
		}
		
		//에디터 선택 유형
		var ext = "";
		for (i = 0; i < frm.editorflag.length; i++) {
		    if (frm.editorflag[i].checked == true) {
		        ext = frm.editorflag[i].value;
		        break;
		    }
		}

		if(ext == "Y"){														//HTML에디터를 사용할 경우 

			var varCont = myeditor.get_content("NO");
			frm.cont.value = varCont;
		
		} else {																//텍스트를 사용할 경우 

			if (frm.txtCont.value == "" || frm.txtCont.value == null){
				alert("본문 내용을 입력해 주세요.");
				frm.txtCont.focus();
				return false;
			} 
			
			if (fnSpaceChk(frm.txtCont.value, "내용을 올바르게 입력하세요.") == false ) 	return false;
		}
		
		//첨부파일명 길이를 체크한다.
		for(var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if(eval(file_object) != ""){
				if(checkFileName(eval(file_object)) == false){
					return false;					
				}
			}
		}
		
		//첨부파일의 타입을 체크한다.		
		for (var i = 0; i < max_file; i++) {
			var file_object = "document.frmUpdate.upfile" + i + ".value";
			if (eval(file_object) != "") { 		
				 if(fnBoardLimitAttach(eval(file_object))== false){
		            return false;
		        }
			}
		}
		
		frm.editorext.value = ext;
		frm.fileext.value = fileext;
			
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="/forum/common/MenuTopForumPop.jsp" %>
<table width="800" height="450" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top"> 
    <td width="149" background="/image/forum/bg_forumLeft.gif"> 
      <%@ include file="/forum/common/MenuLeftForumPop.jsp" %>
    </td>
    <td align="center">
      <!-- 자유게시판 수정 테이블 시작 ----------------------------->
	  <table width="590" border="0" cellspacing="0" cellpadding="0">
	  <form name="frmUpdate" method="post" action="IndBoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>" onSubmit="return isSave();" encType="multipart/form-data">
	  <input type="hidden" name="fid" value="<%=strForumID%>">
	  <input type="hidden" name="uStt" value="<%=strUserStt%>">
	  <input type="hidden" name="anctgt" value="<%=strAncTgt%>">
	  <input type="hidden" name="cmd" value="UPDATE">
	  <textarea name="cont" wrap="hard" style="display:none;"><%=strCont%></textarea>
 	  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
	  <input type="hidden" name="dataid" value="<%=strDataID%>">
	  <input type="hidden" name="editorext" value="">
	  <input type="hidden" name="fileext" value="">
        <tr> 
          <td height="21" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          <table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="<%=intBbrdLength%>%" background="/image/forum/bg_forumpop_tit.gif"><span class="title"><%=strBbrdNm%></span></td>
                <td width="<%=intBbrdLength2%>%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="30" align="left" class="text_s"><%=strBbrdDsc%></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          	<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="105" height="2" class="td_forumpop"></td>
                <td width="485" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제목</td>
                <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" value="<%=strTitle%>"></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록자</td>
                <td height="25" class="td_lmagin"><%=strUserNm%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록일</td>
                <td height="25" class="td_lmagin"><%=strWriteTS%></td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 쓰기 선택</td>
                <td height="25" class="td_lmagin">
			  	<input type="radio" name="editorflag" value="N" onClick="selEditor('newlayer', 'newlayer2', frmUpdate.txtCont);" <% if(strEditorExt.equals("N")) out.println("checked"); %>>텍스트
              	<input type="radio" name="editorflag" value="Y" onClick="selEditor('newlayer2', 'newlayer', frmUpdate.txtCont);" <% if(strEditorExt.equals("Y")) out.println("checked"); %>>HTML 편집기</td>
              </tr>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 내용</td>
                <td height="260" valign="top" class="td_box">
                  <span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 250"><%=strCont%></textarea></span>
                  <span ID="newlayer2"><script>setCont();</script></span>
                </td>
              </tr>
              <% if (intBbrdFileCnt != 0) {	//파일첨부가 0개가 아니라면....%>
              <tr> 
                <td height="1" class="tbl-line"></td>
                <td height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 파일</td>
                <td height="25" class="td_lmagin">
                <% 
                for(int i = 0; i < intBbrdFileCnt; i++) {
                	
                	out.println("<input type='text' name='showfile" + i + "'  class='textfield' style='WIDTH: 300px'  value='' readonly>");
					out.println("<input type='file' name='upfile" + i + "' class='textfield' style='WIDTH: 0px' onChange='javascript:searchFile(this.form, this);'><br>");
					
				} //end for
				
				if (objAryFileList != null) {
                	if (objAryFileList.size() != 0){ 
				    	for (int i = 0; i < objAryFileList.size(); i++) {
				    		Hashtable objHshFile = (Hashtable)objAryFileList.get(i);
			
							String strFileName = (String)objHshFile.get("FILE_NAME");
							out.println("<input type='checkbox' name='delfile' value='"+ (String)objHshFile.get("FILE_ID") + "'>");
							out.println(strFileName + " 삭제<br>");
				    	}
					} 
				}
			    %>
                </td>
              </tr>
              <% } %>
              <tr height="1"> 
                <td height="2" class="tbl-line"></td>
                <td height="2" class="tbl-line"></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td height="35">
          	<input type="image" src="/image/button/bt_save.gif" width="43" height="20">
          	<img src="/image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
          	<a href="IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
         </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </form>
      </table>
      <!-- 자유게시판 등록 테이블 끝 ----------------------------->
    </td>
  </tr>
</table>

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

<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
