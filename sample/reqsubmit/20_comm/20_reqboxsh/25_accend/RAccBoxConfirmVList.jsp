<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxVListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>

<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	/**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
	RCommReqBoxVListForm objParams =new RCommReqBoxVListForm();  
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
	blnParamCheck=objParams.validateParams(request);
	if(blnParamCheck==false){
	  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  		objMsgBean.setStrCode("DSPARAM-0000");
	  	objMsgBean.setStrMsg(objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}//endif

	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 
	String strUserId = objUserInfo.getUserID(); 
	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
	CommRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	CommRequestInfoDelegate  objReqInfo=null;		/** �䱸���� Delegate */
	ResultSetSingleHelper objRsSH=null;			/** �䱸�� �󼼺��� ���� */
	ResultSetHelper objRs=null;					/**�䱸 ��� */
	ResultSetHelper objRsHST=null;
	
	try{
		objReqBox=new CommRequestBoxDelegate();
		boolean blnHashAuth=objReqBox.checkReqBoxAuth((String)objParams.getParamValue("ReqBoxID"),objUserInfo.getCurrentCMTList()).booleanValue();
		if(!blnHashAuth){
			objMsgBean.setMsgType(MessageBean.TYPE_WARN);
			objMsgBean.setStrCode("DSAUTH-0001");
	  		objMsgBean.setStrMsg("�ش� �䱸���� �� ������ �����ϴ�.");
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		}
	
	    objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));
   		/**�䱸 ���� �븮�� New */    
    	objReqInfo=new CommRequestInfoDelegate();
    	objRs=new ResultSetHelper((Hashtable)objReqInfo.getRecordList(objParams));
		objRsHST = new ResultSetHelper(cmtmanagerCn.getCmtManagerHistoy((String)objParams.getParamValue("ReqBoxID")));
	}catch(AppException objAppEx){
	 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}

	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();	
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_DETAIL_VIEW%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  //�䱸�� �������� ����.
  function gotoEdit(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxEdit.jsp?IngStt=002&ReqBoxStt=011";
  	form.target = "";
  	form.submit();		
  }

  //�䱸�� ������ ����.
  function gotoDelete(strReqBoxID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;

  	if(<%=objRs.getRecordSize()%> >0){
		if(confirm("��ϵ� �䱸������ �ֽ��ϴ�. \n\n�䱸���� �����Ǹ� ��ϵ� �䱸������ �Բ� ���� �˴ϴ�. \n\n�׷��� �����Ͻðڽ��ϱ�? ")){
	  		var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
	 	}
  	 	return;
  	} else {
		if(confirm(" �䱸���� �����Ͻðڽ��ϱ�? ")){
		  	var winl = (screen.width - 300) / 2;
			var winh = (screen.height - 240) / 2;
			form.target = "popwin";
			form.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc.jsp";
			window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			form.submit();
		}
		return;
  	}
  }

  //�䱸 �󼼺���� ����.
  function gotoDetail(strReqBoxID, strCommReqID){
    form=document.formName;
  	form.ReqBoxID.value=strReqBoxID;
  	form.CommReqID.value=strCommReqID;
  	form.action="./RAccReqConfirmInfo.jsp";
  	form.target = "";
  	form.submit();
  }  

  /** ������� ���� */
  function gotoList(){
  	form=document.formName;
  	form.action="./RAccBoxConfirmList.jsp";
  	form.submit();
  	form.target = "";
  }

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	form=document.formName;
  	form.CommReqInfoSortField.value=sortField;
  	form.CommReqInfoSortMtd.value=sortMethod;
  	form.target = "";
  	form.submit();
  }  

  /** �䱸����������� ����. */
  function gotoReqInfo(){
  	var form = document.formName;
  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommReqInfoWrite.jsp?IngStt=002";
  	form.target = "";
  	form.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	form=document.formName;
  	form.CommReqInfoPage.value=strPage;
  	form.target = "";
  	form.submit();
  } 
</script>
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

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
	<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %>
	<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
	<SCRIPT language="JavaScript" src="/js/reqsubmit/reqboxview.js"></SCRIPT>
	</td>
