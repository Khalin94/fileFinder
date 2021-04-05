<%@ page language="java" contentType="text/html;charset=EUC-KR" errorPage="/reqsubmit/DefaultErrorPage.jsp"%>

<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoWriteForm" %>
<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
String _ROOT_DIR = "/mnt/nads/reqsubmit/pdf_temp";

String save_folder = _ROOT_DIR;
String real_folder = "";
String tmp_folder = "/tmp";

try {
	real_folder = save_folder;
	tmp_folder = real_folder+tmp_folder+"/";

	File fp = new File(tmp_folder);
	fp.mkdir();

	int nSizeLimit = 3*1024*1024;

	MultipartRequest multi = new MultipartRequest(request, tmp_folder, nSizeLimit, "EUC-KR", new DefaultFileRenamePolicy());

	System.out.println("ANSTIMECHEK(1) : "+this.getCurrentTime());

	UserInfoDelegate objUserInfo =null; // 이용자 정보
	CDInfoDelegate objCdinfo =null; // 시스템 변수(상수)

	SMemAnsInfoWriteForm objParamForm = new SMemAnsInfoWriteForm();
	SMemReqInfoDelegate objReqInfo = null;
	AnsInfoDelegate objSMAIDelegate = null;

	String strMsgDigest = "";
	String strOldPdfFile = "";
	String strOldDocFile = "";
	String strReqBoxID = "";
	String strPdfFileName = "";
	String strDocFileName = "";
	String strAnsFileID = "";
	String strUserDN = "";
	String strRsUserDN = "";
	String strCount = "";
	String PdfFilePath = "";
	String DocFilePath = "";
	int count = -1;
	System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// 파라미터가 정상적으로 넘어온건지 확인해보자
	boolean blnParamCheck = false;

	System.out.println("ANSTIMECHEK(2) : "+this.getCurrentTime());

	//blnParamCheck = objParamForm.validateParams(request);

	System.out.println("ANSTIMECHEK(3) : "+this.getCurrentTime());

  	//if(!blnParamCheck) {
	//	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
	//	objMsgBean.setStrCode("DSPARAM-0000");
	//  	objMsgBean.setStrMsg(objParamForm.getStrErrors());
%>
  		<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
<%
		//return;
	//} // end if

	try {
		objReqInfo = new SMemReqInfoDelegate();
		objSMAIDelegate = new AnsInfoDelegate();

		// 정상적으로 업로드가 되었습니까? 그럼 동일한 temp 폴더에서 파일명을 시퀀스에 해당하는
		// 현재 페이지의 궁극의 목적! MSG Digest 생성

		// 2004-06-04 이용자 인증서 USER DN
		strUserDN = multi.getParameter("UserDN");
		strCount = multi.getParameter("count");
		count = Integer.parseInt(strCount);
		System.out.println("objUserInfo.getUserID() : "+objUserInfo.getUserID());
		strRsUserDN = objReqInfo.getUserDN(objUserInfo.getUserID());

		System.out.println("strRsUserDN : "+strRsUserDN);
		System.out.println("strUserDN : "+strUserDN);
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

		out.println("<form  name=encForm>");
		out.println("<input type=hidden value='' name='passwd'>");
		out.println("<input type=hidden value='"+strUserDN+"' name='user_dn'>");
		out.println("<input type=hidden value='"+strUserDN+"' name='rec_dn'>");

		out.println("<input type=\"hidden\" value=\""+multi.getParameter("MatType")+"\" name=\"MatType\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("SendWay")+"\" name=\"SendWay\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("AnsType")+"\" name=\"AnsType\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("OpenCL")+"\" name=\"OpenCL\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("AnsOpin")+"\" name=\"AnsOpin\" size=\"0\">");

		String[] strFilename = multi.getParameterValues("_innods_filename");
		String[] strFilesize = multi.getParameterValues("_innods_filesize");

		/*
		 * CBC Comment
		 *---------------------------------------------------------------
		 * get the SUB_DIR
		 */
		String strFolder = multi.getParameter("_SUB_DIR");

		for(int i=0;i<strFilename.length;i++){

			strOldPdfFile = strFilename[i];
			if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
				strOldPdfFile = objSMAIDelegate.getDecryptedPdfPath(strOldPdfFile);
			}else{
				strOldDocFile = strFilename[i];
			}

			strOldPdfFile = StringUtil.ReplaceString(strOldPdfFile, "\\", "/");
			strOldDocFile = StringUtil.ReplaceString(strOldDocFile, "\\", "/");

			if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
				//strMsgDigest = objSMAIDelegate.getMsgDigest(strOldPdfFile);
				strMsgDigest = "";
			}


			out.println("<input type=\"hidden\" value=\""+strMsgDigest+"\" name=\"src"+i+"\">");
			// 답변 파일 SEQ를 여기서 미리 생성하자.
			if(i != 0 && i != 1){
				if(i%2 ==0){
					strAnsFileID = strAnsFileID + "Ω"+StringUtil.padl(objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO"), 10);
				}

				if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
					strPdfFileName = strPdfFileName+"Ω"+FileUtil.getFileName(strOldPdfFile);
					PdfFilePath = PdfFilePath+"Ω"+ strFolder + "/" + FileUtil.getFileName(strOldPdfFile, "/");
				}else{
					strDocFileName = strDocFileName+"Ω"+FileUtil.getFileName(strOldDocFile);
					DocFilePath = DocFilePath+"Ω"+ strFolder + "/" + FileUtil.getFileName(strOldDocFile, "/");  //"Ω"+
				}
			}else if(i==0 || i==1){
				if((FileUtil.getFileExtension(strOldPdfFile)).equals("pdf")||(FileUtil.getFileExtension(strOldPdfFile)).equals("PDF")){
					strPdfFileName = FileUtil.getFileName(strOldPdfFile);
					PdfFilePath = strFolder + "/" + FileUtil.getFileName(strOldPdfFile, "/");
				}else{
					strDocFileName = FileUtil.getFileName(strOldDocFile);
					DocFilePath = strFolder + "/" + FileUtil.getFileName(strOldDocFile, "/");
				}
				 strAnsFileID = StringUtil.padl(objSMAIDelegate.getSeqNextVal("TBDS_ANS_FILE_INFO"), 10);
			}

		}


		System.out.println("strMsgDigest :"+strMsgDigest);
		System.out.println("PdfFilePath :"+PdfFilePath);
		System.out.println("DocFilePath :"+DocFilePath);
		System.out.println("strAnsFileID :"+strAnsFileID);
		System.out.println("strPdfFileName :"+strPdfFileName);
		System.out.println("strDocFileName :"+strDocFileName);


		out.println("<input type=\"hidden\" value=\""+PdfFilePath+"\" name=\"OldPdfFile\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+DocFilePath+"\" name=\"OldDocFile\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strAnsFileID+"\" name=\"AnsFileID\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strPdfFileName+"\" name=\"PdfFileName\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strDocFileName+"\" name=\"DocFileName\" size=\"0\">");
		out.println("<input type=hidden value='' name='signed_data'>");

		out.println("</form>");
