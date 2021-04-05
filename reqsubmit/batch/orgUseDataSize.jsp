<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*"%> 
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.*" %>
<%@ page import="kr.co.kcc.bf.db.*" %> 
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String strCmd = StringUtil.getEmptyIfNull(request.getParameter("cmd"));
	String defaultPath = "/mnt/nads/reqsubmit/";
	String strCmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrgID"));
	String strOrganID = StringUtil.getEmptyIfNull(request.getParameter("OrgID"));
	String strStartDay = StringUtil.getEmptyIfNull(request.getParameter("StartDay"));
	String strEndDay = StringUtil.getEmptyIfNull(request.getParameter("EndDay"));
	
	StringBuffer strSQL = new StringBuffer();
	DBAccess objDAO=null;
	Hashtable objReturnHash = new Hashtable();
	int intCount = 0;
	
	Hashtable objOrgHash = new Hashtable();
	int intOrgCnt = 0;
	Vector objOrgVec = null;
		
	try {
		objDAO = new DBAccess(this.getClass());
		
		// ����ȸ ��� ��ȸ 
		strSQL.append("SELECT (select count(*) from tbdm_organ where organ_kind='004') as cnt, ");
		strSQL.append("organ_id, organ_nm FROM tbdm_organ WHERE organ_kind='004' ");
		strSQL.append("ORDER BY organ_nm ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		Vector objCmtOrgVec = (Vector)objReturnHash.get("CNT");
		
		// ����ȸ �� �ǿ��� ��� ��ȸ 
		if(StringUtil.isAssigned(strCmtOrganID)) {
			objDAO.init();
			strSQL.setLength(0);
			strSQL.append("select (select COUNT(*) from tbdm_organ A, tbdm_rel_organ B ");
			strSQL.append("where B.rel_organ_id='"+strCmtOrganID+"' ");
			strSQL.append("AND A.organ_id = B.organ_id ");
			strSQL.append("AND B.rel_cd = '003') AS CNT, A.organ_id, A.organ_nm from tbdm_organ A, tbdm_rel_organ B ");
			strSQL.append("where B.rel_organ_id='"+strCmtOrganID+"' ");
			strSQL.append("AND A.organ_id = B.organ_id ");
			strSQL.append("AND B.rel_cd = '003' ");
			strSQL.append("ORDER BY A.organ_nm ");
			
			objDAO.setSQL(strSQL.toString(), null);
			objDAO.doQuery();
			objOrgHash = objDAO.getResultSetMatrix();
			objOrgVec = (Vector)objOrgHash.get("CNT");
		}
		
%>

<html>
<head>
<title>�����ڷ� �������� �ý��� - ����� ���� �ý��� ��뷮 ����</title>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript">
	function showDiv() {
		document.all.formDiv.style.display = '';
	}

	function hiddenDiv() {
		document.all.formDiv.style.display = 'none';
	}
	
	function doSubmit() {
		var f = document.selectForm;
		if(f.CmtOrgID.value == "") {
			alert("����ȸ�� ������ �ּ���");
			f.CmtOrgID.focus();
			return;
		}
		f.cmd.value = "exec";
		f.submit();
	}
</script>

</head>

<body leftmargin="0" topmargin="0">
	<CENTER>
	<p><BR></p>
	<font style="font-family:HY������M; font-size:18px; color:darkblue;">
		�����ڷ� �������� �ý���<BR>
	</font>
	<font style="font-family:HY������M; font-size:24px; color:darkblue; font-weight:bold;">
		����� ���� �ý��� ��뷮 ��ȸ 
	</font>
	<p>
<FORM method="get" action="orgUseDataSize.jsp" name="selectForm">
	<input type="hidden" name="cmd" value="">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="650" bgcolor="#e1e1e1">
			<table border="0" cellpadding="0" cellspacing="1">
				<tr>
					<td width="650" height="3" bgcolor="steelblue" colspan="2">
					</td> 
				</tr>
				<tr>
					<td width="120" height="25" align="right" style="padding-right:5px" bgcolor="#f4f4f4">����ȸ ����</td>
					<td width="530" align="left" style="padding-left:5px" bgcolor="#ffffff">
						<select name="CmtOrgID" onChange="this.form.submit()">
							<option value="">::: ������ �ּ��� :::</option>
							<%
								if(objCmtOrgVec.size() > 0) {
									intCount = Integer.parseInt(StringUtil.getEmptyIfNull(String.valueOf(((Vector)objReturnHash.get("CNT")).elementAt(0))));
									String strCmtSelected = "";
									for(int i=0; i<intCount; i++) {
										String strCmtOrgId = (String)((Vector)objReturnHash.get("ORGAN_ID")).elementAt(i);
										String strOrgName = (String)((Vector)objReturnHash.get("ORGAN_NM")).elementAt(i);
										if(strCmtOrgId.equals(strCmtOrganID)) strCmtSelected = " selected";
										else strCmtSelected = "";
										out.println("<option value='"+strCmtOrgId+"'"+strCmtSelected+">"+strOrgName+"</option>");
									}
								}
							%>
						</select>
					</td>
				</tr>

				<tr>
					<td width="120" height="25" align="right" style="padding-right:5px" bgcolor="#f4f4f4">�ǿ��� ����</td>
					<td width="530" align="left" style="padding-left:5px" bgcolor="#ffffff">
						<select name="OrgID">
							<option value="">::: ����ȸ�� ���� ������ �ּ��� :::</option>
							<%
								if(objOrgVec != null && objOrgVec.size() > 0) {
									intOrgCnt = Integer.parseInt(StringUtil.getEmptyIfNull(String.valueOf(((Vector)objOrgHash.get("CNT")).elementAt(0))));
									String strOrgSelected = "";
									for(int i=0; i<intOrgCnt; i++) {
										String strOrgId = (String)((Vector)objOrgHash.get("ORGAN_ID")).elementAt(i);
										String strOrgName = (String)((Vector)objOrgHash.get("ORGAN_NM")).elementAt(i);
										if(strOrganID.equals(strOrgId)) strOrgSelected = " selected";
										else strOrgSelected = "";
										out.println("<option value='"+strOrgId+"'"+strOrgSelected+">"+strOrgName+"</option>");
									}
								}
							%>
						</select>
					</td>
				</tr>
				
				<tr>
					<td width="120" height="25" align="right" style="padding-right:5px" bgcolor="#f4f4f4">�Ⱓ ����</td>
					<td width="530" align="left" style="padding-left:5px" bgcolor="#ffffff">
						<input type="text" class="input" name="StartDay" size="10" maxlength="8" value="<%= strStartDay %>"  readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" >
						<input type="button" value="..." style="cursor:hand" OnClick="javascript:Calendar(document.selectForm.StartDay);" class="button">	&nbsp;&nbsp; ~	&nbsp;&nbsp;
				       	<input type="text" class="input" name="EndDay" size="10" maxlength="8" value="<%= strEndDay %>" readonly  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;">
						<input type="button" value="..." style="cursor:hand" OnClick="javascript:Calendar(document.selectForm.EndDay);" class="button">
					</td>
				</tr>

				<tr>
					<td colspan="2" bgcolor="white" style="padding-top:5px;padding-bottom:5px">
						<%
							Hashtable objRsHash = new Hashtable();
							Vector objRsVec = null;
							int intRsCnt = 0;
							long longTotalFileSize = 0;
							if(StringUtil.isAssigned(strCmd) && StringUtil.isAssigned(strCmtOrganID)) {
								String strOrgWhereClause = "";
								String strDateWhereClause = "";
								if(StringUtil.isAssigned(strOrganID)) {
									strOrgWhereClause = "AND req_organ_id='"+strOrganID+"' ";
								}
								if(StringUtil.isAssigned(strStartDay) && StringUtil.isAssigned(strEndDay)) {
									String strStartYear = strStartDay.substring(0, 4);
									String strEndYear = strEndDay.substring(0, 4);
									strDateWhereClause = "AND audit_year BETWEEN '"+strStartYear+"' AND '"+strEndYear+"' ";
								}
								
								objDAO.init();
								strSQL.setLength(0);
								
								strSQL.append("SELECT ");
								strSQL.append("(SELECT COUNT(*) AS RSCNT FROM tbds_request_box WHERE cmt_organ_id='"+strCmtOrganID+"' ");
								strSQL.append(strOrgWhereClause);
								strSQL.append(strDateWhereClause);
								strSQL.append(") AS RSCNT, ");
								strSQL.append("req_box_id, req_organ_id, cmt_organ_id, audit_year ");
								strSQL.append("FROM tbds_request_box ");
								strSQL.append("WHERE cmt_organ_id='"+strCmtOrganID+"' ");
								strSQL.append(strOrgWhereClause);
								strSQL.append(strDateWhereClause);
								
								objDAO.setSQL(strSQL.toString(), null);
								objDAO.doQuery();
								objRsHash = objDAO.getResultSetMatrix();
								objRsVec = (Vector)objRsHash.get("RSCNT");

								//out.println(strSQL.toString()+"<P>");

								if(objRsVec != null && objRsVec.size() > 0) {
									intRsCnt = Integer.parseInt(StringUtil.getEmptyIfNull(String.valueOf(((Vector)objRsHash.get("RSCNT")).elementAt(0))));
									
									for(int i=0; i<intRsCnt; i++) {
										String strReqBoxID = (String)((Vector)objRsHash.get("REQ_BOX_ID")).elementAt(i);
										String strAuditYear = (String)((Vector)objRsHash.get("AUDIT_YEAR")).elementAt(i);
										String strFullPath = defaultPath+strAuditYear+"/"+strReqBoxID;
										
										File objDir = new File(strFullPath);
										String[] arrFileList = objDir.list();

										longTotalFileSize = longTotalFileSize + FileUtil.getFileSize(strFullPath);
										
										if(arrFileList != null && arrFileList.length > 0) {
											for(int k=0; k<arrFileList.length; k++) {
												//File objFile = new File(strFullPath+"/"+arrFileList[k]);
												longTotalFileSize = longTotalFileSize + FileUtil.getFileSize(strFullPath+"/"+arrFileList[k]);
											}
										}

									}
								}
							}
						%>
						&nbsp;&nbsp;<B>[��ȸ ���]</B>
						<BR>
						&nbsp;&nbsp;- �䱸�� �� : <B><%= intRsCnt %></B> �� 
						<BR>
						&nbsp;&nbsp;- ���� �ý��� ��뷮 : <B><%= longTotalFileSize %> </B> bytes (<%= FileUtil.getFileSize(longTotalFileSize) %>)
						<BR>
					</td>
				</tr>

				<tr>
					<td width="650" height="3" bgcolor="steelblue" colspan="2">
					</td> 
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<p>
	<input type="button" name="btn" class="button" value="��ȸ�մϴ�" onClick="doSubmit()">
</FORM>
	</CENTER>
</body>

</html>

<%
	} catch(Exception e) {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		e.printStackTrace(new PrintStream(bout));
		out.println(bout.toString());
		//out.println(e.getMessage());
	}
%>