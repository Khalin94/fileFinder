<!--
**      Program Name : ISearch_Relation_html.jsp
**      Program Date : 2004. 05.19.
**      Last    Date : 2004. 05.19.
**      Programmer   : Kim Kang Soo
**      Description  : 상세검색중 관련기관웹사이트 -html검색
**
**      1)vspider를 이용하여 html페이지 검색한부분임 
**	  2)고객의 요구로 추가했으나 검색품질이 좋지 않으므로 요구시 삭제가능한 프로그램임
-->
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import=" java.util.*"%>
<%@ page import="com.verity.search.*" %>
<%@ include file="utils.jsp" %> 
<%@ include file="/common/CheckSession.jsp" %>
<%@ page errorPage = "bad.jsp" %>
<html>
<head>
<title>의정자료 전자유통 시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/System.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
function GotoPage(form, docStart){	

		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";			
			document.PageForm.query.focus();
			return ;
            }
         }

	form.docStart.value = docStart * form.docPage.value + 1;
	form.submit();
	return;
}

function search()
{
		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";			
			document.PageForm.query.focus();
			return ;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.submit();
}
function OnEnter()
{
		var str1=document.PageForm.query.value

		for (var i=0; i < str1.length; i++) {
			if (str1.charAt(i) == "%" |str1.charAt(i) == ">" |str1.charAt(i) == "<" |str1.charAt(i) == ">" |str1.charAt(i) == "(" |str1.charAt(i) == ")" |str1.charAt(i) == "+" |str1.charAt(i) == "," |str1.charAt(i) == "[") {
			alert("허용되지않은 문자입니다.");
			document.PageForm.query.value="";			
			document.PageForm.query.focus();
			return false;
            }
         }

	document.PageForm.docStart.value = 1;
	document.PageForm.submit();
}

</script>
</head>
<%


	//검색에 필요한 parameter 설정

//문자파라미터



	
	String query = request.getParameter("query"); 
	if(query==null) query = "";

	String deptText = request.getParameter("deptText"); 	
	if(deptText==null) deptText = "";

	String deptText00 = request.getParameter("deptText00"); 	
	if(deptText00==null) deptText00 = "";

	String SRCH_DISPLAY_KIND = (String)session.getAttribute("SRCH_DISPLAY_KIND");

	String SRCH_RECORD_CNT = (String)session.getAttribute("SRCH_RECORD_CNT");



//숫자파라미터

	int docStart = 1;
	if(request.getParameter("docStart")!=null)
		docStart = Integer.parseInt(request.getParameter("docStart"));
	
	int docPage = Integer.parseInt(SRCH_RECORD_CNT.trim());
	if(request.getParameter("docPage")!=null)
		docPage = Integer.parseInt(request.getParameter("docPage"));

	int     maxDocs     = 4000;
	if(request.getParameter("maxDocs") != null)
		maxDocs = Integer.parseInt(request.getParameter("maxDocs"));

	String sortSpec = request.getParameter("SortSpec");
	if(sortSpec==null) sortSpec = "date desc";

	String colls = request.getParameter("colls");
	if(colls==null) colls = "relation_html";

	Result result = null;
	try {
		VSearch vs = new VSearch();
		
		//3.x 이상에만 있는 method
		

		vs.setServerSpec("10.201.60.2:9940");
		vs.setCharMap("ksc");
		vs.setUrlStringsMode(true);
		vs.addCollection(colls);
		
			vs.addField("VDKFEATURES");
			vs.addField("VDKSUMMARY");
			vs.addField("DOC");			
			vs.addField("vdksummary");
			vs.addField("DOC_FN");
			vs.addField("DOC_SZ");
			vs.addField("DOC_OF");			
			vs.addField("VdkVgwKey");
			vs.addField("Title");
			vs.addField("Subject");
			vs.addField("Author");			
			vs.addField("Keywords");
			vs.addField("MIME-Type");
			vs.addField("VLang");
			vs.addField("Charset");
			vs.addField("To");
			vs.addField("NewsGroups");
			vs.addField("PageMap");
			vs.addField("Date");
			vs.addField("URL");
			vs.addField("Ext");
			vs.addField("Size");
			vs.addField("Created");

			vs.setSortSpec(sortSpec);
			vs.setMaxDocCount(maxDocs);
			vs.setQueryText(toAscii(query));
			vs.setDocsStart(docStart);
			vs.setDocsCount(docPage);
			result = vs.getResult();	

	} catch(Exception e) {
		throw new RuntimeException(e.getMessage()+e.getClass());
	}
	
	//검색 결과 Print
	int hitCount = result.docsFound;
