<%@ page import="java.util.*"%>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil"%>
<%@ page import="nads.lib.message.MessageBean"%>
<%@ page import="kr.co.kcc.pf.exception.AppException"%>

<%
	String strMessage = "";
	String strError = "";
	try
	{
		if(!strDocboxId.equals("") && !strOrganId.equals("") && !strUserId.equals("")){
			Hashtable objParamHt = new Hashtable();
			objParamHt.put("DOCBOX_ID", strDocboxId);
			objParamHt.put("ORGAN_ID", strOrganId);
			objParamHt.put("GUBUN", strGubn);
			objParamHt.put("CONTENT", strContent);
			objParamHt.put("CURRENTPAGE", strCurrentPage);
			objParamHt.put("COUNTPERPAGE", strCountPerPage);
			Hashtable objDutyHt = objBusInfoDelegate.selectDutyInfoList(objParamHt);

			strTotalCnt = (String)objDutyHt.get("TOTAL_COUNT");
			ArrayList objDutyArry = (ArrayList)objDutyHt.get("DUTY_INFO");
			String strTopId = (String)objDutyHt.get("TOP_DOCBOX_ID");

			Hashtable objDutyInfoHt = new Hashtable();

			String strDutyId = "";   //업무정보ID
			String strFileName = "";  //분류함명, 파일명
			String strRealFile = "";  //물리적 파일명
			String strFileSize = "";   //파일사이즈
			String strCrtDt = "";        //생성일자
			String strDsc = "";         //설명
			String strUserNm = "";   //작성자명
			String strTopDocboxId = "";   //상위분류함명

			if((strTopId != null) && (!strTopId.equals(""))){
%>
					<tr>
                      <td scope="col"></td>
                      <td scope="col" style="cursor:hand" OnClick="fun_organ('<%=strTopId%>', '<%=strOrganId%>', '<%=strUserId%>')" >
                        <img src="../image/common/icon_folder.gif" width="15" height="12" border="0">&nbsp;..</td>
                      <td scope="col"></td>
                      <td scope="col"></td>
                      <td scope="col"></td>
                    </tr>
<%
			}//if((strTopId != null) && (!strTopId.equals("0"))

			if (objDutyArry.size() > 0){
				for (int i=0; i < objDutyArry.size(); i++){
					objDutyHt = (Hashtable)objDutyArry.get(i);

					strDutyId = (String)objDutyHt.get("DUTY_ID");
					strFileName = (String)objDutyHt.get("FILE_NAME");
					strRealFile = (String)objDutyHt.get("REAL_FILE");
					strFileSize = (String)objDutyHt.get("FILE_SIZE");
					strCrtDt = (String)objDutyHt.get("CRT_DT");
					strDsc = (String)objDutyHt.get("DSC");
					strUserNm = (String)objDutyHt.get("USER_NM");
					strTopDocboxId = (String)objDutyHt.get("TOP_DOCBOX_ID");

					if(!strTopDocboxId.equals("N")){   //폴더인지 파일인지 구분
						//폴더
%>
					<tr>
                      <td scope="col" align="center"><input type="checkbox" name="checkD" value="<%=strDutyId%>"></td>
                      <td scope="col" style="cursor:hand;text-align:left;"  OnClick="fun_organ('<%=strDutyId%>', '<%=strOrganId%>', '<%=strUserId%>')" >
                        <img src="../image/common/icon_folder.gif" width="15" height="12" border="0">&nbsp;<%=strFileName%></td>
                      <td scope="col"><%=strFileSize%></td>
                      <td scope="col"><%=strCrtDt%></td>
                      <td scope="col"><%=strUserNm%></td>
                    </tr>
<%
					}else{
						//파일
%>
					<tr>
                      <td scope="col" align="center"><input type="checkbox" name="checkF" value="<%=strDutyId%>"></td>
                      <td scope="col" style="text-align:left;" onMouseover="showtip(this,event,'<%=strDsc%>')" onMouseout="hidetip()"><a href="./businfo/FileDownload.jsp?duty_id=<%=strDutyId%>&organ_id=<%=strOrganId%>&real_file=<%=strRealFile%>&file_name=<%=strFileName%>"><%=strFileName%></a></td>
                      <td scope="col"><%=strFileSize%></td>
                      <td scope="col"><%=strCrtDt%></td>
                      <td scope="col"><%=strUserNm%></td>
                    </tr>
<%
					}//if(strTopDocboxId.equals("N"))

				}//for (int i=0; i < objDutyArry.size(); i++)
			}else{
				out.println("<tr>");
				out.println("<td scope='col' colspan='6'>해당 데이타가 없습니다.");
				out.println("</td>");
				out.println("</tr>");
			}	//if (objDutyArry.size() > 0)
		}else{
			strTotalCnt = "0";
		}//if(strDocboxId.equals("") || strOrganId.equals("") || strUserId.equals(""))
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




