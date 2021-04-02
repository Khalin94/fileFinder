<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.commReqDoc.CommReqDocDelegate" %>
<%@ page import="nads.lib.reqsubmit.util.*" %>
<%@ page import="java.util.*" %>

<%@ page import="kr.co.kcc.bf.db.*" %>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.requestbox.*" %>
<%@ page import="nads.lib.reqsubmit.EnvConstants" %>
<%@ page import="unidocs.pdf.uniflow.*" %>
<%@ page import="nads.lib.reqsubmit.ftp.FTPCommand" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<link href="/css/System.css" rel="stylesheet" type="text/css">

<%
	String strReqBoxID = request.getParameter("ReqBoxID");

	if(!StringUtil.isAssigned(strReqBoxID)) {
		out.println("<CENTER>");
		out.println("요구함 ID가 없습니다. 더이상 작업을 진행할 수 없습니다.");
		out.println("<p><a href='javascript:self.close()'>[close]</a>");
		out.println("</CENTER>");
	}

	List objList = new ArrayList();

	try {
		StringBuffer strSQL = new StringBuffer();
		DBAccess objDAO=null;
		Vector objVec = new Vector();
		Hashtable objReqDocInfoHash  = new Hashtable();
		CommReqDocDelegate objReqDoc = new CommReqDocDelegate();

		objDAO = new DBAccess(this.getClass());

		MemReqDocSendDelegate objRDSDelegate = new MemReqDocSendDelegate();
		//String strReqDocSeq = objRDSDelegate.getSeqNextVal("TBDS_REQ_DOC_INFO");
		//strReqDocSeq = StringUtil.padl(strReqDocSeq, 10);
		String strReqDocSeq = strReqBoxID;

		strSQL.append("select * from ( select a.*, to_char(rownum+rnum-1) totalrecordcount from ( select a.*, rownum rnum from (");
		strSQL.append("SELECT DISTINCT(B.old_req_organ_id) AS req_organ_id, B.old_req_organ_nm AS req_organ_nm, ");
		strSQL.append(" A.req_box_id, A.cmt_organ_id, A.cmt_organ_nm, A.submt_organ_nm, A.submt_dln, A.reg_dt, ");
		strSQL.append(" C.user_id, C.user_nm, C.office_tel, A.req_box_nm ");
		strSQL.append(" FROM ");
		strSQL.append(" (select req_box_id, cmt_organ_id, cmt_organ_nm, submt_organ_nm, ");
		strSQL.append(" submt_dln, reg_dt, req_box_nm from vids_request_box ");
		strSQL.append(" where req_box_id=?) A, vids_request_info B, tbdm_user_info C ");
		strSQL.append(" WHERE A.req_box_id =?");
		strSQL.append(" AND A.req_box_id = B.req_box_id ");
		strSQL.append(" AND A.cmt_organ_id = B.cmt_organ_id ");
		strSQL.append(" AND B.regr_id = C.user_id ");
		strSQL.append(") a order by rnum desc ) a order by req_organ_nm ) where rnum between to_number(1) and to_number(100)");

		// out.println("[SLCommReqDocBean getReqOrgInfo() SQL] "+strSQL.toString()+"<BR>");
		objVec.add(strReqBoxID);
		objVec.add(strReqBoxID);
		objDAO.setSQL(strSQL.toString(), objVec);
		objDAO.doQuery();
		objReqDocInfoHash = objDAO.getResultSetMatrix();

		int intCount = Integer.parseInt((String)((Vector)objReqDocInfoHash.get("TOTALRECORDCOUNT")).elementAt(0));
		//out.println(intCount+"<BR>");

		for(int i=0; i<intCount; i++) {
			strReqDocSeq = strReqDocSeq+"-"+String.valueOf(i);
			String strReqOrganID = String.valueOf(((Vector)objReqDocInfoHash.get("REQ_ORGAN_ID")).elementAt(i));
			String strCmtOrganName = String.valueOf(((Vector)objReqDocInfoHash.get("CMT_ORGAN_NM")).elementAt(i));
			String strReqOrganName = String.valueOf(((Vector)objReqDocInfoHash.get("REQ_ORGAN_NM")).elementAt(i));
			String strSubmitOrganName = String.valueOf(((Vector)objReqDocInfoHash.get("SUBMT_ORGAN_NM")).elementAt(i));
			String strRegDt = String.valueOf(((Vector)objReqDocInfoHash.get("REG_DT")).elementAt(i));
			String strReqBoxName = String.valueOf(((Vector)objReqDocInfoHash.get("REQ_BOX_NM")).elementAt(i));
			String strSubmtDln = String.valueOf(((Vector)objReqDocInfoHash.get("SUBMT_DLN")).elementAt(i));
			String strUserName = String.valueOf(((Vector)objReqDocInfoHash.get("USER_NM")).elementAt(i));
			String strOfficeTel = String.valueOf(((Vector)objReqDocInfoHash.get("OFFICE_TEL")).elementAt(i));

			//out.println("[CommReqDocDelegate strReqOrganID] "+strReqOrganID+"<BR>");
			//out.println("[CommReqDocDelegate strCmtOrganName] "+strCmtOrganName+"<BR>");
			//out.println("[CommReqDocDelegate strReqOrganName] "+strReqOrganName+"<BR>");
			//out.println("[CommReqDocDelegate strSubmitOrganName]"+strSubmitOrganName+"<BR>");
			//out.println("[CommReqDocDelegate Reg DT]"+strRegDt+"<BR>");
			//out.println("[CommReqDocDelegate strReqBoxName]"+strReqBoxName+"<BR>");
			//out.println("[CommReqDocDelegate strSubmtDln]"+strSubmtDln+"<BR>");
			//out.println("[CommReqDocDelegate strUserName] "+strUserName+"<BR>");
			//out.println("[CommReqDocDelegate strOfficeTel]"+strOfficeTel+"<BR>");
			//out.println("[CommReqDocDelegate ReqDoc SEQ]"+strReqDocSeq+"<BR>");

			Hashtable objTmpHash = new Hashtable();
			objTmpHash.put("REQ_ORGAN_ID", strReqOrganID);
			objTmpHash.put("CMT_ORGAN_NM", strCmtOrganName);
			objTmpHash.put("REQ_ORGAN_NM", strReqOrganName);
			objTmpHash.put("SUBMT_ORGAN_NM", strSubmitOrganName);
			objTmpHash.put("REQ_BOX_NM", strReqBoxName);
			objTmpHash.put("REG_DT", strRegDt);
			objTmpHash.put("SUBMT_DLN", strSubmtDln);
			objTmpHash.put("USER_NM", strUserName);
			objTmpHash.put("OFFICE_TEL", strOfficeTel);
			objTmpHash.put("REQ_DOC_SEQ", strReqDocSeq);

			objDAO.init();
			strSQL.setLength(0);

			strSQL.append("select * from ( select a.*, to_char(rownum+rnum-1) totalrecordcount from ( select a.*, rownum rnum from (");
			strSQL.append("SELECT req_cont, req_dtl_cont FROM vids_request_info ");
			strSQL.append(" WHERE req_box_id='"+strReqBoxID+"' AND old_req_organ_id='"+strReqOrganID+"'");
			strSQL.append(" ORDER BY req_cont");
			strSQL.append(") a order by rnum desc ) a order by rnum)");

			objDAO.setSQL(strSQL.toString());
			objDAO.doQuery();
			Hashtable objReqListHash = objDAO.getResultSetMatrix();

			StringBuffer strReqDocXml = new StringBuffer();

			String strTmpRegDt = (String)objTmpHash.get("REG_DT");
			strTmpRegDt = strTmpRegDt.substring(0, 4)+"."+strTmpRegDt.substring(4, 6)+"."+strTmpRegDt.substring(6, 8);
			String strTmpSubmtDln = (String)objTmpHash.get("SUBMT_DLN");
			strTmpSubmtDln = strTmpSubmtDln.substring(0, 4)+"."+strTmpSubmtDln.substring(4, 6)+"."+strTmpSubmtDln.substring(6, 8);

			strReqDocXml.append("<?xml version=\"1.0\" encoding=\"euc-kr\"?>\n");
			strReqDocXml.append("<req_doc_info>\n");
			strReqDocXml.append("<req_doc_no>"+(String)objTmpHash.get("REQ_DOC_SEQ")+"</req_doc_no>\n");
			strReqDocXml.append("<cmt_organ>"+(String)objTmpHash.get("CMT_ORGAN_NM")+"</cmt_organ>\n");
			strReqDocXml.append("<req_organ_nm>"+(String)objTmpHash.get("REQ_ORGAN_NM")+"</req_organ_nm>\n");
			strReqDocXml.append("<ans_organ_nm>"+(String)objTmpHash.get("SUBMT_ORGAN_NM")+"</ans_organ_nm>\n");
			strReqDocXml.append("<req_dt>"+strTmpRegDt+"</req_dt>\n");
			strReqDocXml.append("<req_box_nm>"+(String)objTmpHash.get("REQ_BOX_NM")+"</req_box_nm>\n");
			strReqDocXml.append("<submit_dln>"+strTmpSubmtDln+"</submit_dln>\n");
			strReqDocXml.append("<req_rep>"+(String)objTmpHash.get("USER_NM")+"</req_rep>\n");
			strReqDocXml.append("<req_tel>"+(String)objTmpHash.get("OFFICE_TEL")+"</req_tel>\n");

			strReqDocXml.append("<reqlist>\n");

			int intCount2 = Integer.parseInt((String)((Vector)objReqListHash.get("TOTALRECORDCOUNT")).elementAt(0));

			for(int j=0; j<intCount2; j++) {
				String strTmpReqCont = String.valueOf(((Vector)objReqListHash.get("REQ_CONT")).elementAt(j));
				String strTmpReqDtlCont = String.valueOf(((Vector)objReqListHash.get("REQ_DTL_CONT")).elementAt(j));
				strTmpReqCont = StringUtil.ReplaceString(strTmpReqCont, "<", "&lt;");
				strTmpReqCont = StringUtil.ReplaceString(strTmpReqCont, ">", "&gt;");
				strTmpReqCont = StringUtil.ReplaceString(strTmpReqCont, "&", ",");
				strTmpReqDtlCont = StringUtil.ReplaceString(strTmpReqDtlCont, "<", "&lt;");
				strTmpReqDtlCont = StringUtil.ReplaceString(strTmpReqDtlCont, ">", "&gt;");
				strTmpReqDtlCont = StringUtil.ReplaceString(strTmpReqDtlCont, "&", ",");

				strReqDocXml.append("\t<reqinfo>\n");
				strReqDocXml.append("\t\t<req_no>"+(j+1)+"</req_no>\n");
				strReqDocXml.append("\t\t<req_cont>"+strTmpReqCont+"</req_cont>\n");
				strReqDocXml.append("\t\t<req_dtl_cont>"+strTmpReqDtlCont+"</req_dtl_cont>\n");
				strReqDocXml.append("\t</reqinfo>\n");
			}

			strReqDocXml.append("</reqlist>\n");
			strReqDocXml.append("</req_doc_info>\n");

			//System.out.println(strReqDocXml.toString());

			String strXmlFileName = (String)objTmpHash.get("REQ_DOC_SEQ")+".xml";
			String strPluralReqDocXmlPath = EnvConstants.UNIX_FILE_SERVER_REQ_DOC_TEMP_DIRECTORY+strXmlFileName;
			FileUtil.prepareFolder(strPluralReqDocXmlPath);

			java.io.FileOutputStream objFO = new java.io.FileOutputStream(strPluralReqDocXmlPath);
			byte[] buf = strReqDocXml.toString().getBytes();
			objFO.write(buf);
			objFO.close();

			//out.println("<BR>XML Path : "+strPluralReqDocXmlPath+"<BR>");


			if(StringUtil.isAssigned(strPluralReqDocXmlPath)) {
				nads.lib.reqsubmit.uniflow.UniFlowWrapper objUniFlow = new nads.lib.reqsubmit.uniflow.UniFlowWrapper();
				String strPluralReqDocPath = EnvConstants.UNIX_SAVE_PATH+strRegDt.substring(0, 4)+"/"+strReqBoxID+"/"+"req_"+strReqDocSeq+".pdf";
				FileUtil.prepareFolder(strPluralReqDocPath);

				//out.println("PDF Path : " + strPluralReqDocPath+"<BR>");
				int intResult = 0;

				// 4. FTP를 통해서 XML 파일을 WorkFlow 서버로 전송한다.
				FTPCommand objFTP = new FTPCommand();
				objFTP.ftpConnect("10.201.12.141", EnvConstants.getFtpUserID(), EnvConstants.getFtpPassword());

				// 5.실제 XML, 생성할 PDF 파일명만 구하기
				String strPdfFileName = strPluralReqDocPath.substring(strPluralReqDocPath.lastIndexOf('/')+1, strPluralReqDocPath.length());
				//String strXmlFileName = strPluralReqDocXmlPath.substring(strPluralReqDocXmlPath.lastIndexOf('/')+1, strPluralReqDocXmlPath.length());

				if(!(StringUtil.isAssigned(strPdfFileName)) || !(StringUtil.isAssigned(strXmlFileName))) {
					System.out.println("파일 경로에 문제가 있어서 정확한 파일명 추출에 실패했습니다. 경로명을 확인해 주시기 바랍니다.");
					System.out.println("[PDF File Name] : "+strPdfFileName);
					System.out.println("[XML File Name] : "+strXmlFileName);
					return;
				}

				// 6. WorkFlow가 설치된 Windows에서 사용될 파일 경로 설정
				String strUniFlowSavePath = EnvConstants.WIN_TEMP_SAVE_PATH;
				String strPdfFilePathForWorkFlow = strUniFlowSavePath+strPdfFileName;
				String strXmlFilePathForWorkFlow = strUniFlowSavePath+strXmlFileName;

				strPdfFilePathForWorkFlow = StringUtil.ReplaceString(strPdfFilePathForWorkFlow, "/", "\\");
				strXmlFilePathForWorkFlow = StringUtil.ReplaceString(strXmlFilePathForWorkFlow, "/", "\\");

				// 7. FTP 로 해당 파일 WorkFlow가 설치된 장비로 전송

				//System.out.println(strXmlFilePathForWorkFlow);
				//System.out.println(strPluralReqDocXmlPath);
				//int intXmlPutResult = objFTP.putFile(strXmlFilePathForWorkFlow, strPluralReqDocXmlPath);
				int intXmlPutResult = objFTP.putFile(strXmlFileName, strPluralReqDocXmlPath);

				if(intXmlPutResult < 1) {
					System.out.println("FTP를 이용한 WorkFlow 변환서버로의 파일 업로드가 실패했습니다. 파일 경로나 존재 여부를 확인해 주시기 	바랍니다.");
					System.out.println("[XML FTP File Path] : "+strXmlFilePathForWorkFlow);
					System.out.println("[XML Local File Path] : "+strPluralReqDocXmlPath);
					return;
				}

				String strFormPath = EnvConstants.REQ_DOC_REQ_FORM_FULL_PATH;
				strFormPath = StringUtil.ReplaceString(strFormPath, "/", "\\");

				StringBuffer strWorkFlowJobMsg = new StringBuffer();
				strWorkFlowJobMsg.append("JOB SYNC=1 /FORMPDF");
				strWorkFlowJobMsg.append(" PDF="+strPdfFilePathForWorkFlow);
				strWorkFlowJobMsg.append(" DATA="+strXmlFilePathForWorkFlow);
				strWorkFlowJobMsg.append(" FORM="+strFormPath);


				UniFlowJob objJob = new UniFlowJob(EnvConstants.UNIFLOW_SERVER_IP_ADDRESS, EnvConstants.UNIFLOW_SERVER_PORT);
				intResult = objJob.SubmitJob(strWorkFlowJobMsg.toString(), true);

				if(intResult < 1) {
					System.out.println("WorkFlow를 이용한 XML 파일의 PDF 요구서 변환이 실패했습니다. WorkFlow 에러 메시지를 확인해 주시기 바랍니다.");
					System.out.println("[JOB Msg] : "+strWorkFlowJobMsg);
					out.println(strCmtOrganName+" 위원회의 "+i+"번째 "+strReqOrganName+" 요구서 생성 실패");
					return;
				}

				// 6. 잘 끝냈으니 FTP를 통해서 회수만 해오자
				intResult = objFTP.getFile(strPdfFileName, strPluralReqDocPath);

				if(intResult < 1) {
					System.out.println("생성된 PDF 파일을 FTP를 통해서 받아오는 과정 중 에러 발생. 파일 존재 유무와 경로명을 확인해 주시기 바랍니다.");
					System.out.println("[FTP File Path] : "+strPdfFilePathForWorkFlow);
					System.out.println("[Local File Path] : "+strPluralReqDocPath);
					return;
				}

				// 5. 생성된 요구서 정보를 반환하기 위해서 저장하자
				Hashtable objReturnHash = new Hashtable();
				objReturnHash.put("CMT_ORGAN_NM", strCmtOrganName);
				objReturnHash.put("REQ_ORGAN_NM", strReqOrganName);
				objReturnHash.put("REQ_DOC_PATH", strRegDt.substring(0, 4)+"/"+strReqBoxID+"/"+"req_"+strReqDocSeq+".pdf");
				objList.add(objReturnHash);

			}

		} // end for

			//CommReqDocDelegate objReqDoc = new CommReqDocDelegate();
			//List objList = (List)objReqDoc.createPluralReqDocPDF(strReqBoxID);

			if(objList == null) {
				out.println("요구서 PDF 생성 중 에러 발생");
				return;
			}

	} catch(AppException objAppEx) {
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
	  	return;
	}
