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
<%@ page import="nads.lib.reqsubmit.params.cmtsubmt.CmtSubmtReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqInfoDelegate" %>

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
	CmtSubmtReqBoxVListForm objParams =new CmtSubmtReqBoxVListForm();  
	objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester()));//�䱸�亯�ڿ��μ���
	
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
	  
	String strAuditYear = request.getParameter("AuditYear");


	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	CmtSubmtReqBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	CmtSubmtReqInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */
	ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;				/**�䱸 ��� */

	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new CmtSubmtReqBoxDelegate();
		/**�䱸�� �̿� ���� üũ */
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getOrganID()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
			objMsgBean.setStrMsg("�ش� ��û���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		} else {
			/** �䱸�� ���� */
			objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
			/**�䱸 ���� �븮�� New */    
			objReqInfo=new CmtSubmtReqInfoDelegate();
			objRs=new ResultSetHelper(objReqInfo.getRecordList(objParams)); 
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
<title><%=MenuConstants.REQ_BOK_COMM_REQ%> > <%=MenuConstants.REQ_BOX_COMM_REQ_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="javascript">
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }
  /**�䱸 �󼼺���� ����.*/
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RCommReqInfoView.jsp";
  	formName.submit();
  }
  
  /** ������� ���� */
  function gotoList(){
  	formName.action="./RCommReqList.jsp";
  	formName.submit();
  }
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }
  /** �䱸����������� ����. */
  function gotoRegReqInfo(){
  	formName.action="./RCommReqInfoWrite.jsp";
  	formName.submit();
  }

  /** ����ȸ �����û ���� */
  function sendCommReqReqDoc(strReqDocID,strCmtOrganID){
    if(confirm('����ȸ �����û���� �߼��Ͻðڽ��ϱ�?')){
    	var strPath="";
       if(confirm('���ڰ��縦 ���� �����û���� �߼��Ͻðڽ��ϱ�?\n��Ҹ� �����Ͻø� ��� �����û�� �Ϸ�˴ϴ�.')){
	  	 strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID;
  	   }else{
  	     strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID + '&RightNow=Yes';
  	   }
  	   //window.open(strPath, '', 'width=300,height=200, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	   NewWindow(strPath, '', '300', '200');
  	}
  }
  /** ����ȸ �����û�Ϸ� */
  function commitCommReqReqDoc(strReqDocID,strCmtOrganID){
    if(confirm('����ȸ �����û���� ����ȸ�� �ø��ðڽ��ϱ�??')){
       var strPath="";
  	   strPath='/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpCommit.jsp?ReqBoxID=' + strReqDocID + '&CmtOrganID=' + strCmtOrganID;
  	   window.open(strPath, '', 'width=300,height=200, scrollbars=no, resizable=yes, toolbar=no, menubar=no, location=no, directories=no, status=no');
  	}  
  }
  
  /** ����ȸ ���� ��û�� ���� */
  function gotoCommReqDeletePage(){
  	if(confirm("��ϵ� �䱸 ������ �ֽ��ϴ�. �ϰ� �����Ͻðڽ��ϱ�?")){
  		document.formName.action="./RCommReqDelProc.jsp";
	  	var blnCheckBoxFlag = false;  
		blnCheckBoxFlag = !blnCheckBoxFlag;
	 	for(i=0; i<document.formName.length; i++) {
	 		if(document.formName[i].type=='checkbox') {
		 		document.formName[i].checked = blnCheckBoxFlag;
			}
		}	
		document.formName.submit();
	}	
  }
