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
	//String strOrganIndex = StringUtil.getNVL(request.getParameter("strOrganIndex"), "��").trim();
	
	String strTitle = "";
	String strComment = "";
	String strLeft = "";
	String strRight = "";
	
	if(strRelCd.equals("001")) {
		strTitle = "�μ������ñ������";
		strComment = "�μ��� ���ñ���� ������ �� �ֽ��ϴ�.";
		strLeft = "�μ�";
		strRight = "���ñ��";
	} else {
		strTitle = "����ȸ���ǿ���ܰ���";
		strComment = "����ȸ�� �Ҽ��ǿ��� ������ �� �ֽ��ϴ�.";
		strLeft = "����ȸ";
		strRight = "�Ҽ��ǿ���";
	}	
		
	/** ������ ���� delegate */
	CmtManagerDelegate  objRelationMgr = new CmtManagerDelegate();
		
	/** ��������� */
	ArrayList objList = new ArrayList();	
	
	try 
	{
		objList = objRelationMgr.getSelectedRelOrganList(strRelCd, strOrganID);	
		System.out.println(strRelCd+strOrganID);
		//out.println("size :" + objList.size());
	} 
	catch(AppException objAppEx)
	{
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
//		out.println(objAppEx.getStrErrCode());
//		out.println("������ ��� ��ȸ �� ���� �߻� || �޼��� �������� �̵�");
//		return;
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());

			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
			return;
	}	


	Hashtable objInfo = new Hashtable();
	
	try 
	{
		objInfo = objRelationMgr.getOrganInfo(strOrganID);	
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
	
	String strRelOrganNM = (String)objInfo.get("ORGAN_NM");
	
%> 

<html>
<head>
	<title>�����ڷ� �������� �ý��� - ���ñ�� ��ȸ</title>

	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<script language="JavaScript" type="text/JavaScript">
	<!--
		function MM_preloadImages() { //v3.0
			var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
			if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		}
		
		function getList() {
			frmList.action = "SubmissionOrgan.jsp";
			frmList.submit();			
		}
		
		//������ ���� ���� ����(����)
		function setOrganRelation(varCmd,varOrgan) {
			var cnt =0;

			if(frmList.ckOrgan	== null) 
				return;
					
			//ó�� ��� ��� �������� ���� ó��
			if(frmList.ckOrgan.length>1) {
				for(i=0;i<frmList.ckOrgan.length;i++) {
	      			if(frmList.ckOrgan[i].checked) cnt++;
	    		}
	    		
	    		if(cnt==0) {
	      			alert("���� ������� ������ �ֽʽÿ�."); 
    	  			return;
    			} else {}
    		} else {	
				if(!frmList.ckOrgan.checked) { 
	    			alert("���� ������� ������ �ֽʽÿ�."); 
	    			return; 
    			}
    		}				
			
			if(!confirm("���õ� ���踦 �����Ͻðڽ��ϱ�?"))
				return;

			frmList.action = "OrganRelationProc.jsp";
			frmList.strCmd.value= varCmd;
			frmList.strOrganID.value = varOrgan;
//			frmList.target = "req";
			frmList.target = "list1";
			frmList.submit();					
		}
		
		function setRelOrgan() {
			varRelOrganID = frmList.strOrganID.value;			
			varRelCd 			= frmList.strRelCd.value;
			window.open("SetOrganRelationPop.jsp?strOrganID="+varRelOrganID+"&strRelCd="+varRelCd, "relation", "width=400,height=500,toolbar=no,menubar=no,location=no,scrollbars=yes,status=yes");			
			//showModalDialog�� ���� �ʿ�
		}
		
		function setOrders() {
			frmList.action = "OrganRelationProc.jsp";
			frmList.strCmd.value= 'Z';
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

		function getOrganUserInfo(varOrganID,varOrganNm) {
			parent.blnFlag = true;
			
			frmList.action = "RequestOrgan.jsp";
			frmList.target = "list2";
			frmList.strOrganID.value = varOrganID;
			frmList.strOrganNM.value = varOrganNm;
			parent.frmList.strOrganID.value = varOrganID;
			frmList.submit();
		}




	//-->
	</script>
	<link href="/css/global.css" rel="stylesheet" type="text/css">
</head>

<body width="100%" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >

<form name="frmList" method="post">
	<input type="hidden" name="strOrganID" value="<%=strOrganID%>">
	<input type="hidden" name="strOrganNM" value="">
	<input type="hidden" name="strRelCd" value="<%=strRelCd%>">
<!--	<input type="hidden" name="strOrganIndex" value="strOrganIndex">-->
	<input type="hidden" name="strCmd" value="">
	
<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
	<tr> 
		<td align="left" valign="top" bgcolor="ffffff">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td align="left" valign="top">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--							<tr> 
						    	<td colspan="2" class="td0_1" height="20">
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('ī')">ī</a>&nbsp;
						    		<a href="javascript:getList('Ÿ')">Ÿ</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    		<a href="javascript:getList('��')">��</a>&nbsp;
						    	</td>					    	
						  	</tr>
						  
							<tr> 
						    	<td colspan="2" class="td0_1" height="3"></td>
						  	</tr>
							<tr> 
						    	<td width="10%" height="21" align="center" class="td0_2">&nbsp;</td>
						    	<td width="90%" height="21" align="center" class="td0_2">��������</td>
						  	</tr>

-->
							<tr>
							   	<td height="20" align="center"  colspan="3">
							   		<font color="#6B66FF"><b>[<%=strRelOrganNM%>]</b></font> <%=strRight%>
							   	</td>
							</tr>
							<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
							<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
						  	<tr align="center"  > 
						    	<td height="22" width="50" align="center">
						    		<a href="javascript:allOrNot();"><img src="../image/button/allCheck.gif" width="12" height="14" border="0"></a>
						    	</td>
						    	<td height="22" width="300" align="center"><font color="#6B66FF"><b>���</b></font></td>
						    	<td height="22" width="100" align="center"><font color="#6B66FF"><b>���ļ���</b></font></td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
						  	
<% if(objList.size() > 0) { %>
<% 	for(int i=0; i<objList.size() ; i++)	{ 
		Hashtable objHash = (Hashtable)objList.get(i);
		String strOragnID = StringUtil.getNVLNULL((String)objHash.get("ORGAN_ID")).trim();
		String strOragnNM = StringUtil.getNVLNULL((String)objHash.get("ORGAN_NM")).trim();
		String strRelOragnID = StringUtil.getNVLNULL((String)objHash.get("REL_ORGAN_ID")).trim();		
		String strOrd = StringUtil.getNVLNULL((String)objHash.get("ORD")).trim();		
%>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''" onclick="getOrganUserInfo('<%=strOragnID%>','<%=strOragnNM%>');"> 
						    	<td height="22" align="center" >
						    		<input type="checkbox" name="ckOrgan" value="<%=strOragnID%>">
						    		<input type="hidden" name="strOrganIDs" value="<%=strOragnID%>">
						    	</td>
						    	<td height="22" align="left" style="cusor:pointer;cusor:hand">&nbsp;<%=strOragnNM%></td>
						    	<td height="22" align="center">
									<input type="text" name="strOrd" value="<%=strOrd%>"  class="input" style="WIDTH: 30px">
								</td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
<%	}%>
<%} else {%>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="22" colspan="3">&nbsp;�ش� ����� �������� �ʽ��ϴ�.</td>
						  	</tr>
						  	<tr align="center" onMouseOver="this.style.backgroundColor='#f4f4f4'" OnMouseOut="this.style.backgroundColor=''"> 
						    	<td height="1" colspan="3" class="tbl-line"></td>
						  	</tr>
<%}%>						  	
						</table>					
					
	
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>


<iframe width="0" height="0" name="req"></iframe>
</body>
</html>