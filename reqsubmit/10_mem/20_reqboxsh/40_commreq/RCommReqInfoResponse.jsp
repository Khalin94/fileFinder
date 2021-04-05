<%@ page language="java" contentType="text/xml; charset=EUC-KR" %>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.cmtsubmt.CmtSubmtReqBoxDelegate" %>
<%!
	public String getOffiDocID(String strXML) throws Exception {
		String strReturnOffiDocID = StringUtil.getCutString(strXML, "<SUID>", "</SUID>");
		int intLastP1 = strReturnOffiDocID.lastIndexOf('[');
		int intLastP2 = strReturnOffiDocID.indexOf(']');
		strReturnOffiDocID = strReturnOffiDocID.substring(intLastP1+1, intLastP2);
		return strReturnOffiDocID;
	}
%>

<%   
    /*******************************************************************/
    /** 전자결재 요청 처리 (위원회 제출신청서용)                         */
    /*******************************************************************/
    /*
	System.out.println("=================전자결재 위원회 제출신청서 ===================");
	
	if(request.getParameterNames()!=null){
	    for(java.util.Enumeration enum=request.getParameterNames();enum.hasMoreElements();){
	    	String strTmpKey=(String)enum.nextElement();
	    	System.out.println("Key:" + strTmpKey);
	    	System.out.println("Value:" + request.getParameter(strTmpKey));
	    }
    }
    */
    
	CmtSubmtReqBoxDelegate objReqBox = new CmtSubmtReqBoxDelegate();	
	StringBuffer strBufReturnXml = new StringBuffer();
	boolean blnReturn = false;
	String strSystemID = request.getParameter("systemid");
	String strBusinessID = StringUtil.getEmptyIfNull(request.getParameter("businessid"));
	String strDocID = StringUtil.getEmptyIfNull(request.getParameter("docid"));
	String strLegacyIn = StringUtil.getEmptyIfNull(request.getParameter("legacyin"));
	String strEventCode = StringUtil.getEmptyIfNull(request.getParameter("event"));
	String strOffiDocID = "";
	String[] strReturns=null;	
	String strReqBoxID = "";//신청함ID
	String strCmtOrganID="";//위원회ID
	if(StringUtil.isAssigned(strLegacyIn)){
		//strOffiDocID=StringUtil.getCutString(strLegacyIn, "<SUID>", "</SUID>");
		strOffiDocID = getOffiDocID(strLegacyIn);
		strReturns=objReqBox.getCmtSubmitReqBoxID(strOffiDocID);
		strReqBoxID = strReturns[0];//신청함ID
		strCmtOrganID=strReturns[1];//위원회ID
	}
	
	
	if (!StringUtil.isAssigned(strReqBoxID)) {
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>");
		strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>");
		strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>");
		strBufReturnXml.append("</REPLY>");
	}else{
	
		// 전자결재쪽 이벤트 코드에 따라서 작업을 다르게 진행한다.
		if (CodeConstants.ELC_EVENT_0X01.equalsIgnoreCase(strEventCode)) {		 			// ELC_EVENT_0X01 : 상신
			
			// 요구함 정보 업데이트
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_006).booleanValue();
			
		} else if (CodeConstants.ELC_EVENT_02.equalsIgnoreCase(strEventCode)) {			// ELC_EVENT_02 : 기안회수 
			
			// 요구함 정보 업데이트
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_007).booleanValue();
		
		} else if (CodeConstants.ELC_EVENT_0X02.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X02 : 기안보류
			
			// 요구함 정보 업데이트
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_008).booleanValue();
		
		} else if (CodeConstants.ELC_EVENT_0X08.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X08 : 결재완료
	
			//체크 위원회 일정
			String strReqScheID="";
			strReqScheID=objReqBox.checkHavingCommSche(strCmtOrganID);
			if(StringUtil.isAssigned(strReqScheID)){//일정이 있으면
				//위원회 일정이 있으면 결재최종완료 CMT_SUBMT_REQ_BOX_STT_005
				blnReturn = objReqBox.approveCmtSubmtReqBox(strReqBoxID,true).booleanValue();			
			}else{//일정없으면.
				blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_003).booleanValue();
			}
		} else if (CodeConstants.ELC_EVENT_0X16.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X16 : 반려
			blnReturn = objReqBox.approveCmtSubmtReqBox(strReqBoxID,false).booleanValue();			
		}
		
		if (blnReturn) {
			strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
			strBufReturnXml.append("<REPLY>\n");
			strBufReturnXml.append("<REPLY_CODE>1</REPLY_CODE>\n");
			strBufReturnXml.append("<DESCRIPTION>SUCCESS</DESCRIPTION>\n");
			strBufReturnXml.append("</REPLY>");
		} else {
			strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
			strBufReturnXml.append("<REPLY>\n");
			strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>\n");
			strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>\n");
			strBufReturnXml.append("</REPLY>");
		}
	}//endif 요구함체크끝.
	try{
		response.reset();
	}catch(Exception e){}
	out.println(strBufReturnXml.toString());
%>