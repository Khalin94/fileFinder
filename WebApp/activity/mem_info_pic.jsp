<%

	   response.setHeader("Content-Type","image/png"); //다운로드할 파일 형식 결정.
	   
	   String filename = request.getParameter("mem_code"); // 요청페이지 에서 넘어온 파일 경로
	   
	   if(filename == null || filename.equals("")){
			return;
	   }
	   nads.lib.reqsubmit.encode.Base64Code base = new nads.lib.reqsubmit.encode.Base64Code();
	   nads.lib.reqsubmit.util.HashEncrypt base2 = new nads.lib.reqsubmit.util.HashEncrypt();
	   byte[] aa = base.decode(filename);
	   String ss = new String(aa);
	   filename = base2.decrypt(ss);
	   response.sendRedirect("http:naps.assembly.go.kr/"+filename);
	   return;
%>