<!------- 2004-06-02 ������ �������� ���� ����� �κ� ���� ------->
	<td width="100%">
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
<form name="formName" method="post" action="<%=request.getRequestURI()%>">
		<%  //�䱸�� ���� ���� �ޱ�.
			String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
			String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
			//�䱸�� ������ ��ȣ �ޱ�.
			String strCommReqBoxPagNum=objParams.getParamValue("CommReqBoxPageNum");
			//�䱸�� ��ȸ���� �ޱ�.
			String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
			String strCommReqBoxQryTerm=objParams.getParamValue("CommReqBoxQryTerm");

			//�䱸 ���� ���� ���� �ޱ�.
			String strCommReqInfoSortField=objParams.getParamValue("CommReqInfoSortField");
			String strCommReqInfoSortMtd=objParams.getParamValue("CommReqInfoSortMtd");

			//�䱸�� ���� ������ ��ȣ �ޱ�.
			String strCommReqInfoPagNum=objParams.getParamValue("CommReqInfoPageNum");					
		%>
	    <input type="hidden" name="ReqBoxID" value="<%=objParams.getParamValue("ReqBoxID")%>">
	    <input type="hidden" name="CmtOrganID" value="<%=objParams.getParamValue("CmtOrganID")%>">
   		<input type="hidden" name="AuditYear" value="<%=objParams.getParamValue("AuditYear")%>">
	    <input type="hidden" name="IngStt" value="">
	    <input type="hidden" name="ReqBoxNm" value="<%=objRsSH.getObject("REQ_BOX_NM")%>">	    
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=strCommReqBoxPagNum%>"><!--�䱸�� ������ ��ȣ -->
		<input type="hidden" name="CommReqBoxQryField" value="<%=strCommReqBoxQryField%>">
		<input type="hidden" name="CommReqBoxQryTerm" value="<%=strCommReqBoxQryTerm%>">
		<input type="hidden" name="CommReqInfoSortField" value="<%=strCommReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
		<input type="hidden" name="CommReqInfoSortMtd" value="<%=strCommReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
		<input type="hidden" name="CommReqInfoPage" value="<%=strCommReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
		<input type="hidden" name="CommReqID" value=""><!--�䱸���� ID-->
		<input type="hidden" name="ReturnURL" value="<%=request.getRequestURI()%>">
		<input type="hidden" name="DelURL" value="/reqsubmit/20_comm/20_reqboxsh/25_accend/RAccBoxConfirmList.jsp">
		<input type="hidden" name="RltdDuty" value="<%=objParams.getParamValue("RltdDuty")%>">		

		<tr> 
			<td align="left" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" height="23px">
			</tr>
            <tr> 
				<td width="35%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
		    		<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
		      		<span class="title"><%=MenuConstants.COMM_MNG_CONFIRM_END%></span> <strong>- �䱸�� �󼼺���</strong>
              	</td>
              	<td width="10%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
              	<td width="55%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
              		<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
              		<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
					<%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%=MenuConstants.COMM_MNG_CONFIRM_END%></B>
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
				String strIngStt=(String)objRsSH.getObject("ING_STT");
			%>
   
			<tr> 
				<td width="110" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�䱸�Ը� </td>
				<td width="570" height="25" colspan="3" class="td_lmagin"><B><%=objRsSH.getObject("REQ_BOX_NM")%></B>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
            
            <tr> 
            	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				���� �䱸 ����</td>
				<td height="25" colspan="3" class="td_lmagin"><%=StringUtil.getDate((String)objRsSH.getObject("ACPT_BGN_DT"))%> ���� <%=StringUtil.getDate((String)objRsSH.getObject("ACPT_END_DT"))%> ������ �䱸 ���� �Ⱓ�� �����Ǿ����ϴ�.
				</td>
            </tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
            
			<tr> 
				<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�������� </td>
				<td height="25" colspan="3" class="td_lmagin">
               	<%=objCdinfo.getRelatedDuty((String)objRsSH.getObject("RLTD_DUTY"))%>
				</td>
			</tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>   
            <tr> 
              	<td width="110" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                �䱸��� </td>
              	<td width="230" height="25" class="td_lmagin">
           	   	<%=objRsSH.getObject("CMT_ORGAN_NM")%>
              	</td>
              	<td width="110" height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                ������ </td>
              	<td width="230" height="25" class="td_lmagin">
              	<%=(String)objRsSH.getObject("SUBMT_ORGAN_NM")%>
              	</td> 
            </tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
            
            <tr> 
              	<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
                ������� </td>
              	<td height="25" class="td_lmagin" colspan="3">
              	<%=StringUtil.getDate((String)objRsSH.getObject("SUBMT_DLN"))%> ���� �亯 ������ ��û�մϴ�.
              	</td>
	        </tr>
            <tr height="1" class="tbl-line"> 
              	<td height="1" colspan="4"></td>
            </tr>
			<tr> 
				<td height="25" class="td_gray1"><img src="/image/common/icon_nemo_gray.gif" width="3" height="6"> 
				�䱸�Լ��� </td>
			  	<td height="25" colspan="3" class="td_lmagin">
			  	<%=StringUtil.getDescString((String)objRsSH.getObject("REQ_BOX_DSC"))%>
			  	</td>
			</tr>
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
			<td height="30" align="left" class="soti_reqsubmit">
	        	<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
	        	<img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
                  ����Ȯ�� ����
			</td>
		</tr>
		<tr> 
			<td align="left" valign="top" class="soti_reqsubmit">
				<table width="680" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td height="1" class="td_reqsubmit" colspan="5"></td>
				</tr>
				<tr class="td_top" height="20">
					<td width="80" align="center">����</td>
					<td width="200" align="center">Ȯ��������</td>
					<td width="120" align="center">Ȯ�νð�</td>
					<td width="280" align="center">�������</td>
				</tr>
           	    <tr> 
					<td height="1" class="td_reqsubmit" colspan="4"></td>
				</tr>
				<%if(objRsHST.getRecordSize() != 0){%>
					<%while(objRsHST.next()){%>
					<tr height="20">
						<td width="80" align="center">
							<% 
								if(!StringUtil.isAssigned((String)objRsHST.getObject("DESCRIPTION"))) out.println("[����]");
								else out.println("[�ݷ�]");
							%>
						</td>
						<td width="200" align="left">&nbsp;&nbsp;<%=objRsHST.getObject("ORGAN_NM")%>(<%=objRsHST.getObject("USER_NM")%>)</td>
						<td width="120" align="center"><%=objRsHST.getObject("REG_DATE")%></td>
						<td width="280" style="padding-left:4px"><%=objRsHST.getObject("DESCRIPTION")%></td>
					</tr>
					<tr height="1" class="tbl-line"> 
						<td height="1" colspan="4"></td>
					</tr>
					<%}%>
				<%}else{%>
					<tr height="20">
						<td width="680" align="center" colspan="4">&nbsp</td>
					</tr>
				<%}%>
				<tr height="1" class="tbl-line"> 
					<td height="1" colspan="4"></td>
				</tr>
				</table>
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
       	 	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				<%
					/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
					if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
				%>
						<!-- �䱸�� ���� BUTTON -->
						<img src="/image/button/bt_modifyReqBox.gif" border="0" onClick="gotoEdit('<%=objRsSH.getObject("REQ_BOX_ID")%>')" style="cursor:hand">	    	      		
						<!-- �䱸�� ���� BUTTON -->
	    	      		<img src="/image/button/bt_delReqBox.gif"  height="20" border="0" onClick="gotoDelete('<%=objRsSH.getObject("REQ_BOX_ID")%>')" style="cursor:hand">
				<% 
					}
				%>
				<!-- �䱸�� ��� -->
				<img src="/image/button/bt_reqBoxList.gif"  height="20" border="0" onClick="gotoList()" style="cursor:hand">
				
				<% if (objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004") && intTotalRecordCount > 0) { %>
						<!-- �䱸�� �̸����� BUTTON -->
						<img src="/image/button/bt_previewReq2.gif" border="0" onClick="PreReqDocView(formName,'<%=objRsSH.getObject("REQ_BOX_ID")%>','002');" style="cursor:hand" alt="���������� �߼��� �䱸��(PDF)�� �̸� Ȯ���մϴ�.">					 

						<!-- �䱸�� �߼� -->
						<img src="/image/button/bt_sendReq.gif" style="cursor:hand" onClick="javascript:sendReqDoc('<%=CodeConstants.REQ_DOC_TYPE_002%>', '<%=objParams.getParamValue("ReqBoxID")%>')" alt="�ۼ��� �䱸���� ���������� �߼��մϴ�.">
				<% } %>
				
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
				</td>
	            <td width="259" align="right" valign="bottom" class="text_s">
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
        	<tr align="center">
        		<td>
        		<table width="759" border="0" cellspacing="0" cellpadding="0">
				<tr class="td_top">
					<td width="19" align="center" height="22">NO</td>
					<td width="345" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REQ_CONT",strCommReqInfoSortField,strCommReqInfoSortMtd,"�䱸����")%></td>
					<td width="210" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OLD_REQ_ORGAN_NM",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û���")%></td>
					<td width="120" align="center"><%=SortingUtil.getSortLink("changeSortQuery","OPEN_CL",strCommReqInfoSortField,strCommReqInfoSortMtd,"�������")%></td>
					<td width="65" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqInfoSortField,strCommReqInfoSortMtd,"��û��")%></td>
					</tr>
           	    <tr> 
					<td height="1" class="td_reqsubmit" colspan="5"></td>
				</tr>
				<%
				int intRecordNumber= intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("CommReqInfoPageSize")));
				String strReqInfoID="";
				if(objRs.getRecordSize()>0){
					while(objRs.next()){
						strReqInfoID=(String)objRs.getObject("REQ_ID");
					%>								
					<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
						<td align="center" height="20"><%=intRecordNumber%></td>
						<td class="td_lmagin">&nbsp;&nbsp;<%= StringUtil.getNotifyImg((String)objRs.getObject("REG_DT"), (String)objRs.getObject("REQ_STT")) %><a href="javascript:gotoDetail('<%=objRsSH.getObject("REQ_BOX_ID")%>','<%=objRs.getObject("REQ_ID")%>')" hint="<%= StringUtil.substring((String)objRs.getObject("REQ_DTL_CONT"), 80) %>"><%=objRs.getObject("REQ_CONT")%></a></td>
						<td align="center"><%=objRs.getObject("OLD_REQ_ORGAN_NM")%></td>
						<td class="td_lmagin" align="center"><%=CodeConstants.getOpenClass((String)objRs.getObject("OPEN_CL"))%></td>
						<td align="right" style="padding-top:2px;padding-bottom:2px"><%=StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
					</tr>
		            <tr class="tbl-line"> 
		            	<td height="1" colspan="5"></td>
					</tr>
					<%
					intRecordNumber--;
					}//endwhile
				} else {
				%>
					<tr>
						<td colspan="5" height="35" align="center">��ϵ� �䱸������ �����ϴ�.</td>
					</tr>
		            <tr class="tbl-line"> 
		            	<td height="1" colspan="5"></td>
					</tr>					
				<%
				}//endif
				%>
	            <tr class="tbl-line"> 
	            	<td height="1" colspan="5"></td>
				</tr>
				</table>

				<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� �� ------------------------->
				</td>
			</tr>
			<tr> 
            	<td height="35" align="center">
               	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
				<%=	PageCount.getLinkedString(
						new Integer(intTotalRecordCount).toString(),
						new Integer(intCurrentPageNum).toString(),
						objParams.getParamValue("CommReqInfoPageSize"))
					    //����¡ ��� ����.
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
					<%
					/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
					if(objUserInfo.getOrganGBNCode().equals("004")  && !strReqSubmitFlag.equals("004")){
						//if(objRsSH.getObject("REQ_BOX_STT").equals("002") || objRsSH.getObject("REQ_BOX_STT").equals("005")){
						%>
						<img src="/image/button/bt_registerReq.gif" height="20"  style="cursor:hand" onClick="gotoReqInfo();">
						<% //}
				 	} %>
					</td>
					<td width="403" align="right" valign="middle">
					<%
					String strCommReqInfoQryField=(String)objParams.getParamValue("CommReqInfoQryField");
					%>
					<select name="CommReqInfoQryField" class="select">
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_cont"))? " selected ": ""%>value="req_cont">�䱸����</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("req_dtl_cont"))? " selected ": ""%>value="req_dtl_cont">�䱸����</option>
					<option <%=(strCommReqInfoQryField.equalsIgnoreCase("old_req_organ_nm"))? " selected ": ""%>value="old_req_organ_nm">�䱸���</option>					
					</select>
					<input type="text" name="CommReqInfoQryTerm" value="<%=objParams.getParamValue("CommReqInfoQryTerm")%>">
					<input type="button" name="Query" value="��ȸ" onClick="formName.submit()">
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
        	<td height="35px"></td>
        </tr>
		</table>
		<!--------------------------------------- �������  MAIN WORK AREA ���� �ڵ��� ���Դϴ�. ----------------------------->      
    	</td>
  	</tr>
	</table>
	</td>
</tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>