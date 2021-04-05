<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="java.util.*" %>
<%@ page import="nads.lib.reqsubmit.CodeConstants"%>
<%@ page import="nads.lib.reqsubmit.util.StringUtil" %>
<%@ page import="kr.co.kcc.bf.db.*" %> 
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="java.io.*"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.answerinfo.AnsInfoDelegate" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<%
	String strMethod = StringUtil.getEmptyIfNull(request.getParameter("method"));
	String strColType = StringUtil.getEmptyIfNull(request.getParameter("fieldType"));
	String strColValue = StringUtil.getEmptyIfNull(request.getParameter("fieldValue"));
	String strPwd = StringUtil.getEmptyIfNull(request.getParameter("pwd"));
	String strWhereClause = "";

	if(!"naps337".equalsIgnoreCase(strPwd)) {
		out.println("<script language='javascript'>\n");
		out.println("alert(\"비밀번호가 틀렸습니다. 다시 입력 바랍니다.\");\n");
		out.println("</script>\n");
		out.println("<meta http-equiv='refresh' content='0; url=deleteTestDataForm.jsp?method="+strMethod+"'>\n");
		return;
	}
	
	if("1".equals(strMethod)) {
		if(!StringUtil.isAssigned(strColType) || !StringUtil.isAssigned(strColValue)) {
			out.println("<script language='javascript'>\n");
			out.println("alert(\"검색 필드 또는 검색어가 누락되었습니다. 다시 입력 바랍니다.\");\n");
			out.println("</script>\n");
			out.println("<meta http-equiv='refresh' content='0; url=deleteTestDataForm.jsp'>\n");
			return;
		}
		strWhereClause = " WHERE "+strColType+" like '"+strColValue+"%'";
	} else {
		strWhereClause = " WHERE user_nm like '교육%'";
	}
	
	try {

		AnsInfoDelegate objAnsDelegate = new AnsInfoDelegate();
		StringBuffer strSQL = new StringBuffer();
		DBAccess objDAO=null;
		Hashtable objReturnHash = new Hashtable();
		int intCount = 0;

		objDAO = new DBAccess(this.getClass());
		
		/**
		 *************************************************************************************
		 * NO : 1
		 * TABLE : tbds_send_info
		 * DESC : 요구서 발송 정보
		 *************************************************************************************
		 */
		strSQL.append(" select rownum, A.* ");
		strSQL.append(" FROM ( ");
		strSQL.append(" select A.*, B.req_box_nm from tbds_send_info A, ");
		strSQL.append(" (select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append(" WHERE A.REGR_ID = B.user_id ");
		strSQL.append(" ) B ");
		strSQL.append(" WHERE A.REQ_BOX_ID = B.req_box_id ");
		strSQL.append(" ORDER BY A.snd_id ");
		strSQL.append(" ) A ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();

		Vector objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(StringUtil.getEmptyIfNull(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0))));
			out.println("[TBDS_SEND_INFO] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strSndID = (String)((Vector)objReturnHash.get("SND_ID")).elementAt(i);
				out.println(strSndID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");
				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_send_info WHERE snd_id='"+strSndID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("요구서 발송 정보 테이블의 데이터 삭제 중 에러 <BR>");
			}
		}

		/**
		 *************************************************************************************
		 * NO : 2
		 * TABLE : tbds_req_log
		 * DESC : 요구 관련 로그 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, A.req_logid, b.req_id, b.user_id, b.user_nm from tbds_req_log A, ");
		strSQL.append("(select b.req_box_id, A.req_id, b.user_id, b.user_nm from tbds_request_info A, ");
		strSQL.append("(select req_box_id, regr_id, user_id, user_nm from tbds_request_box A, ");
		strSQL.append("(select user_id, user_nm from tbdm_user_info where user_nm like '교육%') B ");
		strSQL.append("WHERE A.REGR_ID = B.user_id) B ");
		strSQL.append("WHERE A.req_box_ID = B.req_box_id ");
		strSQL.append(") B ");
		strSQL.append("where a.req_id = b.req_id ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString());
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_REQ_LOG] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strReqLogID = (String)((Vector)objReturnHash.get("REQ_LOGID")).elementAt(i);
				out.println(strReqLogID+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_req_log WHERE req_logid='"+strReqLogID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("요구 관련 로그 테이블의 데이터 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 3
		 * TABLE : tbds_req_doc_info
		 * DESC : 요구서 정보
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append(" select rownum, A.* ");
		strSQL.append(" FROM ( ");
		strSQL.append(" select A.*, B.req_box_nm from tbds_req_doc_info A, ");
		strSQL.append(" (select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append(" WHERE A.REGR_ID = B.user_id ");
		strSQL.append(" ) B ");
		strSQL.append(" WHERE A.REQ_BOX_ID = B.req_box_id ");
		strSQL.append(" ORDER BY A.req_doc_id ");
		strSQL.append(" ) A ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_REQ_DOC_INFO] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strReqDocID = (String)((Vector)objReturnHash.get("REQ_DOC_ID")).elementAt(i);
				out.println(strReqDocID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_req_doc_info WHERE req_doc_id='"+strReqDocID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("요구서 정보 테이블의 데이터 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 4
		 * TABLE : tbds_gov_submt_data_box
		 * DESC : 회의자료함 정보 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append(" select rownum, submt_data_id from tbds_gov_submt_data_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append(" WHERE A.REGR_ID = B.user_id ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_GOV_SUBMT_DATA_BOX] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strSubmtDataID = (String)((Vector)objReturnHash.get("SUBMT_DATA_ID")).elementAt(i);
				out.println(strSubmtDataID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_gov_submt_data_box WHERE submt_data_id='"+strSubmtDataID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("회의자료함 테이블 데이터 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 5
		 * TABLE : tbds_official_doc_info
		 * DESC : 전자 문서 관련 정보 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append(" select rownum, A.* ");
		strSQL.append(" FROM ( ");
		strSQL.append(" select A.*, B.req_box_nm from tbds_official_doc_info A, ");
		strSQL.append(" (select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append(" WHERE A.REGR_ID = B.user_id ");
		strSQL.append(" ) B ");
		strSQL.append(" WHERE A.REQ_BOX_ID = B.req_box_id ");
		strSQL.append(" ORDER BY A.offi_doc_id ");
		strSQL.append(" ) A ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_OFFICIAL_DOC_INFO] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strOffiDocID = (String)((Vector)objReturnHash.get("OFFI_DOC_ID")).elementAt(i);
				out.println(strOffiDocID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_official_doc_info WHERE offi_doc_id='"+strOffiDocID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("전자 문서 관려 정보 테이블 데이터 삭제 중 에러 <BR>");
				
			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 6
		 * TABLE : tbds_ans_doc_info
		 * DESC : 답변서 문서 관련 정보 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append(" select rownum, A.* from ");
		strSQL.append(" (select A.ans_doc_id, B.req_box_nm from tbds_ans_doc_info A, ");
		strSQL.append(" (select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append(" WHERE A.REGR_ID = B.user_id ");
		strSQL.append(" ) B ");
		strSQL.append(" WHERE A.REQ_BOX_ID = B.req_box_id ");
		strSQL.append(" ORDER BY ans_doc_id) A ");
		strSQL.append(" ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_ANS_DOC_INFO] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strAnsDocID = (String)((Vector)objReturnHash.get("ANS_DOC_ID")).elementAt(i);
				out.println(strAnsDocID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_ans_doc_info WHERE ans_doc_id='"+strAnsDocID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("답변서 관련 정보 테이블 데이터 삭제 중 에러 <BR>");

			}
		}


		/**
		 *************************************************************************************
		 * NO : 7
		 * TABLE : tbds_answer_info
		 * DESC : 답변 정보
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select a.* from tbds_answer_info a, ");
		strSQL.append("(select a.req_id, a.req_box_id, b.req_box_id,b.req_box_nm from tbds_request_info A, ");
		strSQL.append("(select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.REGR_ID = B.user_id) B ");
		strSQL.append("where a.req_box_id = B.req_box_id) B ");
		strSQL.append("where a.req_id = b.req_id ");
		//strSQL.append("and a.ans_file_id IS NULL ");
		strSQL.append("ORDER BY ans_id) Z ");
		strSQL.append("ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_ANSWER_INFO] Data Count : " + intCount+"<BR>");
			
			Vector objAnsVec = (Vector)objReturnHash.get("ANS_ID");
			String[] arrAnsIDs = new String[intCount];
			for(int i=0; i<objAnsVec.size(); i++) {
				out.println("Vec Ans ID : " +(String)objAnsVec.elementAt(i)+"<BR>");
				arrAnsIDs[i] = (String)objAnsVec.elementAt(i);
			}
			
			objAnsDelegate.deleteRecord(arrAnsIDs, CodeConstants.REQ_BOX_STT_006);
		}

		
		/**
		 *************************************************************************************
		 * NO : 8
		 * TABLE : tbds_cmt_submt_req_info
		 * DESC : 위원회 제출 신청함 신청된 요구 정보 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select A.* from tbds_cmt_submt_req_info A, ");
		strSQL.append("(select * from tbds_cmt_submt_req_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.CMT_SUBMT_REQR_ID = B.user_id ");
		strSQL.append(") B ");
		strSQL.append("WHERE A.CMT_SUBMT_REQ_BOX_ID = B.cmt_submt_req_box_id ");
		strSQL.append("ORDER BY cmt_submt_req_id) Z ");
		strSQL.append("ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_CMT_SUBMT_REQ_INFO] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strCmtReqID = (String)((Vector)objReturnHash.get("CMT_SUBMT_REQ_ID")).elementAt(i);
				out.println(strCmtReqID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_cmt_submt_req_info WHERE cmt_submt_req_id='"+strCmtReqID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("제출신청함 신청 요구 정보 테이블 데이터 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 9
		 * TABLE : tbds_cmt_submt_req_box
		 * DESC : 위원회 제출 신청함 정보 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select A.cmt_submt_req_box_id from tbds_cmt_submt_req_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.CMT_SUBMT_REQR_ID = B.user_id ");
		strSQL.append("ORDER BY cmt_submt_req_box_id ");
		strSQL.append(") Z ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_CMT_SUBMT_REQ_BOX] Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strCmtReqBoxID = (String)((Vector)objReturnHash.get("CMT_SUBMT_REQ_BOX_ID")).elementAt(i);
				out.println(strCmtReqBoxID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_cmt_submt_req_box WHERE cmt_submt_req_box_id='"+strCmtReqBoxID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("제출신청함 신청 정보 테이블 데이터 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 10
		 * TABLE : tbds_request_info 
		 * DESC : 참조해서 생성한 요구 우선 삭제 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select A.* from tbds_request_info A, ");
		strSQL.append("(select * from tbds_request_box A, ");
		strSQL.append(" (select * from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.REGR_ID = B.user_id) B ");
		strSQL.append("WHERE A.req_box_id = B.req_box_id ");
		strSQL.append("AND A.ref_req_id IS NOT NULL ");
		strSQL.append("ORDER BY A.req_id) Z ");
		strSQL.append("ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_REQUEST_INFO] Is Ref Req Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strReqID = (String)((Vector)objReturnHash.get("REQ_ID")).elementAt(i);
				out.println(strReqID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_request_info WHERE req_id='"+strReqID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("참조되어서 생성된 요구 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 11
		 * TABLE : tbds_request_info 
		 * DESC : 요구 삭제 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select A.req_id, A.ref_req_id, A.req_box_id from tbds_request_info A, ");
		strSQL.append("(select regr_id, req_box_id from tbds_request_box A, ");
		strSQL.append(" (select user_id, user_nm from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.REGR_ID = B.user_id) B ");
		strSQL.append("WHERE A.req_box_id = B.req_box_id ");
		strSQL.append("AND A.ref_req_id IS NULL ");
		strSQL.append("ORDER BY A.req_id) Z ");
		strSQL.append("ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_REQUEST_INFO] Req Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strReqID = (String)((Vector)objReturnHash.get("REQ_ID")).elementAt(i);
				out.println(strReqID+"<BR>");
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_request_info WHERE req_id='"+strReqID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("요구 삭제 중 에러 <BR>");

			}
		}

		
		/**
		 *************************************************************************************
		 * NO : 12
		 * TABLE : tbds_request_box
		 * DESC : 요구함 삭제 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		objReturnHash = null;
		
		strSQL.append("select rownum, Z.* FROM ");
		strSQL.append("(select req_box_id, req_box_nm, req_sche_id, regr_id, user_nm ");
		strSQL.append("from tbds_request_box A, ");
		strSQL.append(" (select user_id, user_nm from tbdm_user_info"+strWhereClause+") B ");
		strSQL.append("WHERE A.REGR_ID = B.user_id ");
		strSQL.append("ORDER BY req_box_id) Z ");
		strSQL.append("ORDER BY rownum DESC ");
		
		objDAO.setSQL(strSQL.toString(), null);
		objDAO.doQuery();
		objReturnHash = objDAO.getResultSetMatrix();
		objVec = (Vector)objReturnHash.get("ROWNUM");
		Vector objScheVec = new Vector();
		if(objVec.size() > 0) {
			intCount = Integer.parseInt(String.valueOf(((Vector)objReturnHash.get("ROWNUM")).elementAt(0)));
			out.println("[TBDS_REQUEST_BOX] Req Data Count : " + intCount+"<BR>");
			for(int i=0; i<intCount; i++) {
				String strReqBoxID = (String)((Vector)objReturnHash.get("REQ_BOX_ID")).elementAt(i);
				String strReqScheID = (String)((Vector)objReturnHash.get("REQ_SCHE_ID")).elementAt(i);
				out.println("Req Box ID : "+strReqBoxID+", Sche ID : " +strReqScheID+"<BR>");
				if(StringUtil.isAssigned(strReqScheID)) objScheVec.add(strReqScheID);
				//out.println((String)((Vector)objReturnHash.get("REQ_BOX_NM")).elementAt(i)+"<BR>");

				objDAO.init();
				strSQL.setLength(0);
				strSQL.append("DELETE FROM tbds_request_box WHERE req_box_id='"+strReqBoxID+"'");
				objDAO.setSQL(strSQL.toString(), null);
				int intResult = objDAO.doUpdate();
				if(intResult < 0) out.println("요구함 삭제 중 에러 <BR>");

			}
			out.println("요구함 정보에서 추출된 요구 일정 개수(중복포함) : " + objScheVec.size()+"<BR>");
		}

		
		/**
		 *************************************************************************************
		 * NO : 13
		 * TABLE : tbds_request_schedule
		 * DESC : 요구 일정 
		 *************************************************************************************
		 */
		objDAO.init();
		strSQL.setLength(0);
		strSQL.append("DELETE FROM tbds_request_schedule WHERE req_sche_id=");
		for(int i=0; i<objScheVec.size(); i++) {
			strSQL.append("'"+(String)objScheVec.elementAt(i)+"'");
			objDAO.setSQL(strSQL.toString());
			int intResult = objDAO.doUpdate();
			//if(intResult < 0) out.println("요구 일정 삭제 중 에러 <BR>");
		}

		out.println("All Process Is Done !!!!!!!!!!!!!!!!!!!!!!!!!!!");

		out.println("<P><input type=\"button\" value=\"Return To Input Form\" onClick=\"location.href='deleteTestDataForm.jsp?method="+strMethod+"'\">");
		


	} catch(Exception e) {
		ByteArrayOutputStream bout = new ByteArrayOutputStream();
		e.printStackTrace(new PrintStream(bout));
		out.println(bout.toString());
		//out.println(e.getMessage());
	}
%>