<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.HashtableUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RMakeReqBoxEidt.jsp
	* Summary	  : �䱸�� ���� ȭ��.
	* Description : �䱸�� ���� ȭ�� ����.
	/******************************************************************************/

	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	// 2004-07-08
	// ������åó ������ ���ؼ� ������� �ڵ带 �����Ѵ�.
	String strOrgGbnCode = objUserInfo.getOrganGBNCode();

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		// out.println("ParamError:" + objParams.getStrErrors());
	%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
	<%
		return;
	} //endif
%>
<%
 /******* ���� ������ SELECT Box Param */
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganIDX"));/**����ȸ ��� */
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDutyX"));/** �������� */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** ȸ�� */
 String strReqBoxCnt=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxCnt"));	/** ȸ�� */
 String strSubmtDln=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtDln"));/** ������� */
 String strReqBoxDsc=StringUtil.getEmptyIfNull((String)request.getParameter("ReqBoxDsc"));/** �䱸�Լ��� */
 String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganIDX"));/** ������ID */
 if(!StringUtil.isAssigned(strSubmtOrganID)){
   strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganID"));/** ������ID */
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /******** ������ ���� �����̳� ���� ********/
 ResultSetHelper objCmtRs=null;        /** �Ҽ� ����ȸ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** ������ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */
 ResultSetSingleHelper objRsSH=null;	/** �䱸�� �󼼺��� ���� */
 try{
   /********* �븮�� ���� ���� *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */
   MemRequestBoxDelegate objReqBox=new  MemRequestBoxDelegate(); /**�䱸�� ���� �븮�� New */

   /********* ���������� **************/
   Hashtable objReqBoxHash = (Hashtable)objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"));
   objRsSH=new  ResultSetSingleHelper(objReqBoxHash);	/** Ư�� �䱸�� ���� ������ ����.*/
   if(!StringUtil.isAssigned(strCmtOrganID)){
   	  strCmtOrganID=HashtableUtil.getEmptyIfNull(objReqBoxHash,"CMT_ORGAN_ID");

   	  /** ����ȸ���� ��Ÿ ����ȸ�̸� ���� �������� �Ҽӵ� ����ȸ�� ã���� 2004.05.14 ==>���� 2004.06.04 */
   	  //if(strCmtOrganID.equals(CodeConstants.ETC_CMT_ORGAN_ID)){
   	  //   strCmtOrganID=objOrganInfo.getCmtOrganID(HashtableUtil.getEmptyIfNull(objReqBoxHash,"SUBMT_ORGAN_ID"));
   	  //}//endif
   }
   objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());    /** ��ü ����ȸ */

   // 2004-07-08 �繫ó, ����ó�� GbnCode�� ���� ��ü ������ ����� �����;� �ϹǷ�
   //objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**����������Ʈ*/
   objSubmtOrganRs = new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID, strOrgGbnCode)); // ����������Ʈ*/

   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList()); /** ���� ���� �������� */
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<%
 /*************************************************************************************************/
 /** 					������ �� Ȯ��   Part 													  */
 /*************************************************************************************************/

 if(!objRsSH.next()){
 	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSDATA-0001");
  	objMsgBean.setStrMsg("��û�Ͻ� ������ �ý��ۿ� �������� �ʽ��ϴ�.");
  	//out.println("<br>Error!!!" + "��û�Ͻ� ������ �ý��ۿ� �������� �ʽ��ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/
 strRltdDuty=StringUtil.getEmptyIfNull(strRltdDuty,(String)objRsSH.getObject("RLTD_DUTY"));/** �������� */
 strNatCnt=StringUtil.getEmptyIfNull(strNatCnt,(String)objRsSH.getObject("NAT_CNT"));	/** ȸ�� */
 strReqBoxCnt=StringUtil.getEmptyIfNull(strReqBoxCnt,(String)objRsSH.getObject("REQ_BOX_CNT"));	/** ȸ�� */
 strSubmtDln=StringUtil.getEmptyIfNull(strSubmtDln,StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")));/** ������� */
 strReqBoxDsc=StringUtil.getEmptyIfNull(strReqBoxDsc,(String)objRsSH.getObject("REQ_BOX_DSC"));/** �䱸�Լ��� */
 strSubmtOrganID=StringUtil.getEmptyIfNull(strSubmtOrganID,(String)objRsSH.getObject("SUBMT_ORGAN_ID"));/** ������ID */

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  /** ����������Ʈ ���. */
  function changeSubmtOrganList(){
  	formName.action="<%=request.getRequestURI()%>";
  	formName.submit();
  }

  /** �������� üũ */
  function checkFormData(){
<%
	// 2004-07-08 �繫ó, ������åó Ư�� ������ ���� ���� ��~��~
	if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
	} else {
%>
  	if(formName.CmtOrganIDX.value==""){
  	    alert("����ȸ�� �����ϼ���");
  	    return false;
  	}
<% } %>
  	if(formName.SubmtOrganID.value==""){
  	    alert("�������� �����ϼ���");
  	    return false;
  	}
	if(formName.elements['NatCnt'].value==""){
		alert("ȸ�⸦  �Է��ϼ���!!");
		formName.elements['NatCnt'].focus();
		return false;
	}
	if(formName.elements['ReqBoxCnt'].value==""){
		alert("ȸ����  �Է��ϼ���!!");
		formName.elements['ReqBoxCnt'].focus();
		return false;
	}
	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("�䱸�Լ����� 250���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value==""){
		alert("��������� �Է�(����)�ϼ���!!");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("��������� ����(<%=StringUtil.getSysDate()%>)������ ��¥�� �����ϼž��մϴ�");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	formName.action="./RMakeReqBoxEditProc.jsp";
	formName.submit();
  }//endfunc

  /** ������ ��ȸ �˾� */
  function popupSearchSubmitOrgan(){
    var varWidth=320;
    var varHeight=250;
    var winl = (screen.width - varWidth) / 2;
	var wint = (screen.height - varHeight) / 2;
  	window.open("/reqsubmit/common/SearchSubmtOrganList.jsp",'','width=' + varWidth + ',height=' + varHeight + ',top='+wint+',left='+winl+',scrollbars=yes, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=yes');
  }
  /** �䱸������ ���� */
  function gotoList(){
    //formName.CmtOrganIDX.value="";
    formName.ReqBoxDsc.value="";
    formName.SubmtDln.value="";
  	formName.action="./RMakeReqBoxVList.jsp";
  	formName.submit();
  }

	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 250;
		var aaaElem = document.formName.ReqBoxDsc;
		var aaaLength = calcLength(aaaElem.value);
		document.getElementById("textlimit").innerHTML = aaaLength;
		if (aaaLength > length_limit) {
			alert("�ִ� " + length_limit + "byte�̹Ƿ� �ʰ��� ���ڼ��� �ڵ����� �����˴ϴ�.");
			aaaElem.value = aaaElem.value.replace(/\r\n$/, "");
			aaaElem.value = assertLength(aaaElem.value, length_limit);
		}
	}

	function calcLength(message) {
		var nbytes = 0;

		for (i=0; i<message.length; i++) {
			var ch = message.charAt(i);
			if(escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}
		return nbytes;
	}

	function assertLength(message, maximum) {
		var inc = 0;
		var nbytes = 0;
		var msg = "";
		var msglen = message.length;

		for (i=0; i<msglen; i++) {
			var ch = message.charAt(i);
			if (escape(ch).length > 4) {
				inc = 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					inc = 1;
				}
			} else if (ch == '<' || ch == '>') {
				inc = 4;
			} else {
				inc = 1;
			}
			if ((nbytes + inc) > maximum) {
				break;
			}
			nbytes += inc;
			msg += ch;
		}
		document.getElementById("textlimit").innerHTML = nbytes;
		return msg;
	}

</script>
</head>

<body>
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>

	<div id="rightCon">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �������� ���� -->
          	 <%=objParams.getHiddenFormTags()%>
          	 <input type="hidden" name="SubmtOrganIDX" value="">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >-<%=MenuConstants.REQ_BOX_EDIT%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.--><!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->
		<span class="list02_tl">�䱸�� ����</span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;�䱸�Ը� </th>
                    <td height="25" colspan="3">
					<input value="<%=(String)objRsSH.getObject("REQ_BOX_NM")%>" size="45" name="ReqBoxNm" />
					</td>
                </tr>
<%
	// 2004-07-08 �繫ó, ������åó Ư�� ������ ���� ���� ��~��~
	if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
		out.println("<input type='hidden' name='CmtOrganIDX' value='"+(String)objRsSH.getObject("CMT_ORGAN_ID")+"'>");
	} else {
%>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;�Ұ� ����ȸ</th>
                    <td height="25" colspan="3">
					<select name="CmtOrganIDX" onChange="changeSubmtOrganList()" class="select"  style="width:auto;" >
						<%
						   /** ��ü ����ȸ ����Ʈ ��� */
						   while(objCmtRs.next()){
							   String strOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
							   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("CMT_ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						  <% //����ȸ�������� ���� ����� ������. %>
						  <option value="<%=CodeConstants.NO_CMT_ORGAN_ID%>" <%=StringUtil.getSelectedStr(strCmtOrganID,CodeConstants.NO_CMT_ORGAN_ID)%>><%=CodeConstants.NO_CMT_ORGAN_NM%></option>
					</select>
					</td>
                </tr>
<% } %>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;ȸ��</th>
                    <td height="25" width="191">
					��<input size="3" maxlength="3" name="NatCnt" name="ReqBoxNm" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>"/>ȸ ��ȸ
					</td>
                    <th height="25" width="149">&bull;&nbsp;ȸ��</th>
                    <td height="25" width="191">
					<input size="3" maxlength="3" name="ReqBoxCnt" onKeyUp="CheckNumeric(this);" value="<%=strReqBoxCnt%>"/>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;��������</th>
                    <td height="25" width="191">
						<select name="RltdDutyX" class="select"  style="width:auto;" >
						<%
						   /**�������� ����Ʈ ��� */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
					</td>
                    <th height="25" width="149">&bull;&nbsp;�������</th>
                    <td height="25" width="191">
					<input name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);"/>
					<a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
                </tr>
				<tr>
                    <th height="25">&bull;&nbsp;
					<a href="javascript:popupSearchSubmitOrgan()">������</a>
					</th>
                    <td height="25" colspan="3">
						<select name="SubmtOrganID" class="select">
						<%
								// 2004-07-08 �繫ó, ������åó Ư�� ������ ���� ���� ��~��~
								if ((CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(strOrgGbnCode)) || (CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(strOrgGbnCode))) {
								} else {
						%>
							<option value="" selected>::: ����ȸ�� ���� ������ �ּ��� :::</option>
						<% } %>
						<%
						   /**������ ����Ʈ ��� */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>
						</select>
						<span class="list_bts right"><a href="#" onClick="popupSearchSubmitOrgan()">��ȸ</a></span>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;�䱸�Լ���</th>
                    <td colspan="3">
						<!--
						<textarea
						onKeyDown="javascript:updateChar2()"
                      	onKeyUp="javascript:updateChar2()"
                      	onfocus="javascript:updateChar2()"
						rows="3" cols="70" name="ReqBoxDsc" style="height:100px;" wrap="hard">
						<%//=strReqBoxDsc%>
						</textarea>
						-->
						<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"
                      		onKeyDown="javascript:updateChar2()"
                      		onKeyUp="javascript:updateChar2()"
                      		onfocus="javascript:updateChar2()"><%=strReqBoxDsc%></textarea>
                        <br />
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;">
										<script>document.write(calcLength(document.formName.ReqBoxDsc.value));</script>
									</div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (250 bytes ������ �Էµ˴ϴ�) </span>
			<!--  ���� �ý��� ���� javascript �κ��� ��� ���� �߻�.  -->
								</td>
                                </tr>
                        </table></td>
                </tr>
                </tbody>
        </table>
        <!-- /list -->

        <!-- ����Ʈ ��ư-->
        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()" >����</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
				<span class="list_bt"><a href="#" onClick="gotoList()">�䱸�Ժ���</a></span>
			</span>
		</div>

         <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>