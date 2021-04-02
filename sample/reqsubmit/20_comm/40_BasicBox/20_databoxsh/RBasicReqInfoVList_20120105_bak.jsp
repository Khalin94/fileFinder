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
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();


  /**�Ϲ� �䱸 �󼼺��� �Ķ���� ����.*/
  RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();
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
 ResultSetSingleHelper objInfoRsSH=null;		/**�䱸 ���� �󼼺��� */

 ResultSetHelper objRs=null;				/** �亯���� ��� ���*/

 try{
   /**�䱸 ���� �븮�� New */
    objReqInfo=new PreRequestInfoDelegate();
   /**�䱸���� �̿� ���� üũ */
   //���� üũ�� ���ؼ� �����غ����Ѵ�..���� �ȵƴ�....-by yan 2004.04.08

   //boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),objUserInfo.getOrganID()).booleanValue();
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth((String)objParams.getParamValue("ReqInfoID"),(String)objParams.getParamValue("CmtOrganID")).booleanValue();
   //out.println("info: "+blnHashAuth);
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  //out.println("�ش� �䱸���� �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
  }else{

    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord((String)objParams.getParamValue("ReqInfoID")));

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
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--

  /**�亯���� �󼼺���� ����.*/
  function gotoDetail(strID){
  window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&ReqID=<%=objParams.getParamValue("ReqInfoID")%>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  }

  /**�䱸���� ������������ ����.*/
  function gotoEditPage(){
  	formName.action="./RBasicReqInfoEdit.jsp";
  	formName.submit();
  }
  /**�䱸 ���� ���� */
  function gotoDeletePage(){
  	if(confirm('�����Ͻ� �䱸������ �����Ͻðڽ��ϱ�?')){
	  	formName.action="./RBasicReqInfoDelProc.jsp";
  		formName.submit();
  	}
  }
  /** �䱸�� ����  */
  function gotoBoxView(){
  	formName.action="./RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
  	formName.submit();
  }

 //-->
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
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
    </div>
    <div id="rightCon">
          <form name="formName" method="post" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
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

			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
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

			<input type="hidden" name="Rsn" value=""><!--�߰��䱸 -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_PRE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <b><%=MenuConstants.REQ_BOX_PRE%></b></div>
        <p>���������� ���� �䱸���� �䱸������ Ȯ���ϴ� ȭ���Դϴ�. </p>
      </div>

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸 ���� </span>
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
                <table border="0" cellspacing="0" cellpadding="0" width="680" class="list02">
                    <tr>
                      <th height="25">&bull; ����ȸ </th>
                      <td height="25" colspan="3">
                      	<%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; �䱸�Ը� </th>
                      <td height="25" colspan="3">
                      	<%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; ������ </th>
                      <td width="191" height="25">
                      	<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
                      </td>
                      <th height="25">&bull; �䱸��� </th>
                      <td width="191" height="25">
                      	<%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; �䱸���� </th>
                      <td height="25" colspan="3">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%>
                      	<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objInfoRsSH.getObject("TBDS_REQ_LOG")) %>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; �䱸�󼼳��� </th>
                      <td height="25" colspan="3">
                      	<%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull; ������� </th>
                      <td height="25">
                      	<%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%>
                      </td>
                      <th height="25">&bull; ÷������</th>
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
               	    <%
					  //�䱸�� ���� ����.
					  String strReqBoxStt=(String)objInfoRsSH.getObject("REQ_BOX_STT");
					%>


         <div id="btn_all"class="t_right">
            <%
         //���� ���� 001
         if(!strReqSubmitFlag.equals("004")){ %>
            <%
              if(objUserInfo.getOrganGBNCode().equals("004")){
                /** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
                //if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
                 String strReqStt1 = (String)objInfoRsSH.getObject("REQ_STT");
                 if(strReqStt1.equals("001")){
              %>
            <span class="list_bt"><a href="javascript:gotoEditPage()">�䱸����</a></span>
                <%}%>
                <%if( objInfoRsSH.getObject("ANS_CNT").equals("0")){ %>
            <span class="list_bt"><a href="javascript:gotoDeletePage()">�䱸����</a></span>
                <% } %>

                    <%//�߰��亯�䱸
                    if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//����Ϸ�ȰͿ� ���ؼ� �߰��䱸����
                    %>
            <span class="list_bt"><a href="javascript:requestAddAnswer()">�߰� �亯 �䱸</a></span>
                    <%
                     }//endif �߰��䱸
                    %>
              <%
                //}//endif
             }//endif - ����ȸ������ ���̵���..
            %>
         <%} //end if 001 ���Ѿ����� ���� %>

            <!-- �䱸�� ���� -->
			 <span class="list_bt"><a href="javascript:gotoBoxView()">�䱸�Ժ���</a></span>
		 </div>



              <%
              	String strReqStt = (String)objInfoRsSH.getObject("REQ_STT");
              	if(strReqStt.equals("002")||strReqStt.equals("003")){

              %>
        <span class="list01_tl">�亯���
		<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= objRs.getRecordSize() %>�� </span>
		</span>

        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col">NO</th>
              <th scope="col" style="width:40%; ">�����ǰ�</th>
              <th scope="col">�ۼ���</th>
              <th scope="col">����</th>
              <th scope="col">�� ��</th>
              <th scope="col">�� �� ��</th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber= 1;
				if(objRs.getRecordSize() < 1) {
			%>
            <tr>
				<td colspan="6" align="center"> ��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
				}
				String strAnsInfoID="";
                while(objRs.next()){
                    strAnsInfoID=(String)objRs.getObject("ANS_ID");
			%>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td align="center"><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
			<%
				intRecordNumber++;
			} //endwhile
			%>
          </tbody>
        </table>
	        <!-- /list -->


        <!-- /�������� ���� -->
      </div>


              <%
              	}
              %>

</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>