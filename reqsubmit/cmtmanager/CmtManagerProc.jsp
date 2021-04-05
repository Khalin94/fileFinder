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
			   /********* ������ ���� �ϱ�  **************/
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
		alert("���������� ��ϵǾ����ϴ�.");
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
			alert("���õ� ���簡 �����ϴ�.\n�Ѹ� �̻��� ���縦 ������ �ֽñ� �ٶ��ϴ�.");
			return false;
		}
		return true;
	}

  function deleteRecord(formName){

	if(formName.ReqInfoIDs == null) {
		alert("������ ���簡 �����ϴ�. ���� ����� ����� �� �����ϴ�.");
		return;
	}

     //�䱸 ��� ���� üũ Ȯ��.
  	if(hashCheckedMngIDs(formName)==false) return false;

  	if(confirm("�����Ͻ� ���������� �����Ͻðڽ��ϱ�?")){
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
  <input type="hidden" name="flag" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>���� ����</h3>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p><%if(result > 1){%>[������ �����]<%}else{%>[������ ������� ����]<%}%></p>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;">
				<input name="checkAll" type="checkbox" value="" class="borderNo" onClick="checkAllOrNot(document.formName);"/>
			 </th>
              <th scope="col"><a>�ǿ���</a></th>
              <th scope="col"><a>����</a></th>
			  <th scope="col"><a>�����</a></th>
			  <th scope="col"><a>�����</a></th>
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
				<td colspan="5" align="center">������ ���簡 �����ϴ�.</td>
			</tr>
			<% } %>
          </tbody>
        </table>

        <!-- /list -->
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <!-- /����Ʈ �� �˻� -->

		<span class="right">
			<span class="list_bt"><a href="/reqsubmit/cmtmanager/CmtManagerReg.jsp">��������</a></span>
			<span class="list_bt"><a href="#" onclick="deleteRecord(formName);">��������</a></span>
		</span>

		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>