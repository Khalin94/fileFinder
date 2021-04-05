<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%		
	//관계기관 상위기관 ID(트리에서 선택된 기관)
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();	
	//기관관계
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	//조회 문자집합 인덱스
	String strOrganIndex = StringUtil.getNVL(request.getParameter("strOrganIndex"), "가^나").trim();
	
	/** 관계기관 관련 delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();
	
	/** 관계기관대상목록(선택 안된 관련기관) */
	ArrayList objList = new ArrayList();	
	
	try 
	{
		System.out.println("strRelCd :"+strRelCd);
		System.out.println("strOrganID :"+strOrganID);
		objList = objRelationMgr.getNotSelectedRelOrganList2(strOrganIndex, strRelCd, strOrganID);
	} 
	catch(AppException objAppEx)
	{
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
	<title>의정자료 전자유통 시스템 - 관련기관 설정</title>

	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="JavaScript" type="text/JavaScript">
	<!--
		function MM_preloadImages() { //v3.0
			var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
			if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		}
		
		function getList(varChar) {
			frmList.action = "SetOrganRelationPop.jsp";
			frmList.strOrganIndex.value = varChar;
			frmList.submit();			
		}
		
		//관계기관 설정 사항 저장(생성)
		function setOrganRelation(varCmd) {
		
			//'C'일때만 선택여부를 확인한다.
			if (varCmd == 'C') {
			
				var cnt =0;
				/**
				//처리 대상 기관 미지정에 대한 처리
				if(frmList.ckOrgan.length>1) {
					for(i=0;i<frmList.ckOrgan.length;i++) {
		      			if(frmList.ckOrgan[i].checked) cnt++;
		    		}
		    		
		    		if(cnt==0) {
		      			alert("처리 대상기관을 선택해 주십시요."); 
	    	  			return;
	    			} else {}
	    		} else {	
					if(!frmList.ckOrgan.checked) { 
		    			alert("처리 대상기관을 선택해 주십시요."); 
		    			return; 
	    			}
	    		}
	    		*/
	    		
	    		for (var i = 0; i < frmList.elements.length; i++) {
	    			if (frmList.elements[i].name == "ckOrgan") {
	    				if (frmList.elements[i].checked) {
	    					cnt++;
	    					break;
	    				}
	    			}
	    		}
	    		if (cnt == 0) {
	    			alert("처리대상을 선택해 주십시요.");
	    			return;
	    		}
	    		
	    	}


			frmList.action = "OrganRelationProc.jsp";
			frmList.strCmd.value= varCmd;
//			frmList.target = "req";
			frmList.submit();					
		}
		
		
		//전체관계기관 설정
		function setAllOrganRelation(varCmd) {

			if(!confirm("모든 관련기관에 대해 관계를 설정하시겠습니까?"))
				return;

			frmList.action = "OrganRelationProc.jsp";
			frmList.strCmd.value= varCmd;
//			frmList.target = "req";
			frmList.submit();					
		}	
		



		var varAllOrNot = true;
		function allOrNot_Old() {
		
			for (var i = 0; i < document.frmList.elements.length; i++) {
				if (document.frmList.elements[i].name == "ckOrgan") {
					document.frmList.elements[i].checked = varAllOrNot;
				}
			}
			varAllOrNot = (!varAllOrNot);
		}


		function allOrNot() {

			if(document.frmList.ckOrgan != null)
			{	
				if(document.frmList.ckOrgan.length != null)
				{
					for (var i = 0; i < document.frmList.ckOrgan.length; i++) {
							document.frmList.ckOrgan[i].checked = varAllOrNot;
					}
				}
				else
				{
					document.frmList.ckOrgan.checked = varAllOrNot;
				}

				varAllOrNot = (!varAllOrNot);
			}
		}






		function initSize()
		{	
			try 
			{
				window.resizeTo(450, 500);	
			}
			catch (err) 
			{}
		}



	//-->
	</script>
	<link href="/css/global.css" rel="stylesheet" type="text/css">
	<link href="/css2/style.css" rel="stylesheet" type="text/css">
</head>

<body width="100%" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:initSize();">

<form name="frmList" method="post">
	<input type="hidden" name="strOrganID" value="<%=strOrganID%>">
	<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
	<input type="hidden" name="strOrganIndex" value="<%=strOrganIndex%>">
	<input type="hidden" name="strCmd" value="">
	
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
	<tr> 
		<td height="95" align="left" valign="top" bgcolor="ffffff">
			<table width="100%" border="0" cellspacing="8" cellpadding="0">
				<tr> 
					<td align="left" valign="top">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr> 
						    	<td colspan="2" bgcolor="#00D8FF" height="20">
						    		<a href="javascript:getList('가^나')">가</a>&nbsp;
						    		<a href="javascript:getList('나^다')">나</a>&nbsp;
						    		<a href="javascript:getList('다^라')">다</a>&nbsp;
						    		<a href="javascript:getList('라^마')">라</a>&nbsp;
						    		<a href="javascript:getList('마^바')">마</a>&nbsp;
						    		<a href="javascript:getList('바^사')">바</a>&nbsp;
						    		<a href="javascript:getList('사^아')">사</a>&nbsp;
						    		<a href="javascript:getList('아^자')">아</a>&nbsp;
						    		<a href="javascript:getList('자^차')">자</a>&nbsp;
						    		<a href="javascript:getList('차^카')">차</a>&nbsp;
						    		<a href="javascript:getList('카^타')">카</a>&nbsp;
						    		<a href="javascript:getList('타^파')">타</a>&nbsp;
						    		<a href="javascript:getList('파^하')">파</a>&nbsp;
						    		<a href="javascript:getList('하^하')">하</a>&nbsp;
						    		<a href="javascript:getList('@^@')">기타</a>&nbsp;
									<a href="javascript:getList('0^0')">[전체]</a>
						    	</td>					    	
						  	</tr>
							<tr> 
						    	<td colspan="2" bgcolor="#0054FF" height="3"></td>
						  	</tr>
<!--						  	<tr> 
						    	<td width="10%" height="21" align="center" class="td0_2">&nbsp;</td>
						    	<td width="90%" height="21" align="center" class="td0_2">제출기관명</td>
						  	</tr>-->
							<tr> 
						    	<td width="10%" height="21" align="left">
									&nbsp;<a href="javascript:allOrNot();"><img src="../image/button/allCheck.gif" width="12" height="14" border="0"></a>
								</td>
						    	<td width="90%" height="21" align="center" >기관명</td>
						  	</tr>

<% if(objList.size() > 0) { %>
<% 	for(int i=0; i<objList.size() ; i++)	{ 
		Hashtable objHash = (Hashtable)objList.get(i);
		String strOragnID = StringUtil.getNVLNULL((String)objHash.get("ORGAN_ID")).trim();
		String strOragnNM = StringUtil.getNVLNULL((String)objHash.get("ORGAN_NM")).trim();
//		String strRelOragnID = StringUtil.getNVLNULL((String)objHash.get("REL_ORGAN_ID")).trim();		
%>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="22" width="20" align="center">
						    		<input type="checkbox" name="ckOrgan" value="<%=strOragnID%>">
						    	</td>
						    	<td height="22" align="left">&nbsp;<%=strOragnNM%></td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="2" colspan="2" class="tbl-line"></td>
						  	</tr>
<%	}%>
<%} else {%>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="22" colspan="2">&nbsp;해당 목록이 존재하지 않습니다.</td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="2" colspan="2" class="tbl-line"></td>
						  	</tr>
<%}%>						  	
						</table>					
					
	
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right" colspan="2" height="1"></td>
	</tr>
	<tr>
		<td align="right">
			<span class="list_bt"><a href="javascript:setOrganRelation('C')">저장</a></span>
			&nbsp;
			<!--a href="javascript:setOrganRelation('A')">
				<img src="../image/button/bt_registerAllOrgR_modified.jpg" height="20" border="0">
			</a-->
		</td>
	</tr>
</table>
</form>

<!--<iframe width="0" height="0" name="req"></iframe>-->
</body>
</html>