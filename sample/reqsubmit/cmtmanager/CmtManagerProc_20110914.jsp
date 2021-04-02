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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> <% //nads.lib.reqsubmit.EnvConstants.UNIX_TEMP_SAVE_PATH%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
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
				<td height="22" align="left" class="text_s">
					<!-------------------- ���� �������� ���� ���� ��� ------------------------>
				 �Ҽ�����ȸ�� ����(�Ǵ� �׿� ���ϴ� �����)�� ����,���� �Ͻ� �� �ֽ��ϴ�.
				
				</td>
			  </tr>
			  <tr>
				<td height="22" align="left" class="text_s">
					<!-------------------- ���� �������� ���� ���� ��� ------------------------>
					<img src="/image/common/icon_exclam_mark.gif" border="0"> ��� �� 1�� �̻��� ���縦 ������ ��� �ڵ����� <B>���� ��� �����</B> ���� ó�� �˴ϴ�.
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>
				<table width="650" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="650" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="300" align="center">&nbsp;</td>
							<td width="350" align="right"><%if(result > 1){%><b>[������ �����]</b><%}else{%><b>[������ ������� ����]</b><%}%></td>
					</tr>
					</table>
				 </td>
			</tr>
			<tr class="td_reqsubmit"> 
			  <td width="650" height="2"></td>
			</tr>
		    <tr class="td_top">
				<td>
				<table width="650" border="0" cellspacing="0" cellpadding="0">
						<tr class="td_top">
							<td height="22" width="19" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
							<!--<td width="100" align="center">�Ҽ�����ȸ</td>-->
							<td width="150" align="center">�ǿ���</td>
							<td width="100" align="center">����</td>
							<td width="100" align="center">�����</td>
							<td width="160" align="center">�����</td>
						</tr>
					</table>
				 </td>
		     <tr>
			 <tr> 
				<td height="1" class="td_reqsubmit"></td>
			 </tr>
			 <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
				<td>
					<table width="650" border="0" cellspacing="0" cellpadding="0">
						<%if(objRs != null && objRs.getRecordSize() > 0){%>
							<%while(objRs.next()){%>
						<tr>
							<td align="center" width="19" height="22"><input type="checkbox" name="ReqInfoIDs"       value="<%=objRs.getObject("CMT_MANAGER_NO")%>"></td>
							<!--<td align="center" width="100" height="22"><%=objRs.getObject("CMT_ORGAN_ID")%></td>-->
							<td align="center" width="150" height="22"><%=objRs.getObject("ORGAN_NM")%></td>
							<td align="center" width="100" height="22"><%=objRs.getObject("USER_NM")%></td>
							<td align="center" width="100" height="22"><%=objRs.getObject("REG_USER_NM")%></td>
							<td align="center" width="160" height="22"><%= StringUtil.getDate2((String)objRs.getObject("REG_DATE")) %></td>
						</tr>
						<tr class="tbl-line"> 
							<td height="1" colspan="6"></td>
						</tr>  
							<%}%>
						<% } else { %>  
						<tr> 
							<td height="40" align="center">������ ���簡 �����ϴ�.</td>
						</tr>
					<% } %>
					 </table>
				 </td>
			 </tr>
			 <tr class="tbl-line"> 
				<td height="1"></td>
			 </tr>       	
			
			 <tr class="tbl-line"> 
				<td height="1"></td>
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
               		<a href="/reqsubmit/cmtmanager/CmtManagerReg.jsp"><img src="/image/reqsubmit/bt_mngRegist.gif" border="0"></a>	
			&nbsp;&nbsp;<img src="/image/reqsubmit/bt_mngDelete.gif" height="20"  style="cursor:hand" onClick="deleteRecord(formName);">
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


