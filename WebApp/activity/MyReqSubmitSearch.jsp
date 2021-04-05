<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.RequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.*" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
</head>
<%
	/*** PagingDelegate */
	PagingDelegate objPaging=new PagingDelegate(); 		/*����¡ ��ȯ Delegate*/
%>
<%
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>
<%


	/*************************************************************************************************/
	/** 					�Ķ���� üũ Part 														  */
	/*************************************************************************************************/
	/**���õ� ����⵵�� ���õ� ����ȸID*/
	String strSelectedAuditYear= null; /**���õ� ����⵵*/
	String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
	String strRltdDuty=null;	/**���õ� �������� */
	String strDaeSuCh = null;
	String strCmtGubun = objUserInfo.getOrganGBNCode();	/**(�ۼ��� �䱸�� ��ȸ�� �ʿ�)*/
	String strBoxTp = null;			/**���õ� ���ں����ڱ���(����Ϸ� �䱸�� ��ȸ�� �ʿ�)*/
	String strReqBoxStt = null;		/**���õ� �������*/
	String strReqBoxStt2 = null;	/**���õ� �������2[�䱸�����ڷ�˻� �뵵(����Ʈ���� ������ ������ ������� ������ ����Ѵ�.)]*/

	/**�䱸�� �����ȸ�� �Ķ���� ����.*/
	RMemReqBoxListForm objParams=new RMemReqBoxListForm();

	/**�䱸��� ���� :: �Ҽ� ���.*/
//	objParams.setParamValue("ReqOrganID", objUserInfo.getOrganID());

	// ��� �䱸�� ���¸� �����ֱ� ���� �䱸�� ���� �Ķ���͸� �������� ����

	/**�䱸�� ����: �ۼ��� �䱸��.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);

	/**�䱸�� ����: �߼ۿϷ� �䱸��.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_006);
//	if(!StringUtil.isAssigned(objParams.getParamValue("ReqBoxSortField"))) objParams.setParamValue("ReqBoxSortField", "LAST_REQ_DOC_SND_DT");

	/**�䱸�� ����: ����Ϸ� �䱸��.*/
