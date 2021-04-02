<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="java.util.List.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RPreReqBoxListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.SPreReqBoxDelegate" %>
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
<%@ include file="../../../common/RUserCodeInfoInc.jsp" %>

<%!
	private static String getLocationTitle(String strTitle, String strLocation) {
		float fTitle =strTitle.length() * 1.8f;
		float fLocation=strLocation.length() * 1.2f;
		float fMiddle=100-(fLocation+fTitle);
		StringBuffer strReturnStr = new StringBuffer();
        strReturnStr.append("<table width="+"100%"+" height="+"23"+" border="+"0"+" cellpadding="+"0"+" cellspacing="+"0"+"> ");
        strReturnStr.append("<tr> ");
        strReturnStr.append("<td width="+fTitle+"%"+" background="+"/image/reqsubmit/bg_reqsubmit_tit.gif"+">");
        strReturnStr.append("<span class="+"title"+">"+strTitle+"</span>");
        strReturnStr.append("</td>");
        strReturnStr.append("<td width="+fMiddle+"%"+" align="+"left"+" background="+"/image/common/bg_titLine.gif"+">&nbsp;</td>");
        strReturnStr.append("<td width="+fLocation+"%"+" align="+"right"+" background="+"/image/common/bg_titLine.gif"+" class="+"text_s"+">");
        strReturnStr.append("<img src="+"/image/common/icon_navi.gif"+" width="+"3"+" height="+"5"+" align="+"absmiddle"+">&nbsp;"+strLocation+"</td>");
        strReturnStr.append("</tr>");
        strReturnStr.append("</table>");
		return strReturnStr.toString();
	}
%>


<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  //�α��� ����� ������ �����´�. ���Ѿ��� ��� ������ �����ϴ�.
  String strReqSubmitFlag = objUserInfo.getReqSubmitFlag();

  /**���õ� ����⵵�� ���õ� ����ȸID*/
  String strSelectedAuditYear= null; /**���õ� ����⵵*/
  String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/
  String strRltdDuty=null; 			 /**���õ� �������� */

  /**�䱸�� �����ȸ�� �Ķ���� ����.*/
  RPreReqBoxListForm objParams=new RPreReqBoxListForm();
  /**�䱸��� ���� :: �Ҽ� ���.*/

  /** ����ȸ �������� �϶��� ȭ�鿡 �����.*/

  if(objUserInfo.getOrganGBNCode().equals("003")){
  objParams.setParamValue("CmtOrganID",strSelectedCmtOrganID);
  }else{
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  }
  //�ش�����ȸ�� �������� ���� ���
  if(objUserInfo.getCurrentCMTList().isEmpty()){
  	objParams.setParamValue("CmtOrganID","XXXXXXXXXX");
  }


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
  strRltdDuty=objParams.getParamValue("RltdDuty") ; 			 /**���õ� �������� */
  String strID = objUserInfo.getOrganID();
%>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 PreRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/

 SPreReqBoxDelegate selfDelegate = null; // �䱸-����κ� �ǽð����� ��Ȳ �����ش� -by yan

 ResultSetHelper objRs=null;				/**�䱸�� ��� */
 ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */
 ResultSetHelper objRltdDutyRs=null;   /** �������� ����Ʈ ��¿� RsHelper */
 try{
   /**�䱸�� ���� �븮�� New */
   objReqBox=new PreRequestBoxDelegate();
   selfDelegate = new SPreReqBoxDelegate(); //-by yan

	//�ش�����ȸ�� �������� ���� ���
	if(objUserInfo.getCurrentCMTList().isEmpty()){
		List lst = objUserInfo.getCurrentCMTList();
		Hashtable objHash = new Hashtable();
		objHash.put("ORGAN_ID", "XXXXXXXXXX");
		objHash.put("ORGAN_NM", "XXXXXXXXXX");
		lst.add(objHash);

		objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(lst,null));
	} else {
		/*
		out.println("�̿����� ����ȸ ��� ����<BR>");
		List objList = objUserInfo.getCurrentCMTList();
		for(int z=0; z<objList.size(); z++) {
			Hashtable objHash = (Hashtable)objList.get(z);
			out.println(objHash.get("ORGAN_ID"));
			out.println(" : " + objHash.get("ORGAN_NM")+"<BR>");
			z++;
		}
		if (1==1) return;
		*/
	 	objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));
 	} //endif

   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));

   /** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
   //if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) && !StringUtil.isAssigned(strSelectedCmtOrganID)){

	if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear)){
 		strSelectedAuditYear = (String)objCmtRs.getObject("AUDIT_YEAR");
 		strSelectedCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
	    objParams.setParamValueIfNull("CmtOrganID",strSelectedCmtOrganID);
   }

   objRs=new ResultSetHelper(objReqBox.getRecordList(objParams)); //�䱸�� ���
   objRltdDutyRs=new ResultSetHelper(objCdinfo.getRelatedDutyList());
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
	System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  	objMsgBean.setStrCode("SYS-00010");//AppException����.
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	//out.println("Error:" + objAppEx.getMessage());
  	%>
	<jsp:forward page="/common/message/ViewMsg.jsp"/>
  	<%
  	return;
 }
%>

<%
 /*************************************************************************************************/
 /** 					������ �� �Ҵ�  Part 														  */
 /*************************************************************************************************/

 /**�䱸���� �����ȸ�� ��� ��ȯ.*/
 int intTotalRecordCount=objRs.getTotalRecordCount();
 int intCurrentPageNum=objRs.getPageNumber();
 int intTotalPage=objRs.getTotalPageCount();
