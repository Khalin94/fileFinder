<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.bf.db.*" %> 
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.io.*"%> 

<style>
body, table, td { font-size:11px; font-family:Verdana,����; }
.title { font-family:HY������M; font-size:20px; color:darkblue; }
.button { cursor:hand; font-size:11px; font-family:Verdana,����; background-color:white; color:#909090; height:20px; }
</style>

<%
	String strExec = StringUtil.getEmptyIfNull(request.getParameter("exec"));
	
	StringBuffer strSQL = new StringBuffer();
	DBAccess objDAO = null;
	List objList = new ArrayList();
	
	try {
		objDAO = new DBAccess(this.getClass());
		strSQL.append("SELECT B.organ_id, B.organ_nm, A.user_id, A.user_nm, "); 
		strSQL.append("decode(A.stt_cd, '001', '����', '006', '���Խ���') AS stt_cd, A.dept_nm, ");
		strSQL.append("decode(C.rep_flag, 'Y', '��ǥ', 'N', '') AS rep_flag ");
		strSQL.append("FROM tbdm_user_info A, tbdm_organ B, tbdm_brg_dept C ");
		strSQL.append("WHERE A.user_id = C.user_id ");
		strSQL.append("AND C.organ_id = B.organ_id ");
		strSQL.append("AND A.stt_cd IN ('001', '006') ");
		strSQL.append("AND A.dept_nm like '%��ȹ%' ");
		//strSQL.append("AND C.rep_flag='N' ");
		strSQL.append("ORDER BY B.organ_nm, A.stt_cd, A.user_nm ");
		strSQL.append("");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		
		objList = objDAO.getArrayList();
		
	} catch(Exception e) {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		e.printStackTrace(new PrintStream(bout));
		out.println(bout.toString());
		//out.println(e.getMessage());
		return;
	}

	if("Y".equalsIgnoreCase(strExec)) {		// �۾� ���� ��ư�� Ŭ���� ���
		
		try {
			// tbdm_brg_dept_history ���̺� ���� ������Ʈ
			objDAO.init();
			
			for(int i=0; i<objList.size(); i++) {
				Hashtable objHash = (Hashtable)objList.get(i);
				String strUserID = (String)objHash.get("USER_ID");
				String strSQL2 = "DELETE FROM tbdm_brg_dept_history WHERE user_id='"+strUserID+"'";
				objDAO.setSQL(strSQL2, null);
				if(objDAO.doUpdate() < 0) {
					out.println("<script language='javascript'>");
					out.println("alert('[�̿��� ID : "+strUserID+"] ��ǥ ����� ���� �������� ������ �߻��߽��ϴ�.');");
					out.println("location.href='updateRepUserInfo.jsp';");
					out.println("</script>");
					return;
				}
			}
			//out.println("dept_history update success");
			
			// tbdm_brg_dept ���̺� ������Ʈ
			objDAO.init();
			String strOldOrganID = "";
			for(int i=0; i<objList.size(); i++) {
				Hashtable objHash = (Hashtable)objList.get(i);
				String strUserID = (String)objHash.get("USER_ID");
				String strOrganID = (String)objHash.get("ORGAN_ID");
				
				String strSQL2 = "";
				if(strOldOrganID.equalsIgnoreCase(strOrganID)) strSQL2 = "UPDATE tbdm_brg_dept SET rep_flag='N' WHERE user_id='"+strUserID+"'";
				else strSQL2 = "UPDATE tbdm_brg_dept SET rep_flag='Y' WHERE user_id='"+strUserID+"'";
				
				objDAO.setSQL(strSQL2, null);
				if(objDAO.doUpdate() < 0) {
					out.println("<script language='javascript'>");
					out.println("alert('[�̿��� ID : "+strUserID+"] ��ǥ ����� ���� �������� ������ �߻��߽��ϴ�.');");
					out.println("location.href='updateRepUserInfo.jsp';");
					out.println("</script>");
					return;
				}

				strOldOrganID = strOrganID;
			}
			
			out.println("<script language='javascript'>");
			out.println("alert('��ǥ ����� ������ ���������� �Ϸ��߽��ϴ�.');");
			out.println("location.href='updateRepUserInfo.jsp';");
			out.println("</script>");
			return;
			
		} catch(Exception e) {
			ByteArrayOutputStream bout = new ByteArrayOutputStream();
			e.printStackTrace(new PrintStream(bout));
			out.println(bout.toString());
			//out.println(e.getMessage());
			return;
		}

	} else {	// �� ó�� ȭ���� �ε��� ���

%>
		<P><BR></P>
		<div class="title">�� ����� ��ǥ ����� ��� ���</div>
		<br>
		<input type="button" name="btn1" value="��ǥ ����� ���� START" onClick="javascript:location.href='updateRepUserInfo.jsp?exec=Y'" class="button">
		<br>
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="30" align="center" height="24">NO</td>
				<td width="250" align="center">�����</td>
				<td width="80" align="center">�̿��� ID</td>
				<td width="100" align="center">�̿��� �̸�</td>
				<td width="60" align="center">���Ի���</td>
				<td width="120" align="center">�μ���</td>
				<td width="50" align="center">��ǥ����</td>
			</tr>
			<tr>
				<td colspan="7" height="1" bgcolor="#c0c0c0"></td>
			</tr>
			<%
				String strOldOrganID = "";
				for(int i=0; i<objList.size(); i++) {
					Hashtable objHash = (Hashtable)objList.get(i);
					String strOrganID = (String)objHash.get("ORGAN_ID");
			%>
			<tr>
				<td align="center" height="21"><%= (i+1) %></td>
				<td><%= objHash.get("ORGAN_NM") %> (<%= objHash.get("ORGAN_ID") %>)</td>
				<td align="center"><%= objHash.get("USER_ID") %></td>
				<td><%= objHash.get("USER_NM") %></td>
				<td align="center"><%= objHash.get("STT_CD") %></td>
				<td><%= objHash.get("DEPT_NM") %></td>
				<td align="center"><%= objHash.get("REP_FLAG") %></td>
			</tr>
			<tr>
				<td colspan="7" height="1" bgcolor="#e1e1e1"></td>
			</tr>
			<%
					strOldOrganID = strOrganID;
				}
			%>
			
		</table>
		<p>
		<input type="button" name="btn1" value="��ǥ ����� ���� START" onClick="javascript:location.href='updateRepUserInfo.jsp?exec=Y'" class="button">
<%
	}
%>