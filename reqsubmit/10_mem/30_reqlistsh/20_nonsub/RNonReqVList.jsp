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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RMemReqInfoListViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqInfoListViewForm objParams =new RMemReqInfoListViewForm();
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

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;

	ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
	ResultSetHelper objRs=null;				/** �亯���� ��� ���*/

	try {
		/**�䱸�� ���� �븮�� New */
		objReqInfo=new MemRequestInfoDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();

		/**�䱸�� �̿� ���� üũ */
		boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
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
			objRs = new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList((String)objParams.getParamValue("ReqInfoID"), "Y"));/**���⸸ Y */

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
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<script language="javascript">
  /**�䱸���� ������������ ����.*/
  function gotoEditPage(){
  	if(confirm("�䱸���� ��������� �����Ͻðڽ��ϱ�?")){
	  	formName.action="/reqsubmit/common/ChangeReqInfoOpenCLProc2.jsp";
  		formName.submit();
  	}
  }

  /** ������� ���� */
  function gotoList(){
  	formName.action="./RNonReqList.jsp";
  	formName.submit();
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
</head>

<body>
<div id="wrap">
<div id="balloonHint" style="display:none">
<table border="0" cellspacing="0" cellpadding="4">
<tr><td class="td_top" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080"><font style="font-size:11px;font-family:verdana,����">{{hint}}</font></td></tr>
</table>
</div>
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>
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
			<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
			<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">
			<input type="hidden" name="CmtReqAppFlag" value="<%=objParams.getParamValue("CmtReqAppFlag")%>">
			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqInfoID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsID" value=""><!--�亯����ID -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			<input type="hidden" name="CmtReqAppFlag" value="<%=objParams.getParamValue("CmtReqAppFlag")%>">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%> <span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_NONE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">
        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸���� </span>

        <!-- ��� ��ư

		-->
         <div class="top_btn">
			<samp>
		<!-- ���� �Ϸ� -->
		<%
		  //�䱸�� ���� ����.
		  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
		%>
		<%
			//�䱸�Ի��°� �������̸� �̵� ���� ������ �Ұ�������.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004) && objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
		%>
			 <span class="btn"><a href="#" onclick="gotoEditPage()">���� ���� ����</a></span>
		<%
			} // end if check status
		%>
			 <span class="btn"><a href="#" onclick="viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="#" onclick="gotoList()">�䱸 ���</a></span>
			 </samp>
		 </div>

        <!-- /��� ��ư-->

        <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">

            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><strong><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></strong></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸���� </th>
                <td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                <%=nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG"))%>
				</td>
            </tr>
		<%
			// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
			if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
			} else {
		%>
            <tr>
                <th height="25">&bull; �Ұ� ����ȸ </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%></td>
            </tr>
		 <% } %>
            <tr>
                <th height="25">&bull; �䱸�Ը� </th>
                <td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
                <th height="25" width="18%">&bull; �䱸��� </th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> (<%=(String)objInfoRsSH.getObject("REGR_NM")%>)</td>
                <th height="25" width="18%">&bull;&nbsp;������</th>
                <td height="25" width="32%"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
					<select name="OpenCL" class="select_reqsubmit">
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
                <th height="25">&bull;&nbsp;���������� </th>
                <td height="25">
					<%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%>
				</td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25"><%= StringUtil.getDate((String)objInfoRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                <th height="25">&bull;&nbsp;�䱸�Ͻ�</th>
                <td height="25"><%=StringUtil.getDate2((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; �亯 ������� </th>
                <td height="25"><%=CodeConstants.getRequestStatus((String)objInfoRsSH.getObject("REQ_STT"))%></td>
                <th height="25">&bull;&nbsp;����ȸ �������</th>
                <td height="25"><%=CodeConstants.getCmtRequestAppoint((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG"))%></td>
            </tr>
        </table>
        <!-- /list view -->
<!--        <p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>
-->
        <!-- �ߴ� ��ư -->
         <div id="btn_all">
			<div  class="t_right">
		<!-- ���� �Ϸ� -->
		<%
			//�䱸�Ի��°� �������̸� �̵� ���� ������ �Ұ�������.
			if(!strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_004) && objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))) {
				if(((String)objInfoRsSH.getObject("CMT_REQ_APP_FLAG")).equals(CodeConstants.CMT_REQ_APP_FLAG_MEM) && objUserInfo.getIsMyCmtOrganID((String)objInfoRsSH.getObject("CMT_ORGAN_ID")) && !objCmtSubmt.checkCmtOrganMakeAutoSche((String)objInfoRsSH.getObject("CMT_ORGAN_ID"))) {
					// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
					if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
					} else {
		%>
			 <div class="mi_btn"><a href="#" onclick="appointCmtReq()"><span>����ȸ ���� ��û</span></a></div>
		<%
					}
				}

			} // end if check status
		%>

			</div>
		 </div>

        <!-- /�ߴ� ��ư-->

        <!-- list -->
  <%
		// 2005-10-04 kogaeng ADD
		// �߰��亯�� ��� ������ ��ϵ� �亯�� ����� ���δ�.
		if(CodeConstants.REQ_STT_ADD.equals((String)objInfoRsSH.getObject("REQ_STT"))) {
  %>
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=objRs.getRecordSize()%>�� </span></span>
<!--
checkbox
<input name="" type="checkbox" value="" class="borderNo" />
-->
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">NO</th>
              <th scope="col">���� �ǰ�</th>
              <th scope="col">�ۼ���</th>
              <th scope="col">��������</th>
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
                <td height="22" width="19" align="center"><%=intRecordNumber%></td>
                <td width="370" class="td_lmagin"><a href="JavaScript:gotoAnsInfoView('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
                <td width="100" align="center"><%=(String)objRs.getObject("ANSWER_NM")%></td>
                <td width="80" align="center"><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
                <td width="120" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
                <td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
	<%
			intRecordNumber ++;
		}//endwhile
	%>

<!--
	�ڷᰡ ���� ���
			<tr>
			 <td colspan="6"  align ="center"> ��ϵ� �䱸������ �����ϴ�. </td>
            </tr>
-->
          </tbody>
        </table>
	 <%
			}
	  %>

        <!-- /list -->

        <!-- ����¡
        <span class="paging" > <span class="list_num_on"><a href="#">1</a></span> <span class="list_num"><a href="#">2</a></span> <span class="list_num"><a href="#">3</a></span> <span class="list_num"><a href="#">4</a></span> <span class="list_num"><a href="#">5</a></span> </span>

         /����¡-->


       <!-- ����Ʈ ��ư
        <div id="btn_all" >
		<!-- ����Ʈ �� �˻� -->
<!--
		<div class="list_ser" >
          <select name="select" class="selectBox5"  style="width:70px;" >
            <option value="">�䱸����</option>
            <option value="">�䱸����</option>
          </select>
          <input name="iptName" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/> </div>
-->
        <!-- /����Ʈ �� �˻�
			<span class="right">
				<span class="list_bt"><a href="#">�䱸����</a></span>
				<span class="list_bt"><a href="#">�䱸�̵�</a></span>
				<span class="list_bt"><a href="#">�䱸����</a></span>
				<span class="list_bt"><a href="#">�䱸����</a></span>
			</span>
		</div>

         /����Ʈ ��ư-->
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