<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*"%>
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
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>
<%
 UserInfoDelegate objUserInfo =null;
 CDInfoDelegate objCdinfo =null;
%>
<%@ include file="./RUserCodeInfoInc.jsp" %>
<%
 /*************************************************************************************************/
 /** 					�Ķ���� üũ Part 														  */
 /*************************************************************************************************/
  /**���õ� ����⵵�� ���õ� ����ȸID*/
  String strSelectedAuditYear= null; /**���õ� ����⵵*/
  String strSelectedCmtOrganID=null; /**���õ� ����ȸID*/

  /**�䱸�� �����ȸ�� �Ķ���� ����.*/
  RPreReqBoxListForm objParams=new RPreReqBoxListForm();
  /**�䱸��� ���� :: �Ҽ� ���.*/
  objParams.setParamValue("CmtOrganID",objUserInfo.getOrganID());
  /**�䱸�� ����: �ۼ��� �䱸��.*/
  objParams.setParamValue("ReqBoxStt",CodeConstants.REQ_BOX_STT_003);
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

 
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 ResultSetHelper objRs=null;				/**�䱸�� ��� */
 try{
   /**�䱸�� ���� �븮�� New */ 
   
   PreRequestBoxDelegate objReqBox=new PreRequestBoxDelegate();
   objRs=new ResultSetHelper(objReqBox.getRecordList(objParams));
     
 }catch(AppException objAppEx){
 	objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  	objMsgBean.setStrCode(objAppEx.getStrErrCode());
  	objMsgBean.setStrMsg(objAppEx.getMessage());
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
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">

<html>
<head>
<title>����ȸ ���� �䱸 ���� </title>
<link href="/css/System.css" rel="stylesheet" type="text/css">

<script language="JavaScript">

  /** ���Ĺ�� �ٲٱ� */
  function changeSortQuery(sortField,sortMethod){
  	formName.ReqBoxSortField.value=sortField;
  	formName.ReqBoxSortMtd.value=sortMethod;
  	document.formName.target = "";
  	formName.submit();
  }
  
    /** ����¡ �ٷΰ��� */
  function goPage(strPage){
  	formName.ReqBoxPage.value=strPage;
  	document.formName.target = "";
  	formName.submit();
  } 

	//�䱸 ���� �䱸 ���� Ȯ��
	/*
	function preAppoint(){
		if(hashCheckedReqBoxIDsCopy(formName)==false) return false;
		window.returnValue=getReqBoxIDs(formName);
		document.formName.target = "";
		self.close();
	}*/
	
  //�䱸 ���� Ȯ��
	function preAppoint(){
		if(hashCheckedReqBoxIDsCopy(formName)==false) return false;
		opener.formName.ReqBoxIDs.value=getReqBoxIDs(formName);
		opener.formName.method="post";
		opener.formName.action="/reqsubmit/common/PreReqAppointBoxListProc.jsp";
		opener.formName.submit(); 
		self.close();
	}
	

	

</script>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="628" border="0" cellspacing="0" cellpadding="0"  scrolling="yes">
  <tr class="td_reqsubmit"> 
    <td height="5"></td>
    <td height="5"></td>
  </tr>
  <tr> 
    <td width="14" height="10"></td>
    <td width="615" height="10"></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="25" valign="middle"><img src="/image/reqsubmit/icon_reqsubmit_soti.gif" width="9" height="9" align="absmiddle"> 
      <span class="soti_reqsubmit">���� �䱸 ���� </span></td>
  </tr>
  <tr>
    <td width="14" height="5"></td>
    <td height="14" class="text_s">���� �䱸�� ������ �䱸���� �������ּ���.</td>
  </tr>
  <tr> 
    <td width="14" height="5"></td>
    <td height="5" align="left" valign="top"><TABLE width=600 height="22" border=0 cellPadding=0 cellSpacing=0>
        <TBODY>
          <TR> 
            <TD class=soti_reqsubmit width="50%">&nbsp;</TD>
            <TD class=text_s vAlign=middle align=right width="50%" class="text_s">
              <!------------------------- COUNT (PAGE) ------------------------------------>
              &nbsp;&nbsp;<IMG 
            height=6 src="/image/common/icon_nemo_gray.gif" width=3 
            align=absMiddle >��ü �ڷ� �� : <%=intTotalRecordCount%>�� &nbsp;&nbsp;</TD>
          </TR>
        </TBODY>
      </TABLE></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="23" align="left" valign="top"><TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
      
      <form name="formName" method="<%=nads.lib.reqsubmit.EnvConstants.FORM_METHOD%>" action="<%=request.getRequestURI()%>">
             
          <%
			//�䱸��  ���� ���� ���� �ޱ�.
			String strReqBoxSortField=objParams.getParamValue("ReqBoxSortField");
			String strReqBoxSortMtd=objParams.getParamValue("ReqBoxSortMtd");
			
			//�䱸��  ���� ������ ��ȣ �ޱ�.
			String strReqBoxPagNum=objParams.getParamValue("ReqBoxPage");
			
		  %>
			  <input type="hidden" name="ReqBoxSortField" value="<%=strReqBoxSortField%>"><!--�䱸��  ��������ʵ� -->
			  <input type="hidden" name="ReqBoxSortMtd" value="<%=strReqBoxSortMtd%>"><!--�䱸��  ������ɹ��-->
			  <input type="hidden" name="ReqBoxPage" value="<%=strReqBoxPagNum%>"><!--�䱸��  ������ ��ȣ -->
			  <input type="hidden" name="ReturnUrl" value="<%=request.getParameter("ReturnUrl")%>"><!--�ǵ��ƿ� URL -->
     
        <TBODY>
          <TR> 
            <TD class=td_reqsubmit height=2></TD>
          </TR>
          <TR class=td_top align=middle> 
            <TD> <TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
                <TBODY>
                  <TR class=td_top> 
                    <TD align=middle width=10 height=22><INPUT 
                  onclick=checkAllOrNot(document.formName); type=checkbox 
                  name=checkAll></TD>
                    <TD align=middle width=19>NO</TD>
                    
				    <TD align="center" width=210><%=SortingUtil.getSortLink("changeSortQuery","REQ_BOX_NM",strReqBoxSortField,strReqBoxSortMtd,"�䱸�Ը�")%></td>
				    <TD align="center" width=100><%=SortingUtil.getSortLink("changeSortQuery","SUBMT_ORGAN_NM",strReqBoxSortField,strReqBoxSortMtd,"��������")%></td>
				    <TD align="center" width=80><%=SortingUtil.getSortLink("changeSortQuery","RLTD_DUTY",strReqBoxSortField,strReqBoxSortMtd,"��������")%></td>
                    <TD align="center" width=80><%=SortingUtil.getSortLink("changeSortQuery","REG_DT",strReqBoxSortField,strReqBoxSortMtd,"�����")%></td>
                  </TR>
                </TBODY>
              </TABLE></TD>
          </TR>
          <TR> 
            <TD class=td_reqsubmit height=1></TD>
          </TR>
		<%
		  int intRecordNumber=objRs.getRecordSize();
		  if(objRs.getRecordSize()>0){
		  	String strReqBoxID="";
		  	while(objRs.next()){
	  	 		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
		 %>								  
          <TR onmouseover="this.style.backgroundColor='#FCFDF0'" 
        onmouseout="this.style.backgroundColor=''"> 
            <TD> <TABLE cellSpacing=0 cellPadding=0 width=600 border=0>
                <TBODY>
                  <TR> 
                    <TD align=middle width=10 height=22><input type="checkbox" name="ReqBoxIDs" value="<%=strReqBoxID%>"></TD>
                    <TD align=middle width=19><%=intRecordNumber%></TD>
                    
                    <TD class=td_lmagin width=210><%=(String)objRs.getObject("REQ_BOX_NM")%></TD>
                    <TD align=middle width=100><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></TD>
                    <TD align=middle width=80><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></TD>
                    <TD align=middle width=80><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></TD>
                  </TR>
                </TBODY>
              </TABLE></TD>
          </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
			    intRecordNumber --;
			}//endwhile
		}else{
		%> 
		  <TR onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''">
			<TD align="center" height="22"><%=MenuConstants.REQ_BOX_PRE%>�� �����ϴ�.</TD>
		  </TR>
          <TR class=tbl-line> 
            <TD height=1></TD>
          </TR>
		<%
		}//end if ��� ��� ��.
		%>		         
           <tr> 
                <td height="35" align="center">
                	<!-----------------------------------------  ����¡ �׺���̼� ---------------------------------------->
                	<%= PageCount.getLinkedString(
							new Integer(intTotalRecordCount).toString(),
							new Integer(intCurrentPageNum).toString(),
							objParams.getParamValue("ReqBoxPageSize"))
					%>
                </td>
          </tr>
		  
          <TR class=tbl-line> 
            <TD height=2></TD>
          </TR>
        </TBODY>
        </form>
      </TABLE></td>
  </tr>
  <tr> 
    <td width="14">&nbsp;</td>
    <td height="40" align="left"><table width="600" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td height="25" align="right">
			
				<img src="/image/button/bt_appoint.gif" height="20"  style="cursor:hand" onClick="preAppoint();">
			
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
