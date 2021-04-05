<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.pentasecurity.egsign.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="nads.lib.util.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="nads.lib.reqsubmit.encode.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

<%
	String strMessage = "";
	String strError = "no";
	
	String strGrpId = "";
	String strRecordCnt = "";
	String strDisplayKind = "";
	String strPeriod = "";
	try {
	
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ

		strGrpId = objConfig.get("join.userOutGrpId");
		strRecordCnt = objConfig.get("join.srchRecordCnt");
		strDisplayKind = objConfig.get("join.srchDisplayKind");
		strPeriod = objConfig.get("join.gtherPeriod");

	} catch (ConfigException objConfigEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(objConfigEx.getMessage());
		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}
	
	String strPhotoPath = "";
	String strReal = "";
	boolean blnRlt = true;
	String strSuccUserId = ""; 
	try
	{
		String strPreUserId = (String)session.getAttribute("USER_ID");
		String strInOutGbn = (String)session.getAttribute("INOUT_GBN");
		
		Log.debug.println("[JSP] Delegate ����....����");
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		Log.debug.println("[JSP] Delegate ����....��");		
		
		int iChkDn = objJoinMemberDelegate.checkDn(strPreUserId);
		if(iChkDn == 1){     //����Ű�� ������ �����ڸ� ������ �ʿ䰡 ����.
			/**** file upload ****/
			FileUpload fileup=new FileUpload(request.getInputStream());

			String strUserKind = ActComm.fromDB((String)fileup.getParameter("user_kind"));
			String strOffisignFlag = ActComm.fromDB((String)fileup.getParameter("offisign_flag"));
			String strUserNm = ActComm.fromDB((String)fileup.getParameter("user_nm"));
			String strJuminNo1 = ActComm.fromDB((String)fileup.getParameter("jumin_no1"));
			String strJuminNo2 = ActComm.fromDB((String)fileup.getParameter("jumin_no2"));
			String strDeptNm = ActComm.fromDB((String)fileup.getParameter("dept_nm"));
			String strEmail = ActComm.fromDB((String)fileup.getParameter("email"));
			String strOfficeTel1 = ActComm.fromDB((String)fileup.getParameter("office_tel1"));
			String strOfficeTel2 = ActComm.fromDB((String)fileup.getParameter("office_tel2"));
			String strOfficeTel3 = ActComm.fromDB((String)fileup.getParameter("office_tel3"));
			String strFaxNo1 = ActComm.fromDB((String)fileup.getParameter("fax_no1"));
			String strFaxNo2 = ActComm.fromDB((String)fileup.getParameter("fax_no2"));
			String strFaxNo3 = ActComm.fromDB((String)fileup.getParameter("fax_no3"));
			String strCphone1 = ActComm.fromDB((String)fileup.getParameter("cphone1"));
			String strCphone2 = ActComm.fromDB((String)fileup.getParameter("cphone2"));
			String strCphone3 = ActComm.fromDB((String)fileup.getParameter("cphone3"));
			String strPostCd1 = ActComm.fromDB((String)fileup.getParameter("post_cd1"));
			String strPostCd2 = ActComm.fromDB((String)fileup.getParameter("post_cd2"));
			String strJuso1 = ActComm.fromDB((String)fileup.getParameter("juso1"));
			String strJuso2 = ActComm.fromDB((String)fileup.getParameter("juso2"));
			
			strPhotoPath = ActComm.fromDB((String)fileup.getFileName());
			
			/*************** file upload ***********************************/
			if((strPhotoPath != null) && (!strPhotoPath.equals(""))){
				strReal = strPreUserId + "." + fileup.getKST("yyyyMMddHHmmss");
				FileOutputStream upfile = new FileOutputStream(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strReal);
				fileup.UpFile(upfile);
				upfile.close();
			}				
			String strRemark = ActComm.fromDB((String)fileup.getRemark("remark"));
			String strPostCd = strPostCd1 + strPostCd2;
			
			String strFaxNo = "";
			if(!strFaxNo1.equals("")) strFaxNo = strFaxNo1;
			if(!strFaxNo2.equals("")) strFaxNo = strFaxNo + "-" + strFaxNo2;
			if(!strFaxNo3.equals("")) strFaxNo = strFaxNo + "-" + strFaxNo3;

			String strCphone = "";
			if(!strCphone1.equals("")) strCphone = strCphone1;
			if(!strCphone2.equals("")) strCphone = strCphone + "-" + strCphone2;
			if(!strCphone3.equals("")) strCphone = strCphone + "-" + strCphone3;

			String strOfficeTel = "";
			if(!strOfficeTel1.equals("")) strOfficeTel = strOfficeTel1;
			if(!strOfficeTel2.equals("")) strOfficeTel = strOfficeTel + "-" + strOfficeTel2;
			if(!strOfficeTel3.equals("")) strOfficeTel = strOfficeTel + "-" + strOfficeTel3;

			Hashtable objHshUserInfo = new Hashtable();

			objHshUserInfo.put("JUMIN_NO", strJuminNo1 + strJuminNo2);
			objHshUserInfo.put("USER_NM", strUserNm);
			objHshUserInfo.put("GRD_CD", "");
			objHshUserInfo.put("GRD_NM", "");
			objHshUserInfo.put("DEPT_NM", strDeptNm);
			objHshUserInfo.put("POST_CD", strPostCd);	
			objHshUserInfo.put("JUSO1", strJuso1);	
			objHshUserInfo.put("JUSO2", strJuso2);	
			objHshUserInfo.put("EMAIL", strEmail);	
			objHshUserInfo.put("CPHONE", strCphone);	
			objHshUserInfo.put("OFFICE_TEL", strOfficeTel);
			objHshUserInfo.put("FAX_NO", strFaxNo);	
			
			//objHshUserInfo.put("CG_DUTY", strCgDuty);	//�������� ������ �� �ִ� �ڵ�� ����(2004.05.20)
			objHshUserInfo.put("CG_DUTY", ""); 	

			if((strReal != null) && (!strReal.equals(""))){
				objHshUserInfo.put("PHOTO_PATH", AdminIo.getPhoteDir() + strReal);	
			}else{
				objHshUserInfo.put("PHOTO_PATH", "");	
			}
			
			objHshUserInfo.put("STT_CD", "001");
			objHshUserInfo.put("STT_CHG_RSN", "");

			objHshUserInfo.put("USER_GRP_ID", strGrpId);
			objHshUserInfo.put("SRCH_RECORD_CNT", strRecordCnt);
			objHshUserInfo.put("SRCH_DISPLAY_KIND", strDisplayKind);
			objHshUserInfo.put("GTHER_PERIOD", strPeriod);

			objHshUserInfo.put("REMARK", strRemark);//remark	
			
			objHshUserInfo.put("USER_KIND", strUserKind);             //2004.06.17 �߰�
			objHshUserInfo.put("OFFISIGN_FLAG", strOffisignFlag);   //2004.06.17 �߰�
			objHshUserInfo.put("INOUT_GBN", strInOutGbn);      //2004.06.17 �߰�
			objHshUserInfo.put("PRE_USER_ID", strPreUserId);      //2005.03.14 �߰�

			Base64Code objBase64Code = new Base64Code();
			String strPasswd = objJoinMemberDelegate.makePassword();
			objHshUserInfo.put("PWD",objBase64Code.encode(strPasswd));

			strSuccUserId = objJoinMemberDelegate.appSuccessor(strPreUserId, objHshUserInfo);
			if(strSuccUserId != null){

				//sso������ ����Ÿ ����.
				/************************************************************
				 Parameter : {serverIP, port, dir, juminNo, usrId, pwd, svcId}
				 serverIP, port, dir, svcId�� �ϵ��ڵ� �ؾ���. (SSO������ ������ �ٲ�� ��������� ��)
				************************************************************/
				String[] bb = {"10.201.60.9","9001","/egsign/sso/httpreceive_ssoreg.jsp",strJuminNo1 + strJuminNo2, strSuccUserId, strPasswd, "1d82d4ee-8958-4652-adeb-0054d2435de2"};
				HttpPostReqReg.main(bb);

				nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsDelegate = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();

				if(objUmsDelegate != null){
					Hashtable objHashData = new Hashtable();
					Log.debug.println("[SLJoinMemberBean] UmsDelegate ȣ�� ����!"); 
					objHashData.put("RID", strSuccUserId);
					objHashData.put("RNAME", strUserNm);
					objHashData.put("RMAIL", strEmail);
					objHashData.put("SID", "tester1");
					objHashData.put("SNAME", "�����");
					objHashData.put("SMAIL", "newpops@hanmail.net");
					objHashData.put("SUBJECT", "ȸ������");
					objHashData.put("CONTENTS","ȸ�������� ��ī�մϴ�");	
					//objUmsDelegate.insertSMTP_REC(objHashData);	

				}else{
					Log.debug.println("[SLJoinMemberBean] UmsDelegate ȣ�� ����!");
				}
				strMessage = "�����ڰ� ��ϵǾ����ϴ�."; 
			}else{
				strMessage = "�����ڰ� ��ϵ��� �ʾҽ��ϴ�.(Ȯ�ο��)";
				strError = "yes";
			}//if(strSuccUserId != null){
		}else{
			strMessage = "����Ű�� �����Ƿ� �����ڸ� ������ �� �����ϴ�.(�����ڿ��� Ȯ�ο��)";
			strError = "yes";
		}//if(iChkDn == 1){
	}
	catch(Exception objExcept)
	{	
		if((strPhotoPath != null) && (!strPhotoPath.equals(""))){
			blnRlt = AdminIo.deleteIo(AdminIo.getWebappPath() + AdminIo.getPhoteDir()  + strReal) ;
		}				
		String strErrCode = ((AppException)objExcept).getStrErrCode();
		
		if(strErrCode.equals("ORA-00001")){

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0002");
			objMsgBean.setStrMsg("ȸ�������� �̹� �����մϴ�.");
		}
		else
		{
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("SYS-00001");
			objMsgBean.setStrMsg(objExcept.getMessage());
		}

		Log.debug.println( "[���ܹ߻�]\\n" +objExcept.toString());	
		


		
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
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
	location.href="/activity/CreatePerInfoPop.jsp?gubn=2&succid=<%=strSuccUserId%>";
	<%}else{%>
	history.back();
	<%}%>
//-->
</script>