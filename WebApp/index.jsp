<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strGubn = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("gubun"), "1");
	String strCommittee = kr.co.kcc.bf.bfutil.StringUtil.getNVL(request.getParameter("comm"), "");
	String strUserId = "tester1";
	String strUserGubn = "true";
%>

<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" type="text/JavaScript">
<!--
	function MM_preloadImages() { //v3.0
		var d=document; 
		if(d.images){ 
			if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
				for(i=0; i<a.length; i++)
					if (a[i].indexOf("#")!=0){ 
						d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];
					}
		}
	}

	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; 
		for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_findObj(n, d) { //v4.01
		var p,i,x;  
		if(!d) d=document; 
		if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; 
			n=n.substring(0,p);
		}
		if(!(x=d[n])&&d.all) x=d.all[n]; 
		for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) 
			x=MM_findObj(n,d.layers[i].document);
		if(!x && d.getElementById) 
			x=d.getElementById(n); 
		return x;
	}

	function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
 		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	function fun_chgcomm(strGubn){
		var vaComm = document.form_main.committee.value;
		var vaUrl = "/index.jsp?gubn=" + strGubn + "&comm=" + vaComm;
		window.location = vaUrl;
	}
	
	function fun_homepage(){
		var vaRelUrl = document.form_main.relorgan.value;
		var vaRelNm = document.form_main.relorgan.text;
		if (trim(vaRelUrl) == ""){
			alert("해당기관의 홈페이지가 없습니다");
		}else{
			window.open(vaRelUrl, vaRelNm);
		}	 
	}	
	
	function fun_newpage(vaUrl, vaWidth, vaHeigth){
		var vaOption = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width=' + vaWidth + ',height=' + vaHeigth + ',left=0,top=0';
		window.open(vaUrl,'New', vaOption);	
	}
//-->
</script>
<script src='/js/activity.js'></script>
<link href="css/System.css" rel="stylesheet" type="text/css">
<link href="css/Main.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="main/MainTop.jsp" %>
<table width="824" height="268" border="0" cellpadding="0" cellspacing="0">
<form name="form_main" method="post" action="">
  <tr align="left" valign="top"> 
    <td width="185" background="image/main/bg_left.gif"><%@ include file="main/MainLeft.jsp" %></td>
    <td width="639" align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr background="image/main/bg_search.gif"> 
          <td width="23" height="25" align="left" valign="top" background="image/main/bg_search.gif">&nbsp;</td>
          <td width="600" height="25" align="right" valign="middle" background="image/main/bg_search.gif"><img src="image/main/search.gif" width="48" height="9"> 
            <input name="textfield2222" type="text" class="textfield" style="WIDTH: 181px" > 
            <img src="image/main/bt_go.gif" width="24" height="16" align="absmiddle"> 
          </td>
          <td width="16" height="25" align="left" valign="top" background="image/main/bg_search.gif">&nbsp;</td>
        </tr>
        <tr height="14"> 
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" background="image/main/bg_tit.gif">
              <tr align="left">
<!--제출자, 요구자 를 구분한다-->
<%
	if(strUserGubn.equals("true")){
%>
                <td width="33%"><img src="image/main/tit_newList.gif" width="197" height="21"></td>
<%
	}else{
%>
                <td width="33%"><img src="image/main/tit_newSubmitList.gif" width="197" height="21"></td>
<%
	}
%>

                <td width="58%">&nbsp;</td>
                <td width="9%" align="right"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
              </tr>
            </table></td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td height="13" align="left" valign="top"></td>
          <td height="13" align="left" valign="top"></td>
          <td height="13" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">
            <table width="100%" height="77" border="0" cellpadding="0" cellspacing="0">
<%@ include file="main/MainReqSubmit.jsp" %>
            </table>
          </td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
        </tr>
        <tr height="1"> 
          <td height="1" align="left" valign="top"></td>
          <td height="1" align="left" valign="top" bgcolor="EEEEEE"></td>
          <td height="1" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="48%" height="60" align="left" valign="top"><table width="290" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="290" align="left" valign="top"><img src="image/main/tit_newMaterial.gif" width="290" height="24"></td>
                    </tr>
                    <tr> 
                      <td height="104" align="left" valign="middle" bgcolor="FBFBFB"><table width="97%" border="0" cellspacing="0" cellpadding="0">
