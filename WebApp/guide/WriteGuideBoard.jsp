<%@ page language="java"  contentType="text/html;charset=euc-kr" %>	
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//게시판 아이디
	String strEditorExt =  "N";																										//디폴트값 "N"
	/* 답변일 경우 추가되는 GET 파라미터 */
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
	
	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;			//게시판 
	String strGoToPage = URLEncoder.encode("/guide/GuideBoardList.jsp", "UTF-8");	//링크될 페이지 정보 
	session.setAttribute("BBRD_ID",strBbrdID);
	
	try{
		//1. 게시판 정보를 가져온다.
		objHshBbrdInfo = objBoard.selectBbrdInfo(strBbrdID);
	
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
	int intBbrdFileCnt = Integer.valueOf((String)objHshBbrdInfo.get("APD_FILE_CNT")).intValue();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript" src="/js/editor/htmleditor.js"></script>
<script type="text/javascript" src="/js/core.js"></script><!-- 단방향 -->
<script type="text/javascript" src="/js/sha256.js"></script><!-- 단방향 -->
<script language="javascript">
	
	//에디터 초기화
	var myeditor = new htmleditor("myeditor");
	
	function setCont() {

		myeditor.width = 200;
		myeditor.height = 200;
		//myeditor.fontsize = '10pt';
		//myeditor.lineheight = '14pt';
		var varCont = document.frmWrite.cont.value;
		myeditor.init(varCont);
		
	}

	function isSave() {
		
		frm = document.frmWrite;
		
		//제목 
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
        
        //등록자 
        if (frm.writernm.value == "" || frm.writernm.value == null){
			alert("등록자를 입력해 주세요.");
			frm.writernm.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.writernm.value, "등록자를 올바르게 입력하세요.") == false ) 	return false;
		
		//한글, 영문 구별하여 문자열 길이를 체크한다.
        if(checkStrLen(frm.writernm, 10, "등록자") == false){
            return false;
        }
        
		var ext = "N";
		/*for (i = 0; i < frm.editorflag.length; i++) {
		    if (frm.editorflag[i].checked == true) {
		        ext = frm.editorflag[i].value;
		        break;
		    }
		}

		if(ext == "Y"){													//HTML에디터를 사용할 경우 
			var varCont = myeditor.get_content("NO");
			frm.cont.value = varCont;
		} else {*/															//텍스트를 사용할 경우 
		
			if (frm.txtCont.value == "" || frm.txtCont.value == null){
				alert("본문 내용을 입력해 주세요.");
				frm.txtCont.focus();
				return false;
			} 
			
			if (fnSpaceChk(frm.txtCont.value, "내용을 올바르게 입력하세요.") == false ) 	return false;
		//}
		
		//비밀번호 
		 if (frm.tmp_datapwd.value == "" || frm.tmp_datapwd.value == null){
			alert("비밀번호를 입력해 주세요.");
			frm.tmp_datapwd.focus();
			return false;
		} 
		
		if (fnSpaceChk(frm.tmp_datapwd.value, "비밀번호를 올바르게 입력하세요.") == false ) 	return false;
		
		//한글, 영문 구별하여 문자열 길이를 체크한다.
        if(checkStrLen(frm.tmp_datapwd, 8, "비밀번호") == false){
            return false;
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
		//단방향적용을 위함 20180824
	    var temp = CryptoJS.SHA256(frm.tmp_datapwd.value).toString();
        frm.datapwd.value = temp.toUpperCase();
        frm.tmp_datapwd.value = "";
		
	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!-- 문의게시판 등록 테이블 시작 ----------------------------->
<table width="502" border="0" cellpadding="0" cellspacing="0">
<form name="frmWrite" method="post" action="/board/common/BoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>"  onSubmit="return isSave();" encType="multipart/form-data">
<input type="hidden" name="cmd" value="CREATE">
<textarea name="cont" wrap="hard"  style="display:none;"></textarea>
<input type="hidden" name="strGoToPage" value="<%=strGoToPage%>">
<input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
<input type="hidden" name="dataid" value="<%=strDataID%>">
<input type="hidden" name="ttopid" value="<%=strTTopID%>">
<input type="hidden" name="toplevel" value="<%=strTopLevel%>">
<input type="hidden" name="toporder" value="<%=strTopOrder%>">
<input type="hidden" name="editorext" value="">
<input type="hidden" name="datapwd" value="">
  <tr height="15" align="left" valign="top"> 
    <td><img src="../image/guide/blank.gif" width="24" height="2"></td>
    <td><table width="478" border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr class="td_board"> 
                <td width="100" height="2"></td>
                <td width="378" height="2"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 제목</td>
                <td height="25" class="td_lmagin"><input name="title" type="text" class="textfield" style="WIDTH: 300px" ></td>
              </tr>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 등록자</td>
                <td height="25" class="td_lmagin"><input name="writernm" type="text" class="textfield" style="WIDTH: 150px"></td>
              </tr> 
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
              <tr> 
                <td height="45" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 내용</td>
                <td height="45" valign="top" class="td_box">
				  <span ID="newlayer" style="position:absolute;"><textarea name="txtCont" wrap="hard" class="textfield" style="WIDTH: 100% ; height: 200"></textarea></span>
               	  <span ID="newlayer2"><script>setCont();</script></span>
				</td>
              </tr>
			  <% if (intBbrdFileCnt != 0) {	//파일첨부가 0개가 아니라면....%>
			  <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr> 
                <td height="25" class="td_gray1"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 파일</td>
                <td height="25" class="td_lmagin">
				<% for(int i = 0; i < intBbrdFileCnt; i++) {%>
              	  <input type="text" name="showfile<%=i%>"  class="textfield" style="WIDTH: 230px"  value="" readonly>
			  	  <input type="file" name="upfile<%=i%>" class="textfield" style="WIDTH: 0px" onChange="javascript:searchFile(this.form, this);"><br>
			  	<% } %>
			  	첨부파일 최대용량 : <%=intKBSize%>M
				</td>
              </tr>
			  <% } %>
              <tr class="tbl-line"> 
                <td height="1"></td>
                <td height="1"></td>
              </tr>
			  <tr> 
                <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 비밀번호</td>
                <td height="25" class="td_lmagin"><input name="tmp_datapwd" type="password" class="textfield" style="WIDTH: 150px"></td>
              </tr>
              <tr height="1" class="tbl-line"> 
                <td height="2"></td>
                <td height="2"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
  <tr align="left" valign="top"> 
    <td width="24" height="26">&nbsp;</td>
    <td height="40" align="left" valign="middle">
	  <input type="image" src="../image/button/bt_save.gif" width="43" height="20"> 
      <img src="../image/button/bt_cancel.gif" width="43" height="20" style="cursor:hand;" onClick="reset();">
      <a href="GuideBoardList.jsp?strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="../image/button/bt_list.gif" width="43" height="20" border="0"></a></td>
  </tr>
  <tr align="left" valign="top"> 
    <td height="35">&nbsp;</td>
    <td height="35">&nbsp;</td>
  </tr>
</form>
</table>
<!-- 문의게시판 등록 테이블 끝 ----------------------------->
<script language="javascript">
	
	//에디터 초기화 
	selEditor('newlayer', 'newlayer2');
	
</script>
</body>
</html>