//	objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_007);
//	if((objParams.getParamValue("ReqBoxSortField")).equals("reg_dt")) objParams.setParamValue("ReqBoxSortField","LAST_ANS_DOC_SND_DT");

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

	strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/
	strSelectedCmtOrganID=objParams.getParamValue("CmtOrganID") ; /**���õ� ����ȸID*/
	strBoxTp=objParams.getParamValue("BoxTp") ;		/**���õ� ���ں����ڱ���(����Ϸ� �䱸�� ��ȸ�� �ʿ�)*/
	strReqBoxStt=objParams.getParamValue("ReqBoxStt") ;	/**���õ� �������*/

	strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */
	String strDaesuInfo = StringUtil.getEmptyIfNull(request.getParameter("DaeSu"));
	strDaeSuCh = StringUtil.getEmptyIfNull(request.getParameter("DAESUCH"));

	/*************************************************************************************************/
	/** 					������ ȣ�� Part 														  */
	/*************************************************************************************************/

	/*** Delegate �� ������ Container��ü ���� */
	MemRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
	RequestBoxDelegate objReqBoxDelegate = null;

	// 2005-08-29 kogaeng ADD
	// �䱸�����ڵ������� üũ�ϱ� ���ؼ� �߰��Ǵ� Delegate
	CmtSubmtReqBoxDelegate objBean2 = null;

	ResultSetHelper objRs=null;				/**�䱸�� ��� */
	ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
	ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
	ResultSetHelper objDaeRs=null;
	ResultSetHelper objYearRs=null;

	String strDaesu = null;
	String strStartdate = null;
	String strEnddate = null;
	String strStrDay = null;
	String strEndDay = null;

	String strStartdateReq = null;
	String strEnddateReq = null;
	String strStrDayReq = null;
	String strEndDayReq = null;

	String strSearchKeyword = null;
	strSearchKeyword = StringUtil.getEmptyIfNull(request.getParameter("SearchKeyword"));


	// ���ǿ��� �˻��� �ʿ��� Ű�� ��������
	HttpSession objSession = request.getSession();

	// �䱸��, ������ ���а�
	String REQ_SUBMT_FLAG = (String)objSession.getAttribute("REQ_SUBMT_FLAG").toString();	// �䱸�� : 001, ������ : 002
	String INOUT_GBN = (String)objSession.getAttribute("INOUT_GBN").toString();			// �䱸�� : I, ������ : X

	// ORGAN_ID
	String ORGAN_ID = (String)objSession.getAttribute("ORGAN_ID").toString();

	// ORGAN_KIND : �ǿ���(003), ����ȸ(004)
	String ORGAN_KIND = (String)objSession.getAttribute("ORGAN_KIND").toString();



	// ������, �䱸���

	String ans_organ_select = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select"));
	String ans_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("ans_organ_select_id"));
	if("".equals(ans_organ_select))	ans_organ_select_id = ""; // ������� ����� �˻��ϸ�, ���ID ���� ����

	String req_organ_select = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select"));
	String req_organ_select_id = StringUtil.getEmptyIfNull(request.getParameter("req_organ_select_id"));
	if("".equals(req_organ_select))	req_organ_select_id = ""; // ������� ����� �˻��ϸ�, ���ID ���� ����


	// �Ҽ�����ȸ

	String CmtOrganID = StringUtil.getEmptyIfNull(request.getParameter("CmtOrganID"));


	// �����

	String REGR_NM = StringUtil.getEmptyIfNull(request.getParameter("REGR_NM"));


	try{
		/**�䱸�� ���� �븮�� New */
		objReqBox=new MemRequestBoxDelegate();
		objReqBoxDelegate = new RequestBoxDelegate();

		objBean2 = new CmtSubmtReqBoxDelegate();

		objDaeRs = new ResultSetHelper(objReqBoxDelegate.getOrganDaesu(objUserInfo.getOrganID()));

		// �������[�䱸�����ڷ�˻� ��������]
		strReqBoxStt2	= StringUtil.getEmptyIfNull(request.getParameter("ReqBoxStt2"));

		strStrDay		= StringUtil.getEmptyIfNull(request.getParameter("StartDate"));
		strEndDay		= StringUtil.getEmptyIfNull(request.getParameter("EndDate"));
		strStartdate	= strStrDay.replaceAll("-","");
		strEnddate		= strEndDay.replaceAll("-","");
		strDaesu		= "";

		strStrDayReq		= StringUtil.getEmptyIfNull(request.getParameter("StartDateReq"));
		strEndDayReq		= StringUtil.getEmptyIfNull(request.getParameter("EndDateReq"));
		strStartdateReq		= strStrDayReq.replaceAll("-","");
		strEnddateReq		= strEndDayReq.replaceAll("-","");


		if("".equals(strStartdate) || "".equals(strEnddate)) {
			if(strDaesuInfo.equals("")){
				if(objDaeRs != null){
					if(objDaeRs.next()){
						strDaesu = (String)objDaeRs.getObject("DAE_NUM");
						strStartdate = (String)objDaeRs.getObject("START_DATE");
						strEnddate = (String)objDaeRs.getObject("END_DATE");
						objDaeRs.first();
					}
				}

			}else{
				String[] strDaesuInfos = StringUtil.split("^",strDaesuInfo);
				strDaesu = strDaesuInfos[0];
				strStartdate = strDaesuInfos[1];
				strEnddate = strDaesuInfos[2];

			}
		}
	    Hashtable objhashdata = new Hashtable();
		System.out.println("TIMEMMMM1 : "+this.getCurrentTime());

		// ������ ����ȸ ResultSet : �ۼ��� �䱸��
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_003,strStartdate,strEnddate));

		// ������ ����ȸ ResultSet : �߼ۿϷ� �䱸��
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_006,strStartdate,strEnddate));

		// ������ ����ȸ ResultSet : ����Ϸ� �䱸��
//		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate,strSelectedAuditYear));
//		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList(objUserInfo.getOrganID(), CodeConstants.REQ_BOX_STT_007,strStartdate,strEnddate));

		// ������ ����ȸ ResultSet : �ۼ��� + �߼ۿϷ� + ����Ϸ� �䱸��
		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate,strSelectedAuditYear));
		objYearRs = new ResultSetHelper(objReqBox.getReqrPerYearDaeList2(objUserInfo.getOrganID(), strStartdate,strEnddate));

		System.out.println("TIMEMMMM2 : "+this.getCurrentTime());



//		�� �˻�
		objhashdata.put("START_DATE",strStartdate);
	    objhashdata.put("END_DATE",strEnddate);

//		��û�� �˻�
		objhashdata.put("START_DATE_REQ",strStartdateReq);
	    objhashdata.put("END_DATE_REQ",strEnddateReq);

//		�˻���(�䱸�Ը�)
		objhashdata.put("SEARCH_KEYWORD",strSearchKeyword);

//		�Ҽ�����ȸ
		objhashdata.put("CmtOrganID",CmtOrganID);