<!---최신자료------->
<%@ include file="main/MainRecData.jsp" %>
                        </table></td>
                    </tr>
                    <tr height="1"> 
                      <td height="1" align="left" valign="top" bgcolor="E5E5E5"></td>
                    </tr>
                  </table></td>
                <td width="13%">&nbsp;</td>
                <td width="39%" align="right" valign="top"><table width="293" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td align="left" valign="top"><img src="image/main/tit_news.gif" width="241" height="24"><a href="javascript:fun_newpage('/activity/SelectNewList.jsp', 760, 380)"><img src="image/main/news_more.gif" width="52" height="24" border="0"></a></td>
                    </tr>
                    <tr> 
                      <td height="104" align="left" valign="middle" bgcolor="FBFBFB"><table width="97%" border="0" cellspacing="0" cellpadding="0">
<!---최신뉴스------->
<%@ include file="main/MainRecNew.jsp" %>
                        </table></td>
                    </tr>
                    <tr height="1"> 
                      <td height="1" align="left" valign="top" bgcolor="E5E5E5"></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
          <td height="14" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr align="left" valign="top">

<!--제출자, 요구자 를 구분한다-->
<%
	if(strUserGubn.equals("true")){
		switch (Integer.parseInt(strGubn)){
			case 1:
%>  
                <td width="15%"><img src="image/main/tab_govern_over.gif" width="93" height="24"></td>
                <td width="15%"><a href="/index.jsp?gubun=2&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image67','','image/main/tab_openBiz_over.gif',1)"><img src="image/main/tab_openBiz.gif" name="Image67" width="93" height="24" border="0"></a></td>
                <td width="13%"><a href="/index.jsp?gubun=3&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image68','','image/main/tab_cocernInfo_over.gif',1)"><img src="image/main/tab_cocernInfo.gif" name="Image68" width="81" height="24" border="0"></a></td>
                <td width="1%"><a href="/index.jsp?gubun=4&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image69','','image/main/tab_notice_over.gif',1)"><img src="image/main/tab_notice.gif" name="Image69" width="81" height="24" border="0"></a></td>
                <td width="56%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>             
<%
				break;
			case 2:
%>
                <td width="15%"><a href="/index.jsp?gubun=1&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10112','','image/main/tab_govern_over.gif',1)"><img src="image/main/tab_govern.gif" name="Image10112" width="93" height="24" border="0" id="Image101"></a></td>
                <td width="15%"><img src="image/main/tab_openBiz_over.gif" width="93" height="24"></td>
                <td width="13%"><a href="/index.jsp?gubun=3&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image682','','image/main/tab_cocernInfo_over.gif',1)"><img src="image/main/tab_cocernInfo.gif" name="Image682" width="81" height="24" border="0" id="Image682"></a></td>
                <td width="1%"><a href="/index.jsp?gubun=4&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image693','','image/main/tab_notice_over.gif',1)"><img src="image/main/tab_notice.gif" name="Image693" width="81" height="24" border="0" id="Image693"></a></td>
                <td width="56%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
				break;
			case 3:
%>
               <td><a href="/index.jsp?gubun=1&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10111','','image/main/tab_govern_over.gif',1)"><img src="image/main/tab_govern.gif" name="Image10111" width="93" height="24" border="0" id="Image101"></a></td>
               <td><a href="/index.jsp?gubun=2&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image67111','','image/main/tab_openBiz_over.gif',1)"><img src="image/main/tab_openBiz.gif" name="Image67111" width="93" height="24" border="0" id="Image671"></a></td>
               <td width="13%"><img src="image/main/tab_cocernInfo_over.gif" width="81" height="24"></td>
               <td width="1%"><a href="/index.jsp?gubun=4&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6911','','image/main/tab_notice_over.gif',1)"><img src="image/main/tab_notice.gif" name="Image6911" width="81" height="24" border="0" id="Image691"></a></td>
               <td width="56%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
				break;
			case 4:
%>
                <td width="15%"><a href="/index.jsp?gubun=1&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1011','','image/main/tab_govern_over.gif',1)"><img src="image/main/tab_govern.gif" name="Image1011" width="93" height="24" border="0" id="Image101"></a></td>
                <td width="15%"><a href="/index.jsp?gubun=2&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6711','','image/main/tab_openBiz_over.gif',1)"><img src="image/main/tab_openBiz.gif" name="Image6711" width="93" height="24" border="0" id="Image671"></a></td>
                <td width="13%"><a href="/index.jsp?gubun=3&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6811','','image/main/tab_cocernInfo_over.gif',1)"><img src="image/main/tab_cocernInfo.gif" name="Image6811" width="81" height="24" border="0" id="Image681"></a></td>
                <td width="1%"><img src="image/main/tab_notice_over.gif" width="81" height="24"></td>
                <td width="56%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
		}
	}else{
		switch (Integer.parseInt(strGubn)){
			case 1:
%>  
                <td width="15%"><img src="image/main/tab_govern_over.gif" width="93" height="24"></td>
                <td width="13%"><a href="/index.jsp?gubun=3&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image65','','image/main/tab_cocernInfo_over.gif',1)"><img src="image/main/tab_cocernInfo.gif" name="Image65" width="81" height="24" border="0"></a></td>
                <td width="2%"><a href="/index.jsp?gubun=4&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image64','','image/main/tab_notice_over.gif',1)"><img src="image/main/tab_notice.gif" name="Image64" width="81" height="24" border="0"></a></td>
                <td width="70%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
				break;
			case 3:
%>
               <td width="2%"><a href="/index.jsp?gubun=1&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6411','','image/main/tab_govern_over.gif',1)"><img src="image/main/tab_govern.gif" name="Image6411" width="93" height="24" border="0" id="Image641"></a></td>
               <td width="13%"><img src="image/main/tab_cocernInfo_over.gif" width="81" height="24"></td>
               <td width="2%"><a href="/index.jsp?gubun=4&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','image/main/tab_notice_over.gif',1)"><img src="image/main/tab_notice.gif" name="Image8" width="81" height="24" border="0"></a></td>
               <td width="70%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
				break;
			case 4:
%>
                <td width="2%"><a href="/index.jsp?gubun=1&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image64111','','image/main/tab_govern_over.gif',1)"><img src="image/main/tab_govern.gif" name="Image64111" width="93" height="24" border="0" id="Image641"></a></td>
                <td width="13%"><a href="/index.jsp?gubun=3&comm=<%=strCommittee%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image652','','image/main/tab_cocernInfo_over.gif',1)"><img src="image/main/tab_cocernInfo.gif" name="Image652" width="81" height="24" border="0" id="Image652"></a></td>
                <td width="2%"><img src="image/main/tab_notice_over.gif" width="81" height="24"></td>
                <td width="70%" align="right" valign="middle"><a href="#"><img src="image/main/bt_more.gif" width="34" height="7" border="0"></a>&nbsp;&nbsp;</td>
<%
		}	
	}
