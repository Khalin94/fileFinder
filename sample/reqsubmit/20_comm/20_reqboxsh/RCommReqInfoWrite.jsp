<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
/******************************************************************************
* Name		  : RMakeReqInfoWrite.jsp
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
<%@ include file="../../common/RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();
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
 CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
 String strIngStt = (String)request.getParameter("IngStt");
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new CommRequestBoxDelegate();
   /**�䱸�� �̿� ���� üũ */

   boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">

  /** �������� üũ */
  function checkFormData(){
	if(formName.elements['ReqCont'].value==""){
		alert("�䱸������  �Է��ϼ���!!");
		formName.elements['ReqCont'].focus();
		return false;
	}
	if (getByteLength(formName.elements['ReqDtlCont'].value) > <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>) {
		alert("�䱸������ �ѱ�, ������ ���� <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}
	/* �䱸�ߺ�üũ */
	checkDupReqInfo(formName2);

  }//endfunc

  /**�䱸�� �󼼺��� �������� ����.*/
  function gotoView(){
	<% if("002".equalsIgnoreCase(strIngStt)){ %>
	formName.action="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
  	<% } else { %>
	formName.action="./RCommReqBoxVList.jsp";
  	<% } %>
  	var str1 = document.formName.ReqCont.value;
  	var str2 = document.formName.ReqDtlCont.value;

  	if (str1.length != 0 && str2.length != 0) {
  		if (confirm("�Է��Ͻ� �䱸�� ����Ͻðڽ��ϱ�? ��Ҹ� �����ø� ������� �ʽ��ϴ�.")) {
			formName.action = "./RCommReqInfoWriteProc.jsp";
  			checkFormData();
			return;
  		}
	}
	formName.submit();
  }
</script>
</head>
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
          <%/*�䱸 �ߺ�üũ�� ������*/%>
          <form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">
          </form>
          <form name="formName" method="post" encType="multipart/form-data" action="./RCommReqInfoWriteProc.jsp"><!--�䱸 �ű����� ���� -->
			<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
			<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("ReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
			<input type="hidden" name="CommReqInfoQryField" value="<%=objParams.getParamValue("CommReqInfoQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
			<input type="hidden" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>"><!--�䱸�� ��ȸ�ʵ� -->
			<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
			<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
			<input type="hidden" name="CommReqInfoPage" value="1"><!--�䱸���� ������ ��ȣ(����¡����ؼ� �켱 1��������) -->
			<%
			String strURL = (String)request.getParameter("ReturnURL");
			if(strURL == null){
				if("002".equalsIgnoreCase(strIngStt)){
					strURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp";
				} else {
					strURL = "./RCommReqBoxVList.jsp";
				}
			}
			%>
			<input type="hidden" name="ReturnURL" value="<%=strURL%>">
        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
        <% if("002".equalsIgnoreCase(strIngStt)){ %>
        <B><%=MenuConstants.COMM_REQ_BOX_MAKE_END%></B>
        <% } else { %>
        <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B>
        <% } %>
        <span class="sub_stl" >-<%=MenuConstants.REQ_INFO_WRITE%></span>
        </h3>

        <div class="navi">
            <img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> >
            <% if("002".equalsIgnoreCase(strIngStt)){ %>
            <B><%=MenuConstants.COMM_REQ_BOX_MAKE_END%></B>
            <% } else { %>
            <B><%=MenuConstants.COMM_REQ_BOX_MAKE%></B>
            <% } %>
        </div>
        <p><!--����--></p>
        </div>
        <!-- /pgTit -->
        <!-- contents -->
       <div id="contents">
        <span class="list02_tl">�䱸 ���� </span>
                <table cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;����ȸ </th>
                      <td height="25" colspan="3">
                      <%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸�Ը�</th>
                      <td height="25" colspan="3">
                      <%=objRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;��������</th>
                      <td height="25">
                      <%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
                      </td>
                      <th height="25">&bull;&nbsp;������ </th>
					  <td height="25">
						<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸����</th>
                      <td height="25" colspan="3">
                      <input type="text" size="90" maxlength="100" name="ReqCont" class="textfield">
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸����</th>
                      <td height="25" colspan="3">
                      	<textarea rows="3" cols="70" name="ReqDtlCont" class="textfield" style="WIDTH: 90% ; height: 120"></textarea>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�������</th>
                      <td height="25" colspan="3">
                      <select name="OpenCL"  class="select_reqsubmit">
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
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
					  </td>
                   </tr>
                </table>

        <div id="btn_all"class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkFormData();">����</a></span>
            <span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
            <span class="list_bt"><a href="#" OnClick="javascript:gotoView()">�䱸�Ժ���</a></span>
        </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