%>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<SCRIPT language="JavaScript" src="/js/reqsubmit/reqinfo.js"></SCRIPT>
<%@ include file="/common/TopMenu.jsp" %>

<table width="100%" height="470" border="0" cellpadding="0" cellspacing="0">
  <tr align="left" valign="top">
    <td width="186" height="470" background="../image/common/bg_leftMenu.gif">
	<%@ include file="/common/LeftMenu.jsp" %></td>

    <td width="100%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr height="24" valign="top"> 
          <td height="24" colspan="2" align="left"><table width="789" height="24" border="0" cellpadding="0" cellspacing="0" bgcolor="FFF4DF">
              <tr>
                <td height="24"></td>
              </tr>
            </table></td>
        </tr>

<form  method=post name=PageForm action=ISearch_Relation_html.jsp >
        <tr valign="top"> 
          <td width="30" height="553" align="left"><img src="../image/common/bg_leftBody.gif" width="30" height="1"></td>
          <td align="left"><table width="759" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="23" colspan="2" align="left" valign="top"><table width="100%" height="23" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="20%" background="../image/infosearch/bg_infosearch_tit.gif"><span class="title">관련기관 웹사이트검색</span> </td>
                      <td width="20%" align="left" background="../image/common/bg_titLine.gif">&nbsp;</td>
                      <td width="55%" align="right" background="../image/common/bg_titLine.gif" class="text_s"><img src="../image/common/icon_navi.gif" width="3" height="5" align="absmiddle"> 
                        Home&gt;정보검색&gt;<strong>관련기관웹사이트검색</strong></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
			<td height="50" colspan="2" align="left" class="text_s">제출기관의 웹문서를  보실수있습니다. 링크를 클릭하면 해당 사이트로 이동됩니다.</td>
              </tr>
              <tr> 
                <td height="15" colspan="2" align="left" valign="top" class="text_s">&nbsp;</td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top" class="text_s"><table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="CCCCCC">
                    <tr> 
                      <td height="63" align="center" bgcolor="#F3F3F3"><table width="54%" border="0" cellspacing="3" cellpadding="0">
                          <tr> 
                            <td width="22%" align="left"></td>
                            <td width="62%" align="left"><strong> 
                              <input name="query" type="text" class="textfield" style="WIDTH: 250px" value="<%=toMulti(query)%>" onKeyDown="JavaScript: if(event.keyCode == 13) {return OnEnter();};" >
                              </strong></td>
                            <td width="16%" align="left"><strong><a href="JavaScript:search();"><img src="../image/button/bt_gumsack_icon.gif" width="47" height="19" align="absmiddle" border=0></a></strong></td>
                          </tr>
                          <tr> 
                            <td align="left">&nbsp;</td>
                            <td align="left">

					<input type=hidden name=maxDocs VALUE="<%=maxDocs%>">		
					<input type=hidden name=docStart VALUE="<%=docStart%>">
					<input type=hidden name=docPage VALUE="<%=docPage%>">
                    <input type="hidden" name="SortSpec" value="<%=sortSpec%>">
                    <input type="hidden" name="colls" value="<%=colls%>">
					<input type=hidden name=deptText VALUE="<%=deptText%>">
					<input type=hidden name=deptText00 VALUE="<%=deptText00%>">
                    
                            </td>
                            <td align="left">&nbsp;</td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td height="25" colspan="2" align="left" valign="top"></td>
              </tr>
              <tr> 

                <td colspan="2" align="left" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="59%" height="22" class="text_s"><img src="../image/common/icon_nemo_gray.gif" width="3" height="6"> 
                        검색어 : <strong><%=replace(replace(toMulti(query), "<", "&lt;"),">","&gt")%></strong>(<%=hitCount%>개)</td>
                      <td width="41%" rowspan="2" align="right" valign="bottom" class="text_s"><table width="20%" border="0" cellspacing="0" cellpadding="0">
                          <tr align="left" valign="bottom"> 
                            <td width="3%"><a href="ISearch_Relation.jsp?queryText=<%=toMulti(query)%>&deptText=<%=deptText%>&query=<%=query%>&deptText00=<%=deptText00%>"><img src="../image/infosearch/tab_material_over.gif" width="96" height="24" border=0></a></td>
                            <td width="97%"><img src="../image/infosearch/tab_webdoc.gif" ></td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>



              </tr>
              <tr> 
                <td height="2" align="left" valign="top" class="td_infosearch"></td>
              </tr>
              <tr> 
                <td height="10" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td align="center" valign="top"><table width="719" border="0" cellspacing="0" cellpadding="0">


