<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="nads.lib.reqsubmit.ftp.FTPCommand" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	try {
		String strJobID = request.getParameter("JOBID");
		String strStatus = request.getParameter("STAT");
		strStatus = strStatus.substring(0, 1);
		if ("-".equalsIgnoreCase(strStatus)) strStatus = "-1";
		String strParam = request.getParameter("PARAM");
		String strErrorMsg = request.getParameter("ERROR");
		
		String[] arrParam = StringUtil.split("^", strParam);
		String strCmd = String.valueOf(arrParam[0]);
		String strAnsID = null;
		String strNowYear = null;
		String strReqBoxID = null;
		String strSaveFileName = null;
		String strAnsFileID = null;
		
		
		String strSaveFolder = null;
		String strGovSubmtID = null;
		String strDBInsertPDFPath = null;
		String strXtocFileName = null;
		//System.out.println(" [AnsInfoBGHLIndexResultEdit.jsp] strCmd = " + strCmd);
		
		if(strCmd.equalsIgnoreCase("ERROR")){
			String strCmdData = String.valueOf(arrParam[1]);
				if(strCmdData.equals("GOV")){
				
		            strSaveFileName    = String.valueOf(arrParam[2]);
				   	strNowYear    = String.valueOf(arrParam[3]);
				   	strSaveFolder =	String.valueOf(arrParam[4]);
				   	strGovSubmtID =  String.valueOf(arrParam[5]);
				   	
				   	/*
				   	System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strSaveFileName : "+strSaveFileName);	
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strNowYear : "+strNowYear);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strSaveFolder : "+strSaveFolder);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strGovSubmtID : "+strGovSubmtID);
					*/
					
					SGovSubmtDataDelegate objSobmtDataDelegate = new SGovSubmtDataDelegate();
					strDBInsertPDFPath = "��ȯ����";
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] ȸ���ڷ��� strDBInsertPDFPath =" + strDBInsertPDFPath);
					
					// ȸ���ڷ����� PDF �����н��� [��������] �Է� 
				     objSobmtDataDelegate.GovSubmtDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					
				}else if(strCmdData.equals("BINDING")){
				
				    strSaveFileName    = String.valueOf(arrParam[2]);				    
				   	strNowYear    = String.valueOf(arrParam[3]);
				   	strReqBoxID   =	String.valueOf(arrParam[4]);
				   	strSaveFolder =  String.valueOf(arrParam[5]);
				    strGovSubmtID =  String.valueOf(arrParam[6]);
				    strXtocFileName =  String.valueOf(arrParam[7]);
				    
				    /*
				    System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strSaveFileName : "+strSaveFileName);	
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strNowYear : "+strNowYear);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strReqBoxID : "+strReqBoxID);			
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] strSaveFolder : "+strSaveFolder);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] stGovSubmtID : "+strGovSubmtID);
					*/
					
					bindDelegate objSubmtDataDelegate = new bindDelegate();
					strDBInsertPDFPath = "��ȯ����";
					
					// PDF �����н� ���
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] ���ε� strDBInsertPDFPath =" + strDBInsertPDFPath);
					 objSubmtDataDelegate.GovConnectBindingDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					
				}
		}else{
				/** �ش� Type�� ���� param �� ���� */
				if("TXT".equalsIgnoreCase(strCmd) || "IDX".equalsIgnoreCase(strCmd)){
					strAnsID = String.valueOf(arrParam[1]);
					strNowYear = String.valueOf(arrParam[2]);
					strReqBoxID = String.valueOf(arrParam[3]);
					strSaveFileName = String.valueOf(arrParam[4]);
					strAnsFileID = String.valueOf(arrParam[5]);			
				}else if("GOV".equalsIgnoreCase(strCmd)){
		  		   /* "GOV^" + PDFFileName + "^" +strInsertYear +"^etc^" + strSubmtDataNextID;*/
		  		    strSaveFileName    = String.valueOf(arrParam[1]);
				   	strNowYear    = String.valueOf(arrParam[2]);
				   	strSaveFolder =	String.valueOf(arrParam[3]);
				   	strGovSubmtID =  String.valueOf(arrParam[4]);
				   	
					/*
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strSaveFileName : "+strSaveFileName);	
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strNowYear : "+strNowYear);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strSaveFolder : "+strSaveFolder);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strGovSubmtID : "+strGovSubmtID);
				    */
					
				}else if("BINDING".equalsIgnoreCase(strCmd)){
		
		  		    /*"BINDING^" + strNewBindName + "^" + strYear + "^" +strReqBoxId +"^ReqBind^" + reqBindID + "^" + strXtocFileName ;*/
		  		    strSaveFileName    = String.valueOf(arrParam[1]);
				   	strNowYear    = String.valueOf(arrParam[2]);
				   	strReqBoxID =	String.valueOf(arrParam[3]);
				   	strSaveFolder =  String.valueOf(arrParam[4]);
				    strGovSubmtID =  String.valueOf(arrParam[5]);
				    strXtocFileName =  String.valueOf(arrParam[6]);
				    
				    /*
				    System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strSaveFileName : "+strSaveFileName);	
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strNowYear : "+strNowYear);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strReqBoxID : "+strReqBoxID);			
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strSaveFolder : "+strSaveFolder);
					System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] strGovSubmtID : "+strGovSubmtID);
					*/
				}
				
				String strDefaultTmpSavePath = EnvConstants.UNIX_TEMP_SAVE_PATH;
				String strDefaultRealSavePath = EnvConstants.UNIX_SAVE_PATH;
				String strNewSavePath = strDefaultRealSavePath+strNowYear+"/"+strReqBoxID+"/";
				
				
				/** �ش� ���̺� ������Ʈ */
				int intResult = 0;
				if ("TXT".equalsIgnoreCase(strCmd)) {
					AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
					intResult = objSMAIDelegate.setRecordAnsInfoBGHLIndexFlag(strAnsID, strStatus);
					
				}else if("GOV".equalsIgnoreCase(strCmd)){
					SGovSubmtDataDelegate objSobmtDataDelegate = new SGovSubmtDataDelegate();
					strDBInsertPDFPath = strNowYear + "/etc/pdf_" + strGovSubmtID + ".pdf" ;
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] ���������ڷ��� strDBInsertPDFPath =" + strDBInsertPDFPath);
					
					// ȸ���ڷ����� PDF �����н� ���
					intResult = objSobmtDataDelegate.GovSubmtDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					
				}else if("BINDING".equalsIgnoreCase(strCmd)){
					
					bindDelegate objSubmtDataDelegate = new bindDelegate();
					//strDBInsertPDFPath = strNowYear + "/" + strSaveFolder + "/pdf_" + strGovSubmtID + ".pdf" ;
					strDBInsertPDFPath =  strSaveFolder + "/pdf_" + strGovSubmtID + ".pdf" ;
					
					// PDF �����н� ���
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] ���ε� strDBInsertPDFPath =" + strDBInsertPDFPath);
					intResult = objSubmtDataDelegate.GovConnectBindingDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] ���ε� 0 �̸� ���� 1�̻��� ���;��� : intResult =" + intResult);
				
				}else {
					intResult = 1;
				}
				
				if (intResult < 1) {
					objMsgBean.setMsgType(MessageBean.TYPE_WARN);
					objMsgBean.setStrCode("");
					objMsgBean.setStrMsg("HLINDEX UPDATE PROCESS ERROR");
			%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
			<%
					return;
				}
				
				
				 if("GOV".equalsIgnoreCase(strCmd)){
							
					FTPCommand objFTP = new FTPCommand();
		            objFTP.ftpConnect(EnvConstants.getFtpIpAddress(), EnvConstants.getFtpUserID(), EnvConstants.getFtpPassword());
		            
		            /** IDX���� �ٿ�ε� */
					String strTextFileName = "IDX_" + strGovSubmtID + ".txt" ;
					String strUnixCopyIDXFilePath = EnvConstants.UNIX_TEMP_SAVE_PATH + strTextFileName;
					//System.out.println("[src] = " + strTextFileName + " [to] " + strUnixCopyIDXFilePath);
					//System.out.println("****** FTP ���� �����ڷ� IDX ���� �ٿ�ε� **********");
					intResult = objFTP.getFile(strTextFileName,strUnixCopyIDXFilePath);
					
					if(intResult < 0){
						//System.out.println("**** FTP ���� �����ڷ� IDX���� ���ε� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("���� �����ڷ� IDX���� ���ε� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					}
					 //System.out.println("****** FTP ���� �����ڷ� IDX ���� �ٿ�ε�Ϸ� **********");
				 
					  /** �ٿ�ε��  IDX������ SRC ������ �̵� **/
					 String strFromIDXFilePath =  EnvConstants.UNIX_TEMP_SAVE_PATH  + strTextFileName;
					 String strToIDXPath 	   =  EnvConstants.UNIX_SAVE_PATH +  strNowYear + "/etc/" + strTextFileName;
					 /*
					 System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] IDX ���� Move [TO] strFromIDXFilePath =" + strFromIDXFilePath);
					 System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] IDX ���� Move [SRC] strToIDXPath =" + strToIDXPath);
					 System.out.println(" IDX ���� �̵� [From] = " + strFromIDXFilePath + " [To] " + strToIDXPath);
					 System.out.println("****** FTP ���� �����ڷ� IDX ���� ROOT ������ MOVE ����  **********");
					 */
					 int intResutl = FileUtil.moveFile(strFromIDXFilePath,strToIDXPath);
					 
					 if(intResult < 0){
					 	System.out.println("**** FTP ���� �����ڷ� IDX���� Root������ ���� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("���� �����ڷ� IDX���� Root������ ���� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					 }			 
					 /*
					 System.out.println("****** FTP ���� �����ڷ� IDX ���� ROOT ������ MOVE ����  **********");					
					 System.out.println("****** FTP ���ε�� ���� �����ڷ� PDF ���� ���� �غ� **********");			 
					 */
					 /**WORKFLOW ������ ���ε�� PDF���� ���� */
					 String strDeletPDFFileName = strSaveFileName;
					 //System.out.println(" FTP ���� ���� = " + strDeletPDFFileName);
					 intResult  = objFTP.deleteFile(strDeletPDFFileName);
					 if(intResult < 0){
						System.out.println("**** FTP ���ε�� ���� �����ڷ� PDF���� ���� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP ���ε�� ���� �����ڷ� PDF���� ���� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 //System.out.println("****** FTP ���ε�� ���� �����ڷ� PDF ���� ���� �Ϸ� **********");			 
					 
					 /** WORKFLOW ������ ������  IDX ���� ���� */
					//System.out.println("****** FTP ���ε�� ���� �����ڷ� IDX ���� ���� �غ� **********");	
					intResult =  objFTP.deleteFile(strTextFileName);
					if(intResult < -1){
						System.out.println("**** FTP  ���ε�� ���� �����ڷ�  IDX ���� ���� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP ���ε�� ���� �����ڷ� IDX ���� ���� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%				
						return;
					}
				    //System.out.println("****** FTP ���ε�� ���� �����ڷ� IDX ���� ���� ���� **********");	
				    
					 
				} else if("BINDING".equalsIgnoreCase(strCmd)){
				
					FTPCommand objFTP = new FTPCommand();
			        objFTP.ftpConnect(EnvConstants.getFtpIpAddress(), EnvConstants.getFtpUserID(), EnvConstants.getFtpPassword());
			        
			        /** BINDING�� PDF ���� �ٿ�ε� */
					String strBindedPDFFileName = "pdf_" + strGovSubmtID + ".pdf" ;
					String strFTPPDFFilePath = "/Binder/" + strSaveFileName + ".pdf";
					//String strUnixCopyIDXFilePath = EnvConstants.UNIX_SAVE_PATH + strNowYear + "/" + strSaveFolder + "/" + strBindedPDFFileName;
				    String strUnixCopyIDXFilePath = EnvConstants.UNIX_SAVE_PATH +  "/" + strSaveFolder + "/" + strBindedPDFFileName;
					System.out.println("���ε� [src] = " + strFTPPDFFilePath + " [to] " + strUnixCopyIDXFilePath);
					System.out.println("****** ���ε��� ���� FTP �ٿ�ε� ���� **********");
					intResult = objFTP.getFile(strFTPPDFFilePath,strUnixCopyIDXFilePath);

					if(intResult < 0){
						System.out.println("****  ���ε��� ���� FTP �ٿ�ε� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("���ε��� ���� FTP �ٿ�ε� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					}
					
					 /**WORKFLOW ������ ���ε��۾���  PDF, XTOC ���� ���� */
					 String strDeletPDFFileName = "/Binder/" + strSaveFileName + ".pdf";
					 String strDeletXTOCFileName = "/Binder/" + strXtocFileName ;
					 //System.out.println(" FTP ���� ���� = " + strDeletPDFFileName);
					 //System.out.println(" XTOC ���� ���� = " + strDeletXTOCFileName);
					 intResult  = objFTP.deleteFile(strDeletPDFFileName);			
					 if(intResult < 0 ){
						System.out.println("**** FTP ���ε�� ���� �����ڷ� PDF���� ���� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP ���ε�� ���� �����ڷ� PDF���� ���� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 
					 intResult = objFTP.deleteFile(strDeletXTOCFileName);
					 if(intResult < 0 ){
						System.out.println("**** FTP ���ε�� ���� �����ڷ� XTOC���� ���� ���� ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP ���ε�� ���� �����ڷ� XTOC���� ���� ����");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 
					 //System.out.println("****** FTP ���ε�� ���� �����ڷ� PDF ���� ���� �Ϸ� **********");			 
				
				}else if ("IDX".equalsIgnoreCase(strCmd)) {
					
					// PDF, DOC, IDX, TXT FILE FTP GET PROCESS START
					FTPCommand objFTP = new FTPCommand();
					// FTP Connection 
					objFTP.ftpConnect(EnvConstants.getFtpIpAddress(), EnvConstants.getFtpUserID(), EnvConstants.getFtpPassword());
					// HL INDEX FILE GET
					int intGetResult1 = objFTP.getFile(strSaveFileName+".idx", strNewSavePath+strAnsFileID+".idx", 0, false);
					// TXT FILE GET
					int intGetResult2 = objFTP.getFile(strSaveFileName+".txt", strNewSavePath+strAnsFileID+".txt", 0, false);
					
					if (intGetResult1 == 1 && intGetResult2 == 1) {
						int intMoveResult1 = FileUtil.moveFile(strNewSavePath+strSaveFileName+".idx", strNewSavePath+strAnsFileID+".idx");
						int intMoveResult2 = FileUtil.moveFile(strNewSavePath+strSaveFileName+".txt", strNewSavePath+strAnsFileID+".txt");
						
						if (intMoveResult1 == 1 && intMoveResult2 == 1) {
							System.out.println("IDX, TXT File Transfer & Copy Success!!!!!!!!!");
							System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] �亯 ID "+strAnsID+"�� ó���� ���������� �Ϸ��߽��ϴ�.");
						} // end if (boolCP1 && boolCP2)
					} // end if (intGetResult1 == 1 && intGetResult2 == 1)
				}
				
		} 
	} catch(Exception e) {
		System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] Exception : " + e.getMessage());
		e.printStackTrace();
	}
%>