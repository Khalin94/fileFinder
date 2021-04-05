<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>

<%
	String webURL = ""; //http 주소
	try {
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
	
	String strTitle 		= StringUtil.getNVLNULL(request.getParameter("title"));			//(삭제)타이틀
	String strSendName 		= StringUtil.getNVLNULL(request.getParameter("sendname"));  	// 수신자
	String strReqName 		= StringUtil.getNVLNULL(request.getParameter("reqname"));    	// 발신자
	String strSendOrg 		= StringUtil.getNVLNULL(request.getParameter("sendorg"));  		// 수신
	String strReqOrg 		= StringUtil.getNVLNULL(request.getParameter("reqorg"));    	// 발신	
	String strReqBoxNm 		= StringUtil.getNVLNULL(request.getParameter("reqboxnm"));    	// 요구함명		
	String strReqContent 	= StringUtil.getNVLNULL(request.getParameter("reqcontent"));  	// 수정내용
	String strReqTel 		= StringUtil.getNVLNULL(request.getParameter("reqtel"));      	// 발신처 전화번호
	String strReqMail 		= StringUtil.getNVLNULL(request.getParameter("reqmail"));    	// 발신처 메일
%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/css/System.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" >
<table width="588" border="0" cellpadding="0" cellspacing="3" bgcolor="E7E7E7">
  <tr>
    <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="AAAAAA">
        <tr>
          <td bgcolor="ffffff"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="left" valign="top"><img src="<%=webURL%>/image/newsletter/img_reqsubmit.jpg" width="580" height="170" border="0" usemap="#Map"></td>
              </tr>
              <tr> 
                <td height="1" align="left" valign="top" bgcolor="DBDBDB"></td>
              </tr>
              <tr> 
                <td height="35" align="center" valign="middle"><table width="568" height="29" border="0" cellpadding="0" cellspacing="0" bgcolor="E7E7E7">
                    <tr> 
                      <td width="30" align="center"><img src="<%=webURL%>/image/newsletter/icon_tit.gif" width="20" height="20"></td>
                      <td width="538" align="left" valign="middle" class="title"><%=strTitle%>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="1" align="left" valign="top" bgcolor="DBDBDB"></td>
              </tr>
              <tr> 
                <td height="17" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td align="center" valign="top"><table width="87%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td align="left" valign="top" class="TD"><strong><%=strSendName%></strong>님 
                        <br>
                        의정자료 전자유통 시스템에 자료제출 요구 내용이 삭제되었습니다.</td>
                    </tr>
                    <tr>
                      <td align="left" valign="top" class="TD">&nbsp;</td>
                    </tr>
                    <tr> 
                      <td height="25" valign="middle"><img src="<%=webURL%>/image/newsletter/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                        <span class="TD"><strong><font color="3B8815">삭제정보</font></strong></span></td>
                    </tr>
                    <tr height="5"> 
                      <td height="5" align="left" valign="top"></td>
                    </tr>
                    <tr> 
                      <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="TD">
                          <tr bgcolor="87BE8A"> 
                            <td width="26%" height="2" bgcolor="87BE8A"></td>
                            <td width="74%" height="2" bgcolor="87BE8A"></td>
                          </tr>
                          <tr>
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>발신</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            	<table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strReqOrg%></td></tr>
                            	</table>
                            </td>
                          </tr>
                          <tr height="1" bgcolor="E0E0E0"> 
                            <td height="1"></td>
                            <td height="1"></td>
                          </tr>
                          <tr> 
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>수신</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            <table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strSendOrg%></td></tr>
                            	</table>
                            </td>
                          </tr>
                          <tr height="1" bgcolor="E0E0E0"> 
                            <td height="1"></td>
                            <td height="1"></td>
                          </tr>
                          <tr>
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>내용</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            <table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strReqContent%></td></tr>
                            	</table>
                           	</td>
                          </tr>
                          <tr height="1" bgcolor="E0E0E0">
                            <td height="1"></td>
                            <td height="1"></td>
                          </tr>
                          <tr>
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>담당자</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            <table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strReqName%></td></tr>
                            	</table>
                            </td>
                          </tr>
                          <tr height="1" bgcolor="E0E0E0">
                            <td height="1"></td>
                            <td height="1"></td>
                          </tr>
                          <tr> 
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>전화번호</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            <table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strReqTel%></td></tr>
                            	</table>
                            </td>
                          </tr>
                          <tr height="1" bgcolor="E0E0E0">
                            <td height="1"></td>
                            <td height="1"></td>
                          </tr>
                          <tr> 
                            <td height="25" bgcolor="F5F5F5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=webURL%>/image/newsletter/icon_nemo_gray.gif" width="3" height="6"> 
                              <strong>E-Mail</strong> </td>
                            <td height="25">&nbsp;&nbsp;&nbsp;&nbsp;
                            <table border="0" cellspacing="0" cellpadding="0">
                            	<tr><td><%=strReqMail%></td></tr>
                            	</table>
                            </td>
                          </tr>
                          <tr height="2" bgcolor="E0E0E0"> 
                            <td height="2"></td>
                            <td height="2"></td>
                          </tr>
                          <tr>
                            <td align="left" valign="top" class="TD">&nbsp;</td>
                          </tr>
                          <tr height="10" >
                            <td></td>
                            <td align="right">                                                      
                              <a href='<%=webURL%>'><img src="<%=webURL%>/image/newsletter/bt_goNaps.gif" border=0></a>             				
                            </td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr> 
                <td align="left" valign="top"><img src="<%=webURL%>/image/newsletter/copyright.gif" width="580" height="47"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
<p class="text">&nbsp;</p>
<p class="text">&nbsp;</p>
<p class="title">&nbsp; </p>
<map name="Map">
  <area shape="rect" coords="5,3,191,40" href="#">
</map>
</form>
</body>
</html>