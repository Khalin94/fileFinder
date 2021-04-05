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

<%@ include file="/forum/common/CheckSessionPop.jsp" %>

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
 	//MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new UniqueFileRenamePolicy());

	//String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	//String fileKind = "";

	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fid"))); //포럼ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("uStt"))); //회원상태
	String strCMD = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cmd"))); //수정:upd
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_NM"))); //포럼명
	String strForumSort = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_SORT"))); //포럼분류
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("OPEN_FLAG"))); //공개여부
	String strForumIntro = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_INTRO"))); //포럼소개
	String strImgPathOld = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("IMG_PATH_OLD"))); //기존 이미지데이터
	String strImgPathNew = "";

/*
	out.print("strForumNM : "+strForumNM);
	out.print("<br>strForumSort : "+strForumSort);
	out.print("<br>strOpenFlag : "+strOpenFlag);
	out.print("<br>strForumIntro : "+strForumIntro);
*/
	try {

		SLDBForumDelegate objDBForum = new SLDBForumDelegate();
		Vector objForumData = new Vector(0);
	
		for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){

			String strFormName=(String)formNames.nextElement(); 		// 자료가 많을 경우엔 while 문을 사용

			String strFileName = multi.getFilesystemName(strFormName); 	// 파일의 이름 얻기
			String strOrgName = multi.getOriginalFileName(strFormName);
			File objFile = multi.getFile(strFormName);
		
			if(strFileName == null) {   // 파일이 업로드 되지 않았을때
			
				//out.print("파일 업로드 되지 않았음");
				
			} else {  // 파일이 업로드 되었을때
				strImgPathNew = imgPath + strFileName;

/*
				if(strFileName.lastIndexOf(".") > 0) {
					fileKind = strFileName.substring(strFileName.lastIndexOf("."));
				}

				File uploadImg = new File(strFullPath,strFileName);
				File renameImg = new File(strFullPath,realDate+fileKind);

				if(uploadImg.renameTo(renameImg) == true) {
					strImgPathNew = imgPath + renameImg.getName();
				}
				//out.print("uploadImg="+uploadImg.getName() +"<br>renameImg="+renameImg.getName());
*/

				/*
				out.print("Form Name : " + strFormName + "<BR>");
				out.print("File Name  : " + strFileName + "<BR>");
				out.print("Org File Name " + strOrgName + "<BR>");
				out.println("File length : " + objFile.length() + "<br>");
				out.print("===============================<br>");
				*/
			}

		}	//end for

		objForumData.add(strForumNM);
		objForumData.add(strForumSort);
		objForumData.add(strOpenFlag);
		objForumData.add(strForumIntro);
		if(!strImgPathNew.equals("")) {
			objForumData.add(strImgPathNew);
		}
		objForumData.add(strForumID);

		int intCnt = objDBForum.updateForumInfo(strImgPathNew, objForumData);

		if (intCnt < 1) {
			out.print("에러1");

%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>			
<%
			return;

		} else {
			if(!strImgPathOld.equals("") && !strImgPathNew.equals("")) { //새로운파일이 올라왓을때 기존파일 삭제
				File objExistsFile = new File(webPath + strImgPathOld);
				if(objExistsFile.exists()) {
					objExistsFile.delete();
				}
			}
%>
				<script language="JavaScript">
				<!--
					alert("처리되었습니다.");
					location.href='/forum/indinfo/ForumIndInfo.jsp?fid=<%=strForumID%>&uStt=<%=strUserStt%>';
				//-->
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