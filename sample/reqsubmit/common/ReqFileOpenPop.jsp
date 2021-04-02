<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.util.*"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.common.pdfviewdelegate.PdfViewDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>

<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strDocFilePath = request.getParameter("strDocFilePath");
%>
		<html>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<head>
		<title>Innorix Multi Platform Solution - InnoFD</title>
		</head>
			<body leftmargin="0" topmargin="0" onLoad="InnoFD.SingleDownload('http://naps.assembly.go.kr/InnoFDP/download.jsp?_filename=<%=strDocFilePath %>');history.back();">
				<div style="border: 1px solid #c0c0c0; width:450px">
				<script type="text/javascript" src="/js2/InnoFDP/InnoFD.js"></script>
				<script type="text/javascript">
					var Enc = "F1yV/Ih1CIWKmwpkR++vU4L5x6Qw09ZdbnfMOMAF4yP/qX8ir89PSOJEu0KGxmZ7+nwY4oq8SqjF6+BH2rAyuehELATMrnCBJd33fPqR3zO0/EZoPZFUTOJnU4al6tZO+4gcNw==";
					var UseFileSizeQueryString = true;

					var CharSet = "EUC-KR";
					var ListStyle = "report";
					var ViewType = 0;

					InnoFDInit( 1, 1 );
				</script>
				</div>
			</body>
	   </html>

