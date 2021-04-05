<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
</head>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%

	String userID=objUserInfo.getUserID();
	String organID=objUserInfo.getOrganID();
	String userRep="N";
	ArrayList organList = null;

	nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
	organList=objJoinMemberDelegate.getOrganTree(organID);
	userRep=objJoinMemberDelegate.getUserRep(organID,userID);

%>
<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">


</script>

<body>
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
		<form name="formName" method="post" >
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>기관정보관리</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > 나의 페이지 > 기관정보관리</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
      <div class="left_table">
								<!-- 요구기관 트리 Start-->
								<iframe name="organlist" src="OrganList.jsp?strUserID=<%=userID%>&strOrganID=<%=organID%>&strUserRep=<%=userRep%>" frameborder=0 width='100%' height='620' leftmargin='0' rightmargin='0' topmargin='0' scrolling=no></iframe>
								<!-- 요구기관 트리 End -->
        </div>
        <div class="table_con3">
								<!-- 제출기관 목록 Start -->
								<iframe name="organInfo" src="about:blank" frameborder=0 width='100%' height='620' leftmargin='0' rightmargin='0' topmargin='0' scrolling=yes></iframe>
								<!-- 제출기관 목록 End -->
        </div>

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