//		�䱸�� �����
		objhashdata.put("REGR_NM",REGR_NM);

//		�������
		objhashdata.put("REQBOXSTT2",strReqBoxStt2);

//		����/������
		objhashdata.put("BOXTP",strBoxTp);
//      ���� �䱸 ���
		objhashdata.put("ans_organ_select_id",ans_organ_select_id);
        objhashdata.put("req_organ_select_id",req_organ_select_id);

		// ����Ÿ��

		String strRegType = "";

		System.out.println("REQ_SUBMT_FLAG : "+REQ_SUBMT_FLAG);
		System.out.println("ORGAN_KIND : "+ORGAN_KIND);

		// �䱸��
		if("001".equals(REQ_SUBMT_FLAG)){
			// �ǿ���
			if("003".equals(ORGAN_KIND)){
//				objParams.setParamValue("req_organ_id",ORGAN_ID);
//				objParams.setParamValue("SUBMT_ORGAN_ID",null);
//				objParams.setParamValue("CMT_ORGAN_ID",null);
				strRegType = "001";
			// ����ȸ
			}else{
//				objParams.setParamValue("req_organ_id",null);
//				objParams.setParamValue("SUBMT_ORGAN_ID",null);
//				objParams.setParamValue("CMT_ORGAN_ID",ORGAN_ID);
				strRegType = "003";
			}
		// ������
		}else{
//			objParams.setParamValue("req_organ_id",null);
//			objParams.setParamValue("SUBMT_ORGAN_ID",ORGAN_ID);
//			objParams.setParamValue("CMT_ORGAN_ID",null);
			strRegType = "002";
		}

//		objParams.setParamValue("ReqOrganID",null);

//		����Ÿ��
		objhashdata.put("REGTYPE",strRegType);

//		����� ���ID
		objhashdata.put("ORGAN_ID",ORGAN_ID);

		System.out.println("-------------------------------------------------------------------------------------");
		// �䱸�� ����Ʈ ResultSet
		objRs=new ResultSetHelper(objReqBox.getRecordDaeList2(objParams,objhashdata));
		System.out.println("-------------------------------------------------------------------------------------");
        System.out.println("strRegType"+strRegType);
        System.out.println("req_organ_select_id"+ans_organ_select_id);
		System.out.println("-------------------------------------------------------------------------------------");
		// �������� ����Ʈ ��¿� ResultSet
		objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
		System.out.println("TIMEMMMM4 : "+this.getCurrentTime());

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
<script language=Javascript src="/js/datepicker.js"></script>
<script language="javascript" src="/js/reqsubmit/common.js"></script>
<script language="javascript">

  var IsClick=false;	// �ۼ��� �䱸�� ��ȸ�� �ʿ�

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
	formName.DAESUCH.value = "N";
	formName.target = '';	// �ۼ��� �䱸�� ��ȸ�� �ʿ�
    formName.action = "<%=request.getRequestURI()%>";
  	formName.submit();
  }

  //�ۼ��� �䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
	/*
  	formName.action="./RMakeReqBoxVList.jsp?ReqBoxID="+strID;
  	formName.target = "";
  	formName.submit();
	*/

	var strIDArr = strID.split("/");
	var strID = strIDArr[0];
	var strStt = strIDArr[1];

	var REQ_SUBMT_FLAG = '<%=REQ_SUBMT_FLAG %>';
	var ORGAN_KIND = '<%=ORGAN_KIND %>';

	if(!IsClick){

		// �䱸��
		if(REQ_SUBMT_FLAG == '001'){

			// �ǿ���
			if(ORGAN_KIND == '003'){

				switch(strStt){

					case '003': location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/RMakeReqBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �ۼ���
					case '006': location.href="/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �߼ۿϷ�
					case '007': location.href="/reqsubmit/10_mem/20_reqboxsh/30_makeend/RMakeEndVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// ����Ϸ�

				}

			// ����ȸ
			}else{

				switch(strStt){

					case '002': location.href="/reqsubmit/20_comm/20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �����Ϸ�
					case '006': location.href="/reqsubmit/20_comm/20_reqboxsh/30_sendend/RSendBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �߼ۿϷ�
					case '007': location.href="/reqsubmit/20_comm/20_reqboxsh/40_subend/RSubEndBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// ����Ϸ�

				}

			}

		// ������
		}else{

				switch(strStt){

					case '006': location.href="/reqsubmit/10_mem/20_reqboxsh/10_make/SMakeReqBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �ۼ���
					case '007': location.href="/reqsubmit/10_mem/20_reqboxsh/30_makeend/SMakeEndBoxVList.jsp?ReqBoxID="+strID+"&CmtOrganID="+formName.CmtOrganID.value; break;	// �ۼ��Ϸ�

				}

		}


	}else{
		alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
		return;
	}

  }

  //�߼ۿϷ� �䱸�Ի󼼺���� ����.
