<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>


<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RBasicReqInfoAppointListProc.jsp
* Summary	  : 사전 요구 지정 처리.
* Description : 사전 요구 지정 처리 기능 제공.
* 				※※ 체크 ※※
*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /** 요구함 생성위한 세션 파라미터 설정.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();  
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());//요구기관설정.
  objParams.setParamValue("RegrID",objUserInfo.getUserID());	//요구자 ID설정.
  //System.out.println("현재 등록자 "+objUserInfo.getUserID());
  
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	//return;
  }//endif

%>

<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
 PreRequestInfoDelegate objReqInfo=new PreRequestInfoDelegate();   /** 요구 정보 입력용 */

	String strReqBoxID=null;
 	String[] strReqIdArray = new String[300];	
	strReqIdArray = request.getParameterValues("ReqInfoIDs");
	strReqBoxID = request.getParameter("ReqBoxID");
	
	if (strReqIdArray != null)
	{
		int intlength = strReqIdArray.length ;
		String strAppointIndex = null;		
		String strBoxID=null;
		for(int i=0; i<intlength; i++) {
			strAppointIndex = strReqIdArray[i];
			strBoxID = strReqBoxID;
			
			String strUserID=objUserInfo.getUserID();
			String strReqInfoID=objReqInfo.setRecordNewApp(strAppointIndex,strBoxID,strUserID);
			
            //out.println(strReqInfoID);
			
			System.out.println("<br>");
			System.out.println(" 넘겨받은 값들  =" + strAppointIndex + "<br>");				 		
		}
		
	}

%>



<html>
<script language="JavaScript">
	function init(){
		
		alert("선택하신 요구함에 과년도 사전 요구를 가져왔습니다.");
		opener.window.location.href='<%=request.getParameter("ReturnUrl")%>?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>'; 
		
		self.close();
		formName.submit();
		
	}
</script>
<body onLoad="init()">
				
                <form name="formName" method="get" action="<%=request.getParameter("ReturnUrl")%>" ><!--요구함 상세보기 정보 전달 -->
				<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
				<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
				<input type="hidden" name="ReqOrganID" value="<%=objParams.getParamValue("ReqOrganID")%>">		    		    		    		    				
				<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
				<input type="hidden" name="ReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--요구함목록정렬필드 -->
				<input type="hidden" name="ReqBoxSortMtd" value="<%=objParams.getParamValue("ReqBoxSortMtd")%>"><!--요구함목록정령방법-->
				<input type="hidden" name="ReqBoxPage" value="<%=objParams.getParamValue("ReqBoxPage")%>"><!--요구함 페이지 번호 -->
				<input type="hidden" name="ReqBoxQryField" value="<%=objParams.getParamValue("ReqBoxQryField")%>"><!--요구함 조회필드 -->
				<input type="hidden" name="ReqBoxQryTerm" value="<%=objParams.getParamValue("ReqBoxQryMtd")%>"><!--요구함 조회어 -->
				<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--요구정보 목록정렬필드 -->
				<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--요구정보 목록정령방법-->
				<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--요구 조회필드 -->
				<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryMtd")%>"><!--요구 조회어 -->					
				<input type="hidden" name="ReqInfoPage" value="1"><!--요구정보 페이지 번호 <%=objParams.getParamValue("ReqInfoPage")%> -->
				</form>
</body>
</html>




