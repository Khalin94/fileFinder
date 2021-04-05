<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.bf.db.DBAccess" %>
<%@ page import="kr.co.kcc.bf.db.DBAccessException" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	ResultSetHelper objRs = null;
	int result = 0;
	String FLAG = StringUtil.getEmptyIfNull(request.getParameter("flag"));
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	try{
		int resultYn = -1;
		CmtManagerDelegate cmtmanager = new CmtManagerDelegate();
		CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
		if(FLAG.equals("delete")){
			String[] strNo=request.getParameterValues("ReqInfoIDs");

			for(int i=0;i<strNo.length;i++){
			   String No=strNo[i];
			   /********* 데이터 삭제 하기  **************/
			   resultYn = cmtmanager.removeRecord(No);
		   }//end for
		}
		objRs = new ResultSetHelper(cmtmanager.getRecordList((String)objUserInfo.getOrganID()));
		result = cmtmanagerCn.getFLAG((String)objUserInfo.getOrganID());
	}catch(AppException objAppEx){
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
	<%if(FLAG.equals("insert")){%>
		alert("정상적으로 등록되었습니다.");
	<%}%>

	function hashCheckedMngIDs(formName){
		var blnFlag=false;
		if(formName.ReqInfoIDs.length==undefined){
			if(formName.ReqInfoIDs.checked==true){
				blnFlag=true;
			}
		}else{
			var intLen=formName.ReqInfoIDs.length;
			for(var i=0;i<intLen;i++){
				if(formName.ReqInfoIDs[i].checked==true){
					blnFlag=true;break;
				}
			}
		}
		if(blnFlag==false){
			alert("선택된 간사가 없습니다.\n한명 이상의 간사를 지정해 주시기 바랍니다.");
			return false;
		}
		return true;
	}

  function deleteRecord(formName){

	if(formName.ReqInfoIDs == null) {
		alert("지정된 간사가 없습니다. 해제 기능을 사용할 수 없습니다.");
		return;
	}

     //요구 목록 내용 체크 확인.
  	if(hashCheckedMngIDs(formName)==false) return false;

  	if(confirm("선택하신 간사정보를 삭제하시겠습니까?")){
		formName.flag.value="delete";
  		formName.action="/reqsubmit/cmtmanager/CmtManagerProc.jsp";
  		formName.submit();
  	}else{
  		return false;
  	}
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
  <input type="hidden" name="flag" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>간사 관리</h3>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
          <p><%if(result > 1){%>[간사기능 사용중]<%}else{%>[간사기능 사용하지 않음]<%}%></p>
        <!-- /검색조건-->

        <!-- 각페이지 내용 -->

        <!-- list -->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="checkAllOrNot(document.formName);"/>
			 </th>
              <th scope="col"><a>의원실</a></th>
              <th scope="col"><a>간사</a></th>
			  <th scope="col"><a>등록자</a></th>
			  <th scope="col"><a>등록일</a></th>
            </tr>
          </thead>
          <tbody>
			<%if(objRs != null && objRs.getRecordSize() > 0){%>
				<%while(objRs.next()){%>
            <tr>
              <td ><input name="ReqInfoIDs" type="checkbox" value="<%=objRs.getObject("CMT_MANAGER_NO")%>"  class="borderNo" /></td>
              <td><%=objRs.getObject("ORGAN_NM")%></td>
              <td><%=objRs.getObject("USER_NM")%></td>
              <td><%=objRs.getObject("REG_USER_NM")%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DATE")) %></td>
            </tr>
				<%}%>
			<% } else { %>
			<tr>
				<td colspan="5" align="center">지정된 간사가 없습니다.</td>
			</tr>
			<% } %>
          </tbody>
        </table>

        <!-- /list -->
        <!-- 페이징-->
         <!-- /페이징-->
        <!--  <p class="warning">* 요구서를 발송하게 되면 해당 제출 기관 대표 담당자에게 지정 발송되며, 담당자가 없는 경우는 작성 중 요구함에 그대로 남아있게 됩니다.  </p>
          <p class="warning">* 요구서 발송 버튼을 이용하시기 위해서는 위원회를 선택해 주시기 바랍니다.  </p>  -->



        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <!-- /리스트 내 검색 -->

		<span class="right">
			<span class="list_bt"><a href="/reqsubmit/cmtmanager/CmtManagerReg.jsp">간사지정</a></span>
			<span class="list_bt"><a href="#" onclick="deleteRecord(formName);">간사해제</a></span>
		</span>

		</div>

        <!-- /리스트 버튼-->

        <!-- /각페이지 내용 -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>