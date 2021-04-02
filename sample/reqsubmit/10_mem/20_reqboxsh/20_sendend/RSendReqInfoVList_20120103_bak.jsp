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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqInfoVListForm objParams =new RMemReqInfoVListForm();
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false) {
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
	ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
	ResultSetHelper objRs=null;				/** �亯���� ��� ���*/
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	try {
		/**�䱸 ���� �븮�� New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**�䱸�� �̿� ���� üũ */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth) {
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� �䱸������ �� ������ �����ϴ�.");
			//out.println("�ش� �䱸������ �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));
			objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"),"Y"));/**���⸸ Y */
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
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="javascript">
	/**�䱸���� ������������ ����.*/
	function gotoEditPage(){
  		if(confirm("�䱸���� ��������� �����Ͻðڽ��ϱ�?")){
	  		formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc.jsp";
  			formName.submit();
  		}
  	}

	/** ������� ���� */
	function gotoList(){
  		formName.action="./RSendBoxVList.jsp";
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
<form name="formName" method="get" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
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
		    <input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
		    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--�䱸�� ������ ��ȣ -->
			<%if(StringUtil.isAssigned(strReqBoxQryField)){%>
			<input type="hidden" name="ReqBoxQryField" value=""><!--�䱸�� ��ȸ�ʵ� -->
			<input type="hidden" name="ReqBoxQryTerm" value=""><!--�䱸�� ��ȸ�ʵ� -->
			<%}//�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� �����.%>
			<input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsID" value=""><!--�亯����ID: �亯�󼼺���� -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

      <!-- pgTit -->

		<div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_SEND_END%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_SEND_END%></div>
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
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th width="120" scope="col">&bull;&nbsp;�䱸���� </th>
				  <td colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���� </th>
			  <td><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
               	  <%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG"))%>
			  </td>
            </tr>
		<%
			// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸�Ը�  </th>
			  <td><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
		<% } %>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���  </th>
			  <td><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;������  </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�������  </th>
			  <td>
				<select name="OpenCL" class="select">
				<%
					List objOpenClassList=CodeConstants.getOpenClassList();
					String strOpenClass=(String)objInfoRsSH.getObject("OPEN_CL");
					for(int i=0;i<objOpenClassList.size();i++){
						String strCode=(String)((Hashtable)objOpenClassList.get(i)).get("Code");
						String strValue=(String)((Hashtable)objOpenClassList.get(i)).get("Value");
						out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strOpenClass,strCode) + ">" + strValue + "</option>");
						}
				%>
				</select>
			  </td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;÷������  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�����  </th>
			  <td><%=(String)objInfoRsSH.getObject("REGR_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;����Ͻ�  </th>
			  <td><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�亯 ���⿩��  </th>
			  <td><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;����ȸ ���⿩��  </th>
			  <td><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- ����Ʈ ��ư-->
<!--
�䱸�� ���, ���ε�, �䱸�� ����, �亯�� �̸� ����, �亯�� �߼�, �������� ����
-->
         <div id="btn_all"  class="t_right">
		<%
		  //�䱸�� ���� ����.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//�䱸�Ի��°� �������̸� �̵� ���� ������ �Ұ�������.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004)) {
				/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
				if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
		%>
			 <span class="list_bt"><a href="javascript:gotoEditPage()">���� ���� ����</a></span>
		<%
					if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)) { //����Ϸ�ȰͿ� ���ؼ� �߰��䱸����
		%>
			 <span class="list_bt"><a href="javascript:requestAddAnswer()">�߰� �亯 �䱸</a></span>
		<%
					}//endif �߰��䱸
				}//endif
			}//end if

		%>
		<%
			// 2005-08-22 kogaeng ADD
			// 2005-08-29 kogaeng EDIT
			// ���� 1 : ������� �䱸���� �Ұ� ����ȸ �Ҽ� �ǿ��� �̾�� �Ѵ�.
			// ���� 2 : �Ҽ� ����� �ǿ����̾�� �Ѵ�.
			// ���� 3 : �䱸 ���� �ڵ� ������ ������� �ʾƾ� �Ѵ�.
			if(objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && ((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
		%>
			 <span class="list_bt"><a href="javascript:appointCmtReq()">����ȸ ���� ��û</a></span>
		<%
			}
		%>
			 <span class="list_bt"><a href="#" onclick="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">�䱸 �̷� ����</a></span>
			 <span class="list_bt"><a href="javascript:gotoList()">�䱸�� ����</a></span>
		 </div>

        <!-- /����Ʈ ��ư-->
        <!-- list -->
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=objRs.getRecordSize()%>��</span></span>
        <table>
			<tr><td>&nbsp;</td></tr>
		</table>



        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
			  <th scope="col">NO</th>
              <th scope="col">�����ǰ�</th>
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
		  while(objRs.next()){
			 strAnsInfoID=(String)objRs.getObject("ANS_ID");
		 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
		<%
				intRecordNumber++;
			} //endwhile
		%>
	<%
	/*��ȸ��� ������ ��� ����.*/
	if(objRs.getRecordSize()<1){
	%>
			<tr>
				<td colspan="6" align="cneter">����� �亯������ �����ϴ�.</td>
			</tr>
	<%
		}/*��ȸ��� ������ ��� ��.*/
	%>
          </tbody>
        </table>
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