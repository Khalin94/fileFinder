<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.SMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SMemReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.SMemReqInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	System.out.println("###########################################################################");
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	// 2004-05-11 �߰��� �Ķ����
	// �亯 ����� ��� �Ϸ�Ǹ� �ڵ����� �亯�� �߼� â�� ����.
	String strStartAnsDocSend = StringUtil.getEmptyIfNull(request.getParameter("startAnsDocSend"));
	
	SMemReqBoxDelegate selfDelegate = null;
	MemRequestBoxDelegate reqDelegate = null;
	SMemReqInfoDelegate reqInfoDelegate = null;
	
	SMemReqBoxVListForm objParams = new SMemReqBoxVListForm();  
	//SReqInfoListForm objParams = new SReqInfoListForm();  
	// �䱸�� ������ ���θ� Form�� �߰��Ѵ�
  	objParams.setParamValue("IsRequester", String.valueOf(objUserInfo.isRequester()));
	
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
	
	// �䱸 ���� �� ����¡ ����
	int intTotalRecordCount = 0;
	int intCurrentPageNum = 0;
	int intTotalPage = 0;
	
	// ���� �䱸���� �䱸�� ��ϵ� �亯 ����
	int intTotalAnsCount = 0;

	ResultSetSingleHelper objRsSH = null;
	ResultSetHelper objRs = null;
	
	try{
		selfDelegate = new SMemReqBoxDelegate();
	   	reqDelegate = new MemRequestBoxDelegate();
	   	reqInfoDelegate = new SMemReqInfoDelegate();
	   
	   	boolean blnHashAuth = reqDelegate.checkReqBoxAuth(strReqBoxID, objUserInfo.getOrganID()).booleanValue();
	   
	   	if(!blnHashAuth) { 
	   		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	  		objMsgBean.setStrCode("DSAUTH-0001");
  	  		objMsgBean.setStrMsg("�ش� �䱸�ڷḦ �� ������ �����ϴ�.");
  	  		out.println("�ش� �䱸�ڷḦ �� ������ �����ϴ�.");
		    return;
		} else {
	    	// �䱸�� ��� ������ SELECT �Ѵ�.
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	    	objRsSH = new ResultSetSingleHelper(selfDelegate.getRecord(strReqBoxID, objUserInfo.getUserID()));

			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~ : "+objRsSH.getObject("REQ_BOX_NM"));
	    	
	    	// �䱸 ����� SELECT �Ѵ�.
	    	objRs = new ResultSetHelper(reqInfoDelegate.getRecordList(objParams));
	    	
	    	// ���� �䱸���� ��ϵ� �䱸�� �亯 ������??
	    	intTotalAnsCount = selfDelegate.checkReqInfoAnsIsNull(strReqBoxID);
	    	 
	    	 /**�䱸���� �����ȸ�� ��� ��ȯ.*/
			intTotalRecordCount = objRs.getTotalRecordCount();
 			intCurrentPageNum = objRs.getPageNumber();
 			intTotalPage = objRs.getTotalPageCount();	
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
<title><%=MenuConstants.getReqBoxGeneral(request)%> > <%=MenuConstants.REQ_BOX_MAKE%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
	var IsClick=false;

	
	var strPopup;
	var strGubun = -1;

	function ButtonProcessing()
	{
		try{			
			if(strGubun < 0){
				var oPopup = window.createPopup();
				var  oPopBody  =  oPopup.document.body;
				oPopBody.style.backgroundColor  =  "white";
				oPopBody.style.border  =  "solid  #dddddd 1px";



				// "ó�����Դϴ�"��� �޽����� �ε��̹����� ǥ�õǵ��� �Ѵ�.
				oPopBody.innerHTML  = "<table width='100%' height='100%' border='1'><tr><td align='center' style='font-size:9pt;'><b>ó�����Դϴ�. ��ø� ��ٷ��ּ���...<b><br><img src='/image/reqsubmit/processing.gif'></td></tr></table>";



				var leftX = document.body.clientWidth/2 -130;
				var topY = (document.body.clientHeight/1.7) - (oPopBody.offsetHeight/2);

				oPopup.show(leftX,  topY,  270,  130,  document.body);



				// createPopup()�� �̿��� �˾��������� ����� ��� 
				// �⺻������ �ش� �˾����� onblur�̺�Ʈ�� �߻��ϸ� �� �˾��������� ������ �˴ϴ�.

				// �ش� �˾����������� onblur�̺�Ʈ�� �߻��Ҷ�����  �޼ҵ带 ��ȣ���Ͽ�

				// �˾��������� �׻� ǥ�õǰ� �մϴ�.
				oPopBody.attachEvent("onblur", ButtonProcessing);
				strPopup = oPopup;
			}
			strGubun = -1;
		} 
		catch(e) {}
	}

	function notProcessing(){
		if(strPopup.isOpen){
			strPopup.hide();
			strGubun = 1;
		}		
	}

	var f;	
	
	// �䱸�� ����
	function goReqDocView() {
		NewWindow('/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001', '', '800', '600');
		//window.open("/reqsubmit/common/ReqDocView.jsp?ReqBoxId=<%= strReqBoxID%>&ReqTp=001", "",	"resizable=no,menubar=no,status=yes,titlebar=yes,scrollbars=no,location=no,toolbar=no,height=600,width=800" );
	}
	
	// �亯�� �߼�
	function sendAnsDoc() {
		var f = document.viewForm;
		f.action = "/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID %>";
		f.target = "popwin";
		NewWindow('/blank.html', 'popwin', '470', '300');
		f.submit();
		//window.open('/reqsubmit/common/AnsDocSend.jsp?ReqBoxID=<%= strReqBoxID%>', '', 'width=450,height=300, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
	}
	
	// �䱸 ��� ��ȸ
	function goReqBoxList() {
		f = document.viewForm;
		f.action = "SMakeOpReqBoxList.jsp";
		f.target = "";
		f.submit();
	}
	
	// ���Ĺ�� �ٲٱ�
	function changeSortQuery(sortField, sortMethod){
		f = document.viewForm;
  		f.ReqInfoSortField.value = sortField;
  		f.ReqInfoSortMtd.value = sortMethod;
  		f.target = "";
  		f.submit();
  	}
  
  	// �䱸 �󼼺���� ���� */
  	function gotoDetail(strID){
  		f = document.viewForm;
  		f.ReqID.value = strID;
  		f.action="SMakeOpReqInfoVList.jsp";
  		f.target = "";
  		f.submit();
  	}


  
  	// ����¡ �ٷΰ���
  	function goPage(strPage){
  		f = document.viewForm;
  		f.ReqInfoPage.value = strPage;
  		f.target = "";
  		f.submit();
  	}
  	
  	// �亯�� �߼��� �� �� ��ϵ� �亯�� �ϳ��� ������ �߼��� ���Ѵٴ� �޼����� �����ش�.
  	function alertSendAnsDocMessage() {
  		alert("�亯�� ��ϵ��� ���� �䱸�� �ֽ��ϴ�.\nȮ�� �� �ٽ� �õ��� �ֽñ� �ٶ��ϴ�.");
  	}
  	
  	/**
  	 * 2005-10-20 kogaeng ADD
  	 * üũ�ڽ��� �ϳ��� �����ϰ� �ϴ� ��ũ��Ʈ
  	 */
  	function checkBoxValidate(cb, strID) {
		if(<%= intTotalRecordCount %> == 1) {
			if(cb == 0) {
				document.viewForm.ReqInfoID.checked = true;
				document.viewForm.ReqID.value = strID;
				return;
			}
		}
		for (j = 0; j < <%= intTotalRecordCount %>; j++) {
			if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
				document.viewForm.ReqInfoID[j].checked = false;
				if (j == cb) {
					document.viewForm.ReqInfoID[j].checked = true;
					document.viewForm.ReqID.value = strID;
				} else {
					document.viewForm.ReqInfoID[j].checked = false;
					document.viewForm.ReqID.value = "";
				}
			}
		}
	}
  	
  	// �亯 �ۼ� ȭ������ �̵�
  	function goSbmtReqForm() {
  		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/SAnsInfoWrite.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}
  	
	/** �䱸 �̷º��� */
	function viewReqHistory() {
		var cnt = 0;
		if(<%= intTotalRecordCount %> == 1) {
			if(eval("document.viewForm.ReqInfoID.checked") == true) cnt = 1;
		} else {
			for (j = 0; j < <%= intTotalRecordCount %>; j++) {
				if (eval("document.viewForm.ReqInfoID[" + j + "].checked") == true) {
					document.viewForm.ReqID.value = document.viewForm.ReqInfoID[j].value;
					cnt++;
				}
			}
		}
  		
  		if(cnt == 0) {
  			alert("�䱸�� �����Ͻ� �Ŀ� ��ư�� �ٽ� Ŭ���� �ּ���");
  			return;
  		}
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID="+document.viewForm.ReqID.value;
		var winl = (screen.width - 540) / 2;
		var winh = (screen.height - 450) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=450,width=540, left="+winl+", top="+winh);
		f.submit();
		/*
  		var popModal = window.showModalDialog('/reqsubmit/common/ViewReqHistory.jsp?ReqInfoID='+document.viewForm.ReqID.value, 
  																'', 'dialogWidth:540px;dialogHeight:450px; center:yes; help:no; status:no; scroll:yes; resizable:yes');
  		*/
	}

	// �亯 �ۼ� ȭ������ �̵�
  	function offlineSubmit() {  		
  		f = document.viewForm;
		f.target = "newpopup";		  
		f.action = "/reqsubmit/common/OffLineDocSend.jsp";
		var winl = (screen.width - 550) / 2;
		var winh = (screen.height - 350) / 2;
		window.open("/blank.html","newpopup","resizable=yes,menubar=no,status=no,titlebar=no, scrollbars=yes,location=no,toolbar=no,height=350,width=520, left="+winl+", top="+winh);
		f.submit();
  	}

  	
	function doDelete() {
		if(!IsClick){
			
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
	  	
	  	if(confirm("�����Ͻ� �䱸���� �����Ͻðڽ��ϱ�?\n\r���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.viewForm.action = "/reqsubmit/10_mem/20_reqboxsh/15_make/ReqBoxOpDelProc.jsp";
			document.viewForm.target = 'processingFrame';	
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.viewForm.submit();
	  	}
	}
  	
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
<% if("Y".equalsIgnoreCase(strStartAnsDocSend)) { %>
onLoad="javascript:sendAnsDoc()" 
<% } %>
> 
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="balloonHint" style="display:none;height:100px"> 
<table border="0" cellspacing="0" cellpadding="4"> 
	<tr>
		<td bgcolor="#EBF2F5" width="30" height="20" align="center" style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;"><font style="font-size:11px;font-family:verdana,����;font-weight:bold">�䱸<BR>��<BR>����</font></td>
		<td style="border-left:1px solid #808080;border-top:1px solid #808080;border-bottom:2px solid #808080;border-right:2px solid #808080;text-align:justify;word-break:break-all;" width="220">
			<font style="font-size:11px;font-family:verdana,����">{{hint}}</font>
		</td>
	</tr> 
</table> 
</div> 
<SCRIPT language="JavaScript" src="/js2/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="/image/common/bg_leftMenu.gif">
		<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
		<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
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
                      <td width="34%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_MAKE%></span> <strong>- <%= MenuConstants.REQ_BOX_DETAIL_VIEW %></strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="50%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > ��ȸ�ǿ� ������ �ڷ� �䱸 > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		��ȸ(�ǿ���, �繫ó, ������åó, �������� ��)�κ��� �߼۵� �䱸�ڷ��� �� ���� �� ��ϵ� �䱸 ����� Ȯ���Ͻ� �� �ֽ��ϴ�.
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
				                	 �䱸�ڷ� ��� ����
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
					<input type="hidden" name="ReqID" value=""> <!-- �䱸 ID -->
					<input type="hidden" name="ReqInfoSortField" value="<%= strReqInfoSortField %>"><!--�䱸���� ��������ʵ� -->
					<input type="hidden" name="ReqInfoSortMtd" value="<%= strReqInfoSortMtd %>"><!--�䱸���� ������Ĺ��-->
					<input type="hidden" name="ReqInfoPage" value="<%= strReqInfoPagNum %>"><!-- �䱸���� ������ ��ȣ -->
					<input type="hidden" name="createdocflag" value="OPLSUBMT">
					<input type="hidden" name="ReturnURL" value="/reqsubmit/10_mem/20_reqboxsh/15_make/SMakeOpReqBoxList.jsp">
					
					
					<table width="680" border="0" cellspacing="0" cellpadding="0">
                    	<tr class="td_reqsubmit"> 
                      		<td width="110" height="2"></td>
                      		<td width="570" height="2" colspan="3"></td>
                    	</tr>
                    	<tr> 
                      		<td height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸�ڷ�
                      		</td>
                      		<td height="25" colspan="3" class="td_lmagin"><B><%= objRsSH.getObject("REQ_BOX_NM") %></B>
                      			<%
                      				// 2004-06-15 ADD
                      				String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
                      				if (StringUtil.isAssigned(strElcDocNo)) {
                      					out.println(" (���ڰ����ȣ : "+strElcDocNo+")");
                      				}
                      			%>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" bgcolor="white"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �Ұ� ����ȸ
                      		</td>
                      		<td width="230" height="25" class="td_lmagin"><%= objRsSH.getObject("CMT_ORGAN_NM") %></td>
                      		<td width="110" height="25" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �������� 
                      		</td>
                      		<td width="230" class="td_lmagin"><%= objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY")) %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �߼�����</td>
							<td colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
								<table border="0" cellpadding="0" cellspacing="0">
									<!--tr>
										<td colspan="2" align="center" height="20">
											<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
												<tr><td height="18" align="center" width="120" bgcolor="#f4f4f4">�䱸���</td>
												</tr>
											</table>
										</td>
										<td></td>
										<td colspan="2" align="left">
											<table border="0" cellpadding="0" cellspacing="0" style="border:1px solid #c0c0c0">
												<tr><td height="18" align="center" width="120" bgcolor="#f4f4f4">������</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5" height="2"></td>
									</tr -->
									<%										
										String tempoplmtd = "";
										if(((String)objRsSH.getObject("OPL_MTD")).equals("001")){
											tempoplmtd = "��ȭ";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("002")){
											tempoplmtd = "e-����";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("003")){
											tempoplmtd = "�ѽ�";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("004")){
											tempoplmtd = "����";
										}else if(((String)objRsSH.getObject("OPL_MTD")).equals("005")){
											tempoplmtd = "��Ÿ";
										}else{
											tempoplmtd = "��Ÿ";
										}
									%>
									<tr>
		                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_assembly.gif" border="0"></td>
		                      			<td>&nbsp;<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>&nbsp;&nbsp;</td>
		                      			<td width="50" align="center" rowspan="2"><img src="/image/reqsubmit/arrow1.gif" border="0"><br><font color="blue">(<%=tempoplmtd%>)</font></td>
		                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_cube.gif" border="0"></td>
		                      			<td>&nbsp;<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
	                      			</tr>
	                      			<tr>
	                      				<td>&nbsp;<%=(String)objRsSH.getObject("REGR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("REGR_EMAIL")%>"><%=(String)objRsSH.getObject("REGR_EMAIL")%></a> / <%=(String)objRsSH.getObject("REGR_CPHONE")%>)</td>
	                      				<td>&nbsp;<%=(String)objRsSH.getObject("RCVR_NM")%> </td>
	                      			</tr>
                      			</table>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸�ڷ� �̷�</td>
                      		<td colspan="3" class="td_lmagin" style="padding-top:5px;padding-bottom:5px">
                      			<table border="0" cellpadding="0" cellspacing="0">
                      				<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> �䱸�ڷ� ������ </td>
                      					<td width="5" align="center">:</td>
                      					<td width="150">&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                      				</tr>
                      				<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> �����ڿ䱸 ������ </td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></td>
                      				</tr>
									<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> ������ ��ȸ��</td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></td>
                      				</tr>
									<tr>
                      					<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> <B>�������</B></td>
                      					<td width="5" align="center">:</td>
                      					<td>&nbsp;<B><%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00 </B></td>
                      				</tr>
                      			</table>
                      		</td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    	<tr> 
                      		<td height="40" class="td_gray1">
                      			<img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> �䱸�ڷἳ��
                      		</td>
                      		<td height="40" colspan="3" class="td_lmagin"><%= objRsSH.getObject("REQ_BOX_DSC") %></td>
                    	</tr>
                    	<tr height="1" class="tbl-line"> 
                      		<td height="1" colspan="4"></td>
                    	</tr>
                    	
                    </table>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr><td height="30">
                    &nbsp;
					
                    	</td></tr>
                    </table>
                    <!-- �亯�� �߼� -->
                    <%
                    	String strAnsDocURL = null;
						String strAnsDocPreviewScriptURL = null;
		              	if (intTotalAnsCount == 0) { 
		               		strAnsDocURL = "javascript:sendAnsDoc()";
							strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
						} else {
		               		strAnsDocURL = "javascript:alertSendAnsDocMessage()";
		               		strAnsDocPreviewScriptURL = "javascript:alertSendAnsDocMessage()";
						}
						//strAnsDocPreviewScriptURL = "javascript:PreAnsDocView(viewForm,'"+strReqBoxID+"')";
                    %>
                    <!-- �䱸�� ��� -->										
                    <img src="/image/reqsubmit/searchlist2.gif" border="0" onClick="javascript:goReqBoxList()" style="cursor:hand"> <img src="/image/button/bt_delReqBox.gif" border="0" onClick="javascript:doDelete('<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand">                  
                    <!-- �䱸�� ���� -->
                    <img src="/image/button/bt_previewReq2.gif" border="0" 
						onClick="PreReqDocView(viewForm,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= CodeConstants.PRE_REQ_DOC_FORM_101 %>')" 
									style="cursor:hand" alt="�������� ���� �䱸��(PDF)�� Ȯ���մϴ�.">
                    <img src="/image/button/bt_previewSubmit2.gif" border="0" style="cursor:hand" onClick="<%= strAnsDocPreviewScriptURL %>" alt="�䱸������� ������ �亯��(PDF)�� �̸� Ȯ���մϴ�.">
                    <img src="/image/button/bt_sendAnswer2.gif" border="0" onClick="<%= strAnsDocURL %>" style="cursor:hand" alt="������ �Ϸ�� �䱸�ڷḦ �䱸������� �߼��մϴ�.">					
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
				                	 �䱸 ���
				            </td>
				            <td width="459" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	<img src="/image/common/icon_nemo_gray.gif" border="0">&nbsp;&nbsp;��ü �ڷ� �� : <%= intTotalRecordCount %> �� (<%= intCurrentPageNum %> / <%= intTotalPage %> Page)
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
                      		<td height="2" colspan="8" class="td_reqsubmit"></td>
	                    </tr>
    	                <tr align="center" class="td_top"> 
    	                	<td width="20" align="center"></td>
            	          	<td width="44" height="22">NO</td>
	                	    <td width="415"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_CONT", strReqInfoSortField, strReqInfoSortMtd, "�䱸����") %></td>
                    	  	<td width="80"><%= SortingUtil.getSortLink("changeSortQuery", "REQ_STT", strReqInfoSortField, strReqInfoSortMtd, "����") %></td>
	                      	<td width="80"><%= SortingUtil.getSortLink("changeSortQuery", "OPEN_CL", strReqInfoSortField, strReqInfoSortMtd, "�������") %></td>
    	                  	<td width="50">�亯</td>
							<td width="50">÷��</td>
        	              	<td width="70"><%=SortingUtil.getSortLink("changeSortQuery", "REG_DT", strReqInfoSortField, strReqInfoSortMtd, "�������")%></td>
            	        </tr>
                	    <tr> 
                    	  	<td height="1" colspan="8" class="td_reqsubmit"></td>
                    	</tr>
                    	<%
                    		int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
							String strReqInfoID = "";
							while(objRs.next()){
								strReqInfoID = (String)objRs.getObject("REQ_ID");
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
							<td width="20" align="center"><input type="checkbox" name="ReqInfoID" value="<%= strReqInfoID %>" onClick="javascript:checkBoxValidate(<%= (intRecordNumber-1) %>, '<%= strReqInfoID %>')"></td>
							<td width="44" height="22" align="center"><%= intRecordNumber %></td>
							<td width="415" class="td_lmagin"><a href="javascript:gotoDetail('<%= objRs.getObject("REQ_ID") %>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%= objRs.getObject("REQ_CONT") %></a></td>
							<td width="80" align="center"><%= CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT")) %></td>
							<td width="80" align="center"><%= CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL")) %></td>
							<td width="50" align="center"><%= nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"), (String)objRs.getObject("ANS_MTD"), (String)objRs.getObject("ANS_OPIN"), (String)objRs.getObject("SUBMT_FLAG"), objUserInfo.isRequester()) %></td>
							<td width="50" align="center"><%=makeAttachedFileLink((String)objRs.getObject("ans_estyle_file_path"))%></td>
							<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
						</tr>
						<tr class="tbl-line"> 
                    	  	<td height="1" colspan="8"></td>
                    	</tr>
                    	<%
                    			intRecordNumber++;
							} //endwhile
                    	%>
	                    <tr class="tbl-line"> 
                    	  	<td height="1" colspan="8"></td>
                    	</tr>
                    </table>
	               	<!------------------------------------------------- �䱸 ��� ���̺� �� ------------------------------------------------->
	               	
	               	<table border="0" cellpadding="0" cellspacing="0">
						<tr><td height="30">
		                    <img src="/image/common/icon_exclam_mark.gif" border="0"> �߰��Ͻ� �亯�ۼ��� �ִ� ���, �ϴ��� <b>�߰��亯 �ۼ�</b> ��ư�� Ŭ���Ͽ� �ֽñ� �ٶ��ϴ�.
		               	</td></tr>
		            </table>
	               	
                </td>
              </tr>
              
              <!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="300" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
			                    <!-- �亯 �ۼ� -->
				               	<img src="/image/reqsubmit/addsubmtreg.gif" border="0" style="cursor:hand" onClick="javascript:goSbmtReqForm()">
				               	<!-- �䱸 �̷� ��ȸ -->
								<img src="/image/button/bt_viewReqHistory.gif"  height="20" border="0" onClick="viewReqHistory()" style="cursor:hand"  alt="���� �䱸�� ó�������� ���ں��� ��ȸ�մϴ�.">
                      		</td>
                      		<td width="459" align="right" valign="middle">
                      			&nbsp;
                          	</td>
                    	</tr>
                  	</table>
               </td>
              </tr>
              
              <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqInfoPageSize"))
					%>
                </td>
              </tr>
              
            </table>
</form>
			<p><br/></p>

            </td>
        </tr>
      </table></td>
  </tr>
</table>

<%!
	public String makeAttachedFileLink(String strFileName){
		String strReturnURL = null;
		if(!StringUtil.isAssigned(strFileName)){
			//���ϰ�ΰ� ������ �⺻ ���ϰ�η� ��ġ��.
			strReturnURL = "";
			//strFileName=nads.lib.reqsubmit.EnvConstants.getConstFilePath();
		} else {
			strReturnURL = "<a href=\"/reqsubmit/common/AttachStyleFileDownload.jsp?path=" + strFileName+ "\"><img src=\"/image/common/icon_etc.gif\" border=\"0\"></a>";
		}
		return strReturnURL;
	}

%>

<%@ include file="/common/Bottom.jsp" %>


</body>
</html>