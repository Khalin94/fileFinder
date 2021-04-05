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
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
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
		
		// �������
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
        <h3>����ȸ ��ǥ ����ڰ���</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > ����ȸ ��ǥ ����ڰ���</div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
         <!-- <p>�䱸����ȸ����</p>  -->
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
			  <div class="box">
			  ����ȸ ���������� ��ǥ����ڸ� �����Ͽ� ����ȸ �䱸�� �����ÿ� ���ڸ� ������ ����ڸ� �����Ͻ� �� �ֽ��ϴ�.
				<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
				<!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->			
				</div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <table width="50%" height="420" border="0" cellpadding="0" cellspacing="0">
			<tr> 				
				<td width="2%">&nbsp;</td>
				<td width="49%" valign="top">
					<table width="100%" height="100%" border="0"  cellspacing="1" cellpadding="0" bgcolor="CCCCCC">
						<tr> 
							<td valign="top" bgcolor="ffffff">
								<!-- ������ ��� Start -->    					
								<iframe name="list2" src="CmtSmsUser.jsp?strOrganID=<%=objUserInfo.getOrganID()%>" frameborder=0 width='100%' height='420' leftmargin='0' rightmargin='0' topmargin='0' scrolling=yes></iframe>
								<!-- ������ ��� End -->
							</td>
						</tr>                    					
					</table>
					<br>
					<span class="right"><span class="list_bt"><a href="javascript:getOrganUserInfo();">��ǥ����� ����</a></span></span>
				</td>
			</tr>
		</table>
		</div>

         <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->

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