<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.util.HashtableUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RBasicReqBoxEidt.jsp
* Summary	  : �䱸�� ���� ȭ��.
* Description : �䱸�� ���� ȭ�� ����.
/******************************************************************************/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();
  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	//out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
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
   PreRequestBoxDelegate objReqBox=new  PreRequestBoxDelegate(); /**�䱸�� ���� �븮�� New */

   /********* ���������� **************/
   Hashtable objReqBoxHash=objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"));
   objRsSH=new  ResultSetSingleHelper(objReqBoxHash);	/** Ư�� �䱸�� ���� ������ ����.*/
   if(!StringUtil.isAssigned(strCmtOrganID)){
   	  strCmtOrganID=HashtableUtil.getEmptyIfNull(objReqBoxHash,"CMT_ORGAN_ID");

   	  /** ����ȸ���� ��Ÿ ����ȸ�̸� ���� �������� �Ҽӵ� ����ȸ�� ã���� 2004.05.14 ==>���� 2004.06.04 */
   	  //if(strCmtOrganID.equals(CodeConstants.ETC_CMT_ORGAN_ID)){
   	  //   strCmtOrganID=objOrganInfo.getCmtOrganID(HashtableUtil.getEmptyIfNull(objReqBoxHash,"SUBMT_ORGAN_ID"));
   	  //}//endif
   }

   //objCmtRs=new ResultSetHelper(objOrganInfo.getCmtOrganList());    /** ��ü ����ȸ */
   objCmtRs=new ResultSetHelper(objUserInfo.getCurrentCMTList());   /** �Ҽ� ����ȸ */
   objSubmtOrganRs=new ResultSetHelper(objOrganInfo.getSubmtOrganList(strCmtOrganID));/**����������Ʈ*/
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
  	if(formName.CmtOrganIDX.value==""){
  	    alert("����ȸ�� �����ϼ���");
  	    return false;
  	}
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
	formName.action="./RBasicReqBoxEditProc.jsp";
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
    formName.CmtOrganIDX.value="";
    formName.ReqBoxDsc.value="";
    formName.SubmtDln.value="";
  	formName.action="./RBasicReqBoxVList.jsp";
  	formName.submit();
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

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_EDIT%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->
      <!-- contents -->
      <div id="contents">
      <span class="list02_tl">�䱸�� ���� </span>
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;����ȸ </th>
                      <td colspan="3">
						<select name="CmtOrganIDX" onChange="changeSubmtOrganList()"  class="select">
						<%

						   while(objCmtRs.next()){
						       String strOrganID=(String)objCmtRs.getObject("ORGAN_ID");
						   	   out.println("<option value=\"" + strOrganID + "\" " + StringUtil.getSelectedStr(strCmtOrganID,strOrganID) + ">" + objCmtRs.getObject("ORGAN_NM") + "</option>");
						   }//endwhile
						%>

						</select>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸�Ը�</th>
                      <td height="25" colspan="3">
	                      <%=(String)objRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;ȸ��</th>
                      <td height="25">
	                      ��<input type="text" size="3" maxlength="3" name="NatCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strNatCnt%>">ȸ��ȸ
                      </td>
                      <th height="25">&bull;&nbsp;ȸ��</th>
                      <td height="25">
	                      <input type="text" size="3" maxlength="3" name="ReqBoxCnt" class="textfield" onKeyUp="CheckNumeric(this);" value="<%=strReqBoxCnt%>">
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;��������</th>
                      <td height="25" width="191">
						<select name="RltdDutyX"  class="select">
						<%
						   /**�������� ����Ʈ ��� */
						   while(objRltdDutyRs.next()){
						   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
						   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
						   }
						%>
						</select>
                      </td>
                      <th height="25">&bull;&nbsp;�������</th>
                      <td height="25" colspan="3">
						<input type="text" class="textfield" name="SubmtDln" size="10" maxlength="8" value="<%=strSubmtDln%>"  OnClick="this.select()" OnKeyPress="if ((event.keyCode&lt;48)||(event.keyCode&gt;57)) event.returnValue=false;" OnBlur="javascript:SetFormatDate(this);">
						<a href="#" OnClick="javascript:show_calendar('formName.SubmtDln');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;������</th>
						<td height="25" colspan="3">
                            <select name="SubmtOrganID" class="select">
						<%
						   /**������ ����Ʈ ��� */
						   while(objSubmtOrganRs.next()){
						   		String strSubmitOrganID=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_ID");
						   		String strSubmitOrganNM=(String)objSubmtOrganRs.getObject("SUBMT_ORGAN_NM");
						   		out.println("<option value=\"" + strSubmitOrganID + "\" " + StringUtil.getSelectedStr(strSubmtOrganID,strSubmitOrganID) + ">" + strSubmitOrganNM.trim() + "</option>");
						   }
						%>
								</select>
						</td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸�Լ���</th>
                      <td height="25" colspan="3">
                      	<textarea rows="3" cols="70" name="ReqBoxDsc" class="textfield" style="WIDTH: 90% ; height: 80"><%=strReqBoxDsc%></textarea>
                      </td>
                    </tr>
                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
        <div id="btn_all"  class="t_right">
                <%
                //���� ����
                if(!strReqSubmitFlag.equals("004")){
                %>
				<span class="list_bt"><a href="#" onClick="checkFormData()">����</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
                <%} //end if ���Ѿ����� ���� %>
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