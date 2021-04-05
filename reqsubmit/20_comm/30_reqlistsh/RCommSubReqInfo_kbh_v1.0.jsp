<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="java.util.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommAnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();
  objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���

  boolean blnParamCheck=false;
  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  }//endif
%>
<%
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

 /*** Delegate �� ������ Container��ü ���� */
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
 CommAnsInfoDelegate objAnsInfo = new CommAnsInfoDelegate();
 ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
 ResultSetSingleHelper objRsRI=null;			/** �䱸 �󼼺��� ���� */
 ResultSetHelper objRs = null;					/** �亯 ��� */

 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   /** �䱸�� ���� */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
   /**�䱸 ���� �븮�� New */
    objReqInfo=new CommRequestInfoDelegate();
	objRsRI=new ResultSetSingleHelper(objReqInfo.getRecord((String)request.getParameter("ReqInfoID")));
   	// �亯 ����� SELECT �Ѵ�.
   	objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)request.getParameter("ReqInfoID")));
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
	// �亯 �󼼺���� ����
  	function gotoDetail(strID){
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=520,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  		NewWindow('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 520, 400);
  	}

  	// ����� �䱸������� ����
  	function gotoList(){
  		f = document.formName;
  		f.action="RCommSubReqList.jsp";
  		f.submit();
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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
			<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
		    <input type="hidden" name="ReqInfoID" value="<%=(String)request.getParameter("ReqInfoID")%>">
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>?ReqBoxID=<%=(String)objParams.getParamValue("ReqBoxID")%>&ReqID=<%=(String)request.getParameter("ReqInfoID")%>&AuditYear=<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="Rsn" value="">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- �䱸�󼼺���</span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸 ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
		<%
			if(!objRsRI.next()){
		%>
			<tr>
				<td height="45" colspan="4">�䱸 ���� �� �����ϴ�.</td>
			</tr>
		<%
			}else{
		%>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><strong><%=objRsRI.getObject("REQ_CONT")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objRsRI.getObject("REQ_DTL_CONT"))%>
               	<%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsRI.getObject("TBDS_REQ_LOG"))%>     </td>
            </tr>
            <%
				if(!objRsSH.next()){
			%>
			<tr>
				<td height="25" colspan="4">�䱸�� ���� �� �����ϴ�.</td>
			</tr>
			<%
				}else{
			%>
            <tr>
			<%
				//�䱸�� ���� ����.
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%> </td>
            </tr>
            <tr>
                <th height="25" width="120">&bull; �䱸��� </th>
                <td height="25" width="220"><%=objRsSH.getObject("CMT_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="120">&bull;&nbsp;������ </th>
                <td height="25" width="220"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25">
				<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
				</td>
                <th height="25">&bull;&nbsp;��������</th>
                <td height="25"> <span class="list_bts"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></span></td>
            </tr>
			<%
			}/** �䱸�� ���� �� ������. */
			%>
            <tr>
                <th height="25">&bull; �䱸�Ͻ� </th>
                <td height="25">
				<%=StringUtil.getDate2((String)objRsRI.getObject("LAST_REQ_DT"))%>
				</td>
                <th height="25">&bull;&nbsp;�亯�Ͻ�</th>
                <td height="25"> <span class="list_bts"><%=StringUtil.getDate2((String)objRsRI.getObject("LAST_ANS_DT"))%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
				</td>
                <th height="25">&bull;&nbsp;��������</th>
                <td height="25"> <span class="list_bts"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></span></td>
            </tr>
            <tr>
                <th height="25">&bull; �������Ͼ�� </th>
                <td height="25" colspan="3">
				<%=StringUtil.makeAttachedFileLink((String)objRsRI.getObject("ANS_ESTYLE_FILE_PATH"),(String)objRsRI.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; ��û��� </th>
                <td height="25">
				<%=objRsRI.getObject("OLD_REQ_ORGAN_NM")%>
				</td>
                <th height="25">&bull;&nbsp;��û��</th>
                <td height="25"> <span class="list_bts"><%=objRsRI.getObject("REGR_NM")%></span></td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="viewReqHistory('<%= strReqID %>')">�䱸 �̷� ����</a></span>
			 <span class="list_bt"><a href="gotoList()">�䱸���</a></span>
<!--			 <span class="list_bt"><a href="#">�䱸�̷º���</a></span>
			 <span class="list_bt"><a href="#">�䱸���</a></span>
-->
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= objRs.getRecordSize() %>�� </span></span>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
               <th scope="col">
			  <input type="checkbox" name="checkAll" value="" onClick="javascript:checkAllOrNot(this.form)" class="borderNo"/>
			  </th>
              <th scope="col">NO</th>
              <th scope="col" style="width:40%; ">�����ǰ�</th>
              <th scope="col">�ۼ���</th>
              <th scope="col">����</th>
               <th scope="col">�亯</th>
              <th scope="col">�亯����</th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber=1;
				String strAnsInfoID="";
				if (objRs.getRecordSize() > 0) {
					while(objRs.next()) {
						strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
			  <td><input type="checkbox" name="AnsID" value="<%= strAnsInfoID %>" class="borderNo"/></td>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>

              <td><%=(String)objRs.getObject("USER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
			<%
						intRecordNumber ++;
					} // endwhile
				} else {
			%>
            <tr>
				<td colspan="6" align="center"> ��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
				}
//�߰� �亯 ���			%>

          </tbody>
        </table>
		<%
			if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
		%>
         <div id="btn_all"class="t_right">
			 <span class="list_bt"><a href="javascript:goSbmtReqForm()" onfocus="this.blur()">�߰� �亯 ���</a></span>
		</div>
		<%
			}
		%>

        <!-- /list -->


        <!-- /�������� ���� -->
      </div>
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>