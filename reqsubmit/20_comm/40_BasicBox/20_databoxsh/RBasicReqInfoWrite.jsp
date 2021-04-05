<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
/******************************************************************************
* Name		  : RBasicReqInfoWrite.jsp
* Summary	  : �䱸 ��� ������ ����.
* Description : �䱸�����Է��� ūȭ�鿡�� �Է� �����ϰ� �ؾ��ϰ�,
*				�亯��� ������ ÷���Ҽ� �ִ� ����� �����ؾ���.
*
*
******************************************************************************/
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

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreReqBoxVListForm objParams =new RPreReqBoxVListForm();
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
 PreRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new PreRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */
   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
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
    /** �䱸�� ���� */
    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
  }/**���� endif*/
 }catch(AppException objAppEx){
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
<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/

%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">

  /** �������� üũ */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("�䱸������  �Է��ϼ���!!");
		formName.elements['ReqCont'].focus();
		return false;
	}

	if(formName.elements['ReqDtlCont'].value.length><%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>){
		alert("�䱸 ������ <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}


	/* �䱸�ߺ�üũ */
	checkDupReqInfo(formName2);

  }//endfunc


  /** �䱸�� ����  */
  function gotoBoxView(){
  	formName.action="./RBasicReqBoxVList.jsp?ReqBoxID=<%=objParams.getParamValue("ReqBoxID")%>&CmtOrganID=<%=objParams.getParamValue("CmtOrganID")%>";
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
          <form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">

         </form>
          <form name="formName" method="post" encType="multipart/form-data" action="./RBasicReqInfoWriteProc.jsp"><!--�䱸 �ű����� ���� -->
            <!--�䱸���� ������ ��ȣ(����¡����ؼ� �켱 1��������) -->
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
             <input type="hidden" name="CmtOrganID">
             <input type="hidden" name="ReqBoxID">
      <!-- pgTit -->

      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=MenuConstants.REQ_BOX_WRITE%><span class="sub_stl" >-<%=MenuConstants.REQ_INFO_WRITE%></span></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" />  <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQUEST_BOX_PRE%> > <%=MenuConstants.REQ_BOX_PRE%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.--><!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->
		<span class="list02_tl">�䱸 ���� </span>
        <table border="0" cellspacing="0" cellpadding="0" class="list02">
            <tbody>
                <tr>
                    <th height="25">&bull;&nbsp;����ȸ </th>
                    <td height="25" colspan="3">
					<%=objRsSH.getObject("CMT_ORGAN_NM")%>
					</td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;�䱸�Ը�</th>
                    <td height="25" colspan="3"><%=objRsSH.getObject("REQ_BOX_NM")%></td>
                </tr>
                <tr>
                    <th height="25" width="149">&bull;&nbsp;��������</th>
                    <td height="25" width="191">
					<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
					</td>
                    <th height="25" width="149">&bull;&nbsp;������</th>
                    <td height="25" width="191">
					<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;�䱸����</th>
                    <td height="25" colspan="3">
						<input maxlength="100" size="85" name="ReqCont" />
					</td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;�䱸����</th>
                    <td colspan="3">
						<textarea
						onKeyDown="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onKeyUp="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onFocus="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						onClick="javascript:updateChar2(document.formName, 'ReqDtlCont', '660')"
						rows="3" cols="70" name="ReqDtlCont" style="height:100px;" wrap="hard" ></textarea>
                        <br />                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class=" list_none">
                            <tr>
                                <td width="6%"><strong>
                                    <div id="textlimit" style="float:let;height:15px;width:30px;"></div>
                                    </strong></td>
                                <td width="94%" height="25">
									<span class="fonts" >bytes (660 bytes ������ �Էµ˴ϴ�) </span>
			<!--  ���� �ý��� ���� javascript �κ��� ��� ���� �߻�.  -->
								</td>
                                </tr>
                        </table></td>
                </tr>
                <tr>
                    <th height="25">&bull;&nbsp;�������</th>
                    <td height="25" colspan="3">
					<select name="OpenCL" class="selectBox5"  style="width:auto;" >
				<%
					List objOpenClassList=CodeConstants.getOpenClassList();
					String strOpenClass=CodeConstants.OPN_CL_OPEN;//������Ģ.
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
                    <th height="25">&bull;&nbsp;����������</th>
                    <td height="25" colspan="3">
						<input size="55" type="file" name="AnsEstyleFilePath"  style="width:90%;"/>
					</td>
                </tr>
                </tbody>
        </table>
        <!-- /list -->








        <!-- ����Ʈ ��ư-->
        <div id="btn_all"  class="t_right">
				<span class="list_bt"><a href="#" onClick="checkFormData()" >����</a></span>
				<span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
				<span class="list_bt"><a href="#" onClick="gotoBoxView()">�䱸�Ժ���</a></span>
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