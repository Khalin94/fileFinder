<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/******************************************************************************
* Name		  : RNewPreBoxMake.jsp
* Summary	  : �ű� �䱸�� ���.
* Description : �䱸�� ��� ȭ�� ����.
* 				�ء� üũ �ء�
*				 ���� ����ó���� ������ �������� �ѱ��� ����.
******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /** ���� ������ SELECT Box Param */
 String strCmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("CmtOrganID"));/**����ȸ ��� */
 String strRltdDuty=StringUtil.getEmptyIfNull((String)request.getParameter("RltdDuty"));/** �������� */
 String strNatCnt=StringUtil.getEmptyIfNull((String)request.getParameter("NatCnt"));	/** ȸ�� */
 //�������а� ���õȰ��� ������ �⺻���� ������ �ǰ���. ����� ���������ڵ�.
 if(strRltdDuty.equals("")){
 	strRltdDuty=CDInfoDelegate.SELECTED_RLTD_DUTY;
 }
 String strSubmtOrganID=StringUtil.getEmptyIfNull((String)request.getParameter("SubmtOrganID"));/** ������ID */

%>
<%

 /******** ������ ���� �����̳� ���� *********/
 ResultSetHelper objCmtRs=null;        /** �Ҽ� ����ȸ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objSubmtOrganRs=null; /** ������ ����Ʈ ��¿� RsHelper */
 ResultSetHelper objRltdDutyRs=null;   /** ���ñ�� ����Ʈ ��¿� RsHelper */
 try{
   /********* �븮�� ���� ���� *********/
   OrganInfoDelegate objOrganInfo=new OrganInfoDelegate();   /** ������� ��¿� �븮�� */

   /********* ���������� **************/
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(objUserInfo.getOrganID()));/**����������Ʈ*/
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<!--jsp:forward page="/common/message/ViewMsg.jsp"/-->
  	<%
  	return;
 }

%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<script language=Javascript src="/js/reqsubmit/common.js"></script>
<script language=Javascript src="/js/nads_lib.js"></script>
<script language=Javascript src="/js/datepicker.js"></script>
<script language="JavaScript">
  <%
 	//�޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
    out.println("var form;");
    out.println("var varSelectedSubmt='" + strSubmtOrganID + "';");
	out.println("var arrCmtSubmtOrgans=new Array(" + objSubmtOrganRs.getRecordSize() + ");");
	for(int i=0;objSubmtOrganRs.next();i++){
	    out.println("arrCmtSubmtOrgans[" + i + "]=new Array('"
			+ (String)objSubmtOrganRs.getObject("CMT_ORGAN_ID")	+ "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_ID") + "','" + objSubmtOrganRs.getObject("SUBMT_ORGAN_NM") + "');");
	}//endfor
  %>

  /** ����ȸ ���� �ʱ�ȭ */
  function init(){
	var field=formName.CmtOrganID;
	makeSubmtOrganList(field.options[field.selectedIndex].value);
  }//end of func
  /** ������ ����ȸ ����Ʈ �ʱ�ȭ */
  function makeSubmtOrganList(strOrganID){
       	var field=formName.SubmtOrganID;
       	field.length=0;
	for(var i=0;i<arrCmtSubmtOrgans.length;i++){
	   var strTmpCmt=arrCmtSubmtOrgans[i][0];
	   if(strOrganID==strTmpCmt){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrCmtSubmtOrgans[i][1];
		   tmpOpt.text=arrCmtSubmtOrgans[i][2];
		   if(varSelectedSubmt==tmpOpt.text){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);
	   }
	}
  }//end of func
  /** ����ȸ ID ��ȭ�� ���� ������ ����Ʈ ��ȭ */
  function changeSubmtOrganList(){
    makeSubmtOrganList(formName.CmtOrganID.options[formName.CmtOrganID.selectedIndex].value);
  }//end of func


    /** �������� üũ */
  function checkFormData() {
  	var alertStr = "";
	if(formName.elements['NatCnt'].value==""){
		alertStr = alertStr + "- ȸ��\n";
	}

	if(formName.elements['SubmtDln'].value==""){
		alertStr = alertStr + "- �������\n";
	}

	if (alertStr.length != 0) {
		alertStr = "[�Ʒ��� �ʼ� �Է� �׸��� �Է��� �ֽñ� �ٶ��ϴ�]\n\n"+alertStr;
		alert(alertStr);
		return;
	}

	if(formName.elements['ReqBoxDsc'].value.length>250){
		alert("�䱸�Լ����� 250���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqBoxDsc'].focus();
		return false;
	}

	if(formName.elements['SubmtDln'].value<="<%=StringUtil.getSysDate()%>"){
		alert("��������� ����(<%=StringUtil.getSysDate()%>)������ ��¥�� �����ϼž��մϴ�");
		formName.elements['SubmtDln'].focus();
		return false;
	}
	formName.submit();
  }//endfunc

  // 2004-07-21
  function gotoPreReqBoxList() {
  	var str1 = document.formName.NatCnt.value;
  	var str2 = document.formName.SubmtDln.value;
  	if (str1.length != 0 && str2.length != 0) {
  		if (confirm("�Է��Ͻ� �䱸���� �����Ͻðڽ��ϱ�?\n��Ҹ� �����ø� ������� �ʽ��ϴ�.")) {
  			checkFormData();
  			return;
  		}
  	}
  	document.formName.action = "/reqsubmit/20_comm/40_BasicBox/20_databoxsh/RBasicReqBoxList.jsp";
  	document.formName.submit();
  }


</script>

</head>

<body onLoad="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>

	<div id="rightCon">
<form name="formName" method="get" action="./RNewPreBoxMakeProc.jsp"><!--�䱸�� �ű����� ���� -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_WRITE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.--><!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;����ȸ </th>
                    <td height="25" colspan="3">
					<select name="CmtOrganID" onChange="changeSubmtOrganList()">
						<%
						   /** �Ҽ�����ȸ ����Ʈ ��� */
						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>
						</select>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;ȸ ��</th>
                    <td height="25" colspan="3">��
                        <input onKeyUp="CheckNumeric(this);" maxlength="3" size="3" name="NatCnt" value="<%=strNatCnt%>"/>
                        ȸ ��ȸ </td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;��������</th>
                    <td height="25" width="191">
					<select name="RltdDuty">
						 <%
						   /**�������� ����Ʈ ��� */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
					</td>
                    <th height="25" width="149">&bull;&nbsp;������</th>
                    <td height="25" width="191">
					<select name="SubmtOrganID" class="select_reqsubmit">

							</select>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;�������</th>
                    <td height="25" colspan="3">
						<input onBlur="javascript:SetFormatDate(this);" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" maxlength="8" size="10" name="SubmtDln" />
                        <a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
                </tr>
                <tr>
                    <th height="25" rowspan="2">&bull;&nbsp;�䱸�� ����</th>
                    <td colspan="3">
						<textarea
						onKeyDown="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onKeyUp="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onFocus="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" onClick="javascript:updateChar2(document.formName, 'ReqBoxDsc', '660')" rows="3" cols="70" name="ReqBoxDsc" style="height:100px;"></textarea>
                        <br />                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;"></div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (*250 bytes ������ �Էµ˴ϴ�) </span>
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
				<span class="list_bt"><a href="#" onClick="gotoPreReqBoxList()">�䱸�Ը��</a></span>
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