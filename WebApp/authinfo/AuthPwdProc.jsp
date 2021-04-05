<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="nads.lib.message.MessageBean" %>
<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%
	/*GET �Ķ����*/
	String strCurrentPage =  StringUtil.getNVLNULL(request.getParameter("strCurrentPage")); //���� ������
	String strGoToPage = StringUtil.getNVLNULL(URLDecoder.decode(request.getParameter("strGoToPage"), "UTF-8"));	//��ũ�� ������
	String strBbrdID =  StringUtil.getNVLNULL(request.getParameter("bbrdid"));						//�Խ��� ���̵�
	String strDataID =  StringUtil.getNVLNULL(request.getParameter("dataid"));						//�Խù� ���̵�
	String strPwdCmd =  StringUtil.getNVLNULL(request.getParameter("pwdcmd"));					//����
	String strCfmPwd = StringUtil.getNVLNULL(request.getParameter("cfmpwd"));					//�Խù� ��й�ȣ
	
	/*�ʱⰪ ���� */ 
	nads.dsdm.app.board.SLBoardDelegate objAuthBoard = new nads.dsdm.app.board.SLBoardDelegate();
	Hashtable objHshDataInfo = null;
	
	try {
		
		//1. �Խù� ������ �����´�.
		objHshDataInfo = objAuthBoard.selectBbrdDataInfo(strDataID);
	
	} catch (AppException objAppEx) {

			objMsgBean.setMsgType(MessageBean.TYPE_ERR);
			objMsgBean.setStrCode(objAppEx.getStrErrCode());
			objMsgBean.setStrMsg(objAppEx.getMessage());
		
			// ���� �߻� �޼��� �������� �̵��Ѵ�.
%>
			<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
			return;
		
		}
	
	//2. ��й�ȣ�� Ȯ���Ѵ�.
	String strDataPwd = (String)objHshDataInfo.get("DATA_PWD");
	
	if(strDataPwd.equals(strCfmPwd)){
		
		//��й�ȣ�� ��ġ�ϸ� ���� �Ǵ� ���� ȭ���� �����ش�.UpdateAuthBoard
		String strUrl = null;
		
		if(strPwdCmd.equals("CFM_UPDATE")){
		
			out.println("<script language=javascript>");
	        out.println("opener.location.href='"+strGoToPage+"?strCurrentPage="+strCurrentPage+"&bbrdid="+strBbrdID+"&dataid="+strDataID + "';");
	        out.println("self.close();");
	        out.println("</script>");
        
        } else if (strPwdCmd.equals("CFM_DELETE")) {
        	
        	out.println("<script language=javascript>");
			out.println("opener.goToDelete();");
			out.println("self.close();");
	        out.println("</script>");
	        
		}
	
	} else {
	
			//����� �����ϸ� â�� �ݰ� �� �������� Reload�Ѵ�.
			out.println("<script language=javascript>");
            out.println("alert('��й�ȣ�� ��ġ���� �ʽ��ϴ�.')");
            out.println("history.back();");
            out.println("</script>");
	
	}
%>


			