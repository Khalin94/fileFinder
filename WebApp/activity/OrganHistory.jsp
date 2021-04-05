<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.dsdm.app.join.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.*" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	String strOrganID = StringUtil.getNVLNULL(request.getParameter("strOrganID")).trim();//소속기관코드

	ArrayList objResult = null;




	try
	{	/** 하위기관 대상 목록조회 */
		JoinMemberDelegate  objSLOrganDelegate = new JoinMemberDelegate();
		objResult = objSLOrganDelegate.getOrganHistory(strOrganID);
	}
	catch (Exception objAppEx) {
		System.out.println(objAppEx.toString());
%>
		<jsp:forward page="../common/message/ViewMsg.jsp"/>
<%
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
    <title>기관정보관리-이력정보보기</title>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv="Page-Enter" content="blendTrans(Duration=.01)" />
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=.01)" />
    <script type="text/javascript" src="/js2/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="/js2/jquery.selectbox-0.6.1.js"></script>
    <script type="text/javascript" src="/js2/common.js"></script>
    <link type="text/css" href="/css2/style.css" rel="stylesheet">
	<script language="JavaScript" type="text/JavaScript">
		window.focus();
	</script>
</head>


<body>
<div id="contents" style="width:490px;">
    <div class="myP" style="width:490px; margin-top:10px;">
    <span class="list01_tl">이력정보보기 </span>
    <form name="frmOrgan" method="post" action="OrganSubList.jsp">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
            <tr>
                <th width="44" scope="col">NO</th>
                <th width="160" scope="col">작업</th>
                <th width="161" scope="col">이력내용</th>
                <th width="135" scope="col">작업일</th>
            </tr>
            </thead>
<%
	String strSNO = null;
	String strWK_RECD = null;
	String strHIST_CN = null;
	String strRG_DT = null;

	if(objResult.size() > 0)
	{

		for(int i=0; i<objResult.size(); i++)
		{
			strSNO = i+1+"";//String.valueOf(((Hashtable)(objResult.get(i))).get("SEQ"));
			strWK_RECD = String.valueOf(((Hashtable)(objResult.get(i))).get("WK_RECD_CN"));
			strHIST_CN = String.valueOf(((Hashtable)(objResult.get(i))).get("HIST_CN"));
			strRG_DT = String.valueOf(((Hashtable)(objResult.get(i))).get("RG_DT"));

%>
	<tr>
		<td>
			<%=strSNO%>
		</td>
		<td>
			<%=strWK_RECD%>
		</td>
		<td>
			<%=strHIST_CN%>
		</td>
		<td>
			<%=strRG_DT%>
		</td>
	</tr>


<%

		}

	}else{

%>
	<tr>
		<td align="center" COLSPAN="4">
			검색된 이력이 없습니다.
		</td>
	</tr>
<%
	}
%>
    </table>
    <div id="btn_all" ><span class="right"> <span class="list_bt"><a href="javascript:self.close()">닫기</a></span> </span> </div>
        </div>
        <!-- /contents -->

      </div>
    </div>
</body>
</html>
