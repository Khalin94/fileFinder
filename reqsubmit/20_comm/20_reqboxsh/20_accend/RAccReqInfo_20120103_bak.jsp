<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();

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
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
  int FLAG = -1;
  CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
 /*** Delegate �� ������ Container��ü ���� */
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
 ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
 ResultSetSingleHelper objRsRI=null;			/** �䱸 �󼼺��� ���� */
 ResultSetSingleHelper objRsCS=null;			/** �䱸 �󼼺��� ���� */
 String strRefReqID ="";

 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
   System.out.println("blnHashAuth : "+blnHashAuth);
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  out.println("�ش� �䱸���� �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg3.jsp"/>
  	<%
      return;
  }else{
   /** �䱸�� ���� */
    System.out.println("11111");
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
	System.out.println("22222"+(String)objParams.getParamValue("CommReqID"));
   /**�䱸 ���� �븮�� New */
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("CommReqID")));
	System.out.println("3333");
	strRefReqID = (String)objRsRI.getObject("REF_REQ_ID");
	System.out.println("4444");
    objRsCS=new ResultSetSingleHelper(objReqInfo.getCmtSubmt((String)objParams.getParamValue("CommReqID"),strRefReqID));
	System.out.println("5555");
	FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
	System.out.println("66666");
  }/**���� endif*/
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
 String strIngStt = (String)objRsSH.getObject("ING_STT");
 String strCmt = (String)objRsCS.getObject("CMT_SUBMT_REQ_ID");

 // 2005-08-09 kogaeng ADD
 // ��Ȯ�� �䱸�� ã�ư��� �ϱ� ���� �䱸�� ���� ���� ���� �� ����
 String strReqBoxStt = (String)objRsSH.getObject("REQ_BOX_STT");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
//������� ������������ ����
function openCLUp(){
	form = document.formName;
	form.action="/reqsubmit/20_comm/20_reqboxsh/ROpenCLProc.jsp";
	form.target="";
	form.submit();
}
  /**�䱸���� ������������ ����.*/
  function gotoEdit(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoEdit.jsp";
	formName.target="";
  	formName.submit();
  }

  /**�䱸�� ����*/
  function gotoReqBox(){
  	form = document.formName;
  	form.action="./RAccBoxVList.jsp";
	form.target="";
  	form.submit();
  }

  /**�䱸������������ ����.*/
  function gotoDelete(){
  	formName.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	formName.target="";
  	formName.submit();
  }

  function showDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = '';
  }

  function FinalSubmit() {
	  var f = document.formName;
	<%if(!"".equalsIgnoreCase(strCmt)){%>
		if (f.elements['Rsn'].value == "") {
			f.elements['Rsn'].value = "���� ���� ����";
			//return;
		}
	<% } %>
	  f.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqDelProc.jsp";
	  f.target = "";
	  if (confirm("�䱸 ������ �����Ͻðڽ��ϱ�?")) f.submit();
  }

  function hiddenDelMoreInfoDiv() {
	  document.all.delMoreInfoDiv.style.display = 'none';
  }
</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
<form name="formName" method="post" action="<%=request.getRequestURI()%>">
		<%  //�䱸 ���� ���� ���� �ޱ�.
		String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
		String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");
		//�䱸�� ���� ������ ��ȣ �ޱ�.
		String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");
		%>
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--�䱸�� ��ȸ�� -->
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		<input type="hidden" name="CommReqID" value="<%=(String)objParams.getParamValue("CommReqID")%>"><!--�䱸���� ID-->
		<input type="hidden" name="RefReqID" value="<%=strRefReqID%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqID" value="<%=objRsRI.getObject("REQ_ID")%>"><!--�䱸���� ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		<input type="hidden" name="IngStt" value="<%=strIngStt%>">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">

		<input type="hidden" name="ReqBoxStt" value="<%= strReqBoxStt %>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %> <span class="sub_stl" >- �䱸�󼼺���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></div>

      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">


        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸�� ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
	<%
		if(!objRsSH.next()){
	%>
            <tr>
                <td height="25" colspan="4"><strong>�䱸�� ������ �����ϴ�.</strong></td>
            </tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3">- <%=objRsSH.getObject("REQ_BOX_NM")%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25" colspan="3"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸��� </th>
                <td height="25"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;������</th>
                <td height="25"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25">
				<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
				</td>
				<th height="25">&bull;&nbsp;��������</th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
            </tr>
	<%
		}/** �䱸�� ���� �� ������. */
	%>
        </table>
<br><br>

        <span class="list02_tl">�䱸 ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			if(!objRsRI.next()){
		%>
            <tr>
                <td height="25" colspan="4"><strong>�䱸�� ������ �����ϴ�.</strong></td>
            </tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">- <%=objRsRI.getObject("REQ_CONT")%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%> </td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25"><%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%></td>
                <th height="25">&bull;&nbsp;����Ͻ�</th>
                <td height="25"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; ÷������ </th>
                <td height="25" colspan="3">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
           </tr>
            <tr>
                <th height="25">&bull; ��û��� </th>
                <td height="25"><%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%></td>
                <th height="25">&bull;&nbsp;��û��</th>
                <td height="25"><%=objRsRI.getObject("REGR_NM")%></td>
            </tr>
	<%
		}/** �䱸 ���� �� ������. */
	%>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>
-->
        <!-- ����Ʈ ��ư
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="#">�߰� �亯 �䱸</a></span>
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->

        <!-- /list===============================
        <span class="list01_tl">�䱸 ���
		<span class="list_total">&bull;&nbsp;��ü�ڷ�� :  �� ( /  Page) </span>
		</span>
<!--
checkbox

       <!-- ����Ʈ ��ư
        <div id="btn_all" >
		<!-- ����Ʈ �� �˻�

       <!-- /����Ʈ �� �˻�  -->
			<span class="right">
		<%
		String strDelete = "";
		if(strCmt.equalsIgnoreCase("")){
			strDelete = "gotoDelete()";
		} else {
			strDelete = "javascript:showDelMoreInfoDiv()";
		}

		/**����ȸ���� �űԵ���� �䱸�� ����-> ����??*/
		//�䱸�Ժ��� ��ư...
		/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
		if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
			if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
			%>
				<span class="list_bt"><a href="javascript:gotoEdit()">�䱸����</a></span>
				<span class="list_bt"><a href="#" onclick="<%=strDelete%>">�䱸����</a></span>
				<%}
			}
			%>
				<span class="list_bt"><a href="javascript:viewReqHistory('<%=(String)request.getParameter("CommReqID")%>')">�䱸 �̷� ����</a></span>
				<span class="list_bt"><a href="javascript:gotoReqBox()">�䱸�� ����</a></span>
			</span>
		</div>

<div id="delMoreInfoDiv" style="display:none;">
        <p><!-- ���� ��ϰ� ���� ����� ������ ���� �߰���.--></p>

        <span class="list02_tl">�䱸 ���� ���� �� �뺸��� </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
            <tr>
                <th height="25">&bull; �������� ���� </th>
                <td height="25" colspan="3"><input type="checkbox" name="NtcMtd" value="002">���
				</td>
            </tr>
            <tr>
                <th height="25">&bull; ���� </th>
                <td height="25" colspan="3"><textarea rows="3" cols="10" name="Rsn" class="textfield" style="WIDTH: 90% ; height: 30"></textarea> </td>
            </tr>
        </table>

	<span class="right">

				<span class="list_bt"><a href="FinalSubmit()">����</a></span>

</div>
        <!-- /����Ʈ ��ư-->
        <!-- /�������� ����
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>