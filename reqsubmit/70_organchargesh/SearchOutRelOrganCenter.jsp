<%


	objHshParam.put("InOutMode",InOutMode);
	objHshParam.put("OrganKind","004");
	objHshParam.put("OrganGbn","001");
	objHshParam.put("SttCd","001");
	objHshParam.put("GovGbn","G");


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
			 			
			 		
					for(int i=0;i < objArySearchOrgan.size();i++){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
						strOrganNm = (String)objHshSearchOrganList.get("ORGAN_NM");
						strOrganId = (String)objHshSearchOrganList.get("ORGAN_ID");
						
						if((i%4) == 0 || i ==0)
							out.println("<tr>");


						out.println("<td witdh=468 height=22><a href=SearchOutRelOrgan.jsp?organId="+strOrganId+">"+this.substring(strOrganNm,13)+"</a></td>");
						
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
				else{
					out.println("데이타 없음<br>");
				}
				
			  %>
	

            </table></td>
        </tr>

<%!
	public String substring(String strSource,int intLength){
		
		if(strSource != null && !strSource.equals("")){
			if(strSource.length()>intLength){
				return strSource.substring(0,intLength) + "...";
			}else{
				return strSource;
			}
		}else{
			return "";
		}
	}
%>