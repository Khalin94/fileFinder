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
  out.println("alert('�ڷ� �䱸 ���� ������ ���� �̿��� �Դϴ�.\\n \\n �ڷ� �䱸 �޴��� �̿��ϽǺ��� �����ڿ��� �����ϼ���');");
  out.println("location.href='/main.jsp';");
  out.println("</script>");
  out.println("</html>");
  return;
 }
 */
 //����� �α��εǾ �Ѿ����..
 if(strOff.equals("")){
			String strIsRequester=(String)request.getSession().getAttribute("IS_REQUESTER");
			String strOrganKind=(String)request.getSession().getAttribute("ORGAN_KIND");
			if(!(strIsRequester==null || strIsRequester.length()<1)){
				
				if(strIsRequester.equals("true")){//�䱸��
					if(strOrganKind.equals("004")){//����ȸ ��� 
						response.sendRedirect("/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxList.jsp");
					}else{
						response.sendRedirect("/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxList.jsp");
					}
					blfAAAFlag=true;
				}else{//������
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
