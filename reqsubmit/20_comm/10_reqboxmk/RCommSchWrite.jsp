<%@ page language="java" contentType="text/html;charset=euc-kr" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
     //로그인한 사용자ID를 가져온다.
 	String strUserID   = objUserInfo.getUserID();

	String strYear        = StringUtil.getNVLNULL(request.getParameter("strYear"));             //년도
	String strOrganId   = StringUtil.getNVLNULL(request.getParameter("strOrganId"));       //위원회 ID
	String strOrganNm   = StringUtil.getNVLNULL(request.getParameter("strOrganNm"));  //위원회명

	//※Delegate 선언※.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	Hashtable objHashYear = new Hashtable();
	objHashYear= objCommReq.selectSysDate();
    //시스템 일자
    strYear = (String)objHashYear.get("SYS_DATE");
    String strYearDate = (String)objHashYear.get("YEARDATE");

	Hashtable objHashCnt = new Hashtable();
	objHashCnt = objCommReq.selectSchCnt(strYear, strOrganId);
	//차수
	String strMaxCnt = (String)objHashCnt.get("MAX_CNT");

	if ( strMaxCnt == null || strMaxCnt.equals("") ) {
		strMaxCnt = "1";
	}

	//사용자 메일, 전화번호를 가져온다.
	Hashtable objHashUserInfo = new Hashtable();
	objHashUserInfo = objCommReq.selectUserInfo(strUserID);
	String strMail    = StringUtil.getNVL((String)objHashUserInfo.get("EMAIL"),"등록되어 있지 않음");
	String strOffiTel = StringUtil.getNVL((String)objHashUserInfo.get("OFFICE_TEL"),"--");
	//out.print("strMail : " + strMail + "<br>");
	//out.print("strOffiTel : " + strOffiTel + "<br>");
	//out.print("strOffiTel : " + strOrganId + "<br>");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>

<script language="javascript">

function fUsrAction(mode) {
  switch(mode) {
    case "list" :
         if (!fCheckField()) return false;

	     if (!confirm("요구 일정을 등록하시겠습니까?\r\n[참조해 주세요]\r\n요구일정이 등록되면 자동으로 위원회 소속 의원실 사용자에게 e-mail이 발송됩니다.")) {
	         return false;
	     };
         form1.action="RCommSchProc.jsp";
         form1.submit();
         break;
  }
}

