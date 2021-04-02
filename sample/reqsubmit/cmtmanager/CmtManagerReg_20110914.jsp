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
			alert("���縦 ������ �ֽʽÿ�.");
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
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%@ include file="../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
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
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->
        <tr valign="top"> 
          <td width="30" align="left">
		  <img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
              <input type="hidden" name="flag" value="">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title">���� ����</span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
			  <tr>
				<td height="30" align="left" class="text_s">
					<!-------------------- ���� �������� ���� ���� ��� ------------------------>
				 �Ҽ�����ȸ�� ����(�Ǵ� �׿� ���ϴ� �����)�� ����,���� �Ͻ� �� �ֽ��ϴ�.
				
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>
				<table width="680" border="0" cellspacing="0" cellpadding="0">
				<input type="hidden" name="RELORGANID" value="<%=organId%>">
                <input type="hidden" name="REGUSERNM" value="<%=strUserNM%>">
                    <tr class="td_reqsubmit"> 
                      <td width="120" height="2"></td>
                      <td width="560" height="2"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����ȸ</td>
                      <td width="560" height="25" class="td_lmagin"><%=OrganNM%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �����</td>
                      <td width="560" height="25" class="td_lmagin"><%=strUserNM%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td width="120" height="1"></td>
                      <td width="560" height="1"></td>
                    </tr>
                    <tr> 
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ����</td>
                      <td width="560" height="25" class="td_lmagin">
					    <select name="ORGANID" onChange="selectOrganId()">
							<option value="">�����ϼ���</option>
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
                      <td width="120" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���������</td>
                      <td width="560" height="25" class="td_lmagin">
					  <select name="USERID">
							<option value="0000000">�����ϼ���</option>
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
               	<!-- �����̽���ĭ -->
              </tr>
              <tr>
               	<td>
               	<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
               	 <table>
               	   <tr>
               		 <td align="center">
               			<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkFormData()" style="cursor:hand">
						<a href="/reqsubmit/cmtmanager/CmtManagerProc.jsp">
						<img src="/image/reqsubmit/bt_mngList.gif" border="0" height="20"></a>
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->                                
          </form>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    </td>
  </tr>
</table>
</td>
  </tr>
</table>
<%@ include file="../../common/Bottom.jsp" %>
</body>
</html>              


