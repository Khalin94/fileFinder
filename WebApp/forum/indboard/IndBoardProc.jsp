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
	/*���ǰ� */ 
	String strLoginID = (String)session.getAttribute("USER_ID");										//�α��� ID
	String strLoginNm = (String)session.getAttribute("USER_NM");									//�α��� Name
	
	/*GET �Ķ����*/
	String strBbrdID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdid")));			 //�Խ��� ���̵�
	String strBbrdKind = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(request.getParameter("bbrdkind")));		 //�Խ��� ����
	
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
	
 	int intSizeLimit =Integer.valueOf(fileMaxSize).intValue(); 														// ÷������ �ִ�뷮 (���� 5�ް�)
 	
 	//���ε� ���丮�� ���ٸ� �����Ѵ�. [��Ģ : webroot + board + bbrd_kind + strBbrdID + �⵵]
	java.text.SimpleDateFormat yearFormat = new java.text.SimpleDateFormat ("yyyy") ;
	String strYear  = yearFormat.format(new Date(System.currentTimeMillis()));
	String strSavePath = uploadPath + "board/" + strBbrdKind + "/" + strBbrdID + "/" + strYear ;	// ������ ���丮 (������)
	
	String strFullPath = webPath + strSavePath;
 	File objDir = new File(strFullPath);
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
 	
 	/*MultipartRequest ����*/
 	MultipartRequest multi = new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	
	/*�������� ������ �Ķ���� (����ID, ȸ������, ��������, ������)*/
	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("uStt"))); //ȸ������
	String strOpenFlag = ""; //��������
	String strForumNM = ""; //������
	
	/*GET �Ķ����*/
	String strCurrentPage =  nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("strCurrentPage")));  //���� ������
	String strCmd = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cmd")));					 //����
	String strAncTgt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("anctgt")));				 //�������
	String strTitle = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("title")));				 //�Խù� ����
	String strCont = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cont")));					 //�Խù� ����(Editor��)
	String strTxtCont = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("txtCont")));			 //�Խù� ����(Text��)
	String strDataID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("dataid")));				 //�Խù� ���̵�(UPDATE, DELETE)
	String strTtopID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("ttopid")));				 //�Խù� ���̵�(ANSWER)
	String strOneExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("oneext")));				 //���ٴ亯 ����(DELETE)
	String strFileExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fileext")));			 //÷������ ����(DELETE) 
	String strEditorExt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("editorext")));		 //HTML ������ ��� ����(DELETE) New 

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objIndBoard = new nads.dsdm.app.board.SLBoardDelegate();
	BoardComm objBoardComm = new BoardComm();
	Hashtable objHshBbrdData = new Hashtable();
	int intResult = 0;
	boolean blnResult = false;

		if(strCmd.equals("CREATE")){
			
			//out.println("����<br>");
			
			//1. ÷�������� ���ε� �Ѵ�.===============================
			ArrayList objAryFileInfo = new ArrayList();										//������ �������� ��ü�� ���� ArrayList
			strFileExt = "N";																					//������ �������� �ʱⰪ�� "N" �� ����.
			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('�߸��������Դϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("BBRD_ID");
					return;
			}
			boolean flagResult = true;
 			for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){
				boolean flag = false;
				String strFormName=(String)formNames.nextElement(); 				//���� ���ε�
				String strFileName = multi.getFilesystemName(strFormName); 	//������ �̸� ���
				String strOrgName = multi.getOriginalFileName(strFormName);	//���� ���� �̸� ���
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
				
				if(strFileName != null) {    // ������ ���ε� �Ǿ�����

					//out.print("Form Name : " + strFormName + "<BR>");
					//out.print("File Name  : " + strFileName + "<BR>");
					
					//����Ÿ ������ �����Ѵ�. FILE_ID, DATA_ID �� Beans ���� ó��.
					Hashtable objHshFileInfo = new Hashtable();
					objHshFileInfo.put("FILE_NAME" , strOrgName);
					objHshFileInfo.put("REAL_FILE" , strFileName);
					objHshFileInfo.put("FILE_SIZE" , String.valueOf(objFile.length()));
					objHshFileInfo.put("DOWN_CNT" ,  new Integer(0));
					
					objAryFileInfo.add(objHshFileInfo);
					
					//���� ���������� �����Ѵ�.
					strFileExt = "Y";
				}
					
				if(flag == false){
					flagResult = false;
					break;
				}
				
			}	//end for
					
			if(flagResult == true){
				//1-1. 0~5���� ÷������ ������ Hashtable�� �߰��Ѵ�.
				objHshBbrdData.put("FILE_OBJ", objAryFileInfo);
				
				//���� ���� ������ "N"��� FILE_PATH�� ""�� �����Ѵ�.
				if(strFileExt.equals("N")){
					strSavePath = "";
				}
				
				
				//2. �Խù������� ����Ѵ�.===============================
				
				if(strTtopID == null || strTtopID.equals("")){
				
					//objHshBbrdData.put("TTOP_BBRD_ID", "");							//������ ��� Bean���� ó��. DATA_ID�� ����
					//objHshBbrdData.put("TOP_BBRD_ID", "");								//������ ��� Bean���� ó��. DATA_ID�� ����
					objHshBbrdData.put("DATA_LEVEL", new Integer(0));				//������ ��� 0
					objHshBbrdData.put("DATA_ORDER", new Integer(0));			//������ ��� 0
				
				} else {
				
					String strTopLevel = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("toplevel")));
					String strTopOrder = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("toporder")));
	
					try {
						//������ ����� DATA_STEP +1 UPDATE
						intResult = objIndBoard.updateDataOrder(strTtopID, strTopOrder);
						
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
					
					int intTopLevel = Integer.valueOf(strTopLevel).intValue() + 1;
					int intTopOrder = Integer.valueOf(strTopOrder).intValue() + 1;
					
					objHshBbrdData.put("TTOP_BBRD_ID", strTtopID);
					objHshBbrdData.put("TOP_BBRD_ID", strDataID);	
					objHshBbrdData.put("DATA_LEVEL", new Integer(intTopLevel));				//����� ��� +1
					objHshBbrdData.put("DATA_ORDER", new Integer(intTopOrder));			//����� ��� +1
				
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
				objHshBbrdData.put("ONE_ANS_EXT", "N");						//����Ʈ�� "N"
				objHshBbrdData.put("HTML_USE_FLAG", strEditorExt);
				objHshBbrdData.put("QRY_CNT", "0");
				objHshBbrdData.put("USER_IP", request.getHeader("Proxy-Client-IP"));
				objHshBbrdData.put("DEL_FLAG", "N");
				objHshBbrdData.put("ANC_TGT", strAncTgt);					//�߰� (2004-03-23) :�⺻�� 0 (ȸ��)
				objHshBbrdData.put("REMARK", "");
				objHshBbrdData.put("WRITER_NM", strLoginNm);			//�߰� (2004-06-26)
				objHshBbrdData.put("WRITER_EMAIL", "");						//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_PWD", "");								//�߰� (2004-06-26)
				
				try {
				
					intResult = objIndBoard.insertBbrdData(objHshBbrdData);
				
				} catch (AppException objAppEx) {
					
					//����Ÿ ��� ������ ��� ��ϵǾ��� ÷�����ϵ��� ������ �����Ѵ�.
					if (objAryFileInfo != null){
					
						blnResult = objBoardComm.deletePhysicalFile(objAryFileInfo, strFullPath);
						
					}
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode(objAppEx.getStrErrCode());
					objMsgBean.setStrMsg(objAppEx.getMessage());
						
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
			
				}
	
				if(intResult != 0 ){
					//����� �����ϸ� ������ �������� �̵��Ѵ�.
					response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID);
				} else {
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0010");
			
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
				
				}
			}else{
				out.println("<script language=javascript>");
                out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");
                out.println("history.go(-2);");
                out.println("</script>");
				return;
			}
			
		}
		else if(strCmd.equals("UPDATE")){
		
			//out.print("����<br>");
			
			String strWriterID = (String)session.getAttribute("WRITER_ID")==null?"":(String)session.getAttribute("WRITER_ID");
			String strUserID = (String)session.getAttribute("USER_ID");
			
			if(strWriterID != null){
				if(!strWriterID.equals(strUserID)){
					session.removeAttribute("WRITER_ID");
					out.println("<script language=javascript>");
					out.println("alert('�Խ��� ���뿡 ���� ���������� �����ϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");				
					return;
				}else{
					session.removeAttribute("WRITER_ID");
				}
			}else{
					out.println("<script language=javascript>");
					out.println("alert('�Խ��� ���뿡 ���� ���������� �����ϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");
			}

			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('�߸��������Դϴ�.');");
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
					out.println("alert('�߸��������Դϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");	
					session.removeAttribute("DATA_ID");
					return;
			}else{
					session.removeAttribute("DATA_ID");
			}
			
			ArrayList objAryNewFile = new ArrayList();			//�߰� ��û�� ����
			ArrayList objAryDelFile = null;								//���� ��û�� ���� 
			boolean flagResult = true;
			//1-1. ���� �߰��Ǵ� ������ ������ ���ε� �Ѵ�.
			for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){
				boolean flag = false;
				String strFormName=(String)formNames.nextElement();
				String strFileName = multi.getFilesystemName(strFormName); 	// ������ �̸� ���
				String strOrgName = multi.getOriginalFileName(strFormName);	// ���� ���� �̸� ���
				String strOrgNameTemp = multi.getOriginalFileName(strFormName);	//���� ���� �̸� ���
				
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
			
				if(strFileName != null) {  // ������ ���ε� �Ǿ�����
				
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
			
			//1-2. ���� �߰��Ǵ� ���������� Hashtable�� �߰��Ѵ�.
			if(flagResult == true){
				if(objAryNewFile.size() != 0){
					objHshBbrdData.put("NEW_FILE", objAryNewFile);
				}
				
				//2. ������û�� ������ ������ Hashtable�� �߰��Ѵ�.
				String[] strDelFiles = multi.getParameterValues("delfile");
				if (strDelFiles != null){
					objHshBbrdData.put("DEL_FILE", strDelFiles);
				}
				
				//3. ������ �Խù� �⺻������ Hashtable�� �߰��Ѵ�.
				objHshBbrdData.put("TITLE", strTitle);
				if(strEditorExt.equals("Y")){
					objHshBbrdData.put("CONT", strCont);
				} else {
					objHshBbrdData.put("CONT", strTxtCont); 
				}
				objHshBbrdData.put("USER_IP", request.getHeader("Proxy-Client-IP"));
				objHshBbrdData.put("REMARK", "");
				//���� ���� ������ "N"��� ������� FILE_PATH�� ""�� �����Ѵ�.
				if (strFileExt.equals("N")){
					objHshBbrdData.put("FILE_PATH", "");							//�߰� (2004-03-04)
				} else if (strFileExt.equals("Y")){
					objHshBbrdData.put("FILE_PATH", strSavePath);			//�߰� (2004-03-04)
				}
				objHshBbrdData.put("APD_FILE_EXT", strFileExt);
				objHshBbrdData.put("HTML_USE_FLAG", strEditorExt);		//�߰� (2004-3-26)
				objHshBbrdData.put("ANC_TGT", strAncTgt);					//�߰� (2004-03-23) :�⺻�� 0 (ȸ��)
				objHshBbrdData.put("WRITER_NM", strLoginNm);
				objHshBbrdData.put("WRITER_EMAIL", "");						//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_PWD", "");								//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_ID", strDataID);
				
				try {
				
					//4. ���� ��û�� ÷������ ������ �����´�.(������ REAL_FILE�� �ʿ��ϹǷ�)
					if (strDelFiles != null){
					   objAryDelFile = objIndBoard.selectFileInfo(strDelFiles);
					}
					
					//5. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objIndBoard.updateBbrdData(objHshBbrdData);
					
				} catch (AppException objAppEx) {
					
					//����Ÿ ��� ������ ��� ��ϵǾ��� ÷�����ϵ��� ������ �����Ѵ�.
					if (objAryNewFile != null){
					
						blnResult = objBoardComm.deletePhysicalFile(objAryNewFile, strFullPath);
					
					}
					
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode(objAppEx.getStrErrCode());
					objMsgBean.setStrMsg(objAppEx.getMessage());
			
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
			
				}
				
				if(intResult != 0 ){
	
					//6. ���� ��û�� ���� ������ �����Ѵ�.
					if(strDelFiles != null){
					
						if(strDelFiles.length > 0){
							
							blnResult = objBoardComm.deletePhysicalFile(objAryDelFile, strFullPath);
	
							if (blnResult){
							
								//���� �����ϸ� �Խù� ��� �������� �̵��Ѵ�.
								response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);
							
							}else{
							
								//���� ���� ����.
								objMsgBean.setMsgType(MessageBean.TYPE_ERR);
								objMsgBean.setStrCode("DMPARAM-0010");
								objMsgBean.setStrMsg("��û�Ͻ� ������ ���� ���� ���߽��ϴ�.");
						
								// ���� �߻� �޼��� �������� �̵��Ѵ�.
	%>
								<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
								return;
							
							}
						
						}
						
					} else {	
					
						//������ ���Ͼ��� ������� ���� �Ϸ� �� ��� �Խù� ����������� �̵��Ѵ�.
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);
					
					}
					
				} else {
				
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0011");
			
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
	%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
					return;
				
				}
			
			}else{
				out.println("<script language=javascript>");
                out.println("alert('hwp,pdf,zip,alz,doc,ppt,xls,txt ������ ���ϸ� ���ε尡���մϴ�.');");
                out.println("history.go(-2);");
                out.println("</script>");				
			}
			
		}else if(strCmd.equals("DELETE")){
		
			//out.print("����<br>");
			
			String strDelID = (String)session.getAttribute("DELID")==null?"":(String)session.getAttribute("DELID");
			String strUserID = (String)session.getAttribute("USER_ID");
			
			if(strDelID != null){
				if(!strDelID.equals(strUserID)){
					session.removeAttribute("DELID");
					out.println("<script language=javascript>");
					out.println("alert('�Խ��� ���뿡 ���� ���������� �����ϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");				
					return;
				}else{
					session.removeAttribute("DELID");
				}
			}else{
					out.println("<script language=javascript>");
					out.println("alert('�Խ��� ���뿡 ���� ���������� �����ϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");
			}
			
			String strSesBbrdId = (String)session.getAttribute("BBRD_ID")==null?"":(String)session.getAttribute("BBRD_ID");
			
			if(!strSesBbrdId.equals(strBbrdID)){
					out.println("<script language=javascript>");
					out.println("alert('�߸��������Դϴ�.');");
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
					out.println("alert('�߸��������Դϴ�.');");
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
			
				//1. �����ϱ��� ����� �ִ��� ������ Ȯ���Ѵ�.
				objAryAnsList = objIndBoard.selectBbrdDelInfo(strDataID);
				
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

			if (objAryAnsList.size() == 0) {
				
				//��� �����Ƿ� ���� ����
				//2. ���� �Խù��� �ش� ���ٴ���� �����ϴ� �޼ҵ带 ȣ���Ѵ�.
				try {
				
					//2-1. �Խù��� ���ϴ� ÷������ ������ �����´�.(������ REAL_FILE�� �ʿ��ϹǷ�)
				   objAryDelFile = objIndBoard.selectFileList(strDataID);
				   
					//2-2. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objIndBoard.deleteBbrdData(strDataID, strOneExt, strFileExt);
					
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

				if(intResult != 0 ){
			
					//3. ������ ������ �����Ѵ�.
					if(strFileExt.equals("Y")){
						
						blnResult = objBoardComm.deletePhysicalFile(objAryDelFile, strFullPath);

					} else {	
					
						//÷�������� ���� ������ ���� ������ ��� �Խù� ��� �������� �̵��Ѵ�.
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&bbrdid=" + strBbrdID);
						
					} //end if

					if (blnResult){
					
						response.sendRedirect("IndBoardList.jsp?fid=" + strForumID + "&uStt=" + strUserStt  + "&anctgt=" + strAncTgt + "&bbrdid=" + strBbrdID);
					
					}else{
					
						//���� ���� ����.
						objMsgBean.setMsgType(MessageBean.TYPE_ERR);
						objMsgBean.setStrCode("DMPARAM-0010");
						objMsgBean.setStrMsg("��û�Ͻ� ������ ���� ���� ���߽��ϴ�.");
					
						// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
						return;
					}
					
				} else {
				
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					objMsgBean.setStrCode("DSDATA-0012");
					
					// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
					return;
			
				}
				
			} else {
				
				//����� �����Ƿ� ���� �Ұ��� 
				out.println("<script language=javascript>");
                out.println("alert('����� �����ϹǷ� ������ �� �����ϴ�.');");
                out.println("history.back();");
                out.println("</script>");
			}
		
		}
	
} catch(IOException e){
	//������������ �������� alert���� �˷��ش�. \n�� alert�� ���� ������.
	out.println("<script language='javascript'>");
	out.println("alert('���Ͼ��ε�� �����߻��߽��ϴ�.÷������ �ִ�뷮�� �ʰ��Ͽ����� Ȯ���� �ֽʽÿ�.');");
	out.println("history.back();");
	out.println("</script>");
	
} catch(Exception objException){
	
	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	objMsgBean.setStrCode("DMPARAM-0020");
	objMsgBean.setStrMsg(objException.getMessage());
	
	// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	return;

}
%>
