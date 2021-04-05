<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.bf.db.DBAccess" %>
<%@ page import="kr.co.kcc.bf.db.DBAccessException" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	String CmtOrganID = "";
	ResultSetHelper objSubmtOrganRs=null;
%>
<%
	CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));
	if(!CmtOrganID.equals("")){
		OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
		objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(CmtOrganID));/**제출기관리스트*/
	}
%>

<HTML>
<TITLE>제출기관 선택 목록</TITLE>
<HEAD>
<style>
	BODY, table, tr, td { font-family:Verdana, 돋움; font-size:11px; color:#585858; }
	form { margin:0px }
	a.hover { text-decoration: underline }
	SELECT { font-family:Verdana, 돋움; font-size:11px; background-color:#f1f1f1; color:#585858; }
	BUTTON { font-family:verdana,돋움; font-size:11px; border:0px solid #ffffff; background-color:white; cursor:hand; }
	.button { font-family:verdana, 돋움; font-size:11px; background-color:#E5E6FD; cursor:hand; }
	.input { font-family:verdana, 돋움; font-size:11px; }
	INPUT { font-family:verdana, 돋움; font-size:11px; height:19px }
	TEXTAREA { font-family:verdana, 돋움; font-size:11px; }
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
						<td width="190" valign="top">
						
							<!---------------------------- START ------------------------------>
							&nbsp;&nbsp;<img src="/image/common/icon_reqsubmit_soti.gif"> 선택된 제출기관 목록
							<br>
								  &nbsp;<span id="divReqInfo">
							<!----------------------------- END   ------------------------------>
						<!--
						<%if(!CmtOrganID.equals("")){%>
							<br>&nbsp;
								<%if(objSubmtOrganRs != null){%>
									<%while(objSubmtOrganRs.next()){%>
										<input type="checkbox" name="" value="<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>">
										<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%><br>&nbsp;
									<%}%>
								<%}%>
						<%}%>
						-->
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</BODY>
</HTML>