<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> 
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.raonsecure.ksbiz.*" %>
<%@ page import="com.raonsecure.ksbiz.log.*" %>
<%
	KSBiz_v2 ksobj = new KSBiz_v2(); 
	String uploadPath = "//var//tmp//nxbiz//";
	/*String uploadDir = "download";
	ServletContext context = getServletContext();
	String uploadPath = context.getRealPath(uploadDir) + File.separator;*/
	
	String outputFileName = uploadPath + "server.fenv";
	String inputFileName = uploadPath + request.getParameter("filename");
	String encData = request.getParameter("ksbizEnc").trim();

	String decryptData="";
	int errorCode = -1;
	String errMsg = "";
	try 
	{
		ksobj.libInit();
		KSBizLogger.log("lib init success");
		
		decryptData = ksobj.decodeEnv(encData, (String)session.getAttribute("KSBIZ_SID"));
		errorCode = ksobj.getErrorCode();
		
		if(errorCode != 0)
		{
			throw new KSBizException("DecodeEnv Failed", errorCode);
		}
		KSBizLogger.setLog(true);
		KSBizLogger.log("decryptData : " + decryptData);
		KSBizLogger.log("outputFileName : " + outputFileName);
		KSBizLogger.log("inputFileName : " + inputFileName);
		
		ksobj.encodeFileW(outputFileName, inputFileName);
		
		if(ksobj.getErrorCode() != 0)
		{
			throw new KSBizException(ksobj.getErrorMsg(), ksobj.getErrorCode());
		}
	} 
	catch ( KSBizException e ) 
	{
		KSBizLogger.log("KSBException occured : " + e.getMessage());
	}

	File f = new File(outputFileName);
	if(f.exists()){
		long f_size = f.length();
		byte[] buf = new byte[(int)f_size];
		int byteRead = 0;
		
		BufferedInputStream bis = null;
		InputStream fis = null;
		BufferedOutputStream bos = null;
		ServletOutputStream fos = null;
		try{
			response.setContentType("application/x-msdownload");
			response.setHeader("Content-Disposition", "attachment;filename=data.fsenc;");
			
			fis = new FileInputStream(f);
			bis = new BufferedInputStream(fis);
			
			out.clear();
			out = pageContext.pushBody();
			
			fos = response.getOutputStream();
			bos = new BufferedOutputStream(fos);
			
			while((byteRead = bis.read(buf)) != -1){
				bos.write(buf, 0, byteRead);
				bos.flush();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try{
				if(fis != null)
				fis.close();
				if(bis != null)
				bis.close();
				if(fos != null)
				fos.close();
				if(bos != null)
				bos.close();
			}catch(Exception e){}
		}
	}
%>