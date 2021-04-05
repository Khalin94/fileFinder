<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.infosearch.history.IsHistorySelectDelegate" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<html>
<head>
<title>국회 의정활동 서류제출 정보관리 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<script language="javascript">

function search_submit()
{
	if(document.list.p_strSrch_start.value > document.list.p_strSrch_end.value)
	{
		alert("시작년도가 종료년도보다 큽니다.");
		document.list.p_strSrch_start.focus();
		return ;
	}

	document.list.submit();
}

</script>
<script language="JavaScript">
function GotoPage(form,strRn_start, strRn_end,strUser_id,strMenu_cd,strSrch_start,strSrch_end){	

	form.p_strRn_start.value=strRn_start;
	form.p_strRn_end.value=strRn_end;	
	form.submit();
	return;
}
</script>
</head>
<%
	String strRn_start = request.getParameter("p_strRn_start"); 
	if(strRn_start==null) strRn_start = "1";
	String strRn_end = request.getParameter("p_strRn_end"); 
	if(strRn_end==null) strRn_end = "30";
	String strUser_id = (String)session.getAttribute("USER_ID");
	String strMenu_cd = request.getParameter("p_strMenu_cd"); 
	if(strMenu_cd==null) strMenu_cd = "0";
	String strFlag = request.getParameter("p_strFlag"); 
	if(strFlag==null) strFlag = "0";

	Hashtable objHtSelectHistorySysdate;
	IsHistorySelectDelegate objCMD = new IsHistorySelectDelegate();
	
		try {
	
			objHtSelectHistorySysdate = objCMD.selectHistorySysdate(strUser_id);
	
		} catch (AppException objAppEx) {
		
			// 에러 발생 메세지 페이지로 이동한다.
		 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
		  	objMsgBean.setStrMsg(objAppEx.getMessage());
			System.out.println(objAppEx.getStrErrCode());
	%>
		  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%	
			return;
		}


	String strSrch_start = request.getParameter("p_strSrch_start"); 
	if(strSrch_start==null) strSrch_start =(String)objHtSelectHistorySysdate.get("SYSFROM");
	String strSrch_end = request.getParameter("p_strSrch_end"); 
	if(strSrch_end==null) strSrch_end =(String)objHtSelectHistorySysdate.get("SYSTO");

	ArrayList objArrselectHistoryRangeOther;	
	ArrayList objArrselectHistoryRange;		


%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<script language=Javascript src="/js/date_picker.js"></script>
<%//@ include file="/common/TopMenu.jsp" %>
<table width="100%" height="470" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="../image/common/bg_leftMenu.gif">
	<%//@ include file="/common/LeftMenu.jsp" %></td>

    <td width="100%">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="FFF4DF">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<form name="list" action="IsHistorySelectRange.jsp" method="POST" >
        <tr valign="top"> 
          <td width="30" align="left"><img src="../../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="14%" background="../../image/infosearch/bg_infosearch_tit.gif">
                      <span class="title">
                      <%	if(strFlag.equals("0")){%>
                      전체 인기검색어
                      <%}else{%>
                      나의 인기검색어
                      <%}%>
					  </span></td>
                      <td width="26%" align="left" background="../../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="50%" align="right" background="../../image/common/bg_titLine.gif" class="text_s"><img src="../../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;정보검색&gt;<strong>인기검색어</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="50" colspan="2" align="left" class="text_s">시스템 이용자가 검색서비스 이용시 가장 많이 활용한 검색어를 기간별로 조회하실 수 있습니다.</td>
              </tr>
              <tr> 
                <td height="15" colspan="2" align="left" valign="top" class="text_s">&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top" class="text_s"><table width="600" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
                    <tr> 
                      <td height="45" align="center" bgcolor="#F3F3F3"><table width="74%" border="0" cellspacing="3" cellpadding="0">
                          <tr> 
                            <td width="12%" align="left"><img src="../../image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle"> 
                              <strong>기간</strong> </td>
                            <td width="75%" align="left">
					  <input type=hidden name=p_strRn_start value="<%=strRn_start%>" >
					  <input type=hidden name=p_strRn_end value="<%=strRn_end%>" >
					  <input type=hidden name=p_strUser_id value="<%=strUser_id%>" >
					  <input type=hidden name=p_strFlag value="<%=strFlag%>" >		  
					  <input name=p_strSrch_start readonly size=8 value="<%=strSrch_start%>" ><input type="button" value="입력" style="cursor:hand" OnClick="javascript:show_calendar('list.p_strSrch_start');"> ~ 
					  <input name=p_strSrch_end readonly size=8 value="<%=strSrch_end%>"><input type="button" value="입력" style="cursor:hand" OnClick="javascript:show_calendar('list.p_strSrch_end');">
					  
				    </td>
                            <td width="13%" align="left"><strong><a href="JavaScript:search_submit();"><img src="../../image/button/bt_gumsack_icon.gif" width="47" height="19" align="absmiddle" border=0></a></strong></td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" align="left" valign="top" class="text_s"></td>
              </tr>
              <tr> 
                <td height="30" align="left" valign="middle" class="soti_infosearch"><img src="../../image/infosearch/icon_infosearch_soti.gif" width="9" height="9" align="absmiddle"> 
                  <strong> 
                  <select name="p_strMenu_cd" class="select_infosearch" onchange="search_submit()">
				<option value="0"  <%if (strMenu_cd.equals("0")) {%> selected <%}%>>전체</option>
				<option value="01"  <%if (strMenu_cd.equals("01")) {%> selected <%}%>>요구제출자료</option>
				<option value="05"  <%if (strMenu_cd.equals("05")) {%> selected <%}%>>회의등록자료</option>
				<option value="02"  <%if (strMenu_cd.equals("02")) {%> selected <%}%>>위원회홈페이지</option>
				<option value="03"  <%if (strMenu_cd.equals("03")) {%> selected <%}%>>관련기관웹사이트</option>
				<option value="04"  <%if (strMenu_cd.equals("04")) {%> selected <%}%>>News(신문)검색</option>

                  </select>

                  </strong></td>
              </tr>
              <tr> 
                <td height="253" align="left" valign="top" class="soti_infosearch"><table width="600" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="2" colspan="3" class="td_infosearch"></td>
                    </tr>
                    <tr align="center" class="td_top"> 
                      <td width="59" height="22">순위</td>
                      <td width="365" height="22">검색어</td>
                      <td width="76">회수</td>
                    </tr>
                    <tr> 
                      <td height="1" colspan="3" class="td_infosearch"></td>
                    </tr>

