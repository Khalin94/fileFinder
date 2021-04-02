<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String webURL = ""; //http �ּ�
	try {
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
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
		String strUserNm = StringUtil.getNVL(objUserInfo.getUserName(),"�߽���");

		String strCmd =StringUtil.getNVLNULL(request.getParameter("cmd"));										//����

		//���� �������� ������ ��.
		String strOrganId   = StringUtil.getNVLNULL(request.getParameter("OrganId"));		//����ȸ ID
		String strOrganNm   = StringUtil.getNVLNULL(request.getParameter("OrganNm"));	//����ȸ��
		String strYear      = StringUtil.getNVLNULL(request.getParameter("Year")); 			//�⵵
		String strStrday 	= StringUtil.getNVLNULL(request.getParameter("str_day"));	    //����������
		String strEndDay    = StringUtil.getNVLNULL(request.getParameter("end_day")); 	//����������
		String strMaxCnt    = StringUtil.getNVLNULL(request.getParameter("MaxCnt"));	    //����
		String strSendEnd   = StringUtil.getNVLNULL(request.getParameter("send_end_day"));		//�������
		String strNatCnt       = StringUtil.getNVLNULL(request.getParameter("NatCnt"));		//ȸ��
		String strMail      = StringUtil.getNVLNULL(request.getParameter("Mail"));	    //����ڸ���
		String strOffiTel   = StringUtil.getNVLNULL(request.getParameter("OffiTel"));		//����� �繫����ȭ��ȣ
		String strReqScheId   = StringUtil.getNVLNULL(request.getParameter("ReqScheId"));		//sch_id

		String strContents  = webURL+"/newsletter/CommNotice.jsp?title=����ȸ �䱸���� ����&year="+strYear+"&maxcnt="+strMaxCnt+"&reqname="+strOrganNm+"["+strUserNm+"]"+"&reqdate="+strStrday+"~"+strEndDay+"&senddate="+strSendEnd+"&reqtel="+strOffiTel+"&reqmail="+strMail;

	     //�Ķ���ͷ� ����� ���� ������ �⺻ �� ����.

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

		//��Delegate �����.
	    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

		//�Է��� ����Ÿ�� HashTable ����
		Hashtable objHashData = new Hashtable();
		int intResult = 0;

		if(strCmd.equals("creat")){
			//out.println("����<br>");

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

		   //�������� �䱸������ �ִ��� Ȯ���Ѵ�.
		   int intSchResult;
		   ArrayList objCommStt = (ArrayList)objCommReq.selectComm_IngStt(strOrganId);
		   intSchResult = objCommStt.size();

	  	   if (intSchResult == 0 ){

				try {
					//�䱸���� ���
					intResult = objCommReq.insertCommSch(objHashData);

					// ���� �߻� �޼��� �������� �̵��Ѵ�.
					if(intResult < 1) {
						System.out.println("�䱸���� ����� Error�� �߻��Ͽ����ϴ�.");
						objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				  		objMsgBean.setStrCode("SYS-00010");
	  					objMsgBean.setStrMsg("�䱸���� ����� Error�� �߻��Ͽ����ϴ�.");
				  		//out.println("ParamError:" + objParams.getStrErrors());
%>
						<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
						return;
					}//endif

					//����ȸ �Ҽ� �ǿ��ǿ��� ��������
					//intResult = objCommReq.insertSchMail(objHashData);
					intResult = 1;

				} catch (AppException objAppEx) {
					objMsgBean.setMsgType(MessageBean.TYPE_ERR);
					System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
					objMsgBean.setStrCode("SYS-00010");//AppException����.
					objMsgBean.setStrMsg(objAppEx.getMessage());
					//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			  		return;
				}

				if(intResult != 0 ){
					//out.println("���� ����<br>");
					response.sendRedirect("RNewBoxMake.jsp");
				}

		   }
%>
<html>
<script language="JavaScript">
	function init(){
		alert("���� ���� �������� �䱸������ �����մϴ�. ");
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
			//out.print("����<br>");

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

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�䱸���� ������ Error�� �߻��Ͽ����ϴ�.<br>");
				return;
			}

			try {
				intResult = objCommReq.updateBoxNatCnt(objHashData);
			} catch (AppException objAppEx) {

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
				out.println(objAppEx.getStrErrCode() + "<br>");
				out.println("�䱸���������� �䱸�� ȸ�� update �� Error�� �߻��Ͽ����ϴ�.<br>");
				return;
			}

			//out.print("���� ȣ��<br>");

			//out.print("intResult : " + intResult);

			if(intResult != 0 ){
				//out.print("���� ����<br>");
				response.sendRedirect("RCommSchVList.jsp?ReqSchId="+strReqScheId);
			}
		}
%>
