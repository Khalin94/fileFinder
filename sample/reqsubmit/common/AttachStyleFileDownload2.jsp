<%@ page language="java"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.http.HttpServlet"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.http.HttpServletResponse"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.util.FileUtil"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
		try{
			
			//파일경로 파람으로 받기.
			String strFilePath = (String)request.getParameter("path");
			if (!StringUtil.isAssigned(strFilePath)){
			  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  	objMsgBean.setStrCode("DSDATA-0015");
			  	objMsgBean.setStrMsg("전달된 경로 없음.");
			  	%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
			  	<%
			  	return;
			}
		
			strFilePath=FileUtil.getFileSeparatorPath(EnvConstants.UNIX_SAVE_PATH + strFilePath);
			String strFileName=FileUtil.getFileName(strFilePath);	
			File dfile        = new File(strFilePath); 
			if(dfile.exists() == false){
			  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			  	objMsgBean.setStrCode("DSDATA-0015");
			  	objMsgBean.setStrMsg("해당 파일이 시스템에 존재하지 않습니다.");
			  	%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
			  	<%
			  	return;
			}else{
				try{
					response.reset();
				}catch(Exception e){}
				int intFileSize      = (int)dfile.length();
				String strClient  = request.getHeader("User-Agent");
				String strFileType = null;;
				strFileName=new String(strFileName.getBytes("EUC_KR"),"8859_1");
				if(strClient.indexOf("MSIE 5.5") != -1) {
					response.setHeader("Content-Disposition","filename="+strFileName+";");
					strFileType   = "doesn/matter";
				} else {
					response.setHeader("Content-Disposition","attachment;filename="+strFileName+";");
					strFileType   = "application/octet-stream";
				}

				response.setContentType(strFileType);
				response.setContentLength(intFileSize);
               
				byte b[] = new byte[1024];
				if (dfile.isFile())
				{
					BufferedInputStream fin = new BufferedInputStream(new FileInputStream(dfile));
					BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
					int read = 0;
					try {
						while ((read = fin.read(b)) != -1){
							outs.write(b,0,read);
						}
						fin.close();
						outs.close();
					} catch (Exception e) {
						System.out.println(e.getMessage());
					} finally {
						if(fin!=null) fin.close();
					}
				}
			}			
		}catch(Exception e){
			System.out.print("Attatched File Download Exception Occur : " + e.toString() + "!!!"); 
		}  
%>