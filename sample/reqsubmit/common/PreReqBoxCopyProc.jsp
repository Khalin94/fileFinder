<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/

  /**요구함 ID */
  String strReqBoxID=(String)request.getParameter("ReqBoxID");
  String[] strSubmtOrganIDs=request.getParameterValues("SubmtOrganIDs");/**  선택된 제출기관 리스트  */
  String strNatCnt=(String)request.getParameter("NatCnt");
  /**에러 체크 문자열 */
  String strErrorMsg="";
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
  if(StringUtil.isAssigned(strReqBoxID)){
    if(strSubmtOrganIDs==null){
    	strErrorMsg="제출기관이 선택되지 않았습니다.";
    }else{
	  	blnParamCheck=true;
  	}
  }else{
  	strErrorMsg="요구함ID가 누락 되었습니다.";
  }
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(strErrorMsg);
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
 /*************************************************************************************************/
 /** 					데이터 처리 Part 														  */
 /*************************************************************************************************/
	try{
        OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** 기관정보 출력용 대리자 */
		PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();
		for(int i=0;i<strSubmtOrganIDs.length;i++){
		  String strCmtOrganID=objOrganInfo.getCmtOrganID(strSubmtOrganIDs[i]);//없으면 ""반환.		
		  /** 소속위원회 제출기관이 아니면 기타위원회 설정 2004.05.13 */
		  if(objUserInfo.getIsMyCmtOrganID(strCmtOrganID)==false){
		     strCmtOrganID=CodeConstants.ETC_CMT_ORGAN_ID;
		  }//endif		
			String strReturn=objReqBox.copyRecord(strReqBoxID,objUserInfo.getUserID(),strNatCnt,strCmtOrganID,strSubmtOrganIDs[i]);
			if(!StringUtil.isAssigned(strReturn)){
			 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			  	objMsgBean.setStrCode("DSDATA-0010");
			  	objMsgBean.setStrMsg("요구함을 복사하지 못했습니다");
			  	%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
			  	<%  	
			  	return;
			}//endif
		}//endfor
	 }catch(AppException objAppEx){ 
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%  	
	  	return; 
	 }//endoftry
%>
<%
 /*************************************************************************************************/
 /** 					페이지 전환 Part 														  */
 /*************************************************************************************************/
%>
<html>
<script language="JavaScript">
		alert("요구함이 복사되었습니다");
		opener.location.href="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxList.jsp";
		self.close();
</script>
</html>