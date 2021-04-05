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

<!--%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreReqInfoVListForm" %-->
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RPreAppointListForm" %>

<%@ page import="nads.dsdm.app.reqsubmit.SortingUtil"%>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.prereqbox.PreRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.prereqinfo.PreRequestInfoDelegate" %>
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
  /**���õ� ����⵵�� ���õ� ����ȸID*/
  String strSelectedAuditYear= null; /**���õ� ����⵵*/

  /**�Ϲ� �䱸�� �󼼺��� �Ķ���� ����.*/
  RPreAppointListForm objParams =new RPreAppointListForm();
  //RPreReqInfoVListForm objParams =new RPreReqInfoVListForm();

  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());/**�䱸���ID*/

  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());/**�䱸���ID*/

  //objParams.setParamValue("ReqInfoSortField","reg_dt");/**�����亯���� Default*/
  //objParams.setParamValue("IsRequester",String.valueOf(objUserInfo.isRequester())); //�䱸�亯�ڿ��μ���



  boolean blnParamCheck=false;

  /**���޵� �ĸ����� üũ */
  blnParamCheck=objParams.validateParams(request);
  if(blnParamCheck==false){
  	objMsgBean.setMsgType(MessageBean.TYPE_WARN);
  	objMsgBean.setStrCode("DSPARAM-0000");
  	objMsgBean.setStrMsg(objParams.getStrErrors());
  	out.println("ParamError:" + objParams.getStrErrors());
   	return;
  }//endif
  strSelectedAuditYear= objParams.getParamValue("AuditYear"); /**���õ� ����⵵*/

%>

<%
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 PreRequestBoxDelegate objReqBox=null; 		/**�䱸�� Delegate*/
 PreRequestInfoDelegate  objReqInfo=null;	/** �䱸���� Delegate */

 ResultSetHelper objRs=null;				/**�䱸 ��� */
 ResultSetSingleHelper objRsSH=null;		/** �䱸�� �󼼺��� ���� */
 ResultSetHelper objCmtRs=null;			/** ������ ����ȸ */



 try{

   //�䱸�� ���� �븮�� New
   objReqBox=new PreRequestBoxDelegate();
   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getCurrentCMTList(),null));

   // �䱸�� ����
   objRsSH=new ResultSetSingleHelper(objReqBox.getRecord((String)objParams.getParamValue("ReqBoxID")));


   String strCmtID=(String)request.getParameter("CmtOrganID");
   String strSubmtID=(String)request.getParameter("SubmtOrganID");
   String strAuditYear=(String)request.getParameter("AuditYear");
   String strRltdDuty=(String)request.getParameter("RltdDuty");

   //String strCmtOrganNM=(String)request.getParameter("CmtOrganNM");
   //String strSubmtOrganNM=(String)request.getParameter("SubmtOrganNM");

   //objCmtRs=new ResultSetHelper(objReqBox.getReqrPerYearCMTList(objUserInfo.getOrganID(),null));
   /** �Ķ���ͷ� ���� ������ ���� ��� ����Ʈ���� ������.*/
   if(objCmtRs.next() && !StringUtil.isAssigned(strSelectedAuditYear) ){
		strSelectedAuditYear=(String)objCmtRs.getObject("AUDIT_YEAR");
 	    objParams.setParamValueIfNull("AuditYear",strSelectedAuditYear);
   }
   /**�䱸 ���� �븮�� New */
   objReqInfo=new PreRequestInfoDelegate();
   objRs=new ResultSetHelper(objReqInfo.getRecordListA(objParams,strCmtID,strSubmtID,strAuditYear,strRltdDuty));




 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
  	out.println("<br>Error!!!" + objAppEx.getMessage());
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

