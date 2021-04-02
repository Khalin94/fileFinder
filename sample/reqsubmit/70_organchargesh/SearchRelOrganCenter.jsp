<%@ page import = "java.util.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<script language="JavaScript">
var NS4 = (document.layers);
var IE4 = (document.all);
var win = window;
var n   = 0;

</script>

<script src="/js/searchRel.js"></script>
<link href="/css/System.css" rel="stylesheet" type="text/css">
<%@ page import = "java.util.*" %>
<%@ page import="nads.dsdm.app.reqsubmit.delegate.*" %>
<%@ page import="kr.co.kcc.pf.exception.AppException" %>
<%@ page import="kr.co.kcc.bf.bfutil.StringUtil" %>
<%@ page import="nads.lib.reqsubmit.params.requestbox.RMemReqBoxListForm" %>

<jsp:useBean id="objMsgBean" class="nads.lib.message.MessageBean" scope="request"/>

<%

	Hashtable objHshSearchOrganList = new Hashtable();
	nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate objSearchOrgan = new nads.dsdm.app.reqsubmit.delegate.searchrelorgan.SearchOrganDelegate();
	ArrayList objArySearchOrgan = new ArrayList();
	String InOutMode = nads.lib.reqsubmit.util.StringUtil.getEmptyIfNull(request.getParameter("InOutMode")); 

	//String strRootOrganId = request.getParameter("RootOrganId");

	Hashtable objHshParam = new Hashtable();

	if(StringUtil.getNVLNULL(InOutMode).equals(""))
		InOutMode="I";
		
	objHshParam.put("SttCd","001");
	objHshParam.put("InOutMode",InOutMode);

	

	try{
		objArySearchOrgan = objSearchOrgan.getRelOrgan(objHshParam);
	}
	catch(Exception e){

		objMsgBean.setMsgType(objMsgBean.TYPE_ERR);
		objMsgBean.setStrCode("SYS-00001");
		objMsgBean.setStrMsg(e.getMessage());
		
		// 에러 발생 메세지 페이지로 이동한다.
%>
		<jsp:forward page="/common/message/ViewMsg.jsp"/>
<%
		return;
	}

%>


  <table width="86%" border="0" cellpadding="0" cellspacing="1" bgcolor="cccccc">
      <tr> 
        <td align="left" valign="top" bgcolor="ffffff">
		<table width="234" border="0" cellspacing="0" cellpadding="8">
            <tr> 
              <td align="left" valign="top" width=234>
			
<!-- <img src="/image/reqsubmit/ex_tree.gif" width="234" height="266">
 -->								  

			  <%
					
					String strIndex = (String)request.getParameter("cIndex");
					String strFolderId = (String)request.getParameter("cFolderId");
					String strStep= (String)request.getParameter("cStep");

					if(strFolderId == null || strFolderId.equals(""))
						strFolderId = "0";
					
					if( strIndex== null ||strIndex.equals("") )
						strIndex="0";
					int getIndex = Integer.parseInt(strIndex);
					if( getIndex == 0)
						getIndex = 1;

					String strOrganStep = "";
					String strOrganNm ="";
					String strOrganId = "";
					String strJuso1= "";
					String strJuso2 = "";
					String strTelNum = "";
					String strHomeUrl = "";


				if(objArySearchOrgan != null){
			 			
					int index=0;

			 		out.println("<script>");	
					for(int i=0;i < objArySearchOrgan.size();i++){
						objHshSearchOrganList = (Hashtable)objArySearchOrgan.get(i);
						strOrganStep = (String)objHshSearchOrganList.get("LVL");
						strOrganNm = (String)objHshSearchOrganList.get("ORGAN_NM");
						strOrganId = (String)objHshSearchOrganList.get("ORGAN_ID");
						strJuso1= (String)objHshSearchOrganList.get("JUSO1");
						strJuso2 = (String)objHshSearchOrganList.get("JUSO2");
						strTelNum = (String)objHshSearchOrganList.get("TEL_NUM");
						strHomeUrl = (String)objHshSearchOrganList.get("HOME_URL");

						if(index != getIndex && !strOrganStep.equals("1"))
							continue;
						
						if(strOrganStep.equals("1"))
							index++;
						
						if(i == 0){
				  %>

							fIndex0 = gFld("대한민국국회","","","", "")

				  <%

						}else{
				  %>

							fIndex<%=String.valueOf(Integer.parseInt(strOrganStep)-1)%> = insFld(fIndex<%=String.valueOf(Integer.parseInt(strOrganStep)-2)%>, gFld("<%=strOrganNm%>","<%=strOrganId%>","<%=index%>","<%=strOrganStep%>", "parent.document.frames['userlist'].location.href='/reqsubmit/70_organchargesh/UserList.jsp?OrganId=<%=strOrganId%>'"))
				  <%
						}

					}
					out.println("</script>");
				}
				else{
					out.println("데이타 없음<br>");
				}
				
			  %>


<script>
initializeDocument4Organ(<%=getIndex%>,<%=strFolderId%>)
</script>


		  </td>
        </tr>
      </table>
	  </td>
  </tr>
</table>
