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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>

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
 //�߰��亯 �� ���⿩��Ȯ��
 SMemReqBoxDelegate sReqDelegate = new SMemReqBoxDelegate();
 //�䱸��Ŭ���� ANSW_INQ_YN�� ���� 2016.02.17 ksw
 AnsInfoDelegate objSMAIDelegate = new AnsInfoDelegate();
 
 String strBoxId = (String)request.getParameter("ReqBoxId");
 System.out.println("kangthis logs RCommSubReqInfo.jsp strBoxId => " + strBoxId);
 
 //�亯�Ϸ�� �Ŀ� �߰��亯 �ִ��� ���� Ȯ��
 int intNotSubmitAnsCnt = sReqDelegate.getAnsCntNotSubmit(strBoxId);
 System.out.println("kangthis logs RCommSubReqInfo.jsp(strBoxId) => " + strBoxId);
 System.out.println("kangthis logs RCommSubReqInfo.jsp(intNotSubmitAnsCnt) => " + intNotSubmitAnsCnt);
 if (intNotSubmitAnsCnt > 0) {
 		int intUpdateResult = objSMAIDelegate.setRecordToAnsInfo_view1(strBoxId);	
 }

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
	/**�亯���λ��� �����ϱ�.*/
	function gotoEditPage2(){
		if(confirm("�䱸���� �亯���λ��¸� �����Ͻðڽ��ϱ�?")){
			formName.action="/reqsubmit/common/ChangeReqInfoAnsApprSttProc.jsp";
			formName.submit();
		}
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

        <!-- ��� ��ư ����-->
         <div class="top_btn">
			<samp>
		<%
		/**����ȸ���� �űԵ���� �䱸�� ����-> ����??*/
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
			if(((String)objRsRI.getObject("REQ_STT")).equals(CodeConstants.REQ_STT_SUBMT)){//����Ϸ�ȰͿ� ���ؼ� �߰��䱸����
		%>
			 <span class="btn"><a href="javascript:requestAddAnswer()">�߰��亯 �䱸</a></span>
		<%	 }
			} %>
			 <span class="btn"><a href="javascript:gotoList()">�䱸���</a></span>
			 <span class="btn"><a href="javascript:viewReqHistory('<%=(String)request.getParameter("ReqInfoID")%>')">�䱸�̷º���</a></span>
			 </samp>
		 </div>

        <!-- /��� ��ư ��-->

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
                <th height="25" width="18%">&bull; �䱸��� </th>
                <td height="25" width="32%"><%=objRsSH.getObject("CMT_ORGAN_NM")%> (<%=(String)objRsRI.getObject("REGR_NM")%>) </td>
                <th height="25" width="18%">&bull;&nbsp;������ </th>
                <td height="25" width="32%"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �������� </th>
                <td height="25">
				<%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%>
				</td>
                <th height="25">&bull;&nbsp;��������</th>
                <td height="25"> <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%></td>
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
                <td height="25"><%=StringUtil.getDate2((String)objRsRI.getObject("LAST_ANS_DT"))%></td>
            </tr>
            <tr>
                <th height="25">&bull; ������� </th>
                <td height="25">
				<%=CodeConstants.getOpenClass((String)objRsRI.getObject("OPEN_CL"))%>
				</td>
                <th height="25">&bull;&nbsp;��������</th>
                <td height="25"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%></td>
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
                <td height="25"><%=objRsRI.getObject("REGR_NM")%></td>
            </tr>
            <tr>
                <th height="25">&bull; �亯 ���λ��� </th>
                <td height="25">
					<select name="ANSW_PERM_CD" class="select_reqsubmit">
					<%
						List objAnsApprSttList=CodeConstants.getAnsApprSttList();
						String strAnsApprStt=(String)objRsRI.getObject("ANSW_PERM_CD");
						for(int i=0;i<objAnsApprSttList.size();i++){
							String strCode=(String)((Hashtable)objAnsApprSttList.get(i)).get("Code");
							String strValue=(String)((Hashtable)objAnsApprSttList.get(i)).get("Value");
							out.println("<option value=\"" + strCode + "\"" + StringUtil.getSelectedStr(strAnsApprStt,strCode) + ">" + strValue + "</option>");
						}
					%>
					</select>
				</td>
                <th height="25">&nbsp;</th>
                <td height="25">&nbsp;</td>
            </tr>
		<%
		}/** �䱸 ���� �� ������. */
		%>
			<tr>
				<td height="25" colspan="4" align="center"></td>
            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->
        <!-- �ߴ� ��ư ����-->
         <div id="btn_all">
			<div  class="t_right">
		<%
		/**����ȸ���� �űԵ���� �䱸�� ����-> ����??*/
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
		%>
            <div class="mi_btn"><a href="javascript:gotoEditPage2()"><span>�亯���λ�������</span></a></div>
		<%} %>
			</div>
		 </div>

        <!-- /�ߴ� ��ư ��-->

        <!-- list -->
        <span class="list01_tl">�亯���
