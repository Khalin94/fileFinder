
<%


	objHshParam.put("InOutMode",InOutMode);
	objHshParam.put("Type","PerOrgan");
	objHshParam.put("RootOrganId",strRootOrganId);
	objHshParam.put("SttCd","001");
	objHshParam.put("RelCd","001");


	try{
		objArySearchOrgan = objSearchOrgan.getRelOrgan(objHshParam);
	}
	catch(Exception e){
		System.out.print("[JSP] : " + e.toString());
	}

%>

        <tr> 
          <td height="10" align="center" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">

		<%
					
					String strOrganNm ="";
					String strOrganId = "";

				if(objArySearchOrgan != null){
			 			
			 		if(objArySearchOrgan.size() == 0)
						out.println("<TR><TD>데이타 없음<br></TD></TR>");

					for(int i=0;i < objArySearchOrgan.size();i++){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
						strOrganNm = (String)objHshSearchOrganList.get("ORGAN_NM");
						strOrganId = (String)objHshSearchOrganList.get("ORGAN_ID");
						
						if((i%4) == 0 || i ==0)
							out.println("<tr>");
     
						out.println("<td witdh=468 height=22><a href=/reqsubmit/70_organchargesh/SearchRelOrgan4Word.jsp?srchWord="+strOrganId+"&srchMode=OrganIdForSubmit&InOutMode=X&organNm="+strOrganNm+">"+strOrganNm+"</a></td>");
						
						if(i == (objArySearchOrgan.size()-1)){
							int j=1;
							while(objArySearchOrgan.size()%4 <= j){
								out.println("<td></td>");
								j--;
							}
						}
						if((i%4) == 3)
							out.println("</tr>");
					}
					
				}
				
				
			  %>
	

                  </table></td>
              </tr>

