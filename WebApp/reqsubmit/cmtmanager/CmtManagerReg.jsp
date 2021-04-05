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
			  objMsgBean.setStrMsg("간사등록 권이 없습니다.");
			  out.println("간사등록 권이 없습니다.");
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
		alert("이미등록된 사용자입니다.");
	<%}}%>
	function selectOrganId(){
		document.formName.submit();
	}
	function checkFormData(){
		if(document.formName.ORGANID.value == ""){
			alert("의원실을 선택하여 주십시오.");
			return;
		}
		if(document.formName.USERID.value == "0000000"){
			alert("간사대행자를 지정해 주십시오.");
			return;
		}
		if(confirm("선택하신 사용자를 간사로 지정하시겠습니까?")){
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
  <input type="hidden" name="flag" value="">
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>간사 관리</h3>
        <p>소속위원회의 간사(또는 그에 준하는 사용자)를 지정,해제 하실 수 있습니다.</p>
      </div>
      <!-- /pgTit --> 
      
      <!-- contents -->
      
      <div id="contents"> 
        
        <!-- 검색조건 없는 경우 아래 div 삭제 나 주석으로 막으세요.-->
        <div class="schBox">
        <!-- /검색조건--> 
        
        <!-- 각페이지 내용 --> 
        
        <!-- list --> 
        
        
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<input type="hidden" name="RELORGANID" value="<%=organId%>">
		<input type="hidden" name="REGUSERNM" value="<%=strUserNM%>">
            <tr>
                <th height="25">&bull; 위원회 </th>
                <td height="25" colspan="3"><strong><%=OrganNM%></strong></td>
            </tr>
			<tr>
                <th height="25">&bull; 등록자 </th>
                <td height="25" colspan="3"><strong><%=strUserNM%></strong></td>
            </tr>			
			<tr>
                <th height="25">&bull; 간사 </th>
                <td height="25" colspan="3">
					<select name="ORGANID" onChange="selectOrganId()">
							<option value="">선택하세요</option>
						<%while(objOrganRs.next()){%>
							<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(strMorgan.equals(objOrganRs.getObject("ORGAN_ID"))){%>selected<%}%>>
							<%=objOrganRs.getObject("ORGAN_NM")%></option>
						<%}%>
					</select>
			  </td>
            </tr>
			<tr>
                <th height="25">&bull; 간사대행자 </th>
                <td height="25" colspan="3">
					<select name="USERID">
							<option value="0000000">선택하세요</option>
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
        
        <!-- 리스트 버튼-->
        <div id="btn_all" >        <!-- 리스트 내 검색 -->
        <!-- /리스트 내 검색 --> 

		<span class="right"> 
			<span class="list_bt"><a href="#" onclick="checkFormData()" >저장</a></span> 
			<span class="list_bt"><a href="/reqsubmit/cmtmanager/CmtManagerProc.jsp">간사목록</a></span> 
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