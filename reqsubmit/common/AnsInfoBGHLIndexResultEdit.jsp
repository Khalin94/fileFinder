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
					strDBInsertPDFPath = "변환에러";
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp][ERROR] 회의자료함 strDBInsertPDFPath =" + strDBInsertPDFPath);
					
					// 회의자료등록함 PDF 파일패스에 [에러정보] 입력 
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
					strDBInsertPDFPath = "변환에러";
					
					// PDF 파일패스 등록
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] 바인딩 strDBInsertPDFPath =" + strDBInsertPDFPath);
					 objSubmtDataDelegate.GovConnectBindingDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					
				}
		}else{
				/** 해당 Type에 따른 param 값 설정 */
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
				
				
				/** 해당 테이블 업데이트 */
				int intResult = 0;
				if ("TXT".equalsIgnoreCase(strCmd)) {
					AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
					intResult = objSMAIDelegate.setRecordAnsInfoBGHLIndexFlag(strAnsID, strStatus);
					
				}else if("GOV".equalsIgnoreCase(strCmd)){
					SGovSubmtDataDelegate objSobmtDataDelegate = new SGovSubmtDataDelegate();
					strDBInsertPDFPath = strNowYear + "/etc/pdf_" + strGovSubmtID + ".pdf" ;
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] 정부제출자료함 strDBInsertPDFPath =" + strDBInsertPDFPath);
					
					// 회의자료등록함 PDF 파일패스 등록
					intResult = objSobmtDataDelegate.GovSubmtDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					
				}else if("BINDING".equalsIgnoreCase(strCmd)){
					
					bindDelegate objSubmtDataDelegate = new bindDelegate();
					//strDBInsertPDFPath = strNowYear + "/" + strSaveFolder + "/pdf_" + strGovSubmtID + ".pdf" ;
					strDBInsertPDFPath =  strSaveFolder + "/pdf_" + strGovSubmtID + ".pdf" ;
					
					// PDF 파일패스 등록
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] 바인딩 strDBInsertPDFPath =" + strDBInsertPDFPath);
					intResult = objSubmtDataDelegate.GovConnectBindingDBPDFFileFieldUpdate(strGovSubmtID,strDBInsertPDFPath);
					//System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] 바인딩 0 이면 에러 1이상이 나와야함 : intResult =" + intResult);
				
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
		            
		            /** IDX파일 다운로드 */
					String strTextFileName = "IDX_" + strGovSubmtID + ".txt" ;
					String strUnixCopyIDXFilePath = EnvConstants.UNIX_TEMP_SAVE_PATH + strTextFileName;
					//System.out.println("[src] = " + strTextFileName + " [to] " + strUnixCopyIDXFilePath);
					//System.out.println("****** FTP 정부 제출자료 IDX 파일 다운로드 **********");
					intResult = objFTP.getFile(strTextFileName,strUnixCopyIDXFilePath);
					
					if(intResult < 0){
						//System.out.println("**** FTP 정부 제출자료 IDX파일 업로드 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("정부 제출자료 IDX파일 업로드 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					}
					 //System.out.println("****** FTP 정부 제출자료 IDX 파일 다운로드완료 **********");
				 
					  /** 다운로드된  IDX파일을 SRC 폴더로 이동 **/
					 String strFromIDXFilePath =  EnvConstants.UNIX_TEMP_SAVE_PATH  + strTextFileName;
					 String strToIDXPath 	   =  EnvConstants.UNIX_SAVE_PATH +  strNowYear + "/etc/" + strTextFileName;
					 /*
					 System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] IDX 파일 Move [TO] strFromIDXFilePath =" + strFromIDXFilePath);
					 System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] IDX 파일 Move [SRC] strToIDXPath =" + strToIDXPath);
					 System.out.println(" IDX 파일 이동 [From] = " + strFromIDXFilePath + " [To] " + strToIDXPath);
					 System.out.println("****** FTP 정부 제출자료 IDX 파일 ROOT 폴더로 MOVE 시작  **********");
					 */
					 int intResutl = FileUtil.moveFile(strFromIDXFilePath,strToIDXPath);
					 
					 if(intResult < 0){
					 	System.out.println("**** FTP 정부 제출자료 IDX파일 Root폴더로 복사 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("정부 제출자료 IDX파일 Root폴더로 복사 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					 }			 
					 /*
					 System.out.println("****** FTP 정부 제출자료 IDX 파일 ROOT 폴더로 MOVE 성공  **********");					
					 System.out.println("****** FTP 업로드된 정부 제출자료 PDF 파일 삭제 준비 **********");			 
					 */
					 /**WORKFLOW 서버로 업로드된 PDF파일 삭제 */
					 String strDeletPDFFileName = strSaveFileName;
					 //System.out.println(" FTP 파일 삭제 = " + strDeletPDFFileName);
					 intResult  = objFTP.deleteFile(strDeletPDFFileName);
					 if(intResult < 0){
						System.out.println("**** FTP 업로드된 정부 제출자료 PDF파일 삭제 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP 업로드된 정부 제출자료 PDF파일 삭제 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 //System.out.println("****** FTP 업로드된 정부 제출자료 PDF 파일 삭제 완료 **********");			 
					 
					 /** WORKFLOW 서버에 생성된  IDX 파일 삭제 */
					//System.out.println("****** FTP 업로드된 정부 제출자료 IDX 파일 삭제 준비 **********");	
					intResult =  objFTP.deleteFile(strTextFileName);
					if(intResult < -1){
						System.out.println("**** FTP  업로드된 정부 제출자료  IDX 파일 삭제 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP 업로드된 정부 제출자료 IDX 파일 삭제 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%				
						return;
					}
				    //System.out.println("****** FTP 업로드된 정부 제출자료 IDX 파일 삭제 성공 **********");	
				    
					 
				} else if("BINDING".equalsIgnoreCase(strCmd)){
				
					FTPCommand objFTP = new FTPCommand();
			        objFTP.ftpConnect(EnvConstants.getFtpIpAddress(), EnvConstants.getFtpUserID(), EnvConstants.getFtpPassword());
			        
			        /** BINDING된 PDF 파일 다운로드 */
					String strBindedPDFFileName = "pdf_" + strGovSubmtID + ".pdf" ;
					String strFTPPDFFilePath = "/Binder/" + strSaveFileName + ".pdf";
					//String strUnixCopyIDXFilePath = EnvConstants.UNIX_SAVE_PATH + strNowYear + "/" + strSaveFolder + "/" + strBindedPDFFileName;
				    String strUnixCopyIDXFilePath = EnvConstants.UNIX_SAVE_PATH +  "/" + strSaveFolder + "/" + strBindedPDFFileName;
					System.out.println("바인딩 [src] = " + strFTPPDFFilePath + " [to] " + strUnixCopyIDXFilePath);
					System.out.println("****** 바인딩된 파일 FTP 다운로드 시작 **********");
					intResult = objFTP.getFile(strFTPPDFFilePath,strUnixCopyIDXFilePath);

					if(intResult < 0){
						System.out.println("****  바인딩된 파일 FTP 다운로드 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg("바인딩된 파일 FTP 다운로드 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						 return ;
					}
					
					 /**WORKFLOW 서버의 바인딩작업한  PDF, XTOC 파일 삭제 */
					 String strDeletPDFFileName = "/Binder/" + strSaveFileName + ".pdf";
					 String strDeletXTOCFileName = "/Binder/" + strXtocFileName ;
					 //System.out.println(" FTP 파일 삭제 = " + strDeletPDFFileName);
					 //System.out.println(" XTOC 파일 삭제 = " + strDeletXTOCFileName);
					 intResult  = objFTP.deleteFile(strDeletPDFFileName);			
					 if(intResult < 0 ){
						System.out.println("**** FTP 업로드된 정부 제출자료 PDF파일 삭제 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP 업로드된 정부 제출자료 PDF파일 삭제 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 
					 intResult = objFTP.deleteFile(strDeletXTOCFileName);
					 if(intResult < 0 ){
						System.out.println("**** FTP 업로드된 정부 제출자료 XTOC파일 삭제 실패 ****");
						objMsgBean.setMsgType(MessageBean.TYPE_WARN);
						objMsgBean.setStrCode("");
						objMsgBean.setStrMsg(" FTP 업로드된 정부 제출자료 XTOC파일 삭제 실패");
						%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
						<%
						return ;
					 }
					 
					 //System.out.println("****** FTP 업로드된 정부 제출자료 PDF 파일 삭제 완료 **********");			 
				
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
							System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] 답변 ID "+strAnsID+"의 처리를 정상적으로 완료했습니다.");
						} // end if (boolCP1 && boolCP2)
					} // end if (intGetResult1 == 1 && intGetResult2 == 1)
				}
				
		} 
	} catch(Exception e) {
		System.out.println("[AnsInfoBGHLIndexResultEdit.jsp] Exception : " + e.getMessage());
		e.printStackTrace();
	}
%>