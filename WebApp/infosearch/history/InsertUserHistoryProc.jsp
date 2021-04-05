<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*"%>
<%@ page import="nads.dsdm.app.infosearch.history.IsHistoryDelegate" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ include file="../utils.jsp" %> 
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%

	String Actionquery = ""; 
//문자파라미터

	String ri = StringUtil.getEmptyIfNull(request.getParameter("ri")); 
	if(ri==null) ri = "";

	String query = StringUtil.getEmptyIfNull(request.getParameter("query")); 
	if(query==null) query = "";

	String queryText = StringUtil.getEmptyIfNull(request.getParameter("queryText")); 
	if(queryText==null) queryText = "";

	String deptText = StringUtil.getEmptyIfNull(request.getParameter("deptText")); 	
	if(deptText==null) deptText = "";

	String deptText00 = StringUtil.getEmptyIfNull(request.getParameter("deptText00")); 	
	if(deptText00==null) deptText00 = "";

	String USER_ID = (String)session.getAttribute("USER_ID");

	String MENU_CD = StringUtil.getEmptyIfNull(request.getParameter("MENU_CD")); 	
	if(MENU_CD==null || MENU_CD.equals("")) MENU_CD = "01";

	String audit_year_from = StringUtil.getEmptyIfNull(request.getParameter("audit_year_from")); 
	if(audit_year_from==null) audit_year_from = "";

	String audit_year_to = StringUtil.getEmptyIfNull(request.getParameter("audit_year_to")); 
	if(audit_year_to==null) audit_year_to = "";

	String ans_text = StringUtil.getEmptyIfNull(request.getParameter("ans_text")); 	
	if(ans_text==null) ans_text = "";

	String req_text = StringUtil.getEmptyIfNull(request.getParameter("req_text")); 	
	if(req_text==null) req_text = "";

	String andor = StringUtil.getEmptyIfNull(request.getParameter("andor")); 	
	if(andor==null || andor.equals("")) andor = "AND";

	String req_select = StringUtil.getEmptyIfNull(request.getParameter("req_select")); 	
	if(req_select==null) req_select = "";

	String ans_select = StringUtil.getEmptyIfNull(request.getParameter("ans_select")); 	
	if(ans_select==null) ans_select = "";

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select")); 	
	if(req_organ_select==null) req_organ_select = "";

	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select")); 	
	if(ans_organ_select==null) ans_organ_select = "";

	String SUBMT_DATA_GBN = StringUtil.getEmptyIfNull(request.getParameter("SUBMT_DATA_GBN")); 	
	if(SUBMT_DATA_GBN==null) SUBMT_DATA_GBN = "";

	String REQ_MAIN = StringUtil.getEmptyIfNull(request.getParameter("REQ_MAIN")); 	
	if(REQ_MAIN==null) REQ_MAIN = "";

	String REQ_SUB = StringUtil.getEmptyIfNull(request.getParameter("REQ_SUB")); 	
	if(REQ_SUB==null) REQ_SUB = "";

	String GROUPNAME = StringUtil.getEmptyIfNull(request.getParameter("GROUPNAME")); 	
	if(GROUPNAME==null) GROUPNAME = "";

	String currCommittee = StringUtil.getEmptyIfNull(request.getParameter("currCommittee")); 	
	if(currCommittee==null) currCommittee = "";


//숫자파라미터

	int docStart = 1;
	if(request.getParameter("docStart")!=null)
		docStart = Integer.parseInt(request.getParameter("docStart"));
	
	int docPage = 10;
	if(request.getParameter("docPage")!=null)
		docPage = Integer.parseInt(request.getParameter("docPage"));

	int     maxDocs     = 4000;
	if(request.getParameter("maxDocs") != null)
		maxDocs = Integer.parseInt(request.getParameter("maxDocs"));


	if (!query.equals("") ){

		IsHistoryDelegate objCMD = new IsHistoryDelegate();
		
		try {
	
			Vector objVecinsertKeyword = new Vector();
			objVecinsertKeyword.add(USER_ID);
			objVecinsertKeyword.add(MENU_CD);
			objVecinsertKeyword.add(toMulti(query));		
			int intResult = objCMD.insertKeyword(objVecinsertKeyword);

		
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
		 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
		  	objMsgBean.setStrMsg(objAppEx.getMessage());
			System.out.println(objAppEx.getStrErrCode());
	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%	
			return;
		}
	}

%>
<html>
<body>

<% if (MENU_CD.equals("01")) Actionquery = "../ISearch_Nads.jsp";%>
<% if (MENU_CD.equals("02")) Actionquery = "../ISearch_Committee.jsp";%>
<% if (MENU_CD.equals("03")) Actionquery = "../ISearch_Relation.jsp";%>
<% if (MENU_CD.equals("04")) Actionquery = "../ISearch_News.jsp";%>
<% if (MENU_CD.equals("05")) Actionquery = "../ISearch_Submit.jsp";%>

<form name=frm method="post" action="<%=Actionquery%>">

	<input type=hidden name=deptText value="<%=toMulti(deptText)%>">
	<input type=hidden name=deptText00 value="<%=toMulti(deptText00)%>">	
	<input type=hidden name=query value="<%=toMulti(query)%>">
	<input type=hidden name=queryText value="<%=toMulti(queryText)%>">
	<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">
	<input type=hidden name=docStart VALUE="<%=docStart%>">
	<input type=hidden name=docPage VALUE="<%=docPage%>">
	<input type=hidden name=audit_year_from VALUE="<%=audit_year_from%>">
	<input type=hidden name=audit_year_to VALUE="<%=audit_year_to%>">
	<input type=hidden name=ans_text VALUE="<%=ans_text%>">
	<input type=hidden name=req_text VALUE="<%=req_text%>">
	<input type=hidden name=andor VALUE="<%=andor%>">
	<input type=hidden name=req_select VALUE="<%=req_select%>">
	<input type=hidden name=ans_select VALUE="<%=ans_select%>">
	<input type=hidden name=req_organ_select VALUE="<%=req_organ_select%>">
	<input type=hidden name=ans_organ_select VALUE="<%=ans_organ_select%>">
	<input type=hidden name=SUBMT_DATA_GBN VALUE="<%=SUBMT_DATA_GBN%>">
	<input type=hidden name=REQ_MAIN VALUE="<%=REQ_MAIN%>">
	<input type=hidden name=REQ_SUB VALUE="<%=REQ_SUB%>">
	<input type=hidden name=ri VALUE="<%=ri%>">
	<input type=hidden name=GROUPNAME VALUE="<%=GROUPNAME%>">
	<input type=hidden name=currCommittee VALUE="<%=currCommittee%>">	
</form>

<script language="javascript">
	document.frm.submit();
</script>
</body>
</html>
