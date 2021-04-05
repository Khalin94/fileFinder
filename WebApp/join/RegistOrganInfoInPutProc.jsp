<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.join.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%		
	//신규인 경우 OrganID가 ''로 넘어옴
	String strOrganID 		= StringUtil.getNVLNULL(request.getParameter("ORGAN_ID")).trim();
	
	//String EncData   		= StringUtil.getNVLNULL(request.getParameter("issacweb_data")).trim();
	

//	String symm_enckey   	= StringUtil.getNVLNULL(request.getParameter("symm_enckey")).trim();
	String username   		= StringUtil.getNVLNULL(request.getParameter("username")).trim();
	
	String eventdate   		= StringUtil.getNVLNULL(request.getParameter("eventdate")).trim();
	
	//String strUserID 		= StringUtil.getNVLNULL(request.getParameter("USER_ID")).trim();
	
	//String strUserNM 		= StringUtil.getNVLNULL(request.getParameter("USER_NM")).trim();
	
	//String strCphone 		= StringUtil.getNVLNULL(request.getParameter("CPHONE")).trim();

	String strORGAN_NM 	= StringUtil.getNVLNULL(request.getParameter("ORGAN_NM")).trim();
	String strINOUT_GBN  	= StringUtil.getNVLNULL(request.getParameter("INOUT_GBN")).trim();

	String strORGAN_GBN	= StringUtil.getNVLNULL(request.getParameter("ORGAN_GBN")).trim();
	String strORGAN_KIND	= StringUtil.getNVLNULL(request.getParameter("ORGAN_KIND")).trim();
	String strPOST_CD1		= StringUtil.getNVLNULL(request.getParameter("POST_CD1")).trim();
	String strPOST_CD2		= StringUtil.getNVLNULL(request.getParameter("POST_CD2")).trim();
	String strPOST_CD		= strPOST_CD1 + strPOST_CD2;
	String strJUSO1 			= StringUtil.getNVLNULL(request.getParameter("JUSO1")).trim();
	String strJUSO2 			= StringUtil.getNVLNULL(request.getParameter("JUSO2")).trim();
	String strTEL_NUM 		= StringUtil.getNVLNULL(request.getParameter("TEL_NUM")).trim();	
	String strFAX_NUM 		= StringUtil.getNVLNULL(request.getParameter("FAX_NUM")).trim();	
	String strHOME_URL 	= StringUtil.getNVLNULL(request.getParameter("HOME_URL")).trim();	
	String strDUTY_SIZE 	= StringUtil.getNVLNULL(request.getParameter("DUTY_SIZE")).trim();	
	String strGOV_GBN 		= StringUtil.getNVLNULL(request.getParameter("GOV_GBN")).trim();
	String strGOV_STD_CD = StringUtil.getNVLNULL(request.getParameter("GOV_STD_CD")).trim();
	String strSTT_CD 		= StringUtil.getNVLNULL(request.getParameter("STT_CD")).trim();	
	String strREMARK  		= StringUtil.getNVLNULL(request.getParameter("REMARK")).trim();
	String strBUSEORANKING  	= StringUtil.getNVLNULL(request.getParameter("BUSEORANKING")).trim();
	String strBUSEOCODE  		= StringUtil.getNVLNULL(request.getParameter("BUSEOCODE")).trim();
	String strReqSubmtCd = StringUtil.getNVLNULL(request.getParameter("strReqSubmtCd")).trim();
	
	//사업자등록번호
	String strOrganNo1 = StringUtil.getNVLNULL(request.getParameter("strOrganNo1")).trim();
	String strOrganNo2 = StringUtil.getNVLNULL(request.getParameter("strOrganNo2")).trim();
	String strOrganNo3 = StringUtil.getNVLNULL(request.getParameter("strOrganNo3")).trim();
	String strOrganNo = strOrganNo1 + strOrganNo2 + strOrganNo3;
	String strCommiteeId = StringUtil.getNVLNULL(request.getParameter("AllCmtOrganID"));
	int resultInt = -1;
	Vector objParam = new Vector();
	
	objParam.add(strORGAN_NM);			//idx : 0
	objParam.add(strINOUT_GBN);			//1
	objParam.add(strORGAN_GBN);
	objParam.add(strORGAN_KIND);
	objParam.add(strGOV_GBN);				//4
	objParam.add(strGOV_STD_CD);	
	objParam.add(strSTT_CD);
	objParam.add(strTEL_NUM);
	objParam.add(strFAX_NUM);
	objParam.add(strPOST_CD);
	objParam.add(strJUSO1);					//idx: 10
	objParam.add(strJUSO2);					
	objParam.add(strHOME_URL);
	objParam.add(strDUTY_SIZE);
	objParam.add(strREMARK);
	objParam.add(strBUSEORANKING);
	objParam.add(strBUSEOCODE);
	objParam.add(strReqSubmtCd);
	objParam.add(strORGAN_NM);
	objParam.add(strOrganNo);
	objParam.add("ADMIN");

	JoinMemberDelegate  objOrgan = new JoinMemberDelegate();
	//UmsInfoDelegate objUmsDelegate = new UmsInfoDelegate();
	
	if(strOrganID.equals("")){	//신규인 경우
		try {
			objParam.add("ADMIN");			//idx : 16	: 생성자ID
			
			strOrganID = objOrgan.setNewOrgan(objParam);
			//System.out.println("ORGAN_ID : "+strOrganID);
			//Hashtable objUserInfoHt = null;
			//objUserInfoHt = objOrgan.getUserInfo("ADMIN");
			//String strSendPhoneNo = StringUtil.ReplaceString((String)objUserInfoHt.get("CPHONE"), "-", "");
			//String strReturnPhoneNo = StringUtil.ReplaceString(strCphone, "-", "");;									
			//strSmsMsg = strUserNM +"님의 "+strORGAN_NM+" 기관신청 요청입니다.";
			//int intSmsSendResult = 0;
			//Hashtable hashSmsInfo = new Hashtable();

			//hashSmsInfo.put("SEND_PHONE_NO", strSendPhoneNo);
			//hashSmsInfo.put("RETURN_NO", strReturnPhoneNo);
			//hashSmsInfo.put("SEND_STATUS", "1"); 
			//hashSmsInfo.put("MSG", strSmsMsg);
			//hashSmsInfo.put("SYSTEM_GBN", "S13002");
			//hashSmsInfo.put("SERVICE_GBN", "003");
			//hashSmsInfo.put("DEPT_GBN", strOrganId);
			//hashSmsInfo.put("USER_ID", strUserID);
			//hashSmsInfo.put("DEPT_NM", strORGAN_NM); 
			//hashSmsInfo.put("USER_NM", strUserNM);

			//intSmsSendResult = objUmsDelegate.insertSMS(hashSmsInfo);

			if(!strCommiteeId.equals("") && !strOrganID.equals("")){
				resultInt = objOrgan.setRelOrgan(strOrganID,"001",strCommiteeId,"ADMIN");
			}
			
			
		} catch (AppException objAppEx) {
		
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());
	
				// 에러 발생 메세지 페이지로 이동한다.
	%>
				<jsp:forward page="../common/message/ViewMsg.jsp"/>
	<%
				return;
	
		}
		
	}
%>	


<form name="frmOrgan" method="post">
	<input type="hidden" name="ORGAN_ID" value="<%=strOrganID%>">	
	
	<input type="hidden" name="SFLAG" value="Y">
	<input type="hidden" name="username" value="<%=username%>">
	
	<input type="hidden" name="eventdate" value="<%=eventdate%>">
</form>

<script language="javascript">

	frmOrgan.action = "RegistUserInfoInPut.jsp";
	frmOrgan.submit();

</script>