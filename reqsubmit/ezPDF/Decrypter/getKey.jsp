<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.db.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	/** Ŭ���̾�Ʈ���� �������� 3���� �Ķ���� */
	String strDocID = StringUtil.getEmptyIfNull(request.getParameter("docid"));
	String strRegKey = StringUtil.getEmptyIfNull(request.getParameter("keys1"));
	strRegKey = StringUtil.ReplaceString(strRegKey, "\n", "");
	strRegKey = StringUtil.ReplaceString(strRegKey, "\t", "");
	strRegKey = StringUtil.ReplaceString(strRegKey, " ", "");
	String strMacAddr = StringUtil.getEmptyIfNull(request.getParameter("keys2"));
	strMacAddr = StringUtil.ReplaceString(strMacAddr, "\n", "");
	strMacAddr = StringUtil.ReplaceString(strMacAddr, "\t", "");
	strMacAddr = StringUtil.ReplaceString(strMacAddr, " ", "");
	
	StringBuffer strSQL = new StringBuffer();
	DBAccess objDAO=null;

	//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] doc ID : "+strDocID);
	//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Reg Key : "+strRegKey);
	//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Mac Addr : "+strMacAddr);

	if (!StringUtil.isAssigned(strDocID) || !StringUtil.isAssigned(strRegKey) || !StringUtil.isAssigned(strMacAddr)) {
		response.reset();
		out.println("DocID : "+strDocID+", RegKey(keys1) : "+strRegKey+", Mac Addr(keys2) : "+strMacAddr);
		return;
	}

	try {
		strSQL.append("SELECT user_addr FROM TBDS_ezPDF_REG_INFO ");
		strSQL.append(" WHERE reg_key='"+StringUtil.ReplaceString(strRegKey, " ", "")+"'");
		//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] execute SQL : " +strSQL.toString());
		objDAO = new DBAccess(this.getClass());
		objDAO.setSQL(strSQL.toString());
		objDAO.doQuery();
		Hashtable objHashResult = objDAO.getSingleHashtable();
		String strRsRegKey = (String)objHashResult.get("USER_ADDR");
		//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Reg Key : " +strRsRegKey);
		
		// �ѹ� �۾������� DBConn, SQL, Hashtable�� �ʱ�ȭ �ؼ� �ٽ� ����
		objDAO.init();
		strSQL.setLength(0);
		objHashResult.clear();
		
		if (strRsRegKey.equalsIgnoreCase(strMacAddr)) { // �����ϴٸ� ��� ����
			int intHashDocID = strDocID.hashCode();
			if (intHashDocID < 0) intHashDocID = intHashDocID  * -1;
			System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Hash Doc ID : " +intHashDocID);
			int intKeyNo = intHashDocID%1000; // ���ڿ��� hashcode�� ���� key�� ���ؿ� �ڸ����� ���Ѵ�.
			//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Key No : " +intKeyNo);
			
			strSQL.append("SELECT enc_key FROM TBDS_ezPDF_enc_key ");
			strSQL.append(" WHERE enc_key_id="+intKeyNo);
			
			//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] execute SQL2 : " +strSQL.toString());
			objDAO.setSQL(strSQL.toString());
			objDAO.doQuery();
			objHashResult = objDAO.getSingleHashtable();
			String strRsEncKey = (String)objHashResult.get("ENC_KEY");
			
			//System.out.println("[ezPDFAnyWhere(Decrypt-getKey.jsp)] Enc Key : " +strRsEncKey);
			
			if (StringUtil.isAssigned(strRsEncKey)) {
				response.reset();
				out.println("ACK,1,"+strRsEncKey);
			} else {
				response.reset();
				out.println("DNY,1,����ID����");
			}
			
		} else { // Ʋ���ٸ� �׷��� ������ �ٽ� Ŭ���̾�Ʈ�� �˸�
			response.reset();
			out.println("DNY,1,��ϵ� ����ڰ� �ƴ�");
		}
		
	} catch(DBAccessException e) {
		response.reset();
		out.println("DNY,1,��ϵ� ����ڰ� �ƴ�(in Exception)");
		throw new AppException(e.getMessage(), e, e.getErrCode());
	} finally {
		try{
			objDAO.release();
		} catch(DBAccessException e) {
			throw new AppException(e.getMessage(), e, e.getErrCode());
		} catch(Exception e) {
			throw new AppException(e.getMessage(), e);
		}
	} //end of finally
%>