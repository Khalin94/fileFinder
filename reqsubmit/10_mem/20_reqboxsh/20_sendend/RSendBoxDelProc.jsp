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
	* Summary	  : �䱸�� ����  ó�� ���.
	* Description : �䱸�� ������ �����ϰ� �䱸�� ��� ���� �̵��Ѵ�.
	* 				�ء� üũ �ء�
	*				 ���� ����ó���� ������ �������� �ѱ��� ����.
	******************************************************************************/
	UserInfoDelegate objUserInfo =null;
	CDInfoDelegate objCdinfo =null;
	
	String webURL = ""; //http �ּ�
	try {
		Config objConfig = PropertyConfig.getInstance(); //������Ƽ
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
		objMsgBean.setStrMsg("�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
		//out.println("ParamError:" + "�Ķ����(�䱸�� ID)�� ���޵��� �ʾҽ��ϴ�");
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

	RCommReqLogForm objParams = new RCommReqLogForm();
	boolean blnParamCheck=false;
	/**���޵� �ĸ����� üũ */
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

	boolean blnEditOk = false; //���� ����.
	int resultInt = -1; //���� ����.
	int intResultCnt = 0;
	String strMsg = "";
	int misCnt = 0;
	
	try {
		/********* �븮�� ���� ���� *********/
		MemRequestBoxDelegate objReqBox=new MemRequestBoxDelegate();
		SendReqBoxDelegate objSReqBox = new SendReqBoxDelegate();

		/********* ������ ���� �ϱ�  **************/
		// 2005-09-27 kogaeng ADD
		// ���� �䱸�� �������� ��Ͽ��� ���� ���� �䱸���� �Ѳ����� ������ �� �ִ� ������� �߰�.
		for(int i=0; i<intLenReqBoxIDs; i++) {
			
			// ���� �亯�� �������� ��Ȳ�̶�� ���� ������ ������ �� ����. 
			// true�� ��ȯ�Ǹ� ������ �����ϴٶ�� ���. true ==> N
			// false�� ��ȯ�Ǹ� ������ �� ���ٶ�� ���̴� false ==> Y
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
			strMsg = "��ü "+intLenReqBoxIDs+" �� �� "+intResultCnt+" ���� �䱸�� ������ �����Ǿ����ϴ�. "+misCnt+ " ���� �䱸���� �亯���� �����Դϴ�.";
		}else{
			strMsg = "��ü "+intLenReqBoxIDs+" �� �� "+intResultCnt+" ���� �䱸�� ������ �����Ǿ����ϴ� ";
		}
		

	} catch(AppException objAppEx){ 
 		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
		System.out.println("SysErrorCode:" + objAppEx.getStrErrCode());
  		objMsgBean.setStrCode("SYS-00010");//AppException����.
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
  	//2018-09-20 hgyoo ȭ�� �ε�â ����
	//parent.notProcessing();
	var elem = parent.document.getElementById('loading_layer');
	elem.parentNode.removeChild(elem);

	alert("<%=strMsg%>");
	parent.location.href='/reqsubmit/10_mem/20_reqboxsh/20_sendend/RSendBoxList.jsp?AuditYear=<%= strAuditYear %>';
	self.close();
</script>		
