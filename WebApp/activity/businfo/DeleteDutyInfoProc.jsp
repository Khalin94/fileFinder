<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	try
	{	
		String strUserId = (String)session.getAttribute("USER_ID");
	
		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strDocIdArry[] = request.getParameterValues("checkD"); 
		//삭제하고자 하는 폴명ID
		String strDutyIdArry[] = request.getParameterValues("checkF"); 
		//삭제하고자 하는 파일ID
		
		Vector objDocId = new Vector();
		Vector objDutyId = new Vector();
		
		int iDocCnt = 0;
		int iDutyCnt = 0;
		
		if(strDocIdArry == null){
			iDocCnt = 0;
		}else{
			iDocCnt = strDocIdArry.length;  //선택한 분류함 개수
		}	

		if(strDutyIdArry == null){
			iDutyCnt = 0;
		}else{
			iDutyCnt = strDutyIdArry.length;  //선택한 업무정보 개수
		}	
				
		if(iDocCnt + iDutyCnt > 0){
			if(iDocCnt > 0){
				for (int i=0; i < strDocIdArry.length ; i++){
					objDocId.add(strDocIdArry[i]);			
				}
			}
			
			if(iDutyCnt > 0){
				for (int i=0; i < strDutyIdArry.length ; i++){
					objDutyId.add(strDutyIdArry[i]);			
				}
			}
			
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("USER_ID", strUserId);  //사용자ID
			objParamHt.put("DOC_ID", objDocId);    //삭제하고자하는 분류함ID
			objParamHt.put("DUTY_ID", objDutyId);  //삭제하고자 하는 업무정보ID
		
			int iResult = objBusInfoDelegate.deleteDutyInfo(objParamHt);
			
			if(iResult == -1){
				strMessage = "폴더에 다른 사용자가 업무정보를 저장하였습니다(확인요망).";
			}else{
				strMessage = strMessage + String.valueOf(iResult) + "건 삭제 되었습니다.";
			}	
		}else{
			strMessage = "삭제할 업무정보를 선택하지 않았습니다.!";
		}//strDocIdArry.length + strDutyIdArry.length > 1)
		strError = "no";
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
