<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.kcc.bf.db.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>

<%!
	private final static String strLicenseKey = "c61746b3-1d40-4847-9e81-936a88475523";
%>

<%
	//System.out.println("[ezPDFAnyWhere(register.jsp)] register start");
	/** 클라이언트에서 보내오는 입력 파라미터 */
	String strUserID = StringUtil.getEmptyIfNull(request.getParameter("userID"));
	String strUserName = StringUtil.getEmptyIfNull(request.getParameter("userName"));
	String strCompanyName = StringUtil.getEmptyIfNull(request.getParameter("cmpnyName"));
	String strMacAddr = StringUtil.getEmptyIfNull(request.getParameter("macAddr"));
	//String strMacAddr = "c61746b3-1d40-4847-9e81-936a88475523";
	strMacAddr = StringUtil.ReplaceString(strMacAddr, " ", "");
	String strSvrKey = StringUtil.getEmptyIfNull(request.getParameter("svrKey"));
	strSvrKey = StringUtil.ReplaceString(strSvrKey, "\n", "");
	strSvrKey = StringUtil.ReplaceString(strSvrKey, "\t", "");
	strSvrKey = StringUtil.ReplaceString(strSvrKey, " ", "");

	//System.out.println(strUserID+"==> OK");
	//System.out.println(strUserName+"==> OK");
	//System.out.println(strCompanyName+"==> OK");
	//System.out.println(strMacAddr+"==> OK");
	//System.out.println(strSvrKey+"==> OK");

	String strRegCount = null;
	String strRegInfoID = null;
	String strRegKey = null;

	if (!StringUtil.isAssigned(strSvrKey) || !StringUtil.isAssigned(strMacAddr) || !StringUtil.isAssigned(strUserID)) {
		response.reset();
		out.println("DNY,1,필수 입력 값이 누락되었습니다.");
		return;
	}
	
	if (!strLicenseKey.equalsIgnoreCase(strSvrKey)) {
		response.reset();
		out.println("DNY,1,등록 오류-Server License가 일치하지 않습니다.");
		//System.out.println("[ezPDFAnyWhere(register.jsp)] 설정된 License Key : " +strLicenseKey);
		//System.out.println("[ezPDFAnyWhere(register.jsp)] 파라미터 Server Key : " +strSvrKey);
		return;
	}
	
	StringBuffer strSQL = new StringBuffer();
	DBAccess objDAO=null;
	Vector objVec = new Vector();
	Hashtable objHashResult = new Hashtable();
	int intResult = 0;
	
	try {
		objDAO = new DBAccess(this.getClass());
		strSQL.append("SELECT MAX(reg_info_id) AS maxRegInfoID FROM TBDS_ezPDF_REG_INFO ");
		objDAO.setSQL(strSQL.toString());
		objDAO.doQuery();
		objHashResult = objDAO.getSingleHashtable();
		int intMaxRegInfoID = 0;
		intMaxRegInfoID = Integer.parseInt((String)objHashResult.get("MAXREGINFOID"));
		// 한번 작업했으니 DBConn, SQL, Hashtable을 초기화 해서 다시 쓰자
		objDAO.init();
		strSQL.setLength(0);
		objHashResult.clear();

		strSQL.append("SELECT COUNT(reg_info_id) AS RS_COUNT FROM TBDS_ezPDF_REG_INFO ");
		strSQL.append(" WHERE user_addr='"+strMacAddr+"'");
		objDAO.setSQL(strSQL.toString());
		objDAO.doQuery();
		objHashResult = objDAO.getSingleHashtable();
		int intRsCount = Integer.parseInt((String)objHashResult.get("RS_COUNT"));
		// 한번 작업했으니 DBConn, SQL, Hashtable을 초기화 해서 다시 쓰자
		objDAO.init();
		strSQL.setLength(0);
		objHashResult.clear();
		
		if (intRsCount > 0) {
			strSQL.append("SELECT reg_info_id, reg_count, user_addr FROM TBDS_ezPDF_REG_INFO ");
			strSQL.append(" WHERE user_addr='"+strMacAddr+"'");
			
			objDAO.setSQL(strSQL.toString());
			objDAO.doQuery();
			objHashResult = objDAO.getSingleHashtable();
			strRegCount = (String)objHashResult.get("REG_COUNT");
			strRegInfoID = (String)objHashResult.get("REG_INFO_ID");
		}
		
		// 한번 작업했으니 DBConn, SQL, Hashtable을 초기화 해서 다시 쓰자
		objDAO.init();
		strSQL.setLength(0);
		objHashResult.clear();
		
		if (StringUtil.isAssigned(strRegInfoID)) { // 값이 있다
			// UPDATE
			strSQL.append("UPDATE tbds_ezPDF_reg_info SET user_id=?, user_name=?, company_name=?, ");
			strSQL.append(" reg_date=TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'), reg_key=?, ");
			strSQL.append(" reg_count=? WHERE reg_info_id=?");

			strRegKey = strMacAddr+strMacAddr+strMacAddr.substring(0, 8);
			intRsCount = intRsCount+1;
			//System.out.println("[ezPDFAnyWhere(register.jsp)] Reg Key : "+strRegKey);
			
			objVec.add(strUserID);
			objVec.add(strUserName);
			objVec.add(strCompanyName);
			objVec.add(strRegKey);
			objVec.add(strRegCount);
			objVec.add(strRegInfoID);
			
			objDAO.setSQL(strSQL.toString(), objVec);
			intResult = objDAO.doUpdate();
			
		} else {
			// INSERT
			strSQL.append("INSERT INTO tbds_ezPDF_reg_info (reg_info_id, user_addr, user_id, user_name, ");
			strSQL.append(" company_name, reg_date, reg_count, reg_key) ");
			strSQL.append(" VALUES(?, ?, ?, ?, ?, TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3'), 1, ?) ");
			
			strRegKey = strMacAddr+strMacAddr+strMacAddr.substring(0, 8);

			//System.out.println("[ezPDFAnyWhere(register.jsp)] Reg Key : "+strRegKey);
			String hyu = String.valueOf(intMaxRegInfoID+1);
			objVec.add(hyu);
			objVec.add(strMacAddr);
			objVec.add(strUserID);
			objVec.add(strUserName);
			objVec.add(strCompanyName);
			objVec.add(strRegKey);
			
			objDAO.setSQL(strSQL.toString(), objVec);
			intResult = objDAO.doUpdate();
		}
		
		if (intResult > 0) {
			response.reset();
			out.println("ACK,1,"+strRegKey);
		} else {
			response.reset();
			out.println("DNY,1,등록오류");
		}
		
	} catch(DBAccessException e) {
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