</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
		    %>
		    <% 
		    	/**��� �˻��� �ʵ�� �ߺ��̱⿡ ��¾���.*/
		    	objParams.getFormElement("ReqInfoQryTerm").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    	objParams.getFormElement("ReqInfoQryField").setFormTagType(nads.lib.reqsubmit.form.FormElement.FORM_TAG_TYPE_SESSION);
		    %>
		    <%=objParams.getHiddenFormTags()%>
			<input type="hidden" name="ReturnUrl" value="<%=request.getRequestURI()%>"><!--�ǵ��ƿ� URL -->
              <tr> 
                <td height="23" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif">
                      		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                      		<span class="title"><%=MenuConstants.REQ_BOK_COMM_REQ%></span><strong>- ��û�� �󼼺���</strong>
                      </td>
                      <td width="16%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="49%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
                      		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
                      		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.getReqBoxGeneral(request)%> > <B><%=MenuConstants.REQ_BOK_COMM_REQ%></B>
                      </td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="text_s">
                		<!-------------------- ���� �������� ���� ���� ��� ------------------------>
                		��û�� �� ������ Ȯ���ϴ� ȭ���Դϴ�.
                </td>
              </tr>
              <tr> 
                <td height="5" align="left" class="soti_reqsubmit"></td>
              </tr>
              <tr> 
                <td height="30" align="left" class="soti_reqsubmit">
                	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  ��û�� ����
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
					  String strReqBoxStt=(String)objRsSH.getObject("STT");                    
					%>

					<tr> 
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û�Ը� </td>
                      <td width="580" colspan="3" class="td_lmagin">
                      	<B><%=objRsSH.getObject("CMT_SUBMT_REQ_BOX_NM")%></B>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
					
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �Ұ� ����ȸ </td>
                      <td colspan="3" class="td_lmagin">
                      	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
                      </td>
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>              
                    
                    <tr> 
                      <td height="25" width="100" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��ûȽ�� </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("CNT")%> ��°
                      </td>
                      <td width="100" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td height="25" width="240" class="td_lmagin">
                      	<%=CodeConstants.getCmtSubmtReqBoxStt((String)objRsSH.getObject("STT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �������� </td>
                      <td height="25" class="td_lmagin">
                      	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%> 
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û��� </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("REQ_ORGAN_NM")%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ��û�� </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("CMT_SUBMT_REQR_NM")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        ������� </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate2((String)objRsSH.getObject("CMT_SUBMT_REQ_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <%
                    /** ���� ����Ȱ�츸 �����.*/
                    if(StringUtil.isAssigned((String)objRsSH.getObject("APRV_DT"))){
                    %>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>
                    <tr> 
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �����ȣ </td>
                      <td height="25" class="td_lmagin">
                      	<%=(String)objRsSH.getObject("APRV_DOC_NO")%>
                      </td>
                      <td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        �������� </td>
                      <td height="25" class="td_lmagin">
                      	<%=StringUtil.getDate((String)objRsSH.getObject("APRV_DT"))%>
                      </td> 
                    </tr>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
                    </tr>                    
                    <%
                    }//endif
                    %>
                    <tr height="1" class="tbl-line"> 
                      <td height="1" colspan="4"></td>
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
						<%
							// 2005-09-26 kogaeng EDIT
							// �ۼ���(001), ��Ŵ��(002), ����ȸ�䱸����(009)
							if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)){
						%>
						  <%
							/** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
							if(objUserInfo.getUserID().equals((String)objRsSH.getObject("CMT_SUBMT_REQR_ID"))){
						  %>
						 <!-- ���� ��ư�� ���������� ������ �ʴ� ���, stylesheet����(*.css) ������ ������Ʈ �Ͻÿ�!!!!!!!! -->
						<!-- �䱸�� ���� BUTTON -->
						<img src="/image/button/bt_modifyAppBox.gif" border="0" onClick="javascript:gotoCommReqEditPage()" style="cursor:hand">
							<%
							  if(intTotalRecordCount > 0){//�����ı��� ������ ����.
							%>
						<!-- �䱸�� ���� BUTTON -->
						<img src="/image/button/bt_deleteAppBox.gif"  border="0" onClick="javascript:gotoCommReqDeletePage()" style="cursor:hand">
							<%
							  }//endif �����ı�.
							%>
						  <%
							}//endif
						  %>												
							<%
								// 2005-09-26 kogaeng EDIT
								// �ۼ���(001), ��Ŵ��(002), ����ȸ�䱸����(009)
								if(intTotalRecordCount>0 && (strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_009)) ){//�����ı��� ������ ������. �ۼ���,��Ŵ���϶���..
							%>
						<!-- ��û�� ������� ����  BUTTON -->

<SCRIPT language="VBScript">
Sub sendCommReqReqDoc2(strReqDocID, strCmtOrganID)
	dim a 
	dim strPath
		'a = MsgBox ("����ȸ �����û���� �߼��Ͻðڽ��ϱ�?"+chr(13)&chr(10)+"���� Ŭ���Ͻø� ���ڰ��縦 ���ؼ�"+chr(13)&chr(10)+"�ƴϿ��� Ŭ���Ͻø� ��� �߼۵Ǹ�"+chr(13)&chr(10)+"��Ҹ� Ŭ���Ͻø� �߼��� ��ҵ˴ϴ�.", 3, "����ȸ ���� ��û")
		a = MsgBox("����ȸ�����û���� ���ڰ��縦 ���Ͽ� �߼��Ͻðڽ��ϱ�?", 3, "����ȸ ���� ��û")
		if a = 6 Then
			'document.location.href="http://www.yahoo.co.kr"
			strPath="/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&AuditYear=<%= strAuditYear %>"
			window.open strPath, "", "width=300px, height=300px"
		Elseif a = 7 Then
			'document.location.href="http://www.naver.com"
			strPath = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&RightNow=Yes&AuditYear=<%= strAuditYear %>"
			window.open strPath, "", "width=300px, height=300px"
		Elseif a = 2 Then
		Else
		End if
End Sub
</SCRIPT>

<script language="javascript">
	function aaa(strReqDocID, strCmtOrganID) {
		if(confirm("����ȸ�� ���� ��û���� �߼� �Ͻðڽ��ϱ�?")) {
			var strPath = "/reqsubmit/10_mem/20_reqboxsh/40_commreq/RCommPopUpApply.jsp?ReqBoxID="+strReqDocID+"&CmtOrganID="+strCmtOrganID+"&RightNow=Yes&AuditYear=<%= strAuditYear %>";
			NewWindow(strPath, '', 300, 300);
		}
	}
</script>

						<img src="/image/button/bt_applyCommitteeSubmit.gif"  border="0" onClick="aaa('<%= (String)objParams.getParamValue("ReqBoxID") %>','<%=(String)objRsSH.getObject("CMT_ORGAN_ID")%>')" style="cursor:hand">
							<%
							  }//endif �����ı�.
							%>
					    <%	
							}//end if
						%>
						<!-- 2005-05-30 ������ �Ҽ� �ǿ����� ������� ���������� ����� ���� �д� -->
						<%
							//if(objUserInfo.getIsMyCmtOrganID("GI00004773")) {
							if(objReqBox.checkCmtOrganMakeAutoSche((String)objRsSH.getObject("CMT_ORGAN_ID")) 
							&& objUserInfo.getIsMyCmtOrganID((String)objRsSH.getObject("CMT_ORGAN_ID")) 
							&& strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_003) 
							&& objUserInfo.getUserID().equals((String)objRsSH.getObject("CMT_SUBMT_REQR_ID"))) {
						%>
						<img src="/image/button/bt_commitCommitteeSubmit.gif"  border="0" onClick="javascript:commitCommReqReqDoc('<%= (String)objParams.getParamValue("ReqBoxID") %>','<%=(String)objRsSH.getObject("CMT_ORGAN_ID")%>')" style="cursor:hand">
						<%
						 	}
						%>						
						<!-- ��û�� ��� -->
						<img src="/image/button/bt_appBoxList.gif"  border="0" onClick="javascript:gotoList()" style="cursor:hand">
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
										<td height="22" width="10" align="center"><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
										<td width="19" align="center">NO</td>
										<td width="400" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
										<td width="170" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqInfoSortField,strReqInfoSortMtd,"������")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strReqInfoSortField,strReqInfoSortMtd,"�������")%></td>
										<td width="80" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"�������")%></td>
									</tr>
	                    		</table>
	                    	</td>
	                    </tr>
                	    <tr> 
                    	  	<td height="1" class="td_reqsubmit"></td>
                    	</tr>
						<%
						  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")));						
						  //int intRecordNumber= (intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqInfoPageSize")) +1;
						  String strReqInfoID="";
						  while(objRs.next()){
						   	 strReqInfoID=(String)objRs.getObject("CMT_SUBMT_REQ_ID");
						 %>								
						<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
							<td>
								<table width="759" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td height="22" width="10" align="center"><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
										<td width="29" align="center"><%=intRecordNumber%></td>
										<td width="400" class="td_lmagin"><a href="JavaScript:gotoDetail('<%=strReqInfoID%>');" hint="<%= (String)objRs.getObject("REQ_DTL_CONT") %>"><%=StringUtil.substring((String)objRs.getObject("REQ_CONT"),35)%></a></td>
										<td width="170" align="left"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
										<td width="80" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
										<td width="70" align="right" style="padding-top:2px;padding-bottom:2px;padding-right:4px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
									</tr>
								</table>
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
                      		<td width="356" height="40">
                      			<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
						<%//��û�Ի��°� �ۼ����϶��� ��������.
						if(strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_001) || strReqBoxStt.equals(CodeConstants.CMT_SUBMT_REQ_BOX_STT_002) ){
						%>                      			
                      			<img src="/image/button/bt_registerReq.gif" height="20"  style="cursor:hand" onClick="gotoRegReqInfo();">
                      			<%
                      			if(objRs.getRecordSize()<=0){/**�䱸�����������츸 ���*/
                      			%>
                      			<img src="/image/button/bt_delReq.gif" height="20"  style="cursor:hand" onClick="delCommReqInfos(formName);">                      			
                      			<%
                      			}//endif 
                      			%>
                      	<%
                      	}//endif
                      	%>
                      		</td>
							<td width="403" align="right" valign="middle">
							<%
								String strReqInfoQryField=(String)objParams.getParamValue("ReqInfoQryField");
							%>
								<select name="ReqInfoQryField" class="select">
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
									<option <%=(strReqInfoQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
								</select>
								<input type="text" class="textfield" name="ReqInfoQryTerm" value="<%=objParams.getParamValue("ReqInfoQryTerm")%>">
								<img src="/image/common/bt_search_table.gif" height="18" align="absmiddle" onClick="formName.submit();" style="cursor:hand">
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
