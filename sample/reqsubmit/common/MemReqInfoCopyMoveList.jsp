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
 /** 					파라미터 체크 Part 														  */
 /*************************************************************************************************/
  /**선택된 감사년도와 선택된 위원회ID*/
  String strSelectedAuditYear= null; /**선택된 감사년도*/
  String strSelectedCmtOrganID=null; /**선택된 위원회ID*/

  /**요구함 목록조회용 파라미터 설정.*/
  RMemReqBoxCopyMoveListForm objParams=new RMemReqBoxCopyMoveListForm();
  /**요구기관 설정 :: 소속 기관.*/
  objParams.setParamValue("ReqOrganID",objUserInfo.getOrganID());
  boolean blnParamCheck=false;
  /**전달된 파리미터 체크 */
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

  /** 요구 이동인지 복사 인지: 기본은 복사 */
  boolean blnIsReqMove=false;
  if(StringUtil.isAssigned(request.getParameter("IsReqMove"))){
  	blnIsReqMove=true;
  }
%>
<% 
 /*************************************************************************************************/
 /** 					데이터 호출 Part 														  */
 /*************************************************************************************************/

 /*** Delegate 과 데이터 Container객체 선언 */
 ResultSetHelper objRs=null;				/**요구함 목록 */
 try{
   /**요구함 정보 대리자 New */ 
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
	//요구 복사 확인
	function copyReqInfo(){
		if(hashCheckedReqBoxIDsCopy(formName)==false) return false;
		opener.formName.ReqBoxIDs.value=getReqBoxIDs(formName);
		opener.formName.method="post";
		opener.formName.action="/reqsubmit/common/MemReqInfoCopyMoveListProc.jsp";
		opener.formName.submit(); 
		self.close();
	}
	
	//요구 이동 
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
    <p>요구복사</p>
    
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td style="padding:10px;"><span class=" warning">작성 중인 요구함 가운데 <%=(blnIsReqMove)? "이동될 " : "복사될" %> 요구함을 선택해주세요. </span> <span class="list_total">&bull;&nbsp;전체자료수 : <%=objRs.getRecordSize()%>개 </span> 
                <!-- list -->
<form name="formName" method="post">                
                <table border="0" cellspacing="0" cellpadding="0" class="popup_lis">
                    <tr>
                        <th colspan="2" scope="col">NO</th>
                        <th scope="col">위원회명</th>
                        <th  style="width:40%; "  scope="col">요구함명</th>
                        <th scope="col">제출기관명</th>
                        <th scope="col">업무구분</th>
                        <th scope="col">등록일<img src="/images2/btn/bt_td.gif" width="11" height="11" alt="" /></th>
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
					   <td colspan="7" align="center"><%=MenuConstants.REQ_BOX_MAKE%>이 없습니다.</td>
                    </tr>
		<%
		}//end if 목록 출력 끝.
		%>	
                </table>
                
                <!-- /list --></td>
        </tr>
    </table>
    <p style= "height:2px;padding:0;"></p>
    <!-- 리스트 버튼-->
    <div id="btn_all"  class="t_right">
	<%if(blnIsReqMove){%>
		<span class="list_bt"><a href="#" onClick="moveReqInfo();">이동</a></span>&nbsp;&nbsp; 
	<%}else{ %>
		<span class="list_bt"><a href="#" onClick="copyReqInfo();">복사</a></span>&nbsp;&nbsp; 	
	<%}//endif%>
	</div>
    
    <!-- /리스트 버튼--> 
</div>
</form>
</body>
</html>