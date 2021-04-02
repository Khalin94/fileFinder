<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.util.PageCount" %>
<%@ page import="kr.co.kcc.bf.config.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>
<%@ page import="nads.dsdm.app.common.page.PagingDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

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
    /**�䱸�� �����ȸ�� �Ķ���� ����.*/
    RMemReqBoxListForm objParams=new RMemReqBoxListForm();

     //�α����� �����ID�� �����´�.
 	String strUserID   = objUserInfo.getUserID();
    String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();
	//���� �������� ������ ��.
	String strReqSchId   		   = StringUtil.getNVLNULL(request.getParameter("ReqSchId"));		//TBDS_REQUEST_SCHEDULE���̺� SEQ
	String strReqBoxQryTerm   = StringUtil.getNVLNULL(request.getParameter("ReqBoxQryTerm"));		//TBDS_REQUEST_SCHEDULE���̺� SEQ
    String strKind       = objUserInfo.getOrganGBNCode();

	//��Delegate �����.
    nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate objCommReq = new  nads.dsdm.app.reqsubmit.delegate.commreqsch.CommMakeBoxDelegate();

	Hashtable objHashDetail = new Hashtable();
	objHashDetail = objCommReq.selectSchDetail(strReqSchId);

	String strReqScheId = (String)objHashDetail.get("REQ_SCHE_ID");    	//SEQ
	String strOrganNm 	= (String)objHashDetail.get("ORGAN_NM");      	//����ȸ��
	String strReqNm 		= (String)objHashDetail.get("REQNM");   				//�䱸��
	String strAcptBgnDt 	= (String)objHashDetail.get("ACPT_BGN_DT");    	//����������
	String strAcptEndDt 	= (String)objHashDetail.get("ACPT_END_DT");    	//����������
	String strIngStt 		= (String)objHashDetail.get("ING_STT");    		  	//��������ڵ�
	String strRegDt		= (String)objHashDetail.get("REG_DT");    		  	//�������
	String strSubmtDln 	= (String)objHashDetail.get("SUBMT_DLN");    		//���⸶����
	String strAuditYear 	= (String)objHashDetail.get("AUDIT_YEAR");    		//�䱸�⵵
    String strOrderInfo 	= (String)objHashDetail.get("ORDER_INFO");     	//����
    String strCdNm 		= (String)objHashDetail.get("CD_NM");     			//������¸�
    String strCmtOrganId= (String)objHashDetail.get("CMT_ORGAN_ID");    //����ȸ id
    String strNatCnt        = (String)objHashDetail.get("NAT_CNT");    //ȸ��

    //�⵵ Format ��ȭ
	strAcptBgnDt 	= strAcptBgnDt.substring(0,4) +"-"+ strAcptBgnDt.substring(4,6) +"-"+ strAcptBgnDt.substring(6,8) ;    	//����������
	strAcptEndDt 	= strAcptEndDt.substring(0,4) +"-"+ strAcptEndDt.substring(4,6) +"-"+ strAcptEndDt.substring(6,8) ;    	//����������
	strSubmtDln 	= strSubmtDln.substring(0,4) +"-"+ strSubmtDln.substring(4,6) +"-"+ strSubmtDln.substring(6,8) ;    		//���⸶����

	//Page Count
	String strCurrentPage = StringUtil.getNVL(request.getParameter("strCurrentPage"), "1");	//���� ������
	String strCountPerPage;																										//�������� ROW����

	//#### Page ####
	// �ý��� ��ü������ �������� row�� ������ property�� ���Ͽ� ����Ѵ�.
	// ���� Ư�������������� row�� ������ �����ϰ� ������ �Ʒ� catch���� Ȱ���Ѵ�.
	try {
		Config objConfig = PropertyConfig.getInstance();
		strCountPerPage = objConfig.get("page.rowcount");
	}
	catch (ConfigException objConfigEx) {
		strCountPerPage = StringUtil.getNVL(request.getParameter("strCountPerPage"), "10");
	}

