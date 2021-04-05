<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

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
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>
<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/

	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();
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
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
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
		} else {
			/** �䱸�� ���� */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
		}/**���� endif*/
	} catch(AppException objAppEx) {
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

<html>
<head>
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_WRITE%> </title>
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
	if(formName.elements['ReqDtlCont'].value.length>2000){
		alert("�䱸 ������ 1000���� �̳��� �ۼ����ּ���!!");
		formName.elements['ReqDtlCont'].focus();
		return false;
	}

	/* �䱸�ߺ�üũ */
	checkDupReqInfo(formName2);
  }//endfunc

  /** �䱸������ ���� */
  function gotoList(){
    var str1 = document.formName.ReqCont.value;
    var str2 = document.formName.ReqDtlCont.value;

    if (str1.length != 0 && str2.length != 0) {
    	if (confirm("�Է��Ͻ� �䱸 ������ �����Ͻðڽ��ϱ�?\n������� �̵��Ͻ÷��� ��Ҹ� ������ �ּ���")) {
    		document.formName.action="./RMakeReqInfoWriteProc.jsp";
    	} else {
    		document.formName.action="./RMakeReqBoxVList.jsp";
    	}
    } else {
    	document.formName.action="./RMakeReqBoxVList.jsp";
    }
    document.formName.submit();
  }


	/**
	 * 2005-09-13 kogaeng ADD
	 */
	function updateChar2() {
		var length_limit = 2000;
		var aaaElem = document.formName.ReqDtlCont;
		var aaaLength = calcLength(aaaElem.value);
		document.getElementById("textlimit").innerHTML = aaaLength;
		if (aaaLength > length_limit) {
			alert("�ִ� " + length_limit + "byte�̹Ƿ� �ʰ��� ���ڼ��� �ڵ����� �����˴ϴ�.");
			aaaElem.value = aaaElem.value.replace(/\r\n$/, "");
			aaaElem.value = assertLength(aaaElem.value, length_limit);
		}
	}

	function calcLength(message) {
		var nbytes = 0;

		for (i=0; i<message.length; i++) {
			var ch = message.charAt(i);
			if(escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}
		return nbytes;
	}

	function assertLength(message, maximum) {
		var inc = 0;
		var nbytes = 0;
		var msg = "";
		var msglen = message.length;

		for (i=0; i<msglen; i++) {
			var ch = message.charAt(i);
			if (escape(ch).length > 4) {
				inc = 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					inc = 1;
				}
			} else if (ch == '<' || ch == '>') {
				inc = 4;
			} else {
				inc = 1;
			}
			if ((nbytes + inc) > maximum) {
				break;
			}
			nbytes += inc;
			msg += ch;
		}
		document.getElementById("textlimit").innerHTML = nbytes;
		return msg;
	}




</script>
<head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<%@ include file="../../../common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="../../../common/MenuLeftReqsubmit.jsp" %></td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
<td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top">
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="DEEFCC">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� �� ------->
        <tr valign="top">
          <td width="30" align="left"><img src="/image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left">
          <table width="759" border="0" cellspacing="0" cellpadding="0">
          <%/*�䱸 �ߺ�üũ�� ������*/%>
<form name="formName2" method="post" action="">
             <input type="hidden" name="ReqBoxID">
             <input type="hidden" name="ReqCont">
             <input type="hidden" name="ReqDtlCont">
</form>
<form name="formName" method="post" encType="multipart/form-data" action="./RMakeReqInfoWriteProc.jsp"><!--�䱸 �ű����� ���� -->
            <!--�䱸���� ������ ��ȣ(����¡����ؼ� �켱 1��������) -->
            <% objParams.setParamValue("ReqInfoPage","1");%>
            <%=objParams.getHiddenFormTags()%>
              <tr>
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr>
			  <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
				<h3><%=MenuConstants.REQ_BOX_MAKE%><span class="sub_stl" >- <%=MenuConstants.REQ_INFO_WRITE%></span> </h3>
				<div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B> </div>
				<p><!--����--></p>
			  </div>
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <span class="list02_tl">�䱸��� </span>
              <tr>
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
                <table border="0" cellspacing="0" cellpadding="0" class="list02">
					<tr>
						<th height="25">&bull; �䱸�Ը�</th>
						<td height="25" colspan="3"><strong><%=objRsSH.getObject("REQ_BOX_NM")%></strong></td>
					</tr>
					<%
						// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
					%>
					<tr>
						<th height="25">&bull; �Ұ� ����ȸ </th>
						<td height="25" colspan="3"><%=objRsSH.getObject("CMT_ORGAN_NM")%></td>
					</tr>
                    <% } %>
					<tr>
						<th height="25" width="140">&bull; ��������</th>
						<td height="25" width="200"><%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> </td>
						<th height="25" width="140">&bull; ������ </th>
						<td height="25" width="200"><%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%> </td>
					</tr>
					<tr>
						<th height="25">&bull; �䱸����</th>
						<td height="25" colspan="3">
							<input type="text" name="ReqCont" size="70" maxlength="1000" class="textfield">
							<br />
							<br />
							* �ѱ��� 100��, ������ 200��   ������ �Է� �����մϴ�. </td>
					</tr>
					<tr>
						<th height="25">&bull; �䱸����</th>
						<td height="25" colspan="3">
							<textarea onKeyDown="javascript:updateChar2()" onFocus="javascript:updateChar2()" onKeyUp="javascript:updateChar2()" onClick="javascript:updateChar2()" rows="5" cols="70" name="ReqDtlCont"></textarea>
							<br />
							<table border="0">
								<tbody>
									<tr>
										<td width="40" align="right"><strong>
											<div id="textlimit"></div>
										</strong></td>
										<td width="560">bytes (2000 bytes ������ �Էµ˴ϴ�) </td>
									</tr>
								</tbody>
							</table>
							<br />
							* �ѱ��� 1000��, ������ 2000�ڿ� �ش��մϴ�. </td>
					</tr>
					<tr>
						<th height="25">&bull; �������</th>
						<td height="25" colspan="3">
							<select name="OpenCL"  class="select">
							<%
								List objOpenClassList=CodeConstants.getOpenClassList();
								String strOpenClass=CodeConstants.OPN_CL_CLOSE;//�������Ģ.
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
						<th height="25">&bull; ����������</th>
						<td height="25" colspan="3"><input type="file" name="AnsEstyleFilePath" size="70"  class="textfield"></td>
					</tr>
                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
                </td>
              </tr>
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>&nbsp;</td>
               	<!-- �����̽���ĭ -->
              </tr>
              <tr>
               	<td>
               	<!----------------------- ���� ��ҵ� Form���� ��ư ���� ------------------------->
               	 <table>
               	   <tr>
               		 <td>
               			<img src="/image/button/bt_save.gif"  height="20" border="0" onClick="checkFormData()" style="cursor:hand">
               			<img src="/image/button/bt_cancel.gif"  height="20" border="0" onClick="formName.reset()" style="cursor:hand">
               			<img src="/image/button/bt_viewReqBox.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
               		 </td>
               	   </tr>
               	</table>
               	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->
                </td>
              </tr>
          </form>
          </table>
          </td>
        </tr>
        <tr>
        	<td height="35">&nbsp;</td>
        </tr>
    </table>
    <!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->
    </td>
  </tr>
</table>
<%@ include file="../../../../common/Bottom.jsp" %>
</body>
</html>
