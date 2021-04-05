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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SPreReqInfoViewForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.SPreReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

	SPreReqInfoViewForm objParams = new SPreReqInfoViewForm();
	SPreReqInfoDelegate objReqInfo = new SPreReqInfoDelegate();
	AnsInfoDelegate objAnsInfo = new AnsInfoDelegate();

  	boolean blnParamCheck = false;
  	blnParamCheck = objParams.validateParams(request);
  	if(blnParamCheck == false){
  		System.out.println("Param Check Error ");
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
%>
  		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
  	}

	String strReqID = (String)objParams.getParamValue("ReqID");
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	//String strReqID = objParams.getParamValue("ReqID");


 	ResultSetSingleHelper objInfoRsSH = null;	/**�䱸 ���� �󼼺��� */
 	ResultSetHelper objRs = null;				/** �亯���� ��� ���*/

 	try{
  		objInfoRsSH = new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqID")));
   		//objRs = new ResultSetHelper(objAnsInfo.getRecordList((String)objParams.getParamValue("ReqID")));
   		objRs = new ResultSetHelper(objAnsInfo.getRecordList(strReqID));
	} catch(AppException objAppEx) {
		System.out.println("AppException : "+objAppEx.getMessage());
  		objAppEx.printStackTrace();
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
  		return;
	}
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /**�亯���� �󼼺���� ����.*/
  //function gotoDetail(strID){

  //	window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  //}

// �亯 �󼼺���� ����
  	function gotoDetail(strID){
		f = document.formName;
	  	f.AnsID.value = strID;
		f.target = "popwin";
	  	f.action="/reqsubmit/common/SAnsInfoView.jsp";
		NewWindow('/blank.html', 'popwin', '520', '320');
	  	f.submit();
  	}

  /** ������� ���� */
  function gotoList(){
  	formName.action="SSubPreInfoList.jsp";
  	formName.submit();
  }

  /** �䱸 �̷º��� */
  function viewReqHistory() {
  	alert('�䱸�̷º���');
  }

  // �߰� �亯 �ۼ� ȭ������ �̵�
	function gotoAddAnsInfoWrite() {
	    formName.action="/reqsubmit/20_comm/40_BasicBox/20_databoxsh/SBasicAnsInfoWrite.jsp";
	    formName.target="";
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
		    %>
		    <input type="hidden" name="ReqBoxID" value="<%= objInfoRsSH.getObject("REQ_BOX_ID") %>">
		    <input type="hidden" name="ReqID" value="<%= strReqID %>">

			<input type="hidden" name="ReqInfoSortField" value="<%=objParams.getParamValue("ReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="ReqInfoSortMtd" value="<%=objParams.getParamValue("ReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="ReqInfoQryField" value="<%=objParams.getParamValue("ReqInfoQryField")%>"><!--�䱸���� ��ȸ �ʵ�-->
			<input type="hidden" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>"><!--�䱸���� ��ȸ��-->
			<input type="hidden" name="ReqInfoPage" value="<%=objParams.getParamValue("ReqInfoPage")%>"><!--�䱸���� ������ ��ȣ -->
			<input type="hidden" name="ReqInfoID" value="<%=objParams.getParamValue("ReqID")%>"><!--�䱸���� ID-->
			<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
			<input type="hidden" name="AnsID" value=""><!--�亯����ID -->
			<input type="hidden" name="WinType" value="SELF">
			<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= objInfoRsSH.getObject("REQ_BOX_ID") %>&ReqID=<%=strReqID %>">
			<input type="hidden" name="AddAnsFlag" value="Y">

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
                        > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%></div>
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
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqID")%>')">�䱸 �̷� ����</a></span>
			 <span class="btn"><a href="javascript:gotoList();">�䱸 ���</a></span>
		</samp></div>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list02">

            <tr>

              <th scope="col">&bull;&nbsp;�䱸�Ը� </th>
				  <td colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;������ </th>
			  <td><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸���  </th>
			  <td>	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸����  </th>
			  <td>	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�䱸����  </th>
			  <td>	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�������  </th>
			  <td><%= CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL")) %></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;����������  </th>
			  <td><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
            </tr>
            <tr>
              <th scope="col">&bull;&nbsp;�����  </th>
			  <td><%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%></td>
            </tr>
        </table>
        <!-- /list view -->
        <!-- ����Ʈ ��ư-->
<!--
�䱸 �̷� ����, �䱸���
-->
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯 ��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� :  <%=objRs.getRecordSize()%>�� </span></span>
        <table width="100%" style="padding:0;">
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col"><a>�����ǰ�</a></th>
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
		  if(objRs.getRecordSize()>0){
		  while(objRs.next()){
			 strAnsInfoID=(String)objRs.getObject("ANS_ID");
		 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
<%
			intRecordNumber++;
		} //endwhile
	}else{
%>
            <tr>
              <td colspan="6" align="center">��ϵ� �亯������ �����ϴ�.</td>
            </tr>
<%
	}//end if ��� ��� ��.
%>
          </tbody>
        </table>
        <!-- /list -->

       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
			<span class="list_bt"><a href="javascript:gotoAddAnsInfoWrite()" onfocus="this.blur()">�߰��亯���</a></span>
<!--
			<span class="list_bt"><a href="#">�䱸����</a></span>
			<span class="list_bt"><a href="#">�䱸����</a></span>
-->
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