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
     //�α����� �����ID�� �����´�.
 	String strUserID   = objUserInfo.getUserID();

	String strYear        = StringUtil.getNVLNULL(request.getParameter("strYear"));             //�⵵
	String strOrganId   = StringUtil.getNVLNULL(request.getParameter("strOrganId"));       //����ȸ ID
	String strOrganNm   = StringUtil.getNVLNULL(request.getParameter("strOrganNm"));  //����ȸ��

	//��Delegate �����.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	Hashtable objHashYear = new Hashtable();
	objHashYear= objCommReq.selectSysDate();
    //�ý��� ����
    strYear = (String)objHashYear.get("SYS_DATE");
    String strYearDate = (String)objHashYear.get("YEARDATE");

	Hashtable objHashCnt = new Hashtable();
	objHashCnt = objCommReq.selectSchCnt(strYear, strOrganId);
	//����
	String strMaxCnt = (String)objHashCnt.get("MAX_CNT");

	if ( strMaxCnt == null || strMaxCnt.equals("") ) {
		strMaxCnt = "1";
	}

	//����� ����, ��ȭ��ȣ�� �����´�.
	Hashtable objHashUserInfo = new Hashtable();
	objHashUserInfo = objCommReq.selectUserInfo(strUserID);
	String strMail    = StringUtil.getNVL((String)objHashUserInfo.get("EMAIL"),"��ϵǾ� ���� ����");
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

	     if (!confirm("�䱸 ������ ����Ͻðڽ��ϱ�?\r\n[������ �ּ���]\r\n�䱸������ ��ϵǸ� �ڵ����� ����ȸ �Ҽ� �ǿ��� ����ڿ��� e-mail�� �߼۵˴ϴ�.")) {
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
			strReturn = strReturn + "- �����Ⱓ ������\n";
    	}
	    if (end_day.value == '') {
			strReturn = strReturn + "- �����Ⱓ ������\n";
    	}
	    if (send_end_day.value == '') {
			strReturn = strReturn + "- ����Ϸ���\n";
    	}
	    if (NatCnt.value == '') {
			strReturn = strReturn + "- ȸ��\n";
    	}

		if (strReturn.length != 0 || strReturn != "") {
			strReturn = "[�Ʒ� �ʼ� �׸� �Է��� �����Ǿ����ϴ�. Ȯ�� �ٶ��ϴ�]\n\n" + strReturn;
			alert(strReturn);
			return;
		}
		if (Year.value != (str_day.value).replace("-","").replace("-","").substr(0,4)) {
	    	alert('�����Ⱓ �������� ' + Year.value + '�⵵�� �����ϼ���');
			str_day.focus();
	    	return false;
	    }
	    if ((str_day.value).replace("-","").replace("-","") < (YearDate.value).replace("-","").replace("-","") ) {
			alert('�����Ⱓ �������� ' + YearDate.value + '�� ���� ��¥�� �����ϼ���');
			str_day.focus();
			return false;
		}
	    if (Year.value != (end_day.value).replace("-","").replace("-","").substr(0,4)) {
			alert('�����Ⱓ �������� ' + Year.value + '�⵵�� �����ϼ���');
			end_day.focus();
			return false;
		}
		if ((end_day.value).replace("-","").replace("-","") < (YearDate.value).replace("-","").replace("-","") ) {
			alert('�����Ⱓ ������ ' + YearDate.value + '�� ���� ��¥�� �����ϼ���');
			end_day.focus();
			return false;
		}
		if ((end_day.value).replace("-","").replace("-","")  < (str_day.value).replace("-","").replace("-","")) {
			alert('�����Ⱓ �������� �����Ⱓ �����Ϻ��� �۽��ϴ�.');
			end_day.focus();
			return false;
		}
		if (Year.value != (send_end_day.value).replace("-","").replace("-","").substr(0,4)) {
			alert('����Ϸ����� ' + Year.value + '�⵵�� �����ϼ���');
			send_end_day.focus();
			return false;
		}
		if ((send_end_day.value).replace("-","").replace("-","")  < (end_day.value).replace("-","").replace("-","")) {
			alert('����Ϸ����� �����Ⱓ �����Ϻ��� �۽��ϴ�.');
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
        <h3><%=strYear%>�⵵ <%=MenuConstants.REQ_BOX_SCH_SAVE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH_SAVE%></B></div>
        <p><!--����--></p>
        </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <span class="list02_tl">�䱸���� ���� </span>
        <table cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;����ȸ </th>
                      <td height="25"><%=strOrganNm%></td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;����</th>
                      <td height="25"><%=strMaxCnt%>��</td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�����Ⱓ</th>
                      <td height="25">
					  	<!--
						<input type="text" style="font-size:11px;font-family:verdana,����" class="textbox" name="str_day" size="10" maxlength="8" value=""  readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" >
					    <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.str_day);"/>	&nbsp;&nbsp; ~	&nbsp;&nbsp;
       					<input type="text" style="font-size:11px;font-family:verdana,����" class="textbox" name="end_day" size="10" maxlength="8" value="" readonly  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;">
					    <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.end_day);"/>
						-->
						<input type="text" class="textfield" name="str_day" size="10" maxlength="8" value=""  readonly" >
                <a href="#" OnClick="javascript:show_calendar('form1.str_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
			    <input type="text" class="textfield" name="end_day" size="10" maxlength="8" value="" readonly">
			    <a href="#" OnClick="javascript:show_calendar('form1.end_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>

                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;���� �Ϸ���</th>
                      <td height="25">
				      	<input type="text" style="font-size:11px;font-family:verdana,����" class="textbox" name="send_end_day" size="10" maxlength="8" value="" readonly OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" >�� ����
						<!--<img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:Calendar(form1.send_end_day);">-->
						<a href="#" OnClick="javascript:show_calendar('form1.send_end_day');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;ȸ��</th>
                      <td height="25">
						��<input type="text" style="font-size:11px;font-family:verdana,����" size="3" maxlength="3" name="NatCnt"  onChange="javascript:CheckNumeric(this)">ȸ ��ȸ</td>
                      </td>
                    </tr>
                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
                <div id="btn_all"class="t_right">
                    <span class="list_bt"><a href="#" onClick="javascript:fUsrAction('list');">����</a></span>
                    <span class="list_bt"><a href="#" onClick="form1.reset()">���</a></span>
                    <span class="list_bt"><a href="#" OnClick="javascript:history.go(-1)">����ȭ��</a></span>
                </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>