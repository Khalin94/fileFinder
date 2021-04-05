<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.MyPageReqInfoListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
</head>
<%@ include file="/common/CheckSession.jsp" %>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�Ϲ� �䱸��� �Ķ� ����.*/
  MyPageReqInfoListForm objParams =new MyPageReqInfoListForm();

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
 RequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 CommMakeBoxDelegate  objSche=null; /**����ȸ ���� */
 ResultSetHelper objRs=null;				/**�䱸 ��� */
 ResultSetHelper objScheRs=null;			/** ������ ����ȸ */
 try{
   /** ����ȸ ���� */
   objSche=new CommMakeBoxDelegate();
   try{
    objScheRs=new ResultSetHelper(objSche.getCmtScheduleList(objUserInfo.getCurrentCMTList()));
   }catch(Exception e){
    /*
 	objMsgBean.setMsgType(MessageBean.TYPE_INFO);
  	objMsgBean.setStrCode("DSDATA-0021");
  	objMsgBean.setStrMsg("�Ҽӱ���� �����ϴ� ����ȸ�� �����Ǿ����� �ʽ��ϴ�. �����ڿ��� �����ϼ���");
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
  	*/
   }

   /**�䱸 ���� �븮�� New */
   objReqInfo=new RequestInfoDelegate();
   objRs=new ResultSetHelper(objReqInfo.getRecordListWithCmt(objParams));

 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>



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
      <!-- pgTit -->
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg_my.jpg) no-repeat left top;">
        <h3>���������� <!-- <span class="sub_stl" >- �󼼺���</span> --></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > ���������� > ���� �ڷ� �䱸���� > �䱸���</div>
			<p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �������� ���� -->

        <div class="myP">

          <!-- �˻�â -->

          <!-- /�˻�â  -->
<%
   if(objScheRs!=null && objScheRs.getRecordSize()>0){//����ȸ ������ ���� ��츸 ������.
%>
         <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; ">����ȸ</th>
                <th scope="col">�䱸����</th>
                <th scope="col">���������</th>
                <th scope="col">���⸶����</th>
              </tr>
            </thead>
            <tbody>
			<%
			  int intRecordNumber=objScheRs.getRecordSize();
			  while(objScheRs.next()){
			 %>
              <tr>
                <td><%=intRecordNumber%></td>
                <td style="text-align:left;"><%=objScheRs.getObject("ORGAN_NM")%></td>
                <td><%=StringUtil.substring((String)objScheRs.getObject("REQNM"),30)%></td>
                <td><%=StringUtil.getDate((String)objScheRs.getObject("ACPT_BGN_DT"))%></td>
                <td><%=StringUtil.getDate((String)objScheRs.getObject("ACPT_END_DT"))%></td>
              </tr>
			  	<%
						intRecordNumber --;
					}//endwhile
				%>
            </tbody>
          </table>
<%
  }//endif ����ȸ ���� ���� üũ ��.
%>

          <!-- list -->
          <span class="list01_tl">
		  <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
          <select onChange="formName.submit()" name="ReqBoxTp" class="select_mypage">
            <option selected="selected" value="">��ü</option>
				<%
                   if(!objUserInfo.getOrganGBNCode().equals("004")){//����ȸ�� �ƴϸ� ����.
                  %>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_MEM%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_MEM)%>><%=MenuConstants.getReqBoxGeneral(request)%></OPTION>
                  <%
                   }//endif ����ȸ �ƴ� ����.
                   %>
                  <%
                   if(objUserInfo.getOrganGBNCode().equals("003") || objUserInfo.getOrganGBNCode().equals("004") || objUserInfo.isRequester()==false){// �ǿ���,����ȸ �������� ����.
                  %>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_CMT%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_CMT)%>><%=MenuConstants.REQUEST_BOX_COMM%></OPTION>
                  	<OPTION value="<%=CodeConstants.REQ_BOX_TP_PRE%>" <%=StringUtil.getSelectedStr(objParams.getParamValue("ReqBoxTp"),CodeConstants.REQ_BOX_TP_PRE)%>><%=MenuConstants.REQUEST_BOX_PRE%></OPTION>
                  <%
                   }//endif �ǿ���, ����ȸ�� ����.
                  %>
          </select>�䱸 ���

<!--   ���� ������ ���� �Ǽ� �� ������ ����
		  <span class="list_total">&bull;&nbsp;��ü�ڷ�� : 20�� (1/2 page)</span></span>
-->

          <span class="list_total"></span></span>
          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
            <thead>
              <tr>
                <th scope="col">NO</th>
                <th scope="col" style="width:300px; ">�䱸����</th>
                <th scope="col">
				<%
					if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase((String)objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase((String)objUserInfo.getOrganGBNCode())) {
						out.println("�䱸���");
					} else {
						out.println("����ȸ");
					}
				%>
				</th>
                <th scope="col"><%=(objParams.isRequester())? "������":"�䱸���"%></th>
                <th scope="col">�亯</th>
                <th scope="col"><%=(objParams.isRequester())? "�����亯��":"�����䱸��"%><img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
              </tr>
            </thead>
            <tbody>
	<%
	   if(objRs.getRecordSize()>0){//�䱸����� �ִ� ���.
	%>
				<%
				  int intRecordNumber=objRs.getRecordSize();
				  while(objRs.next()){
				 %>
              <tr>
                <td><%=intRecordNumber%></td>
                <td style="text-align:left;"><a href="<%=RequestInfoDelegate.getGotoLink(objParams.isRequester(),objRs.getObject("REQ_BOX_ID"),objRs.getObject("REQ_BOX_TP"),objRs.getObject("REQ_ID"),objRs.getObject("AUDIT_YEAR"),objRs.getObject("CMT_ORGAN_ID"),objRs.getObject("REQ_ORGAN_ID"))%>">
				<%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),25)%>
				</a></td>
                <td><%=objRs.getObject("CMT_ORGAN_NM")%></td>
                <td><%=(objParams.isRequester())? objRs.getObject("SUBMT_ORGAN_NM"): objRs.getObject("REQ_ORGAN_NM")%></td>
                <td><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
                <td><%=StringUtil.getDate((String)((objParams.isRequester())? objRs.getObject("LAST_ANS_DT"):objRs.getObject("LAST_REQ_DT")))%></td>
              </tr>
			  			<%
							    intRecordNumber --;
							}//endwhile
						%>
						<%
							}else{//�䱸��� ������..
						%>
						<tr>
                <td>��ϵ� �䱸������ �����ϴ�.</td>
              </tr>
						<%
						   }//endif �䱸��� ���� üũ ��.
						%>
			 </tbody>

          </table>
          <!-- /list -->
          <!-- /�������� ���� -->
        </div>
        <!-- /contents -->
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>