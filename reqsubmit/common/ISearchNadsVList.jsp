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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.MemAnswerInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
	/*
	 ���ǿ� ���� �����ߴٴ� �����Ͽ� ���.
		select usr.user_id,usr.user_nm,organ.organ_id,organ.organ_nm,ORGAN_KIND,REQ_SUBMT_FLAG
		from tbdm_user_Info usr,tbdm_brg_dept dept, tbdm_organ organ
		where usr.user_id=dept.user_id
		and dept.organ_id=organ.organ_id
		and usr.user_id='tester1'
		and org_posi_gbn=1;

	HttpSession objSession=request.getSession();
	//�䱸��
	objSession.setAttribute("USER_ID","tester1");
	objSession.setAttribute("ORGAN_ID","NI00000001");
	objSession.setAttribute("ORGAN_KIND","003");
	objSession.setAttribute("REQ_SUBMT_FLAG","001");
	objSession.setAttribute("IS_REQUESTER",Boolean.toString(true));
	//������

	objSession.setAttribute("USER_ID","tester2");
	objSession.setAttribute("ORGAN_ID","A000000047");
	objSession.setAttribute("ORGAN_KIND","006");
	objSession.setAttribute("REQ_SUBMT_FLAG","002");
	objSession.setAttribute("IS_REQUESTER",Boolean.toString(false));
	*/

%>
<%
 /** �䱸 ������ ����..*/
 boolean blnIsRequester=true;//�䱸��
 if(request.getSession().getAttribute("IS_REQUESTER").equals("false")){
 	blnIsRequester=false;
 }
 //�α����̿��� �������.
 String strOrganID=(String)request.getSession().getAttribute("ORGAN_ID");
%>

<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�䱸���� �󼼺��� �Ķ���� üũ.*/
  String strReqInfoIDParam=(String)request.getParameter("ReqInfoID");
  boolean blnParamCheck=false;
  if(StringUtil.isAssigned(strReqInfoIDParam)){
  	blnParamCheck=true;
  }
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg("�䱸ID���� ����");
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
 RequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
 ResultSetHelper objRs=null;				/** �亯���� ��� ���*/
 try{
   /**�䱸 ���� �븮�� New */
   objReqInfo=new RequestInfoDelegate();

   /**�䱸�� �̿� ���� üũ */
   System.out.println("111");
   boolean blnHashAuth=objReqInfo.checkReqInfoAuth(strReqInfoIDParam,strOrganID).booleanValue();
   System.out.println("222");

   objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord(strReqInfoIDParam));
   System.out.println("333");

   if(!objInfoRsSH.next()){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSDATA-0030");
  	  objMsgBean.setStrMsg("��û�Ͻ� �䱸������ DB�� �������� �ʽ��ϴ�.");
	  System.out.println("HERE NOT FOUND!");
	  	%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
	  	<%
      return;
   }
   if(objInfoRsSH.getObject("OPEN_CL").equals(CodeConstants.OPN_CL_OPEN)){
   	 if(blnHashAuth==false && blnIsRequester){
   	 	blnHashAuth=true;
   	 }
   }
   if(!blnHashAuth){
      objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  objMsgBean.setStrCode("DSAUTH-0001");
  	  objMsgBean.setStrMsg("�ش� �䱸������ �� ������ �����ϴ�.");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
      return;
   }


   /** �亯 ��� ��� */
   objRs=new ResultSetHelper(new MemAnswerInfoDelegate().getRecordList(strReqInfoIDParam,((blnIsRequester)? "Y":"N")));
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
  	%>

  	<%
  	return;
 }
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<body>
<div class="popup">
    <p>�˻�����󼼺���</p>

    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%" style="padding:10px;">
				<span class="fonts">�˻��� ����� ���õ� �䱸������ �������� Ȯ���մϴ�. </span>
				<br />
				<br />
				<span class="list02_tl">�䱸����</span>
				<table border="0" cellspacing="0" cellpadding="0" class="list02">
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;����ȸ </th>
						<td height="25" colspan="3"><%=objInfoRsSH.getObject("CMT_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;�䱸�Ը� </th>
						<td height="25" colspan="3"><%=objInfoRsSH.getObject("REQ_BOX_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;������ </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
						<th height="25">&bull;&nbsp;&nbsp;�䱸��� </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("REQ_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;�䱸���� </th>
						<td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_CONT"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;�䱸�󼼳��� </th>
						<td height="25" colspan="3"><%=StringUtil.getDescString((String)objInfoRsSH.getObject("REQ_DTL_CONT"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;������� </th>
						<td height="25"><%=CodeConstants.getOpenClass((String)objInfoRsSH.getObject("OPEN_CL"))%> </td>
						<th height="25">&bull;&nbsp;&nbsp;���������� </th>
						<td height="25"><%=StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID"))%></td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;&nbsp;����� </th>
						<td height="25"><%=(String)objInfoRsSH.getObject("REGR_NM")%> </td>
						<th height="25">&bull;&nbsp;&nbsp;������� </th>
						<td height="25"><%=StringUtil.getDate((String)objInfoRsSH.getObject("REG_DT"))%> </td>
					</tr>
				</table>

				<!-- /list --> <br />
				<br />

				<!-- list -->
				<span class="list01_tl">�亯 ��� <!--<span class="list_total">&bull;&nbsp;��ü�ڷ�� : 20�� (1/2 page)</span>--></span>
				<table border="0" cellspacing="0" cellpadding="0" class="list01">
					<thead>
						<tr>

							<th scope="col">NO</th>
							<th style="width:350px; " scope="col">�����ǰ�</th>
							<th scope="col">�ۼ���</th>
							<th scope="col">����</th>
							<th scope="col">�亯</th>

							<th scope="col">�亯��</th>

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
							<td style="text-align:left;"><a href="#"><%=StringUtil.substring((String)objRs.getObject("ANS_OPIN"),35)%></a></td>
							<td><%=(String)objRs.getObject("ANSWER_NM")%></td>

							<td><%=CodeConstants.getOpenClass(((String)objRs.getObject("OPEN_CL")))%></td>
							<td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml(strAnsInfoID,(String)objRs.getObject("ANS_MTD"))%></td>
							<td><%=StringUtil.getDate((String)objRs.getObject("ANS_DT"))%></td>

						</tr>
						<%
							    intRecordNumber ++;
							}//endwhile
						%>
					</tbody>
				</table>

			<!-- /list -->

			</td>
		</tr>
	</table>
    <p style= "height:2px;padding:0;"></p>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all"  class="t_right"><span class="list_bt"><a href="#" onClick="self.close()">â�ݱ�</a></span>&nbsp;&nbsp; </div>

    <!-- /����Ʈ ��ư-->
</div>
</body>
</html>