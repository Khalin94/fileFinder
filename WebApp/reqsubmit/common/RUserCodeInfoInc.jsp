<%@ page import="java.util.*" %>
<%
	//�̿��� ���� ����.
	try {
		if(!((String)request.getHeader("Proxy-Client-IP")).equals((String)session.getAttribute("CHECKIP"))){
			session.invalidate();
			response.sendRedirect("/index.html");
			return;

			//window.location = "/index.html";
		}
		objUserInfo = new nads.dsdm.app.reqsubmit.delegate.UserInfoDelegate(request);

	} catch(kr.co.kcc.pf.exception.AppException objAppEx) {
		objMsgBean.setMsgType(nads.lib.message.MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode("SYS-00099");//���� Ÿ�� �ƿ�.
		response.sendRedirect("/login/Login4ReSession.jsp");
		return;
	}

	//�ڵ� ���� ����.
	objCdinfo=nads.dsdm.app.reqsubmit.delegate.CDInfoDelegate.getInstance();
%>