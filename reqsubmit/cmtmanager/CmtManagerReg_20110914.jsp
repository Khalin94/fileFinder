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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> <% //nads.lib.reqsubmit.EnvConstants.UNIX_TEMP_SAVE_PATH%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
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
			alert("간사를 지정해 주십시오.");
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
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 시작 ------->
	<td width="100%">
	   <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left">
		  <table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<!------- 2004-06-02 디자인 수정으로 인해 변경된 부분 끝 ------->
        <tr valign="top"> 
          <td width="30" align="left">
		  <img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--요구함 신규정보 전달 -->
              <input type="hidden" name="flag" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- 타이틀을 입력해 주세요 ------------------------>
                      		<span class="title">간사 관리</span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- 현재 위치 정보를 기술한답니다. ------------------------>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
			  <tr>
				<td height="30" align="left" class="text_s">
					<!-------------------- 현재 페이지에 대한 설명 기술 ------------------------>
				 소속위원회의 간사(또는 그에 준하는 사용자)를 지정,해제 하실 수 있습니다.
				
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
              <tr>
               	<!-- 스페이스한칸 -->
               	<td>
				<table width="680" border="0" cellspacing="0" cellpadding="0">
				<input type="hidden" name="RELORGANID" value="<%=organId%>">
                <input type="hidden" name="REGUSERNM" value="<%=strUserNM%>">
                    <tr class="td_reqsubmit"> 
                      <td width="120" height="2"></td>
                      <td width="560" height="2"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 위원회</td>
                      <td width="560" height="25" class="td_lmagin"><%=OrganNM%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 등록자</td>
                      <td width="560" height="25" class="td_lmagin"><%=strUserNM%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 간사</td>
                      <td width="560" height="25" class="td_lmagin">
					    <select name="ORGANID" onChange="selectOrganId()">
							<option value="">선택하세요</option>
						<%while(objOrganRs.next()){%>
							<option value="<%=objOrganRs.getObject("ORGAN_ID")%>" <%if(strMorgan.equals(objOrganRs.getObject("ORGAN_ID"))){%>selected<%}%>>
							<%=objOrganRs.getObject("ORGAN_NM")%></option>
						<%}%>
						</select>
						</td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 간사대행자</td>
                      <td width="560" height="25" class="td_lmagin">
					  <select name="USERID">
							<option value="0000000">선택하세요</option>
							<%if(!strMorgan.equals("")&& strMorgan != null){
								while(objUserRs.next()){%>
									<option value="<%=objUserRs.getObject("USER_ID")%>"><%=objUserRs.getObject("USER_NM")%></option>
								<%}%>//endwhile
							<%}%>//end if
						</select>
						</td>
                    </tr>
					<tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
				</table>
               	</td>
               	<!-- 스페이스한칸 -->
              </tr>
              <tr>
               	<td>
               	<!----------------------- 저장 취소등 Form관련 버튼 시작 ------------------------->
               	 <table>
               	   <tr>
               		 <td align="center">
               			<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkFormData()" style="cursor:hand">
						<a href="/reqsubmit/cmtmanager/CmtManagerProc.jsp">
						<img src="/image/reqsubmit/bt_mngList.gif" border="0" height="20"></a>
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- 저장 취소등 Form관련 버튼 끝 ------------------------->                                
          </form>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- 여기까지  MAIN WORK AREA 실제 코딩의 끝입니다. ----------------------------->      
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<%@ include file="../../common/Bottom.jsp" %>
</body>
</html>              