%>
<jsp:include page="/inc/header.jsp" flush="true"/>
<link href="/css2/style.css" rel="stylesheet" type="text/css">
<script language="javascript">
<!--
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
	  	/**��Ÿ����ȸ�� �޸� ǥ���ϱ� 2004.06.04*/
	  	String strTmpCmtOrganNm=(String)objCmtRs.getObject("CMT_ORGAN_NM");
	  	String strTmpCmtOrganID=(String)objCmtRs.getObject("CMT_ORGAN_ID");
	  	if(objUserInfo.getIsMyCmtOrganID(strTmpCmtOrganID)==false){
	  	   strTmpCmtOrganNm=StringUtil.getOtherCmtOrganNm(strTmpCmtOrganNm);
	  	}
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
	var field=formName.AuditYear;
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
       	var field=formName.CmtOrganID;
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
    makePerYearCmtList(formName.AuditYear.options[formName.AuditYear.selectedIndex].value);
  }//end of func
  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
  	formName.submit();
  }
  //�䱸�Ի󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqBoxID.value=strID;
  	formName.action="./RBasicReqBoxVList.jsp";
  	formName.submit();
  }
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
  	formName.submit();
  }
  /**�⵵�� ����ȸ�θ� ��ȸ�ϱ� */
  function gotoHeadQuery(){
  	formName.ReqBoxQryField.value="";
  	formName.ReqBoxQryTerm.value="";
  	formName.ReqBoxSortField.value="";
  	formName.ReqBoxSortMtd.value="";
  	formName.ReqBoxPage.value="";
  	formName.submit();
  }
 -->
</script>
</head>

<body onload="init()">
<div id="wrap">
  <jsp:include page="/inc/top.jsp" flush="true"/>
  <jsp:include page="/inc/top_menu02.jsp" flush="true"/>
  <div id="container">
    <div id="leftCon">
      <jsp:include page="/inc/log_info.jsp" flush="true"/>
      <jsp:include page="/inc/left_menu02.jsp" flush="true"/>
    </div>
    <div id="rightCon">