<%	if(strFlag.equals("0"))
	{
			try {
		
				Vector objVecselectHistoryRangeOther = new Vector();
				objVecselectHistoryRangeOther.add(strSrch_start);
				objVecselectHistoryRangeOther.add(strSrch_end);
				objVecselectHistoryRangeOther.add(strMenu_cd);
				objVecselectHistoryRangeOther.add(strRn_start);
				objVecselectHistoryRangeOther.add(strRn_end);

		
				objArrselectHistoryRangeOther = objCMD.selectHistoryRangeOther(objVecselectHistoryRangeOther);
			
			} catch (AppException objAppEx) {
			
				// 에러 발생 메세지 페이지로 이동한다.
			 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
			  	objMsgBean.setStrMsg(objAppEx.getMessage());
				System.out.println(objAppEx.getStrErrCode());
		%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%	
				return;
			}

	
	for (int i = 0; i < objArrselectHistoryRangeOther.size(); i++) {
	Hashtable objHashBSorts = (Hashtable)objArrselectHistoryRangeOther.get(i);
%>

                    <tr  align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22"><%=objHashBSorts.get("RN")%></td>
                      <td height="22" align="left" class="td_lmagin"><a href="/infosearch/ISearch_All01.jsp?iptName=<%=objHashBSorts.get("SRCH_WORD")%>&sflag=1"><%=objHashBSorts.get("SRCH_WORD")%></a></td>
                      <td><%=objHashBSorts.get("CNT")%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                      <td></td>
                    </tr>
	<%}%>

<%	}else {


			try {
		
				Vector objVecselectHistoryRange = new Vector();	
				objVecselectHistoryRange.add(strSrch_start);
				objVecselectHistoryRange.add(strSrch_end);
				objVecselectHistoryRange.add(strUser_id);
				objVecselectHistoryRange.add(strMenu_cd);	
				objVecselectHistoryRange.add(strRn_start);
				objVecselectHistoryRange.add(strRn_end);
		
				objArrselectHistoryRange = objCMD.selectHistoryRange(objVecselectHistoryRange);
			
			} catch (AppException objAppEx) {
			
				// 에러 발생 메세지 페이지로 이동한다.
			 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
			  	objMsgBean.setStrMsg(objAppEx.getMessage());
				System.out.println(objAppEx.getStrErrCode());
		%>
			  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
		<%	
				return;
			}


	for (int i = 0; i < objArrselectHistoryRange.size(); i++) {
	Hashtable objHashBSorts = (Hashtable)objArrselectHistoryRange.get(i);

%>

                    <tr  align="center" onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22"><%=objHashBSorts.get("RN")%></td>
                      <td height="22" align="left" class="td_lmagin"><a href="/infosearch/ISearch_All01.jsp?iptName=<%=objHashBSorts.get("SRCH_WORD")%>&sflag=1"><%=objHashBSorts.get("SRCH_WORD")%></a></td>
                      <td><%=objHashBSorts.get("CNT")%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                      <td></td>
                    </tr>

	<%}%>

<%}%>
                  </table></td>

              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_infosearch"><table width="600" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td height="35" align="center">
<!--                      | <a href="JavaScript:GotoPage(document.list,'1','10','<%=strUser_id%>','<%=strMenu_cd%>','<%=strSrch_start%>','<%=strSrch_end%>')">1-10위</a>-->
<!--                      | <a href="JavaScript:GotoPage(document.list,'11','20','<%=strUser_id%>','<%=strMenu_cd%>','<%=strSrch_start%>','<%=strSrch_end%>')">11-20위</a>-->
<!--			    	  | <a href="JavaScript:GotoPage(document.list,'21','30','<%=strUser_id%>','<%=strMenu_cd%>','<%=strSrch_start%>','<%=strSrch_end%>')">21-30위</a>-->
                      </td>
                    </tr>
                  </table></td>
              </tr>


              <tr> 
                <td height="35" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</form>
<%//@ include file="../../common/Bottom.jsp" %>
</body>
</html>
