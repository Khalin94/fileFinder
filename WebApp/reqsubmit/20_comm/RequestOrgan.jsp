<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemReqDocSendDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>


<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	//기관관계
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();
	String strOrganNM = StringUtil.getNVLNULL(request.getParameter("strOrganNM")).trim();
	
	
	/** 관계기관 관련 delegate */
	MemReqDocSendDelegate objRDSDelegate = null;
	ResultSetHelper objRs = null;
	
	try 
	{
		objRDSDelegate = new MemReqDocSendDelegate();
		Hashtable hash = (Hashtable)objRDSDelegate.getUserListByOrganID(strOrganID);
		objRs = new ResultSetHelper(hash);	
	
	} catch (AppException objAppEx) {
	
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());

			// 에러 발생 메세지 페이지로 이동한다.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;

	}
	
%>
<html>
<head>
	<title>의정자료전자유통시스템 - 부서목록 조회</title>

	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

	<script language="JavaScript" type="text/JavaScript">
	<!--
		function MM_preloadImages() { //v3.0
			var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
			if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		}
		
		function getOrganUserInfo() {
			var cnt =0;
			if(frmList.ckUser.length>1) {
				for(i=0;i<frmList.ckUser.length;i++) {
	      			if(frmList.ckUser[i].checked) cnt++;
	    		}
	    		
	    		if(cnt==0) {
	      			alert("사용자를 선택해 주십시요."); 
    	  			return;
    			} else {}
    		} else {	
				if(!frmList.ckUser.checked) { 
	    			alert("사용자를 선택해 주십시요."); 
	    			return; 
    			}
    		}
			frmList.action = "UserDpProc.jsp";
			frmList.submit();
		}

		function clearPage(relCd){			
			parent.frmList.action = "ManageOrganRelationComm.jsp?strRelCd="+relCd;
			parent.frmList.submit();
		}

		
		
	//-->
	</script>
	<link href="/css/global.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	<form name="frmList" method="post">
	<!--------------------------Tree 관련 스크립트 Start--------------------------------->	
	<SCRIPT LANGUAGE="JavaScript" src="/js/common_ss.js"></SCRIPT>
	<!--------------------------Tree 관련 스크립트 End--------------------------------->
	
	 <table width="100%"  border="0" cellspacing="1" cellpadding="0">
	 <tr align="center"> 
		<td height="1" colspan="3"><font color="#6B66FF"><b>[<%=strOrganNM%>]</b></font></td>
	</tr>
	<tr align="left" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
		<td height="1" colspan="3" class="tbl-line"></td>
	</tr>
	<tr align="left" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
		<td height="1" colspan="3" class="tbl-line"></td>
	</tr>
	 <tr align="left"> 
		<td height="22" align="center">
			대표담당
		</td>
		<td height="22" align="left">&nbsp;사용자</td>	
		<td height="22" align="left">&nbsp;부서명</td>
	</tr>
	<tr align="left" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
		<td height="1" colspan="3" class="tbl-line"></td>
	</tr>

	 <%if(objRs.getRecordSize() > 0){
		String temp1 = "";
		while(objRs.next()) { 			
			if(objRs.getObject("REP_FLAG") != null && ((String)objRs.getObject("REP_FLAG")).equals("Y")){
				temp1 = "checked";	
			}else{
				temp1 = "";
			}
%>

						  	<tr align="left" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="22" align="center">
						    		<input type="checkbox" name="ckUser" value="<%=objRs.getObject("USER_ID")%>" <%=temp1%>>
						    	</td>
						    	<td height="22" align="left">&nbsp;<%=objRs.getObject("USER_NM")%></td>	
								<td height="22" align="left">&nbsp;<%=objRs.getObject("DEPT_NM")%></td>
						  	</tr>
						  	<tr align="left" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
		
<%
		}
	}else{
	
%>

						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="22" colspan="3">&nbsp;해당 목록이 존재하지 않습니다.</td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
<%}%>
	</table>
	
	
		<input type="hidden" name="strOrganID" value="<%=strOrganID%>">
		<input type="hidden" name="strRelCd" value="<%=strRelCd%>">		<!--001:제출기관, 002:소속부서, 003:소속의원실 -->
	</form>
	
</BODY>
</HTML>			 	