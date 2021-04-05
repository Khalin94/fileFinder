<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="kr.co.kcc.bf.db.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%
	StringBuffer strSQL = new StringBuffer();
	DBAccess objDAO=null;
	Vector objVec = new Vector();
	String strBuf = null;
	String strEncKeyFile = "/mnt/nads/reqsubmit/EncKey.txt";
		
	try {
		strSQL.append("INSERT INTO tbds_ezPDF_enc_key ");
		strSQL.append(" VALUES(?, ?)");
		objDAO = new DBAccess(this.getClass());
		
		BufferedReader bufreader = new BufferedReader(new FileReader(strEncKeyFile));
		int i=0;
		while(true) {
			strBuf = bufreader.readLine();
			if(strBuf == null) break;
			strBuf.trim();
			out.println(i+" : "+strBuf);
			
			objVec.add(String.valueOf(i));
			objVec.add(strBuf);
			
			objDAO.setSQL(strSQL.toString(), objVec);
			int intResult = objDAO.doUpdate();
			out.println(intResult);
			objVec.clear();
			i++;
		}
		
	} catch(DBAccessException e) {
		throw new AppException(e.getMessage(), e, e.getErrCode());
	} catch(IOException e) {
		throw new AppException(e.getMessage());
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