//    strCountPerPage = "10";

	ArrayList objCommList = new ArrayList();

	try{
	//����ȸ �䱸�Ը�� ��ȸ����¡���� �޼ҵ� ȣ��
		if ( strReqBoxQryTerm == null || strReqBoxQryTerm.equals("")) {
			objCommList = objCommReq.selectCommDataListPerPage(strCmtOrganId, strReqScheId, strCurrentPage, strCountPerPage);
		}else{
			objCommList = objCommReq.selectCommDataListPerPageQry(strCmtOrganId, strReqScheId, strCurrentPage, strCountPerPage, strReqBoxQryTerm);
		}
	} catch (AppException objAppEx) {
		// ���� �߻� �޼��� �������� �̵��Ѵ�.
		out.println(objAppEx.getStrErrCode() + "<br>");
		out.println("�޼��� �������� �̵��Ͽ��� �Ѵ�.<br>");
		return;
	}

	String strTotalCount = (String)((Hashtable)objCommList.get(0)).get("TOTAL_COUNT");


	//�䱸�Լӿ� �䱸�� �ִ��� Ȯ��
    Hashtable objHashCnt = new Hashtable();
	objHashCnt = objCommReq.selectSchReqIdCnt(strReqScheId);
	//�䱸��� ����
	String strReqCnt = (String)objHashCnt.get("CNT");


	//���� �������� ���� �䱸���� ������ �ִ��� Ȯ���Ѵ�.
  	Hashtable objHashNatCnt = new Hashtable();
	objHashNatCnt = objCommReq.selectSchNatCnt(strAuditYear, strCmtOrganId, strOrderInfo);
	int intNatCnt = objHashNatCnt.size();

	//out.print("intNatCnt : " + intNatCnt + "<br>");
%>

