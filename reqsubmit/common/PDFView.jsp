<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
	
						
	<%
		String strPdfFileNm = request.getParameter("PDF");
        System.out.println("PDF ���� ���� strPdfFileNm : " + strPdfFileNm);
		
		if(strPdfFileNm.contains("../")){ %>
                <script>
					alert('�߸��� �����Դϴ�.');
					location.href = "http://naps.assembly.go.kr/";
				</script>
	<%	} else {
				String userId = (String)session.getAttribute("USER_ID");
				System.out.println("ID�ִ��� ������ ���� üũ..." + userId);
				if(userId == null || "".equals(userId)) { %>
					<script>
						alert('��ϵ��� ���� ������Դϴ�.\n\r����������� �̵��մϴ�.');
						location.href = "http://nafs.assembly.go.kr/egsign/main/login.jsp";
					</script>
			<%	} else { %>
					<jsp:forward page="/servlet/nads.dsdm.app.reqsubmit.servlets.FastWebViewPdf"/>
			<%	} %>
	<%	} %>
