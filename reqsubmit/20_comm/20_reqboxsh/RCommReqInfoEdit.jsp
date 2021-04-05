<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
 CommRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
 ResultSetSingleHelper objInfoRsSH=null;	/**�䱸 ���� �󼼺��� */
 ResultSetSingleHelper objRsSH=null;		/**����ȸ �����û ���� */

 String strReqBoxID = objParams.getParamValue("ReqBoxID");
 String strReqID = objParams.getParamValue("CommReqID");
 String strIngStt = (String)request.getParameter("IngStt");
 String strReqBoxStt = (String)request.getParameter("ReqBoxStt");
 String strCmtOrganID = (String)request.getParameter("CmtOrganID");

 try{
   /**�䱸 ���� �븮�� New */
    objReqInfo=new CommRequestInfoDelegate();
   /**�䱸���� �̿� ���� üũ */



    objInfoRsSH=new ResultSetSingleHelper(objReqInfo.getRecord(strReqID));
	String strRefReqID = (String)objInfoRsSH.getObject("REF_REQ_ID");
    objRsSH=new ResultSetSingleHelper(objReqInfo.getCmtSubmt(strReqID,strRefReqID));
  /**���� endif*/
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
	String strRefReqID = (String)objInfoRsSH.getObject("REF_REQ_ID");
  	String strCmtSubmt = (String)objRsSH.getObject("CMT_SUBMT_REQ_ID");
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script src="/js/reqsubmit/common.js"></script>
<script language="JavaScript">

  /** �������� üũ */
  function checkFormData(){
	if(formName.ReqCont.value==""){
		alert("�䱸������ �Է��ϼ���!!");
		formName.elements['ReqCont'].focus();
		return false;
	}
	if (getByteLength(formName.ReqDtlCont.value) > '<%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>') {
		alert("�䱸������ �ѱ�, ������ ���� <%=nads.lib.reqsubmit.EnvConstants.MAX_REQ_DTL_CONT_SIZE%>�� �̳��� �Է��� �ּ���. ��, �ѱ��� 2�ڷ� ó���˴ϴ�.");
		formName.ReqDtlCont.focus();
		return false;
	}
	<%if(!"".equalsIgnoreCase(strCmtSubmt)){%>
	if (formName.elements['Rsn'].value == "") {
		formName.elements['Rsn'].value = "���� ���� ����";
		//return;
	}
	<% } %>
	formName.action="./RCommReqInfoEditProc.jsp";
	formName.target="";
	formName.submit();
  }//endfunc

  //����/���� �뺸�� �����ϱ�
  function gotoInform(){
	//var path = 'RCommReqInform.jsp?ReqBoxID=<%=strReqBoxID%>&ReqID=<%=strReqID%>&RefReqID=<%=objInfoRsSH.getObject("REF_REQ_ID")%>&UdFlag=Update';
   	//var add = window.open(path,'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,width=450,height=300');
	f = document.formName;
  	f.target = "popwin";
  	NewWindow('RCommReqInform.jsp?ReqBoxID=<%=strReqBoxID%>&ReqID=<%=strReqID%>&RefReqID=<%=objInfoRsSH.getObject("REF_REQ_ID")%>&UdFlag=Update', 'popwin', '450', '330');
  }

  //�䱸����� ����
  function gotoViewReq(){
  	form=document.formName;
	<% if("002".equalsIgnoreCase(strReqBoxStt)) { %>
		form.action="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccReqInfo.jsp?CmtOrganID=<%= strCmtOrganID %>";
	<% } else if("011".equalsIgnoreCase(strReqBoxStt)) { %>
		form.action="/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccReqConfirmInfo.jsp?CmtOrganID=<%= strCmtOrganID %>";
  	<% } else { %>
	  	form.action="./RCommReqInfo.jsp";
  	<% } %>
	formName.target="";
  	form.submit();
  }
</script>
<head>
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
        <form name="formName" method="post" encType="multipart/form-data" action=""><!--�䱸 �������� ���� -->
		<input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
		<input type="hidden" name="CommReqBoxSortField" value="<%=objParams.getParamValue("CommReqBoxSortField")%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=objParams.getParamValue("CommReqBoxSortMtd")%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=objParams.getParamValue("CommReqBoxPage")%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=objParams.getParamValue("CommReqBoxQryField")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"><!--�䱸�� ��ȸ�ʵ� -->
		<input type="hidden" name="CommReqInfoSortField" value="<%=objParams.getParamValue("CommReqInfoSortField")%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=objParams.getParamValue("CommReqInfoSortMtd")%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="1"><!--�䱸���� ������ ��ȣ(����¡����ؼ� �켱 1��������) -->
		<input type="hidden" name="ReqInfoID" value="<%=strReqID%>">
		<input type="hidden" name="CommReqID" value="<%=strReqID%>">
		<input type="hidden" name="RefReqID" value="<%=objInfoRsSH.getObject("REF_REQ_ID")%>">
		<%
			String strURL = (String)request.getParameter("ReturnURL");
			if("null".equalsIgnoreCase(strURL)) {
				if("002".equalsIgnoreCase(strReqBoxStt)) {
					strURL = "/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccReqInfo.jsp?CmtOrganID="+strCmtOrganID;
				} else if("002".equalsIgnoreCase(strReqBoxStt)) {
					strURL = "/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccReqConfirmInfo.jsp?CmtOrganID="+strCmtOrganID;
				} else {
					strURL = "./RCommReqInfo.jsp";
				}
			}
		%>
        <input type="hidden" name="ReturnURL" value="<%=strURL%>">
        <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>
        <%
            if("002".equalsIgnoreCase(strReqBoxStt)) out.println(MenuConstants.COMM_MNG_CHECK);
            else if("011".equalsIgnoreCase(strReqBoxStt)) out.println(MenuConstants.COMM_MNG_CONFIRM_END);
            else out.println(MenuConstants.COMM_REQ_BOX_MAKE);
        %>
        <span class="sub_stl" >-<%=MenuConstants.REQ_INFO_EDIT%></span>
        </h3>

        <div class="navi">
            <img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> >
            <B>
            <%
                if("002".equalsIgnoreCase(strReqBoxStt)) out.println(MenuConstants.COMM_MNG_CHECK);
                else if("011".equalsIgnoreCase(strReqBoxStt)) out.println(MenuConstants.COMM_MNG_CONFIRM_END);
                else out.println(MenuConstants.COMM_REQ_BOX_MAKE);
            %>
            </B>
        </div>
        <p><!--����--></p>
        </div>
        <!-- /pgTit -->
        <!-- contents -->
       <div id="contents">
        <span class="list02_tl">�䱸 ���� </span>
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
                <table cellspacing="0" cellpadding="0" class="list02">
                    <tr>
                      <th height="25">&bull;&nbsp;����ȸ </th>
                      <td height="25" colspan="3">
                      <%=objInfoRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸�Ը�</th>
                      <td height="25" colspan="3">
                      <%=objInfoRsSH.getObject("REQ_BOX_NM")%>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;��������</th>
                      <td height="25">
                      <%=objCdinfo.getRelatedDuty((String)objInfoRsSH.getObject("RLTD_DUTY"))%>
                      </td>
                      <th height="25">&bull;&nbsp;������ </th>
					  <td height="25">
						<%=(String)objInfoRsSH.getObject("SUBMT_ORGAN_NM")%>
					  </td>
                    </tr>
					<%
        	       	if(!"".equalsIgnoreCase(strCmtSubmt)){
               		%>
					<tr>
						<th height="25">&bull;&nbsp;�뺸���</th>
						<td height="25" colspan="3"><input type="checkbox" name="NtcMtd" value="002">
						���� ���� ����</td>
					</tr>
					<tr>
						<th height="25">&bull;&nbsp;����(����)����</th>
						<td height="25" colspan="3"><textarea rows="3" cols="10" name="Rsn" class="textfield" style="WIDTH: 90% ; height: 30"></textarea></td>
					</tr>
					<% } %>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸����</th>
                      <td height="25" colspan="3">
                      <input type="text" size="90" maxlength="100" name="ReqCont" value="<%=(String)objInfoRsSH.getObject("REQ_CONT")%>" class="textfield">
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�䱸����</th>
                      <td height="25" colspan="3">
                      	<textarea rows="3" cols="70" name="ReqDtlCont" class="textfield" style="WIDTH: 90% ; height: 120"><%=(String)objInfoRsSH.getObject("REQ_DTL_CONT")%></textarea>
                      </td>
                    </tr>
                    <tr>
                      <th height="25">&bull;&nbsp;�������</th>
                      <td height="25" colspan="3">
                      <select name="OpenCL"  class="select_reqsubmit">
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
                      <th height="25">&bull;&nbsp;����������</th>
                      <td height="25" colspan="3">
                      	<input type="file" name="AnsEstyleFilePath" size="70"  class="textfield">
                      	<%
                      	if(StringUtil.isAssigned((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"))){
                      		out.println("<input type=\"checkbox\" name=\"DeleteFile\" value=\"OK\">���ϻ���:");
                      		out.println(StringUtil.makeAttachedFileLink((String)objInfoRsSH.getObject("ANS_ESTYLE_FILE_PATH"),(String)objInfoRsSH.getObject("REQ_ID")));
                      		out.println("<br>�������������� �����Ͻø� ������ ������ �����Ͻ� ���Ϸ� ��ġ�մϴ�");
                      	}//endif
                      	%>
					  </td>
                   </tr>
                </table>
        <div id="btn_all"class="t_right">
            <span class="list_bt"><a href="#" onClick="javascript:checkFormData();">����</a></span>
            <span class="list_bt"><a href="#" onClick="formName.reset()">���</a></span>
            <span class="list_bt"><a href="#" OnClick="javascript:gotoViewReq()">�䱸����</a></span>
        </div>
        </form>
      </div>
    </div>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
