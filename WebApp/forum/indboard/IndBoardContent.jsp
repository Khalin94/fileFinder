<%@ page language="java"  contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>	
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
	/*세션값 */ 
	String strLoginID = (String)session.getAttribute("USER_ID");								//로그인 ID
	String strLoginNm = (String)session.getAttribute("USER_NM");							//로그인 Name																	
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("fid"))); 			//포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("uStt"))); 			//회원상태
	String strOpenFlag = ""; 																						//공개여부
	String strForumNM = ""; 																						//포럼명
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("strCurrentPage"))); //현재 페이지
	String strBbrdID =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("dataid")));			 //게시물 아이디
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("anctgt")));			 //공지대상
	
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
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshBbrdInfo = null;			//게시판 
	Hashtable objHshMainInfo = null;			//주글
	Hashtable objHshBeforeInfo = null;			//이전글
	Hashtable objHshNextInfo = null;			//다음글
	ArrayList objAryTtopList = null;				//관련글
	ArrayList objAryFileList = null;					//파일정보 
	
	try{
		//1. 게시판 정보를 가져온다.
		objHshBbrdInfo = objIndBoard.selectBbrdInfo(strBbrdID);
		
		//2. 주글, 이전글, 다음글 정보를 가져온다.
		Hashtable objHshDataInfo = objIndBoard.selectBbrdBNInfo(strBbrdID, strDataID, strAncTgt);
		objHshMainInfo = (Hashtable)objHshDataInfo.get("MAIN_INFO");
		objHshBeforeInfo = (Hashtable)objHshDataInfo.get("BEFORE_INFO");
		objHshNextInfo = (Hashtable)objHshDataInfo.get("NEXT_INFO");
		
		//3. 해당 게시물의 관련글 리스트를 가져온다.
		objAryTtopList = objIndBoard.selectTtopDataList((String)objHshMainInfo.get("TTOP_BBRD_ID"));
		
		//4. 등록된 파일이 있다면 파일정보 리스트를 가져온다.
		if (((String)objHshMainInfo.get("APD_FILE_EXT")).equals("Y")) {
			objAryFileList = objIndBoard.selectFileList(strDataID);
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
	String strBbrdAnsExt = (String)objHshBbrdInfo.get("ANS_EXT");
	String strBbrdOneExt = (String)objHshBbrdInfo.get("ONE_ANS_EXT");
	
	//게시물 정보 
	String strTitle = BoardComm.replaceTag2Text((String)objHshMainInfo.get("TITLE"));
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
	String strEditorExt = (String)objHshMainInfo.get("HTML_USE_FLAG");
	if(strEditorExt.equals("N")) {
		strCont = BoardComm.replaceTag2Text(strCont); 
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
	session.setAttribute("DELID",strWriterID);
	//관리자에 의한 삭제글 처리 
	String strDelFlag = (String)objHshMainInfo.get("DEL_FLAG");
	if(strDelFlag.equals("A") || strDelFlag.equals("Y")){
		strTitle = "해당글이 삭제 되었습니다";
		//내용에 삭제 사유를 나타낸다.
		strCont = "삭제사유 : " + (String)objHshMainInfo.get("DEL_RSN");
	}
	//한줄답변을 위해서 필요한 값
	String strOneExt = (String)objHshMainInfo.get("ONE_ANS_EXT");
	//답글을 위해서 필요한 값.
	String strTtopID = (String)objHshMainInfo.get("TTOP_BBRD_ID");
	String strLevel = (String)objHshMainInfo.get("DATA_LEVEL");
	String strOrder = (String)objHshMainInfo.get("DATA_ORDER");
	String strFileExt = (String)objHshMainInfo.get("APD_FILE_EXT");
	
	session.setAttribute("DELID",strWriterID);
	session.setAttribute("DATA_ID",strDataID);
	session.setAttribute("BBRD_ID",strBbrdID);
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/forum.js"></script>
<script language="javascript">

	function goToUpdate(frm){

		//delete 때문에 encType="multipart/form-data"를 사용하므로 get 방식으로 데이타를 넘김
		frm.action = "UpdateIndBoard.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>";
	
	}
	
	function goToDelete(frm){

		var msg = "해당 한줄답글과 첨부파일이 모두 삭제됩니다.\n게시물을 삭제 하시겠습니까?";

	    if(confirm(msg)){
			frm.cmd.value = "DELETE";
			frm.oneext.value = "<%=strOneExt%>";
			frm.fileext.value = "<%=strFileExt%>";
			frm.action = "IndBoardProc.jsp?bbrdid=<%=strBbrdID%>&bbrdkind=<%=strBbrdKind%>";
	    }
	    else{
	        return false;
	    }
	    
	}
	
	function goToAnswer(frm){

		//상위 게시물에 대한 정보를 보낸다.
		//delete 때문에 encType="multipart/form-data"를 사용하므로 get 방식으로 데이타를 넘김 
		frm.action = "WriteIndBoard.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&ttopid=<%=strTtopID%>&toplevel=<%=strLevel%>&toporder=<%=strOrder%>";
	
	}
	
	function goToOneSave(){
		var frm = document.frmOneAns;

		if (frm.oneword.value == "" || frm.oneword.value == null){
			alert("한줄답글 내용을 입력해 주세요.");
			frm.oneword.focus();
			return false;
		}

		if (fnSpaceChk(frm.oneword.value, "한줄답글을 올바르게 입력하세요.") == false ) 	return false;
		
		//한글, 영문 구별하여 문자열 길이를 체크한다.
        if(checkStrLen(frm.oneword, 100, "한줄 답글") == false){
            return false;
        }
        
        //frm.submit();
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
          <td height="30" align="left" class="text_s"><%=strBbrdDsc%></td>
        </tr>
        <tr> 
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">
          	<!-- 자유게시판 상세정보 테이블 시작 --------------------->
          	<table width="100%" border="0" cellspacing="0" cellpadding="0">
          	<form name="frmContent" method="post" action="" encType="multipart/form-data">
          	<input type="hidden" name="cmd" value="">
          	<input type="hidden" name="fid" value="<%=strForumID%>">
          	<input type="hidden" name="uStt" value="<%=strUserStt%>">
          	<input type="hidden" name="anctgt" value="<%=strAncTgt%>">
            <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
			<input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
			<input type="hidden" name="dataid" value="<%=strDataID%>">
			<input type="hidden" name="oneext" value="">
			<input type="hidden" name="fileext" value="">
              <tr> 
                <td width="95" height="2" class="td_forumpop"></td>
                <td width="495" height="2" class="td_forumpop"></td>
              </tr>
              <tr> 
                <td width="95" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 제목</td>
                <td width="495" height="25" class="td_lmagin"><%=strTitle%></td>
              </tr>
              <tr> 
                <td width="95" height="1" class="tbl-line"></td>
                <td width="495" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="95" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록자</td>
                <td width="495" height="25" class="td_lmagin"><%=strUserNm%> (조회 : <%=strQryCnt%>)</td>
              </tr>
              <tr> 
                <td width="95" height="1" class="tbl-line"></td>
                <td width="495" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="95" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록일</td>
                <td width="495" height="25" class="td_lmagin"><%=strWriteTs%></td>
              </tr>
              <tr> 
                <td width="95" height="1" class="tbl-line"></td>
                <td width="495" height="1" class="tbl-line"></td>
              </tr>
              <tr> 
                <td width="95" height="45" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 내용</td>
                <td width="495" height="45" valign="top" class="td_box"><%=strCont%></td>
              </tr>
              <tr> 
                <td width="95" height="1" class="tbl-line"></td>
                <td width="495" height="1" class="tbl-line"></td>
              </tr>
              <% if (strDelFlag.equals("N") && intBbrdFileCnt != 0) {	//게시판 정보에 파일첨부가 0개가 아니라면....%>
              <tr> 
                <td width="95" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 파일</td>
                <td width="495" height="25" class="td_lmagin">
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
               	  <img src="/image/common/icon_<%=strFileIcon%>.gif" width="13" height="15" align="absmiddle"> 
                  <a href="/board/common/FileDownload.jsp?dataid=<%=strDataID%>&fileid=<%=(String)objHshFile.get("FILE_ID")%>"><%=(String)objHshFile.get("FILE_NAME")%></a> 
                  (<%=intSize%>KB) Download : <%=(String)objHshFile.get("DOWN_CNT")%><br>
                  <%
				    	}	//end for
				    } else {
				    	out.println("&nbsp;<br>");
				    }
				  }	//end if (null check)
				  %>
				</td>
              </tr>
              <tr> 
                <td width="95" height="1" class="tbl-line"></td>
                <td width="495" height="1" class="tbl-line"></td>
              </tr>
              <% } %>
              <!-- 이전글/다음글 시작 --------------------------------->
              <% if(objHshBeforeInfo.get("DATA_ID") != null){ %>
              <tr> 
                <td width="95" height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
                  이전글 :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td width="495" height="25" class="td_lmagin">
                	<a href="IndList2Content.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshBeforeInfo.get("DATA_ID")%>">
                	<%
			  		String strBTitle = BoardComm.replaceTag2Text((String)objHshBeforeInfo.get("TITLE"));
					String strBDelFlag = (String)objHshBeforeInfo.get("DEL_FLAG");
					if(strBDelFlag.equals("A") || strBDelFlag.equals("Y")){	//관리자 또는 운영자에 의한 삭제 
						strBTitle = "해당글이 삭제 되었습니다";
					}
					out.println(strBTitle);
					%>
                	</a>
                </td>
              </tr>
              <%
              	}
              
              	if(objHshNextInfo.get("DATA_ID") != null){
              %>
              <tr> 
                <td width="95" height="25" class="td_lmagin"><font color="792597"><img src="/image/forum/icon_boardDot.gif" width="3" height="5" align="absmiddle"></font> 
                  다음글 :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td width="495" height="25" class="td_lmagin">
                	<a href="IndList2Content.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=objHshNextInfo.get("DATA_ID")%>">
                	<%
               		String strNTitle = BoardComm.replaceTag2Text((String)objHshNextInfo.get("TITLE"));
					String strNDelFlag = (String)objHshNextInfo.get("DEL_FLAG");
					if(strNDelFlag.equals("A") || strNDelFlag.equals("Y")){	//관리자 또는 운영자에 의한 삭제 
						strNTitle = "해당글이 삭제 되었습니다";
					}
					out.println(strNTitle);
                    %>
                	</a>
                </td>
              </tr>
              <% } %>
              <!-- 이전글/다음글 끝 --------------------------------->
              <tr height="1"> 
                <td width="95" height="2" class="tbl-line"></td>
                <td width="495" height="2" class="tbl-line"></td>
              </tr>
	          <tr> 
	            <td height="15" valign="top" colspan="2">
	              <!-- 관련글 리스트 시작 -------------------------------->
	              <% if (strBbrdAnsExt.equals("Y")) { 	//게시판 답글 유무가 "Y"일 경우만 관련글을 보여준다.%>
	              <table width="100%" border="0" cellspacing="0" cellpadding="0">
	              <tr> 
		            <td height="20" valign="top">&nbsp;</td>
		          </tr>
	              <tr> 
	                <td height="2" colspan="5" class="td_forum"></td>
	              </tr>
	              <tr class="td_top"> 
	                <td width="410" height="22" align="center">제목</td>
	                <td width="44" height="22" align="center">파일</td>
	                <td width="80" height="22" align="center">등록자</td>
	                <td width="84" height="22" align="center">등록일자</td>
	                <td width="62" align="center">조회</td>
	              </tr>
	              <tr> 
	                <td height="1" colspan="5" class="td_forum"></td>
	              </tr>
	              <%
	              if (objAryTtopList != null) {
					for (int i = 0; i < objAryTtopList.size(); i++) {
						Hashtable objHshTtopList = (Hashtable)objAryTtopList.get(i);
                  		
                  		String strTtopDataID = (String)objHshTtopList.get("DATA_ID");
                  		String strTtopTitle = BoardComm.replaceTag2Text((String)objHshTtopList.get("TITLE"));
                  		String strTtopDelFlag = (String)objHshTtopList.get("DEL_FLAG");
						if(strTtopDelFlag.equals("A") || strTtopDelFlag.equals("Y")){
							strTtopTitle = "해당글이 삭제 되었습니다";
						}
                  		if (strDataID.equals(strTtopDataID)){
                  			strTtopTitle = "<b>" + strTtopTitle + "</b>";
                  		}
                  		String strTtopFileExt = (String)objHshTtopList.get("APD_FILE_EXT");
						String strTtopFileExtImg = "&nbsp;";
						if(strTtopFileExt.equals("Y")){
							strTtopFileExtImg = "<img src='/image/common/icon_file.gif' width='13' height='15'>";
						}
                  		String strTtopWriteTs = (String)objHshTtopList.get("WRITE_TS");
                  		strTtopWriteTs = strTtopWriteTs.substring(0, 4) + "-" + strTtopWriteTs.substring(4, 6) + "-" 
													+ strTtopWriteTs.substring(6, 8);
						int intTtopLevel = Integer.valueOf((String)objHshTtopList.get("DATA_LEVEL")).intValue();
                  %>
	              <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
	                <td height="22" class="td_lmagin">
	                	<%
							if(intTtopLevel > 0 ){
								String strTtopWid = "";
								
								for(int j=0; j < intTtopLevel ; j++){
									strTtopWid = strTtopWid + "&nbsp;&nbsp;&nbsp;";
								}
								out.print(strTtopWid + "<img src='/image/board/icon_reply.gif' border='0'>");		
							}
	                    %>
	                	<a href="IndList2Content.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strTtopDataID%>"><%=strTtopTitle%></a>
	                </td>
	                <td height="22" align="center"><%=strTtopFileExtImg%></td>
	                <td height="22" align="center"><%=objHshTtopList.get("USER_NM")%></td>
	                <td height="22" align="center"><%=strTtopWriteTs%></td>
	                <td align="center"><%=objHshTtopList.get("QRY_CNT")%></td>
	              </tr>
	              <tr class="tbl-line"> 
	                <td height="1"></td>
	                <td height="1"></td>
	                <td height="1" align="left" class="td_lmagin"></td>
	                <td height="1" align="left" class="td_lmagin"></td>
	                <td align="left" class="td_lmagin"></td>
	              </tr>
	              <% 
	              	} 	//end for
	              }	//end if
	              %>
	              <tr class="tbl-line"> 
	                <td height="1"></td>
	                <td height="1"></td>
	                <td height="1"></td>
	                <td height="1"></td>
	                <td></td>
	              </tr>
	            </table>
	            <% } //end if (관련글 "Y")%>
	            <!-- 관련글 리스트 끝 -------------------------------->
	            </td>
	          </tr>
              <tr>
              	<td  height="40" colspan="2">
              		<% 
              			if(strDelFlag.equals("N") && !strBbrdKind.equals(allNoticeBoard)){
						 	if (strLoginID.equals(strWriterID)) {											//등록자인 경우
					%>
	              	<input type="image" src="/image/button/bt_modify.gif" width="43" height="20" onClick="goToUpdate(this.form);">
		          	<input type="image" src="/image/button/bt_delete.gif" width="43" height="20" onClick="goToDelete(this.form);">
		          	<% 
		          			} else {
		          				if (strUserStt.equals("OO") || strUserStt.equals("CO")) {	 //등록자는 아니고 운영자의 경우 
		          	%>
		          	<input type="image" src="/image/button/bt_delete.gif" width="43" height="20" onClick="javascript:openWin('IndBoardDelPop.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&cmd=OPR_DELETE&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>','380','280');">
		          	<%
		          				}
		          			} //등록자인 체크 End
		          			
		          			//게시판 답글 유무가 "Y"이고 회원일 경우만 [답글]버튼을 보여준다.
		          			//공지사항과 운영자공지사항의 경우는 답글 버튼을 보여주지 않는다.
		          			if (strBbrdAnsExt.equals("Y")) { 
		          				if(strBbrdKind.equals(noticeBoard)) {
		          					if (strUserStt.equals("OO") || strUserStt.equals("CO")) {	 //등록자는 아니고 운영자의 경우 
		          		%>
		          		<input type="image" src="/image/button/bt_reply.gif" width="43" height="20" onClick="goToAnswer(this.form);">
		          		<%
		          					}
		          				} else {
			          				if(strUserStt.equals("N") || strUserStt.equals("NJ")) {
			          					out.println("");
			          				}
			          				else {
		          	%>
					<input type="image" src="/image/button/bt_reply.gif" width="43" height="20" onClick="goToAnswer(this.form);">
		          	<%
		          					}
		          				}	//noticeBoard 체크 End
		          			} //strBbrdAnsExt.equals("Y") End
		          		} //strDelFlag.equals("N") End 
		          	%>
		          	<a href="IndBoardList.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>"><img src="/image/button/bt_list.gif" width="43" height="20" border="0"></a>
              	</td>
              </tr>
            </form>
            </table>
            <!-- 자유게시판 상세정보 테이블 끝 --------------------->
           </td>
        </tr>
        <tr>
          <td height="10" align="left"></td>
        </tr>
        <tr>
          <td height="15" align="left">
          <!-- 한줄답글 테이블 시작 --------------------------------->
          <% if(strBbrdOneExt.equals("Y") && strDelFlag.equals("N")){ %>
          <table width="590" border="0" cellspacing="0" cellpadding="0">
          <form name="frmOneAns" method="post" action="IndOneAnsProc.jsp?cmd=ONE_CREATE" onSubmit="return goToOneSave();">
          <input type="hidden" name="fid" value="<%=strForumID%>">
          <input type="hidden" name="uStt" value="<%=strUserStt%>">
          <input type="hidden" name="anctgt" value="<%=strAncTgt%>">
		  <input type="hidden" name="strCurrentPage" value="<%=strCurrentPage%>">
		  <input type="hidden" name="bbrdid" value="<%=strBbrdID%>">
		  <input type="hidden" name="dataid" value="<%=strDataID%>">
		  <input type="hidden" name="nowext" value="<%=strOneExt%>">
          <%	
			if(strOneExt.equals("Y")){
				ArrayList objAryOneAnsList = new ArrayList();
				int c=0;
				String strBgColor = "";
				
				try {
					//서버에서 게시물에 해당하는 답글리스트를 가져온다.
					objAryOneAnsList = objIndBoard.selectOneAnsList(strDataID);
					
				} catch (AppException objAppEx) {
		
					// 에러 발생 메세지 페이지로 이동한다.
					out.println(objAppEx.getStrErrCode());
					out.println("메세지 페이지로 이동하여야 한다.");
					return;
					
				}
				
				if(objAryOneAnsList != null){

					int intOneCnt = objAryOneAnsList.size();						//전체 한줄답글 갯수 
					
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
							strOneWord = "삭제사유 : " + (String)objHshOneAnsList.get("DEL_RSN");
						}
						
						if(c%2==0){	strBgColor = "bgcolor='#F7F3F8'"; }
						else{ strBgColor = ""; }
						c++;
			  %>
            <tr> 
              <td align="center" <%=strBgColor%>><%=strOneUserNm%><br>
                (<%=strOneWriteTs%>) </td>
              <td colspan="2" valign="top" <%=strBgColor%> class="td_box"><%=strOneWord%>
				<%
				if(strOneDelFlag.equals("N")){ 
					if (strLoginID.equals(strOneWriterID)){ %>
				<a href="IndOneAnsProc.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&strCurrentPage=<%=strCurrentPage%>&cmd=ONE_DELETE&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&oneid=<%=strOneID%>&onecnt=<%=intOneCnt%>" onClick="return goToOneDelete();"><img src="/image/button/bt_del_board.gif" width="25" height="12" border="0"></a>
				<% 
					} else {
						if (strUserStt.equals("OO") || strUserStt.equals("CO")) {	 //등록자는 아니고 운영자의 경우
				%>
				<img src="/image/button/bt_del_board.gif" width="25" height="12" style="cursor:hand;" onClick="javascript:openWin('IndBoardDelPop.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>&anctgt=<%=strAncTgt%>&cmd=ONE_OPR_DELETE&strCurrentPage=<%=strCurrentPage%>&bbrdid=<%=strBbrdID%>&dataid=<%=strDataID%>&oneid=<%=strOneID%>','380','280');">	
				<%
						}
					}
				}	//end DelFlag "N"
				%>
              </td>
            </tr>
            <%
						}	//end for
					}
				}	//end if strOneExt
	  		%>
            <tr valign="top" class="tbl-line">
              <td height="1"></td>
              <td height="1"></td>
              <td height="1"></td>
            </tr>
            <tr> 
              <td width="15%" rowspan="2" bgcolor="E9E9E9" class="td_gray2"><font color="E9E9E9">...</font><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                <span class="soti_forumpop">한줄 답글</span></td>
              <td width="75%" height="22" valign="bottom" bgcolor="E9E9E9" class="td_lmagin">작성자 : <%=strLoginNm%>&nbsp;&nbsp;&nbsp;[현재 <span id="textlimit">0</span>/최대 100byte(한글 50자, 영문 100자)]</td>
              <td width="10%" valign="middle" bgcolor="E9E9E9">&nbsp;</td>     
            </tr>
            <tr>
              <td width="73%" valign="top" bgcolor="E9E9E9" class="td_box"><input name="oneword" type="text" class="textfield" style="WIDTH: 400px" onKeyUp="javascript:textCounter(frmOneAns.oneword, 100);"></td>
              <td width="10%" valign="middle" bgcolor="E9E9E9">
              	<input type="image" src="/image/button/bt_confirm_icon.gif" width="47" height="19" border="0">
              </td>
            </tr>
            </form>
          </table>
          <% } %>
          <!-- 한줄답글 테이블 끝 --------------------------------->
          </td>
        </tr>
        <tr> 
          <td height="15">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
<%@ include file="/forum/common/BottomForumPop.jsp" %>
</body>
</html>