<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
	function fUsrAction(mode, strReqScheId, strOrganNm, strOrderInfo, strAcptBgnDt, strAcptEndDt, strSubmtDln, strAuditYear, strCmtOrganId, strNatCnt, strReqSchId) {
	  switch(mode) {
	    //�䱸���� ����
	    case "insert" :
			location.href="RCommSchWrite.jsp?strYear="+strYear+"&strOrganId="+strOrganId+"&strOrganNm="+strOrganNm;
	        break;

	    //�䱸���� ����
	    case "update" :
			location.href="RCommSchUpdate.jsp?strReqScheId="+strReqScheId+"&strOrganNm="+strOrganNm+"&strOrderInfo="+strOrderInfo+"&strAcptBgnDt="+strAcptBgnDt+"&strAcptEndDt="+strAcptEndDt+"&strSubmtDln="+strSubmtDln+"&strAuditYear="+strAuditYear+"&strCmtOrganId="+strCmtOrganId+"&strNatCnt="+strNatCnt+"&strReqSchId="+strReqSchId ;
	        break;
	  }
	}

	function fUsrAction2(mode, strReqScheId) {
	  switch(mode) {

	    //�䱸���� ����
	    case "delet" :
            if (!fCheckField()) return false;
		    if (!confirm("������ �䱸������ �����Ͻðڽ��ϱ�?")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=delet&ReqScheId=" + strReqScheId;
	        break;

	    //�䱸����
	    case "reqend" :
            if (!fCheckField2()) return false;
		    if (!confirm("�䱸 ������ ������ �Ͻðڽ��ϱ�?  �䱸������ �䱸�Ե� �����Ϸ�˴ϴ�.")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=updat&ReqScheId=" + strReqScheId;
	        break;

	    //�䱸����
	    case "reqendback" :
		    if (!confirm("�䱸 ������ ������ ��� �Ͻðڽ��ϱ�? ")) {
	            return false;
	        };
			location.href="RCommSchDProc.jsp?cmd=updateback&ReqScheId=" + strReqScheId;
	        break;

	  }
	}

	function fCheckField() {
	  with (form1) {
	    if (ReqCnt.value != '0') {
	      alert('�䱸��  �Ǵ� �䱸����� �����մϴ�.  ���� �䱸�Կ� ��ϵǾ��ִ� �䱸��ϰ� �䱸���� ���� �ϼ���!');
	      return false;
	    }
	  }
	  return true;
	}

	function fCheckField2() {
	  with (form1) {
	    if (ReqBoxCnt.value == 0) {
	      alert('������ �䱸�� �Ǵ� �䱸����� �������� �ʽ��ϴ�. ���� �䱸�԰� �䱸 ����� ����ϼ���!');
	      return false;
	    }
	  }
	  return true;
	}

	function fUsrActionBack(mode, strYear) {
	  switch(mode) {
	    //�䱸����
	    case "back" :
			location.href="RNewBoxMake.jsp?year_cd=" + strYear;
	        break;
	  }
	}

	function fUsrActionMake(mode, strReqScheId) {
	  switch(mode) {
	    //�䱸�� ����
	    case "make" :
			location.href="../20_reqboxsh/RCommNewBoxMake.jsp?ReqScheID=" + strReqScheId;
	        break;
	  }
	}

	function fUsrActionList(mode, strReqBoxID) {
	  switch(mode) {
	    //�䱸��ϸ���Ʈ

	    //   001	������
	    case "001" :
			location.href="../20_reqboxsh/RCommReqBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   002	�����Ϸ�
	    case "002" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   004	��������
	    case "004" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   005	�ݷ�
	    case "005" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;


	    //   006	�߼ۿϷ�/�ۼ���
	    case "006" :
			location.href="../20_reqboxsh/30_sendend/RSendBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   007	����Ϸ�/�ۼ��Ϸ�
	    case "007" :
			location.href="../20_reqboxsh/40_subend/RSubEndBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;

	    //   009	��Ŵ��
	    case "009" :
			location.href="../20_reqboxsh/20_accend/RAccBoxVList.jsp?ReqBoxID=" + strReqBoxID;
	        break;
	  }
	}

	function fUsrActionSort(mode, strReqSchId, strOrderInfo) {
	  switch(mode) {
	    //����
	    case "sort" :
			location.href="../20_reqboxsh/RCommReqBoxVList.jsp?ReqBoxID=" + strReqBoxID;
		  	form1.submit();
	        break;
	  }
	}

	/** ���Ĺ�� �ٲٱ� */
	function changeSortQuery(sortField,sortMethod){
  		form1.CommReqBoxSortField.value=sortField;
	  	form1.CommReqBoxSortMtd.value=sortMethod;
	  	form1.submit();
	}

	function goPage(varPageNo) {
		document.form1.strCurrentPage.value = varPageNo;
		document.form1.submit();
	}

</script>
</head>

<body>
<div id="wrap">
<SCRIPT language="JavaScript" src="/js/reqinfo.js"></SCRIPT>
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="form1" method="post" action="RCommSchVList.jsp">
	<input type=hidden name=ReqScheId VALUE="<%=strReqScheId%>">
	<input type=hidden name=OrganNm VALUE="<%=strOrganNm%>">
	<input type=hidden name=OrderInfo VALUE="<%=strOrderInfo%>">
	<input type=hidden name=AcptBgnDt VALUE="<%=strAcptBgnDt%>">
	<input type=hidden name=AcptEndDt VALUE="<%=strAcptEndDt%>">
	<input type=hidden name=SubmtDln VALUE="<%=strSubmtDln%>">
	<input type=hidden name=AuditYear VALUE="<%=strAuditYear%>">
	<input type=hidden name=CmtOrganId VALUE="<%=strCmtOrganId%>">
	<input type=hidden name=ReqCnt VALUE="<%=strReqCnt%>">
	<input type=hidden name=NatCnt VALUE="<%=strNatCnt%>">

	<input type=hidden name=strcmd VALUE="delete">

	<%//���� ���� �ޱ�.
		String strCommReqBoxSortField=objParams.getParamValue("CommReqBoxSortField");
		String strCommReqBoxSortMtd=objParams.getParamValue("CommReqBoxSortMtd");
	%>

	<input type="hidden" name="CommReqBoxSortField" value="<%=strCommReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
	<input type="hidden" name="CommReqBoxSortMtd" value="<%=strCommReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
	<input type="hidden" name="ReqBoxPage" value="<%=strCurrentPage%>"><!--������ ��ȣ -->

	<input type=hidden name=ReqSchId VALUE="<%=strReqScheId%>">
	<input type=hidden name=strCurrentPage value="<%=strCurrentPage%>"> <!--����¡ �Ķ����-->

      <!-- pgTit -->

         <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strOrganNm%>
		<!-- ������ ���� ���̰� ũ�⶧���� �� ���� ���� ����
		&nbsp;<%=strReqNm%>������--></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=MenuConstants.GOTO_HOME%> > <%=MenuConstants.REQ_SUBMIT_MAIN_MENU%> > <%=MenuConstants.REQUEST_BOX_COMM%> > <%=MenuConstants.REQ_BOX_SCH %></div>
        <p>�ش� �䱸������ �䱸�� ���� ����� Ȯ���ϴ� ȭ���Դϴ�. </p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <!-- /�˻�����-->


        <!-- �������� ���� -->
         <!-- list view-->

        <span class="list02_tl">�䱸���� ���� </span>
        <table cellspacing="0" cellpadding="0" class="list02">


                        <tr>
                            <th height="25">&bull;&nbsp;������� </th>
                            <td height="25"><%=strCdNm%> </td>
                            <th height="25" width="149">&bull;&nbsp;ȸ�� </th>
                            <td height="25">�� [<%=strNatCnt%>]ȸ ��ȸ </td>
                    </tr>
                        <tr>
                            <th height="25">&bull;&nbsp;�������� </th>
                            <td height="25"><%=strAcptBgnDt%> </td>
                            <th height="25" width="149">&bull;&nbsp;�������� </th>
                            <td height="25"><%=strAcptEndDt%> </td>
                        </tr>
                        <tr>
                            <th height="25">&bull;&nbsp;���⸶�� </th>
                            <td height="25" colspan="3"><%=strSubmtDln%> </td>

            </tr>
        </table>
        <!-- /list view -->
        <!--<p class="warning mt10">* �䱸�� �߼� : �ǿ���(�Ǵ� �Ҽӱ��) ���Ƿ� �ش� �������� �䱸���� �߼��մϴ�.</p>  -->
<!-- ����Ʈ ��ư
�䱸����
�䱸���� ���
�䱸���� ����
�䱸���� ����
���

-->
         <div id="btn_all"class="t_right">
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
	<% if(strIngStt.equals("001")) { %>
	<!--�䱸���� ��ư -->
			 <span class="list_bt"><a href="#" onclick="javascript:fUsrAction2('reqend',form1.ReqScheId.value);">�䱸����</a></span>
	<%}%>
	<% if(strIngStt.equals("002")) { %>
		<% if ( intNatCnt == 0 ) { %>
		 <!--�䱸������� ��ư -->
			 <span class="list_bt"><a href="#" onclick="fUsrAction2('reqendback',form1.ReqScheId.value);">�䱸���� ���</a></span>
		<%}%>
	<%}%>
	<% if(strIngStt.equals("001")) { %>
	 <!--���� ��ư -->
			<span class="list_bt"><a href="#"
			onclick="fUsrAction('update', form1.ReqScheId.value, form1.OrganNm.value,form1.OrderInfo.value, form1.AcptBgnDt.value, form1.AcptEndDt.value,  form1.SubmtDln.value, form1.AuditYear.value,  form1.CmtOrganId.value, form1.NatCnt.value, form1.ReqScheId.value);">�䱸���� ����</a></span>
			<span class="list_bt"><a href="#" onclick="fUsrAction2('delet',form1.ReqScheId.value)">�䱸���� ����</a></span>
	<%}%>
			<span class="list_bt"><a href="#" onclick="fUsrActionBack('back',form1.AuditYear.value);">���</a></span>
<%}else{%>
		<span class="list_bt"><a href="#" onclick="fUsrActionBack('back',form1.AuditYear.value);" >���</a></span>
<%}%>
		 </div><!-- /����Ʈ ��ư-->
      <!-- list -->
        <span class="list01_tl">�䱸�Ը��<span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=objCommList.size()-1%>��</span></span>
		<input type=hidden name=ReqBoxCnt VALUE=" <%=objCommList.size()-1%>">
		<br>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>

              <th scope="col"><a href="#">NO</a></th>
              <th scope="col" style="width:70%; "><a href="#">�䱸�Ը�</a></th>
              <th scope="col"><a href="#">�������</a></th>
              <th scope="col"><a href="#">����Ͻ�</a></th>

            </tr>
          </thead>
          <tbody>
	<%
		if(objCommList.size()-1 != 0){
			int N = objCommList.size()-1;
			for (int i = 1; i < objCommList.size(); i++) {
				Hashtable objHashCommList = (Hashtable)objCommList.get(i);

				String strReqBoxID   = (String)objHashCommList.get("REQ_BOX_ID");
				String strReqBoxNm = (String)objHashCommList.get("REQ_BOX_NM");
				String strReqBoxStt  = (String)objHashCommList.get("REQ_BOX_STT");
				String strCdNM         = (String)objHashCommList.get("CD_NM");
				String strReqRegDt   = nads.lib.reqsubmit.util.StringUtil.getDate2((String)objHashCommList.get("REG_DT"));
				//strReqRegDt = strReqRegDt.substring(0, 4) + "-" + strReqRegDt.substring(4, 6) + "-" + strReqRegDt.substring(6, 8);
	%>
            <tr>

              <td><%=N%></td>
              <td style="text-align:center;"><a href="javascript:fUsrActionList('<%=strReqBoxStt%>','<%=strReqBoxID%>')"><%=strReqBoxNm%></a></td>
              <td><%=strCdNM%></td>
              <td><%=strReqRegDt%></td>
            </tr>
	<%
				N = N - 1;
			  }//end for
		}else{
	%>
			<tr>
              <td colspan="4" align="center">��ϵ� �䱸���� �����ϴ�.</td>
            </tr>
	<%
		}//end if ��� ��� ��.
	%>
          </tbody>
        </table>

        <!-- /list -->

        <!-- ����¡-->

			<%=objPaging.pagingTrans(PageCount.getLinkedString(
				strTotalCount , strCurrentPage, strCountPerPage
				)
			)%>

        <!-- /����¡-->


       <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option value="req_box_nm">�䱸�Ը�</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value=""/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="form1.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->
			<span class="right">
<%
     if (strKind.equals("004") & !strReqSubmitFlag.equals("004")) {
%>
	<% if(strIngStt.equals("001")) { %>
				<span class="list_bt"><a href="javascript:fUsrActionMake('make', form1.ReqScheId.value);">�䱸�� �ۼ�</a></span>
	<%}else{%>
	<%}%>
<%}%>
			</span>
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
    </div>
  </div>
</form>
  <jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>