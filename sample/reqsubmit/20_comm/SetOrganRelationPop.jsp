<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Hashtable"%>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%		
	//������ ������� ID(Ʈ������ ���õ� ���)
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();	
	//�������
	String strRelCd = StringUtil.getNVLNULL(request.getParameter("strRelCd")).trim();
	//��ȸ �������� �ε���
	String strOrganIndex = StringUtil.getNVL(request.getParameter("strOrganIndex"), "��^��").trim();
	
	/** ������ ���� delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();
	
	/** �����������(���� �ȵ� ���ñ��) */
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

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
		return;
	}	
	
%> 

<html>
<head>
	<title>�����ڷ� �������� �ý��� - ���ñ�� ����</title>

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
		
		//������ ���� ���� ����(����)
		function setOrganRelation(varCmd) {
		
			//'C'�϶��� ���ÿ��θ� Ȯ���Ѵ�.
			if (varCmd == 'C') {
			
				var cnt =0;
				/**
				//ó�� ��� ��� �������� ���� ó��
				if(frmList.ckOrgan.length>1) {
					for(i=0;i<frmList.ckOrgan.length;i++) {
		      			if(frmList.ckOrgan[i].checked) cnt++;
		    		}
		    		
		    		if(cnt==0) {
		      			alert("ó�� ������� ������ �ֽʽÿ�."); 
	    	  			return;
	    			} else {}
	    		} else {	
					if(!frmList.ckOrgan.checked) { 
		    			alert("ó�� ������� ������ �ֽʽÿ�."); 
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
	    			alert("ó������� ������ �ֽʽÿ�.");
	    			return;
	    		}
	    		
	    	}


			frmList.action = "OrganRelationProc.jsp";
			frmList.strCmd.value= varCmd;
//			frmList.target = "req";
			frmList.submit();					
		}
		
		
		//��ü������ ����
		function setAllOrganRelation(varCmd) {

			if(!confirm("��� ���ñ���� ���� ���踦 �����Ͻðڽ��ϱ�?"))
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
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^ī')">��</a>&nbsp;
						    		<a href="javascript:getList('ī^Ÿ')">ī</a>&nbsp;
						    		<a href="javascript:getList('Ÿ^��')">Ÿ</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('��^��')">��</a>&nbsp;
						    		<a href="javascript:getList('@^@')">��Ÿ</a>&nbsp;
									<a href="javascript:getList('0^0')">[��ü]</a>
						    	</td>					    	
						  	</tr>
							<tr> 
						    	<td colspan="2" bgcolor="#0054FF" height="3"></td>
						  	</tr>
<!--						  	<tr> 
						    	<td width="10%" height="21" align="center" class="td0_2">&nbsp;</td>
						    	<td width="90%" height="21" align="center" class="td0_2">��������</td>
						  	</tr>-->
							<tr> 
						    	<td width="10%" height="21" align="left">
									&nbsp;<a href="javascript:allOrNot();"><img src="../image/button/allCheck.gif" width="12" height="14" border="0"></a>
								</td>
						    	<td width="90%" height="21" align="center" >�����</td>
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
						    	<td height="22" colspan="2">&nbsp;�ش� ����� �������� �ʽ��ϴ�.</td>
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
			<span class="list_bt"><a href="javascript:setOrganRelation('C')">����</a></span>
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