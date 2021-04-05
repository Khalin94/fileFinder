<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.pentasecurity.egsign.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="java.text.*" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>


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

	for(int i =0;objEnuNames.hasMoreElements() ;){

		strParamName = (String)objEnuNames.nextElement();
		Log.debug.println(strParamName+":"+multi.getParameter(strParamName));
		objHshReqUserInfo.put(strParamName,multi.getParameter(strParamName));
	}


	try
	{
		

		Enumeration formNames = multi.getFileNames();
		String strFormName=(String)formNames.nextElement(); 		// �ڷᰡ ���� ��쿣 while ���� ���		
		String strFileName = multi.getFilesystemName(strFormName); 	// ������ �̸� ���
		String strOrgName = multi.getOriginalFileName(strFormName);
		File objFile = multi.getFile(strFormName);
		
		if(strFileName == null) {   // ������ ���ε� ���� �ʾ�����
		
			out.print("���� ���ε� ���� �ʾ���");
			
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
			String[] bb = {"10.201.60.4","9001","/egsign/sso/httpreceive_ssoreg.jsp",multi.getParameter("JUMIN_NO"),multi.getParameter("USER_ID"),strPasswd,"1d82d4ee-8958-4652-adeb-0054d2435de2"};
			System.out.println("aaaaa");
			HttpPostReqReg.main(bb);

			System.out.println(multi.getParameter("JUMIN_NO"));
			System.out.println(multi.getParameter("USER_ID"));
			System.out.println(strPasswd);
		

			
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