%>

<html>
<head>
<title>답변등록 - 전자서명 중입니다.</title>
<!-- script language="vbscript" src="/js/activex.vbs"></script -->
<script language="javascript">

	

	function autoSubmit(form) {
		var f2 = parent.document.returnSubmitForm;

		f2.PdfFilePath.value = form.OldPdfFile.value;
		f2.DocFilePath.value = form.OldDocFile.value;
		f2.AnsOpin.value = form.AnsOpin.value;
		f2.MatType.value = "";
		f2.SendWay.value = "";
		f2.AnsType.value = form.AnsType.value;
		f2.OpenCL.value = form.OpenCL.value;
		f2.AnsFileID.value = form.AnsFileID.value;
		f2.PdfFileName.value = form.PdfFileName.value;
		f2.OriginFileName.value = form.DocFileName.value;
		//f2.MsgDigest.value = form.signed_data.value;
		f2.MsgDigest.value = "undefinedΩ";
		f2.user_dn.value = form.user_dn.value;
		f2.count.value = "<%=strFilename.length/2%>";
		f2.action = "/reqsubmit/common/SAnsInfoWriteProc.jsp";
		f2.submit();
		//self.close();
	}
</script>

</head>

<body onLoad="javascript:autoSubmit(document.encForm);">


</body>
</html>
<%
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println(e.getMessage());
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("");
	  	objMsgBean.setStrMsg(e.getMessage());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	} // end try.......... catch
%>
<%
	System.out.println("ANSTIMECHEK(4) : "+this.getCurrentTime());
%>


<%
//	fp.delete();
}
catch(Exception e)
{
	//System.out.println(e);
}
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>
