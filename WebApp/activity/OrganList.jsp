<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>

<link href="/css2/style.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/JavaScript">
	<!--
		function getSubmissionOrgan(varUserID,varOrganIDOrig,varOrganID,varUserRep,varOrganType) {
			frmList.action = "OrganInfo.jsp";
			frmList.target = "organInfo";
			frmList.strUserID.value = varUserID;
			frmList.strOrganIDOrig.value = varOrganIDOrig;
			frmList.strOrganID.value = varOrganID;
			frmList.strUserRep.value = varUserRep;
			frmList.strOrganType.value = varOrganType;
			frmList.submit();
		}
	//-->
	</script>
</head>
<%

	String userID=request.getParameter("strUserID");
	String organID=request.getParameter("strOrganID");
	String userRep=request.getParameter("strUserRep");
	ArrayList organList = new ArrayList();


    String fuserID ="";
    String forganID="";
    String fOrganId="";
    String fuserRep="";
    String fOrganType="";
try{
	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	organList=objJoinMemberDelegate.getOrganTree(organID);
}catch(Exception e){
	out.println(e.getMessage());
}
%>
<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">


</script>

<body>
<div class="left_table">
<ul>
    <li>
<%
	//out.println(organList.size());
try{
	Hashtable organInfo = new Hashtable();
	String strOrganId="";
	String strOrganNm="";
	String strOrganType="";
	for(int i=0;i<organList.size();i++){
		organInfo=(Hashtable)organList.get(i);
		strOrganId = (String)organInfo.get("ORGAN_ID");
		strOrganNm = (String)organInfo.get("ORGAN_NM");
		strOrganType = (String)organInfo.get("ORGAN_TYPE");
        if (i==0){
%>
		<li><a href="javascript:getSubmissionOrgan('<%=userID%>','<%=organID%>','<%=strOrganId%>','<%=userRep%>','<%=strOrganType%>')"><img src="../images2/foundation/left_icon1.gif" align="absmiddle"><%=strOrganNm%></a>
        <ul>
<%
            fuserID =userID;
            forganID=organID;
            fOrganId=strOrganId;
            fuserRep=userRep;
            fOrganType=strOrganType;
        } else {
%>
        <li><a href="javascript:getSubmissionOrgan('<%=userID%>','<%=organID%>','<%=strOrganId%>','<%=userRep%>','<%=strOrganType%>')"><img src="../images2/foundation/left_icon2.gif" align="absmiddle"><%=strOrganNm.replace("&nbsp;","")%></a><li>
<%
        }
	}
}catch(Exception e){
	out.println(e.getMessage());
}
%>
        </ul>
    </li>
</ul>
</div>
	<form name="frmList" method="post">
		<input type="hidden" name="strOrganID" value="">
		<input type="hidden" name="strOrganIDOrig" value="">
		<input type="hidden" name="strUserID" value="">
		<input type="hidden" name="strUserRep" value="">
		<input type="hidden" name="strOrganType" value="">
	</form>
</body>
</html>
<script>
    getSubmissionOrgan('<%=fuserID%>','<%=forganID%>','<%=fOrganId%>','<%=fuserRep%>','<%=fOrganType%>');
</script>