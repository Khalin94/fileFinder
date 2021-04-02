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
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SendReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	String existFlag = "N";
%>

<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%
	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RMemReqBoxVListForm objParams =new RMemReqBoxVListForm();  
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	  
	if(blnParamCheck==false) {
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		//out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/
	
	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	MemRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	SendReqBoxDelegate objSendBean = null;
	CmtSubmtReqBoxDelegate objCmtSubmt = null;
	
	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */
	
	try {
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objSendBean = new SendReqBoxDelegate();
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
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID"), CodeConstants.REQ_BOX_STT_006));
			/**�䱸 ���� �븮�� New */    
			objReqInfo=new MemRequestInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams));
		}/**���� endif*/
		
		/*
		 * 2005-07-26 kogaeng ADD
		 * �䱸���� �䱸�鿡 �亯���� �����ϴ����� üũ�ϴ� �Լ��� Ȱ��
		 * true�� ��ȯ�Ǹ� ������ �����ϴٶ�� ���. true ==> N
		 * false�� ��ȯ�Ǹ� ������ �� ���ٶ�� ���̴� false ==> Y
		 */
		if(objSendBean.checkDelReqBoxPermit((String)objParams.getParamValue("ReqBoxID"))) existFlag = "N";
		else existFlag = "Y";
		
	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		objMsgBean.setStrCode(objAppEx.getStrErrCode());
		objMsgBean.setStrMsg(objAppEx.getMessage());
		//out.println("<br>Error!!!" + objAppEx.getMessage());
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
<title><%=MenuConstants.REQ_BOX_SEND_END%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.target = '';
  	formName.submit();
  }
  
  /**�䱸�󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RSendReqInfoVList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RSendBoxList.jsp";
  	formName.target = '';
  	formName.submit();
  }
  
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.target = '';
  	formName.submit();
  }
  
  function deleteReqBox(strBoxID){
  	var f = document.formName;
	if(confirm("�ش�䱸���� ���� �Ͻðڽ��ϱ�?")){
		f.ReqBoxIDs.value = strBoxID;
		f.action ="RSendBoxDelProc.jsp";
		f.target = "popwin";
		window.open('/blank.html', 'popwin', 'width=40, height=40, left=2000, top=2000');
		var winl = (screen.width - 304) / 2;
		var winh = (screen.height - 118) / 2;
		document.all.loadingDiv.style.left = winl;
		document.all.loadingDiv.style.top = winh;
		document.all.loadingDiv.style.display = '';
		f.submit();
	}
  }
  
	function copyReqBox(ReqBoxID) {
		if(confirm("�ش�䱸���� �����Ͻðڽ��ϱ�?")){
  			NewWindow('/reqsubmit/common/MemReqBoxCopyList.jsp?ReqBoxID='+ReqBoxID,'', '640', '450');
	  	}
	}
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
<td width="100%">
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
		    <%=objParams.getHiddenFormTags()%>
			
			<!-- 2005-09-27 kogaeng ADD -->
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="30%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOX_SEND_END%></span> <strong>-<%=MenuConstants.REQ_BOX_DETAIL_VIEW%></strong>
                      </td>
                      <td width="21%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="59%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOX_SEND_END%></B>
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
                <table width="750" border="0" cellspacing="0" cellpadding="0">
                    <tr class="td_reqsubmit"> 
                      <td width="120" height="2"></td>
                      <td width="560" height="2" colspan="3"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �䱸�Ը� </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<B><%=objRsSH.getObject("REQ_BOX_NM")%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
                    </tr>
                    <%
						// 2004-07-08 �繫ó, ����ó�� ��쿡�� ����ȸ��°� ��������
						if (CodeConstants.ORGAN_GBN_ASM.equalsIgnoreCase(objUserInfo.getOrganGBNCode()) || CodeConstants.ORGAN_GBN_BUD.equalsIgnoreCase(objUserInfo.getOrganGBNCode())) {
						} else {
					
						//�䱸�� ���� ����.
					  	String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_STT");                    
					%>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �Ұ� ����ȸ </td>
                      <td height="25" colspan="3" class="td_lmagin">
                      	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      	<%
							// 2004-06-17 kogaeng modified
							String strElcDocNo = (String)objRsSH.getObject("DOC_NO");
							if (StringUtil.isAssigned(strElcDocNo)) out.println(" (���ڹ�����ȣ : "+strElcDocNo+")");
						%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1" colspan="3"></td>
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
                      			<td width="350">&nbsp;<%=(String)objRsSH.getObject("RCVR_NM")%> (<a href="mailto:<%=(String)objRsSH.getObject("RCVR_EMAIL")%>"><%=(String)objRsSH.getObject("RCVR_EMAIL")%></a>) (<%=(String)objRsSH.getObject("RCVR_OFFICE_TEL")%>/<%=(String)objRsSH.getObject("RCVR_CPHONE")%>)</td>
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
                      <td height="90" colspan="3" class="td_lmagin">
                      	<table border="0" cellpadding="0" cellspacing="0">
                      		<tr>
                      			<td width="110" height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> �䱸�Ի����Ͻ� : </td>
                      			<td width="150">&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("REG_DT"))%></td>
                      		</tr>
                      		<tr>
                      			<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> �䱸���߼��Ͻ� : </td>
                      			<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("LAST_REQ_DOC_SND_DT"))%></td>
                      		</tr>
							<tr>
                      			<td height="20">&nbsp;<img src="/image/reqsubmit/icon_box.gif" border="0"> ��������ȸ�Ͻ� : </td>
                      			<td>&nbsp;<%=StringUtil.getDate2((String)objRsSH.getObject("FST_QRY_DT"))%></td>
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
                      <td height="2"></td>
                      <td height="2" colspan="3"></td>
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
               	<img src="/image/common/icon_exclam_mark.gif" border="0"> �䱸�� ������ ���������� ��ϵ� �䱸�� ���� �亯�� �ۼ����� ���� ��쿡�� �����մϴ�.
               	<BR>
               	<img src="/image/common/icon_exclam_mark.gif" border="0"> �䱸�� ���縦 ���� ������ �䱸���� �ۼ��� �䱸�Կ��� Ȯ���Ͻ� �� �ֽ��ϴ�.
               	 <table>
               	   <tr>
               		 <td>
               		 	<%
               		 		String strJscript = "";
               		 		if(existFlag.equals("N")) strJscript = "javascript:deleteReqBox('"+objRsSH.getObject("REQ_BOX_ID")+"')";
               		 		else strJscript = "alert('���������� �亯 �ۼ��� ���� ���̹Ƿ� ������ �Ͻ� �� �����ϴ�.')";
               		 	%>
						  <img src="/image/button/bt_delReqBox.gif" OnClick="<%= strJscript %>" border="0" style="cursor:hand">
						<img src="/image/button/bt_copyReqBox.gif"  height="20" border="0" onClick="javascript:copyReqBox('<%=objRsSH.getObject("REQ_BOX_ID")%>')" style="cursor:hand" alt="���� �䱸���� ���纻 �䱸���� �����˴ϴ�.">
						<img src="/image/button/bt_reqBoxList.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
						<img src="/image/button/bt_viewReqDoc.gif" border="0" onClick="ReqDocOpenView('<%= (String)objParams.getParamValue("ReqBoxID") %>')" style="cursor:hand"  alt="�������� ���� �䱸��(PDF)�� Ȯ���մϴ�.">	
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
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>
										<td width="50" align="center"><%=SortingUtil.getSortLink("changeSortQuery","CMT_REQ_APP_FLAG",strReqInfoSortField,strReqInfoSortMtd,"����ȸ")%></td>
										<%
										}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td width="70" align="center">�亯</td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"����Ͻ�")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));
						  String strReqInfoID="";
						  String strCmtApplyValue = "Y";
						  while(objRs.next()){
						   	 strReqInfoID=(String)objRs.getObject("REQ_ID");
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
										int intTmpWidth2=500;
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										  intTmpWidth2=intTmpWidth2-50;
										}//endif�ǿ��ǼҼ�Ȯ��
										%>
										<td width="<%=intTmpWidth2%>" class="td_lmagin"><%=StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"),(String)objRs.getObject("REQ_STT"))%><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
										<%
										if(objUserInfo.getOrganGBNCode().equals("003")){//�ǿ��ǼҼ�
										%>
										<td width="50" align="center"><%=CodeConstants.getCmtRequestAppoint((String)objRs.getObject("CMT_REQ_APP_FLAG"))%></td>
										<%
										}//endif�ǿ��ǼҼ�Ȯ��
										%>										
										<td width="70" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
							</td>
						</tr>
    	                <tr class="tbl-line"> 
                      		<td height="1"></td>
                    	</tr>       	
                    	<input type="hidden" name="ReqID" value="<%= strReqInfoID %>">
                    	<input type="hidden" name="CmtApplys" value="<%=strCmtApplyValue%>">
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
                      		<td width="356" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
                      			<img src="/image/button/bt_copyReq.gif" height="20"  style="cursor:hand" onClick="copyMemReqInfo(formName);"  alt="���� �䱸�� ���纻�� ������ �䱸�Կ� �����մϴ�.">

                      			<!-- ����ȸ ���� ��û -->
                      			<% if(objRs.getRecordSize()>0 && (!objCmtSubmt.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) || !objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")))) { %>
	       							<img src="/image/button/bt_formalReqSelsct.gif" height="20"  style="cursor:hand" onClick="ApplyCmt(document.formName);"  alt="���õ� �䱸������ ����ȸ���Ƿ� ���������� ���������� ��û�Կ� �߰��մϴ�.">
                      			<% } %>
                      		</td>
							<td width="403" align="right" valign="middle">
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