<form name="formName" method="get" action="<%=request.getRequestURI()%>">
		  <%//���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
		  %>
			<input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸�Ը�������ʵ� -->
			<input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸�Ը�����ɹ��-->
			<input type="hidden" name="ReqBoxPage" value="<%=intCurrentPageNum%>"><!--������ ��ȣ -->

			<input type="hidden" name="ReqBoxID" value=""><!--�䱸�Թ�ȣ �Ϲ������δ� ���ȵ�-->

      <!-- pgTit -->
	            <%
                // ���꿡 ��ó�� ������ Ÿ��Ʋ��� ��ġ�� ǥ���ϴ� ���̺� �ٸ� �������ִ� �κ� -modify 06.29
                  String strTitle = MenuConstants.REQ_BOX_PRE;
				  String strLocation = MenuConstants.GOTO_HOME+" > "+MenuConstants.REQ_SUBMIT_MAIN_MENU+" > "+MenuConstants.REQUEST_BOX_COMM+" > "+MenuConstants.REQUEST_BOX_PRE+" > <B>"+MenuConstants.REQ_BOX_PRE+"</B>";
				%>
      <div id="pgTit" style="background:url(/images2/foundation/stl_bg02.gif) no-repeat left top;">
        <h3><%=strTitle%></h3>
        <div class="navi"><img src="/images2/foundation/home.gif" width="13" height="11" /> <%=strLocation%></div>
        <p><!--����--></p>
      </div>
      <!-- /pgTit -->

      <!-- contents -->

      <div id="contents">

        <!-- �˻����� ���� ��� �Ʒ� div ���� �� �ּ����� ��������.-->
        <div class="schBox">
          <p>�䱸����ȸ����</p>
          <span class="line"><img src="/images2/foundation/search_line.gif" width="172" height="3" /></span>
          <div class="box">
            <!-- ������ �˻� ����Ʈ�� ��ư�� ��������-->
            <select name="AuditYear" onChange="changeCmtList()"></select>
			<select name="CmtOrganID"></select>
			<select name="RltdDuty">
				<option value="">��������(��ü)</option>
			<%
			   /**�������� ����Ʈ ��� */
			   while(objRltdDutyRs!=null && objRltdDutyRs.next()){
					String strCode=(String)objRltdDutyRs.getObject("MSORT_CD");
					out.println("<option value=\"" + strCode + "\" " + StringUtil.getSelectedStr(strRltdDuty,strCode) + ">" + objRltdDutyRs.getObject("CD_NM") + "</option>");
			   }
			%>
			</select>
            <a href="javascript:gotoHeadQuery();"><img src="/images2/btn/bt_search2.gif" width="50" height="22" /></a> </div>
        </div>
        <!-- /�˻�����-->

        <!-- �������� ���� -->

        <!-- list -->

        <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=intTotalRecordCount%>�� (<%=intCurrentPageNum%> / <%=intTotalPage%> page)</span>


        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="list01">
          <thead>
            <tr>
              <th scope="col" style="width:15px;"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"NO")%></th>
              <th scope="col" style="width:250px;"><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","",strReqBoxSortField,strReqBoxSortMtd,"����/�䱸")%></th>
              <th scope="col"><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"�����")%></th>
            </tr>
          </thead>
          <tbody>
		<%
		  int intRecordNumber=intTotalRecordCount;
		  if(objRs.getRecordSize()>0){
			String strReqBoxID="";
			while(objRs.next()){
			 strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");

			 Hashtable countHash = (Hashtable)selfDelegate.getReqBoxRelateCount(strReqBoxID);
		 %>
            <tr>
              <td><%= intRecordNumber %></td>
              <td><a href="javascript:gotoDetail('<%=strReqBoxID%>')"><%=(String)objRs.getObject("REQ_BOX_NM")%></a></td>
              <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%>
			  </td>
              <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
              <td><%=(String)objRs.getObject("SUBMT_CNT")%> / <%=(String)objRs.getObject("REQ_CNT")%></td>
              <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
            </tr>
			<%
					intRecordNumber --;
				}//endwhile
			}else{
			%>
			<tr>
				<td colspan="6" align="center">��ϵ� ���� �䱸 �ڷ����� �����ϴ�.</td>
            </tr>
			<%
			}//end if ��� ��� ��.
			%>
          </tbody>
        </table>

        <!-- /list -->
		<%=objPaging.pagingTrans(PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize")))%>
        <!-- ����¡-->
         <!-- /����¡-->
        <!--  <p class="warning">* �䱸���� �߼��ϰ� �Ǹ� �ش� ���� ��� ��ǥ ����ڿ��� ���� �߼۵Ǹ�, ����ڰ� ���� ���� �ۼ� �� �䱸�Կ� �״�� �����ְ� �˴ϴ�.  </p>
          <p class="warning">* �䱸�� �߼� ��ư�� �̿��Ͻñ� ���ؼ��� ����ȸ�� ������ �ֽñ� �ٶ��ϴ�.  </p>  -->



        <!-- ����Ʈ ��ư-->
        <div id="btn_all" >        <!-- ����Ʈ �� �˻� -->
        <div class="list_ser" >
		<%
			String strReqBoxQryField=objParams.getParamValue("ReqBoxQryField");
		%>
          <select name="ReqBoxQryField" class="selectBox5"  style="width:70px;" >
            <option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_nm">�䱸�Ը�</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("req_box_nm"))? " selected ": ""%>value="req_box_dsc">�䱸�Լ���</option>
			<option <%=(strReqBoxQryField.equalsIgnoreCase("submt_organ_nm"))? " selected ": ""%>value="req_box_nm">������</option>
          </select>
          <input name="ReqBoxQryTerm" onKeyDown="return ch()" onMouseDown="return ch()"
		 class="li_input"  style="width:100px" value="<%=objParams.getParamValue("ReqBoxQryTerm")%>"/>
          <img src="/images2/btn/bt_list_search.gif"  onMouseOver="menuOn(this);" onMouseOut="menuOut(this);" onClick="formName.submit();"/> </div>
        <!-- /����Ʈ �� �˻� -->

		<span class="right">
		<%
		//���� ����
		if(!strReqSubmitFlag.equals("004")){
		 /** ����ڿ�  �α����ڰ� �������� ȭ�鿡 �����.*/
		 if(objUserInfo.getOrganGBNCode().equals("004")){
		 %>
			<span class="list_bt"><a href="../10_databoxmk/RNewPreBoxMake.jsp">�䱸�� �ۼ�</a></span>
		<% }//end if-getOrganGBNCode()
		}// end if  ���� ����  %>
		</span>
		</div>

        <!-- /����Ʈ ��ư-->

        <!-- /�������� ���� -->
      </div>
      <!-- /contents -->

    </div>
  </div>
</form>
<jsp:include page="/inc/footer.jsp" flush="true"/>
</div>
</body>
</html>