function fCheckField() {
	var strReturn = "";
  	with (form1) {
	    if (str_day.value == '') {
			strReturn = strReturn + "- 접수기간 시작일\n";
    	}
	    if (end_day.value == '') {
			strReturn = strReturn + "- 접수기간 마감일\n";
    	}
	    if (send_end_day.value == '') {
			strReturn = strReturn + "- 제출완료일\n";
    	}
	    if (NatCnt.value == '') {
			strReturn = strReturn + "- 회기\n";
    	}

		if (strReturn.length != 0 || strReturn != "") {
			strReturn = "[아래 필수 항목 입력이 누락되었습니다. 확인 바랍니다]\n\n" + strReturn;
			alert(strReturn);
			return;
		}
		if (Year.value != (str_day.value).replace("-","").replace("-","").substr(0,4)) {
	    	alert('접수기간 시작일을 ' + Year.value + '년도로 선택하세요');
			str_day.focus();
	    	return false;
	    }
	    if ((str_day.value).replace("-","").replace("-","") < (YearDate.value).replace("-","").replace("-","") ) {
			alert('접수기간 시작일을 ' + YearDate.value + '일 이후 날짜로 선택하세요');
			str_day.focus();
			return false;
		}
	    if (Year.value != (end_day.value).replace("-","").replace("-","").substr(0,4)) {
			alert('접수기간 마감일을 ' + Year.value + '년도로 선택하세요');
			end_day.focus();
			return false;
		}
		if ((end_day.value).replace("-","").replace("-","") < (YearDate.value).replace("-","").replace("-","") ) {
			alert('접수기간 마감일 ' + YearDate.value + '일 이후 날짜로 선택하세요');
			end_day.focus();
			return false;
		}
		if ((end_day.value).replace("-","").replace("-","")  < (str_day.value).replace("-","").replace("-","")) {
			alert('접수기간 마감일이 접수기간 시작일보다 작습니다.');
			end_day.focus();
			return false;
		}
		if (Year.value != (send_end_day.value).replace("-","").replace("-","").substr(0,4)) {
			alert('제출완료일을 ' + Year.value + '년도로 선택하세요');
			send_end_day.focus();
			return false;
		}
		if ((send_end_day.value).replace("-","").replace("-","")  < (end_day.value).replace("-","").replace("-","")) {
			alert('제출완료일이 접수기간 마감일보다 작습니다.');
			end_day.focus();
			return false;
		}
	}
	return true;
}
</script>
<head>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="<%=request.getRequestURI()%>">
        <input type="hidden" name="cmd" value="creat">
        <input type="hidden" name="Year" value="<%=strYear%>" >
        <input type="hidden" name="OrganId" value="<%=strOrganId%>" >
        <input type="hidden" name="OrganNm" value="<%=strOrganNm%>" >
        <input type="hidden" name="MaxCnt"  value="<%=strMaxCnt%>" >
        <input type="hidden" name="YearDate"  value="<%=strYearDate%>" >
        <input type="hidden" name="Mail"  value="<%=strMail%>" >
        <input type="hidden" name="OffiTel"  value="<%=strOffiTel%>" >

        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strYear%>년도 <%=MenuConstants.REQ_BOX_SCH_SAVE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH_SAVE%></B></div>
        <p><!--문구--></p>
        </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <span class="list02_tl">요구일정 정보 </span>
        <table cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;위원회 </th>
                      <td height="25"><%=strOrganNm%></td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;차수</th>
                      <td height="25"><%=strMaxCnt%>차</td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;접수기간</th>
                      <td height="25">
					  	<!--
						<input type="text" style="font-size:11px;font-family:verdana,돋움" class="textbox" name="str_day" size="10" maxlength="8" value=""  readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" >
					    <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.str_day);"/>	&nbsp;&nbsp; ~	&nbsp;&nbsp;
       					<input type="text" style="font-size:11px;font-family:verdana,돋움" class="textbox" name="end_day" size="10" maxlength="8" value="" readonly  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;">
					    <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.end_day);"/>
						-->
						<input type="text" class="textfield" name="str_day" size="10" maxlength="8" value=""  readonly" >
                <a href="#" OnClick="javascript:show_calendar('form1.str_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
			    <input type="text" class="textfield" name="end_day" size="10" maxlength="8" value="" readonly">
			    <a href="#" OnClick="javascript:show_calendar('form1.end_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>

                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;제출 완료일</th>
                      <td height="25">
				      	<input type="text" style="font-size:11px;font-family:verdana,돋움" class="textbox" name="send_end_day" size="10" maxlength="8" value="" readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" >일 까지
						<!--<img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.send_end_day);">-->
						<a href="#" OnClick="javascript:show_calendar('form1.send_end_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;회기</th>
                      <td height="25">
						제<input type="text" style="font-size:11px;font-family:verdana,돋움" size="3" maxlength="3" name="NatCnt"  onChange="javascript:CheckNumeric(this)">회 국회</td>
                      </td>
                    </tr>
                </table>
				<!------------------------- TAB에 해당하는 테이블(목록이든 등록폼이든 상세정보든) 출력 끝 ------------------------->
                <div id="btn_all"class="t_right">
                    <span class="list_bt"><a href="#" onClick="javascript:fUsrAction('list');">저장</a></span>
                    <span class="list_bt"><a href="#" onClick="form1.reset()">취소</a></span>
                    <span class="list_bt"><a href="#" OnClick="javascript:history.go(-1)">이전화면</a></span>
                </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>