<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.SMemReqInfoVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<% 
	UserInfoDelegate objUserInfo = null;
	CDInfoDelegate objCdinfo = null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate selfDelegate = null;
	AnsInfoDelegate ansDelegate = null;
	
	SMemReqInfoVListForm objParams = new SMemReqInfoVListForm();  
	
	boolean blnParamCheck=false;
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck==false) {
  		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
  		objMsgBean.setStrMsg(objParams.getStrErrors());
  		out.println("ParamError:" + objParams.getStrErrors());
	  	return;
  	}//endif
  	
	// �Ѿ�� �Ķ���͸� �����ؼ� �ʿ��� ?? ������ ����
	// �䱸�� ����
	String strReqBoxID = objParams.getParamValue("ReqBoxID");
	String strReqID = objParams.getParamValue("ReqID");
	
	String strReqBoxSortField = objParams.getParamValue("ReqBoxSortField");
	String strReqBoxSortMtd = objParams.getParamValue("ReqBoxSortMtd");
	String strReqBoxPagNum = objParams.getParamValue("ReqBoxPage");
	String strReqBoxQryField = objParams.getParamValue("ReqBoxQryField");
	String strReqBoxQryTerm = objParams.getParamValue("ReqBoxQryTerm");
	
	// �䱸 ��� ���� 
	String strReqInfoSortField = objParams.getParamValue("ReqInfoSortField");
	String strReqInfoSortMtd = objParams.getParamValue("ReqInfoSortMtd");
	String strReqInfoQryField = objParams.getParamValue("ReqInfoQryField");
	String strReqInfoQryTerm = objParams.getParamValue("ReqInfoQryTerm");
	String strReqInfoPagNum = objParams.getParamValue("ReqInfoPage");

	String strReqStt = null; // �䱸 ���� ���� ����

	// �亯 ���� �� ����¡ ����
	int intTotalRecordCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	
	try{
	   	reqDelegate = new MemRequestBoxDelegate();
	   	selfDelegate = new SMemReqInfoDelegate();
	   	ansDelegate = new AnsInfoDelegate();

	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();

	   	if(!blnHashAuth) { 
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸���� �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸 ��� ������ SELECT �Ѵ�.
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqID));
	    	// �䱸 ���� ���� ������ ����!
	    	strReqStt = (String)objRsSH.getObject("REQ_STT");
	    	// �亯 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(ansDelegate.getRecordList(objParams));
			intTotalRecordCount = objRs.getTotalRecordCount();
		}
	} catch(AppException e) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(e.getStrErrCode());
  		objMsgBean.setStrMsg(e.getMessage());
  		out.println("<br>Error!!!" + e.getMessage());
	  	return;
 	}
%>

<html>
<head>
<title>��ȸ�ǿ� ������ �ڷ� �䱸 > <%=MenuConstants.REQ_BOX_MAKE_END %></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

