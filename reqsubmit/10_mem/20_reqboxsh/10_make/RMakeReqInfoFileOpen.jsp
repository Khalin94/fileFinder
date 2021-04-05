<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<HTML>
<HEAD>
<Title>제출양식파일 작성</Title>
<FRAMESET ROWS="41,*" BORDER="0">
<FRAME NAME="btns" SRC="./RMakeReqInfoFileOpenTop.jsp">
<FRAME NAME="hwps" SRC="./RMakeReqInfoFileOpenIn.jsp?ReqInfoID=<%=(String)request.getParameter("ReqInfoID")%>">
</FRAMESET>
</HEAD>
</HTML>