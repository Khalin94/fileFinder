<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.reqsubmit.uniflow.UniFlowWrapper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.govSubmtData.SGovSubmtDataDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%  // ���� 
	String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
	strUserID = "tester2";
%>
<%
	String[] strLegiConnArray ;
	String strPdfPath = null;
	String strOrgPath = null;
	String strTocPath = null;
	int intResult = -1;
	int intExtractResult = -1;
	String	GOV_LEGI_CONNECT = "Y";
	
	strLegiConnArray = request.getParameterValues("LegiConn");
	String strAnsSubmtQryTerm = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryTerm"));
	String strAnsSubmtQryField = StringUtil.getEmptyIfNull((String)request.getParameter("strAnsSubmtQryField"));
	String strGovSubmtDataSortField = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortField"));
	String strGovSubmtDataSortMtd = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataSortMtd"));
    String strGovSubmtDataPageNum = StringUtil.getEmptyIfNull((String)request.getParameter("strGovSubmtDataPageNum"));
		
	SGovSubmtDataDelegate objGovSubmtData = new SGovSubmtDataDelegate();
	//StringUtil objStringUtil = new StringUtil();
	//FileUtil  objFile = new FileUtil();
	boolean blnCheck = true;
	
	/**���뿬��� temp ���� �н�*/
	String strLegiConnTempFilePath = EnvConstants.UNIX_SAVE_PATH + "LegiConnTemp/";    //EnvConstants.FILE_SERVER_ROOT_DIRECTORY_SLASH + "LegiConnTemp/";
	//System.out.println("���뿬�� ���� ����  = " + strLegiConnTempFilePath);
	FileUtil.prepareFolder(strLegiConnTempFilePath);
	UniFlowWrapper objWorkFlowWrapper = new UniFlowWrapper();
	

	if (strLegiConnArray != null)
	{
		int intlength = strLegiConnArray.length ;
		String strGovSubmtId = null;		
		//System.out.println("[ GovSubDataBoxLegiConnect.jsp ] intlength =" + intlength);
		
		for(int i=0; i<intlength ; i++) {
			strGovSubmtId = strLegiConnArray[i];
			//System.out.println(" ���������ڷ� id  =" + strGovSubmtId );

			Hashtable objHash = objGovSubmtData.getGovSubmtDataLegiConnFileInfo(strGovSubmtId);

			String strGovGbn = (String)objHash.get("SUBMT_DATA_GBN");
		    //System.out.println("[GovSubDataBoxLegiConnect.jsp] strGovGbn =" + strGovGbn);						

			/** INDEX ���� ����*/
		    String strIdxFilePath =  (String)objHash.get("INX_FILE_PATH");			 			
		    String strIdxFileName = FileUtil.getFileName(strIdxFilePath,"/");				 				 
			String strCopyIdxFilePath = strLegiConnTempFilePath + strIdxFileName;
			//System.out.println("[GovSubDataBoxLegiConnect.jsp][TO] strCopyIdxFilePath = " + strCopyIdxFilePath);
			//System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strIdxFileName = " + strIdxFileName);
			 
			 blnCheck = FileUtil.copyFile(strIdxFilePath,strCopyIdxFilePath);
				 
			 if(!blnCheck){				 	
			 	break;
			 }

			int intMetaCopyDone = objGovSubmtData.CreatMetaDataAndCopyLegiConnectFolder(strGovSubmtId);
			if(intMetaCopyDone < 0 ){
				//System.out.println("  Meta ���� ������  Copy ���� ");
			}else{
				//System.out.println("  Meta ���� ������  Copy ����  ");
			}
			
			// ����� ,���� �ϰ�� ,��ݰ��
			if( strGovGbn == "002" || strGovGbn.equals("002") || strGovGbn == "003" || strGovGbn.equals("003") || strGovGbn == "006" || strGovGbn.equals("006")){
				 //System.out.println("����� ,���� �ϰ��  ");
				 
				 //PDF
				 strPdfPath = EnvConstants.UNIX_SAVE_PATH + (String)objHash.get("APD_PDF_FILE_PATH");				 
				 //strPdfPath = FileUtil.getFileSeparatorPath(strPdfPath);
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strPdfPath =" + strPdfPath);			 				 
				 String strPdfPathName = FileUtil.getFileName(strPdfPath,"/");
				 			 
				 String strPDFTempPath = strLegiConnTempFilePath + strPdfPathName;				 
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] " + strPdfPath  + "-> [TO] " + strPDFTempPath);
				 
				 blnCheck = FileUtil.copyFile(strPdfPath,strPDFTempPath); 				 				 
				 if(!blnCheck){				 	
				 	break;
				 }
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp] pdf ���� ���� �Ϸ�");
				 
				 
				 //���� ����
				 strOrgPath = EnvConstants.UNIX_SAVE_PATH + (String)objHash.get("APD_ORG_FILE_PATH");				 
				 //strOrgPath = FileUtil.getFileSeparatorPath(strOrgPath);
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strOrgPath =" + strOrgPath);				 				 
				 String strOrgPathName = FileUtil.getFileName(strOrgPath,"/");
				 String strORGTempPath = strLegiConnTempFilePath + strOrgPathName;
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][TO]strORGTempPath =" + strORGTempPath);
				 blnCheck = FileUtil.copyFile(strOrgPath,strORGTempPath);
				 if(!blnCheck){				 	
				 	break;
				 }				 
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp] �������� ���� �Ϸ�");
				  
				 //TOC ����
				 strTocPath= EnvConstants.UNIX_SAVE_PATH + (String)objHash.get("APD_TOC_FILE_PATH");
				 //strTocPath = FileUtil.getFileSeparatorPath(strTocPath);
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strTocPath =" + strTocPath);
				 String strTocPathName = FileUtil.getFileName(strTocPath,"/");
				 String strTOCTempPath = strLegiConnTempFilePath + strTocPathName;
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][TO] strTOCTempPath =" + strTOCTempPath);
				 blnCheck = FileUtil.copyFile(strTocPath,strTOCTempPath);
				 if(!blnCheck){				 	
				 	break;
				 }	
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp] TOC���Ϻ��� �Ϸ�");

			}else{ // ����� ,����, ��ݰ�� �̿��� �������
			
				 //System.out.println("����� ,���� �̿��� ���̴�. ");
				 strPdfPath =  EnvConstants.UNIX_SAVE_PATH + (String)objHash.get("APD_PDF_FILE_PATH");				 				 				 
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strPdfPath =" + strPdfPath);
				 //strPdfPath = objFile.getFileSeparatorPath(strPdfPath);
				 String strPdfPathName = FileUtil.getFileName(strPdfPath,"/");				 				 
				 String strPDFTempPath = strLegiConnTempFilePath + strPdfPathName;				 
				 //System.out.println("[GovSubDataBoxLegiConnect.jsp][TO] strPDFTempPath =" + strPDFTempPath);
				 
				 blnCheck = FileUtil.copyFile(strPdfPath,strPDFTempPath);
				 
				 if(!blnCheck){				 	
				 	break;
				 }
 				 //System.out.println("[GovSubDataBoxLegiConnect.jsp] pdf ���� ���� �Ϸ�");

			}
						
			Vector objParam = new Vector();
			objParam.add(GOV_LEGI_CONNECT);
			objParam.add(strGovSubmtId);
					
			intResult =  objGovSubmtData.getGovSubmtDataLegiConnUdpate(objParam);
			if(intResult < 0){
				System.out.println(" ������Ʈ�� �������Ͽ����ϴ�.");
				blnCheck = false;
				break;
			}else{
   				//System.out.println(" ������Ʈ ������");   			
			}
		}		
	}

	if(blnCheck || intExtractResult > 0){
%>

<html>
<script language="JavaScript">
	function init(){
		alert("�Թ����սý��ۿ� ��ϵǾ����ϴ� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="get" action="./SGovSubDataBoxList.jsp">
				    <input type="hidden" name="strAnsSubmtQryField" value="<%=strAnsSubmtQryField%>">
					<input type="hidden" name="strAnsSubmtQryTerm" value="<%=strAnsSubmtQryTerm%>">
					<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strGovSubmtDataPageNum%>">
					<input type="hidden" name="strGovSubmtDataSortField" value="<%=strGovSubmtDataSortField%>">
					<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strGovSubmtDataSortMtd%>">
				</form>
</body>
</html>

<%
	} else {
		 objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		 objMsgBean.setStrCode("DSDATA-0010"); //���ϻ��� ����		
%>
		 <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
%>