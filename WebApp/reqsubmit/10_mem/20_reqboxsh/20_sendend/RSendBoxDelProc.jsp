<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.MemRequestBoxDelegate" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.SendReqBoxDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.ResultSetSingleHelper" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestinfo.CommRequestInfoDelegate" %>
<%@ page import="nads.lib.reqsubmit.params.requestinfo.RCommReqLogForm" %>
<%@ page import="nads.dsdm.app.common.ums.UmsInfoDelegate" %>
<%@ page import="kr.co.kcc.bf.config.*" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/******************************************************************************
	* Name		  : RMakeReqBoxDelProc.jsp
	* Summary	  : 요구함 삭제  처리 기능.
	* Description : 요구함 정보를 삭제하고 요구함 목록 으로 이동한다.
	* 				※※ 체크 ※※
	*				 아직 에러처리후 포워딩 페이지로 넘기지 않음.
	******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	
	String webURL = ""; //http 주소
	try {
		Config objConfig = PropertyConfig.getInstance(); //프로퍼티
		webURL = objConfig.get("nads.dsdm.url");
	} catch (ConfigException objConfigEx) {
		out.println(objConfigEx.toString() + "<br>");
		return;
	}
%>
<%@ include file="/reqsubmit/common/RUserCodeInfoInc.jsp" %>

<%
	String[] arrReqBoxID = request.getParameterValues("ReqBoxIDs");
	String strCmtOrganID = (String)request.getParameter("CmtOrganID");
	String strAuditYear = (String)request.getParameter("AuditYear");
	int intLenReqBoxIDs = arrReqBoxID.length;

	if(intLenReqBoxIDs < 1){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg("파라미터(요구함 ID)가 전달되지 않았습니다");
		//out.println("ParamError:" + "파라미터(요구함 ID)가 전달되지 않았습니다");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	RCommReqLogForm objParams = new RCommReqLogForm();
	boolean blnParamCheck=false;
	/**전달된 파리미터 체크 */
	blnParamCheck = objParams.validateParams(request);
	if(blnParamCheck == false){
		objMsgBean.setMsgType(MessageBean.TYPE_WARN);
		objMsgBean.setStrCode("DSPARAM-0000");
		objMsgBean.setStrMsg(objParams.getStrErrors());
		out.println("ParamError:" + objParams.getStrErrors());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	boolean blnEditOk = false; //삭제 여부.
	int resultInt = -1; //삭제 여부.
	int intResultCnt = 0;
	String strMsg = "";
	int misCnt = 0;
	
	try {
		/********* 대리자 정보 설정 *********/
		MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();
		SendReqBoxDelegate objSReqBox = new SendReqBoxDelegate();

		/********* 데이터 삭제 하기  **************/
		// 2005-09-27 kogaeng ADD
		// 단일 요구함 삭제에서 목록에서 여러 개의 요구함을 한꺼번에 삭제할 수 있는 기능으로 추가.
		for(int i=0; i<intLenReqBoxIDs; i++) {
			
			// 현재 답변이 진행중인 상황이라면 삭제 과정을 진행할 수 없다. 
			// true가 반환되면 삭제가 가능하다라는 얘기. true ==> N
			// false가 반환되면 삭제할 수 없다라는 것이니 false ==> Y
			if(objSReqBox.checkDelReqBoxPermit(arrReqBoxID[i])) {
				objSReqBox.removeReqFile(arrReqBoxID[i]);
				objSReqBox.removeSubmitFile(arrReqBoxID[i]);
				//resultInt = objSReqBox.removeAllRecord(arrReqBoxID[i]);
				blnEditOk = ((Boolean)objReqBox.removeRecord(arrReqBoxID[i])).booleanValue();
				intResultCnt++;
			}
		}
		misCnt = intLenReqBoxIDs - intResultCnt;
		
		if(misCnt > 0){
			strMsg = "전체 "+intLenReqBoxIDs+" 개 중 "+intResultCnt+" 개의 요구함 정보가 삭제되었습니다. "+misCnt+ " 개의 요구함은 답변진행 상태입니다.";
		}else{
			strMsg = "전체 "+intLenReqBoxIDs+" 개 중 "+intResultCnt+" 개의 요구함 정보가 삭제되었습니다 ";
		}
		

	} catch(AppException objAppEx){ 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException에러.
	  	objMsgBean.setStrMsg(objAppEx.getMessage());
  		//out.println("<br>Error!!!" + objAppEx.getMessage());
%>
	  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
  		return; 
	}
%>

<script language="JavaScript">
	
	var oLastBtn=0; 
    bIsMenu = false; 

    //No RIGHT CLICK************************ 
    // **************************** 
    if (window.Event) document.captureEvents(Event.MOUSEUP); 
    function nocontextmenu() { 
        event.cancelBubble = true 
        event.returnValue = false; 
        return false; 
    } 

    function norightclick(e) { 
        if (window.Event) { 
            if (e.which !=1) return false; 
        } else { 
            if (event.button !=1) { 
                event.cancelBubble = true 
                event.returnValue = false; 
                return false; 
            } 
        } 
    } 

    document.oncontextmenu = nocontextmenu; 
    document.onmousedown = norightclick; 

    // Block backspace onKeyDown************ 
    function onKeyDown() { 
        if ( (event.altKey) || ((event.keyCode == 8) && 
            (event.srcElement.type != "text" && 
            event.srcElement.type != "textarea" && 
            event.srcElement.type != "password")) || 
            ((event.ctrlKey) && ((event.keyCode == 78) || (event.keyCode == 82)) ) || 
            (event.keyCode == 116) ) { 
            event.keyCode = 0; 
            event.returnValue = false; 
        } 
    } 
  	//2018-09-20 hgyoo 화면 로딩창 수정
	//parent.notProcessing();
	var elem = parent.document.getElementById('loading_layer');
	elem.parentNode.removeChild(elem);

	alert("<%=strMsg%>");
	parent.location.href='/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp?AuditYear=<%= strAuditYear %>';
	self.close();
</script>		
