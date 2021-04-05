<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoListViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.PreAnswerInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqInfoListViewForm objParams =new RPreReqInfoListViewForm();
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
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 PreRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
 ResultSetHelper objRs=null;				/** �亯���� ��� ���*/
 try{
   /**�䱸�� ���� �븮�� New */
   objReqInfo=new PreRequestInfoDelegate();
    //�ӽù��� ���� ������ �����Ͽ���..�������� ��....���� ������ �ذ��Ұ��ΰ�??? -by yan 2004.04.08
   /**�䱸�� �̿� ���� üũ */
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();

   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸������ �� ������ �����ϴ�.");
  	  //out.println("�ش� �䱸������ �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));

    //out.println("ReqInfoID");
    objRs=new ResultSetHelper(new PreAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**���⸸ Y */
  }/**���� endif*/
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

<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/


%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">

  /** ������� ���� */
  function gotoList(){
  	formName.action="./RNonPreReqInfoList.jsp";
  	formName.submit();
  }
  /** �䱸 �̷º��� */
  function viewReqHistory() {
  	alert('�䱸�̷º���');
  }
  /** ���Ŀ䱸���� */
  function appointCmtReq(){
  	alert('���Ŀ䱸����');
  }


</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
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
<form name="formName" method="get" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >   <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%>  > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p>���������� �亯�� �䱸 ���� ����� Ȯ���ϴ� ȭ���Դϴ�. </p>
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

            <tr>
                <th height="25">&bull; ����ȸ </th>
                <td height="25" colspan="3"><strong><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; ������ </th>
                <td height="25" ><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
                <th height="25" width="120">&bull; �䱸��� </th>
                <td height="25" width="220"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">
				<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
				</td>
				<th height="25">&bull; ÷������ </th>
                <td height="25">
				<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; ����� </th>
                <td height="25">
				<%=(String)objInfoRsSH.getObject("REGR_NM")%>
				</td>
				<th height="25">&bull; ������� </th>
                <td height="25">
				<%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%>
				</td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->
        <!-- ����Ʈ ��ư-->
         <div id="btn_all"class="t_right">
		<%
		//���� ����
		 if(!strReqSubmitFlag.equals("004")){

			//�䱸�Ի��°� �������̸� �̵� ���� ������ �Ұ�������.
            String strReqBoxStt = (String)objInfoRsSH.getObject("REQ_BOX_STT");
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)){
		%>
		  <%
			/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
			//if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
				if(objUserInfo.getOrganGBNCode().equals("004")){
		  %>
			 <span class="list_bt"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">�䱸�̷º���</a></span>
			  <%      }

		  } // ���Ѿ����� ���� %>
			 <span class="list_bt"><a href="javascript:gotoList()">�䱸���</a></span>
			  <%
				//}//endif
			  %>
			<%
			}//end if


			%>

<!--			 <span class="list_bt"><a href="#">�䱸�̷º���</a></span>
			 <span class="list_bt"><a href="#">�䱸���</a></span>
-->
		 </div>

        <!-- /����Ʈ ��ư-->

        <!-- list -->

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