/*
  function gotoDetail(strID, strCmtOrganID) {
  	formName.ReqBoxID.value = strID;
  	formName.CmtOrganID.value = strCmtOrganID;
  	formName.action="./RSendBoxVList.jsp";
  	formName.submit();
  }
*/
  //����Ϸ� �䱸�Ի󼼺���� ����.
/*
  function gotoDetail(strID){
  	formName.ReqBoxID.value=strID;
  	formName.action="./RMakeEndVList.jsp";
  	formName.submit();
  }
*/
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
	formName.DAESUCH.value = "N";
	formName.target = '';	// �ۼ��� �䱸�� ��ȸ�� �ʿ�
    formName.action = "<%=request.getRequestURI()%>";
  	formName.submit();
  }

  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
//  	formName.ReqBoxQryField.value="";
//  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
	formName.DAESUCH.value = "N";
	formName.target = '';	// �ۼ��� �䱸�� ��ȸ�� �ʿ�
    formName.action = "<%=request.getRequestURI()%>";
  	formName.submit();
  }

	// 2005-07-13 �䱸�� �ϰ� �߼�
	function sendReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("�䱸�� �߼��� ���ؼ��� �켱 ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.");
				document.formName.CmtOrganID.focus();
				return;
			}

			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("�߼��Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}

	  	if(confirm("�����Ͻ� �䱸���� �ش� ���������� �ϰ� �߼��Ͻðڽ��ϱ�?\n\r\n\r***** Ȯ�ιٶ��ϴ� *****\n\r�ش����� ��ǥ ����ڰ� ���� ���� �߼۵��� �ʽ��ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
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
	function sendReqDoc1() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("�䱸�� �߼��� ���ؼ��� �켱 ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.");
				document.formName.CmtOrganID.focus();
				return;
			}

			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("�߼��Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}

	  	if(confirm("�����Ͻ� �䱸���� �ش� ���������� �ϰ� �߼��Ͻðڽ��ϱ�?\n\r\n\r***** Ȯ�ιٶ��ϴ� *****\n\r�ش����� ��ǥ ����ڰ� ���� ���� �߼۵��� �ʽ��ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��
			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/ReqDocSendProcMultiTest.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}else{
			 return ;
		}
	}

	function AllInOne(){

		var w = 800;
		var h = 700;
		var winl = (screen.width - w) / 2;
		var winh = (screen.height - h) / 2;
		var url = "/reqsubmit/common/ReqInfoWriteAllInOne.jsp";	window.open(url,'New','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+w+',height='+h+',left='+winl+',top='+winh);
	}

	// 2005-07-18 ���õ� �䱸�� �ϰ� ����
	function doDelete() {
		if(!IsClick){
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
				return;
			}
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}

	  	if(confirm("�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?\n\r���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			//var winl = (screen.width - 300) / 2;
			//var winh = (screen.height - 240) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/10_mem/20_reqboxsh/10_make/ReqBoxDelProcMulti.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=240, left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}

	// 2005-08-26 kogaeng ADD
	// ����ȸ ���� �䱸�� �ϰ� �߼�
	function sendCmtReqDoc() {
		if(!IsClick){
			if(document.formName.CmtOrganID.value == "") {
				alert("�䱸�� �߼��� ���ؼ��� �켱 ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.");
				document.formName.CmtOrganID.focus();
				return;
			}

			//if(document.formName.CmtOrganID.value == "GI00004773"){
			//	alert("�ӱ⸸��� ���Ͽ� �䱸���� ������ �� �����ϴ� \n ���� ����ȸ�� ������ �����Ǹ� �䱸���� ������ �� �ֽ��ϴ�.");
			//	return;
			//}
			if(getCheckCount(document.formName, "ReqBoxID") < 1) {
				alert("����ȸ ���Ƿ� �߼��� �䱸���� �ϳ� �̻� ������ �ּ���.");
				return;
			}
			<% if(objBean2.checkCmtOrganMakeAutoSche(strSelectedCmtOrganID) && objUserInfo.getIsMyCmtOrganID(strSelectedCmtOrganID)) { %>

			<%}else{
				if("GI00007001".equals(strSelectedCmtOrganID)|| "GI00007002".equals(strSelectedCmtOrganID)){

				}else{
			%>
				alert("�Ҽ� ��������ȸ�� �ƴ� ��쿡�� �߼��Ͻ� �� �����ϴ�.");
				return;
			<%
				}
			}
			%>
		}else{
			alert("���μ����� �۵����Դϴ�. ��� ��ٷ��ֽʽÿ�.");
			return false;
		}

		if(confirm("�����Ͻ� �䱸���� �ش� ����ȸ ���Ƿ� �߼��Ͻðڽ��ϱ�?\n\r\n\r[Ȯ�λ���]\n\r1. �Ҽ� ��������ȸ�� �ƴ� ��쿡�� �߼��Ͻ� �� �����ϴ�.\n\r2. ��ϵ� �䱸�� ���� ��� �߼��Ͻ� �� �����ϴ�.")) {
			IsClick = true;  //��ư ó���� ������..
			ButtonProcessing();  //ó�����¸� ǥ���ϴ� �޼ҵ� ȣ��

			//var winl = (screen.width - 304) / 2;
			//var winh = (screen.height - 118) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "/reqsubmit/common/CmtReqDocSendAllInOneMulti.jsp";
			document.formName.target = 'processingFrame';
			//window.open('/blank.html', 'popwin', 'width=300, height=200, left='+winl+', top='+winh);
	  		document.formName.submit();
		}
	}

/*
	// �߼ۿϷ�
	// 2005-07-18 ���õ� �䱸�� �ϰ� ����
	function doDelete() {
	  	if(getCheckCount(document.formName, "ReqBoxIDs") < 1) {
	  		alert("�����Ͻ� �ϳ� �̻��� �䱸���� ������ �ּ���.");
	  		return;
	  	}
	  	if(confirm("�����Ͻ� �䱸���� �ϰ� �����Ͻðڽ��ϱ�?\n\r\n\r1. ���Ե� ��� �䱸 ���뵵 �ϰ� �����˴ϴ�.\n\r2. �亯�� ���� ���� �䱸���� �������� �ʽ��ϴ�.")) {
	  		var w = 300;
	  		var h = 200;
			var winl = (screen.width - w) / 2;
			var winh = (screen.height - h) / 2;
			//document.all.loadingDiv.style.left = winl;
			//document.all.loadingDiv.style.top = winh;
			//document.all.loadingDiv.style.display = '';
			document.formName.action = "RSendBoxDelProc.jsp";
			document.formName.target = 'popwin';
			window.open('/blank.html', 'popwin', 'width='+w+', height='+h+', left='+winl+', top='+winh);
	  		document.formName.submit();
	  	}
	}
*/
	function changeDaesu(){
		formName.StartDateReq.value="";
		formName.EndDateReq.value="";
		formName.DAESUCH.value = "Y";
        formName.target = "";
        formName.action = "<%=request.getRequestURI()%>";
		formName.submit();
	}

	function doListRefresh() {
		var f = document.formName;
		f.target = "";
        f.action = "<%=request.getRequestURI()%>";
		f.submit();
	}

	// �䱸��� �˻�
	function findreq(){
		var http = "./ISearch_Reqlist.jsp";
		window.open(http,"ISearch_Reqlist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
	}

	// ������ �˻�
    function findans(){
		var http = "./ISearch_Anslist.jsp";
		window.open(http,"ISearch_Anslist","resizable=yes,menubar=no,status=yes,titlebar=yes,scrollbars=yes,location=no,toolbar=no,height=600,width=530" );
	}
	function getExcelData() {
		var f = document.formName;
		//f.target = "processingFrame";
        f.method = "post";
        f.ReqBoxPageSize.value="100000";
		f.action = "MyReqSubmitSearch_Excel.jsp";
		f.target = "_self";
		f.submit();
        f.ReqBoxPageSize.value="";
	}
</script>
<%//System.out.close();%>
<%
	// 2005-08-09 kogaeng ADD
	// �䱸�� �ۼ� �޴� ������ �Ұ����ϰ� �߰�
	String strAddScript = "";
	String strAutoPopup = StringUtil.getEmptyIfNull(request.getParameter("AutoPopup"));
	if("Y".equalsIgnoreCase(strAutoPopup)) strAddScript = "AllInOne();";
%>
<body onload="<%= strAddScript %>">
<iframe name='processingFrame' height='0' width='0'></iframe>
<DIV ID="loadingDiv" style="display:none;position:absolute;">
	<img src="/image/reqsubmit/loading.jpg" border="0"> </td>
</DIV>
<div id="wrap">
<%
	System.out.println("TIMEMMMM4.4 : "+this.getCurrentTime());
%>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu01.jsp" flush="true"/>
<%
	System.out.println("TIMEMMMM4.5 : "+this.getCurrentTime());
%>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu01.jsp" flush="true"/>
    </div>
    <div id="rightCon">
      <!-- pgTit -->
		<form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
        <input type="hidden" name="ReqBoxPageSize" value=""/>
<%//���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
%>
		<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
		<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
		<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->
		<!-- 2005-07-18 �䱸�� �߼��� ���� �⺻ ���� ����(�ۼ���)-->
		<input type="hidden" name="ReqDocType" value="<%= CodeConstants.REQ_DOC_TYPE_001 %>">
		<input type="hidden" name="ReqTp" value="<%= CodeConstants.REQ_DOC_FORM_001 %>">
		<input type="hidden" name="SmsUse" value="<%= CodeConstants.NTC_MTD_BOTH %>">
		<!--
		<input type="hidden" name="ReqOrganID" value="<%= objUserInfo.getOrganID() %>">
		-->
		<input type="hidden" name="SndrID" value="<%= objUserInfo.getUserID() %>">
		<!-- 2005-07-18 �䱸�� �߼��� ���� �⺻ ���� ��(�ۼ���)-->
		<input type="hidden" name="ReqBoxID" value=""><!--�䱸�Թ�ȣ �Ϲ������δ� ���ȵ�(�߼ۿϷ�,����Ϸ�)-->
		<input type="hidden" name="DAESUCH" value="">
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3>�䱸�����ڷ�˻�</h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> > ���� ������ > ���� �ڷ�䱸���� > �䱸�����ڷ�˻�</div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸�����ڷ�˻�����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box03">

			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
				<tr>
					<td height="40" colspan="6" align="center" valign="top" style="border-bottom: solid 1px  #cfdde2;">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;���հ˻�</strong>&nbsp;<input type="text" name="SearchKeyword" value="<%=strSearchKeyword%>" size="50" style="height:20px;"><a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
					</td>
				</tr>
				<tr><td height="5" colspan="6"></td></tr>
				<tr>
					<td width="15%" height="25" >
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;��ȸ����</strong></td>
					<td width="35%">
						<select onChange="changeDaesu()" name="DaeSu">
					    <%
							if(objDaeRs != null){
								while(objDaeRs.next()){
									String str = objDaeRs.getObject("DAE_NUM")+"^"+objDaeRs.getObject("START_DATE")+"^"+objDaeRs.getObject("END_DATE");
						%>
								<option value="<%=objDaeRs.getObject("DAE_NUM")%>^<%=objDaeRs.getObject("START_DATE")%>^<%=objDaeRs.getObject("END_DATE")%>" <%if(str.equals(strDaesuInfo)){%>selected<%}%>><%=objDaeRs.getObject("DAE_NUM")%>��</option>
						<%
								}
							}
						%>
						</select>
					</td>
					<td width="15%">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;��û��</strong></td>
					<td width="35%" colspan="3">
						<!--
						<select onChange="javascript:doListRefresh()" name="AuditYear">
						  <option selected="selected" value="">��ü</option>
						<%
							if(objYearRs != null && objYearRs.getTotalRecordCount() > 0){
								while(objYearRs.next()){
							%>
								<option value="<%=objYearRs.getObject("AUDIT_YEAR")%>" <%if(((String)objYearRs.getObject("AUDIT_YEAR")).equals(strSelectedAuditYear)){%>selected<%}%>><%=objYearRs.getObject("AUDIT_YEAR")%></option>
							<%
								}
							}
						%>
						</select>
						-->
   					    <input type="text" class="textfield" name="StartDateReq" size="10" maxlength="8" value="<%=strStrDayReq%>"  readonly" >
                        <a href="#" OnClick="javascript:show_calendar('formName.StartDateReq');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a> ~
					    <input type="text" class="textfield" name="EndDateReq" size="10" maxlength="8" value="<%=strEndDayReq%>" readonly">
					    <a href="#" OnClick="javascript:show_calendar('formName.EndDateReq');"><img src="/images2/btn/bt_calender.gif" width="17" height="13" onMouseOver="menuOn(this);" onMouseOut="menuOut(this);"/></a>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;�䱸�� �����</strong>
					</td>
					<td>
						<input type="text" size="20" name="REGR_NM" value="<%=REGR_NM %>">
					</td>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // �䱸��%>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;������</strong>
					</td>
					<td>
						<input type="text" size="20" name="ans_organ_select" value="<%=ans_organ_select %>"><a href="javascript:findans();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
						<input type="hidden" name="ans_organ_select_id" value="<%=ans_organ_select_id%>">
					</td>
					<%}else{ // ������%>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;�䱸���</strong>
					</td>
					<td>
						<input type="text" size="20" name="req_organ_select" value="<%=req_organ_select %>"><a href="javascript:findreq();"><img src="/images2/btn/bt_search2.gif" width="50" height="22"  /></a>
						<input type="hidden" name="req_organ_select_id" value="<%=req_organ_select_id%>">
					</td>
					<%} %>
				</tr>
				<tr>
					<%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ //�䱸�� %>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;�������</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="ReqBoxStt2">
							<option value="" <%if(strReqBoxStt2.equals("")){%>selected<%}%>>��ü</option>
							<%if("003".equals(ORGAN_KIND)){ //�ǿ��� %>
							<option value="003" <%if(strReqBoxStt2.equals("003")){%>selected<%}%>>�ۼ���</option>
							<%}else{ //����ȸ %>
							<option value="002" <%if(strReqBoxStt2.equals("002")){%>selected<%}%>>�����Ϸ�</option>
							<%} %>
							<option value="006" <%if(strReqBoxStt2.equals("006")){%>selected<%}%>>�߼ۿϷ�</option>
							<option value="007" <%if(strReqBoxStt2.equals("007")){%>selected<%}%>>����Ϸ�</option>
						</select>
					</td>
					<%}else{ //������ %>
					<td >
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;�������</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="ReqBoxStt2">
							<option value="" <%if(strReqBoxStt2.equals("")){%>selected<%}%>>��ü</option>
							<option value="006" <%if(strReqBoxStt2.equals("006")){%>selected<%}%>>�ۼ���</option>
							<option value="007" <%if(strReqBoxStt2.equals("007")){%>selected<%}%>>�ۼ��Ϸ�</option>
						</select>
					</td>
					<%} %>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;�Ҽ�����ȸ</strong>
					</td>
					<td>
						<select onChange="javascript:doListRefresh()" name="CmtOrganID">
							<option selected="selected" value="">:::: ��ü����ȸ :::</option>
						<%
							if(objCmtRs != null && objCmtRs.getTotalRecordCount() > 0){
								while(objCmtRs.next()){
							%>
								<option value="<%=objCmtRs.getObject("ORGAN_ID")%>" <%if(((String)objCmtRs.getObject("ORGAN_ID")).equals(strSelectedCmtOrganID)){%>selected<%}%>><%=objCmtRs.getObject("ORGAN_NM")%></option>
							<%
								}
							}
						%>
						</select>
					</td>
				</tr>
				<tr>
					<td height="25">
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3" />&nbsp;��������</strong>
					</td>
					<td>
						<select onChange="this.form.submit()" name="RltdDuty">
							<option selected="selected" value="">��������(��ü)</option>
							<%
							   /**�������� ����Ʈ ��� */
							   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
									String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
									out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
							   }
							%>
						</select>
					</td>
					<td>
						<strong><img src="/images2/common/bullet01.gif" width="3" height="3"  />&nbsp;��������</strong>
					</td>
					<td colspan="3">
						<select onChange="this.form.submit()" name="BoxTp">
							<option value="" <%if(strBoxTp.equals("")){%>selected<%}%>>����/������</option>
							<option value="001" <%if(strBoxTp.equals("001")){%>selected<%}%>>����</option>
							<option value="005" <%if(strBoxTp.equals("005")){%>selected<%}%>>������</option>
						</select>
					</td>
				</tr>
			</table>

            </div>
			&nbsp;<br>
			<font color="blue">�ڷ�䱸�������<br>
			������ ����� �ڷḸ �˻��� ��쿡�� '�䱸�Ե����'  �׸� ���� ������ �Է��� �� ��ȸ�Ͻø� �˴ϴ�.</font>
			
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->


        <span><img src="../image/button/bt_excelDownload.gif" height="20"  style="cursor:hand" OnClick="javascript:getExcelData();"><span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%>/<%=intTotalPage%> page)</span></span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">

          <thead>
            <tr>
              <th scope="col" style="width:15px;"><a>No</a></th>
              <th scope="col" style="width:230px; "><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_STT",strReqBoxSortField,strReqBoxSortMtd,"�������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"����")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"����Ͻ�")%></th>
			  <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","LAST_ANS_DOC_SND_DT",strReqBoxSortField,strReqBoxSortMtd,"�亯�Ͻ�")%></th>
            </tr>
          </thead>

          <tbody>
			<%
			  int intRecordNumber=intTotalRecordCount - ((intCurrentPageNum -1) * Integer.parseInt((String)objParams.getParamValue("ReqBoxPageSize")));
			  //int intRecordNumber=intTotalRecordCount;
			  if(objRs.getRecordSize()>0){
				String strReqBoxID="";
				String strReqBoxSttParam="";
				int intMakeGrdID = 0;
				while(objRs.next()){
					 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
					 strReqBoxSttParam=(String)objRs.getObject("REQ_BOX_STT");
					 intMakeGrdID = Integer.parseInt(StringUtil.getEmptyIfNull((String)objRs.getObject("MAKE_GRD_ID"), "0"));
					 String strBgColor = "";
					 if((intMakeGrdID % 2) == 0) strBgColor = "#f4f4f4";
			 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td width="260px"><a href="javascript:gotoDetail('<%=strReqBoxID%>/<%=strReqBoxSttParam %>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td>
			  <%if("001".equals(REQ_SUBMT_FLAG) && "I".equals(INOUT_GBN)){ // �䱸�� %>
			  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),true)%>
			  <%}else{ // ������ %>
        	  <%=CodeConstants.getReqBoxStatus((String)objRs.getObject("REQ_BOX_STT"),false)%>
			  <%} %>
			  </td>
              <td><%=objRs.getObject("SUBMT_CNT")%>/<%=objRs.getObject("REQ_CNT")%></td>
              <td><%= StringUtil.getDate2((String)objRs.getObject("REG_DT"))%></td>
			  <td><%= StringUtil.getDate2((String)objRs.getObject("LAST_ANS_DOC_SND_DT"))%></td>
            </tr>
			<%
						intRecordNumber --;
					}//endwhile
				}else{
			%>
			<tr>
              <td colspan="7">��ϵ� <%=MenuConstants.REQ_BOX_MAKE%>�� �����ϴ�.</td>
            </tr>
			<%
			}//end if ��� ��� ��.
			%>
          </tbody>

        </table>

        <!-- /list -->


        <!-- ����¡-->
		<table  align="center">
              <tr>
                <td height="35" align="center">
                	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                	<%//= PageCount.getLinkedString(
						//	new Integer(intTotalRecordCount).toString(),
						//	new Integer(intCurrentPageNum).toString(),
						//	objParams.getParamValue("ReqBoxPageSize"))
