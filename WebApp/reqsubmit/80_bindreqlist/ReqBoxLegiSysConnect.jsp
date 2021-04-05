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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.binder.bindDelegate"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String[] strLegiConnArray ;	
	
	String strReqBoxID = null;
  	String strReqDataNm = null;
  	String strRegerID = null;
  	String strRegDT = null;
	String strPDFFilePath = null;
	String strConnect = null;
	
	String strBindingSortField = null;
	String strBindingSortMtd = null;	
	String strCurrentPageNum = null;
	String strSubmtOrgNm = null;
	String strReqOrgNm = null;

	int intCurrentPageNum = 0;
	int intResult = -1;
	int intExtractResult = -1;
	
	ArrayList objMeta = null;

	String	GOV_LEGI_CONNECT = "Y";	

	
	Hashtable objHash = null;
		
		
/******************* PARAM ��  *****************************************************************/	
/********************************************************************************************************/	
	//�����ý��� �������̺� ID	
	strLegiConnArray = request.getParameterValues("LegiConn");
	
	// sort �ʵ�
	strBindingSortField = request.getParameter("strBindingSortField");
	System.out.println("[ReqBoxLegiSysConnect.jsp] strBindingSortField = " + strBindingSortField);
	// sort ����
 	strBindingSortMtd= request.getParameter("strBindingSortMtd");
	System.out.println("[ReqBoxLegiSysConnect.jsp] strBindingSortMtd = " + strBindingSortMtd);
	// ���� ������ ��ȣ �ޱ�.
	strCurrentPageNum = request.getParameter("strBindingPageNum");
	if(strCurrentPageNum == null || strCurrentPageNum.equals("")){
		strCurrentPageNum = "1";
	}
	Integer objIntD = new Integer(strCurrentPageNum);
	intCurrentPageNum = objIntD.intValue();
	System.out.println("[ReqBoxLegiSysConnect.jsp] intCurrentPageNum = " + intCurrentPageNum);
	// ������
	strSubmtOrgNm = request.getParameter("strSubmtOrgNm");
	System.out.println("[ReqBoxLegiSysConnect.jsp] strSubmtOrgNm = " + strSubmtOrgNm);
	// �䱸���
	strReqOrgNm = request.getParameter("strReqOrgNm");
	System.out.println("[ReqBoxLegiSysConnect.jsp] strReqOrgNm = " + strReqOrgNm);
/********************************************************************************************************/	
/********************************************************************************************************/	

	bindDelegate objBinding = new bindDelegate();
	objMeta = new ArrayList();
	boolean blnCheck = true;
	
	/**���뿬��� temp ���� �н�*/
	String strLegiConnTempFilePath = EnvConstants.UNIX_SAVE_PATH + "ReqBindTemp/";
	System.out.println("�����ý��ۿ��� ���� ����  = " + strLegiConnTempFilePath);
	FileUtil.prepareFolder(strLegiConnTempFilePath);
	
	if (strLegiConnArray != null)
	{
		int intlength = strLegiConnArray.length ;
		String strGovSubmtId = null;		
		System.out.println("[ GovSubDataBoxLegiConnect.jsp ] intlength =" + intlength);
		
		for(int i = 0; i < intlength ; i++){
			strGovSubmtId = strLegiConnArray[i];
			System.out.println(" ���������ý��� ���� ID  =" + strGovSubmtId );
			
			objHash = objBinding.getConnectBindingListInfo(strGovSubmtId);
			
			strReqBoxID = (String)objHash.get("REQ_BOX_ID");
			objMeta.add(strReqBoxID);
  			strReqDataNm = (String)objHash.get("DATA_NM");
  			objMeta.add(strReqDataNm);
  			strRegerID = (String)objHash.get("REGR_ID");
  			objMeta.add(strRegerID);
  			strRegDT = (String)objHash.get("REG_DT");
  			objMeta.add(strRegDT);
			strPDFFilePath	= (String)objHash.get("PDF_FILE_PATH");
			//objMeta.add(strPDFFilePath);
			strConnect  = (String)objHash.get("AUDIT_SYS_REL_FLAG");
			objMeta.add(strReqOrgNm);
			objMeta.add(strSubmtOrgNm);

			/** BINDING�� PDF ���� ����*/		   
		    String strPDFFileName = FileUtil.getFileName(strPDFFilePath,"/");		   
			String strCopyPDFFilePath = strLegiConnTempFilePath + strPDFFileName;
			String strSrcBindingFilePath = EnvConstants.UNIX_SAVE_PATH + strPDFFilePath;
			System.out.println("[GovSubDataBoxLegiConnect.jsp][SRC] strSrcBindingFilePath = " + strSrcBindingFilePath);
			System.out.println("[GovSubDataBoxLegiConnect.jsp][TO] strCopyPDFFilePath = " + strCopyPDFFilePath);			
			 
			blnCheck = FileUtil.copyFile(strSrcBindingFilePath,strCopyPDFFilePath);
			if(!blnCheck){
			 	break;
			}
			
			int intMetaCopyDone = objBinding.CreateMetaFileBindingLegiConnectTempFolder(objMeta,strGovSubmtId);
			if(intMetaCopyDone < 0 ){
				System.out.println("  Meta ���� ������  Copy ���� ");
				blnCheck = false;
				break;
			}else{
				System.out.println("  Meta ���� ������  Copy ����  ");
			}
			
			intResult =  objBinding.GovConnectBindingConnectFieldUpdate(strGovSubmtId);
			if(intResult < 0){
				System.out.println(" �������翬�輺���� ������Ʈ�� �������Ͽ����ϴ�.");
				blnCheck = false;
				break;
			}else{
   				System.out.println("�������翬�輺���� ������Ʈ ���� �Ͽ����ϴ�.");   			
			}
			
			for(int j = 0 ; j < objMeta.size() ; j ++ ){
				objMeta.remove(i);
			}
		}		
	}
%>
<%
	if(blnCheck || intExtractResult > 0){
%>
<html>
<script language="JavaScript">
	function init(){
		alert("��������ý��ۿ��� ���� ");
		formName.submit();
	}
</script>
<body onLoad="init()">
				<form name="formName" method="get" action="./ReqBoxLegiSysConnectList.jsp">				   
					<input type="hidden" name="strGovSubmtDataPageNum" value="<%=strCurrentPageNum%>">
					<input type="hidden" name="strGovSubmtDataSortField" value="<%=strBindingSortField%>">
					<input type="hidden" name="strGovSubmtDataSortMtd" value="<%=strBindingSortMtd%>">
				</form>
</body>
</html>
<%
	} else {
		 objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		 //objMsgBean.setStrCode("DSDATA-0010"); //���ϻ��� ����		
		 objMsgBean.setStrCode(""); //���ϻ��� ����		
		 objMsgBean.setStrMsg("���������ý��� ���� ���� ");	
%>
		 <jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	}
%>