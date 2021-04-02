<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.params.cmtreqsch.CmtReqSchForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<jsp:include page="/inc/header.jsp" flush="true"/>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*페이징 변환 Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	
%>

<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/calendar.js"></script>
<script language="javascript">
	<!--
		blnFlag = false;
		
		function MM_preloadImages() { //v3.0
			var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		}
		
		function setOrganRelation(varCmd,varorgan) {
			
			list1.setOrganRelation(varCmd,varorgan);
		}
		
		function setRelOrgan() {
			
			list1.setRelOrgan();
		}
		
		function setOrders() { 
				
			list1.setOrders();
		}	

		function getOrganUserInfo(){
			list2.getOrganUserInfo();
		}
		
		// 엑셀출력
		function toExcel() {
			frmList.action = "SubmitUserListToExcel.jsp";
			frmList.submit();
		}
	//-->	
	</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="<%=request.getRequestURI()%>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>위원회 대표 담당자관리</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > 위원회 대표 담당자관리</div>
        <p><!--문구--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
         <!-- <p>요구함조회조건</p>  -->
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
			  <div class="box">
			  위원회 정상사용자중 대표담당자를 설정하여 위원회 요구함 접수시에 문자를 받으실 사용자를 설정하실 수 있습니다.
				<!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->
				<!-- 기존의 검색 셀렉트와 버튼만 넣으세요-->			
				</div>
        </div>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->

        <table width="50%" height="420" border="0" cellpadding="0" cellspacing="0">
			<tr> 				
				<td width="2%">&nbsp;</td>
				<td width="49%" valign="top">
					<table width="100%" height="100%" border="0"  cellspacing="1" cellpadding="0" bgcolor="CCCCCC">
						<tr> 
							<td valign="top" bgcolor="ffffff">
								<!-- 제출기관 목록 Start -->    					
								<iframe name="list2" src="CmtSmsUser.jsp?strOrganID=<%=objUserInfo.getOrganID()%>" frameborder=0 width='100%' height='420' leftmargin='0' rightmargin='0' topmargin='0' scrolling=yes></iframe>
								<!-- 제출기관 목록 End -->
							</td>
						</tr>                    					
					</table>
					<br>
					<span class="right"><span class="list_bt"><a href="javascript:getOrganUserInfo();">대표담당자 저장</a></span></span>
				</td>
			</tr>
		</table>
		</div>

         <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->

</form>
<form name="frmList" method="post">
<input type="hidden" name="strOrganID" value="<%=objUserInfo.getOrganID()%>">
</form>
      </div>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>