<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.*" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>

<link href="/css/global.css"  rel="stylesheet" type="text/css" />

<%
	/*
	 *******************************************************************************************
	 * ��������� ���õ� ������ ���� ó�� �۾��� �ٸ��� �����Ѵ�.
	 * ����, �ش��ϴ� �䱸 ID�� �ʼ��� �Է¹޾ƾ� �ϸ� ���õ� �亯 ������ ���� �Ķ���� NULL üũ�� �ٸ��� ������
	 * ���� ���ε� ���۳�Ʈ�� �������. �Ƹ��� MultipartRequest�� ������...
	 * Ȥ�� ��� �Ǵ� LOG ������ ���̺��� ���� ģ���ϰ� �ش� �����͸� INSERT ���� �� ����
	 *******************************************************************************************
	 */

	String tmpPath = null; // �ӽ� ����� ���� ���
	String reqID = null; // �䱸 ID
	String reqBoxID = null; // �䱸�� ID
	String ansType = null; // �亯 ����
	String originFile = null; // ���� ������
	String pdfFile = null; // PDF ���ϸ�
	String ansOpinion = null; // ���� �ǰ�
	String realSavePath = null; // ������ ����� ������ ���� ���(Windows���)
	String nowYear = null; // �ý����� ���� �⵵
	String idxFileName = null; // ����� txt ���ϸ�
	String signData = null; // ���� ���� ����
	String openCL = null; // ��������
	String ansrID = null; // �Է��� ID
	 
	try {
	
		// �ʿ��� �Լ��� ����� Delegate ����
		// SLSubmitDocumentDelegate selfDelegate = new SLSubmitDocumentDelegate();
		SMemAnsInfoDelegate selfDelegate = new SMemAnsInfoDelegate();
	 
		tmpPath = EnvConstants.WIN_TEMP_SAVE_PATH; // ���� ���� ���. ���߿��� ��򰡿� �����Ǿ�������
		
		// ���߿� ��� �� ����� ���� ������ ���ؼ� �̸� ���� ���´�. ���� �����ٰ�!!!
		Calendar now = Calendar.getInstance();
 		nowYear = String.valueOf(now.get(Calendar.YEAR));
		
		reqID = request.getParameter("ReqID");
		reqBoxID = request.getParameter("ReqBoxID");
		ansType = request.getParameter("ansType");
		ansOpinion = StringUtil.toMulti(request.getParameter("ansOpinion"));
		originFile = StringUtil.toMulti(request.getParameter("originFile"));
		pdfFile = StringUtil.toMulti(request.getParameter("pdfFile"));
		signData = StringUtil.toMulti(request.getParameter("signData"));
		openCL = request.getParameter("openCL");
		ansrID = StringUtil.toMulti(request.getParameter("ansrID"));
		
		// ���ڵ� �ٲ�� �ϳ�???
		//System.out.println(ansOpinion);
		//System.out.println(originFile);
		//System.out.println(pdfFile);
		//System.out.println(signData);
		
		
		// �䱸ID�� NULL�̸� �ȵȴ�. �����~~. �ٸ� �͵� �߿����� ���� �ȵǴ� �͵��� �ִ�. üũ����.
		if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqID))) {
		 	out.println("�䱸 ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
	 	} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(ansType))) {
			out.println("���õ� �亯 ������ �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
		} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqBoxID))) {
			out.println("�䱸�� ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
	 	} else if ("".equalsIgnoreCase(signData)) { // ���� ���� �Դµ� �̰� ���� �ȵ���..
	 		out.println("Sign Data�� �����ϴ�. ���� �ܰ迡���� ���� �ȵźη�~");
	 	}
	 	
 		// ���ϰ��� �۾� 3�ѻ� ����
 		// �۾�. 1. ���϶���Ʈ ������ ����
 		// ���߿� ���Ծ��� wrapping class�� ����� �ֹ� �ٲܱ��~ � �ٲ����̼�~
 		int HLSuccess = selfDelegate.setHLIndex(pdfFile);
 		if (HLSuccess < 1) {
 			out.println("��ϵ� PDF ������ ���϶���Ʈ ���� �������� ������ �߻��߽��ϴ�.");
 		}
	 		
 		// �۾�.2. Full Text ������ ���� TXT ������ ��������
 		idxFileName = selfDelegate.getIdxFile(pdfFile);
 		if ("".equalsIgnoreCase(idxFileName)) {
 			out.println("TXT ���� �����۾����� ������ �߻��߽��ϴ�.");
 		}
	 			 		
 		// ���ϸ����� ������ �亯 ID�� ������ �ѹ��� �޾ƿ���.
 		String ansInfoID = selfDelegate.getSeqNextVal("TBDS_ANSWER_INFO");
 		
		// TBDS_ANS_FILE_INFO�� SEQUENCE�� �޾ƿ´�.
		String ansFileID = selfDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO");
	 			 		
 		// �켱�� ������ ��¥ ��¥ ���� ��ġ�� ����?�̵�? ��Ű��
 		// ���� ���� ������ ����Ű�� ==> ��ӵ� ����� + ���� + �䱸��ID
 		realSavePath = EnvConstants.UNIX_SAVE_PATH+nowYear+"/"+StringUtil.padl(reqBoxID, 10)+ "/";
 		
 		// ���� �����ϰ��� �ϴ� ������ ������ �ȵ� ��쿡�� ���������
		FileUtil.prepareFolder(realSavePath);
		
		// �̵���ų ���ο� ���ϸ��� ��������. �ʿ��� ���ο� �λ���...... -��-
		String newOriginFileName = StringUtil.padl(ansFileID, 10)+"."+originFile.substring(originFile.lastIndexOf('.')+1, originFile.length());
		String newPdfFileName = StringUtil.padl(ansFileID, 10)+".pdf";
		String newIdxFileName = StringUtil.padl(ansFileID, 10)+"."+idxFileName.substring(idxFileName.lastIndexOf('.')+1, idxFileName.length());
		
		//System.out.println("New Origin File Name : " + newOriginFileName);
		//System.out.println("New PDF File Name : " + newPdfFileName);
		//System.out.println("New HL Index File Name : " + newIdxFileName);
			
 		// ������ ����ҿ� ��ӵ� ���ϸ����� ���縦 ����.
 		boolean success1 = FileUtil.copyFile(tmpPath+originFile, realSavePath+newOriginFileName);
 		boolean success2 = FileUtil.copyFile(tmpPath+pdfFile, realSavePath+newPdfFileName);
 		boolean success3 = FileUtil.copyFile(tmpPath+idxFileName, realSavePath+newIdxFileName);
 		// ���߿� ���� �� �� ���� ���϶���Ʈ �ε��� ���õ� ������ ���� ������ ���� �����ϴ� API�� ��������� ���ؼ�
 		// �ϼ��ȴٸ�.. �׶��� ���� ���� ���� ���θ� �ϳ� �� üũ�� ��� �� ���̴�...
	 		
 		if (success1 && success2 && success3) { // �� �� �����ؾ� ���� ���μ����� ��������...
 		
 			Vector paramI = new Vector();
 			Vector paramII = new Vector();
 			
 			// insertAnsFileInfo() parameter Vector
 			paramI.add(ansFileID); // 1
			paramI.add(nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newPdfFileName); // 2
			paramI.add(nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newOriginFileName); // 3
			paramI.add(signData); // 4
			paramI.add(EnvConstants.UNIX_SAVE_PATH+nowYear+"/"+StringUtil.padl(reqBoxID, 10)+"/"+newIdxFileName); // 5
			
			// insertAnswerInfo parameter Vector
			paramII.add(ansInfoID); 				// 1
			paramII.add(reqID); 						// 2
			paramII.add(ansFileID); 				// 3
			paramII.add(ansrID); 					// 4
			paramII.add(ansOpinion); 				// 5
			paramII.add(ansType); 					// 6
			paramII.add(openCL); 					// 7
			paramII.add(""); 							// 8 - ��ü ����
			paramII.add(""); 							// 9 - �߼� ���
			 			
 			int dbSuccess1 = selfDelegate.insertAnsFileInfo(paramI);
 			int dbSuccess2 = selfDelegate.insertAnswerInfo(paramII);
 			
 			if (dbSuccess1 > 0 && dbSuccess2 > 0) {
 				out.println("<script>alert('�亯 ����� ���������� �Ϸ��Ͽ����ϴ�.');</script>");
 				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
 			} else {
 				out.println("<script>alert('Sorry.............. Check Error..... and Please, try again.. ');</script>");
 			}
 			
	 	} else {
	 		out.println("���� ���� ���� �� ���� �߻�");
	 	}
		
	 } catch(IOException e) {
	 	out.println("IOException : " + e.getMessage());
	 } catch(Exception e) {
	 	out.println("Exception : " + e.getMessage());
	 }
%>
