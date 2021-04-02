<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>
<%@ page import="java.io.*, java.util.*" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="kr.co.kcc.pf.ejb.EJBExtendException" %>

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
	String savePath = null; // ���� ���
	int sizeLimit = 0; // ���ε� ���� ũ��
	String reqID = null; // �䱸 ID
	String reqBoxID = null; // �䱸�� ID
	String ansType = null; // �亯 ����
	String originFile = null; // ���� ������
	String pdfFile = null; // PDF ���ϸ�
	String matType = null; // ��ü ����
	String sendWay = null; // �߼� ����
	String ansOpinion = null; // ���� �ǰ�
	String realSavePath = null; // ������ ����� ������ ���� ���(Windows���)
	String nowYear = null; // �ý����� ���� �⵵
	String idxFileName = null; // ����� txt ���ϸ�
	String msgDigest = null; // Msg Digest
	String aSignFile = null; // ���ڼ��� ���� ���� ����
	String openCL = null; // ��������
	String ansrID = null; // �Է��� ID
	
	Vector param = new Vector(); // ���ڹ����� ���� �ʿ������, �����ڹ���, �ش����ƴ��� ��쿡�� �� ���������� �ٷ� INSERT
	
	try {
	
		CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
		FileUtil fuBean = new FileUtil();
	 
		savePath = EnvConstants.WIN_TEMP_SAVE_PATH; // ���� ���� ���. ���߿��� ��򰡿� �����Ǿ�������
		
		// ���� �����ϰ��� �ϴ� ������ ������ �ȵ� ��쿡�� ���������
		FileUtil.prepareFolder(savePath);
		
		// ������ ���ϵ��� �뼭���� �ʰڴ�!
		fuBean.DeloldFile(savePath);
		
		// ���߿� ��� �� ����� ���� ������ ���ؼ� �̸� ���� ���´�. ���� �����ٰ�!!!
		Calendar now = Calendar.getInstance();
 		nowYear = String.valueOf(now.get(Calendar.YEAR));
		
		sizeLimit = 50 * 1024 * 1024 ; // 50�ް������� ������ ������ �ְڴ�. ���� �� �ټ��� ������...
		
		MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, "EUC-KR");
		// MultipartRequest �� Ư¡�̶� �ϸ�... ���� �����ϴ� �����̶� �ϸ�...
		// ��ü�� ������ ���ÿ� �ش��ϴ� ������ ���ε带 ���ÿ� �����Ѵٶ�� ���̴�.
		// ��Ÿ���... �ʿ�� �ϴ� �Ķ���͸� �и���Ű��� ���� �̹� ������ �ö󰡹�����..
		// ��ĩ �߸� �ϸ� �������� ���ϵ��� ��������� ���ܳ� ���� ���� ������ �ϴ�.. ���.. 
		// ��! �ڵ��̳� ������ ���ڱ���~ �׷��ڱ���~
		
		reqID = multi.getParameter("CommReqID");
		reqBoxID = multi.getParameter("ReqBoxID");
		ansType = multi.getParameter("ansType");
		ansOpinion = multi.getParameter("ansOpinion");
		openCL = multi.getParameter("openCL");
		ansrID = multi.getParameter("ansrID");
		
		// �䱸ID�� NULL�̸� �ȵȴ�. �����~~. �ٸ� �͵� �߿����� ���� �ȵǴ� �͵��� �ִ�. üũ����.
		if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqID))) {
			out.println("�䱸 ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
		 	//throw new EJBExtendException("�䱸 ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
	 	} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(ansType))) {
			out.println("���õ� �亯 ������ �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
			//throw new EJBExtendException("���õ� �亯 ������ �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
		} else if ("".equalsIgnoreCase(StringUtil.getEmptyIfNull(reqBoxID))) {
			out.println("�䱸�� ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
			//throw new EJBExtendException("�䱸�� ID�� �����ϴ�. �亯�� �����Ͻ� �� �����ϴ�.");
	 	}
	 	
	 	// ���� ������ ���� �Ķ���͸� �����ϰ� ������ ���μ����� ó���ϵ��� ����
	 	if (CodeConstants.ANS_MTD_ELEC.equalsIgnoreCase(ansType)) { // '���� ����'�� ���
	 		
	 		originFile = multi.getFilesystemName("originFile");
	 		pdfFile = multi.getFilesystemName("pdfFile");
	 		
	 		msgDigest = objAnsInfo.getMsgDigest(savePath+pdfFile);

			out.println("<form method='post' name='autoForm' action=''>\n");
			out.println("<input type='hidden' name='signData' value=''>\n");
			out.println("<input type=\"hidden\" name=\"ReqBoxID\" value=\""+reqBoxID+"\">\n");
			out.println("<input type=\"hidden\" name=\"ReqID\" value=\""+reqID+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansType\" value=\""+ansType+"\">\n");
			out.println("<input type=\"hidden\" name=\"originFile\" value=\""+originFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"pdfFile\" value=\""+pdfFile+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansOpinion\" value=\""+ansOpinion+"\">\n");
			out.println("<input type=\"hidden\" name=\"openCL\" value=\""+openCL+"\">\n");
			out.println("<input type=\"hidden\" name=\"ansrID\" value=\""+ansrID+"\">\n");
			out.println("</form>\n");
			out.println("<DIV id=\"loadingDIV\" style=\"position:relative; left:0px;top:0px;width:500; z-index:1; border-width:0px; border-style:none; display:none; \">");
			out.println("<CENTER><p><br></p><p><br></p><p><br></p><p><br></p>");
			out.println("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" style=\"border:1px solid #c0c0c0\">");
			out.println("<tr><td width=\"250\" height=\"100\" align=\"center\"><img src=\"/reqsubmit/image/loading6.gif\" border=\"0\"></td>");
			out.println("</tr></table></DIV></CENTER>");
%>
<html>
<head>
<title>NADS</title>
<script language="vbscript" src="/js/activex.vbs"></script>
<script language="javascript" src="/js/axkcase.js"></script>
<script language="javascript">
	function NADSEncryptDigest() {
		var encdigetdata;
		if(!CheckAX()) {
			alert("Ŭ���̾�Ʈ ���α׷��� ��ġ���� �ʾ� ������ �� �����ϴ�.");
			return;
		}
		var dn = document.AxKCASE.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return false;
		}
		encdigetdata = document.AxKCASE.EncryptedDigest(dn, "", '<%= msgDigest %>');
		
		if((encdigetdata == null) || (encdigetdata == "")) {
			if(document.AxKCASE.GetErrorCode() != -1) alert(document.AxKCASE.GetErrorContent());
			return;
		}
		
		autoSubmit(encdigetdata);
	}
	
	function autoSubmit(str) {
		var f = document.autoForm;
		f.signData.value = str;
		f.action = "SCommAnsInfoWriteProc2.jsp";
		f.submit();		
		document.all.loadingDIV.style.display = '';
	}
</script>
</head>

<body onLoad="javascript:NADSEncryptDigest();">

<script language="javascript" src="/js/AxNAROK2.js"></script>

</body>

</html>

<%
	 	} else if (CodeConstants.ANS_MTD_ETCS.equalsIgnoreCase(ansType)) { // '������ ����' �� ���
	 	
	 		matType = multi.getParameter("matType");
			sendWay = multi.getParameter("sendWay");
			
			//System.out.println("�߼� ��� : " + sendWay);
			
			// ���ϸ����� ������ �亯 ID�� ������ �ѹ��� �޾ƿ���.
	 		String ansInfoID = objAnsInfo.getSeqNextVal("TBDS_ANSWER_INFO");
	 		
	 		// insertAnswerInfo parameter Vector
	 		param.add(ansInfoID); 				// 1
			param.add(reqID); 					// 2
			param.add(""); 							// 3
			param.add(ansrID); 					// 4
			param.add(ansOpinion);				// 5
			param.add(ansType); 				// 6
			param.add(openCL); 					// 7
			param.add(matType);				// 8 - ��ü ����
			param.add(sendWay);				// 9 - �߼� ���
			
			int dbSuccess = objAnsInfo.insertAnswerInfo(param);
			
			if (dbSuccess > 0) {
				out.println("<script>alert('������ ���� �亯 ������ ���������� �Ϸ��Ͽ����ϴ�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
			} else {
				out.println("<script>alert('oh.. sorry.. Please, Check the Error Message.....T_T');</script>");
			}
				 	
	 	} else if (CodeConstants.ANS_MTD_NONE.equalsIgnoreCase(ansType)) { // '�ش�������'�� ���
	 	
	 		// ���ϸ����� ������ �亯 ID�� ������ �ѹ��� �޾ƿ���.
	 		String ansInfoID = objAnsInfo.getSeqNextVal("TBDS_ANSWER_INFO");
	 		
	 		// insertAnswerInfo parameter Vector
	 		param.add(ansInfoID); 				// 1
			param.add(reqID); 					// 2
			param.add(""); 							// 3
			param.add(ansrID); 					// 4
			param.add(ansOpinion);				// 5
			param.add(ansType); 				// 6
			param.add(openCL); 					// 7
			param.add("");				// 8 - ��ü ����
			param.add("");				// 9 - �߼� ���
			
			int dbSuccess = objAnsInfo.insertAnswerInfo(param);
			
			if (dbSuccess > 0) {
				out.println("<script>alert('�䱸 ���뿡 �ش��ϴ� ����� �ƴ��� �뺸�Ͽ����ϴ�.');</script>");
				out.println("<meta http-equiv='refresh' content='0; url=SMakeReqInfoVList.jsp?ReqID="+reqID+"&ReqBoxID="+reqBoxID+"'>");
			} else {
				//throw new EJBExtendException("oh.. sorry.. Please, Check the Error Message.....T_T");
				out.println("oh.. sorry.. Please, Check the Error Message.....T_T");
			}
	 	
	 	} else { // �� ���� ��� ����� ������ �������������~
			//throw new EJBExtendException("�����Ͻ� �亯 ������ �������� �ʽ��ϴ�.");
			out.println("�����Ͻ� �亯 ������ �������� �ʽ��ϴ�.");
	 	}

	 } catch(IOException e) {
	 	//throw new EJBExtendException("IOException : " + e.getMessage(), e);
		out.println(e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	 } catch(Exception e) {
	 	//throw new EJBExtendException("Exception : " + e.getMessage(), e);
		out.println(e.getMessage());
		System.out.println(e.getMessage());
		e.printStackTrace();
	 }
%>
