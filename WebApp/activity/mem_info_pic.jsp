<%

	   response.setHeader("Content-Type","image/png"); //�ٿ�ε��� ���� ���� ����.
	   
	   String filename = request.getParameter("mem_code"); // ��û������ ���� �Ѿ�� ���� ���
	   
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