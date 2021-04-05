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
	MultipartRequest multi=new MultipartRequest(request, strFullPath, intSizeLimit, "euc-kr", new UniqueFileRenamePolicy());

	//String realDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	//String fileKind = "";

	String strForumNM = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_NM"))); //������
	String strForumOprtrID = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_OPRTR_ID"))); //��ڸ�
	String strForumSort = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_SORT"))); //�����з�
	String strForumStt = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_STT"))); //��������
	String strOpenFlag = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("OPEN_FLAG"))); //��������
	String strForumIntro = this.replaceXss(StringUtil.getNVLNULL(multi.getParameter("FORUM_INTRO"))); //�����Ұ�
	String strImgPath = "";


	try {

		SLDBForumDelegate objDBForum = new SLDBForumDelegate();

		Vector objForumData = new Vector(0);

		//Enumeration formNames = multi.getFileNames();  				// ���� �̸� ��ȯ

		
		for (Enumeration formNames = multi.getFileNames(); formNames.hasMoreElements();){

			String strFormName=(String)formNames.nextElement(); 		// �ڷᰡ ���� ��쿣 while ���� ���		
			String strFileName = multi.getFilesystemName(strFormName); 	// ������ �̸� ���
			String strOrgName = multi.getOriginalFileName(strFormName);
			File objFile = multi.getFile(strFormName);
		
			if(strFileName == null) {   // ������ ���ε� ���� �ʾ�����
			
				//out.print("���� ���ε� ���� �ʾ���");
				
			} else {  // ������ ���ε� �Ǿ�����
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
					 out.println("alert('jpg,gif,png,bmp,jpeg,tiff ������ ���ϸ� ���ε尡���մϴ�.');");
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
				alert("ó���Ǿ����ϴ�.");
				location.href='/forum/openreq/ForumOpenreq.jsp';
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