<!--		<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%= objRs.getRecordSize() %>�� </span> -->
		</span>




        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col"><a>NO</a></th>
              <th scope="col" style="width:40%; "><a>�����ǰ�</a></th>
              <th scope="col"><a>�亯</a></th>
              <th scope="col"><a>������</a></th>
              <th scope="col"><a>������</a></th>
            </tr>
          </thead>
          <tbody>
			<%
				int intRecordNumber= 1;
				if(objRs.getTotalRecordCount() < 1) {
			%>
            <tr>
				<td colspan="5" align="center"> ��ϵ� �亯�� �����ϴ�.</td>
            </tr>
			<%
				}
				while(objRs.next()){
			%>
            <tr>
              <td><%=intRecordNumber%></td>
              <td style="text-align:left;"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
              <td><%=this.makeAnsInfoHtml2((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"),(String)objRsRI.getObject("REQ_CONT"),intRecordNumber+"",(String)objRsSH.getObject("SUBMT_ORGAN_NM")) %></td>
              <td><%= objRs.getObject("ANSR_NM") %></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
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
</form>
      <!-- /contents -->

    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>

<%!
	public static String makeAnsInfoHtml2(String strAnsID,String strAnsMtd,String strReqCont,String strSeq,String strSubmt){
		StringBuffer strBufReturn=new StringBuffer();
		strBufReturn.append("<table width=\"100%\" border=\"0\"><tr>");
		if(strAnsMtd.equals(CodeConstants.ANS_MTD_ELEC)){
			strBufReturn.append("<td width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_EDoc.gif' width='73' height='16' border='0' >");
			strBufReturn.append("</td>");
			strBufReturn.append("<td width='37%' height='18' valign='top'>");
			strBufReturn.append("<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=PDF&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");
			strBufReturn.append("<img src='/image/common/icon_pdf.gif' width='16' height='16' border='0' alt='PDF����'>");
			strBufReturn.append("</a>");
			strBufReturn.append("&nbsp;<a href='/reqsubmit/common/ReqFileOpen2.jsp?paramAnsId=" + strAnsID + "&DOC=DOC&REQNM=" + strReqCont + "&REQSEQ=" + strSeq + "&SubmtOrganNm="+strSubmt+"' target='_self'>");
			strBufReturn.append("<img src='/image/common/icon_file.gif' border='0' alt='��������'>");
			strBufReturn.append("</a>");
			strBufReturn.append("</td>");
		}else if(strAnsMtd.equals(CodeConstants.ANS_MTD_ETCS)){
			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_NotEDoc.gif' width='73' height='16' border='0' >");
			strBufReturn.append("</td>");					
		}else if(strAnsMtd.equals("004")){
			strBufReturn.append("<td colspan=\\'2\\' width=\\'18\\' height=\\'18\\' align=\\'left\\' valign=\\'top\\'>");
			strBufReturn.append("<img src=\\'/image/reqsubmit/bt_offLineSubmit.gif\\' width=\\'73\\' height=\\'16\\' border=\\'0\\' alt=\\'���������� ���� ����\\'>");
			strBufReturn.append("</td>");					
		}else {
			strBufReturn.append("<td colspan='2' width='18' height='18' align='left' valign='top'>");
			strBufReturn.append("<img src='/image/reqsubmit/bt_NotPertinentOrg.gif' width='73' height='16' border='0'>");
			strBufReturn.append("</td>");					
		}
		strBufReturn.append("</tr></table>");
		return strBufReturn.toString();
	}
%>