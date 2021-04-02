<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RCommNewBoxMake
* Summary	  : ����ȸ �䱸�� �ű� ���.
* Description : �䱸�� ��� ȭ�� ����.
* �ء� üũ �ء�
* 1. ����ȸ�䱸�Ե�ϱ����� �ִ��� ���� üũ
* 2. ����ȸ �䱸���� ��Ͻ� �ڵ����� ������ ������ ����ȸ �䱸�� ����(�Ǵ븮�Բ� ����)
* 3. �䱸�Ը��� selectBox�� �� ���� ���������� ����ȸ�䱸���� ��Ͻ� ������ ������
*    �� ������ �ش��� �Ҽ� �������� ����.
*    �䱸���� ��Ͻ� �������� ��ü�������� �ÿ��� �䱸�Ը��� selectBox���� �����̶� ���� ����.
*    -- �䱸���� ���� ��� SQL�� ROWNUM ����
*	 -- ������ selectBox ���� ����
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>

<%
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDuty"));/** �������� */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** ȸ�� */
 //�������а� ���õȰ��� ������ �⺻���� ������ �ǰ���. ����� ���������ڵ�.
 if(strRltdDuty.equals("")){
 	strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
 }
 String strIngStt = (String)request.getParameter("IngStt");

 /******** ������ ���� �����̳� ���� *********/
 ResultSetSingleHelper objRsSH=null;	/** �䱸���� ���� ��¿�  ResultSetSingleHelper*/
 ResultSetHelper objSubmtOrganRs=null;  /** ������ ����Ʈ ��¿� ResultSetHelper */
 ResultSetHelper objRltdDutyRs=null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */

 try{
   /********* �븮�� ���� ���� *********/
	CommRequestBoxDelegate objReqBox=new CommRequestBoxDelegate(); 		/**�䱸�� Delegate*/
	OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */

   /********* ���������� **************/
    objRsSH=new ResultSetSingleHelper(objReqBox.getScheRecord((String)request.getParameter("ReqScheID")));
	objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(objUserInfo.getOrganID()));/**����������Ʈ*/
    objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
   /** �������� üũ */
  function checkFormData(){
  	var alertStr = "";
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- ȸ��\n";
	}
	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- �������\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[�Ʒ��� �׸��� �ʼ��Է� �׸��Դϴ�. Ȯ�� �ٶ��ϴ�]\n\n" + alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("��������� ����(<%=StringUtil.getSysDate()%>)������ ��¥�� �����ϼž��մϴ�");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value <="<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%>"){
		alert("��������� �����Ⱓ ������ ��¥�� �����ϼž��մϴ�.");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if (getByteLength(formName.elements['ReqBoxDsc'].value) > 250) {
		alert("�䱸�� ������ �ѱ�, ������ ���� 250�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}
	formName.submit();
  }//endfunc

  function gotoReqBoxList() {
  	formName.action = "./RCommReqBoxList.jsp";
  	formName.submit();
  }
</script>
</head>
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
		<form name="formName" method="post" action="./RCommNewBoxMakeProc.jsp"><!--�䱸�� �ű����� ���� -->
		<input type="hidden" name="ReqOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
		<input type="hidden" name="CmtOrganID" value="<%=objRsSH.getObject("CMT_ORGAN_ID")%>">
		<input type="hidden" name="AuditYear" value="<%=objRsSH.getObject("AUDIT_YEAR")%>">
		<input type="hidden" name="ReqScheID" value="<%=objRsSH.getObject("REQ_SCHE_ID")%>">
		<input type="hidden" name="IngStt" value="<%=objRsSH.getObject("ING_STT")%>">
		<input type="hidden" name="ReqBoxStt" value="<%=objRsSH.getObject("ING_STT")%>">

        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%></h3>
        <div class="navi">
            <img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> >
				<% if("002".equalsIgnoreCase(strIngStt)){ %>
				<B><%=MenuConstants.COMM_REQ_BOX_MAKE_END%></B>
				<% } else { %>
				<B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B>
				<% } %>
        </div>
        <p><!--����--></p>
        </div>
        <!-- /pgTit -->
        <!-- contents -->
      <div id="contents">
        <span class="list02_tl">�䱸���� ���� </span>
        <table cellspacing="0" cellpadding="0" class="list02">
			<tr>
				<th height="25">&bull;&nbsp;����ȸ </th>
				<td height="25" colspan="3"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;�䱸 ����</th>
				<td height="25" colspan="3">
				<%=objRsSH.getObject("AUDIT_YEAR")%> �� &nbsp; <%=objRsSH.getObject("CMT_ORGAN_NM")%>
				&nbsp;<%=objRsSH.getObject("ORDER_INFO")%> &nbsp;�� &nbsp;�䱸
				</td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;���� ����</th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
				<th height="25">&bull;&nbsp;���� ����</th>
				<td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
			</tr>
			<tr>
				<th height="25">&bull;&nbsp;ȸ��</th>
				<td height="25">
				��<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" value="<%=objRsSH.getObject("NAT_CNT")%>" readonly>ȸ ��ȸ</td>
            	<th height="25">&bull;&nbsp;��������</th>
              	<td height="25">
				<select name="RltdDuty" class="select">
				<%
				   /**�������� ����Ʈ ��� */
				   while(objRltdDutyRs.next()){
				   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
				   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
				   }
				%>
				</select>
              	</td>
            </tr>
			<tr>
				<th height="25">&bull;&nbsp;������</th>
				<td height="25"><select name="SmtOrganID" class="select">
				<% while(objSubmtOrganRs.next()){ %>
				<option value ="<%=objSubmtOrganRs.getObject("SUBMT_ORGAN_ID")%>"><%=objSubmtOrganRs.getObject("SUBMT_ORGAN_NM")%></option>
				<%
				}
				%>
				</select>
				</td>
				<th height="25">&bull;&nbsp;�������</th>
				<td height="25">
				<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value=""  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
                <img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" style="cursor:hand" OnClick="javascript:show_calendar('formName.SubmtDln');"/>
				</td>
            </tr>
            <tr>
				<th height="25">&bull;&nbsp;�䱸�� ����</th>
				<td height="25" colspan="3">
              	<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"></textarea>
				</td>
            </tr>
			</table>
        <div id="btn_all"class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkFormData();">����</a></span>
            <span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
            <span class="list_bt"><a href="#" OnClick="javascript:gotoReqBoxList()">�䱸�Ը��</a></span>
        </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>