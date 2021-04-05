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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.ROpenReqInfoListForm" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.ROpenReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../common/RUserCodeInfoInc.jsp" %>

<%
	/*********************************************************/
	/** �����ڷ� ��� ���� ���� üũ                           */
	/*********************************************************/
	/** �䱸�ڸ� ���� �ִ�. */
	if(objUserInfo.isRequester()==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSDATA-0035");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�䱸���� �󼼺��� �Ķ���� ����.*/
	ROpenReqInfoListForm objParams =new ROpenReqInfoListForm();
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/** ������ ��¿� �Ķ� üũ*/
	ROpenReqInfoVListForm  objAnsInfoParams=new ROpenReqInfoVListForm();
	blnParamCheck=objAnsInfoParams.validateParams(request);
	if(blnParamCheck==false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	RequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
	ResultSetHelper objRs=null;				/** �亯���� ��� ���*/
	try{
		/**�䱸 ���� �븮�� New */
		objReqInfo=new RequestInfoDelegate();
		objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objAnsInfoParams.getParamValue("ReqInfoID")));
		/**�䱸���� �̿� ���� üũ */
		if(!CodeConstants.OPN_CL_OPEN.equals((String)objInfoRsSH.getObject("OPEN_CL"))){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸�� �� ������ �����ϴ�. <br> ������ �䱸 ������ �ƴմϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
		/** �亯 ��� ��� */
		objRs=new ResultSetHelper(new AnsInfoDelegate().getRecordList(objAnsInfoParams));
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
<script language="javascript">
  /**�亯���� �󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.AnsInfoID.value=strID;
  	formName.action="../../../common/AnsInfoView.jsp";
  	formName.target="_blank";
  	formName.submit();
  }

  /** ������� ���� */
  function gotoList(){
  	formName.action="./ROpenReqList.jsp";
  	formName.submit();
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
 <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.OPEN_REQ_INFO_LIST%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >  <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.OPEN_REQ_INFO_LIST%></div>
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
		<div class="top_btn"><samp>
				<span class="btn"><a href="javascript:gotoList();">�䱸���</a></span>
        </samp></div>
        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3">- <%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; ����ȸ </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%> </td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25" width="120">&bull; ������ </th>
                <td height="25" width="220"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="120">&bull;&nbsp;�䱸��� </th>
                <td height="25" width="220"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
				</td>
                <th height="25">&bull;&nbsp;����������</th>
                <td height="25"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
                <th height="25" width="120">&bull; ����� </th>
                <td height="25" width="220"><%=(String)objInfoRsSH.getObject("REGR_NM")%> (<%=(String)objInfoRsSH.getObject("USER_NM")%>) </td>
                <th height="25" width="120">&bull;&nbsp;������� </th>
                <td height="25" width="220"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
        </table>
		<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :<%=objRs.getRecordSize()%>�� </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col" style="width:40%; "><a>�����ǰ�</a></th>
              <th scope="col"><a>�ۼ���</a></th>
              <th scope="col"><a>����</a></th>
               <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>�亯��</a></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=1;
		  String strAnsInfoID="";
		  while(objRs.next()){
			 strAnsInfoID=(String)objRs.getObject("ANS_ID");
		 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>

              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>

            </tr>
		<%
				intRecordNumber ++;
			}//endwhile
		%>
		<%
		/*��ȸ��� ������ ��� ����.*/
		if(objRs.getRecordSize()<1){
		%>
            <tr>
				<td colspan="6" align="center"> ����� �亯������ �����ϴ�.</td>
            </tr>
		<%
			}/*��ȸ��� ������ ��� ��.*/
		%>

          </tbody>
        </table>

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