%>
              </tr>
            </table>
          </td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr> 
          <td height="2" align="left" valign="top"></td>
          <td height="2" align="left" valign="top" bgcolor="AD8FBC"></td>
          <td height="2" align="left" valign="top"></td>
        </tr>
        <tr height="3"> 
          <td height="5" align="left" valign="top"></td>
          <td height="5" align="left" valign="top"></td>
          <td height="5" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td align="left" valign="top">&nbsp;</td>
          <td align="left" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
		switch (Integer.parseInt(strGubn)){
			/** 정부 서류제출함 **/
			case 1:
%>                                          
<%@ include file="main/TabGovernMaterial.jsp" %>

<%
				break;
			/** 공개업무정보 **/
			case 2:
%>
<%@ include file="main/TabOpenBizInfo.jsp" %>

<%
				break;
			/** 관심정보목록 **/
			case 3:
%>
<%@ include file="main/TabConcernInfo.jsp" %>

<%
				break;
			/** 공지사항목록 **/
			case 4:
%>                                          
<%@ include file="main/TabNotice.jsp" %>

<%
				break;
		}
%>
            </table></td>
          <td align="left" valign="top">&nbsp;</td>
        </tr>
        <tr height="3"> 
          <td height="3" align="left" valign="top"></td>
          <td height="3" align="left" valign="top"></td>
          <td height="3" align="left" valign="top"></td>
        </tr>
        <tr height="1"> 
          <td height="1" align="left" valign="top"></td>
          <td height="1" align="left" valign="top" bgcolor="EEEEEE"></td>
          <td height="1" align="left" valign="top"></td>
        </tr>
        <tr> 
          <td width="23" height="15" align="left" valign="top"></td>
          <td width="600" height="15" align="left" valign="top"></td>
          <td width="16" height="15" align="left" valign="top"></td>
        </tr>
      </table></td>
  </tr>
 </form>
</table>
<%@ include file="main/MainBottom.jsp" %>
</body>
</html>