%>

<html>
<head>
<title>의원실별 요구서 보기</title>
</head>
<body leftmargin="0" topmargin="0">

<table border="0" cellpadding="0" cellspacing="0" width="300">
	<tr>
		<td width="300" height="30" bgcolor="#e1e1e1" align="center">
			<font style="font-size:12pt;font-weight:bold;color:#000000;font-family:verdana,돋움">의원실별 요구서 보기</font>
		</td>
	</tr>
	<tr>
		<td height="220" bgcolor="white" align="center">
			<table border="0" cellpadding="0" cellspacing="1">
				<tr class="td_reqsubmit">
					<td width="30" height="23" align="center" style="color:white">NO</td>
					<td width="180" align="center" style="color:white">의원실</td>
					<td width="70" align="center" style="color:white">요구서PDF</td>
				</tr>
				<%
					Hashtable objDispHash = null;
					for(int i=0; i<objList.size(); i++) {
						objDispHash = (Hashtable)objList.get(i);
						out.println("<tr onMouseOver=\"this.style.backgroundColor='#f4f4f4'\" onMouseOut=\"this.style.backgroundColor=''\">");
						out.println("<td bgcolor='#e1e1e1' align='center' height='21'>"+(i+1)+"</td>");
						out.println("<td bgcolor='white' align='left'>&nbsp;&nbsp;"+(String)objDispHash.get("REQ_ORGAN_NM")+"</td>");
						out.println("<td bgcolor='white' align='left'>&nbsp;&nbsp;"+"<a href='/reqsubmit/common/PDFView.jsp?PDF="+(String)objDispHash.get("REQ_DOC_PATH")+"' target='_blank'><img src='/image/common/icon_pdf.gif' border='0'></a></td>");
						out.println("</tr>");
					}
				%>
			</table>
			<p><br></p>
			<a href="javascript:self.close()">[close]</a>
		</td>
	</tr>
</table>

</body>
</html>