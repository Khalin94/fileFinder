<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="kr.co.kcc.bf.log.Log" %>
<%@ page import="nads.lib.pentasecurity.egsign.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="nads.lib.message.MessageBean" %>
<%@ page import="kr.co.kcc.bf.db.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<!-- 담당업무구분시작 -->
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
	String webPath = ""; //이미지 저장할 물리적 경로
	String imgPath = ""; //포럼이미지 경로

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("user.photo.path");

	} catch (ConfigException objConfigEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(objConfigEx.getMessage());
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}


	String strImgPath = webPath + imgPath;
	String strFullPath = webPath + imgPath;
 	File objDir = new File(strImgPath); // 저장할 디렉토리 (절대경로)
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
	int intSizeLimit = 1000 * 1024 ; // 1메가까지 제한 넘어서면 예외발생

	java.util.Hashtable objHshReqUserInfo = new java.util.Hashtable();
	Hashtable objHashData = new Hashtable();

	MultipartRequest multi = null;

	try{

		multi=new MultipartRequest(request, strImgPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	}
	catch(IOException objIOEx)
	{
		

				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode("DSPARAM-0010");
				//objMsgBean.setStrMsg(objIOEx.getMessage());

				// 에러 발생 메세지 페이지로 이동한다.
%>

				<script>alert("업로드파일은 1Mbyte를 넘을 수 없습니다.");history.back();</script>
<%

			return;
		
		}



	String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	String fileKind = "";

	Enumeration objEnuNames = multi.getParameterNames();
	String strParamName = "";
	Vector objVctMain = new Vector();
	Vector objVctSub = new Vector();

	for(int i =0;objEnuNames.hasMoreElements() ;){

		strParamName = (String)objEnuNames.nextElement();
		Log.debug.println(strParamName+":"+multi.getParameter(strParamName));
		//파라미터 설정
		if(strParamName.indexOf("mchr") > -1 )
		{
			Log.debug.println("strParamName main===========>"+multi.getParameter(strParamName));
			objVctMain.add(	multi.getParameter(strParamName));

		}else if(strParamName.indexOf("schr") > -1 )
		{
			Log.debug.println("strParamName sub===========>"+multi.getParameter(strParamName));
			objVctSub.add(	multi.getParameter(strParamName));

		}else {
			if(strParamName.equals("CERT_DN")){
				System.out.println("XXXXXXXXXXXXXXXXX : "+multi.getParameter(strParamName));
			}
			objHshReqUserInfo.put(strParamName,multi.getParameter(strParamName));
		}
	}

	objHshReqUserInfo.put("M",objVctMain);
	objHshReqUserInfo.put("S",objVctSub);

	try
	{
		
		Enumeration formNames = multi.getFileNames();
		String strFormName=(String)formNames.nextElement(); 		// 자료가 많을 경우엔 while 문을 사용		
		String strFileName = multi.getFilesystemName(strFormName); 	// 파일의 이름 얻기
		String strOrgName = multi.getOriginalFileName(strFormName);
		File objFile = multi.getFile(strFormName);
		
		if(strFileName == null) {   // 파일이 업로드 되지 않았을때
		
			//out.print("파일 업로드 되지 않았음");
			
		} else {  // 파일이 업로드 되었을때
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

		Log.debug.println("[JSP] Delegate 생성....시작");
		nads.dsdm.app.join.JoinMemberDelegate objJoinMemberDelegate = new nads.dsdm.app.join.JoinMemberDelegate();
		Log.debug.println("[JSP] Delegate 생성....끝");
		

		String strPasswd = objJoinMemberDelegate.makePassword();
		objHshReqUserInfo.put("PWD",strPasswd);

		Log.debug.println("[JSP] Delegate Method Call....시작");
		int intResult = objJoinMemberDelegate.joinMember(objHshReqUserInfo);
		Log.debug.println("[JSP] Delegate Method Call....끝");



		/*************************
		* 회원 소속 기관 테이블에 organ_no 저장
		***************************/
		DBAccess objDAO = null;
		try {
			objDAO = new DBAccess(this.getClass());
			
			String strOrganNoOld =StringUtil.getNVLNULL(multi.getParameter("organ_no_old")) ;
			String strOrganNoNew =StringUtil.getNVLNULL(multi.getParameter("organ_no_new")) ;
			String strOrganId =multi.getParameter("ORGAN_ID") ;
			String strSQL = "update tbdm_organ set organ_no = '"+strOrganNoNew+"' where organ_id ='"+strOrganId+"' ";
			if("".equals(strOrganNoOld) == true  && "".equals(strOrganNoNew) != true ) 
			{
				objDAO.setSQL(strSQL,null);
				int retVal=objDAO.doUpdate();
			}
		
		}catch (DBAccessException objDBEx){
				
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objDBEx.getErrCode());
				objMsgBean.setStrMsg(objDBEx.getMessage());

				// 에러 발생 메세지 페이지로 이동한다.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;		
		}finally{

			try {
					
				if(objDAO != null ) objDAO.release();
					
			} catch (DBAccessException objDBEx) {
	
				
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objDBEx.getErrCode());
				objMsgBean.setStrMsg(objDBEx.getMessage());

				// 에러 발생 메세지 페이지로 이동한다.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;					
			}
		}

		

		if(intResult == 1){


			//sso서버로 데이타 전송.
			/************************************************************
			 Parameter : {serverIP, port, dir, juminNo, usrId, pwd, svcId}
			 serverIP, port, dir, svcId는 하드코딩 해야함. (SSO서버의 정보가 바뀌면 수정해줘야 함)
			************************************************************/
              String[] bb = {"10.201.12.130","9001","/egsign/sso/httpreceive_ssoreg.jsp",multi.getParameter("JUMIN_NO"),multi.getParameter("USER_ID"),strPasswd,"5187503d-baf8-4f69-88a8-3a232f00db72"};

			//HttpPostReqReg.main(bb);


			//System.<I></I>out.println(multi.getParameter("JUMIN_NO"));
			//System.out.println(multi.getParameter("USER_ID"));
			//System.out.println(strPasswd);
		

/*			
			nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate objUmsDelegate = new  nads.dsdm.app.reqsubmit.delegate.common.UmsDelegate();

			if(objUmsDelegate != null){
				Log.debug.println("[SLJoinMemberBean] UmsDelegate 호출 성공!"); 
				objHashData.put("RID", multi.getParameter("USER_ID"));
				objHashData.put("RNAME", multi.getParameter("USER_NM"));
				objHashData.put("RMAIL", multi.getParameter("EMAIL"));
				objHashData.put("SID", "tester1");
				objHashData.put("SNAME", "양재경");
				objHashData.put("SMAIL", "newpops@hanmail.net");
				objHashData.put("SUBJECT", "회원가입");
				objHashData.put("CONTENTS","회원가입을 추카합니다");	
				//objUmsDelegate.insertSMTP_REC(objHashData);	

			}else
				Log.debug.println("[SLJoinMemberBean] UmsDelegate 호출 실패!"); 

*/

			//회원가입 메일보내기 START
			String strGbn_Mail = "joinUser"; 
			String strForumID_Mail = ""; //포럼ID
			String strRUserID_Mail = multi.getParameter("USER_ID"); //수신자ID
			String strSessInOutGbn_Mail = multi.getParameter("INOUT_GBN"); //내외부구분

			String strRUserNM_Mail = "";
			String strREmail_Mail = "";

			String strSUserID_Mail = "";
			String strSUserNM_Mail = "";
			String strSOrganNM_Mail = "";
			String strSEmail_Mail = "";
			String strSGovStdCd_Mail = "";

			// DB로부터 메일에 보낼 정보 읽어오기 START
			try {

				SLDBForumDelegate objForum = new SLDBForumDelegate();

				Hashtable objHashData_Mail = objForum.selectMailInfo(strForumID_Mail, strRUserID_Mail);

				strRUserNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("R_USER_NM")); //수신자이름
				strREmail_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("R_EMAIL")); //수신자이메일

				strSUserID_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_USER_ID")); //발신자ID
				strSUserNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_USER_NM")); //발신자이름
				strSEmail_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_EMAIL")); //발신자이메일
				//strSEmail_Mail = "paper@assembly.go.kr";
				strSOrganNM_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_ORGAN_NM")); //발신자부서명
				strSGovStdCd_Mail = StringUtil.getNVLNULL((String)objHashData_Mail.get("S_ORGAN_ID")); //발신자부서ID
				if(strSGovStdCd_Mail.equals(""))
					strSGovStdCd_Mail = "0000000";
				
			} catch (AppException objAppEx) {
				
				objMsgBean.setMsgType(MessageBean.TYPE_ERR);
				objMsgBean.setStrCode(objAppEx.getStrErrCode());
				objMsgBean.setStrMsg(objAppEx.getMessage());

				// 에러 발생 메세지 페이지로 이동한다.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;

			}
			// DB로부터 메일에 보낼 정보 읽어오기 END


			// 메일내용 START
			String webURL_Mail = ""; //http 주소
			try {

				Config objConfig = PropertyConfig.getInstance(); //프로퍼티
				webURL_Mail = objConfig.get("nads.dsdm.url");

			} catch (ConfigException objConfigEx) {
				out.println(objConfigEx.toString() + "<br>");
				return;
			}

			String strMailContentURL_Mail = webURL_Mail + "/newsletter/";
			strMailContentURL_Mail += "SendUser.jsp?gbn="+strGbn_Mail+"&inout="+strSessInOutGbn_Mail+"&uid="+strRUserID_Mail;
			// 메일내용 END


			// 메일보내기 START
			try {

				UmsInfoDelegate objUmsInfo = new UmsInfoDelegate();
				Hashtable objHashData_Mail = new Hashtable();
				int intResult_Mail = 0;

				String strSubject_Mail   = "[의정자료 전자유통 시스템]사용자등록을 축하드립니다."; //제목
				String strServiceGbn_Mail = "001"; //서비스구분 (회원가입:001 회원탈퇴:002 포럼회원가입:003 포럼회원탈퇴:004)
				String strStatus_Mail    = "0"; //전송상태(전송대기='9' 전송요청 = '0')
				String strSystemGbn_Mail  = "S13002"; //시스템구분(정보관리:S13002)

				//수신자정보
				objHashData_Mail.put("RID", strRUserID_Mail); //수신자ID
				objHashData_Mail.put("RNAME", strRUserNM_Mail); //수신자명
				objHashData_Mail.put("RMAIL", strREmail_Mail); //수신자 이메일
				//발신자정보
				objHashData_Mail.put("SID", strSUserID_Mail); //발신자ID
				objHashData_Mail.put("SNAME", strSUserNM_Mail); //발신자명
				objHashData_Mail.put("SMAIL", strSEmail_Mail); //발신자 이메일

				objHashData_Mail.put("SUBJECT", strSubject_Mail); //제목
				objHashData_Mail.put("CONTENTS", strMailContentURL_Mail); //내용
				objHashData_Mail.put("SYSTEM_GBN", strSystemGbn_Mail); //시스템구분
				objHashData_Mail.put("SERVICE_GBN", strServiceGbn_Mail); //서비스구분
				objHashData_Mail.put("STATUS", strStatus_Mail); //전송상태
				objHashData_Mail.put("DEPT_GBN", strSGovStdCd_Mail); //부서구분(부서ID)
				objHashData_Mail.put("DEPT_NM", strSOrganNM_Mail); //부서명

				intResult_Mail = objUmsInfo.insertSMTP_WEB_REC(objHashData_Mail);
				
				if(intResult_Mail != 0 ){
					//out.println("<br>생성 성공<br>");
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

				// 에러 발생 메세지 페이지로 이동한다.
%>

				<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
				return;
		
			}

			// 메일보내기 END
		}

		out.println("<script language='javascript'>alert('정상처리 되었습니다.');document.location = '/index.html'</script>");

	}
	catch(Exception objExcept)
	{	

		
		String strErrCode = ((AppException)objExcept).getStrErrCode();
		
		if(strErrCode.equals("ORA-00001")){

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("DSDATA-0002");
			objMsgBean.setStrMsg("회원정보가 이미 존재합니다.");
		}
		else
		{
			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode("SYS-00001");
			objMsgBean.setStrMsg(objExcept.getMessage());
		}

		Log.debug.println( "[예외발생]\\n" +objExcept.toString());	
		


		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>	
<%
		return;
	}
	
%>

