<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String webURL = ""; //http 주소
	try {
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		//out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
		String strUserID   = StringUtil.getNVL(objUserInfo.getUserID(),"9999999999");
		String strUserNm = StringUtil.getNVL(objUserInfo.getUserName(),"발신자");

		String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//구분

		//추후 세션으로 변경할 값.
		String strOrganId   = StringUtil.getNVLNULL(request.getParameter("OrganId"));		//위원회 ID
		String strOrganNm   = StringUtil.getNVLNULL(request.getParameter("OrganNm"));	//위원회명
		String strYear      = StringUtil.getNVLNULL(request.getParameter("Year")); 			//년도
		String strStrday 	= StringUtil.getNVLNULL(request.getParameter("str_day"));	    //접수시작일
		String strEndDay    = StringUtil.getNVLNULL(request.getParameter("end_day")); 	//접수마감일
		String strMaxCnt    = StringUtil.getNVLNULL(request.getParameter("MaxCnt"));	    //차수
		String strSendEnd   = StringUtil.getNVLNULL(request.getParameter("send_end_day"));		//제출기한
		String strNatCnt       = StringUtil.getNVLNULL(request.getParameter("NatCnt"));		//회기
		String strMail      = StringUtil.getNVLNULL(request.getParameter("Mail"));	    //사용자메일
		String strOffiTel   = StringUtil.getNVLNULL(request.getParameter("OffiTel"));		//사용자 사무실전화번호
		String strReqScheId   = StringUtil.getNVLNULL(request.getParameter("ReqScheId"));		//sch_id

		String strContents  = webURL+"/newsletter/CommNotice.jsp?title=위원회 요구일정 공지&year="+strYear+"&maxcnt="+strMaxCnt+"&reqname="+strOrganNm+"["+strUserNm+"]"+"&reqdate="+strStrday+"~"+strEndDay+"&senddate="+strSendEnd+"&reqtel="+strOffiTel+"&reqmail="+strMail;

	     //파라미터로 나라온 것이 없으면 기본 값 세팅.

	    strStrday = strStrday.substring(0, 4) + "" + strStrday.substring(5, 7) + "" + strStrday.substring(8, 10);
	    strEndDay = strEndDay.substring(0, 4) + "" + strEndDay.substring(5, 7) + "" + strEndDay.substring(8, 10);
	    strSendEnd = strSendEnd.substring(0, 4) + "" + strSendEnd.substring(5, 7) + "" + strSendEnd.substring(8, 10);

		//out.print("strUserID : " + strUserID + "<br>");
		//out.print("strUserNm : " + strUserNm + "<br>");
		//out.print("strOrganId : " + strOrganId + "<br>");
		//out.print("strOrganNm : " + strOrganNm + "<br>");
		//out.print("strYear : " + strYear + "<br>");
		//out.print("strStrday : " + strStrday + "<br>");
		//out.print("strEndDay : " + strEndDay + "<br>");
		//out.print("strMaxCnt : " + strMaxCnt + "<br>");
		//out.print("strSendEnd : " + strSendEnd + "<br>");
		//out.print("strNatCnt : " + strNatCnt + "<br>");
	    //out.print("strContents : " + strContents + "<br>");

		//※Delegate 선언※.
	    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

		//입력할 데이타를 HashTable 생성
		Hashtable objHashData = new Hashtable();
		int intResult = 0;

		if(strCmd.equals("creat")){
			//out.println("생성<br>");

			objHashData.put("USER_ID", strUserID);
			objHashData.put("USER_NM", strUserNm);
			objHashData.put("CMT_ORGAN_ID", strOrganId);
			objHashData.put("CMT_ORGAN_NM", strOrganNm);
			objHashData.put("AUDIT_YEAR", strYear);
			objHashData.put("ACPT_BGN_DT", strStrday);
			objHashData.put("ACPT_END_DT", strEndDay);
			objHashData.put("ORDER_INFO", strMaxCnt);
			objHashData.put("SUBMT_DLN", strSendEnd);
			objHashData.put("CONTENTS", strContents);
			objHashData.put("USERMAIL", strMail);
		    objHashData.put("NAT_CNT", strNatCnt);

		   //진행중인 요구일정이 있는지 확인한다.
		   int intSchResult;
		   ArrayList objCommStt = (ArrayList)objCommReq.selectComm_IngStt(strOrganId);
		   intSchResult = objCommStt.size();

	  	   if (intSchResult == 0 ){

				try {
					//요구일정 등록
					intResult = objCommReq.insertCommSch(objHashData);

					// 에러 발생 메세지 페이지로 이동한다.
					if(intResult < 1) {
						System.out.println("요구일정 등록중 Error가 발생하였습니다.");
						objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  		objMsgBean.setStrCode("SYS-00010");
	  					objMsgBean.setStrMsg("요구일정 등록중 Error가 발생하였습니다.");
				  		//out.println("ParamError:" + objParams.getStrErrors());
%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
						return;
					}//endif

					//위원회 소속 의원실에게 메일전송
					//intResult = objCommReq.insertSchMail(objHashData);
					intResult = 1;

				} catch (AppException objAppEx) {
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
					objMsgBean.setStrCode("SYS-00010");//AppException에러.
					objMsgBean.setStrMsg(objAppEx.getMessage());
					//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			  		return;
				}

				if(intResult != 0 ){
					//out.println("생성 성공<br>");
					response.sendRedirect("RNewBoxMake.jsp");
				}

		   }
%>
<html>
<script language="JavaScript">
	function init(){
		alert("현재 접수 진행중인 요구일정이 존재합니다. ");
		formName.submit();
	}
</script>
<body onLoad="init()">
	<form name="formName" method="post" action="RNewBoxMake.jsp" >
	</form>
</body>
</html>
<%
		}
		else if(strCmd.equals("updat")){
			//out.print("수정<br>");

			objHashData.put("ACPT_BGN_DT", strStrday);
			objHashData.put("ACPT_END_DT", strEndDay);
			objHashData.put("SUBMT_DLN", strSendEnd);
			objHashData.put("CMT_ORGAN_ID", strOrganId);
			objHashData.put("AUDIT_YEAR", strYear);
			objHashData.put("ORDER_INFO", strMaxCnt);
			objHashData.put("NAT_CNT", strNatCnt);
			objHashData.put("REQ_SCH_ID", strReqScheId);

			try {
				intResult = objCommReq.updateCommSch(objHashData);
			} catch (AppException objAppEx) {

				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("요구일정 수정중 Error가 발생하였습니다.<br>");
				return;
			}

			try {
				intResult = objCommReq.updateBoxNatCnt(objHashData);
			} catch (AppException objAppEx) {

				// 에러 발생 메세지 페이지로 이동한다.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("요구일정수정중 요구함 회기 update 중 Error가 발생하였습니다.<br>");
				return;
			}

			//out.print("서버 호출<br>");

			//out.print("intResult : " + intResult);

			if(intResult != 0 ){
				//out.print("수정 성공<br>");
				response.sendRedirect("RCommSchVList.jsp?ReqSchId="+strReqScheId);
			}
		}
%>
