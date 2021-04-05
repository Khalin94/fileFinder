<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.raonsecure.ksbiz.*"%>
<%@page import="com.raonsecure.ksbiz.log.*"%>
<%
	KSBizLogger.setLog(true);
	KSBizLogger.log("---------- Web App(channelEncryptAction.jsp) ----------");
	KSBizLogger.logWithTime("[RemoteAddr]: " + request.getRemoteAddr());
	KSBizLogger.logWithTime("[RemoteSessionID]: " + session.getId());

	String output = "-1"; 
	try{
		
		// 요청 정보 확인
		// channelEncryptAction.jsp?msg=data		
		String msg = request.getParameter("msg");		
		if(msg == null || msg.equals("")){
			throw new KSBizException(new String("msg is null."), -1);
		}

		KSBiz_v2 ksbiz = (KSBiz_v2)session.getAttribute("KSBIZ_OBJ");
		if(ksbiz == null){
			throw new KSBizException("Key Exchange Channel is not initialized yet.", -1);
			
		}

		// 구간 암호화 채널
		{
			String plain = null;
			plain = ksbiz.symDeCrypt(msg);
			output = ksbiz.symEnCrypt(plain);
		}
	}
	catch(KSBizException e) {
		output = e.getErrorCode() + ":" + e.getMessage();
		KSBizLogger.logWithTime("KSBException occured : " + output);		
	}

	KSBizLogger.log("---------- Server Web Application ----------");
	KSBizLogger.setLog(false);
%>
<%=output%>