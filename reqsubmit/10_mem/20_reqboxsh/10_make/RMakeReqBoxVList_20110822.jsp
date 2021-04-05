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
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.MemRequestInfoDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
	} //endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	 
	String strAuditYear = (String)objParams.getParamValue("AuditYear") == null ? "2008" : (String)objParams.getParamValue("AuditYear");
	String strCmtGubun = objUserInfo.getOrganGBNCode();
	strAuditYear = StringUtil.getEmptyIfNull(strAuditYear);
	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
 
	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objCmtSubmt = new CmtSubmtReqBoxDelegate();
		   
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
			
			/**�䱸 ���� �븮�� New */    
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));

			if(strAuditYear.equals("")){
				strAuditYear = ((String)objRsSH.getObject("REG_DT")).substring(0,4);
			}
		}/**���� endif*/
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

	/*************************************************************************************************/
	/** 					������ �� �Ҵ�  Part 														  */
	/*************************************************************************************************/

	/**�䱸���� �����ȸ�� ��� ��ȯ.*/
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.REQ_BOX_MAKE%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }
  /**�䱸 �󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RMakeReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RMakeReqBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }
  
  /** �䱸����������� ����. */
  function gotoRegReqInfo(){
  	formName.action="./RMakeReqInfoWrite.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
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


	function sendReqDocByCmtTitle() {		
		
		if(!IsClick){
			
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
		if(confirm("�ش� �䱸 ������ ����ȸ�� ��û�Ͻ� �� ����ȸ ���Ƿ� �߼��Ͻðڽ��ϱ�?")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			formName.method = "POST";
			formName.target = "processingFrame";
			formName.action = "/reqsubmit/common/CmtReqDocSendAllInOne.jsp";
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			//window.open('about:blank', 'popwin', 'width=100px, height=100px, left=1500px, top=1500px');
			formName.submit();
		}
	}

	function sendReqDocNew(strReqDocType, strReqBoxID) {
		if(!IsClick){
			NewWindowFixSize('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', '460', '340');
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
  	//var popModal = window.showModalDialog('RMakeReqDocSend.jsp?ReqDocType="+strReqDocType+"&ReqBoxID=' + strReqBoxID, 
  	//															'', 'dialogWidth:450px;dialogHeight:500px; center:yes; help:no; status:no; scroll:no; resizable:yes');
  	//window.open('/reqsubmit/common/ReqDocSend.jsp?ReqBoxID='+strReqBoxID+'&ReqDocType='+strReqDocType, '', 'width=450,height=320, scrollbars=no, resizable=no, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	
  }

	function copyReqBox(ReqBoxID) {
		NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
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
<SCRIPT language="JavaScript" src="/js/reqsubmit/tooltip.js"></SCRIPT>
<script language="javascript">balloonHint("balloonHint")</script>

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
<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>"><!--�䱸�� �ű����� ���� -->
			<%//�䱸�� ���� ���� �ޱ�.
				String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
				String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
				//�䱸�� ������ ��ȣ �ޱ�.
				String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
				//�䱸�� ��ȸ���� �ޱ�.
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
				String strReqBoxQryTerm=objParams.getParamValue("ReqBoxQryTerm");
				//�䱸 ���� ���� ���� �ޱ�.
				String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
				String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");
				//�䱸�� ���� ������ ��ȣ �ޱ�.
				String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
				//�䱸��ȸ�����±׾��ֱ�����.
				objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
				objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <!-- %= objParams.getHiddenFormTags()% -->
			
			<input type="hidden" name="ReqBoxPage" value="<%= strReqBoxPagNum %>">
			<input type="hidden" name="ReqBoxPageSize" value="<%= (String)objParams.getParamValue("ReqBoxPageSize") %>">
			<input type="hidden" name="ReqBoxQryField" value="<%= (String)objParams.getParamValue("ReqBoxQryField") %>">
			<input type="hidden" name="ReqBoxQryTerm" value="<%= (String)objParams.getParamValue("ReqBoxQryTerm") %>">
			<input type="hidden" name="ReqBoxSortField" value="<%= (String)objParams.getParamValue("ReqBoxSortField") %>">
			<input type="hidden" name="ReqBoxSortMtd" value="<%= (String)objParams.getParamValue("ReqBoxSortMtd") %>">
			<input type="hidden" name="ReqInfoPage" value="<%= (String)objParams.getParamValue("ReqInfoPage") %>">
			<input type="hidden" name="ReqInfoPageSize" value="<%= (String)objParams.getParamValue("ReqInfoPageSize") %>">
			<input type="hidden" name="ReqInfoSortField" value="<%= (String)objParams.getParamValue("ReqInfoSortField") %>">
			<input type="hidden" name="ReqInfoSortMtd" value="<%= (String)objParams.getParamValue("ReqInfoSortMtd") %>">
			<input type="hidden" name="AuditYear" value="<%= strAuditYear %>">
			<input type="hidden" name="RltdDuty" value="<%= (String)objParams.getParamValue("RltdDuty") %>">
			
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
			<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>"><!-- ReqDocType -->
			<input type="hidden" name="CmtOrganID" value="<%= objRsSH.getObject("CMT_ORGAN_ID") %>">
			<input type="hidden" name="ReqBoxID" value="<%= (String)objParams.getParamValue("ReqBoxID") %>">
			<input type="hidden" name="ReqInfoID" value="">
			<input type="hidden" name="ReqBoxIDs">
			<input type="hidden" name="SubmtDln" value="<%= StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN")) %>">
			<input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">
			<input type="hidden" name="ReqOrganNm" value="<%=objRsSH.getObject("REQ_ORGAN_NM")%>">
			<input type="hidden" name="RegrNm" value="<%=objRsSH.getObject("REGR_NM")%>">
			<input type="hidden" name="ReqOrganId" value="<%=objRsSH.getObject("REQ_ORGAN_ID")%>">
			
			<%
				int int1st = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("��");
				int int2nd = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).indexOf("ȸ");
				String strNatCnt = String.valueOf(objRsSH.getObject("REQ_BOX_NM")).substring(int1st+1, int2nd);
			%>
			<input type="hidden" name="NatCnt" value="<%= strNatCnt %>">
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="25%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_MAKE%></span>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_MAKE%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		���������� ���� �䱸�� ������ Ȯ���ϴ� ȭ���Դϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  �䱸�� ����
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
                <table width="680" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td height="2" colspan="4"></td>
                    </tr>
                    <%
					  //�䱸�� ���� ����.
					  String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");                    
					%>
					
					<tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�Ը� </td>
                      <td width="580" height="25" colspan="3" class="td_lmagin">
                      	<B><%=objRsSH.getObject("REQ_BOX_NM")%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>

					<%
						// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
					%>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �Ұ� ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    <% } %>

					<tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �߼�����</td>
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
                      		<tr>
                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_assembly.gif" border="0"></td>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>&nbsp;&nbsp;</td>
                      			<td width="50" align="center" rowspan="2"><img src="/image/reqsubmit/arrow1.gif" border="0"></td>
                      			<td width="20" height="20" align="center" rowspan="2"><img src="/image/reqsubmit/icon_cube.gif" border="0"></td>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%></td>
                      		</tr>
                      		<tr>
                      			<td>&nbsp;<%=(String)objRsSH.getObject("REGR_NM")%>&nbsp;&nbsp;</td>
                      			<td width="350">&nbsp;(�߼۵��� �ʾ����Ƿ�, �亯 ����� ������ �����ϴ�.)</td>
                      		</tr>
                      	</table>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�� �̷�</td>
                      <td height="50" colspan="3" class="td_lmagin">
                      	<table border="0" cellpadding="0" cellspacing="0">
                      		<tr>
                      			<td width="110" height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> �䱸�Ի����Ͻ� : </td>
                      			<td width="150">&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                      		</tr>
							<tr>
                      			<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> ������� : </td>
                      			<td>&nbsp;<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> 24:00</td>
                      		</tr>
                      	</table>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�Լ��� </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
                      </td>
                    </tr>
                    <tr height="2" class="tbl-line"> 
                      <td height="2" colspan="4"></td>
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
						<DIV style="height:25px;color:brown">
						<img src="/image/common/icon_exclam_mark.gif" border="0"> <B>�䱸�� �߼� </B> : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.
						</DIV>
						<% 
							if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
							//if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && ("GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) || "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) { 
						%> 
						<DIV style="height:25px;color:brown">
						<img src="/image/common/icon_exclam_mark.gif" border="0"> <B>����ȸ ���� �䱸�� �߼�</B> : ����ȸ�� �ۼ��� �䱸 ������ �ڵ� ��û �մϴ�. ����ȸ �����Ϸ� �䱸�� ���� �ش� ������ Ȯ���ϼ���.
						</DIV>
						<% } %>

						<%
							//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
						  	//�� �ۼ��߰� �ݷ����¿����� ������.
							if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
	
								/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
								if(objUserInfo.getUserID().equals((String)objRsSH.getObject("REGR_ID"))){
						%>
									<!-- �䱸�� ���� BUTTON -->
									<img src="/image/button/bt_modifyReqBox.gif" border="0" onClick="javascript:gotoMemEditPage()" style="cursor:hand">
									<!-- �䱸�� ���� BUTTON -->
									<img src="/image/button/bt_delReqBox.gif"  border="0" onClick="javascript:gotoMemDeletePage(<%=objRs.getTotalRecordCount()%>)" style="cursor:hand">
						<%
							 	} // ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.
						%>
									<!-- �䱸�� ���� -->
									<a href="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')" onfocus="this.blur()">
										<img src="/image/button/bt_copyReqBox.gif" border="0" style="cursor:hand" alt="���� �䱸���� ���纻 �䱸���� �����˴ϴ�.">
									</a>
									
									<!-- �䱸�� ��� -->
									<img src="/image/button/bt_reqBoxList.gif"  border="0" onClick="javascript:gotoList()" style="cursor:hand">
						<%
								if(intTotalRecordCount>0){
						%>
									<!-- �䱸�� �߼� BUTTON -->
									<!-- 2005-08-08 kogaeng EDIT -->
									<!-- �������� ��� �������� �ȵȴ� -->
									<% if(objUserInfo.getIsMyCmtOrganID("GI00004757") && "GI00004757".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
									<% } else { %>
										<%if(strCmtGubun.equals("004")){%>
										<img src="/image/button/bt_sendReq2_bak.gif"  border="0" onClick="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand" alt="�ۼ��� �䱸���� ���������� �߼��մϴ�.">
										<%}else{%>
										<img src="/image/button/bt_sendReq2.gif"  border="0" onClick="javascript:sendReqDocNew('<%= CodeConstants.REQ_DOC_TYPE_001 %>', '<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand" alt="�ۼ��� �䱸���� ���������� �߼��մϴ�.">
										<%}%>										
									<% } %>

									<!-- 2005-01-15 �����������ȸ(organ_id : GI00004757) �� ��� ����ȸ�� �����Ϸ� �䱸������ �̵���Ų��. -->
						<% 
									if(objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) && objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) {
						%> 
										<img src="/image/button/bt_sendReqDocCmtTitle2.gif"   border="0" onClick="sendReqDocByCmtTitle()" style="cursor:hand" alt="�ۼ��� �䱸���� ���������� �߼��մϴ�.">
						<% 
									} 
						%>
						<!-- 2004-12-08 -->
						<!-- �ۼ��� �䱸���� �ڵ� ����ȸ ���� �� ����ȸ ���Ƿ� �߼� -->
						<!-- �α����� �̿��ڰ� �Ҽӵ� ����ȸ �̾�� �ϸ�, �� ����ȸ�� '������Ư������ȸ' �� ��쿡�� �ش� ����� �����Ѵ�. -->
						<% //if(objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) && "GI00004773".equalsIgnoreCase((String)objRsSH.getObject("CMT_ORGAN_ID")) && objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) == true) { %> 
							<!-- img src="/image/button/bt_sendReqDocCmtTitle.gif" onClick="javascript:sendReqDocByCmtTitle()" alt="�ۼ��� �䱸���� ����ȸ�� �̸����� ���������� �߼��մϴ�." style="cursor:hand" -->
						<% //} %>
						<%
								}//�����ı����־�� ����.
							
							} // endif

							/*��ȸ��� ������ ��� ����.*/
							if(objRs.getRecordSize()>0){
						%>						
								<img src="/image/button/bt_previewReq2.gif" border="0" 
						<%
							String strReqTp = "";
							if (CodeConstants.ORGAN_GBN_CMT.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) strReqTp = CodeConstants.PRE_REQ_DOC_FORM_901;
							else strReqTp = CodeConstants.PRE_REQ_DOC_FORM_101;
						%>
								onClick="PreReqDocView(formName,'<%= (String)objParams.getParamValue("ReqBoxID") %>', '<%= strReqTp %>')" 
									style="cursor:hand" alt="�������� ���� �䱸��(PDF)�� Ȯ���մϴ�.">
						<%
							}//endif �䱸�� �̸����� ��ư ���� ��.
						%>
						
               		 </td>
               	   </tr>
               	</table>   
               	<!----------------------- ���� ��ҵ� Form���� ��ư �� ------------------------->               	   
                </td>
              </tr> 
              <tr>
               	<!-- �����̽���ĭ -->
               	<td>&nbsp;</td>
               	<!-- �����̽���ĭ -->
              </tr>
              <tr> 
                <td height="30" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="759">
                		<tr>
                			<td width="400" class="soti_reqsubmit">
                			   <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  				�䱸 ���
				            </td>
				            <td width="359" align="right" valign="bottom" class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
				            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> Page)&nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>
                </td>
              </tr>
              <tr> 
                <td align="left" valign="top" class="soti_reqsubmit">
                <!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->
					<table width="759" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td height="2" class="td_reqsubmit"></td>
	                    </tr>
	                    <tr align="center" class="td_top">
	                    	<td>
	                    		<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr class="td_top">
										<td height="22" width="15" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
										<td width="24" align="center">NO</td>
										<%
										int intTmpWidth1=490;
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										  intTmpWidth1=intTmpWidth1-50;
										}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td width="<%=intTmpWidth1%>" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></td>
										<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_STT",strReqInfoSortField,strReqInfoSortMtd,"����")%></td>
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>
										<td width="50" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"����ȸ")%></td>
										<%
										}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"����Ͻ�")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
							int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));						  
						  	String strReqInfoID = "";
						  	String strCmtApplyValue = "Y";
						  	
						  	while(objRs.next()) {
						  		strReqInfoID = (String)objRs.getObject("REQ_ID");
						   	 	/** ����ȸ��û��������(Y) �ƴ��� "" ����*/
						   	 	if(CodeConstants.isDuplatedApplyToCmtReq((String)objRs.getObject("CMT_REQ_APP_FLAG"))) strCmtApplyValue = "";
								else strCmtApplyValue="Y";
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="15" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
										<td width="24" align="center"><%=intRecordNumber%></td>
										<%
										int intTmpWidth2=490;
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										  intTmpWidth2=intTmpWidth2-50;
										}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td width="<%=intTmpWidth2%>" class="td_lmagin"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 40)+" ..."	 %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
										<td width="70" align="center"><%=CodeConstants.getRequestStatus((String)objRs.getObject("REQ_STT"))%></td>
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>
										<td width="60" align="center"><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
										<%
										}//endif�ǿ��ǼҼ�Ȯ��
										%>										
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:4px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
								<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
								<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
								
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
							    intRecordNumber --;
							}//endwhile
						%>
						<%
						/*��ȸ��� ������ ��� ����.*/
						if(objRs.getRecordSize()<1){
						%>
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						    <td align="center" height="22">��ϵ� �䱸������ �����ϴ�.</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
						<%
						}/*��ȸ��� ������ ��� ��.*/
						%>												
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
	                </table>
				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
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
              <tr height="3">
              	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
              </tr>                                          
              <!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
              <tr> 
                <td height="40" align="left" valign="top">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    	<tr> 
                      		<td width="456" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
                 		   <%//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
					          //�� �ۼ��߰� �ݷ����¿����� ������.
					         if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009) ){
					       %>
                      			<img src="/image/button/bt_registerReq.gif" height="20"  style="cursor:hand" onClick="gotoRegReqInfo();">
                      			<%
                      			if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
                      			%>
                      			<img src="/image/button/bt_moveReq.gif" height="20"  style="cursor:hand" onClick="moveMemReqInfo(formName);" alt="���� �䱸�� ������ �䱸������ �̵���ŵ�ϴ�.">
                      			<%
                      			}//endif
                    			%>
                  		   <%
                      		}//endif �䱸�� ���� üũ ��.
                      	   %>
                 		   <%//��������(���),��ȴ����  ���¿����� �䱸�� ����,����,�䱸�� �߼� ��ư�� Disable�Ǿ��־����.
					          //�� �ۼ��߰� �ݷ����¿����� ������.
					         if(strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_003) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_005) || strReqBoxStt.equals(CodeConstants.REQ_BOX_STT_009)){
                      			if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
                  			%>
                      			<img src="/image/button/bt_delReq.gif" height="20"  style="cursor:hand" onClick="delMemReqInfos(formName);">
                      			<!-- ����ȸ ���� ��û -->
                      			<% if(!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID"))) { %>
								<!--
       							<img src="/image/button/bt_formalReqSelsct.gif" height="20"  style="cursor:hand" onClick="ApplyCmt(document.formName);"  alt="���õ� �䱸������ ����ȸ���Ƿ� ���������� ���������� ��û�Կ� �߰��մϴ�.">
								-->
       							<% } %>
                   			<%
                      			}//endif
                      		}//endif �䱸�� ���� üũ ��.
                      	   %>
                      	   
                   			<%
                   				if(objRs.getRecordSize()>0){/**�䱸�����������츸 ���*/
                   			%>
                   				<img src="/image/button/bt_copyReq.gif" height="20"  style="cursor:hand" onClick="copyMemReqInfo(document.formName);" alt="���� �䱸�� ���纻�� ������ �䱸�Կ� �����մϴ�.">
                   				
                   			<%
                   				}//endif
                   			%>
                      		</td>
							<td width="303" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="gotoReqInfoSearch(formName);" style="cursor:hand">
							</td>
                    	</tr>
                  	</table>
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
