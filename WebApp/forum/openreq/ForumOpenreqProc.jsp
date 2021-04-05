<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="nads.dsdm.app.forum.SLDBForumDelegate" %>
<%@ page import=" java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="nads.lib.fileupdown.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="kr.co.kcc.pf.exception.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.session.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%@ include file="/common/CheckSession.jsp" %>

<%
	String webPath = ""; //이미지 저장할 물리적 경로
	String imgPath = ""; //포럼이미지 경로

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("forum.title.image.path");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>

<%
	String strFullPath = webPath + imgPath;
 	File objDir = new File(strFullPath); // 저장할 디렉토리 (절대경로)
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
	
 	int intSizeLimit = 5 * 1024 * 1024 ; // 5메가까지 제한 넘어서면 예외발생
	MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new UniqueFileRenamePolicy());

	//String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	//String fileKind = "";

	String strForumNM = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_NM"))); //포럼명
	String strForumOprtrID = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_OPRTR_ID"))); //운영자명
	String strForumSort = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_SORT"))); //포럼분류
	String strForumStt = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_STT"))); //포럼상태
	String strOpenFlag = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("OPEN_FLAG"))); //공개여부
	String strForumIntro = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_INTRO"))); //포럼소개
	String strImgPath = "";


	try {

		SLDBForumDelegate objDBForum = new SLDBForumDelegate();

		Vector objForumData = new Vector(0);

		//Enumeration formNames = multi.getFileNames();  				// 폼의 이름 반환

		
		for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){

			String strFormName=(String)formNames.nextElement(); 		// 자료가 많을 경우엔 while 문을 사용		
			String strFileName = multi.getFilesystemName(strFormName); 	// 파일의 이름 얻기
			String strOrgName = multi.getOriginalFileName(strFormName);
			File objFile = multi.getFile(strFormName);
		
			if(strFileName == null) {   // 파일이 업로드 되지 않았을때
			
				//out.print("파일 업로드 되지 않았음");
				
			} else {  // 파일이 업로드 되었을때
				strImgPath = imgPath+strFileName;
				
				 boolean flag = false;
				 String strOrgNameTemp = null;
				 strOrgNameTemp = strFileName;		 
				 System.out.println("strOrgNameTemp : "+strOrgNameTemp);
				 int pos = strOrgNameTemp.lastIndexOf(".");
				 //String[] strExtensions = nads.lib.reqsubmit.util.StringUtil.split(".",strOrgNameTemp);
				 String strExtension1 = strOrgNameTemp.substring(pos+1);
				 strExtension1 = strExtension1.toLowerCase();
				 String[] strEx = {"jpg", "gif", "png", "bmp", "jpeg", "tiff"};
				
				 for(int i = 0; i < strEx.length ; i++){
					 if(strEx[i].equals(strExtension1)){
						flag = true;
					 }
				 }
				 if(flag == false){
					 out.println("<script language=javascript>");			
					 out.println("alert('jpg,gif,png,bmp,jpeg,tiff 형식의 파일만 업로드가능합니다.');");
					 out.println("history.back(-1)");
					 out.println("</script>");
					 return;
				}
			}			
		}	
		objForumData.add(strForumNM);
		objForumData.add(strForumOprtrID);
		objForumData.add(strForumSort);
		objForumData.add(strForumStt);
		objForumData.add(strOpenFlag);
		objForumData.add(strForumIntro);
		objForumData.add(strImgPath);

		int intCnt = objDBForum.insertForumOpenreq(objForumData);

		if (intCnt < 1) {

%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>			
<%
			return;

		} else {
%>
			<script language="JavaScript">			
				alert("처리되었습니다.");
				location.href='/forum/openreq/ForumOpenreq.jsp';
			</script>
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
%>

<%!
	public String replaceXss(String str){
		
		if(str.equals("") || str == null){			
			str = "";
		}else{
			str = str.replaceAll("<","&lt;");
			str = str.replaceAll(">","&gt;");		
			str = str.replaceAll("\"", "&#34;");
			str = str.replaceAll("\'", "&#39;");
		}		
		
		return str;
	}	
%>