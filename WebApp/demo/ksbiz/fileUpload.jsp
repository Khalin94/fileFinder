<%@page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> 
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.raonsecure.ksbiz.KSBiz_v2" %>
<%
	String uploadPath = "//var//tmp//nxbiz";
/* 	String uploadDir = "download";
	ServletContext context = getServletContext();
	String uploadPath = context.getRealPath(uploadDir); */
	
	//int size = 10*1024*1024;
 	int size = 2100000000;
	String message = null;
	KSBiz_v2 ksobj = new KSBiz_v2();
	try{
  		ksobj.libInit();
  		
  		String filePath = uploadPath + System.getProperty("file.separator");
  		String outputFilePath = "";
  		String inputFilePath = "";
  		
		MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "utf-8", new DefaultFileRenamePolicy());
  		Enumeration files = multi.getFileNames();
 		
  		String file = (String)files.nextElement();
		String filename = multi.getFilesystemName(file);
		
  		if(filename != null){
	  		message = filename;
  		} else{
	  		message="fail to upload file";
	  		System.out.println(message);
  		}
  		
 	}catch(Exception e){
		message="fail to upload file";
		e.printStackTrace();
 	}
	System.out.println(message);
%>
{"result":"<%=message%>",
 "errorCode":<%=ksobj.getErrorCode()%>,
 "errorMsg":"<%=ksobj.getErrorMsg()%>"}