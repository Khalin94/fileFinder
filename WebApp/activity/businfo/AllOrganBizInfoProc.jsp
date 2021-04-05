<%@ page import="java.util.*"%>
<%@ page import="nads.lib.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	String strMessage = "";
	String strError = "";

	try
	{
		if((strGubn == null) || (strGubn.length() < 1)){
			strGubn = "0";
		}

		Hashtable objParamHt = new Hashtable();
		objParamHt.put("GUBUN", strGubn);
		objParamHt.put("CONTENT", strSearch);
		objParamHt.put("CURRENTPAGE", strCurrentPage);
		objParamHt.put("COUNTPERPAGE", strCountPerPage);
		
		
		Vector objVectorVt = ActComm.makeNoType(strOrganId, ",");
		
		if((objVectorVt == null) || (objVectorVt.size() < 1) 
		    || objVectorVt.elementAt(0).equals("")){
			return;
		}
		
		objParamHt.put("ORGANID", (Vector)objVectorVt);
		Hashtable objDutyInfoHt = objBusInfoDelegate.selectOrganAllDutyInfoList(objParamHt);	
	
		strTotal = (String)objDutyInfoHt.get("TOTAL_COUNT");
		ArrayList objDutyArry = (ArrayList)objDutyInfoHt.get("DUTY_INFO");
	
		Hashtable objDutyHt = new Hashtable();

		String strDutyId = "";
		String strCrtDt = "";
		String strUserNm = "";
	
		String strFileName = "";
		String strDsc = "";
		String strRealFile = "";
		String strFileSize = "";
		String strOrganNm = "";
		String strDocNm = "";
		String strOrganIdItem = "";

		if (objDutyArry.size() > 0){
			for (int i=0; i < objDutyArry.size(); i++){
				objDutyHt = (Hashtable)objDutyArry.get(i);

				strDutyId = (String)objDutyHt.get("DUTY_ID");
				strFileName = (String)objDutyHt.get("FILE_NAME");
				strRealFile = (String)objDutyHt.get("REAL_FILE");
				strFileSize = (String)objDutyHt.get("FILE_SIZE");
				strCrtDt =(String)objDutyHt.get("CRT_DT");
				strDsc = (String)objDutyHt.get("DSC");
				strUserNm = (String)objDutyHt.get("USER_NM");
				strOrganNm = (String)objDutyHt.get("ORGAN_NM");
				strDocNm = (String)objDutyHt.get("DOCBOX_NM");
				strOrganIdItem = (String)objDutyHt.get("ORGAN_ID");

%>
					<tr> 
                      <td scope="col" onMouseover="showtip(this,event,'<%=strDsc%>')" onMouseout="hidetip()">
                        <a href="./businfo/FileDownload.jsp?duty_id=<%=strDutyId%>&real_file=<%=strRealFile%>&organ_id=<%=strOrganIdItem%>&file_name=<%=strFileName%>"><%=strFileName%></a>
                      <td scope="col"><%=strFileSize%></td>
                      <td scope="col"><%=strDocNm%></td>
                      <td scope="col"><%=strCrtDt%></td>
                      <td scope="col"><%=strUserNm%></td>
                      <td scope="col"><%=strOrganNm%></td>
                    </tr>
<%
			}//for (int i=0; i < objDutyArry.size(); i++)
		}else{
			out.println("<tr>");
			out.println("<td  scope='col' colspan='6'>해당 데이타가 없습니다.");
			out.println("</td>");
			out.println("</tr>");
		}	
	}
	catch(AppException objAppEx)
	{	
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode(objAppEx.getStrErrCode());
  		objMsgBean.setStrMsg(objAppEx.getMessage());
  		out.println("<br>Error!!!" + objAppEx.getMessage());
		strError = "yes";
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return;
	}
	catch(Exception  objException)
	{
		objMsgBean.setMsgType(MessageBean.TYPE_ERR);
  		objMsgBean.setStrCode("DMPARAM-0020");
  		objMsgBean.setStrMsg(objException.getMessage());
%>
  	<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%  	
		return	;
	}
%>	

