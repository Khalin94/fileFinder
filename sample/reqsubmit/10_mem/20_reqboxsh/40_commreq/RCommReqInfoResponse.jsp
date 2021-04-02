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
    /** ���ڰ��� ��û ó�� (����ȸ �����û����)                         */
    /*******************************************************************/
    /*
	System.out.println("=================���ڰ��� ����ȸ �����û�� ===================");
	
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
	String strReqBoxID = "";//��û��ID
	String strCmtOrganID="";//����ȸID
	if(StringUtil.isAssigned(strLegacyIn)){
		//strOffiDocID=StringUtil.getCutString(strLegacyIn, "<SUID>", "</SUID>");
		strOffiDocID = getOffiDocID(strLegacyIn);
		strReturns=objReqBox.getCmtSubmitReqBoxID(strOffiDocID);
		strReqBoxID = strReturns[0];//��û��ID
		strCmtOrganID=strReturns[1];//����ȸID
	}
	
	
	if (!StringUtil.isAssigned(strReqBoxID)) {
		strBufReturnXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>");
		strBufReturnXml.append("<REPLY>");
		strBufReturnXml.append("<REPLY_CODE>0</REPLY_CODE>");
		strBufReturnXml.append("<DESCRIPTION>FAIL</DESCRIPTION>");
		strBufReturnXml.append("</REPLY>");
	}else{
	
		// ���ڰ����� �̺�Ʈ �ڵ忡 ���� �۾��� �ٸ��� �����Ѵ�.
		if (CodeConstants.ELC_EVENT_0X01.equalsIgnoreCase(strEventCode)) {		 			// ELC_EVENT_0X01 : ���
			
			// �䱸�� ���� ������Ʈ
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_006).booleanValue();
			
		} else if (CodeConstants.ELC_EVENT_02.equalsIgnoreCase(strEventCode)) {			// ELC_EVENT_02 : ���ȸ�� 
			
			// �䱸�� ���� ������Ʈ
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_007).booleanValue();
		
		} else if (CodeConstants.ELC_EVENT_0X02.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X02 : ��Ⱥ���
			
			// �䱸�� ���� ������Ʈ
			blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_008).booleanValue();
		
		} else if (CodeConstants.ELC_EVENT_0X08.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X08 : ����Ϸ�
	
			//üũ ����ȸ ����
			String strReqScheID="";
			strReqScheID=objReqBox.checkHavingCommSche(strCmtOrganID);
			if(StringUtil.isAssigned(strReqScheID)){//������ ������
				//����ȸ ������ ������ ���������Ϸ� CMT_SUBMT_REQ_BOX_STT_005
				blnReturn = objReqBox.approveCmtSubmtReqBox(strReqBoxID,true).booleanValue();			
			}else{//����������.
				blnReturn = objReqBox.changeReqBoxStt(strReqBoxID, CodeConstants.CMT_SUBMT_REQ_BOX_STT_003).booleanValue();
			}
		} else if (CodeConstants.ELC_EVENT_0X16.equalsIgnoreCase(strEventCode)) {		// ELC_EVENT_0X16 : �ݷ�
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
	}//endif �䱸��üũ��.
	try{
		response.reset();
	}catch(Exception e){}
	out.println(strBufReturnXml.toString());
%>