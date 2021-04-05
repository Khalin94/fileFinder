<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	String strTotal = "";
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
	
		Hashtable objDutyInfoHt = objBusInfoDelegate.selectOpenDutyInfoList(objParamHt);	
	
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

%>
					<tr onMouseOver="this.style.backgroundColor='#FCFDF0'" onMouseOut="this.style.backgroundColor=''"> 
                      <td height="22" align="center"></td>
                      <td height="22" class="td_lmagin" onMouseover="showtip(this,event,'<%=strDsc%>')" onMouseout="hidetip()">
                        <a href="./businfo/FileDownload.jsp?duty_id=<%=strDutyId%>&real_file=<%=strRealFile%>&file_name=<%=strFileName%>"><%=strFileName%></a>
                      <td height="22" align="center"><%=strFileSize%></td>
                      <td height="22" align="center"><%=strCrtDt%></td>
                      <td height="22" align="center"><%=strUserNm%></td>
                      <td height="22" align="center"><%=strOrganNm%></td>
                    </tr>
                    <tr class="tbl-line"> 
                      <td height="1"></td>
                      <td height="1"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1" align="left" class="td_lmagin"></td>
                      <td height="1"></td>
                      <td height="1"></td>
                    </tr>
<%
			}//for (int i=0; i < objDutyArry.size(); i++)
		}else{
			out.println("<tr>");
			out.println("<td height='22' colspan='5' align='center'>해당 데이타가 없습니다.");
			out.println("</td>");
			out.println("</tr>");
			out.println("<tr class='tbl-line'>");
			out.println("<td height='1'></td>");
			out.println("<td height='1'></td>");
			out.println("<td height='1' align='left' class='td_lmagin'></td>");
			out.println("<td height='1' align='left' class='td_lmagin'></td>");
			out.println("<td height='1'></td>");
			out.println("<td height='1'></td>");
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
%>

