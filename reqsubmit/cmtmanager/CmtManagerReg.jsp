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
%>

<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	String strOrgGbnCode = objUserInfo.getOrganGBNCode();
	String strUserId 	 = objUserInfo.getUserID();
	String strUserNM 	 = objUserInfo.getUserName();
	String organId		 = objUserInfo.getOrganID();
	String FLAG = StringUtil.getEmptyIfNull(request.getParameter("flag"));
	CmtManagerDelegate cmtManager = new CmtManagerDelegate();;
	ResultSetHelper objOrganRs = null;
	ResultSetHelper objUserRs = null;
	String strMorgan = null;
	int reusltInt = -1;
	String OrganNM = cmtManager.getOrganNm(organId);
	//String organId = "GI00001559";
	try{
		
		
		if(strOrgGbnCode.equals(CodeConstants.ORGAN_GBN_CMT)){
			objOrganRs =new ResultSetHelper(cmtManager.selectRelOrganID(organId));
			strMorgan = StringUtil.getEmptyIfNull(request.getParameter("ORGANID"));
			if(!strMorgan.equals("")&& strMorgan != null){
				objUserRs = new ResultSetHelper(cmtManager.selectUserID(strMorgan));
			}
			if(FLAG.equals("insert")){
				String relorgan = request.getParameter("RELORGANID");
				String regusernm = request.getParameter("REGUSERNM");
				String organid = request.getParameter("ORGANID");
				String userid = request.getParameter("USERID");

				reusltInt = cmtManager.insertCmtManager(relorgan,organid,userid,regusernm);	
				if(reusltInt > 0){
					response.sendRedirect("/reqsubmit/cmtmanager/CmtManagerProc.jsp");
				}
			}
		}else{
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  objMsgBean.setStrCode("DSAUTH-0001");
			  objMsgBean.setStrMsg("������ ���� �����ϴ�.");
			  out.println("������ ���� �����ϴ�.");
			%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
			<%
			  return;
		}
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
	<%if(FLAG.equals("insert")){
		if(reusltInt < 0){%>
		alert("�̵̹�ϵ� ������Դϴ�.");
	<%}}%>
	function selectOrganId(){
		document.formName.submit();
	}
	function checkFormData(){
		if(document.formName.ORGANID.value == ""){
			alert("�ǿ����� �����Ͽ� �ֽʽÿ�.");
			return;
		}
		if(document.formName.USERID.value == "0000000"){
			alert("��������ڸ� ������ �ֽʽÿ�.");
			return;
		}
		if(confirm("�����Ͻ� ����ڸ� ����� �����Ͻðڽ��ϱ�?")){
			document.formName.flag.value="insert";
			document.formName.submit();
		}else{
			return false;
		}
		
	}
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
  <input type="hidden" name="flag" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>���� ����</h3>
        <p>�Ҽ�����ȸ�� ����(�Ǵ� �׿� ���ϴ� �����)�� ����,���� �Ͻ� �� �ֽ��ϴ�.</p>
      </div>
      <!-- /pgTit --> 
      
      <!-- contents -->
      
      <div id="contents"> 
        
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
        <!-- /�˻�����--> 
        
        <!-- �������� ���� --> 
        
        <!-- list --> 
        
        
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<input type="hidden" name="RELORGANID" value="<%=organId%>">
		<input type="hidden" name="REGUSERNM" value="<%=strUserNM%>">
            <tr>
                <th height="25">&bull; ����ȸ </th>
                <td height="25" colspan="3"><strong><%=OrganNM%></strong></td>
            </tr>
			<tr>
                <th height="25">&bull; ����� </th>
                <td height="25" colspan="3"><strong><%=strUserNM%></strong></td>
            </tr>			
			<tr>
                <th height="25">&bull; ���� </th>
                <td height="25" colspan="3">
					<select name="ORGANID" onChange="selectOrganId()">
							<option value="">�����ϼ���</option>
						<%while(objOrganRs.next()){%>
							<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(strMorgan.equals(objOrganRs.getObject("ORGAN_ID"))){%>selected<%}%>>
							<%=objOrganRs.getObject("ORGAN_NM")%></option>
						<%}%>
					</select>
			  </td>
            </tr>
			<tr>
                <th height="25">&bull; ��������� </th>
                <td height="25" colspan="3">
					<select name="USERID">
							<option value="0000000">�����ϼ���</option>
							<%if(!strMorgan.equals("")&& strMorgan != null){
								while(objUserRs.next()){%>
									<option value="<%=objUserRs.getObject("USER_ID")%>"><%=objUserRs.getObject("USER_NM")%></option>
								<%}%>
							<%}%>
					</select>
				</td>
            </tr>
          </tbody>
        </table>
        
        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <!-- /����Ʈ �� �˻� --> 

		<span class="right"> 
			<span class="list_bt"><a href="#" onclick="checkFormData()" >����</a></span> 
			<span class="list_bt"><a href="/reqsubmit/cmtmanager/CmtManagerProc.jsp">������</a></span> 
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