<%
	if (hitCount !=0) {
		String viewHref = "";
		String temp = "";	
		int i=0;		
		Enumeration enum = result.documents().elements();
		while(enum.hasMoreElements()){
			Document doc = (Document)enum.nextElement();
		temp =query;
		i++;				
		int j=i%2;
		
%>
                    <tr> 
                      <td  height="22" valign="top" <% if (j==1){out.println(" bgcolor='#FEFAEF'");}%> class="td_box">
                      <strong><a href="<%=doc.field("url")%>"  <%if (SRCH_DISPLAY_KIND.trim().equals("0")) { out.println("target='_blank'");}%>><%=doc.rank%>. 
                      <% if(doc.title==null){%>제목없음<%}else{%><%=doc.title%><%}%></a>
                      </strong><br>
					
					<%if (!query.equals("")) { %>
					<%=replace(replace(doc.field("vdksummary"),temp, "<font color=red>"+temp),temp,temp+"</font>")%>
					<%}else { %>
					<%=doc.field("vdksummary")%>
					<%}%><br>
					<%=doc.field("date")%><br>					
				</td>
                    </tr>					

<%
		}
	}else{
%>
                    <tr> 
                      <td  align="center">검색된 결과가 없습니다.</td>
                    </tr>					                      
<%
	}
%>

                  </table></td>
              </tr>
              <tr> 
                <td height="10" align="left" valign="top"></td>
              </tr>
              <tr> 
                <td height="1" align="left" valign="top" class="tbl-line"></td>
              </tr>
              <tr valign="middle"> 
				<td height="35" colspan="2" align="center" valign="middle">              
<!-- Page Navigation -->
<%
	if (hitCount > docPage) {
		int Total, Start, Page;
		int CurPage, StartPage, EndPage, TotalPage;
		int i;

		Total = hitCount; 
		if (hitCount > maxDocs) Total = maxDocs-1;
		Start = docStart;
		Page = docPage;

		CurPage = Start / Page;
		StartPage = ( Start / ( 10 * Page ) ) * 10;
		if((Total % Page)==0)
		{
		TotalPage = (Total / Page) -1;		
		}else{		
		TotalPage = Total / Page;
		}

		EndPage = StartPage + 9 > TotalPage ? TotalPage : StartPage + 9;

%>

<%

		if (StartPage != 0) {
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, 0)\'>[First]</a>&nbsp;");
			out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + (StartPage-10) + ")\'><img src='/image/button/bt_prev.gif' border='0'></a>&nbsp;");
		}
		

		for (i = StartPage ; i <= EndPage ; i++) {
			if( i == CurPage ){
				out.println("<strong>["+(i+1)+"]</strong>&nbsp;");;
			}
			else {
				out.println("<a href=\'JavaScript:GotoPage(document.PageForm, " + i + ")'>" +"["+ (i+1)+"]&nbsp;</a> ");
			}
		}

		if (TotalPage > EndPage) {
			EndPage = EndPage + 1;
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + EndPage + ")'><img src='/image/button/bt_next.gif' border='0'></a>");
			out.println("&nbsp;<a href=\'JavaScript:GotoPage(document.PageForm, " + TotalPage + ")'>[End]</a>");
		}
	}
%>                                </td>
              </tr>
              <tr> 
                <td height="3" align="left" valign="top" background="../image/common/line_table.gif"></td>
              </tr>
              <tr> 
                <td height="40" colspan="2" align="left"><a href="ISearch_Relation_html.jsp"><img src="../image/button/bt_goFirst.gif" width="67" height="20" border=0></a></td>
              </tr>
              <tr> 
                <td height="15" colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
              
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</form>
<%@ include file="../common/Bottom.jsp" %>
</body>
</html>
