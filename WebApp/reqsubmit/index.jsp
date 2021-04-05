<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>

<%
	String strReqIP = request.getRemoteAddr();
	session.setAttribute("MSG_OPEN_GBN", "N");
	String strOff=request.getParameter("Off");
	String strFlag=request.getParameter("flag"); 
	boolean blfAAAFlag=false;
	if(strOff==null) strOff="";
/*
 String strReqSubmtFlag=(String)request.getSession().getAttribute("REQ_SUBMT_FLAG");
 if(strReqSubmtFlag!=null && strReqSubmtFlag.equals("004")){
  out.println("<html>");
  out.println("<script language=\"javascript\">");
  out.println("alert('자료 요구 제출 관한이 없는 이용자 입니다.\\n \\n 자료 요구 메뉴를 이용하실분은 관리자에게 문의하세요');");
  out.println("location.href='/main.jsp';");
  out.println("</script>");
  out.println("</html>");
  return;
 }
 */
 //제대로 로그인되어서 넘어오면..
 if(strOff.equals("")){
			String strIsRequester=(String)request.getSession().getAttribute("IS_REQUESTER");
			String strOrganKind=(String)request.getSession().getAttribute("ORGAN_KIND");
			if(!(strIsRequester==null || strIsRequester.length()<1)){
				
				if(strIsRequester.equals("true")){//요구자
					if(strOrganKind.equals("004")){//위원회 사람 
						response.sendRedirect("/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxList.jsp");
					}else{
						response.sendRedirect("/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp");
					}
					blfAAAFlag=true;
				}else{//제출자
					response.sendRedirect("/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxList.jsp");
					blfAAAFlag=true;
				}
			} 	
 }else{
	out.println("<script language=\"javascript\">");
	out.println("location.href='http://naps.assembly.go.kr';");
	out.println("</script>");
 }
%>
