<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.reqsubmit.util.*"%>
<%@ page import="nads.lib.reqsubmit.EnvConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.dsdm.app.common.pdfviewdelegate.PdfViewDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.lib.reqsubmit.params.answerinfo.SMemAnsInfoEditForm" %>
<%@ page import = "java.io.*" %>
<%@ page import= "net.sf.jazzlib.ZipEntry"%>
<%@ page import= "net.sf.jazzlib.ZipOutputStream"%>

<%@ page import="nads.lib.message.MessageBean"%>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%

	 String strPluralYn = request.getParameter("PluralYn");
	 //Runtime.getRuntime().runFinalization();
	 //�̿��� ���� ����.
	 long lasttime=session.getLastAccessedTime();
	 long createdtime=session.getCreationTime();
	 long time_used=(lasttime-createdtime)/60000;
	 System.out.println("sessiontimeout : "+time_used+"��");
	 System.out.println("sessionip : "+request.getHeader("Proxy-Client-IP"));

	 Hashtable objHashtable = null;
	 String strPdfFilePath = null;
	 String strDocFilePath = null;
	 String strDocFileName = null;
	 String strPdfFileName = null;
	 Vector  objPdfFilePath  = null;
	 Vector  objDocFilePath  = null;
	 Vector  objDocFileName  = null;
	 Vector  objPdfFileName  = null;
	 String strFileName = null;
	 String strDocName = null;
	 String strUserID = (String)session.getAttribute(CodeConstants.SESSION_USERID);
	 PdfViewDelegate PdfDelegate = new PdfViewDelegate();
	 String[] strAnsIdArray = new String[300];
	 //String[] strDocArray = new String[300];
	 strAnsIdArray = request.getParameterValues("AnsInfoIDs");
	 	 
	 //System.out.println("strAnsId => "  +strAnsIdArray[0]);
	 
	 if(strUserID==null || strUserID.equals("")){
		//throw new ReqsubmitException(request.getRequestURI(),"NoSessionUserInfo","����� ID�� ���ǿ� �������� �ʳ׿�");
		//strUserID="tester1";//���ǿ��� ���� ����� ID Test��. �ءء� �׽�Ʈ ���� ���� ���.
	 }
	 UserInfoDelegate objUserInfo=(UserInfoDelegate)session.getAttribute(CodeConstants.USER_INFO_DELEGATE);
	 if(objUserInfo==null){
		//objUserInfo=new UserInfoDelegate(strUserID);
		objUserInfo=new UserInfoDelegate(request);
		session.setAttribute(CodeConstants.USER_INFO_DELEGATE,(Object)objUserInfo);
	 }
	 
		 // ���� ���ε�� ���
		String filepath = "/mnt/nads/reqsubmit";
		String savePath = "/mnt/nads/reqsubmit/tmpzip";
		
		// ������ ���� ����� ���ϸ�
		String filename = "�ϰ��ٿ�ε�_" + System.currentTimeMillis() + ".zip" ;
		 
		// ���� ������ ���ϸ�
		String orgfilename = "�ϰ��ٿ�ε�.zip" ;
		
		boolean process = false;
		byte[] buffer = new byte[1024];
		ZipEntry ze = null;
		
		FileOutputStream fos = null;

		ZipOutputStream zos = null;
		
		try{
			
			 fos = new FileOutputStream(savePath + "/" + filename);
			 zos = new ZipOutputStream(fos);

		 	if (strAnsIdArray != null)
			{
			int intAnsIDLength = strAnsIdArray.length ;
			System.out.println("intAnsIDLength => " + intAnsIDLength);
	
			for(int i=0; i<intAnsIDLength ; i++) {
				String strAnsId = strAnsIdArray[i];
				objHashtable =   PdfDelegate.getFileInfo(strAnsId);
	
				objPdfFilePath = (Vector)objHashtable.get("PDF_FILE_PATH");
				objDocFilePath = (Vector)objHashtable.get("ORG_FILE_PATH");
				objDocFileName = (Vector)objHashtable.get("ORG_FILE_NAME");
				objPdfFileName = (Vector)objHashtable.get("PDF_FILE_NAME");
				
				strPdfFilePath =  (String)objPdfFilePath.elementAt(0);
				strDocFilePath =  (String)objDocFilePath.elementAt(0);
				strDocFileName =  (String)objDocFileName.elementAt(0);
				strPdfFileName =  (String)objPdfFileName.elementAt(0);

				strFileName = strPdfFilePath.substring(strPdfFilePath.lastIndexOf("/") + 1); //��ȯ�� ����
				strDocName = strDocFilePath.substring(strDocFilePath.lastIndexOf("/") + 1); //��������
				
				System.out.println("kangthis logs strPdfFilePath => " + strPdfFilePath);
				System.out.println("kangthis logs strPdfFilePath => " + strDocFilePath);
				System.out.println("kangthis logs strFileName => " + strFileName);
				System.out.println("kangthis logs strDocName => " + strDocName);
				System.out.println("kangthis logs strDocFileName => " + strDocFileName);
				System.out.println("kangthis logs strPdfFileName => " + strPdfFileName);
				
				ze = new ZipEntry(strDocFileName); //���ϸ�
				zos.putNextEntry(ze);
				//FileInputStream in = new FileInputStream(filepath + "/" + strPdfFilePath); //���ϰ��
				FileInputStream in = new FileInputStream(filepath + "/" + strDocFilePath); //���ϰ��
				int len;
				 while ((len = in.read(buffer)) > 0) {
				  zos.write(buffer, 0, len);
				 }
				 in.close(); 
			}
		}
	 	 zos.closeEntry();
	
		
		 System.out.println("Zip ������ �Ϸ�Ǿ����ϴ�.");

		}catch(IOException ex){
		  System.out.println(" ������ ���� ���� �ʽ��ϴ�.");
		  ex.printStackTrace();
		}catch(Exception ex){
		  ex.printStackTrace();
		}
		finally
		{
			try{if(zos!=null)zos.close();}catch(Exception ex){ ex.printStackTrace();};
			try{if(fos!=null)fos.close();}catch(Exception ex){ ex.printStackTrace();};
		
			//FIXME : buffer Ŭ����
		}
		
		
		request.setCharacterEncoding("utf-8");
		//response.reset() ;
		 

		InputStream in = null;
		OutputStream os = null;
		File file = null;
		boolean skip = false;
		String client = "";


		try{
		    // ������ �о� ��Ʈ���� ���
		    try{
		        file = new File(savePath, filename);
		        in = new FileInputStream(file);
		    }catch(FileNotFoundException fe){
		        skip = true;
		    }
		    
		    client = request.getHeader("User-Agent");

			response.reset();

		    // ���� �ٿ�ε� ��� ����
		    
		    response.setContentType("application/octet-stream");
		    response.setHeader("Content-Description", "JSP Generated Data");


		    if(!skip){
		        // IE
		        if(client.indexOf("MSIE") != -1){
		           // response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
				   response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgfilename.getBytes("euc-kr"),"8859_1"));

		        }else{
		            // �ѱ� ���ϸ� ó��
		           // orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");

		            response.setHeader("Content-Disposition", "attachment; filename=\"" + orgfilename + "\"");
		            response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
		        }  

				System.out.println("file.length()  ; "+file.length());
		         
		        response.setHeader ("Content-Length", ""+file.length() );

				os = new BufferedOutputStream(response.getOutputStream());

				byte b[] = new byte[1024];

		        int leng = 0;
		        
		        while( (leng = in.read(b)) > 0 ){
		            os.write(b,0,leng);
					os.flush();
		        }
				process = true;
				
		    }else{
		        response.setContentType("text/html;charset=UTF-8");
		        out.println("<script language='javascript'>alert('zip������ ����µ� ������ �ֽ��ϴ�.\n�����ڿ��� �����ϼ���');</script>");
		    }
		    
		    in.close();
			os.flush();
		    os.close();
			
			deleteFile(savePath, filename);
		}catch(Exception e){
		  e.printStackTrace();
		}
		finally
		{
			try{if(in!=null)in.close();}catch(Exception ex){ ex.printStackTrace();};
			try{if(os!=null)os.close();}catch(Exception ex){ ex.printStackTrace();};
		}
		
%>

<%!
	void deleteFile(String savePath, String filename)
	{
		try {
	        File delfile = new File(savePath, filename);
	        
			boolean result = delfile.delete();
	
			if(result == false)
			{
				System.out.println("���� ������ ���� ���� �ʽ��ϴ�.");
			}
	
	    } catch(Exception ex) {
			ex.printStackTrace();
		}
	}
%>







