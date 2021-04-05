<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.bf.db.DBAccess" %>
<%@ page import="kr.co.kcc.bf.db.DBAccessException" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.all.ReqInfoAllInOneDelegate" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%

ResultSetHelper objSubmtOrganRs=null;  /** ������ ����Ʈ ��¿� ResultSetHelper */
String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
System.out.println(CmtOrganID);
OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**����������Ʈ*/
%>
<HTML>
<TITLE>������ ���� ���</TITLE>
<HEAD>
<style>
	BODY, table, tr, td { font-family:Verdana, ����; font-size:11px; color:#585858; }
	form { margin:0px }
	a.hover { text-decoration: underline }
	SELECT { font-family:Verdana, ����; font-size:11px; background-color:#f1f1f1; color:#585858; }
	BUTTON { font-family:verdana,����; font-size:11px; border:0px solid #ffffff; background-color:white; cursor:hand; }
	.button { font-family:verdana, ����; font-size:11px; background-color:#E5E6FD; cursor:hand; }
	.input { font-family:verdana, ����; font-size:11px; }
	INPUT { font-family:verdana, ����; font-size:11px; height:19px }
	TEXTAREA { font-family:verdana, ����; font-size:11px; }
</style>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
</HEAD>
<BODY leftmargin="0" topmargin="0">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="190" align="center">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="190" height="25" valign="top" style="padding-top:10px;padding-bottom:10px">
							<!---------------------------- START ------------------------------>
							&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> ���� ��� ����
							<br>
							&nbsp;&nbsp;
							<select select name="SubOrganID" ID="SubOrganID" size="10" multiple="multiple" >
								<%if(objSubmtOrganRs != null){%>
									<%while(objSubmtOrganRs.next()){%>
										<option value="<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>">
										<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%></option>
									<%}%>
								<%}%>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</BODY>
</HTML>