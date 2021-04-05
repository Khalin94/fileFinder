<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.pentasecurity.egsign.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="java.text.*" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<!-- ���������н��� -->
<%
		nads.dsdm.app.activity.userinfo.UserInfoDelegate objUserInfoDelegate = new nads.dsdm.app.activity.userinfo.UserInfoDelegate();
	
	ArrayList objChargeInfoArry = new ArrayList();

	String strError = "no";	
	try
	{

		
		objChargeInfoArry = objUserInfoDelegate.selectChargeCdInfo();

		
		
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		Log.debug.println("Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	
%>

<%
	String webPath = ""; //�̹��� ������ ������ ���
	String imgPath = ""; //�����̹��� ���

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("user.photo.path");

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


	String strImgPath = webPath + imgPath;
	String strFullPath = webPath + imgPath;
 	File objDir = new File(strImgPath); // ������ ���丮 (������)
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
	int intSizeLimit = 200 * 1024 ; // 5�ް����� ���� �Ѿ�� ���ܹ߻�

	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	Hashtable objHashData = new Hashtable();
	//���Ͼ��ε� multi-part
	MultipartRequest multi=new MultipartRequest(request, strImgPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());

	String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	String fileKind = "";

	Enumeration objEnuNames = multi.getParameterNames();
	String strParamName = "";
	Vector objVctMain = new Vector();
	Vector objVctSub = new Vector();

	for(int i =0;objEnuNames.hasMoreElements() ;){

		strParamName = (String)objEnuNames.nextElement();
		Log.debug.println(strParamName+":"+multi.getParameter(strParamName));
		//�Ķ���� ����
		if(strParamName.indexOf("mchr") > -1 )
		{
			Log.debug.println("strParamName main===========>"+multi.getParameter(strParamName));
			objVctMain.add(	multi.getParameter(strParamName));

		}else if(strParamName.indexOf("schr") > -1 )
		{
			Log.debug.println("strParamName sub===========>"+multi.getParameter(strParamName));
			objVctSub.add(	multi.getParameter(strParamName));

		}else {

			objHshReqUserInfo.put(strParamName,multi.getParameter(strParamName));
		}
	}

	objHshReqUserInfo.put("M",objVctMain);
	objHshReqUserInfo.put("S",objVctSub);

	try
	{
		
		Enumeration formNames = multi.getFileNames();
		String strFormName=(String)formNames.nextElement(); 		// �ڷᰡ ���� ��쿣 while ���� ���		
		String strFileName = multi.getFilesystemName(strFormName); 	// ������ �̸� ���
		String strOrgName = multi.getOriginalFileName(strFormName);
		File objFile = multi.getFile(strFormName);
		
		if(strFileName == null) {   // ������ ���ε� ���� �ʾ�����
		
			//out.print("���� ���ε� ���� �ʾ���");
			
		} else {  // ������ ���ε� �Ǿ�����
			strImgPath = imgPath+strFileName;

			if(strFileName.lastIndexOf(".") > 0) {
				fileKind = strFileName.substring(strFileName.lastIndexOf("."));
			}

			File uploadImg = new File(strFullPath,strFileName);
			File renameImg = new File(strFullPath,realDate+fileKind);

			if(uploadImg.renameTo(renameImg) == true) {
				strImgPath = imgPath + renameImg.getName();
			}


			/*
			out.print("Form Name : " + strFormName + "<BR>");
			out.print("File Name  : " + strFileName + "<BR>");
			out.print("Org File Name " + strOrgName + "<BR>");
			out.println("File length : " + objFile.length() + "<br>");
			out.print("===============================<br>");
			*/
		}
		
		if(strFileName != null){
			objHshReqUserInfo.put("PHOTO_PATH",strImgPath);	
		}

		Log.debug.println("[JSP] Delegate ����....����");
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		Log.debug.println("[JSP] Delegate ����....��");
		

		String strPasswd = objJoinMemberDelegate.makePassword();
		objHshReqUserInfo.put("PWD",strPasswd);

		Log.debug.println("[JSP] Delegate Method Call....����");
		int intResult = objJoinMemberDelegate.joinMember(objHshReqUserInfo);
		Log.debug.println("[JSP] Delegate Method Call....��");
		

		if(intResult == 1){

			//sso������ ����Ÿ ����.
			/************************************************************
			 Parameter : {serverIP, port, dir, juminNo, usrId, pwd, svcId}
			 serverIP, port, dir, svcId�� �ϵ��ڵ� �ؾ���. (SSO������ ������ �ٲ�� ��������� ��)
			************************************************************/
			String[] bb = {"10.201.60.4","9001","/egsign/sso/httpreceive_ssoreg.jsp",multi.getParameter("JUMIN_NO"),multi.getParameter("USER_ID"),strPasswd,"65c5b204-b5b6-4552-b275-851c74da9881"};
			System.out.println("aaaaa");
			HttpPostReqReg.main(bb);

			System.out.println(multi.getParameter("JUMIN_NO"));
			System.out.println(multi.getParameter("USER_ID"));
			System.out.println(strPasswd);
		

/*			
			nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsDelegate = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();

			if(objUmsDelegate != null){
				Log.debug.println("[SLJoinMemberBean] UmsDelegate ȣ�� ����!"); 
				objHashData.put("RID", multi.getParameter("USER_ID"));
				objHashData.put("RNAME", multi.getParameter("USER_NM"));
				objHashData.put("RMAIL", multi.getParameter("EMAIL"));
				objHashData.put("SID", "tester1");
				objHashData.put("SNAME", "�����");
				objHashData.put("SMAIL", "newpops@hanmail.net");
				objHashData.put("SUBJECT", "ȸ������");
				objHashData.put("CONTENTS","ȸ�������� ��ī�մϴ�");	
				//objUmsDelegate.insertSMTP_REC(objHashData);	

			}else
				Log.debug.println("[SLJoinMemberBean] UmsDelegate ȣ�� ����!"); 

*/
			//ȸ������ ���Ϻ����� START
			String strGbn_Mail = "joinUser"; 
			String strForumID_Mail = ""; //����ID
			String strRUserID_Mail = multi.getParameter("USER_ID"); //������ID
			String strRUserNM_Mail = "";
			String strCPhone_Mail = "";
			String strRDeptNM_Mail = "";
			String strREmail_Mail = "";

			String strSUserID_Mail = "";
			String strSUserNM_Mail = "";
			String strSOrganNM_Mail = "";
			String strSEmail_Mail = "";
			String strSGovStdCd_Mail = "";

			/* DB�κ��� ���Ͽ� ���� ���� �о���� START */
			try {

				SLDBForumDelegate objForum = new SLDBForumDelegate();

				Hashtable objHashData_Mail = objForum.selectMailInfo(strForumID_Mail, strRUserID_Mail);

				strRUserNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("R_USER_NM")); //�������̸�
				strCPhone_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("CPHONE")); //��ȭ��ȣ
				strREmail_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("R_EMAIL")); //�������̸���
				strRDeptNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("R_DEPT_NM")); //�����ںμ���

				strSUserID_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_USER_ID")); //�߽���ID
				strSUserNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_USER_NM")); //�߽����̸�
				strSEmail_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_EMAIL")); //�߽����̸���
				strSOrganNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_ORGAN_NM")); //�߽��ںμ���
				strSGovStdCd_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_GOV_STD_CD")); //�߽��ںμ�ID
				if(strSGovStdCd_Mail.equals(""))
					strSGovStdCd_Mail = "0000000";
				
			} catch (AppException objAppEx) {
				
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;

			}
			/* DB�κ��� ���Ͽ� ���� ���� �о���� END */


			/* ���ϳ��� START */
			String webURL_Mail = ""; //http �ּ�
			try {

				Config objConfig = PropertyConfig.getInstance(); //������Ƽ
				webURL_Mail = objConfig.get("nads.dsdm.url");

			} catch (ConfigException objConfigEx) {
				out.println(objConfigEx.toString() + "<br>");
				return;
			}

			String strMailContentURL_Mail = webURL_Mail + "/newsletter/";
			strMailContentURL_Mail += "SendUser.jsp?gbn="+strGbn_Mail;
			strMailContentURL_Mail += "&uNM=" + strRUserNM_Mail + "&cPH=" + strCPhone_Mail + "&dNM=" + strRDeptNM_Mail + "&eM=" + strREmail_Mail;
			/* ���ϳ��� END */


			/* ���Ϻ����� START */
			try {

				UmsInfoDelegate objUmsInfo = new UmsInfoDelegate();
				Hashtable objHashData_Mail = new Hashtable();
				int intResult_Mail = 0;

				String strSubject_Mail   = "[�����ڷ� �������� �ý���]ȸ�������� ���ϵ帳�ϴ�."; //����
				String strServiceGbn_Mail = "001"; //���񽺱��� (ȸ������:001 ȸ��Ż��:002 ����ȸ������:003 ����ȸ��Ż��:004)
				String strStatus_Mail    = "0"; //���ۻ���(���۴��='9' ���ۿ�û = '0')
				String strSystemGbn_Mail  = "S13002"; //�ý��۱���(��������:S13002)

				//����������
				objHashData_Mail.put("RID", strRUserID_Mail); //������ID
				objHashData_Mail.put("RNAME", strRUserNM_Mail); //�����ڸ�
				objHashData_Mail.put("RMAIL", strREmail_Mail); //������ �̸���
				//�߽�������
				objHashData_Mail.put("SID", strSUserID_Mail); //�߽���ID
				objHashData_Mail.put("SNAME", strSUserNM_Mail); //�߽��ڸ�
				objHashData_Mail.put("SMAIL", strSEmail_Mail); //�߽��� �̸���

				objHashData_Mail.put("SUBJECT", strSubject_Mail); //����
				objHashData_Mail.put("CONTENTS", strMailContentURL_Mail); //����
				objHashData_Mail.put("SYSTEM_GBN", strSystemGbn_Mail); //�ý��۱���
				objHashData_Mail.put("SERVICE_GBN", strServiceGbn_Mail); //���񽺱���
				objHashData_Mail.put("STATUS", strStatus_Mail); //���ۻ���
				objHashData_Mail.put("DEPT_GBN", strSGovStdCd_Mail); //�μ�����(�μ�ID)
				objHashData_Mail.put("DEPT_NM", strSOrganNM_Mail); //�μ���


				//out.println("<script language='javascript'>alert('strREmail_Mail:"+strREmail_Mail+"');</script>");
				//out.println("<script language='javascript'>alert('strCPhone_Mail:"+strCPhone_Mail+"');</script>");

				intResult_Mail = objUmsInfo.insertSMTP_WEB_REC(objHashData_Mail);
				
				if(intResult_Mail != 0 ){
					//out.println("<br>���� ����<br>");
				}

				if (intResult_Mail < 1) {
%>
					<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
					return;
				}
		
			} catch (AppException objAppEx) {
				
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());

				// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;
		
			}

			/* ���Ϻ����� END */

			//ȸ������ ���Ϻ����� END
		}

		out.println("<script language='javascript'>document.location = '/index.html'</script>");

	}
	catch(Exception objExcept)
	{	

		
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

