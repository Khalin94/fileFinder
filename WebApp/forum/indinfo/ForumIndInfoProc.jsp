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
	String webPath = ""; //�̹��� ������ ������ ���
	String imgPath = ""; //�����̹��� ���

	try {
	
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ

		webPath = objConfig.get("nads.dsdm.webapp.path");
		imgPath = objConfig.get("forum.title.image.path");

	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>

<%
	String strFullPath = webPath + imgPath;
 	File objDir = new File(strFullPath); // ������ ���丮 (������)
 	if(!objDir.exists()){
 		objDir.mkdirs();
 	}
	
 	int intSizeLimit = 5 * 1024 * 1024 ; // 5�ް����� ���� �Ѿ�� ���ܹ߻�
 	//MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new UniqueFileRenamePolicy());

	//String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	//String fileKind = "";

	String strForumID = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("fid"))); //����ID
	String strUserStt = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("uStt"))); //ȸ������
	String strCMD = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("cmd"))); //����:upd
	String strForumNM = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_NM"))); //������
	String strForumSort = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_SORT"))); //�����з�
	String strOpenFlag = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("OPEN_FLAG"))); //��������
	String strForumIntro = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("FORUM_INTRO"))); //�����Ұ�
	String strImgPathOld = nads.lib.reqsubmit.util.StringUtil.getNoTagStr(StringUtil.getNVLNULL(multi.getParameter("IMG_PATH_OLD"))); //���� �̹���������
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

			String strFormName=(String)formNames.nextElement(); 		// �ڷᰡ ���� ��쿣 while ���� ���

			String strFileName = multi.getFilesystemName(strFormName); 	// ������ �̸� ���
			String strOrgName = multi.getOriginalFileName(strFormName);
			File objFile = multi.getFile(strFormName);
		
			if(strFileName == null) {   // ������ ���ε� ���� �ʾ�����
			
				//out.print("���� ���ε� ���� �ʾ���");
				
			} else {  // ������ ���ε� �Ǿ�����
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
			out.print("����1");

%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>			
<%
			return;

		} else {
			if(!strImgPathOld.equals("") && !strImgPathNew.equals("")) { //���ο������� �ö������ �������� ����
				File objExistsFile = new File(webPath + strImgPathOld);
				if(objExistsFile.exists()) {
					objExistsFile.delete();
				}
			}
%>
				<script language="JavaScript">
				<!--
					alert("ó���Ǿ����ϴ�.");
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

		// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>

		<jsp:forward page="/common/message/ViewMsg.jsp"/>

<%
		return;
		
	}
%>