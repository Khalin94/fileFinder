<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
	
						
	<%
		String strPdfFileNm = request.getParameter("PDF");
        System.out.println("PDF 파일 열기 strPdfFileNm : " + strPdfFileNm);
		
		if(strPdfFileNm.contains("../")){ %>
                <script>
					alert('잘못된 접근입니다.');
					location.href = "http://naps.assembly.go.kr/";
				</script>
	<%	} else {
				String userId = (String)session.getAttribute("USER_ID");
				System.out.println("ID있는지 없는지 여부 체크..." + userId);
				if(userId == null || "".equals(userId)) { %>
					<script>
						alert('등록되지 않은 사용자입니다.\n\r등록페이지로 이동합니다.');
						location.href = "http://nafs.assembly.go.kr/egsign/main/login.jsp";
					</script>
			<%	} else { %>
					<jsp:forward page="/servlet/nads.dsdm.app.reqsubmit.servlets.FastWebViewPdf"/>
			<%	} %>
	<%	} %>
