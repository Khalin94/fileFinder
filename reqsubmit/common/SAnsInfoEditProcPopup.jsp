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
    String strAnsID = "";
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

	System.out.println("ANSTIMECHEK(3) : "+this.getCurrentTime());
%>
  		<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
<%
	try {
		objReqInfo = new SMemReqInfoDelegate();
		objSMAIDelegate = new AnsInfoDelegate();


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
		for (int i = 0; i < strFilename.length; i++){
			strOldPdfFile = strFilename[i];
			// 2004-05-31 EncryptedPDF ------> DecryptedPDF
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

			System.out.println("PdfFile :"+strOldPdfFile);
			System.out.println("OriginFile :"+strOldDocFile);
			out.println("<input type=\"hidden\" value=\""+strMsgDigest+"\" name=\"src"+i+"\">");
			// 답변 파일 SEQ를 여기서 미리 생성하자.
			if(i != 0 && i != 1){
				if(i%2 ==0){
                    strAnsID = strAnsFileID + "Ω"+(String)objParamForm.getParamValue("AnsID");
                    strAnsFileID = strAnsFileID + "Ω"+(String)objParamForm.getParamValue("AnsFileID");
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
				 strAnsFileID = (String)objParamForm.getParamValue("AnsFileID");
			}
		}

		System.out.println("strMsgDigest :"+strMsgDigest);
		System.out.println("PdfFilePath :"+PdfFilePath);
		System.out.println("DocFilePath :"+DocFilePath);
        System.out.println("strAnsID :"+strAnsID);
		System.out.println("strAnsFileID :"+strAnsFileID);
		System.out.println("strPdfFileName :"+strPdfFileName);
		System.out.println("strDocFileName :"+strDocFileName);


		out.println("<input type=\"hidden\" value=\""+PdfFilePath+"\" name=\"OldPdfFile\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+DocFilePath+"\" name=\"OldDocFile\" size=\"0\">");
        out.println("<input type=\"hidden\" value=\""+strAnsID+"\" name=\"AnsID\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strAnsFileID+"\" name=\"AnsFileID\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strPdfFileName+"\" name=\"PdfFileName\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+strDocFileName+"\" name=\"DocFileName\" size=\"0\">");
		// 실제파일명 작업 20170818
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("_innods_orifilename")+"\" name=\"OrgRealFileName\" size=\"0\">");
		out.println("<input type=\"hidden\" value=\""+multi.getParameter("_innods_oripdffilename")+"\" name=\"PdfRealFileName\" size=\"0\">");
		out.println("<input type=hidden value='' name='signed_data'>");
		out.println("</form>");
%>

<html>
<head>
<title>답변수정 - 전자서명 중입니다.</title>
<!-- script language="vbscript" src="/js/activex.vbs"></script -->
<script language="javascript" src="/js/axkcase.js"></script>
<script language="javascript">

	function SelectCert2(form) {
		var dn;

		if(!CheckAX()) {
			alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
			return;
		}

		dn = document.AxNAROK.SelectCert();
		if ((dn == null) || (dn == "")) {
			if(document.AxNAROK.GetErrorCode() != -1) {
				alert(document.AxNAROK.GetErrorContent());
				return;
			}
		}
		return dn;
	}

	function NADSEncryptDigest(form) {
		var encdigetdata;
		var f = parent.document.returnSubmitForm;

		if(!CheckAX()) {
			alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
			return;
		}
		var strRsUserDN = "<%= strRsUserDN %>";
		var user_dn = form.user_dn.value;
		for(var i=0; i < <%=count%>;i++){
			src = eval("form.src"+i);
			var strMsgDigest = src.value;
			if ((user_dn == null) || (user_dn == "")) {
				user_dn = SelectCert2(f);
				if (user_dn != strRsUserDN) {
					alert("선택하신 인증서가 본인의 것과 동일한지 확인해 주시기 바랍니다.");
					parent.document.all.loadingDiv.style.display = 'none';
					return;
				}
				if(user_dn == "")
				return;
			}
			if(i == <%=count%>){
				encdigetdata = encdigetdata+document.AxNAROK.SignedData(user_dn, '', strMsgDigest);
			}else{
				encdigetdata = encdigetdata+document.AxNAROK.SignedData(user_dn, '', strMsgDigest)+"Ω";
			}
		}
		form.signed_data.value = encdigetdata;
		form.user_dn.value = user_dn;
		autoSubmit(form);
		self.close();
	}

	function SignedData2(form) {
		var signeddata;
		if(!CheckAX()) {
			alert("클라이언트 프로그램이 설치되지 않아 수행할 수 없습니다.");
			return;
		}
		var user_dn = form.user_dn.value;
		if ((user_dn == null) || (user_dn == "")) {
			if(!SelectCert(form))
			return;
		}

		signeddata = document.AxNAROK.SignedData(user_dn, "", form.src.value);
		if((signeddata == null) || (signeddata == "")) {
			if(document.AxNAROK.GetErrorCode() != -1)
				alert(document.AxNAROK.GetErrorContent());
			return;
		}
		form.signed_data.value = signeddata;
		return;
	}

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
		// 실제파일명 작업 20170818
		f2.OrgRealFileName.value = form.OrgRealFileName.value;
		f2.PdfRealFileName.value = form.PdfRealFileName.value;
		//f2.MsgDigest.value = form.signed_data.value;
		f2.MsgDigest.value = "undefinedΩ";
		f2.user_dn.value = form.user_dn.value;
		f2.count.value = "<%=strFilename.length/2%>";
		f2.action = "/reqsubmit/common/SAnsInfoEditProc.jsp";
		f2.submit();
		//self.close();
	}
</script>

</head>

<body onLoad="javascript:autoSubmit(document.encForm);">

<%--
 CBC Comment Out
<!-- OBJECT ID="AxNAROK" CLASSID="CLSID:1966B8D2-9779-4B05-BE2D-30D55C2586A1"
 codebase="<%= strWebServerAddress %>/cab/AxNAROK(2.0.0.8).cab#Version=2,0,0,8" height="1" width="1">
</OBJECT -->
--%>
<!-- script language="javascript" src="/js/AxNAROK3.js"></script -->
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
