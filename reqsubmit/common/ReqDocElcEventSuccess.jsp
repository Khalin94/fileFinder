<%
	StringBuffer strBufReturnXml = new StringBuffer();
	strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n");
	strBufReturnXml.append("<REPLY>\n");
	strBufReturnXml.append("<REPLY_CODE>1</REPLY_CODE>\n");
	strBufReturnXml.append("<DESCRIPTION>SUCCESS</DESCRIPTION>\n");
	strBufReturnXml.append("</REPLY>");
	out.println(strBufReturnXml.toString());
%>