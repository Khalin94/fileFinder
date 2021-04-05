<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	int iResult = 0;

	try
	{
		String strUserId = (String)session.getAttribute("USER_ID");

		nads.dsdm.app.activity.businfo.BusInfoDelegate objBusInfoDelegate = new nads.dsdm.app.activity.businfo.BusInfoDelegate();

		String strDutyIdArry[]   = request.getParameterValues("checkF");
		//선택한 파일(업무정보) ID
		String strDocboxIdArry[]   = request.getParameterValues("checkD");
		//선택한 폴더(분류함)ID
		String strChgDocboxId   = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(request.getParameter("chg_docbox_id"));
		//이동하고자하는 폴더(분류함)ID

		int iDocCnt = 0;
		int iDutyCnt = 0;

		if(strDocboxIdArry == null){
			iDocCnt = 0;
		}else{
			iDocCnt = strDocboxIdArry.length;  //선택한 폴더 개수
		}
		if(strDutyIdArry == null){
			iDutyCnt = 0;
		}else{
			iDutyCnt = strDutyIdArry.length;  //선택한 파일 개수
		}

		if((iDocCnt + iDutyCnt) < 1){ //선택된 업무정보가 있는지 확인
			strMessage = "선택된 업무정보가 없습니다.!";
		}else{
			if((iDutyCnt > 0) && strChgDocboxId.equals( "0")){
				strError = "yes";
				strMessage = "파일은 부서 하위로 이동할 수 없습니다.(확인요망-폴더만 가능)";
			}else{
				Hashtable objParamHt = new Hashtable();
				Vector objDutyIdVt = new Vector();
				Vector objDocIdVt = new Vector();

				if (iDutyCnt > 0){
					for(int i=0; i<strDutyIdArry.length; i++){
						objDutyIdVt.add(nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strDutyIdArry[i]));
					}
				}

				if (iDocCnt > 0){
					for(int i=0; i<strDocboxIdArry.length; i++){
						objDocIdVt.add(nads.lib.reqsubmit.util.StringUtil.getNoTagStr(strDocboxIdArry[i]));
					}
				}
				objParamHt.put("CHG_DOCBOX_ID", strChgDocboxId);  //이동하고자 하는 폴더의 ID
				objParamHt.put("USER_ID", strUserId);  //사용자ID
				objParamHt.put("DUTY_ID", objDutyIdVt);  //
				objParamHt.put("DOC_ID", objDocIdVt);

				iResult = objBusInfoDelegate.updateDutyInfo(objParamHt);

				if(iResult == -1){
					strMessage = "폴더에 다른 사용자가 업무정보를 저장하였습니다(확인요망).";
					strError = "yes";
				}else{
					strMessage = strMessage + String.valueOf(iResult) + "건 이동/변경 되었습니다.";
					strError = "no";
				}
			}
		}
		//--out.println("Result : " + intResult);
		//--response.sendRedirect("SendFax.jsp");
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
