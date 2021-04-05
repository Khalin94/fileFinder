<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strId = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_id")); 
		String strNm = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_nm")); 
		String strGubn = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("gubun")); 
		
		if((strNm != null) && (strNm.trim().length() > 0)){
			strNm = strNm.trim() ;
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USER_ID", strUserId);
			objParamHt.put("ID", strId);
			objParamHt.put("NM", strNm);
			objParamHt.put("GUBUN", strGubn);
			int iResult = objBusInfoDelegate.updateName(objParamHt);
			if(iResult == -1){
				strMessage = "폴더에 다른 사용자가 업무정보를 저장하였습니다(확인요망).";
			}else if(iResult == -3){
				strMessage = "같은 위치에 같은폴더명을 생성할 수 없습니다.(확인요망).";
			}else{
				strMessage = strMessage + String.valueOf(iResult) + "건 수정 되었습니다.";
			}	
			strError = "no";
		}else{
			strError = "yes";
			strMessage = "변경할 폴더/파일명이 없습니다.";
		}
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
%>

<script language="javascript">
<!--
	alert("<%=strMessage%>");
		
	<%if(strError.equals("no")){%>
	opener.location.reload();
    self.window.close(); 
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>