<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<html>
<head>
<title>���� �䱸 �������� </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<script language="javascript">
  <%
 	//�޺� �ڽ��� �ڷ� �ֱ����� Array�� ������ �־��ִ� �κ�.
    out.println("var varSelectedYear='" + strSelectedAuditYear + "';");
	out.println("var arrPerYearCmt=new Array(" + objCmtRs.getTotalRecordCount() + ");");
	Vector vectorYear=new Vector();
	String strTmpYear="";
	String strOldYear="";
	objCmtRs.first();
	for(int i=0;objCmtRs.next();i++){
	  	strTmpYear=(String)objCmtRs.getObject("AUDIT_YEAR");
	    out.println("arrPerYearCmt[" + i + "]=new Array('"
			+ strTmpYear	+ "');");
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
		   if(varSelectedYear==tmpOpt.text){
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
  	formName.ReqInfoSortField.value=sortField;
  	formName.ReqInfoSortMtd.value=sortMethod;
  	formName.submit();
  }


  //�䱸 �󼼺���� ����.
  function gotoDetail(strID){
  	formName.ReqInfoID.value=strID;
  	formName.action="./RSubPreReqInfoVList.jsp";
  	formName.submit();
  }
  /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqInfoPage.value=strPage;
  	formName.submit();
  }

  function checkFormData(){
    if(hashCheckedReqInfoIDs(formName)==false) return false;

  	if(confirm('�����Ͻ� �䱸������ ���� �䱸�� �������ðڽ��ϱ�?')){
	  	formName.action="./RBasicReqInfoAppointListProc.jsp";
  		formName.submit();
  	}

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
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<table width="100%" border="0" cellspacing="0" cellpadding="0" valign="top">
  <tr class="td_reqsubmit">
    <td height="5"></td>
    <td height="5"></td>
  </tr>
 <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">


          <%
			//�䱸 ���� ���� ���� �ޱ�.
			String strReqInfoSortField=objParams.getParamValue("ReqInfoSortField");
			String strReqInfoSortMtd=objParams.getParamValue("ReqInfoSortMtd");

			//�䱸 ���� ������ ��ȣ �ޱ�.
			String strReqInfoPagNum=objParams.getParamValue("ReqInfoPage");
			String strReqBoxID =(String)request.getParameter("ReqBoxID");
			//

   			String strCmtID=(String)request.getParameter("CmtOrganID");
            String strSubmtID=(String)request.getParameter("SubmtOrganID");
            String strAuditYear=(String)request.getParameter("AuditYear");
            String strRltdDuty=(String)request.getParameter("RltdDuty");
            String strCmtOrganNM=(String)request.getParameter("CmtOrganNM");
            String strSubmtOrganNM=(String)request.getParameter("SubmtOrganNM");
		  %>


		  	  <input type="hidden" name="ReqBoxID" value="<%=strReqBoxID%>">
			  <input type="hidden" name="ReqInfoSortField" value="<%=strReqInfoSortField%>"><!--�䱸���� ��������ʵ� -->
			  <input type="hidden" name="ReqInfoSortMtd" value="<%=strReqInfoSortMtd%>"><!--�䱸���� ������ɹ��-->
			  <input type="hidden" name="ReqInfoPage" value="<%=strReqInfoPagNum%>"><!--�䱸���� ������ ��ȣ -->
			  <input type="hidden" name="ReqInfoID" value=""><!--�䱸���� ID-->

			  <input type="hidden" name="CmtOrganNM" value="<%=strCmtOrganNM%>">
			  <input type="hidden" name="SubmtOrganNM" value="<%=strSubmtOrganNM%>">
			  <input type="hidden" name="SubmtOrganID" value="<%=strSubmtID%>">
			  <input type="hidden" name="CmtOrganID" value="<%=strCmtID%>">
			  <input type="hidden" name="AuditYear" value="<%=strAuditYear%>">
			  <input type="hidden" name="RltdDuty" value="<%=strRltdDuty%>">

			  <input type="hidden" name="ReturnUrl" value="<%=request.getParameter("ReturnUrl")%>"><!--�ǵ��ƿ� URL -->

  <tr>
    <td width="14"></td>
    <td height="25" valign="middle"><img src="../image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
	<%//�䱸�� ���� ����.
		String strReqBoxStt=(String)objRsSH.getObject("REQ_BOX_ID");
	%>
      <img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle">
      <span class="soti_reqsubmit"><%=strCmtOrganNM%>&nbsp;&nbsp;<%=strSubmtOrganNM%>&nbsp;&nbsp;<%=MenuConstants.REQ_BOX_PRE%>&nbsp;&nbsp;�䱸 ��� </span></td>
  </tr>
  <tr>
    <td width="14" height="5"></td>
    &nbsp;&nbsp;<td height="14" class="text_s">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� �䱸�� ������ �䱸�� �����Ͻ� �� '����' ��ư�� Ŭ���� �ּ��� </td>
  </tr>
  <tr>
    <td width="14" height="5"></td>
    <td height="5" align="left" valign="top"><TABLE width=600 height="22" border=0 cellPadding=0 cellSpacing=0>
        <TBODY>
          <TR>

			<TD class=soti_reqsubmit width="50%">
				<!-------------------- TAB �� �ش��ϴ� ������ ����ϴ� ��������. ------------------------>
                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                		<tr>

				             <TD class=text_s vAlign=middle align=right width="50% class="text_s">
				            	<!------------------------- COUNT (PAGE) ------------------------------------>
				            	&nbsp;&nbsp;<img src="/image/common/icon_nemo_gray.gif" width="3"  align="absmiddle">
				            	��ü �ڷ� �� : <%=intTotalRecordCount%>�� &nbsp;&nbsp;
				            </td>
				       </tr>
				   </table>

			</TD>

          </TR>
        </TBODY>
      </TABLE></td>
  </tr>
  <tr>
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
        <TBODY>
          <TR>
            <TD class=td_reqsubmit height=2></TD>
          </TR>
          <TR class=td_top align=middle>
            <TD> <TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
                <TBODY>
                  <TR class=td_top>
                   <TD align="center" width=9 height=22><input type="checkbox" name="checkAll" onClick="checkAllOrNot(document.formName);"></td>
				   <TD align="center" width=22 height=22>NO</td>
				   <TD align="center" width=100>������</td>
				   <TD align="center" width=200><%=SortingUtil.getSortLink("changeSortQuery","REQ_ORGAN_NM",strReqInfoSortField,strReqInfoSortMtd,"�䱸����")%></td>
				   <TD align="center" width=100><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqInfoSortField,strReqInfoSortMtd,"�����")%></td>
				   <TD align="center" width=80><%=SortingUtil.getSortLink("changeSortQuery","REGR_NM",strReqInfoSortField,strReqInfoSortMtd,"�����")%></td>
				   <TD align="center" width=70><%=SortingUtil.getSortLink("changeSortQuery","PRE_REQ_APP_CNT",strReqInfoSortField,strReqInfoSortMtd,"�����䱸����Ƚ��")%></td>
				   <TD align="center" width=70>�亯</td>
                  </TR>
                </TBODY>
              </TABLE></TD>
          </TR>
          <TR>
            <TD class=td_reqsubmit height=1></TD>
          </TR>

		  <%
			  int intRecordNumber= intTotalRecordCount;
			  if(objRs.getRecordSize()>0){
			  String strReqInfoID  ="";
			  while(objRs.next()){
			 	 strReqInfoID=(String)objRs.getObject("REQ_ID");
		  %>
          <TR onmouseover="this.style.backgroundColor='#FCFDF0'"
        onmouseout="this.style.backgroundColor=''">
            <TD> <TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
                <TBODY>
                  <TR>
                    <TD align="center" width=9 height=22><input type="checkbox" name="ReqInfoIDs" value="<%=strReqInfoID%>"></td>
					<td align="center" width=22 height=22><%=intRecordNumber%></td>
					<td align="center" width=100><%=objRs.getObject("SUBMT_ORGAN_NM")%></td>
					<td class=td_lmagin width=200><%=objRs.getObject("REQ_CONT")%></td>
				    <td align="center" width=100><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
					<td align="center" width=80><%=objRs.getObject("REGR_NM")%></td>
					<td align="center" width=70><%=objRs.getObject("PRE_REQ_APP_CNT")%></td>
					<td width="70" align="center"><%=nads.lib.reqsubmit.util.DBAccessUtil.makeAnsInfoHtml((String)objRs.getObject("ANS_ID"),(String)objRs.getObject("ANS_MTD"),(String)objRs.getObject("ANS_OPIN"),(String)objRs.getObject("SUBMT_FLAG"),objUserInfo.isRequester())%></td>
                  </TR>
                   <TR class=tbl-line>
                     <TD height=1 colspan='8'></TD>
                   </TR>
                </TBODY>
              </TABLE></TD>
          <%
		      intRecordNumber --;
			}//endwhile
		}else{
		  %>
			      <tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
					<td align="center" colspan='8' height="22">������ �����Ǿ��� �䱸������ �����ϴ�.</td>
				  </tr>

		  <%
		}//end if ��� ��� ��.
		  %>
		  <TR class=tbl-line>
            <TD height=2 colspan='8'></TD>
          </TR>
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

          <TR class=tbl-line>
            <TD height=2></TD>
          </TR>
        </TBODY>
      </TABLE></td>
  </tr>
  <tr>
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="600" border="0" cellspacing="0" cellpadding="0">
       	<tr>
          <td height="25" align="right">
			<img src="/image/button/bt_appoint.gif" height="20"  style="cursor:hand" onClick="checkFormData();">
          </td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="25" colspan="2" align="right" class="td_gray1">&nbsp;<img src="/image/button/bt_close.gif" width="46" height="11" border="0" style="cursor:hand" onClick="self.close();">&nbsp;&nbsp;</td>
  </tr>
</table>
</body>
</html>
