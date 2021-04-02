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
<%@ page import="nads.lib.reqsubmit.util.FileUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
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

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸 �󼼺��� �Ķ���� ����.*/
	RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
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

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objInfoRsSH=null;		/**�䱸 ���� �󼼺��� */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try {
		/**�䱸 ���� �븮�� New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**�䱸���� �̿� ���� üũ */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸������ �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
		}/**���� endif*/
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
		objMsgBean.setStrCode("SYS-00010");//AppException����.
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--

  /**�亯���� �󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="../../../common/AnsInfoView.jsp";
  	formName.target="_blank";
  	formName.submit();
  }
  /**�䱸���� ������������ ����.*/
  function gotoEditPage(){
  	formName.action="./RMakeReqInfoEdit.jsp";
  	formName.submit();
  }
  /**�䱸 ���� ���� */
  function gotoDeletePage(){
  	if(confirm('�����Ͻ� �䱸������ �����Ͻðڽ��ϱ�?')){
	  	formName.action="./RMakeReqInfoDelProc.jsp";
  		formName.submit();
  	}
  }
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RMakeReqBoxVList.jsp";
  	formName.submit();
  }

  function popUpWindow(){
     NewWindow('./RMakeReqInfoFileOpen.jsp?ReqInfoID=<%=(String)objParams.getParamValue("ReqInfoID")%>', '', '810', '610');
  }
 //-->
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
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
	<%//�䱸�� ���� ���� �ޱ�.
	String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
	//�䱸�� ������ ��ȣ �ޱ�.
	String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
	//�䱸�� ��ȸ���� �ޱ�.
	String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
	//�䱸 ���� ���� ���� �ޱ�.
	String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
	//�䱸 ���� ������ ��ȣ �ޱ�.
	String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
	%>
	 <%=objParams.getHiddenFormTags()%>
	<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></div>
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
<!-- ��� ��ư-->
<!--
�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����
-->
		<%
		  //�䱸�� ���� ����.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
         <div class="top_btn">
		  <samp>
<!--
�䱸 ����
�䱸 ����
�䱸 �̵�
�䱸 ����
����ȸ ���� ��û
�䱸 �̷� ����
�䱸�� ����

-->
		<%
			//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
			//�� �ۼ��߰� �ݷ����¿����� ������.
			if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
				/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
				if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
		%>
			 <span class="btn"><a href="javascript:gotoEditPage()">�䱸 ����</a></span>
			 <span class="btn"><a href="javascript:gotoDeletePage()">�䱸 ����</a></span>
			 <span class="btn"><a href="javascript:moveSingleMemReqInfo(document.formName,'/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp')">�䱸 �̵�</a></span>
		<%
				}//endif
			}//end if
		%>
			 <span class="btn"><a href="javascript:copySingleMemReqInfo(document.formName)">�䱸 ����</a></span>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// ���� 1 : ������� �䱸���� �Ұ� ����ȸ �Ҽ� �ǿ��� �̾�� �Ѵ�.
			// ���� 2 : �Ҽ� ����� �ǿ����̾�� �Ѵ�.
			// ���� 3 : �䱸 ���� �ڵ� ������ ������� �ʾƾ� �Ѵ�.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="btn"><a href="javascript:appointCmtReq()">����ȸ ���� ��û</a></span>
		<%
			}
		%>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList()">�䱸�� ����</a></span>
			  </samp>
		 </div>
<!-- ��� ��ư ��-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th height="25" scope="col" width="120">&bull;&nbsp;�䱸���� </th>
				  <td colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�䱸����</th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
            </tr>
		<%
			// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�Ұ� ����ȸ  </th>
			  <td><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
		 <% } %>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�䱸�Ը�  </th>
			  <td><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�䱸���  </th>
			  <td><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;������  </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�������  </th>
			  <td><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;÷������  </th>
				  <td><%
							String strFileExt = FileUtil.getFileExtension((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"));
							String strReqFilePath = StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objInfoRsSH.getObject("REQ_ID"));
							if (StringUtil.isAssigned(strReqFilePath)) {
								out.println(strReqFilePath);
							}
						%>
				</td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�����  </th>
			  <td><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;����Ͻ�  </th>
			  <td><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;�亯 ���⿩��  </th>
			  <td><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
            </tr>
            <tr>
              <th height="25"  scope="col" width="120">&bull;&nbsp;����ȸ ���⿩��  </th>
			  <td><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
<div id="btn_all"  class="t_right">

		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// ���� 1 : ������� �䱸���� �Ұ� ����ȸ �Ҽ� �ǿ��� �̾�� �Ѵ�.
			// ���� 2 : �Ҽ� ����� �ǿ����̾�� �Ѵ�.
			// ���� 3 : �䱸 ���� �ڵ� ������ ������� �ʾƾ� �Ѵ�.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="mi_btn"><a href="javascript:appointCmtReq()">����ȸ ���� ��û</a></span>
		<%
			}
		%>

		 </div>

      </div>
      <!-- /contents -->
    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>