<script language="javascript">
	var f;	

	// ���� �Ϸ�
	function sbmtReq() {
		f = document.viewForm;
		f.target = "";
		f.action = "/reqsubmit/common/SReqSubmtDoneProc.jsp";
		if (confirm("���� �䱸�� ���� �亯 ������ �Ϸ��Ͻðڽ��ϱ�?")) f.submit();
	}
	
	// �䱸�� ����
	function goReqBoxView() {
		f = document.viewForm;
		f.action = "SMakeEndBoxVList.jsp";
		f.target = "";
		f.submit();
	}

	// �䱸�� ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeEndBoxList.jsp";
		f.target = "";
		f.submit();
	}

  	// �亯 �󼼺���� ����
  	function gotoDetail(strID){
  		f = document.viewForm;
  		//f.AnsID.value = strID;
		f.target = "popwin";
  		f.action="/reqsubmit/common/SAnsInfoView.jsp?AnsID="+strID;
		NewWindow('/blank.html', 'popwin', '520', '320');
  		f.submit();
  		//var add_sub = window.showModalDialog('SMakeAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'dialogWidth:500px;dialogHeight:300px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  		//window.open('/reqsubmit/common/SAnsInfoView.jsp?returnURL=POPUP&ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>&AnsID='+strID, '', 'width=500,height=400, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}

  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		//f = document.viewForm;
  		//f.ReqID.value = "<%= strReqID %>";
  		//f.AddAnsFlag.value = "Y";
  		//f.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeAnsInfoWrite.jsp";
		//f.target = "";
 		//f.submit();

		f = document.viewForm;
  		f.ReqID.value = "<%= strReqID %>";
		f.AddAnsFlag.value = "Y";
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

  	// ���� �亯 ����
  	function selectDelete() {
  		var f = document.viewForm;
  		if (getCheckCount(f, "AnsID") < 1) {
  			alert("�ϳ� �̻��� üũ�ڽ��� ������ �ּ���");
  			return;
  		}
  		f.action = "SMakeAnsInfoDelProc.jsp";
		f.target = "";
  		if (confirm("�����Ͻ� �亯���� �����Ͻðڽ��ϱ�?\n�ش� �亯���� �����ϸ� ���Ե� ���ϵ鵵 �ϰ� �����˴ϴ�.")) f.submit();
  	}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	</td>
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
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="44%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%= MenuConstants.REQ_BOX_MAKE_END %></span> <strong>- <%= MenuConstants.REQ_INFO_DETAIL_VIEW %></strong>
                      </td>
                      <td width="6%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="50%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > ��ȸ�ǿ� ������ �ڷ� �䱸 > <B><%=MenuConstants.REQ_BOX_MAKE_END %></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���� �Ϸ�� �䱸���� �䱸���� �� ��ϵ� �亯 ��Ͽ� ���� �� ������ ��ȸ�Ͻ� �� �ֽ��ϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				                	 �䱸 ��� ����
				            </td>
				            <td width="359" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	<!--------------- �󼼺��⿡���� �ʿ������.. �ֱ� ���� �׸��� ���� ���� ��������... ------------------->
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
<form name="viewForm" method="post" action="" style="margin:0px">
					<!-- �䱸�� ��� ���� ���� -->
					<input type="hidden" name="ReqBoxID" value="<%= strReqBoxID %>">
					<input type="hidden" name="ReqBoxSortField" value="<%= strReqBoxSortField %>"><!--�䱸�Ը�������ʵ� -->
					<input type="hidden" name="ReqBoxSortMtd" value="<%= strReqBoxSortMtd %>"><!--�䱸�Ը�����Ĺ��-->
					<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>"><!--�䱸�� ������ ��ȣ -->
					<% if(StringUtil.isAssigned(strReqBoxQryTerm)) { %>
					<input type="hidden" name="ReqBoxQryField" value="<%= strReqBoxQryField %>"><!--�䱸�� ��ȸ�ʵ� -->
					<input type="hidden" name="ReqBoxQryTerm" value="<%= strReqBoxQryTerm %>"><!--�䱸�� ��ȸ�ʵ� -->
					<% } //�䱸�� ��ȸ� �ִ� ��츸 ����ؼ� ����� %>
					
					<!-- �䱸 ��� ���� -->
					<input type="hidden" name="ReqID" value="<%= strReqID %>"> <!-- �䱸 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
					<% if(StringUtil.isAssigned(strReqInfoQryTerm)) { %>
					<input type="hidden" name="ReqInfoQryField" value="<%= strReqInfoQryField %>"><!--�䱸���� ��ȸ�ʵ� -->
					<input type="hidden" name="ReqInfoQryTerm" value="<%= strReqInfoQryTerm %>"><!-- �䱸���� ��ȸ�� -->
					<% } %>
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
					<input type="hidden" name="ReqStt" value="<%= strReqStt %>">
					
					<!-- ���� �� ��ȯ�� URL�� �����ϱ� ���� Parameter ���� -->
					<input type="hidden" name="WinType" value="SELF">
					<input type="hidden" name="ReturnURL" value="<%= request.getRequestURI() %>?ReqBoxID=<%= strReqBoxID %>&ReqID=<%= strReqID %>">
					<input type="hidden" name="AddAnsFlag" value="">
										
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td height="2" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸����
                      		</td>
                      		<td width="570" height="25" colspan="3" class="td_lmagin"><B><%= objRsSH.getObject("REQ_CONT") %></B></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸����
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      			<%= StringUtil.getDescString((String)objRsSH.getObject("REQ_DTL_CONT")) %>
                      			<%= nads.dsdm.app.reqsubmit.delegate.requestinfo.RequestInfoDelegate.getAppendRequestInfo((List)objRsSH.getObject("TBDS_REQ_LOG")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" bgcolor="#d0d0d0"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="#ffffff"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="#d0d0d0"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸�Ը�
                      		</td>
                      		<td colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸���
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objRsSH.getObject("REQ_ORGAN_NM") %> (<%= objRsSH.getObject("USER_NM") %>)</td>
                      		<td width="110" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objRsSH.getObject("SUBMT_ORGAN_NM") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �������
                      		</td>
                      		<td class="td_lmagin"><%= CodeConstants.getOpenClass((String)objRsSH.getObject("OPEN_CL")) %></td>
                      		<td class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ÷������
                      		</td>
                      		<td width="242" class="td_lmagin">
                      			<%= StringUtil.makeAttachedFileLink((String)objRsSH.getObject("ANS_ESTYLE_FILE_PATH"), (String)objRsSH.getObject("REQ_ID")) %>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸����
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DT")) %></td>
                      		<td class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ��������
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate2((String)objRsSH.getObject("LAST_ANS_DT")) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr> 
                    		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ������� 
                      		</td>
                      		<td class="td_lmagin"><%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %> 24:00</td>
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> ���� ����
                      		</td>
                      		<td class="td_lmagin"><%= CodeConstants.getRequestStatus(strReqStt) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1"></td>
                      		<td height="1" colspan="3"></td>
                    	</tr>
         	
                    </table>
                    <p>
                    <!-- ���� �Ϸ� -->
                    <% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
	                    <img src="/image/button/bt_reqEnd.gif" border="0" onClick="javascript:sbmtReq()" style="cursor:hand"  alt="�亯�� ��ϵ� �䱸�� ��� �䱸������� �����մϴ�.">
	                <% } %>
					<!-- �䱸 �̷� ��ȸ -->
					<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory('<%= strReqID %>')" style="cursor:hand"  alt="���� �䱸�� ó�������� ���ں��� ��ȸ�մϴ�.">
                    <!-- �䱸�� ���� -->
                    <img src="/image/button/bt_viewReqBox.gif" border="0" onClick="javascript:goReqBoxView()" style="cursor:hand">
                    <!-- �䱸�� ��� -->
                    <img src="/image/reqsubmit/searchlist2.gif" border="0" onClick="javascript:goReqBoxList()" style="cursor:hand">

				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
               </td>
              </tr>
                         
            	<!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
            	<!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
          	
            	<tr>
            		<td class="soti_reqsubmit" height="15"></td>
	           	</tr>
            	<tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="300" class="soti_reqsubmit">
                				<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
				                	 �亯 ���
				            </td>
				            <td width="459" align="right" valign="bottom">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	��ü �ڷ� �� : <%= intTotalRecordCount %> ��
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                	<!------------------------------------------------- �䱸 ��� ���̺� ���� ------------------------------------------------->
                	<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" colspan="7" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
            	          	<td width="64" height="22">
            	          		<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
	            	          		<input type="checkbox" name="" value="" onClick="javascript:revCheck(this.form, 'AnsID')">
	            	          	<% }  else { %>
									NO
								<% } %>
            	          	</td>
	                	    <td width="345">���� �ǰ�</td>
                    	  	<td width="80">�ۼ���</td>
    	                  	<td width="60">��������</td>
        	              	<td width="150">�亯</td>
	                      	<td width="70">�ۼ���</td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="7" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber= 0;
							while(objRs.next()){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
							<td width="64" height="22" align="center">
								<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
									<input type="checkbox" name="AnsID" value="<%= objRs.getObject("ANS_ID") %>">
								<% } else { %>
									<%= intRecordNumber+1 %>
								<% } %>
							</td>
							<td width="345" class="td_lmagin"><a href="javascript:gotoDetail('<%= objRs.getObject("ANS_ID") %>')"><%= objRs.getObject("ANS_OPIN") %></a></td>
							<td width="80" align="center"><%= objRs.getObject("USER_NM") %></td>
							<td width="60" align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td width="150" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD")) %></td>
							<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("ANS_DT")) %></td>
						</tr>
						<tr class="tbl-line"> 
                    	  	<td height="1" colspan="7"></td>
                    	</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	%>
                    	<tr class="tbl-line"> 
                    	  	<td height="1" colspan="7"></td>
                    	</tr>
                    </table>
	               	<!------------------------------------------------- �䱸 ��� ���̺� �� ------------------------------------------------->
                </td>
              </tr>
              
              <!------------------ BUTTON <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="300" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
                      			<% if (!CodeConstants.REQ_STT_SUBMT.equalsIgnoreCase(strReqStt)) { // ����Ϸᰡ �ƴ� ��츸 �����ּ��� %>
                      				<img src="/image/button/bt_registerAddAnswer2.gif" border="0" onClick="javascript:goSbmtReqForm()" style="cursor:hand"  alt="�߰��亯�䱸�� ���� �亯�� �ۼ��մϴ�.">
	                      			<img src="/image/button/bt_delSelect.gif" border="0" onClick="javascript:selectDelete()" style="cursor:hand">
                      			<% } %>
                      		</td>
                      		<td width="459" align="right" valign="middle">
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
              <tr>
              	<td height="35"></td>
              </tr>

            </table>
</form>

            </td>
        </tr>
              

      </table></td>
  </tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>
