<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RCommReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.CommRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtmanager.CmtManagerConfirmDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<% 
	/*************************************************************************************************/
	/** 	name : RCommReqBoxList.jsp																  */
	/** 		   ����ȸ �䱸�� ����� ����Ѵ�.													  */
	/** 		   �䱸������ �ִ� �Ҽ� ����ȸ�� ����� ����Ѵ�.										  */
	/*************************************************************************************************/
	//�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
	String strReqSubmitFlag = objUserInfo.getReqSubmitFlag(); 
  
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strReqScheID="";			 /**����ȸ �䱸����ID*/
	String strRltdDuty=null; 			 /**���õ� �������� */
	String strUserId = objUserInfo.getUserID(); 
	int FLAG = -1;

	/**����ȸ�����ȸ�� �Ķ���� ����.*/
	RCommReqBoxListForm objParams=new RCommReqBoxListForm();
	//�䱸��� ���� :: �Ҽ� ���.
	objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
	//����ȸ �䱸����������� : �����Ϸ�
	objParams.setParamValue("IngStt",CodeConstants.REQ_ING_STT_002);
	//�䱸�� ���� : �����Ϸ�
	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_002);
 
	/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
	if(objUserInfo.getOrganGBNCode().equals("004")){
		objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
	}

	//�ش�����ȸ�� �������.. �����޼��� ���..
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
	}

	String strReqOrganID = "";
	
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
	}
  
	strSelectedAuditYear= objParams.getParamValue("AuditYear"); 	/**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
	strRltdDuty=objParams.getParamValue("RltdDuty") ; 

	//�䱸�� ��ü ��Delegate �����.
	CommRequestBoxDelegate objReqBox = null;
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRs=null;			/** ����ȸ �䱸�� ��� */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	CmtManagerConfirmDelegate cmtmanagerCn = new CmtManagerConfirmDelegate();
	
	ResultSetHelper objReqOrganRS = null;				/** ����ȸ�� �ǿ��� ��� */	
	String strCmtOpenCl = "";

 
	try{
		if(objUserInfo.getOrganGBNCode().equals("004") && !strReqSubmitFlag.equals("004")){
			
		}else{
			if((StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"))).equals("")){
				String strSelfOrganID = (String)objUserInfo.getOrganID();
				objParams.setParamValue("ReqOrganIDZ",strSelfOrganID);
			}				
		}
		strReqOrganID = StringUtil.getEmptyIfNull(objParams.getParamValue("ReqOrganIDZ"));
 
	 	objReqBox=new CommRequestBoxDelegate();
	
		//�ش�����ȸ�� �������.. 
		if(objUserInfo.getCurrentCMTList().isEmpty()){
			List lst = objUserInfo.getCurrentCMTList();
			Hashtable objHash = new Hashtable();
			objHash.put("ORGAN_ID", "XXXXXXXXXX"); 	
			objHash.put("ORGAN_NM", "XXXXXXXXXX"); 	
			lst.add(objHash);

			objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,CodeConstants.REQ_ING_STT_001,CodeConstants.REQ_BOX_STT_001));   
		} else { 	
	 		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),CodeConstants.REQ_ING_STT_002,CodeConstants.REQ_BOX_STT_002));   
		}

		//���¿� ���� ��� List���..
		if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){
 			strSelectedAuditYear =(String)objCmtRs.getObject("AUDIT_YEAR");
 			strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	    	objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
	    	objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID); 		
   			if(!StringUtil.isAssigned(strSelectedCmtOrganID)){
				objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
			}
   		} else if(!StringUtil.isAssigned(strSelectedAuditYear)) {
   			strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    	objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
   		}


   		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
   		//�䱸�� ���
		objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
	   	//����ȸ����ID
	   	strReqScheID = objReqBox.getReqScheID(strSelectedAuditYear, strSelectedCmtOrganID, CodeConstants.REQ_ING_STT_002, CodeConstants.REQ_BOX_STT_002);
		FLAG = cmtmanagerCn.getFLAG((String)objParams.getParamValue("CmtOrganID"));
		//����ȸ�䱸�ڷ�������������2006-09-20
		strCmtOpenCl = cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID")) == null ? "" : cmtmanagerCn.getOpenCl((String)objParams.getParamValue("CmtOrganID"));
		
		objReqOrganRS = new ResultSetHelper(objReqBox.getCmtReqOrganList(strSelectedCmtOrganID));
		
	} catch(AppException objAppEx) {
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
 
	String strRsCmt = (String)objCmtRs.getObject("CMT_ORGAN_ID");
	 
	//�䱸�� �����ȸ�� ��� ��ȯ.
	int intTotalRecordCount=objRs.getTotalRecordCount();
	int intCurrentPageNum=objRs.getPageNumber();
	int intTotalPage=objRs.getTotalPageCount();
%>

<html>
<head>
<title><%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.COMM_REQ_BOX_MAKE_END%></title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">
 <%
 	//�޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
    out.println("var varSelectedCmt='" + strSelectedCmtOrganID + "';");
	out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" + i + "]=new Array('" 
			+ strTmpYear	+ "','" + objCmtRs.getObject("CMT_ORGAN_ID") + "','" + objCmtRs.getObject("CMT_ORGAN_NM") + "');");
		if(!strTmpYear.equals(strOldYear)){
			vectorYear.add(strTmpYear);
		}
		strOldYear=strTmpYear;	
	}
	 out.println("var arrYear=new Array(" + vectorYear.size() + ");");
	 for(int i=0;i<vectorYear.size();i++){
	   out.println("arrYear[" + i + "]= new Array('" + (String)vectorYear.get(i)+ "');");
	 }
  %>
   
  /** ����ȸ ���� �ʱ�ȭ */
  function init(){
	var field=listqry.AuditYear;
	for(var i=0;i<arrYear.length;i++){
	   var tmpOpt=new Option();
	   tmpOpt.text=arrYear[i];
	   tmpOpt.value=tmpOpt.text;
	   if(varSelectedYear==tmpOpt.text){
	     tmpOpt.selected=true;
	   }
	   field.add(tmpOpt);
	}
	makePerYearCmtList(field.options[field.selectedIndex].value);
  }//end of func

  /** ������ ����ȸ ����Ʈ �ʱ�ȭ */
  function makePerYearCmtList(strYear){
       	var field=listqry.CmtOrganID;
       	field.length=0;
	for(var i=0;i<arrPerYearCmt.length;i++){
	   var strTmpYear=arrPerYearCmt[i][0];
	   if(strYear==strTmpYear){
		   var tmpOpt=new Option();
		   tmpOpt.value=arrPerYearCmt[i][1];
		   tmpOpt.text=arrPerYearCmt[i][2];
		   if(varSelectedCmt==tmpOpt.value){
		     tmpOpt.selected=true;
		   }
		   field.add(tmpOpt);	
	   }
	}
  }//end of func

  /** ���� ��ȭ�� ���� ����ȸ ����Ʈ ��ȭ */
  function changeCmtList(){
    makePerYearCmtList(listqry.AuditYear.options[listqry.AuditYear.selectedIndex].value);
  }//end of func

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	listqry.CommReqBoxSortField.value=sortField;
  	listqry.CommReqBoxSortMtd.value=sortMethod;
  	listqry.target = "";
  	listqry.submit();
  }

  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	listqry.action="./RAccBoxVList.jsp?ReqBoxID="+strID;
  	listqry.target = "";
  	listqry.submit();
  }

  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	listqry.CommReqBoxPage.value=strPage;
  	listqry.target = "";
  	listqry.submit();
  }

  /** �䱸�� ���� �ٷΰ��� */
  function gotoMake(strReqScheID,strIngStt){
    form=document.listqry;
	if(<%= strRsCmt.equals("")%>){
		alert("����ȸ �䱸 ������ �����ϴ�.");
	} else {
	  	form.ReqScheID.value=strReqScheID;
	  	form.action="/reqsubmit/20_comm/20_reqboxsh/RCommNewBoxMake.jsp?IngStt="+strIngStt;
	  	listqry.target = "";
	  	form.submit();
  	}
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	listqry.CommReqBoxQryField.value="";
  	listqry.CommReqBoxQryTerm.value="";
  	listqry.CommReqBoxSortField.value="";
  	listqry.CommReqBoxSortMtd.value="";
  	listqry.CommReqBoxPage.value="";
  	listqry.target = "";
  	listqry.submit();
  }
  
  var IsClick=false;

	// 2005-10-04 ���� �䱸�� ��� ȭ�� 
	function openReqBoxPopup(){
		if(!IsClick){
			var f = document.listqry;
			var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp?ReqBoxTp=002";
			f.action = url;
			f.target = "POPUP";
			NewWindow('/blank.html', 'POPUP', 800, 700);
			f.submit();
		
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}		
	}

	

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


	
	// 2005-07-13 �䱸�� �ϰ� �߼�
	function sendReqDoc() {
		if(!IsClick){
			if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
				alert("�߼��Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}

	  	
	  	if(confirm("�����Ͻ� �䱸���� �ش� ���������� �ϰ� �߼��Ͻðڽ��ϱ�?\n\r\n\r***** Ȯ�ιٶ��ϴ� *****\n\r1. �ش����� ��ǥ ����ڰ� ���� ���� �߼۵��� �ʽ��ϴ�.\n\r2. ���ڹ��� �ý��� ������ �Ͻ÷��� ����, ���������� �߼� �ٶ��ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.listqry.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp?ReqOrganID=<%= objUserInfo.getOrganID() %>";
			document.listqry.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.listqry.submit();
	  	}
	}
	
	// 2005-10-06 kogaeng ADD
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.listqry, "ReqBoxID") < 1) {
				alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ֽñ� �ٶ��ϴ�.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}
		
		if(confirm("�䱸���� �����Ͻø� ���Ե� �䱸 ����鵵 �ϰ� �����˴ϴ�.\n\r\n\r�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			document.listqry.target = "processingFrame";
			document.listqry.action = "/reqsubmit/20_comm/20_reqboxsh/RCommReqBoxDelProc.jsp";
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
			document.listqry.submit();
		}
	}
	
	// ��ȸ �ɼǿ� ���� Form submit �� ����
	function doListRefresh() {
		var f = document.listqry;
		f.target = "";
		f.submit();
	}  
</script>
</head>
<body  leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init()">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>

<%@ include file="/reqsubmit/common/MenuTopReqsubmit.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align="left" valign="top">
	<td width="186" height="470" background="/image/common/bg_leftMenu.gif">
	<%
	%>
	<%@ include file="/reqsubmit/common/MenuLeftReqsubmit.jsp" %></td>
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
<form name="listqry" method="post" action="<%=request.getRequestURI()%>">
		<%//���� ���� �ޱ�.
			String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
			String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
		%>
		<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>">	<!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="CommReqBoxPage" value="<%=intCurrentPageNum%>">			<!--������ ��ȣ -->
		<input type="hidden" name="ReqScheID" value="<%= strReqScheID %>">		<!--����ȸ ����ID -->
		
		<!-- 2005-07-18 �䱸�� �߼��� ���� �⺻ ���� -->
		<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_002 %>">
		<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_010 %>">
		<input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
		<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
		<input type="hidden" name="DelURL" value="<%= request.getRequestURI() %>">
		<input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
		<input type="hidden" name="OpenCl" value="<%=strCmtOpenCl%>">
		
		</tr>
        <tr> 
        	<td align="left" valign="top">
        	<table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" height="23px">
			</tr>
            <tr> 
            	<td width="30%" background="/image/reqsubmit/bg_reqsubmit_tit.gif" height="23">
                	<!-------------------- Ÿ��Ʋ�� �Է��� �ּ��� ------------------------>
                	<span class="title"><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></span> <strong>- �䱸�� ���</strong>
                </td>
                <td width="15%" align="left" background="/image/common/bg_titLine.gif">&nbsp;</td>
                <td width="55%" align="right" background="/image/common/bg_titLine.gif" class="text_s">
				<!-------------------- ���� ��ġ ������ ����Ѵ�ϴ�. ------------------------>
					<img src="/image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                    <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <B><%= (FLAG > 1)?MenuConstants.COMM_MNG_CHECK:MenuConstants.COMM_REQ_BOX_MAKE_END %></B>
                </td>
			</tr>
			</table></td>
		</tr>
		<tr> 
			<td height="30" align="left" class="text_s">
            <!-------------------- ���� �������� ���� ���� ��� ------------------------>
            ���� �Ϸ�� ����ȸ �䱸�� ����� Ȯ���Ͻ� �� �ֽ��ϴ�.
			</td>
		</tr>
		
		<!---------------------------------------------------------------------- �����ǵ� ��ȸ ���� ���� ���� ------------------------------------------------------------------------>
              <tr> 
                <td height="2"></td>
              </tr>
              <tr>
              	<td width="759">
              		<table border="0" cellpadding="0" cellspacing="0">
              			<tr>
              				<td width="6" height="53"><img src="/image/reqsubmit/searchTableLeft.jpg" border="0"></td>
              				<td width="746" height="53" background="/image/reqsubmit/searchTableBg.jpg">
              					<table border="0" cellpadding="0" cellspacing="0" width="746">
              						<tr>
              							<td width="200" height="24"><img src="/image/reqsubmit/searchTableTop2.jpg" border="0"></td>
              							<td width="546" align="right" valign="bottom">
              								&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3" height="6" align="absmiddle">
											��ü �ڷ� �� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage+1%> Page)
              							</td>
              						</tr>
									<tr>
										<td height="29" colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr><td style="padding-left:25px">
													<select name="AuditYear" onChange="changeCmtList()" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
					                				<select name="CmtOrganID" class="select_reqsubmit" onChange="javascript:doListRefresh()"></select>
					                				<select name="ReqOrganIDZ" class="select_reqsubmit" onChange="javascript:doListRefresh()">
														<option value="00">:::: �ǿ��Ǻ� ��ȸ ::::</option>
														<%
															if(StringUtil.isAssigned(strSelectedCmtOrganID)) {
																String strSelected = "";
																if(strSelectedCmtOrganID.equalsIgnoreCase(strReqOrganID)) strSelected = " selected";
																else strSelected = "";
														%>
																<option value="<%= strSelectedCmtOrganID %>" <%= strSelected %>>:::: ����ȸ ��ü ���� ::::</option>
														<%
																if(objReqOrganRS.getTotalRecordCount() > 0) {
																	while(objReqOrganRS.next()) {
																		if(strReqOrganID.equalsIgnoreCase((String)objReqOrganRS.getObject("ORGAN_ID"))) {
																			strSelected = " selected";
																		} else {
																			strSelected = "";
																		}
																		out.println("<option value='"+(String)objReqOrganRS.getObject("ORGAN_ID")+"' "+strSelected+">"+(String)objReqOrganRS.getObject("ORGAN_NM")+"</option>");
																	}
																}
															} else {
																out.println("<option value=''>:::: ����ȸ�� ���� ������ �ּ��� ::::</option>");
															}
														%>
													</select>
													<select name="RltdDuty"  class="select_reqsubmit" onChange="javascript:doListRefresh()">
														<option value="">��������(��ü)</option>
														<%
														   /**�������� ����Ʈ ��� */
														   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
														   		String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
														   		out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
														   }
														%>													
													</select>
												</td>
												<td>&nbsp;&nbsp;<img src="/image/button/bt_inquiry.gif" height="20"  style="cursor:hand" onClick="gotoHeadQuery();"></td>
												</tr>
											</table>
										</td>
									</tr>
              					</table>
              				</td>
              				<td width="7" height="53"><img src="/image/reqsubmit/searchTableRight.jpg" border="0"></td>
              			</tr>
              		</table>
              	</td>
              </tr>
              <tr> 
                <td height="5"></td>
              </tr>
              <!---------------------------------------------------------------------- �����ǵ� ��ȸ ���� ���� �� ------------------------------------------------------------------------>
              
		<tr> 
			<td align="left" valign="top" class="soti_reqsubmit">
			<!------------------------- TAB�� �ش��ϴ� ���̺�(����̵� ������̵� ��������) ��� ��~~~�� ------------------------->             
			<table width="759" border="0" cellspacing="0" cellpadding="0">
        	<tr> 
          		<td height="2" colspan="7" class="td_reqsubmit"></td>
            </tr>
            <tr align="center" class="td_top"> 
	          	<td width="19" align="center" height="22"><input type="checkbox" name="checkAll" onClick="javascript:checkAllOrNot(document.listqry)"></td>
        	  	<td width="310" height="22"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"�䱸�Ը�")%></td>
              	<td width="170" height="22"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strCommReqBoxSortField,strCommReqBoxSortMtd,"������")%></td>
              	<td width="80" height="22"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strCommReqBoxSortField,strCommReqBoxSortMtd,"��������")%></td>				
				<td width="40" align="center" height="22">�䱸</td>
				<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_DLN",strCommReqBoxSortField,strCommReqBoxSortMtd,"�������")%></td>              	
              	<td width="70" align="center"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strCommReqBoxSortField,strCommReqBoxSortMtd,"����Ͻ�")%></td>
	        </tr>
    	    <tr> 
        	  	<td height="1" colspan="7" class="td_reqsubmit"></td>
        	</tr>
  			<%
			String strRecordNumber = request.getParameter("RecordNumber");
			int intRecordNumber=0;
			if(intCurrentPageNum == 1){
				intRecordNumber= intTotalRecordCount;
			} else {
				intRecordNumber= java.lang.Integer.parseInt(strRecordNumber);
			}
			if(objRs.getRecordSize()>0){
				String strReqBoxID="";
			  	String strCommOrganID="";
			  		
			  	while(objRs.next()){
			  		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
			  	 	strCommOrganID=(String)objRs.getObject("CMT_ORGAN_ID");
			 %>
            <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
              	<td width="45" align="center" height="20"><input type="checkbox" name="ReqBoxID" value="<%=strReqBoxID%>">&nbsp;<%= intRecordNumber %></td>
    	      	<td width="300" class="td_lmagin">&nbsp;&nbsp;
				<a href="javascript:gotoDetail('<%=strReqBoxID%>')">
				<%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
        	  	<td width="170" class="td_lmagin"><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
 				<td width="80" class="td_lmagin"><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
          		<td width="40" class="td_lmagin" align="center"><%=objRs.getObject("REQ_CNT")%></td>
          		<td width="70" class="td_lmagin" align="right"><%= StringUtil.getDate((String)objRs.getObject("SUBMT_DLN")) %> 24:00</td>
              	<td width="70" class="td_lmagin" align="right" style="padding-top:2px;padding-bottom:2px"><%= StringUtil.getDate2((String)objRs.getObject("REG_DT")) %></td>
            </tr>
            <tr class="tbl-line"> 
          		<td height="1" colspan="7"></td>
        	</tr>
			<%
				    intRecordNumber--;
				}//endofwhile
			%>
			<input type="hidden" name="RecordNumber" value="<%=intRecordNumber%>">
			<%
			}else{
			%>
			<tr>
				<td colspan="7" height="40" align="center">��ϵ� �䱸���� �����ϴ�.</td>
			</tr>
			<%
				} // end if
			%>
            <tr class="tbl-line"> 
          		<td height="2" colspan="7"></td>
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
					objParams.getParamValue("CommReqBoxPageSize"))
			%>
			</td>
		</tr>
		<tr height="3">
        	<td height="3" align="left" valign="top" background="/image/common/line_table.gif"></td>
		</tr>
		<!------------------ �˻�(��ȸ) �� <tr></tr> --------------------------->
		<tr> 
			<td height="40" align="left" valign="top">
				<% if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")) { %>
				<BR>
					<img src="/image/common/icon_exclam_mark.gif" border="0"> �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.<BR>
					<img src="/image/common/icon_exclam_mark.gif" border="0"> ���ڹ��� �ý����� �̿��Ͻ� ���� �䱸�Ժ��� ���� �߼��� �ֽñ� �ٶ��ϴ�.
				<% } %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr> 
          		<td width="256" height="40">
          		<!-- ��ư�� �ʿ��ϴٸ� ���⿡ �߰��Ͻ� �˴ϴٿ� -->
				<%
					//���� ���� 
					if(!strReqSubmitFlag.equals("004")){				
						/** ����ȸ �������� �϶��� ȭ�鿡 �����.*/
						if(objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")){
				%>
          				<img src="/image/button/bt_makeReqBox.gif" height="20"  style="cursor:hand" onClick="javascript:openReqBoxPopup();" alt="���ο� �䱸�� �ۼ��� �����մϴ�."> 
          				<img src="/image/button/bt_delReqBox.gif" border="0" style="cursor:hand" onClick="javascript:doDelete()">
          		<% }	} %>

				<!-- 2005-08-18 kogaeng ADD -->
				<% if(FLAG < 2 && objUserInfo.getOrganGBNCode().equals("004") && !strRsCmt.equals("")) { %>
					<img src="/image/button/bt_sendReq2.gif" border="0" onClick="javascript:sendReqDoc()" style="cursor:hand">
				<% } %>
          		</td>
          		<td width="503" align="right" valign="middle">
          		<%
				String strCommReqBoxQryField=objParams.getParamValue("CommReqBoxQryField");
				%>
				<select name="CommReqBoxQryField"  class="select">
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
					<option <%=(strCommReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
				</select>
				<input type="text" name="CommReqBoxQryTerm" value="<%=objParams.getParamValue("CommReqBoxQryTerm")%>"  class="textfield" style="WIDTH:180px">
				<img src="/image/common/bt_search_table.gif" width="51" height="18" align="absmiddle" onClick="listqry.submit()" style="cursor:hand">
				</td>	
        	</tr>
			</table>
			</td>
		</tr>
              
        <!------------------------- �� TAB�� �ΰ� �����ø� ���� �ҽ����� �����ؼ� �� ���� �ٿ��ֱ� �ؼ� �����ϼ��� ------------------------->
        <!----- [����] TAB <tr> �� �� �ؿ� ������ �����ϴ� <tr>�� �� �����ؼ� �� ì�� �ֽþ��. ������.. -------->
        <tr>
        	<td height="35px"></td>
        </tr>
		</form>
        </table>
        </td>
	</tr>
    </table></td>
</tr>
</table>
<%@ include file="/common/Bottom.jsp" %>
</body>
</html>