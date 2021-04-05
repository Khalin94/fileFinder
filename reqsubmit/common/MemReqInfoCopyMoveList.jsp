<%@ page language="java" contentType="text/html;charset=EUC-KR" %>

<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="kr.co.kcc.bf.config.*"%>
<%@ page import="kr.co.kcc.pf.util.PageCount"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.ResultSetHelper" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxCopyMoveListForm" %>
<%@ page import="nads.dsdm.app.reqsubmit.MenuConstants"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>

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
  RMemReqBoxCopyMoveListForm objParams=new RMemReqBoxCopyMoveListForm();
  /**�䱸��� ���� :: �Ҽ� ���.*/
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
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

  /** �䱸 �̵����� ���� ����: �⺻�� ���� */
  boolean blnIsReqMove=false;
  if(StringUtil.isAssigned(request.getParameter("IsReqMove"))){
  	blnIsReqMove=true;
  }
%>
<% 
 /*************************************************************************************************/
 /** 					������ ȣ�� Part 														  */
 /*************************************************************************************************/

 /*** Delegate �� ������ Container��ü ���� */
 ResultSetHelper objRs=null;				/**�䱸�� ��� */
 try{
   /**�䱸�� ���� �븮�� New */ 
   MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();
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

<jsp:include page="/inc/header.jsp" flush="true"/>
<SCRIPT language="JavaScript" src="/js/reqsubmit/common.js"></SCRIPT>
<script language="JavaScript">
	//�䱸 ���� Ȯ��
	function copyReqInfo(){
		if(hashCheckedReqBoxIDsCopy(formName)==false) return false;
		opener.formName.ReqBoxIDs.value=getReqBoxIDs(formName);
		opener.formName.method="post";
		opener.formName.action="/reqsubmit/common/MemReqInfoCopyMoveListProc.jsp";
		opener.formName.submit(); 
		self.close();
	}
	
	//�䱸 �̵� 
	function moveReqInfo(){
		if(hashCheckedReqBoxIDsMove(formName)==false) return false;
		opener.formName.ReqBoxIDs.value=getReqBoxIDs(formName);
		opener.formName.method="post";
		opener.formName.action="/reqsubmit/common/MemReqInfoCopyMoveListProc.jsp?IsReqMove=YES";
		opener.formName.submit(); 
		self.close();
	}
	
	
	function checkBoxValidate(cb) {
		for (j=0; j<<%= objRs.getRecordSize()%>; j++) {
			if (eval("document.formName.ReqBoxIDs[" + j + "].checked") == true) {
				document.formName.ReqBoxIDs[j].checked = false;
				if (j == cb) {
					document.formName.ReqBoxIDs[j].checked = true;
         		}
      		}
   		}
	}
	
	
</script>
</head>

<body>
<div class="popup">
    <p>�䱸����</p>
    
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td style="padding:10px;"><span class=" warning">�ۼ� ���� �䱸�� ��� <%=(blnIsReqMove)? "�̵��� " : "�����" %> �䱸���� �������ּ���. </span> <span class="list_total">&bull;&nbsp;��ü�ڷ�� : <%=objRs.getRecordSize()%>�� </span> 
                <!-- list -->
<form name="formName" method="post">                
                <table border="0" cellspacing="0" cellpadding="0" class="popup_lis">
                    <tr>
                        <th colspan="2" scope="col">NO</th>
                        <th scope="col">����ȸ��</th>
                        <th  style="width:40%; "  scope="col">�䱸�Ը�</th>
                        <th scope="col">��������</th>
                        <th scope="col">��������</th>
                        <th scope="col">�����<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
                    </tr>
		<%
		  int intRecordNumber=objRs.getRecordSize();
		  int k = 0;
		  if(objRs.getRecordSize()>0){
		  	String strReqBoxID="";
		  	while(objRs.next()){
	  	 		strReqBoxID=(String)objRs.getObject("REQ_BOX_ID");
		 %>	
                    <tr>
                        <td ><input name="ReqBoxIDs" type="checkbox" value="<%=strReqBoxID%>" class="borderNo" onClick="javascript:checkBoxValidate(<%= k%>);"/></td>
                        <td><%=intRecordNumber%></td>
                        <td><%=(String)objRs.getObject("CMT_ORGAN_NM")%></td>
                        <td ><%=(String)objRs.getObject("REQ_BOX_NM")%></td>
                        <td><%=(String)objRs.getObject("SUBMT_ORGAN_NM")%></td>
                        <td><%=objCdinfo.getRelatedDuty((String)objRs.getObject("RLTD_DUTY"))%></td>
                        <td><%=StringUtil.getDate((String)objRs.getObject("REG_DT"))%></td>
                    </tr>
		<%
			    intRecordNumber --;
			    k++;
			}//endwhile
		}else{
		%> 
					</tr>
					   <td colspan="7" align="center"><%=MenuConstants.REQ_BOX_MAKE%>�� �����ϴ�.</td>
                    </tr>
		<%
		}//end if ��� ��� ��.
		%>	
                </table>
                
                <!-- /list --></td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- ����Ʈ ��ư-->
    <div id="btn_all"  class="t_right">
	<%if(blnIsReqMove){%>
		<span class="list_bt"><a href="#" onClick="moveReqInfo();">�̵�</a></span>&nbsp;&nbsp; 
	<%}else{ %>
		<span class="list_bt"><a href="#" onClick="copyReqInfo();">����</a></span>&nbsp;&nbsp; 	
	<%}//endif%>
	</div>
    
    <!-- /����Ʈ ��ư--> 
</div>
</form>
</body>
</html>