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


  /**�亯���� �󼼺���� ����.*/

  function gotoDetail(strID){
  	formName.AnsInfoID.value=strID;

  	window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');

  }


  /**�䱸���� ������������ ����.*/
  function gotoEditPage(){
  	alert('�䱸��޼����ض�..');
  }
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RSubPreReqInfoList.jsp";
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
	<input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
	<input type="hidden" name="AnsInfoID" value=""><!--�亯����ID -->
	<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
	<input type="hidden" name="Rsn" value=""><!--�߰��䱸 -->

      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_INFO_LIST_SUBMT_DONE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_DETAIL_VIEW%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> >   <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%>
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
		<% //���� ����
		  if(!strReqSubmitFlag.equals("004")){
		%>
		  <%
			/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
			//if(objUserInfo.getUserID().equals((String)objInfoRsSH.getObject("REGR_ID"))){
				if(objUserInfo.getOrganGBNCode().equals("004")){ //����ȸ������ ���̵���
		  %>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=objParams.getParamValue("ReqInfoID")%>')">�䱸 �̷� ����</a></span>
		<%
		  if(((String)objInfoRsSH.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//����Ϸ�ȰͿ� ���ؼ� �߰��䱸����
		%>
			 <span class="btn"><a href="javascript:requestAddAnswer()">�߰� �亯 �䱸</a></span>
			<%
			  }//endif �߰��䱸
			%>


		  <%     }//����ȸ������ ���̵��� %>
		<%
		}//end if ���� ����
		%>
			 <span class="btn"><a href="javascript:gotoList()">�䱸���</a></span>
		  <%
			//}//endif
		  %>
<!--			 <span class="list_bt"><a href="#">�䱸�̷º���</a></span>
			 <span class="list_bt"><a href="#">�䱸���</a></span>
-->
		</samp></div>
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
                <td height="25" colspan="3"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �䱸��� </th>
                <td height="25" colspan="3"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%></td>
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
                <th height="25" width="18%">&bull; ������� </th>
                <td height="25" width="32%"><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%></td>
				<th height="25" width="18%">&bull; ÷������ </th>
                <td height="25" width="32%">
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
        <div id="btn_all"><div  class="t_right">
        </div></div>
        <!-- /����Ʈ ��ư-->

        <!-- list -->
        <span class="list01_tl">�亯��� <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=objRs.getRecordSize()%>�� </span></span>
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
			  if(objRs.getRecordSize()>0){
			  while(objRs.next()){
				 strAnsInfoID=(String)objRs.getObject("ANS_ID");
			 %>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="JavaScript:gotoDetail('<%=strAnsInfoID%>');"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
              <td><%=(String)objRs.getObject("ANSWER_NM")%></td>
              <td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
              <td><<%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>
            </tr>
			<%
					intRecordNumber ++;
				}//endwhile
			}else{
			%>
            <tr>
				<td colspan="6" align="center"> ��ϵ� �亯������ �����ϴ�.</td>
            </tr>
			<%
			}//end if ��� ��� ��.
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