//							"1")
					%>
					<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
					<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize"))
							) %>
                </td>
              </tr>
		</table>
        <!-- /����¡-->


        <!-- ����Ʈ ��ư-->
        <!--div id="btn_all" >
        <div class="list_ser" >
			<%
				String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
			%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_dsc"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="submt_organ_nm">������</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
			<span class="right">
			<span class="list_bt"><a href="javascript:AllInOne();"">�䱸���ۼ�</a></span>
			<span class="list_bt"><a href="javascript:doDelete()">�䱸�Ի���</a></span>
			<%
				if(!objUserInfo.getIsMyCmtOrganID("GI00004757")) {
			%>
					<%if(strCmtGubun.equals("004")){%>
					<%}else{%>
					<span class="list_bt"><a href="javascript:sendReqDoc()">�ǿ��� ���� �䱸�� �߼�</a></span>
					<%}%>
			<%
				} else {
					if(!"".equalsIgnoreCase(strSelectedCmtOrganID) && !"GI00004757".equalsIgnoreCase(strSelectedCmtOrganID)) {
			%>

					<%if(strCmtGubun.equals("004")){%>
					<%}else{%>
					<span class="list_bt"><a href="javascript:sendCmtReqDoc()">����ȸ���� �䱸���߼�</a></span>
					<%}%>
		<%
				}
			}
		%>
			<span class="list_bt">
			<a href="javascript:sendCmtReqDoc()">����ȸ ���� �䱸�� �߼�</a></span>
			</span>
		</div>
      </div-->
      <!-- /contents -->

    </div>
</form>
  </div>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>
<%
	System.out.println("TIMEMMMM5 : "+this.getCurrentTime());
%>
<%!
	public String getCurrentTime() {
        Calendar oCalendar = Calendar.getInstance();
		String serverDate = oCalendar.get(Calendar.YEAR) + "/" +(oCalendar.get(Calendar.MONTH) + 1)+"/"+ oCalendar.get(Calendar.DAY_OF_MONTH)+"  "+oCalendar.get(Calendar.HOUR_OF_DAY)+":"+oCalendar.get(Calendar.MINUTE)+":"+oCalendar.get(Calendar.SECOND)+":"+oCalendar.get(Calendar.MILLISECOND);
		 return serverDate;
     }

%>