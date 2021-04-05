<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/board/common/GetBoardProperty.jsp" %>
<%
try { 
	/*세션값 */ 
	String strLoginID = (String)session.getAttribute("USER_ID");										//로그인 ID
	String strLoginNm = (String)session.getAttribute("USER_NM");									//로그인 Name
	
	/*GET 파라미터*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //게시판 아이디
	String strBbrdKind = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdkind")));		 //게시판 종류
	
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
	
 	int intSizeLimit =Integer.valueOf(fileMaxSize).intValue(); 														// 첨부파일 최대용량 (임의 5메가)
 	
 	//업로드 디렉토리가 없다면 생성한다. [규칙 : webroot + board + bbrd_kind + strBbrdID + 년도]
	java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat ("yyyy") ;
	String strYear  = yearFormat.format(new Date(System.currentTimeMillis()));
	String strSavePath = uploadPath + "board/" + strBbrdKind + "/" + strBbrdID + "/" + strYear ;	// 저장할 디렉토리 (절대경로)
	
	String strFullPath = webPath + strSavePath;
 	File objDir = new File(strFullPath);
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
 	
 	/*MultipartRequest 생성*/
 	MultipartRequest multi = new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	
	/*개별포럼 페이지 파라미터 (포럼ID, 회원상태, 공개여부, 포럼명)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fid"))); //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("uStt"))); //회원상태
	String strOpenFlag = ""; //공개여부
	String strForumNM = ""; //포럼명
	
	/*GET 파라미터*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("strCurrentPage")));  //현재 페이지
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cmd")));					 //구분
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("anctgt")));				 //공지대상
	String strTitle = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("title")));				 //게시물 제목
	String strCont = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cont")));					 //게시물 내용(Editor용)
	String strTxtCont = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("txtCont")));			 //게시물 내용(Text용)
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("dataid")));				 //게시물 아이디(UPDATE, DELETE)
	String strTtopID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("ttopid")));				 //게시물 아이디(ANSWER)
	String strOneExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("oneext")));				 //한줄답변 유무(DELETE)
	String strFileExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fileext")));			 //첨부파일 유무(DELETE) 
	String strEditorExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("editorext")));		 //HTML 에디터 사용 유무(DELETE) New 

	/*초기값 설정 */
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	BoardComm objBoardComm = new BoardComm();
	Hashtable objHshBbrdData = new Hashtable();
	int intResult = 0;
	boolean blnResult = false;

		if(strCmd.equals("CREATE")){
			
			//out.println("생성<br>");
			
			//1. 첨부파일을 업로드 한다.===============================
			ArrayList objAryFileInfo = new ArrayList();										//생성될 파일정보 객체를 담을 ArrayList
			strFileExt = "N";																					//생성시 파일유무 초기값은 "N" 로 설정.
			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('잘못된접근입니다.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("BBRD_ID");
					return;
			}
			boolean flagResult = true;
 			for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){
				boolean flag = false;
				String strFormName=(String)formNames.nextElement(); 				//파일 업로드
				String strFileName = multi.getFilesystemName(strFormName); 	//파일의 이름 얻기
				String strOrgName = multi.getOriginalFileName(strFormName);	//파일 원래 이름 얻기
				String strOrgNameTemp = multi.getOriginalFileName(strFormName);
				
				
				if(strOrgNameTemp == null){
					strOrgNameTemp = "success.hwp";
				}
				String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
				String strExtension = strExtensions[1];
				strExtension = strExtension.toLowerCase();
				String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt"};
				
				for(int i = 0; i < strEx.length ; i++){
					if(strEx[i].equals(strExtension)){
						flag = true;
					}
				}
				
				File objFile = multi.getFile(strFormName);
				
				if(strFileName != null) {    // 파일이 업로드 되었을때

					//out.print("Form Name : " + strFormName + "<BR>");
					//out.print("File Name  : " + strFileName + "<BR>");
					
					//데이타 정보를 생성한다. FILE_ID, DATA_ID 는 Beans 에서 처리.
					Hashtable objHshFileInfo = new Hashtable();
					objHshFileInfo.put("FILE_NAME" , strOrgName);
					objHshFileInfo.put("REAL_FILE" , strFileName);
					objHshFileInfo.put("FILE_SIZE" , String.valueOf(objFile.length()));
					objHshFileInfo.put("DOWN_CNT" ,  new Integer(0));
					
					objAryFileInfo.add(objHshFileInfo);
					
					//파일 존재유무를 수정한다.
					strFileExt = "Y";
				}
					
				if(flag == false){
					flagResult = false;
					break;
				}
				
			}	//end for
					
			if(flagResult == true){
				//1-1. 0~5개의 첨부파일 정보를 Hashtable에 추가한다.
				objHshBbrdData.put("FILE_OBJ", objAryFileInfo);
				
				//파일 존재 유무가 "N"라면 FILE_PATH도 ""로 수정한다.
				if(strFileExt.equals("N")){
					strSavePath = "";
				}
				
				
				//2. 게시물정보를 등록한다.===============================
				
				if(strTtopID == null || strTtopID.equals("")){
				
					//objHshBbrdData.put("TTOP_BBRD_ID", "");							//원글일 경우 Bean에서 처리. DATA_ID와 같음
					//objHshBbrdData.put("TOP_BBRD_ID", "");								//원글일 경우 Bean에서 처리. DATA_ID와 같음
					objHshBbrdData.put("DATA_LEVEL", new Integer(0));				//원글일 경우 0
					objHshBbrdData.put("DATA_ORDER", new Integer(0));			//원글일 경우 0
				
				} else {
				
					String strTopLevel = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("toplevel")));
					String strTopOrder = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("toporder")));
	
					try {
						//기존의 답글의 DATA_STEP +1 UPDATE
						intResult = objIndBoard.updateDataOrder(strTtopID, strTopOrder);
						
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
					
					int intTopLevel = Integer.valueOf(strTopLevel).intValue() + 1;
					int intTopOrder = Integer.valueOf(strTopOrder).intValue() + 1;
					
					objHshBbrdData.put("TTOP_BBRD_ID", strTtopID);
					objHshBbrdData.put("TOP_BBRD_ID", strDataID);	
					objHshBbrdData.put("DATA_LEVEL", new Integer(intTopLevel));				//답글일 경우 +1
					objHshBbrdData.put("DATA_ORDER", new Integer(intTopOrder));			//답글일 경우 +1
				
				}
				
				objHshBbrdData.put("BBRD_ID", strBbrdID);
				objHshBbrdData.put("TITLE", strTitle);
				if(strEditorExt.equals("Y")){
					objHshBbrdData.put("CONT", strCont);
				} else {
					objHshBbrdData.put("CONT", strTxtCont); 
				}
				objHshBbrdData.put("WRITER_ID", strLoginID);
				objHshBbrdData.put("FILE_PATH", strSavePath);
				objHshBbrdData.put("APD_FILE_EXT", strFileExt);
				objHshBbrdData.put("ONE_ANS_EXT", "N");						//디폴트값 "N"
				objHshBbrdData.put("HTML_USE_FLAG", strEditorExt);
				objHshBbrdData.put("QRY_CNT", "0");
				objHshBbrdData.put("USER_IP", request.getHeader("Proxy-Client-IP"));
				objHshBbrdData.put("DEL_FLAG", "N");
				objHshBbrdData.put("ANC_TGT", strAncTgt);					//추가 (2004-03-23) :기본값 0 (회원)
				objHshBbrdData.put("REMARK", "");
				objHshBbrdData.put("WRITER_NM", strLoginNm);			//추가 (2004-06-26)
				objHshBbrdData.put("WRITER_EMAIL", "");						//추가 (2004-06-26)
				objHshBbrdData.put("DATA_PWD", "");								//추가 (2004-06-26)
				
				try {
				
					intResult = objIndBoard.insertBbrdData(objHshBbrdData);
				
				} catch (AppException objAppEx) {
					
					//데이타 등록 에러일 경우 등록되었던 첨부파일들을 물리적 삭제한다.
					if (objAryFileInfo != null){
					
						blnResult = objBoardComm.deletePhysicalFile(objAryFileInfo, strFullPath);
						
					}
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode(objAppEx.getStrErrCode());
					objMsgBean.setStrMsg(objAppEx.getMessage());
						
					// 에러 발생 메세지 페이지로 이동한다.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
			
				}
	
				if(intResult != 0 ){
					//등록이 성공하면 상세정보 페이지로 이동한다.
					response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID);
				} else {
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0010");
			
					// 에러 발생 메세지 페이지로 이동한다.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
				
				}
			}else{
				out.println("<script language=javascript>");
                out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");
                out.println("history.go(-2);");
                out.println("</script>");
				return;
			}
			
		}
		else if(strCmd.equals("UPDATE")){
		
			//out.print("수정<br>");
			
			String strWriterID = (String)session.getAttribute("WRITER_ID")==null?"":(String)session.getAttribute("WRITER_ID");
			String strUserID = (String)session.getAttribute("USER_ID");
			
			if(strWriterID != null){
				if(!strWriterID.equals(strUserID)){
					session.removeAttribute("WRITER_ID");
					out.println("<script language=javascript>");
					out.println("alert('게시판 내용에 대한 수정권한이 없습니다.');");
					out.println("history.go(-2);");
					out.println("</script>");				
					return;
				}else{
					session.removeAttribute("WRITER_ID");
				}
			}else{
					out.println("<script language=javascript>");
					out.println("alert('게시판 내용에 대한 수정권한이 없습니다.');");
					out.println("history.go(-2);");
					out.println("</script>");
			}

			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('잘못된접근입니다.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("BBRD_ID");
					return;
			}else{
					session.removeAttribute("BBRD_ID");
			}

			String strSesDataId = (String)session.getAttribute("DATA_ID")==null?"":(String)session.getAttribute("DATA_ID");
			
			if(!strSesDataId.equals(strDataID)){
					out.println("<script language=javascript>");
					out.println("alert('잘못된접근입니다.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("DATA_ID");
					return;
			}else{
					session.removeAttribute("DATA_ID");
			}
			
			ArrayList objAryNewFile = new ArrayList();			//추가 요청된 파일
			ArrayList objAryDelFile = null;								//삭제 요청된 파일 
			boolean flagResult = true;
			//1-1. 새로 추가되는 물리적 파일을 업로드 한다.
			for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){
				boolean flag = false;
				String strFormName=(String)formNames.nextElement();
				String strFileName = multi.getFilesystemName(strFormName); 	// 파일의 이름 얻기
				String strOrgName = multi.getOriginalFileName(strFormName);	// 파일 원래 이름 얻기
				String strOrgNameTemp = multi.getOriginalFileName(strFormName);	//파일 원래 이름 얻기
				
				if(strOrgNameTemp == null){
					strOrgNameTemp = "success.hwp";
				}
				String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
				String strExtension = strExtensions[1];
				strExtension = strExtension.toLowerCase();
				String[] strEx = {"hwp", "pdf", "zip", "alz", "doc", "ppt", "xls", "txt"};
				
				for(int i = 0; i < strEx.length ; i++){
					if(strEx[i].equals(strExtension)){
						flag = true;
					}
				}
				
				File objFile = multi.getFile(strFormName);
			
				if(strFileName != null) {  // 파일이 업로드 되었을때
				
					//out.println("Form Name : " + strFormName + "<BR>");
					//out.println("File Name  : " + strFileName + "<BR>");

					Hashtable objHshNewFile = new Hashtable();
					objHshNewFile.put("FILE_NAME" , strOrgName);
					objHshNewFile.put("REAL_FILE" , strFileName);
					objHshNewFile.put("FILE_SIZE" , String.valueOf(objFile.length()));
					objHshNewFile.put("DOWN_CNT" ,  new Integer(0));
					
					objAryNewFile.add(objHshNewFile);
				}

				if(flag == false){
					flagResult = false;
					break;
				}
				
			}	//end for
			
			//1-2. 새로 추가되는 파일정보를 Hashtable에 추가한다.
			if(flagResult == true){
				if(objAryNewFile.size() != 0){
					objHshBbrdData.put("NEW_FILE", objAryNewFile);
				}
				
				//2. 삭제요청된 파일의 정보를 Hashtable에 추가한다.
				String[] strDelFiles = multi.getParameterValues("delfile");
				if (strDelFiles != null){
					objHshBbrdData.put("DEL_FILE", strDelFiles);
				}
				
				//3. 수정될 게시물 기본정보를 Hashtable에 추가한다.
				objHshBbrdData.put("TITLE", strTitle);
				if(strEditorExt.equals("Y")){
					objHshBbrdData.put("CONT", strCont);
				} else {
					objHshBbrdData.put("CONT", strTxtCont); 
				}
				objHshBbrdData.put("USER_IP", request.getHeader("Proxy-Client-IP"));
				objHshBbrdData.put("REMARK", "");
				//파일 존재 유무가 "N"라면 디비정보 FILE_PATH도 ""로 수정한다.
				if (strFileExt.equals("N")){
					objHshBbrdData.put("FILE_PATH", "");							//추가 (2004-03-04)
				} else if (strFileExt.equals("Y")){
					objHshBbrdData.put("FILE_PATH", strSavePath);			//추가 (2004-03-04)
				}
				objHshBbrdData.put("APD_FILE_EXT", strFileExt);
				objHshBbrdData.put("HTML_USE_FLAG", strEditorExt);		//추가 (2004-3-26)
				objHshBbrdData.put("ANC_TGT", strAncTgt);					//추가 (2004-03-23) :기본값 0 (회원)
				objHshBbrdData.put("WRITER_NM", strLoginNm);
				objHshBbrdData.put("WRITER_EMAIL", "");						//추가 (2004-06-26)
				objHshBbrdData.put("DATA_PWD", "");								//추가 (2004-06-26)
				objHshBbrdData.put("DATA_ID", strDataID);
				
				try {
				
					//4. 삭제 요청된 첨부파일 정보를 가져온다.(삭제시 REAL_FILE이 필요하므로)
					if (strDelFiles != null){
					   objAryDelFile = objIndBoard.selectFileInfo(strDelFiles);
					}
					
					//5. 게시물 수정 메소드를 호출한다.
					intResult = objIndBoard.updateBbrdData(objHshBbrdData);
					
				} catch (AppException objAppEx) {
					
					//데이타 등록 에러일 경우 등록되었던 첨부파일들을 물리적 삭제한다.
					if (objAryNewFile != null){
					
						blnResult = objBoardComm.deletePhysicalFile(objAryNewFile, strFullPath);
					
					}
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode(objAppEx.getStrErrCode());
					objMsgBean.setStrMsg(objAppEx.getMessage());
			
					// 에러 발생 메세지 페이지로 이동한다.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
			
				}
				
				if(intResult != 0 ){
	
					//6. 삭제 요청된 파일 물리적 삭제한다.
					if(strDelFiles != null){
					
						if(strDelFiles.length > 0){
							
							blnResult = objBoardComm.deletePhysicalFile(objAryDelFile, strFullPath);
	
							if (blnResult){
							
								//수정 성공하면 게시물 목록 페이지로 이동한다.
								response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);
							
							}else{
							
								//파일 삭제 실패.
								objMsgBean.setMsgType(MessageBean.TYPE_ERR);
								objMsgBean.setStrCode("DMPARAM-0010");
								objMsgBean.setStrMsg("요청하신 파일을 삭제 하지 못했습니다.");
						
								// 에러 발생 메세지 페이지로 이동한다.
	%>
								<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
								return;
							
							}
						
						}
						
					} else {	
					
						//삭제할 파일없고 디비정보 수정 완료 될 경우 게시물 목록페이지로 이동한다.
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);
					
					}
					
				} else {
				
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0011");
			
					// 에러 발생 메세지 페이지로 이동한다.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
				
				}
			
			}else{
				out.println("<script language=javascript>");
                out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt 형식의 파일만 업로드가능합니다.');");
                out.println("history.go(-2);");
                out.println("</script>");				
			}
			
		}else if(strCmd.equals("DELETE")){
		
			//out.print("삭제<br>");
			
			String strDelID = (String)session.getAttribute("DELID")==null?"":(String)session.getAttribute("DELID");
			String strUserID = (String)session.getAttribute("USER_ID");
			
			if(strDelID != null){
				if(!strDelID.equals(strUserID)){
					session.removeAttribute("DELID");
					out.println("<script language=javascript>");
					out.println("alert('게시판 내용에 대한 삭제권한이 없습니다.');");
					out.println("history.go(-2);");
					out.println("</script>");				
					return;
				}else{
					session.removeAttribute("DELID");
				}
			}else{
					out.println("<script language=javascript>");
					out.println("alert('게시판 내용에 대한 삭제권한이 없습니다.');");
					out.println("history.go(-2);");
					out.println("</script>");
			}
			
			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('잘못된접근입니다.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("BBRD_ID");
					return;
			}else{
					session.removeAttribute("BBRD_ID");
			}

			String strSesDataId = (String)session.getAttribute("DATA_ID")==null?"":(String)session.getAttribute("DATA_ID");
			
			if(!strSesDataId.equals(strDataID)){
					out.println("<script language=javascript>");
					out.println("alert('잘못된접근입니다.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("DATA_ID");
					return;
			}else{
					session.removeAttribute("DATA_ID");
			}
			
			ArrayList objAryAnsList = null;
			ArrayList objAryDelFile = null;
			
			try {
			
				//1. 삭제하기전 답글이 있는지 없는지 확인한다.
				objAryAnsList = objIndBoard.selectBbrdDelInfo(strDataID);
				
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

			if (objAryAnsList.size() == 0) {
				
				//답글 없으므로 삭제 가능
				//2. 실제 게시물과 해당 한줄답글을 삭제하는 메소드를 호출한다.
				try {
				
					//2-1. 게시물에 속하는 첨부파일 정보를 가져온다.(삭제시 REAL_FILE이 필요하므로)
				   objAryDelFile = objIndBoard.selectFileList(strDataID);
				   
					//2-2. 게시물 삭제 메소드를 호출한다.
					intResult = objIndBoard.deleteBbrdData(strDataID, strOneExt, strFileExt);
					
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

				if(intResult != 0 ){
			
					//3. 물리적 파일을 삭제한다.
					if(strFileExt.equals("Y")){
						
						blnResult = objBoardComm.deletePhysicalFile(objAryDelFile, strFullPath);

					} else {	
					
						//첨부파일은 없고 데이터 삭제 성공일 경우 게시물 목록 페이지로 이동한다.
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&bbrdid=" + strBbrdID);
						
					} //end if

					if (blnResult){
					
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&bbrdid=" + strBbrdID);
					
					}else{
					
						//파일 삭제 실패.
						objMsgBean.setMsgType(MessageBean.TYPE_ERR);
						objMsgBean.setStrCode("DMPARAM-0010");
						objMsgBean.setStrMsg("요청하신 파일을 삭제 하지 못했습니다.");
					
						// 에러 발생 메세지 페이지로 이동한다.
%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
						return;
					}
					
				} else {
				
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0012");
					
					// 에러 발생 메세지 페이지로 이동한다.
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
					return;
			
				}
				
			} else {
				
				//답글이 있으므로 삭제 불가능 
				out.println("<script language=javascript>");
                out.println("alert('답글이 존재하므로 삭제할 수 없습니다.');");
                out.println("history.back();");
                out.println("</script>");
			}
		
		}
	
} catch(IOException e){
	//에러페이지로 보내던지 alert으로 알려준다. \n가 alert에 들어가면 에러남.
	out.println("<script language='javascript'>");
	out.println("alert('파일업로드시 에러발생했습니다.첨부파일 최대용량이 초과하였는지 확인해 주십시요.');");
	out.println("history.back();");
	out.println("</script>");
	
} catch(Exception objException){
	
	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	objMsgBean.setStrCode("DMPARAM-0020");
	objMsgBean.setStrMsg(objException.getMessage());
	
	// 에러 발생 메세지 페이지로 이동한다.
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	return;

}
%>
