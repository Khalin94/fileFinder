<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.util.BoardComm" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%//@ include file="/common/CheckSession.jsp" %>
<%@ include file="/board/common/GetBoardProperty.jsp" %>

<%
try {
	/*���ǰ� */
    System.out.println("�׽�Ʈ");
	String strLoginID = (String)session.getAttribute("USER_ID")==null?"99999":(String)session.getAttribute("USER_ID");//�α��� ID
	String strLoginNm = (String)session.getAttribute("USER_NM")==null?request.getParameter("writernm"):(String)session.getAttribute("USER_NM");//�α��� Name
    /*GET �Ķ����*/
	String strBbrdID = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("bbrdid")));						//�Խ��� ���̵�
	String strBbrdKind = this.replaceXss(StringUtil.getNVLNULL(request.getParameter("bbrdkind")));					//�Խ��� ����

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

 	//���ε� ���丮 ���ٸ� ���� [��Ģ : webroot + board + bbrd_kind + strBbrdID + �⵵]
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

	/*GET �Ķ����*/
	String strGoToPage = this.replaceXss(StringUtil.getNVLNULL(URLDecoder.decode(multi.getParameter("strGoToPage"), "UTF-8")));

	//��ũ������
	String strCurrentPage =  this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("strCurrentPage")));
	//���� ������
	String strCmd = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("cmd")));
	//����

	String strTitle = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("title")));
	//�Խù� ����
	String strCont = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("cont")));
	//�Խù� ����(Editor��)
	String strTxtCont = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("txtCont")));
	//�Խù� ����(Text��)


	String strDataID = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("dataid")));
	//�Խù� ���̵�(UPDATE, DELETE)
	String strTtopID = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("ttopid")));
	//�Խù� ���̵�(ANSWER)
	String strOneExt = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("oneext")));
	//���ٴ亯 ����(DELETE)
	String strFileExt = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("fileext")));
	//÷������ ����(DELETE)
	String strEditorExt = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("editorext")));
	//HTML ������ ���
	if(strEditorExt.equals("") || strEditorExt == null){

		strEditorExt = "N";

	}


	String strWriterNm = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("writernm")));						//����ڸ�
	String strDataPwd = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("datapwd")));							//�Խù� ��й�ȣ

	/*�ʱⰪ ���� */
	nads.dsdm.app.board.SLBoardDelegate objBoard = new nads.dsdm.app.board.SLBoardDelegate();
	BoardComm objBoardComm = new BoardComm();

	//�Է��� ����Ÿ�� HashTable ����
	Hashtable objHshBbrdData = new Hashtable();
	int intResult = 0;
	boolean blnResult = true;
		if(strCmd.equals("CREATE")){

			//out.println("����<br>");

			if(strBbrdID.equals("0000000010") || strBbrdID.equals("0000000012")){
				if(strLoginID.equals("ADMIN") || strLoginID.equals("ADMIN1") || strLoginID.equals("ADMIN2")){

				}else{
					out.println("<script language=javascript>");
					out.println("alert('�Խ��ǿ� ���� ������ �����ϴ�.');");
					out.println("history.go(-2);");
					out.println("</script>");
					return;
				}
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

			//1. ÷�������� ���ε� �Ѵ�.===============================
			ArrayList objAryFileInfo = new ArrayList();										//������ �������� ��ü�� ���� ArrayList
			strFileExt = "N";																					//������ �������� �ʱⰪ�� "N" �� ����.
			boolean flagResult = true;
 			for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){
				boolean flag = false;
				String strFormName=(String)formNames.nextElement(); 				//�ڷᰡ ���� ��쿣
				String strFileName = multi.getFilesystemName(strFormName); 	//������ �̸� ���
				String strOrgName = multi.getOriginalFileName(strFormName);	//���� ���� �̸� ���
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

				if(strFileName != null) {    // ������ ���ε� �Ǿ�����

					//out.print("Form Name : " + strFormName + "<BR>");
					//out.print("File Name  : " + strFileName + "<BR>");

					//FILE_ID, DATA_ID, FILE_NAME, REAL_FILE, FILE_SIZE, DOWN_CNT
					Hashtable objHshFileInfo = new Hashtable();

					//FILE_ID, DATA_ID �� Beans ���� ó��.
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

					String strTopLevel = StringUtil.getNVLNULL(multi.getParameter("toplevel"));
					String strTopOrder = StringUtil.getNVLNULL(multi.getParameter("toporder"));

					try {
						//������ ����� DATA_STEP +1 UPDATE
						intResult = objBoard.updateDataOrder(strTtopID, strTopOrder);

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
				objHshBbrdData.put("FILE_PATH", strSavePath);
				objHshBbrdData.put("APD_FILE_EXT", strFileExt);
				objHshBbrdData.put("ONE_ANS_EXT", "N");						//����Ʈ�� "N"
				objHshBbrdData.put("HTML_USE_FLAG", strEditorExt);
				objHshBbrdData.put("QRY_CNT", "0");
				objHshBbrdData.put("USER_IP", request.getHeader("Proxy-Client-IP"));
				objHshBbrdData.put("DEL_FLAG", "N");
				objHshBbrdData.put("ANC_TGT", "0");								//�߰� (2004-03-23) :�⺻�� 0 (ȸ��)
				objHshBbrdData.put("REMARK", "");
				if(strWriterNm == null || strWriterNm.equals("")) {			//�߰� (2004-06-26)
					objHshBbrdData.put("WRITER_ID", strLoginID);
					objHshBbrdData.put("WRITER_NM", strLoginNm);
				} else {
					objHshBbrdData.put("WRITER_ID", "BBRDUSER");		//��¥ ����Ÿ.
					objHshBbrdData.put("WRITER_NM", strWriterNm);
				}
				objHshBbrdData.put("WRITER_EMAIL", "");						//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_PWD", strDataPwd);				//�߰� (2004-06-26)

				try {

					intResult = objBoard.insertBbrdData(objHshBbrdData);

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

					//�Է��� �����ϸ� ��� �������� �̵��Ѵ�.
					response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID);

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
		}else if(strCmd.equals("UPDATE")){

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
			ArrayList objAryDelFile = null;						//���� ��û�� ����

			//1-1. ���� �߰��Ǵ� ������ ������ ���ε� �Ѵ�.
			boolean flagResult = true;
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
				System.out.println(strOrgNameTemp);

				File objFile = multi.getFile(strFormName);

				if(strFileName != null) {  // ������ ���ε� �Ǿ�����

					//out.println("Form Name : " + strFormName + "<BR>");
					//out.println("File Name  : " + strFileName + "<BR>");

					//FILE_ID, DATA_ID, FILE_NAME, REAL_FILE, FILE_SIZE, DOWN_CNT
					Hashtable objHshNewFile = new Hashtable();

					//FILE_ID, DATA_ID �� Beans ���� ó��.
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
				objHshBbrdData.put("ANC_TGT", "0");								//�߰� (2004-03-23) :�⺻�� 0 (ȸ��)
				if(strWriterNm == null || strWriterNm.equals("")) {			//�߰� (2004-06-26)
					objHshBbrdData.put("WRITER_NM", strLoginNm);
				} else {
					objHshBbrdData.put("WRITER_NM", strWriterNm);
				}
				objHshBbrdData.put("WRITER_EMAIL", "");						//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_PWD", strDataPwd);				//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_ID", strDataID);

				try {

					//4. ���� ��û�� ÷������ ������ �����´�.(������ REAL_FILE�� �ʿ��ϹǷ�)
					if (strDelFiles != null){
					   objAryDelFile = objBoard.selectFileInfo(strDelFiles);
					}

					//5. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objBoard.updateBbrdData(objHshBbrdData);

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

								//�Է��� �����ϰ� �������� ���/���� �����ϸ� ��� �������� �̵��Ѵ�.
								response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);

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

						//������ ���Ͼ��� ������� ���� �Ϸ� �� ��� �Խù� ������� �̵��Ѵ�.
						response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);

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
		} else if(strCmd.equals("DELETE")){

			//out.println("����<br>");

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
				objAryAnsList = objBoard.selectBbrdDelInfo(strDataID);

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
				   objAryDelFile = objBoard.selectFileList(strDataID);

					//2-2. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objBoard.deleteBbrdData(strDataID, strOneExt, strFileExt);

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

						if (blnResult){
							//������ �����ϸ� �Խù� ��� �������� �̵��Ѵ�.
                            if (strBbrdID.equals("0000000015")){
    							response.sendRedirect("/help/BoardList.jsp?bbrdid=" + strBbrdID);
                            } else {
    							response.sendRedirect("/board/BoardList.jsp?bbrdid=" + strBbrdID);
                            }
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
						//÷�������� ���� ������ ���� ������ ��� �Խù� ��� �������� �̵��Ѵ�.
                        if (strBbrdID.equals("0000000015")){
                            response.sendRedirect("/help/BoardList.jsp?bbrdid=" + strBbrdID);
                        } else {
                            response.sendRedirect("/board/BoardList.jsp?bbrdid=" + strBbrdID);
                        }

					} //end if

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
    else if(strCmd.equals("OPENUPDATE")){

			ArrayList objAryNewFile = new ArrayList();			//�߰� ��û�� ����
			ArrayList objAryDelFile = null;						//���� ��û�� ����

			//1-1. ���� �߰��Ǵ� ������ ������ ���ε� �Ѵ�.
			Hashtable objHshDataInfoTemp = null;
			try {
		
				//1. �Խù� ������ �����´�.
				objHshDataInfoTemp = objBoard.selectBbrdDataInfo(strDataID);
			
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
		    
			String strtemp = (String)objHshDataInfoTemp.get("DATA_PWD");
	
			if(!strtemp.equals(strDataPwd)){
				out.println("<script language=javascript>");
                out.println("alert('��й�ȣ�� ��ġ���� �ʽ��ϴ�.');");
                out.println("history.go(-2);");
                out.println("</script>");
				return;
			
			}
			boolean flagResult = true;
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
				System.out.println(strOrgNameTemp);

				File objFile = multi.getFile(strFormName);

				if(strFileName != null) {  // ������ ���ε� �Ǿ�����

					//out.println("Form Name : " + strFormName + "<BR>");
					//out.println("File Name  : " + strFileName + "<BR>");

					//FILE_ID, DATA_ID, FILE_NAME, REAL_FILE, FILE_SIZE, DOWN_CNT
					Hashtable objHshNewFile = new Hashtable();

					//FILE_ID, DATA_ID �� Beans ���� ó��.
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
				objHshBbrdData.put("ANC_TGT", "0");								//�߰� (2004-03-23) :�⺻�� 0 (ȸ��)
				if(strWriterNm == null || strWriterNm.equals("")) {			//�߰� (2004-06-26)
					objHshBbrdData.put("WRITER_NM", strLoginNm);
				} else {
					objHshBbrdData.put("WRITER_NM", strWriterNm);
				}
				objHshBbrdData.put("WRITER_EMAIL", "");						//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_PWD", strDataPwd);				//�߰� (2004-06-26)
				objHshBbrdData.put("DATA_ID", strDataID);

				try {

					//4. ���� ��û�� ÷������ ������ �����´�.(������ REAL_FILE�� �ʿ��ϹǷ�)
					if (strDelFiles != null){
					   objAryDelFile = objBoard.selectFileInfo(strDelFiles);
					}

					//5. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objBoard.updateBbrdData(objHshBbrdData);

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

								//�Է��� �����ϰ� �������� ���/���� �����ϸ� ��� �������� �̵��Ѵ�.
								response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);

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

						//������ ���Ͼ��� ������� ���� �Ϸ� �� ��� �Խù� ������� �̵��Ѵ�.
						response.sendRedirect(strGoToPage + "?strCurrentPage=" + strCurrentPage + "&bbrdid=" + strBbrdID + "&bbrdkind=" + strBbrdKind);

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
		} else if(strCmd.equals("OPENDELETE")){

			ArrayList objAryAnsList = null;
			ArrayList objAryDelFile = null;
			//1-1. ���� �߰��Ǵ� ������ ������ ���ε� �Ѵ�.
			Hashtable objHshDataInfoTemp2 = null;
			try {
		
				//1. �Խù� ������ �����´�.
				objHshDataInfoTemp2 = objBoard.selectBbrdDataInfo(strDataID);
			
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
		    
			String strtemp2 = (String)objHshDataInfoTemp2.get("DATA_PWD");
			String strtemp3 = (String)session.getAttribute("DATA_PWD");
			session.removeAttribute("DATA_PWD");
	
			if(!strtemp2.equals(strtemp3)){
				out.println("<script language=javascript>");
                out.println("alert('��й�ȣ�� ��ġ���� �ʽ��ϴ�.');");
                out.println("history.go(-2);");
                out.println("</script>");
				return;
			
			}

			try {
				//1. �����ϱ��� ����� �ִ��� ������ Ȯ���Ѵ�.
				objAryAnsList = objBoard.selectBbrdDelInfo(strDataID);

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
				   objAryDelFile = objBoard.selectFileList(strDataID);

					//2-2. �Խù� ���� �޼ҵ带 ȣ���Ѵ�.
					intResult = objBoard.deleteBbrdData(strDataID, strOneExt, strFileExt);

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

						if (blnResult){
   							response.sendRedirect("/guide/GuideBoardList.jsp?mbbrdkind=006");
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
						response.sendRedirect("/guide/GuideBoardList.jsp?mbbrdkind=006");
					} //end if

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

} catch(IOException objIOException){

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
<%!
	public String replaceXss(String str){

		if(str.equals("") || str == null){
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");
			str = str.replaceAll("\"", "&#34;");
			str = str.replaceAll("\'", "&#39;");
		}

		return str;
	}
%>